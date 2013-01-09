Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab3AIQqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:46:17 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:63880 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab3AIQqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:46:15 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, chavey@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] block: add @req to bio_{front|back}_merge tracepoints
Date: Wed,  9 Jan 2013 08:45:05 -0800
Message-Id: <1357749908-16562-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357749908-16562-1-git-send-email-tj@kernel.org>
References: <1357749908-16562-1-git-send-email-tj@kernel.org>
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
 block/blk-core.c             |  4 ++--
 include/trace/events/block.h | 45 +++++++++++++++++++++++++++++++++-----------
 kernel/trace/blktrace.c      |  2 ++
 3 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d915d07..7d6910a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1347,7 +1347,7 @@ static bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
 	if (!ll_back_merge_fn(q, req, bio))
 		return false;
 
-	trace_block_bio_backmerge(q, bio);
+	trace_block_bio_backmerge(q, req, bio);
 
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
 		blk_rq_set_mixed_merge(req);
@@ -1369,7 +1369,7 @@ static bool bio_attempt_front_merge(struct request_queue *q,
 	if (!ll_front_merge_fn(q, req, bio))
 		return false;
 
-	trace_block_bio_frontmerge(q, bio);
+	trace_block_bio_frontmerge(q, req, bio);
 
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
 		blk_rq_set_mixed_merge(req);
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 8a168db..b408f51 100644
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
index 190d98f..fb593f6 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -803,6 +803,7 @@ static void blk_add_trace_bio_complete(void *ignore, struct bio *bio, int error)
 
 static void blk_add_trace_bio_backmerge(void *ignore,
 					struct request_queue *q,
+					struct request *rq,
 					struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE, 0);
@@ -810,6 +811,7 @@ static void blk_add_trace_bio_backmerge(void *ignore,
 
 static void blk_add_trace_bio_frontmerge(void *ignore,
 					 struct request_queue *q,
+					 struct request *rq,
 					 struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_FRONTMERGE, 0);
-- 
1.8.0.2

