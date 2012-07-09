Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab2GISne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:43:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56130 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2GISmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:42:13 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, joshhunt00@gmail.com, axboe@kernel.dk,
        rni@google.com, vgoyal@redhat.com, vwadekar@nvidia.com,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, swhiteho@redhat.com, bpm@sgi.com,
        elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] workqueue: separate out worker_pool flags
Date: Mon,  9 Jul 2012 11:41:53 -0700
Message-Id: <1341859315-17759-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1341859315-17759-1-git-send-email-tj@kernel.org>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCWQ_MANAGE_WORKERS, GCWQ_MANAGING_WORKERS and GCWQ_HIGHPRI_PENDING
are per-pool properties.  Add worker_pool->flags and make the above
three flags per-pool flags.

The changes in this patch are mechanical and don't caues any
functional difference.  This is to prepare for multiple pools per
gcwq.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   47 +++++++++++++++++++++++++----------------------
 1 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9f82c25..e700dcc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -46,11 +46,13 @@
 
 enum {
 	/* global_cwq flags */
-	GCWQ_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
-	GCWQ_MANAGING_WORKERS	= 1 << 1,	/* managing workers */
-	GCWQ_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
-	GCWQ_FREEZING		= 1 << 3,	/* freeze in progress */
-	GCWQ_HIGHPRI_PENDING	= 1 << 4,	/* highpri works on queue */
+	GCWQ_DISASSOCIATED	= 1 << 0,	/* cpu can't serve workers */
+	GCWQ_FREEZING		= 1 << 1,	/* freeze in progress */
+
+	/* pool flags */
+	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
+	POOL_MANAGING_WORKERS	= 1 << 1,	/* managing workers */
+	POOL_HIGHPRI_PENDING	= 1 << 2,	/* highpri works on queue */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -142,6 +144,7 @@ struct worker {
 
 struct worker_pool {
 	struct global_cwq	*gcwq;		/* I: the owning gcwq */
+	unsigned int		flags;		/* X: flags */
 
 	struct list_head	worklist;	/* L: list of pending works */
 	int			nr_workers;	/* L: total number of workers */
@@ -583,7 +586,7 @@ static struct global_cwq *get_work_gcwq(struct work_struct *work)
 static bool __need_more_worker(struct worker_pool *pool)
 {
 	return !atomic_read(get_pool_nr_running(pool)) ||
-		pool->gcwq->flags & GCWQ_HIGHPRI_PENDING;
+		(pool->flags & POOL_HIGHPRI_PENDING);
 }
 
 /*
@@ -612,7 +615,7 @@ static bool keep_working(struct worker_pool *pool)
 
 	return !list_empty(&pool->worklist) &&
 		(atomic_read(nr_running) <= 1 ||
-		 pool->gcwq->flags & GCWQ_HIGHPRI_PENDING);
+		 (pool->flags & POOL_HIGHPRI_PENDING));
 }
 
 /* Do we need a new worker?  Called from manager. */
@@ -625,13 +628,13 @@ static bool need_to_create_worker(struct worker_pool *pool)
 static bool need_to_manage_workers(struct worker_pool *pool)
 {
 	return need_to_create_worker(pool) ||
-		pool->gcwq->flags & GCWQ_MANAGE_WORKERS;
+		(pool->flags & POOL_MANAGE_WORKERS);
 }
 
 /* Do we have too many workers and should some go away? */
 static bool too_many_workers(struct worker_pool *pool)
 {
-	bool managing = pool->gcwq->flags & GCWQ_MANAGING_WORKERS;
+	bool managing = pool->flags & POOL_MANAGING_WORKERS;
 	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
 	int nr_busy = pool->nr_workers - nr_idle;
 
@@ -889,7 +892,7 @@ static struct worker *find_worker_executing_work(struct global_cwq *gcwq,
  * position for the work.  If @cwq is for HIGHPRI wq, the work is
  * queued at the head of the queue but in FIFO order with respect to
  * other HIGHPRI works; otherwise, at the end of the queue.  This
- * function also sets GCWQ_HIGHPRI_PENDING flag to hint @pool that
+ * function also sets POOL_HIGHPRI_PENDING flag to hint @pool that
  * there are HIGHPRI works pending.
  *
  * CONTEXT:
@@ -913,7 +916,7 @@ static inline struct list_head *pool_determine_ins_pos(struct worker_pool *pool,
 			break;
 	}
 
-	pool->gcwq->flags |= GCWQ_HIGHPRI_PENDING;
+	pool->flags |= POOL_HIGHPRI_PENDING;
 	return &twork->entry;
 }
 
@@ -1500,7 +1503,7 @@ static void idle_worker_timeout(unsigned long __pool)
 			mod_timer(&pool->idle_timer, expires);
 		else {
 			/* it's been idle for too long, wake up manager */
-			gcwq->flags |= GCWQ_MANAGE_WORKERS;
+			pool->flags |= POOL_MANAGE_WORKERS;
 			wake_up_worker(pool);
 		}
 	}
@@ -1680,11 +1683,11 @@ static bool manage_workers(struct worker *worker)
 	struct global_cwq *gcwq = pool->gcwq;
 	bool ret = false;
 
-	if (gcwq->flags & GCWQ_MANAGING_WORKERS)
+	if (pool->flags & POOL_MANAGING_WORKERS)
 		return ret;
 
-	gcwq->flags &= ~GCWQ_MANAGE_WORKERS;
-	gcwq->flags |= GCWQ_MANAGING_WORKERS;
+	pool->flags &= ~POOL_MANAGE_WORKERS;
+	pool->flags |= POOL_MANAGING_WORKERS;
 
 	/*
 	 * Destroy and then create so that may_start_working() is true
@@ -1693,7 +1696,7 @@ static bool manage_workers(struct worker *worker)
 	ret |= maybe_destroy_workers(pool);
 	ret |= maybe_create_worker(pool);
 
-	gcwq->flags &= ~GCWQ_MANAGING_WORKERS;
+	pool->flags &= ~POOL_MANAGING_WORKERS;
 
 	/*
 	 * The trustee might be waiting to take over the manager
@@ -1872,7 +1875,7 @@ __acquires(&gcwq->lock)
 	 * If HIGHPRI_PENDING, check the next work, and, if HIGHPRI,
 	 * wake up another worker; otherwise, clear HIGHPRI_PENDING.
 	 */
-	if (unlikely(gcwq->flags & GCWQ_HIGHPRI_PENDING)) {
+	if (unlikely(pool->flags & POOL_HIGHPRI_PENDING)) {
 		struct work_struct *nwork = list_first_entry(&pool->worklist,
 					 struct work_struct, entry);
 
@@ -1880,7 +1883,7 @@ __acquires(&gcwq->lock)
 		    get_work_cwq(nwork)->wq->flags & WQ_HIGHPRI)
 			wake_up_worker(pool);
 		else
-			gcwq->flags &= ~GCWQ_HIGHPRI_PENDING;
+			pool->flags &= ~POOL_HIGHPRI_PENDING;
 	}
 
 	/*
@@ -3360,10 +3363,10 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	 * cancelled.
 	 */
 	BUG_ON(gcwq->cpu != smp_processor_id());
-	rc = trustee_wait_event(!(gcwq->flags & GCWQ_MANAGING_WORKERS));
+	rc = trustee_wait_event(!(gcwq->pool.flags & POOL_MANAGING_WORKERS));
 	BUG_ON(rc < 0);
 
-	gcwq->flags |= GCWQ_MANAGING_WORKERS;
+	gcwq->pool.flags |= POOL_MANAGING_WORKERS;
 
 	list_for_each_entry(worker, &gcwq->pool.idle_list, entry)
 		worker->flags |= WORKER_ROGUE;
@@ -3487,7 +3490,7 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	}
 
 	/* relinquish manager role */
-	gcwq->flags &= ~GCWQ_MANAGING_WORKERS;
+	gcwq->pool.flags &= ~POOL_MANAGING_WORKERS;
 
 	/* notify completion */
 	gcwq->trustee = NULL;
@@ -3604,7 +3607,7 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		spin_unlock_irq(&gcwq->lock);
 		kthread_bind(gcwq->pool.first_idle->task, cpu);
 		spin_lock_irq(&gcwq->lock);
-		gcwq->flags |= GCWQ_MANAGE_WORKERS;
+		gcwq->pool.flags |= POOL_MANAGE_WORKERS;
 		start_worker(gcwq->pool.first_idle);
 		gcwq->pool.first_idle = NULL;
 		break;
-- 
1.7.7.3

