//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Дмитрий Федоров on 20.05.2023.
//

import Foundation
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    private lazy var viewContext = persistentContainer.viewContext
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    private init() {}
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD Methods
    func fetchData() -> [Task] {
        var taskList: [Task] = []
        
        let fetchRequest = Task.fetchRequest()
        do {
            taskList = try viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return taskList
    }
    
    func save(_ taskName: String) -> Task {
        let task = Task(context: viewContext)
        task.title = taskName
        saveContext()
        return task
    }
    
    func update(_ task: Task, withName taskName: String) -> Task {
        task.title = taskName
        saveContext()
        return task
    }
}
