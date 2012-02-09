Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2BIXsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 18:48:54 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49942 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab2BIXsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 18:48:50 -0500
Date: Thu, 9 Feb 2012 15:48:44 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] block: strip out locking optimization in
 put_io_context()
Message-ID: <20120209234844.GG19392@google.com>
References: <4F315113.5010804@kernel.dk>
 <CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
 <20120207164735.GH21292@google.com>
 <CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com>
 <CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com>
 <20120208162925.GA19392@google.com>
 <CANejiEVuQRUY4Ovb2a1JNDZjRTeN_nft8LwY8AB144=9dkFq7A@mail.gmail.com>
 <20120209175948.GE19392@google.com>
 <CA+55aFzVmb_DfPPDyeON9X2KAii79g=NszPi+k9jrNLdQS7+4g@mail.gmail.com>
 <20120209192431.GF19392@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209192431.GF19392@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Shaohua.

Can you please test the following one?  It's probably the simplest
version w/o RCU and wq deferring.  RCUfying isn't too bad but I'm
still a bit hesitant because RCU coverage needs to be extended to
request_queue via conditional synchronize_rcu() in queue exit path
(can't enforce delayed RCU free on request_queues and unconditional
synchronize_rcu() may cause excessive delay during boot for certain
configurations).  It now can be done in the block core layer proper so
it shouldn't be as bad tho.  If this too flops, I'll get to that.

Thanks.
---
 block/blk-cgroup.c        |    2 
 block/blk-core.c          |    2 
 block/blk-ioc.c           |  112 +++++++++++++++++-----------------------------
 block/cfq-iosched.c       |    2 
 fs/ioprio.c               |    2 
 include/linux/blkdev.h    |    3 +
 include/linux/iocontext.h |    8 +--
 kernel/fork.c             |    2 
 8 files changed, 54 insertions(+), 79 deletions(-)

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
Index: work/block/blk-ioc.c
===================================================================
--- work.orig/block/blk-ioc.c
+++ work/block/blk-ioc.c
@@ -29,6 +29,21 @@ void get_io_context(struct io_context *i
 }
 EXPORT_SYMBOL(get_io_context);
 
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
 static void icq_free_icq_rcu(struct rcu_head *head)
 {
 	struct io_cq *icq = container_of(head, struct io_cq, __rcu_head);
@@ -71,63 +86,6 @@ static void ioc_exit_icq(struct io_cq *i
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
-
-	spin_lock_irq(&ioc->lock);
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
-				spin_unlock_irq(&ioc->lock);
-				blk_put_queue(last_q);
-			} else {
-				spin_unlock_irq(&ioc->lock);
-			}
-
-			last_q = this_q;
-			spin_lock_irq(this_q->queue_lock);
-			spin_lock(&ioc->lock);
-			continue;
-		}
-		ioc_exit_icq(icq);
-	}
-
-	if (last_q) {
-		spin_unlock(last_q->queue_lock);
-		spin_unlock_irq(&ioc->lock);
-		blk_put_queue(last_q);
-	} else {
-		spin_unlock_irq(&ioc->lock);
-	}
-
-	kmem_cache_free(iocontext_cachep, ioc);
-}
-
 /**
  * put_io_context - put a reference of io_context
  * @ioc: io_context to put
@@ -135,7 +93,7 @@ static void ioc_release_fn(struct work_s
  * Decrement reference count of @ioc and release it if the count reaches
  * zero.
  */
-void put_io_context(struct io_context *ioc)
+void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
 {
 	unsigned long flags;
 
@@ -144,16 +102,33 @@ void put_io_context(struct io_context *i
 
 	BUG_ON(atomic_long_read(&ioc->refcount) <= 0);
 
-	/*
-	 * Releasing ioc requires reverse order double locking and we may
-	 * already be holding a queue_lock.  Do it asynchronously from wq.
-	 */
-	if (atomic_long_dec_and_test(&ioc->refcount)) {
-		spin_lock_irqsave(&ioc->lock, flags);
-		if (!hlist_empty(&ioc->icq_list))
-			schedule_work(&ioc->release_work);
-		spin_unlock_irqrestore(&ioc->lock, flags);
+	if (!atomic_long_dec_and_test(&ioc->refcount))
+		return;
+
+	spin_lock_irqsave_nested(&ioc->lock, flags,
+				 ioc_release_depth(locked_q));
+
+	while (!hlist_empty(&ioc->icq_list)) {
+		struct io_cq *icq = hlist_entry(ioc->icq_list.first,
+						struct io_cq, ioc_node);
+		struct request_queue *q = icq->q;
+
+		if (q == locked_q || spin_trylock(q->queue_lock)) {
+			ioc_release_depth_inc(q);
+			ioc_exit_icq(icq);
+			ioc_release_depth_dec(q);
+
+			if (q != locked_q)
+				spin_unlock(q->queue_lock);
+		} else {
+			spin_unlock_irqrestore(&ioc->lock, flags);
+			cpu_relax();
+			spin_lock_irqsave_nested(&ioc->lock, flags,
+						 ioc_release_depth(locked_q));
+		}
 	}
+
+	spin_unlock_irqrestore(&ioc->lock, flags);
 }
 EXPORT_SYMBOL(put_io_context);
 
@@ -168,7 +143,7 @@ void exit_io_context(struct task_struct 
 	task_unlock(task);
 
 	atomic_dec(&ioc->nr_tasks);
-	put_io_context(ioc);
+	put_io_context(ioc, NULL);
 }
 
 /**
@@ -208,7 +183,6 @@ void create_io_context_slowpath(struct t
 	spin_lock_init(&ioc->lock);
 	INIT_RADIX_TREE(&ioc->icq_tree, GFP_ATOMIC | __GFP_HIGH);
 	INIT_HLIST_HEAD(&ioc->icq_list);
-	INIT_WORK(&ioc->release_work, ioc_release_fn);
 
 	/*
 	 * Try to install.  ioc shouldn't be installed if someone else
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
Index: work/include/linux/iocontext.h
===================================================================
--- work.orig/include/linux/iocontext.h
+++ work/include/linux/iocontext.h
@@ -3,7 +3,6 @@
 
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
-#include <linux/workqueue.h>
 
 enum {
 	ICQ_IOPRIO_CHANGED,
@@ -113,8 +112,6 @@ struct io_context {
 	struct radix_tree_root	icq_tree;
 	struct io_cq __rcu	*icq_hint;
 	struct hlist_head	icq_list;
-
-	struct work_struct release_work;
 };
 
 static inline struct io_context *ioc_task_link(struct io_context *ioc)
@@ -133,7 +130,7 @@ static inline struct io_context *ioc_tas
 
 struct task_struct;
 #ifdef CONFIG_BLOCK
-void put_io_context(struct io_context *ioc);
+void put_io_context(struct io_context *ioc, struct request_queue *locked_q);
 void exit_io_context(struct task_struct *task);
 struct io_context *get_task_io_context(struct task_struct *task,
 				       gfp_t gfp_flags, int node);
@@ -141,7 +138,8 @@ void ioc_ioprio_changed(struct io_contex
 void ioc_cgroup_changed(struct io_context *ioc);
 #else
 struct io_context;
-static inline void put_io_context(struct io_context *ioc) { }
+static inline void put_io_context(struct io_context *ioc,
+				  struct request_queue *locked_q) { }
 static inline void exit_io_context(struct task_struct *task) { }
 #endif
 
Index: work/kernel/fork.c
===================================================================
--- work.orig/kernel/fork.c
+++ work/kernel/fork.c
@@ -890,7 +890,7 @@ static int copy_io(unsigned long clone_f
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
+	int			ioc_release_depth;
+#endif
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
