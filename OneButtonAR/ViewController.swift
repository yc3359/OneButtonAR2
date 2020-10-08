//
//  ViewController.swift
//  OneButtonAR
//
//  Created by Nien Lam on 10/1/20.
//  Modified by Ying C on 10/7/20

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!

    // Root entity of Reality Composer Scene.
    var myEntities: Entity!

    // Anchor at position [0, 0, 0].
    var originAnchor: AnchorEntity!

    // Anchor tracks camera point of view.
    var cameraAnchor: AnchorEntity!

    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load root entity from Reality Composer Project.
        myEntities = try! Experience.loadMyEntities()
        
        // Create and add origin anchor.
        originAnchor = AnchorEntity(world: float4x4(1))
        arView.scene.addAnchor(originAnchor)

        // Add axis guide.
//        originAnchor.addChild(Guides.makeAxes())
        
        // Create and add camera anchor.
        cameraAnchor = AnchorEntity(.camera)
        arView.scene.addAnchor(cameraAnchor)

        // Setup tap gesture.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        arView.addGestureRecognizer(tapGesture)
    }

    @IBAction func onTap(_ sender: UITapGestureRecognizer)
    {
        print("Tap", counter)

        // Get clone of blueKnife entity.
        // Note: Entity name must match from Reality Composer or this will cause a crash.
        let blueKnife = myEntities.findEntity(named: "BlueKnife")!.clone(recursive: true)
        blueKnife.transform.translation = [0,0,0]

        // Add box to origin anchor.
        originAnchor.addChild(blueKnife)
        
        // Move box to camera position.
        blueKnife.transform.matrix = cameraAnchor.transformMatrix(relativeTo: originAnchor)

        // Move box 0.4 meters in front of camera by multiplying with transform matrix.
        var transform = Transform()
        transform.translation.z = -3
        blueKnife.transform.matrix *= transform.matrix
        let radians = Float.pi / 15 * Float(counter)
        blueKnife.transform.rotation = simd_quatf(angle: radians, axis: [0,0.7,0.75])
        let scale = 0.75 * Float(counter)
        blueKnife.transform.scale = [scale, scale, scale]

 

//        // Get clone of aluminumCylinder entity.
//        // Note: Entity name must match from Reality Composer or this will cause a crash.
//        let aluminumCylinder = myEntities.findEntity(named: "AluminumCylinder")!.clone(recursive: true)
//        aluminumCylinder.transform.translation = [0,0,0]
//
//        // Add box to origin anchor.
//        originAnchor.addChild(aluminumCylinder)
//
//        // Translate based on counter.
//        aluminumCylinder.transform.translation.x = 0.15 * Float(counter)
//
//        // Rotate based on counter.
//        let radians = -Float.pi / 10 * Float(counter)
//        aluminumCylinder.transform.rotation = simd_quatf(angle: radians, axis: [0,0,1])
//
//        // Scale based on counter
//        let scale = 1.0 + 0.25 * Float(counter)
//        aluminumCylinder.transform.scale = [scale, scale, scale]

 
        counter += 1
    }
    
}
