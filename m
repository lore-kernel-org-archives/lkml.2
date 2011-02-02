Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1BBArj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:47:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:35951 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab1BBApV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382961071"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: martin.petersen@oracle.com, snitzer@redhat.com, jaxboe@fusionio.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [131/139] block: Deprecate QUEUE_FLAG_CLUSTER and use queue_limits instead
Message-Id: <20110202004530.D1F8F3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Martin K. Petersen <martin.petersen@oracle.com>

commit e692cb668fdd5a712c6ed2a2d6f2a36ee83997b4 upstream.

When stacking devices, a request_queue is not always available. This
forced us to have a no_cluster flag in the queue_limits that could be
used as a carrier until the request_queue had been set up for a
metadevice.

There were several problems with that approach. First of all it was up
to the stacking device to remember to set queue flag after stacking had
completed. Also, the queue flag and the queue limits had to be kept in
sync at all times. We got that wrong, which could lead to us issuing
commands that went beyond the max scatterlist limit set by the driver.

The proper fix is to avoid having two flags for tracking the same thing.
We deprecate QUEUE_FLAG_CLUSTER and use the queue limit directly in the
block layer merging functions. The queue_limit 'no_cluster' is turned
into 'cluster' to avoid double negatives and to ease stacking.
Clustering defaults to being enabled as before. The queue flag logic is
removed from the stacking function, and explicitly setting the cluster
flag is no longer necessary in DM and MD.

Reported-by: Ed Lin <ed.lin@promise.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 block/blk-merge.c       |    6 +++---
 block/blk-settings.c    |   25 ++-----------------------
 block/blk-sysfs.c       |    2 +-
 drivers/md/dm-table.c   |    5 -----
 drivers/md/md.c         |    3 ---
 drivers/scsi/scsi_lib.c |    3 +--
 include/linux/blkdev.h  |    9 ++++++---
 7 files changed, 13 insertions(+), 40 deletions(-)

Index: linux-2.6.35.y/block/blk-merge.c
===================================================================
--- linux-2.6.35.y.orig/block/blk-merge.c
+++ linux-2.6.35.y/block/blk-merge.c
@@ -22,7 +22,7 @@ static unsigned int __blk_recalc_rq_segm
 		return 0;
 
 	fbio = bio;
-	cluster = test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
+	cluster = blk_queue_cluster(q);
 	seg_size = 0;
 	phys_size = nr_phys_segs = 0;
 	for_each_bio(bio) {
@@ -88,7 +88,7 @@ EXPORT_SYMBOL(blk_recount_segments);
 static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 				   struct bio *nxt)
 {
-	if (!test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags))
+	if (!blk_queue_cluster(q))
 		return 0;
 
 	if (bio->bi_seg_back_size + nxt->bi_seg_front_size >
@@ -124,7 +124,7 @@ int blk_rq_map_sg(struct request_queue *
 	int nsegs, cluster;
 
 	nsegs = 0;
-	cluster = test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
+	cluster = blk_queue_cluster(q);
 
 	/*
 	 * for each bio in rq
Index: linux-2.6.35.y/block/blk-settings.c
===================================================================
--- linux-2.6.35.y.orig/block/blk-settings.c
+++ linux-2.6.35.y/block/blk-settings.c
@@ -108,7 +108,7 @@ void blk_set_default_limits(struct queue
 	lim->alignment_offset = 0;
 	lim->io_opt = 0;
 	lim->misaligned = 0;
-	lim->no_cluster = 0;
+	lim->cluster = 1;
 }
 EXPORT_SYMBOL(blk_set_default_limits);
 
@@ -451,15 +451,6 @@ EXPORT_SYMBOL(blk_queue_io_opt);
 void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
 {
 	blk_stack_limits(&t->limits, &b->limits, 0);
-
-	if (!t->queue_lock)
-		WARN_ON_ONCE(1);
-	else if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags)) {
-		unsigned long flags;
-		spin_lock_irqsave(t->queue_lock, flags);
-		queue_flag_clear(QUEUE_FLAG_CLUSTER, t);
-		spin_unlock_irqrestore(t->queue_lock, flags);
-	}
 }
 EXPORT_SYMBOL(blk_queue_stack_limits);
 
@@ -530,7 +521,7 @@ int blk_stack_limits(struct queue_limits
 	t->io_min = max(t->io_min, b->io_min);
 	t->io_opt = lcm(t->io_opt, b->io_opt);
 
-	t->no_cluster |= b->no_cluster;
+	t->cluster &= b->cluster;
 	t->discard_zeroes_data &= b->discard_zeroes_data;
 
 	/* Physical block size a multiple of the logical block size? */
@@ -626,7 +617,6 @@ void disk_stack_limits(struct gendisk *d
 		       sector_t offset)
 {
 	struct request_queue *t = disk->queue;
-	struct request_queue *b = bdev_get_queue(bdev);
 
 	if (bdev_stack_limits(&t->limits, bdev, offset >> 9) < 0) {
 		char top[BDEVNAME_SIZE], bottom[BDEVNAME_SIZE];
@@ -637,17 +627,6 @@ void disk_stack_limits(struct gendisk *d
 		printk(KERN_NOTICE "%s: Warning: Device %s is misaligned\n",
 		       top, bottom);
 	}
-
-	if (!t->queue_lock)
-		WARN_ON_ONCE(1);
-	else if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(t->queue_lock, flags);
-		if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags))
-			queue_flag_clear(QUEUE_FLAG_CLUSTER, t);
-		spin_unlock_irqrestore(t->queue_lock, flags);
-	}
 }
 EXPORT_SYMBOL(disk_stack_limits);
 
Index: linux-2.6.35.y/block/blk-sysfs.c
===================================================================
--- linux-2.6.35.y.orig/block/blk-sysfs.c
+++ linux-2.6.35.y/block/blk-sysfs.c
@@ -114,7 +114,7 @@ static ssize_t queue_max_segments_show(s
 
 static ssize_t queue_max_segment_size_show(struct request_queue *q, char *page)
 {
-	if (test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags))
+	if (blk_queue_cluster(q))
 		return queue_var_show(queue_max_segment_size(q), (page));
 
 	return queue_var_show(PAGE_CACHE_SIZE, (page));
Index: linux-2.6.35.y/drivers/md/dm-table.c
===================================================================
--- linux-2.6.35.y.orig/drivers/md/dm-table.c
+++ linux-2.6.35.y/drivers/md/dm-table.c
@@ -1081,11 +1081,6 @@ void dm_table_set_restrictions(struct dm
 	 */
 	q->limits = *limits;
 
-	if (limits->no_cluster)
-		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
-	else
-		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
-
 	dm_table_set_integrity(t);
 
 	/*
Index: linux-2.6.35.y/drivers/md/md.c
===================================================================
--- linux-2.6.35.y.orig/drivers/md/md.c
+++ linux-2.6.35.y/drivers/md/md.c
@@ -4248,9 +4248,6 @@ static int md_alloc(dev_t dev, char *nam
 		goto abort;
 	mddev->queue->queuedata = mddev;
 
-	/* Can be unlocked because the queue is new: no concurrency */
-	queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, mddev->queue);
-
 	blk_queue_make_request(mddev->queue, md_make_request);
 
 	disk = alloc_disk(1 << shift);
Index: linux-2.6.35.y/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6.35.y/drivers/scsi/scsi_lib.c
@@ -1640,9 +1640,8 @@ struct request_queue *__scsi_alloc_queue
 
 	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
 
-	/* New queue, no concurrency on queue_flags */
 	if (!shost->use_clustering)
-		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
+		q->limits.cluster = 0;
 
 	/*
 	 * set a reasonable default alignment on word boundaries: the
Index: linux-2.6.35.y/include/linux/blkdev.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/blkdev.h
+++ linux-2.6.35.y/include/linux/blkdev.h
@@ -325,7 +325,7 @@ struct queue_limits {
 
 	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
-	unsigned char		no_cluster;
+	unsigned char		cluster;
 	signed char		discard_zeroes_data;
 };
 
@@ -448,7 +448,6 @@ struct request_queue
 #endif
 };
 
-#define QUEUE_FLAG_CLUSTER	0	/* cluster several segments into 1 */
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
 #define QUEUE_FLAG_STOPPED	2	/* queue is stopped */
 #define	QUEUE_FLAG_SYNCFULL	3	/* read queue has been filled */
@@ -469,7 +468,6 @@ struct request_queue
 #define QUEUE_FLAG_NOXMERGES   17	/* No extended merges */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
-				 (1 << QUEUE_FLAG_CLUSTER) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
 				 (1 << QUEUE_FLAG_SAME_COMP))
 
@@ -636,6 +634,11 @@ enum {
 
 #define rq_data_dir(rq)		((rq)->cmd_flags & 1)
 
+static inline unsigned int blk_queue_cluster(struct request_queue *q)
+{
+	return q->limits.cluster;
+}
+
 /*
  * We regard a request as sync, if either a read or a sync write
  */
