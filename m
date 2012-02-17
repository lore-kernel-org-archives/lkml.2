Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2BQVUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:20:05 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39983 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2BQVUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:20:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.197.74 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Fri, 17 Feb 2012 13:19:58 -0800
From: Tejun Heo <tj@kernel.org>
To: dm-devel@redhat.com, Namhyung Kim <namhyung@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH for-3.3/core] block: add missing block_bio_complete()
 tracepoint
Message-ID: <20120217211958.GG29414@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
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

Signed-off-by: Tejun Heo <tj@kernel.org>
Original-patch-by: Namhyung Kim <namhyung@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: dm-devel@redhat.com
---
 block/blk-core.c             |    1 -
 drivers/md/dm.c              |    1 -
 fs/bio.c                     |    2 ++
 include/linux/blktrace_api.h |    1 +
 include/trace/events/block.h |    5 ++---
 kernel/trace/blktrace.c      |   26 +++++++++++++++++++++++---
 6 files changed, 28 insertions(+), 8 deletions(-)

Index: work/block/blk-core.c
===================================================================
--- work.orig/block/blk-core.c
+++ work/block/blk-core.c
@@ -37,7 +37,6 @@
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
-EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 
 DEFINE_IDA(blk_queue_ida);
 
Index: work/drivers/md/dm.c
===================================================================
--- work.orig/drivers/md/dm.c
+++ work/drivers/md/dm.c
@@ -647,7 +647,6 @@ static void dec_pending(struct dm_io *io
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
-			trace_block_bio_complete(md->queue, bio, io_error);
 			bio_endio(bio, io_error);
 		}
 	}
Index: work/fs/bio.c
===================================================================
--- work.orig/fs/bio.c
+++ work/fs/bio.c
@@ -1443,6 +1443,8 @@ void bio_endio(struct bio *bio, int erro
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+	trace_block_bio_complete(bio, error);
+
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
Index: work/include/trace/events/block.h
===================================================================
--- work.orig/include/trace/events/block.h
+++ work/include/trace/events/block.h
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
Index: work/kernel/trace/blktrace.c
===================================================================
--- work.orig/kernel/trace/blktrace.c
+++ work/kernel/trace/blktrace.c
@@ -753,6 +753,12 @@ static void blk_add_trace_rq_complete(vo
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
 
@@ -788,10 +794,24 @@ static void blk_add_trace_bio_bounce(voi
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
 
Index: work/include/linux/blktrace_api.h
===================================================================
--- work.orig/include/linux/blktrace_api.h
+++ work/include/linux/blktrace_api.h
@@ -151,6 +151,7 @@ struct blk_user_trace_setup {
 
 struct blk_trace {
 	int trace_state;
+	bool rq_based;
 	struct rchan *rchan;
 	unsigned long __percpu *sequence;
 	unsigned char __percpu *msg_data;
