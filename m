Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2BAEr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 23:47:56 -0500
Received: from ozlabs.org ([203.10.76.45]:57071 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122Ab2BAErK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 23:47:10 -0500
From: David Gibson <david@gibson.dropbear.id.au>
To: dwmw2@infradead.org, iommu@lists.linux-foundation.org
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, qemu-devel@nongnu.org,
        alex.williamson@redhat.com, joerg.roedel@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Device isolation group infrastructure (v3)
Date: Wed,  1 Feb 2012 15:46:52 +1100
Message-Id: <1328071614-8320-2-git-send-email-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328071614-8320-1-git-send-email-david@gibson.dropbear.id.au>
References: <1328071614-8320-1-git-send-email-david@gibson.dropbear.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to safely drive a device with a userspace driver, or to pass
it through to a guest system, we must first make sure that the device
is isolated in such a way that it cannot interfere with other devices
on the system.  This isolation is only available on some systems and
will generally require an iommu, and might require other support in
bridges or other system hardware.

Often, it's not possible to isolate every device from every other
device in the system.  For example, certain PCI/PCIe bridge
configurations mean that an iommu cannot reliably distinguish which
device behind the bridge initiated a DMA transaction.  Similarly some
buggy PCI multifunction devices initiate all DMAs as function 0, so
the functions cannot be isolated from each other, even if the IOMMU
normally allows this.

Therefore, the user, and code to allow userspace drivers or guest
passthrough, needs a way to determine which devices can be isolated
from which others.  This patch adds infrastructure to handle this by
introducing the concept of a "device isolation group" - a group of
devices which can, as a unit, be safely isolated from the rest of the
system and therefore can be, as a unit, safely assigned to an
unprivileged used or guest.  That is, the groups represent the minimum
granularity with which devices may be assigned to untrusted
components.

This code manages groups, but does not create them or allow use of
grouped devices by a guest.  Creating groups would be done by iommu or
bridge drivers, using the interface this patch provides.  It's
expected that the groups will be used in future by the in-kernel iommu
interface, and would also be used by VFIO or other subsystems to allow
safe passthrough of devices to userspace or guests.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 drivers/base/Kconfig             |    3 +
 drivers/base/Makefile            |    1 +
 drivers/base/base.h              |    3 +
 drivers/base/core.c              |    6 ++
 drivers/base/device_isolation.c  |  184 ++++++++++++++++++++++++++++++++++++++
 drivers/base/init.c              |    2 +
 include/linux/device.h           |    5 +
 include/linux/device_isolation.h |  100 +++++++++++++++++++++
 8 files changed, 304 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/device_isolation.c
 create mode 100644 include/linux/device_isolation.h

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 7be9f79..a52f2db 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -189,4 +189,7 @@ config DMA_SHARED_BUFFER
 	  APIs extension; the file's descriptor can then be passed on to other
 	  driver.
 
+config DEVICE_ISOLATION
+	bool "Enable isolating devices for safe pass-through to guests or user space."
+
 endmenu
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 2c8272d..5daef29 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_MODULES)	+= module.o
 endif
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 obj-$(CONFIG_REGMAP)	+= regmap/
+obj-$(CONFIG_DEVICE_ISOLATION) += device_isolation.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 
diff --git a/drivers/base/base.h b/drivers/base/base.h
index b858dfd..713e168 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -25,6 +25,9 @@
  * bus_type/class to be statically allocated safely.  Nothing outside of the
  * driver core should ever touch these fields.
  */
+
+#include <linux/device_isolation.h>
+
 struct subsys_private {
 	struct kset subsys;
 	struct kset *devices_kset;
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4a67cc0..18edcb1 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/async.h>
 #include <linux/pm_runtime.h>
+#include <linux/device_isolation.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -644,6 +645,9 @@ void device_initialize(struct device *dev)
 	lockdep_set_novalidate_class(&dev->mutex);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
+#ifdef CONFIG_DEVICE_ISOLATION
+	dev->di_group = NULL;
+#endif
 	device_pm_init(dev);
 	set_dev_node(dev, -1);
 }
@@ -1047,6 +1051,8 @@ int device_add(struct device *dev)
 				class_intf->add_dev(dev, class_intf);
 		mutex_unlock(&dev->class->p->mutex);
 	}
+
+	device_isolation_dev_update_sysfs(dev);
 done:
 	put_device(dev);
 	return error;
diff --git a/drivers/base/device_isolation.c b/drivers/base/device_isolation.c
new file mode 100644
index 0000000..4f1f17e
--- /dev/null
+++ b/drivers/base/device_isolation.c
@@ -0,0 +1,184 @@
+/*
+ * device_isolation.c
+ *
+ * Handling of device isolation groups, groups of hardware devices
+ * which are sufficiently isolated by an IOMMU from the rest of the
+ * system that they can be safely given (as a unit) to an unprivileged
+ * user process or guest system to drive.
+ *
+ * Copyright (c) 2011 Alexey Kardashevskiy, IBM Corporation
+ * Copyright (c) 2011 David Gibson, IBM Corporation
+ *
+ */
+
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/device_isolation.h>
+
+static struct kset *device_isolation_kset;
+
+struct dig_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct device_isolation_group *group, char *buf);
+	ssize_t (*store)(struct device_isolation_group *group, const char *buf,
+			size_t count);
+};
+
+#define DIG_ATTR(_name, _mode, _show, _store)	\
+	struct dig_attribute dig_attr_##_name = \
+		__ATTR(_name, _mode, _show, _store)
+
+#define to_dig_attr(_attr) \
+	container_of(_attr, struct dig_attribute, attr)
+
+static ssize_t dig_attr_show(struct kobject *kobj, struct attribute *attr,
+			     char *buf)
+{
+	struct dig_attribute *dig_attr = to_dig_attr(attr);
+	struct device_isolation_group *group =
+		container_of(kobj, struct device_isolation_group, kobj);
+	ssize_t ret = -EIO;
+
+	if (dig_attr->show)
+		ret = dig_attr->show(group, buf);
+	return ret;
+}
+
+static ssize_t dig_attr_store(struct kobject *kobj, struct attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct dig_attribute *dig_attr = to_dig_attr(attr);
+	struct device_isolation_group *group =
+		container_of(kobj, struct device_isolation_group, kobj);
+	ssize_t ret = -EIO;
+
+	if (dig_attr->store)
+		ret = dig_attr->store(group, buf, count);
+	return ret;
+}
+
+static void dig_release(struct kobject *kobj)
+{
+	/* FIXME: No way for groups to be removed as yet */
+	BUG();
+}
+
+static const struct sysfs_ops dig_sysfs_ops = {
+	.show	= dig_attr_show,
+	.store	= dig_attr_store,
+};
+
+static struct kobj_type dig_ktype = {
+	.sysfs_ops	= &dig_sysfs_ops,
+	.release	= dig_release,
+};
+
+int device_isolation_group_init(struct device_isolation_group *group,
+				const char *fmt, ...)
+{
+	int ret;
+	va_list args;
+
+	kobject_init(&group->kobj, &dig_ktype);
+	mutex_init(&group->mutex);
+	INIT_LIST_HEAD(&group->devices);
+
+	group->kobj.kset = device_isolation_kset;
+
+	va_start(args, fmt);
+	ret = kobject_set_name_vargs(&group->kobj, fmt, args);
+	va_end(args);
+	if (ret < 0) {
+		printk(KERN_ERR "device_isolation: "
+		       "kobject_set_name_vargs() failed\n");
+		return ret;
+	}
+
+	ret = kobject_add(&group->kobj, NULL, NULL);
+	if (ret < 0) {
+		printk(KERN_ERR "device_isolation: "
+		       "kobject_add() failed for %s\n",
+		       kobject_name(&group->kobj));
+		return ret;
+	}
+
+
+#define CREATE_ATTR(_attr) \
+	do { \
+		if (sysfs_create_file(&group->kobj, \
+				      &dig_attr_##_attr.attr) < 0) \
+		printk(KERN_WARNING "device_isolation: create \"" \
+			#_attr "\" \failed for %s (errno=%d)\n", \
+		       kobject_name(&group->kobj), ret); \
+	} while (0)
+
+#undef CREATE_ATTR
+
+	printk(KERN_DEBUG "device_isolation: group %s created\n",
+		kobject_name(&group->kobj));
+
+	return 0;
+}
+
+void device_isolation_dev_add(struct device_isolation_group *group,
+			      struct device *dev)
+{
+	printk(KERN_DEBUG "device_isolation: adding device %s to group %s\n",
+		kobject_name(&dev->kobj), kobject_name(&group->kobj));
+
+	mutex_lock(&group->mutex);
+	list_add_tail(&dev->di_list, &group->devices);
+	dev->di_group = group;
+	mutex_unlock(&group->mutex);
+}
+
+void device_isolation_dev_remove(struct device *dev)
+{
+	struct device_isolation_group *group = dev->di_group;
+
+	BUG_ON(!group);
+
+	mutex_lock(&group->mutex);
+	list_del(&dev->di_list);
+	mutex_unlock(&group->mutex);
+}
+
+int device_isolation_dev_update_sysfs(struct device *dev)
+{
+	int ret;
+	struct device_isolation_group *group = dev->di_group;
+
+	if (!group)
+		return 0;
+
+	printk(KERN_DEBUG "device_isolation: updating links for %s in "
+			"group %s\n", kobject_name(&dev->kobj),
+			kobject_name(&group->kobj));
+
+	mutex_lock(&group->mutex);
+
+	ret = sysfs_create_link(&dev->kobj, &group->kobj, "device_isolation_group");
+	if (0 > ret)
+		printk(KERN_WARNING "device_isolation: create device_isolation_group "
+			"link failed for %s -> %s, errno=%i\n",
+			kobject_name(&dev->kobj), kobject_name(&group->kobj), ret);
+
+	ret = sysfs_create_link(&group->kobj, &dev->kobj, kobject_name(&dev->kobj));
+	if (0 > ret)
+		printk(KERN_WARNING "device_isolation: create "
+			"link failed for %s -> %s, errno=%i\n",
+			kobject_name(&dev->kobj), kobject_name(&group->kobj),
+			ret);
+
+	mutex_unlock(&group->mutex);
+
+	return ret;
+}
+
+int __init device_isolation_init(void)
+{
+	device_isolation_kset = kset_create_and_add("isolation", NULL, NULL);
+	if (!device_isolation_kset)
+		return -ENOMEM;
+	return 0;
+}
diff --git a/drivers/base/init.c b/drivers/base/init.c
index c16f0b8..e765717 100644
--- a/drivers/base/init.c
+++ b/drivers/base/init.c
@@ -8,6 +8,7 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/memory.h>
+#include <linux/device_isolation.h>
 
 #include "base.h"
 
@@ -24,6 +25,7 @@ void __init driver_init(void)
 	devices_init();
 	buses_init();
 	classes_init();
+	device_isolation_init();
 	firmware_init();
 	hypervisor_init();
 
diff --git a/include/linux/device.h b/include/linux/device.h
index b63fb39..9a2b472 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -667,6 +667,11 @@ struct device {
 
 	struct dma_coherent_mem	*dma_mem; /* internal for coherent mem
 					     override */
+#ifdef CONFIG_DEVICE_ISOLATION
+	struct device_isolation_group *di_group;
+	struct list_head 	di_list;
+#endif
+
 	/* arch specific additions */
 	struct dev_archdata	archdata;
 
diff --git a/include/linux/device_isolation.h b/include/linux/device_isolation.h
new file mode 100644
index 0000000..2f0afdc
--- /dev/null
+++ b/include/linux/device_isolation.h
@@ -0,0 +1,100 @@
+#ifndef _DEVICE_ISOLATION_H_
+#define _DEVICE_ISOLATION_H_
+
+#include <linux/kobject.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/device.h>
+
+struct device_isolation_binder {
+	const char *name;
+};
+
+struct device_isolation_group {
+	struct kobject 			kobj;
+	struct list_head 		devices;
+	struct mutex			mutex;
+};
+
+#ifdef CONFIG_DEVICE_ISOLATION
+
+int __init device_isolation_init(void);
+
+int device_isolation_group_init(struct device_isolation_group *group,
+				const char *fmt, ...);
+
+void device_isolation_dev_add(struct device_isolation_group *group,
+			      struct device *dev);
+void device_isolation_dev_remove(struct device *dev);
+int device_isolation_dev_update_sysfs(struct device *dev);
+
+int device_isolation_bind(struct device_isolation_group *group,
+			  struct device_isolation_binder *binder,
+			  void *priv);
+void device_isolation_unbind(struct device_isolation_group *group,
+			     struct device_isolation_binder *binder);
+
+#else /* CONFIG_DEVICE_ISOLATION */
+
+static inline int __init device_isolation_init(void)
+{
+	return 0;
+}
+
+static inline
+int device_isolation_group_init(struct device_isolation_group *group,
+				const char *fmt, ...)
+{
+	return 0;
+}
+
+static inline
+struct isolation_group *device_isolation_group_new(const char *name)
+{
+	return NULL;
+}
+
+static inline
+void device_isolation_dev_add(struct device_isolation_group *group,
+			      struct device *dev)
+{
+}
+
+static inline
+void device_isolation_dev_remove(struct device *dev)
+{
+}
+
+static inline int device_isolation_dev_update_sysfs(struct device *dev)
+{
+	return 0;
+}
+
+static inline
+int device_isolation_bind(struct device_isolation_group *group,
+			  struct device_isolation_binder *binder,
+			  void *priv)
+{
+	return -ENOSYS;
+}
+
+static inline
+void device_isolation_unbind(struct device_isolation_group *group,
+			     struct device_isolation_binder *binder)
+{
+	BUG();
+}
+
+#endif /* CONFIG_DEVICE_ISOLATION */
+
+static inline
+struct device_isolation_group *device_isolation_group(struct device *dev)
+{
+#ifdef CONFIG_DEVICE_ISOLATION
+	return dev->di_group;
+#else /* CONFIG_DEVICE_ISOLATION */
+	return NULL;
+#endif /* CONFIG_DEVICE_ISOLATION */
+}
+
+#endif /* _DEVICE_ISOLATION_H_ */
-- 
1.7.8.3

