Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552Ab1D1WYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 18:24:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:44777 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab1D1WYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 18:24:34 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: Allow setting of number of raw devices as a module parameter
Date: Fri, 29 Apr 2011 00:24:29 +0200
Message-Id: <1304029469-19672-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow setting of maximal number of raw devices as a module parameter. This
requires changing of static array into a vmalloced one (the array is going to
be too large for kmalloc).

Signed-off-by: Jan Kara <jack@suse.cz>

---
 drivers/char/Kconfig |    2 +-
 drivers/char/raw.c   |   33 +++++++++++++++++++++++++++------
 2 files changed, 28 insertions(+), 7 deletions(-)

  We are carrying this patch in SUSE kernels for a few years already (some
customer requested this feature). Can it be merged upstream? I'm not sure
who'd be the right maintainer though...

--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -1059,7 +1059,7 @@ config RAW_DRIVER
           with the O_DIRECT flag.
 
 config MAX_RAW_DEVS
-	int "Maximum number of RAW devices to support (1-8192)"
+	int "Maximum number of RAW devices to support (1-65536)"
 	depends on RAW_DRIVER
 	default "256"
 	help
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -21,6 +21,7 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <linux/compat.h>
+#include <linux/vmalloc.h>
 
 #include <asm/uaccess.h>
 
@@ -30,10 +31,15 @@ struct raw_device_data {
 };
 
 static struct class *raw_class;
-static struct raw_device_data raw_devices[MAX_RAW_MINORS];
+static struct raw_device_data *raw_devices;
 static DEFINE_MUTEX(raw_mutex);
 static const struct file_operations raw_ctl_fops; /* forward declaration */
 
+static int max_raw_minors = MAX_RAW_MINORS;
+
+module_param(max_raw_minors, int, 0);
+MODULE_PARM_DESC(max_raw_minors, "Maximum number of raw devices (1-65536)");
+
 /*
  * Open/close code for raw IO.
  *
@@ -131,7 +137,7 @@ static int bind_set(int number, u64 majo
 	struct raw_device_data *rawdev;
 	int err = 0;
 
-	if (number <= 0 || number >= MAX_RAW_MINORS)
+	if (number <= 0 || number >= max_raw_minors)
 		return -EINVAL;
 
 	if (MAJOR(dev) != major || MINOR(dev) != minor)
@@ -318,12 +324,26 @@ static int __init raw_init(void)
 	dev_t dev = MKDEV(RAW_MAJOR, 0);
 	int ret;
 
-	ret = register_chrdev_region(dev, MAX_RAW_MINORS, "raw");
+	if (max_raw_minors < 1 || max_raw_minors > 65536) {
+		printk(KERN_WARNING "raw: invalid max_raw_minors (must be"
+			" between 1 and 65536), using %d\n", MAX_RAW_MINORS);
+		max_raw_minors = MAX_RAW_MINORS;
+	}
+
+	raw_devices = vmalloc(sizeof(struct raw_device_data) * max_raw_minors);
+	if (!raw_devices) {
+		printk(KERN_ERR "Not enough memory for raw device structures\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+	memset(raw_devices, 0, sizeof(struct raw_device_data) * max_raw_minors);
+
+	ret = register_chrdev_region(dev, max_raw_minors, "raw");
 	if (ret)
 		goto error;
 
 	cdev_init(&raw_cdev, &raw_fops);
-	ret = cdev_add(&raw_cdev, dev, MAX_RAW_MINORS);
+	ret = cdev_add(&raw_cdev, dev, max_raw_minors);
 	if (ret) {
 		kobject_put(&raw_cdev.kobj);
 		goto error_region;
@@ -342,8 +362,9 @@ static int __init raw_init(void)
 	return 0;
 
 error_region:
-	unregister_chrdev_region(dev, MAX_RAW_MINORS);
+	unregister_chrdev_region(dev, max_raw_minors);
 error:
+	vfree(raw_devices);
 	return ret;
 }
 
@@ -352,7 +373,7 @@ static void __exit raw_exit(void)
 	device_destroy(raw_class, MKDEV(RAW_MAJOR, 0));
 	class_destroy(raw_class);
 	cdev_del(&raw_cdev);
-	unregister_chrdev_region(MKDEV(RAW_MAJOR, 0), MAX_RAW_MINORS);
+	unregister_chrdev_region(MKDEV(RAW_MAJOR, 0), max_raw_minors);
 }
 
 module_init(raw_init);
