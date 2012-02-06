Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab2BFVy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:54:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34850 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2BFVy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:54:56 -0500
Date: Mon, 6 Feb 2012 13:54:51 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Shaohua Li <vivek.goyal2008@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: [PATCH] block: strip out locking optimization in put_io_context()
Message-ID: <20120206215451.GD21292@google.com>
References: <1328514611.21268.66.camel@sli10-conroe>
 <20120206151219.GC30752@redhat.com>
 <4F2FFB21.9000202@kernel.dk>
 <20120206163721.GF30752@redhat.com>
 <20120206164428.GA21292@google.com>
 <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
 <20120206172706.GB21292@google.com>
 <4F303506.9000201@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F303506.9000201@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_io_context() performed a complex trylock dancing to avoid
deferring ioc release to workqueue.  It was also broken on UP because
trylock was always assumed to succeed which resulted in unbalanced
preemption count.

While there are ways to fix the UP breakage, even the most
pathological microbench (forced ioc allocation and tight fork/exit
loop) fails to show any appreciable performance benefit of the
optimization.  Strip it out.  If there turns out to be workloads which
are affected by this change, simpler optimization from the discussion
thread can be applied later.

Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <1328514611.21268.66.camel@sli10-conroe>
---
I couldn't find any statiscally meaningful advantage of the
optimization with tight fork/exit tests w/ forced ioc creation on
fork, which gotta be the most pathological test case for the code
path.  So, let's remove the ugly optimization.  If I missed sth, we
can resurrect the simpler optimization later.  Jens, this is on top of
linus#master without Shaohua's patch.

Thanks.

 block/blk-cgroup.c        |    2 -
 block/blk-core.c          |    2 -
 block/blk-ioc.c           |   90 +++++-----------------------------------------
 block/cfq-iosched.c       |    2 -
 fs/ioprio.c               |    2 -
 include/linux/blkdev.h    |    3 -
 include/linux/iocontext.h |    5 +-
 kernel/fork.c             |    2 -
 8 files changed, 18 insertions(+), 90 deletions(-)

Index: work/block/blk-cgroup.c
===================================================================
--- work.orig/block/blk-cgroup.c
+++ work/block/blk-cgroup.c
@@ -1659,7 +1659,7 @@ static void blkiocg_attach(struct cgroup
 		ioc = get_task_io_context(task, GFP_ATOMIC, NUMA_NO_NODE);
 		if (ioc) {
 			ioc_cgroup_changed(ioc);
-			put_io_context(ioc, NULL);
+			put_io_context(ioc);
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
-			put_io_context(rq->elv.icq->ioc, q);
+			put_io_context(rq->elv.icq->ioc);
 	}
 
 	mempool_free(rq, q->rq.rq_pool);
Index: work/block/blk-ioc.c
===================================================================
--- work.orig/block/blk-ioc.c
+++ work/block/blk-ioc.c
@@ -29,21 +29,6 @@ void get_io_context(struct io_context *i
 }
 EXPORT_SYMBOL(get_io_context);
 
-/*
- * Releasing ioc may nest into another put_io_context() leading to nested
- * fast path release.  As the ioc's can't be the same, this is okay but
- * makes lockdep whine.  Keep track of nesting and use it as subclass.
- */
-#ifdef CONFIG_LOCKDEP
-#define ioc_release_depth(q)		((q) ? (q)->ioc_release_depth : 0)
-#define ioc_release_depth_inc(q)	(q)->ioc_release_depth++
-#define ioc_release_depth_dec(q)	(q)->ioc_release_depth--
-#else
-#define ioc_release_depth(q)		0
-#define ioc_release_depth_inc(q)	do { } while (0)
-#define ioc_release_depth_dec(q)	do { } while (0)
-#endif
-
 static void icq_free_icq_rcu(struct rcu_head *head)
 {
 	struct io_cq *icq = container_of(head, struct io_cq, __rcu_head);
@@ -75,11 +60,8 @@ static void ioc_exit_icq(struct io_cq *i
 	if (rcu_dereference_raw(ioc->icq_hint) == icq)
 		rcu_assign_pointer(ioc->icq_hint, NULL);
 
-	if (et->ops.elevator_exit_icq_fn) {
-		ioc_release_depth_inc(q);
+	if (et->ops.elevator_exit_icq_fn)
 		et->ops.elevator_exit_icq_fn(icq);
-		ioc_release_depth_dec(q);
-	}
 
 	/*
 	 * @icq->q might have gone away by the time RCU callback runs
@@ -149,79 +131,29 @@ static void ioc_release_fn(struct work_s
 /**
  * put_io_context - put a reference of io_context
  * @ioc: io_context to put
- * @locked_q: request_queue the caller is holding queue_lock of (hint)
  *
  * Decrement reference count of @ioc and release it if the count reaches
- * zero.  If the caller is holding queue_lock of a queue, it can indicate
- * that with @locked_q.  This is an optimization hint and the caller is
- * allowed to pass in %NULL even when it's holding a queue_lock.
+ * zero.
  */
-void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
+void put_io_context(struct io_context *ioc)
 {
-	struct request_queue *last_q = locked_q;
 	unsigned long flags;
 
 	if (ioc == NULL)
 		return;
 
 	BUG_ON(atomic_long_read(&ioc->refcount) <= 0);
-	if (locked_q)
-		lockdep_assert_held(locked_q->queue_lock);
-
-	if (!atomic_long_dec_and_test(&ioc->refcount))
-		return;
 
 	/*
-	 * Destroy @ioc.  This is a bit messy because icq's are chained
-	 * from both ioc and queue, and ioc->lock nests inside queue_lock.
-	 * The inner ioc->lock should be held to walk our icq_list and then
-	 * for each icq the outer matching queue_lock should be grabbed.
-	 * ie. We need to do reverse-order double lock dancing.
-	 *
-	 * Another twist is that we are often called with one of the
-	 * matching queue_locks held as indicated by @locked_q, which
-	 * prevents performing double-lock dance for other queues.
-	 *
-	 * So, we do it in two stages.  The fast path uses the queue_lock
-	 * the caller is holding and, if other queues need to be accessed,
-	 * uses trylock to avoid introducing locking dependency.  This can
-	 * handle most cases, especially if @ioc was performing IO on only
-	 * single device.
-	 *
-	 * If trylock doesn't cut it, we defer to @ioc->release_work which
-	 * can do all the double-locking dancing.
+	 * Releasing ioc requires reverse order double locking and we may
+	 * already be holding a queue_lock.  Do it asynchronously from wq.
 	 */
-	spin_lock_irqsave_nested(&ioc->lock, flags,
-				 ioc_release_depth(locked_q));
-
-	while (!hlist_empty(&ioc->icq_list)) {
-		struct io_cq *icq = hlist_entry(ioc->icq_list.first,
-						struct io_cq, ioc_node);
-		struct request_queue *this_q = icq->q;
-
-		if (this_q != last_q) {
-			if (last_q && last_q != locked_q)
-				spin_unlock(last_q->queue_lock);
-			last_q = NULL;
-
-			if (!spin_trylock(this_q->queue_lock))
-				break;
-			last_q = this_q;
-			continue;
-		}
-		ioc_exit_icq(icq);
+	if (atomic_long_dec_and_test(&ioc->refcount)) {
+		spin_lock_irqsave(&ioc->lock, flags);
+		if (!hlist_empty(&ioc->icq_list))
+			schedule_work(&ioc->release_work);
+		spin_unlock_irqrestore(&ioc->lock, flags);
 	}
-
-	if (last_q && last_q != locked_q)
-		spin_unlock(last_q->queue_lock);
-
-	spin_unlock_irqrestore(&ioc->lock, flags);
-
-	/* if no icq is left, we're done; otherwise, kick release_work */
-	if (hlist_empty(&ioc->icq_list))
-		kmem_cache_free(iocontext_cachep, ioc);
-	else
-		schedule_work(&ioc->release_work);
 }
 EXPORT_SYMBOL(put_io_context);
 
@@ -236,7 +168,7 @@ void exit_io_context(struct task_struct 
 	task_unlock(task);
 
 	atomic_dec(&ioc->nr_tasks);
-	put_io_context(ioc, NULL);
+	put_io_context(ioc);
 }
 
 /**
Index: work/block/cfq-iosched.c
===================================================================
--- work.orig/block/cfq-iosched.c
+++ work/block/cfq-iosched.c
@@ -1794,7 +1794,7 @@ __cfq_slice_expired(struct cfq_data *cfq
 		cfqd->active_queue = NULL;
 
 	if (cfqd->active_cic) {
-		put_io_context(cfqd->active_cic->icq.ioc, cfqd->queue);
+		put_io_context(cfqd->active_cic->icq.ioc);
 		cfqd->active_cic = NULL;
 	}
 }
Index: work/fs/ioprio.c
===================================================================
--- work.orig/fs/ioprio.c
+++ work/fs/ioprio.c
@@ -51,7 +51,7 @@ int set_task_ioprio(struct task_struct *
 	ioc = get_task_io_context(task, GFP_ATOMIC, NUMA_NO_NODE);
 	if (ioc) {
 		ioc_ioprio_changed(ioc, ioprio);
-		put_io_context(ioc, NULL);
+		put_io_context(ioc);
 	}
 
 	return err;
Index: work/include/linux/blkdev.h
===================================================================
--- work.orig/include/linux/blkdev.h
+++ work/include/linux/blkdev.h
@@ -399,9 +399,6 @@ struct request_queue {
 	/* Throttle data */
 	struct throtl_data *td;
 #endif
-#ifdef CONFIG_LOCKDEP
-	int			ioc_release_depth;
-#endif
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
Index: work/include/linux/iocontext.h
===================================================================
--- work.orig/include/linux/iocontext.h
+++ work/include/linux/iocontext.h
@@ -133,7 +133,7 @@ static inline struct io_context *ioc_tas
 
 struct task_struct;
 #ifdef CONFIG_BLOCK
-void put_io_context(struct io_context *ioc, struct request_queue *locked_q);
+void put_io_context(struct io_context *ioc);
 void exit_io_context(struct task_struct *task);
 struct io_context *get_task_io_context(struct task_struct *task,
 				       gfp_t gfp_flags, int node);
@@ -141,8 +141,7 @@ void ioc_ioprio_changed(struct io_contex
 void ioc_cgroup_changed(struct io_context *ioc);
 #else
 struct io_context;
-static inline void put_io_context(struct io_context *ioc,
-				  struct request_queue *locked_q) { }
+static inline void put_io_context(struct io_context *ioc) { }
 static inline void exit_io_context(struct task_struct *task) { }
 #endif
 
Index: work/kernel/fork.c
===================================================================
--- work.orig/kernel/fork.c
+++ work/kernel/fork.c
@@ -890,7 +890,7 @@ static int copy_io(unsigned long clone_f
 			return -ENOMEM;
 
 		new_ioc->ioprio = ioc->ioprio;
-		put_io_context(new_ioc, NULL);
+		put_io_context(new_ioc);
 	}
 #endif
 	return 0;
