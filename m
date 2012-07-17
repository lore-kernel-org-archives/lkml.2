Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2GQROu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:14:50 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52408 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab2GQRMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:12:41 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, peterz@infradead.org, tglx@linutronix.de,
        linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/9] workqueue: ROGUE workers are UNBOUND workers
Date: Tue, 17 Jul 2012 10:12:23 -0700
Message-Id: <1342545149-3515-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1342545149-3515-1-git-send-email-tj@kernel.org>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, WORKER_UNBOUND is used to mark workers for the unbound
global_cwq and WORKER_ROGUE is used to mark workers for disassociated
per-cpu global_cwqs.  Both are used to make the marked worker skip
concurrency management and the only place they make any difference is
in worker_enter_idle() where WORKER_ROGUE is used to skip scheduling
idle timer, which can easily be replaced with trustee state testing.

This patch replaces WORKER_ROGUE with WORKER_UNBOUND and drops
WORKER_ROGUE.  This is to prepare for removing trustee and handling
disassociated global_cwqs as unbound.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   46 +++++++++++++++++++++-------------------------
 1 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1405fb9..af51292 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -58,13 +58,12 @@ enum {
 	WORKER_DIE		= 1 << 1,	/* die die die */
 	WORKER_IDLE		= 1 << 2,	/* is idle */
 	WORKER_PREP		= 1 << 3,	/* preparing to run works */
-	WORKER_ROGUE		= 1 << 4,	/* not bound to any cpu */
 	WORKER_REBIND		= 1 << 5,	/* mom is home, come back */
 	WORKER_CPU_INTENSIVE	= 1 << 6,	/* cpu intensive */
 	WORKER_UNBOUND		= 1 << 7,	/* worker is unbound */
 
-	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_ROGUE | WORKER_REBIND |
-				  WORKER_CPU_INTENSIVE | WORKER_UNBOUND,
+	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_REBIND | WORKER_UNBOUND |
+				  WORKER_CPU_INTENSIVE,
 
 	/* gcwq->trustee_state */
 	TRUSTEE_START		= 0,		/* start */
@@ -1198,7 +1197,7 @@ static void worker_enter_idle(struct worker *worker)
 	/* idle_list is LIFO */
 	list_add(&worker->entry, &pool->idle_list);
 
-	if (likely(!(worker->flags & WORKER_ROGUE))) {
+	if (likely(gcwq->trustee_state != TRUSTEE_DONE)) {
 		if (too_many_workers(pool) && !timer_pending(&pool->idle_timer))
 			mod_timer(&pool->idle_timer,
 				  jiffies + IDLE_WORKER_TIMEOUT);
@@ -1207,7 +1206,7 @@ static void worker_enter_idle(struct worker *worker)
 
 	/*
 	 * Sanity check nr_running.  Because trustee releases gcwq->lock
-	 * between setting %WORKER_ROGUE and zapping nr_running, the
+	 * between setting %WORKER_UNBOUND and zapping nr_running, the
 	 * warning may trigger spuriously.  Check iff trustee is idle.
 	 */
 	WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
@@ -1301,10 +1300,10 @@ __acquires(&gcwq->lock)
 }
 
 /*
- * Function for worker->rebind_work used to rebind rogue busy workers
- * to the associated cpu which is coming back online.  This is
- * scheduled by cpu up but can race with other cpu hotplug operations
- * and may be executed twice without intervening cpu down.
+ * Function for worker->rebind_work used to rebind unbound busy workers to
+ * the associated cpu which is coming back online.  This is scheduled by
+ * cpu up but can race with other cpu hotplug operations and may be
+ * executed twice without intervening cpu down.
  */
 static void worker_rebind_fn(struct work_struct *work)
 {
@@ -1385,9 +1384,8 @@ static struct worker *create_worker(struct worker_pool *pool, bool bind)
 		set_user_nice(worker->task, HIGHPRI_NICE_LEVEL);
 
 	/*
-	 * A rogue worker will become a regular one if CPU comes
-	 * online later on.  Make sure every worker has
-	 * PF_THREAD_BOUND set.
+	 * An unbound worker will become a regular one if CPU comes online
+	 * later on.  Make sure every worker has PF_THREAD_BOUND set.
 	 */
 	if (bind && !on_unbound_cpu)
 		kthread_bind(worker->task, gcwq->cpu);
@@ -3215,11 +3213,10 @@ EXPORT_SYMBOL_GPL(work_busy);
  * gcwqs serve mix of short, long and very long running works making
  * blocked draining impractical.
  *
- * This is solved by allowing a gcwq to be detached from CPU, running
- * it with unbound (rogue) workers and allowing it to be reattached
- * later if the cpu comes back online.  A separate thread is created
- * to govern a gcwq in such state and is called the trustee of the
- * gcwq.
+ * This is solved by allowing a gcwq to be detached from CPU, running it
+ * with unbound workers and allowing it to be reattached later if the cpu
+ * comes back online.  A separate thread is created to govern a gcwq in
+ * such state and is called the trustee of the gcwq.
  *
  * Trustee states and their descriptions.
  *
@@ -3359,19 +3356,18 @@ static int __cpuinit trustee_thread(void *__gcwq)
 		pool->flags |= POOL_MANAGING_WORKERS;
 
 		list_for_each_entry(worker, &pool->idle_list, entry)
-			worker->flags |= WORKER_ROGUE;
+			worker->flags |= WORKER_UNBOUND;
 	}
 
 	for_each_busy_worker(worker, i, pos, gcwq)
-		worker->flags |= WORKER_ROGUE;
+		worker->flags |= WORKER_UNBOUND;
 
 	gcwq->flags |= GCWQ_DISASSOCIATED;
 
 	/*
-	 * Call schedule() so that we cross rq->lock and thus can
-	 * guarantee sched callbacks see the rogue flag.  This is
-	 * necessary as scheduler callbacks may be invoked from other
-	 * cpus.
+	 * Call schedule() so that we cross rq->lock and thus can guarantee
+	 * sched callbacks see the unbound flag.  This is necessary as
+	 * scheduler callbacks may be invoked from other cpus.
 	 */
 	spin_unlock_irq(&gcwq->lock);
 	schedule();
@@ -3439,7 +3435,7 @@ static int __cpuinit trustee_thread(void *__gcwq)
 				worker = create_worker(pool, false);
 				spin_lock_irq(&gcwq->lock);
 				if (worker) {
-					worker->flags |= WORKER_ROGUE;
+					worker->flags |= WORKER_UNBOUND;
 					start_worker(worker);
 				}
 			}
@@ -3488,7 +3484,7 @@ static int __cpuinit trustee_thread(void *__gcwq)
 		 * rebinding is scheduled.
 		 */
 		worker->flags |= WORKER_REBIND;
-		worker->flags &= ~WORKER_ROGUE;
+		worker->flags &= ~WORKER_UNBOUND;
 
 		/* queue rebind_work, wq doesn't matter, use the default one */
 		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
-- 
1.7.7.3

