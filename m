Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803Ab0HLMrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:47:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:38358 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab0HLMoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:44:21 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/11] block: misc cleanups in barrier code
Date: Thu, 12 Aug 2010 14:41:25 +0200
Message-Id: <1281616891-5691-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1281616891-5691-1-git-send-email-tj@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 12 Aug 2010 12:43:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the following cleanups in preparation of barrier/flush update.

* blk_do_ordered() declaration is moved from include/linux/blkdev.h to
  block/blk.h.

* blk_do_ordered() now returns pointer to struct request, with %NULL
  meaning "try the next request" and ERR_PTR(-EAGAIN) "try again
  later".  The third case will be dropped with further changes.

* In the initialization of proxy barrier request, data direction is
  already set by init_request_from_bio().  Drop unnecessary explicit
  REQ_WRITE setting and move init_request_from_bio() above REQ_FUA
  flag setting.

* add_request() is collapsed into __make_request().

These changes don't make any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-barrier.c    |   32 ++++++++++++++------------------
 block/blk-core.c       |   21 ++++-----------------
 block/blk.h            |    7 +++++--
 include/linux/blkdev.h |    1 -
 4 files changed, 23 insertions(+), 38 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index ed0aba5..f1be85b 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -110,9 +110,9 @@ static void queue_flush(struct request_queue *q, unsigned which)
 	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 }
 
-static inline bool start_ordered(struct request_queue *q, struct request **rqp)
+static inline struct request *start_ordered(struct request_queue *q,
+					    struct request *rq)
 {
-	struct request *rq = *rqp;
 	unsigned skip = 0;
 
 	q->orderr = 0;
@@ -149,11 +149,9 @@ static inline bool start_ordered(struct request_queue *q, struct request **rqp)
 
 		/* initialize proxy request and queue it */
 		blk_rq_init(q, rq);
-		if (bio_data_dir(q->orig_bar_rq->bio) == WRITE)
-			rq->cmd_flags |= REQ_WRITE;
+		init_request_from_bio(rq, q->orig_bar_rq->bio);
 		if (q->ordered & QUEUE_ORDERED_DO_FUA)
 			rq->cmd_flags |= REQ_FUA;
-		init_request_from_bio(rq, q->orig_bar_rq->bio);
 		rq->end_io = bar_end_io;
 
 		elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
@@ -171,27 +169,26 @@ static inline bool start_ordered(struct request_queue *q, struct request **rqp)
 	else
 		skip |= QUEUE_ORDSEQ_DRAIN;
 
-	*rqp = rq;
-
 	/*
 	 * Complete skipped sequences.  If whole sequence is complete,
-	 * return false to tell elevator that this request is gone.
+	 * return %NULL to tell elevator that this request is gone.
 	 */
-	return !blk_ordered_complete_seq(q, skip, 0);
+	if (blk_ordered_complete_seq(q, skip, 0))
+		rq = NULL;
+	return rq;
 }
 
-bool blk_do_ordered(struct request_queue *q, struct request **rqp)
+struct request *blk_do_ordered(struct request_queue *q, struct request *rq)
 {
-	struct request *rq = *rqp;
 	const int is_barrier = rq->cmd_type == REQ_TYPE_FS &&
 				(rq->cmd_flags & REQ_HARDBARRIER);
 
 	if (!q->ordseq) {
 		if (!is_barrier)
-			return true;
+			return rq;
 
 		if (q->next_ordered != QUEUE_ORDERED_NONE)
-			return start_ordered(q, rqp);
+			return start_ordered(q, rq);
 		else {
 			/*
 			 * Queue ordering not supported.  Terminate
@@ -199,8 +196,7 @@ bool blk_do_ordered(struct request_queue *q, struct request **rqp)
 			 */
 			blk_dequeue_request(rq);
 			__blk_end_request_all(rq, -EOPNOTSUPP);
-			*rqp = NULL;
-			return false;
+			return NULL;
 		}
 	}
 
@@ -211,14 +207,14 @@ bool blk_do_ordered(struct request_queue *q, struct request **rqp)
 	/* Special requests are not subject to ordering rules. */
 	if (rq->cmd_type != REQ_TYPE_FS &&
 	    rq != &q->pre_flush_rq && rq != &q->post_flush_rq)
-		return true;
+		return rq;
 
 	/* Ordered by draining.  Wait for turn. */
 	WARN_ON(blk_ordered_req_seq(rq) < blk_ordered_cur_seq(q));
 	if (blk_ordered_req_seq(rq) > blk_ordered_cur_seq(q))
-		*rqp = NULL;
+		rq = ERR_PTR(-EAGAIN);
 
-	return true;
+	return rq;
 }
 
 static void bio_end_empty_barrier(struct bio *bio, int err)
diff --git a/block/blk-core.c b/block/blk-core.c
index 3f802dd..ed8ef89 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1037,22 +1037,6 @@ void blk_insert_request(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL(blk_insert_request);
 
-/*
- * add-request adds a request to the linked list.
- * queue lock is held and interrupts disabled, as we muck with the
- * request queue list.
- */
-static inline void add_request(struct request_queue *q, struct request *req)
-{
-	drive_stat_acct(req, 1);
-
-	/*
-	 * elevator indicated where it wants this request to be
-	 * inserted at elevator_merge time
-	 */
-	__elv_add_request(q, req, ELEVATOR_INSERT_SORT, 0);
-}
-
 static void part_round_stats_single(int cpu, struct hd_struct *part,
 				    unsigned long now)
 {
@@ -1316,7 +1300,10 @@ get_rq:
 		req->cpu = blk_cpu_to_group(smp_processor_id());
 	if (queue_should_plug(q) && elv_queue_empty(q))
 		blk_plug_device(q);
-	add_request(q, req);
+
+	/* insert the request into the elevator */
+	drive_stat_acct(req, 1);
+	__elv_add_request(q, req, ELEVATOR_INSERT_SORT, 0);
 out:
 	if (unplug || !queue_should_plug(q))
 		__generic_unplug_device(q);
diff --git a/block/blk.h b/block/blk.h
index 6e7dc87..874eb4e 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -51,6 +51,8 @@ static inline void blk_clear_rq_complete(struct request *rq)
  */
 #define ELV_ON_HASH(rq)		(!hlist_unhashed(&(rq)->hash))
 
+struct request *blk_do_ordered(struct request_queue *q, struct request *rq);
+
 static inline struct request *__elv_next_request(struct request_queue *q)
 {
 	struct request *rq;
@@ -58,8 +60,9 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 	while (1) {
 		while (!list_empty(&q->queue_head)) {
 			rq = list_entry_rq(q->queue_head.next);
-			if (blk_do_ordered(q, &rq))
-				return rq;
+			rq = blk_do_ordered(q, rq);
+			if (rq)
+				return !IS_ERR(rq) ? rq : NULL;
 		}
 
 		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6003f7c..21baa19 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -867,7 +867,6 @@ extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern void blk_queue_flush(struct request_queue *q, unsigned int flush);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
-extern bool blk_do_ordered(struct request_queue *, struct request **);
 extern unsigned blk_ordered_cur_seq(struct request_queue *);
 extern unsigned blk_ordered_req_seq(struct request *);
 extern bool blk_ordered_complete_seq(struct request_queue *, unsigned, int);
-- 
1.7.1

