Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab0FNVpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:45:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:46908 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab0FNVjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:16 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 19/30] workqueue: make single thread workqueue shared worker pool friendly
Date: Mon, 14 Jun 2010 23:37:36 +0200
Message-Id: <1276551467-21246-20-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reimplement st (single thread) workqueue so that it's friendly to
shared worker pool.  It was originally implemented by confining st
workqueues to use cwq of a fixed cpu and always having a worker for
the cpu.  This implementation isn't very friendly to shared worker
pool and suboptimal in that it ends up crossing cpu boundaries often.

Reimplement st workqueue using dynamic single cpu binding and
cwq->limit.  WQ_SINGLE_THREAD is replaced with WQ_SINGLE_CPU.  In a
single cpu workqueue, at most single cwq is bound to the wq at any
given time.  Arbitration is done using atomic accesses to
wq->single_cpu when queueing a work.  Once bound, the binding stays
till the workqueue is drained.

Note that the binding is never broken while a workqueue is frozen.
This is because idle cwqs may have works waiting in delayed_works
queue while frozen.  On thaw, the cwq is restarted if there are any
delayed works or unbound otherwise.

When combined with max_active limit of 1, single cpu workqueue has
exactly the same execution properties as the original single thread
workqueue while allowing sharing of per-cpu workers.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    6 +-
 kernel/workqueue.c        |  135 +++++++++++++++++++++++++++++++++------------
 2 files changed, 103 insertions(+), 38 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index ab0b7fb..10611f7 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -221,7 +221,7 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 
 enum {
 	WQ_FREEZEABLE		= 1 << 0, /* freeze during suspend */
-	WQ_SINGLE_THREAD	= 1 << 1, /* no per-cpu worker */
+	WQ_SINGLE_CPU		= 1 << 1, /* only single cpu at a time */
 };
 
 extern struct workqueue_struct *
@@ -250,9 +250,9 @@ __create_workqueue_key(const char *name, unsigned int flags, int max_active,
 #define create_workqueue(name)					\
 	__create_workqueue((name), 0, 1)
 #define create_freezeable_workqueue(name)			\
-	__create_workqueue((name), WQ_FREEZEABLE | WQ_SINGLE_THREAD, 1)
+	__create_workqueue((name), WQ_FREEZEABLE | WQ_SINGLE_CPU, 1)
 #define create_singlethread_workqueue(name)			\
-	__create_workqueue((name), WQ_SINGLE_THREAD, 1)
+	__create_workqueue((name), WQ_SINGLE_CPU, 1)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5cd155d..2ce895e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -114,8 +114,7 @@ struct global_cwq {
 } ____cacheline_aligned_in_smp;
 
 /*
- * The per-CPU workqueue (if single thread, we always use the first
- * possible cpu).  The lower WORK_STRUCT_FLAG_BITS of
+ * The per-CPU workqueue.  The lower WORK_STRUCT_FLAG_BITS of
  * work_struct->data are used for flags and thus cwqs need to be
  * aligned at two's power of the number of flag bits.
  */
@@ -159,6 +158,8 @@ struct workqueue_struct {
 	struct list_head	flusher_queue;	/* F: flush waiters */
 	struct list_head	flusher_overflow; /* F: flush overflow list */
 
+	unsigned long		single_cpu;	/* cpu for single cpu wq */
+
 	int			saved_max_active; /* I: saved cwq max_active */
 	const char		*name;		/* I: workqueue name */
 #ifdef CONFIG_LOCKDEP
@@ -289,8 +290,6 @@ static DEFINE_PER_CPU(struct global_cwq, global_cwq);
 
 static int worker_thread(void *__worker);
 
-static int singlethread_cpu __read_mostly;
-
 static struct global_cwq *get_gcwq(unsigned int cpu)
 {
 	return &per_cpu(global_cwq, cpu);
@@ -302,14 +301,6 @@ static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
 	return per_cpu_ptr(wq->cpu_wq, cpu);
 }
 
-static struct cpu_workqueue_struct *target_cwq(unsigned int cpu,
-					       struct workqueue_struct *wq)
-{
-	if (unlikely(wq->flags & WQ_SINGLE_THREAD))
-		cpu = singlethread_cpu;
-	return get_cwq(cpu, wq);
-}
-
 static unsigned int work_color_to_flags(int color)
 {
 	return color << WORK_STRUCT_COLOR_SHIFT;
@@ -410,17 +401,87 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 	wake_up_process(cwq->worker->task);
 }
 
+/**
+ * cwq_unbind_single_cpu - unbind cwq from single cpu workqueue processing
+ * @cwq: cwq to unbind
+ *
+ * Try to unbind @cwq from single cpu workqueue processing.  If
+ * @cwq->wq is frozen, unbind is delayed till the workqueue is thawed.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ */
+static void cwq_unbind_single_cpu(struct cpu_workqueue_struct *cwq)
+{
+	struct workqueue_struct *wq = cwq->wq;
+	struct global_cwq *gcwq = cwq->gcwq;
+
+	BUG_ON(wq->single_cpu != gcwq->cpu);
+	/*
+	 * Unbind from workqueue if @cwq is not frozen.  If frozen,
+	 * thaw_workqueues() will either restart processing on this
+	 * cpu or unbind if empty.  This keeps works queued while
+	 * frozen fully ordered and flushable.
+	 */
+	if (likely(!(gcwq->flags & GCWQ_FREEZING))) {
+		smp_wmb();	/* paired with cmpxchg() in __queue_work() */
+		wq->single_cpu = NR_CPUS;
+	}
+}
+
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
-	struct cpu_workqueue_struct *cwq = target_cwq(cpu, wq);
-	struct global_cwq *gcwq = cwq->gcwq;
+	struct global_cwq *gcwq;
+	struct cpu_workqueue_struct *cwq;
 	struct list_head *worklist;
 	unsigned long flags;
+	bool arbitrate;
 
 	debug_work_activate(work);
 
-	spin_lock_irqsave(&gcwq->lock, flags);
+	/* determine gcwq to use */
+	if (!(wq->flags & WQ_SINGLE_CPU)) {
+		/* just use the requested cpu for multicpu workqueues */
+		gcwq = get_gcwq(cpu);
+		spin_lock_irqsave(&gcwq->lock, flags);
+	} else {
+		unsigned int req_cpu = cpu;
+
+		/*
+		 * It's a bit more complex for single cpu workqueues.
+		 * We first need to determine which cpu is going to be
+		 * used.  If no cpu is currently serving this
+		 * workqueue, arbitrate using atomic accesses to
+		 * wq->single_cpu; otherwise, use the current one.
+		 */
+	retry:
+		cpu = wq->single_cpu;
+		arbitrate = cpu == NR_CPUS;
+		if (arbitrate)
+			cpu = req_cpu;
+
+		gcwq = get_gcwq(cpu);
+		spin_lock_irqsave(&gcwq->lock, flags);
+
+		/*
+		 * The following cmpxchg() is a full barrier paired
+		 * with smp_wmb() in cwq_unbind_single_cpu() and
+		 * guarantees that all changes to wq->st_* fields are
+		 * visible on the new cpu after this point.
+		 */
+		if (arbitrate)
+			cmpxchg(&wq->single_cpu, NR_CPUS, cpu);
+
+		if (unlikely(wq->single_cpu != cpu)) {
+			spin_unlock_irqrestore(&gcwq->lock, flags);
+			goto retry;
+		}
+	}
+
+	/* gcwq determined, get cwq and queue */
+	cwq = get_cwq(gcwq->cpu, wq);
+
 	BUG_ON(!list_empty(&work->entry));
 
 	cwq->nr_in_flight[cwq->work_color]++;
@@ -530,7 +591,7 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 		timer_stats_timer_set_start_info(&dwork->timer);
 
 		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work, target_cwq(raw_smp_processor_id(), wq), 0);
+		set_wq_data(work, get_cwq(raw_smp_processor_id(), wq), 0);
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -790,10 +851,14 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
 	cwq->nr_in_flight[color]--;
 	cwq->nr_active--;
 
-	/* one down, submit a delayed one */
-	if (!list_empty(&cwq->delayed_works) &&
-	    cwq->nr_active < cwq->max_active)
-		cwq_activate_first_delayed(cwq);
+	if (!list_empty(&cwq->delayed_works)) {
+		/* one down, submit a delayed one */
+		if (cwq->nr_active < cwq->max_active)
+			cwq_activate_first_delayed(cwq);
+	} else if (!cwq->nr_active && cwq->wq->flags & WQ_SINGLE_CPU) {
+		/* this was the last work, unbind from single cpu */
+		cwq_unbind_single_cpu(cwq);
+	}
 
 	/* is flush in progress and are we at the flushing tip? */
 	if (likely(cwq->flush_color != color))
@@ -1721,7 +1786,6 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 						struct lock_class_key *key,
 						const char *lock_name)
 {
-	bool singlethread = flags & WQ_SINGLE_THREAD;
 	struct workqueue_struct *wq;
 	bool failed = false;
 	unsigned int cpu;
@@ -1742,6 +1806,8 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	atomic_set(&wq->nr_cwqs_to_flush, 0);
 	INIT_LIST_HEAD(&wq->flusher_queue);
 	INIT_LIST_HEAD(&wq->flusher_overflow);
+	wq->single_cpu = NR_CPUS;
+
 	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
@@ -1767,8 +1833,7 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 
 		if (failed)
 			continue;
-		cwq->worker = create_worker(cwq,
-					    cpu_online(cpu) && !singlethread);
+		cwq->worker = create_worker(cwq, cpu_online(cpu));
 		if (cwq->worker)
 			start_worker(cwq->worker);
 		else
@@ -1952,18 +2017,16 @@ static int __cpuinit trustee_thread(void *__gcwq)
 
 	spin_lock_irq(&gcwq->lock);
 	/*
-	 * Make all multithread workers rogue.  Trustee must be bound
-	 * to the target cpu and can't be cancelled.
+	 * Make all workers rogue.  Trustee must be bound to the
+	 * target cpu and can't be cancelled.
 	 */
 	BUG_ON(gcwq->cpu != smp_processor_id());
 
 	list_for_each_entry(worker, &gcwq->idle_list, entry)
-		if (!(worker->cwq->wq->flags & WQ_SINGLE_THREAD))
-			worker->flags |= WORKER_ROGUE;
+		worker->flags |= WORKER_ROGUE;
 
 	for_each_busy_worker(worker, i, pos, gcwq)
-		if (!(worker->cwq->wq->flags & WQ_SINGLE_THREAD))
-			worker->flags |= WORKER_ROGUE;
+		worker->flags |= WORKER_ROGUE;
 
 	/*
 	 * We're now in charge.  Notify and proceed to drain.  We need
@@ -2068,14 +2131,12 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 			wait_trustee_state(gcwq, TRUSTEE_DONE);
 		}
 
-		/* clear ROGUE from all multithread workers */
+		/* clear ROGUE from all workers */
 		list_for_each_entry(worker, &gcwq->idle_list, entry)
-			if (!(worker->cwq->wq->flags & WQ_SINGLE_THREAD))
-				worker->flags &= ~WORKER_ROGUE;
+			worker->flags &= ~WORKER_ROGUE;
 
 		for_each_busy_worker(worker, i, pos, gcwq)
-			if (!(worker->cwq->wq->flags & WQ_SINGLE_THREAD))
-				worker->flags &= ~WORKER_ROGUE;
+			worker->flags &= ~WORKER_ROGUE;
 		break;
 	}
 
@@ -2260,6 +2321,11 @@ void thaw_workqueues(void)
 			       cwq->nr_active < cwq->max_active)
 				cwq_activate_first_delayed(cwq);
 
+			/* perform delayed unbind from single cpu if empty */
+			if (wq->single_cpu == gcwq->cpu &&
+			    !cwq->nr_active && list_empty(&cwq->delayed_works))
+				cwq_unbind_single_cpu(cwq);
+
 			wake_up_process(cwq->worker->task);
 		}
 
@@ -2285,7 +2351,6 @@ void __init init_workqueues(void)
 	BUILD_BUG_ON(__alignof__(struct cpu_workqueue_struct) <
 		     __alignof__(unsigned long long));
 
-	singlethread_cpu = cpumask_first(cpu_possible_mask);
 	hotcpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);
 
 	/* initialize gcwqs */
-- 
1.6.4.2

