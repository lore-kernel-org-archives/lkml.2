Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0FXIpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 04:45:13 -0400
Received: from smtp.nokia.com ([192.100.105.134]:46093 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0FXIpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 04:45:06 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>, Jens Axboe <axboe@kernel.dk>,
       Kyungmin Park <kmpark@infradead.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       linux-mmc Mailing List <linux-mmc@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 24 Jun 2010 11:44:23 +0300
Message-Id: <20100624084423.25444.1011.sendpatchset@ahunter-work.research.nokia.com>
In-Reply-To: <20100624084351.25444.30143.sendpatchset@ahunter-work.research.nokia.com>
References: <20100624084351.25444.30143.sendpatchset@ahunter-work.research.nokia.com>
Subject: [PATCH V3 4/5] block: Add secure discard
X-OriginalArrivalTime: 24 Jun 2010 08:44:24.0618 (UTC) FILETIME=[72AE30A0:01CB1379]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b25b9a499f255ee5999c219525d82ef40382318c Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Wed, 23 Jun 2010 15:41:38 +0300
Subject: [PATCH 4/5] block: Add secure discard

Secure discard is the same as discard except that all copies
of the discarded sectors (perhaps created by garbage collection)
must also be erased.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 block/blk-core.c        |    6 +++++-
 block/blk-lib.c         |    6 ++++++
 block/compat_ioctl.c    |    1 +
 block/elevator.c        |    4 ++++
 block/ioctl.c           |   15 ++++++++++-----
 include/linux/bio.h     |    7 ++++++-
 include/linux/blkdev.h  |   10 +++++++++-
 include/linux/fs.h      |    2 ++
 kernel/trace/blktrace.c |    8 ++++++++
 9 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f84cce4..6f9c6df 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1153,6 +1153,8 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 		req->cmd_flags |= REQ_DISCARD;
 		if (bio_rw_flagged(bio, BIO_RW_BARRIER))
 			req->cmd_flags |= REQ_SOFTBARRIER;
+		if (bio_rw_flagged(bio, BIO_RW_SECURE))
+			req->cmd_flags |= REQ_SECURE;
 	} else if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER)))
 		req->cmd_flags |= REQ_HARDBARRIER;
 
@@ -1501,7 +1503,9 @@ static inline void __generic_make_request(struct bio *bio)
 			goto end_io;
 
 		if (bio_rw_flagged(bio, BIO_RW_DISCARD) &&
-		    !blk_queue_discard(q)) {
+		    (!blk_queue_discard(q) ||
+		     (bio_rw_flagged(bio, BIO_RW_SECURE) &&
+		      !blk_queue_secdiscard(q)))) {
 			err = -EOPNOTSUPP;
 			goto end_io;
 		}
diff --git a/block/blk-lib.c b/block/blk-lib.c
index d0216b9..dc56682 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -52,6 +52,12 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
 
+	if (flags & BLKDEV_IFL_SECURE) {
+		if (!blk_queue_secdiscard(q))
+			return -EOPNOTSUPP;
+		type |= DISCARD_SECURE;
+	}
+
 	while (nr_sects && !ret) {
 		unsigned int sector_size = q->limits.logical_block_size;
 		unsigned int max_discard_sectors =
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index f26051f..24a146d 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -753,6 +753,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case BLKFLSBUF:
 	case BLKROSET:
 	case BLKDISCARD:
+	case BLKSECDISCARD:
 	/*
 	 * the ones below are implemented in blkdev_locked_ioctl,
 	 * but we call blkdev_ioctl, which gets the lock for us
diff --git a/block/elevator.c b/block/elevator.c
index 923a913..23b5f3d 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -83,6 +83,10 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 	    bio_rw_flagged(rq->bio, BIO_RW_DISCARD))
 		return 0;
 
+	if (bio_rw_flagged(bio, BIO_RW_SECURE) !=
+	    bio_rw_flagged(rq->bio, BIO_RW_SECURE))
+		return 0;
+
 	/*
 	 * different data direction or already started, don't merge
 	 */
diff --git a/block/ioctl.c b/block/ioctl.c
index e8eb679..1fba55f 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -114,8 +114,10 @@ static int blkdev_reread_part(struct block_device *bdev)
 }
 
 static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
-			     uint64_t len)
+			     uint64_t len, int secure)
 {
+	unsigned long flags = BLKDEV_IFL_WAIT;
+
 	if (start & 511)
 		return -EINVAL;
 	if (len & 511)
@@ -125,8 +127,9 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 
 	if (start + len > (bdev->bd_inode->i_size >> 9))
 		return -EINVAL;
-	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL,
-				    BLKDEV_IFL_WAIT);
+	if (secure)
+		flags |= BLKDEV_IFL_SECURE;
+	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL, flags);
 }
 
 static int put_ushort(unsigned long arg, unsigned short val)
@@ -226,7 +229,8 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		unlock_kernel();
 		return 0;
 
-	case BLKDISCARD: {
+	case BLKDISCARD:
+	case BLKSECDISCARD: {
 		uint64_t range[2];
 
 		if (!(mode & FMODE_WRITE))
@@ -235,7 +239,8 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		if (copy_from_user(range, (void __user *)arg, sizeof(range)))
 			return -EFAULT;
 
-		return blk_ioctl_discard(bdev, range[0], range[1]);
+		return blk_ioctl_discard(bdev, range[0], range[1],
+					 cmd == BLKSECDISCARD);
 	}
 
 	case HDIO_GETGEO: {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7fc5606..5355b42 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -160,7 +160,11 @@ struct bio {
  *	for flash based storage.
  *	Don't want driver retries for any fast fail whatever the reason.
  * bit 10 -- Tell the IO scheduler not to wait for more requests after this
-	one has been submitted, even if it is a SYNC request.
+ *	one has been submitted, even if it is a SYNC request.
+ * bit 11 -- secure
+ *	Used with BIO_RW_DISCARD to indicate a secure discard, which means
+ *	all copies of the discarded sectors (perhaps created by garbage
+ *	collection) are also erased.
  */
 enum bio_rw_flags {
 	BIO_RW,
@@ -175,6 +179,7 @@ enum bio_rw_flags {
 	BIO_RW_META,
 	BIO_RW_DISCARD,
 	BIO_RW_NOIDLE,
+	BIO_RW_SECURE,
 };
 
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 09a8402..cff69d3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -115,6 +115,7 @@ enum rq_flag_bits {
 	__REQ_NOIDLE,		/* Don't anticipate more IO after this one */
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
+	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -144,6 +145,7 @@ enum rq_flag_bits {
 #define REQ_NOIDLE	(1 << __REQ_NOIDLE)
 #define REQ_IO_STAT	(1 << __REQ_IO_STAT)
 #define REQ_MIXED_MERGE	(1 << __REQ_MIXED_MERGE)
+#define REQ_SECURE	(1 << __REQ_SECURE)
 
 #define REQ_FAILFAST_MASK	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | \
 				 REQ_FAILFAST_DRIVER)
@@ -467,6 +469,7 @@ struct request_queue
 #define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
 #define QUEUE_FLAG_DISCARD     16	/* supports DISCARD */
 #define QUEUE_FLAG_NOXMERGES   17	/* No extended merges */
+#define QUEUE_FLAG_SECDISCARD  18	/* supports SECDISCARD */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_CLUSTER) |		\
@@ -600,6 +603,8 @@ enum {
 #define blk_queue_stackable(q)	\
 	test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
+#define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
+	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
 
 #define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
 #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
@@ -628,6 +633,7 @@ enum {
 #define blk_barrier_rq(rq)	((rq)->cmd_flags & REQ_HARDBARRIER)
 #define blk_fua_rq(rq)		((rq)->cmd_flags & REQ_FUA)
 #define blk_discard_rq(rq)	((rq)->cmd_flags & REQ_DISCARD)
+#define blk_secure_rq(rq)	((rq)->cmd_flags & REQ_SECURE)
 #define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
 /* rq->queuelist of dequeued request must be list_empty() */
 #define blk_queued_rq(rq)	(!list_empty(&(rq)->queuelist))
@@ -1005,10 +1011,12 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 }
 enum{
 	BLKDEV_WAIT,	/* wait for completion */
-	BLKDEV_BARRIER,	/*issue request with barrier */
+	BLKDEV_BARRIER,	/* issue request with barrier */
+	BLKDEV_SECURE,	/* secure discard */
 };
 #define BLKDEV_IFL_WAIT		(1 << BLKDEV_WAIT)
 #define BLKDEV_IFL_BARRIER	(1 << BLKDEV_BARRIER)
+#define BLKDEV_IFL_SECURE	(1 << BLKDEV_SECURE)
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *,
 			unsigned long);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 471e1ff..03b6e88 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -167,6 +167,7 @@ struct inodes_stat_t {
  */
 #define DISCARD_NOBARRIER (WRITE | (1 << BIO_RW_DISCARD))
 #define DISCARD_BARRIER (DISCARD_NOBARRIER | (1 << BIO_RW_BARRIER))
+#define DISCARD_SECURE (DISCARD_NOBARRIER | (1 << BIO_RW_SECURE))
 
 #define SEL_IN		1
 #define SEL_OUT		2
@@ -309,6 +310,7 @@ struct inodes_stat_t {
 #define BLKALIGNOFF _IO(0x12,122)
 #define BLKPBSZGET _IO(0x12,123)
 #define BLKDISCARDZEROES _IO(0x12,124)
+#define BLKSECDISCARD _IO(0x12,125)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 638711c..1391ba3 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -664,6 +664,9 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 	if (blk_discard_rq(rq))
 		rw |= (1 << BIO_RW_DISCARD);
 
+	if (blk_secure_rq(rq))
+		rw |= (1 << BIO_RW_SECURE);
+
 	if (blk_pc_request(rq)) {
 		what |= BLK_TC_ACT(BLK_TC_PC);
 		__blk_add_trace(bt, 0, blk_rq_bytes(rq), rw,
@@ -1770,6 +1773,8 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
 		rwbs[i++] = 'S';
 	if (rw & 1 << BIO_RW_META)
 		rwbs[i++] = 'M';
+	if (rw & 1 << BIO_RW_SECURE)
+		rwbs[i++] = 'E';
 
 	rwbs[i] = '\0';
 }
@@ -1782,6 +1787,9 @@ void blk_fill_rwbs_rq(char *rwbs, struct request *rq)
 	if (blk_discard_rq(rq))
 		rw |= (1 << BIO_RW_DISCARD);
 
+	if (blk_secure_rq(rq))
+		rw |= (1 << BIO_RW_SECURE);
+
 	bytes = blk_rq_bytes(rq);
 
 	blk_fill_rwbs(rwbs, rw, bytes);
-- 
1.6.3.3

