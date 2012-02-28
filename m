Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030295Ab2B1WdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:33:19 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46869 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2B1WdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:33:18 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/5] watchdog: Add multiple device support
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 28 Feb 2012 22:47:28 +0000
Message-ID: <20120228224710.8961.46003.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We keep the old /dev/watchdog interface file for the first watchdog via
miscdev. This is basically a cut and paste of the relevant interface code
from the rtc driver layer tweaked for watchdog.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/watchdog/watchdog_dev.c |  231 ++++++++++++++++++++++++++++++++-------
 include/linux/watchdog.h        |    6 +
 2 files changed, 193 insertions(+), 44 deletions(-)


diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 1199da0..253e082 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -42,10 +42,12 @@
 #include <linux/init.h>		/* For __init/__exit/... */
 #include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
 
-/* make sure we only register one /dev/watchdog device */
-static unsigned long watchdog_dev_busy;
+static dev_t dog_devt;		/* Watchdog device range */
+static unsigned long dog_mask;	/* Watcodgs that are in use */
 /* the watchdog device behind /dev/watchdog */
-static struct watchdog_device *wdd;
+static struct watchdog_device *old_wdd;
+
+#define DOG_MAX		32	/* assign_id must be changed to boost this */
 
 /*
  *	watchdog_ping: ping the watchdog.
@@ -136,6 +138,7 @@ static int watchdog_stop(struct watchdog_device *wddev)
 static ssize_t watchdog_write(struct file *file, const char __user *data,
 						size_t len, loff_t *ppos)
 {
+	struct watchdog_device *wdd = file->private_data;
 	size_t i;
 	char c;
 
@@ -175,6 +178,7 @@ static ssize_t watchdog_write(struct file *file, const char __user *data,
 static long watchdog_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
+	struct watchdog_device *wdd = file->private_data;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	unsigned int val;
@@ -252,7 +256,8 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
  *	it can only be opened once.
  */
 
-static int watchdog_open(struct inode *inode, struct file *file)
+static int watchdog_do_open(struct watchdog_device *wdd,
+				struct inode *inode, struct file *file)
 {
 	int err = -EBUSY;
 
@@ -271,6 +276,8 @@ static int watchdog_open(struct inode *inode, struct file *file)
 	if (err < 0)
 		goto out_mod;
 
+	file->private_data = wdd;
+
 	/* dev/watchdog is a virtual (and thus non-seekable) filesystem */
 	return nonseekable_open(inode, file);
 
@@ -282,7 +289,44 @@ out:
 }
 
 /*
- *      watchdog_release: release the /dev/watchdog device.
+ *	watchdog_open: open the /dev/watchdog device.
+ *	@inode: inode of device
+ *	@file: file handle to device
+ *
+ *	When the /dev/watchdog device gets opened, we start the watchdog.
+ *	Watch out: the /dev/watchdog device is single open, so we make sure
+ *	it can only be opened once.
+ *
+ *	FIXME: review locking on old_wdd v unregister
+ */
+
+static int watchdog_open(struct inode *inode, struct file *file)
+{
+	if (old_wdd != NULL)
+		return watchdog_do_open(old_wdd, inode, file);
+	return -ENXIO;
+}
+
+/*
+ *	watchdog_mopen: open the newer watchdog devices.
+ *	@inode: inode of device
+ *	@file: file handle to device
+ *
+ *	When the watchdog device gets opened, we start the watchdog.
+ *	Watch out: the /dev/watchdog device is single open, so we make sure
+ *	it can only be opened once.
+ */
+
+static int watchdog_mopen(struct inode *inode, struct file *file)
+{
+	struct watchdog_device *wdd = container_of(inode->i_cdev,
+		struct watchdog_device, cdev);
+
+	return watchdog_do_open(wdd, inode, file);
+}
+
+/*
+ *      watchdog_release: release the watchdog device.
  *      @inode: inode of device
  *      @file: file handle to device
  *
@@ -293,6 +337,7 @@ out:
 
 static int watchdog_release(struct inode *inode, struct file *file)
 {
+	struct watchdog_device *wdd = file->private_data;
 	int err = -EBUSY;
 
 	/*
@@ -327,69 +372,167 @@ static const struct file_operations watchdog_fops = {
 	.release	= watchdog_release,
 };
 
+static const struct file_operations watchdog_multi_fops = {
+	.owner		= THIS_MODULE,
+	.write		= watchdog_write,
+	.unlocked_ioctl	= watchdog_ioctl,
+	.open		= watchdog_mopen,
+	.release	= watchdog_release,
+};
+
 static struct miscdevice watchdog_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &watchdog_fops,
 };
 
-/*
- *	watchdog_dev_register:
- *	@watchdog: watchdog device
+/**
+ *	watchdog_assign_id	-	pick a free watchdog ident
+ *	@watchdog: the watchdog device
+ *	@first: number to scan from
  *
- *	Register a watchdog device as /dev/watchdog. /dev/watchdog
- *	is actually a miscdevice and thus we set it up like that.
+ *	Assign a watchdog number to the device. For the moment we support
+ *	a starting offset so that a legacy watchdog can be worked around
  */
+static int watchdog_assign_id(struct watchdog_device *watchdog, int first)
+{
+	int i;
+	for (i = first; i < DOG_MAX; i ++) {
+		if (test_and_set_bit(i, &dog_mask) == 0) {
+			watchdog->id = i;
+			return i;
+		}
+	}
+	pr_err("no free watchdog slots.\n");
+	return -EBUSY;
+}
 
-int watchdog_dev_register(struct watchdog_device *watchdog)
+/**
+ *	watchdog_release_id	-	release a watchdg id
+ *	@watchdog: the watchdog device
+ *
+ *	Release the identifier associated with this watchdog. All cdev
+ *	resources must have been released first.
+ */
+static void watchdog_release_id(struct watchdog_device *watchdog)
+{
+	clear_bit(watchdog->id, &dog_mask);
+}
+
+/**
+ *	watchdog_add_device	-	add a watchdog device
+ *	@watchdog: the watchdog device
+ *
+ *	Add a watchdog device node to the system and set up all the
+ *	needed structures.
+ */
+static int watchdog_add_device(struct watchdog_device *watchdog)
 {
 	int err;
 
-	/* Only one device can register for /dev/watchdog */
-	if (test_and_set_bit(0, &watchdog_dev_busy)) {
-		pr_err("only one watchdog can use /dev/watchdog.\n");
-		return -EBUSY;
-	}
+	/* Fill in the data structures */
+	watchdog->devt = MKDEV(MAJOR(dog_devt), watchdog->id);
+	watchdog->cdev.owner = watchdog->ops->owner;
+	cdev_init(&watchdog->cdev, &watchdog_multi_fops);
 
-	wdd = watchdog;
+	/* Add the device */
+	err  = cdev_add(&watchdog->cdev, watchdog->devt, 1);
+	if (err)
+		pr_err("watchdog%d unable to add device %d:%d\n",
+			watchdog->id,  MAJOR(dog_devt), watchdog->id);
+	return err;
+}
 
-	err = misc_register(&watchdog_miscdev);
-	if (err != 0) {
-		pr_err("%s: cannot register miscdev on minor=%d (err=%d).\n",
-			watchdog->info->identity, WATCHDOG_MINOR, err);
-		goto out;
-	}
+/**
+ *	watchdog_del_device	-	delete a watchdog device
+ *	@watchdog: the watchdog device
+ *
+ *	Delete a watchdog device cdev object
+ */
+static void watchdog_del_device(struct watchdog_device *watchdog)
+{
+	cdev_del(&watchdog->cdev);
+}	
 
-	return 0;
+/**
+ *	watchdog_dev_register 	-	register a watchdog
+ *	@watchdog: watchdog device
+ *
+ *	Register a watchdog device including handling the legacy
+ *	/dev/watchdog node. /dev/watchdog is actually a miscdevice and
+ *	thus we set it up like that.
+ */
+int watchdog_dev_register(struct watchdog_device *watchdog)
+{
+	int err;
 
-out:
-	wdd = NULL;
-	clear_bit(0, &watchdog_dev_busy);
+	err = watchdog_assign_id(watchdog, 0);
+	if (err < 0)
+		return err;
+	if (err == 0) {
+		err = misc_register(&watchdog_miscdev);
+		if (err == 0)
+			old_wdd = watchdog;
+		else {
+			pr_err("%s: cannot register miscdev on minor=%d (err=%d).\n",
+				watchdog->info->identity, WATCHDOG_MINOR, err);
+			pr_err("%s: probably a legacy watchdog module is present.\n",
+				watchdog->info->identity);
+			watchdog_release_id(watchdog);
+			err = watchdog_assign_id(watchdog, 1);
+			if (err < 0)
+				return err;
+		}
+	}
+	err = watchdog_add_device(watchdog);
+	if (err < 0) {
+		if (watchdog->id == 0)
+			old_wdd = NULL;
+		watchdog_release_id(watchdog);
+	}
 	return err;
 }
 
-/*
- *	watchdog_dev_unregister:
+/**
+ *	watchdog_dev_unregister		-	unregister a watchdog
  *	@watchdog: watchdog device
  *
- *	Deregister the /dev/watchdog device.
+ *	Unregister the watchdog and if needed the legacy /dev/watchdog device.
  */
-
 int watchdog_dev_unregister(struct watchdog_device *watchdog)
 {
-	/* Check that a watchdog device was registered in the past */
-	if (!test_bit(0, &watchdog_dev_busy) || !wdd)
-		return -ENODEV;
-
-	/* We can only unregister the watchdog device that was registered */
-	if (watchdog != wdd) {
-		pr_err("%s: watchdog was not registered as /dev/watchdog.\n",
-			watchdog->info->identity);
-		return -ENODEV;
+	watchdog_del_device(watchdog);
+	if (watchdog->id == 0) {
+		misc_deregister(&watchdog_miscdev);
+		old_wdd = NULL;
 	}
-
-	misc_deregister(&watchdog_miscdev);
-	wdd = NULL;
-	clear_bit(0, &watchdog_dev_busy);
+	watchdog_release_id(watchdog);
 	return 0;
 }
+
+/**
+ *	watchdog_init	-	module init call
+ *
+ *	Allocate a range of chardev nodes to use for watchdog devices
+ */
+int __init watchdog_init(void)
+{
+	int err = alloc_chrdev_region(&dog_devt, 0, DOG_MAX, "watchdog");
+	if (err < 0)
+		pr_err("watchdog: unable to allocate char dev region\n");
+	return err;
+}
+
+/**
+ *	watchdog_exit	-	module exit
+ *
+ *	Release the range of chardev nodes used for watchdog devices
+ */
+void __exit watchdog_exit(void)
+{
+	unregister_chrdev_region(dog_devt, DOG_MAX);
+}
+
+module_init(watchdog_init);
+module_exit(watchdog_exit);
+
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 43ba5b3..4167fd3 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -54,6 +54,8 @@ struct watchdog_info {
 #ifdef __KERNEL__
 
 #include <linux/bitops.h>
+#include <linux/device.h>
+#include <linux/cdev.h>
 
 struct watchdog_ops;
 struct watchdog_device;
@@ -103,6 +105,10 @@ struct watchdog_ops {
  * via the watchdog_set_drvdata and watchdog_get_drvdata helpers.
  */
 struct watchdog_device {
+	struct cdev cdev;		/* Character device */
+	dev_t devt;			/* Our device */
+	int id;				/* Watchdog id */
+
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
 	unsigned int bootstatus;

