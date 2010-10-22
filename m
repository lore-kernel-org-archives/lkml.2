Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0JVSaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:30:18 -0400
Received: from kroah.org ([198.145.64.141]:37793 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758863Ab0JVSZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <axboe@kernel.dk>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/31] driver core: remove CONFIG_SYSFS_DEPRECATED_V2 but keep it for block devices
Date: Fri, 22 Oct 2010 11:24:57 -0700
Message-Id: <1287771916-15016-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This patch removes the old CONFIG_SYSFS_DEPRECATED_V2 config option,
but it keeps the logic around to handle block devices in the old manner
as some people like to run new kernel versions on old (pre 2007/2008)
distros.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c       |   22 -----
 drivers/base/class.c     |   19 -----
 drivers/base/core.c      |  194 ++++++----------------------------------------
 drivers/scsi/hosts.c     |    2 -
 drivers/scsi/scsi_scan.c |    2 -
 include/sound/core.h     |    6 --
 init/Kconfig             |   46 ++++-------
 sound/core/init.c        |   11 +--
 8 files changed, 43 insertions(+), 259 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index eb1b7fa..33c270a 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -440,22 +440,6 @@ static void device_remove_attrs(struct bus_type *bus, struct device *dev)
 	}
 }
 
-#ifdef CONFIG_SYSFS_DEPRECATED
-static int make_deprecated_bus_links(struct device *dev)
-{
-	return sysfs_create_link(&dev->kobj,
-				 &dev->bus->p->subsys.kobj, "bus");
-}
-
-static void remove_deprecated_bus_links(struct device *dev)
-{
-	sysfs_remove_link(&dev->kobj, "bus");
-}
-#else
-static inline int make_deprecated_bus_links(struct device *dev) { return 0; }
-static inline void remove_deprecated_bus_links(struct device *dev) { }
-#endif
-
 /**
  * bus_add_device - add device to bus
  * @dev: device being added
@@ -482,15 +466,10 @@ int bus_add_device(struct device *dev)
 				&dev->bus->p->subsys.kobj, "subsystem");
 		if (error)
 			goto out_subsys;
-		error = make_deprecated_bus_links(dev);
-		if (error)
-			goto out_deprecated;
 		klist_add_tail(&dev->p->knode_bus, &bus->p->klist_devices);
 	}
 	return 0;
 
-out_deprecated:
-	sysfs_remove_link(&dev->kobj, "subsystem");
 out_subsys:
 	sysfs_remove_link(&bus->p->devices_kset->kobj, dev_name(dev));
 out_id:
@@ -530,7 +509,6 @@ void bus_remove_device(struct device *dev)
 {
 	if (dev->bus) {
 		sysfs_remove_link(&dev->kobj, "subsystem");
-		remove_deprecated_bus_links(dev);
 		sysfs_remove_link(&dev->bus->p->devices_kset->kobj,
 				  dev_name(dev));
 		device_remove_attrs(dev->bus, dev);
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 8e231d0..1078969 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -276,25 +276,6 @@ void class_destroy(struct class *cls)
 	class_unregister(cls);
 }
 
-#ifdef CONFIG_SYSFS_DEPRECATED
-char *make_class_name(const char *name, struct kobject *kobj)
-{
-	char *class_name;
-	int size;
-
-	size = strlen(name) + strlen(kobject_name(kobj)) + 2;
-
-	class_name = kmalloc(size, GFP_KERNEL);
-	if (!class_name)
-		return NULL;
-
-	strcpy(class_name, name);
-	strcat(class_name, ":");
-	strcat(class_name, kobject_name(kobj));
-	return class_name;
-}
-#endif
-
 /**
  * class_dev_iter_init - initialize class device iterator
  * @iter: class iterator to initialize
diff --git a/drivers/base/core.c b/drivers/base/core.c
index d1b2c9a..6cf9069 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -203,37 +203,6 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 	if (dev->driver)
 		add_uevent_var(env, "DRIVER=%s", dev->driver->name);
 
-#ifdef CONFIG_SYSFS_DEPRECATED
-	if (dev->class) {
-		struct device *parent = dev->parent;
-
-		/* find first bus device in parent chain */
-		while (parent && !parent->bus)
-			parent = parent->parent;
-		if (parent && parent->bus) {
-			const char *path;
-
-			path = kobject_get_path(&parent->kobj, GFP_KERNEL);
-			if (path) {
-				add_uevent_var(env, "PHYSDEVPATH=%s", path);
-				kfree(path);
-			}
-
-			add_uevent_var(env, "PHYSDEVBUS=%s", parent->bus->name);
-
-			if (parent->driver)
-				add_uevent_var(env, "PHYSDEVDRIVER=%s",
-					       parent->driver->name);
-		}
-	} else if (dev->bus) {
-		add_uevent_var(env, "PHYSDEVBUS=%s", dev->bus->name);
-
-		if (dev->driver)
-			add_uevent_var(env, "PHYSDEVDRIVER=%s",
-				       dev->driver->name);
-	}
-#endif
-
 	/* have the bus specific function add its stuff */
 	if (dev->bus && dev->bus->uevent) {
 		retval = dev->bus->uevent(dev, env);
@@ -578,24 +547,6 @@ void device_initialize(struct device *dev)
 	set_dev_node(dev, -1);
 }
 
-#ifdef CONFIG_SYSFS_DEPRECATED
-static struct kobject *get_device_parent(struct device *dev,
-					 struct device *parent)
-{
-	/* class devices without a parent live in /sys/class/<classname>/ */
-	if (dev->class && (!parent || parent->class != dev->class))
-		return &dev->class->p->class_subsys.kobj;
-	/* all other devices keep their parent */
-	else if (parent)
-		return &parent->kobj;
-
-	return NULL;
-}
-
-static inline void cleanup_device_parent(struct device *dev) {}
-static inline void cleanup_glue_dir(struct device *dev,
-				    struct kobject *glue_dir) {}
-#else
 static struct kobject *virtual_device_parent(struct device *dev)
 {
 	static struct kobject *virtual_dir = NULL;
@@ -666,6 +617,14 @@ static struct kobject *get_device_parent(struct device *dev,
 		struct kobject *parent_kobj;
 		struct kobject *k;
 
+#ifdef CONFIG_SYSFS_DEPRECATED
+		/* block disks show up in /sys/block */
+		if (dev->class == &block_class) {
+			if (parent && parent->class == &block_class)
+				return &parent->kobj;
+			return &block_class.p->class_subsys.kobj;
+		}
+#endif
 		/*
 		 * If we have no parent, we live in "virtual".
 		 * Class-devices with a non class-device as parent, live
@@ -719,7 +678,6 @@ static void cleanup_device_parent(struct device *dev)
 {
 	cleanup_glue_dir(dev, dev->kobj.parent);
 }
-#endif
 
 static void setup_parent(struct device *dev, struct device *parent)
 {
@@ -742,70 +700,29 @@ static int device_add_class_symlinks(struct device *dev)
 	if (error)
 		goto out;
 
-#ifdef CONFIG_SYSFS_DEPRECATED
-	/* stacked class devices need a symlink in the class directory */
-	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
-	    device_is_not_partition(dev)) {
-		error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
-					  &dev->kobj, dev_name(dev));
-		if (error)
-			goto out_subsys;
-	}
-
 	if (dev->parent && device_is_not_partition(dev)) {
-		struct device *parent = dev->parent;
-		char *class_name;
-
-		/*
-		 * stacked class devices have the 'device' link
-		 * pointing to the bus device instead of the parent
-		 */
-		while (parent->class && !parent->bus && parent->parent)
-			parent = parent->parent;
-
-		error = sysfs_create_link(&dev->kobj,
-					  &parent->kobj,
+		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
 					  "device");
 		if (error)
-			goto out_busid;
-
-		class_name = make_class_name(dev->class->name,
-						&dev->kobj);
-		if (class_name)
-			error = sysfs_create_link(&dev->parent->kobj,
-						&dev->kobj, class_name);
-		kfree(class_name);
-		if (error)
-			goto out_device;
+			goto out_subsys;
 	}
-	return 0;
 
-out_device:
-	if (dev->parent && device_is_not_partition(dev))
-		sysfs_remove_link(&dev->kobj, "device");
-out_busid:
-	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
-	    device_is_not_partition(dev))
-		sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj,
-				  dev_name(dev));
-#else
+#ifdef CONFIG_SYSFS_DEPRECATED
+	/* /sys/block has directories and does not need symlinks */
+	if (dev->class == &block_class)
+		return 0;
+#endif
+
 	/* link in the class directory pointing to the device */
 	error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
 				  &dev->kobj, dev_name(dev));
 	if (error)
-		goto out_subsys;
+		goto out_device;
 
-	if (dev->parent && device_is_not_partition(dev)) {
-		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-					  "device");
-		if (error)
-			goto out_busid;
-	}
 	return 0;
 
-out_busid:
-	sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
-#endif
+out_device:
+	sysfs_remove_link(&dev->kobj, "device");
 
 out_subsys:
 	sysfs_remove_link(&dev->kobj, "subsystem");
@@ -818,30 +735,14 @@ static void device_remove_class_symlinks(struct device *dev)
 	if (!dev->class)
 		return;
 
-#ifdef CONFIG_SYSFS_DEPRECATED
-	if (dev->parent && device_is_not_partition(dev)) {
-		char *class_name;
-
-		class_name = make_class_name(dev->class->name, &dev->kobj);
-		if (class_name) {
-			sysfs_remove_link(&dev->parent->kobj, class_name);
-			kfree(class_name);
-		}
-		sysfs_remove_link(&dev->kobj, "device");
-	}
-
-	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
-	    device_is_not_partition(dev))
-		sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj,
-				  dev_name(dev));
-#else
 	if (dev->parent && device_is_not_partition(dev))
 		sysfs_remove_link(&dev->kobj, "device");
-
-	sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
-#endif
-
 	sysfs_remove_link(&dev->kobj, "subsystem");
+#ifdef CONFIG_SYSFS_DEPRECATED
+	if (dev->class == &block_class)
+		return;
+#endif
+	sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
 }
 
 /**
@@ -1613,41 +1514,23 @@ int device_rename(struct device *dev, const char *new_name)
 	pr_debug("device: '%s': %s: renaming to '%s'\n", dev_name(dev),
 		 __func__, new_name);
 
-#ifdef CONFIG_SYSFS_DEPRECATED
-	if ((dev->class) && (dev->parent))
-		old_class_name = make_class_name(dev->class->name, &dev->kobj);
-#endif
-
 	old_device_name = kstrdup(dev_name(dev), GFP_KERNEL);
 	if (!old_device_name) {
 		error = -ENOMEM;
 		goto out;
 	}
 
-#ifndef CONFIG_SYSFS_DEPRECATED
 	if (dev->class) {
 		error = sysfs_rename_link(&dev->class->p->class_subsys.kobj,
 			&dev->kobj, old_device_name, new_name);
 		if (error)
 			goto out;
 	}
-#endif
+
 	error = kobject_rename(&dev->kobj, new_name);
 	if (error)
 		goto out;
 
-#ifdef CONFIG_SYSFS_DEPRECATED
-	if (old_class_name) {
-		new_class_name = make_class_name(dev->class->name, &dev->kobj);
-		if (new_class_name) {
-			error = sysfs_rename_link(&dev->parent->kobj,
-						  &dev->kobj,
-						  old_class_name,
-						  new_class_name);
-		}
-	}
-#endif
-
 out:
 	put_device(dev);
 
@@ -1664,40 +1547,13 @@ static int device_move_class_links(struct device *dev,
 				   struct device *new_parent)
 {
 	int error = 0;
-#ifdef CONFIG_SYSFS_DEPRECATED
-	char *class_name;
 
-	class_name = make_class_name(dev->class->name, &dev->kobj);
-	if (!class_name) {
-		error = -ENOMEM;
-		goto out;
-	}
-	if (old_parent) {
-		sysfs_remove_link(&dev->kobj, "device");
-		sysfs_remove_link(&old_parent->kobj, class_name);
-	}
-	if (new_parent) {
-		error = sysfs_create_link(&dev->kobj, &new_parent->kobj,
-					  "device");
-		if (error)
-			goto out;
-		error = sysfs_create_link(&new_parent->kobj, &dev->kobj,
-					  class_name);
-		if (error)
-			sysfs_remove_link(&dev->kobj, "device");
-	} else
-		error = 0;
-out:
-	kfree(class_name);
-	return error;
-#else
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
index 8a8f803..ba7f87a 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -411,9 +411,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
-#ifndef CONFIG_SYSFS_DEPRECATED
 	shost->shost_gendev.bus = &scsi_bus_type;
-#endif
 	shost->shost_gendev.type = &scsi_host_type;
 
 	device_initialize(&shost->shost_dev);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3d0a1e6..087821f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -417,9 +417,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->reap_ref = 1;
 	dev->parent = get_device(parent);
 	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
-#ifndef CONFIG_SYSFS_DEPRECATED
 	dev->bus = &scsi_bus_type;
-#endif
 	dev->type = &scsi_target_type;
 	starget->id = id;
 	starget->channel = channel;
diff --git a/include/sound/core.h b/include/sound/core.h
index 89e0ac1..df26ebb 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -133,9 +133,7 @@ struct snd_card {
 	int free_on_last_close;		/* free in context of file_release */
 	wait_queue_head_t shutdown_sleep;
 	struct device *dev;		/* device assigned to this card */
-#ifndef CONFIG_SYSFS_DEPRECATED
 	struct device *card_dev;	/* cardX object for sysfs */
-#endif
 
 #ifdef CONFIG_PM
 	unsigned int power_state;	/* power state */
@@ -196,11 +194,7 @@ struct snd_minor {
 /* return a device pointer linked to each sound device as a parent */
 static inline struct device *snd_card_get_device_link(struct snd_card *card)
 {
-#ifdef CONFIG_SYSFS_DEPRECATED
-	return card ? card->dev : NULL;
-#else
 	return card ? card->card_dev : NULL;
-#endif
 }
 
 /* sound.c */
diff --git a/init/Kconfig b/init/Kconfig
index 2de5b1c..137609f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -656,40 +656,24 @@ config MM_OWNER
 	bool
 
 config SYSFS_DEPRECATED
-	bool
-
-config SYSFS_DEPRECATED_V2
 	bool "enable deprecated sysfs features to support old userspace tools"
 	depends on SYSFS
 	default n
-	select SYSFS_DEPRECATED
-	help
-	  This option switches the layout of sysfs to the deprecated
-	  version. Do not use it on recent distributions.
-
-	  The current sysfs layout features a unified device tree at
-	  /sys/devices/, which is able to express a hierarchy between
-	  class devices. If the deprecated option is set to Y, the
-	  unified device tree is split into a bus device tree at
-	  /sys/devices/ and several individual class device trees at
-	  /sys/class/. The class and bus devices will be connected by
-	  "<subsystem>:<name>" and the "device" links. The "block"
-	  class devices, will not show up in /sys/class/block/. Some
-	  subsystems will suppress the creation of some devices which
-	  depend on the unified device tree.
-
-	  This option is not a pure compatibility option that can
-	  be safely enabled on newer distributions. It will change the
-	  layout of sysfs to the non-extensible deprecated version,
-	  and disable some features, which can not be exported without
-	  confusing older userspace tools. Since 2007/2008 all major
-	  distributions do not enable this option, and ship no tools which
-	  depend on the deprecated layout or this option.
-
-	  If you are using a new kernel on an older distribution, or use
-	  older userspace tools, you might need to say Y here. Do not say Y,
-	  if the original kernel, that came with your distribution, has
-	  this option set to N.
+	help
+	  This option switches the layout of the "block" class devices, to not
+	  show up in /sys/class/block/, but only in /sys/block/.
+
+	  This option allows new kernels to run on old distributions and tools,
+	  which might get confused by /sys/class/block/. Since 2007/2008 all
+	  major distributions and tools handle this just fine.
+
+	  Recent distributions and userspace tools after 2009/2010 depend on
+	  the existence of /sys/class/block/, and will not work with this
+	  option enabled.
+
+	  Only if you are using a new kernel on an old distribution, you might
+	  need to say Y here. Never say Y, if the original kernel, that came
+	  with your distribution, has not set this option.
 
 config RELAY
 	bool "Kernel->user space relay support (formerly relayfs)"
diff --git a/sound/core/init.c b/sound/core/init.c
index ec4a50c..f7c3df8 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -395,12 +395,10 @@ int snd_card_disconnect(struct snd_card *card)
 		snd_printk(KERN_ERR "not all devices for card %i can be disconnected\n", card->number);
 
 	snd_info_card_disconnect(card);
-#ifndef CONFIG_SYSFS_DEPRECATED
 	if (card->card_dev) {
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
@@ -649,7 +645,7 @@ int snd_card_register(struct snd_card *card)
 
 	if (snd_BUG_ON(!card))
 		return -EINVAL;
-#ifndef CONFIG_SYSFS_DEPRECATED
+
 	if (!card->card_dev) {
 		card->card_dev = device_create(sound_class, card->dev,
 					       MKDEV(0, 0), card,
@@ -657,7 +653,7 @@ int snd_card_register(struct snd_card *card)
 		if (IS_ERR(card->card_dev))
 			card->card_dev = NULL;
 	}
-#endif
+
 	if ((err = snd_device_register_all(card)) < 0)
 		return err;
 	mutex_lock(&snd_card_mutex);
@@ -674,7 +670,6 @@ int snd_card_register(struct snd_card *card)
 	if (snd_mixer_oss_notify_callback)
 		snd_mixer_oss_notify_callback(card, SND_MIXER_OSS_NOTIFY_REGISTER);
 #endif
-#ifndef CONFIG_SYSFS_DEPRECATED
 	if (card->card_dev) {
 		err = device_create_file(card->card_dev, &card_id_attrs);
 		if (err < 0)
@@ -683,7 +678,7 @@ int snd_card_register(struct snd_card *card)
 		if (err < 0)
 			return err;
 	}
-#endif
+
 	return 0;
 }
 
-- 
1.7.2

