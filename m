Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab2GQROe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:14:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55586 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab2GQRMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:12:42 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, peterz@infradead.org, tglx@linutronix.de,
        linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/9] workqueue: use mutex for global_cwq manager exclusion
Date: Tue, 17 Jul 2012 10:12:24 -0700
Message-Id: <1342545149-3515-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1342545149-3515-1-git-send-email-tj@kernel.org>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

POOL_MANAGING_WORKERS is used to ensure that at most one worker takes
the manager role at any given time on a given global_cwq.  Trustee
later hitched on it to assume manager adding blocking wait for the
bit.  As trustee already needed a custom wait mechanism, waiting for
MANAGING_WORKERS was rolled into the same mechanism.

Trustee is scheduled to be removed.  This patch separates out
MANAGING_WORKERS wait into per-pool mutex.  Workers use
mutex_trylock() to test for manager role and trustee uses mutex_lock()
to claim manager roles.

gcwq_claim/release_management() helpers are added to grab and release
manager roles of all pools on a global_cwq.  gcwq_claim_management()
always grabs pool manager mutexes in ascending pool index order and
uses pool index as lockdep subclass.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   65 ++++++++++++++++++++-------------------------------
 1 files changed, 26 insertions(+), 39 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index af51292..f7a0069 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -51,7 +51,6 @@ enum {
 
 	/* pool flags */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
-	POOL_MANAGING_WORKERS	= 1 << 1,	/* managing workers */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -155,6 +154,7 @@ struct worker_pool {
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
 	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
 
+	struct mutex		manager_mutex;	/* mutex manager should hold */
 	struct ida		worker_ida;	/* L: for worker IDs */
 	struct worker		*first_idle;	/* L: first idle worker */
 };
@@ -644,7 +644,7 @@ static bool need_to_manage_workers(struct worker_pool *pool)
 /* Do we have too many workers and should some go away? */
 static bool too_many_workers(struct worker_pool *pool)
 {
-	bool managing = pool->flags & POOL_MANAGING_WORKERS;
+	bool managing = mutex_is_locked(&pool->manager_mutex);
 	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
 	int nr_busy = pool->nr_workers - nr_idle;
 
@@ -1655,14 +1655,12 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
 static bool manage_workers(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
-	struct global_cwq *gcwq = pool->gcwq;
 	bool ret = false;
 
-	if (pool->flags & POOL_MANAGING_WORKERS)
+	if (!mutex_trylock(&pool->manager_mutex))
 		return ret;
 
 	pool->flags &= ~POOL_MANAGE_WORKERS;
-	pool->flags |= POOL_MANAGING_WORKERS;
 
 	/*
 	 * Destroy and then create so that may_start_working() is true
@@ -1671,15 +1669,7 @@ static bool manage_workers(struct worker *worker)
 	ret |= maybe_destroy_workers(pool);
 	ret |= maybe_create_worker(pool);
 
-	pool->flags &= ~POOL_MANAGING_WORKERS;
-
-	/*
-	 * The trustee might be waiting to take over the manager
-	 * position, tell it we're done.
-	 */
-	if (unlikely(gcwq->trustee))
-		wake_up_all(&gcwq->trustee_wait);
-
+	mutex_unlock(&pool->manager_mutex);
 	return ret;
 }
 
@@ -3255,6 +3245,24 @@ EXPORT_SYMBOL_GPL(work_busy);
  *                         ----------------> RELEASE --------------
  */
 
+/* claim manager positions of all pools */
+static void gcwq_claim_management(struct global_cwq *gcwq)
+{
+	struct worker_pool *pool;
+
+	for_each_worker_pool(pool, gcwq)
+		mutex_lock_nested(&pool->manager_mutex, pool - gcwq->pools);
+}
+
+/* release manager positions */
+static void gcwq_release_management(struct global_cwq *gcwq)
+{
+	struct worker_pool *pool;
+
+	for_each_worker_pool(pool, gcwq)
+		mutex_unlock(&pool->manager_mutex);
+}
+
 /**
  * trustee_wait_event_timeout - timed event wait for trustee
  * @cond: condition to wait for
@@ -3304,16 +3312,6 @@ EXPORT_SYMBOL_GPL(work_busy);
 	__ret1 < 0 ? -1 : 0;						\
 })
 
-static bool gcwq_is_managing_workers(struct global_cwq *gcwq)
-{
-	struct worker_pool *pool;
-
-	for_each_worker_pool(pool, gcwq)
-		if (pool->flags & POOL_MANAGING_WORKERS)
-			return true;
-	return false;
-}
-
 static bool gcwq_has_idle_workers(struct global_cwq *gcwq)
 {
 	struct worker_pool *pool;
@@ -3336,15 +3334,8 @@ static int __cpuinit trustee_thread(void *__gcwq)
 
 	BUG_ON(gcwq->cpu != smp_processor_id());
 
+	gcwq_claim_management(gcwq);
 	spin_lock_irq(&gcwq->lock);
-	/*
-	 * Claim the manager position and make all workers rogue.
-	 * Trustee must be bound to the target cpu and can't be
-	 * cancelled.
-	 */
-	BUG_ON(gcwq->cpu != smp_processor_id());
-	rc = trustee_wait_event(!gcwq_is_managing_workers(gcwq));
-	BUG_ON(rc < 0);
 
 	/*
 	 * We've claimed all manager positions.  Make all workers unbound
@@ -3352,12 +3343,9 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	 * ones which are still executing works from before the last CPU
 	 * down must be on the cpu.  After this, they may become diasporas.
 	 */
-	for_each_worker_pool(pool, gcwq) {
-		pool->flags |= POOL_MANAGING_WORKERS;
-
+	for_each_worker_pool(pool, gcwq)
 		list_for_each_entry(worker, &pool->idle_list, entry)
 			worker->flags |= WORKER_UNBOUND;
-	}
 
 	for_each_busy_worker(worker, i, pos, gcwq)
 		worker->flags |= WORKER_UNBOUND;
@@ -3497,9 +3485,7 @@ static int __cpuinit trustee_thread(void *__gcwq)
 			    work_color_to_flags(WORK_NO_COLOR));
 	}
 
-	/* relinquish manager role */
-	for_each_worker_pool(pool, gcwq)
-		pool->flags &= ~POOL_MANAGING_WORKERS;
+	gcwq_release_management(gcwq);
 
 	/* notify completion */
 	gcwq->trustee = NULL;
@@ -3894,6 +3880,7 @@ static int __init init_workqueues(void)
 			setup_timer(&pool->mayday_timer, gcwq_mayday_timeout,
 				    (unsigned long)pool);
 
+			mutex_init(&pool->manager_mutex);
 			ida_init(&pool->worker_ida);
 		}
 
-- 
1.7.7.3

