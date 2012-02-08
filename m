Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab2BHQ3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:29:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45253 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab2BHQ3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:29:31 -0500
Date: Wed, 8 Feb 2012 08:29:25 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [PATCH] block: strip out locking optimization in
 put_io_context()
Message-ID: <20120208162925.GA19392@google.com>
References: <20120206172706.GB21292@google.com>
 <4F303506.9000201@kernel.dk>
 <20120206215451.GD21292@google.com>
 <4F30C96F.1000905@kernel.dk>
 <20120207162253.GG21292@google.com>
 <4F315113.5010804@kernel.dk>
 <CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
 <20120207164735.GH21292@google.com>
 <CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com>
 <CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Shaohua.

On Wed, Feb 08, 2012 at 04:29:53PM +0800, Shaohua Li wrote:
> > the test adds mem=4G in a 2 sockets 16 CPU machine.
> > just make several copy of kernel source in tmpfs (so there is swap
> > depending on your
> > memory size) and run kernel build in the kernel source in the meaning time.
> > there is only one swap device which is a rotating disk.
> >
> > I'll test both patches soon.
>
> Tried all the options, the regression still exists. Any new idea?
> I'll spend some time on it if I can get anything

Can you please try the following one?  Thanks a lot!

---
 block/blk-cgroup.c        |    2 
 block/blk-core.c          |    2 
 block/blk-ioc.c           |   99 +++++++++++++---------------------------------
 block/cfq-iosched.c       |    2 
 fs/ioprio.c               |    2 
 include/linux/iocontext.h |    8 +--
 kernel/fork.c             |    2 
 7 files changed, 37 insertions(+), 80 deletions(-)

Index: work/block/blk-ioc.c
===================================================================
--- work.orig/block/blk-ioc.c
+++ work/block/blk-ioc.c
@@ -8,9 +8,12 @@
 #include <linux/blkdev.h>
 #include <linux/bootmem.h>	/* for max_pfn/max_low_pfn */
 #include <linux/slab.h>
+#include <linux/rwlock.h>
 
 #include "blk.h"
 
+static DEFINE_RWLOCK(ioc_clear_rwlock);
+
 /*
  * For io context allocations
  */
@@ -45,7 +48,7 @@ static void ioc_exit_icq(struct io_cq *i
 	struct request_queue *q = icq->q;
 	struct elevator_type *et = q->elevator->type;
 
-	lockdep_assert_held(&ioc->lock);
+	//lockdep_assert_held(&ioc->lock);
 	lockdep_assert_held(q->queue_lock);
 
 	radix_tree_delete(&ioc->icq_tree, icq->q->id);
@@ -71,63 +74,6 @@ static void ioc_exit_icq(struct io_cq *i
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
@@ -135,7 +81,7 @@ static void ioc_release_fn(struct work_s
  * Decrement reference count of @ioc and release it if the count reaches
  * zero.
  */
-void put_io_context(struct io_context *ioc)
+void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
 {
 	unsigned long flags;
 
@@ -144,16 +90,26 @@ void put_io_context(struct io_context *i
 
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
+	read_lock_irqsave(&ioc_clear_rwlock, flags);
+
+	while (!hlist_empty(&ioc->icq_list)) {
+		struct io_cq *icq = hlist_entry(ioc->icq_list.first,
+						struct io_cq, ioc_node);
+		struct request_queue *q = icq->q;
+
+		if (q != locked_q)
+			spin_lock_nested(q->queue_lock, 1);
+
+		ioc_exit_icq(icq);
+
+		if (q != locked_q)
+			spin_unlock(q->queue_lock);
 	}
+
+	read_unlock_irqrestore(&ioc_clear_rwlock, flags);
 }
 EXPORT_SYMBOL(put_io_context);
 
@@ -168,7 +124,7 @@ void exit_io_context(struct task_struct 
 	task_unlock(task);
 
 	atomic_dec(&ioc->nr_tasks);
-	put_io_context(ioc);
+	put_io_context(ioc, NULL);
 }
 
 /**
@@ -181,6 +137,8 @@ void ioc_clear_queue(struct request_queu
 {
 	lockdep_assert_held(q->queue_lock);
 
+	write_lock(&ioc_clear_rwlock);
+
 	while (!list_empty(&q->icq_list)) {
 		struct io_cq *icq = list_entry(q->icq_list.next,
 					       struct io_cq, q_node);
@@ -190,6 +148,8 @@ void ioc_clear_queue(struct request_queu
 		ioc_exit_icq(icq);
 		spin_unlock(&ioc->lock);
 	}
+
+	write_unlock(&ioc_clear_rwlock);
 }
 
 void create_io_context_slowpath(struct task_struct *task, gfp_t gfp_flags,
@@ -208,7 +168,6 @@ void create_io_context_slowpath(struct t
 	spin_lock_init(&ioc->lock);
 	INIT_RADIX_TREE(&ioc->icq_tree, GFP_ATOMIC | __GFP_HIGH);
 	INIT_HLIST_HEAD(&ioc->icq_list);
-	INIT_WORK(&ioc->release_work, ioc_release_fn);
 
 	/*
 	 * Try to install.  ioc shouldn't be installed if someone else
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
