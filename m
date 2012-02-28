Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030499Ab2B1WeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:34:12 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46879 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965320Ab2B1WeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:34:09 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 4/5] watchdog: create all the proper device files
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 28 Feb 2012 22:48:25 +0000
Message-ID: <20120228224822.8961.23797.stgit@bob.linux.org.uk>
In-Reply-To: <20120228224710.8961.46003.stgit@bob.linux.org.uk>
References: <20120228224710.8961.46003.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/watchdog/watchdog_dev.c |   29 ++++++++++++++++++++++++-----
 include/linux/watchdog.h        |    5 ++++-
 2 files changed, 28 insertions(+), 6 deletions(-)


diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 253e082..7edab6d 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -42,6 +42,8 @@
 #include <linux/init.h>		/* For __init/__exit/... */
 #include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
 
+static struct class *watchdog_class;	/* So we have someone to create
+					   our devices */
 static dev_t dog_devt;		/* Watchdog device range */
 static unsigned long dog_mask;	/* Watcodgs that are in use */
 /* the watchdog device behind /dev/watchdog */
@@ -434,13 +436,21 @@ static int watchdog_add_device(struct watchdog_device *watchdog)
 	watchdog->devt = MKDEV(MAJOR(dog_devt), watchdog->id);
 	watchdog->cdev.owner = watchdog->ops->owner;
 	cdev_init(&watchdog->cdev, &watchdog_multi_fops);
-
 	/* Add the device */
 	err  = cdev_add(&watchdog->cdev, watchdog->devt, 1);
-	if (err)
+	if (err) {
 		pr_err("watchdog%d unable to add device %d:%d\n",
 			watchdog->id,  MAJOR(dog_devt), watchdog->id);
-	return err;
+		return err;
+	}
+	watchdog->dev = device_create(watchdog_class, watchdog->busdev,
+					MKDEV(MAJOR(dog_devt), watchdog->id),
+					NULL, "watchdog%d", watchdog->id);
+	if (IS_ERR(watchdog->dev)) {
+		cdev_del(&watchdog->cdev);
+		return PTR_ERR(watchdog->dev);
+	}
+	return 0;
 }
 
 /**
@@ -452,6 +462,7 @@ static int watchdog_add_device(struct watchdog_device *watchdog)
 static void watchdog_del_device(struct watchdog_device *watchdog)
 {
 	cdev_del(&watchdog->cdev);
+	device_destroy(watchdog_class, MKDEV(MAJOR(dog_devt), watchdog->id));
 }	
 
 /**
@@ -518,9 +529,16 @@ int watchdog_dev_unregister(struct watchdog_device *watchdog)
 int __init watchdog_init(void)
 {
 	int err = alloc_chrdev_region(&dog_devt, 0, DOG_MAX, "watchdog");
-	if (err < 0)
+	if (err < 0) {
 		pr_err("watchdog: unable to allocate char dev region\n");
-	return err;
+		return err;
+	}
+	watchdog_class = class_create(THIS_MODULE, "watchdog");
+	if (IS_ERR(watchdog_class)) {
+		unregister_chrdev_region(dog_devt, DOG_MAX);
+		return PTR_ERR(watchdog_class);
+	}
+	return 0;
 }
 
 /**
@@ -531,6 +549,7 @@ int __init watchdog_init(void)
 void __exit watchdog_exit(void)
 {
 	unregister_chrdev_region(dog_devt, DOG_MAX);
+	class_destroy(watchdog_class);
 }
 
 module_init(watchdog_init);
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index c80e1ae..598c407 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -108,7 +108,10 @@ struct watchdog_ops {
  */
 struct watchdog_device {
 	struct cdev cdev;		/* Character device */
-	dev_t devt;			/* Our device */
+	struct device *dev;		/* Device for our node */
+	struct device *busdev;		/* Parent bus device (set by caller
+							if used) */
+	dev_t devt;			/* Our device devt */
 	int id;				/* Watchdog id */
 
 	const struct watchdog_info *info;

