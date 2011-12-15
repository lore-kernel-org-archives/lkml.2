Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab1LOG0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:26:42 -0500
Received: from ozlabs.org ([203.10.76.45]:33815 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880Ab1LOGZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:25:53 -0500
From: David Gibson <david@gibson.dropbear.id.au>
To: alex.williamson@redhat.com
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, joerg.roedel@amd.com,
        dwmw2@infradead.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com, rusty@rustcorp.com.au,
        iommu@lists.linux-foundation.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] device_isolation: Infrastructure for managing device isolation groups
Date: Thu, 15 Dec 2011 17:25:38 +1100
Message-Id: <1323930340-24055-2-git-send-email-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
References: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

In order to safely drive a device with a userspace driver, or to pass
it through to a guest system, we must first make sure that the device
is isolated in such a way that it cannot interfere with other devices
on the system.  This isolation is only available on some systems and
will generally require an iommu, and might require other support in
bridges or other system hardware.

Often, it's not possible to isolate every device from every device
from every other device in the system.  For example, certain PCI/PCIe
bridge configurations mean that an iommu cannot reliably distinguish
which device behind the bridge initiated a DMA transaction.  Similarly
some buggy multifunction devices initiate all DMAs as function 0, so
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

This code manages groups, but does not create them or of itself allow
use of grouped devices by a guest.  Creating groups would be done by
iommu or bridge drivers, using the interface this patch provides.
Using the groups is expected to be provided by something similar to
vfio, yet to be written, again using interfaces provided by this code.

What this code does do, is:

 * Allow iommu/bridge drivers to easily create groups and put devices
   in them.

 * Publish the groups in /sys/isolation with links from the group to
   its constituent devices and back.

 * Allow driver matching be disallowed on a group via a sysfs
   attribute.  When this is done, existing kernel drivers will be
   unbound from the group, and drivers will no longer match and bind
   to devices in the group.  Removing kernel drivers is clearly a
   prerequisite before the group can be assigned to a guest.

 * Allows a kernel subsystem to "bind" a group, effectively claiming
   exclusive use of it.  This can be done unprivileged, provided the
   process initiating the bind has permission to the group as
   determined by uid/gid/mode attributes.

It's expected that a subsystem like VFIO would use the "bind"
interface to claim the group for itself before passing the group on
to userspace or a guest.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 drivers/base/Kconfig             |    3 +
 drivers/base/Makefile            |    1 +
 drivers/base/base.h              |    5 +
 drivers/base/core.c              |    6 +
 drivers/base/device_isolation.c  |  509 ++++++++++++++++++++++++++++++++++++++
 drivers/base/init.c              |    2 +
 include/linux/device.h           |    5 +
 include/linux/device_isolation.h |  124 +++++++++
 8 files changed, 655 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/device_isolation.c
 create mode 100644 include/linux/device_isolation.h

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 21cf46f..ed464c9 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -174,4 +174,7 @@ config SYS_HYPERVISOR
 
 source "drivers/base/regmap/Kconfig"
 
+config DEVICE_ISOLATION
+	bool "Enable isolating devices for safe pass-through to guests or user space."
+
 endmenu
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 99a375a..79ac7b3 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_MODULES)	+= module.o
 endif
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 obj-$(CONFIG_REGMAP)	+= regmap/
+obj-$(CONFIG_DEVICE_ISOLATION) += device_isolation.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 
diff --git a/drivers/base/base.h b/drivers/base/base.h
index a34dca0..8ee0c95 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -24,6 +24,9 @@
  * bus_type/class to be statically allocated safely.  Nothing outside of the
  * driver core should ever touch these fields.
  */
+
+#include <linux/device_isolation.h>
+
 struct subsys_private {
 	struct kset subsys;
 	struct kset *devices_kset;
@@ -108,6 +111,8 @@ extern int driver_probe_device(struct device_driver *drv, struct device *dev);
 static inline int driver_match_device(struct device_driver *drv,
 				      struct device *dev)
 {
+	if (!device_isolation_driver_match_allowed(dev))
+		return 0;
 	return drv->bus->match ? drv->bus->match(dev, drv) : 1;
 }
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index bc8729d..ca8a0fa 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -22,6 +22,7 @@
 #include <linux/kallsyms.h>
 #include <linux/mutex.h>
 #include <linux/async.h>
+#include <linux/device_isolation.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -593,6 +594,9 @@ void device_initialize(struct device *dev)
 	lockdep_set_novalidate_class(&dev->mutex);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
+#ifdef CONFIG_DEVICE_ISOLATION
+	dev->di_group = NULL;
+#endif
 	device_pm_init(dev);
 	set_dev_node(dev, -1);
 }
@@ -993,6 +997,8 @@ int device_add(struct device *dev)
 				class_intf->add_dev(dev, class_intf);
 		mutex_unlock(&dev->class->p->class_mutex);
 	}
+
+	device_isolation_dev_update_sysfs(dev);
 done:
 	put_device(dev);
 	return error;
diff --git a/drivers/base/device_isolation.c b/drivers/base/device_isolation.c
new file mode 100644
index 0000000..b13bb46
--- /dev/null
+++ b/drivers/base/device_isolation.c
@@ -0,0 +1,509 @@
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
+static ssize_t dig_show_binder(struct device_isolation_group *group, char *buf)
+{
+	ssize_t ret = 0;
+
+	mutex_lock(&group->mutex);
+	if (group->binder)
+		ret = sprintf(buf, "%s", group->binder->name);
+	mutex_unlock(&group->mutex);
+
+	return ret;
+}
+
+#if 0
+/* ONLY FOR DEBUG PURPOSE */
+static ssize_t dig_set_binder(struct device_isolation_group *group,
+			      const char *buf, size_t count)
+{
+	struct device_isolation_binder *binder;
+
+	if ((0 == buf[0]) || ('0' == buf[0])) {
+		binder = group->binder;
+		if (group->allow_driver_match) {
+			printk(KERN_ERR "device_isolation: not exclusive!!!\n");
+		} else {
+			device_isolation_unbind(group, binder);
+			if (binder) {
+				kfree(binder->name);
+				kfree(binder);
+			}
+		}
+	} else {
+		binder = kzalloc(sizeof(*binder), GFP_KERNEL);
+		binder->name = kstrdup(buf, GFP_KERNEL); 
+		if (0 > device_isolation_bind(group, binder, NULL)) {
+			kfree(binder->name);
+			kfree(binder);
+		}
+	}
+	return count;
+}
+
+static DIG_ATTR(binder, S_IWUSR | S_IRUSR | S_IROTH | S_IWOTH,
+		dig_show_binder, dig_set_binder);
+#endif
+
+static DIG_ATTR(binder, S_IWUSR | S_IRUSR, dig_show_binder, NULL);
+
+static ssize_t dig_show_allow_driver_match(struct device_isolation_group *group,
+					   char *buf)
+{
+	ssize_t ret;
+
+	mutex_lock(&group->mutex);
+	ret = sprintf(buf, "%u", !!group->allow_driver_match);
+	mutex_unlock(&group->mutex);
+
+	return ret;
+}
+
+static ssize_t dig_set_allow_driver_match(struct device_isolation_group *group,
+					  const char *buf, size_t count)
+{
+	switch (buf[0]) {
+	case '0':
+		device_isolation_disallow_driver_match(group);
+		break;
+	case '1':
+		device_isolation_allow_driver_match(group);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return count;
+}
+
+static DIG_ATTR(allow_driver_match, S_IWUSR | S_IRUSR,
+		dig_show_allow_driver_match, dig_set_allow_driver_match);
+
+static ssize_t dig_show_uid(struct device_isolation_group *group,
+			      char *buf)
+{
+	ssize_t ret;
+
+	mutex_lock(&group->mutex);
+	ret = sprintf(buf, "%u", group->uid);
+	mutex_unlock(&group->mutex);
+
+	return ret;
+}
+
+static ssize_t dig_set_uid(struct device_isolation_group *group,
+		     const char *buf, size_t count)
+{
+	long val;
+
+	if (strict_strtol(buf, 10, &val))
+		return -EINVAL;
+
+	mutex_lock(&group->mutex);
+	group->uid = val;
+	mutex_unlock(&group->mutex);
+
+	return count;
+}
+
+static DIG_ATTR(uid, S_IWUSR | S_IRUSR, dig_show_uid, dig_set_uid);
+
+static ssize_t dig_show_gid(struct device_isolation_group *group,
+		     char *buf)
+{
+	ssize_t ret;
+
+	mutex_lock(&group->mutex);
+	ret = sprintf(buf, "%u", group->gid);
+	mutex_unlock(&group->mutex);
+
+	return ret;
+}
+
+static ssize_t dig_set_gid(struct device_isolation_group *group,
+		     const char *buf, size_t count)
+{
+	long val;
+
+	if (current_uid())
+		return -EACCES;
+
+	if (strict_strtol(buf, 10, &val))
+		return -EINVAL;
+
+	mutex_lock(&group->mutex);
+	group->gid = val;
+	mutex_unlock(&group->mutex);
+
+	return count;
+}
+
+static DIG_ATTR(gid, S_IWUSR | S_IRUSR, dig_show_gid, dig_set_gid);
+
+static ssize_t dig_show_mode(struct device_isolation_group *group,
+		     char *buf)
+{
+	ssize_t ret;
+
+	mutex_lock(&group->mutex);
+	ret = sprintf(buf, "0%03o", group->mode);
+	mutex_unlock(&group->mutex);
+
+	return ret;
+}
+
+static ssize_t dig_set_mode(struct device_isolation_group *group,
+		     const char *buf, size_t count)
+{
+	long val;
+
+	if (current_uid())
+		return -EACCES;
+
+	if (strict_strtol(buf, 8, &val))
+		return -EINVAL;
+
+	if (val & ~(S_IWUGO | S_IRUGO))
+		return -EINVAL;
+
+	mutex_lock(&group->mutex);
+	group->mode = val;
+	mutex_unlock(&group->mutex);
+
+	return count;
+}
+
+static DIG_ATTR(mode, S_IWUSR | S_IRUSR, dig_show_mode, dig_set_mode);
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
+	group->mode = 0600;
+	group->allow_driver_match = true;
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
+	CREATE_ATTR(allow_driver_match);
+	CREATE_ATTR(binder);
+	CREATE_ATTR(uid);
+	CREATE_ATTR(gid);
+	CREATE_ATTR(mode);
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
+int device_isolation_allow_driver_match(struct device_isolation_group *group)
+{
+	int ret;
+	struct device *dev;
+
+	mutex_lock(&group->mutex);
+
+	if (group->allow_driver_match) {
+		/* Nothing to do */
+		ret = 0;
+		goto out;
+	}
+
+	if (group->binder) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	group->allow_driver_match = true;
+
+	list_for_each_entry(dev, &group->devices, di_list) {
+		printk(KERN_DEBUG "device_isolation: reprobing %s\n",
+				kobject_name(&dev->kobj));
+		ret = device_reprobe(dev);
+		if (ret < 0)
+			printk(KERN_WARNING "device_isolation: Error %d "
+			       "reprobing device %s\n", ret,
+			       kobject_name(&dev->kobj));
+	}
+
+	ret = 0;
+
+out:
+	mutex_unlock(&group->mutex);
+
+	return ret;
+}
+
+int device_isolation_disallow_driver_match(struct device_isolation_group *group)
+{
+	int ret;
+	struct device *dev;
+
+	BUG_ON(!group);
+
+	mutex_lock(&group->mutex);
+
+	if (!group->allow_driver_match) {
+		/* Nothing to do */
+		ret = 0;
+		goto out;
+	}
+
+	BUG_ON(group->binder);
+
+	group->allow_driver_match = false;
+
+	list_for_each_entry(dev, &group->devices, di_list) {
+		printk(KERN_DEBUG "device_isolation: reprobing %s\n",
+				kobject_name(&dev->kobj));
+		/* We need to drop the lock because reprobe can block */
+		device_release_driver(dev);
+	}
+
+out:
+	mutex_unlock(&group->mutex);
+
+	return ret;
+}
+
+static bool permission_check(struct device_isolation_group *group, int mask)
+{
+	unsigned int mode = group->mode;
+
+	mask &= MAY_READ | MAY_WRITE | MAY_EXEC | MAY_NOT_BLOCK;
+
+	if (likely(current_uid() == group->uid))
+		mode >>= 6;
+	else if (in_group_p(group->gid))
+		mode >>= 3;
+
+	if ((mask & ~mode & (MAY_READ | MAY_WRITE | MAY_EXEC)) == 0)
+		return true;
+
+	printk(KERN_DEBUG "device_isolation: permission check failed.\n");
+
+	return false;
+}
+
+int device_isolation_bind(struct device_isolation_group *group,
+			  struct device_isolation_binder *binder,
+			  void *priv)
+{
+	int ret;
+
+	printk(KERN_DEBUG "device_isolation: bind group %s to %s\n",
+	       kobject_name(&group->kobj), binder->name);
+
+	mutex_lock(&group->mutex);
+
+	if (!capable(CAP_SYS_ADMIN) &&
+	    !permission_check(group, MAY_WRITE | MAY_READ)) {
+		ret = -EACCES;
+		goto out;
+	}
+
+	if (group->allow_driver_match) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (group->binder) {
+		ret = -EEXIST;
+		goto out;
+	}
+
+	group->binder = binder;
+	group->binder_priv = priv;
+	ret = 0;
+
+out:
+	mutex_unlock(&group->mutex);
+
+	return ret;
+}
+
+void device_isolation_unbind(struct device_isolation_group *group,
+			     struct device_isolation_binder *binder)
+{
+	printk(KERN_DEBUG "device_isolation: unbind group %s from %s\n",
+	       kobject_name(&group->kobj), binder->name);
+
+	mutex_lock(&group->mutex);
+
+	BUG_ON(group->allow_driver_match);
+	BUG_ON(group->binder != binder);
+
+	group->binder = NULL;
+	group->binder_priv = NULL;
+
+	mutex_unlock(&group->mutex);
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
index c8a934e..7237e80 100644
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
index c20dfbf..e11f5c7 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -585,6 +585,11 @@ struct device {
 
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
index 0000000..64af9ac
--- /dev/null
+++ b/include/linux/device_isolation.h
@@ -0,0 +1,124 @@
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
+	bool				allow_driver_match;
+	struct device_isolation_binder	*binder;
+	void 				*binder_priv;
+	uid_t				uid;
+	gid_t				gid;
+	mode_t				mode;
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
+int device_isolation_allow_driver_match(struct device_isolation_group *group);
+int device_isolation_disallow_driver_match(struct device_isolation_group *group);
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
+static inline bool device_isolation_driver_match_allowed(struct device *dev)
+{
+	struct device_isolation_group *group =
+		device_isolation_group(dev);
+	int ret = true;
+
+	if (group) {
+		mutex_lock(&group->mutex);
+		ret = group->allow_driver_match;
+		mutex_unlock(&group->mutex);
+	}
+
+	return ret;
+}
+
+#endif /* _DEVICE_ISOLATION_H_ */
-- 
1.7.7.3

