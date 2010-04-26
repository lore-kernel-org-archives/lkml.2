Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab0DZTcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:32:05 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51607 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab0DZT2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:31 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 05/19] staging: iio: Move from class to bus
Date: Mon, 26 Apr 2010 20:31:07 +0100
Message-Id: <1272310281-7418-6-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-5-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-3-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-4-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-5-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/iio.h                  |    2 +-
 drivers/staging/iio/industrialio-core.c    |   28 +++++++++++-----------------
 drivers/staging/iio/industrialio-ring.c    |    2 +-
 drivers/staging/iio/industrialio-trigger.c |    2 +-
 drivers/staging/iio/ring_sw.c              |    2 +-
 5 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/iio/iio.h b/drivers/staging/iio/iio.h
index a12072a..fcee47c 100644
--- a/drivers/staging/iio/iio.h
+++ b/drivers/staging/iio/iio.h
@@ -377,7 +377,7 @@ void iio_deallocate_chrdev(struct iio_handler *handler);
 #define IIO_UNSIGNED(a) (a)
 
 extern dev_t iio_devt;
-extern struct class iio_class;
+extern struct bus_type iio_bus_type;
 
 /**
  * iio_put_device() - reference counted deallocation of struct device
diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 37f58f6..c19a080 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -42,16 +42,10 @@ dev_t iio_devt;
 EXPORT_SYMBOL(iio_devt);
 
 #define IIO_DEV_MAX 256
-static char *iio_devnode(struct device *dev, mode_t *mode)
-{
-	return kasprintf(GFP_KERNEL, "iio/%s", dev_name(dev));
-}
-
-struct class iio_class = {
+struct bus_type iio_bus_type = {
 	.name = "iio",
-	.devnode = iio_devnode,
 };
-EXPORT_SYMBOL(iio_class);
+EXPORT_SYMBOL(iio_bus_type);
 
 void __iio_change_event(struct iio_detected_event_list *ev,
 			int ev_code,
@@ -405,7 +399,7 @@ int iio_setup_ev_int(struct iio_event_interface *ev_int,
 {
 	int ret, minor;
 
-	ev_int->dev.class = &iio_class;
+	ev_int->dev.bus = &iio_bus_type;
 	ev_int->dev.parent = dev;
 	ev_int->dev.type = &iio_event_type;
 	device_initialize(&ev_int->dev);
@@ -478,23 +472,23 @@ static int __init iio_init(void)
 {
 	int ret;
 
-	/* Create sysfs class */
-	ret  = class_register(&iio_class);
+	/* Register sysfs bus */
+	ret  = bus_register(&iio_bus_type);
 	if (ret < 0) {
 		printk(KERN_ERR
-		       "%s could not create sysfs class\n",
+		       "%s could not register bus type\n",
 			__FILE__);
 		goto error_nothing;
 	}
 
 	ret = iio_dev_init();
 	if (ret < 0)
-		goto error_unregister_class;
+		goto error_unregister_bus_type;
 
 	return 0;
 
-error_unregister_class:
-	class_unregister(&iio_class);
+error_unregister_bus_type:
+	bus_unregister(&iio_bus_type);
 error_nothing:
 	return ret;
 }
@@ -502,7 +496,7 @@ error_nothing:
 static void __exit iio_exit(void)
 {
 	iio_dev_exit();
-	class_unregister(&iio_class);
+	bus_unregister(&iio_bus_type);
 }
 
 static int iio_device_register_sysfs(struct iio_dev *dev_info)
@@ -768,7 +762,7 @@ struct iio_dev *iio_allocate_device(void)
 
 	if (dev) {
 		dev->dev.type = &iio_dev_type;
-		dev->dev.class = &iio_class;
+		dev->dev.bus = &iio_bus_type;
 		device_initialize(&dev->dev);
 		dev_set_drvdata(&dev->dev, (void *)dev);
 		mutex_init(&dev->mlock);
diff --git a/drivers/staging/iio/industrialio-ring.c b/drivers/staging/iio/industrialio-ring.c
index e53e214..44d4894 100644
--- a/drivers/staging/iio/industrialio-ring.c
+++ b/drivers/staging/iio/industrialio-ring.c
@@ -210,7 +210,7 @@ __iio_request_ring_buffer_access_chrdev(struct iio_ring_buffer *buf,
 	buf->access_handler.flags = 0;
 
 	buf->access_dev.parent = &buf->dev;
-	buf->access_dev.class = &iio_class;
+	buf->access_dev.bus = &iio_bus_type;
 	buf->access_dev.type = &iio_ring_access_type;
 	device_initialize(&buf->access_dev);
 
diff --git a/drivers/staging/iio/industrialio-trigger.c b/drivers/staging/iio/industrialio-trigger.c
index 35ec80b..8fb2f9d 100644
--- a/drivers/staging/iio/industrialio-trigger.c
+++ b/drivers/staging/iio/industrialio-trigger.c
@@ -362,7 +362,7 @@ struct iio_trigger *iio_allocate_trigger(void)
 	trig = kzalloc(sizeof *trig, GFP_KERNEL);
 	if (trig) {
 		trig->dev.type = &iio_trig_type;
-		trig->dev.class = &iio_class;
+		trig->dev.bus = &iio_bus_type;
 		device_initialize(&trig->dev);
 		dev_set_drvdata(&trig->dev, (void *)trig);
 		spin_lock_init(&trig->pollfunc_list_lock);
diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
index b104c3d..3f82f2d 100644
--- a/drivers/staging/iio/ring_sw.c
+++ b/drivers/staging/iio/ring_sw.c
@@ -416,7 +416,7 @@ struct iio_ring_buffer *iio_sw_rb_allocate(struct iio_dev *indio_dev)
 	buf->dev.type = &iio_sw_ring_type;
 	device_initialize(&buf->dev);
 	buf->dev.parent = &indio_dev->dev;
-	buf->dev.class = &iio_class;
+	buf->dev.bus = &iio_bus_type;
 	dev_set_drvdata(&buf->dev, (void *)buf);
 
 	return buf;
-- 
1.6.4.4

