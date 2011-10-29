Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931Ab1J2XuG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:50:06 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45166 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933885Ab1J2XuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:50:04 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/10] block, cfq: move io_cq exit/release to blk-ioc.c
Date: Sat, 29 Oct 2011 16:49:45 -0700
Message-Id: <1319932187-7631-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319932187-7631-1-git-send-email-tj@kernel.org>
References: <1319932187-7631-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With kmem_cache managed by blk-ioc, io_cq exit/release can be moved to
blk-ioc too.  The odd ->io_cq->exit/release() callbacks are replaced
with elevator_ops->elevator_exit_icq_fn() with unlinking from both ioc
and q, and freeing automatically handled by blk-ioc.  The elevator
operation only need to perform exit operation specific to the elevator
- in cfq's case, exiting the cfqq's.

Also, clearing of io_cq's on q detach is moved to block core and
automatically performed on elevator switch and q release.

Because the q io_cq points to might be freed before RCU callback for
the io_cq runs, blk-ioc code should remember to which cache the io_cq
needs to be freed when the io_cq is released.  New field
io_cq->__rcu_icq_cache is added for this purpose.  As both the new
field and rcu_head are used only after io_cq is released and the
q/ioc_node fields aren't, they are put into unions.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-ioc.c           |   76 ++++++++++++++++++++++++++++++++++++++++-----
 block/blk-sysfs.c         |    6 +++-
 block/blk.h               |    1 +
 block/cfq-iosched.c       |   47 +--------------------------
 block/elevator.c          |    3 +-
 include/linux/elevator.h  |    5 +++
 include/linux/iocontext.h |   20 ++++++++---
 7 files changed, 97 insertions(+), 61 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 87ecc98..0910a55 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -44,6 +44,51 @@ EXPORT_SYMBOL(get_io_context);
 #define ioc_release_depth_dec(q)	do { } while (0)
 #endif
 
+static void icq_free_icq_rcu(struct rcu_head *head)
+{
+	struct io_cq *icq = container_of(head, struct io_cq, __rcu_head);
+
+	kmem_cache_free(icq->__rcu_icq_cache, icq);
+}
+
+/*
+ * Exit and free an icq.  Called with both ioc and q locked.
+ */
+static void ioc_exit_icq(struct io_cq *icq)
+{
+	struct io_context *ioc = icq->ioc;
+	struct request_queue *q = icq->q;
+	struct elevator_type *et = q->elevator->type;
+
+	lockdep_assert_held(&ioc->lock);
+	lockdep_assert_held(q->queue_lock);
+
+	radix_tree_delete(&ioc->icq_tree, icq->q->id);
+	hlist_del_init(&icq->ioc_node);
+	list_del_init(&icq->q_node);
+
+	/*
+	 * Both setting lookup hint to and clearing it from @icq are done
+	 * under queue_lock.  If it's not pointing to @icq now, it never
+	 * will.  Hint assignment itself can race safely.
+	 */
+	if (rcu_dereference_raw(ioc->icq_hint) == icq)
+		rcu_assign_pointer(ioc->icq_hint, NULL);
+
+	if (et->ops.elevator_exit_icq_fn) {
+		ioc_release_depth_inc(q);
+		et->ops.elevator_exit_icq_fn(icq);
+		ioc_release_depth_dec(q);
+	}
+
+	/*
+	 * @icq->q might have gone away by the time RCU callback runs
+	 * making it impossible to determine icq_cache.  Record it in @icq.
+	 */
+	icq->__rcu_icq_cache = et->icq_cache;
+	call_rcu(&icq->__rcu_head, icq_free_icq_rcu);
+}
+
 /*
  * Slow path for ioc release in put_io_context().  Performs double-lock
  * dancing to unlink all icq's and then frees ioc.
@@ -87,10 +132,7 @@ static void ioc_release_fn(struct work_struct *work)
 			spin_lock(&ioc->lock);
 			continue;
 		}
-		ioc_release_depth_inc(this_q);
-		icq->exit(icq);
-		icq->release(icq);
-		ioc_release_depth_dec(this_q);
+		ioc_exit_icq(icq);
 	}
 
 	if (last_q) {
@@ -167,10 +209,7 @@ void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
 			last_q = this_q;
 			continue;
 		}
-		ioc_release_depth_inc(this_q);
-		icq->exit(icq);
-		icq->release(icq);
-		ioc_release_depth_dec(this_q);
+		ioc_exit_icq(icq);
 	}
 
 	if (last_q && last_q != locked_q)
@@ -203,6 +242,27 @@ void exit_io_context(struct task_struct *task)
 	put_io_context(ioc, NULL);
 }
 
+/**
+ * ioc_clear_queue - break any ioc association with the specified queue
+ * @q: request_queue being cleared
+ *
+ * Walk @q->icq_list and exit all io_cq's.  Must be called with @q locked.
+ */
+void ioc_clear_queue(struct request_queue *q)
+{
+	lockdep_assert_held(q->queue_lock);
+
+	while (!list_empty(&q->icq_list)) {
+		struct io_cq *icq = list_entry(q->icq_list.next,
+					       struct io_cq, q_node);
+		struct io_context *ioc = icq->ioc;
+
+		spin_lock(&ioc->lock);
+		ioc_exit_icq(icq);
+		spin_unlock(&ioc->lock);
+	}
+}
+
 void create_io_context_slowpath(struct task_struct *task, gfp_t gfp_flags,
 				int node)
 {
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 5b4b4ab..cf15001 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -479,8 +479,12 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blk_sync_queue(q);
 
-	if (q->elevator)
+	if (q->elevator) {
+		spin_lock_irq(q->queue_lock);
+		ioc_clear_queue(q);
+		spin_unlock_irq(q->queue_lock);
 		elevator_exit(q->elevator);
+	}
 
 	blk_throtl_exit(q);
 
diff --git a/block/blk.h b/block/blk.h
index 3c510a4..ed4d9bf 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -200,6 +200,7 @@ static inline int blk_do_io_stat(struct request *rq)
  */
 void get_io_context(struct io_context *ioc);
 struct io_cq *ioc_lookup_icq(struct io_context *ioc, struct request_queue *q);
+void ioc_clear_queue(struct request_queue *q);
 
 void create_io_context_slowpath(struct task_struct *task, gfp_t gfp_mask,
 				int node);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 06e59ab..f6d3155 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2674,26 +2674,6 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	cfq_put_cfqg(cfqg);
 }
 
-static void cfq_icq_free_rcu(struct rcu_head *head)
-{
-	kmem_cache_free(cfq_icq_pool,
-			icq_to_cic(container_of(head, struct io_cq, rcu_head)));
-}
-
-static void cfq_icq_free(struct io_cq *icq)
-{
-	call_rcu(&icq->rcu_head, cfq_icq_free_rcu);
-}
-
-static void cfq_release_icq(struct io_cq *icq)
-{
-	struct io_context *ioc = icq->ioc;
-
-	radix_tree_delete(&ioc->icq_tree, icq->q->id);
-	hlist_del(&icq->ioc_node);
-	cfq_icq_free(icq);
-}
-
 static void cfq_put_cooperator(struct cfq_queue *cfqq)
 {
 	struct cfq_queue *__cfqq, *next;
@@ -2731,17 +2711,6 @@ static void cfq_exit_icq(struct io_cq *icq)
 {
 	struct cfq_io_cq *cic = icq_to_cic(icq);
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
-	struct io_context *ioc = icq->ioc;
-
-	list_del_init(&icq->q_node);
-
-	/*
-	 * Both setting lookup hint to and clearing it from @icq are done
-	 * under queue_lock.  If it's not pointing to @icq now, it never
-	 * will.  Hint assignment itself can race safely.
-	 */
-	if (rcu_dereference_raw(ioc->icq_hint) == icq)
-		rcu_assign_pointer(ioc->icq_hint, NULL);
 
 	if (cic->cfqq[BLK_RW_ASYNC]) {
 		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);
@@ -2764,8 +2733,6 @@ static struct cfq_io_cq *cfq_alloc_cic(struct cfq_data *cfqd, gfp_t gfp_mask)
 		cic->ttime.last_end_request = jiffies;
 		INIT_LIST_HEAD(&cic->icq.q_node);
 		INIT_HLIST_NODE(&cic->icq.ioc_node);
-		cic->icq.exit = cfq_exit_icq;
-		cic->icq.release = cfq_release_icq;
 	}
 
 	return cic;
@@ -3034,7 +3001,7 @@ out:
 	if (ret)
 		printk(KERN_ERR "cfq: icq link failed!\n");
 	if (icq)
-		cfq_icq_free(icq);
+		kmem_cache_free(cfq_icq_pool, icq);
 	return ret;
 }
 
@@ -3774,17 +3741,6 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	if (cfqd->active_queue)
 		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
 
-	while (!list_empty(&q->icq_list)) {
-		struct io_cq *icq = list_entry(q->icq_list.next,
-					       struct io_cq, q_node);
-		struct io_context *ioc = icq->ioc;
-
-		spin_lock(&ioc->lock);
-		cfq_exit_icq(icq);
-		cfq_release_icq(icq);
-		spin_unlock(&ioc->lock);
-	}
-
 	cfq_put_async_queues(cfqd);
 	cfq_release_cfq_groups(cfqd);
 
@@ -4019,6 +3975,7 @@ static struct elevator_type iosched_cfq = {
 		.elevator_completed_req_fn =	cfq_completed_request,
 		.elevator_former_req_fn =	elv_rb_former_request,
 		.elevator_latter_req_fn =	elv_rb_latter_request,
+		.elevator_exit_icq_fn =		cfq_exit_icq,
 		.elevator_set_req_fn =		cfq_set_request,
 		.elevator_put_req_fn =		cfq_put_request,
 		.elevator_may_queue_fn =	cfq_may_queue,
diff --git a/block/elevator.c b/block/elevator.c
index cca049f..91e18f8 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -979,8 +979,9 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 			goto fail_register;
 	}
 
-	/* done, replace the old one with new one and turn off BYPASS */
+	/* done, clear io_cq's, switch elevators and turn off BYPASS */
 	spin_lock_irq(q->queue_lock);
+	ioc_clear_queue(q);
 	old_elevator = q->elevator;
 	q->elevator = e;
 	spin_unlock_irq(q->queue_lock);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index d3d3e28..06e4dd56 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -5,6 +5,8 @@
 
 #ifdef CONFIG_BLOCK
 
+struct io_cq;
+
 typedef int (elevator_merge_fn) (struct request_queue *, struct request **,
 				 struct bio *);
 
@@ -24,6 +26,7 @@ typedef struct request *(elevator_request_list_fn) (struct request_queue *, stru
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
 
+typedef void (elevator_exit_icq_fn) (struct io_cq *);
 typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
 typedef void (elevator_put_req_fn) (struct request *);
 typedef void (elevator_activate_req_fn) (struct request_queue *, struct request *);
@@ -56,6 +59,8 @@ struct elevator_ops
 	elevator_request_list_fn *elevator_former_req_fn;
 	elevator_request_list_fn *elevator_latter_req_fn;
 
+	elevator_exit_icq_fn *elevator_exit_icq_fn;
+
 	elevator_set_req_fn *elevator_set_req_fn;
 	elevator_put_req_fn *elevator_put_req_fn;
 
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index d15ca65..ac390a3 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -14,14 +14,22 @@ struct io_cq {
 	struct request_queue	*q;
 	struct io_context	*ioc;
 
-	struct list_head	q_node;
-	struct hlist_node	ioc_node;
+	/*
+	 * q_node and ioc_node link io_cq through icq_list of q and ioc
+	 * respectively.  Both fields are unused once ioc_exit_icq() is
+	 * called and shared with __rcu_icq_cache and __rcu_head which are
+	 * used for RCU free of io_cq.
+	 */
+	union {
+		struct list_head	q_node;
+		struct kmem_cache	*__rcu_icq_cache;
+	};
+	union {
+		struct hlist_node	ioc_node;
+		struct rcu_head		__rcu_head;
+	};
 
 	unsigned long		changed;
-	struct rcu_head		rcu_head;
-
-	void (*exit)(struct io_cq *);
-	void (*release)(struct io_cq *);
 };
 
 /*
-- 
1.7.3.1

