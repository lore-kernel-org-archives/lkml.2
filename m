Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab1CaO5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:57:25 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57401 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab1CaOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 07/21] staging:iio: Buffer device flattening.
Date: Thu, 31 Mar 2011 15:54:01 +0100
Message-Id: <1301583255-28468-8-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given we now only have one device we don't need the extra layer any more.
Hence this patch removes it.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/industrialio-ring.c |   76 ++++++++++---------------------
 drivers/staging/iio/ring_generic.h      |    8 +---
 drivers/staging/iio/ring_sw.c           |    3 +-
 3 files changed, 28 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/iio/industrialio-ring.c b/drivers/staging/iio/industrialio-ring.c
index b503ea1..07d64bc 100644
--- a/drivers/staging/iio/industrialio-ring.c
+++ b/drivers/staging/iio/industrialio-ring.c
@@ -106,72 +106,60 @@ static const struct file_operations iio_ring_fileops = {
 	.llseek = noop_llseek,
 };
 
-static void iio_ring_access_release(struct device *dev)
+void iio_ring_access_release(struct device *dev)
 {
 	struct iio_ring_buffer *buf
-		= access_dev_to_iio_ring_buffer(dev);
+		= container_of(dev, struct iio_ring_buffer, dev);
 	cdev_del(&buf->access_handler.chrdev);
 	iio_device_free_chrdev_minor(MINOR(dev->devt));
 }
-
-static struct device_type iio_ring_access_type = {
-	.release = iio_ring_access_release,
-};
+EXPORT_SYMBOL(iio_ring_access_release);
 
 static inline int
-__iio_request_ring_buffer_access_chrdev(struct iio_ring_buffer *buf,
-					int id,
+__iio_request_ring_buffer_chrdev(struct iio_ring_buffer *buf,
 					struct module *owner)
 {
 	int ret, minor;
 
 	buf->access_handler.flags = 0;
 
-	buf->access_dev.parent = &buf->dev;
-	buf->access_dev.bus = &iio_bus_type;
-	buf->access_dev.type = &iio_ring_access_type;
-	device_initialize(&buf->access_dev);
+	buf->dev.bus = &iio_bus_type;
+	device_initialize(&buf->dev);
 
 	minor = iio_device_get_chrdev_minor();
 	if (minor < 0) {
 		ret = minor;
 		goto error_device_put;
 	}
-	buf->access_dev.devt = MKDEV(MAJOR(iio_devt), minor);
-
-
-	buf->access_id = id;
-
-	dev_set_name(&buf->access_dev, "%s:access%d",
-		     dev_name(&buf->dev),
-		     buf->access_id);
-	ret = device_add(&buf->access_dev);
+	buf->dev.devt = MKDEV(MAJOR(iio_devt), minor);
+	dev_set_name(&buf->dev, "%s:buffer%d",
+		     dev_name(buf->dev.parent),
+		     buf->id);
+	ret = device_add(&buf->dev);
 	if (ret < 0) {
-		printk(KERN_ERR "failed to add the ring access dev\n");
+		printk(KERN_ERR "failed to add the ring dev\n");
 		goto error_device_put;
 	}
-
 	cdev_init(&buf->access_handler.chrdev, &iio_ring_fileops);
 	buf->access_handler.chrdev.owner = owner;
-
-	ret = cdev_add(&buf->access_handler.chrdev, buf->access_dev.devt, 1);
+	ret = cdev_add(&buf->access_handler.chrdev, buf->dev.devt, 1);
 	if (ret) {
-		printk(KERN_ERR "failed to allocate ring access chrdev\n");
+		printk(KERN_ERR "failed to allocate ring chrdev\n");
 		goto error_device_unregister;
 	}
 	return 0;
 
 error_device_unregister:
-	device_unregister(&buf->access_dev);
+	device_unregister(&buf->dev);
 error_device_put:
-	put_device(&buf->access_dev);
+	put_device(&buf->dev);
 
 	return ret;
 }
 
-static void __iio_free_ring_buffer_access_chrdev(struct iio_ring_buffer *buf)
+static void __iio_free_ring_buffer_chrdev(struct iio_ring_buffer *buf)
 {
-	device_unregister(&buf->access_dev);
+	device_unregister(&buf->dev);
 }
 
 void iio_ring_buffer_init(struct iio_ring_buffer *ring,
@@ -344,36 +332,25 @@ int iio_ring_buffer_register_ex(struct iio_ring_buffer *ring, int id,
 
 	ring->id = id;
 
-	dev_set_name(&ring->dev, "%s:buffer%d",
-		     dev_name(ring->dev.parent),
-		     ring->id);
-	ret = device_add(&ring->dev);
-	if (ret)
-		goto error_ret;
-
-	ret = __iio_request_ring_buffer_access_chrdev(ring,
-						      0,
-						      ring->owner);
+	ret = __iio_request_ring_buffer_chrdev(ring, ring->owner);
 
 	if (ret)
-		goto error_remove_device;
-
+		goto error_ret;
 	if (ring->scan_el_attrs) {
 		ret = sysfs_create_group(&ring->dev.kobj,
 					 ring->scan_el_attrs);
 		if (ret) {
 			dev_err(&ring->dev,
 				"Failed to add sysfs scan elements\n");
-			goto error_free_ring_buffer_access_chrdev;
+			goto error_free_ring_buffer_chrdev;
 		}
 	} else if (channels) {
 		ret = sysfs_create_group(&ring->dev.kobj,
 					 &iio_scan_el_dummy_group);
 		if (ret)
-			goto error_free_ring_buffer_access_chrdev;
+			goto error_free_ring_buffer_chrdev;
 	}
 
-
 	INIT_LIST_HEAD(&ring->scan_el_dev_attr_list);
 	INIT_LIST_HEAD(&ring->scan_el_en_attr_list);
 	if (channels) {
@@ -388,10 +365,8 @@ int iio_ring_buffer_register_ex(struct iio_ring_buffer *ring, int id,
 	return 0;
 error_cleanup_dynamic:
 	__iio_ring_attr_cleanup(ring);
-error_free_ring_buffer_access_chrdev:
-	__iio_free_ring_buffer_access_chrdev(ring);
-error_remove_device:
-	device_del(&ring->dev);
+error_free_ring_buffer_chrdev:
+	__iio_free_ring_buffer_chrdev(ring);
 error_ret:
 	return ret;
 }
@@ -406,8 +381,7 @@ EXPORT_SYMBOL(iio_ring_buffer_register);
 void iio_ring_buffer_unregister(struct iio_ring_buffer *ring)
 {
 	__iio_ring_attr_cleanup(ring);
-	__iio_free_ring_buffer_access_chrdev(ring);
-	device_del(&ring->dev);
+	__iio_free_ring_buffer_chrdev(ring);
 }
 EXPORT_SYMBOL(iio_ring_buffer_unregister);
 
diff --git a/drivers/staging/iio/ring_generic.h b/drivers/staging/iio/ring_generic.h
index 44c7543..ba441d9 100644
--- a/drivers/staging/iio/ring_generic.h
+++ b/drivers/staging/iio/ring_generic.h
@@ -68,11 +68,9 @@ struct iio_ring_access_funcs {
 /**
  * struct iio_ring_buffer - general ring buffer structure
  * @dev:		ring buffer device struct
- * @access_dev:		system device struct for the chrdev
  * @indio_dev:		industrial I/O device structure
  * @owner:		module that owns the ring buffer (for ref counting)
  * @id:			unique id number
- * @access_id:		device id number
  * @length:		[DEVICE] number of datums in ring
  * @bytes_per_datum:	[DEVICE] size of individual datum including timestamp
  * @bpe:		[DEVICE] size of individual channel value
@@ -92,11 +90,9 @@ struct iio_ring_access_funcs {
   **/
 struct iio_ring_buffer {
 	struct device dev;
-	struct device access_dev;
 	struct iio_dev *indio_dev;
 	struct module *owner;
 	int				id;
-	int				access_id;
 	int				length;
 	int				bytes_per_datum;
 	int				bpe;
@@ -398,8 +394,6 @@ static inline void iio_put_ring_buffer(struct iio_ring_buffer *ring)
 
 #define to_iio_ring_buffer(d)			\
 	container_of(d, struct iio_ring_buffer, dev)
-#define access_dev_to_iio_ring_buffer(d)			\
-	container_of(d, struct iio_ring_buffer, access_dev)
 
 /**
  * iio_ring_buffer_register() - register the buffer with IIO core
@@ -416,6 +410,8 @@ int iio_ring_buffer_register_ex(struct iio_ring_buffer *ring, int id,
 				struct iio_chan_spec *channels,
 				int num_channels);
 
+void iio_ring_access_release(struct device *dev);
+
 /**
  * iio_ring_buffer_unregister() - unregister the buffer from IIO core
  * @ring: the buffer to be unregistered
diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
index a429a3d..5fbf5ff 100644
--- a/drivers/staging/iio/ring_sw.c
+++ b/drivers/staging/iio/ring_sw.c
@@ -375,6 +375,7 @@ EXPORT_SYMBOL(iio_mark_update_needed_sw_rb);
 static void iio_sw_rb_release(struct device *dev)
 {
 	struct iio_ring_buffer *r = to_iio_ring_buffer(dev);
+	iio_ring_access_release(&r->dev);
 	kfree(iio_to_sw_ring(r));
 }
 
@@ -416,9 +417,7 @@ struct iio_ring_buffer *iio_sw_rb_allocate(struct iio_dev *indio_dev)
 	iio_ring_buffer_init(buf, indio_dev);
 	__iio_init_sw_ring_buffer(ring);
 	buf->dev.type = &iio_sw_ring_type;
-	device_initialize(&buf->dev);
 	buf->dev.parent = &indio_dev->dev;
-	buf->dev.bus = &iio_bus_type;
 	dev_set_drvdata(&buf->dev, (void *)buf);
 
 	return buf;
-- 
1.7.3.4

