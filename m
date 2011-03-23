Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab1CWMP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:15:56 -0400
Received: from realvnc.com ([146.101.152.142]:46236 "EHLO realvnc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab1CWMPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:15:54 -0400
Message-ID: <4D89E479.7000100@realvnc.com>
Date: Wed, 23 Mar 2011 12:15:53 +0000
From: Toby Gray <toby.gray@realvnc.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: cdc-acm: Prevent data loss when filling tty buffer.
References: <1300722745-2404-1-git-send-email-toby.gray@realvnc.com> <201103220843.35983.oneukum@suse.de>
In-Reply-To: <201103220843.35983.oneukum@suse.de>
Content-Type: multipart/mixed;
 boundary="------------090906060409000709020902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090906060409000709020902
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 22/03/2011 07:43, Oliver Neukum wrote:
> Have you tested whether the driver recovers from running out of buffers?
> Other than that it is looking good to me.
I had tested the driver running out of buffers quite extensively, but I 
think I must have just been lucky with the timings. Now that I've had a 
look at the code in more detail, I believe it would be possible for a 
throttle/unthrottle not to occur, in which case no more new URB reads 
would be submitted.

I've attached a v3 version of the patch which ensures that either the 
tty is throttled or the tasklet is rescheduled. I assume that it would 
be preferable to wait until Johan Hovold's '[PATCH 16/16] USB: cdc-acm: 
re-write read processing' has been submitted and then for me to submit 
another similar patch to this one, but which doesn't need the rx tasklet.

I decided it was still worth attaching the patch as it'll allow people 
to fix this issue on older kernel versions

Regards,

Toby

--------------090906060409000709020902
Content-Type: text/x-patch;
 name="0001-USB-cdc-acm-Prevent-data-loss-when-filling-tty-buffe.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-USB-cdc-acm-Prevent-data-loss-when-filling-tty-buffe.pa";
 filename*1="tch"

>From 26854b4dfafed835f28e43b0eb5d3d6a5ce9d1bd Mon Sep 17 00:00:00 2001
From: Toby Gray <toby.gray@realvnc.com>
Date: Mon, 21 Mar 2011 12:41:44 +0000
Subject: [PATCH] USB: cdc-acm: Prevent data loss when filling tty buffer.

When sending large quantities of data through a CDC ACM channel it is possible
for data to be lost when attempting to copy the data to the tty buffer. This
occurs due to the return value from tty_insert_flip_string not being checked.

This patch adds checking for how many bytes have been inserted into the tty
buffer and returns any remaining bytes back to the filled read buffer list.

v1 - Initial patch that used memmove on remaining data.
v2 - Removed the use of memmove, using a buffer offset instead.
v3 - Adding extra throttling check to ensure wake-up after throttling.

Signed-off-by: Toby Gray <toby.gray@realvnc.com>
---
 drivers/usb/class/cdc-acm.c |   75 +++++++++++++++++++++++++++++++++++++-----
 drivers/usb/class/cdc-acm.h |    4 ++-
 2 files changed, 69 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index f492a7f..8fe569a 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -363,6 +363,7 @@ static void acm_read_bulk(struct urb *urb)
 		dev_dbg(&acm->data->dev, "bulk rx status %d\n", status);
 
 	buf = rcv->buffer;
+	buf->head = buf->base;
 	buf->size = urb->actual_length;
 
 	if (likely(status == 0)) {
@@ -392,6 +393,7 @@ static void acm_rx_tasklet(unsigned long _acm)
 	struct acm_ru *rcv;
 	unsigned long flags;
 	unsigned char throttled;
+	int copied;
 
 	dbg("Entering acm_rx_tasklet");
 
@@ -423,12 +425,14 @@ next_buffer:
 
 	dbg("acm_rx_tasklet: procesing buf 0x%p, size = %d", buf, buf->size);
 
+	copied = buf->size;
 	if (tty) {
 		spin_lock_irqsave(&acm->throttle_lock, flags);
 		throttled = acm->throttle;
 		spin_unlock_irqrestore(&acm->throttle_lock, flags);
 		if (!throttled) {
-			tty_insert_flip_string(tty, buf->base, buf->size);
+			copied = tty_insert_flip_string(tty,
+							buf->head, buf->size);
 			tty_flip_buffer_push(tty);
 		} else {
 			tty_kref_put(tty);
@@ -440,9 +444,24 @@ next_buffer:
 		}
 	}
 
-	spin_lock_irqsave(&acm->read_lock, flags);
-	list_add(&buf->list, &acm->spare_read_bufs);
-	spin_unlock_irqrestore(&acm->read_lock, flags);
+	buf->head += copied;
+	buf->size -= copied;
+
+	if (buf->size == 0) {
+		spin_lock_irqsave(&acm->read_lock, flags);
+		list_add(&buf->list, &acm->spare_read_bufs);
+		spin_unlock_irqrestore(&acm->read_lock, flags);
+	} else {
+		tty_kref_put(tty);
+		dbg("Partial buffer fill");
+		spin_lock_irqsave(&acm->read_lock, flags);
+		list_add(&buf->list, &acm->filled_read_bufs);
+		spin_unlock_irqrestore(&acm->read_lock, flags);
+		/* Make sure that the tasklet will get run again. */
+		schedule_work(&acm->work_throttle_check);
+		return;
+	}
+
 	goto next_buffer;
 
 urbs:
@@ -519,14 +538,14 @@ static void acm_write_bulk(struct urb *urb)
 	acm_write_done(acm, wb);
 	spin_unlock_irqrestore(&acm->write_lock, flags);
 	if (ACM_READY(acm))
-		schedule_work(&acm->work);
+		schedule_work(&acm->work_wake);
 	else
 		wake_up_interruptible(&acm->drain_wait);
 }
 
-static void acm_softint(struct work_struct *work)
+static void acm_softint_wake(struct work_struct *work)
 {
-	struct acm *acm = container_of(work, struct acm, work);
+	struct acm *acm = container_of(work, struct acm, work_wake);
 	struct tty_struct *tty;
 
 	dev_vdbg(&acm->data->dev, "tx work\n");
@@ -537,6 +556,42 @@ static void acm_softint(struct work_struct *work)
 	tty_kref_put(tty);
 }
 
+static void acm_softint_throttle_check(struct work_struct *work)
+{
+	struct acm *acm = container_of(work, struct acm, work_throttle_check);
+	struct tty_struct *tty;
+	struct acm_rb *buf;
+	size_t needed = 1;
+	int available;
+
+	dev_vdbg(&acm->data->dev, "throttle check\n");
+	if (!ACM_READY(acm))
+		return;
+	tty = tty_port_tty_get(&acm->port);
+	if (!tty)
+		return;
+
+	/* See how much space is needed */
+	spin_lock(&acm->read_lock);
+	if (!list_empty(&acm->filled_read_bufs)) {
+		buf = list_entry(acm->filled_read_bufs.next,
+				 struct acm_rb, list);
+		needed = buf->size;
+	}
+	spin_unlock(&acm->read_lock);
+
+	available = tty_buffer_request_room(tty, needed);
+	if (available < needed) {
+		/* Throttle so that notification occurs when there is
+		 * more space available in the buffers. */
+		tty_throttle(tty);
+	} else {
+		/* Buffer has already been emptied, restart reading */
+		tasklet_schedule(&acm->urb_task);
+	}
+	tty_kref_put(tty);
+}
+
 /*
  * TTY handlers
  */
@@ -1159,7 +1214,8 @@ made_compressed_probe:
 	acm->rx_buflimit = num_rx_buf;
 	acm->urb_task.func = acm_rx_tasklet;
 	acm->urb_task.data = (unsigned long) acm;
-	INIT_WORK(&acm->work, acm_softint);
+	INIT_WORK(&acm->work_wake, acm_softint_wake);
+	INIT_WORK(&acm->work_throttle_check, acm_softint_throttle_check);
 	init_waitqueue_head(&acm->drain_wait);
 	spin_lock_init(&acm->throttle_lock);
 	spin_lock_init(&acm->write_lock);
@@ -1316,6 +1372,7 @@ static void stop_data_traffic(struct acm *acm)
 	dbg("Entering stop_data_traffic");
 
 	tasklet_disable(&acm->urb_task);
+	cancel_work_sync(&acm->work_throttle_check);
 
 	usb_kill_urb(acm->ctrlurb);
 	for (i = 0; i < ACM_NW; i++)
@@ -1325,7 +1382,7 @@ static void stop_data_traffic(struct acm *acm)
 
 	tasklet_enable(&acm->urb_task);
 
-	cancel_work_sync(&acm->work);
+	cancel_work_sync(&acm->work_wake);
 }
 
 static void acm_disconnect(struct usb_interface *intf)
diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
index 5eeb570..b7cf391 100644
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -75,6 +75,7 @@ struct acm_rb {
 	struct list_head	list;
 	int			size;
 	unsigned char		*base;
+	unsigned char		*head;
 	dma_addr_t		dma;
 };
 
@@ -111,7 +112,8 @@ struct acm {
 	spinlock_t write_lock;
 	struct mutex mutex;
 	struct usb_cdc_line_coding line;		/* bits, stop, parity */
-	struct work_struct work;			/* work queue entry for line discipline waking up */
+	struct work_struct work_wake;			/* for tty wake up */
+	struct work_struct work_throttle_check;		/* for throttling */
 	wait_queue_head_t drain_wait;			/* close processing */
 	struct tasklet_struct urb_task;                 /* rx processing */
 	spinlock_t throttle_lock;			/* synchronize throtteling and read callback */
-- 
1.7.0.4


--------------090906060409000709020902--
