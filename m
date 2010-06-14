Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab0FNVpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:45:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:46907 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab0FNVjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:16 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/30] workqueue: implement worker states
Date: Mon, 14 Jun 2010 23:37:34 +0200
Message-Id: <1276551467-21246-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement worker states.  After created, a worker is STARTED.  While a
worker isn't processing a work, it's IDLE and chained on
gcwq->idle_list.  While processing a work, a worker is BUSY and
chained on gcwq->busy_hash.  Also, gcwq now counts the number of all
workers and idle ones.

worker_thread() is restructured to reflect state transitions.
cwq->more_work is removed and waking up a worker makes it check for
events.  A worker is killed by setting DIE flag while it's IDLE and
waking it up.

This gives gcwq better visibility of what's going on and allows it to
find out whether a work is executing quickly which is necessary to
have multiple workers processing the same cwq.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |  214 ++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 173 insertions(+), 41 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d0ca750..62d7cfd 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -35,6 +35,17 @@
 #include <linux/lockdep.h>
 #include <linux/idr.h>
 
+enum {
+	/* worker flags */
+	WORKER_STARTED		= 1 << 0,	/* started */
+	WORKER_DIE		= 1 << 1,	/* die die die */
+	WORKER_IDLE		= 1 << 2,	/* is idle */
+
+	BUSY_WORKER_HASH_ORDER	= 6,		/* 64 pointers */
+	BUSY_WORKER_HASH_SIZE	= 1 << BUSY_WORKER_HASH_ORDER,
+	BUSY_WORKER_HASH_MASK	= BUSY_WORKER_HASH_SIZE - 1,
+};
+
 /*
  * Structure fields follow one of the following exclusion rules.
  *
@@ -51,11 +62,18 @@ struct global_cwq;
 struct cpu_workqueue_struct;
 
 struct worker {
+	/* on idle list while idle, on busy hash table while busy */
+	union {
+		struct list_head	entry;	/* L: while idle */
+		struct hlist_node	hentry;	/* L: while busy */
+	};
+
 	struct work_struct	*current_work;	/* L: work being processed */
 	struct list_head	scheduled;	/* L: scheduled works */
 	struct task_struct	*task;		/* I: worker task */
 	struct global_cwq	*gcwq;		/* I: the associated gcwq */
 	struct cpu_workqueue_struct *cwq;	/* I: the associated cwq */
+	unsigned int		flags;		/* L: flags */
 	int			id;		/* I: worker id */
 };
 
@@ -65,6 +83,15 @@ struct worker {
 struct global_cwq {
 	spinlock_t		lock;		/* the gcwq lock */
 	unsigned int		cpu;		/* I: the associated cpu */
+
+	int			nr_workers;	/* L: total number of workers */
+	int			nr_idle;	/* L: currently idle ones */
+
+	/* workers are chained either in the idle_list or busy_hash */
+	struct list_head	idle_list;	/* L: list of idle workers */
+	struct hlist_head	busy_hash[BUSY_WORKER_HASH_SIZE];
+						/* L: hash of busy workers */
+
 	struct ida		worker_ida;	/* L: for worker IDs */
 } ____cacheline_aligned_in_smp;
 
@@ -77,7 +104,6 @@ struct global_cwq {
 struct cpu_workqueue_struct {
 	struct global_cwq	*gcwq;		/* I: the associated gcwq */
 	struct list_head worklist;
-	wait_queue_head_t more_work;
 	struct worker		*worker;
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	int			work_color;	/* L: current color */
@@ -307,6 +333,33 @@ static inline struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 }
 
 /**
+ * busy_worker_head - return the busy hash head for a work
+ * @gcwq: gcwq of interest
+ * @work: work to be hashed
+ *
+ * Return hash head of @gcwq for @work.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ *
+ * RETURNS:
+ * Pointer to the hash head.
+ */
+static struct hlist_head *busy_worker_head(struct global_cwq *gcwq,
+					   struct work_struct *work)
+{
+	const int base_shift = ilog2(sizeof(struct work_struct));
+	unsigned long v = (unsigned long)work;
+
+	/* simple shift and fold hash, do we need something better? */
+	v >>= base_shift;
+	v += v >> BUSY_WORKER_HASH_ORDER;
+	v &= BUSY_WORKER_HASH_MASK;
+
+	return &gcwq->busy_hash[v];
+}
+
+/**
  * insert_work - insert a work into cwq
  * @cwq: cwq @work belongs to
  * @work: work to insert
@@ -332,7 +385,7 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 	smp_wmb();
 
 	list_add_tail(&work->entry, head);
-	wake_up(&cwq->more_work);
+	wake_up_process(cwq->worker->task);
 }
 
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
@@ -470,13 +523,59 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
+/**
+ * worker_enter_idle - enter idle state
+ * @worker: worker which is entering idle state
+ *
+ * @worker is entering idle state.  Update stats and idle timer if
+ * necessary.
+ *
+ * LOCKING:
+ * spin_lock_irq(gcwq->lock).
+ */
+static void worker_enter_idle(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->gcwq;
+
+	BUG_ON(worker->flags & WORKER_IDLE);
+	BUG_ON(!list_empty(&worker->entry) &&
+	       (worker->hentry.next || worker->hentry.pprev));
+
+	worker->flags |= WORKER_IDLE;
+	gcwq->nr_idle++;
+
+	/* idle_list is LIFO */
+	list_add(&worker->entry, &gcwq->idle_list);
+}
+
+/**
+ * worker_leave_idle - leave idle state
+ * @worker: worker which is leaving idle state
+ *
+ * @worker is leaving idle state.  Update stats.
+ *
+ * LOCKING:
+ * spin_lock_irq(gcwq->lock).
+ */
+static void worker_leave_idle(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->gcwq;
+
+	BUG_ON(!(worker->flags & WORKER_IDLE));
+	worker->flags &= ~WORKER_IDLE;
+	gcwq->nr_idle--;
+	list_del_init(&worker->entry);
+}
+
 static struct worker *alloc_worker(void)
 {
 	struct worker *worker;
 
 	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
-	if (worker)
+	if (worker) {
+		INIT_LIST_HEAD(&worker->entry);
 		INIT_LIST_HEAD(&worker->scheduled);
+	}
 	return worker;
 }
 
@@ -541,13 +640,16 @@ fail:
  * start_worker - start a newly created worker
  * @worker: worker to start
  *
- * Start @worker.
+ * Make the gcwq aware of @worker and start it.
  *
  * CONTEXT:
  * spin_lock_irq(gcwq->lock).
  */
 static void start_worker(struct worker *worker)
 {
+	worker->flags |= WORKER_STARTED;
+	worker->gcwq->nr_workers++;
+	worker_enter_idle(worker);
 	wake_up_process(worker->task);
 }
 
@@ -555,7 +657,10 @@ static void start_worker(struct worker *worker)
  * destroy_worker - destroy a workqueue worker
  * @worker: worker to be destroyed
  *
- * Destroy @worker.
+ * Destroy @worker and adjust @gcwq stats accordingly.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock) which is released and regrabbed.
  */
 static void destroy_worker(struct worker *worker)
 {
@@ -566,12 +671,21 @@ static void destroy_worker(struct worker *worker)
 	BUG_ON(worker->current_work);
 	BUG_ON(!list_empty(&worker->scheduled));
 
+	if (worker->flags & WORKER_STARTED)
+		gcwq->nr_workers--;
+	if (worker->flags & WORKER_IDLE)
+		gcwq->nr_idle--;
+
+	list_del_init(&worker->entry);
+	worker->flags |= WORKER_DIE;
+
+	spin_unlock_irq(&gcwq->lock);
+
 	kthread_stop(worker->task);
 	kfree(worker);
 
 	spin_lock_irq(&gcwq->lock);
 	ida_remove(&gcwq->worker_ida, id);
-	spin_unlock_irq(&gcwq->lock);
 }
 
 /**
@@ -686,6 +800,7 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq = worker->cwq;
 	struct global_cwq *gcwq = cwq->gcwq;
+	struct hlist_head *bwh = busy_worker_head(gcwq, work);
 	work_func_t f = work->func;
 	int work_color;
 #ifdef CONFIG_LOCKDEP
@@ -700,6 +815,7 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 #endif
 	/* claim and process */
 	debug_work_deactivate(work);
+	hlist_add_head(&worker->hentry, bwh);
 	worker->current_work = work;
 	work_color = get_work_color(work);
 	list_del_init(&work->entry);
@@ -727,6 +843,7 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	spin_lock_irq(&gcwq->lock);
 
 	/* we're done with it, release */
+	hlist_del_init(&worker->hentry);
 	worker->current_work = NULL;
 	cwq_dec_nr_in_flight(cwq, work_color);
 }
@@ -763,47 +880,56 @@ static int worker_thread(void *__worker)
 	struct worker *worker = __worker;
 	struct global_cwq *gcwq = worker->gcwq;
 	struct cpu_workqueue_struct *cwq = worker->cwq;
-	DEFINE_WAIT(wait);
 
-	for (;;) {
-		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
-		if (!kthread_should_stop() &&
-		    list_empty(&cwq->worklist))
-			schedule();
-		finish_wait(&cwq->more_work, &wait);
+woke_up:
+	if (unlikely(!cpumask_equal(&worker->task->cpus_allowed,
+				    get_cpu_mask(gcwq->cpu))))
+		set_cpus_allowed_ptr(worker->task, get_cpu_mask(gcwq->cpu));
 
-		if (kthread_should_stop())
-			break;
+	spin_lock_irq(&gcwq->lock);
 
-		if (unlikely(!cpumask_equal(&worker->task->cpus_allowed,
-					    get_cpu_mask(gcwq->cpu))))
-			set_cpus_allowed_ptr(worker->task,
-					     get_cpu_mask(gcwq->cpu));
+	/* DIE can be set only while we're idle, checking here is enough */
+	if (worker->flags & WORKER_DIE) {
+		spin_unlock_irq(&gcwq->lock);
+		return 0;
+	}
 
-		spin_lock_irq(&gcwq->lock);
+	worker_leave_idle(worker);
 
-		while (!list_empty(&cwq->worklist)) {
-			struct work_struct *work =
-				list_first_entry(&cwq->worklist,
-						 struct work_struct, entry);
-
-			if (likely(!(*work_data_bits(work) &
-				     WORK_STRUCT_LINKED))) {
-				/* optimization path, not strictly necessary */
-				process_one_work(worker, work);
-				if (unlikely(!list_empty(&worker->scheduled)))
-					process_scheduled_works(worker);
-			} else {
-				move_linked_works(work, &worker->scheduled,
-						  NULL);
+	/*
+	 * ->scheduled list can only be filled while a worker is
+	 * preparing to process a work or actually processing it.
+	 * Make sure nobody diddled with it while I was sleeping.
+	 */
+	BUG_ON(!list_empty(&worker->scheduled));
+
+	while (!list_empty(&cwq->worklist)) {
+		struct work_struct *work =
+			list_first_entry(&cwq->worklist,
+					 struct work_struct, entry);
+
+		if (likely(!(*work_data_bits(work) & WORK_STRUCT_LINKED))) {
+			/* optimization path, not strictly necessary */
+			process_one_work(worker, work);
+			if (unlikely(!list_empty(&worker->scheduled)))
 				process_scheduled_works(worker);
-			}
+		} else {
+			move_linked_works(work, &worker->scheduled, NULL);
+			process_scheduled_works(worker);
 		}
-
-		spin_unlock_irq(&gcwq->lock);
 	}
 
-	return 0;
+	/*
+	 * gcwq->lock is held and there's no work to process, sleep.
+	 * Workers are woken up only while holding gcwq->lock, so
+	 * setting the current state before releasing gcwq->lock is
+	 * enough to prevent losing any event.
+	 */
+	worker_enter_idle(worker);
+	__set_current_state(TASK_INTERRUPTIBLE);
+	spin_unlock_irq(&gcwq->lock);
+	schedule();
+	goto woke_up;
 }
 
 struct wq_barrier {
@@ -1594,7 +1720,6 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		cwq->max_active = max_active;
 		INIT_LIST_HEAD(&cwq->worklist);
 		INIT_LIST_HEAD(&cwq->delayed_works);
-		init_waitqueue_head(&cwq->more_work);
 
 		if (failed)
 			continue;
@@ -1645,7 +1770,7 @@ EXPORT_SYMBOL_GPL(__create_workqueue_key);
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
-	int cpu;
+	unsigned int cpu;
 
 	flush_workqueue(wq);
 
@@ -1664,8 +1789,10 @@ void destroy_workqueue(struct workqueue_struct *wq)
 		int i;
 
 		if (cwq->worker) {
+			spin_lock_irq(&cwq->gcwq->lock);
 			destroy_worker(cwq->worker);
 			cwq->worker = NULL;
+			spin_unlock_irq(&cwq->gcwq->lock);
 		}
 
 		for (i = 0; i < WORK_NR_COLORS; i++)
@@ -1875,7 +2002,7 @@ void thaw_workqueues(void)
 			       cwq->nr_active < cwq->max_active)
 				cwq_activate_first_delayed(cwq);
 
-			wake_up(&cwq->more_work);
+			wake_up_process(cwq->worker->task);
 		}
 
 		spin_unlock_irq(&gcwq->lock);
@@ -1890,6 +2017,7 @@ out_unlock:
 void __init init_workqueues(void)
 {
 	unsigned int cpu;
+	int i;
 
 	/*
 	 * cwqs are forced aligned according to WORK_STRUCT_FLAG_BITS.
@@ -1909,6 +2037,10 @@ void __init init_workqueues(void)
 		spin_lock_init(&gcwq->lock);
 		gcwq->cpu = cpu;
 
+		INIT_LIST_HEAD(&gcwq->idle_list);
+		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)
+			INIT_HLIST_HEAD(&gcwq->busy_hash[i]);
+
 		ida_init(&gcwq->worker_ida);
 	}
 
-- 
1.6.4.2

