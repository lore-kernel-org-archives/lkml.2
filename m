Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929Ab1J2Xvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:51:31 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60795 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab1J2Xt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:49:58 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/10] block, cfq: move cfqd->icq_list to request_queue and add request->elv.icq
Date: Sat, 29 Oct 2011 16:49:42 -0700
Message-Id: <1319932187-7631-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319932187-7631-1-git-send-email-tj@kernel.org>
References: <1319932187-7631-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of icq management is about to be moved out of cfq into blk-ioc.
This patch prepares for it.

* Move cfqd->icq_list to request_queue->icq_list

* Make request explicitly point to icq instead of through elevator
  private data.  ->elevator_private[3] is replaced with sub struct elv
  which contains icq pointer and priv[2].  cfq is updated accordingly.

* Meaningless clearing of ->elevator_private[0] removed from
  elv_set_request().  At that point in code, the field was guaranteed
  to be %NULL anyway.

This patch doesn't introduce any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c       |    1 +
 block/cfq-iosched.c    |   28 +++++++++++-----------------
 block/elevator.c       |    2 --
 include/linux/blkdev.h |   10 ++++++++--
 4 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 74b44ab..5315f09 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -492,6 +492,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 		    laptop_mode_timer_fn, (unsigned long) q);
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
 	INIT_LIST_HEAD(&q->timeout_list);
+	INIT_LIST_HEAD(&q->icq_list);
 	INIT_LIST_HEAD(&q->flush_queue[0]);
 	INIT_LIST_HEAD(&q->flush_queue[1]);
 	INIT_LIST_HEAD(&q->flush_data_in_flight);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d2f16fc..9bc5ecc 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -54,9 +54,9 @@ static const int cfq_hist_divisor = 4;
 #define CFQQ_SECT_THR_NONROT	(sector_t)(2 * 32)
 #define CFQQ_SEEKY(cfqq)	(hweight32(cfqq->seek_history) > 32/8)
 
-#define RQ_CIC(rq)		icq_to_cic((rq)->elevator_private[0])
-#define RQ_CFQQ(rq)		(struct cfq_queue *) ((rq)->elevator_private[1])
-#define RQ_CFQG(rq)		(struct cfq_group *) ((rq)->elevator_private[2])
+#define RQ_CIC(rq)		icq_to_cic((rq)->elv.icq)
+#define RQ_CFQQ(rq)		(struct cfq_queue *) ((rq)->elv.priv[0])
+#define RQ_CFQG(rq)		(struct cfq_group *) ((rq)->elv.priv[1])
 
 static struct kmem_cache *cfq_pool;
 static struct kmem_cache *cfq_icq_pool;
@@ -297,8 +297,6 @@ struct cfq_data {
 	unsigned int cfq_group_idle;
 	unsigned int cfq_latency;
 
-	struct list_head icq_list;
-
 	/*
 	 * Fallback dummy cfqq for extreme OOM conditions
 	 */
@@ -3053,7 +3051,7 @@ static int cfq_create_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
 	ret = radix_tree_insert(&ioc->icq_tree, q->id, icq);
 	if (likely(!ret)) {
 		hlist_add_head(&icq->ioc_node, &ioc->icq_list);
-		list_add(&icq->q_node, &cfqd->icq_list);
+		list_add(&icq->q_node, &q->icq_list);
 		icq = NULL;
 	} else if (ret == -EEXIST) {
 		/* someone else already did it */
@@ -3605,12 +3603,10 @@ static void cfq_put_request(struct request *rq)
 
 		put_io_context(RQ_CIC(rq)->icq.ioc, cfqq->cfqd->queue);
 
-		rq->elevator_private[0] = NULL;
-		rq->elevator_private[1] = NULL;
-
 		/* Put down rq reference on cfqg */
 		cfq_put_cfqg(RQ_CFQG(rq));
-		rq->elevator_private[2] = NULL;
+		rq->elv.priv[0] = NULL;
+		rq->elv.priv[1] = NULL;
 
 		cfq_put_queue(cfqq);
 	}
@@ -3696,9 +3692,9 @@ new_queue:
 	cfqq->allocated[rw]++;
 
 	cfqq->ref++;
-	rq->elevator_private[0] = &cic->icq;
-	rq->elevator_private[1] = cfqq;
-	rq->elevator_private[2] = cfq_ref_get_cfqg(cfqq->cfqg);
+	rq->elv.icq = &cic->icq;
+	rq->elv.priv[0] = cfqq;
+	rq->elv.priv[1] = cfq_ref_get_cfqg(cfqq->cfqg);
 	spin_unlock_irq(q->queue_lock);
 	return 0;
 
@@ -3810,8 +3806,8 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	if (cfqd->active_queue)
 		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
 
-	while (!list_empty(&cfqd->icq_list)) {
-		struct io_cq *icq = list_entry(cfqd->icq_list.next,
+	while (!list_empty(&q->icq_list)) {
+		struct io_cq *icq = list_entry(q->icq_list.next,
 					       struct io_cq, q_node);
 		struct io_context *ioc = icq->ioc;
 
@@ -3922,8 +3918,6 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->oom_cfqq.ref++;
 	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, &cfqd->root_group);
 
-	INIT_LIST_HEAD(&cfqd->icq_list);
-
 	cfqd->queue = q;
 
 	init_timer(&cfqd->idle_slice_timer);
diff --git a/block/elevator.c b/block/elevator.c
index 31ffe76..c5c6214 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -745,8 +745,6 @@ int elv_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 
 	if (e->type->ops.elevator_set_req_fn)
 		return e->type->ops.elevator_set_req_fn(q, rq, gfp_mask);
-
-	rq->elevator_private[0] = NULL;
 	return 0;
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e4c10a0..6c7e09c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -111,10 +111,14 @@ struct request {
 	 * Three pointers are available for the IO schedulers, if they need
 	 * more they have to dynamically allocate it.  Flush requests are
 	 * never put on the IO scheduler. So let the flush fields share
-	 * space with the three elevator_private pointers.
+	 * space with the elevator data.
 	 */
 	union {
-		void *elevator_private[3];
+		struct {
+			struct io_cq		*icq;
+			void			*priv[2];
+		} elv;
+
 		struct {
 			unsigned int		seq;
 			struct list_head	list;
@@ -357,6 +361,8 @@ struct request_queue {
 	struct timer_list	timeout;
 	struct list_head	timeout_list;
 
+	struct list_head	icq_list;
+
 	struct queue_limits	limits;
 
 	/*
-- 
1.7.3.1

