Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab2AJSap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:30:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab2AJS2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:28:44 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com
Cc: linux-kernel@vger.kernel.org, winget@google.com, namhyung@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/9] block: add @req to bio_{front|back}_merge tracepoints
Date: Tue, 10 Jan 2012 10:28:20 -0800
Message-Id: <1326220106-5765-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1326220106-5765-1-git-send-email-tj@kernel.org>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bio_{front|back}_merge tracepoints report a bio merging into an
existing request but didn't specify which request the bio is being
merged into.  Add @req to it.  This makes it impossible to share the
event template with block_bio_queue - split it out.

@req isn't used or exported to userland at this point and there is no
userland visible behavior change.  Later changes will make use of the
extra parameter.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c             |    4 +-
 include/trace/events/block.h |   45 +++++++++++++++++++++++++++++++----------
 kernel/trace/blktrace.c      |    2 +
 3 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 15de223..dd45d6e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1179,7 +1179,7 @@ static bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
 	if (!ll_back_merge_fn(q, req, bio))
 		return false;
 
-	trace_block_bio_backmerge(q, bio);
+	trace_block_bio_backmerge(q, req, bio);
 
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
 		blk_rq_set_mixed_merge(req);
@@ -1202,7 +1202,7 @@ static bool bio_attempt_front_merge(struct request_queue *q,
 	if (!ll_front_merge_fn(q, req, bio))
 		return false;
 
-	trace_block_bio_frontmerge(q, bio);
+	trace_block_bio_frontmerge(q, req, bio);
 
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
 		blk_rq_set_mixed_merge(req);
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 05c5e61..983f8a8 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -241,11 +241,11 @@ TRACE_EVENT(block_bio_complete,
 		  __entry->nr_sector, __entry->error)
 );
 
-DECLARE_EVENT_CLASS(block_bio,
+DECLARE_EVENT_CLASS(block_bio_merge,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio),
+	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),
 
-	TP_ARGS(q, bio),
+	TP_ARGS(q, rq, bio),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
@@ -272,31 +272,33 @@ DECLARE_EVENT_CLASS(block_bio,
 /**
  * block_bio_backmerge - merging block operation to the end of an existing operation
  * @q: queue holding operation
+ * @rq: request bio is being merged into
  * @bio: new block operation to merge
  *
  * Merging block request @bio to the end of an existing block request
  * in queue @q.
  */
-DEFINE_EVENT(block_bio, block_bio_backmerge,
+DEFINE_EVENT(block_bio_merge, block_bio_backmerge,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio),
+	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),
 
-	TP_ARGS(q, bio)
+	TP_ARGS(q, rq, bio)
 );
 
 /**
  * block_bio_frontmerge - merging block operation to the beginning of an existing operation
  * @q: queue holding operation
+ * @rq: request bio is being merged into
  * @bio: new block operation to merge
  *
  * Merging block IO operation @bio to the beginning of an existing block
  * operation in queue @q.
  */
-DEFINE_EVENT(block_bio, block_bio_frontmerge,
+DEFINE_EVENT(block_bio_merge, block_bio_frontmerge,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio),
+	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),
 
-	TP_ARGS(q, bio)
+	TP_ARGS(q, rq, bio)
 );
 
 /**
@@ -306,11 +308,32 @@ DEFINE_EVENT(block_bio, block_bio_frontmerge,
  *
  * About to place the block IO operation @bio into queue @q.
  */
-DEFINE_EVENT(block_bio, block_bio_queue,
+TRACE_EVENT(block_bio_queue,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
 
-	TP_ARGS(q, bio)
+	TP_ARGS(q, bio),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev			)
+		__field( sector_t,	sector			)
+		__field( unsigned int,	nr_sector		)
+		__array( char,		rwbs,	RWBS_LEN	)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
 );
 
 DECLARE_EVENT_CLASS(block_get_rq,
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index cdea7b5..c1c8c97 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -797,6 +797,7 @@ static void blk_add_trace_bio_complete(void *ignore,
 
 static void blk_add_trace_bio_backmerge(void *ignore,
 					struct request_queue *q,
+					struct request *rq,
 					struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE, 0);
@@ -804,6 +805,7 @@ static void blk_add_trace_bio_backmerge(void *ignore,
 
 static void blk_add_trace_bio_frontmerge(void *ignore,
 					 struct request_queue *q,
+					 struct request *rq,
 					 struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_FRONTMERGE, 0);
-- 
1.7.3.1

