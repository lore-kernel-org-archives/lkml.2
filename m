Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab0FNVnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:43:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:46919 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679Ab0FNVjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:19 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 24/30] workqueue: implement concurrency managed dynamic worker pool
Date: Mon, 14 Jun 2010 23:37:41 +0200
Message-Id: <1276551467-21246-25-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of creating a worker for each cwq and putting it into the
shared pool, manage per-cpu workers dynamically.

Works aren't supposed to be cpu cycle hogs and maintaining just enough
concurrency to prevent work processing from stalling due to lack of
processing context is optimal.  gcwq keeps the number of concurrent
active workers to minimum but no less.  As long as there's one or more
running workers on the cpu, no new worker is scheduled so that works
can be processed in batch as much as possible but when the last
running worker blocks, gcwq immediately schedules new worker so that
the cpu doesn't sit idle while there are works to be processed.

gcwq always keeps at least single idle worker around.  When a new
worker is necessary and the worker is the last idle one, the worker
assumes the role of "manager" and manages the worker pool -
ie. creates another worker.  Forward-progress is guaranteed by having
dedicated rescue workers for workqueues which may be necessary while
creating a new worker.  When the manager is having problem creating a
new worker, mayday timer activates and rescue workers are summoned to
the cpu and execute works which might be necessary to create new
workers.

Trustee is expanded to serve the role of manager while a CPU is being
taken down and stays down.  As no new works are supposed to be queued
on a dead cpu, it just needs to drain all the existing ones.  Trustee
continues to try to create new workers and summon rescuers as long as
there are pending works.  If the CPU is brought back up while the
trustee is still trying to drain the gcwq from the previous offlining,
the trustee will kill all idles ones and tell workers which are still
busy to rebind to the cpu, and pass control over to gcwq which assumes
the manager role as necessary.

Concurrency managed worker pool reduces the number of workers
drastically.  Only workers which are necessary to keep the processing
going are created and kept.  Also, it reduces cache footprint by
avoiding unnecessarily switching contexts between different workers.

Please note that this patch does not increase max_active of any
workqueue.  All workqueues can still only process one work per cpu.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    8 +-
 kernel/workqueue.c        |  908 ++++++++++++++++++++++++++++++++++++++++-----
 kernel/workqueue_sched.h  |   13 +-
 3 files changed, 816 insertions(+), 113 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 07cf5e5..b8f4ec4 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -226,6 +226,7 @@ enum {
 	WQ_FREEZEABLE		= 1 << 0, /* freeze during suspend */
 	WQ_SINGLE_CPU		= 1 << 1, /* only single cpu at a time */
 	WQ_NON_REENTRANT	= 1 << 2, /* guarantee non-reentrance */
+	WQ_RESCUER		= 1 << 3, /* has an rescue worker */
 };
 
 extern struct workqueue_struct *
@@ -252,11 +253,12 @@ __create_workqueue_key(const char *name, unsigned int flags, int max_active,
 #endif
 
 #define create_workqueue(name)					\
-	__create_workqueue((name), 0, 1)
+	__create_workqueue((name), WQ_RESCUER, 1)
 #define create_freezeable_workqueue(name)			\
-	__create_workqueue((name), WQ_FREEZEABLE | WQ_SINGLE_CPU, 1)
+	__create_workqueue((name),				\
+			   WQ_FREEZEABLE | WQ_SINGLE_CPU | WQ_RESCUER, 1)
 #define create_singlethread_workqueue(name)			\
-	__create_workqueue((name), WQ_SINGLE_CPU, 1)
+	__create_workqueue((name), WQ_SINGLE_CPU | WQ_RESCUER, 1)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e0a7609..dd8c38b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -34,17 +34,25 @@
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
 #include <linux/idr.h>
-#include <linux/delay.h>
+
+#include "workqueue_sched.h"
 
 enum {
 	/* global_cwq flags */
+	GCWQ_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
+	GCWQ_MANAGING_WORKERS	= 1 << 1,	/* managing workers */
+	GCWQ_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
 	GCWQ_FREEZING		= 1 << 3,	/* freeze in progress */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
 	WORKER_DIE		= 1 << 1,	/* die die die */
 	WORKER_IDLE		= 1 << 2,	/* is idle */
+	WORKER_PREP		= 1 << 3,	/* preparing to run works */
 	WORKER_ROGUE		= 1 << 4,	/* not bound to any cpu */
+	WORKER_REBIND		= 1 << 5,	/* mom is home, come back */
+
+	WORKER_IGN_RUNNING	= WORKER_PREP | WORKER_ROGUE | WORKER_REBIND,
 
 	/* gcwq->trustee_state */
 	TRUSTEE_START		= 0,		/* start */
@@ -57,7 +65,19 @@ enum {
 	BUSY_WORKER_HASH_SIZE	= 1 << BUSY_WORKER_HASH_ORDER,
 	BUSY_WORKER_HASH_MASK	= BUSY_WORKER_HASH_SIZE - 1,
 
+	MAX_IDLE_WORKERS_RATIO	= 4,		/* 1/4 of busy can be idle */
+	IDLE_WORKER_TIMEOUT	= 300 * HZ,	/* keep idle ones for 5 mins */
+
+	MAYDAY_INITIAL_TIMEOUT	= HZ / 100,	/* call for help after 10ms */
+	MAYDAY_INTERVAL		= HZ / 10,	/* and then every 100ms */
+	CREATE_COOLDOWN		= HZ,		/* time to breath after fail */
 	TRUSTEE_COOLDOWN	= HZ / 10,	/* for trustee draining */
+
+	/*
+	 * Rescue workers are used only on emergencies and shared by
+	 * all cpus.  Give -20.
+	 */
+	RESCUER_NICE_LEVEL	= -20,
 };
 
 /*
@@ -65,8 +85,16 @@ enum {
  *
  * I: Set during initialization and read-only afterwards.
  *
+ * P: Preemption protected.  Disabling preemption is enough and should
+ *    only be modified and accessed from the local cpu.
+ *
  * L: gcwq->lock protected.  Access with gcwq->lock held.
  *
+ * X: During normal operation, modification requires gcwq->lock and
+ *    should be done only from local cpu.  Either disabling preemption
+ *    on local cpu or grabbing gcwq->lock is enough for read access.
+ *    While trustee is in charge, it's identical to L.
+ *
  * F: wq->flush_mutex protected.
  *
  * W: workqueue_lock protected.
@@ -74,6 +102,10 @@ enum {
 
 struct global_cwq;
 
+/*
+ * The poor guys doing the actual heavy lifting.  All on-duty workers
+ * are either serving the manager role, on idle list or on busy hash.
+ */
 struct worker {
 	/* on idle list while idle, on busy hash table while busy */
 	union {
@@ -86,12 +118,17 @@ struct worker {
 	struct list_head	scheduled;	/* L: scheduled works */
 	struct task_struct	*task;		/* I: worker task */
 	struct global_cwq	*gcwq;		/* I: the associated gcwq */
-	unsigned int		flags;		/* L: flags */
+	/* 64 bytes boundary on 64bit, 32 on 32bit */
+	unsigned long		last_active;	/* L: last active timestamp */
+	unsigned int		flags;		/* ?: flags */
 	int			id;		/* I: worker id */
+	struct work_struct	rebind_work;	/* L: rebind worker to cpu */
 };
 
 /*
- * Global per-cpu workqueue.
+ * Global per-cpu workqueue.  There's one and only one for each cpu
+ * and all works are queued and processed here regardless of their
+ * target workqueues.
  */
 struct global_cwq {
 	spinlock_t		lock;		/* the gcwq lock */
@@ -103,15 +140,19 @@ struct global_cwq {
 	int			nr_idle;	/* L: currently idle ones */
 
 	/* workers are chained either in the idle_list or busy_hash */
-	struct list_head	idle_list;	/* L: list of idle workers */
+	struct list_head	idle_list;	/* ?: list of idle workers */
 	struct hlist_head	busy_hash[BUSY_WORKER_HASH_SIZE];
 						/* L: hash of busy workers */
 
+	struct timer_list	idle_timer;	/* L: worker idle timeout */
+	struct timer_list	mayday_timer;	/* L: SOS timer for dworkers */
+
 	struct ida		worker_ida;	/* L: for worker IDs */
 
 	struct task_struct	*trustee;	/* L: for gcwq shutdown */
 	unsigned int		trustee_state;	/* L: trustee state */
 	wait_queue_head_t	trustee_wait;	/* trustee wait */
+	struct worker		*first_idle;	/* L: first idle worker */
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -121,7 +162,6 @@ struct global_cwq {
  */
 struct cpu_workqueue_struct {
 	struct global_cwq	*gcwq;		/* I: the associated gcwq */
-	struct worker		*worker;
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	int			work_color;	/* L: current color */
 	int			flush_color;	/* L: flushing color */
@@ -160,6 +200,9 @@ struct workqueue_struct {
 
 	unsigned long		single_cpu;	/* cpu for single cpu wq */
 
+	cpumask_var_t		mayday_mask;	/* cpus requesting rescue */
+	struct worker		*rescuer;	/* I: rescue worker */
+
 	int			saved_max_active; /* I: saved cwq max_active */
 	const char		*name;		/* I: workqueue name */
 #ifdef CONFIG_LOCKDEP
@@ -286,7 +329,13 @@ static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 static bool workqueue_freezing;		/* W: have wqs started freezing? */
 
+/*
+ * The almighty global cpu workqueues.  nr_running is the only field
+ * which is expected to be used frequently by other cpus via
+ * try_to_wake_up().  Put it in a separate cacheline.
+ */
 static DEFINE_PER_CPU(struct global_cwq, global_cwq);
+static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, gcwq_nr_running);
 
 static int worker_thread(void *__worker);
 
@@ -295,6 +344,11 @@ static struct global_cwq *get_gcwq(unsigned int cpu)
 	return &per_cpu(global_cwq, cpu);
 }
 
+static atomic_t *get_gcwq_nr_running(unsigned int cpu)
+{
+	return &per_cpu(gcwq_nr_running, cpu);
+}
+
 static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
 					    struct workqueue_struct *wq)
 {
@@ -385,6 +439,63 @@ static struct global_cwq *get_work_gcwq(struct work_struct *work)
 	return get_gcwq(cpu);
 }
 
+/*
+ * Policy functions.  These define the policies on how the global
+ * worker pool is managed.  Unless noted otherwise, these functions
+ * assume that they're being called with gcwq->lock held.
+ */
+
+/*
+ * Need to wake up a worker?  Called from anything but currently
+ * running workers.
+ */
+static bool need_more_worker(struct global_cwq *gcwq)
+{
+	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
+
+	return !list_empty(&gcwq->worklist) && !atomic_read(nr_running);
+}
+
+/* Can I start working?  Called from busy but !running workers. */
+static bool may_start_working(struct global_cwq *gcwq)
+{
+	return gcwq->nr_idle;
+}
+
+/* Do I need to keep working?  Called from currently running workers. */
+static bool keep_working(struct global_cwq *gcwq)
+{
+	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
+
+	return !list_empty(&gcwq->worklist) && atomic_read(nr_running) <= 1;
+}
+
+/* Do we need a new worker?  Called from manager. */
+static bool need_to_create_worker(struct global_cwq *gcwq)
+{
+	return need_more_worker(gcwq) && !may_start_working(gcwq);
+}
+
+/* Do I need to be the manager? */
+static bool need_to_manage_workers(struct global_cwq *gcwq)
+{
+	return need_to_create_worker(gcwq) || gcwq->flags & GCWQ_MANAGE_WORKERS;
+}
+
+/* Do we have too many workers and should some go away? */
+static bool too_many_workers(struct global_cwq *gcwq)
+{
+	bool managing = gcwq->flags & GCWQ_MANAGING_WORKERS;
+	int nr_idle = gcwq->nr_idle + managing; /* manager is considered idle */
+	int nr_busy = gcwq->nr_workers - nr_idle;
+
+	return nr_idle > 2 && (nr_idle - 2) * MAX_IDLE_WORKERS_RATIO >= nr_busy;
+}
+
+/*
+ * Wake up functions.
+ */
+
 /* Return the first worker.  Safe with preemption disabled */
 static struct worker *first_worker(struct global_cwq *gcwq)
 {
@@ -412,6 +523,63 @@ static void wake_up_worker(struct global_cwq *gcwq)
 }
 
 /**
+ * wq_worker_waking_up - a worker is waking up
+ * @task: task waking up
+ * @cpu: CPU @task is waking up to
+ *
+ * This function is called during try_to_wake_up() when a worker is
+ * being awoken.
+ *
+ * CONTEXT:
+ * spin_lock_irq(rq->lock)
+ */
+void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
+{
+	struct worker *worker = kthread_data(task);
+
+	if (likely(!(worker->flags & WORKER_IGN_RUNNING)))
+		atomic_inc(get_gcwq_nr_running(cpu));
+}
+
+/**
+ * wq_worker_sleeping - a worker is going to sleep
+ * @task: task going to sleep
+ * @cpu: CPU in question, must be the current CPU number
+ *
+ * This function is called during schedule() when a busy worker is
+ * going to sleep.  Worker on the same cpu can be woken up by
+ * returning pointer to its task.
+ *
+ * CONTEXT:
+ * spin_lock_irq(rq->lock)
+ *
+ * RETURNS:
+ * Worker task on @cpu to wake up, %NULL if none.
+ */
+struct task_struct *wq_worker_sleeping(struct task_struct *task,
+				       unsigned int cpu)
+{
+	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
+	struct global_cwq *gcwq = get_gcwq(cpu);
+	atomic_t *nr_running = get_gcwq_nr_running(cpu);
+
+	if (unlikely(worker->flags & WORKER_IGN_RUNNING))
+		return NULL;
+
+	/* this can only happen on the local cpu */
+	BUG_ON(cpu != raw_smp_processor_id());
+
+	/*
+	 * The counterpart of the following dec_and_test, implied mb,
+	 * worklist not empty test sequence is in insert_work().
+	 * Please read comment there.
+	 */
+	if (atomic_dec_and_test(nr_running) && !list_empty(&gcwq->worklist))
+		to_wakeup = first_worker(gcwq);
+	return to_wakeup ? to_wakeup->task : NULL;
+}
+
+/**
  * busy_worker_head - return the busy hash head for a work
  * @gcwq: gcwq of interest
  * @work: work to be hashed
@@ -508,6 +676,8 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head,
 			unsigned int extra_flags)
 {
+	struct global_cwq *gcwq = cwq->gcwq;
+
 	/* we own @work, set data and link */
 	set_work_cwq(work, cwq, extra_flags);
 
@@ -518,7 +688,16 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 	smp_wmb();
 
 	list_add_tail(&work->entry, head);
-	wake_up_worker(cwq->gcwq);
+
+	/*
+	 * Ensure either worker_sched_deactivated() sees the above
+	 * list_add_tail() or we see zero nr_running to avoid workers
+	 * lying around lazily while there are works to be processed.
+	 */
+	smp_mb();
+
+	if (!atomic_read(get_gcwq_nr_running(gcwq->cpu)))
+		wake_up_worker(gcwq);
 }
 
 /**
@@ -778,11 +957,16 @@ static void worker_enter_idle(struct worker *worker)
 
 	worker->flags |= WORKER_IDLE;
 	gcwq->nr_idle++;
+	worker->last_active = jiffies;
 
 	/* idle_list is LIFO */
 	list_add(&worker->entry, &gcwq->idle_list);
 
-	if (unlikely(worker->flags & WORKER_ROGUE))
+	if (likely(!(worker->flags & WORKER_ROGUE))) {
+		if (too_many_workers(gcwq) && !timer_pending(&gcwq->idle_timer))
+			mod_timer(&gcwq->idle_timer,
+				  jiffies + IDLE_WORKER_TIMEOUT);
+	} else
 		wake_up_all(&gcwq->trustee_wait);
 }
 
@@ -805,6 +989,89 @@ static void worker_leave_idle(struct worker *worker)
 	list_del_init(&worker->entry);
 }
 
+/**
+ * worker_maybe_bind_and_lock - bind worker to its cpu if possible and lock gcwq
+ * @worker: self
+ *
+ * Works which are scheduled while the cpu is online must at least be
+ * scheduled to a worker which is bound to the cpu so that if they are
+ * flushed from cpu callbacks while cpu is going down, they are
+ * guaranteed to execute on the cpu.
+ *
+ * This function is to be used by rogue workers and rescuers to bind
+ * themselves to the target cpu and may race with cpu going down or
+ * coming online.  kthread_bind() can't be used because it may put the
+ * worker to already dead cpu and set_cpus_allowed_ptr() can't be used
+ * verbatim as it's best effort and blocking and gcwq may be
+ * [dis]associated in the meantime.
+ *
+ * This function tries set_cpus_allowed() and locks gcwq and verifies
+ * the binding against GCWQ_DISASSOCIATED which is set during
+ * CPU_DYING and cleared during CPU_ONLINE, so if the worker enters
+ * idle state or fetches works without dropping lock, it can guarantee
+ * the scheduling requirement described in the first paragraph.
+ *
+ * CONTEXT:
+ * Might sleep.  Called without any lock but returns with gcwq->lock
+ * held.
+ *
+ * RETURNS:
+ * %true if the associated gcwq is online (@worker is successfully
+ * bound), %false if offline.
+ */
+static bool worker_maybe_bind_and_lock(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->gcwq;
+	struct task_struct *task = worker->task;
+
+	while (true) {
+		/*
+		 * The following call may fail, succeed or succeed
+		 * without actually migrating the task to the cpu if
+		 * it races with cpu hotunplug operation.  Verify
+		 * against GCWQ_DISASSOCIATED.
+		 */
+		set_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));
+
+		spin_lock_irq(&gcwq->lock);
+		if (gcwq->flags & GCWQ_DISASSOCIATED)
+			return false;
+		if (task_cpu(task) == gcwq->cpu &&
+		    cpumask_equal(&current->cpus_allowed,
+				  get_cpu_mask(gcwq->cpu)))
+			return true;
+		spin_unlock_irq(&gcwq->lock);
+
+		/* CPU has come up inbetween, retry migration */
+		cpu_relax();
+	}
+}
+
+/*
+ * Function for worker->rebind_work used to rebind rogue busy workers
+ * to the associated cpu which is coming back online.
+ */
+static void worker_rebind_fn(struct work_struct *work)
+{
+	struct worker *worker = container_of(work, struct worker, rebind_work);
+	struct global_cwq *gcwq = worker->gcwq;
+
+	/*
+	 * This is scheduled by cpu up but can race with other cpu
+	 * hotplug operations and may be executed twice without
+	 * intervening cpu down.  Bump nr_running only if we clear
+	 * REBIND and nothing else tells us to skip running state
+	 * tracking.
+	 */
+	if (worker_maybe_bind_and_lock(worker) &&
+	    (worker->flags & WORKER_REBIND)) {
+		worker->flags &= ~WORKER_REBIND;
+		if (!(worker->flags & WORKER_IGN_RUNNING))
+			atomic_inc(get_gcwq_nr_running(gcwq->cpu));
+	}
+	spin_unlock_irq(&gcwq->lock);
+}
+
 static struct worker *alloc_worker(void)
 {
 	struct worker *worker;
@@ -813,6 +1080,8 @@ static struct worker *alloc_worker(void)
 	if (worker) {
 		INIT_LIST_HEAD(&worker->entry);
 		INIT_LIST_HEAD(&worker->scheduled);
+		INIT_WORK(&worker->rebind_work, worker_rebind_fn);
+		/* on creation a worker is not idle */
 	}
 	return worker;
 }
@@ -890,7 +1159,7 @@ fail:
  */
 static void start_worker(struct worker *worker)
 {
-	worker->flags |= WORKER_STARTED;
+	worker->flags |= WORKER_STARTED | WORKER_PREP;
 	worker->gcwq->nr_workers++;
 	worker_enter_idle(worker);
 	wake_up_process(worker->task);
@@ -931,6 +1200,220 @@ static void destroy_worker(struct worker *worker)
 	ida_remove(&gcwq->worker_ida, id);
 }
 
+static void idle_worker_timeout(unsigned long __gcwq)
+{
+	struct global_cwq *gcwq = (void *)__gcwq;
+
+	spin_lock_irq(&gcwq->lock);
+
+	if (too_many_workers(gcwq)) {
+		struct worker *worker;
+		unsigned long expires;
+
+		/* idle_list is kept in LIFO order, check the last one */
+		worker = list_entry(gcwq->idle_list.prev, struct worker, entry);
+		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
+
+		if (time_before(jiffies, expires))
+			mod_timer(&gcwq->idle_timer, expires);
+		else {
+			/* it's been idle for too long, wake up manager */
+			gcwq->flags |= GCWQ_MANAGE_WORKERS;
+			wake_up_worker(gcwq);
+		}
+	}
+
+	spin_unlock_irq(&gcwq->lock);
+}
+
+static bool send_mayday(struct work_struct *work)
+{
+	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
+	struct workqueue_struct *wq = cwq->wq;
+
+	if (!(wq->flags & WQ_RESCUER))
+		return false;
+
+	/* mayday mayday mayday */
+	if (!cpumask_test_and_set_cpu(cwq->gcwq->cpu, wq->mayday_mask))
+		wake_up_process(wq->rescuer->task);
+	return true;
+}
+
+static void gcwq_mayday_timeout(unsigned long __gcwq)
+{
+	struct global_cwq *gcwq = (void *)__gcwq;
+	struct work_struct *work;
+
+	spin_lock_irq(&gcwq->lock);
+
+	if (need_to_create_worker(gcwq)) {
+		/*
+		 * We've been trying to create a new worker but
+		 * haven't been successful.  We might be hitting an
+		 * allocation deadlock.  Send distress signals to
+		 * rescuers.
+		 */
+		list_for_each_entry(work, &gcwq->worklist, entry)
+			send_mayday(work);
+	}
+
+	spin_unlock_irq(&gcwq->lock);
+
+	mod_timer(&gcwq->mayday_timer, jiffies + MAYDAY_INTERVAL);
+}
+
+/**
+ * maybe_create_worker - create a new worker if necessary
+ * @gcwq: gcwq to create a new worker for
+ *
+ * Create a new worker for @gcwq if necessary.  @gcwq is guaranteed to
+ * have at least one idle worker on return from this function.  If
+ * creating a new worker takes longer than MAYDAY_INTERVAL, mayday is
+ * sent to all rescuers with works scheduled on @gcwq to resolve
+ * possible allocation deadlock.
+ *
+ * On return, need_to_create_worker() is guaranteed to be false and
+ * may_start_working() true.
+ *
+ * LOCKING:
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * multiple times.  Does GFP_KERNEL allocations.  Called only from
+ * manager.
+ *
+ * RETURNS:
+ * false if no action was taken and gcwq->lock stayed locked, true
+ * otherwise.
+ */
+static bool maybe_create_worker(struct global_cwq *gcwq)
+{
+	if (!need_to_create_worker(gcwq))
+		return false;
+restart:
+	/* if we don't make progress in MAYDAY_INITIAL_TIMEOUT, call for help */
+	mod_timer(&gcwq->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
+
+	while (true) {
+		struct worker *worker;
+
+		spin_unlock_irq(&gcwq->lock);
+
+		worker = create_worker(gcwq, true);
+		if (worker) {
+			del_timer_sync(&gcwq->mayday_timer);
+			spin_lock_irq(&gcwq->lock);
+			start_worker(worker);
+			BUG_ON(need_to_create_worker(gcwq));
+			return true;
+		}
+
+		if (!need_to_create_worker(gcwq))
+			break;
+
+		spin_unlock_irq(&gcwq->lock);
+		__set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(CREATE_COOLDOWN);
+		spin_lock_irq(&gcwq->lock);
+		if (!need_to_create_worker(gcwq))
+			break;
+	}
+
+	spin_unlock_irq(&gcwq->lock);
+	del_timer_sync(&gcwq->mayday_timer);
+	spin_lock_irq(&gcwq->lock);
+	if (need_to_create_worker(gcwq))
+		goto restart;
+	return true;
+}
+
+/**
+ * maybe_destroy_worker - destroy workers which have been idle for a while
+ * @gcwq: gcwq to destroy workers for
+ *
+ * Destroy @gcwq workers which have been idle for longer than
+ * IDLE_WORKER_TIMEOUT.
+ *
+ * LOCKING:
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * multiple times.  Called only from manager.
+ *
+ * RETURNS:
+ * false if no action was taken and gcwq->lock stayed locked, true
+ * otherwise.
+ */
+static bool maybe_destroy_workers(struct global_cwq *gcwq)
+{
+	bool ret = false;
+
+	while (too_many_workers(gcwq)) {
+		struct worker *worker;
+		unsigned long expires;
+
+		worker = list_entry(gcwq->idle_list.prev, struct worker, entry);
+		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
+
+		if (time_before(jiffies, expires)) {
+			mod_timer(&gcwq->idle_timer, expires);
+			break;
+		}
+
+		destroy_worker(worker);
+		ret = true;
+	}
+
+	return ret;
+}
+
+/**
+ * manage_workers - manage worker pool
+ * @worker: self
+ *
+ * Assume the manager role and manage gcwq worker pool @worker belongs
+ * to.  At any given time, there can be only zero or one manager per
+ * gcwq.  The exclusion is handled automatically by this function.
+ *
+ * The caller can safely start processing works on false return.  On
+ * true return, it's guaranteed that need_to_create_worker() is false
+ * and may_start_working() is true.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * multiple times.  Does GFP_KERNEL allocations.
+ *
+ * RETURNS:
+ * false if no action was taken and gcwq->lock stayed locked, true if
+ * some action was taken.
+ */
+static bool manage_workers(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->gcwq;
+	bool ret = false;
+
+	if (gcwq->flags & GCWQ_MANAGING_WORKERS)
+		return ret;
+
+	gcwq->flags &= ~GCWQ_MANAGE_WORKERS;
+	gcwq->flags |= GCWQ_MANAGING_WORKERS;
+
+	/*
+	 * Destroy and then create so that may_start_working() is true
+	 * on return.
+	 */
+	ret |= maybe_destroy_workers(gcwq);
+	ret |= maybe_create_worker(gcwq);
+
+	gcwq->flags &= ~GCWQ_MANAGING_WORKERS;
+
+	/*
+	 * The trustee might be waiting to take over the manager
+	 * position, tell it we're done.
+	 */
+	if (unlikely(gcwq->trustee))
+		wake_up_all(&gcwq->trustee_wait);
+
+	return ret;
+}
+
 /**
  * move_linked_works - move linked works to a list
  * @work: start of series of works to be scheduled
@@ -1137,24 +1620,40 @@ static void process_scheduled_works(struct worker *worker)
  * worker_thread - the worker thread function
  * @__worker: self
  *
- * The cwq worker thread function.
+ * The gcwq worker thread function.  There's a single dynamic pool of
+ * these per each cpu.  These workers process all works regardless of
+ * their specific target workqueue.  The only exception is works which
+ * belong to workqueues with a rescuer which will be explained in
+ * rescuer_thread().
  */
 static int worker_thread(void *__worker)
 {
 	struct worker *worker = __worker;
 	struct global_cwq *gcwq = worker->gcwq;
+	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
 
+	/* tell the scheduler that this is a workqueue worker */
+	worker->task->flags |= PF_WQ_WORKER;
 woke_up:
 	spin_lock_irq(&gcwq->lock);
 
 	/* DIE can be set only while we're idle, checking here is enough */
 	if (worker->flags & WORKER_DIE) {
 		spin_unlock_irq(&gcwq->lock);
+		worker->task->flags &= ~PF_WQ_WORKER;
 		return 0;
 	}
 
 	worker_leave_idle(worker);
 recheck:
+	/* no more worker necessary? */
+	if (!need_more_worker(gcwq))
+		goto sleep;
+
+	/* do we need to manage? */
+	if (unlikely(!may_start_working(gcwq)) && manage_workers(worker))
+		goto recheck;
+
 	/*
 	 * ->scheduled list can only be filled while a worker is
 	 * preparing to process a work or actually processing it.
@@ -1162,27 +1661,20 @@ recheck:
 	 */
 	BUG_ON(!list_empty(&worker->scheduled));
 
-	while (!list_empty(&gcwq->worklist)) {
+	/*
+	 * When control reaches this point, we're guaranteed to have
+	 * at least one idle worker or that someone else has already
+	 * assumed the manager role.
+	 */
+	worker->flags &= ~WORKER_PREP;
+	if (likely(!(worker->flags & WORKER_IGN_RUNNING)))
+		atomic_inc(nr_running);
+
+	do {
 		struct work_struct *work =
 			list_first_entry(&gcwq->worklist,
 					 struct work_struct, entry);
 
-		/*
-		 * The following is a rather inefficient way to close
-		 * race window against cpu hotplug operations.  Will
-		 * be replaced soon.
-		 */
-		if (unlikely(!(worker->flags & WORKER_ROGUE) &&
-			     !cpumask_equal(&worker->task->cpus_allowed,
-					    get_cpu_mask(gcwq->cpu)))) {
-			spin_unlock_irq(&gcwq->lock);
-			set_cpus_allowed_ptr(worker->task,
-					     get_cpu_mask(gcwq->cpu));
-			cpu_relax();
-			spin_lock_irq(&gcwq->lock);
-			goto recheck;
-		}
-
 		if (likely(!(*work_data_bits(work) & WORK_STRUCT_LINKED))) {
 			/* optimization path, not strictly necessary */
 			process_one_work(worker, work);
@@ -1192,13 +1684,21 @@ recheck:
 			move_linked_works(work, &worker->scheduled, NULL);
 			process_scheduled_works(worker);
 		}
-	}
+	} while (keep_working(gcwq));
 
+	if (likely(!(worker->flags & WORKER_IGN_RUNNING)))
+		atomic_dec(nr_running);
+	worker->flags |= WORKER_PREP;
+
+	if (unlikely(need_to_manage_workers(gcwq)) && manage_workers(worker))
+		goto recheck;
+sleep:
 	/*
-	 * gcwq->lock is held and there's no work to process, sleep.
-	 * Workers are woken up only while holding gcwq->lock, so
-	 * setting the current state before releasing gcwq->lock is
-	 * enough to prevent losing any event.
+	 * gcwq->lock is held and there's no work to process and no
+	 * need to manage, sleep.  Workers are woken up only while
+	 * holding gcwq->lock or from local cpu, so setting the
+	 * current state before releasing gcwq->lock is enough to
+	 * prevent losing any event.
 	 */
 	worker_enter_idle(worker);
 	__set_current_state(TASK_INTERRUPTIBLE);
@@ -1207,6 +1707,68 @@ recheck:
 	goto woke_up;
 }
 
+/**
+ * rescuer_thread - the rescuer thread function
+ * @__wq: the associated workqueue
+ *
+ * Workqueue rescuer thread function.  There's one rescuer for each
+ * workqueue which has WQ_RESCUER set.
+ *
+ * Regular work processing on a gcwq may block trying to create a new
+ * worker which uses GFP_KERNEL allocation which has slight chance of
+ * developing into deadlock if some works currently on the same queue
+ * need to be processed to satisfy the GFP_KERNEL allocation.  This is
+ * the problem rescuer solves.
+ *
+ * When such condition is possible, the gcwq summons rescuers of all
+ * workqueues which have works queued on the gcwq and let them process
+ * those works so that forward progress can be guaranteed.
+ *
+ * This should happen rarely.
+ */
+static int rescuer_thread(void *__wq)
+{
+	struct workqueue_struct *wq = __wq;
+	struct worker *rescuer = wq->rescuer;
+	struct list_head *scheduled = &rescuer->scheduled;
+	unsigned int cpu;
+
+	set_user_nice(current, RESCUER_NICE_LEVEL);
+repeat:
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	if (kthread_should_stop())
+		return 0;
+
+	for_each_cpu(cpu, wq->mayday_mask) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		struct global_cwq *gcwq = cwq->gcwq;
+		struct work_struct *work, *n;
+
+		__set_current_state(TASK_RUNNING);
+		cpumask_clear_cpu(cpu, wq->mayday_mask);
+
+		/* migrate to the target cpu if possible */
+		rescuer->gcwq = gcwq;
+		worker_maybe_bind_and_lock(rescuer);
+
+		/*
+		 * Slurp in all works issued via this workqueue and
+		 * process'em.
+		 */
+		BUG_ON(!list_empty(&rescuer->scheduled));
+		list_for_each_entry_safe(work, n, &gcwq->worklist, entry)
+			if (get_work_cwq(work) == cwq)
+				move_linked_works(work, scheduled, &n);
+
+		process_scheduled_works(rescuer);
+		spin_unlock_irq(&gcwq->lock);
+	}
+
+	schedule();
+	goto repeat;
+}
+
 struct wq_barrier {
 	struct work_struct	work;
 	struct completion	done;
@@ -1960,7 +2522,6 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 						const char *lock_name)
 {
 	struct workqueue_struct *wq;
-	bool failed = false;
 	unsigned int cpu;
 
 	max_active = clamp_val(max_active, 1, INT_MAX);
@@ -1985,13 +2546,6 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
 
-	cpu_maps_update_begin();
-	/*
-	 * We must initialize cwqs for each possible cpu even if we
-	 * are going to call destroy_workqueue() finally. Otherwise
-	 * cpu_up() can hit the uninitialized cwq once we drop the
-	 * lock.
-	 */
 	for_each_possible_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		struct global_cwq *gcwq = get_gcwq(cpu);
@@ -2002,14 +2556,25 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		cwq->flush_color = -1;
 		cwq->max_active = max_active;
 		INIT_LIST_HEAD(&cwq->delayed_works);
+	}
 
-		if (failed)
-			continue;
-		cwq->worker = create_worker(gcwq, cpu_online(cpu));
-		if (cwq->worker)
-			start_worker(cwq->worker);
-		else
-			failed = true;
+	if (flags & WQ_RESCUER) {
+		struct worker *rescuer;
+
+		if (!alloc_cpumask_var(&wq->mayday_mask, GFP_KERNEL))
+			goto err;
+
+		wq->rescuer = rescuer = alloc_worker();
+		if (!rescuer)
+			goto err;
+
+		rescuer->task = kthread_create(rescuer_thread, wq, "%s", name);
+		if (IS_ERR(rescuer->task))
+			goto err;
+
+		wq->rescuer = rescuer;
+		rescuer->task->flags |= PF_THREAD_BOUND;
+		wake_up_process(rescuer->task);
 	}
 
 	/*
@@ -2027,16 +2592,12 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 
 	spin_unlock(&workqueue_lock);
 
-	cpu_maps_update_done();
-
-	if (failed) {
-		destroy_workqueue(wq);
-		wq = NULL;
-	}
 	return wq;
 err:
 	if (wq) {
 		free_cwqs(wq->cpu_wq);
+		free_cpumask_var(wq->mayday_mask);
+		kfree(wq->rescuer);
 		kfree(wq);
 	}
 	return NULL;
@@ -2059,42 +2620,26 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	 * wq list is used to freeze wq, remove from list after
 	 * flushing is complete in case freeze races us.
 	 */
-	cpu_maps_update_begin();
 	spin_lock(&workqueue_lock);
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
-	cpu_maps_update_done();
 
+	/* sanity check */
 	for_each_possible_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
-		struct global_cwq *gcwq = cwq->gcwq;
 		int i;
 
-		if (cwq->worker) {
-		retry:
-			spin_lock_irq(&gcwq->lock);
-			/*
-			 * Worker can only be destroyed while idle.
-			 * Wait till it becomes idle.  This is ugly
-			 * and prone to starvation.  It will go away
-			 * once dynamic worker pool is implemented.
-			 */
-			if (!(cwq->worker->flags & WORKER_IDLE)) {
-				spin_unlock_irq(&gcwq->lock);
-				msleep(100);
-				goto retry;
-			}
-			destroy_worker(cwq->worker);
-			cwq->worker = NULL;
-			spin_unlock_irq(&gcwq->lock);
-		}
-
 		for (i = 0; i < WORK_NR_COLORS; i++)
 			BUG_ON(cwq->nr_in_flight[i]);
 		BUG_ON(cwq->nr_active);
 		BUG_ON(!list_empty(&cwq->delayed_works));
 	}
 
+	if (wq->flags & WQ_RESCUER) {
+		kthread_stop(wq->rescuer->task);
+		free_cpumask_var(wq->mayday_mask);
+	}
+
 	free_cwqs(wq->cpu_wq);
 	kfree(wq);
 }
@@ -2103,10 +2648,18 @@ EXPORT_SYMBOL_GPL(destroy_workqueue);
 /*
  * CPU hotplug.
  *
- * CPU hotplug is implemented by allowing cwqs to be detached from
- * CPU, running with unbound workers and allowing them to be
- * reattached later if the cpu comes back online.  A separate thread
- * is created to govern cwqs in such state and is called the trustee.
+ * There are two challenges in supporting CPU hotplug.  Firstly, there
+ * are a lot of assumptions on strong associations among work, cwq and
+ * gcwq which make migrating pending and scheduled works very
+ * difficult to implement without impacting hot paths.  Secondly,
+ * gcwqs serve mix of short, long and very long running works making
+ * blocked draining impractical.
+ *
+ * This is solved by allowing a gcwq to be detached from CPU, running
+ * it with unbound (rogue) workers and allowing it to be reattached
+ * later if the cpu comes back online.  A separate thread is created
+ * to govern a gcwq in such state and is called the trustee of the
+ * gcwq.
  *
  * Trustee states and their descriptions.
  *
@@ -2114,11 +2667,12 @@ EXPORT_SYMBOL_GPL(destroy_workqueue);
  *		new trustee is started with this state.
  *
  * IN_CHARGE	Once started, trustee will enter this state after
- *		making all existing workers rogue.  DOWN_PREPARE waits
- *		for trustee to enter this state.  After reaching
- *		IN_CHARGE, trustee tries to execute the pending
- *		worklist until it's empty and the state is set to
- *		BUTCHER, or the state is set to RELEASE.
+ *		assuming the manager role and making all existing
+ *		workers rogue.  DOWN_PREPARE waits for trustee to
+ *		enter this state.  After reaching IN_CHARGE, trustee
+ *		tries to execute the pending worklist until it's empty
+ *		and the state is set to BUTCHER, or the state is set
+ *		to RELEASE.
  *
  * BUTCHER	Command state which is set by the cpu callback after
  *		the cpu has went down.  Once this state is set trustee
@@ -2129,7 +2683,9 @@ EXPORT_SYMBOL_GPL(destroy_workqueue);
  * RELEASE	Command state which is set by the cpu callback if the
  *		cpu down has been canceled or it has come online
  *		again.  After recognizing this state, trustee stops
- *		trying to drain or butcher and transits to DONE.
+ *		trying to drain or butcher and clears ROGUE, rebinds
+ *		all remaining workers back to the cpu and releases
+ *		manager role.
  *
  * DONE		Trustee will enter this state after BUTCHER or RELEASE
  *		is complete.
@@ -2194,18 +2750,26 @@ EXPORT_SYMBOL_GPL(destroy_workqueue);
 static int __cpuinit trustee_thread(void *__gcwq)
 {
 	struct global_cwq *gcwq = __gcwq;
+	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
 	struct worker *worker;
+	struct work_struct *work;
 	struct hlist_node *pos;
+	long rc;
 	int i;
 
 	BUG_ON(gcwq->cpu != smp_processor_id());
 
 	spin_lock_irq(&gcwq->lock);
 	/*
-	 * Make all workers rogue.  Trustee must be bound to the
-	 * target cpu and can't be cancelled.
+	 * Claim the manager position and make all workers rogue.
+	 * Trustee must be bound to the target cpu and can't be
+	 * cancelled.
 	 */
 	BUG_ON(gcwq->cpu != smp_processor_id());
+	rc = trustee_wait_event(!(gcwq->flags & GCWQ_MANAGING_WORKERS));
+	BUG_ON(rc < 0);
+
+	gcwq->flags |= GCWQ_MANAGING_WORKERS;
 
 	list_for_each_entry(worker, &gcwq->idle_list, entry)
 		worker->flags |= WORKER_ROGUE;
@@ -2214,6 +2778,28 @@ static int __cpuinit trustee_thread(void *__gcwq)
 		worker->flags |= WORKER_ROGUE;
 
 	/*
+	 * Call schedule() so that we cross rq->lock and thus can
+	 * guarantee sched callbacks see the rogue flag.  This is
+	 * necessary as scheduler callbacks may be invoked from other
+	 * cpus.
+	 */
+	spin_unlock_irq(&gcwq->lock);
+	schedule();
+	spin_lock_irq(&gcwq->lock);
+
+	/*
+	 * Sched callbacks are disabled now.  Zap nr_running.  After
+	 * this, gcwq->nr_running stays zero and need_more_worker()
+	 * and keep_working() are always true as long as the worklist
+	 * is not empty.
+	 */
+	atomic_set(nr_running, 0);
+
+	spin_unlock_irq(&gcwq->lock);
+	del_timer_sync(&gcwq->idle_timer);
+	spin_lock_irq(&gcwq->lock);
+
+	/*
 	 * We're now in charge.  Notify and proceed to drain.  We need
 	 * to keep the gcwq running during the whole CPU down
 	 * procedure as other cpu hotunplug callbacks may need to
@@ -2225,18 +2811,90 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	/*
 	 * The original cpu is in the process of dying and may go away
 	 * anytime now.  When that happens, we and all workers would
-	 * be migrated to other cpus.  Try draining any left work.
-	 * Note that if the gcwq is frozen, there may be frozen works
-	 * in freezeable cwqs.  Don't declare completion while frozen.
+	 * be migrated to other cpus.  Try draining any left work.  We
+	 * want to get it over with ASAP - spam rescuers, wake up as
+	 * many idlers as necessary and create new ones till the
+	 * worklist is empty.  Note that if the gcwq is frozen, there
+	 * may be frozen works in freezeable cwqs.  Don't declare
+	 * completion while frozen.
 	 */
 	while (gcwq->nr_workers != gcwq->nr_idle ||
 	       gcwq->flags & GCWQ_FREEZING ||
 	       gcwq->trustee_state == TRUSTEE_IN_CHARGE) {
+		int nr_works = 0;
+
+		list_for_each_entry(work, &gcwq->worklist, entry) {
+			send_mayday(work);
+			nr_works++;
+		}
+
+		list_for_each_entry(worker, &gcwq->idle_list, entry) {
+			if (!nr_works--)
+				break;
+			wake_up_process(worker->task);
+		}
+
+		if (need_to_create_worker(gcwq)) {
+			spin_unlock_irq(&gcwq->lock);
+			worker = create_worker(gcwq, false);
+			spin_lock_irq(&gcwq->lock);
+			if (worker) {
+				worker->flags |= WORKER_ROGUE;
+				start_worker(worker);
+			}
+		}
+
 		/* give a breather */
 		if (trustee_wait_event_timeout(false, TRUSTEE_COOLDOWN) < 0)
 			break;
 	}
 
+	/*
+	 * Either all works have been scheduled and cpu is down, or
+	 * cpu down has already been canceled.  Wait for and butcher
+	 * all workers till we're canceled.
+	 */
+	do {
+		rc = trustee_wait_event(!list_empty(&gcwq->idle_list));
+		while (!list_empty(&gcwq->idle_list))
+			destroy_worker(list_first_entry(&gcwq->idle_list,
+							struct worker, entry));
+	} while (gcwq->nr_workers && rc >= 0);
+
+	/*
+	 * At this point, either draining has completed and no worker
+	 * is left, or cpu down has been canceled or the cpu is being
+	 * brought back up.  There shouldn't be any idle one left.
+	 * Tell the remaining busy ones to rebind once it finishes the
+	 * currently scheduled works by scheduling the rebind_work.
+	 */
+	WARN_ON(!list_empty(&gcwq->idle_list));
+
+	for_each_busy_worker(worker, i, pos, gcwq) {
+		struct work_struct *rebind_work = &worker->rebind_work;
+
+		/*
+		 * Rebind_work may race with future cpu hotplug
+		 * operations.  Use a separate flag to mark that
+		 * rebinding is scheduled.
+		 */
+		worker->flags &= ~WORKER_ROGUE;
+		worker->flags |= WORKER_REBIND;
+
+		/* queue rebind_work, wq doesn't matter, use the default one */
+		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
+				     work_data_bits(rebind_work)))
+			continue;
+
+		debug_work_activate(rebind_work);
+		insert_work(get_cwq(gcwq->cpu, keventd_wq), rebind_work,
+			    worker->scheduled.next,
+			    work_color_to_flags(WORK_NO_COLOR));
+	}
+
+	/* relinquish manager role */
+	gcwq->flags &= ~GCWQ_MANAGING_WORKERS;
+
 	/* notify completion */
 	gcwq->trustee = NULL;
 	gcwq->trustee_state = TRUSTEE_DONE;
@@ -2275,10 +2933,8 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 	unsigned int cpu = (unsigned long)hcpu;
 	struct global_cwq *gcwq = get_gcwq(cpu);
 	struct task_struct *new_trustee = NULL;
-	struct worker *worker;
-	struct hlist_node *pos;
+	struct worker *uninitialized_var(new_worker);
 	unsigned long flags;
-	int i;
 
 	action &= ~CPU_TASKS_FROZEN;
 
@@ -2289,6 +2945,15 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		if (IS_ERR(new_trustee))
 			return notifier_from_errno(PTR_ERR(new_trustee));
 		kthread_bind(new_trustee, cpu);
+		/* fall through */
+	case CPU_UP_PREPARE:
+		BUG_ON(gcwq->first_idle);
+		new_worker = create_worker(gcwq, false);
+		if (!new_worker) {
+			if (new_trustee)
+				kthread_stop(new_trustee);
+			return NOTIFY_BAD;
+		}
 	}
 
 	/* some are called w/ irq disabled, don't disturb irq status */
@@ -2302,26 +2967,50 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		gcwq->trustee_state = TRUSTEE_START;
 		wake_up_process(gcwq->trustee);
 		wait_trustee_state(gcwq, TRUSTEE_IN_CHARGE);
+		/* fall through */
+	case CPU_UP_PREPARE:
+		BUG_ON(gcwq->first_idle);
+		gcwq->first_idle = new_worker;
+		break;
+
+	case CPU_DYING:
+		/*
+		 * Before this, the trustee and all workers except for
+		 * the ones which are still executing works from
+		 * before the last CPU down must be on the cpu.  After
+		 * this, they'll all be diasporas.
+		 */
+		gcwq->flags |= GCWQ_DISASSOCIATED;
 		break;
 
 	case CPU_POST_DEAD:
 		gcwq->trustee_state = TRUSTEE_BUTCHER;
+		/* fall through */
+	case CPU_UP_CANCELED:
+		destroy_worker(gcwq->first_idle);
+		gcwq->first_idle = NULL;
 		break;
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
+		gcwq->flags &= ~GCWQ_DISASSOCIATED;
 		if (gcwq->trustee_state != TRUSTEE_DONE) {
 			gcwq->trustee_state = TRUSTEE_RELEASE;
 			wake_up_process(gcwq->trustee);
 			wait_trustee_state(gcwq, TRUSTEE_DONE);
 		}
 
-		/* clear ROGUE from all workers */
-		list_for_each_entry(worker, &gcwq->idle_list, entry)
-			worker->flags &= ~WORKER_ROGUE;
-
-		for_each_busy_worker(worker, i, pos, gcwq)
-			worker->flags &= ~WORKER_ROGUE;
+		/*
+		 * Trustee is done and there might be no worker left.
+		 * Put the first_idle in and request a real manager to
+		 * take a look.
+		 */
+		spin_unlock_irq(&gcwq->lock);
+		kthread_bind(gcwq->first_idle->task, cpu);
+		spin_lock_irq(&gcwq->lock);
+		gcwq->flags |= GCWQ_MANAGE_WORKERS;
+		start_worker(gcwq->first_idle);
+		gcwq->first_idle = NULL;
 		break;
 	}
 
@@ -2510,10 +3199,10 @@ void thaw_workqueues(void)
 			if (wq->single_cpu == gcwq->cpu &&
 			    !cwq->nr_active && list_empty(&cwq->delayed_works))
 				cwq_unbind_single_cpu(cwq);
-
-			wake_up_process(cwq->worker->task);
 		}
 
+		wake_up_worker(gcwq);
+
 		spin_unlock_irq(&gcwq->lock);
 	}
 
@@ -2558,12 +3247,31 @@ void __init init_workqueues(void)
 		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)
 			INIT_HLIST_HEAD(&gcwq->busy_hash[i]);
 
+		init_timer_deferrable(&gcwq->idle_timer);
+		gcwq->idle_timer.function = idle_worker_timeout;
+		gcwq->idle_timer.data = (unsigned long)gcwq;
+
+		setup_timer(&gcwq->mayday_timer, gcwq_mayday_timeout,
+			    (unsigned long)gcwq);
+
 		ida_init(&gcwq->worker_ida);
 
 		gcwq->trustee_state = TRUSTEE_DONE;
 		init_waitqueue_head(&gcwq->trustee_wait);
 	}
 
+	/* create the initial worker */
+	for_each_online_cpu(cpu) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct worker *worker;
+
+		worker = create_worker(gcwq, true);
+		BUG_ON(!worker);
+		spin_lock_irq(&gcwq->lock);
+		start_worker(worker);
+		spin_unlock_irq(&gcwq->lock);
+	}
+
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
 }
diff --git a/kernel/workqueue_sched.h b/kernel/workqueue_sched.h
index af040ba..2d10fc9 100644
--- a/kernel/workqueue_sched.h
+++ b/kernel/workqueue_sched.h
@@ -4,13 +4,6 @@
  * Scheduler hooks for concurrency managed workqueue.  Only to be
  * included from sched.c and workqueue.c.
  */
-static inline void wq_worker_waking_up(struct task_struct *task,
-				       unsigned int cpu)
-{
-}
-
-static inline struct task_struct *wq_worker_sleeping(struct task_struct *task,
-						     unsigned int cpu)
-{
-	return NULL;
-}
+void wq_worker_waking_up(struct task_struct *task, unsigned int cpu);
+struct task_struct *wq_worker_sleeping(struct task_struct *task,
+				       unsigned int cpu);
-- 
1.6.4.2

