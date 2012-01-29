Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2A2Jll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 04:41:41 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60270 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2A2Jlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 04:41:39 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
Subject: [PATCH] block: add missing block_bio_complete() tracepoint
Date: Sun, 29 Jan 2012 18:41:33 +0900
Message-Id: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block_bio_complete() TP has been missed so long, so that bio-based
drivers haven't been able to trace its IO behavior. Add it.

In some rare cases, such as loop_switch, @bio->bi_bdev can be NULL.
Thus convert it to TRACE_EVENT_CONDITION() as Steven suggested.

>From now on, request-based drivers will also get BLK_TA_COMPLETEs for
all bio's in requests. This needs to be handled in userland properly.

Also remove external use of the TP in DM and unexport it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: dm-devel@redhat.com
---
* v2:
 - Merge previous patches into one as suggested by Tejun.
 - Drop BIO_COMPLETE_MASK. Now I think it should be handled in userland
   like other (maybe duplicated, in some sense) bio complete reports.

 block/blk-core.c             |    1 -
 drivers/md/dm.c              |    1 -
 fs/bio.c                     |    2 ++
 include/trace/events/block.h |    4 +++-
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1b4fd93af2c0..399c128f516c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -37,7 +37,6 @@
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
-EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 
 DEFINE_IDA(blk_queue_ida);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4720f68f817e..01185fa0eb74 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -648,7 +648,6 @@ static void dec_pending(struct dm_io *io, int error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
-			trace_block_bio_complete(md->queue, bio, io_error);
 			bio_endio(bio, io_error);
 		}
 	}
diff --git a/fs/bio.c b/fs/bio.c
index b1fe82cf88cf..14c03eaf384e 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1447,6 +1447,8 @@ void bio_endio(struct bio *bio, int error)
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+	trace_block_bio_complete(bdev_get_queue(bio->bi_bdev), bio, error);
+
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 05c5e61f0a7c..96955f4828b3 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -213,12 +213,14 @@ TRACE_EVENT(block_bio_bounce,
  * This tracepoint indicates there is no further work to do on this
  * block IO operation @bio.
  */
-TRACE_EVENT(block_bio_complete,
+TRACE_EVENT_CONDITION(block_bio_complete,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio, int error),
 
 	TP_ARGS(q, bio, error),
 
+	TP_CONDITION(bio->bi_bdev != NULL),
+
 	TP_STRUCT__entry(
 		__field( dev_t,		dev		)
 		__field( sector_t,	sector		)
-- 
1.7.8.2

