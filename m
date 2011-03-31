Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab1CaOw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:52:58 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57391 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab1CaOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 04/21] staging:iio: remove ability to escalate events.
Date: Thu, 31 Mar 2011 15:53:58 +0100
Message-Id: <1301583255-28468-5-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whilst it is possible to output events to say buffers have passed
a particular level there are no obvious reasons to actually do so.

The upshot of this patch is that buffers will only ever have
one threshold turned on at a time.

This will need to propogated into some drivers (e.g. sca3000)

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/chrdev.h            |   13 -------------
 drivers/staging/iio/iio.h               |   16 ++--------------
 drivers/staging/iio/industrialio-core.c |   30 ++----------------------------
 drivers/staging/iio/industrialio-ring.c |   23 ++---------------------
 drivers/staging/iio/ring_generic.h      |    3 ---
 drivers/staging/iio/ring_sw.c           |   14 +-------------
 6 files changed, 7 insertions(+), 92 deletions(-)

diff --git a/drivers/staging/iio/chrdev.h b/drivers/staging/iio/chrdev.h
index 95b439e..c1e86a9 100644
--- a/drivers/staging/iio/chrdev.h
+++ b/drivers/staging/iio/chrdev.h
@@ -45,23 +45,10 @@ struct iio_event_data {
  * struct iio_detected_event_list - list element for events that have occured
  * @list:		linked list header
  * @ev:			the event itself
- * @shared_pointer:	used when the event is shared - i.e. can be escallated
- *			on demand (eg ring buffer 50%->100% full)
  */
 struct iio_detected_event_list {
 	struct list_head		list;
 	struct iio_event_data		ev;
-	struct iio_shared_ev_pointer	*shared_pointer;
-};
-/**
- * struct iio_shared_ev_pointer - allows shared events to identify if currently
- *				in the detected event list
- * @ev_p:	pointer to detected event list element (null if not in list)
- * @lock:	protect this element to prevent simultaneous edit and remove
- */
-struct iio_shared_ev_pointer {
-	struct iio_detected_event_list	*ev_p;
-	spinlock_t			lock;
 };
 
 /**
diff --git a/drivers/staging/iio/iio.h b/drivers/staging/iio/iio.h
index 578d078..1496f0b 100644
--- a/drivers/staging/iio/iio.h
+++ b/drivers/staging/iio/iio.h
@@ -346,22 +346,10 @@ int iio_push_event(struct iio_dev *dev_info,
  * @ev_int:		the event interface to which we are pushing the event
  * @ev_code:		the outgoing event code
  * @timestamp:		timestamp of the event
- * @shared_pointer_p:	the shared event pointer
  **/
 int __iio_push_event(struct iio_event_interface *ev_int,
-		    int ev_code,
-		    s64 timestamp,
-		    struct iio_shared_ev_pointer*
-		    shared_pointer_p);
-/**
- * __iio_change_event() - change an event code in case of event escalation
- * @ev:			the event to be changed
- * @ev_code:		new event code
- * @timestamp:		new timestamp
- **/
-void __iio_change_event(struct iio_detected_event_list *ev,
-			int ev_code,
-			s64 timestamp);
+		     int ev_code,
+		     s64 timestamp);
 
 /**
  * iio_setup_ev_int() - configure an event interface (chrdev)
diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 809588f..5b7b5df 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -66,15 +66,6 @@ static const char * const iio_chan_info_postfix[] = {
 	[IIO_CHAN_INFO_CALIBBIAS_SHARED/2] = "calibbias",
 };
 
-void __iio_change_event(struct iio_detected_event_list *ev,
-			int ev_code,
-			s64 timestamp)
-{
-	ev->ev.id = ev_code;
-	ev->ev.timestamp = timestamp;
-}
-EXPORT_SYMBOL(__iio_change_event);
-
 /* Used both in the interrupt line put events and the ring buffer ones */
 
 /* Note that in it's current form someone has to be listening before events
@@ -83,9 +74,7 @@ EXPORT_SYMBOL(__iio_change_event);
  */
 int __iio_push_event(struct iio_event_interface *ev_int,
 		     int ev_code,
-		     s64 timestamp,
-		     struct iio_shared_ev_pointer *
-		     shared_pointer_p)
+		     s64 timestamp)
 {
 	struct iio_detected_event_list *ev;
 	int ret = 0;
@@ -105,9 +94,6 @@ int __iio_push_event(struct iio_event_interface *ev_int,
 		}
 		ev->ev.id = ev_code;
 		ev->ev.timestamp = timestamp;
-		ev->shared_pointer = shared_pointer_p;
-		if (ev->shared_pointer)
-			shared_pointer_p->ev_p = ev;
 
 		list_add_tail(&ev->list, &ev_int->det_events.list);
 		ev_int->current_events++;
@@ -127,7 +113,7 @@ int iio_push_event(struct iio_dev *dev_info,
 		   s64 timestamp)
 {
 	return __iio_push_event(&dev_info->event_interfaces[ev_line],
-				ev_code, timestamp, NULL);
+				ev_code, timestamp);
 }
 EXPORT_SYMBOL(iio_push_event);
 
@@ -295,18 +281,6 @@ static ssize_t iio_event_chrdev_read(struct file *filep,
 	list_del(&el->list);
 	ev_int->current_events--;
 	mutex_unlock(&ev_int->event_list_lock);
-	/*
-	 * Possible concurency issue if an update of this event is on its way
-	 * through. May lead to new event being removed whilst the reported
-	 * event was the unescalated event. In typical use case this is not a
-	 * problem as userspace will say read half the buffer due to a 50%
-	 * full event which would make the correct 100% full incorrect anyway.
-	 */
-	if (el->shared_pointer) {
-		spin_lock(&el->shared_pointer->lock);
-		(el->shared_pointer->ev_p) = NULL;
-		spin_unlock(&el->shared_pointer->lock);
-	}
 	kfree(el);
 
 	return len;
diff --git a/drivers/staging/iio/industrialio-ring.c b/drivers/staging/iio/industrialio-ring.c
index 1dfbc6e..466b9fa 100644
--- a/drivers/staging/iio/industrialio-ring.c
+++ b/drivers/staging/iio/industrialio-ring.c
@@ -27,28 +27,11 @@ int iio_push_ring_event(struct iio_ring_buffer *ring_buf,
 		       s64 timestamp)
 {
 	return __iio_push_event(&ring_buf->ev_int,
-			       event_code,
-			       timestamp,
-			       &ring_buf->shared_ev_pointer);
+				event_code,
+				timestamp);
 }
 EXPORT_SYMBOL(iio_push_ring_event);
 
-int iio_push_or_escallate_ring_event(struct iio_ring_buffer *ring_buf,
-				    int event_code,
-				    s64 timestamp)
-{
-	if (ring_buf->shared_ev_pointer.ev_p)
-		__iio_change_event(ring_buf->shared_ev_pointer.ev_p,
-				   event_code,
-				   timestamp);
-	else
-		return iio_push_ring_event(ring_buf,
-					  event_code,
-					  timestamp);
-	return 0;
-}
-EXPORT_SYMBOL(iio_push_or_escallate_ring_event);
-
 /**
  * iio_ring_open() - chrdev file open for ring buffer access
  *
@@ -228,8 +211,6 @@ void iio_ring_buffer_init(struct iio_ring_buffer *ring,
 	ring->indio_dev = dev_info;
 	ring->ev_int.private = ring;
 	ring->access_handler.private = ring;
-	ring->shared_ev_pointer.ev_p = NULL;
-	spin_lock_init(&ring->shared_ev_pointer.lock);
 }
 EXPORT_SYMBOL(iio_ring_buffer_init);
 
diff --git a/drivers/staging/iio/ring_generic.h b/drivers/staging/iio/ring_generic.h
index 6c7e073..320a11d 100644
--- a/drivers/staging/iio/ring_generic.h
+++ b/drivers/staging/iio/ring_generic.h
@@ -107,8 +107,6 @@ struct iio_ring_access_funcs {
  * @scan_timestamp:	[INTERN] does the scan mode include a timestamp
  * @access_handler:	[INTERN] chrdev access handling
  * @ev_int:		[INTERN] chrdev interface for the event chrdev
- * @shared_ev_pointer:	[INTERN] the shared event pointer to allow escalation of
- *			events
  * @access:		[DRIVER] ring access functions associated with the
  *			implementation.
  * @preenable:		[DRIVER] function to run prior to marking ring enabled
@@ -133,7 +131,6 @@ struct iio_ring_buffer {
 	bool				scan_timestamp;
 	struct iio_handler		access_handler;
 	struct iio_event_interface	ev_int;
-	struct iio_shared_ev_pointer	shared_ev_pointer;
 	struct iio_ring_access_funcs	access;
 	int				(*preenable)(struct iio_dev *);
 	int				(*postenable)(struct iio_dev *);
diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
index ea0015e..0004814 100644
--- a/drivers/staging/iio/ring_sw.c
+++ b/drivers/staging/iio/ring_sw.c
@@ -123,14 +123,6 @@ static int iio_store_to_sw_ring(struct iio_sw_ring_buffer *ring,
 		 */
 		if (change_test_ptr == ring->read_p)
 			ring->read_p = temp_ptr;
-
-		spin_lock(&ring->buf.shared_ev_pointer.lock);
-
-		ret = iio_push_or_escallate_ring_event(&ring->buf,
-			       IIO_EVENT_CODE_RING_100_FULL, timestamp);
-		spin_unlock(&ring->buf.shared_ev_pointer.lock);
-		if (ret)
-			goto error_ret;
 	}
 	/* investigate if our event barrier has been passed */
 	/* There are definite 'issues' with this and chances of
@@ -140,15 +132,11 @@ static int iio_store_to_sw_ring(struct iio_sw_ring_buffer *ring,
 	if (ring->half_p == ring->data + ring->buf.length*ring->buf.bytes_per_datum)
 		ring->half_p = ring->data;
 	if (ring->half_p == ring->read_p) {
-		spin_lock(&ring->buf.shared_ev_pointer.lock);
 		code = IIO_EVENT_CODE_RING_50_FULL;
 		ret = __iio_push_event(&ring->buf.ev_int,
 				       code,
-				       timestamp,
-				       &ring->buf.shared_ev_pointer);
-		spin_unlock(&ring->buf.shared_ev_pointer.lock);
+				       timestamp);
 	}
-error_ret:
 	return ret;
 }
 
-- 
1.7.3.4

