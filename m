Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab2GQRNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:13:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53181 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab2GQRMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:12:49 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, peterz@infradead.org, tglx@linutronix.de,
        linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/9] workqueue: remove CPU offline trustee
Date: Tue, 17 Jul 2012 10:12:28 -0700
Message-Id: <1342545149-3515-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1342545149-3515-1-git-send-email-tj@kernel.org>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous changes, a disassociated global_cwq now can run as
an unbound one on its own - it can create workers as necessary to
drain remaining works after the CPU has been brought down and manage
the number of workers using the usual idle timer mechanism making
trustee completely redundant except for the actual unbinding
operation.

This patch removes the trustee and let a disassociated global_cwq
manage itself.  Unbinding is moved to a work item (for CPU affinity)
which is scheduled and flushed from CPU_DONW_PREPARE.

This patch moves nr_running clearing outside gcwq and manager locks to
simplify the code.  As nr_running is unused at the point, this is
safe.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |  288 +++++++---------------------------------------------
 1 files changed, 36 insertions(+), 252 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index acfabb2..d1545da 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -79,13 +79,6 @@ enum {
 	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_REBIND | WORKER_UNBOUND |
 				  WORKER_CPU_INTENSIVE,
 
-	/* gcwq->trustee_state */
-	TRUSTEE_START		= 0,		/* start */
-	TRUSTEE_IN_CHARGE	= 1,		/* trustee in charge of gcwq */
-	TRUSTEE_BUTCHER		= 2,		/* butcher workers */
-	TRUSTEE_RELEASE		= 3,		/* release workers */
-	TRUSTEE_DONE		= 4,		/* trustee is done */
-
 	NR_WORKER_POOLS		= 2,		/* # worker pools per gcwq */
 
 	BUSY_WORKER_HASH_ORDER	= 6,		/* 64 pointers */
@@ -100,7 +93,6 @@ enum {
 						   (min two ticks) */
 	MAYDAY_INTERVAL		= HZ / 10,	/* and then every 100ms */
 	CREATE_COOLDOWN		= HZ,		/* time to breath after fail */
-	TRUSTEE_COOLDOWN	= HZ / 10,	/* for trustee draining */
 
 	/*
 	 * Rescue workers are used only on emergencies and shared by
@@ -194,10 +186,6 @@ struct global_cwq {
 	struct worker_pool	pools[2];	/* normal and highpri pools */
 
 	wait_queue_head_t	rebind_hold;	/* rebind hold wait */
-
-	struct task_struct	*trustee;	/* L: for gcwq shutdown */
-	unsigned int		trustee_state;	/* L: trustee state */
-	wait_queue_head_t	trustee_wait;	/* trustee wait */
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -753,11 +741,11 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 	 * worklist not empty test sequence is in insert_work().
 	 * Please read comment there.
 	 *
-	 * NOT_RUNNING is clear.  This means that trustee is not in
-	 * charge and we're running on the local cpu w/ rq lock held
-	 * and preemption disabled, which in turn means that none else
-	 * could be manipulating idle_list, so dereferencing idle_list
-	 * without gcwq lock is safe.
+	 * NOT_RUNNING is clear.  This means that we're bound to and
+	 * running on the local cpu w/ rq lock held and preemption
+	 * disabled, which in turn means that none else could be
+	 * manipulating idle_list, so dereferencing idle_list without gcwq
+	 * lock is safe.
 	 */
 	if (atomic_dec_and_test(nr_running) && !list_empty(&pool->worklist))
 		to_wakeup = first_worker(pool);
@@ -1217,19 +1205,16 @@ static void worker_enter_idle(struct worker *worker)
 	/* idle_list is LIFO */
 	list_add(&worker->entry, &pool->idle_list);
 
-	if (likely(gcwq->trustee_state != TRUSTEE_DONE)) {
-		if (too_many_workers(pool) && !timer_pending(&pool->idle_timer))
-			mod_timer(&pool->idle_timer,
-				  jiffies + IDLE_WORKER_TIMEOUT);
-	} else
-		wake_up_all(&gcwq->trustee_wait);
+	if (too_many_workers(pool) && !timer_pending(&pool->idle_timer))
+		mod_timer(&pool->idle_timer, jiffies + IDLE_WORKER_TIMEOUT);
 
 	/*
-	 * Sanity check nr_running.  Because trustee releases gcwq->lock
-	 * between setting %WORKER_UNBOUND and zapping nr_running, the
-	 * warning may trigger spuriously.  Check iff trustee is idle.
+	 * Sanity check nr_running.  Because gcwq_unbind_fn() releases
+	 * gcwq->lock between setting %WORKER_UNBOUND and zapping
+	 * nr_running, the warning may trigger spuriously.  Check iff
+	 * unbind is not in progress.
 	 */
-	WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
+	WARN_ON_ONCE(!(gcwq->flags & GCWQ_DISASSOCIATED) &&
 		     pool->nr_workers == pool->nr_idle &&
 		     atomic_read(get_pool_nr_running(pool)));
 }
@@ -3367,46 +3352,9 @@ EXPORT_SYMBOL_GPL(work_busy);
  * gcwqs serve mix of short, long and very long running works making
  * blocked draining impractical.
  *
- * This is solved by allowing a gcwq to be detached from CPU, running it
- * with unbound workers and allowing it to be reattached later if the cpu
- * comes back online.  A separate thread is created to govern a gcwq in
- * such state and is called the trustee of the gcwq.
- *
- * Trustee states and their descriptions.
- *
- * START	Command state used on startup.  On CPU_DOWN_PREPARE, a
- *		new trustee is started with this state.
- *
- * IN_CHARGE	Once started, trustee will enter this state after
- *		assuming the manager role and making all existing
- *		workers rogue.  DOWN_PREPARE waits for trustee to
- *		enter this state.  After reaching IN_CHARGE, trustee
- *		tries to execute the pending worklist until it's empty
- *		and the state is set to BUTCHER, or the state is set
- *		to RELEASE.
- *
- * BUTCHER	Command state which is set by the cpu callback after
- *		the cpu has went down.  Once this state is set trustee
- *		knows that there will be no new works on the worklist
- *		and once the worklist is empty it can proceed to
- *		killing idle workers.
- *
- * RELEASE	Command state which is set by the cpu callback if the
- *		cpu down has been canceled or it has come online
- *		again.  After recognizing this state, trustee stops
- *		trying to drain or butcher and clears ROGUE, rebinds
- *		all remaining workers back to the cpu and releases
- *		manager role.
- *
- * DONE		Trustee will enter this state after BUTCHER or RELEASE
- *		is complete.
- *
- *          trustee                 CPU                draining
- *         took over                down               complete
- * START -----------> IN_CHARGE -----------> BUTCHER -----------> DONE
- *                        |                     |                  ^
- *                        | CPU is back online  v   return workers |
- *                         ----------------> RELEASE --------------
+ * This is solved by allowing a gcwq to be disassociated from the CPU
+ * running as an unbound one and allowing it to be reattached later if the
+ * cpu comes back online.
  */
 
 /* claim manager positions of all pools */
@@ -3427,61 +3375,11 @@ static void gcwq_release_management(struct global_cwq *gcwq)
 		mutex_unlock(&pool->manager_mutex);
 }
 
-/**
- * trustee_wait_event_timeout - timed event wait for trustee
- * @cond: condition to wait for
- * @timeout: timeout in jiffies
- *
- * wait_event_timeout() for trustee to use.  Handles locking and
- * checks for RELEASE request.
- *
- * CONTEXT:
- * spin_lock_irq(gcwq->lock) which may be released and regrabbed
- * multiple times.  To be used by trustee.
- *
- * RETURNS:
- * Positive indicating left time if @cond is satisfied, 0 if timed
- * out, -1 if canceled.
- */
-#define trustee_wait_event_timeout(cond, timeout) ({			\
-	long __ret = (timeout);						\
-	while (!((cond) || (gcwq->trustee_state == TRUSTEE_RELEASE)) &&	\
-	       __ret) {							\
-		spin_unlock_irq(&gcwq->lock);				\
-		__wait_event_timeout(gcwq->trustee_wait, (cond) ||	\
-			(gcwq->trustee_state == TRUSTEE_RELEASE),	\
-			__ret);						\
-		spin_lock_irq(&gcwq->lock);				\
-	}								\
-	gcwq->trustee_state == TRUSTEE_RELEASE ? -1 : (__ret);		\
-})
-
-/**
- * trustee_wait_event - event wait for trustee
- * @cond: condition to wait for
- *
- * wait_event() for trustee to use.  Automatically handles locking and
- * checks for CANCEL request.
- *
- * CONTEXT:
- * spin_lock_irq(gcwq->lock) which may be released and regrabbed
- * multiple times.  To be used by trustee.
- *
- * RETURNS:
- * 0 if @cond is satisfied, -1 if canceled.
- */
-#define trustee_wait_event(cond) ({					\
-	long __ret1;							\
-	__ret1 = trustee_wait_event_timeout(cond, MAX_SCHEDULE_TIMEOUT);\
-	__ret1 < 0 ? -1 : 0;						\
-})
-
-static int __cpuinit trustee_thread(void *__gcwq)
+static void gcwq_unbind_fn(struct work_struct *work)
 {
-	struct global_cwq *gcwq = __gcwq;
+	struct global_cwq *gcwq = get_gcwq(smp_processor_id());
 	struct worker_pool *pool;
 	struct worker *worker;
-	struct work_struct *work;
 	struct hlist_node *pos;
 	int i;
 
@@ -3505,119 +3403,29 @@ static int __cpuinit trustee_thread(void *__gcwq)
 
 	gcwq->flags |= GCWQ_DISASSOCIATED;
 
+	spin_unlock_irq(&gcwq->lock);
+	gcwq_release_management(gcwq);
+
 	/*
 	 * Call schedule() so that we cross rq->lock and thus can guarantee
-	 * sched callbacks see the unbound flag.  This is necessary as
-	 * scheduler callbacks may be invoked from other cpus.
+	 * sched callbacks see the %WORKER_UNBOUND flag.  This is necessary
+	 * as scheduler callbacks may be invoked from other cpus.
 	 */
-	spin_unlock_irq(&gcwq->lock);
 	schedule();
-	spin_lock_irq(&gcwq->lock);
 
 	/*
-	 * Sched callbacks are disabled now.  Zap nr_running.  After
-	 * this, nr_running stays zero and need_more_worker() and
-	 * keep_working() are always true as long as the worklist is
-	 * not empty.
+	 * Sched callbacks are disabled now.  Zap nr_running.  After this,
+	 * nr_running stays zero and need_more_worker() and keep_working()
+	 * are always true as long as the worklist is not empty.  @gcwq now
+	 * behaves as unbound (in terms of concurrency management) gcwq
+	 * which is served by workers tied to the CPU.
+	 *
+	 * On return from this function, the current worker would trigger
+	 * unbound chain execution of pending work items if other workers
+	 * didn't already.
 	 */
 	for_each_worker_pool(pool, gcwq)
 		atomic_set(get_pool_nr_running(pool), 0);
-
-	spin_unlock_irq(&gcwq->lock);
-	for_each_worker_pool(pool, gcwq)
-		del_timer_sync(&pool->idle_timer);
-	spin_lock_irq(&gcwq->lock);
-
-	/*
-	 * We're now in charge.  Notify and proceed to drain.  We need
-	 * to keep the gcwq running during the whole CPU down
-	 * procedure as other cpu hotunplug callbacks may need to
-	 * flush currently running tasks.
-	 */
-	gcwq->trustee_state = TRUSTEE_IN_CHARGE;
-	wake_up_all(&gcwq->trustee_wait);
-
-	/*
-	 * The original cpu is in the process of dying and may go away
-	 * anytime now.  When that happens, we and all workers would
-	 * be migrated to other cpus.  Try draining any left work.  We
-	 * want to get it over with ASAP - spam rescuers, wake up as
-	 * many idlers as necessary and create new ones till the
-	 * worklist is empty.  Note that if the gcwq is frozen, there
-	 * may be frozen works in freezable cwqs.  Don't declare
-	 * completion while frozen.
-	 */
-	while (true) {
-		bool busy = false;
-
-		for_each_worker_pool(pool, gcwq)
-			busy |= pool->nr_workers != pool->nr_idle;
-
-		if (!busy && !(gcwq->flags & GCWQ_FREEZING) &&
-		    gcwq->trustee_state != TRUSTEE_IN_CHARGE)
-			break;
-
-		for_each_worker_pool(pool, gcwq) {
-			int nr_works = 0;
-
-			list_for_each_entry(work, &pool->worklist, entry) {
-				send_mayday(work);
-				nr_works++;
-			}
-
-			list_for_each_entry(worker, &pool->idle_list, entry) {
-				if (!nr_works--)
-					break;
-				wake_up_process(worker->task);
-			}
-
-			if (need_to_create_worker(pool)) {
-				spin_unlock_irq(&gcwq->lock);
-				worker = create_worker(pool);
-				spin_lock_irq(&gcwq->lock);
-				if (worker)
-					start_worker(worker);
-			}
-		}
-
-		/* give a breather */
-		if (trustee_wait_event_timeout(false, TRUSTEE_COOLDOWN) < 0)
-			break;
-	}
-
-	gcwq_release_management(gcwq);
-
-	/* notify completion */
-	gcwq->trustee = NULL;
-	gcwq->trustee_state = TRUSTEE_DONE;
-	wake_up_all(&gcwq->trustee_wait);
-	spin_unlock_irq(&gcwq->lock);
-	return 0;
-}
-
-/**
- * wait_trustee_state - wait for trustee to enter the specified state
- * @gcwq: gcwq the trustee of interest belongs to
- * @state: target state to wait for
- *
- * Wait for the trustee to reach @state.  DONE is already matched.
- *
- * CONTEXT:
- * spin_lock_irq(gcwq->lock) which may be released and regrabbed
- * multiple times.  To be used by cpu_callback.
- */
-static void __cpuinit wait_trustee_state(struct global_cwq *gcwq, int state)
-__releases(&gcwq->lock)
-__acquires(&gcwq->lock)
-{
-	if (!(gcwq->trustee_state == state ||
-	      gcwq->trustee_state == TRUSTEE_DONE)) {
-		spin_unlock_irq(&gcwq->lock);
-		__wait_event(gcwq->trustee_wait,
-			     gcwq->trustee_state == state ||
-			     gcwq->trustee_state == TRUSTEE_DONE);
-		spin_lock_irq(&gcwq->lock);
-	}
 }
 
 static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
@@ -3626,19 +3434,18 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct global_cwq *gcwq = get_gcwq(cpu);
-	struct task_struct *new_trustee = NULL;
 	struct worker_pool *pool;
+	struct work_struct unbind_work;
 	unsigned long flags;
 
 	action &= ~CPU_TASKS_FROZEN;
 
 	switch (action) {
 	case CPU_DOWN_PREPARE:
-		new_trustee = kthread_create(trustee_thread, gcwq,
-					     "workqueue_trustee/%d\n", cpu);
-		if (IS_ERR(new_trustee))
-			return notifier_from_errno(PTR_ERR(new_trustee));
-		kthread_bind(new_trustee, cpu);
+		/* unbinding should happen on the local CPU */
+		INIT_WORK_ONSTACK(&unbind_work, gcwq_unbind_fn);
+		schedule_work_on(cpu, &unbind_work);
+		flush_work(&unbind_work);
 		break;
 
 	case CPU_UP_PREPARE:
@@ -3662,27 +3469,8 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 	spin_lock_irqsave(&gcwq->lock, flags);
 
 	switch (action) {
-	case CPU_DOWN_PREPARE:
-		/* initialize trustee and tell it to acquire the gcwq */
-		BUG_ON(gcwq->trustee || gcwq->trustee_state != TRUSTEE_DONE);
-		gcwq->trustee = new_trustee;
-		gcwq->trustee_state = TRUSTEE_START;
-		wake_up_process(gcwq->trustee);
-		wait_trustee_state(gcwq, TRUSTEE_IN_CHARGE);
-		break;
-
-	case CPU_POST_DEAD:
-		gcwq->trustee_state = TRUSTEE_BUTCHER;
-		break;
-
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		if (gcwq->trustee_state != TRUSTEE_DONE) {
-			gcwq->trustee_state = TRUSTEE_RELEASE;
-			wake_up_process(gcwq->trustee);
-			wait_trustee_state(gcwq, TRUSTEE_DONE);
-		}
-
 		spin_unlock_irq(&gcwq->lock);
 		gcwq_claim_management(gcwq);
 		spin_lock_irq(&gcwq->lock);
@@ -3727,7 +3515,6 @@ static int __devinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
-	case CPU_POST_DEAD:
 		return workqueue_cpu_callback(nfb, action, hcpu);
 	}
 	return NOTIFY_OK;
@@ -3960,9 +3747,6 @@ static int __init init_workqueues(void)
 		}
 
 		init_waitqueue_head(&gcwq->rebind_hold);
-
-		gcwq->trustee_state = TRUSTEE_DONE;
-		init_waitqueue_head(&gcwq->trustee_wait);
 	}
 
 	/* create the initial worker */
-- 
1.7.7.3

