Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934867Ab1ESVeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:34:13 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:44365 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934834Ab1ESVeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fU/i5uAdo3kuKJKm1XPX/DGUX7MHtGiaRuVugBgoc62ECeJjY04KUqfFArkwYr97tG
         csFKG66mJvJ92a1NNZZ8ZvTT4GrdM12lhDcpCs9kE7b6T0tLMCehMtISCurFR0MJFx3S
         h51i/sYegaNV/YY1pUBpTpPtXAvKFPDS+3vLA=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Jim Cromie <jim.cromie@gmail.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 09/23] use register_chrdev_ids in drivers/staging/
Date: Thu, 19 May 2011 15:33:12 -0600
Message-Id: <1305840792-25877-10-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc: Greg Kroah-Hartman <gregkh@suse.de>
cc: devel@driverdev.osuosl.org
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c             |   15 ++++++---------
 drivers/staging/cs5535_gpio/cs5535_gpio.c        |   10 +---------
 drivers/staging/iio/industrialio-core.c          |    2 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c |    2 +-
 4 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index e7e72b8..55f831f 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1960,6 +1960,7 @@ static int __init comedi_init(void)
 {
 	int i;
 	int retval;
+	dev_t devt = MKDEV(COMEDI_MAJOR, 0);
 
 	printk(KERN_INFO "comedi: version " COMEDI_RELEASE
 	       " - http://www.comedi.org\n");
@@ -1983,24 +1984,21 @@ static int __init comedi_init(void)
 	memset(comedi_file_info_table, 0,
 	       sizeof(struct comedi_device_file_info *) * COMEDI_NUM_MINORS);
 
-	retval = register_chrdev_region(MKDEV(COMEDI_MAJOR, 0),
-					COMEDI_NUM_MINORS, "comedi");
+	retval = register_chrdev_ids(&devt, COMEDI_NUM_MINORS, "comedi");
 	if (retval)
 		return -EIO;
 	cdev_init(&comedi_cdev, &comedi_fops);
 	comedi_cdev.owner = THIS_MODULE;
 	kobject_set_name(&comedi_cdev.kobj, "comedi");
-	if (cdev_add(&comedi_cdev, MKDEV(COMEDI_MAJOR, 0), COMEDI_NUM_MINORS)) {
-		unregister_chrdev_region(MKDEV(COMEDI_MAJOR, 0),
-					 COMEDI_NUM_MINORS);
+	if (cdev_add(&comedi_cdev, devt, COMEDI_NUM_MINORS)) {
+		unregister_chrdev_region(devt, COMEDI_NUM_MINORS);
 		return -EIO;
 	}
 	comedi_class = class_create(THIS_MODULE, "comedi");
 	if (IS_ERR(comedi_class)) {
 		printk(KERN_ERR "comedi: failed to create class");
 		cdev_del(&comedi_cdev);
-		unregister_chrdev_region(MKDEV(COMEDI_MAJOR, 0),
-					 COMEDI_NUM_MINORS);
+		unregister_chrdev_region(devt, COMEDI_NUM_MINORS);
 		return PTR_ERR(comedi_class);
 	}
 
@@ -2014,8 +2012,7 @@ static int __init comedi_init(void)
 		if (minor < 0) {
 			comedi_cleanup_legacy_minors();
 			cdev_del(&comedi_cdev);
-			unregister_chrdev_region(MKDEV(COMEDI_MAJOR, 0),
-						 COMEDI_NUM_MINORS);
+			unregister_chrdev_region(devt, COMEDI_NUM_MINORS);
 			return minor;
 		}
 	}
diff --git a/drivers/staging/cs5535_gpio/cs5535_gpio.c b/drivers/staging/cs5535_gpio/cs5535_gpio.c
index b25f9d1..539a08a 100644
--- a/drivers/staging/cs5535_gpio/cs5535_gpio.c
+++ b/drivers/staging/cs5535_gpio/cs5535_gpio.c
@@ -223,15 +223,7 @@ static int __init cs5535_gpio_init(void)
 		return -ENODEV;
 	}
 
-	if (major) {
-		dev_id = MKDEV(major, 0);
-		retval = register_chrdev_region(dev_id, CS5535_GPIO_COUNT,
-						NAME);
-	} else {
-		retval = alloc_chrdev_region(&dev_id, 0, CS5535_GPIO_COUNT,
-					     NAME);
-		major = MAJOR(dev_id);
-	}
+	retval = register_chrdev_ids(&dev_id, CS5535_GPIO_COUNT, NAME);
 
 	if (retval) {
 		release_region(gpio_base, CS5535_GPIO_SIZE);
diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 1795ee1..1ef7198 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -443,7 +443,7 @@ static int __init iio_dev_init(void)
 {
 	int err;
 
-	err = alloc_chrdev_region(&iio_devt, 0, IIO_DEV_MAX, "iio");
+	err = register_chrdev_ids(&iio_devt, IIO_DEV_MAX, "iio");
 	if (err < 0)
 		printk(KERN_ERR "%s: failed to allocate char dev region\n",
 		       __FILE__);
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index c43c7e3..ec7773f 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -349,7 +349,7 @@ static int __devinit omap34_xx_bridge_probe(struct platform_device *pdev)
 		goto err1;
 
 	/* use 2.6 device model */
-	err = alloc_chrdev_region(&dev, 0, 1, driver_name);
+	err = register_chrdev_ids(&dev, 1, driver_name);
 	if (err) {
 		pr_err("%s: Can't get major %d\n", __func__, driver_major);
 		goto err1;
-- 
1.7.4.4

