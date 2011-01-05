Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1AEXqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:46:35 -0500
Received: from kroah.org ([198.145.64.141]:41126 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab1AEXp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:45:29 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:28 2011
Message-Id: <20110105230328.214721956@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:01:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: [47/49] block: Deprecate QUEUE_FLAG_CLUSTER and use queue_limits instead
In-Reply-To: <20110105234415.GA22369@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 block/blk-merge.c       |    6 +++---
 block/blk-settings.c    |   24 ++----------------------
 drivers/md/dm-table.c   |    5 -----
 drivers/md/md.c         |    3 ---
 drivers/scsi/scsi_lib.c |    3 +--
 include/linux/blkdev.h  |    9 ++++++---
 6 files changed, 12 insertions(+), 38 deletions(-)

--- a/block/blk-merge.c
+++ b/block/blk-merge.c
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
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -103,7 +103,7 @@ void blk_set_default_limits(struct queue
 	lim->alignment_offset = 0;
 	lim->io_opt = 0;
 	lim->misaligned = 0;
-	lim->no_cluster = 0;
+	lim->cluster = 1;
 }
 EXPORT_SYMBOL(blk_set_default_limits);
 
@@ -477,15 +477,6 @@ EXPORT_SYMBOL(blk_queue_io_opt);
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
 
@@ -561,7 +552,7 @@ int blk_stack_limits(struct queue_limits
 	t->io_min = max(t->io_min, b->io_min);
 	t->io_opt = lcm(t->io_opt, b->io_opt);
 
-	t->no_cluster |= b->no_cluster;
+	t->cluster &= b->cluster;
 
 	/* Physical block size a multiple of the logical block size? */
 	if (t->physical_block_size & (t->logical_block_size - 1)) {
@@ -652,17 +643,6 @@ void disk_stack_limits(struct gendisk *d
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
 
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1082,11 +1082,6 @@ void dm_table_set_restrictions(struct dm
 	 */
 	q->limits = *limits;
 
-	if (limits->no_cluster)
-		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
-	else
-		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
-
 	dm_table_set_integrity(t);
 
 	/*
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3959,9 +3959,6 @@ static int md_alloc(dev_t dev, char *nam
 		goto abort;
 	mddev->queue->queuedata = mddev;
 
-	/* Can be unlocked because the queue is new: no concurrency */
-	queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, mddev->queue);
-
 	blk_queue_make_request(mddev->queue, md_make_request);
 
 	disk = alloc_disk(1 << shift);
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1636,9 +1636,8 @@ struct request_queue *__scsi_alloc_queue
 
 	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
 
-	/* New queue, no concurrency on queue_flags */
 	if (!shost->use_clustering)
-		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
+		q->limits.cluster = 0;
 
 	/*
 	 * set a reasonable default alignment on word boundaries: the
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -318,7 +318,7 @@ struct queue_limits {
 	unsigned short		max_phys_segments;
 
 	unsigned char		misaligned;
-	unsigned char		no_cluster;
+	unsigned char		cluster;
 };
 
 struct request_queue
@@ -440,7 +440,6 @@ struct request_queue
 #endif
 };
 
-#define QUEUE_FLAG_CLUSTER	0	/* cluster several segments into 1 */
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
 #define QUEUE_FLAG_STOPPED	2	/* queue is stopped */
 #define	QUEUE_FLAG_SYNCFULL	3	/* read queue has been filled */
@@ -461,7 +460,6 @@ struct request_queue
 #define QUEUE_FLAG_DISCARD     17	/* supports DISCARD */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
-				 (1 << QUEUE_FLAG_CLUSTER) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
 				 (1 << QUEUE_FLAG_SAME_COMP))
 
@@ -627,6 +625,11 @@ enum {
 
 #define rq_data_dir(rq)		((rq)->cmd_flags & 1)
 
+static inline unsigned int blk_queue_cluster(struct request_queue *q)
+{
+	return q->limits.cluster;
+}
+
 /*
  * We regard a request as sync, if either a read or a sync write
  */


