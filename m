Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972Ab0JVSZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:25:40 -0400
Received: from kroah.org ([198.145.64.141]:37808 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758944Ab0JVSZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:34 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/31] uio: Fix lack of locking in init_uio_class
Date: Fri, 22 Oct 2010 11:24:59 -0700
Message-Id: <1287771916-15016-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

There is no locking in init_uio_class so multiple
drivers can race and create multiple uio classes.

Fix this by simplifying the code.   In particular always
register the uio class during module_init and make things
simpler.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c |   58 +++++++++++++---------------------------------------
 1 files changed, 15 insertions(+), 43 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index bff1afb..bc774cc 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -45,10 +45,7 @@ static DEFINE_IDR(uio_idr);
 static const struct file_operations uio_fops;
 
 /* UIO class infrastructure */
-static struct uio_class {
-	struct kref kref;
-	struct class *class;
-} *uio_class;
+static struct class *uio_class;
 
 /* Protect idr accesses */
 static DEFINE_MUTEX(minor_lock);
@@ -757,55 +754,35 @@ static void uio_major_cleanup(void)
 
 static int init_uio_class(void)
 {
-	int ret = 0;
-
-	if (uio_class != NULL) {
-		kref_get(&uio_class->kref);
-		goto exit;
-	}
+	struct class *class;
+	int ret;
 
 	/* This is the first time in here, set everything up properly */
 	ret = uio_major_init();
 	if (ret)
 		goto exit;
 
-	uio_class = kzalloc(sizeof(*uio_class), GFP_KERNEL);
-	if (!uio_class) {
-		ret = -ENOMEM;
-		goto err_kzalloc;
-	}
-
-	kref_init(&uio_class->kref);
-	uio_class->class = class_create(THIS_MODULE, "uio");
-	if (IS_ERR(uio_class->class)) {
-		ret = IS_ERR(uio_class->class);
+	class = class_create(THIS_MODULE, "uio");
+	if (IS_ERR(class)) {
+		ret = IS_ERR(class);
 		printk(KERN_ERR "class_create failed for uio\n");
 		goto err_class_create;
 	}
+	uio_class = class;
 	return 0;
 
 err_class_create:
-	kfree(uio_class);
-	uio_class = NULL;
-err_kzalloc:
 	uio_major_cleanup();
 exit:
 	return ret;
 }
 
-static void release_uio_class(struct kref *kref)
+static void release_uio_class(void)
 {
 	/* Ok, we cheat as we know we only have one uio_class */
-	class_destroy(uio_class->class);
-	kfree(uio_class);
-	uio_major_cleanup();
+	class_destroy(uio_class);
 	uio_class = NULL;
-}
-
-static void uio_class_destroy(void)
-{
-	if (uio_class)
-		kref_put(&uio_class->kref, release_uio_class);
+	uio_major_cleanup();
 }
 
 /**
@@ -828,10 +805,6 @@ int __uio_register_device(struct module *owner,
 
 	info->uio_dev = NULL;
 
-	ret = init_uio_class();
-	if (ret)
-		return ret;
-
 	idev = kzalloc(sizeof(*idev), GFP_KERNEL);
 	if (!idev) {
 		ret = -ENOMEM;
@@ -847,7 +820,7 @@ int __uio_register_device(struct module *owner,
 	if (ret)
 		goto err_get_minor;
 
-	idev->dev = device_create(uio_class->class, parent,
+	idev->dev = device_create(uio_class, parent,
 				  MKDEV(uio_major, idev->minor), idev,
 				  "uio%d", idev->minor);
 	if (IS_ERR(idev->dev)) {
@@ -874,13 +847,12 @@ int __uio_register_device(struct module *owner,
 err_request_irq:
 	uio_dev_del_attributes(idev);
 err_uio_dev_add_attributes:
-	device_destroy(uio_class->class, MKDEV(uio_major, idev->minor));
+	device_destroy(uio_class, MKDEV(uio_major, idev->minor));
 err_device_create:
 	uio_free_minor(idev);
 err_get_minor:
 	kfree(idev);
 err_kzalloc:
-	uio_class_destroy();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__uio_register_device);
@@ -907,9 +879,8 @@ void uio_unregister_device(struct uio_info *info)
 	uio_dev_del_attributes(idev);
 
 	dev_set_drvdata(idev->dev, NULL);
-	device_destroy(uio_class->class, MKDEV(uio_major, idev->minor));
+	device_destroy(uio_class, MKDEV(uio_major, idev->minor));
 	kfree(idev);
-	uio_class_destroy();
 
 	return;
 }
@@ -917,11 +888,12 @@ EXPORT_SYMBOL_GPL(uio_unregister_device);
 
 static int __init uio_init(void)
 {
-	return 0;
+	return init_uio_class();
 }
 
 static void __exit uio_exit(void)
 {
+	release_uio_class();
 }
 
 module_init(uio_init)
-- 
1.7.2

