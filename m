Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab0FNVkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:40:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:46952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737Ab0FNVjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:25 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/30] workqueue: misc/cosmetic updates
Date: Mon, 14 Jun 2010 23:37:21 +0200
Message-Id: <1276551467-21246-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the following updates in preparation of concurrency managed
workqueue.  None of these changes causes any visible behavior
difference.

* Add comments and adjust indentations to data structures and several
  functions.

* Rename wq_per_cpu() to get_cwq() and swap the position of two
  parameters for consistency.  Convert a direct per_cpu_ptr() access
  to wq->cpu_wq to get_cwq().

* Add work_static() and Update set_wq_data() such that it sets the
  flags part to WORK_STRUCT_PENDING | WORK_STRUCT_STATIC if static |
  @extra_flags.

* Move santiy check on work->entry emptiness from queue_work_on() to
  __queue_work() which all queueing paths share.

* Make __queue_work() take @cpu and @wq instead of @cwq.

* Restructure flush_work() and __create_workqueue_key() to make them
  easier to modify.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    5 ++
 kernel/workqueue.c        |  131 +++++++++++++++++++++++++++++----------------
 2 files changed, 89 insertions(+), 47 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 0697946..e724daf 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -96,9 +96,14 @@ struct execute_work {
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 extern void __init_work(struct work_struct *work, int onstack);
 extern void destroy_work_on_stack(struct work_struct *work);
+static inline unsigned int work_static(struct work_struct *work)
+{
+	return *work_data_bits(work) & (1 << WORK_STRUCT_STATIC);
+}
 #else
 static inline void __init_work(struct work_struct *work, int onstack) { }
 static inline void destroy_work_on_stack(struct work_struct *work) { }
+static inline unsigned int work_static(struct work_struct *work) { return 0; }
 #endif
 
 /*
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1a47fbf..c56146a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -37,6 +37,16 @@
 #include <trace/events/workqueue.h>
 
 /*
+ * Structure fields follow one of the following exclusion rules.
+ *
+ * I: Set during initialization and read-only afterwards.
+ *
+ * L: cwq->lock protected.  Access with cwq->lock held.
+ *
+ * W: workqueue_lock protected.
+ */
+
+/*
  * The per-CPU workqueue (if single thread, we always use the first
  * possible cpu).
  */
@@ -48,8 +58,8 @@ struct cpu_workqueue_struct {
 	wait_queue_head_t more_work;
 	struct work_struct *current_work;
 
-	struct workqueue_struct *wq;
-	struct task_struct *thread;
+	struct workqueue_struct *wq;		/* I: the owning workqueue */
+	struct task_struct	*thread;
 } ____cacheline_aligned;
 
 /*
@@ -57,13 +67,13 @@ struct cpu_workqueue_struct {
  * per-CPU workqueues:
  */
 struct workqueue_struct {
-	struct cpu_workqueue_struct *cpu_wq;
-	struct list_head list;
-	const char *name;
+	struct cpu_workqueue_struct *cpu_wq;	/* I: cwq's */
+	struct list_head	list;		/* W: list of all workqueues */
+	const char		*name;		/* I: workqueue name */
 	int singlethread;
 	int freezeable;		/* Freeze threads during suspend */
 #ifdef CONFIG_LOCKDEP
-	struct lockdep_map lockdep_map;
+	struct lockdep_map	lockdep_map;
 #endif
 };
 
@@ -204,8 +214,8 @@ static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
 		? cpu_singlethread_map : cpu_populated_map;
 }
 
-static
-struct cpu_workqueue_struct *wq_per_cpu(struct workqueue_struct *wq, int cpu)
+static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
+					    struct workqueue_struct *wq)
 {
 	if (unlikely(is_wq_single_threaded(wq)))
 		cpu = singlethread_cpu;
@@ -217,15 +227,13 @@ struct cpu_workqueue_struct *wq_per_cpu(struct workqueue_struct *wq, int cpu)
  * - Must *only* be called if the pending flag is set
  */
 static inline void set_wq_data(struct work_struct *work,
-				struct cpu_workqueue_struct *cwq)
+			       struct cpu_workqueue_struct *cwq,
+			       unsigned long extra_flags)
 {
-	unsigned long new;
-
 	BUG_ON(!work_pending(work));
 
-	new = (unsigned long) cwq | (1UL << WORK_STRUCT_PENDING);
-	new |= WORK_STRUCT_FLAG_MASK & *work_data_bits(work);
-	atomic_long_set(&work->data, new);
+	atomic_long_set(&work->data, (unsigned long)cwq | work_static(work) |
+			(1UL << WORK_STRUCT_PENDING) | extra_flags);
 }
 
 /*
@@ -233,9 +241,7 @@ static inline void set_wq_data(struct work_struct *work,
  */
 static inline void clear_wq_data(struct work_struct *work)
 {
-	unsigned long flags = *work_data_bits(work) &
-				(1UL << WORK_STRUCT_STATIC);
-	atomic_long_set(&work->data, flags);
+	atomic_long_set(&work->data, work_static(work));
 }
 
 static inline
@@ -244,29 +250,47 @@ struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }
 
+/**
+ * insert_work - insert a work into cwq
+ * @cwq: cwq @work belongs to
+ * @work: work to insert
+ * @head: insertion point
+ * @extra_flags: extra WORK_STRUCT_* flags to set
+ *
+ * Insert @work into @cwq after @head.
+ *
+ * CONTEXT:
+ * spin_lock_irq(cwq->lock).
+ */
 static void insert_work(struct cpu_workqueue_struct *cwq,
-			struct work_struct *work, struct list_head *head)
+			struct work_struct *work, struct list_head *head,
+			unsigned int extra_flags)
 {
 	trace_workqueue_insertion(cwq->thread, work);
 
-	set_wq_data(work, cwq);
+	/* we own @work, set data and link */
+	set_wq_data(work, cwq, extra_flags);
+
 	/*
 	 * Ensure that we get the right work->data if we see the
 	 * result of list_add() below, see try_to_grab_pending().
 	 */
 	smp_wmb();
+
 	list_add_tail(&work->entry, head);
 	wake_up(&cwq->more_work);
 }
 
-static void __queue_work(struct cpu_workqueue_struct *cwq,
+static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
+	struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 	unsigned long flags;
 
 	debug_work_activate(work);
 	spin_lock_irqsave(&cwq->lock, flags);
-	insert_work(cwq, work, &cwq->worklist);
+	BUG_ON(!list_empty(&work->entry));
+	insert_work(cwq, work, &cwq->worklist, 0);
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
 
@@ -308,8 +332,7 @@ queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
 	int ret = 0;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
-		BUG_ON(!list_empty(&work->entry));
-		__queue_work(wq_per_cpu(wq, cpu), work);
+		__queue_work(cpu, wq, work);
 		ret = 1;
 	}
 	return ret;
@@ -320,9 +343,8 @@ static void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
-	struct workqueue_struct *wq = cwq->wq;
 
-	__queue_work(wq_per_cpu(wq, smp_processor_id()), &dwork->work);
+	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
 }
 
 /**
@@ -366,7 +388,7 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 		timer_stats_timer_set_start_info(&dwork->timer);
 
 		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
+		set_wq_data(work, get_cwq(raw_smp_processor_id(), wq), 0);
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -430,6 +452,12 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 	spin_unlock_irq(&cwq->lock);
 }
 
+/**
+ * worker_thread - the worker thread function
+ * @__cwq: cwq to serve
+ *
+ * The cwq worker thread function.
+ */
 static int worker_thread(void *__cwq)
 {
 	struct cpu_workqueue_struct *cwq = __cwq;
@@ -468,6 +496,17 @@ static void wq_barrier_func(struct work_struct *work)
 	complete(&barr->done);
 }
 
+/**
+ * insert_wq_barrier - insert a barrier work
+ * @cwq: cwq to insert barrier into
+ * @barr: wq_barrier to insert
+ * @head: insertion point
+ *
+ * Insert barrier @barr into @cwq before @head.
+ *
+ * CONTEXT:
+ * spin_lock_irq(cwq->lock).
+ */
 static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 			struct wq_barrier *barr, struct list_head *head)
 {
@@ -479,11 +518,10 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 	 */
 	INIT_WORK_ON_STACK(&barr->work, wq_barrier_func);
 	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
-
 	init_completion(&barr->done);
 
 	debug_work_activate(&barr->work);
-	insert_work(cwq, &barr->work, head);
+	insert_work(cwq, &barr->work, head, 0);
 }
 
 static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
@@ -517,9 +555,6 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
  *
  * We sleep until all works which were queued on entry have been handled,
  * but we are not livelocked by new incoming ones.
- *
- * This function used to run the workqueues itself.  Now we just wait for the
- * helper threads to do it.
  */
 void flush_workqueue(struct workqueue_struct *wq)
 {
@@ -558,7 +593,6 @@ int flush_work(struct work_struct *work)
 	lock_map_acquire(&cwq->wq->lockdep_map);
 	lock_map_release(&cwq->wq->lockdep_map);
 
-	prev = NULL;
 	spin_lock_irq(&cwq->lock);
 	if (!list_empty(&work->entry)) {
 		/*
@@ -567,22 +601,22 @@ int flush_work(struct work_struct *work)
 		 */
 		smp_rmb();
 		if (unlikely(cwq != get_wq_data(work)))
-			goto out;
+			goto already_gone;
 		prev = &work->entry;
 	} else {
 		if (cwq->current_work != work)
-			goto out;
+			goto already_gone;
 		prev = &cwq->worklist;
 	}
 	insert_wq_barrier(cwq, &barr, prev->next);
-out:
-	spin_unlock_irq(&cwq->lock);
-	if (!prev)
-		return 0;
 
+	spin_unlock_irq(&cwq->lock);
 	wait_for_completion(&barr.done);
 	destroy_work_on_stack(&barr.work);
 	return 1;
+already_gone:
+	spin_unlock_irq(&cwq->lock);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(flush_work);
 
@@ -665,7 +699,7 @@ static void wait_on_work(struct work_struct *work)
 	cpu_map = wq_cpu_map(wq);
 
 	for_each_cpu(cpu, cpu_map)
-		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+		wait_on_cpu_work(get_cwq(cpu, wq), work);
 }
 
 static int __cancel_work_timer(struct work_struct *work,
@@ -782,9 +816,8 @@ EXPORT_SYMBOL(schedule_delayed_work);
 void flush_delayed_work(struct delayed_work *dwork)
 {
 	if (del_timer_sync(&dwork->timer)) {
-		struct cpu_workqueue_struct *cwq;
-		cwq = wq_per_cpu(get_wq_data(&dwork->work)->wq, get_cpu());
-		__queue_work(cwq, &dwork->work);
+		__queue_work(get_cpu(), get_wq_data(&dwork->work)->wq,
+			     &dwork->work);
 		put_cpu();
 	}
 	flush_work(&dwork->work);
@@ -991,13 +1024,11 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
 	if (!wq)
-		return NULL;
+		goto err;
 
 	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
-	if (!wq->cpu_wq) {
-		kfree(wq);
-		return NULL;
-	}
+	if (!wq->cpu_wq)
+		goto err;
 
 	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
@@ -1041,6 +1072,12 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		wq = NULL;
 	}
 	return wq;
+err:
+	if (wq) {
+		free_percpu(wq->cpu_wq);
+		kfree(wq);
+	}
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
-- 
1.6.4.2

