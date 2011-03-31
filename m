Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab1CaO51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:57:27 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57397 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058Ab1CaOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 06/21] staging:iio: remove legacy event chrdev for the buffers
Date: Thu, 31 Mar 2011 15:54:00 +0100
Message-Id: <1301583255-28468-7-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/industrialio-ring.c |   58 +------------------------------
 drivers/staging/iio/ring_generic.h      |   25 -------------
 drivers/staging/iio/ring_sw.c           |    5 ---
 3 files changed, 1 insertions(+), 87 deletions(-)

diff --git a/drivers/staging/iio/industrialio-ring.c b/drivers/staging/iio/industrialio-ring.c
index 464fec2..b503ea1 100644
--- a/drivers/staging/iio/industrialio-ring.c
+++ b/drivers/staging/iio/industrialio-ring.c
@@ -23,16 +23,6 @@
 #include "iio.h"
 #include "ring_generic.h"
 
-int iio_push_ring_event(struct iio_ring_buffer *ring_buf,
-		       int event_code,
-		       s64 timestamp)
-{
-	return __iio_push_event(&ring_buf->ev_int,
-				event_code,
-				timestamp);
-}
-EXPORT_SYMBOL(iio_push_ring_event);
-
 /**
  * iio_ring_open() - chrdev file open for ring buffer access
  *
@@ -116,43 +106,6 @@ static const struct file_operations iio_ring_fileops = {
 	.llseek = noop_llseek,
 };
 
-/**
- * __iio_request_ring_buffer_event_chrdev() - allocate ring event chrdev
- * @buf:	ring buffer whose event chrdev we are allocating
- * @id:		id of this ring buffer (typically 0)
- * @owner:	the module who owns the ring buffer (for ref counting)
- * @dev:	device with which the chrdev is associated
- **/
-static inline int
-__iio_request_ring_buffer_event_chrdev(struct iio_ring_buffer *buf,
-				       int id,
-				       struct module *owner,
-				       struct device *dev)
-{
-	int ret;
-
-	snprintf(buf->ev_int._name, sizeof(buf->ev_int._name),
-		 "%s:event%d",
-		 dev_name(&buf->dev),
-		 id);
-	ret = iio_setup_ev_int(&(buf->ev_int),
-			       buf->ev_int._name,
-			       owner,
-			       dev);
-	if (ret)
-		goto error_ret;
-	return 0;
-
-error_ret:
-	return ret;
-}
-
-static inline void
-__iio_free_ring_buffer_event_chrdev(struct iio_ring_buffer *buf)
-{
-	iio_free_ev_int(&(buf->ev_int));
-}
-
 static void iio_ring_access_release(struct device *dev)
 {
 	struct iio_ring_buffer *buf
@@ -227,7 +180,6 @@ void iio_ring_buffer_init(struct iio_ring_buffer *ring,
 	if (ring->access.mark_param_change)
 		ring->access.mark_param_change(ring);
 	ring->indio_dev = dev_info;
-	ring->ev_int.private = ring;
 	ring->access_handler.private = ring;
 	init_waitqueue_head(&ring->pollq);
 }
@@ -399,19 +351,12 @@ int iio_ring_buffer_register_ex(struct iio_ring_buffer *ring, int id,
 	if (ret)
 		goto error_ret;
 
-	ret = __iio_request_ring_buffer_event_chrdev(ring,
-						     0,
-						     ring->owner,
-						     &ring->dev);
-	if (ret)
-		goto error_remove_device;
-
 	ret = __iio_request_ring_buffer_access_chrdev(ring,
 						      0,
 						      ring->owner);
 
 	if (ret)
-		goto error_ret;
+		goto error_remove_device;
 
 	if (ring->scan_el_attrs) {
 		ret = sysfs_create_group(&ring->dev.kobj,
@@ -462,7 +407,6 @@ void iio_ring_buffer_unregister(struct iio_ring_buffer *ring)
 {
 	__iio_ring_attr_cleanup(ring);
 	__iio_free_ring_buffer_access_chrdev(ring);
-	__iio_free_ring_buffer_event_chrdev(ring);
 	device_del(&ring->dev);
 }
 EXPORT_SYMBOL(iio_ring_buffer_unregister);
diff --git a/drivers/staging/iio/ring_generic.h b/drivers/staging/iio/ring_generic.h
index 37b5eda..44c7543 100644
--- a/drivers/staging/iio/ring_generic.h
+++ b/drivers/staging/iio/ring_generic.h
@@ -16,29 +16,6 @@
 struct iio_ring_buffer;
 
 /**
- * iio_push_ring_event() - ring buffer specific push to event chrdev
- * @ring_buf:		ring buffer that is the event source
- * @event_code:		event indentification code
- * @timestamp:		time of event
- **/
-int iio_push_ring_event(struct iio_ring_buffer *ring_buf,
-			int event_code,
-			s64 timestamp);
-/**
- * iio_push_or_escallate_ring_event() -	escalate or add as appropriate
- * @ring_buf:		ring buffer that is the event source
- * @event_code:		event indentification code
- * @timestamp:		time of event
- *
- * Typical usecase is to escalate a 50% ring full to 75% full if noone has yet
- * read the first event. Clearly the 50% full is no longer of interest in
- * typical use case.
- **/
-int iio_push_or_escallate_ring_event(struct iio_ring_buffer *ring_buf,
-				     int event_code,
-				     s64 timestamp);
-
-/**
  * struct iio_ring_access_funcs - access functions for ring buffers.
  * @mark_in_use:	reference counting, typically to prevent module removal
  * @unmark_in_use:	reduce reference count when no longer using ring buffer
@@ -106,7 +83,6 @@ struct iio_ring_access_funcs {
  * @scan_mask:		[INTERN] bitmask used in masking scan mode elements
  * @scan_timestamp:	[INTERN] does the scan mode include a timestamp
  * @access_handler:	[INTERN] chrdev access handling
- * @ev_int:		[INTERN] chrdev interface for the event chrdev
  * @access:		[DRIVER] ring access functions associated with the
  *			implementation.
  * @preenable:		[DRIVER] function to run prior to marking ring enabled
@@ -130,7 +106,6 @@ struct iio_ring_buffer {
 	u32				scan_mask;
 	bool				scan_timestamp;
 	struct iio_handler		access_handler;
-	struct iio_event_interface	ev_int;
 	struct iio_ring_access_funcs	access;
 	int				(*preenable)(struct iio_dev *);
 	int				(*postenable)(struct iio_dev *);
diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
index 53c6774..a429a3d 100644
--- a/drivers/staging/iio/ring_sw.c
+++ b/drivers/staging/iio/ring_sw.c
@@ -69,7 +69,6 @@ static int iio_store_to_sw_ring(struct iio_sw_ring_buffer *ring,
 				unsigned char *data, s64 timestamp)
 {
 	int ret = 0;
-	int code;
 	unsigned char *temp_ptr, *change_test_ptr;
 
 	/* initial store */
@@ -133,10 +132,6 @@ static int iio_store_to_sw_ring(struct iio_sw_ring_buffer *ring,
 	if (ring->half_p == ring->data + ring->buf.length*ring->buf.bytes_per_datum)
 		ring->half_p = ring->data;
 	if (ring->half_p == ring->read_p) {
-		code = IIO_EVENT_CODE_RING_50_FULL;
-		ret = __iio_push_event(&ring->buf.ev_int,
-				       code,
-				       timestamp);
 		ring->buf.stufftoread = true;
 		wake_up_interruptible(&ring->buf.pollq);
 	}
-- 
1.7.3.4

