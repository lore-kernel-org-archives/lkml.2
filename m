Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2HNBuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:50:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49110 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab2HNBt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:49:57 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@redhat.com,
        lauro.venancio@openbossa.org, jak@jak-linux.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] workqueue: gut flush[_delayed]_work_sync()
Date: Mon, 13 Aug 2012 18:49:42 -0700
Message-Id: <1344908986-18152-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344908986-18152-1-git-send-email-tj@kernel.org>
References: <1344908986-18152-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all workqueues are non-reentrant, flush[_delayed]_work_sync()
are equivalent to flush[_delayed]_work().  Drop the separate
implementation and make them thin wrappers around
flush[_delayed]_work().

* start_flush_work() no longer takes @wait_executing as the only left
  user - flush_work() - always sets it to %true.

* __cancel_work_timer() uses flush_work() instead of wait_on_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   14 +++++-
 kernel/workqueue.c        |  122 ++++-----------------------------------------
 2 files changed, 22 insertions(+), 114 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 6cd8f91..b2716b6 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -412,11 +412,9 @@ extern int keventd_up(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
 extern bool flush_work(struct work_struct *work);
-extern bool flush_work_sync(struct work_struct *work);
 extern bool cancel_work_sync(struct work_struct *work);
 
 extern bool flush_delayed_work(struct delayed_work *dwork);
-extern bool flush_delayed_work_sync(struct delayed_work *work);
 extern bool cancel_delayed_work(struct delayed_work *dwork);
 extern bool cancel_delayed_work_sync(struct delayed_work *dwork);
 
@@ -441,6 +439,18 @@ static inline bool __deprecated __cancel_delayed_work(struct delayed_work *work)
 	return ret;
 }
 
+/* used to be different but now identical to flush_work(), deprecated */
+static inline bool flush_work_sync(struct work_struct *work)
+{
+	return flush_work(work);
+}
+
+/* used to be different but now identical to flush_delayed_work(), deprecated */
+static inline bool flush_delayed_work_sync(struct delayed_work *dwork)
+{
+	return flush_delayed_work(dwork);
+}
+
 #ifndef CONFIG_SMP
 static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 26f048b..938adc0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2780,8 +2780,7 @@ reflush:
 }
 EXPORT_SYMBOL_GPL(drain_workqueue);
 
-static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
-			     bool wait_executing)
+static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 {
 	struct worker *worker = NULL;
 	struct global_cwq *gcwq;
@@ -2803,13 +2802,12 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 		cwq = get_work_cwq(work);
 		if (unlikely(!cwq || gcwq != cwq->pool->gcwq))
 			goto already_gone;
-	} else if (wait_executing) {
+	} else {
 		worker = find_worker_executing_work(gcwq, work);
 		if (!worker)
 			goto already_gone;
 		cwq = worker->current_cwq;
-	} else
-		goto already_gone;
+	}
 
 	insert_wq_barrier(cwq, barr, work, worker);
 	spin_unlock_irq(&gcwq->lock);
@@ -2836,15 +2834,8 @@ already_gone:
  * flush_work - wait for a work to finish executing the last queueing instance
  * @work: the work to flush
  *
- * Wait until @work has finished execution.  This function considers
- * only the last queueing instance of @work.  If @work has been
- * enqueued across different CPUs on a non-reentrant workqueue or on
- * multiple workqueues, @work might still be executing on return on
- * some of the CPUs from earlier queueing.
- *
- * If @work was queued only on a non-reentrant, ordered or unbound
- * workqueue, @work is guaranteed to be idle on return if it hasn't
- * been requeued since flush started.
+ * Wait until @work has finished execution.  @work is guaranteed to be idle
+ * on return if it hasn't been requeued since flush started.
  *
  * RETURNS:
  * %true if flush_work() waited for the work to finish execution,
@@ -2857,85 +2848,15 @@ bool flush_work(struct work_struct *work)
 	lock_map_acquire(&work->lockdep_map);
 	lock_map_release(&work->lockdep_map);
 
-	if (start_flush_work(work, &barr, true)) {
+	if (start_flush_work(work, &barr)) {
 		wait_for_completion(&barr.done);
 		destroy_work_on_stack(&barr.work);
 		return true;
-	} else
-		return false;
-}
-EXPORT_SYMBOL_GPL(flush_work);
-
-static bool wait_on_cpu_work(struct global_cwq *gcwq, struct work_struct *work)
-{
-	struct wq_barrier barr;
-	struct worker *worker;
-
-	spin_lock_irq(&gcwq->lock);
-
-	worker = find_worker_executing_work(gcwq, work);
-	if (unlikely(worker))
-		insert_wq_barrier(worker->current_cwq, &barr, work, worker);
-
-	spin_unlock_irq(&gcwq->lock);
-
-	if (unlikely(worker)) {
-		wait_for_completion(&barr.done);
-		destroy_work_on_stack(&barr.work);
-		return true;
-	} else
+	} else {
 		return false;
-}
-
-static bool wait_on_work(struct work_struct *work)
-{
-	bool ret = false;
-	int cpu;
-
-	might_sleep();
-
-	lock_map_acquire(&work->lockdep_map);
-	lock_map_release(&work->lockdep_map);
-
-	for_each_gcwq_cpu(cpu)
-		ret |= wait_on_cpu_work(get_gcwq(cpu), work);
-	return ret;
-}
-
-/**
- * flush_work_sync - wait until a work has finished execution
- * @work: the work to flush
- *
- * Wait until @work has finished execution.  On return, it's
- * guaranteed that all queueing instances of @work which happened
- * before this function is called are finished.  In other words, if
- * @work hasn't been requeued since this function was called, @work is
- * guaranteed to be idle on return.
- *
- * RETURNS:
- * %true if flush_work_sync() waited for the work to finish execution,
- * %false if it was already idle.
- */
-bool flush_work_sync(struct work_struct *work)
-{
-	struct wq_barrier barr;
-	bool pending, waited;
-
-	/* we'll wait for executions separately, queue barr only if pending */
-	pending = start_flush_work(work, &barr, false);
-
-	/* wait for executions to finish */
-	waited = wait_on_work(work);
-
-	/* wait for the pending one */
-	if (pending) {
-		wait_for_completion(&barr.done);
-		destroy_work_on_stack(&barr.work);
 	}
-
-	return pending || waited;
 }
-EXPORT_SYMBOL_GPL(flush_work_sync);
+EXPORT_SYMBOL_GPL(flush_work);
 
 static bool __cancel_work_timer(struct work_struct *work, bool is_dwork)
 {
@@ -2949,14 +2870,14 @@ static bool __cancel_work_timer(struct work_struct *work, bool is_dwork)
 		 * would be waiting for before retrying.
 		 */
 		if (unlikely(ret == -ENOENT))
-			wait_on_work(work);
+			flush_work(work);
 	} while (unlikely(ret < 0));
 
 	/* tell other tasks trying to grab @work to back off */
 	mark_work_canceling(work);
 	local_irq_restore(flags);
 
-	wait_on_work(work);
+	flush_work(work);
 	clear_work_data(work);
 	return ret;
 }
@@ -3009,29 +2930,6 @@ bool flush_delayed_work(struct delayed_work *dwork)
 EXPORT_SYMBOL(flush_delayed_work);
 
 /**
- * flush_delayed_work_sync - wait for a dwork to finish
- * @dwork: the delayed work to flush
- *
- * Delayed timer is cancelled and the pending work is queued for
- * execution immediately.  Other than timer handling, its behavior
- * is identical to flush_work_sync().
- *
- * RETURNS:
- * %true if flush_work_sync() waited for the work to finish execution,
- * %false if it was already idle.
- */
-bool flush_delayed_work_sync(struct delayed_work *dwork)
-{
-	local_irq_disable();
-	if (del_timer_sync(&dwork->timer))
-		__queue_work(dwork->cpu,
-			     get_work_cwq(&dwork->work)->wq, &dwork->work);
-	local_irq_enable();
-	return flush_work_sync(&dwork->work);
-}
-EXPORT_SYMBOL(flush_delayed_work_sync);
-
-/**
  * cancel_delayed_work - cancel a delayed work
  * @dwork: delayed_work to cancel
  *
-- 
1.7.7.3

