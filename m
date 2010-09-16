Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab0IPLZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 07:25:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:40135 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab0IPLY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 07:24:26 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, oleg@redhat.com
Cc: dmitry.torokhov@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] workqueue: cleanup flush/cancel functions
Date: Thu, 16 Sep 2010 13:24:05 +0200
Message-Id: <1284636247-4734-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284636247-4734-1-git-send-email-tj@kernel.org>
References: <1284636247-4734-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Sep 2010 11:24:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the following cleanup changes.

* Relocate flush/cancel function prototypes and definitions.

* Relocate wait_on_cpu_work() and wait_on_work() before
  try_to_grab_pending().  These will be used to implement
  flush_work_sync().

* Make all flush/cancel functions return bool instead of int.

* Update wait_on_cpu_work() and wait_on_work() to return %true if they
  actually waited.

* Add / update comments.

This patch doesn't cause any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   18 +++---
 kernel/workqueue.c        |  175 ++++++++++++++++++++++++---------------------
 2 files changed, 103 insertions(+), 90 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 07c4892..bb9b683 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -343,7 +343,6 @@ extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 
 extern void flush_workqueue(struct workqueue_struct *wq);
 extern void flush_scheduled_work(void);
-extern void flush_delayed_work(struct delayed_work *work);
 
 extern int schedule_work(struct work_struct *work);
 extern int schedule_work_on(int cpu, struct work_struct *work);
@@ -355,8 +354,11 @@ extern int keventd_up(void);
 
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
-extern int flush_work(struct work_struct *work);
-extern int cancel_work_sync(struct work_struct *work);
+extern bool flush_work(struct work_struct *work);
+extern bool cancel_work_sync(struct work_struct *work);
+
+extern bool flush_delayed_work(struct delayed_work *dwork);
+extern bool cancel_delayed_work_sync(struct delayed_work *dwork);
 
 extern void workqueue_set_max_active(struct workqueue_struct *wq,
 				     int max_active);
@@ -370,9 +372,9 @@ extern unsigned int work_busy(struct work_struct *work);
  * it returns 1 and the work doesn't re-arm itself. Run flush_workqueue() or
  * cancel_work_sync() to wait on it.
  */
-static inline int cancel_delayed_work(struct delayed_work *work)
+static inline bool cancel_delayed_work(struct delayed_work *work)
 {
-	int ret;
+	bool ret;
 
 	ret = del_timer_sync(&work->timer);
 	if (ret)
@@ -385,9 +387,9 @@ static inline int cancel_delayed_work(struct delayed_work *work)
  * if it returns 0 the timer function may be running and the queueing is in
  * progress.
  */
-static inline int __cancel_delayed_work(struct delayed_work *work)
+static inline bool __cancel_delayed_work(struct delayed_work *work)
 {
-	int ret;
+	bool ret;
 
 	ret = del_timer(&work->timer);
 	if (ret)
@@ -395,8 +397,6 @@ static inline int __cancel_delayed_work(struct delayed_work *work)
 	return ret;
 }
 
-extern int cancel_delayed_work_sync(struct delayed_work *work);
-
 /* Obsolete. use cancel_delayed_work_sync() */
 static inline
 void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f77afd9..1240b9d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2327,16 +2327,24 @@ out_unlock:
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
 /**
- * flush_work - block until a work_struct's callback has terminated
- * @work: the work which is to be flushed
+ * flush_work - wait for a work to finish executing the last queueing instance
+ * @work: the work to flush
  *
- * Returns false if @work has already terminated.
+ * Wait until @work has finished execution.  This function considers
+ * only the last queueing instance of @work.  If @work has been
+ * enqueued across different CPUs on a non-reentrant workqueue or on
+ * multiple workqueues, @work might still be executing on return on
+ * some of the CPUs from earlier queueing.
  *
- * It is expected that, prior to calling flush_work(), the caller has
- * arranged for the work to not be requeued, otherwise it doesn't make
- * sense to use this function.
+ * If @work was queued only on a non-reentrant, ordered or unbound
+ * workqueue, @work is guaranteed to be idle on return if it hasn't
+ * been requeued since flush started.
+ *
+ * RETURNS:
+ * %true if flush_work() waited for the work to finish execution,
+ * %false if it was already idle.
  */
-int flush_work(struct work_struct *work)
+bool flush_work(struct work_struct *work)
 {
 	struct worker *worker = NULL;
 	struct global_cwq *gcwq;
@@ -2374,13 +2382,49 @@ int flush_work(struct work_struct *work)
 
 	wait_for_completion(&barr.done);
 	destroy_work_on_stack(&barr.work);
-	return 1;
+	return true;
 already_gone:
 	spin_unlock_irq(&gcwq->lock);
-	return 0;
+	return false;
 }
 EXPORT_SYMBOL_GPL(flush_work);
 
+static bool wait_on_cpu_work(struct global_cwq *gcwq, struct work_struct *work)
+{
+	struct wq_barrier barr;
+	struct worker *worker;
+
+	spin_lock_irq(&gcwq->lock);
+
+	worker = find_worker_executing_work(gcwq, work);
+	if (unlikely(worker))
+		insert_wq_barrier(worker->current_cwq, &barr, work, worker);
+
+	spin_unlock_irq(&gcwq->lock);
+
+	if (unlikely(worker)) {
+		wait_for_completion(&barr.done);
+		destroy_work_on_stack(&barr.work);
+		return true;
+	} else
+		return false;
+}
+
+static bool wait_on_work(struct work_struct *work)
+{
+	bool ret = false;
+	int cpu;
+
+	might_sleep();
+
+	lock_map_acquire(&work->lockdep_map);
+	lock_map_release(&work->lockdep_map);
+
+	for_each_gcwq_cpu(cpu)
+		ret |= wait_on_cpu_work(get_gcwq(cpu), work);
+	return ret;
+}
+
 /*
  * Upon a successful return (>= 0), the caller "owns" WORK_STRUCT_PENDING bit,
  * so this work can't be re-armed in any way.
@@ -2423,39 +2467,7 @@ static int try_to_grab_pending(struct work_struct *work)
 	return ret;
 }
 
-static void wait_on_cpu_work(struct global_cwq *gcwq, struct work_struct *work)
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
-	}
-}
-
-static void wait_on_work(struct work_struct *work)
-{
-	int cpu;
-
-	might_sleep();
-
-	lock_map_acquire(&work->lockdep_map);
-	lock_map_release(&work->lockdep_map);
-
-	for_each_gcwq_cpu(cpu)
-		wait_on_cpu_work(get_gcwq(cpu), work);
-}
-
-static int __cancel_work_timer(struct work_struct *work,
+static bool __cancel_work_timer(struct work_struct *work,
 				struct timer_list* timer)
 {
 	int ret;
@@ -2472,42 +2484,60 @@ static int __cancel_work_timer(struct work_struct *work,
 }
 
 /**
- * cancel_work_sync - block until a work_struct's callback has terminated
- * @work: the work which is to be flushed
- *
- * Returns true if @work was pending.
+ * cancel_work_sync - cancel a work and wait for it to finish
+ * @work: the work to cancel
  *
- * cancel_work_sync() will cancel the work if it is queued. If the work's
- * callback appears to be running, cancel_work_sync() will block until it
- * has completed.
+ * Cancel @work and wait for its execution to finish.  This function
+ * can be used even if the work re-queues itself or migrates to
+ * another workqueue.  On return from this function, @work is
+ * guaranteed to be not pending or executing on any CPU.
  *
- * It is possible to use this function if the work re-queues itself. It can
- * cancel the work even if it migrates to another workqueue, however in that
- * case it only guarantees that work->func() has completed on the last queued
- * workqueue.
- *
- * cancel_work_sync(&delayed_work->work) should be used only if ->timer is not
- * pending, otherwise it goes into a busy-wait loop until the timer expires.
+ * cancel_work_sync(&delayed_work->work) must not be used for
+ * delayed_work's.  Use cancel_delayed_work_sync() instead.
  *
- * The caller must ensure that workqueue_struct on which this work was last
+ * The caller must ensure that the workqueue on which @work was last
  * queued can't be destroyed before this function returns.
+ *
+ * RETURNS:
+ * %true if @work was pending, %false otherwise.
  */
-int cancel_work_sync(struct work_struct *work)
+bool cancel_work_sync(struct work_struct *work)
 {
 	return __cancel_work_timer(work, NULL);
 }
 EXPORT_SYMBOL_GPL(cancel_work_sync);
 
 /**
- * cancel_delayed_work_sync - reliably kill off a delayed work.
- * @dwork: the delayed work struct
+ * flush_delayed_work - wait for a dwork to finish executing the last queueing
+ * @dwork: the delayed work to flush
+ *
+ * Delayed timer is cancelled and the pending work is queued for
+ * immediate execution.  Like flush_work(), this function only
+ * considers the last queueing instance of @dwork.
+ *
+ * RETURNS:
+ * %true if flush_work() waited for the work to finish execution,
+ * %false if it was already idle.
+ */
+bool flush_delayed_work(struct delayed_work *dwork)
+{
+	if (del_timer_sync(&dwork->timer))
+		__queue_work(raw_smp_processor_id(),
+			     get_work_cwq(&dwork->work)->wq, &dwork->work);
+	return flush_work(&dwork->work);
+}
+EXPORT_SYMBOL(flush_delayed_work);
+
+/**
+ * cancel_delayed_work_sync - cancel a delayed work and wait for it to finish
+ * @dwork: the delayed work cancel
  *
- * Returns true if @dwork was pending.
+ * This is cancel_work_sync() for delayed works.
  *
- * It is possible to use this function if @dwork rearms itself via queue_work()
- * or queue_delayed_work(). See also the comment for cancel_work_sync().
+ * RETURNS:
+ * %true if @dwork was pending, %false otherwise.
  */
-int cancel_delayed_work_sync(struct delayed_work *dwork)
+bool cancel_delayed_work_sync(struct delayed_work *dwork)
 {
 	return __cancel_work_timer(&dwork->work, &dwork->timer);
 }
@@ -2559,23 +2589,6 @@ int schedule_delayed_work(struct delayed_work *dwork,
 EXPORT_SYMBOL(schedule_delayed_work);
 
 /**
- * flush_delayed_work - block until a dwork_struct's callback has terminated
- * @dwork: the delayed work which is to be flushed
- *
- * Any timeout is cancelled, and any pending work is run immediately.
- */
-void flush_delayed_work(struct delayed_work *dwork)
-{
-	if (del_timer_sync(&dwork->timer)) {
-		__queue_work(get_cpu(), get_work_cwq(&dwork->work)->wq,
-			     &dwork->work);
-		put_cpu();
-	}
-	flush_work(&dwork->work);
-}
-EXPORT_SYMBOL(flush_delayed_work);
-
-/**
  * schedule_delayed_work_on - queue work in global workqueue on CPU after delay
  * @cpu: cpu to use
  * @dwork: job to be done
-- 
1.7.1

