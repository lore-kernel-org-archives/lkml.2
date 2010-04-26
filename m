Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0DZT30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:29:26 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51643 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab0DZT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:33 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 16/19] Staging: IIO: Fix uses of spinlocks prior to init in ring implementations
Date: Mon, 26 Apr 2010 20:31:18 +0100
Message-Id: <1272310281-7418-17-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-16-git-send-email-jic23@cam.ac.uk>
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
 <1272310281-7418-14-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-15-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-16-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/industrialio-ring.c |    3 +++
 drivers/staging/iio/ring_generic.h      |    8 +++-----
 drivers/staging/iio/ring_sw.c           |   19 +++++++++++++------
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/iio/industrialio-ring.c b/drivers/staging/iio/industrialio-ring.c
index a8f0086..758b425 100644
--- a/drivers/staging/iio/industrialio-ring.c
+++ b/drivers/staging/iio/industrialio-ring.c
@@ -251,6 +251,9 @@ void iio_ring_buffer_init(struct iio_ring_buffer *ring,
 	ring->indio_dev = dev_info;
 	ring->ev_int.private = ring;
 	ring->access_handler.private = ring;
+	ring->shared_ev_pointer.ev_p = 0;
+	spin_lock_init(&ring->shared_ev_pointer.lock);
+
 }
 EXPORT_SYMBOL(iio_ring_buffer_init);
 
diff --git a/drivers/staging/iio/ring_generic.h b/drivers/staging/iio/ring_generic.h
index ea5727a..0e44375 100644
--- a/drivers/staging/iio/ring_generic.h
+++ b/drivers/staging/iio/ring_generic.h
@@ -134,19 +134,17 @@ void iio_ring_buffer_init(struct iio_ring_buffer *ring,
 			  struct iio_dev *dev_info);
 
 /**
- * __iio_init_ring_buffer() - initialize common elements of ring buffers
+ * __iio_update_ring_buffer() - update common elements of ring buffers
  * @ring:		ring buffer that is the event source
  * @bytes_per_datum:	size of individual datum including timestamp
  * @length:		number of datums in ring
  **/
-static inline void __iio_init_ring_buffer(struct iio_ring_buffer *ring,
-				 int bytes_per_datum, int length)
+static inline void __iio_update_ring_buffer(struct iio_ring_buffer *ring,
+					    int bytes_per_datum, int length)
 {
 	ring->bpd = bytes_per_datum;
 	ring->length = length;
 	ring->loopcount = 0;
-	ring->shared_ev_pointer.ev_p = 0;
-	spin_lock_init(&ring->shared_ev_pointer.lock);
 }
 
 /**
diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
index 3f82f2d..4e5134c 100644
--- a/drivers/staging/iio/ring_sw.c
+++ b/drivers/staging/iio/ring_sw.c
@@ -14,14 +14,13 @@
 #include <linux/workqueue.h>
 #include "ring_sw.h"
 
-static inline int __iio_init_sw_ring_buffer(struct iio_sw_ring_buffer *ring,
-					    int bytes_per_datum, int length)
+static inline int __iio_allocate_sw_ring_buffer(struct iio_sw_ring_buffer *ring,
+						int bytes_per_datum, int length)
+
 {
 	if ((length == 0) || (bytes_per_datum == 0))
 		return -EINVAL;
-
-	__iio_init_ring_buffer(&ring->buf, bytes_per_datum, length);
-	spin_lock_init(&ring->use_lock);
+	__iio_update_ring_buffer(&ring->buf, bytes_per_datum, length);
 	ring->data = kmalloc(length*ring->buf.bpd, GFP_KERNEL);
 	ring->read_p = 0;
 	ring->write_p = 0;
@@ -30,6 +29,11 @@ static inline int __iio_init_sw_ring_buffer(struct iio_sw_ring_buffer *ring,
 	return ring->data ? 0 : -ENOMEM;
 }
 
+static inline void __iio_init_sw_ring_buffer(struct iio_sw_ring_buffer *ring)
+{
+	spin_lock_init(&ring->use_lock);
+}
+
 static inline void __iio_free_sw_ring_buffer(struct iio_sw_ring_buffer *ring)
 {
 	kfree(ring->data);
@@ -320,7 +324,9 @@ int iio_request_update_sw_rb(struct iio_ring_buffer *r)
 		goto error_ret;
 	}
 	__iio_free_sw_ring_buffer(ring);
-	ret = __iio_init_sw_ring_buffer(ring, ring->buf.bpd, ring->buf.length);
+	ret = __iio_allocate_sw_ring_buffer(ring, ring->buf.bpd,
+					    ring->buf.length);
+
 error_ret:
 	spin_unlock(&ring->use_lock);
 	return ret;
@@ -413,6 +419,7 @@ struct iio_ring_buffer *iio_sw_rb_allocate(struct iio_dev *indio_dev)
 	buf = &ring->buf;
 
 	iio_ring_buffer_init(buf, indio_dev);
+	__iio_init_sw_ring_buffer(ring);
 	buf->dev.type = &iio_sw_ring_type;
 	device_initialize(&buf->dev);
 	buf->dev.parent = &indio_dev->dev;
-- 
1.6.4.4

