Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990Ab2CUEGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 00:06:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab2CUEGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 00:06:00 -0400
Date: Wed, 21 Mar 2012 00:05:48 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] Fix I/O counts in vmstat
Message-ID: <Pine.LNX.4.64.1203202336370.15617@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch fixes I/O counting in vmstat. It makes us count only I/Os to 
real physical I/O devices and avoids counting at intermediate drivers 
that send the bio elsewhere.

Mikulas

---

Fix I/O counts in vmstat

Currently, there are two functions to submit a bio, submit_bio and
generic_make_request. They both do the same thing, except that
submit_bio increments the I/O counter (visible in vmstat) and
generic_make_request doesn't.

The decision whether bio is counted or not is made by the code that
submits the bio. This leads to some problems:
* when we write to dm-raid1 target with two raid legs, I/O is counted
  three times (once on entry to dm-raid1 and once on each legs)
* when dm-crypt target accepts large number of bios and sends them out,
  the machine appears deadlocked (there is no I/O activity in vmstat and
  processes are stuck in 'D' state). The machine is not really
  deadlocked, I/Os are submitted by dm-crypt to the disk driver, but
  they are not counted.

This patch changes it so that the decision if the bio should or
shouldn't be counted is made at the queue the bio is sent to. The bios
are counted (regardless if the submitter uses submit_bio or
generic_make_reuqest) unless the queue has a flag
"QUEUE_FLAG_NO_IO_COUNT".

QUEUE_FLAG_NO_IO_COUNT is sent on queues for md, dm and loop because
these drivers forward the bio to some other device.

Consequently, the I/O counts in vmstat are accurate, they measure the
I/O throughput of physical block devices.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-core.c       |   46 +++++++++++++++++++++++-----------------------
 drivers/block/loop.c   |    2 ++
 drivers/md/dm.c        |    1 +
 drivers/md/md.c        |    1 +
 include/linux/blkdev.h |    1 +
 5 files changed, 28 insertions(+), 23 deletions(-)

Index: linux-3.3-rc5-fast/block/blk-core.c
===================================================================
--- linux-3.3-rc5-fast.orig/block/blk-core.c	2012-03-03 01:04:02.000000000 +0100
+++ linux-3.3-rc5-fast/block/blk-core.c	2012-03-03 01:12:59.000000000 +0100
@@ -1636,6 +1636,21 @@ void generic_make_request(struct bio *bi
 		return;
 
 	/*
+	 * If it's a regular read/write or a barrier with data attached,
+	 * go through the normal accounting stuff before submission.
+	 */
+	if (!test_bit(QUEUE_FLAG_NO_IO_COUNT, &bdev_get_queue(bio->bi_bdev)->queue_flags) &&
+	    bio_has_data(bio) && !(bio->bi_rw & REQ_DISCARD)) {
+		int count = bio_sectors(bio);
+		if (bio->bi_rw & WRITE) {
+			count_vm_events(PGPGOUT, count);
+		} else {
+			task_io_account_read(bio->bi_size);
+			count_vm_events(PGPGIN, count);
+		}
+	}
+
+	/*
 	 * We only want one ->make_request_fn to be active at a time, else
 	 * stack usage with stacked devices could be a problem.  So use
 	 * current->bio_list to keep a list of requests submited by a
@@ -1690,31 +1705,16 @@ EXPORT_SYMBOL(generic_make_request);
  */
 void submit_bio(int rw, struct bio *bio)
 {
-	int count = bio_sectors(bio);
-
 	bio->bi_rw |= rw;
 
-	/*
-	 * If it's a regular read/write or a barrier with data attached,
-	 * go through the normal accounting stuff before submission.
-	 */
-	if (bio_has_data(bio) && !(rw & REQ_DISCARD)) {
-		if (rw & WRITE) {
-			count_vm_events(PGPGOUT, count);
-		} else {
-			task_io_account_read(bio->bi_size);
-			count_vm_events(PGPGIN, count);
-		}
-
-		if (unlikely(block_dump)) {
-			char b[BDEVNAME_SIZE];
-			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s (%u sectors)\n",
-			current->comm, task_pid_nr(current),
-				(rw & WRITE) ? "WRITE" : "READ",
-				(unsigned long long)bio->bi_sector,
-				bdevname(bio->bi_bdev, b),
-				count);
-		}
+	if (unlikely(block_dump)) {
+		char b[BDEVNAME_SIZE];
+		printk(KERN_DEBUG "%s(%d): %s block %Lu on %s (%u sectors)\n",
+		current->comm, task_pid_nr(current),
+			(rw & WRITE) ? "WRITE" : "READ",
+			(unsigned long long)bio->bi_sector,
+			bdevname(bio->bi_bdev, b),
+			bio_sectors(bio));
 	}
 
 	generic_make_request(bio);
Index: linux-3.3-rc5-fast/include/linux/blkdev.h
===================================================================
--- linux-3.3-rc5-fast.orig/include/linux/blkdev.h	2012-03-03 01:04:23.000000000 +0100
+++ linux-3.3-rc5-fast/include/linux/blkdev.h	2012-03-03 01:12:59.000000000 +0100
@@ -420,6 +420,7 @@ struct request_queue {
 #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
+#define QUEUE_FLAG_NO_IO_COUNT 19	/* don't increase io request count */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
Index: linux-3.3-rc5-fast/drivers/block/loop.c
===================================================================
--- linux-3.3-rc5-fast.orig/drivers/block/loop.c	2012-03-03 01:04:03.000000000 +0100
+++ linux-3.3-rc5-fast/drivers/block/loop.c	2012-03-03 01:12:59.000000000 +0100
@@ -1633,6 +1633,8 @@ static int loop_add(struct loop_device *
 	if (!lo->lo_queue)
 		goto out_free_dev;
 
+	queue_flag_set_unlocked(QUEUE_FLAG_NO_IO_COUNT, lo->lo_queue);
+
 	disk = lo->lo_disk = alloc_disk(1 << part_shift);
 	if (!disk)
 		goto out_free_queue;
Index: linux-3.3-rc5-fast/drivers/md/md.c
===================================================================
--- linux-3.3-rc5-fast.orig/drivers/md/md.c	2012-03-03 01:04:06.000000000 +0100
+++ linux-3.3-rc5-fast/drivers/md/md.c	2012-03-03 01:12:59.000000000 +0100
@@ -4667,6 +4667,7 @@ static int md_alloc(dev_t dev, char *nam
 
 	blk_queue_make_request(mddev->queue, md_make_request);
 	blk_set_stacking_limits(&mddev->queue->limits);
+	queue_flag_set_unlocked(QUEUE_FLAG_NO_IO_COUNT, mddev->queue);
 
 	disk = alloc_disk(1 << shift);
 	if (!disk) {
Index: linux-3.3-rc5-fast/drivers/md/dm.c
===================================================================
--- linux-3.3-rc5-fast.orig/drivers/md/dm.c	2012-03-03 01:11:47.000000000 +0100
+++ linux-3.3-rc5-fast/drivers/md/dm.c	2012-03-03 01:12:59.000000000 +0100
@@ -1803,6 +1803,7 @@ static void dm_init_md_queue(struct mapp
 	 * This queue is new, so no concurrency on the queue_flags.
 	 */
 	queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, md->queue);
+	queue_flag_set_unlocked(QUEUE_FLAG_NO_IO_COUNT, md->queue);
 
 	md->queue->queuedata = md;
 	md->queue->backing_dev_info.congested_fn = dm_any_congested;
