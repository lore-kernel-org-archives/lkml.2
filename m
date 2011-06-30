Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1F3Ps3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:48:29 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:49449 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1F3Ps1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:48:27 -0400
Date: Thu, 30 Jun 2011 17:48:22 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        linux-hotplug@vger.kernel.org
Subject: [PATCH block:for-2.6.31/core] block: flush MEDIA_CHANGE from drivers
 on close(2)
Message-ID: <20110630154822.GR3386@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, only open(2) is defined as the 'clearing' point.  It has
two roles - first, it's an acknowledgement from userland indicating
that the event has been received and kernel can clear pending states
and proceed to generate more events.  Secondly, it's passed on to
device drivers as a hint indicating that a synchronization point has
been reached and it might want to take a deeper look at the device.

The latter currently is only used by sr which uses two different
mechanisms - GET_EVENT_MEDIA_STATUS_NOTIFICATION and TEST_UNIT_READY
to discover events, where the former is lighter weight and safe to be
used repeatedly but may not provide full coverage.  Among other
things, GET_EVENT can't detect media removal while TUR can.

This patch makes close(2) - blkdev_put() - indicate clearing hint for
MEDIA_CHANGE to drivers.  disk_check_events() is renamed to
disk_flush_events() and updated to take @mask for events to flush
which is or'd to ev->clearing and will be passed to the driver on the
next ->check_events() invocation.

This change makes sr generate MEDIA_CHANGE when media is ejected from
userland - e.g. with eject(1).

Note: Given the current usage, it seems @clearing hint is needlessly
complex.  disk_clear_events() can simply clear all events and the hint
can be boolean @flush.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
Jens, this patch is for 3.1 merge window but generated on top of the
current block:for-linus because it depends on the fixes in that
branch.  It would probably be best to pull in for-linus into
for-2.6.32/core before applying this patch.

Thanks.

 block/genhd.c         |   22 ++++++++++++----------
 fs/block_dev.c        |   23 ++++++++++++++---------
 include/linux/genhd.h |    2 +-
 3 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3608289..6cd3f5b 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1500,30 +1500,32 @@ void disk_unblock_events(struct gendisk *disk)
 }
 
 /**
- * disk_check_events - schedule immediate event checking
- * @disk: disk to check events for
+ * disk_flush_events - schedule immediate event checking and flushing
+ * @disk: disk to check and flush events for
+ * @mask: events to flush
  *
- * Schedule immediate event checking on @disk if not blocked.
+ * Schedule immediate event checking on @disk if not blocked.  Events in
+ * @mask are scheduled to be cleared from the driver.  Note that this
+ * doesn't clear the events from @disk->ev.
  *
  * CONTEXT:
- * Don't care.  Safe to call from irq context.
+ * If @mask is non-zero must be called with bdev->bd_mutex held.
  */
-void disk_check_events(struct gendisk *disk)
+void disk_flush_events(struct gendisk *disk, unsigned int mask)
 {
 	struct disk_events *ev = disk->ev;
-	unsigned long flags;
 
 	if (!ev)
 		return;
 
-	spin_lock_irqsave(&ev->lock, flags);
+	spin_lock_irq(&ev->lock);
+	ev->clearing |= mask;
 	if (!ev->block) {
 		cancel_delayed_work(&ev->dwork);
 		queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
 	}
-	spin_unlock_irqrestore(&ev->lock, flags);
+	spin_unlock_irq(&ev->lock);
 }
-EXPORT_SYMBOL_GPL(disk_check_events);
 
 /**
  * disk_clear_events - synchronously check, clear and return pending events
@@ -1713,7 +1715,7 @@ static int disk_events_set_dfl_poll_msecs(const char *val,
 	mutex_lock(&disk_events_mutex);
 
 	list_for_each_entry(ev, &disk_events, node)
-		disk_check_events(ev->disk);
+		disk_flush_events(ev->disk, 0);
 
 	mutex_unlock(&disk_events_mutex);
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 610e8e0..6ff7f07 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1447,6 +1447,8 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 
 int blkdev_put(struct block_device *bdev, fmode_t mode)
 {
+	mutex_lock(&bdev->bd_mutex);
+
 	if (mode & FMODE_EXCL) {
 		bool bdev_free;
 
@@ -1455,7 +1457,6 @@ int blkdev_put(struct block_device *bdev, fmode_t mode)
 		 * are protected with bdev_lock.  bd_mutex is to
 		 * synchronize disk_holder unlinking.
 		 */
-		mutex_lock(&bdev->bd_mutex);
 		spin_lock(&bdev_lock);
 
 		WARN_ON_ONCE(--bdev->bd_holders < 0);
@@ -1473,17 +1474,21 @@ int blkdev_put(struct block_device *bdev, fmode_t mode)
 		 * If this was the last claim, remove holder link and
 		 * unblock evpoll if it was a write holder.
 		 */
-		if (bdev_free) {
-			if (bdev->bd_write_holder) {
-				disk_unblock_events(bdev->bd_disk);
-				disk_check_events(bdev->bd_disk);
-				bdev->bd_write_holder = false;
-			}
+		if (bdev_free && bdev->bd_write_holder) {
+			disk_unblock_events(bdev->bd_disk);
+			bdev->bd_write_holder = false;
 		}
-
-		mutex_unlock(&bdev->bd_mutex);
 	}
 
+	/*
+	 * Trigger event checking and tell drivers to flush MEDIA_CHANGE
+	 * event.  This is to ensure detection of media removal commanded
+	 * from userland - e.g. eject(1).
+	 */
+	disk_flush_events(bdev->bd_disk, DISK_EVENT_MEDIA_CHANGE);
+
+	mutex_unlock(&bdev->bd_mutex);
+
 	return __blkdev_put(bdev, mode, 0);
 }
 EXPORT_SYMBOL(blkdev_put);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 300d758..02fa469 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -420,7 +420,7 @@ static inline int get_disk_ro(struct gendisk *disk)
 
 extern void disk_block_events(struct gendisk *disk);
 extern void disk_unblock_events(struct gendisk *disk);
-extern void disk_check_events(struct gendisk *disk);
+extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
 extern unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask);
 
 /* drivers/char/random.c */
