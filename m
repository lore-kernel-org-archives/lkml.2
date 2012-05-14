Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab2ENRaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:30:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49381 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757147Ab2ENRaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:30:04 -0400
Date: Mon, 14 May 2012 13:30:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs: get rid of some lockdep false positives
Message-ID: <Pine.LNX.4.44L0.1205141324200.1699-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1554) fixes a lockdep false-positive report.  The
problem arises because lockdep is unable to deal with the
tree-structured locks created by the device core and sysfs.

This particular problem involves a sysfs attribute method that
unregisters itself, not from the device it was called for, but from a
descendant device.  Lockdep doesn't understand the distinction and
reports a possible deadlock, even though the operation is safe.

This is the sort of thing that would normally be handled by using a
nested lock annotation; unfortunately it's not feasible to do that
here.  There's no sensible way to tell sysfs when attribute removal
occurs in the context of a parent attribute method.

As a workaround, the patch adds a new flag to struct attribute
telling sysfs not to inform lockdep when it acquires a readlock on a
sysfs_dirent instance for the attribute.  The readlock is still
acquired, but lockdep doesn't know about it and hence does not
complain about impossible deadlock scenarios.

Also added are macros for static initialization of attribute
structures with the ignore_lockdep flag set.  The three offending
attributes in the USB subsystem are converted to use the new macros.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Tejun Heo <tj@kernel.org>
CC: Eric W. Biederman <ebiederm@xmission.com>
CC: Peter Zijlstra <peterz@infradead.org>

---

 drivers/usb/core/sysfs.c |    6 +++---
 fs/sysfs/dir.c           |   31 ++++++++++++++++++++++++++-----
 include/linux/device.h   |    3 +++
 include/linux/sysfs.h    |   12 ++++++++++++
 4 files changed, 44 insertions(+), 8 deletions(-)

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
+#define __ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store) {	\
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

