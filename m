Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab2GQRMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:12:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55586 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab2GQRMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:12:45 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, peterz@infradead.org, tglx@linutronix.de,
        linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/9] workqueue: reimplement CPU online rebinding to handle idle workers
Date: Tue, 17 Jul 2012 10:12:26 -0700
Message-Id: <1342545149-3515-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1342545149-3515-1-git-send-email-tj@kernel.org>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if there are left workers when a CPU is being brough back
online, the trustee kills all idle workers and scheduled rebind_work
so that they re-bind to the CPU after the currently executing work is
finished.  This works for busy workers because concurrency management
doesn't try to wake up them from scheduler callbacks, which require
the target task to be on the local run queue.  The busy worker bumps
concurrency counter appropriately as it clears WORKER_UNBOUND from the
rebind work item and it's bound to the CPU before returning to the
idle state.

To reduce CPU on/offlining overhead (as many embedded systems use it
for powersaving) and simplify the code path, workqueue is planned to
be modified to retain idle workers across CPU on/offlining.  This
patch reimplements CPU online rebinding such that it can also handle
idle workers.

As noted earlier, due to the local wakeup requirement, rebinding idle
workers is tricky.  All idle workers must be re-bound before scheduler
callbacks are enabled.  This is achieved by interlocking idle
re-binding.  Idle workers are requested to re-bind and then hold until
all idle re-binding is complete so that no bound worker starts
executing work item.  Only after all idle workers are re-bound and
parked, CPU_ONLINE proceeds to release them and queue rebind work item
to busy workers thus guaranteeing scheduler callbacks aren't invoked
until all idle workers are ready.

worker_rebind_fn() is renamed to busy_worker_rebind_fn() and
idle_worker_rebind() for idle workers is added.  Rebinding logic is
moved to rebind_workers() and now called from CPU_ONLINE after
flushing trustee.  While at it, add CPU sanity check in
worker_thread().

Note that now a worker may become idle or the manager between trustee
release and rebinding during CPU_ONLINE.  As the previous patch
updated create_worker() so that it can be used by regular manager
while unbound and this patch implements idle re-binding, this is safe.

This prepares for removal of trustee and keeping idle workers across
CPU hotplugs.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |  215 ++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 166 insertions(+), 49 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e1d05e5..6927fec 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -133,6 +133,7 @@ enum {
 
 struct global_cwq;
 struct worker_pool;
+struct idle_rebind;
 
 /*
  * The poor guys doing the actual heavy lifting.  All on-duty workers
@@ -154,7 +155,10 @@ struct worker {
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
 	int			id;		/* I: worker id */
-	struct work_struct	rebind_work;	/* L: rebind worker to cpu */
+
+	/* for rebinding worker to CPU */
+	struct idle_rebind	*idle_rebind;	/* L: for idle worker */
+	struct work_struct	rebind_work;	/* L: for busy worker */
 };
 
 struct worker_pool {
@@ -190,6 +194,8 @@ struct global_cwq {
 
 	struct worker_pool	pools[2];	/* normal and highpri pools */
 
+	wait_queue_head_t	rebind_hold;	/* rebind hold wait */
+
 	struct task_struct	*trustee;	/* L: for gcwq shutdown */
 	unsigned int		trustee_state;	/* L: trustee state */
 	wait_queue_head_t	trustee_wait;	/* trustee wait */
@@ -1314,13 +1320,37 @@ __acquires(&gcwq->lock)
 	}
 }
 
+struct idle_rebind {
+	int			cnt;		/* # workers to be rebound */
+	struct completion	done;		/* all workers rebound */
+};
+
+/*
+ * Rebind an idle @worker to its CPU.  During CPU onlining, this has to
+ * happen synchronously for idle workers.  worker_thread() will test
+ * %WORKER_REBIND before leaving idle and call this function.
+ */
+static void idle_worker_rebind(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->pool->gcwq;
+
+	/* CPU must be online at this point */
+	WARN_ON(!worker_maybe_bind_and_lock(worker));
+	if (!--worker->idle_rebind->cnt)
+		complete(&worker->idle_rebind->done);
+	spin_unlock_irq(&worker->pool->gcwq->lock);
+
+	/* we did our part, wait for rebind_workers() to finish up */
+	wait_event(gcwq->rebind_hold, !(worker->flags & WORKER_REBIND));
+}
+
 /*
- * Function for worker->rebind_work used to rebind unbound busy workers to
+ * Function for @worker->rebind.work used to rebind unbound busy workers to
  * the associated cpu which is coming back online.  This is scheduled by
  * cpu up but can race with other cpu hotplug operations and may be
  * executed twice without intervening cpu down.
  */
-static void worker_rebind_fn(struct work_struct *work)
+static void busy_worker_rebind_fn(struct work_struct *work)
 {
 	struct worker *worker = container_of(work, struct worker, rebind_work);
 	struct global_cwq *gcwq = worker->pool->gcwq;
@@ -1331,6 +1361,112 @@ static void worker_rebind_fn(struct work_struct *work)
 	spin_unlock_irq(&gcwq->lock);
 }
 
+/**
+ * rebind_workers - rebind all workers of a gcwq to the associated CPU
+ * @gcwq: gcwq of interest
+ *
+ * @gcwq->cpu is coming online.  Rebind all workers to the CPU.  Rebinding
+ * is different for idle and busy ones.
+ *
+ * The idle ones should be rebound synchronously and idle rebinding should
+ * be complete before any worker starts executing work items with
+ * concurrency management enabled; otherwise, scheduler may oops trying to
+ * wake up non-local idle worker from wq_worker_sleeping().
+ *
+ * This is achieved by repeatedly requesting rebinding until all idle
+ * workers are known to have been rebound under @gcwq->lock and holding all
+ * idle workers from becoming busy until idle rebinding is complete.
+ *
+ * Once idle workers are rebound, busy workers can be rebound as they
+ * finish executing their current work items.  Queueing the rebind work at
+ * the head of their scheduled lists is enough.  Note that nr_running will
+ * be properbly bumped as busy workers rebind.
+ *
+ * On return, all workers are guaranteed to either be bound or have rebind
+ * work item scheduled.
+ */
+static void rebind_workers(struct global_cwq *gcwq)
+	__releases(&gcwq->lock) __acquires(&gcwq->lock)
+{
+	struct idle_rebind idle_rebind;
+	struct worker_pool *pool;
+	struct worker *worker;
+	struct hlist_node *pos;
+	int i;
+
+	lockdep_assert_held(&gcwq->lock);
+
+	for_each_worker_pool(pool, gcwq)
+		lockdep_assert_held(&pool->manager_mutex);
+
+	/*
+	 * Rebind idle workers.  Interlocked both ways.  We wait for
+	 * workers to rebind via @idle_rebind.done.  Workers will wait for
+	 * us to finish up by watching %WORKER_REBIND.
+	 */
+	init_completion(&idle_rebind.done);
+retry:
+	idle_rebind.cnt = 1;
+	INIT_COMPLETION(idle_rebind.done);
+
+	/* set REBIND and kick idle ones, we'll wait for these later */
+	for_each_worker_pool(pool, gcwq) {
+		list_for_each_entry(worker, &pool->idle_list, entry) {
+			if (worker->flags & WORKER_REBIND)
+				continue;
+
+			/* morph UNBOUND to REBIND */
+			worker->flags &= ~WORKER_UNBOUND;
+			worker->flags |= WORKER_REBIND;
+
+			idle_rebind.cnt++;
+			worker->idle_rebind = &idle_rebind;
+
+			/* worker_thread() will call idle_worker_rebind() */
+			wake_up_process(worker->task);
+		}
+	}
+
+	if (--idle_rebind.cnt) {
+		spin_unlock_irq(&gcwq->lock);
+		wait_for_completion(&idle_rebind.done);
+		spin_lock_irq(&gcwq->lock);
+		/* busy ones might have become idle while waiting, retry */
+		goto retry;
+	}
+
+	/*
+	 * All idle workers are rebound and waiting for %WORKER_REBIND to
+	 * be cleared inside idle_worker_rebind().  Clear and release.
+	 * Clearing %WORKER_REBIND from this foreign context is safe
+	 * because these workers are still guaranteed to be idle.
+	 */
+	for_each_worker_pool(pool, gcwq)
+		list_for_each_entry(worker, &pool->idle_list, entry)
+			worker->flags &= ~WORKER_REBIND;
+
+	wake_up_all(&gcwq->rebind_hold);
+
+	/* rebind busy workers */
+	for_each_busy_worker(worker, i, pos, gcwq) {
+		struct work_struct *rebind_work = &worker->rebind_work;
+
+		/* morph UNBOUND to REBIND */
+		worker->flags &= ~WORKER_UNBOUND;
+		worker->flags |= WORKER_REBIND;
+
+		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
+				     work_data_bits(rebind_work)))
+			continue;
+
+		/* wq doesn't matter, use the default one */
+		debug_work_activate(rebind_work);
+		insert_work(get_cwq(gcwq->cpu, system_wq), rebind_work,
+			    worker->scheduled.next,
+			    work_color_to_flags(WORK_NO_COLOR));
+	}
+}
+
 static struct worker *alloc_worker(void)
 {
 	struct worker *worker;
@@ -1339,7 +1475,7 @@ static struct worker *alloc_worker(void)
 	if (worker) {
 		INIT_LIST_HEAD(&worker->entry);
 		INIT_LIST_HEAD(&worker->scheduled);
-		INIT_WORK(&worker->rebind_work, worker_rebind_fn);
+		INIT_WORK(&worker->rebind_work, busy_worker_rebind_fn);
 		/* on creation a worker is in !idle && prep state */
 		worker->flags = WORKER_PREP;
 	}
@@ -1829,6 +1965,9 @@ __acquires(&gcwq->lock)
 
 	lockdep_copy_map(&lockdep_map, &work->lockdep_map);
 #endif
+	WARN_ON_ONCE(!(worker->flags & (WORKER_UNBOUND | WORKER_REBIND)) &&
+		     raw_smp_processor_id() != gcwq->cpu);
+
 	/*
 	 * A single work shouldn't be executed concurrently by
 	 * multiple workers on a single cpu.  Check whether anyone is
@@ -1946,11 +2085,20 @@ static int worker_thread(void *__worker)
 woke_up:
 	spin_lock_irq(&gcwq->lock);
 
-	/* DIE can be set only while we're idle, checking here is enough */
-	if (worker->flags & WORKER_DIE) {
+	/*
+	 * DIE can be set only while idle and REBIND set while busy has
+	 * @worker->rebind_work scheduled.  Checking here is enough.
+	 */
+	if (unlikely(worker->flags & (WORKER_REBIND | WORKER_DIE))) {
 		spin_unlock_irq(&gcwq->lock);
-		worker->task->flags &= ~PF_WQ_WORKER;
-		return 0;
+
+		if (worker->flags & WORKER_DIE) {
+			worker->task->flags &= ~PF_WQ_WORKER;
+			return 0;
+		}
+
+		idle_worker_rebind(worker);
+		goto woke_up;
 	}
 
 	worker_leave_idle(worker);
@@ -3468,42 +3616,6 @@ static int __cpuinit trustee_thread(void *__gcwq)
 		}
 	} while (i && rc >= 0);
 
-	/*
-	 * At this point, either draining has completed and no worker
-	 * is left, or cpu down has been canceled or the cpu is being
-	 * brought back up.  There shouldn't be any idle one left.
-	 * Tell the remaining busy ones to rebind once it finishes the
-	 * currently scheduled works by scheduling the rebind_work.
-	 */
-	for_each_worker_pool(pool, gcwq)
-		WARN_ON(!list_empty(&pool->idle_list));
-
-	/* if we're reassociating, clear DISASSOCIATED */
-	if (gcwq->trustee_state == TRUSTEE_RELEASE)
-		gcwq->flags &= ~GCWQ_DISASSOCIATED;
-
-	for_each_busy_worker(worker, i, pos, gcwq) {
-		struct work_struct *rebind_work = &worker->rebind_work;
-
-		/*
-		 * Rebind_work may race with future cpu hotplug
-		 * operations.  Use a separate flag to mark that
-		 * rebinding is scheduled.
-		 */
-		worker->flags |= WORKER_REBIND;
-		worker->flags &= ~WORKER_UNBOUND;
-
-		/* queue rebind_work, wq doesn't matter, use the default one */
-		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
-				     work_data_bits(rebind_work)))
-			continue;
-
-		debug_work_activate(rebind_work);
-		insert_work(get_cwq(gcwq->cpu, system_wq), rebind_work,
-			    worker->scheduled.next,
-			    work_color_to_flags(WORK_NO_COLOR));
-	}
-
 	gcwq_release_management(gcwq);
 
 	/* notify completion */
@@ -3609,13 +3721,16 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 			wait_trustee_state(gcwq, TRUSTEE_DONE);
 		}
 
-		/*
-		 * Either DISASSOCIATED is already cleared or no worker is
-		 * left on the gcwq.  Safe to clear DISASSOCIATED without
-		 * claiming managers.
-		 */
+		spin_unlock_irq(&gcwq->lock);
+		gcwq_claim_management(gcwq);
+		spin_lock_irq(&gcwq->lock);
+
 		gcwq->flags &= ~GCWQ_DISASSOCIATED;
 
+		rebind_workers(gcwq);
+
+		gcwq_release_management(gcwq);
+
 		/*
 		 * Trustee is done and there might be no worker left.
 		 * Put the first_idle in and request a real manager to
@@ -3910,6 +4025,8 @@ static int __init init_workqueues(void)
 			ida_init(&pool->worker_ida);
 		}
 
+		init_waitqueue_head(&gcwq->rebind_hold);
+
 		gcwq->trustee_state = TRUSTEE_DONE;
 		init_waitqueue_head(&gcwq->trustee_wait);
 	}
-- 
1.7.7.3

