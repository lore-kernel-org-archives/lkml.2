Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0FNVjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:39:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:46902 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab0FNVjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:15 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/30] workqueue: use shared worklist and pool all workers per cpu
Date: Mon, 14 Jun 2010 23:37:40 +0200
Message-Id: <1276551467-21246-24-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use gcwq->worklist instead of cwq->worklist and break the strict
association between a cwq and its worker.  All works queued on a cpu
are queued on gcwq->worklist and processed by any available worker on
the gcwq.

As there no longer is strict association between a cwq and its worker,
whether a work is executing can now only be determined by calling
[__]find_worker_executing_work().

After this change, the only association between a cwq and its worker
is that a cwq puts a worker into shared worker pool on creation and
kills it on destruction.  As all workqueues are still limited to
max_active of one, this means that there are always at least as many
workers as active works and thus there's no danger for deadlock.

The break of strong association between cwqs and workers requires
somewhat clumsy changes to current_is_keventd() and
destroy_workqueue().  Dynamic worker pool management will remove both
clumsy changes.  current_is_keventd() won't be necessary at all as the
only reason it exists is to avoid queueing a work from a work which
will be allowed just fine.  The clumsy part of destroy_workqueue() is
added because a worker can only be destroyed while idle and there's no
guarantee a worker is idle when its wq is going down.  With dynamic
pool management, workers are not associated with workqueues at all and
only idle ones will be submitted to destroy_workqueue() so the code
won't be necessary anymore.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |  131 +++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 99 insertions(+), 32 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7994edb..e0a7609 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -34,6 +34,7 @@
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
 #include <linux/idr.h>
+#include <linux/delay.h>
 
 enum {
 	/* global_cwq flags */
@@ -72,7 +73,6 @@ enum {
  */
 
 struct global_cwq;
-struct cpu_workqueue_struct;
 
 struct worker {
 	/* on idle list while idle, on busy hash table while busy */
@@ -86,7 +86,6 @@ struct worker {
 	struct list_head	scheduled;	/* L: scheduled works */
 	struct task_struct	*task;		/* I: worker task */
 	struct global_cwq	*gcwq;		/* I: the associated gcwq */
-	struct cpu_workqueue_struct *cwq;	/* I: the associated cwq */
 	unsigned int		flags;		/* L: flags */
 	int			id;		/* I: worker id */
 };
@@ -96,6 +95,7 @@ struct worker {
  */
 struct global_cwq {
 	spinlock_t		lock;		/* the gcwq lock */
+	struct list_head	worklist;	/* L: list of pending works */
 	unsigned int		cpu;		/* I: the associated cpu */
 	unsigned int		flags;		/* L: GCWQ_* flags */
 
@@ -121,7 +121,6 @@ struct global_cwq {
  */
 struct cpu_workqueue_struct {
 	struct global_cwq	*gcwq;		/* I: the associated gcwq */
-	struct list_head worklist;
 	struct worker		*worker;
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	int			work_color;	/* L: current color */
@@ -386,6 +385,32 @@ static struct global_cwq *get_work_gcwq(struct work_struct *work)
 	return get_gcwq(cpu);
 }
 
+/* Return the first worker.  Safe with preemption disabled */
+static struct worker *first_worker(struct global_cwq *gcwq)
+{
+	if (unlikely(list_empty(&gcwq->idle_list)))
+		return NULL;
+
+	return list_first_entry(&gcwq->idle_list, struct worker, entry);
+}
+
+/**
+ * wake_up_worker - wake up an idle worker
+ * @gcwq: gcwq to wake worker for
+ *
+ * Wake up the first idle worker of @gcwq.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ */
+static void wake_up_worker(struct global_cwq *gcwq)
+{
+	struct worker *worker = first_worker(gcwq);
+
+	if (likely(worker))
+		wake_up_process(worker->task);
+}
+
 /**
  * busy_worker_head - return the busy hash head for a work
  * @gcwq: gcwq of interest
@@ -467,13 +492,14 @@ static struct worker *find_worker_executing_work(struct global_cwq *gcwq,
 }
 
 /**
- * insert_work - insert a work into cwq
+ * insert_work - insert a work into gcwq
  * @cwq: cwq @work belongs to
  * @work: work to insert
  * @head: insertion point
  * @extra_flags: extra WORK_STRUCT_* flags to set
  *
- * Insert @work into @cwq after @head.
+ * Insert @work which belongs to @cwq into @gcwq after @head.
+ * @extra_flags is or'd to work_struct flags.
  *
  * CONTEXT:
  * spin_lock_irq(gcwq->lock).
@@ -492,7 +518,7 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 	smp_wmb();
 
 	list_add_tail(&work->entry, head);
-	wake_up_process(cwq->worker->task);
+	wake_up_worker(cwq->gcwq);
 }
 
 /**
@@ -608,7 +634,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 
 	if (likely(cwq->nr_active < cwq->max_active)) {
 		cwq->nr_active++;
-		worklist = &cwq->worklist;
+		worklist = &gcwq->worklist;
 	} else
 		worklist = &cwq->delayed_works;
 
@@ -793,10 +819,10 @@ static struct worker *alloc_worker(void)
 
 /**
  * create_worker - create a new workqueue worker
- * @cwq: cwq the new worker will belong to
+ * @gcwq: gcwq the new worker will belong to
  * @bind: whether to set affinity to @cpu or not
  *
- * Create a new worker which is bound to @cwq.  The returned worker
+ * Create a new worker which is bound to @gcwq.  The returned worker
  * can be started by calling start_worker() or destroyed using
  * destroy_worker().
  *
@@ -806,9 +832,8 @@ static struct worker *alloc_worker(void)
  * RETURNS:
  * Pointer to the newly created worker.
  */
-static struct worker *create_worker(struct cpu_workqueue_struct *cwq, bool bind)
+static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
 {
-	struct global_cwq *gcwq = cwq->gcwq;
 	int id = -1;
 	struct worker *worker = NULL;
 
@@ -826,7 +851,6 @@ static struct worker *create_worker(struct cpu_workqueue_struct *cwq, bool bind)
 		goto fail;
 
 	worker->gcwq = gcwq;
-	worker->cwq = cwq;
 	worker->id = id;
 
 	worker->task = kthread_create(worker_thread, worker, "kworker/%u:%d",
@@ -953,7 +977,7 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
 	struct work_struct *work = list_first_entry(&cwq->delayed_works,
 						    struct work_struct, entry);
 
-	move_linked_works(work, &cwq->worklist, NULL);
+	move_linked_works(work, &cwq->gcwq->worklist, NULL);
 	cwq->nr_active++;
 }
 
@@ -1021,11 +1045,12 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
  */
 static void process_one_work(struct worker *worker, struct work_struct *work)
 {
-	struct cpu_workqueue_struct *cwq = worker->cwq;
+	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
 	struct global_cwq *gcwq = cwq->gcwq;
 	struct hlist_head *bwh = busy_worker_head(gcwq, work);
 	work_func_t f = work->func;
 	int work_color;
+	struct worker *collision;
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * It is permissible to free the struct work_struct from
@@ -1036,6 +1061,18 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	 */
 	struct lockdep_map lockdep_map = work->lockdep_map;
 #endif
+	/*
+	 * A single work shouldn't be executed concurrently by
+	 * multiple workers on a single cpu.  Check whether anyone is
+	 * already processing the work.  If so, defer the work to the
+	 * currently executing one.
+	 */
+	collision = __find_worker_executing_work(gcwq, bwh, work);
+	if (unlikely(collision)) {
+		move_linked_works(work, &collision->scheduled, NULL);
+		return;
+	}
+
 	/* claim and process */
 	debug_work_deactivate(work);
 	hlist_add_head(&worker->hentry, bwh);
@@ -1043,7 +1080,6 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	worker->current_cwq = cwq;
 	work_color = get_work_color(work);
 
-	BUG_ON(get_work_cwq(work) != cwq);
 	/* record the current cpu number in the work data and dequeue */
 	set_work_cpu(work, gcwq->cpu);
 	list_del_init(&work->entry);
@@ -1107,7 +1143,6 @@ static int worker_thread(void *__worker)
 {
 	struct worker *worker = __worker;
 	struct global_cwq *gcwq = worker->gcwq;
-	struct cpu_workqueue_struct *cwq = worker->cwq;
 
 woke_up:
 	spin_lock_irq(&gcwq->lock);
@@ -1127,9 +1162,9 @@ recheck:
 	 */
 	BUG_ON(!list_empty(&worker->scheduled));
 
-	while (!list_empty(&cwq->worklist)) {
+	while (!list_empty(&gcwq->worklist)) {
 		struct work_struct *work =
-			list_first_entry(&cwq->worklist,
+			list_first_entry(&gcwq->worklist,
 					 struct work_struct, entry);
 
 		/*
@@ -1844,18 +1879,37 @@ int keventd_up(void)
 
 int current_is_keventd(void)
 {
-	struct cpu_workqueue_struct *cwq;
-	int cpu = raw_smp_processor_id(); /* preempt-safe: keventd is per-cpu */
-	int ret = 0;
+	bool found = false;
+	unsigned int cpu;
 
-	BUG_ON(!keventd_wq);
+	/*
+	 * There no longer is one-to-one relation between worker and
+	 * work queue and a worker task might be unbound from its cpu
+	 * if the cpu was offlined.  Match all busy workers.  This
+	 * function will go away once dynamic pool is implemented.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct worker *worker;
+		struct hlist_node *pos;
+		unsigned long flags;
+		int i;
 
-	cwq = get_cwq(cpu, keventd_wq);
-	if (current == cwq->worker->task)
-		ret = 1;
+		spin_lock_irqsave(&gcwq->lock, flags);
 
-	return ret;
+		for_each_busy_worker(worker, i, pos, gcwq) {
+			if (worker->task == current) {
+				found = true;
+				break;
+			}
+		}
+
+		spin_unlock_irqrestore(&gcwq->lock, flags);
+		if (found)
+			break;
+	}
 
+	return found;
 }
 
 static struct cpu_workqueue_struct *alloc_cwqs(void)
@@ -1947,12 +2001,11 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		cwq->wq = wq;
 		cwq->flush_color = -1;
 		cwq->max_active = max_active;
-		INIT_LIST_HEAD(&cwq->worklist);
 		INIT_LIST_HEAD(&cwq->delayed_works);
 
 		if (failed)
 			continue;
-		cwq->worker = create_worker(cwq, cpu_online(cpu));
+		cwq->worker = create_worker(gcwq, cpu_online(cpu));
 		if (cwq->worker)
 			start_worker(cwq->worker);
 		else
@@ -2014,13 +2067,26 @@ void destroy_workqueue(struct workqueue_struct *wq)
 
 	for_each_possible_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		struct global_cwq *gcwq = cwq->gcwq;
 		int i;
 
 		if (cwq->worker) {
-			spin_lock_irq(&cwq->gcwq->lock);
+		retry:
+			spin_lock_irq(&gcwq->lock);
+			/*
+			 * Worker can only be destroyed while idle.
+			 * Wait till it becomes idle.  This is ugly
+			 * and prone to starvation.  It will go away
+			 * once dynamic worker pool is implemented.
+			 */
+			if (!(cwq->worker->flags & WORKER_IDLE)) {
+				spin_unlock_irq(&gcwq->lock);
+				msleep(100);
+				goto retry;
+			}
 			destroy_worker(cwq->worker);
 			cwq->worker = NULL;
-			spin_unlock_irq(&cwq->gcwq->lock);
+			spin_unlock_irq(&gcwq->lock);
 		}
 
 		for (i = 0; i < WORK_NR_COLORS; i++)
@@ -2318,7 +2384,7 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  *
  * Start freezing workqueues.  After this function returns, all
  * freezeable workqueues will queue new works to their frozen_works
- * list instead of the cwq ones.
+ * list instead of gcwq->worklist.
  *
  * CONTEXT:
  * Grabs and releases workqueue_lock and gcwq->lock's.
@@ -2404,7 +2470,7 @@ out_unlock:
  * thaw_workqueues - thaw workqueues
  *
  * Thaw workqueues.  Normal queueing is restored and all collected
- * frozen works are transferred to their respective cwq worklists.
+ * frozen works are transferred to their respective gcwq worklists.
  *
  * CONTEXT:
  * Grabs and releases workqueue_lock and gcwq->lock's.
@@ -2485,6 +2551,7 @@ void __init init_workqueues(void)
 		struct global_cwq *gcwq = get_gcwq(cpu);
 
 		spin_lock_init(&gcwq->lock);
+		INIT_LIST_HEAD(&gcwq->worklist);
 		gcwq->cpu = cpu;
 
 		INIT_LIST_HEAD(&gcwq->idle_list);
-- 
1.6.4.2

