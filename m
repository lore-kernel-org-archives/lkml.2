Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab0FNVly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:41:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:46948 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab0FNVjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:23 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>, Anton Blanchard <anton@samba.org>
Subject: [PATCH 21/30] workqueue: carry cpu number in work data once execution starts
Date: Mon, 14 Jun 2010 23:37:38 +0200
Message-Id: <1276551467-21246-22-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To implement non-reentrant workqueue, the last gcwq a work was
executed on must be reliably obtainable as long as the work structure
is valid even if the previous workqueue has been destroyed.

To achieve this, work->data will be overloaded to carry the last cpu
number once execution starts so that the previous gcwq can be located
reliably.  This means that cwq can't be obtained from work after
execution starts but only gcwq.

Implement set_work_{cwq|cpu}(), get_work_[g]cwq() and
clear_work_data() to set work data to the cpu number when starting
execution, access the overloaded work data and clear it after
cancellation.

queue_delayed_work_on() is updated to preserve the last cpu while
in-flight in timer and other callers which depended on getting cwq
from work after execution starts are converted to depend on gcwq
instead.

* Anton Blanchard fixed compile error on powerpc due to missing
  linux/threads.h include.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Anton Blanchard <anton@samba.org>
---
 include/linux/workqueue.h |    7 ++-
 kernel/workqueue.c        |  163 ++++++++++++++++++++++++++++----------------
 2 files changed, 109 insertions(+), 61 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 10611f7..0a78141 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -9,6 +9,7 @@
 #include <linux/linkage.h>
 #include <linux/bitops.h>
 #include <linux/lockdep.h>
+#include <linux/threads.h>
 #include <asm/atomic.h>
 
 struct workqueue_struct;
@@ -59,6 +60,7 @@ enum {
 
 	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
 	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
+	WORK_STRUCT_NO_CPU	= NR_CPUS << WORK_STRUCT_FLAG_BITS,
 };
 
 struct work_struct {
@@ -70,8 +72,9 @@ struct work_struct {
 #endif
 };
 
-#define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
-#define WORK_DATA_STATIC_INIT()	ATOMIC_LONG_INIT(WORK_STRUCT_STATIC)
+#define WORK_DATA_INIT()	ATOMIC_LONG_INIT(WORK_STRUCT_NO_CPU)
+#define WORK_DATA_STATIC_INIT()	\
+	ATOMIC_LONG_INIT(WORK_STRUCT_NO_CPU | WORK_STRUCT_STATIC)
 
 struct delayed_work {
 	struct work_struct work;
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7111683..f606c44 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -319,31 +319,71 @@ static int work_next_color(int color)
 }
 
 /*
- * Set the workqueue on which a work item is to be run
- * - Must *only* be called if the pending flag is set
+ * Work data points to the cwq while a work is on queue.  Once
+ * execution starts, it points to the cpu the work was last on.  This
+ * can be distinguished by comparing the data value against
+ * PAGE_OFFSET.
+ *
+ * set_work_{cwq|cpu}() and clear_work_data() can be used to set the
+ * cwq, cpu or clear work->data.  These functions should only be
+ * called while the work is owned - ie. while the PENDING bit is set.
+ *
+ * get_work_[g]cwq() can be used to obtain the gcwq or cwq
+ * corresponding to a work.  gcwq is available once the work has been
+ * queued anywhere after initialization.  cwq is available only from
+ * queueing until execution starts.
  */
-static inline void set_wq_data(struct work_struct *work,
-			       struct cpu_workqueue_struct *cwq,
-			       unsigned long extra_flags)
+static inline void set_work_data(struct work_struct *work, unsigned long data,
+				 unsigned long flags)
 {
 	BUG_ON(!work_pending(work));
+	atomic_long_set(&work->data, data | flags | work_static(work));
+}
 
-	atomic_long_set(&work->data, (unsigned long)cwq | work_static(work) |
-			WORK_STRUCT_PENDING | extra_flags);
+static void set_work_cwq(struct work_struct *work,
+			 struct cpu_workqueue_struct *cwq,
+			 unsigned long extra_flags)
+{
+	set_work_data(work, (unsigned long)cwq,
+		      WORK_STRUCT_PENDING | extra_flags);
 }
 
-/*
- * Clear WORK_STRUCT_PENDING and the workqueue on which it was queued.
- */
-static inline void clear_wq_data(struct work_struct *work)
+static void set_work_cpu(struct work_struct *work, unsigned int cpu)
+{
+	set_work_data(work, cpu << WORK_STRUCT_FLAG_BITS, WORK_STRUCT_PENDING);
+}
+
+static void clear_work_data(struct work_struct *work)
+{
+	set_work_data(work, WORK_STRUCT_NO_CPU, 0);
+}
+
+static inline unsigned long get_work_data(struct work_struct *work)
+{
+	return atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK;
+}
+
+static struct cpu_workqueue_struct *get_work_cwq(struct work_struct *work)
 {
-	atomic_long_set(&work->data, work_static(work));
+	unsigned long data = get_work_data(work);
+
+	return data >= PAGE_OFFSET ? (void *)data : NULL;
 }
 
-static inline struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
+static struct global_cwq *get_work_gcwq(struct work_struct *work)
 {
-	return (void *)(atomic_long_read(&work->data) &
-			WORK_STRUCT_WQ_DATA_MASK);
+	unsigned long data = get_work_data(work);
+	unsigned int cpu;
+
+	if (data >= PAGE_OFFSET)
+		return ((struct cpu_workqueue_struct *)data)->gcwq;
+
+	cpu = data >> WORK_STRUCT_FLAG_BITS;
+	if (cpu == NR_CPUS)
+		return NULL;
+
+	BUG_ON(cpu >= num_possible_cpus());
+	return get_gcwq(cpu);
 }
 
 /**
@@ -443,7 +483,7 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 			unsigned int extra_flags)
 {
 	/* we own @work, set data and link */
-	set_wq_data(work, cwq, extra_flags);
+	set_work_cwq(work, cwq, extra_flags);
 
 	/*
 	 * Ensure that we get the right work->data if we see the
@@ -599,7 +639,7 @@ EXPORT_SYMBOL_GPL(queue_work_on);
 static void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
-	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
+	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
 
 	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
 }
@@ -639,13 +679,19 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	struct work_struct *work = &dwork->work;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
+		struct global_cwq *gcwq = get_work_gcwq(work);
+		unsigned int lcpu = gcwq ? gcwq->cpu : raw_smp_processor_id();
+
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
 
 		timer_stats_timer_set_start_info(&dwork->timer);
-
-		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work, get_cwq(raw_smp_processor_id(), wq), 0);
+		/*
+		 * This stores cwq for the moment, for the timer_fn.
+		 * Note that the work's gcwq is preserved to allow
+		 * reentrance detection for delayed works.
+		 */
+		set_work_cwq(work, get_cwq(lcpu, wq), 0);
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -970,11 +1016,14 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	worker->current_work = work;
 	worker->current_cwq = cwq;
 	work_color = get_work_color(work);
+
+	BUG_ON(get_work_cwq(work) != cwq);
+	/* record the current cpu number in the work data and dequeue */
+	set_work_cpu(work, gcwq->cpu);
 	list_del_init(&work->entry);
 
 	spin_unlock_irq(&gcwq->lock);
 
-	BUG_ON(get_wq_data(work) != cwq);
 	work_clear_pending(work);
 	lock_map_acquire(&cwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
@@ -1406,37 +1455,39 @@ EXPORT_SYMBOL_GPL(flush_workqueue);
 int flush_work(struct work_struct *work)
 {
 	struct worker *worker = NULL;
-	struct cpu_workqueue_struct *cwq;
 	struct global_cwq *gcwq;
+	struct cpu_workqueue_struct *cwq;
 	struct wq_barrier barr;
 
 	might_sleep();
-	cwq = get_wq_data(work);
-	if (!cwq)
+	gcwq = get_work_gcwq(work);
+	if (!gcwq)
 		return 0;
-	gcwq = cwq->gcwq;
-
-	lock_map_acquire(&cwq->wq->lockdep_map);
-	lock_map_release(&cwq->wq->lockdep_map);
 
 	spin_lock_irq(&gcwq->lock);
 	if (!list_empty(&work->entry)) {
 		/*
 		 * See the comment near try_to_grab_pending()->smp_rmb().
-		 * If it was re-queued under us we are not going to wait.
+		 * If it was re-queued to a different gcwq under us, we
+		 * are not going to wait.
 		 */
 		smp_rmb();
-		if (unlikely(cwq != get_wq_data(work)))
+		cwq = get_work_cwq(work);
+		if (unlikely(!cwq || gcwq != cwq->gcwq))
 			goto already_gone;
 	} else {
-		if (cwq->worker && cwq->worker->current_work == work)
-			worker = cwq->worker;
+		worker = find_worker_executing_work(gcwq, work);
 		if (!worker)
 			goto already_gone;
+		cwq = worker->current_cwq;
 	}
 
 	insert_wq_barrier(cwq, &barr, work, worker);
 	spin_unlock_irq(&gcwq->lock);
+
+	lock_map_acquire(&cwq->wq->lockdep_map);
+	lock_map_release(&cwq->wq->lockdep_map);
+
 	wait_for_completion(&barr.done);
 	destroy_work_on_stack(&barr.work);
 	return 1;
@@ -1453,7 +1504,6 @@ EXPORT_SYMBOL_GPL(flush_work);
 static int try_to_grab_pending(struct work_struct *work)
 {
 	struct global_cwq *gcwq;
-	struct cpu_workqueue_struct *cwq;
 	int ret = -1;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work)))
@@ -1463,24 +1513,23 @@ static int try_to_grab_pending(struct work_struct *work)
 	 * The queueing is in progress, or it is already queued. Try to
 	 * steal it from ->worklist without clearing WORK_STRUCT_PENDING.
 	 */
-
-	cwq = get_wq_data(work);
-	if (!cwq)
+	gcwq = get_work_gcwq(work);
+	if (!gcwq)
 		return ret;
-	gcwq = cwq->gcwq;
 
 	spin_lock_irq(&gcwq->lock);
 	if (!list_empty(&work->entry)) {
 		/*
-		 * This work is queued, but perhaps we locked the wrong cwq.
+		 * This work is queued, but perhaps we locked the wrong gcwq.
 		 * In that case we must see the new value after rmb(), see
 		 * insert_work()->wmb().
 		 */
 		smp_rmb();
-		if (cwq == get_wq_data(work)) {
+		if (gcwq == get_work_gcwq(work)) {
 			debug_work_deactivate(work);
 			list_del_init(&work->entry);
-			cwq_dec_nr_in_flight(cwq, get_work_color(work));
+			cwq_dec_nr_in_flight(get_work_cwq(work),
+					     get_work_color(work));
 			ret = 1;
 		}
 	}
@@ -1489,20 +1538,16 @@ static int try_to_grab_pending(struct work_struct *work)
 	return ret;
 }
 
-static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
-				struct work_struct *work)
+static void wait_on_cpu_work(struct global_cwq *gcwq, struct work_struct *work)
 {
-	struct global_cwq *gcwq = cwq->gcwq;
 	struct wq_barrier barr;
 	struct worker *worker;
 
 	spin_lock_irq(&gcwq->lock);
 
-	worker = NULL;
-	if (unlikely(cwq->worker && cwq->worker->current_work == work)) {
-		worker = cwq->worker;
-		insert_wq_barrier(cwq, &barr, work, worker);
-	}
+	worker = find_worker_executing_work(gcwq, work);
+	if (unlikely(worker))
+		insert_wq_barrier(worker->current_cwq, &barr, work, worker);
 
 	spin_unlock_irq(&gcwq->lock);
 
@@ -1514,8 +1559,6 @@ static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
 
 static void wait_on_work(struct work_struct *work)
 {
-	struct cpu_workqueue_struct *cwq;
-	struct workqueue_struct *wq;
 	int cpu;
 
 	might_sleep();
@@ -1523,14 +1566,8 @@ static void wait_on_work(struct work_struct *work)
 	lock_map_acquire(&work->lockdep_map);
 	lock_map_release(&work->lockdep_map);
 
-	cwq = get_wq_data(work);
-	if (!cwq)
-		return;
-
-	wq = cwq->wq;
-
 	for_each_possible_cpu(cpu)
-		wait_on_cpu_work(get_cwq(cpu, wq), work);
+		wait_on_cpu_work(get_gcwq(cpu), work);
 }
 
 static int __cancel_work_timer(struct work_struct *work,
@@ -1545,7 +1582,7 @@ static int __cancel_work_timer(struct work_struct *work,
 		wait_on_work(work);
 	} while (unlikely(ret < 0));
 
-	clear_wq_data(work);
+	clear_work_data(work);
 	return ret;
 }
 
@@ -1647,7 +1684,7 @@ EXPORT_SYMBOL(schedule_delayed_work);
 void flush_delayed_work(struct delayed_work *dwork)
 {
 	if (del_timer_sync(&dwork->timer)) {
-		__queue_work(get_cpu(), get_wq_data(&dwork->work)->wq,
+		__queue_work(get_cpu(), get_work_cwq(&dwork->work)->wq,
 			     &dwork->work);
 		put_cpu();
 	}
@@ -2407,6 +2444,14 @@ void __init init_workqueues(void)
 	BUILD_BUG_ON(__alignof__(struct cpu_workqueue_struct) <
 		     __alignof__(unsigned long long));
 
+	/*
+	 * The pointer part of work->data is either pointing to the
+	 * cwq or contains the cpu number the work ran last on.  Make
+	 * sure cpu number won't overflow into kernel pointer area so
+	 * that they can be distinguished.
+	 */
+	BUILD_BUG_ON(NR_CPUS << WORK_STRUCT_FLAG_BITS >= PAGE_OFFSET);
+
 	hotcpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);
 
 	/* initialize gcwqs */
-- 
1.6.4.2

