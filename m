Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab2GQROL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:14:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53181 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2GQRMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:12:44 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, peterz@infradead.org, tglx@linutronix.de,
        linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/9] workqueue: drop @bind from create_worker()
Date: Tue, 17 Jul 2012 10:12:25 -0700
Message-Id: <1342545149-3515-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1342545149-3515-1-git-send-email-tj@kernel.org>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, create_worker()'s callers are responsible for deciding
whether the newly created worker should be bound to the associated CPU
and create_worker() sets WORKER_UNBOUND only for the workers for the
unbound global_cwq.  Creation during normal operation is always via
maybe_create_worker() and @bind is true.  For workers created during
hotplug, @bind is false.

Normal operation path is planned to be used even while the CPU is
going through hotplug operations or offline and this static decision
won't work.

Drop @bind from create_worker() and decide whether to bind by looking
at GCWQ_DISASSOCIATED.  create_worker() will also set WORKER_UNBOUND
autmatically if disassociated.  To avoid flipping GCWQ_DISASSOCIATED
while create_worker() is in progress, the flag is now allowed to be
changed only while holding all manager_mutexes on the global_cwq.

This requires that GCWQ_DISASSOCIATED is not cleared behind trustee's
back.  CPU_ONLINE no longer clears DISASSOCIATED before flushing
trustee, which clears DISASSOCIATED before rebinding remaining workers
if asked to release.  For cases where trustee isn't around, CPU_ONLINE
clears DISASSOCIATED after flushing trustee.  Also, now, first_idle
has UNBOUND set on creation which is explicitly cleared by CPU_ONLINE
while binding it.  These convolutions will soon be removed by further
simplification of CPU hotplug path.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   64 ++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f7a0069..e1d05e5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -45,7 +45,22 @@
 #include "workqueue_sched.h"
 
 enum {
-	/* global_cwq flags */
+	/*
+	 * global_cwq flags
+	 *
+	 * A bound gcwq is either associated or disassociated with its CPU.
+	 * While associated (!DISASSOCIATED), all workers are bound to the
+	 * CPU and none has %WORKER_UNBOUND set and concurrency management
+	 * is in effect.
+	 *
+	 * While DISASSOCIATED, the cpu may be offline and all workers have
+	 * %WORKER_UNBOUND set and concurrency management disabled, and may
+	 * be executing on any CPU.  The gcwq behaves as an unbound one.
+	 *
+	 * Note that DISASSOCIATED can be flipped only while holding
+	 * managership of all pools on the gcwq to avoid changing binding
+	 * state while create_worker() is in progress.
+	 */
 	GCWQ_DISASSOCIATED	= 1 << 0,	/* cpu can't serve workers */
 	GCWQ_FREEZING		= 1 << 1,	/* freeze in progress */
 
@@ -1334,7 +1349,6 @@ static struct worker *alloc_worker(void)
 /**
  * create_worker - create a new workqueue worker
  * @pool: pool the new worker will belong to
- * @bind: whether to set affinity to @cpu or not
  *
  * Create a new worker which is bound to @pool.  The returned worker
  * can be started by calling start_worker() or destroyed using
@@ -1346,10 +1360,9 @@ static struct worker *alloc_worker(void)
  * RETURNS:
  * Pointer to the newly created worker.
  */
-static struct worker *create_worker(struct worker_pool *pool, bool bind)
+static struct worker *create_worker(struct worker_pool *pool)
 {
 	struct global_cwq *gcwq = pool->gcwq;
-	bool on_unbound_cpu = gcwq->cpu == WORK_CPU_UNBOUND;
 	const char *pri = worker_pool_pri(pool) ? "H" : "";
 	struct worker *worker = NULL;
 	int id = -1;
@@ -1370,7 +1383,7 @@ static struct worker *create_worker(struct worker_pool *pool, bool bind)
 	worker->pool = pool;
 	worker->id = id;
 
-	if (!on_unbound_cpu)
+	if (gcwq->cpu != WORK_CPU_UNBOUND)
 		worker->task = kthread_create_on_node(worker_thread,
 					worker, cpu_to_node(gcwq->cpu),
 					"kworker/%u:%d%s", gcwq->cpu, id, pri);
@@ -1384,15 +1397,19 @@ static struct worker *create_worker(struct worker_pool *pool, bool bind)
 		set_user_nice(worker->task, HIGHPRI_NICE_LEVEL);
 
 	/*
-	 * An unbound worker will become a regular one if CPU comes online
-	 * later on.  Make sure every worker has PF_THREAD_BOUND set.
+	 * Determine CPU binding of the new worker depending on
+	 * %GCWQ_DISASSOCIATED.  The caller is responsible for ensuring the
+	 * flag remains stable across this function.  See the comments
+	 * above the flag definition for details.
+	 *
+	 * As an unbound worker may later become a regular one if CPU comes
+	 * online, make sure every worker has %PF_THREAD_BOUND set.
 	 */
-	if (bind && !on_unbound_cpu)
+	if (!(gcwq->flags & GCWQ_DISASSOCIATED)) {
 		kthread_bind(worker->task, gcwq->cpu);
-	else {
+	} else {
 		worker->task->flags |= PF_THREAD_BOUND;
-		if (on_unbound_cpu)
-			worker->flags |= WORKER_UNBOUND;
+		worker->flags |= WORKER_UNBOUND;
 	}
 
 	return worker;
@@ -1568,7 +1585,7 @@ restart:
 	while (true) {
 		struct worker *worker;
 
-		worker = create_worker(pool, true);
+		worker = create_worker(pool);
 		if (worker) {
 			del_timer_sync(&pool->mayday_timer);
 			spin_lock_irq(&gcwq->lock);
@@ -3420,12 +3437,10 @@ static int __cpuinit trustee_thread(void *__gcwq)
 
 			if (need_to_create_worker(pool)) {
 				spin_unlock_irq(&gcwq->lock);
-				worker = create_worker(pool, false);
+				worker = create_worker(pool);
 				spin_lock_irq(&gcwq->lock);
-				if (worker) {
-					worker->flags |= WORKER_UNBOUND;
+				if (worker)
 					start_worker(worker);
-				}
 			}
 		}
 
@@ -3463,6 +3478,10 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	for_each_worker_pool(pool, gcwq)
 		WARN_ON(!list_empty(&pool->idle_list));
 
+	/* if we're reassociating, clear DISASSOCIATED */
+	if (gcwq->trustee_state == TRUSTEE_RELEASE)
+		gcwq->flags &= ~GCWQ_DISASSOCIATED;
+
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
 
@@ -3546,7 +3565,7 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		i = 0;
 		for_each_worker_pool(pool, gcwq) {
 			BUG_ON(pool->first_idle);
-			new_workers[i] = create_worker(pool, false);
+			new_workers[i] = create_worker(pool);
 			if (!new_workers[i++])
 				goto err_destroy;
 		}
@@ -3584,7 +3603,6 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		gcwq->flags &= ~GCWQ_DISASSOCIATED;
 		if (gcwq->trustee_state != TRUSTEE_DONE) {
 			gcwq->trustee_state = TRUSTEE_RELEASE;
 			wake_up_process(gcwq->trustee);
@@ -3592,6 +3610,13 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		}
 
 		/*
+		 * Either DISASSOCIATED is already cleared or no worker is
+		 * left on the gcwq.  Safe to clear DISASSOCIATED without
+		 * claiming managers.
+		 */
+		gcwq->flags &= ~GCWQ_DISASSOCIATED;
+
+		/*
 		 * Trustee is done and there might be no worker left.
 		 * Put the first_idle in and request a real manager to
 		 * take a look.
@@ -3601,6 +3626,7 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 			kthread_bind(pool->first_idle->task, cpu);
 			spin_lock_irq(&gcwq->lock);
 			pool->flags |= POOL_MANAGE_WORKERS;
+			pool->first_idle->flags &= ~WORKER_UNBOUND;
 			start_worker(pool->first_idle);
 			pool->first_idle = NULL;
 		}
@@ -3899,7 +3925,7 @@ static int __init init_workqueues(void)
 		for_each_worker_pool(pool, gcwq) {
 			struct worker *worker;
 
-			worker = create_worker(pool, true);
+			worker = create_worker(pool);
 			BUG_ON(!worker);
 			spin_lock_irq(&gcwq->lock);
 			start_worker(worker);
-- 
1.7.7.3

