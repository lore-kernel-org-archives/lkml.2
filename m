Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab3AIQqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:46:15 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:39490 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3AIQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:46:13 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, chavey@google.com, Tejun Heo <tj@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
Subject: [PATCH 1/5] block: add missing block_bio_complete() tracepoint
Date: Wed,  9 Jan 2013 08:45:04 -0800
Message-Id: <1357749908-16562-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357749908-16562-1-git-send-email-tj@kernel.org>
References: <1357749908-16562-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bio completion didn't kick block_bio_complete TP.  Only dm was
explicitly triggering the TP on IO completion.  This makes
block_bio_complete TP useless for tracers which want to know about
bios, and all other bio based drivers skip generating blktrace
completion events.

This patch makes all bio completions via bio_endio() generate
block_bio_complete TP.

* Explicit trace_block_bio_complete() invocation removed from dm and
  the trace point is unexported.

* @rq dropped from trace_block_bio_complete().  bios may fly around
  w/o queue associated.  Verifying and accessing the assocaited queue
  belongs to TP probes.

* blktrace now gets both request and bio completions.  Make it ignore
  bio completions if request completion path is happening.

This makes all bio based drivers generate blktrace completion events
properly and makes the block_bio_complete TP actually useful.

v2: With this change, block_bio_complete TP could be invoked on sg
    commands which have bio's with %NULL bi_bdev.  Update TP
    assignment code to check whether bio->bi_bdev is %NULL before
    dereferencing.

Signed-off-by: Tejun Heo <tj@kernel.org>
Original-patch-by: Namhyung Kim <namhyung@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: dm-devel@redhat.com
---
 block/blk-core.c             |  1 -
 drivers/md/dm.c              |  1 -
 drivers/md/raid5.c           | 11 +----------
 fs/bio.c                     |  2 ++
 include/linux/blktrace_api.h |  1 +
 include/trace/events/block.h |  8 ++++----
 kernel/trace/blktrace.c      | 26 +++++++++++++++++++++++---
 7 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c973249..d915d07 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -39,7 +39,6 @@
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
-EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_unplug);
 
 DEFINE_IDA(blk_queue_ida);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c72e4d5..650ec28 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -627,7 +627,6 @@ static void dec_pending(struct dm_io *io, int error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
-			trace_block_bio_complete(md->queue, bio, io_error);
 			bio_endio(bio, io_error);
 		}
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 19d77a0..9ab506d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -184,8 +184,6 @@ static void return_io(struct bio *return_bi)
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
-		trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
-					 bi, 0);
 		bio_endio(bi, 0);
 		bi = return_bi;
 	}
@@ -3917,8 +3915,6 @@ static void raid5_align_endio(struct bio *bi, int error)
 	rdev_dec_pending(rdev, conf->mddev);
 
 	if (!error && uptodate) {
-		trace_block_bio_complete(bdev_get_queue(raid_bi->bi_bdev),
-					 raid_bi, 0);
 		bio_endio(raid_bi, 0);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
 			wake_up(&conf->wait_for_stripe);
@@ -4377,8 +4373,6 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 		if ( rw == WRITE )
 			md_write_end(mddev);
 
-		trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
-					 bi, 0);
 		bio_endio(bi, 0);
 	}
 }
@@ -4755,11 +4749,8 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 		handled++;
 	}
 	remaining = raid5_dec_bi_active_stripes(raid_bio);
-	if (remaining == 0) {
-		trace_block_bio_complete(bdev_get_queue(raid_bio->bi_bdev),
-					 raid_bio, 0);
+	if (remaining == 0)
 		bio_endio(raid_bio, 0);
-	}
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
 		wake_up(&conf->wait_for_stripe);
 	return handled;
diff --git a/fs/bio.c b/fs/bio.c
index b96fc6c..bb5768f 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1428,6 +1428,8 @@ void bio_endio(struct bio *bio, int error)
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+	trace_block_bio_complete(bio, error);
+
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 7c2e030..0ea61e0 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -12,6 +12,7 @@
 
 struct blk_trace {
 	int trace_state;
+	bool rq_based;
 	struct rchan *rchan;
 	unsigned long __percpu *sequence;
 	unsigned char __percpu *msg_data;
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 05c5e61..8a168db 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -206,7 +206,6 @@ TRACE_EVENT(block_bio_bounce,
 
 /**
  * block_bio_complete - completed all work on the block operation
- * @q: queue holding the block operation
  * @bio: block operation completed
  * @error: io error value
  *
@@ -215,9 +214,9 @@ TRACE_EVENT(block_bio_bounce,
  */
 TRACE_EVENT(block_bio_complete,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio, int error),
+	TP_PROTO(struct bio *bio, int error),
 
-	TP_ARGS(q, bio, error),
+	TP_ARGS(bio, error),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev		)
@@ -228,7 +227,8 @@ TRACE_EVENT(block_bio_complete,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->dev		= bio->bi_bdev ?
+					  bio->bi_bdev->bd_dev : 0;
 		__entry->sector		= bio->bi_sector;
 		__entry->nr_sector	= bio->bi_size >> 9;
 		__entry->error		= error;
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c0bd030..190d98f 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -739,6 +739,12 @@ static void blk_add_trace_rq_complete(void *ignore,
 				      struct request_queue *q,
 				      struct request *rq)
 {
+	struct blk_trace *bt = q->blk_trace;
+
+	/* if control ever passes through here, it's a request based driver */
+	if (unlikely(bt && !bt->rq_based))
+		bt->rq_based = true;
+
 	blk_add_trace_rq(q, rq, BLK_TA_COMPLETE);
 }
 
@@ -774,10 +780,24 @@ static void blk_add_trace_bio_bounce(void *ignore,
 	blk_add_trace_bio(q, bio, BLK_TA_BOUNCE, 0);
 }
 
-static void blk_add_trace_bio_complete(void *ignore,
-				       struct request_queue *q, struct bio *bio,
-				       int error)
+static void blk_add_trace_bio_complete(void *ignore, struct bio *bio, int error)
 {
+	struct request_queue *q;
+	struct blk_trace *bt;
+
+	if (!bio->bi_bdev)
+		return;
+
+	q = bdev_get_queue(bio->bi_bdev);
+	bt = q->blk_trace;
+
+	/*
+	 * Request based drivers will generate both rq and bio completions.
+	 * Ignore bio ones.
+	 */
+	if (likely(!bt) || bt->rq_based)
+		return;
+
 	blk_add_trace_bio(q, bio, BLK_TA_COMPLETE, error);
 }
 
-- 
1.8.0.2

