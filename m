Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0IHN6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:58:46 -0400
Received: from kroah.org ([198.145.64.141]:35094 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab0IHN6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:58:43 -0400
Date: Wed, 8 Sep 2010 06:55:30 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>, Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        axboe@kernel.dk, tiwai@suse.de, James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH] SYSFS: Allow boot time switching between deprecated
	and modern sysfs layout
Message-ID: <20100908135530.GA2978@kroah.com>
References: <1283951991-16202-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <1283951991-16202-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 08, 2010 at 03:19:51PM +0200, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> I have some systems which need legacy sysfs due to old udev versions,
> and it's a big hazzle to compile separate kernels for them.
> 
> This patch turns CONFIG_SYSFS_DEPRECATED into a run time option
> that can be switched on/off the kernel command line. This way
> the same binary can be used in both cases with just a option
> on the command line.

Nice idea.  It will make testing easier for lots of people.

But, Kay and I just changed the logic in the kernel in this area,
getting rid of the CONFIG_SYSFS_DEPRECATED_V2 option entirely, to try to
make the code path smaller, only offering the "old" mode for block
devices, to keep kernels booting on userspace instances like what you
have.

So, could you respin this patch against the linux-next tree which has
Kay's patch in it?  Or, if it's easier, I've attached the patch below.

thanks,

greg k-h

--VS++wcV0S1rZb1Fb
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="driver-core-remove-config_sysfs_deprecated_v2-but-keep-it-for-block-devices.patch"

>From foo@baz Sat Sep  4 22:33:14 PDT 2010
Date: Sat, 04 Sep 2010 22:33:14 -0700
To: Greg KH <greg@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Subject: driver core: remove CONFIG_SYSFS_DEPRECATED_V2 but keep it for block devices

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
 drivers/base/class.c     |   19 ----
 drivers/base/core.c      |  194 ++++++-----------------------------------------
 drivers/scsi/hosts.c     |    2 
 drivers/scsi/scsi_scan.c |    2 
 include/sound/core.h     |    6 -
 init/Kconfig             |   42 +++-------
 sound/core/init.c        |   11 --
 8 files changed, 41 insertions(+), 257 deletions(-)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -440,22 +440,6 @@ static void device_remove_attrs(struct b
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
@@ -530,7 +509,6 @@ void bus_remove_device(struct device *de
 {
 	if (dev->bus) {
 		sysfs_remove_link(&dev->kobj, "subsystem");
-		remove_deprecated_bus_links(dev);
 		sysfs_remove_link(&dev->bus->p->devices_kset->kobj,
 				  dev_name(dev));
 		device_remove_attrs(dev->bus, dev);
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
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -203,37 +203,6 @@ static int dev_uevent(struct kset *kset,
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
@@ -578,24 +547,6 @@ void device_initialize(struct device *de
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
@@ -666,6 +617,14 @@ static struct kobject *get_device_parent
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
@@ -719,7 +678,6 @@ static void cleanup_device_parent(struct
 {
 	cleanup_glue_dir(dev, dev->kobj.parent);
 }
-#endif
 
 static void setup_parent(struct device *dev, struct device *parent)
 {
@@ -742,70 +700,29 @@ static int device_add_class_symlinks(str
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
@@ -818,30 +735,14 @@ static void device_remove_class_symlinks
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
@@ -1613,41 +1514,23 @@ int device_rename(struct device *dev, co
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
 
@@ -1664,40 +1547,13 @@ static int device_move_class_links(struc
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
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -411,9 +411,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
-#ifndef CONFIG_SYSFS_DEPRECATED
 	shost->shost_gendev.bus = &scsi_bus_type;
-#endif
 	shost->shost_gendev.type = &scsi_host_type;
 
 	device_initialize(&shost->shost_dev);
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -417,9 +417,7 @@ static struct scsi_target *scsi_alloc_ta
 	starget->reap_ref = 1;
 	dev->parent = get_device(parent);
 	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
-#ifndef CONFIG_SYSFS_DEPRECATED
 	dev->bus = &scsi_bus_type;
-#endif
 	dev->type = &scsi_target_type;
 	starget->id = id;
 	starget->channel = channel;
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
 	help
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
+	  This option switches the layout of the "block" class devices, to not
+	  show up in /sys/class/block/, but only in /sys/block/.
 
-	  If you are using a new kernel on an older distribution, or use
-	  older userspace tools, you might need to say Y here. Do not say Y,
-	  if the original kernel, that came with your distribution, has
-	  this option set to N.
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
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -395,12 +395,10 @@ int snd_card_disconnect(struct snd_card
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
@@ -573,7 +571,6 @@ void snd_card_set_id(struct snd_card *ca
 }
 EXPORT_SYMBOL(snd_card_set_id);
 
-#ifndef CONFIG_SYSFS_DEPRECATED
 static ssize_t
 card_id_show_attr(struct device *dev,
 		  struct device_attribute *attr, char *buf)
@@ -630,7 +627,6 @@ card_number_show_attr(struct device *dev
 
 static struct device_attribute card_number_attrs =
 	__ATTR(number, S_IRUGO, card_number_show_attr, NULL);
-#endif /* CONFIG_SYSFS_DEPRECATED */
 
 /**
  *  snd_card_register - register the soundcard
@@ -649,7 +645,7 @@ int snd_card_register(struct snd_card *c
 
 	if (snd_BUG_ON(!card))
 		return -EINVAL;
-#ifndef CONFIG_SYSFS_DEPRECATED
+
 	if (!card->card_dev) {
 		card->card_dev = device_create(sound_class, card->dev,
 					       MKDEV(0, 0), card,
@@ -657,7 +653,7 @@ int snd_card_register(struct snd_card *c
 		if (IS_ERR(card->card_dev))
 			card->card_dev = NULL;
 	}
-#endif
+
 	if ((err = snd_device_register_all(card)) < 0)
 		return err;
 	mutex_lock(&snd_card_mutex);
@@ -674,7 +670,6 @@ int snd_card_register(struct snd_card *c
 	if (snd_mixer_oss_notify_callback)
 		snd_mixer_oss_notify_callback(card, SND_MIXER_OSS_NOTIFY_REGISTER);
 #endif
-#ifndef CONFIG_SYSFS_DEPRECATED
 	if (card->card_dev) {
 		err = device_create_file(card->card_dev, &card_id_attrs);
 		if (err < 0)
@@ -683,7 +678,7 @@ int snd_card_register(struct snd_card *c
 		if (err < 0)
 			return err;
 	}
-#endif
+
 	return 0;
 }
 

--VS++wcV0S1rZb1Fb--
