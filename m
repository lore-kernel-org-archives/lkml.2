Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2KTCHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 21:07:31 -0500
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60161 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab2KTCH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 21:07:29 -0500
From: Derek Basehore <dbasehore@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, msb@chromium.orq, bleung@chromium.org,
        taysom@chromium.org, Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH v2 2/2] block: prevent race/cleanup
Date: Mon, 19 Nov 2012 18:07:02 -0800
Message-Id: <1353377222-19541-2-git-send-email-dbasehore@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1353377222-19541-1-git-send-email-dbasehore@chromium.org>
References: <1353377222-19541-1-git-send-email-dbasehore@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a race condition which causes a warning in disk_clear_events. This is a
race between disk_clear_events and disk_flush_events. ev->clearing will be
altered by disk_flush_events (even though we are blocking event checking through
disk_flush_events). If this happens after ev->clearing was cleared for
disk_clear_events, this can cause the WARN_ON_ONCE in that function to be
triggered.

This change also has disk_clear_events not go through a workqueue. Since we have
to wait for the work to complete, we should just call the function directly.
Also, since this work cannot be put on a freezable workqueue, it will have to
contend with increased demand, so calling the function directly avoids this.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
---
 block/genhd.c |   46 +++++++++++++++++++++++++++++++---------------
 1 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 4e700ee..768371f 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -35,6 +35,8 @@ static DEFINE_IDR(ext_devt_idr);
 
 static struct device_type disk_type;
 
+static void disk_check_events(struct disk_events *ev,
+			      unsigned int *clearing_ptr);
 static void disk_alloc_events(struct gendisk *disk);
 static void disk_add_events(struct gendisk *disk);
 static void disk_del_events(struct gendisk *disk);
@@ -1555,6 +1557,7 @@ unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
 	const struct block_device_operations *bdops = disk->fops;
 	struct disk_events *ev = disk->ev;
 	unsigned int pending;
+	unsigned int clearing = mask;
 
 	if (!ev) {
 		/* for drivers still using the old ->media_changed method */
@@ -1564,40 +1567,53 @@ unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
 		return 0;
 	}
 
-	/* tell the workfn about the events being cleared */
+	disk_block_events(disk);
+
+	/*
+	 * store the union of mask and ev->clearing on the stack so that the
+	 * race with disk_flush_events does not cause ambiguity (ev->clearing
+	 * can still be modified even if events are blocked).
+	 */
 	spin_lock_irq(&ev->lock);
-	ev->clearing |= mask;
+	clearing |= ev->clearing;
+	ev->clearing = 0;
 	spin_unlock_irq(&ev->lock);
 
-	/* uncondtionally schedule event check and wait for it to finish */
-	disk_block_events(disk);
-	/* We need to put the work on system_nrt_wq here since there is a
-	 * deadlock that happens while probing a usb device while suspending. If
-	 * we put work on a freezable worqueue here, a usb probe will wait here
-	 * until the workqueue is unfrozen during suspend. Since suspend waits
-	 * on all probes to complete, we have a deadlock
+	disk_check_events(ev, &clearing);
+	/* 
+	 * if ev->clearing is not 0, the disk_flush_events got called in the
+	 * middle of this function, so we want to run the workfn without delay.
 	 */
-	queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
-	flush_delayed_work(&ev->dwork);
-	__disk_unblock_events(disk, false);
+	__disk_unblock_events(disk, ev->clearing ? true : false);
 
 	/* then, fetch and clear pending events */
 	spin_lock_irq(&ev->lock);
-	WARN_ON_ONCE(ev->clearing & mask);	/* cleared by workfn */
 	pending = ev->pending & mask;
 	ev->pending &= ~mask;
 	spin_unlock_irq(&ev->lock);
+	WARN_ON_ONCE(clearing & mask);
 
 	return pending;
 }
 
+/*
+ * Seperate this part out so that a different pointer for clearing_ptr can be
+ * passed in for disk_clear_events.
+ */
 static void disk_events_workfn(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct disk_events *ev = container_of(dwork, struct disk_events, dwork);
+
+	disk_check_events(ev, &ev->clearing);
+}
+
+static void disk_check_events(struct disk_events *ev,
+			      unsigned int *clearing_ptr)
+{
 	struct gendisk *disk = ev->disk;
 	char *envp[ARRAY_SIZE(disk_uevents) + 1] = { };
-	unsigned int clearing = ev->clearing;
+	unsigned int clearing = *clearing_ptr;
 	unsigned int events;
 	unsigned long intv;
 	int nr_events = 0, i;
@@ -1610,7 +1626,7 @@ static void disk_events_workfn(struct work_struct *work)
 
 	events &= ~ev->pending;
 	ev->pending |= events;
-	ev->clearing &= ~clearing;
+	*clearing_ptr &= ~clearing;
 
 	intv = disk_events_poll_jiffies(disk);
 	if (!ev->block && intv)
-- 
1.7.7.3

