Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933943Ab1J2XuK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:50:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51657 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933929Ab1J2XuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:50:06 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/10] block, cfq: move icq creation and rq->elv.icq association to block core
Date: Sat, 29 Oct 2011 16:49:47 -0700
Message-Id: <1319932187-7631-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319932187-7631-1-git-send-email-tj@kernel.org>
References: <1319932187-7631-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now block layer knows everything necessary to create and associate
icq's with requests.  Move ioc_create_icq() to blk-ioc.c and update
get_request() such that, if elevator_type->icq_size is set, requests
are automatically associated with their matching icq's before
elv_set_request().  io_context reference is also managed by block core
on request alloc/free.

* Only ioprio/cgroup changed handling remains from cfq_get_cic().
  Collapsed into cfq_set_request().

* This removes queue kicking on icq allocation failure (for now).  As
  icq allocation failure is rare and the only effect of queue kicking
  achieved was possibily accelerating queue processing, this change
  shouldn't be noticeable.

  There is a larger underlying problem.  Unlike request allocation,
  icq allocation is not guaranteed to succeed eventually after
  retries.  The number of icq is unbound and thus mempool can't be the
  solution either.  This effectively adds allocation dependency on
  memory free path and thus possibility of deadlock.

  This usually wouldn't happen because icq allocation is not a hot
  path and, even when the condition triggers, it's highly unlikely
  that none of the writeback workers already has icq.

  However, this is still possible especially if elevator is being
  switched under high memory pressure, so we better get it fixed.
  Probably the only solution is just bypassing elevator and appending
  to dispatch queue on any elevator allocation failure.

* Comment added to explain how icq's are managed and synchronized.

This completes cleanup of io_context interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c          |   46 +++++++++++++--
 block/blk-ioc.c           |   60 ++++++++++++++++++++-
 block/blk.h               |    1 +
 block/cfq-iosched.c       |  135 ++++-----------------------------------------
 include/linux/elevator.h  |    8 +-
 include/linux/iocontext.h |   59 ++++++++++++++++++++
 6 files changed, 173 insertions(+), 136 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5315f09..2da3cd6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -635,13 +635,18 @@ EXPORT_SYMBOL(blk_get_queue);
 
 static inline void blk_free_request(struct request_queue *q, struct request *rq)
 {
-	if (rq->cmd_flags & REQ_ELVPRIV)
+	if (rq->cmd_flags & REQ_ELVPRIV) {
 		elv_put_request(q, rq);
+		if (rq->elv.icq)
+			put_io_context(rq->elv.icq->ioc, q);
+	}
+
 	mempool_free(rq, q->rq.rq_pool);
 }
 
 static struct request *
-blk_alloc_request(struct request_queue *q, unsigned int flags, gfp_t gfp_mask)
+blk_alloc_request(struct request_queue *q, struct io_cq *icq,
+		  unsigned int flags, gfp_t gfp_mask)
 {
 	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
 
@@ -652,10 +657,15 @@ blk_alloc_request(struct request_queue *q, unsigned int flags, gfp_t gfp_mask)
 
 	rq->cmd_flags = flags | REQ_ALLOCED;
 
-	if ((flags & REQ_ELVPRIV) &&
-	    unlikely(elv_set_request(q, rq, gfp_mask))) {
-		mempool_free(rq, q->rq.rq_pool);
-		return NULL;
+	if (flags & REQ_ELVPRIV) {
+		rq->elv.icq = icq;
+		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
+			mempool_free(rq, q->rq.rq_pool);
+			return NULL;
+		}
+		/* @rq->elv.icq holds on to io_context until @rq is freed */
+		if (icq)
+			get_io_context(icq->ioc);
 	}
 
 	return rq;
@@ -767,11 +777,14 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 {
 	struct request *rq = NULL;
 	struct request_list *rl = &q->rq;
+	struct elevator_type *et;
 	struct io_context *ioc;
+	struct io_cq *icq = NULL;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
 	bool retried = false;
 	int may_queue;
 retry:
+	et = q->elevator->type;
 	ioc = current->io_context;
 
 	if (unlikely(blk_queue_dead(q)))
@@ -832,17 +845,36 @@ retry:
 	rl->count[is_sync]++;
 	rl->starved[is_sync] = 0;
 
+	/*
+	 * Decide whether the new request will be managed by elevator.  If
+	 * so, mark @rw_flags and increment elvpriv.  Non-zero elvpriv will
+	 * prevent the current elevator from being destroyed until the new
+	 * request is freed.  This guarantees icq's won't be destroyed and
+	 * makes creating new ones safe.
+	 *
+	 * Also, lookup icq while holding queue_lock.  If it doesn't exist,
+	 * it will be created after releasing queue_lock.
+	 */
 	if (blk_rq_should_init_elevator(bio) &&
 	    !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags)) {
 		rw_flags |= REQ_ELVPRIV;
 		rl->elvpriv++;
+		if (et->icq_cache && ioc)
+			icq = ioc_lookup_icq(ioc, q);
 	}
 
 	if (blk_queue_io_stat(q))
 		rw_flags |= REQ_IO_STAT;
 	spin_unlock_irq(q->queue_lock);
 
-	rq = blk_alloc_request(q, rw_flags, gfp_mask);
+	/* create icq if missing */
+	if (unlikely(et->icq_cache && !icq))
+		icq = ioc_create_icq(q, gfp_mask);
+
+	/* rqs are guaranteed to have icq on elv_set_request() if requested */
+	if (likely(!et->icq_cache || icq))
+		rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);
+
 	if (unlikely(!rq)) {
 		/*
 		 * Allocation failed presumably due to memory. Undo anything
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 0910a55..c04d16b 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -289,7 +289,6 @@ void create_io_context_slowpath(struct task_struct *task, gfp_t gfp_flags,
 		kmem_cache_free(iocontext_cachep, ioc);
 	task_unlock(task);
 }
-EXPORT_SYMBOL(create_io_context_slowpath);
 
 /**
  * get_task_io_context - get io_context of a task
@@ -362,6 +361,65 @@ out:
 }
 EXPORT_SYMBOL(ioc_lookup_icq);
 
+/**
+ * ioc_create_icq - create and link io_cq
+ * @q: request_queue of interest
+ * @gfp_mask: allocation mask
+ *
+ * Make sure io_cq linking %current->io_context and @q exists.  If either
+ * io_context and/or icq don't exist, they will be created using @gfp_mask.
+ *
+ * The caller is responsible for ensuring @ioc won't go away and @q is
+ * alive and will stay alive until this function returns.
+ */
+struct io_cq *ioc_create_icq(struct request_queue *q, gfp_t gfp_mask)
+{
+	struct elevator_type *et = q->elevator->type;
+	struct io_context *ioc;
+	struct io_cq *icq;
+
+	/* allocate stuff */
+	ioc = create_io_context(current, gfp_mask, q->node);
+	if (!ioc)
+		return NULL;
+
+	icq = kmem_cache_alloc_node(et->icq_cache, gfp_mask | __GFP_ZERO,
+				    q->node);
+	if (!icq)
+		return NULL;
+
+	if (radix_tree_preload(gfp_mask) < 0) {
+		kmem_cache_free(et->icq_cache, icq);
+		return NULL;
+	}
+
+	icq->ioc = ioc;
+	icq->q = q;
+	INIT_LIST_HEAD(&icq->q_node);
+	INIT_HLIST_NODE(&icq->ioc_node);
+
+	/* lock both q and ioc and try to link @icq */
+	spin_lock_irq(q->queue_lock);
+	spin_lock(&ioc->lock);
+
+	if (likely(!radix_tree_insert(&ioc->icq_tree, q->id, icq))) {
+		hlist_add_head(&icq->ioc_node, &ioc->icq_list);
+		list_add(&icq->q_node, &q->icq_list);
+		if (et->ops.elevator_init_icq_fn)
+			et->ops.elevator_init_icq_fn(icq);
+	} else {
+		kmem_cache_free(et->icq_cache, icq);
+		icq = ioc_lookup_icq(ioc, q);
+		if (!icq)
+			printk(KERN_ERR "cfq: icq link failed!\n");
+	}
+
+	spin_unlock(&ioc->lock);
+	spin_unlock_irq(q->queue_lock);
+	radix_tree_preload_end();
+	return icq;
+}
+
 void ioc_set_changed(struct io_context *ioc, int which)
 {
 	struct io_cq *icq;
diff --git a/block/blk.h b/block/blk.h
index ed4d9bf..7efd772 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -200,6 +200,7 @@ static inline int blk_do_io_stat(struct request *rq)
  */
 void get_io_context(struct io_context *ioc);
 struct io_cq *ioc_lookup_icq(struct io_context *ioc, struct request_queue *q);
+struct io_cq *ioc_create_icq(struct request_queue *q, gfp_t gfp_mask);
 void ioc_clear_queue(struct request_queue *q);
 
 void create_io_context_slowpath(struct task_struct *task, gfp_t gfp_mask,
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 11f49d0..f3b44c3 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2935,117 +2935,6 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
 	return cfqq;
 }
 
-/**
- * ioc_create_icq - create and link io_cq
- * @q: request_queue of interest
- * @gfp_mask: allocation mask
- *
- * Make sure io_cq linking %current->io_context and @q exists.  If either
- * io_context and/or icq don't exist, they will be created using @gfp_mask.
- *
- * The caller is responsible for ensuring @ioc won't go away and @q is
- * alive and will stay alive until this function returns.
- */
-static struct io_cq *ioc_create_icq(struct request_queue *q, gfp_t gfp_mask)
-{
-	struct elevator_type *et = q->elevator->type;
-	struct io_context *ioc;
-	struct io_cq *icq;
-
-	/* allocate stuff */
-	ioc = create_io_context(current, gfp_mask, q->node);
-	if (!ioc)
-		return NULL;
-
-	icq = kmem_cache_alloc_node(et->icq_cache, gfp_mask | __GFP_ZERO,
-				    q->node);
-	if (!icq)
-		return NULL;
-
-	if (radix_tree_preload(gfp_mask) < 0) {
-		kmem_cache_free(et->icq_cache, icq);
-		return NULL;
-	}
-
-	icq->ioc = ioc;
-	icq->q = q;
-	INIT_LIST_HEAD(&icq->q_node);
-	INIT_HLIST_NODE(&icq->ioc_node);
-
-	/* lock both q and ioc and try to link @icq */
-	spin_lock_irq(q->queue_lock);
-	spin_lock(&ioc->lock);
-
-	if (likely(!radix_tree_insert(&ioc->icq_tree, q->id, icq))) {
-		hlist_add_head(&icq->ioc_node, &ioc->icq_list);
-		list_add(&icq->q_node, &q->icq_list);
-		if (et->ops.elevator_init_icq_fn)
-			et->ops.elevator_init_icq_fn(icq);
-	} else {
-		kmem_cache_free(et->icq_cache, icq);
-		icq = ioc_lookup_icq(ioc, q);
-		if (!icq)
-			printk(KERN_ERR "cfq: icq link failed!\n");
-	}
-
-	spin_unlock(&ioc->lock);
-	spin_unlock_irq(q->queue_lock);
-	radix_tree_preload_end();
-	return icq;
-}
-
-/**
- * cfq_get_cic - acquire cfq_io_cq and bump refcnt on io_context
- * @cfqd: cfqd to setup cic for
- * @gfp_mask: allocation mask
- *
- * Return cfq_io_cq associating @cfqd and %current->io_context and
- * bump refcnt on io_context.  If ioc or cic doesn't exist, they're created
- * using @gfp_mask.
- *
- * Must be called under queue_lock which may be released and re-acquired.
- * This function also may sleep depending on @gfp_mask.
- */
-static struct cfq_io_cq *cfq_get_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
-{
-	struct request_queue *q = cfqd->queue;
-	struct cfq_io_cq *cic = NULL;
-	struct io_context *ioc;
-
-	lockdep_assert_held(q->queue_lock);
-
-	while (true) {
-		/* fast path */
-		ioc = current->io_context;
-		if (likely(ioc)) {
-			cic = cfq_cic_lookup(cfqd, ioc);
-			if (likely(cic))
-				break;
-		}
-
-		/* slow path - unlock, create missing ones and retry */
-		spin_unlock_irq(q->queue_lock);
-		cic = icq_to_cic(ioc_create_icq(q, gfp_mask));
-		spin_lock_irq(q->queue_lock);
-		if (!cic)
-			return NULL;
-	}
-
-	/* bump @ioc's refcnt and handle changed notifications */
-	get_io_context(ioc);
-
-	if (unlikely(cic->icq.changed)) {
-		if (test_and_clear_bit(ICQ_IOPRIO_CHANGED, &cic->icq.changed))
-			changed_ioprio(cic);
-#ifdef CONFIG_CFQ_GROUP_IOSCHED
-		if (test_and_clear_bit(ICQ_CGROUP_CHANGED, &cic->icq.changed))
-			changed_cgroup(cic);
-#endif
-	}
-
-	return cic;
-}
-
 static void
 __cfq_update_io_thinktime(struct cfq_ttime *ttime, unsigned long slice_idle)
 {
@@ -3524,8 +3413,6 @@ static void cfq_put_request(struct request *rq)
 		BUG_ON(!cfqq->allocated[rw]);
 		cfqq->allocated[rw]--;
 
-		put_io_context(RQ_CIC(rq)->icq.ioc, cfqq->cfqd->queue);
-
 		/* Put down rq reference on cfqg */
 		cfq_put_cfqg(RQ_CFQG(rq));
 		rq->elv.priv[0] = NULL;
@@ -3574,7 +3461,7 @@ static int
 cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
-	struct cfq_io_cq *cic;
+	struct cfq_io_cq *cic = icq_to_cic(rq->elv.icq);
 	const int rw = rq_data_dir(rq);
 	const bool is_sync = rq_is_sync(rq);
 	struct cfq_queue *cfqq;
@@ -3582,9 +3469,16 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
 	spin_lock_irq(q->queue_lock);
-	cic = cfq_get_cic(cfqd, gfp_mask);
-	if (!cic)
-		goto queue_fail;
+
+	/* handle changed notifications */
+	if (unlikely(cic->icq.changed)) {
+		if (test_and_clear_bit(ICQ_IOPRIO_CHANGED, &cic->icq.changed))
+			changed_ioprio(cic);
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+		if (test_and_clear_bit(ICQ_CGROUP_CHANGED, &cic->icq.changed))
+			changed_cgroup(cic);
+#endif
+	}
 
 new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
@@ -3615,17 +3509,10 @@ new_queue:
 	cfqq->allocated[rw]++;
 
 	cfqq->ref++;
-	rq->elv.icq = &cic->icq;
 	rq->elv.priv[0] = cfqq;
 	rq->elv.priv[1] = cfq_ref_get_cfqg(cfqq->cfqg);
 	spin_unlock_irq(q->queue_lock);
 	return 0;
-
-queue_fail:
-	cfq_schedule_dispatch(cfqd);
-	spin_unlock_irq(q->queue_lock);
-	cfq_log(cfqd, "set_request fail");
-	return 1;
 }
 
 static void cfq_kick_queue(struct work_struct *work)
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index c8f1e67..c24f3d7 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -60,8 +60,8 @@ struct elevator_ops
 	elevator_request_list_fn *elevator_former_req_fn;
 	elevator_request_list_fn *elevator_latter_req_fn;
 
-	elevator_init_icq_fn *elevator_init_icq_fn;
-	elevator_exit_icq_fn *elevator_exit_icq_fn;
+	elevator_init_icq_fn *elevator_init_icq_fn;	/* see iocontext.h */
+	elevator_exit_icq_fn *elevator_exit_icq_fn;	/* ditto */
 
 	elevator_set_req_fn *elevator_set_req_fn;
 	elevator_put_req_fn *elevator_put_req_fn;
@@ -90,8 +90,8 @@ struct elevator_type
 
 	/* fields provided by elevator implementation */
 	struct elevator_ops ops;
-	size_t icq_size;
-	size_t icq_align;
+	size_t icq_size;	/* see iocontext.h */
+	size_t icq_align;	/* ditto */
 	struct elv_fs_entry *elevator_attrs;
 	char elevator_name[ELV_NAME_MAX];
 	struct module *elevator_owner;
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index ac390a3..7e1371c 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -10,6 +10,65 @@ enum {
 	ICQ_CGROUP_CHANGED,
 };
 
+/*
+ * An io_cq (icq) is association between an io_context (ioc) and a
+ * request_queue (q).  This is used by elevators which need to track
+ * information per ioc - q pair.
+ *
+ * Elevator can request use of icq by setting elevator_type->icq_size and
+ * ->icq_align.  Both size and align must be larger than that of struct
+ * io_cq and elevator can use the tail area for private information.  The
+ * recommended way to do this is defining a struct which contains io_cq as
+ * the first member followed by private members and using its size and
+ * align.  For example,
+ *
+ *	struct snail_io_cq {
+ *		struct io_cq	icq;
+ *		int		poke_snail;
+ *		int		feed_snail;
+ *	};
+ *
+ *	struct elevator_type snail_elv_type {
+ *		.ops =		{ ... },
+ *		.icq_size =	sizeof(struct snail_io_cq),
+ *		.icq_align =	__alignof__(struct snail_io_cq),
+ *		...
+ *	};
+ *
+ * If icq_size is set, block core will manage icq's.  All requests will
+ * have its ->elv.icq field set before elevator_ops->elevator_set_req_fn()
+ * is called and be holding a reference to the associated io_context.
+ *
+ * Whenever a new icq is created, elevator_ops->elevator_init_icq_fn() is
+ * called and, on destruction, ->elevator_exit_icq_fn().  Both functions
+ * are called with both the associated io_context and queue locks held.
+ *
+ * Elevator is allowed to lookup icq using ioc_lookup_icq() while holding
+ * queue lock but the returned icq is valid only until the queue lock is
+ * released.  Elevators can not and should not try to create or destroy
+ * icq's.
+ *
+ * As icq's are linked from both ioc and q, the locking rules are a bit
+ * complex.
+ *
+ * - ioc lock nests inside q lock.
+ *
+ * - ioc->icq_list and icq->ioc_node are protected by ioc lock.
+ *   q->icq_list and icq->q_node by q lock.
+ *
+ * - ioc->icq_tree and ioc->icq_hint are protected by ioc lock, while icq
+ *   itself is protected by q lock.  However, both the indexes and icq
+ *   itself are also RCU managed and lookup can be performed holding only
+ *   the q lock.
+ *
+ * - icq's are not reference counted.  They are destroyed when either the
+ *   ioc or q goes away.  Each request with icq set holds an extra
+ *   reference to ioc to ensure it stays until the request is completed.
+ *
+ * - Linking and unlinking icq's are performed while holding both ioc and q
+ *   locks.  Due to the lock ordering, q exit is simple but ioc exit
+ *   requires reverse-order double lock dance.
+ */
 struct io_cq {
 	struct request_queue	*q;
 	struct io_context	*ioc;
-- 
1.7.3.1

