Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1JZBt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:49:56 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42843 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab1JZBtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:49:09 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/13] block, cfq: unlink cfq_io_context's immediately
Date: Tue, 25 Oct 2011 18:48:36 -0700
Message-Id: <1319593719-19132-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319593719-19132-1-git-send-email-tj@kernel.org>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cic is association between io_context and request_queue.  A cic is
linked from both ioc and q and should be destroyed when either one
goes away.  As ioc and q both have their own locks, locking becomes a
bit complex - both orders work for removal from one but not from the
other.

Currently, cfq tries to circumvent this locking order issue with RCU.
ioc->lock nests inside queue_lock but the radix tree and cic's are
also protected by RCU allowing either side to walk their lists without
grabbing lock.

This rather unconventional use of RCU quickly devolves into extremely
fragile convolution.  e.g. The following is from cfqd going away too
soon after ioc and q exits raced.

 general protection fault: 0000 [#1] PREEMPT SMP
 CPU 2
 Modules linked in:
 [   88.503444]
 Pid: 599, comm: hexdump Not tainted 3.1.0-rc10-work+ #158 Bochs Bochs
 RIP: 0010:[<ffffffff81397628>]  [<ffffffff81397628>] cfq_exit_single_io_context+0x58/0xf0
 ...
 Call Trace:
  [<ffffffff81395a4a>] call_for_each_cic+0x5a/0x90
  [<ffffffff81395ab5>] cfq_exit_io_context+0x15/0x20
  [<ffffffff81389130>] exit_io_context+0x100/0x140
  [<ffffffff81098a29>] do_exit+0x579/0x850
  [<ffffffff81098d5b>] do_group_exit+0x5b/0xd0
  [<ffffffff81098de7>] sys_exit_group+0x17/0x20
  [<ffffffff81b02f2b>] system_call_fastpath+0x16/0x1b

The only real hot path here is cic lookup during request
initialization and avoiding extra locking requires very confined use
of RCU.  This patch makes cic removal from both ioc and request_queue
perform double-locking and unlink immediately.

* From q side, the change is almost trivial as ioc->lock nests inside
  queue_lock.  It just needs to grab each ioc->lock as it walks
  cic_list and unlink it.

* From ioc side, it's a bit more difficult because of inversed lock
  order.  ioc needs its lock to walk its cic_list but can't grab the
  matching queue_lock and needs to perform unlock-relock dancing.

  Unlinking is now wholly done from put_io_context() and fast path is
  optimized by using the queue_lock the caller already holds, which is
  by far the most common case.  If the ioc accessed multiple devices,
  it tries with trylock.  In unlikely cases of fast path failure, it
  falls back to full double-locking dance from workqueue.

Double-locking isn't the prettiest thing in the world but it's *far*
simpler and more understandable than RCU trick without adding any
meaningful overhead.

This still leaves a lot of now unnecessary RCU logics.  Future patches
will trim them.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-cgroup.c        |    2 +-
 block/blk-ioc.c           |  164 +++++++++++++++++++++++++++++++++++++--------
 block/cfq-iosched.c       |   44 ++----------
 fs/ioprio.c               |    2 +-
 include/linux/blkdev.h    |    3 +
 include/linux/iocontext.h |   12 ++-
 kernel/fork.c             |    2 +-
 7 files changed, 157 insertions(+), 72 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index dc00835..2788693 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1649,7 +1649,7 @@ static void blkiocg_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 	ioc = get_task_io_context(tsk, GFP_ATOMIC, NUMA_NO_NODE);
 	if (ioc) {
 		ioc_cgroup_changed(ioc);
-		put_io_context(ioc);
+		put_io_context(ioc, NULL);
 	}
 }
 
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 6f59fba..a5aeb39 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -29,55 +29,162 @@ void get_io_context(struct io_context *ioc)
 }
 EXPORT_SYMBOL(get_io_context);
 
-static void cfq_dtor(struct io_context *ioc)
+/*
+ * Releasing ioc may nest into another put_io_context() leading to nested
+ * fast path release.  As the ioc's can't be the same, this is okay but
+ * makes lockdep whine.  Keep track of nesting and use it as subclass.
+ */
+#ifdef CONFIG_LOCKDEP
+#define ioc_release_depth(q)		((q) ? (q)->ioc_release_depth : 0)
+#define ioc_release_depth_inc(q)	(q)->ioc_release_depth++
+#define ioc_release_depth_dec(q)	(q)->ioc_release_depth--
+#else
+#define ioc_release_depth(q)		0
+#define ioc_release_depth_inc(q)	do { } while (0)
+#define ioc_release_depth_dec(q)	do { } while (0)
+#endif
+
+/*
+ * Slow path for ioc release in put_io_context().  Performs double-lock
+ * dancing to unlink all cic's and then frees ioc.
+ */
+static void ioc_release_fn(struct work_struct *work)
 {
-	if (!hlist_empty(&ioc->cic_list)) {
-		struct cfq_io_context *cic;
+	struct io_context *ioc = container_of(work, struct io_context,
+					      release_work);
+	struct request_queue *last_q = NULL;
+
+	spin_lock_irq(&ioc->lock);
+
+	while (!hlist_empty(&ioc->cic_list)) {
+		struct cfq_io_context *cic = hlist_entry(ioc->cic_list.first,
+							 struct cfq_io_context,
+							 cic_list);
+		if (cic->q != last_q) {
+			struct request_queue *this_q = cic->q;
+
+			/*
+			 * Need to switch to @this_q.  Once we release
+			 * @ioc->lock, it can go away along with @cic.
+			 * Hold on to it.
+			 */
+			__blk_get_queue(this_q);
+
+			/*
+			 * blk_put_queue() might sleep thanks to kobject
+			 * idiocy.  Always release both locks, put and
+			 * restart.
+			 */
+			if (last_q) {
+				spin_unlock(last_q->queue_lock);
+				spin_unlock_irq(&ioc->lock);
+				blk_put_queue(last_q);
+			} else {
+				spin_unlock_irq(&ioc->lock);
+			}
+
+			last_q = this_q;
+			spin_lock_irq(this_q->queue_lock);
+			spin_lock(&ioc->lock);
+			continue;
+		}
+		ioc_release_depth_inc(cic->q);
+		cic->exit(cic);
+		cic->release(cic);
+		ioc_release_depth_dec(cic->q);
+	}
 
-		cic = hlist_entry(ioc->cic_list.first, struct cfq_io_context,
-								cic_list);
-		cic->dtor(ioc);
+	if (last_q) {
+		spin_unlock(last_q->queue_lock);
+		spin_unlock_irq(&ioc->lock);
+		blk_put_queue(last_q);
+	} else {
+		spin_unlock_irq(&ioc->lock);
 	}
+
+	kmem_cache_free(iocontext_cachep, ioc);
 }
 
 /**
  * put_io_context - put a reference of io_context
  * @ioc: io_context to put
+ * @locked_q: request_queue the caller is holding queue_lock of (hint)
  *
  * Decrement reference count of @ioc and release it if the count reaches
- * zero.
+ * zero.  If the caller is holding queue_lock of a queue, it can indicate
+ * that with @locked_q.  This is an optimization hint and the caller is
+ * allowed to pass in %NULL even when it's holding a queue_lock.
  */
-void put_io_context(struct io_context *ioc)
+void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
 {
+	struct request_queue *last_q = locked_q;
+	unsigned long flags;
+
 	if (ioc == NULL)
 		return;
 
 	BUG_ON(atomic_long_read(&ioc->refcount) <= 0);
+	if (locked_q)
+		lockdep_assert_held(locked_q->queue_lock);
 
 	if (!atomic_long_dec_and_test(&ioc->refcount))
 		return;
 
-	rcu_read_lock();
-	cfq_dtor(ioc);
-	rcu_read_unlock();
-
-	kmem_cache_free(iocontext_cachep, ioc);
-}
-EXPORT_SYMBOL(put_io_context);
+	/*
+	 * Destroy @ioc.  This is a bit messy because cic's are chained
+	 * from both ioc and queue, and ioc->lock nests inside queue_lock.
+	 * The inner ioc->lock should be held to walk our cic_list and then
+	 * for each cic the outer matching queue_lock should be grabbed.
+	 * ie. We need to do reverse-order double lock dancing.
+	 *
+	 * Another twist is that we are often called with one of the
+	 * matching queue_locks held as indicated by @locked_q, which
+	 * prevents performing double-lock dance for other queues.
+	 *
+	 * So, we do it in two stages.  The fast path uses the queue_lock
+	 * the caller is holding and, if other queues need to be accessed,
+	 * uses trylock to avoid introducing locking dependency.  This can
+	 * handle most cases, especially if @ioc was performing IO on only
+	 * single device.
+	 *
+	 * If trylock doesn't cut it, we defer to @ioc->release_work which
+	 * can do all the double-locking dancing.
+	 */
+	spin_lock_irqsave_nested(&ioc->lock, flags,
+				 ioc_release_depth(locked_q));
+
+	while (!hlist_empty(&ioc->cic_list)) {
+		struct cfq_io_context *cic = hlist_entry(ioc->cic_list.first,
+							 struct cfq_io_context,
+							 cic_list);
+		if (cic->q != last_q) {
+			if (last_q && last_q != locked_q)
+				spin_unlock(last_q->queue_lock);
+			last_q = NULL;
+
+			if (!spin_trylock(cic->q->queue_lock))
+				break;
+			last_q = cic->q;
+			continue;
+		}
+		ioc_release_depth_inc(cic->q);
+		cic->exit(cic);
+		cic->release(cic);
+		ioc_release_depth_dec(cic->q);
+	}
 
-static void cfq_exit(struct io_context *ioc)
-{
-	rcu_read_lock();
+	if (last_q && last_q != locked_q)
+		spin_unlock(last_q->queue_lock);
 
-	if (!hlist_empty(&ioc->cic_list)) {
-		struct cfq_io_context *cic;
+	spin_unlock_irqrestore(&ioc->lock, flags);
 
-		cic = hlist_entry(ioc->cic_list.first, struct cfq_io_context,
-								cic_list);
-		cic->exit(ioc);
-	}
-	rcu_read_unlock();
+	/* if no cic's left, we're done; otherwise, kick release_work */
+	if (hlist_empty(&ioc->cic_list))
+		kmem_cache_free(iocontext_cachep, ioc);
+	else
+		schedule_work(&ioc->release_work);
 }
+EXPORT_SYMBOL(put_io_context);
 
 /* Called by the exiting task */
 void exit_io_context(struct task_struct *task)
@@ -92,10 +199,8 @@ void exit_io_context(struct task_struct *task)
 	task->io_context = NULL;
 	task_unlock(task);
 
-	if (atomic_dec_and_test(&ioc->nr_tasks))
-		cfq_exit(ioc);
-
-	put_io_context(ioc);
+	atomic_dec(&ioc->nr_tasks);
+	put_io_context(ioc, NULL);
 }
 
 static struct io_context *create_task_io_context(struct task_struct *task,
@@ -115,6 +220,7 @@ static struct io_context *create_task_io_context(struct task_struct *task,
 	spin_lock_init(&ioc->lock);
 	INIT_RADIX_TREE(&ioc->radix_root, GFP_ATOMIC | __GFP_HIGH);
 	INIT_HLIST_HEAD(&ioc->cic_list);
+	INIT_WORK(&ioc->release_work, ioc_release_fn);
 
 	/* try to install, somebody might already have beaten us to it */
 	task_lock(task);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e617b08..6cc6065 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1778,7 +1778,7 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfqd->active_queue = NULL;
 
 	if (cfqd->active_cic) {
-		put_io_context(cfqd->active_cic->ioc);
+		put_io_context(cfqd->active_cic->ioc, cfqd->queue);
 		cfqd->active_cic = NULL;
 	}
 }
@@ -2812,38 +2812,6 @@ static void cfq_exit_cic(struct cfq_io_context *cic)
 	}
 }
 
-static void cfq_exit_single_io_context(struct io_context *ioc,
-				       struct cfq_io_context *cic)
-{
-	struct cfq_data *cfqd = cic_to_cfqd(cic);
-
-	if (cfqd) {
-		struct request_queue *q = cfqd->queue;
-		unsigned long flags;
-
-		spin_lock_irqsave(q->queue_lock, flags);
-
-		/*
-		 * Ensure we get a fresh copy of the ->key to prevent
-		 * race between exiting task and queue
-		 */
-		smp_read_barrier_depends();
-		if (cic->key == cfqd)
-			cfq_exit_cic(cic);
-
-		spin_unlock_irqrestore(q->queue_lock, flags);
-	}
-}
-
-/*
- * The process that ioc belongs to has exited, we need to clean up
- * and put the internal structures we have that belongs to that process.
- */
-static void cfq_exit_io_context(struct io_context *ioc)
-{
-	call_for_each_cic(ioc, cfq_exit_single_io_context);
-}
-
 static struct cfq_io_context *
 cfq_alloc_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 {
@@ -2855,8 +2823,8 @@ cfq_alloc_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 		cic->ttime.last_end_request = jiffies;
 		INIT_LIST_HEAD(&cic->queue_list);
 		INIT_HLIST_NODE(&cic->cic_list);
-		cic->dtor = cfq_free_io_context;
-		cic->exit = cfq_exit_io_context;
+		cic->exit = cfq_exit_cic;
+		cic->release = cfq_release_cic;
 		elv_ioc_count_inc(cfq_ioc_count);
 	}
 
@@ -3726,7 +3694,7 @@ static void cfq_put_request(struct request *rq)
 		BUG_ON(!cfqq->allocated[rw]);
 		cfqq->allocated[rw]--;
 
-		put_io_context(RQ_CIC(rq)->ioc);
+		put_io_context(RQ_CIC(rq)->ioc, cfqq->cfqd->queue);
 
 		rq->elevator_private[0] = NULL;
 		rq->elevator_private[1] = NULL;
@@ -3937,8 +3905,12 @@ static void cfq_exit_queue(struct elevator_queue *e)
 		struct cfq_io_context *cic = list_entry(cfqd->cic_list.next,
 							struct cfq_io_context,
 							queue_list);
+		struct io_context *ioc = cic->ioc;
 
+		spin_lock(&ioc->lock);
 		cfq_exit_cic(cic);
+		cfq_release_cic(cic);
+		spin_unlock(&ioc->lock);
 	}
 
 	cfq_put_async_queues(cfqd);
diff --git a/fs/ioprio.c b/fs/ioprio.c
index f8d8429..10b88d3 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -50,7 +50,7 @@ int set_task_ioprio(struct task_struct *task, int ioprio)
 	ioc = get_task_io_context(task, GFP_ATOMIC, NUMA_NO_NODE);
 	if (ioc) {
 		ioc_ioprio_changed(ioc, ioprio);
-		put_io_context(ioc);
+		put_io_context(ioc, NULL);
 	}
 
 	return err;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 19037fb..e4c10a0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -393,6 +393,9 @@ struct request_queue {
 	/* Throttle data */
 	struct throtl_data *td;
 #endif
+#ifdef CONFIG_LOCKDEP
+	int			ioc_release_depth;
+#endif
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 2c2b6da..01e8631 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -3,6 +3,7 @@
 
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
+#include <linux/workqueue.h>
 
 struct cfq_queue;
 struct cfq_ttime {
@@ -33,8 +34,8 @@ struct cfq_io_context {
 
 	unsigned long changed;
 
-	void (*dtor)(struct io_context *); /* destructor */
-	void (*exit)(struct io_context *); /* called on task exit */
+	void (*exit)(struct cfq_io_context *);
+	void (*release)(struct cfq_io_context *);
 
 	struct rcu_head rcu_head;
 };
@@ -61,6 +62,8 @@ struct io_context {
 	struct radix_tree_root radix_root;
 	struct hlist_head cic_list;
 	void __rcu *ioc_data;
+
+	struct work_struct release_work;
 };
 
 static inline struct io_context *ioc_task_link(struct io_context *ioc)
@@ -79,7 +82,7 @@ static inline struct io_context *ioc_task_link(struct io_context *ioc)
 
 struct task_struct;
 #ifdef CONFIG_BLOCK
-void put_io_context(struct io_context *ioc);
+void put_io_context(struct io_context *ioc, struct request_queue *locked_q);
 void exit_io_context(struct task_struct *task);
 struct io_context *get_task_io_context(struct task_struct *task,
 				       gfp_t gfp_flags, int node);
@@ -87,7 +90,8 @@ void ioc_ioprio_changed(struct io_context *ioc, int ioprio);
 void ioc_cgroup_changed(struct io_context *ioc);
 #else
 struct io_context;
-static inline void put_io_context(struct io_context *ioc) { }
+static inline void put_io_context(struct io_context *ioc,
+				  struct request_queue *locked_q) { }
 static inline void exit_io_context(struct task_struct *task) { }
 #endif
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 11da931..79e2909 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -895,7 +895,7 @@ static int copy_io(unsigned long clone_flags, struct task_struct *tsk)
 			return -ENOMEM;
 
 		new_ioc->ioprio = ioc->ioprio;
-		put_io_context(new_ioc);
+		put_io_context(new_ioc, NULL);
 	}
 #endif
 	return 0;
-- 
1.7.3.1

