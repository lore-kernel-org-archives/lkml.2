Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab0INSgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:36:32 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48396 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab0INSgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:36:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>, <linux-kernel@vger.kernel.org>
References: <m1y6b48973.fsf@fess.ebiederm.org>
Date: Tue, 14 Sep 2010 11:36:27 -0700
In-Reply-To: <m1y6b48973.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Tue, 14 Sep 2010 11:35:28 -0700")
Message-ID: <m1sk1c895g.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: 
Subject: [PATCH 1/5] uio: Fix lack of locking in init_uio_class
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is no locking in init_uio_class so multiple
drivers can race and create multiple uio classes.

Fix this by simplifying the code.   In particular always
register the uio class during module_init and make things
simpler.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
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
1.7.2.2

