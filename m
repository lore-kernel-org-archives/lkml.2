Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933935Ab1J2Xvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:51:45 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60795 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933628Ab1J2Xt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:49:57 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] block, cfq: reorganize cfq_io_context into generic and cfq specific parts
Date: Sat, 29 Oct 2011 16:49:41 -0700
Message-Id: <1319932187-7631-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319932187-7631-1-git-send-email-tj@kernel.org>
References: <1319932187-7631-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently io_context and cfq logics are mixed without clear boundary.
Most of io_context is independent from cfq but cfq_io_context handling
logic is dispersed between generic ioc code and cfq.

cfq_io_context represents association between an io_context and a
request_queue, which is a concept useful outside of cfq, but it also
contains fields which are useful only to cfq.

This patch takes out generic part and put it into io_cq (io
context-queue) and the rest into cfq_io_cq (cic moniker remains the
same) which contains io_cq.  The following changes are made together.

* cfq_ttime and cfq_io_cq now live in cfq-iosched.c.

* All related fields, functions and constants are renamed accordingly.

* ioc->ioc_data is now "struct io_cq *" instead of "void *" and
  renamed to icq_hint.

This prepares for io_context API cleanup.  Documentation is currently
sparse.  It will be added later.

Changes in this patch are mechanical and don't cause functional
change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-ioc.c           |   58 +++++------
 block/cfq-iosched.c       |  248 ++++++++++++++++++++++++---------------------
 include/linux/iocontext.h |   43 +++-----
 3 files changed, 175 insertions(+), 174 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index e23c797..dc5e69d 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -46,7 +46,7 @@ EXPORT_SYMBOL(get_io_context);
 
 /*
  * Slow path for ioc release in put_io_context().  Performs double-lock
- * dancing to unlink all cic's and then frees ioc.
+ * dancing to unlink all icq's and then frees ioc.
  */
 static void ioc_release_fn(struct work_struct *work)
 {
@@ -56,11 +56,10 @@ static void ioc_release_fn(struct work_struct *work)
 
 	spin_lock_irq(&ioc->lock);
 
-	while (!hlist_empty(&ioc->cic_list)) {
-		struct cfq_io_context *cic = hlist_entry(ioc->cic_list.first,
-							 struct cfq_io_context,
-							 cic_list);
-		struct request_queue *this_q = cic->q;
+	while (!hlist_empty(&ioc->icq_list)) {
+		struct io_cq *icq = hlist_entry(ioc->icq_list.first,
+						struct io_cq, ioc_node);
+		struct request_queue *this_q = icq->q;
 
 		if (this_q != last_q) {
 			/*
@@ -89,8 +88,8 @@ static void ioc_release_fn(struct work_struct *work)
 			continue;
 		}
 		ioc_release_depth_inc(this_q);
-		cic->exit(cic);
-		cic->release(cic);
+		icq->exit(icq);
+		icq->release(icq);
 		ioc_release_depth_dec(this_q);
 	}
 
@@ -131,10 +130,10 @@ void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
 		return;
 
 	/*
-	 * Destroy @ioc.  This is a bit messy because cic's are chained
+	 * Destroy @ioc.  This is a bit messy because icq's are chained
 	 * from both ioc and queue, and ioc->lock nests inside queue_lock.
-	 * The inner ioc->lock should be held to walk our cic_list and then
-	 * for each cic the outer matching queue_lock should be grabbed.
+	 * The inner ioc->lock should be held to walk our icq_list and then
+	 * for each icq the outer matching queue_lock should be grabbed.
 	 * ie. We need to do reverse-order double lock dancing.
 	 *
 	 * Another twist is that we are often called with one of the
@@ -153,11 +152,10 @@ void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
 	spin_lock_irqsave_nested(&ioc->lock, flags,
 				 ioc_release_depth(locked_q));
 
-	while (!hlist_empty(&ioc->cic_list)) {
-		struct cfq_io_context *cic = hlist_entry(ioc->cic_list.first,
-							 struct cfq_io_context,
-							 cic_list);
-		struct request_queue *this_q = cic->q;
+	while (!hlist_empty(&ioc->icq_list)) {
+		struct io_cq *icq = hlist_entry(ioc->icq_list.first,
+						struct io_cq, ioc_node);
+		struct request_queue *this_q = icq->q;
 
 		if (this_q != last_q) {
 			if (last_q && last_q != locked_q)
@@ -170,8 +168,8 @@ void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
 			continue;
 		}
 		ioc_release_depth_inc(this_q);
-		cic->exit(cic);
-		cic->release(cic);
+		icq->exit(icq);
+		icq->release(icq);
 		ioc_release_depth_dec(this_q);
 	}
 
@@ -180,8 +178,8 @@ void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
 
 	spin_unlock_irqrestore(&ioc->lock, flags);
 
-	/* if no cic's left, we're done; otherwise, kick release_work */
-	if (hlist_empty(&ioc->cic_list))
+	/* if no icq is left, we're done; otherwise, kick release_work */
+	if (hlist_empty(&ioc->icq_list))
 		kmem_cache_free(iocontext_cachep, ioc);
 	else
 		schedule_work(&ioc->release_work);
@@ -219,8 +217,8 @@ void create_io_context_slowpath(struct task_struct *task, gfp_t gfp_flags,
 	atomic_long_set(&ioc->refcount, 1);
 	atomic_set(&ioc->nr_tasks, 1);
 	spin_lock_init(&ioc->lock);
-	INIT_RADIX_TREE(&ioc->radix_root, GFP_ATOMIC | __GFP_HIGH);
-	INIT_HLIST_HEAD(&ioc->cic_list);
+	INIT_RADIX_TREE(&ioc->icq_tree, GFP_ATOMIC | __GFP_HIGH);
+	INIT_HLIST_HEAD(&ioc->icq_list);
 	INIT_WORK(&ioc->release_work, ioc_release_fn);
 
 	/* try to install, somebody might already have beaten us to it */
@@ -270,11 +268,11 @@ EXPORT_SYMBOL(get_task_io_context);
 
 void ioc_set_changed(struct io_context *ioc, int which)
 {
-	struct cfq_io_context *cic;
+	struct io_cq *icq;
 	struct hlist_node *n;
 
-	hlist_for_each_entry(cic, n, &ioc->cic_list, cic_list)
-		set_bit(which, &cic->changed);
+	hlist_for_each_entry(icq, n, &ioc->icq_list, ioc_node)
+		set_bit(which, &icq->changed);
 }
 
 /**
@@ -282,8 +280,8 @@ void ioc_set_changed(struct io_context *ioc, int which)
  * @ioc: io_context of interest
  * @ioprio: new ioprio
  *
- * @ioc's ioprio has changed to @ioprio.  Set %CIC_IOPRIO_CHANGED for all
- * cic's.  iosched is responsible for checking the bit and applying it on
+ * @ioc's ioprio has changed to @ioprio.  Set %ICQ_IOPRIO_CHANGED for all
+ * icq's.  iosched is responsible for checking the bit and applying it on
  * request issue path.
  */
 void ioc_ioprio_changed(struct io_context *ioc, int ioprio)
@@ -292,7 +290,7 @@ void ioc_ioprio_changed(struct io_context *ioc, int ioprio)
 
 	spin_lock_irqsave(&ioc->lock, flags);
 	ioc->ioprio = ioprio;
-	ioc_set_changed(ioc, CIC_IOPRIO_CHANGED);
+	ioc_set_changed(ioc, ICQ_IOPRIO_CHANGED);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 }
 
@@ -300,7 +298,7 @@ void ioc_ioprio_changed(struct io_context *ioc, int ioprio)
  * ioc_cgroup_changed - notify cgroup change
  * @ioc: io_context of interest
  *
- * @ioc's cgroup has changed.  Set %CIC_CGROUP_CHANGED for all cic's.
+ * @ioc's cgroup has changed.  Set %ICQ_CGROUP_CHANGED for all icq's.
  * iosched is responsible for checking the bit and applying it on request
  * issue path.
  */
@@ -309,7 +307,7 @@ void ioc_cgroup_changed(struct io_context *ioc)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->lock, flags);
-	ioc_set_changed(ioc, CIC_CGROUP_CHANGED);
+	ioc_set_changed(ioc, ICQ_CGROUP_CHANGED);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 }
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5f7e4d1..d2f16fc 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -54,13 +54,12 @@ static const int cfq_hist_divisor = 4;
 #define CFQQ_SECT_THR_NONROT	(sector_t)(2 * 32)
 #define CFQQ_SEEKY(cfqq)	(hweight32(cfqq->seek_history) > 32/8)
 
-#define RQ_CIC(rq)		\
-	((struct cfq_io_context *) (rq)->elevator_private[0])
+#define RQ_CIC(rq)		icq_to_cic((rq)->elevator_private[0])
 #define RQ_CFQQ(rq)		(struct cfq_queue *) ((rq)->elevator_private[1])
 #define RQ_CFQG(rq)		(struct cfq_group *) ((rq)->elevator_private[2])
 
 static struct kmem_cache *cfq_pool;
-static struct kmem_cache *cfq_ioc_pool;
+static struct kmem_cache *cfq_icq_pool;
 
 #define CFQ_PRIO_LISTS		IOPRIO_BE_NR
 #define cfq_class_idle(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
@@ -69,6 +68,14 @@ static struct kmem_cache *cfq_ioc_pool;
 #define sample_valid(samples)	((samples) > 80)
 #define rb_entry_cfqg(node)	rb_entry((node), struct cfq_group, rb_node)
 
+struct cfq_ttime {
+	unsigned long last_end_request;
+
+	unsigned long ttime_total;
+	unsigned long ttime_samples;
+	unsigned long ttime_mean;
+};
+
 /*
  * Most of our rbtree usage is for sorting with min extraction, so
  * if we cache the leftmost node we don't have to walk down the tree
@@ -210,6 +217,12 @@ struct cfq_group {
 	struct cfq_ttime ttime;
 };
 
+struct cfq_io_cq {
+	struct io_cq		icq;		/* must be the first member */
+	struct cfq_queue	*cfqq[2];
+	struct cfq_ttime	ttime;
+};
+
 /*
  * Per block device queue structure
  */
@@ -261,7 +274,7 @@ struct cfq_data {
 	struct work_struct unplug_work;
 
 	struct cfq_queue *active_queue;
-	struct cfq_io_context *active_cic;
+	struct cfq_io_cq *active_cic;
 
 	/*
 	 * async queue for each priority case
@@ -284,7 +297,7 @@ struct cfq_data {
 	unsigned int cfq_group_idle;
 	unsigned int cfq_latency;
 
-	struct list_head cic_list;
+	struct list_head icq_list;
 
 	/*
 	 * Fallback dummy cfqq for extreme OOM conditions
@@ -457,24 +470,28 @@ static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
 				       struct io_context *, gfp_t);
-static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
-						struct io_context *);
+static struct cfq_io_cq *cfq_cic_lookup(struct cfq_data *, struct io_context *);
 
-static inline struct cfq_queue *cic_to_cfqq(struct cfq_io_context *cic,
-					    bool is_sync)
+static inline struct cfq_io_cq *icq_to_cic(struct io_cq *icq)
+{
+	/* cic->icq is the first member, %NULL will convert to %NULL */
+	return container_of(icq, struct cfq_io_cq, icq);
+}
+
+static inline struct cfq_queue *cic_to_cfqq(struct cfq_io_cq *cic, bool is_sync)
 {
 	return cic->cfqq[is_sync];
 }
 
-static inline void cic_set_cfqq(struct cfq_io_context *cic,
-				struct cfq_queue *cfqq, bool is_sync)
+static inline void cic_set_cfqq(struct cfq_io_cq *cic, struct cfq_queue *cfqq,
+				bool is_sync)
 {
 	cic->cfqq[is_sync] = cfqq;
 }
 
-static inline struct cfq_data *cic_to_cfqd(struct cfq_io_context *cic)
+static inline struct cfq_data *cic_to_cfqd(struct cfq_io_cq *cic)
 {
-	return cic->q->elevator->elevator_data;
+	return cic->icq.q->elevator->elevator_data;
 }
 
 /*
@@ -1541,7 +1558,7 @@ static struct request *
 cfq_find_rq_fmerge(struct cfq_data *cfqd, struct bio *bio)
 {
 	struct task_struct *tsk = current;
-	struct cfq_io_context *cic;
+	struct cfq_io_cq *cic;
 	struct cfq_queue *cfqq;
 
 	cic = cfq_cic_lookup(cfqd, tsk->io_context);
@@ -1655,7 +1672,7 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 			   struct bio *bio)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
-	struct cfq_io_context *cic;
+	struct cfq_io_cq *cic;
 	struct cfq_queue *cfqq;
 
 	/*
@@ -1671,7 +1688,7 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 	 * and %current are guaranteed to be equal.  Avoid lookup which
 	 * requires queue_lock by using @rq's cic.
 	 */
-	if (current->io_context == RQ_CIC(rq)->ioc) {
+	if (current->io_context == RQ_CIC(rq)->icq.ioc) {
 		cic = RQ_CIC(rq);
 	} else {
 		cic = cfq_cic_lookup(cfqd, current->io_context);
@@ -1761,7 +1778,7 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfqd->active_queue = NULL;
 
 	if (cfqd->active_cic) {
-		put_io_context(cfqd->active_cic->ioc, cfqd->queue);
+		put_io_context(cfqd->active_cic->icq.ioc, cfqd->queue);
 		cfqd->active_cic = NULL;
 	}
 }
@@ -1981,7 +1998,7 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
-	struct cfq_io_context *cic;
+	struct cfq_io_cq *cic;
 	unsigned long sl, group_idle = 0;
 
 	/*
@@ -2016,7 +2033,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 * task has exited, don't wait
 	 */
 	cic = cfqd->active_cic;
-	if (!cic || !atomic_read(&cic->ioc->nr_tasks))
+	if (!cic || !atomic_read(&cic->icq.ioc->nr_tasks))
 		return;
 
 	/*
@@ -2567,9 +2584,9 @@ static bool cfq_dispatch_request(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfq_dispatch_insert(cfqd->queue, rq);
 
 	if (!cfqd->active_cic) {
-		struct cfq_io_context *cic = RQ_CIC(rq);
+		struct cfq_io_cq *cic = RQ_CIC(rq);
 
-		atomic_long_inc(&cic->ioc->refcount);
+		atomic_long_inc(&cic->icq.ioc->refcount);
 		cfqd->active_cic = cic;
 	}
 
@@ -2652,24 +2669,24 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	cfq_put_cfqg(cfqg);
 }
 
-static void cfq_cic_free_rcu(struct rcu_head *head)
+static void cfq_icq_free_rcu(struct rcu_head *head)
 {
-	kmem_cache_free(cfq_ioc_pool,
-			container_of(head, struct cfq_io_context, rcu_head));
+	kmem_cache_free(cfq_icq_pool,
+			icq_to_cic(container_of(head, struct io_cq, rcu_head)));
 }
 
-static void cfq_cic_free(struct cfq_io_context *cic)
+static void cfq_icq_free(struct io_cq *icq)
 {
-	call_rcu(&cic->rcu_head, cfq_cic_free_rcu);
+	call_rcu(&icq->rcu_head, cfq_icq_free_rcu);
 }
 
-static void cfq_release_cic(struct cfq_io_context *cic)
+static void cfq_release_icq(struct io_cq *icq)
 {
-	struct io_context *ioc = cic->ioc;
+	struct io_context *ioc = icq->ioc;
 
-	radix_tree_delete(&ioc->radix_root, cic->q->id);
-	hlist_del(&cic->cic_list);
-	cfq_cic_free(cic);
+	radix_tree_delete(&ioc->icq_tree, icq->q->id);
+	hlist_del(&icq->ioc_node);
+	cfq_icq_free(icq);
 }
 
 static void cfq_put_cooperator(struct cfq_queue *cfqq)
@@ -2705,20 +2722,21 @@ static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfq_put_queue(cfqq);
 }
 
-static void cfq_exit_cic(struct cfq_io_context *cic)
+static void cfq_exit_icq(struct io_cq *icq)
 {
+	struct cfq_io_cq *cic = icq_to_cic(icq);
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
-	struct io_context *ioc = cic->ioc;
+	struct io_context *ioc = icq->ioc;
 
-	list_del_init(&cic->queue_list);
+	list_del_init(&icq->q_node);
 
 	/*
-	 * Both setting lookup hint to and clearing it from @cic are done
-	 * under queue_lock.  If it's not pointing to @cic now, it never
+	 * Both setting lookup hint to and clearing it from @icq are done
+	 * under queue_lock.  If it's not pointing to @icq now, it never
 	 * will.  Hint assignment itself can race safely.
 	 */
-	if (rcu_dereference_raw(ioc->ioc_data) == cic)
-		rcu_assign_pointer(ioc->ioc_data, NULL);
+	if (rcu_dereference_raw(ioc->icq_hint) == icq)
+		rcu_assign_pointer(ioc->icq_hint, NULL);
 
 	if (cic->cfqq[BLK_RW_ASYNC]) {
 		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);
@@ -2731,19 +2749,18 @@ static void cfq_exit_cic(struct cfq_io_context *cic)
 	}
 }
 
-static struct cfq_io_context *
-cfq_alloc_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
+static struct cfq_io_cq *cfq_alloc_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
 {
-	struct cfq_io_context *cic;
+	struct cfq_io_cq *cic;
 
-	cic = kmem_cache_alloc_node(cfq_ioc_pool, gfp_mask | __GFP_ZERO,
+	cic = kmem_cache_alloc_node(cfq_icq_pool, gfp_mask | __GFP_ZERO,
 							cfqd->queue->node);
 	if (cic) {
 		cic->ttime.last_end_request = jiffies;
-		INIT_LIST_HEAD(&cic->queue_list);
-		INIT_HLIST_NODE(&cic->cic_list);
-		cic->exit = cfq_exit_cic;
-		cic->release = cfq_release_cic;
+		INIT_LIST_HEAD(&cic->icq.q_node);
+		INIT_HLIST_NODE(&cic->icq.ioc_node);
+		cic->icq.exit = cfq_exit_icq;
+		cic->icq.release = cfq_release_icq;
 	}
 
 	return cic;
@@ -2791,7 +2808,7 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 	cfq_clear_cfqq_prio_changed(cfqq);
 }
 
-static void changed_ioprio(struct cfq_io_context *cic)
+static void changed_ioprio(struct cfq_io_cq *cic)
 {
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
 	struct cfq_queue *cfqq;
@@ -2802,7 +2819,7 @@ static void changed_ioprio(struct cfq_io_context *cic)
 	cfqq = cic->cfqq[BLK_RW_ASYNC];
 	if (cfqq) {
 		struct cfq_queue *new_cfqq;
-		new_cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic->ioc,
+		new_cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic->icq.ioc,
 						GFP_ATOMIC);
 		if (new_cfqq) {
 			cic->cfqq[BLK_RW_ASYNC] = new_cfqq;
@@ -2836,7 +2853,7 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-static void changed_cgroup(struct cfq_io_context *cic)
+static void changed_cgroup(struct cfq_io_cq *cic)
 {
 	struct cfq_queue *sync_cfqq = cic_to_cfqq(cic, 1);
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
@@ -2864,7 +2881,7 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 		     struct io_context *ioc, gfp_t gfp_mask)
 {
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
-	struct cfq_io_context *cic;
+	struct cfq_io_cq *cic;
 	struct cfq_group *cfqg;
 
 retry:
@@ -2956,56 +2973,57 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
 }
 
 /**
- * cfq_cic_lookup - lookup cfq_io_context
+ * cfq_cic_lookup - lookup cfq_io_cq
  * @cfqd: the associated cfq_data
  * @ioc: the associated io_context
  *
- * Look up cfq_io_context associated with @cfqd - @ioc pair.  Must be
- * called with queue_lock held.
+ * Look up cfq_io_cq associated with @cfqd - @ioc pair.  Must be called
+ * with queue_lock held.
  */
-static struct cfq_io_context *
+static struct cfq_io_cq *
 cfq_cic_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 {
 	struct request_queue *q = cfqd->queue;
-	struct cfq_io_context *cic;
+	struct io_cq *icq;
 
 	lockdep_assert_held(cfqd->queue->queue_lock);
 	if (unlikely(!ioc))
 		return NULL;
 
 	/*
-	 * cic's are indexed from @ioc using radix tree and hint pointer,
+	 * icq's are indexed from @ioc using radix tree and hint pointer,
 	 * both of which are protected with RCU.  All removals are done
 	 * holding both q and ioc locks, and we're holding q lock - if we
-	 * find a cic which points to us, it's guaranteed to be valid.
+	 * find a icq which points to us, it's guaranteed to be valid.
 	 */
 	rcu_read_lock();
-	cic = rcu_dereference(ioc->ioc_data);
-	if (cic && cic->q == q)
+	icq = rcu_dereference(ioc->icq_hint);
+	if (icq && icq->q == q)
 		goto out;
 
-	cic = radix_tree_lookup(&ioc->radix_root, cfqd->queue->id);
-	if (cic && cic->q == q)
-		rcu_assign_pointer(ioc->ioc_data, cic);	/* allowed to race */
+	icq = radix_tree_lookup(&ioc->icq_tree, cfqd->queue->id);
+	if (icq && icq->q == q)
+		rcu_assign_pointer(ioc->icq_hint, icq);	/* allowed to race */
 	else
-		cic = NULL;
+		icq = NULL;
 out:
 	rcu_read_unlock();
-	return cic;
+	return icq_to_cic(icq);
 }
 
 /**
- * cfq_create_cic - create and link a cfq_io_context
+ * cfq_create_cic - create and link a cfq_io_cq
  * @cfqd: cfqd of interest
  * @gfp_mask: allocation mask
  *
- * Make sure cfq_io_context linking %current->io_context and @cfqd exists.
- * If ioc and/or cic doesn't exist, they will be created using @gfp_mask.
+ * Make sure cfq_io_cq linking %current->io_context and @cfqd exists.  If
+ * ioc and/or cic doesn't exist, they will be created using @gfp_mask.
  */
 static int cfq_create_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
 {
 	struct request_queue *q = cfqd->queue;
-	struct cfq_io_context *cic = NULL;
+	struct io_cq *icq = NULL;
+	struct cfq_io_cq *cic;
 	struct io_context *ioc;
 	int ret = -ENOMEM;
 
@@ -3016,26 +3034,27 @@ static int cfq_create_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
 	if (!ioc)
 		goto out;
 
-	cic = cfq_alloc_io_context(cfqd, gfp_mask);
+	cic = cfq_alloc_cic(cfqd, gfp_mask);
 	if (!cic)
 		goto out;
+	icq = &cic->icq;
 
 	ret = radix_tree_preload(gfp_mask);
 	if (ret)
 		goto out;
 
-	cic->ioc = ioc;
-	cic->q = cfqd->queue;
+	icq->ioc = ioc;
+	icq->q = cfqd->queue;
 
-	/* lock both q and ioc and try to link @cic */
+	/* lock both q and ioc and try to link @icq */
 	spin_lock_irq(q->queue_lock);
 	spin_lock(&ioc->lock);
 
-	ret = radix_tree_insert(&ioc->radix_root, q->id, cic);
+	ret = radix_tree_insert(&ioc->icq_tree, q->id, icq);
 	if (likely(!ret)) {
-		hlist_add_head(&cic->cic_list, &ioc->cic_list);
-		list_add(&cic->queue_list, &cfqd->cic_list);
-		cic = NULL;
+		hlist_add_head(&icq->ioc_node, &ioc->icq_list);
+		list_add(&icq->q_node, &cfqd->icq_list);
+		icq = NULL;
 	} else if (ret == -EEXIST) {
 		/* someone else already did it */
 		ret = 0;
@@ -3047,29 +3066,28 @@ static int cfq_create_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
 	radix_tree_preload_end();
 out:
 	if (ret)
-		printk(KERN_ERR "cfq: cic link failed!\n");
-	if (cic)
-		cfq_cic_free(cic);
+		printk(KERN_ERR "cfq: icq link failed!\n");
+	if (icq)
+		cfq_icq_free(icq);
 	return ret;
 }
 
 /**
- * cfq_get_io_context - acquire cfq_io_context and bump refcnt on io_context
+ * cfq_get_cic - acquire cfq_io_cq and bump refcnt on io_context
  * @cfqd: cfqd to setup cic for
  * @gfp_mask: allocation mask
  *
- * Return cfq_io_context associating @cfqd and %current->io_context and
+ * Return cfq_io_cq associating @cfqd and %current->io_context and
  * bump refcnt on io_context.  If ioc or cic doesn't exist, they're created
  * using @gfp_mask.
  *
  * Must be called under queue_lock which may be released and re-acquired.
  * This function also may sleep depending on @gfp_mask.
  */
-static struct cfq_io_context *
-cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
+static struct cfq_io_cq *cfq_get_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
 {
 	struct request_queue *q = cfqd->queue;
-	struct cfq_io_context *cic = NULL;
+	struct cfq_io_cq *cic = NULL;
 	struct io_context *ioc;
 	int err;
 
@@ -3095,11 +3113,11 @@ cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 	/* bump @ioc's refcnt and handle changed notifications */
 	get_io_context(ioc);
 
-	if (unlikely(cic->changed)) {
-		if (test_and_clear_bit(CIC_IOPRIO_CHANGED, &cic->changed))
+	if (unlikely(cic->icq.changed)) {
+		if (test_and_clear_bit(ICQ_IOPRIO_CHANGED, &cic->icq.changed))
 			changed_ioprio(cic);
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-		if (test_and_clear_bit(CIC_CGROUP_CHANGED, &cic->changed))
+		if (test_and_clear_bit(ICQ_CGROUP_CHANGED, &cic->icq.changed))
 			changed_cgroup(cic);
 #endif
 	}
@@ -3120,7 +3138,7 @@ __cfq_update_io_thinktime(struct cfq_ttime *ttime, unsigned long slice_idle)
 
 static void
 cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
-	struct cfq_io_context *cic)
+			struct cfq_io_cq *cic)
 {
 	if (cfq_cfqq_sync(cfqq)) {
 		__cfq_update_io_thinktime(&cic->ttime, cfqd->cfq_slice_idle);
@@ -3158,7 +3176,7 @@ cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
  */
 static void
 cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
-		       struct cfq_io_context *cic)
+		       struct cfq_io_cq *cic)
 {
 	int old_idle, enable_idle;
 
@@ -3175,8 +3193,9 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	if (cfqq->next_rq && (cfqq->next_rq->cmd_flags & REQ_NOIDLE))
 		enable_idle = 0;
-	else if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
+	else if (!atomic_read(&cic->icq.ioc->nr_tasks) ||
+		 !cfqd->cfq_slice_idle ||
+		 (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime.ttime_samples)) {
 		if (cic->ttime.ttime_mean > cfqd->cfq_slice_idle)
@@ -3308,7 +3327,7 @@ static void
 cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		struct request *rq)
 {
-	struct cfq_io_context *cic = RQ_CIC(rq);
+	struct cfq_io_cq *cic = RQ_CIC(rq);
 
 	cfqd->rq_queued++;
 	if (rq->cmd_flags & REQ_PRIO)
@@ -3361,7 +3380,7 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 
 	cfq_log_cfqq(cfqd, cfqq, "insert_request");
-	cfq_init_prio_data(cfqq, RQ_CIC(rq)->ioc);
+	cfq_init_prio_data(cfqq, RQ_CIC(rq)->icq.ioc);
 
 	rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
 	list_add_tail(&rq->queuelist, &cfqq->fifo);
@@ -3411,7 +3430,7 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
 
 static bool cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
-	struct cfq_io_context *cic = cfqd->active_cic;
+	struct cfq_io_cq *cic = cfqd->active_cic;
 
 	/* If the queue already has requests, don't wait */
 	if (!RB_EMPTY_ROOT(&cfqq->sort_list))
@@ -3548,7 +3567,7 @@ static int cfq_may_queue(struct request_queue *q, int rw)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct task_struct *tsk = current;
-	struct cfq_io_context *cic;
+	struct cfq_io_cq *cic;
 	struct cfq_queue *cfqq;
 
 	/*
@@ -3563,7 +3582,7 @@ static int cfq_may_queue(struct request_queue *q, int rw)
 
 	cfqq = cic_to_cfqq(cic, rw_is_sync(rw));
 	if (cfqq) {
-		cfq_init_prio_data(cfqq, cic->ioc);
+		cfq_init_prio_data(cfqq, cic->icq.ioc);
 
 		return __cfq_may_queue(cfqq);
 	}
@@ -3584,7 +3603,7 @@ static void cfq_put_request(struct request *rq)
 		BUG_ON(!cfqq->allocated[rw]);
 		cfqq->allocated[rw]--;
 
-		put_io_context(RQ_CIC(rq)->ioc, cfqq->cfqd->queue);
+		put_io_context(RQ_CIC(rq)->icq.ioc, cfqq->cfqd->queue);
 
 		rq->elevator_private[0] = NULL;
 		rq->elevator_private[1] = NULL;
@@ -3598,7 +3617,7 @@ static void cfq_put_request(struct request *rq)
 }
 
 static struct cfq_queue *
-cfq_merge_cfqqs(struct cfq_data *cfqd, struct cfq_io_context *cic,
+cfq_merge_cfqqs(struct cfq_data *cfqd, struct cfq_io_cq *cic,
 		struct cfq_queue *cfqq)
 {
 	cfq_log_cfqq(cfqd, cfqq, "merging with queue %p", cfqq->new_cfqq);
@@ -3613,7 +3632,7 @@ cfq_merge_cfqqs(struct cfq_data *cfqd, struct cfq_io_context *cic,
  * was the last process referring to said cfqq.
  */
 static struct cfq_queue *
-split_cfqq(struct cfq_io_context *cic, struct cfq_queue *cfqq)
+split_cfqq(struct cfq_io_cq *cic, struct cfq_queue *cfqq)
 {
 	if (cfqq_process_refs(cfqq) == 1) {
 		cfqq->pid = current->pid;
@@ -3636,7 +3655,7 @@ static int
 cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
-	struct cfq_io_context *cic;
+	struct cfq_io_cq *cic;
 	const int rw = rq_data_dir(rq);
 	const bool is_sync = rq_is_sync(rq);
 	struct cfq_queue *cfqq;
@@ -3644,14 +3663,14 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
 	spin_lock_irq(q->queue_lock);
-	cic = cfq_get_io_context(cfqd, gfp_mask);
+	cic = cfq_get_cic(cfqd, gfp_mask);
 	if (!cic)
 		goto queue_fail;
 
 new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
-		cfqq = cfq_get_queue(cfqd, is_sync, cic->ioc, gfp_mask);
+		cfqq = cfq_get_queue(cfqd, is_sync, cic->icq.ioc, gfp_mask);
 		cic_set_cfqq(cic, cfqq, is_sync);
 	} else {
 		/*
@@ -3677,7 +3696,7 @@ new_queue:
 	cfqq->allocated[rw]++;
 
 	cfqq->ref++;
-	rq->elevator_private[0] = cic;
+	rq->elevator_private[0] = &cic->icq;
 	rq->elevator_private[1] = cfqq;
 	rq->elevator_private[2] = cfq_ref_get_cfqg(cfqq->cfqg);
 	spin_unlock_irq(q->queue_lock);
@@ -3791,15 +3810,14 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	if (cfqd->active_queue)
 		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
 
-	while (!list_empty(&cfqd->cic_list)) {
-		struct cfq_io_context *cic = list_entry(cfqd->cic_list.next,
-							struct cfq_io_context,
-							queue_list);
-		struct io_context *ioc = cic->ioc;
+	while (!list_empty(&cfqd->icq_list)) {
+		struct io_cq *icq = list_entry(cfqd->icq_list.next,
+					       struct io_cq, q_node);
+		struct io_context *ioc = icq->ioc;
 
 		spin_lock(&ioc->lock);
-		cfq_exit_cic(cic);
-		cfq_release_cic(cic);
+		cfq_exit_icq(icq);
+		cfq_release_icq(icq);
 		spin_unlock(&ioc->lock);
 	}
 
@@ -3904,7 +3922,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->oom_cfqq.ref++;
 	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, &cfqd->root_group);
 
-	INIT_LIST_HEAD(&cfqd->cic_list);
+	INIT_LIST_HEAD(&cfqd->icq_list);
 
 	cfqd->queue = q;
 
@@ -3942,8 +3960,8 @@ static void cfq_slab_kill(void)
 	 */
 	if (cfq_pool)
 		kmem_cache_destroy(cfq_pool);
-	if (cfq_ioc_pool)
-		kmem_cache_destroy(cfq_ioc_pool);
+	if (cfq_icq_pool)
+		kmem_cache_destroy(cfq_icq_pool);
 }
 
 static int __init cfq_slab_setup(void)
@@ -3952,8 +3970,8 @@ static int __init cfq_slab_setup(void)
 	if (!cfq_pool)
 		goto fail;
 
-	cfq_ioc_pool = KMEM_CACHE(cfq_io_context, 0);
-	if (!cfq_ioc_pool)
+	cfq_icq_pool = KMEM_CACHE(cfq_io_cq, 0);
+	if (!cfq_icq_pool)
 		goto fail;
 
 	return 0;
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index b2b75a5..d15ca65 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -5,38 +5,23 @@
 #include <linux/rcupdate.h>
 #include <linux/workqueue.h>
 
-struct cfq_queue;
-struct cfq_ttime {
-	unsigned long last_end_request;
-
-	unsigned long ttime_total;
-	unsigned long ttime_samples;
-	unsigned long ttime_mean;
-};
-
 enum {
-	CIC_IOPRIO_CHANGED,
-	CIC_CGROUP_CHANGED,
+	ICQ_IOPRIO_CHANGED,
+	ICQ_CGROUP_CHANGED,
 };
 
-struct cfq_io_context {
-	struct request_queue *q;
-
-	struct cfq_queue *cfqq[2];
-
-	struct io_context *ioc;
-
-	struct cfq_ttime ttime;
-
-	struct list_head queue_list;
-	struct hlist_node cic_list;
+struct io_cq {
+	struct request_queue	*q;
+	struct io_context	*ioc;
 
-	unsigned long changed;
+	struct list_head	q_node;
+	struct hlist_node	ioc_node;
 
-	void (*exit)(struct cfq_io_context *);
-	void (*release)(struct cfq_io_context *);
+	unsigned long		changed;
+	struct rcu_head		rcu_head;
 
-	struct rcu_head rcu_head;
+	void (*exit)(struct io_cq *);
+	void (*release)(struct io_cq *);
 };
 
 /*
@@ -58,9 +43,9 @@ struct io_context {
 	int nr_batch_requests;     /* Number of requests left in the batch */
 	unsigned long last_waited; /* Time last woken after wait for request */
 
-	struct radix_tree_root radix_root;
-	struct hlist_head cic_list;
-	void __rcu *ioc_data;
+	struct radix_tree_root	icq_tree;
+	struct io_cq __rcu	*icq_hint;
+	struct hlist_head	icq_list;
 
 	struct work_struct release_work;
 };
-- 
1.7.3.1

