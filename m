Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2DPNGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:06:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab2DPNG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:06:28 -0400
From: Hannes Reinecke <hare@suse.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>,
        Greg Kroah-Hartmann <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>, Stable Kernel <stable@kernel.org>
Subject: [PATCH] driver core: check start node in klist_iter_init_node
Date: Mon, 16 Apr 2012 15:06:25 +0200
Message-Id: <1334581585-42726-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

klist_iter_init_node() takes a node as a start argument.
However, this node might not be valid anymore.
This patch updates the klist_iter_init_node() and
dependent functions to return an error if so.
All calling functions have been audited to check
for a return code here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Greg Kroah-Hartmann <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Stable Kernel <stable@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 26a06b8..a2152a6 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -297,11 +297,13 @@ int bus_for_each_dev(struct bus_type *bus, struct device *start,
 	if (!bus)
 		return -EINVAL;
 
-	klist_iter_init_node(&bus->p->klist_devices, &i,
-			     (start ? &start->p->knode_bus : NULL));
-	while ((dev = next_device(&i)) && !error)
-		error = fn(dev, data);
-	klist_iter_exit(&i);
+	error = klist_iter_init_node(&bus->p->klist_devices, &i,
+				     (start ? &start->p->knode_bus : NULL));
+	if (!error) {
+		while ((dev = next_device(&i)) && !error)
+			error = fn(dev, data);
+		klist_iter_exit(&i);
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(bus_for_each_dev);
@@ -331,8 +333,10 @@ struct device *bus_find_device(struct bus_type *bus,
 	if (!bus)
 		return NULL;
 
-	klist_iter_init_node(&bus->p->klist_devices, &i,
-			     (start ? &start->p->knode_bus : NULL));
+	if (klist_iter_init_node(&bus->p->klist_devices, &i,
+				 (start ? &start->p->knode_bus : NULL)) < 0)
+		return NULL;
+
 	while ((dev = next_device(&i)))
 		if (match(dev, data) && get_device(dev))
 			break;
@@ -385,7 +389,9 @@ struct device *subsys_find_device_by_id(struct bus_type *subsys, unsigned int id
 		return NULL;
 
 	if (hint) {
-		klist_iter_init_node(&subsys->p->klist_devices, &i, &hint->p->knode_bus);
+		if (klist_iter_init_node(&subsys->p->klist_devices, &i,
+					 &hint->p->knode_bus) < 0)
+			return NULL;
 		dev = next_device(&i);
 		if (dev && dev->id == id && get_device(dev)) {
 			klist_iter_exit(&i);
@@ -447,11 +453,13 @@ int bus_for_each_drv(struct bus_type *bus, struct device_driver *start,
 	if (!bus)
 		return -EINVAL;
 
-	klist_iter_init_node(&bus->p->klist_drivers, &i,
-			     start ? &start->p->knode_bus : NULL);
-	while ((drv = next_driver(&i)) && !error)
-		error = fn(drv, data);
-	klist_iter_exit(&i);
+	error = klist_iter_init_node(&bus->p->klist_drivers, &i,
+				     start ? &start->p->knode_bus : NULL);
+	if (!error) {
+		while ((drv = next_driver(&i)) && !error)
+			error = fn(drv, data);
+		klist_iter_exit(&i);
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(bus_for_each_drv);
@@ -1112,15 +1120,19 @@ EXPORT_SYMBOL_GPL(bus_sort_breadthfirst);
  * otherwise if it is NULL, the iteration starts at the beginning of
  * the list.
  */
-void subsys_dev_iter_init(struct subsys_dev_iter *iter, struct bus_type *subsys,
-			  struct device *start, const struct device_type *type)
+int subsys_dev_iter_init(struct subsys_dev_iter *iter, struct bus_type *subsys,
+			 struct device *start, const struct device_type *type)
 {
 	struct klist_node *start_knode = NULL;
+	int error;
 
 	if (start)
 		start_knode = &start->p->knode_bus;
-	klist_iter_init_node(&subsys->p->klist_devices, &iter->ki, start_knode);
-	iter->type = type;
+	error = klist_iter_init_node(&subsys->p->klist_devices, &iter->ki,
+				     start_knode);
+	if (!error)
+		iter->type = type;
+	return error;
 }
 EXPORT_SYMBOL_GPL(subsys_dev_iter_init);
 
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 03243d4..23dbc66 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -301,15 +301,20 @@ void class_destroy(struct class *cls)
  * otherwise if it is NULL, the iteration starts at the beginning of
  * the list.
  */
-void class_dev_iter_init(struct class_dev_iter *iter, struct class *class,
-			 struct device *start, const struct device_type *type)
+int class_dev_iter_init(struct class_dev_iter *iter, struct class *class,
+			struct device *start, const struct device_type *type)
 {
 	struct klist_node *start_knode = NULL;
+	int error;
 
 	if (start)
 		start_knode = &start->knode_class;
-	klist_iter_init_node(&class->p->klist_devices, &iter->ki, start_knode);
-	iter->type = type;
+	error = klist_iter_init_node(&class->p->klist_devices, &iter->ki,
+				     start_knode);
+	if (!error)
+		iter->type = type;
+
+	return error;
 }
 EXPORT_SYMBOL_GPL(class_dev_iter_init);
 
@@ -387,14 +392,15 @@ int class_for_each_device(struct class *class, struct device *start,
 		return -EINVAL;
 	}
 
-	class_dev_iter_init(&iter, class, start, NULL);
-	while ((dev = class_dev_iter_next(&iter))) {
-		error = fn(dev, data);
-		if (error)
-			break;
+	error = class_dev_iter_init(&iter, class, start, NULL);
+	if (!error) {
+		while ((dev = class_dev_iter_next(&iter))) {
+			error = fn(dev, data);
+			if (error)
+				break;
+		}
+		class_dev_iter_exit(&iter);
 	}
-	class_dev_iter_exit(&iter);
-
 	return error;
 }
 EXPORT_SYMBOL_GPL(class_for_each_device);
@@ -434,7 +440,9 @@ struct device *class_find_device(struct class *class, struct device *start,
 		return NULL;
 	}
 
-	class_dev_iter_init(&iter, class, start, NULL);
+	if (class_dev_iter_init(&iter, class, start, NULL) < 0)
+		return NULL;
+
 	while ((dev = class_dev_iter_next(&iter))) {
 		if (match(dev, data)) {
 			get_device(dev);
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 3ec3896..16f6dd2 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -49,11 +49,13 @@ int driver_for_each_device(struct device_driver *drv, struct device *start,
 	if (!drv)
 		return -EINVAL;
 
-	klist_iter_init_node(&drv->p->klist_devices, &i,
-			     start ? &start->p->knode_driver : NULL);
-	while ((dev = next_device(&i)) && !error)
-		error = fn(dev, data);
-	klist_iter_exit(&i);
+	error = klist_iter_init_node(&drv->p->klist_devices, &i,
+				     start ? &start->p->knode_driver : NULL);
+	if (!error) {
+		while ((dev = next_device(&i)) && !error)
+			error = fn(dev, data);
+		klist_iter_exit(&i);
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(driver_for_each_device);
@@ -83,8 +85,10 @@ struct device *driver_find_device(struct device_driver *drv,
 	if (!drv)
 		return NULL;
 
-	klist_iter_init_node(&drv->p->klist_devices, &i,
-			     (start ? &start->p->knode_driver : NULL));
+	if (klist_iter_init_node(&drv->p->klist_devices, &i,
+				 (start ? &start->p->knode_driver : NULL)) < 0)
+		return NULL;
+
 	while ((dev = next_device(&i)))
 		if (match(dev, data) && get_device(dev))
 			break;
diff --git a/include/linux/device.h b/include/linux/device.h
index 5ad17cc..50429b9 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -128,7 +128,7 @@ struct subsys_dev_iter {
 	struct klist_iter		ki;
 	const struct device_type	*type;
 };
-void subsys_dev_iter_init(struct subsys_dev_iter *iter,
+int subsys_dev_iter_init(struct subsys_dev_iter *iter,
 			 struct bus_type *subsys,
 			 struct device *start,
 			 const struct device_type *type);
@@ -380,10 +380,10 @@ int class_compat_create_link(struct class_compat *cls, struct device *dev,
 void class_compat_remove_link(struct class_compat *cls, struct device *dev,
 			      struct device *device_link);
 
-extern void class_dev_iter_init(struct class_dev_iter *iter,
-				struct class *class,
-				struct device *start,
-				const struct device_type *type);
+extern int class_dev_iter_init(struct class_dev_iter *iter,
+			       struct class *class,
+			       struct device *start,
+			       const struct device_type *type);
 extern struct device *class_dev_iter_next(struct class_dev_iter *iter);
 extern void class_dev_iter_exit(struct class_dev_iter *iter);
 
diff --git a/include/linux/klist.h b/include/linux/klist.h
index a370ce5..9f63323 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -60,7 +60,7 @@ struct klist_iter {
 
 
 extern void klist_iter_init(struct klist *k, struct klist_iter *i);
-extern void klist_iter_init_node(struct klist *k, struct klist_iter *i,
+extern int klist_iter_init_node(struct klist *k, struct klist_iter *i,
 				 struct klist_node *n);
 extern void klist_iter_exit(struct klist_iter *i);
 extern struct klist_node *klist_next(struct klist_iter *i);
diff --git a/lib/klist.c b/lib/klist.c
index 0874e41..a2741a7 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -278,13 +278,19 @@ EXPORT_SYMBOL_GPL(klist_node_attached);
  * Similar to klist_iter_init(), but starts the action off with @n,
  * instead of with the list head.
  */
-void klist_iter_init_node(struct klist *k, struct klist_iter *i,
-			  struct klist_node *n)
+int klist_iter_init_node(struct klist *k, struct klist_iter *i,
+			 struct klist_node *n)
 {
+	if (n) {
+		kref_get(&n->n_ref);
+		if (!n->n_klist) {
+			kref_put(&n->n_ref);
+			return -ENODEV;
+		}
+	}
 	i->i_klist = k;
 	i->i_cur = n;
-	if (n)
-		kref_get(&n->n_ref);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(klist_iter_init_node);
 
