Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352Ab2EDTI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:08:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52887 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753890Ab2EDTIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:08:55 -0400
Date: Fri, 4 May 2012 15:08:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
In-Reply-To: <20120504165232.GB24639@google.com>
Message-ID: <Pine.LNX.4.44L0.1205041459240.1166-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2012, Tejun Heo wrote:

> > Is there any reasonable way to get from the kobject and the attribute
> > to the appropriate sysfs_dirent?  Search through all the groups
> > attached to the kobject?  Restrict the new interface so that it can be
> > used only by attributes at the kobject's top level (i.e., not in a
> > named group)?
> > 
> > Any suggestions?
> 
> Urgh... I can't think of anything pretty.  How about just marking the
> attr as "I'm special" and let sysfs code override lockdep annotation?

Never mind, I figured it out.  The caller knows what the group is (if 
there's a group), so it can simply pass that information along.

To make things clearer, I broke the interface into two parts: one to 
find the sysfs_dirent and the other to handle the lockdep annotations.  
Here's the patch -- it works.  What do you think?

Alan Stern

P.S.: I'm not sure about the namespace arguments to sysfs_get_dirent().  
Is NULL appropriate?  Or should I use sysfs_ns_type(kobj->sd)?




Index: usb-3.4/include/linux/sysfs.h
===================================================================
--- usb-3.4.orig/include/linux/sysfs.h
+++ usb-3.4/include/linux/sysfs.h
@@ -121,6 +121,10 @@ struct sysfs_dirent;
 
 int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
 			    void *data, struct module *owner);
+struct sysfs_dirent *sysfs_find_dirent_for_attr(struct kobject *kobj,
+			const struct attribute *attr, const char *group);
+void sysfs_unannotate_readlock(struct sysfs_dirent *sd);
+void sysfs_reannotate_readlock(struct sysfs_dirent *sd);
 
 int __must_check sysfs_create_dir(struct kobject *kobj);
 void sysfs_remove_dir(struct kobject *kobj);
@@ -188,6 +192,21 @@ static inline int sysfs_schedule_callbac
 	return -ENOSYS;
 }
 
+static inline struct sysfs_dirent *sysfs_find_dirent_for_attr(
+			struct kobject *kobj,
+			const struct attribute *attr, const char *group)
+{
+	return NULL;
+}
+
+static inline void sysfs_unannotate_readlock(struct sysfs_dirent *sd)
+{
+}
+
+static inline void sysfs_reannotate_readlock(struct sysfs_dirent *sd)
+{
+}
+
 static inline int sysfs_create_dir(struct kobject *kobj)
 {
 	return 0;
Index: usb-3.4/include/linux/device.h
===================================================================
--- usb-3.4.orig/include/linux/device.h
+++ usb-3.4/include/linux/device.h
@@ -514,6 +514,11 @@ extern void device_remove_bin_file(struc
 				   const struct bin_attribute *attr);
 extern int device_schedule_callback_owner(struct device *dev,
 		void (*func)(struct device *dev), struct module *owner);
+extern void *device_start_attribute_infanticide(
+		struct device *dev, const struct device_attribute *attr,
+		const char *group);
+extern void device_end_attribute_infanticide(void *cookie);
+
 
 /* This is a macro to avoid include problems with THIS_MODULE */
 #define device_schedule_callback(dev, func)			\
Index: usb-3.4/fs/sysfs/dir.c
===================================================================
--- usb-3.4.orig/fs/sysfs/dir.c
+++ usb-3.4/fs/sysfs/dir.c
@@ -133,6 +133,74 @@ static void sysfs_unlink_sibling(struct
 }
 
 /**
+ *	sysfs_find_dirent_for_attr - find sysfs_dirent for a given kobject and attribute
+ *	@kobj: kobject the attribute is attached to
+ *	@attr: attribute whose sysfs_dirent should be found
+ *	@group: name of the group containing @attr, or NULL
+ *
+ *	Looks up and returns a pointer to the sysfs_dirent structure
+ *	corresponding to the instance of @attr in @group attached to @kobj.
+ *	Returns NULL if the sysfs_dirent cannot be found.
+ *
+ *	Retains a reference to the returned sysfs_dirent.  The caller must
+ *	release this reference, as done by sysfs_reannotate_readlock()
+ *	below.
+ */
+struct sysfs_dirent *sysfs_find_dirent_for_attr(struct kobject *kobj,
+			const struct attribute *attr, const char *group)
+{
+	struct sysfs_dirent *dir_sd;
+	struct sysfs_dirent *sd;
+
+	if (group)
+		dir_sd = sysfs_get_dirent(kobj->sd, NULL, group);
+	else
+		dir_sd = sysfs_get(kobj->sd);
+	if (!dir_sd)
+		return NULL;
+
+	sd = sysfs_get_dirent(dir_sd, NULL, attr->name);
+	sysfs_put(dir_sd);
+	return sd;
+}
+
+/**
+ *	sysfs_unannotate_readlock - drop the lockdep annotation for an attribute
+ *	@sd: sysfs_dirent for the attribute whose lock annotation is dropped
+ *
+ *	Lockdep is not able to cope with the tree-structured locks used
+ *	by the device core.  It considers all the s_active lock associated
+ *	a particular attribute to be the same.  This causes a false
+ *	positive report when a method for an attribute attached to a device
+ *	wants to remove the same attribute attached to a child device.
+ *
+ *	To avoid such false positives, the method can call this routine to
+ *	drop the lockdep annotation indicating that the attribute's dirent is
+ *	currently locked, remove the child's attribute, and then reacquire
+ *	the annotation.
+ */
+void sysfs_unannotate_readlock(struct sysfs_dirent *sd)
+{
+	rwsem_release(&sd->dep_map, 1, _RET_IP_);
+}
+
+/**
+ *	sysfs_reannotate_readlock - reacquire the lockdep annotation for an attribute
+ *	@sd: sysfs_dirent for the attribute whose lock annotation is reacquired
+ *
+ *	After an attribute method has called sysfs_unannotate_readlock()
+ *	and removed the attributes from various child devices, it should
+ *	call this routine to reacquire the lockdep annotation (and also to
+ *	drop the reference to @sd obtained by
+ *	sysfs_get_dirent_for_attribute()) before returning.
+ */
+void sysfs_reannotate_readlock(struct sysfs_dirent *sd)
+{
+	rwsem_acquire_read(&sd->dep_map, 0, 1, _RET_IP_);
+	sysfs_put(sd);
+}
+
+/**
  *	sysfs_get_active - get an active reference to sysfs_dirent
  *	@sd: sysfs_dirent to get an active reference to
  *
Index: usb-3.4/drivers/base/core.c
===================================================================
--- usb-3.4.orig/drivers/base/core.c
+++ usb-3.4/drivers/base/core.c
@@ -609,6 +609,48 @@ int device_schedule_callback_owner(struc
 }
 EXPORT_SYMBOL_GPL(device_schedule_callback_owner);
 
+/**
+ * device_start_attribute_infanticide - prepare to remove child attributes
+ * @dev: device passed to the calling method
+ * @attr: attribute passed to the calling method
+ * @group: name of the group containing @attr, or NULL
+ *
+ * To avoid false positive reports from lockdep, this routine should be
+ * called by an attribute method that wants to remove the same attribute
+ * from a descendant of the device for which it was called (an
+ * "infanticidal" attribute).
+ *
+ * The returned value should be treated as an opaque cookie and passed to
+ * device_end_attribute_infanticide() below after the descendant
+ * attributes have been removed.
+ */
+void *device_start_attribute_infanticide(
+		struct device *dev, const struct device_attribute *attr,
+		const char *group)
+{
+	struct sysfs_dirent *sd;
+
+	sd = sysfs_find_dirent_for_attr(&dev->kobj, &attr->attr, group);
+	if (sd)
+		sysfs_unannotate_readlock(sd);
+	return sd;
+}
+EXPORT_SYMBOL_GPL(device_start_attribute_infanticide);
+
+/**
+ * device_end_attribute_infanticide - finish removing child attributes
+ * @cookie: value returned by device_start_attribute_infanticide() above
+ *
+ * This routine should be called by attribute methods after they have
+ * finished removing the corresponding attributes from descendant devices.
+ */
+void device_end_attribute_infanticide(void *cookie)
+{
+	if (cookie)
+		sysfs_reannotate_readlock(cookie);
+}
+EXPORT_SYMBOL_GPL(device_end_attribute_infanticide);
+
 static void klist_children_get(struct klist_node *n)
 {
 	struct device_private *p = to_device_private_parent(n);
Index: usb-3.4/drivers/usb/core/sysfs.c
===================================================================
--- usb-3.4.orig/drivers/usb/core/sysfs.c
+++ usb-3.4/drivers/usb/core/sysfs.c
@@ -64,11 +64,14 @@ set_bConfigurationValue(struct device *d
 {
 	struct usb_device	*udev = to_usb_device(dev);
 	int			config, value;
+	void			*cookie;
 
 	if (sscanf(buf, "%d", &config) != 1 || config < -1 || config > 255)
 		return -EINVAL;
 	usb_lock_device(udev);
+	cookie = device_start_attribute_infanticide(dev, attr, NULL);
 	value = usb_set_configuration(udev, config);
+	device_end_attribute_infanticide(cookie);
 	usb_unlock_device(udev);
 	return (value < 0) ? value : count;
 }
@@ -588,10 +591,15 @@ static ssize_t usb_dev_authorized_store(
 	result = sscanf(buf, "%u\n", &val);
 	if (result != 1)
 		result = -EINVAL;
-	else if (val == 0)
+	else if (val == 0) {
+		void *cookie;
+
+		cookie = device_start_attribute_infanticide(dev, attr, NULL);
 		result = usb_deauthorize_device(usb_dev);
-	else
+		device_end_attribute_infanticide(cookie);
+	} else {
 		result = usb_authorize_device(usb_dev);
+	}
 	return result < 0? result : size;
 }
 
@@ -605,12 +613,15 @@ static ssize_t usb_remove_store(struct d
 {
 	struct usb_device *udev = to_usb_device(dev);
 	int rc = 0;
+	void *cookie;
 
 	usb_lock_device(udev);
 	if (udev->state != USB_STATE_NOTATTACHED) {
 
 		/* To avoid races, first unconfigure and then remove */
+		cookie = device_start_attribute_infanticide(dev, attr, NULL);
 		usb_set_configuration(udev, -1);
+		device_end_attribute_infanticide(cookie);
 		rc = usb_remove_device(udev);
 	}
 	if (rc == 0)

