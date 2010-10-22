Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab0JVS3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:29:12 -0400
Received: from kroah.org ([198.145.64.141]:37821 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758955Ab0JVSZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/31] uio: Support 2^MINOR_BITS minors
Date: Fri, 22 Oct 2010 11:25:02 -0700
Message-Id: <1287771916-15016-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

register_chrdev limits uio devices to 256 minor numbers which causes
problems on one system I have with 384+ uio devices.  So instead set
UIO_MAX_DEVICES to the maximum number of minors and use
alloc_chrdev_region to reserve the uio minors.

The final result is that the code works the same but the uio driver now
supports any minor the idr allocator comes up with.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c |   43 +++++++++++++++++++++++++++++++++++++------
 1 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 0fd2cda..3d4d65b 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -23,9 +23,10 @@
 #include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/kobject.h>
+#include <linux/cdev.h>
 #include <linux/uio_driver.h>
 
-#define UIO_MAX_DEVICES 255
+#define UIO_MAX_DEVICES		(1U << MINORBITS)
 
 struct uio_device {
 	struct module		*owner;
@@ -41,6 +42,7 @@ struct uio_device {
 };
 
 static int uio_major;
+static struct cdev *uio_cdev;
 static DEFINE_IDR(uio_idr);
 static const struct file_operations uio_fops;
 
@@ -731,15 +733,44 @@ static const struct file_operations uio_fops = {
 
 static int uio_major_init(void)
 {
-	uio_major = register_chrdev(0, "uio", &uio_fops);
-	if (uio_major < 0)
-		return uio_major;
-	return 0;
+	static const char name[] = "uio";
+	struct cdev *cdev = NULL;
+	dev_t uio_dev = 0;
+	int result;
+
+	result = alloc_chrdev_region(&uio_dev, 0, UIO_MAX_DEVICES, name);
+	if (result)
+		goto out;
+
+	result = -ENOMEM;
+	cdev = cdev_alloc();
+	if (!cdev)
+		goto out_unregister;
+
+	cdev->owner = THIS_MODULE;
+	cdev->ops = &uio_fops;
+	kobject_set_name(&cdev->kobj, "%s", name);
+
+	result = cdev_add(cdev, uio_dev, UIO_MAX_DEVICES);
+	if (result)
+		goto out_put;
+
+	uio_major = MAJOR(uio_dev);
+	uio_cdev = cdev;
+	result = 0;
+out:
+	return result;
+out_put:
+	kobject_put(&cdev->kobj);
+out_unregister:
+	unregister_chrdev_region(uio_dev, UIO_MAX_DEVICES);
+	goto out;
 }
 
 static void uio_major_cleanup(void)
 {
-	unregister_chrdev(uio_major, "uio");
+	unregister_chrdev_region(MKDEV(uio_major, 0), UIO_MAX_DEVICES);
+	cdev_del(uio_cdev);
 }
 
 static int init_uio_class(void)
-- 
1.7.2

