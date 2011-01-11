Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab1AKAXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:23:34 -0500
Received: from kroah.org ([198.145.64.141]:45158 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab1AKAX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:23:29 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/4] driver-core: merge private parts of class and bus
Date: Mon, 10 Jan 2011 16:23:23 -0800
Message-Id: <1294705405-31471-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110110234825.GA30018@kroah.com>
References: <20110110234825.GA30018@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

As classes and busses are pretty much the same thing, and we want to
merge them together into a 'subsystem' in the future, let us share the
same private data parts to make that merge easier.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h    |   62 +++++++++++++++++++----------------------------
 drivers/base/bus.c     |   13 ++++-----
 drivers/base/class.c   |   38 ++++++++++++++--------------
 drivers/base/core.c    |   22 ++++++++--------
 include/linux/device.h |    7 ++---
 5 files changed, 64 insertions(+), 78 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 2ca7f5b..19f49e4 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -1,31 +1,46 @@
 
 /**
- * struct bus_type_private - structure to hold the private to the driver core portions of the bus_type structure.
+ * struct subsys_private - structure to hold the private to the driver core portions of the bus_type/class structure.
  *
- * @subsys - the struct kset that defines this bus.  This is the main kobject
- * @drivers_kset - the list of drivers associated with this bus
- * @devices_kset - the list of devices associated with this bus
+ * @subsys - the struct kset that defines this subsystem
+ * @devices_kset - the list of devices associated
+ *
+ * @drivers_kset - the list of drivers associated
  * @klist_devices - the klist to iterate over the @devices_kset
  * @klist_drivers - the klist to iterate over the @drivers_kset
  * @bus_notifier - the bus notifier list for anything that cares about things
- * on this bus.
+ *                 on this bus.
  * @bus - pointer back to the struct bus_type that this structure is associated
- * with.
+ *        with.
+ *
+ * @class_interfaces - list of class_interfaces associated
+ * @glue_dirs - "glue" directory to put in-between the parent device to
+ *              avoid namespace conflicts
+ * @class_mutex - mutex to protect the children, devices, and interfaces lists.
+ * @class - pointer back to the struct class that this structure is associated
+ *          with.
  *
  * This structure is the one that is the actual kobject allowing struct
- * bus_type to be statically allocated safely.  Nothing outside of the driver
- * core should ever touch these fields.
+ * bus_type/class to be statically allocated safely.  Nothing outside of the
+ * driver core should ever touch these fields.
  */
-struct bus_type_private {
+struct subsys_private {
 	struct kset subsys;
-	struct kset *drivers_kset;
 	struct kset *devices_kset;
+
+	struct kset *drivers_kset;
 	struct klist klist_devices;
 	struct klist klist_drivers;
 	struct blocking_notifier_head bus_notifier;
 	unsigned int drivers_autoprobe:1;
 	struct bus_type *bus;
+
+	struct list_head class_interfaces;
+	struct kset glue_dirs;
+	struct mutex class_mutex;
+	struct class *class;
 };
+#define to_subsys_private(obj) container_of(obj, struct subsys_private, subsys.kobj)
 
 struct driver_private {
 	struct kobject kobj;
@@ -36,33 +51,6 @@ struct driver_private {
 };
 #define to_driver(obj) container_of(obj, struct driver_private, kobj)
 
-
-/**
- * struct class_private - structure to hold the private to the driver core portions of the class structure.
- *
- * @class_subsys - the struct kset that defines this class.  This is the main kobject
- * @class_devices - list of devices associated with this class
- * @class_interfaces - list of class_interfaces associated with this class
- * @class_dirs - "glue" directory for virtual devices associated with this class
- * @class_mutex - mutex to protect the children, devices, and interfaces lists.
- * @class - pointer back to the struct class that this structure is associated
- * with.
- *
- * This structure is the one that is the actual kobject allowing struct
- * class to be statically allocated safely.  Nothing outside of the driver
- * core should ever touch these fields.
- */
-struct class_private {
-	struct kset class_subsys;
-	struct klist class_devices;
-	struct list_head class_interfaces;
-	struct kset class_dirs;
-	struct mutex class_mutex;
-	struct class *class;
-};
-#define to_class(obj)	\
-	container_of(obj, struct class_private, class_subsys.kobj)
-
 /**
  * struct device_private - structure to hold the private to the driver core portions of the device structure.
  *
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 33c270a..e243bd4 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -20,7 +20,6 @@
 #include "power/power.h"
 
 #define to_bus_attr(_attr) container_of(_attr, struct bus_attribute, attr)
-#define to_bus(obj) container_of(obj, struct bus_type_private, subsys.kobj)
 
 /*
  * sysfs bindings for drivers
@@ -96,11 +95,11 @@ static ssize_t bus_attr_show(struct kobject *kobj, struct attribute *attr,
 			     char *buf)
 {
 	struct bus_attribute *bus_attr = to_bus_attr(attr);
-	struct bus_type_private *bus_priv = to_bus(kobj);
+	struct subsys_private *subsys_priv = to_subsys_private(kobj);
 	ssize_t ret = 0;
 
 	if (bus_attr->show)
-		ret = bus_attr->show(bus_priv->bus, buf);
+		ret = bus_attr->show(subsys_priv->bus, buf);
 	return ret;
 }
 
@@ -108,11 +107,11 @@ static ssize_t bus_attr_store(struct kobject *kobj, struct attribute *attr,
 			      const char *buf, size_t count)
 {
 	struct bus_attribute *bus_attr = to_bus_attr(attr);
-	struct bus_type_private *bus_priv = to_bus(kobj);
+	struct subsys_private *subsys_priv = to_subsys_private(kobj);
 	ssize_t ret = 0;
 
 	if (bus_attr->store)
-		ret = bus_attr->store(bus_priv->bus, buf, count);
+		ret = bus_attr->store(subsys_priv->bus, buf, count);
 	return ret;
 }
 
@@ -858,9 +857,9 @@ static BUS_ATTR(uevent, S_IWUSR, NULL, bus_uevent_store);
 int bus_register(struct bus_type *bus)
 {
 	int retval;
-	struct bus_type_private *priv;
+	struct subsys_private *priv;
 
-	priv = kzalloc(sizeof(struct bus_type_private), GFP_KERNEL);
+	priv = kzalloc(sizeof(struct subsys_private), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 7975a52..4f1df2e 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -27,7 +27,7 @@ static ssize_t class_attr_show(struct kobject *kobj, struct attribute *attr,
 			       char *buf)
 {
 	struct class_attribute *class_attr = to_class_attr(attr);
-	struct class_private *cp = to_class(kobj);
+	struct subsys_private *cp = to_subsys_private(kobj);
 	ssize_t ret = -EIO;
 
 	if (class_attr->show)
@@ -39,7 +39,7 @@ static ssize_t class_attr_store(struct kobject *kobj, struct attribute *attr,
 				const char *buf, size_t count)
 {
 	struct class_attribute *class_attr = to_class_attr(attr);
-	struct class_private *cp = to_class(kobj);
+	struct subsys_private *cp = to_subsys_private(kobj);
 	ssize_t ret = -EIO;
 
 	if (class_attr->store)
@@ -49,7 +49,7 @@ static ssize_t class_attr_store(struct kobject *kobj, struct attribute *attr,
 
 static void class_release(struct kobject *kobj)
 {
-	struct class_private *cp = to_class(kobj);
+	struct subsys_private *cp = to_subsys_private(kobj);
 	struct class *class = cp->class;
 
 	pr_debug("class '%s': release.\n", class->name);
@@ -65,7 +65,7 @@ static void class_release(struct kobject *kobj)
 
 static const struct kobj_ns_type_operations *class_child_ns_type(struct kobject *kobj)
 {
-	struct class_private *cp = to_class(kobj);
+	struct subsys_private *cp = to_subsys_private(kobj);
 	struct class *class = cp->class;
 
 	return class->ns_type;
@@ -82,7 +82,7 @@ static struct kobj_type class_ktype = {
 	.child_ns_type	= class_child_ns_type,
 };
 
-/* Hotplug events for classes go to the class class_subsys */
+/* Hotplug events for classes go to the class subsys */
 static struct kset *class_kset;
 
 
@@ -90,7 +90,7 @@ int class_create_file(struct class *cls, const struct class_attribute *attr)
 {
 	int error;
 	if (cls)
-		error = sysfs_create_file(&cls->p->class_subsys.kobj,
+		error = sysfs_create_file(&cls->p->subsys.kobj,
 					  &attr->attr);
 	else
 		error = -EINVAL;
@@ -100,20 +100,20 @@ int class_create_file(struct class *cls, const struct class_attribute *attr)
 void class_remove_file(struct class *cls, const struct class_attribute *attr)
 {
 	if (cls)
-		sysfs_remove_file(&cls->p->class_subsys.kobj, &attr->attr);
+		sysfs_remove_file(&cls->p->subsys.kobj, &attr->attr);
 }
 
 static struct class *class_get(struct class *cls)
 {
 	if (cls)
-		kset_get(&cls->p->class_subsys);
+		kset_get(&cls->p->subsys);
 	return cls;
 }
 
 static void class_put(struct class *cls)
 {
 	if (cls)
-		kset_put(&cls->p->class_subsys);
+		kset_put(&cls->p->subsys);
 }
 
 static int add_class_attrs(struct class *cls)
@@ -162,7 +162,7 @@ static void klist_class_dev_put(struct klist_node *n)
 
 int __class_register(struct class *cls, struct lock_class_key *key)
 {
-	struct class_private *cp;
+	struct subsys_private *cp;
 	int error;
 
 	pr_debug("device class '%s': registering\n", cls->name);
@@ -170,11 +170,11 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
 	if (!cp)
 		return -ENOMEM;
-	klist_init(&cp->class_devices, klist_class_dev_get, klist_class_dev_put);
+	klist_init(&cp->klist_devices, klist_class_dev_get, klist_class_dev_put);
 	INIT_LIST_HEAD(&cp->class_interfaces);
-	kset_init(&cp->class_dirs);
+	kset_init(&cp->glue_dirs);
 	__mutex_init(&cp->class_mutex, "struct class mutex", key);
-	error = kobject_set_name(&cp->class_subsys.kobj, "%s", cls->name);
+	error = kobject_set_name(&cp->subsys.kobj, "%s", cls->name);
 	if (error) {
 		kfree(cp);
 		return error;
@@ -187,15 +187,15 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 #if defined(CONFIG_BLOCK)
 	/* let the block class directory show up in the root of sysfs */
 	if (!sysfs_deprecated || cls != &block_class)
-		cp->class_subsys.kobj.kset = class_kset;
+		cp->subsys.kobj.kset = class_kset;
 #else
-	cp->class_subsys.kobj.kset = class_kset;
+	cp->subsys.kobj.kset = class_kset;
 #endif
-	cp->class_subsys.kobj.ktype = &class_ktype;
+	cp->subsys.kobj.ktype = &class_ktype;
 	cp->class = cls;
 	cls->p = cp;
 
-	error = kset_register(&cp->class_subsys);
+	error = kset_register(&cp->subsys);
 	if (error) {
 		kfree(cp);
 		return error;
@@ -210,7 +210,7 @@ void class_unregister(struct class *cls)
 {
 	pr_debug("device class '%s': unregistering\n", cls->name);
 	remove_class_attrs(cls);
-	kset_unregister(&cls->p->class_subsys);
+	kset_unregister(&cls->p->subsys);
 }
 
 static void class_create_release(struct class *cls)
@@ -295,7 +295,7 @@ void class_dev_iter_init(struct class_dev_iter *iter, struct class *class,
 
 	if (start)
 		start_knode = &start->knode_class;
-	klist_iter_init_node(&class->p->class_devices, &iter->ki, start_knode);
+	klist_iter_init_node(&class->p->klist_devices, &iter->ki, start_knode);
 	iter->type = type;
 }
 EXPORT_SYMBOL_GPL(class_dev_iter_init);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6ed6454..46ff6c2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -610,7 +610,7 @@ class_dir_create_and_add(struct class *class, struct kobject *parent_kobj)
 	dir->class = class;
 	kobject_init(&dir->kobj, &class_dir_ktype);
 
-	dir->kobj.kset = &class->p->class_dirs;
+	dir->kobj.kset = &class->p->glue_dirs;
 
 	retval = kobject_add(&dir->kobj, parent_kobj, "%s", class->name);
 	if (retval < 0) {
@@ -635,7 +635,7 @@ static struct kobject *get_device_parent(struct device *dev,
 		if (sysfs_deprecated && dev->class == &block_class) {
 			if (parent && parent->class == &block_class)
 				return &parent->kobj;
-			return &block_class.p->class_subsys.kobj;
+			return &block_class.p->subsys.kobj;
 		}
 #endif
 
@@ -654,13 +654,13 @@ static struct kobject *get_device_parent(struct device *dev,
 		mutex_lock(&gdp_mutex);
 
 		/* find our class-directory at the parent and reference it */
-		spin_lock(&dev->class->p->class_dirs.list_lock);
-		list_for_each_entry(k, &dev->class->p->class_dirs.list, entry)
+		spin_lock(&dev->class->p->glue_dirs.list_lock);
+		list_for_each_entry(k, &dev->class->p->glue_dirs.list, entry)
 			if (k->parent == parent_kobj) {
 				kobj = kobject_get(k);
 				break;
 			}
-		spin_unlock(&dev->class->p->class_dirs.list_lock);
+		spin_unlock(&dev->class->p->glue_dirs.list_lock);
 		if (kobj) {
 			mutex_unlock(&gdp_mutex);
 			return kobj;
@@ -682,7 +682,7 @@ static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
 {
 	/* see if we live in a "glue" directory */
 	if (!glue_dir || !dev->class ||
-	    glue_dir->kset != &dev->class->p->class_dirs)
+	    glue_dir->kset != &dev->class->p->glue_dirs)
 		return;
 
 	kobject_put(glue_dir);
@@ -709,7 +709,7 @@ static int device_add_class_symlinks(struct device *dev)
 		return 0;
 
 	error = sysfs_create_link(&dev->kobj,
-				  &dev->class->p->class_subsys.kobj,
+				  &dev->class->p->subsys.kobj,
 				  "subsystem");
 	if (error)
 		goto out;
@@ -728,7 +728,7 @@ static int device_add_class_symlinks(struct device *dev)
 #endif
 
 	/* link in the class directory pointing to the device */
-	error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
+	error = sysfs_create_link(&dev->class->p->subsys.kobj,
 				  &dev->kobj, dev_name(dev));
 	if (error)
 		goto out_device;
@@ -756,7 +756,7 @@ static void device_remove_class_symlinks(struct device *dev)
 	if (sysfs_deprecated && dev->class == &block_class)
 		return;
 #endif
-	sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
+	sysfs_delete_link(&dev->class->p->subsys.kobj, &dev->kobj, dev_name(dev));
 }
 
 /**
@@ -947,7 +947,7 @@ int device_add(struct device *dev)
 		mutex_lock(&dev->class->p->class_mutex);
 		/* tie the class to the device */
 		klist_add_tail(&dev->knode_class,
-			       &dev->class->p->class_devices);
+			       &dev->class->p->klist_devices);
 
 		/* notify any interfaces that the device is here */
 		list_for_each_entry(class_intf,
@@ -1535,7 +1535,7 @@ int device_rename(struct device *dev, const char *new_name)
 	}
 
 	if (dev->class) {
-		error = sysfs_rename_link(&dev->class->p->class_subsys.kobj,
+		error = sysfs_rename_link(&dev->class->p->subsys.kobj,
 			&dev->kobj, old_device_name, new_name);
 		if (error)
 			goto out;
diff --git a/include/linux/device.h b/include/linux/device.h
index dd48953..1e2d335 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -30,9 +30,8 @@ struct device_private;
 struct device_driver;
 struct driver_private;
 struct class;
-struct class_private;
+struct subsys_private;
 struct bus_type;
-struct bus_type_private;
 struct device_node;
 
 struct bus_attribute {
@@ -65,7 +64,7 @@ struct bus_type {
 
 	const struct dev_pm_ops *pm;
 
-	struct bus_type_private *p;
+	struct subsys_private *p;
 };
 
 extern int __must_check bus_register(struct bus_type *bus);
@@ -213,7 +212,7 @@ struct class {
 
 	const struct dev_pm_ops *pm;
 
-	struct class_private *p;
+	struct subsys_private *p;
 };
 
 struct class_dev_iter {
-- 
1.7.3.2

