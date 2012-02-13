Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab2BMUtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:49:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56738 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058Ab2BMUtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:49:43 -0500
Date: Mon, 13 Feb 2012 12:49:37 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] block: strip out locking optimization in
 put_io_context()
Message-ID: <20120213204937.GF12117@google.com>
References: <20120208162925.GA19392@google.com>
 <CANejiEVuQRUY4Ovb2a1JNDZjRTeN_nft8LwY8AB144=9dkFq7A@mail.gmail.com>
 <20120209175948.GE19392@google.com>
 <CA+55aFzVmb_DfPPDyeON9X2KAii79g=NszPi+k9jrNLdQS7+4g@mail.gmail.com>
 <20120209192431.GF19392@google.com>
 <20120209234844.GG19392@google.com>
 <CANejiEXaaSfv8Rs3Rg6zLamYsUj=apKku6yrw7EUtpKkB1ZATA@mail.gmail.com>
 <CANejiEVBd6eu8LwmhbMvQqMW4LqUh6F-5psyW0dVYU06WEJqBQ@mail.gmail.com>
 <20120211021724.GO19392@google.com>
 <CANejiEVQav8mtQHD0FETxo1-Zc7exMyb6ecjrAzdZWw68OkTug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANejiEVQav8mtQHD0FETxo1-Zc7exMyb6ecjrAzdZWw68OkTug@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Shaohua.

Can you please test the following patch?  It's combination of three
patches which invokes elevator icq exit from exit_io_context().  This
unfortunately ends up adding another reverse locking loop and using
RCU could be better; unfortunately, the change isn't trivial due to
q->queue_lock modification during blk_cleanup_queue() and ioc cleanup
being called after that from blk_release_queue() - IOW, while holding
RCU, we might end up grabbing the wrong q lock (I don't think this is
a new problem).

Now that we have proper request draining on queue exit, we can
probably move ioc clearing and other operations to blk_cleanup_queue()
and then apply RCU, but that's for another merge window.

Thanks.

Index: work/block/blk-ioc.c
===================================================================
--- work.orig/block/blk-ioc.c
+++ work/block/blk-ioc.c
@@ -29,6 +29,21 @@ void get_io_context(struct io_context *i
 }
 EXPORT_SYMBOL(get_io_context);
 
+/*
+ * Exiting ioc may nest into another put_io_context() leading to nested
+ * fast path release.  As the ioc's can't be the same, this is okay but
+ * makes lockdep whine.  Keep track of nesting and use it as subclass.
+ */
+#ifdef CONFIG_LOCKDEP
+#define ioc_exit_depth(q)		((q) ? (q)->ioc_exit_depth : 0)
+#define ioc_exit_depth_inc(q)		(q)->ioc_exit_depth++
+#define ioc_exit_depth_dec(q)		(q)->ioc_exit_depth--
+#else
+#define ioc_exit_depth(q)		0
+#define ioc_exit_depth_inc(q)		do { } while (0)
+#define ioc_exit_depth_dec(q)		do { } while (0)
+#endif
+
 static void icq_free_icq_rcu(struct rcu_head *head)
 {
 	struct io_cq *icq = container_of(head, struct io_cq, __rcu_head);
@@ -36,17 +51,31 @@ static void icq_free_icq_rcu(struct rcu_
 	kmem_cache_free(icq->__rcu_icq_cache, icq);
 }
 
-/*
- * Exit and free an icq.  Called with both ioc and q locked.
- */
+/* Exit an icq. Called with both ioc and q locked. */
 static void ioc_exit_icq(struct io_cq *icq)
 {
+	struct elevator_type *et = icq->q->elevator->type;
+
+	if (icq->flags & ICQ_EXITED)
+		return;
+
+	if (et->ops.elevator_exit_icq_fn) {
+		ioc_exit_depth_inc(icq->q);
+		et->ops.elevator_exit_icq_fn(icq);
+		ioc_exit_depth_dec(icq->q);
+	}
+
+	icq->flags |= ICQ_EXITED;
+}
+
+/* Release an icq.  Called with both ioc and q locked. */
+static void ioc_destroy_icq(struct io_cq *icq)
+{
 	struct io_context *ioc = icq->ioc;
-	struct request_queue *q = icq->q;
-	struct elevator_type *et = q->elevator->type;
+	struct elevator_type *et = icq->q->elevator->type;
 
 	lockdep_assert_held(&ioc->lock);
-	lockdep_assert_held(q->queue_lock);
+	lockdep_assert_held(icq->q->queue_lock);
 
 	radix_tree_delete(&ioc->icq_tree, icq->q->id);
 	hlist_del_init(&icq->ioc_node);
@@ -60,8 +89,7 @@ static void ioc_exit_icq(struct io_cq *i
 	if (rcu_dereference_raw(ioc->icq_hint) == icq)
 		rcu_assign_pointer(ioc->icq_hint, NULL);
 
-	if (et->ops.elevator_exit_icq_fn)
-		et->ops.elevator_exit_icq_fn(icq);
+	ioc_exit_icq(icq);
 
 	/*
 	 * @icq->q might have gone away by the time RCU callback runs
@@ -71,70 +99,6 @@ static void ioc_exit_icq(struct io_cq *i
 	call_rcu(&icq->__rcu_head, icq_free_icq_rcu);
 }
 
-/*
- * Slow path for ioc release in put_io_context().  Performs double-lock
- * dancing to unlink all icq's and then frees ioc.
- */
-static void ioc_release_fn(struct work_struct *work)
-{
-	struct io_context *ioc = container_of(work, struct io_context,
-					      release_work);
-	struct request_queue *last_q = NULL;
-	unsigned long flags;
-
-	/*
-	 * Exiting icq may call into put_io_context() through elevator
-	 * which will trigger lockdep warning.  The ioc's are guaranteed to
-	 * be different, use a different locking subclass here.  Use
-	 * irqsave variant as there's no spin_lock_irq_nested().
-	 */
-	spin_lock_irqsave_nested(&ioc->lock, flags, 1);
-
-	while (!hlist_empty(&ioc->icq_list)) {
-		struct io_cq *icq = hlist_entry(ioc->icq_list.first,
-						struct io_cq, ioc_node);
-		struct request_queue *this_q = icq->q;
-
-		if (this_q != last_q) {
-			/*
-			 * Need to switch to @this_q.  Once we release
-			 * @ioc->lock, it can go away along with @cic.
-			 * Hold on to it.
-			 */
-			__blk_get_queue(this_q);
-
-			/*
-			 * blk_put_queue() might sleep thanks to kobject
-			 * idiocy.  Always release both locks, put and
-			 * restart.
-			 */
-			if (last_q) {
-				spin_unlock(last_q->queue_lock);
-				spin_unlock_irqrestore(&ioc->lock, flags);
-				blk_put_queue(last_q);
-			} else {
-				spin_unlock_irqrestore(&ioc->lock, flags);
-			}
-
-			last_q = this_q;
-			spin_lock_irqsave(this_q->queue_lock, flags);
-			spin_lock_nested(&ioc->lock, 1);
-			continue;
-		}
-		ioc_exit_icq(icq);
-	}
-
-	if (last_q) {
-		spin_unlock(last_q->queue_lock);
-		spin_unlock_irqrestore(&ioc->lock, flags);
-		blk_put_queue(last_q);
-	} else {
-		spin_unlock_irqrestore(&ioc->lock, flags);
-	}
-
-	kmem_cache_free(iocontext_cachep, ioc);
-}
-
 /**
  * put_io_context - put a reference of io_context
  * @ioc: io_context to put
@@ -142,7 +106,7 @@ static void ioc_release_fn(struct work_s
  * Decrement reference count of @ioc and release it if the count reaches
  * zero.
  */
-void put_io_context(struct io_context *ioc)
+void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
 {
 	unsigned long flags;
 
@@ -151,16 +115,33 @@ void put_io_context(struct io_context *i
 
 	BUG_ON(atomic_long_read(&ioc->refcount) <= 0);
 
+	if (!atomic_long_dec_and_test(&ioc->refcount))
+		return;
+
 	/*
-	 * Releasing ioc requires reverse order double locking and we may
-	 * already be holding a queue_lock.  Do it asynchronously from wq.
+	 * Need to grab both q and ioc locks from ioc side to release all
+	 * icqs.  Perform reverse double locking.
 	 */
-	if (atomic_long_dec_and_test(&ioc->refcount)) {
-		spin_lock_irqsave(&ioc->lock, flags);
-		if (!hlist_empty(&ioc->icq_list))
-			schedule_work(&ioc->release_work);
-		spin_unlock_irqrestore(&ioc->lock, flags);
+	spin_lock_irqsave_nested(&ioc->lock, flags, ioc_exit_depth(locked_q));
+
+	while (!hlist_empty(&ioc->icq_list)) {
+		struct io_cq *icq = hlist_entry(ioc->icq_list.first,
+						struct io_cq, ioc_node);
+		struct request_queue *q = icq->q;
+
+		if (q == locked_q || spin_trylock(q->queue_lock)) {
+			ioc_destroy_icq(icq);
+			if (q != locked_q)
+				spin_unlock(q->queue_lock);
+		} else {
+			spin_unlock_irqrestore(&ioc->lock, flags);
+			cpu_relax();
+			spin_lock_irqsave_nested(&ioc->lock, flags,
+						 ioc_exit_depth(locked_q));
+		}
 	}
+
+	spin_unlock_irqrestore(&ioc->lock, flags);
 }
 EXPORT_SYMBOL(put_io_context);
 
@@ -168,14 +149,40 @@ EXPORT_SYMBOL(put_io_context);
 void exit_io_context(struct task_struct *task)
 {
 	struct io_context *ioc;
+	struct io_cq *icq;
+	struct hlist_node *n;
 
 	task_lock(task);
 	ioc = task->io_context;
 	task->io_context = NULL;
 	task_unlock(task);
 
-	atomic_dec(&ioc->nr_tasks);
-	put_io_context(ioc);
+	if (!atomic_dec_and_test(&ioc->nr_tasks)) {
+		put_io_context(ioc, NULL);
+		return;
+	}
+
+	/*
+	 * Need ioc lock to walk icq_list and q lock to exit icq.  Perform
+	 * reverse double locking.
+	 */
+retry:
+	spin_lock_irq(&ioc->lock);
+	hlist_for_each_entry(icq, n, &ioc->icq_list, ioc_node) {
+		if (icq->flags & ICQ_EXITED)
+			continue;
+		if (spin_trylock(icq->q->queue_lock)) {
+			ioc_exit_icq(icq);
+			spin_unlock(icq->q->queue_lock);
+		} else {
+			spin_unlock_irq(&ioc->lock);
+			cpu_relax();
+			goto retry;
+		}
+	}
+	spin_unlock_irq(&ioc->lock);
+
+	put_io_context(ioc, NULL);
 }
 
 /**
@@ -194,7 +201,7 @@ void ioc_clear_queue(struct request_queu
 		struct io_context *ioc = icq->ioc;
 
 		spin_lock(&ioc->lock);
-		ioc_exit_icq(icq);
+		ioc_destroy_icq(icq);
 		spin_unlock(&ioc->lock);
 	}
 }
@@ -215,7 +222,6 @@ void create_io_context_slowpath(struct t
 	spin_lock_init(&ioc->lock);
 	INIT_RADIX_TREE(&ioc->icq_tree, GFP_ATOMIC | __GFP_HIGH);
 	INIT_HLIST_HEAD(&ioc->icq_list);
-	INIT_WORK(&ioc->release_work, ioc_release_fn);
 
 	/*
 	 * Try to install.  ioc shouldn't be installed if someone else
@@ -363,13 +369,13 @@ struct io_cq *ioc_create_icq(struct requ
 	return icq;
 }
 
-void ioc_set_changed(struct io_context *ioc, int which)
+void ioc_set_icq_flags(struct io_context *ioc, unsigned int flags)
 {
 	struct io_cq *icq;
 	struct hlist_node *n;
 
 	hlist_for_each_entry(icq, n, &ioc->icq_list, ioc_node)
-		set_bit(which, &icq->changed);
+		icq->flags |= flags;
 }
 
 /**
@@ -387,7 +393,7 @@ void ioc_ioprio_changed(struct io_contex
 
 	spin_lock_irqsave(&ioc->lock, flags);
 	ioc->ioprio = ioprio;
-	ioc_set_changed(ioc, ICQ_IOPRIO_CHANGED);
+	ioc_set_icq_flags(ioc, ICQ_IOPRIO_CHANGED);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 }
 
@@ -404,11 +410,33 @@ void ioc_cgroup_changed(struct io_contex
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->lock, flags);
-	ioc_set_changed(ioc, ICQ_CGROUP_CHANGED);
+	ioc_set_icq_flags(ioc, ICQ_CGROUP_CHANGED);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 }
 EXPORT_SYMBOL(ioc_cgroup_changed);
 
+/**
+ * icq_get_changed - fetch and clear icq changed mask
+ * @icq: icq of interest
+ *
+ * Fetch and clear ICQ_*_CHANGED bits from @icq.  Grabs and releases
+ * @icq->ioc->lock.
+ */
+unsigned icq_get_changed(struct io_cq *icq)
+{
+	unsigned int changed = 0;
+	unsigned long flags;
+
+	if (unlikely(icq->flags & ICQ_CHANGED_MASK)) {
+		spin_lock_irqsave(&icq->ioc->lock, flags);
+		changed = icq->flags & ICQ_CHANGED_MASK;
+		icq->flags &= ~ICQ_CHANGED_MASK;
+		spin_unlock_irqrestore(&icq->ioc->lock, flags);
+	}
+	return changed;
+}
+EXPORT_SYMBOL(icq_get_changed);
+
 static int __init blk_ioc_init(void)
 {
 	iocontext_cachep = kmem_cache_create("blkdev_ioc",
Index: work/block/cfq-iosched.c
===================================================================
--- work.orig/block/cfq-iosched.c
+++ work/block/cfq-iosched.c
@@ -1787,7 +1787,7 @@ __cfq_slice_expired(struct cfq_data *cfq
 		cfqd->active_queue = NULL;
 
 	if (cfqd->active_cic) {
-		put_io_context(cfqd->active_cic->icq.ioc);
+		put_io_context(cfqd->active_cic->icq.ioc, cfqd->queue);
 		cfqd->active_cic = NULL;
 	}
 }
@@ -3470,20 +3470,20 @@ cfq_set_request(struct request_queue *q,
 	const int rw = rq_data_dir(rq);
 	const bool is_sync = rq_is_sync(rq);
 	struct cfq_queue *cfqq;
+	unsigned int changed;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
 	spin_lock_irq(q->queue_lock);
 
 	/* handle changed notifications */
-	if (unlikely(cic->icq.changed)) {
-		if (test_and_clear_bit(ICQ_IOPRIO_CHANGED, &cic->icq.changed))
-			changed_ioprio(cic);
+	changed = icq_get_changed(&cic->icq);
+	if (unlikely(changed & ICQ_IOPRIO_CHANGED))
+		changed_ioprio(cic);
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-		if (test_and_clear_bit(ICQ_CGROUP_CHANGED, &cic->icq.changed))
-			changed_cgroup(cic);
+	if (unlikely(changed & ICQ_CGROUP_CHANGED))
+		changed_cgroup(cic);
 #endif
-	}
 
 new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
Index: work/include/linux/iocontext.h
===================================================================
--- work.orig/include/linux/iocontext.h
+++ work/include/linux/iocontext.h
@@ -3,11 +3,13 @@
 
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
-#include <linux/workqueue.h>
 
 enum {
-	ICQ_IOPRIO_CHANGED,
-	ICQ_CGROUP_CHANGED,
+	ICQ_IOPRIO_CHANGED	= 1 << 0,
+	ICQ_CGROUP_CHANGED	= 1 << 1,
+	ICQ_EXITED		= 1 << 2,
+
+	ICQ_CHANGED_MASK	= ICQ_IOPRIO_CHANGED | ICQ_CGROUP_CHANGED,
 };
 
 /*
@@ -88,7 +90,8 @@ struct io_cq {
 		struct rcu_head		__rcu_head;
 	};
 
-	unsigned long		changed;
+	/* ICQ_*, use atomic bitops */
+	unsigned long		flags;
 };
 
 /*
@@ -113,8 +116,6 @@ struct io_context {
 	struct radix_tree_root	icq_tree;
 	struct io_cq __rcu	*icq_hint;
 	struct hlist_head	icq_list;
-
-	struct work_struct release_work;
 };
 
 static inline struct io_context *ioc_task_link(struct io_context *ioc)
@@ -133,15 +134,17 @@ static inline struct io_context *ioc_tas
 
 struct task_struct;
 #ifdef CONFIG_BLOCK
-void put_io_context(struct io_context *ioc);
+void put_io_context(struct io_context *ioc, struct request_queue *locked_q);
 void exit_io_context(struct task_struct *task);
 struct io_context *get_task_io_context(struct task_struct *task,
 				       gfp_t gfp_flags, int node);
 void ioc_ioprio_changed(struct io_context *ioc, int ioprio);
 void ioc_cgroup_changed(struct io_context *ioc);
+unsigned int icq_get_changed(struct io_cq *icq);
 #else
 struct io_context;
-static inline void put_io_context(struct io_context *ioc) { }
+static inline void put_io_context(struct io_context *ioc,
+				  struct request_queue *locked_q) { }
 static inline void exit_io_context(struct task_struct *task) { }
 #endif
 
Index: work/block/blk-cgroup.c
===================================================================
--- work.orig/block/blk-cgroup.c
+++ work/block/blk-cgroup.c
@@ -1659,7 +1659,7 @@ static void blkiocg_attach(struct cgroup
 		ioc = get_task_io_context(task, GFP_ATOMIC, NUMA_NO_NODE);
 		if (ioc) {
 			ioc_cgroup_changed(ioc);
-			put_io_context(ioc);
+			put_io_context(ioc, NULL);
 		}
 	}
 }
Index: work/block/blk-core.c
===================================================================
--- work.orig/block/blk-core.c
+++ work/block/blk-core.c
@@ -642,7 +642,7 @@ static inline void blk_free_request(stru
 	if (rq->cmd_flags & REQ_ELVPRIV) {
 		elv_put_request(q, rq);
 		if (rq->elv.icq)
-			put_io_context(rq->elv.icq->ioc);
+			put_io_context(rq->elv.icq->ioc, q);
 	}
 
 	mempool_free(rq, q->rq.rq_pool);
Index: work/fs/ioprio.c
===================================================================
--- work.orig/fs/ioprio.c
+++ work/fs/ioprio.c
@@ -51,7 +51,7 @@ int set_task_ioprio(struct task_struct *
 	ioc = get_task_io_context(task, GFP_ATOMIC, NUMA_NO_NODE);
 	if (ioc) {
 		ioc_ioprio_changed(ioc, ioprio);
-		put_io_context(ioc);
+		put_io_context(ioc, NULL);
 	}
 
 	return err;
Index: work/kernel/fork.c
===================================================================
--- work.orig/kernel/fork.c
+++ work/kernel/fork.c
@@ -910,7 +910,7 @@ static int copy_io(unsigned long clone_f
 			return -ENOMEM;
 
 		new_ioc->ioprio = ioc->ioprio;
-		put_io_context(new_ioc);
+		put_io_context(new_ioc, NULL);
 	}
 #endif
 	return 0;
Index: work/include/linux/blkdev.h
===================================================================
--- work.orig/include/linux/blkdev.h
+++ work/include/linux/blkdev.h
@@ -399,6 +399,9 @@ struct request_queue {
 	/* Throttle data */
 	struct throtl_data *td;
 #endif
+#ifdef CONFIG_LOCKDEP
+	int			ioc_exit_depth;
+#endif
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
