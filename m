Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0GCIsB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 04:48:01 -0400
Received: from sh.osrg.net ([192.16.179.4]:47315 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0GCIqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 04:46:44 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: axboe@kernel.dk
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 9/9] block: remove q->prepare_flush_fn completely
Date: Sat,  3 Jul 2010 17:45:40 +0900
Message-Id: <1278146740-8731-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 03 Jul 2010 17:46:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes q->prepare_flush_fn completely (changes the
blk_queue_ordered API).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-barrier.c          |    7 +------
 drivers/block/brd.c          |    2 +-
 drivers/block/loop.c         |    2 +-
 drivers/block/osdblk.c       |    2 +-
 drivers/block/ps3disk.c      |    2 +-
 drivers/block/virtio_blk.c   |    4 ++--
 drivers/block/xen-blkfront.c |    3 +--
 drivers/ide/ide-disk.c       |    2 +-
 drivers/md/dm.c              |    2 +-
 drivers/mmc/card/queue.c     |    2 +-
 drivers/s390/block/dasd.c    |    2 +-
 drivers/scsi/sd.c            |    2 +-
 include/linux/blkdev.h       |    4 +---
 13 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 7ce0a32..eefbde8 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -13,7 +13,6 @@
  * blk_queue_ordered - does this queue support ordered writes
  * @q:        the request queue
  * @ordered:  one of QUEUE_ORDERED_*
- * @prepare_flush_fn: rq setup helper for cache flush ordered writes
  *
  * Description:
  *   For journalled file systems, doing ordered writes on a commit
@@ -22,8 +21,7 @@
  *   feature should call this function and indicate so.
  *
  **/
-int blk_queue_ordered(struct request_queue *q, unsigned ordered,
-		      prepare_flush_fn *prepare_flush_fn)
+int blk_queue_ordered(struct request_queue *q, unsigned ordered)
 {
 	if (ordered != QUEUE_ORDERED_NONE &&
 	    ordered != QUEUE_ORDERED_DRAIN &&
@@ -38,7 +36,6 @@ int blk_queue_ordered(struct request_queue *q, unsigned ordered,
 
 	q->ordered = ordered;
 	q->next_ordered = ordered;
-	q->prepare_flush_fn = prepare_flush_fn;
 
 	return 0;
 }
@@ -140,8 +137,6 @@ static void queue_flush(struct request_queue *q, unsigned which)
 	rq->cmd_flags = REQ_HARDBARRIER | REQ_FLUSH;
 	rq->rq_disk = q->bar_rq.rq_disk;
 	rq->end_io = end_io;
-	if (q->prepare_flush_fn)
-		q->prepare_flush_fn(q, rq);
 
 	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 }
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 1b218c6..1d2c186 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -479,7 +479,7 @@ static struct brd_device *brd_alloc(int i)
 	if (!brd->brd_queue)
 		goto out_free_dev;
 	blk_queue_make_request(brd->brd_queue, brd_make_request);
-	blk_queue_ordered(brd->brd_queue, QUEUE_ORDERED_TAG, NULL);
+	blk_queue_ordered(brd->brd_queue, QUEUE_ORDERED_TAG);
 	blk_queue_max_hw_sectors(brd->brd_queue, 1024);
 	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index fedfdb7..d285a54 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -831,7 +831,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	lo->lo_queue->unplug_fn = loop_unplug;
 
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
-		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN, NULL);
+		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN);
 
 	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index 9639565..2284b4f 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -439,7 +439,7 @@ static int osdblk_init_disk(struct osdblk_device *osdev)
 	blk_queue_stack_limits(q, osd_request_queue(osdev->osd));
 
 	blk_queue_prep_rq(q, blk_queue_start_tag);
-	blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH, NULL);
+	blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH);
 
 	disk->queue = q;
 
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index ab528a4..e9da874 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -468,7 +468,7 @@ static int __devinit ps3disk_probe(struct ps3_system_bus_device *_dev)
 	blk_queue_dma_alignment(queue, dev->blk_size-1);
 	blk_queue_logical_block_size(queue, dev->blk_size);
 
-	blk_queue_ordered(queue, QUEUE_ORDERED_DRAIN_FLUSH, NULL);
+	blk_queue_ordered(queue, QUEUE_ORDERED_DRAIN_FLUSH);
 
 	blk_queue_max_segments(queue, -1);
 	blk_queue_max_segment_size(queue, dev->bounce_size);
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index b277f9e..0a3222f 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -366,9 +366,9 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 
 	/* If barriers are supported, tell block layer that queue is ordered */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
-		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH, NULL);
+		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH);
 	else if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER))
-		blk_queue_ordered(q, QUEUE_ORDERED_TAG, NULL);
+		blk_queue_ordered(q, QUEUE_ORDERED_TAG);
 
 	/* If disk is read-only in the host, the guest should obey */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_RO))
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 495533e..76af65b 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -373,8 +373,7 @@ static int xlvbd_barrier(struct blkfront_info *info)
 	int err;
 
 	err = blk_queue_ordered(info->rq,
-				info->feature_barrier ? QUEUE_ORDERED_DRAIN : QUEUE_ORDERED_NONE,
-				NULL);
+				info->feature_barrier ? QUEUE_ORDERED_DRAIN : QUEUE_ORDERED_NONE);
 
 	if (err)
 		return err;
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index c22e622..7433e07 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -549,7 +549,7 @@ static void update_ordered(ide_drive_t *drive)
 	} else
 		ordered = QUEUE_ORDERED_DRAIN;
 
-	blk_queue_ordered(drive->queue, ordered, NULL);
+	blk_queue_ordered(drive->queue, ordered);
 }
 
 ide_devset_get_flag(wcache, IDE_DFLAG_WCACHE);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 00c8105..d505a96 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1901,7 +1901,7 @@ static struct mapped_device *alloc_dev(int minor)
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
 	blk_queue_prep_rq(md->queue, dm_prep_fn);
 	blk_queue_lld_busy(md->queue, dm_lld_busy);
-	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH, NULL);
+	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH);
 
 	md->disk = alloc_disk(1);
 	if (!md->disk)
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index ec92bcb..c77eb49 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -128,7 +128,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	mq->req = NULL;
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
-	blk_queue_ordered(mq->queue, QUEUE_ORDERED_DRAIN, NULL);
+	blk_queue_ordered(mq->queue, QUEUE_ORDERED_DRAIN);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
 
 #ifdef CONFIG_MMC_BLOCK_BOUNCE
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 33975e9..17b033d 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2196,7 +2196,7 @@ static void dasd_setup_queue(struct dasd_block *block)
 	 */
 	blk_queue_max_segment_size(block->request_queue, PAGE_SIZE);
 	blk_queue_segment_boundary(block->request_queue, PAGE_SIZE - 1);
-	blk_queue_ordered(block->request_queue, QUEUE_ORDERED_DRAIN, NULL);
+	blk_queue_ordered(block->request_queue, QUEUE_ORDERED_DRAIN);
 }
 
 /*
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e8c295e..d9a4314 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2135,7 +2135,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	else
 		ordered = QUEUE_ORDERED_DRAIN;
 
-	blk_queue_ordered(sdkp->disk->queue, ordered, NULL);
+	blk_queue_ordered(sdkp->disk->queue, ordered);
 
 	set_capacity(disk, sdkp->capacity);
 	kfree(buffer);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6bba04c..3a2c5d9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -212,7 +212,6 @@ struct bvec_merge_data {
 };
 typedef int (merge_bvec_fn) (struct request_queue *, struct bvec_merge_data *,
 			     struct bio_vec *);
-typedef void (prepare_flush_fn) (struct request_queue *, struct request *);
 typedef void (softirq_done_fn)(struct request *);
 typedef int (dma_drain_needed_fn)(struct request *);
 typedef int (lld_busy_fn) (struct request_queue *q);
@@ -286,7 +285,6 @@ struct request_queue
 	unprep_rq_fn		*unprep_rq_fn;
 	unplug_fn		*unplug_fn;
 	merge_bvec_fn		*merge_bvec_fn;
-	prepare_flush_fn	*prepare_flush_fn;
 	softirq_done_fn		*softirq_done_fn;
 	rq_timed_out_fn		*rq_timed_out_fn;
 	dma_drain_needed_fn	*dma_drain_needed;
@@ -896,7 +894,7 @@ extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
 extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
-extern int blk_queue_ordered(struct request_queue *, unsigned, prepare_flush_fn *);
+extern int blk_queue_ordered(struct request_queue *, unsigned);
 extern bool blk_do_ordered(struct request_queue *, struct request **);
 extern unsigned blk_ordered_cur_seq(struct request_queue *);
 extern unsigned blk_ordered_req_seq(struct request *);
-- 
1.6.5

