Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2F2XCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 19:02:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36094 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab2F2XCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 19:02:42 -0400
Date: Fri, 29 Jun 2012 16:02:37 -0700
From: Tejun Heo <tj@kernel.org>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: multi-second application stall in open()
Message-ID: <20120629230237.GF21048@google.com>
References: <20120626155332.GJ22557@redhat.com>
 <CAKA=qzYoX-1nTZ6QfdD7RhWf=KU7J6tWOJXgt-F+Kz2c3Xn0TQ@mail.gmail.com>
 <20120626205651.GW3869@google.com>
 <CAKA=qzbBtteDjHiPogCvN5jOSiPrDxx=vn96p02bXUy=6=jAgA@mail.gmail.com>
 <CAKA=qzaZweeeYUFD2OHDeAO-SQihSvExAZ=ZnXeY5o5sMWpxJg@mail.gmail.com>
 <CAKA=qzbaM-z7CbASUgq-A7CZWiUq6pdb93e4giYAw63hQK=MCg@mail.gmail.com>
 <20120627173822.GK15811@google.com>
 <CAKA=qzY5FT8rWU=z8DwGB7aF6AvCuT=bH2sOJQafyEPqtbkduQ@mail.gmail.com>
 <20120627175458.GL15811@google.com>
 <CAKA=qzaArsuwuuqHVKgTqwszY_Zx8d690e6UJsOQUvq_4--hjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKA=qzaArsuwuuqHVKgTqwszY_Zx8d690e6UJsOQUvq_4--hjQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Josh.

Can you please test the followign patch?  It's on top of 3.5-rc4.  It
seems to work here but is still quite experimental and may cause
crashes or alien invasion especially across cpu hotplugs.

Thanks.

Index: work/kernel/workqueue.c
===================================================================
--- work.orig/kernel/workqueue.c
+++ work/kernel/workqueue.c
@@ -46,11 +46,12 @@
 
 enum {
 	/* global_cwq flags */
-	GCWQ_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
-	GCWQ_MANAGING_WORKERS	= 1 << 1,	/* managing workers */
-	GCWQ_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
-	GCWQ_FREEZING		= 1 << 3,	/* freeze in progress */
-	GCWQ_HIGHPRI_PENDING	= 1 << 4,	/* highpri works on queue */
+	GCWQ_DISASSOCIATED	= 1 << 0,	/* cpu can't serve workers */
+	GCWQ_FREEZING		= 1 << 1,	/* freeze in progress */
+
+	/* pool flags */
+	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
+	POOL_MANAGING_WORKERS	= 1 << 1,	/* managing workers */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -72,6 +73,8 @@ enum {
 	TRUSTEE_RELEASE		= 3,		/* release workers */
 	TRUSTEE_DONE		= 4,		/* trustee is done */
 
+	NR_WORKER_POOLS		= 2,		/* # worker pools per gcwq */
+
 	BUSY_WORKER_HASH_ORDER	= 6,		/* 64 pointers */
 	BUSY_WORKER_HASH_SIZE	= 1 << BUSY_WORKER_HASH_ORDER,
 	BUSY_WORKER_HASH_MASK	= BUSY_WORKER_HASH_SIZE - 1,
@@ -91,6 +94,7 @@ enum {
 	 * all cpus.  Give -20.
 	 */
 	RESCUER_NICE_LEVEL	= -20,
+	HIGHPRI_NICE_LEVEL	= -20,
 };
 
 /*
@@ -115,6 +119,7 @@ enum {
  */
 
 struct global_cwq;
+struct worker_pool;
 
 /*
  * The poor guys doing the actual heavy lifting.  All on-duty workers
@@ -131,7 +136,7 @@ struct worker {
 	struct cpu_workqueue_struct *current_cwq; /* L: current_work's cwq */
 	struct list_head	scheduled;	/* L: scheduled works */
 	struct task_struct	*task;		/* I: worker task */
-	struct global_cwq	*gcwq;		/* I: the associated gcwq */
+	struct worker_pool	*pool;		/* I: the associated pool */
 	/* 64 bytes boundary on 64bit, 32 on 32bit */
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
@@ -139,6 +144,22 @@ struct worker {
 	struct work_struct	rebind_work;	/* L: rebind worker to cpu */
 };
 
+struct worker_pool {
+	struct global_cwq	*gcwq;		/* I: the owning gcwq */
+	unsigned int		flags;		/* X: flags */
+
+	struct list_head	worklist;	/* L: list of pending works */
+	int			nr_workers;	/* L: total number of workers */
+	int			nr_idle;	/* L: currently idle ones */
+
+	struct list_head	idle_list;	/* X: list of idle workers */
+	struct timer_list	idle_timer;	/* L: worker idle timeout */
+	struct timer_list	mayday_timer;	/* L: SOS timer for dworkers */
+
+	struct ida		worker_ida;	/* L: for worker IDs */
+	struct worker		*first_idle;	/* L: first idle worker */
+};
+
 /*
  * Global per-cpu workqueue.  There's one and only one for each cpu
  * and all works are queued and processed here regardless of their
@@ -146,27 +167,18 @@ struct worker {
  */
 struct global_cwq {
 	spinlock_t		lock;		/* the gcwq lock */
-	struct list_head	worklist;	/* L: list of pending works */
 	unsigned int		cpu;		/* I: the associated cpu */
 	unsigned int		flags;		/* L: GCWQ_* flags */
 
-	int			nr_workers;	/* L: total number of workers */
-	int			nr_idle;	/* L: currently idle ones */
-
-	/* workers are chained either in the idle_list or busy_hash */
-	struct list_head	idle_list;	/* X: list of idle workers */
+	/* workers are chained either in busy_head or pool idle_list */
 	struct hlist_head	busy_hash[BUSY_WORKER_HASH_SIZE];
 						/* L: hash of busy workers */
 
-	struct timer_list	idle_timer;	/* L: worker idle timeout */
-	struct timer_list	mayday_timer;	/* L: SOS timer for dworkers */
-
-	struct ida		worker_ida;	/* L: for worker IDs */
+	struct worker_pool	pools[2];	/* normal and highpri pools */
 
 	struct task_struct	*trustee;	/* L: for gcwq shutdown */
 	unsigned int		trustee_state;	/* L: trustee state */
 	wait_queue_head_t	trustee_wait;	/* trustee wait */
-	struct worker		*first_idle;	/* L: first idle worker */
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -175,7 +187,7 @@ struct global_cwq {
  * aligned at two's power of the number of flag bits.
  */
 struct cpu_workqueue_struct {
-	struct global_cwq	*gcwq;		/* I: the associated gcwq */
+	struct worker_pool	*pool;		/* I: the associated pool */
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	int			work_color;	/* L: current color */
 	int			flush_color;	/* L: flushing color */
@@ -264,6 +276,10 @@ EXPORT_SYMBOL_GPL(system_nrt_freezable_w
 #define CREATE_TRACE_POINTS
 #include <trace/events/workqueue.h>
 
+#define for_each_worker_pool(pool, gcwq)				\
+	for ((pool) = &(gcwq)->pools[0];				\
+	     (pool) != &(gcwq)->pools[NR_WORKER_POOLS]; (pool)++)
+
 #define for_each_busy_worker(worker, i, pos, gcwq)			\
 	for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)			\
 		hlist_for_each_entry(worker, pos, &gcwq->busy_hash[i], hentry)
@@ -444,7 +460,7 @@ static bool workqueue_freezing;		/* W: h
  * try_to_wake_up().  Put it in a separate cacheline.
  */
 static DEFINE_PER_CPU(struct global_cwq, global_cwq);
-static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, gcwq_nr_running);
+static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, pool_nr_running[NR_WORKER_POOLS]);
 
 /*
  * Global cpu workqueue and nr_running counter for unbound gcwq.  The
@@ -452,10 +468,17 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(ato
  * workers have WORKER_UNBOUND set.
  */
 static struct global_cwq unbound_global_cwq;
-static atomic_t unbound_gcwq_nr_running = ATOMIC_INIT(0);	/* always 0 */
+static atomic_t unbound_pool_nr_running[NR_WORKER_POOLS] = {
+	[0 ... NR_WORKER_POOLS - 1]	= ATOMIC_INIT(0),	/* always 0 */
+};
 
 static int worker_thread(void *__worker);
 
+static bool is_highpri_worker_pool(struct worker_pool *pool)
+{
+	return pool != &pool->gcwq->pools[0];
+}
+
 static struct global_cwq *get_gcwq(unsigned int cpu)
 {
 	if (cpu != WORK_CPU_UNBOUND)
@@ -464,12 +487,17 @@ static struct global_cwq *get_gcwq(unsig
 		return &unbound_global_cwq;
 }
 
-static atomic_t *get_gcwq_nr_running(unsigned int cpu)
+static atomic_t *get_pool_nr_running(struct worker_pool *pool)
 {
+	int cpu = pool->gcwq->cpu;
+	atomic_t (*nr_running)[NR_WORKER_POOLS];
+
 	if (cpu != WORK_CPU_UNBOUND)
-		return &per_cpu(gcwq_nr_running, cpu);
+		nr_running = &per_cpu(pool_nr_running, cpu);
 	else
-		return &unbound_gcwq_nr_running;
+		nr_running = &unbound_pool_nr_running;
+
+	return nr_running[is_highpri_worker_pool(pool)];
 }
 
 static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
@@ -555,7 +583,7 @@ static struct global_cwq *get_work_gcwq(
 
 	if (data & WORK_STRUCT_CWQ)
 		return ((struct cpu_workqueue_struct *)
-			(data & WORK_STRUCT_WQ_DATA_MASK))->gcwq;
+			(data & WORK_STRUCT_WQ_DATA_MASK))->pool->gcwq;
 
 	cpu = data >> WORK_STRUCT_FLAG_BITS;
 	if (cpu == WORK_CPU_NONE)
@@ -571,55 +599,56 @@ static struct global_cwq *get_work_gcwq(
  * assume that they're being called with gcwq->lock held.
  */
 
-static bool __need_more_worker(struct global_cwq *gcwq)
+static bool __need_more_worker(struct worker_pool *pool)
 {
-	return !atomic_read(get_gcwq_nr_running(gcwq->cpu)) ||
-		gcwq->flags & GCWQ_HIGHPRI_PENDING;
+	return !atomic_read(get_pool_nr_running(pool));
 }
 
 /*
  * Need to wake up a worker?  Called from anything but currently
  * running workers.
+ *
+ * Note that, because unbound workers never contribute to nr_running, this
+ * function will always return %true for unbound gcwq as long as the
+ * worklist isn't empty.
  */
-static bool need_more_worker(struct global_cwq *gcwq)
+static bool need_more_worker(struct worker_pool *pool)
 {
-	return !list_empty(&gcwq->worklist) && __need_more_worker(gcwq);
+	return !list_empty(&pool->worklist) && __need_more_worker(pool);
 }
 
 /* Can I start working?  Called from busy but !running workers. */
-static bool may_start_working(struct global_cwq *gcwq)
+static bool may_start_working(struct worker_pool *pool)
 {
-	return gcwq->nr_idle;
+	return pool->nr_idle;
 }
 
 /* Do I need to keep working?  Called from currently running workers. */
-static bool keep_working(struct global_cwq *gcwq)
+static bool keep_working(struct worker_pool *pool)
 {
-	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
+	atomic_t *nr_running = get_pool_nr_running(pool);
 
-	return !list_empty(&gcwq->worklist) &&
-		(atomic_read(nr_running) <= 1 ||
-		 gcwq->flags & GCWQ_HIGHPRI_PENDING);
+	return !list_empty(&pool->worklist) && atomic_read(nr_running) <= 1;
 }
 
 /* Do we need a new worker?  Called from manager. */
-static bool need_to_create_worker(struct global_cwq *gcwq)
+static bool need_to_create_worker(struct worker_pool *pool)
 {
-	return need_more_worker(gcwq) && !may_start_working(gcwq);
+	return need_more_worker(pool) && !may_start_working(pool);
 }
 
 /* Do I need to be the manager? */
-static bool need_to_manage_workers(struct global_cwq *gcwq)
+static bool need_to_manage_workers(struct worker_pool *pool)
 {
-	return need_to_create_worker(gcwq) || gcwq->flags & GCWQ_MANAGE_WORKERS;
+	return need_to_create_worker(pool) || pool->flags & POOL_MANAGE_WORKERS;
 }
 
 /* Do we have too many workers and should some go away? */
-static bool too_many_workers(struct global_cwq *gcwq)
+static bool too_many_workers(struct worker_pool *pool)
 {
-	bool managing = gcwq->flags & GCWQ_MANAGING_WORKERS;
-	int nr_idle = gcwq->nr_idle + managing; /* manager is considered idle */
-	int nr_busy = gcwq->nr_workers - nr_idle;
+	bool managing = pool->flags & POOL_MANAGING_WORKERS;
+	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
+	int nr_busy = pool->nr_workers - nr_idle;
 
 	return nr_idle > 2 && (nr_idle - 2) * MAX_IDLE_WORKERS_RATIO >= nr_busy;
 }
@@ -629,26 +658,26 @@ static bool too_many_workers(struct glob
  */
 
 /* Return the first worker.  Safe with preemption disabled */
-static struct worker *first_worker(struct global_cwq *gcwq)
+static struct worker *first_worker(struct worker_pool *pool)
 {
-	if (unlikely(list_empty(&gcwq->idle_list)))
+	if (unlikely(list_empty(&pool->idle_list)))
 		return NULL;
 
-	return list_first_entry(&gcwq->idle_list, struct worker, entry);
+	return list_first_entry(&pool->idle_list, struct worker, entry);
 }
 
 /**
  * wake_up_worker - wake up an idle worker
- * @gcwq: gcwq to wake worker for
+ * @pool: worker pool to wake worker from
  *
- * Wake up the first idle worker of @gcwq.
+ * Wake up the first idle worker of @pool.
  *
  * CONTEXT:
  * spin_lock_irq(gcwq->lock).
  */
-static void wake_up_worker(struct global_cwq *gcwq)
+static void wake_up_worker(struct worker_pool *pool)
 {
-	struct worker *worker = first_worker(gcwq);
+	struct worker *worker = first_worker(pool);
 
 	if (likely(worker))
 		wake_up_process(worker->task);
@@ -670,7 +699,7 @@ void wq_worker_waking_up(struct task_str
 	struct worker *worker = kthread_data(task);
 
 	if (!(worker->flags & WORKER_NOT_RUNNING))
-		atomic_inc(get_gcwq_nr_running(cpu));
+		atomic_inc(get_pool_nr_running(worker->pool));
 }
 
 /**
@@ -692,8 +721,8 @@ struct task_struct *wq_worker_sleeping(s
 				       unsigned int cpu)
 {
 	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
-	struct global_cwq *gcwq = get_gcwq(cpu);
-	atomic_t *nr_running = get_gcwq_nr_running(cpu);
+	struct worker_pool *pool = worker->pool;
+	atomic_t *nr_running = get_pool_nr_running(pool);
 
 	if (worker->flags & WORKER_NOT_RUNNING)
 		return NULL;
@@ -712,8 +741,8 @@ struct task_struct *wq_worker_sleeping(s
 	 * could be manipulating idle_list, so dereferencing idle_list
 	 * without gcwq lock is safe.
 	 */
-	if (atomic_dec_and_test(nr_running) && !list_empty(&gcwq->worklist))
-		to_wakeup = first_worker(gcwq);
+	if (atomic_dec_and_test(nr_running) && !list_empty(&pool->worklist))
+		to_wakeup = first_worker(pool);
 	return to_wakeup ? to_wakeup->task : NULL;
 }
 
@@ -733,7 +762,7 @@ struct task_struct *wq_worker_sleeping(s
 static inline void worker_set_flags(struct worker *worker, unsigned int flags,
 				    bool wakeup)
 {
-	struct global_cwq *gcwq = worker->gcwq;
+	struct worker_pool *pool = worker->pool;
 
 	WARN_ON_ONCE(worker->task != current);
 
@@ -744,12 +773,12 @@ static inline void worker_set_flags(stru
 	 */
 	if ((flags & WORKER_NOT_RUNNING) &&
 	    !(worker->flags & WORKER_NOT_RUNNING)) {
-		atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
+		atomic_t *nr_running = get_pool_nr_running(pool);
 
 		if (wakeup) {
 			if (atomic_dec_and_test(nr_running) &&
-			    !list_empty(&gcwq->worklist))
-				wake_up_worker(gcwq);
+			    !list_empty(&pool->worklist))
+				wake_up_worker(pool);
 		} else
 			atomic_dec(nr_running);
 	}
@@ -769,7 +798,7 @@ static inline void worker_set_flags(stru
  */
 static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
 {
-	struct global_cwq *gcwq = worker->gcwq;
+	struct worker_pool *pool = worker->pool;
 	unsigned int oflags = worker->flags;
 
 	WARN_ON_ONCE(worker->task != current);
@@ -783,7 +812,7 @@ static inline void worker_clr_flags(stru
 	 */
 	if ((flags & WORKER_NOT_RUNNING) && (oflags & WORKER_NOT_RUNNING))
 		if (!(worker->flags & WORKER_NOT_RUNNING))
-			atomic_inc(get_gcwq_nr_running(gcwq->cpu));
+			atomic_inc(get_pool_nr_running(pool));
 }
 
 /**
@@ -867,43 +896,6 @@ static struct worker *find_worker_execut
 }
 
 /**
- * gcwq_determine_ins_pos - find insertion position
- * @gcwq: gcwq of interest
- * @cwq: cwq a work is being queued for
- *
- * A work for @cwq is about to be queued on @gcwq, determine insertion
- * position for the work.  If @cwq is for HIGHPRI wq, the work is
- * queued at the head of the queue but in FIFO order with respect to
- * other HIGHPRI works; otherwise, at the end of the queue.  This
- * function also sets GCWQ_HIGHPRI_PENDING flag to hint @gcwq that
- * there are HIGHPRI works pending.
- *
- * CONTEXT:
- * spin_lock_irq(gcwq->lock).
- *
- * RETURNS:
- * Pointer to inserstion position.
- */
-static inline struct list_head *gcwq_determine_ins_pos(struct global_cwq *gcwq,
-					       struct cpu_workqueue_struct *cwq)
-{
-	struct work_struct *twork;
-
-	if (likely(!(cwq->wq->flags & WQ_HIGHPRI)))
-		return &gcwq->worklist;
-
-	list_for_each_entry(twork, &gcwq->worklist, entry) {
-		struct cpu_workqueue_struct *tcwq = get_work_cwq(twork);
-
-		if (!(tcwq->wq->flags & WQ_HIGHPRI))
-			break;
-	}
-
-	gcwq->flags |= GCWQ_HIGHPRI_PENDING;
-	return &twork->entry;
-}
-
-/**
  * insert_work - insert a work into gcwq
  * @cwq: cwq @work belongs to
  * @work: work to insert
@@ -920,7 +912,7 @@ static void insert_work(struct cpu_workq
 			struct work_struct *work, struct list_head *head,
 			unsigned int extra_flags)
 {
-	struct global_cwq *gcwq = cwq->gcwq;
+	struct worker_pool *pool = cwq->pool;
 
 	/* we own @work, set data and link */
 	set_work_cwq(work, cwq, extra_flags);
@@ -940,8 +932,8 @@ static void insert_work(struct cpu_workq
 	 */
 	smp_mb();
 
-	if (__need_more_worker(gcwq))
-		wake_up_worker(gcwq);
+	if (__need_more_worker(pool))
+		wake_up_worker(pool);
 }
 
 /*
@@ -1043,7 +1035,7 @@ static void __queue_work(unsigned int cp
 	if (likely(cwq->nr_active < cwq->max_active)) {
 		trace_workqueue_activate_work(work);
 		cwq->nr_active++;
-		worklist = gcwq_determine_ins_pos(gcwq, cwq);
+		worklist = &cwq->pool->worklist;
 	} else {
 		work_flags |= WORK_STRUCT_DELAYED;
 		worklist = &cwq->delayed_works;
@@ -1192,7 +1184,8 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on)
  */
 static void worker_enter_idle(struct worker *worker)
 {
-	struct global_cwq *gcwq = worker->gcwq;
+	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 
 	BUG_ON(worker->flags & WORKER_IDLE);
 	BUG_ON(!list_empty(&worker->entry) &&
@@ -1200,15 +1193,15 @@ static void worker_enter_idle(struct wor
 
 	/* can't use worker_set_flags(), also called from start_worker() */
 	worker->flags |= WORKER_IDLE;
-	gcwq->nr_idle++;
+	pool->nr_idle++;
 	worker->last_active = jiffies;
 
 	/* idle_list is LIFO */
-	list_add(&worker->entry, &gcwq->idle_list);
+	list_add(&worker->entry, &pool->idle_list);
 
 	if (likely(!(worker->flags & WORKER_ROGUE))) {
-		if (too_many_workers(gcwq) && !timer_pending(&gcwq->idle_timer))
-			mod_timer(&gcwq->idle_timer,
+		if (too_many_workers(pool) && !timer_pending(&pool->idle_timer))
+			mod_timer(&pool->idle_timer,
 				  jiffies + IDLE_WORKER_TIMEOUT);
 	} else
 		wake_up_all(&gcwq->trustee_wait);
@@ -1219,8 +1212,8 @@ static void worker_enter_idle(struct wor
 	 * warning may trigger spuriously.  Check iff trustee is idle.
 	 */
 	WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
-		     gcwq->nr_workers == gcwq->nr_idle &&
-		     atomic_read(get_gcwq_nr_running(gcwq->cpu)));
+		     pool->nr_workers == pool->nr_idle &&
+		     atomic_read(get_pool_nr_running(pool)));
 }
 
 /**
@@ -1234,11 +1227,11 @@ static void worker_enter_idle(struct wor
  */
 static void worker_leave_idle(struct worker *worker)
 {
-	struct global_cwq *gcwq = worker->gcwq;
+	struct worker_pool *pool = worker->pool;
 
 	BUG_ON(!(worker->flags & WORKER_IDLE));
 	worker_clr_flags(worker, WORKER_IDLE);
-	gcwq->nr_idle--;
+	pool->nr_idle--;
 	list_del_init(&worker->entry);
 }
 
@@ -1275,7 +1268,7 @@ static void worker_leave_idle(struct wor
 static bool worker_maybe_bind_and_lock(struct worker *worker)
 __acquires(&gcwq->lock)
 {
-	struct global_cwq *gcwq = worker->gcwq;
+	struct global_cwq *gcwq = worker->pool->gcwq;
 	struct task_struct *task = worker->task;
 
 	while (true) {
@@ -1317,7 +1310,7 @@ __acquires(&gcwq->lock)
 static void worker_rebind_fn(struct work_struct *work)
 {
 	struct worker *worker = container_of(work, struct worker, rebind_work);
-	struct global_cwq *gcwq = worker->gcwq;
+	struct global_cwq *gcwq = worker->pool->gcwq;
 
 	if (worker_maybe_bind_and_lock(worker))
 		worker_clr_flags(worker, WORKER_REBIND);
@@ -1342,10 +1335,10 @@ static struct worker *alloc_worker(void)
 
 /**
  * create_worker - create a new workqueue worker
- * @gcwq: gcwq the new worker will belong to
+ * @pool: pool the new worker will belong to
  * @bind: whether to set affinity to @cpu or not
  *
- * Create a new worker which is bound to @gcwq.  The returned worker
+ * Create a new worker which is bound to @pool.  The returned worker
  * can be started by calling start_worker() or destroyed using
  * destroy_worker().
  *
@@ -1355,16 +1348,18 @@ static struct worker *alloc_worker(void)
  * RETURNS:
  * Pointer to the newly created worker.
  */
-static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
+static struct worker *create_worker(struct worker_pool *pool, bool bind)
 {
+	struct global_cwq *gcwq = pool->gcwq;
 	bool on_unbound_cpu = gcwq->cpu == WORK_CPU_UNBOUND;
+	const char *pri = is_highpri_worker_pool(pool) ? "H" : "";
 	struct worker *worker = NULL;
 	int id = -1;
 
 	spin_lock_irq(&gcwq->lock);
-	while (ida_get_new(&gcwq->worker_ida, &id)) {
+	while (ida_get_new(&pool->worker_ida, &id)) {
 		spin_unlock_irq(&gcwq->lock);
-		if (!ida_pre_get(&gcwq->worker_ida, GFP_KERNEL))
+		if (!ida_pre_get(&pool->worker_ida, GFP_KERNEL))
 			goto fail;
 		spin_lock_irq(&gcwq->lock);
 	}
@@ -1374,20 +1369,22 @@ static struct worker *create_worker(stru
 	if (!worker)
 		goto fail;
 
-	worker->gcwq = gcwq;
+	worker->pool = pool;
 	worker->id = id;
 
 	if (!on_unbound_cpu)
 		worker->task = kthread_create_on_node(worker_thread,
-						      worker,
-						      cpu_to_node(gcwq->cpu),
-						      "kworker/%u:%d", gcwq->cpu, id);
+					worker, cpu_to_node(gcwq->cpu),
+					"kworker/%u:%d%s", gcwq->cpu, id, pri);
 	else
 		worker->task = kthread_create(worker_thread, worker,
-					      "kworker/u:%d", id);
+					      "kworker/u:%d%s", id, pri);
 	if (IS_ERR(worker->task))
 		goto fail;
 
+	if (is_highpri_worker_pool(pool))
+		set_user_nice(worker->task, HIGHPRI_NICE_LEVEL);
+
 	/*
 	 * A rogue worker will become a regular one if CPU comes
 	 * online later on.  Make sure every worker has
@@ -1405,7 +1402,7 @@ static struct worker *create_worker(stru
 fail:
 	if (id >= 0) {
 		spin_lock_irq(&gcwq->lock);
-		ida_remove(&gcwq->worker_ida, id);
+		ida_remove(&pool->worker_ida, id);
 		spin_unlock_irq(&gcwq->lock);
 	}
 	kfree(worker);
@@ -1424,7 +1421,7 @@ fail:
 static void start_worker(struct worker *worker)
 {
 	worker->flags |= WORKER_STARTED;
-	worker->gcwq->nr_workers++;
+	worker->pool->nr_workers++;
 	worker_enter_idle(worker);
 	wake_up_process(worker->task);
 }
@@ -1440,7 +1437,8 @@ static void start_worker(struct worker *
  */
 static void destroy_worker(struct worker *worker)
 {
-	struct global_cwq *gcwq = worker->gcwq;
+	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 	int id = worker->id;
 
 	/* sanity check frenzy */
@@ -1448,9 +1446,9 @@ static void destroy_worker(struct worker
 	BUG_ON(!list_empty(&worker->scheduled));
 
 	if (worker->flags & WORKER_STARTED)
-		gcwq->nr_workers--;
+		pool->nr_workers--;
 	if (worker->flags & WORKER_IDLE)
-		gcwq->nr_idle--;
+		pool->nr_idle--;
 
 	list_del_init(&worker->entry);
 	worker->flags |= WORKER_DIE;
@@ -1461,29 +1459,30 @@ static void destroy_worker(struct worker
 	kfree(worker);
 
 	spin_lock_irq(&gcwq->lock);
-	ida_remove(&gcwq->worker_ida, id);
+	ida_remove(&pool->worker_ida, id);
 }
 
-static void idle_worker_timeout(unsigned long __gcwq)
+static void idle_worker_timeout(unsigned long __pool)
 {
-	struct global_cwq *gcwq = (void *)__gcwq;
+	struct worker_pool *pool = (void *)__pool;
+	struct global_cwq *gcwq = pool->gcwq;
 
 	spin_lock_irq(&gcwq->lock);
 
-	if (too_many_workers(gcwq)) {
+	if (too_many_workers(pool)) {
 		struct worker *worker;
 		unsigned long expires;
 
 		/* idle_list is kept in LIFO order, check the last one */
-		worker = list_entry(gcwq->idle_list.prev, struct worker, entry);
+		worker = list_entry(pool->idle_list.prev, struct worker, entry);
 		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
 
 		if (time_before(jiffies, expires))
-			mod_timer(&gcwq->idle_timer, expires);
+			mod_timer(&pool->idle_timer, expires);
 		else {
 			/* it's been idle for too long, wake up manager */
-			gcwq->flags |= GCWQ_MANAGE_WORKERS;
-			wake_up_worker(gcwq);
+			pool->flags |= POOL_MANAGE_WORKERS;
+			wake_up_worker(pool);
 		}
 	}
 
@@ -1500,7 +1499,7 @@ static bool send_mayday(struct work_stru
 		return false;
 
 	/* mayday mayday mayday */
-	cpu = cwq->gcwq->cpu;
+	cpu = cwq->pool->gcwq->cpu;
 	/* WORK_CPU_UNBOUND can't be set in cpumask, use cpu 0 instead */
 	if (cpu == WORK_CPU_UNBOUND)
 		cpu = 0;
@@ -1509,37 +1508,38 @@ static bool send_mayday(struct work_stru
 	return true;
 }
 
-static void gcwq_mayday_timeout(unsigned long __gcwq)
+static void gcwq_mayday_timeout(unsigned long __pool)
 {
-	struct global_cwq *gcwq = (void *)__gcwq;
+	struct worker_pool *pool = (void *)__pool;
+	struct global_cwq *gcwq = pool->gcwq;
 	struct work_struct *work;
 
 	spin_lock_irq(&gcwq->lock);
 
-	if (need_to_create_worker(gcwq)) {
+	if (need_to_create_worker(pool)) {
 		/*
 		 * We've been trying to create a new worker but
 		 * haven't been successful.  We might be hitting an
 		 * allocation deadlock.  Send distress signals to
 		 * rescuers.
 		 */
-		list_for_each_entry(work, &gcwq->worklist, entry)
+		list_for_each_entry(work, &pool->worklist, entry)
 			send_mayday(work);
 	}
 
 	spin_unlock_irq(&gcwq->lock);
 
-	mod_timer(&gcwq->mayday_timer, jiffies + MAYDAY_INTERVAL);
+	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
 }
 
 /**
  * maybe_create_worker - create a new worker if necessary
- * @gcwq: gcwq to create a new worker for
+ * @pool: pool to create a new worker for
  *
- * Create a new worker for @gcwq if necessary.  @gcwq is guaranteed to
+ * Create a new worker for @pool if necessary.  @pool is guaranteed to
  * have at least one idle worker on return from this function.  If
  * creating a new worker takes longer than MAYDAY_INTERVAL, mayday is
- * sent to all rescuers with works scheduled on @gcwq to resolve
+ * sent to all rescuers with works scheduled on @pool to resolve
  * possible allocation deadlock.
  *
  * On return, need_to_create_worker() is guaranteed to be false and
@@ -1554,52 +1554,54 @@ static void gcwq_mayday_timeout(unsigned
  * false if no action was taken and gcwq->lock stayed locked, true
  * otherwise.
  */
-static bool maybe_create_worker(struct global_cwq *gcwq)
+static bool maybe_create_worker(struct worker_pool *pool)
 __releases(&gcwq->lock)
 __acquires(&gcwq->lock)
 {
-	if (!need_to_create_worker(gcwq))
+	struct global_cwq *gcwq = pool->gcwq;
+
+	if (!need_to_create_worker(pool))
 		return false;
 restart:
 	spin_unlock_irq(&gcwq->lock);
 
 	/* if we don't make progress in MAYDAY_INITIAL_TIMEOUT, call for help */
-	mod_timer(&gcwq->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
+	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
 
 	while (true) {
 		struct worker *worker;
 
-		worker = create_worker(gcwq, true);
+		worker = create_worker(pool, true);
 		if (worker) {
-			del_timer_sync(&gcwq->mayday_timer);
+			del_timer_sync(&pool->mayday_timer);
 			spin_lock_irq(&gcwq->lock);
 			start_worker(worker);
-			BUG_ON(need_to_create_worker(gcwq));
+			BUG_ON(need_to_create_worker(pool));
 			return true;
 		}
 
-		if (!need_to_create_worker(gcwq))
+		if (!need_to_create_worker(pool))
 			break;
 
 		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(CREATE_COOLDOWN);
 
-		if (!need_to_create_worker(gcwq))
+		if (!need_to_create_worker(pool))
 			break;
 	}
 
-	del_timer_sync(&gcwq->mayday_timer);
+	del_timer_sync(&pool->mayday_timer);
 	spin_lock_irq(&gcwq->lock);
-	if (need_to_create_worker(gcwq))
+	if (need_to_create_worker(pool))
 		goto restart;
 	return true;
 }
 
 /**
  * maybe_destroy_worker - destroy workers which have been idle for a while
- * @gcwq: gcwq to destroy workers for
+ * @pool: pool to destroy workers for
  *
- * Destroy @gcwq workers which have been idle for longer than
+ * Destroy @pool workers which have been idle for longer than
  * IDLE_WORKER_TIMEOUT.
  *
  * LOCKING:
@@ -1610,19 +1612,19 @@ restart:
  * false if no action was taken and gcwq->lock stayed locked, true
  * otherwise.
  */
-static bool maybe_destroy_workers(struct global_cwq *gcwq)
+static bool maybe_destroy_workers(struct worker_pool *pool)
 {
 	bool ret = false;
 
-	while (too_many_workers(gcwq)) {
+	while (too_many_workers(pool)) {
 		struct worker *worker;
 		unsigned long expires;
 
-		worker = list_entry(gcwq->idle_list.prev, struct worker, entry);
+		worker = list_entry(pool->idle_list.prev, struct worker, entry);
 		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
 
 		if (time_before(jiffies, expires)) {
-			mod_timer(&gcwq->idle_timer, expires);
+			mod_timer(&pool->idle_timer, expires);
 			break;
 		}
 
@@ -1655,23 +1657,24 @@ static bool maybe_destroy_workers(struct
  */
 static bool manage_workers(struct worker *worker)
 {
-	struct global_cwq *gcwq = worker->gcwq;
+	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 	bool ret = false;
 
-	if (gcwq->flags & GCWQ_MANAGING_WORKERS)
+	if (pool->flags & POOL_MANAGING_WORKERS)
 		return ret;
 
-	gcwq->flags &= ~GCWQ_MANAGE_WORKERS;
-	gcwq->flags |= GCWQ_MANAGING_WORKERS;
+	pool->flags &= ~POOL_MANAGE_WORKERS;
+	pool->flags |= POOL_MANAGING_WORKERS;
 
 	/*
 	 * Destroy and then create so that may_start_working() is true
 	 * on return.
 	 */
-	ret |= maybe_destroy_workers(gcwq);
-	ret |= maybe_create_worker(gcwq);
+	ret |= maybe_destroy_workers(pool);
+	ret |= maybe_create_worker(pool);
 
-	gcwq->flags &= ~GCWQ_MANAGING_WORKERS;
+	pool->flags &= ~POOL_MANAGING_WORKERS;
 
 	/*
 	 * The trustee might be waiting to take over the manager
@@ -1728,10 +1731,9 @@ static void cwq_activate_first_delayed(s
 {
 	struct work_struct *work = list_first_entry(&cwq->delayed_works,
 						    struct work_struct, entry);
-	struct list_head *pos = gcwq_determine_ins_pos(cwq->gcwq, cwq);
 
 	trace_workqueue_activate_work(work);
-	move_linked_works(work, pos, NULL);
+	move_linked_works(work, &cwq->pool->worklist, NULL);
 	__clear_bit(WORK_STRUCT_DELAYED_BIT, work_data_bits(work));
 	cwq->nr_active++;
 }
@@ -1804,7 +1806,8 @@ __releases(&gcwq->lock)
 __acquires(&gcwq->lock)
 {
 	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
-	struct global_cwq *gcwq = cwq->gcwq;
+	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 	struct hlist_head *bwh = busy_worker_head(gcwq, work);
 	bool cpu_intensive = cwq->wq->flags & WQ_CPU_INTENSIVE;
 	work_func_t f = work->func;
@@ -1846,27 +1849,19 @@ __acquires(&gcwq->lock)
 	list_del_init(&work->entry);
 
 	/*
-	 * If HIGHPRI_PENDING, check the next work, and, if HIGHPRI,
-	 * wake up another worker; otherwise, clear HIGHPRI_PENDING.
-	 */
-	if (unlikely(gcwq->flags & GCWQ_HIGHPRI_PENDING)) {
-		struct work_struct *nwork = list_first_entry(&gcwq->worklist,
-						struct work_struct, entry);
-
-		if (!list_empty(&gcwq->worklist) &&
-		    get_work_cwq(nwork)->wq->flags & WQ_HIGHPRI)
-			wake_up_worker(gcwq);
-		else
-			gcwq->flags &= ~GCWQ_HIGHPRI_PENDING;
-	}
-
-	/*
 	 * CPU intensive works don't participate in concurrency
 	 * management.  They're the scheduler's responsibility.
 	 */
 	if (unlikely(cpu_intensive))
 		worker_set_flags(worker, WORKER_CPU_INTENSIVE, true);
 
+	/*
+	 * Unbound gcwq isn't concurrency managed and work items should be
+	 * executed ASAP.  Wake up another worker if necessary.
+	 */
+	if ((worker->flags & WORKER_UNBOUND) && need_more_worker(pool))
+		wake_up_worker(pool);
+
 	spin_unlock_irq(&gcwq->lock);
 
 	work_clear_pending(work);
@@ -1939,7 +1934,8 @@ static void process_scheduled_works(stru
 static int worker_thread(void *__worker)
 {
 	struct worker *worker = __worker;
-	struct global_cwq *gcwq = worker->gcwq;
+	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 
 	/* tell the scheduler that this is a workqueue worker */
 	worker->task->flags |= PF_WQ_WORKER;
@@ -1956,11 +1952,11 @@ woke_up:
 	worker_leave_idle(worker);
 recheck:
 	/* no more worker necessary? */
-	if (!need_more_worker(gcwq))
+	if (!need_more_worker(pool))
 		goto sleep;
 
 	/* do we need to manage? */
-	if (unlikely(!may_start_working(gcwq)) && manage_workers(worker))
+	if (unlikely(!may_start_working(pool)) && manage_workers(worker))
 		goto recheck;
 
 	/*
@@ -1979,7 +1975,7 @@ recheck:
 
 	do {
 		struct work_struct *work =
-			list_first_entry(&gcwq->worklist,
+			list_first_entry(&pool->worklist,
 					 struct work_struct, entry);
 
 		if (likely(!(*work_data_bits(work) & WORK_STRUCT_LINKED))) {
@@ -1991,11 +1987,11 @@ recheck:
 			move_linked_works(work, &worker->scheduled, NULL);
 			process_scheduled_works(worker);
 		}
-	} while (keep_working(gcwq));
+	} while (keep_working(pool));
 
 	worker_set_flags(worker, WORKER_PREP, false);
 sleep:
-	if (unlikely(need_to_manage_workers(gcwq)) && manage_workers(worker))
+	if (unlikely(need_to_manage_workers(pool)) && manage_workers(worker))
 		goto recheck;
 
 	/*
@@ -2053,14 +2049,15 @@ repeat:
 	for_each_mayday_cpu(cpu, wq->mayday_mask) {
 		unsigned int tcpu = is_unbound ? WORK_CPU_UNBOUND : cpu;
 		struct cpu_workqueue_struct *cwq = get_cwq(tcpu, wq);
-		struct global_cwq *gcwq = cwq->gcwq;
+		struct worker_pool *pool = cwq->pool;
+		struct global_cwq *gcwq = pool->gcwq;
 		struct work_struct *work, *n;
 
 		__set_current_state(TASK_RUNNING);
 		mayday_clear_cpu(cpu, wq->mayday_mask);
 
 		/* migrate to the target cpu if possible */
-		rescuer->gcwq = gcwq;
+		rescuer->pool = pool;
 		worker_maybe_bind_and_lock(rescuer);
 
 		/*
@@ -2068,7 +2065,7 @@ repeat:
 		 * process'em.
 		 */
 		BUG_ON(!list_empty(&rescuer->scheduled));
-		list_for_each_entry_safe(work, n, &gcwq->worklist, entry)
+		list_for_each_entry_safe(work, n, &pool->worklist, entry)
 			if (get_work_cwq(work) == cwq)
 				move_linked_works(work, scheduled, &n);
 
@@ -2079,8 +2076,8 @@ repeat:
 		 * regular worker; otherwise, we end up with 0 concurrency
 		 * and stalling the execution.
 		 */
-		if (keep_working(gcwq))
-			wake_up_worker(gcwq);
+		if (keep_working(pool))
+			wake_up_worker(pool);
 
 		spin_unlock_irq(&gcwq->lock);
 	}
@@ -2205,7 +2202,7 @@ static bool flush_workqueue_prep_cwqs(st
 
 	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
-		struct global_cwq *gcwq = cwq->gcwq;
+		struct global_cwq *gcwq = cwq->pool->gcwq;
 
 		spin_lock_irq(&gcwq->lock);
 
@@ -2421,9 +2418,9 @@ reflush:
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		bool drained;
 
-		spin_lock_irq(&cwq->gcwq->lock);
+		spin_lock_irq(&cwq->pool->gcwq->lock);
 		drained = !cwq->nr_active && list_empty(&cwq->delayed_works);
-		spin_unlock_irq(&cwq->gcwq->lock);
+		spin_unlock_irq(&cwq->pool->gcwq->lock);
 
 		if (drained)
 			continue;
@@ -2463,7 +2460,7 @@ static bool start_flush_work(struct work
 		 */
 		smp_rmb();
 		cwq = get_work_cwq(work);
-		if (unlikely(!cwq || gcwq != cwq->gcwq))
+		if (unlikely(!cwq || gcwq != cwq->pool->gcwq))
 			goto already_gone;
 	} else if (wait_executing) {
 		worker = find_worker_executing_work(gcwq, work);
@@ -2984,13 +2981,6 @@ struct workqueue_struct *__alloc_workque
 	if (flags & WQ_MEM_RECLAIM)
 		flags |= WQ_RESCUER;
 
-	/*
-	 * Unbound workqueues aren't concurrency managed and should be
-	 * dispatched to workers immediately.
-	 */
-	if (flags & WQ_UNBOUND)
-		flags |= WQ_HIGHPRI;
-
 	max_active = max_active ?: WQ_DFL_ACTIVE;
 	max_active = wq_clamp_max_active(max_active, flags, wq->name);
 
@@ -3011,9 +3001,10 @@ struct workqueue_struct *__alloc_workque
 	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		struct global_cwq *gcwq = get_gcwq(cpu);
+		int pool_idx = (bool)(flags & WQ_HIGHPRI);
 
 		BUG_ON((unsigned long)cwq & WORK_STRUCT_FLAG_MASK);
-		cwq->gcwq = gcwq;
+		cwq->pool = &gcwq->pools[pool_idx];
 		cwq->wq = wq;
 		cwq->flush_color = -1;
 		cwq->max_active = max_active;
@@ -3317,9 +3308,30 @@ EXPORT_SYMBOL_GPL(work_busy);
 	__ret1 < 0 ? -1 : 0;						\
 })
 
+static bool gcwq_managing_workers(struct global_cwq *gcwq)
+{
+	struct worker_pool *pool;
+
+	for_each_worker_pool(pool, gcwq)
+		if (pool->flags & POOL_MANAGING_WORKERS)
+			return true;
+	return false;
+}
+
+static bool gcwq_has_idle_workers(struct global_cwq *gcwq)
+{
+	struct worker_pool *pool;
+
+	for_each_worker_pool(pool, gcwq)
+		if (!list_empty(&pool->idle_list))
+			return true;
+	return false;
+}
+
 static int __cpuinit trustee_thread(void *__gcwq)
 {
 	struct global_cwq *gcwq = __gcwq;
+	struct worker_pool *pool;
 	struct worker *worker;
 	struct work_struct *work;
 	struct hlist_node *pos;
@@ -3335,13 +3347,15 @@ static int __cpuinit trustee_thread(void
 	 * cancelled.
 	 */
 	BUG_ON(gcwq->cpu != smp_processor_id());
-	rc = trustee_wait_event(!(gcwq->flags & GCWQ_MANAGING_WORKERS));
+	rc = trustee_wait_event(!gcwq_managing_workers(gcwq));
 	BUG_ON(rc < 0);
 
-	gcwq->flags |= GCWQ_MANAGING_WORKERS;
+	for_each_worker_pool(pool, gcwq) {
+		pool->flags |= POOL_MANAGING_WORKERS;
 
-	list_for_each_entry(worker, &gcwq->idle_list, entry)
-		worker->flags |= WORKER_ROGUE;
+		list_for_each_entry(worker, &pool->idle_list, entry)
+			worker->flags |= WORKER_ROGUE;
+	}
 
 	for_each_busy_worker(worker, i, pos, gcwq)
 		worker->flags |= WORKER_ROGUE;
@@ -3362,10 +3376,12 @@ static int __cpuinit trustee_thread(void
 	 * keep_working() are always true as long as the worklist is
 	 * not empty.
 	 */
-	atomic_set(get_gcwq_nr_running(gcwq->cpu), 0);
+	for_each_worker_pool(pool, gcwq)
+		atomic_set(get_pool_nr_running(pool), 0);
 
 	spin_unlock_irq(&gcwq->lock);
-	del_timer_sync(&gcwq->idle_timer);
+	for_each_worker_pool(pool, gcwq)
+		del_timer_sync(&pool->idle_timer);
 	spin_lock_irq(&gcwq->lock);
 
 	/*
@@ -3387,29 +3403,38 @@ static int __cpuinit trustee_thread(void
 	 * may be frozen works in freezable cwqs.  Don't declare
 	 * completion while frozen.
 	 */
-	while (gcwq->nr_workers != gcwq->nr_idle ||
-	       gcwq->flags & GCWQ_FREEZING ||
-	       gcwq->trustee_state == TRUSTEE_IN_CHARGE) {
-		int nr_works = 0;
+	while (true) {
+		bool busy = false;
 
-		list_for_each_entry(work, &gcwq->worklist, entry) {
-			send_mayday(work);
-			nr_works++;
-		}
+		for_each_worker_pool(pool, gcwq)
+			busy |= pool->nr_workers != pool->nr_idle;
 
-		list_for_each_entry(worker, &gcwq->idle_list, entry) {
-			if (!nr_works--)
-				break;
-			wake_up_process(worker->task);
-		}
+		if (!busy && !(gcwq->flags & GCWQ_FREEZING) &&
+		    gcwq->trustee_state != TRUSTEE_IN_CHARGE)
+			break;
 
-		if (need_to_create_worker(gcwq)) {
-			spin_unlock_irq(&gcwq->lock);
-			worker = create_worker(gcwq, false);
-			spin_lock_irq(&gcwq->lock);
-			if (worker) {
-				worker->flags |= WORKER_ROGUE;
-				start_worker(worker);
+		for_each_worker_pool(pool, gcwq) {
+			int nr_works = 0;
+
+			list_for_each_entry(work, &pool->worklist, entry) {
+				send_mayday(work);
+				nr_works++;
+			}
+
+			list_for_each_entry(worker, &pool->idle_list, entry) {
+				if (!nr_works--)
+					break;
+				wake_up_process(worker->task);
+			}
+
+			if (need_to_create_worker(pool)) {
+				spin_unlock_irq(&gcwq->lock);
+				worker = create_worker(pool, false);
+				spin_lock_irq(&gcwq->lock);
+				if (worker) {
+					worker->flags |= WORKER_ROGUE;
+					start_worker(worker);
+				}
 			}
 		}
 
@@ -3424,11 +3449,18 @@ static int __cpuinit trustee_thread(void
 	 * all workers till we're canceled.
 	 */
 	do {
-		rc = trustee_wait_event(!list_empty(&gcwq->idle_list));
-		while (!list_empty(&gcwq->idle_list))
-			destroy_worker(list_first_entry(&gcwq->idle_list,
-							struct worker, entry));
-	} while (gcwq->nr_workers && rc >= 0);
+		rc = trustee_wait_event(gcwq_has_idle_workers(gcwq));
+
+		i = 0;
+		for_each_worker_pool(pool, gcwq) {
+			while (!list_empty(&pool->idle_list)) {
+				worker = list_first_entry(&pool->idle_list,
+							  struct worker, entry);
+				destroy_worker(worker);
+			}
+			i |= pool->nr_workers;
+		}
+	} while (i || rc < 0);
 
 	/*
 	 * At this point, either draining has completed and no worker
@@ -3437,7 +3469,8 @@ static int __cpuinit trustee_thread(void
 	 * Tell the remaining busy ones to rebind once it finishes the
 	 * currently scheduled works by scheduling the rebind_work.
 	 */
-	WARN_ON(!list_empty(&gcwq->idle_list));
+	for_each_worker_pool(pool, gcwq)
+		WARN_ON(!list_empty(&pool->idle_list));
 
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
@@ -3462,7 +3495,8 @@ static int __cpuinit trustee_thread(void
 	}
 
 	/* relinquish manager role */
-	gcwq->flags &= ~GCWQ_MANAGING_WORKERS;
+	for_each_worker_pool(pool, gcwq)
+		pool->flags &= ~POOL_MANAGING_WORKERS;
 
 	/* notify completion */
 	gcwq->trustee = NULL;
@@ -3504,8 +3538,10 @@ static int __devinit workqueue_cpu_callb
 	unsigned int cpu = (unsigned long)hcpu;
 	struct global_cwq *gcwq = get_gcwq(cpu);
 	struct task_struct *new_trustee = NULL;
-	struct worker *uninitialized_var(new_worker);
+	struct worker *new_workers[NR_WORKER_POOLS] = { };
+	struct worker_pool *pool;
 	unsigned long flags;
+	int i;
 
 	action &= ~CPU_TASKS_FROZEN;
 
@@ -3518,12 +3554,13 @@ static int __devinit workqueue_cpu_callb
 		kthread_bind(new_trustee, cpu);
 		/* fall through */
 	case CPU_UP_PREPARE:
-		BUG_ON(gcwq->first_idle);
-		new_worker = create_worker(gcwq, false);
-		if (!new_worker) {
-			if (new_trustee)
-				kthread_stop(new_trustee);
-			return NOTIFY_BAD;
+		i = 0;
+		for_each_worker_pool(pool, gcwq) {
+			BUG_ON(pool->first_idle);
+			new_workers[i] = create_worker(pool, false);
+			if (!new_workers[i])
+				goto err_destroy;
+			i++;
 		}
 	}
 
@@ -3540,8 +3577,11 @@ static int __devinit workqueue_cpu_callb
 		wait_trustee_state(gcwq, TRUSTEE_IN_CHARGE);
 		/* fall through */
 	case CPU_UP_PREPARE:
-		BUG_ON(gcwq->first_idle);
-		gcwq->first_idle = new_worker;
+		i = 0;
+		for_each_worker_pool(pool, gcwq) {
+			BUG_ON(pool->first_idle);
+			pool->first_idle = new_workers[i++];
+		}
 		break;
 
 	case CPU_DYING:
@@ -3558,8 +3598,10 @@ static int __devinit workqueue_cpu_callb
 		gcwq->trustee_state = TRUSTEE_BUTCHER;
 		/* fall through */
 	case CPU_UP_CANCELED:
-		destroy_worker(gcwq->first_idle);
-		gcwq->first_idle = NULL;
+		for_each_worker_pool(pool, gcwq) {
+			destroy_worker(pool->first_idle);
+			pool->first_idle = NULL;
+		}
 		break;
 
 	case CPU_DOWN_FAILED:
@@ -3576,18 +3618,32 @@ static int __devinit workqueue_cpu_callb
 		 * Put the first_idle in and request a real manager to
 		 * take a look.
 		 */
-		spin_unlock_irq(&gcwq->lock);
-		kthread_bind(gcwq->first_idle->task, cpu);
-		spin_lock_irq(&gcwq->lock);
-		gcwq->flags |= GCWQ_MANAGE_WORKERS;
-		start_worker(gcwq->first_idle);
-		gcwq->first_idle = NULL;
+		for_each_worker_pool(pool, gcwq) {
+			spin_unlock_irq(&gcwq->lock);
+			kthread_bind(pool->first_idle->task, cpu);
+			spin_lock_irq(&gcwq->lock);
+			pool->flags |= POOL_MANAGE_WORKERS;
+			start_worker(pool->first_idle);
+			pool->first_idle = NULL;
+		}
 		break;
 	}
 
 	spin_unlock_irqrestore(&gcwq->lock, flags);
 
 	return notifier_from_errno(0);
+
+err_destroy:
+	if (new_trustee)
+		kthread_stop(new_trustee);
+
+	spin_lock_irqsave(&gcwq->lock, flags);
+	for (i = 0; i < NR_WORKER_POOLS; i++)
+		if (new_workers[i])
+			destroy_worker(new_workers[i]);
+	spin_unlock_irqrestore(&gcwq->lock, flags);
+
+	return NOTIFY_BAD;
 }
 
 #ifdef CONFIG_SMP
@@ -3746,6 +3802,7 @@ void thaw_workqueues(void)
 
 	for_each_gcwq_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct worker_pool *pool;
 		struct workqueue_struct *wq;
 
 		spin_lock_irq(&gcwq->lock);
@@ -3767,7 +3824,8 @@ void thaw_workqueues(void)
 				cwq_activate_first_delayed(cwq);
 		}
 
-		wake_up_worker(gcwq);
+		for_each_worker_pool(pool, gcwq)
+			wake_up_worker(pool);
 
 		spin_unlock_irq(&gcwq->lock);
 	}
@@ -3788,24 +3846,29 @@ static int __init init_workqueues(void)
 	/* initialize gcwqs */
 	for_each_gcwq_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct worker_pool *pool;
 
 		spin_lock_init(&gcwq->lock);
-		INIT_LIST_HEAD(&gcwq->worklist);
 		gcwq->cpu = cpu;
 		gcwq->flags |= GCWQ_DISASSOCIATED;
 
-		INIT_LIST_HEAD(&gcwq->idle_list);
 		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)
 			INIT_HLIST_HEAD(&gcwq->busy_hash[i]);
 
-		init_timer_deferrable(&gcwq->idle_timer);
-		gcwq->idle_timer.function = idle_worker_timeout;
-		gcwq->idle_timer.data = (unsigned long)gcwq;
+		for_each_worker_pool(pool, gcwq) {
+			pool->gcwq = gcwq;
+			INIT_LIST_HEAD(&pool->worklist);
+			INIT_LIST_HEAD(&pool->idle_list);
+
+			init_timer_deferrable(&pool->idle_timer);
+			pool->idle_timer.function = idle_worker_timeout;
+			pool->idle_timer.data = (unsigned long)pool;
 
-		setup_timer(&gcwq->mayday_timer, gcwq_mayday_timeout,
-			    (unsigned long)gcwq);
+			setup_timer(&pool->mayday_timer, gcwq_mayday_timeout,
+				    (unsigned long)pool);
 
-		ida_init(&gcwq->worker_ida);
+			ida_init(&pool->worker_ida);
+		}
 
 		gcwq->trustee_state = TRUSTEE_DONE;
 		init_waitqueue_head(&gcwq->trustee_wait);
@@ -3814,15 +3877,20 @@ static int __init init_workqueues(void)
 	/* create the initial worker */
 	for_each_online_gcwq_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);
-		struct worker *worker;
+		struct worker_pool *pool;
 
 		if (cpu != WORK_CPU_UNBOUND)
 			gcwq->flags &= ~GCWQ_DISASSOCIATED;
-		worker = create_worker(gcwq, true);
-		BUG_ON(!worker);
-		spin_lock_irq(&gcwq->lock);
-		start_worker(worker);
-		spin_unlock_irq(&gcwq->lock);
+
+		for_each_worker_pool(pool, gcwq) {
+			struct worker *worker;
+
+			worker = create_worker(pool, true);
+			BUG_ON(!worker);
+			spin_lock_irq(&gcwq->lock);
+			start_worker(worker);
+			spin_unlock_irq(&gcwq->lock);
+		}
 	}
 
 	system_wq = alloc_workqueue("events", 0, 0);
Index: work/include/trace/events/workqueue.h
===================================================================
--- work.orig/include/trace/events/workqueue.h
+++ work/include/trace/events/workqueue.h
@@ -54,7 +54,7 @@ TRACE_EVENT(workqueue_queue_work,
 		__entry->function	= work->func;
 		__entry->workqueue	= cwq->wq;
 		__entry->req_cpu	= req_cpu;
-		__entry->cpu		= cwq->gcwq->cpu;
+		__entry->cpu		= cwq->pool->gcwq->cpu;
 	),
 
 	TP_printk("work struct=%p function=%pf workqueue=%p req_cpu=%u cpu=%u",
