Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab1J2Xur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:50:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52327 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab1J2XuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:50:04 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/10] block, cfq: restructure io_cq creation path for io_context interface cleanup
Date: Sat, 29 Oct 2011 16:49:46 -0700
Message-Id: <1319932187-7631-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319932187-7631-1-git-send-email-tj@kernel.org>
References: <1319932187-7631-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add elevator_ops->elevator_init_icq_fn() and restructure
cfq_create_cic() and rename it to ioc_create_icq().

The new function expects its caller to pass in io_context, uses
elevator_type->icq_cache, handles generic init, calls the new elevator
operation for elevator specific initialization, and returns pointer to
created or looked up icq.  This leaves cfq_icq_pool variable without
any user.  Removed.

This prepares for io_context interface cleanup and doesn't introduce
any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/cfq-iosched.c      |   94 ++++++++++++++++++++--------------------------
 include/linux/elevator.h |    2 +
 2 files changed, 43 insertions(+), 53 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f6d3155..11f49d0 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -59,7 +59,6 @@ static const int cfq_hist_divisor = 4;
 #define RQ_CFQG(rq)		(struct cfq_group *) ((rq)->elv.priv[1])
 
 static struct kmem_cache *cfq_pool;
-static struct kmem_cache *cfq_icq_pool;
 
 #define CFQ_PRIO_LISTS		IOPRIO_BE_NR
 #define cfq_class_idle(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
@@ -2707,6 +2706,13 @@ static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfq_put_queue(cfqq);
 }
 
+static void cfq_init_icq(struct io_cq *icq)
+{
+	struct cfq_io_cq *cic = icq_to_cic(icq);
+
+	cic->ttime.last_end_request = jiffies;
+}
+
 static void cfq_exit_icq(struct io_cq *icq)
 {
 	struct cfq_io_cq *cic = icq_to_cic(icq);
@@ -2723,21 +2729,6 @@ static void cfq_exit_icq(struct io_cq *icq)
 	}
 }
 
-static struct cfq_io_cq *cfq_alloc_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
-{
-	struct cfq_io_cq *cic;
-
-	cic = kmem_cache_alloc_node(cfq_icq_pool, gfp_mask | __GFP_ZERO,
-							cfqd->queue->node);
-	if (cic) {
-		cic->ttime.last_end_request = jiffies;
-		INIT_LIST_HEAD(&cic->icq.q_node);
-		INIT_HLIST_NODE(&cic->icq.ioc_node);
-	}
-
-	return cic;
-}
-
 static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 {
 	struct task_struct *tsk = current;
@@ -2945,64 +2936,62 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
 }
 
 /**
- * cfq_create_cic - create and link a cfq_io_cq
- * @cfqd: cfqd of interest
+ * ioc_create_icq - create and link io_cq
+ * @q: request_queue of interest
  * @gfp_mask: allocation mask
  *
- * Make sure cfq_io_cq linking %current->io_context and @cfqd exists.  If
- * ioc and/or cic doesn't exist, they will be created using @gfp_mask.
+ * Make sure io_cq linking %current->io_context and @q exists.  If either
+ * io_context and/or icq don't exist, they will be created using @gfp_mask.
+ *
+ * The caller is responsible for ensuring @ioc won't go away and @q is
+ * alive and will stay alive until this function returns.
  */
-static int cfq_create_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
+static struct io_cq *ioc_create_icq(struct request_queue *q, gfp_t gfp_mask)
 {
-	struct request_queue *q = cfqd->queue;
-	struct io_cq *icq = NULL;
-	struct cfq_io_cq *cic;
+	struct elevator_type *et = q->elevator->type;
 	struct io_context *ioc;
-	int ret = -ENOMEM;
-
-	might_sleep_if(gfp_mask & __GFP_WAIT);
+	struct io_cq *icq;
 
 	/* allocate stuff */
 	ioc = create_io_context(current, gfp_mask, q->node);
 	if (!ioc)
-		goto out;
+		return NULL;
 
-	cic = cfq_alloc_cic(cfqd, gfp_mask);
-	if (!cic)
-		goto out;
-	icq = &cic->icq;
+	icq = kmem_cache_alloc_node(et->icq_cache, gfp_mask | __GFP_ZERO,
+				    q->node);
+	if (!icq)
+		return NULL;
 
-	ret = radix_tree_preload(gfp_mask);
-	if (ret)
-		goto out;
+	if (radix_tree_preload(gfp_mask) < 0) {
+		kmem_cache_free(et->icq_cache, icq);
+		return NULL;
+	}
 
 	icq->ioc = ioc;
-	icq->q = cfqd->queue;
+	icq->q = q;
+	INIT_LIST_HEAD(&icq->q_node);
+	INIT_HLIST_NODE(&icq->ioc_node);
 
 	/* lock both q and ioc and try to link @icq */
 	spin_lock_irq(q->queue_lock);
 	spin_lock(&ioc->lock);
 
-	ret = radix_tree_insert(&ioc->icq_tree, q->id, icq);
-	if (likely(!ret)) {
+	if (likely(!radix_tree_insert(&ioc->icq_tree, q->id, icq))) {
 		hlist_add_head(&icq->ioc_node, &ioc->icq_list);
 		list_add(&icq->q_node, &q->icq_list);
-		icq = NULL;
-	} else if (ret == -EEXIST) {
-		/* someone else already did it */
-		ret = 0;
+		if (et->ops.elevator_init_icq_fn)
+			et->ops.elevator_init_icq_fn(icq);
+	} else {
+		kmem_cache_free(et->icq_cache, icq);
+		icq = ioc_lookup_icq(ioc, q);
+		if (!icq)
+			printk(KERN_ERR "cfq: icq link failed!\n");
 	}
 
 	spin_unlock(&ioc->lock);
 	spin_unlock_irq(q->queue_lock);
-
 	radix_tree_preload_end();
-out:
-	if (ret)
-		printk(KERN_ERR "cfq: icq link failed!\n");
-	if (icq)
-		kmem_cache_free(cfq_icq_pool, icq);
-	return ret;
+	return icq;
 }
 
 /**
@@ -3022,7 +3011,6 @@ static struct cfq_io_cq *cfq_get_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
 	struct request_queue *q = cfqd->queue;
 	struct cfq_io_cq *cic = NULL;
 	struct io_context *ioc;
-	int err;
 
 	lockdep_assert_held(q->queue_lock);
 
@@ -3037,9 +3025,9 @@ static struct cfq_io_cq *cfq_get_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
 
 		/* slow path - unlock, create missing ones and retry */
 		spin_unlock_irq(q->queue_lock);
-		err = cfq_create_cic(cfqd, gfp_mask);
+		cic = icq_to_cic(ioc_create_icq(q, gfp_mask));
 		spin_lock_irq(q->queue_lock);
-		if (err)
+		if (!cic)
 			return NULL;
 	}
 
@@ -3975,6 +3963,7 @@ static struct elevator_type iosched_cfq = {
 		.elevator_completed_req_fn =	cfq_completed_request,
 		.elevator_former_req_fn =	elv_rb_former_request,
 		.elevator_latter_req_fn =	elv_rb_latter_request,
+		.elevator_init_icq_fn =		cfq_init_icq,
 		.elevator_exit_icq_fn =		cfq_exit_icq,
 		.elevator_set_req_fn =		cfq_set_request,
 		.elevator_put_req_fn =		cfq_put_request,
@@ -4028,7 +4017,6 @@ static int __init cfq_init(void)
 		kmem_cache_destroy(cfq_pool);
 		return ret;
 	}
-	cfq_icq_pool = iosched_cfq.icq_cache;
 
 	blkio_policy_register(&blkio_policy_cfq);
 
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 06e4dd56..c8f1e67 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -26,6 +26,7 @@ typedef struct request *(elevator_request_list_fn) (struct request_queue *, stru
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
 
+typedef void (elevator_init_icq_fn) (struct io_cq *);
 typedef void (elevator_exit_icq_fn) (struct io_cq *);
 typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
 typedef void (elevator_put_req_fn) (struct request *);
@@ -59,6 +60,7 @@ struct elevator_ops
 	elevator_request_list_fn *elevator_former_req_fn;
 	elevator_request_list_fn *elevator_latter_req_fn;
 
+	elevator_init_icq_fn *elevator_init_icq_fn;
 	elevator_exit_icq_fn *elevator_exit_icq_fn;
 
 	elevator_set_req_fn *elevator_set_req_fn;
-- 
1.7.3.1

