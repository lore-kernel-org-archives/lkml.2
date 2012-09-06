Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777Ab2IFUJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:09:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51926 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759239Ab2IFUJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:09:53 -0400
Date: Thu, 6 Sep 2012 13:09:48 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH wq/for-3.7] workqueue: move gcwq_associate() under CPU
 hotplug section
Message-ID: <20120906200948.GJ29092@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f3b57042feab077e340da166f0a0329793e94a16 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 6 Sep 2012 12:59:59 -0700

gcwq_associate() is now more involved with CPU hotplug and its current
location requires forward declarations of
gcwq_claim/release_management().  Move it under CPU hotplug section
and remove the prototypes.

This patch is pure relocation.  Nothing else changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
This patch is applied after pulling in wq/for-3.6-fixes into
wq/for-3.7.

Thanks.

 kernel/workqueue.c |  296 ++++++++++++++++++++++++++--------------------------
 1 files changed, 147 insertions(+), 149 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3787d31..f12b9bc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -479,8 +479,6 @@ static atomic_t unbound_pool_nr_running[NR_WORKER_POOLS] = {
 };
 
 static int worker_thread(void *__worker);
-static void gcwq_claim_management(struct global_cwq *gcwq);
-static void gcwq_release_management(struct global_cwq *gcwq);
 
 static int worker_pool_pri(struct worker_pool *pool)
 {
@@ -1662,153 +1660,6 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 	spin_unlock_irq(&gcwq->lock);
 }
 
-/**
- * gcwq_associate - (re)associate a gcwq to its CPU and rebind its workers
- * @gcwq: gcwq of interest
- *
- * @gcwq->cpu is coming online.  Clear %GCWQ_DISASSOCIATED and rebind all
- * workers to the CPU.  Rebinding is different for idle and busy ones.
- *
- * The idle ones should be rebound synchronously and idle rebinding should
- * be complete before any worker starts executing work items with
- * concurrency management enabled; otherwise, scheduler may oops trying to
- * wake up non-local idle worker from wq_worker_sleeping().
- *
- * This is achieved by repeatedly requesting rebinding until all idle
- * workers are known to have been rebound under @gcwq->lock and holding all
- * idle workers from becoming busy until idle rebinding is complete.
- *
- * Once idle workers are rebound, busy workers can be rebound as they
- * finish executing their current work items.  Queueing the rebind work at
- * the head of their scheduled lists is enough.  Note that nr_running will
- * be properbly bumped as busy workers rebind.
- *
- * On return, all workers are guaranteed to either be bound or have rebind
- * work item scheduled.
- */
-static void gcwq_associate(struct global_cwq *gcwq)
-{
-	struct idle_rebind idle_rebind;
-	struct worker_pool *pool;
-	struct worker *worker;
-	struct hlist_node *pos;
-	int i;
-
-	gcwq_claim_management(gcwq);
-	spin_lock_irq(&gcwq->lock);
-
-	gcwq->flags &= ~GCWQ_DISASSOCIATED;
-
-	/*
-	 * Rebind idle workers.  Interlocked both ways.  We wait for
-	 * workers to rebind via @idle_rebind.done.  Workers will wait for
-	 * us to finish up by watching %WORKER_REBIND.
-	 */
-	init_completion(&idle_rebind.done);
-retry:
-	idle_rebind.cnt = 1;
-	INIT_COMPLETION(idle_rebind.done);
-
-	/* set REBIND and kick idle ones, we'll wait for these later */
-	for_each_worker_pool(pool, gcwq) {
-		list_for_each_entry(worker, &pool->idle_list, entry) {
-			unsigned long worker_flags = worker->flags;
-
-			if (worker->flags & WORKER_REBIND)
-				continue;
-
-			/* morph UNBOUND to REBIND atomically */
-			worker_flags &= ~WORKER_UNBOUND;
-			worker_flags |= WORKER_REBIND;
-			ACCESS_ONCE(worker->flags) = worker_flags;
-
-			idle_rebind.cnt++;
-			worker->idle_rebind = &idle_rebind;
-
-			/* worker_thread() will call idle_worker_rebind() */
-			wake_up_process(worker->task);
-		}
-	}
-
-	if (--idle_rebind.cnt) {
-		spin_unlock_irq(&gcwq->lock);
-		wait_for_completion(&idle_rebind.done);
-		spin_lock_irq(&gcwq->lock);
-		/* busy ones might have become idle while waiting, retry */
-		goto retry;
-	}
-
-	/* all idle workers are rebound, rebind busy workers */
-	for_each_busy_worker(worker, i, pos, gcwq) {
-		unsigned long worker_flags = worker->flags;
-		struct work_struct *rebind_work = &worker->rebind_work;
-		struct workqueue_struct *wq;
-
-		/* morph UNBOUND to REBIND atomically */
-		worker_flags &= ~WORKER_UNBOUND;
-		worker_flags |= WORKER_REBIND;
-		ACCESS_ONCE(worker->flags) = worker_flags;
-
-		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
-				     work_data_bits(rebind_work)))
-			continue;
-
-		debug_work_activate(rebind_work);
-
-		/*
-		 * wq doesn't really matter but let's keep @worker->pool
-		 * and @cwq->pool consistent for sanity.
-		 */
-		if (worker_pool_pri(worker->pool))
-			wq = system_highpri_wq;
-		else
-			wq = system_wq;
-
-		insert_work(get_cwq(gcwq->cpu, wq), rebind_work,
-			worker->scheduled.next,
-			work_color_to_flags(WORK_NO_COLOR));
-	}
-
-	/*
-	 * At this point, each pool is guaranteed to have at least one idle
-	 * worker and all idle workers are waiting for WORKER_REBIND to
-	 * clear.  Release management before releasing idle workers;
-	 * otherwise, they can all go become busy as we're holding the
-	 * manager_mutexes, which can lead to deadlock as we don't actually
-	 * create new workers.
-	 */
-	gcwq_release_management(gcwq);
-
-	/*
-	 * Clear %WORKER_REBIND and release.  Clearing it from this foreign
-	 * context is safe because these workers are still guaranteed to be
-	 * idle.
-	 *
-	 * We need to make sure all idle workers passed WORKER_REBIND wait
-	 * in idle_worker_rebind() before returning; otherwise, workers can
-	 * get stuck at the wait if hotplug cycle repeats.
-	 */
-	idle_rebind.cnt = 1;
-	INIT_COMPLETION(idle_rebind.done);
-
-	for_each_worker_pool(pool, gcwq) {
-		WARN_ON_ONCE(list_empty(&pool->idle_list));
-		list_for_each_entry(worker, &pool->idle_list, entry) {
-			worker->flags &= ~WORKER_REBIND;
-			idle_rebind.cnt++;
-		}
-	}
-
-	wake_up_all(&gcwq->rebind_hold);
-
-	if (--idle_rebind.cnt) {
-		spin_unlock_irq(&gcwq->lock);
-		wait_for_completion(&idle_rebind.done);
-	} else {
-		spin_unlock_irq(&gcwq->lock);
-	}
-}
-
 static struct worker *alloc_worker(void)
 {
 	struct worker *worker;
@@ -3537,6 +3388,153 @@ static void gcwq_release_management(struct global_cwq *gcwq)
 		mutex_unlock(&pool->manager_mutex);
 }
 
+/**
+ * gcwq_associate - (re)associate a gcwq to its CPU and rebind its workers
+ * @gcwq: gcwq of interest
+ *
+ * @gcwq->cpu is coming online.  Clear %GCWQ_DISASSOCIATED and rebind all
+ * workers to the CPU.  Rebinding is different for idle and busy ones.
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
+static void gcwq_associate(struct global_cwq *gcwq)
+{
+	struct idle_rebind idle_rebind;
+	struct worker_pool *pool;
+	struct worker *worker;
+	struct hlist_node *pos;
+	int i;
+
+	gcwq_claim_management(gcwq);
+	spin_lock_irq(&gcwq->lock);
+
+	gcwq->flags &= ~GCWQ_DISASSOCIATED;
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
+			unsigned long worker_flags = worker->flags;
+
+			if (worker->flags & WORKER_REBIND)
+				continue;
+
+			/* morph UNBOUND to REBIND atomically */
+			worker_flags &= ~WORKER_UNBOUND;
+			worker_flags |= WORKER_REBIND;
+			ACCESS_ONCE(worker->flags) = worker_flags;
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
+	/* all idle workers are rebound, rebind busy workers */
+	for_each_busy_worker(worker, i, pos, gcwq) {
+		unsigned long worker_flags = worker->flags;
+		struct work_struct *rebind_work = &worker->rebind_work;
+		struct workqueue_struct *wq;
+
+		/* morph UNBOUND to REBIND atomically */
+		worker_flags &= ~WORKER_UNBOUND;
+		worker_flags |= WORKER_REBIND;
+		ACCESS_ONCE(worker->flags) = worker_flags;
+
+		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
+				     work_data_bits(rebind_work)))
+			continue;
+
+		debug_work_activate(rebind_work);
+
+		/*
+		 * wq doesn't really matter but let's keep @worker->pool
+		 * and @cwq->pool consistent for sanity.
+		 */
+		if (worker_pool_pri(worker->pool))
+			wq = system_highpri_wq;
+		else
+			wq = system_wq;
+
+		insert_work(get_cwq(gcwq->cpu, wq), rebind_work,
+			worker->scheduled.next,
+			work_color_to_flags(WORK_NO_COLOR));
+	}
+
+	/*
+	 * At this point, each pool is guaranteed to have at least one idle
+	 * worker and all idle workers are waiting for WORKER_REBIND to
+	 * clear.  Release management before releasing idle workers;
+	 * otherwise, they can all go become busy as we're holding the
+	 * manager_mutexes, which can lead to deadlock as we don't actually
+	 * create new workers.
+	 */
+	gcwq_release_management(gcwq);
+
+	/*
+	 * Clear %WORKER_REBIND and release.  Clearing it from this foreign
+	 * context is safe because these workers are still guaranteed to be
+	 * idle.
+	 *
+	 * We need to make sure all idle workers passed WORKER_REBIND wait
+	 * in idle_worker_rebind() before returning; otherwise, workers can
+	 * get stuck at the wait if hotplug cycle repeats.
+	 */
+	idle_rebind.cnt = 1;
+	INIT_COMPLETION(idle_rebind.done);
+
+	for_each_worker_pool(pool, gcwq) {
+		WARN_ON_ONCE(list_empty(&pool->idle_list));
+		list_for_each_entry(worker, &pool->idle_list, entry) {
+			worker->flags &= ~WORKER_REBIND;
+			idle_rebind.cnt++;
+		}
+	}
+
+	wake_up_all(&gcwq->rebind_hold);
+
+	if (--idle_rebind.cnt) {
+		spin_unlock_irq(&gcwq->lock);
+		wait_for_completion(&idle_rebind.done);
+	} else {
+		spin_unlock_irq(&gcwq->lock);
+	}
+}
+
 static void gcwq_unbind_fn(struct work_struct *work)
 {
 	struct global_cwq *gcwq = get_gcwq(smp_processor_id());
-- 
1.7.7.3

