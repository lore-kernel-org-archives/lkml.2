Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab0JVS2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:28:43 -0400
Received: from kroah.org ([198.145.64.141]:37824 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758934Ab0JVSZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/31] uio: Statically allocate uio_class and use class .dev_attrs.
Date: Fri, 22 Oct 2010 11:25:03 -0700
Message-Id: <1287771916-15016-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

Instead of adding uio class attributes manually after the uio device has
been created and we have sent a uevent to userspace, use the class
attribute mechanism.  This removes races and makes the code simpler.

At the same time don't bother to dynamically allocate a struct class for
uio, just declare one statically.  Less code is needed and it is easier
to set the class parameters.tune the class

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c |   53 ++++++++++++++++++-----------------------------------
 1 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 3d4d65b..3fe9a9d 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -46,9 +46,6 @@ static struct cdev *uio_cdev;
 static DEFINE_IDR(uio_idr);
 static const struct file_operations uio_fops;
 
-/* UIO class infrastructure */
-static struct class *uio_class;
-
 /* Protect idr accesses */
 static DEFINE_MUTEX(minor_lock);
 
@@ -233,7 +230,6 @@ static ssize_t show_name(struct device *dev,
 	struct uio_device *idev = dev_get_drvdata(dev);
 	return sprintf(buf, "%s\n", idev->info->name);
 }
-static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
 
 static ssize_t show_version(struct device *dev,
 			    struct device_attribute *attr, char *buf)
@@ -241,7 +237,6 @@ static ssize_t show_version(struct device *dev,
 	struct uio_device *idev = dev_get_drvdata(dev);
 	return sprintf(buf, "%s\n", idev->info->version);
 }
-static DEVICE_ATTR(version, S_IRUGO, show_version, NULL);
 
 static ssize_t show_event(struct device *dev,
 			  struct device_attribute *attr, char *buf)
@@ -249,17 +244,18 @@ static ssize_t show_event(struct device *dev,
 	struct uio_device *idev = dev_get_drvdata(dev);
 	return sprintf(buf, "%u\n", (unsigned int)atomic_read(&idev->event));
 }
-static DEVICE_ATTR(event, S_IRUGO, show_event, NULL);
 
-static struct attribute *uio_attrs[] = {
-	&dev_attr_name.attr,
-	&dev_attr_version.attr,
-	&dev_attr_event.attr,
-	NULL,
+static struct device_attribute uio_class_attributes[] = {
+	__ATTR(name, S_IRUGO, show_name, NULL),
+	__ATTR(version, S_IRUGO, show_version, NULL),
+	__ATTR(event, S_IRUGO, show_event, NULL),
+	{}
 };
 
-static struct attribute_group uio_attr_grp = {
-	.attrs = uio_attrs,
+/* UIO class infrastructure */
+static struct class uio_class = {
+	.name = "uio",
+	.dev_attrs = uio_class_attributes,
 };
 
 /*
@@ -276,10 +272,6 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 	struct uio_port *port;
 	struct uio_portio *portio;
 
-	ret = sysfs_create_group(&idev->dev->kobj, &uio_attr_grp);
-	if (ret)
-		goto err_group;
-
 	for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
 		mem = &idev->info->mem[mi];
 		if (mem->size == 0)
@@ -347,8 +339,6 @@ err_map:
 		kobject_put(&map->kobj);
 	}
 	kobject_put(idev->map_dir);
-	sysfs_remove_group(&idev->dev->kobj, &uio_attr_grp);
-err_group:
 	dev_err(idev->dev, "error creating sysfs files (%d)\n", ret);
 	return ret;
 }
@@ -374,8 +364,6 @@ static void uio_dev_del_attributes(struct uio_device *idev)
 		kobject_put(&port->portio->kobj);
 	}
 	kobject_put(idev->portio_dir);
-
-	sysfs_remove_group(&idev->dev->kobj, &uio_attr_grp);
 }
 
 static int uio_get_minor(struct uio_device *idev)
@@ -775,7 +763,6 @@ static void uio_major_cleanup(void)
 
 static int init_uio_class(void)
 {
-	struct class *class;
 	int ret;
 
 	/* This is the first time in here, set everything up properly */
@@ -783,16 +770,14 @@ static int init_uio_class(void)
 	if (ret)
 		goto exit;
 
-	class = class_create(THIS_MODULE, "uio");
-	if (IS_ERR(class)) {
-		ret = IS_ERR(class);
-		printk(KERN_ERR "class_create failed for uio\n");
-		goto err_class_create;
+	ret = class_register(&uio_class);
+	if (ret) {
+		printk(KERN_ERR "class_register failed for uio\n");
+		goto err_class_register;
 	}
-	uio_class = class;
 	return 0;
 
-err_class_create:
+err_class_register:
 	uio_major_cleanup();
 exit:
 	return ret;
@@ -800,9 +785,7 @@ exit:
 
 static void release_uio_class(void)
 {
-	/* Ok, we cheat as we know we only have one uio_class */
-	class_destroy(uio_class);
-	uio_class = NULL;
+	class_unregister(&uio_class);
 	uio_major_cleanup();
 }
 
@@ -841,7 +824,7 @@ int __uio_register_device(struct module *owner,
 	if (ret)
 		goto err_get_minor;
 
-	idev->dev = device_create(uio_class, parent,
+	idev->dev = device_create(&uio_class, parent,
 				  MKDEV(uio_major, idev->minor), idev,
 				  "uio%d", idev->minor);
 	if (IS_ERR(idev->dev)) {
@@ -868,7 +851,7 @@ int __uio_register_device(struct module *owner,
 err_request_irq:
 	uio_dev_del_attributes(idev);
 err_uio_dev_add_attributes:
-	device_destroy(uio_class, MKDEV(uio_major, idev->minor));
+	device_destroy(&uio_class, MKDEV(uio_major, idev->minor));
 err_device_create:
 	uio_free_minor(idev);
 err_get_minor:
@@ -899,7 +882,7 @@ void uio_unregister_device(struct uio_info *info)
 
 	uio_dev_del_attributes(idev);
 
-	device_destroy(uio_class, MKDEV(uio_major, idev->minor));
+	device_destroy(&uio_class, MKDEV(uio_major, idev->minor));
 	kfree(idev);
 
 	return;
-- 
1.7.2

