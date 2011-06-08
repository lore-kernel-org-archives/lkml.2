Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab1FHPir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 11:38:47 -0400
Received: from realvnc.com ([146.101.152.142]:47420 "EHLO realvnc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab1FHPip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 11:38:45 -0400
From: Toby Gray <toby.gray@realvnc.com>
To: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Toby Gray <toby.gray@realvnc.com>
Subject: [PATCH] USB: cdc-acm: Prevent loss of data when filling tty buffer
Date: Wed,  8 Jun 2011 16:38:39 +0100
Message-Id: <1307547519-29246-1-git-send-email-toby.gray@realvnc.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sending large quantities of data through a CDC ACM channel it is possible
for data to be lost when attempting to copy the data to the tty buffer. This
occurs due to the return value from tty_insert_flip_string not being checked.

This patch adds checking for how many bytes have been inserted into the tty
buffer and places data which hasn't been inserted into a pending buffer list.
The pending buffer list is pushed to the tty buffer when the tty unthrottles

Signed-off-by: Toby Gray <toby.gray@realvnc.com>
---
 drivers/usb/class/cdc-acm.c |   95 ++++++++++++++++++++++++++++++++++++------
 drivers/usb/class/cdc-acm.h |    6 ++-
 2 files changed, 85 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 395a347..9f1d3ff 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -361,23 +361,65 @@ static int acm_submit_read_urbs(struct acm *acm, gfp_t mem_flags)
 	return 0;
 }
 
-static void acm_process_read_urb(struct acm *acm, struct urb *urb)
+static void acm_process_read_buf(struct acm *acm, struct acm_rb *rb)
 {
 	struct tty_struct *tty;
+	int copied;
 
-	if (!urb->actual_length)
+	if (!rb->size)
 		return;
 
 	tty = tty_port_tty_get(&acm->port);
-	if (!tty)
+	if (!tty) {
+		/* drop all data */
+		rb->size = 0;
 		return;
+	}
 
-	tty_insert_flip_string(tty, urb->transfer_buffer, urb->actual_length);
+	copied = tty_insert_flip_string(tty, rb->head, rb->size);
 	tty_flip_buffer_push(tty);
 
+	rb->head += copied;
+	rb->size -= copied;
+
 	tty_kref_put(tty);
 }
 
+static void acm_process_pending_read_bufs(struct acm *acm)
+{
+	unsigned long flags;
+	struct acm_rb *buf;
+
+	spin_lock_irqsave(&acm->read_lock, flags);
+	while (!list_empty(&acm->pending_read_bufs)) {
+		buf = list_entry(acm->pending_read_bufs.next,
+				 struct acm_rb, list);
+		list_del(&buf->list);
+		spin_unlock_irqrestore(&acm->read_lock, flags);
+
+		acm_process_read_buf(acm, buf);
+
+		spin_lock_irqsave(&acm->read_lock, flags);
+		if (buf->size > 0) {
+			/* Managed to fill tty buffer again, so readd to
+			 * the head before giving up. */
+			list_add(&buf->list, &acm->pending_read_bufs);
+			spin_unlock_irqrestore(&acm->read_lock, flags);
+			return;
+		}
+
+		set_bit(buf->index, &acm->read_urbs_free);
+	}
+	/* Submit any free urbs if not throttled */
+	if (!acm->throttled && !acm->susp_count) {
+		spin_unlock_irqrestore(&acm->read_lock, flags);
+		acm_submit_read_urbs(acm, GFP_KERNEL);
+	} else {
+		spin_unlock_irqrestore(&acm->read_lock, flags);
+	}
+	return;
+}
+
 static void acm_read_bulk_callback(struct urb *urb)
 {
 	struct acm_rb *rb = urb->context;
@@ -386,24 +428,52 @@ static void acm_read_bulk_callback(struct urb *urb)
 
 	dev_vdbg(&acm->data->dev, "%s - urb %d, len %d\n", __func__,
 					rb->index, urb->actual_length);
-	set_bit(rb->index, &acm->read_urbs_free);
 
 	if (!acm->dev) {
+		set_bit(rb->index, &acm->read_urbs_free);
 		dev_dbg(&acm->data->dev, "%s - disconnected\n", __func__);
 		return;
 	}
 	usb_mark_last_busy(acm->dev);
 
 	if (urb->status) {
+		set_bit(rb->index, &acm->read_urbs_free);
 		dev_dbg(&acm->data->dev, "%s - non-zero urb status: %d\n",
 							__func__, urb->status);
 		return;
 	}
-	acm_process_read_urb(acm, urb);
+	rb->head = urb->transfer_buffer;
+	rb->size = urb->actual_length;
 
-	/* throttle device if requested by tty */
 	spin_lock_irqsave(&acm->read_lock, flags);
-	acm->throttled = acm->throttle_req;
+
+	if (!list_empty(&acm->pending_read_bufs)) {
+		/* Data from previous reads is still pending, so
+		 * add to the end of that. */
+		list_add_tail(&rb->list, &acm->pending_read_bufs);
+	} else {
+		spin_unlock_irqrestore(&acm->read_lock, flags);
+
+		acm_process_read_buf(acm, rb);
+
+		spin_lock_irqsave(&acm->read_lock, flags);
+		/* Bulk endpoints are recommended by the ACM specification
+		 * to be used for hardware flow control. If bulk endpoints
+		 * are being used then check that all data was passed to
+		 * the tty.
+		 */
+		if (!acm->is_int_ep && rb->size > 0) {
+			/* acm->throttled might not yet be true as throttling is
+			 * detect by the ldisc handler, however it will be
+			 * detected eventually and therefore unthrottled.
+			 */
+			list_add_tail(&rb->list, &acm->pending_read_bufs);
+		} else {
+			set_bit(rb->index, &acm->read_urbs_free);
+		}
+	}
+
+	/* throttle device if requested by tty */
 	if (!acm->throttled && !acm->susp_count) {
 		spin_unlock_irqrestore(&acm->read_lock, flags);
 		acm_submit_read_urb(acm, rb->index, GFP_ATOMIC);
@@ -651,26 +721,22 @@ static void acm_tty_throttle(struct tty_struct *tty)
 		return;
 
 	spin_lock_irq(&acm->read_lock);
-	acm->throttle_req = 1;
+	acm->throttled = 1;
 	spin_unlock_irq(&acm->read_lock);
 }
 
 static void acm_tty_unthrottle(struct tty_struct *tty)
 {
 	struct acm *acm = tty->driver_data;
-	unsigned int was_throttled;
 
 	if (!ACM_READY(acm))
 		return;
 
 	spin_lock_irq(&acm->read_lock);
-	was_throttled = acm->throttled;
 	acm->throttled = 0;
-	acm->throttle_req = 0;
 	spin_unlock_irq(&acm->read_lock);
 
-	if (was_throttled)
-		acm_submit_read_urbs(acm, GFP_KERNEL);
+	acm_process_pending_read_bufs(acm);
 }
 
 static int acm_tty_break_ctl(struct tty_struct *tty, int state)
@@ -1078,6 +1144,7 @@ made_compressed_probe:
 	spin_lock_init(&acm->read_lock);
 	mutex_init(&acm->mutex);
 	acm->rx_endpoint = usb_rcvbulkpipe(usb_dev, epread->bEndpointAddress);
+	INIT_LIST_HEAD(&acm->pending_read_bufs);
 	acm->is_int_ep = usb_endpoint_xfer_int(epread);
 	if (acm->is_int_ep)
 		acm->bInterval = epread->bInterval;
diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
index ca7937f..995333b 100644
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -72,8 +72,10 @@ struct acm_wb {
 };
 
 struct acm_rb {
+	struct list_head	list;
 	int			size;
 	unsigned char		*base;
+	unsigned char		*head;
 	dma_addr_t		dma;
 	int			index;
 	struct acm		*instance;
@@ -96,6 +98,7 @@ struct acm {
 	struct acm_rb read_buffers[ACM_NR];
 	int rx_buflimit;
 	int rx_endpoint;
+	struct list_head pending_read_bufs;
 	spinlock_t read_lock;
 	int write_used;					/* number of non-empty write buffers */
 	int transmitting;
@@ -113,8 +116,7 @@ struct acm {
 	unsigned int susp_count;			/* number of suspended interfaces */
 	unsigned int combined_interfaces:1;		/* control and data collapsed */
 	unsigned int is_int_ep:1;			/* interrupt endpoints contrary to spec used */
-	unsigned int throttled:1;			/* actually throttled */
-	unsigned int throttle_req:1;			/* throttle requested */
+	unsigned int throttled:1;			/* tty is throttling */
 	u8 bInterval;
 	struct acm_wb *delayed_wb;			/* write queued for a device about to be woken */
 };
-- 
1.7.0.4

