Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab2EHSxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:53:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44760 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753252Ab2EHSxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:53:12 -0400
Date: Tue, 8 May 2012 14:53:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
In-Reply-To: <20120507215518.GN19417@google.com>
Message-ID: <Pine.LNX.4.44L0.1205081448590.1164-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2012, Tejun Heo wrote:

> On Mon, May 07, 2012 at 05:51:52PM -0400, Alan Stern wrote:
> > I guess in the end it's a question of balance.  Which has more 
> > overhead, adding a few function calls here and there, or adding a new 
> > flags field to every struct attribute?
> 
> Yes, and there are different types of overheads.  I'm happy to trade
> some runtime memory overhead under debugging mode for lower code
> complexity.  Lock proving is pretty expensive anyway.  I don't think
> there's much point in trying to optimize some bytes from struct
> attributes.

Okay, then what do you think about this approach?  It does seem smaller 
and simpler than the previous attempt.

And I did try to avoid unnecessary bloat; if lockdep isn't being used
then the extra attribute flag isn't present.

Alan Stern




Index: usb-3.4/include/linux/sysfs.h
===================================================================
--- usb-3.4.orig/include/linux/sysfs.h
+++ usb-3.4/include/linux/sysfs.h
@@ -27,6 +27,7 @@ struct attribute {
 	const char		*name;
 	umode_t			mode;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
+	bool			ignore_lockdep:1;
 	struct lock_class_key	*key;
 	struct lock_class_key	skey;
 #endif
@@ -80,6 +81,17 @@ struct attribute_group {
 
 #define __ATTR_NULL { .attr = { .name = NULL } }
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#define __ATTR_IGNORE_LOCKDEP(_name,_mode,_show,_store) { \
+	.attr = {.name = __stringify(_name), .mode = _mode,	\
+			.ignore_lockdep = true },		\
+	.show		= _show,				\
+	.store		= _store,				\
+}
+#else
+#define __ATTR_IGNORE_LOCKDEP	__ATTR
+#endif
+
 #define attr_name(_attr) (_attr).attr.name
 
 struct file;
Index: usb-3.4/fs/sysfs/dir.c
===================================================================
--- usb-3.4.orig/fs/sysfs/dir.c
+++ usb-3.4/fs/sysfs/dir.c
@@ -132,6 +132,24 @@ static void sysfs_unlink_sibling(struct
 	rb_erase(&sd->s_rb, &sd->s_parent->s_dir.children);
 }
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+/* Test for attributes that want to ignore lockdep for read-locking */
+static bool ignore_lockdep(struct sysfs_dirent *sd)
+{
+	return sysfs_type(sd) == SYSFS_KOBJ_ATTR &&
+			sd->s_attr.attr->ignore_lockdep;
+}
+
+#else
+
+static inline bool ignore_lockdep(struct sysfs_dirent *sd)
+{
+	return true;
+}
+
+#endif
+
 /**
  *	sysfs_get_active - get an active reference to sysfs_dirent
  *	@sd: sysfs_dirent to get an active reference to
@@ -155,15 +173,17 @@ struct sysfs_dirent *sysfs_get_active(st
 			return NULL;
 
 		t = atomic_cmpxchg(&sd->s_active, v, v + 1);
-		if (likely(t == v)) {
-			rwsem_acquire_read(&sd->dep_map, 0, 1, _RET_IP_);
-			return sd;
-		}
+		if (likely(t == v))
+			break;
 		if (t < 0)
 			return NULL;
 
 		cpu_relax();
 	}
+
+	if (likely(!ignore_lockdep(sd)))
+		rwsem_acquire_read(&sd->dep_map, 0, 1, _RET_IP_);
+	return sd;
 }
 
 /**
@@ -180,7 +200,8 @@ void sysfs_put_active(struct sysfs_diren
 	if (unlikely(!sd))
 		return;
 
-	rwsem_release(&sd->dep_map, 1, _RET_IP_);
+	if (likely(!ignore_lockdep(sd)))
+		rwsem_release(&sd->dep_map, 1, _RET_IP_);
 	v = atomic_dec_return(&sd->s_active);
 	if (likely(v != SD_DEACTIVATED_BIAS))
 		return;
Index: usb-3.4/include/linux/device.h
===================================================================
--- usb-3.4.orig/include/linux/device.h
+++ usb-3.4/include/linux/device.h
@@ -503,6 +503,9 @@ ssize_t device_store_int(struct device *
 #define DEVICE_INT_ATTR(_name, _mode, _var) \
 	struct dev_ext_attribute dev_attr_##_name = \
 		{ __ATTR(_name, _mode, device_show_ulong, device_store_ulong), &(_var) }
+#define DEVICE_ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store) \
+	struct device_attribute dev_attr_##_name =		\
+		__ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store)
 
 extern int device_create_file(struct device *device,
 			      const struct device_attribute *entry);
Index: usb-3.4/drivers/usb/core/sysfs.c
===================================================================
--- usb-3.4.orig/drivers/usb/core/sysfs.c
+++ usb-3.4/drivers/usb/core/sysfs.c
@@ -73,7 +73,7 @@ set_bConfigurationValue(struct device *d
 	return (value < 0) ? value : count;
 }
 
-static DEVICE_ATTR(bConfigurationValue, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR_IGNORE_LOCKDEP(bConfigurationValue, S_IRUGO | S_IWUSR,
 		show_bConfigurationValue, set_bConfigurationValue);
 
 /* String fields */
@@ -595,7 +595,7 @@ static ssize_t usb_dev_authorized_store(
 	return result < 0? result : size;
 }
 
-static DEVICE_ATTR(authorized, 0644,
+static DEVICE_ATTR_IGNORE_LOCKDEP(authorized, 0644,
 	    usb_dev_authorized_show, usb_dev_authorized_store);
 
 /* "Safely remove a device" */
@@ -618,7 +618,7 @@ static ssize_t usb_remove_store(struct d
 	usb_unlock_device(udev);
 	return rc;
 }
-static DEVICE_ATTR(remove, 0200, NULL, usb_remove_store);
+static DEVICE_ATTR_IGNORE_LOCKDEP(remove, 0200, NULL, usb_remove_store);
 
 
 static struct attribute *dev_attrs[] = {

