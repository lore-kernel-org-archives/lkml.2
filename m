Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0DZTa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:30:26 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51633 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab0DZT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:33 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 13/19] staging:iio: Remove naming via IDR's where no longer necessary under new abi.
Date: Mon, 26 Apr 2010 20:31:15 +0100
Message-Id: <1272310281-7418-14-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-13-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-3-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-4-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-5-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-6-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-7-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-8-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-9-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-10-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-11-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-12-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-13-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/accel/lis3l02dq_ring.c |    2 +-
 drivers/staging/iio/accel/sca3000_core.c   |    2 +-
 drivers/staging/iio/adc/max1363_ring.c     |    2 +-
 drivers/staging/iio/industrialio-ring.c    |   48 +++++++---------------------
 drivers/staging/iio/ring_generic.h         |    2 +-
 5 files changed, 16 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index bba4b09..7617da8 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -581,7 +581,7 @@ error_iio_sw_rb_free:
 
 int lis3l02dq_initialize_ring(struct iio_ring_buffer *ring)
 {
-	return iio_ring_buffer_register(ring);
+	return iio_ring_buffer_register(ring, 0);
 }
 
 void lis3l02dq_uninitialize_ring(struct iio_ring_buffer *ring)
diff --git a/drivers/staging/iio/accel/sca3000_core.c b/drivers/staging/iio/accel/sca3000_core.c
index 45e4777..9485b13 100644
--- a/drivers/staging/iio/accel/sca3000_core.c
+++ b/drivers/staging/iio/accel/sca3000_core.c
@@ -1338,7 +1338,7 @@ static int __devinit __sca3000_probe(struct spi_device *spi,
 	if (ret < 0)
 		goto error_free_dev;
 	regdone = 1;
-	ret = iio_ring_buffer_register(st->indio_dev->ring);
+	ret = iio_ring_buffer_register(st->indio_dev->ring, 0);
 	if (ret < 0)
 		goto error_unregister_dev;
 	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0) {
diff --git a/drivers/staging/iio/adc/max1363_ring.c b/drivers/staging/iio/adc/max1363_ring.c
index 6003f7e..f1e37f2 100644
--- a/drivers/staging/iio/adc/max1363_ring.c
+++ b/drivers/staging/iio/adc/max1363_ring.c
@@ -255,5 +255,5 @@ void max1363_uninitialize_ring(struct iio_ring_buffer *ring)
 
 int max1363_initialize_ring(struct iio_ring_buffer *ring)
 {
-	return iio_ring_buffer_register(ring);
+	return iio_ring_buffer_register(ring, 0);
 };
diff --git a/drivers/staging/iio/industrialio-ring.c b/drivers/staging/iio/industrialio-ring.c
index 07b996e..a8f0086 100644
--- a/drivers/staging/iio/industrialio-ring.c
+++ b/drivers/staging/iio/industrialio-ring.c
@@ -20,19 +20,11 @@
 #include <linux/poll.h>
 #include <linux/module.h>
 #include <linux/cdev.h>
-#include <linux/idr.h>
 #include <linux/slab.h>
 
 #include "iio.h"
 #include "ring_generic.h"
 
-/* IDR for ring buffer identifier */
-static DEFINE_IDR(iio_ring_idr);
-/* IDR for ring event identifier */
-static DEFINE_IDR(iio_ring_event_idr);
-/* IDR for ring access identifier */
-static DEFINE_IDR(iio_ring_access_idr);
-
 int iio_push_ring_event(struct iio_ring_buffer *ring_buf,
 		       int event_code,
 		       s64 timestamp)
@@ -158,11 +150,8 @@ __iio_request_ring_buffer_event_chrdev(struct iio_ring_buffer *buf,
 				       struct device *dev)
 {
 	int ret;
-	ret = iio_get_new_idr_val(&iio_ring_event_idr);
-	if (ret < 0)
-		goto error_ret;
-	else
-		buf->ev_int.id = ret;
+
+	buf->ev_int.id = id;
 
 	snprintf(buf->ev_int._name, sizeof(buf->ev_int._name),
 		 "%s:event%d",
@@ -173,11 +162,9 @@ __iio_request_ring_buffer_event_chrdev(struct iio_ring_buffer *buf,
 			       owner,
 			       dev);
 	if (ret)
-		goto error_free_id;
+		goto error_ret;
 	return 0;
 
-error_free_id:
-	iio_free_idr_val(&iio_ring_event_idr, buf->ev_int.id);
 error_ret:
 	return ret;
 }
@@ -186,7 +173,6 @@ static inline void
 __iio_free_ring_buffer_event_chrdev(struct iio_ring_buffer *buf)
 {
 	iio_free_ev_int(&(buf->ev_int));
-	iio_free_idr_val(&iio_ring_event_idr, buf->ev_int.id);
 }
 
 static void iio_ring_access_release(struct device *dev)
@@ -222,18 +208,16 @@ __iio_request_ring_buffer_access_chrdev(struct iio_ring_buffer *buf,
 	}
 	buf->access_dev.devt = MKDEV(MAJOR(iio_devt), minor);
 
-	ret = iio_get_new_idr_val(&iio_ring_access_idr);
-	if (ret < 0)
-		goto error_device_put;
-	else
-		buf->access_id = ret;
+
+	buf->access_id = id;
+
 	dev_set_name(&buf->access_dev, "%s:access%d",
 		     dev_name(&buf->dev),
 		     buf->access_id);
 	ret = device_add(&buf->access_dev);
 	if (ret < 0) {
 		printk(KERN_ERR "failed to add the ring access dev\n");
-		goto error_free_idr;
+		goto error_device_put;
 	}
 
 	cdev_init(&buf->access_handler.chrdev, &iio_ring_fileops);
@@ -245,10 +229,9 @@ __iio_request_ring_buffer_access_chrdev(struct iio_ring_buffer *buf,
 		goto error_device_unregister;
 	}
 	return 0;
+
 error_device_unregister:
 	device_unregister(&buf->access_dev);
-error_free_idr:
-	iio_free_idr_val(&iio_ring_access_idr, buf->access_id);
 error_device_put:
 	put_device(&buf->access_dev);
 
@@ -257,7 +240,6 @@ error_device_put:
 
 static void __iio_free_ring_buffer_access_chrdev(struct iio_ring_buffer *buf)
 {
-	iio_free_idr_val(&iio_ring_access_idr, buf->access_id);
 	device_unregister(&buf->access_dev);
 }
 
@@ -272,21 +254,18 @@ void iio_ring_buffer_init(struct iio_ring_buffer *ring,
 }
 EXPORT_SYMBOL(iio_ring_buffer_init);
 
-int iio_ring_buffer_register(struct iio_ring_buffer *ring)
+int iio_ring_buffer_register(struct iio_ring_buffer *ring, int id)
 {
 	int ret;
-	ret = iio_get_new_idr_val(&iio_ring_idr);
-	if (ret < 0)
-		goto error_ret;
-	else
-		ring->id = ret;
+
+	ring->id = id;
 
 	dev_set_name(&ring->dev, "%s:buffer%d",
 		     dev_name(ring->dev.parent),
 		     ring->id);
 	ret = device_add(&ring->dev);
 	if (ret)
-		goto error_free_id;
+		goto error_ret;
 
 	ret = __iio_request_ring_buffer_event_chrdev(ring,
 						     0,
@@ -307,8 +286,6 @@ error_free_ring_buffer_event_chrdev:
 	__iio_free_ring_buffer_event_chrdev(ring);
 error_remove_device:
 	device_del(&ring->dev);
-error_free_id:
-	iio_free_idr_val(&iio_ring_idr, ring->id);
 error_ret:
 	return ret;
 }
@@ -319,7 +296,6 @@ void iio_ring_buffer_unregister(struct iio_ring_buffer *ring)
 	__iio_free_ring_buffer_access_chrdev(ring);
 	__iio_free_ring_buffer_event_chrdev(ring);
 	device_del(&ring->dev);
-	iio_free_idr_val(&iio_ring_idr, ring->id);
 }
 EXPORT_SYMBOL(iio_ring_buffer_unregister);
 
diff --git a/drivers/staging/iio/ring_generic.h b/drivers/staging/iio/ring_generic.h
index c649b6d..ea5727a 100644
--- a/drivers/staging/iio/ring_generic.h
+++ b/drivers/staging/iio/ring_generic.h
@@ -261,7 +261,7 @@ static inline void iio_put_ring_buffer(struct iio_ring_buffer *ring)
 	container_of(d, struct iio_ring_buffer, dev)
 #define access_dev_to_iio_ring_buffer(d)			\
 	container_of(d, struct iio_ring_buffer, access_dev)
-int iio_ring_buffer_register(struct iio_ring_buffer *ring);
+int iio_ring_buffer_register(struct iio_ring_buffer *ring, int id);
 void iio_ring_buffer_unregister(struct iio_ring_buffer *ring);
 
 ssize_t iio_read_ring_length(struct device *dev,
-- 
1.6.4.4

