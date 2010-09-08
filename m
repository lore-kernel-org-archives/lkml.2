Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab0IHNUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:20:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46237 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0IHNUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:20:19 -0400
From: Andi Kleen <andi@firstfloor.org>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        axboe@kernel.dk, tiwai@suse.de, James.Bottomley@HansenPartnership.com
Subject: [PATCH] SYSFS: Allow boot time switching between deprecated and modern sysfs layout
Date: Wed,  8 Sep 2010 15:19:51 +0200
Message-Id: <1283951991-16202-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

I have some systems which need legacy sysfs due to old udev versions,
and it's a big hazzle to compile separate kernels for them.

This patch turns CONFIG_SYSFS_DEPRECATED into a run time option
that can be switched on/off the kernel command line. This way
the same binary can be used in both cases with just a option
on the command line.

The old CONFIG_SYSFS_DEPRECATED_V2 option is still there to set
the default. I kept the weird name to not break existing
config files.

Also the compat code can be still completely disabled by undefining
CONFIG_SYSFS_DEPRECATED_SWITCH -- just the optimizer takes
care of this now instead of lots of ifdefs. This makes the code
look nicer.

This is a tree sweep for core/scsi/block/sound/core. There weren't
that many users and the changes were straight forward so I just did them
all in one go without splitting up.

Cc: axboe@kernel.dk
Cc: tiwai@suse.de
Cc: James.Bottomley@HansenPartnership.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/kernel-parameters.txt |    9 ++
 block/genhd.c                       |    8 +-
 drivers/base/bus.c                  |   12 ++--
 drivers/base/class.c                |    6 +-
 drivers/base/core.c                 |  150 +++++++++++++++++++++--------------
 drivers/scsi/hosts.c                |    5 +-
 drivers/scsi/scsi_scan.c            |    5 +-
 fs/partitions/check.c               |   19 ++---
 include/linux/device.h              |    7 ++
 include/sound/core.h                |   10 +--
 init/Kconfig                        |   30 +++++--
 sound/core/init.c                   |   14 +---
 12 files changed, 158 insertions(+), 117 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index f084af0..a452600 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2357,6 +2357,15 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	switches=	[HW,M68k]
 
+	sysfs.deprecated=0|1 [KNL] 
+			Enable/disable old style sysfs layout for old udev
+			on older distributions. When this option is enabled
+			very new udev will not work anymore. When this option
+			is disabled (or CONFIG_SYSFS_DEPRECATED not compiled)
+			in older udev will not work anymore.
+			Default depends on CONFIG_SYSFS_DEPRECATED_V2 set in 
+			the kernel configuration.
+
 	sysrq_always_enabled
 			[KNL]
 			Ignore sysrq setting - this boot parameter will
diff --git a/block/genhd.c b/block/genhd.c
index 59a2db6..d0b9f83 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -18,13 +18,12 @@
 #include <linux/buffer_head.h>
 #include <linux/mutex.h>
 #include <linux/idr.h>
+#include <linux/device.h>
 
 #include "blk.h"
 
 static DEFINE_MUTEX(block_class_lock);
-#ifndef CONFIG_SYSFS_DEPRECATED
 struct kobject *block_depr;
-#endif
 
 /* for extended dynamic devt allocation, currently only one major is used */
 #define MAX_EXT_DEVT		(1 << MINORBITS)
@@ -803,10 +802,9 @@ static int __init genhd_device_init(void)
 
 	register_blkdev(BLOCK_EXT_MAJOR, "blkext");
 
-#ifndef CONFIG_SYSFS_DEPRECATED
 	/* create top-level block dir */
-	block_depr = kobject_create_and_add("block", NULL);
-#endif
+	if (!sysfs_deprecated)
+		block_depr = kobject_create_and_add("block", NULL);
 	return 0;
 }
 
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index eb1b7fa..36a535f 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/string.h>
+#include <linux/device.h>
 #include "base.h"
 #include "power/power.h"
 
@@ -440,21 +441,20 @@ static void device_remove_attrs(struct bus_type *bus, struct device *dev)
 	}
 }
 
-#ifdef CONFIG_SYSFS_DEPRECATED
 static int make_deprecated_bus_links(struct device *dev)
 {
+	if (!sysfs_deprecated)
+		return 0;
+
 	return sysfs_create_link(&dev->kobj,
 				 &dev->bus->p->subsys.kobj, "bus");
 }
 
 static void remove_deprecated_bus_links(struct device *dev)
 {
-	sysfs_remove_link(&dev->kobj, "bus");
+	if (sysfs_deprecated)
+		sysfs_remove_link(&dev->kobj, "bus");
 }
-#else
-static inline int make_deprecated_bus_links(struct device *dev) { return 0; }
-static inline void remove_deprecated_bus_links(struct device *dev) { }
-#endif
 
 /**
  * bus_add_device - add device to bus
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 8e231d0..0433d27 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -184,9 +184,9 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 	if (!cls->dev_kobj)
 		cls->dev_kobj = sysfs_dev_char_kobj;
 
-#if defined(CONFIG_SYSFS_DEPRECATED) && defined(CONFIG_BLOCK)
+#if defined(CONFIG_BLOCK)
 	/* let the block class directory show up in the root of sysfs */
-	if (cls != &block_class)
+	if (sysfs_deprecated && cls != &block_class)
 		cp->class_subsys.kobj.kset = class_kset;
 #else
 	cp->class_subsys.kobj.kset = class_kset;
@@ -276,7 +276,7 @@ void class_destroy(struct class *cls)
 	class_unregister(cls);
 }
 
-#ifdef CONFIG_SYSFS_DEPRECATED
+#ifdef CONFIG_SYSFS_DEPRECATED_SWITCH
 char *make_class_name(const char *name, struct kobject *kobj)
 {
 	char *class_name;
diff --git a/drivers/base/core.c b/drivers/base/core.c
index d1b2c9a..c8bf261 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -26,6 +26,21 @@
 #include "base.h"
 #include "power/power.h"
 
+#ifdef CONFIG_SYSFS_DEPRECATED_SWITCH
+#ifdef CONFIG_SYSFS_DEPRECATED_V2
+long sysfs_deprecated = 1;
+#else
+long sysfs_deprecated = 0;
+#endif
+
+static __init int setup_sysfs_deprecated(char *arg)
+{
+	return strict_strtol(arg, 10, &sysfs_deprecated);
+}
+
+early_param("sysfs.deprecated", setup_sysfs_deprecated);
+#endif
+
 int (*platform_notify)(struct device *dev) = NULL;
 int (*platform_notify_remove)(struct device *dev) = NULL;
 static struct kobject *dev_kobj;
@@ -203,8 +218,7 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 	if (dev->driver)
 		add_uevent_var(env, "DRIVER=%s", dev->driver->name);
 
-#ifdef CONFIG_SYSFS_DEPRECATED
-	if (dev->class) {
+	if (sysfs_deprecated && dev->class) {
 		struct device *parent = dev->parent;
 
 		/* find first bus device in parent chain */
@@ -232,7 +246,6 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 			add_uevent_var(env, "PHYSDEVDRIVER=%s",
 				       dev->driver->name);
 	}
-#endif
 
 	/* have the bus specific function add its stuff */
 	if (dev->bus && dev->bus->uevent) {
@@ -578,8 +591,7 @@ void device_initialize(struct device *dev)
 	set_dev_node(dev, -1);
 }
 
-#ifdef CONFIG_SYSFS_DEPRECATED
-static struct kobject *get_device_parent(struct device *dev,
+static struct kobject *deprecated_get_device_parent(struct device *dev,
 					 struct device *parent)
 {
 	/* class devices without a parent live in /sys/class/<classname>/ */
@@ -592,10 +604,6 @@ static struct kobject *get_device_parent(struct device *dev,
 	return NULL;
 }
 
-static inline void cleanup_device_parent(struct device *dev) {}
-static inline void cleanup_glue_dir(struct device *dev,
-				    struct kobject *glue_dir) {}
-#else
 static struct kobject *virtual_device_parent(struct device *dev)
 {
 	static struct kobject *virtual_dir = NULL;
@@ -660,6 +668,9 @@ class_dir_create_and_add(struct class *class, struct kobject *parent_kobj)
 static struct kobject *get_device_parent(struct device *dev,
 					 struct device *parent)
 {
+	if (sysfs_deprecated)
+		return deprecated_get_device_parent(dev, parent);
+
 	if (dev->class) {
 		static DEFINE_MUTEX(gdp_mutex);
 		struct kobject *kobj = NULL;
@@ -707,6 +718,9 @@ static struct kobject *get_device_parent(struct device *dev,
 
 static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
 {
+	if (sysfs_deprecated)
+		return;
+
 	/* see if we live in a "glue" directory */
 	if (!glue_dir || !dev->class ||
 	    glue_dir->kset != &dev->class->p->class_dirs)
@@ -717,9 +731,9 @@ static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
 
 static void cleanup_device_parent(struct device *dev)
 {
-	cleanup_glue_dir(dev, dev->kobj.parent);
+	if (!sysfs_deprecated)
+		cleanup_glue_dir(dev, dev->kobj.parent);
 }
-#endif
 
 static void setup_parent(struct device *dev, struct device *parent)
 {
@@ -729,27 +743,17 @@ static void setup_parent(struct device *dev, struct device *parent)
 		dev->kobj.parent = kobj;
 }
 
-static int device_add_class_symlinks(struct device *dev)
+static int deprecated_device_add_class_symlinks(struct device *dev)
 {
 	int error;
 
-	if (!dev->class)
-		return 0;
-
-	error = sysfs_create_link(&dev->kobj,
-				  &dev->class->p->class_subsys.kobj,
-				  "subsystem");
-	if (error)
-		goto out;
-
-#ifdef CONFIG_SYSFS_DEPRECATED
 	/* stacked class devices need a symlink in the class directory */
 	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
 	    device_is_not_partition(dev)) {
 		error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
 					  &dev->kobj, dev_name(dev));
 		if (error)
-			goto out_subsys;
+			return error;
 	}
 
 	if (dev->parent && device_is_not_partition(dev)) {
@@ -788,37 +792,52 @@ out_busid:
 	    device_is_not_partition(dev))
 		sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj,
 				  dev_name(dev));
-#else
-	/* link in the class directory pointing to the device */
-	error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
-				  &dev->kobj, dev_name(dev));
+	return error;
+}
+
+static int device_add_class_symlinks(struct device *dev)
+{
+	int error;
+
+	if (!dev->class)
+		return 0;
+
+	error = sysfs_create_link(&dev->kobj,
+				  &dev->class->p->class_subsys.kobj,
+				  "subsystem");
 	if (error)
-		goto out_subsys;
+		goto out;
 
-	if (dev->parent && device_is_not_partition(dev)) {
-		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-					  "device");
+	if (sysfs_deprecated) { 
+		error = deprecated_device_add_class_symlinks(dev);
+		if (error) 
+			goto out_subsys;
+	} else {
+		/* link in the class directory pointing to the device */
+		error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
+					  &dev->kobj, dev_name(dev));
 		if (error)
-			goto out_busid;
+			goto out_subsys;
+
+		if (dev->parent && device_is_not_partition(dev)) {
+			error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
+						  "device");
+			if (error)
+				goto out_busid;
+		}
 	}
 	return 0;
 
 out_busid:
 	sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
-#endif
-
 out_subsys:
 	sysfs_remove_link(&dev->kobj, "subsystem");
 out:
 	return error;
 }
 
-static void device_remove_class_symlinks(struct device *dev)
+static void deprecated_device_remove_class_symlinks(struct device *dev)
 {
-	if (!dev->class)
-		return;
-
-#ifdef CONFIG_SYSFS_DEPRECATED
 	if (dev->parent && device_is_not_partition(dev)) {
 		char *class_name;
 
@@ -834,12 +853,21 @@ static void device_remove_class_symlinks(struct device *dev)
 	    device_is_not_partition(dev))
 		sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj,
 				  dev_name(dev));
-#else
-	if (dev->parent && device_is_not_partition(dev))
-		sysfs_remove_link(&dev->kobj, "device");
+}
 
-	sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
-#endif
+static void device_remove_class_symlinks(struct device *dev)
+{
+	if (!dev->class)
+		return;
+
+	if (sysfs_deprecated) {
+		deprecated_device_remove_class_symlinks(dev);
+	} else {
+		if (dev->parent && device_is_not_partition(dev))
+			sysfs_remove_link(&dev->kobj, "device");
+
+		sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
+	}
 
 	sysfs_remove_link(&dev->kobj, "subsystem");
 }
@@ -1613,10 +1641,8 @@ int device_rename(struct device *dev, const char *new_name)
 	pr_debug("device: '%s': %s: renaming to '%s'\n", dev_name(dev),
 		 __func__, new_name);
 
-#ifdef CONFIG_SYSFS_DEPRECATED
-	if ((dev->class) && (dev->parent))
+	if (sysfs_deprecated && (dev->class) && (dev->parent))
 		old_class_name = make_class_name(dev->class->name, &dev->kobj);
-#endif
 
 	old_device_name = kstrdup(dev_name(dev), GFP_KERNEL);
 	if (!old_device_name) {
@@ -1624,20 +1650,17 @@ int device_rename(struct device *dev, const char *new_name)
 		goto out;
 	}
 
-#ifndef CONFIG_SYSFS_DEPRECATED
-	if (dev->class) {
+	if (sysfs_deprecated && dev->class) {
 		error = sysfs_rename_link(&dev->class->p->class_subsys.kobj,
 			&dev->kobj, old_device_name, new_name);
 		if (error)
 			goto out;
 	}
-#endif
 	error = kobject_rename(&dev->kobj, new_name);
 	if (error)
 		goto out;
 
-#ifdef CONFIG_SYSFS_DEPRECATED
-	if (old_class_name) {
+	if (sysfs_deprecated && old_class_name) {
 		new_class_name = make_class_name(dev->class->name, &dev->kobj);
 		if (new_class_name) {
 			error = sysfs_rename_link(&dev->parent->kobj,
@@ -1646,7 +1669,6 @@ int device_rename(struct device *dev, const char *new_name)
 						  new_class_name);
 		}
 	}
-#endif
 
 out:
 	put_device(dev);
@@ -1659,13 +1681,12 @@ out:
 }
 EXPORT_SYMBOL_GPL(device_rename);
 
-static int device_move_class_links(struct device *dev,
-				   struct device *old_parent,
-				   struct device *new_parent)
+static int deprecated_device_move_class_links(struct device *dev,
+					      struct device *old_parent,
+					      struct device *new_parent)
 {
-	int error = 0;
-#ifdef CONFIG_SYSFS_DEPRECATED
 	char *class_name;
+	int error = 0;
 
 	class_name = make_class_name(dev->class->name, &dev->kobj);
 	if (!class_name) {
@@ -1690,14 +1711,23 @@ static int device_move_class_links(struct device *dev,
 out:
 	kfree(class_name);
 	return error;
-#else
+}
+
+static int device_move_class_links(struct device *dev,
+				   struct device *old_parent,
+				   struct device *new_parent)
+{
+	int error = 0;
+
+	if (sysfs_deprecated)
+		return deprecated_device_move_class_links(dev, old_parent, 
+							  new_parent);
 	if (old_parent)
 		sysfs_remove_link(&dev->kobj, "device");
 	if (new_parent)
 		error = sysfs_create_link(&dev->kobj, &new_parent->kobj,
 					  "device");
 	return error;
-#endif
 }
 
 /**
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8a8f803..bf63d9e 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -411,9 +411,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
-#ifndef CONFIG_SYSFS_DEPRECATED
-	shost->shost_gendev.bus = &scsi_bus_type;
-#endif
+	if (!sysfs_deprecated)
+		shost->shost_gendev.bus = &scsi_bus_type;
 	shost->shost_gendev.type = &scsi_host_type;
 
 	device_initialize(&shost->shost_dev);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3d0a1e6..c0856d9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -417,9 +417,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->reap_ref = 1;
 	dev->parent = get_device(parent);
 	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
-#ifndef CONFIG_SYSFS_DEPRECATED
-	dev->bus = &scsi_bus_type;
-#endif
+	if (!sysfs_deprecated)
+		dev->bus = &scsi_bus_type;
 	dev->type = &scsi_target_type;
 	starget->id = id;
 	starget->channel = channel;
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 79fbf3f..137bf97 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -513,14 +513,14 @@ void register_disk(struct gendisk *disk)
 
 	if (device_add(ddev))
 		return;
-#ifndef CONFIG_SYSFS_DEPRECATED
-	err = sysfs_create_link(block_depr, &ddev->kobj,
-				kobject_name(&ddev->kobj));
-	if (err) {
-		device_del(ddev);
-		return;
+	if (!sysfs_deprecated) {
+		err = sysfs_create_link(block_depr, &ddev->kobj,
+					kobject_name(&ddev->kobj));
+		if (err) {
+			device_del(ddev);
+			return;
+		}
 	}
-#endif
 	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
 	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
 
@@ -737,8 +737,7 @@ void del_gendisk(struct gendisk *disk)
 	kobject_put(disk->part0.holder_dir);
 	kobject_put(disk->slave_dir);
 	disk->driverfs_dev = NULL;
-#ifndef CONFIG_SYSFS_DEPRECATED
-	sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
-#endif
+	if (!sysfs_deprecated)
+		sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
 	device_del(disk_to_dev(disk));
 }
diff --git a/include/linux/device.h b/include/linux/device.h
index 516feca..fb30f45 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -751,4 +751,11 @@ do {						     \
 	MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
 #define MODULE_ALIAS_CHARDEV_MAJOR(major) \
 	MODULE_ALIAS("char-major-" __stringify(major) "-*")
+
+#ifndef CONFIG_SYSFS_DEPRECATED_SWITCH
+#define sysfs_deprecated 0
+#else
+extern long sysfs_deprecated;
+#endif
+
 #endif /* _DEVICE_H_ */
diff --git a/include/sound/core.h b/include/sound/core.h
index 89e0ac1..181b1be 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -29,6 +29,7 @@
 #include <linux/pm.h>			/* pm_message_t */
 #include <linux/device.h>
 #include <linux/stringify.h>
+#include <linux/device.h>
 
 /* number of supported soundcards */
 #ifdef CONFIG_SND_DYNAMIC_MINORS
@@ -133,9 +134,7 @@ struct snd_card {
 	int free_on_last_close;		/* free in context of file_release */
 	wait_queue_head_t shutdown_sleep;
 	struct device *dev;		/* device assigned to this card */
-#ifndef CONFIG_SYSFS_DEPRECATED
 	struct device *card_dev;	/* cardX object for sysfs */
-#endif
 
 #ifdef CONFIG_PM
 	unsigned int power_state;	/* power state */
@@ -196,11 +195,8 @@ struct snd_minor {
 /* return a device pointer linked to each sound device as a parent */
 static inline struct device *snd_card_get_device_link(struct snd_card *card)
 {
-#ifdef CONFIG_SYSFS_DEPRECATED
-	return card ? card->dev : NULL;
-#else
-	return card ? card->card_dev : NULL;
-#endif
+	struct device *dev = sysfs_deprecated ? card->dev : card->card_dev;
+	return card ? dev : NULL;
 }
 
 /* sound.c */
diff --git a/init/Kconfig b/init/Kconfig
index 2de5b1c..ae69ed0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -655,17 +655,19 @@ endif # CGROUPS
 config MM_OWNER
 	bool
 
-config SYSFS_DEPRECATED
-	bool
-
-config SYSFS_DEPRECATED_V2
-	bool "enable deprecated sysfs features to support old userspace tools"
+config SYSFS_DEPRECATED_SWITCH
+	bool "allow enabling deprecated sysfs layout at boot time"
 	depends on SYSFS
 	default n
-	select SYSFS_DEPRECATED
 	help
-	  This option switches the layout of sysfs to the deprecated
-	  version. Do not use it on recent distributions.
+	  Support runtime switching of the deprecated and modern
+	  sysfs layout. Generally the modern layout is needed for newer
+	  distributions and deprecated for very old distributions with
+	  old udev.
+
+	  The default is modern layout unless CONFIG_SYSFS_DEPRECATED_V2
+	  is set. The old layout can be forced by setting 
+	  sysfs.deprecated=1 on the kernel command line.
 
 	  The current sysfs layout features a unified device tree at
 	  /sys/devices/, which is able to express a hierarchy between
@@ -678,6 +680,16 @@ config SYSFS_DEPRECATED_V2
 	  subsystems will suppress the creation of some devices which
 	  depend on the unified device tree.
 
+# use select, not depend, on DEPRECATED_SWITCH to not break old configs
+config SYSFS_DEPRECATED_V2
+	bool "enable deprecated sysfs features to support old userspace tools"
+	depends on SYSFS
+	default n
+	select SYSFS_DEPRECATED_SWITCH
+	help
+	  This option switches the layout of sysfs to the deprecated
+	  version. Do not use it on recent distributions.
+
 	  This option is not a pure compatibility option that can
 	  be safely enabled on newer distributions. It will change the
 	  layout of sysfs to the non-extensible deprecated version,
@@ -690,7 +702,7 @@ config SYSFS_DEPRECATED_V2
 	  older userspace tools, you might need to say Y here. Do not say Y,
 	  if the original kernel, that came with your distribution, has
 	  this option set to N.
-
+	  
 config RELAY
 	bool "Kernel->user space relay support (formerly relayfs)"
 	help
diff --git a/sound/core/init.c b/sound/core/init.c
index ec4a50c..1ad1583 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -395,12 +395,10 @@ int snd_card_disconnect(struct snd_card *card)
 		snd_printk(KERN_ERR "not all devices for card %i can be disconnected\n", card->number);
 
 	snd_info_card_disconnect(card);
-#ifndef CONFIG_SYSFS_DEPRECATED
-	if (card->card_dev) {
+	if (!sysfs_deprecated && card->card_dev) {
 		device_unregister(card->card_dev);
 		card->card_dev = NULL;
 	}
-#endif
 #ifdef CONFIG_PM
 	wake_up(&card->power_sleep);
 #endif
@@ -573,7 +571,6 @@ void snd_card_set_id(struct snd_card *card, const char *nid)
 }
 EXPORT_SYMBOL(snd_card_set_id);
 
-#ifndef CONFIG_SYSFS_DEPRECATED
 static ssize_t
 card_id_show_attr(struct device *dev,
 		  struct device_attribute *attr, char *buf)
@@ -630,7 +627,6 @@ card_number_show_attr(struct device *dev,
 
 static struct device_attribute card_number_attrs =
 	__ATTR(number, S_IRUGO, card_number_show_attr, NULL);
-#endif /* CONFIG_SYSFS_DEPRECATED */
 
 /**
  *  snd_card_register - register the soundcard
@@ -649,15 +645,13 @@ int snd_card_register(struct snd_card *card)
 
 	if (snd_BUG_ON(!card))
 		return -EINVAL;
-#ifndef CONFIG_SYSFS_DEPRECATED
-	if (!card->card_dev) {
+	if (!sysfs_deprecated && !card->card_dev) {
 		card->card_dev = device_create(sound_class, card->dev,
 					       MKDEV(0, 0), card,
 					       "card%i", card->number);
 		if (IS_ERR(card->card_dev))
 			card->card_dev = NULL;
 	}
-#endif
 	if ((err = snd_device_register_all(card)) < 0)
 		return err;
 	mutex_lock(&snd_card_mutex);
@@ -674,8 +668,7 @@ int snd_card_register(struct snd_card *card)
 	if (snd_mixer_oss_notify_callback)
 		snd_mixer_oss_notify_callback(card, SND_MIXER_OSS_NOTIFY_REGISTER);
 #endif
-#ifndef CONFIG_SYSFS_DEPRECATED
-	if (card->card_dev) {
+	if (!sysfs_deprecated && card->card_dev) {
 		err = device_create_file(card->card_dev, &card_id_attrs);
 		if (err < 0)
 			return err;
@@ -683,7 +676,6 @@ int snd_card_register(struct snd_card *card)
 		if (err < 0)
 			return err;
 	}
-#endif
 	return 0;
 }
 
-- 
1.7.1

