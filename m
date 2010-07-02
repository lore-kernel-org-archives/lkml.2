Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab0GBJ2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:28:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59186 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab0GBJ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:28:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AHywafE3gNC0iaZXJwEulCiDHQ0GJiFjUfSC3G6phWLN+BrCA7jp0E15tSlnEPLtwq
         rZbNPBk37izygz/P1js5fvDtHRKDdl6liPruYzg07I4xk5cR1aeyN1sgtdPmXvFIoQ/w
         InZJ9jci8FPu5S2X8XpNicKyowe0xtGk54Y0Q=
Message-ID: <4C2DB149.8090109@gmail.com>
Date: Fri, 02 Jul 2010 11:28:41 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 2/4] workqueue: implement unbound workqueue
References: <4C2A2688.1020206@kernel.org> <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <25085.1277847455@redhat.com> <4C2DAEBB.7090607@kernel.org>
In-Reply-To: <4C2DAEBB.7090607@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements unbound workqueue which can be specified with
WQ_UNBOUND flag on creation.  An unbound workqueue has the following
properties.

* It uses a dedicated gcwq with a pseudo CPU number WORK_CPU_UNBOUND.
  This gcwq is always online and disassociated.

* Workers are not bound to any CPU and not concurrency managed.  Works
  are dispatched to workers as soon as possible and the only applied
  limitation is @max_active.  IOW, all unbound workqeueues are
  implicitly high priority.

Unbound workqueues can be used as simple execution context provider.
Contexts unbound to any cpu are served as soon as possible.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
---
 include/linux/workqueue.h |   15 +++-
 kernel/workqueue.c        |  218 +++++++++++++++++++++++++++++++++------------
 2 files changed, 173 insertions(+), 60 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 139069a..67ce734 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -51,7 +51,8 @@ enum {
 	WORK_NO_COLOR		= WORK_NR_COLORS,

 	/* special cpu IDs */
-	WORK_CPU_NONE		= NR_CPUS,
+	WORK_CPU_UNBOUND	= NR_CPUS,
+	WORK_CPU_NONE		= NR_CPUS + 1,
 	WORK_CPU_LAST		= WORK_CPU_NONE,

 	/*
@@ -237,11 +238,17 @@ enum {
 	WQ_RESCUER		= 1 << 3, /* has an rescue worker */
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
+	WQ_UNBOUND		= 1 << 6, /* not bound to any cpu */

 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
+	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
 	WQ_DFL_ACTIVE		= WQ_MAX_ACTIVE / 2,
 };

+/* unbound wq's aren't per-cpu, scale max_active according to #cpus */
+#define WQ_UNBOUND_MAX_ACTIVE	\
+	max_t(int, WQ_MAX_ACTIVE, num_possible_cpus() * WQ_MAX_UNBOUND_PER_CPU)
+
 /*
  * System-wide workqueues which are always present.
  *
@@ -256,10 +263,16 @@ enum {
  * system_nrt_wq is non-reentrant and guarantees that any given work
  * item is never executed in parallel by multiple CPUs.  Queue
  * flushing might take relatively long.
+ *
+ * system_unbound_wq is unbound workqueue.  Workers are not bound to
+ * any specific CPU, not concurrency managed, and all queued works are
+ * executed immediately as long as max_active limit is not reached and
+ * resources are available.
  */
 extern struct workqueue_struct *system_wq;
 extern struct workqueue_struct *system_long_wq;
 extern struct workqueue_struct *system_nrt_wq;
+extern struct workqueue_struct *system_unbound_wq;

 extern struct workqueue_struct *
 __alloc_workqueue_key(const char *name, unsigned int flags, int max_active,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a105ddf..4608563 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -53,9 +53,10 @@ enum {
 	WORKER_ROGUE		= 1 << 4,	/* not bound to any cpu */
 	WORKER_REBIND		= 1 << 5,	/* mom is home, come back */
 	WORKER_CPU_INTENSIVE	= 1 << 6,	/* cpu intensive */
+	WORKER_UNBOUND		= 1 << 7,	/* worker is unbound */

 	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_ROGUE | WORKER_REBIND |
-				  WORKER_CPU_INTENSIVE,
+				  WORKER_CPU_INTENSIVE | WORKER_UNBOUND,

 	/* gcwq->trustee_state */
 	TRUSTEE_START		= 0,		/* start */
@@ -96,7 +97,7 @@ enum {
  * X: During normal operation, modification requires gcwq->lock and
  *    should be done only from local cpu.  Either disabling preemption
  *    on local cpu or grabbing gcwq->lock is enough for read access.
- *    While trustee is in charge, it's identical to L.
+ *    If GCWQ_DISASSOCIATED is set, it's identical to L.
  *
  * F: wq->flush_mutex protected.
  *
@@ -220,14 +221,52 @@ struct workqueue_struct {
 struct workqueue_struct *system_wq __read_mostly;
 struct workqueue_struct *system_long_wq __read_mostly;
 struct workqueue_struct *system_nrt_wq __read_mostly;
+struct workqueue_struct *system_unbound_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_wq);
 EXPORT_SYMBOL_GPL(system_long_wq);
 EXPORT_SYMBOL_GPL(system_nrt_wq);
+EXPORT_SYMBOL_GPL(system_unbound_wq);

 #define for_each_busy_worker(worker, i, pos, gcwq)			\
 	for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)			\
 		hlist_for_each_entry(worker, pos, &gcwq->busy_hash[i], hentry)

+static inline int __next_gcwq_cpu(int cpu, const struct cpumask *mask,
+				  unsigned int sw)
+{
+	if (cpu < nr_cpu_ids) {
+		if (sw & 1) {
+			cpu = cpumask_next(cpu, mask);
+			if (cpu < nr_cpu_ids)
+				return cpu;
+		}
+		if (sw & 2)
+			return WORK_CPU_UNBOUND;
+	}
+	return WORK_CPU_NONE;
+}
+
+static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
+				struct workqueue_struct *wq)
+{
+	return __next_gcwq_cpu(cpu, mask, !(wq->flags & WQ_UNBOUND) ? 1 : 2);
+}
+
+#define for_each_gcwq_cpu(cpu)						\
+	for ((cpu) = __next_gcwq_cpu(-1, cpu_possible_mask, 3);		\
+	     (cpu) < WORK_CPU_NONE;					\
+	     (cpu) = __next_gcwq_cpu((cpu), cpu_possible_mask, 3))
+
+#define for_each_online_gcwq_cpu(cpu)					\
+	for ((cpu) = __next_gcwq_cpu(-1, cpu_online_mask, 3);		\
+	     (cpu) < WORK_CPU_NONE;					\
+	     (cpu) = __next_gcwq_cpu((cpu), cpu_online_mask, 3))
+
+#define for_each_cwq_cpu(cpu, wq)					\
+	for ((cpu) = __next_wq_cpu(-1, cpu_possible_mask, (wq));	\
+	     (cpu) < WORK_CPU_NONE;					\
+	     (cpu) = __next_wq_cpu((cpu), cpu_possible_mask, (wq)))
+
 #ifdef CONFIG_DEBUG_OBJECTS_WORK

 static struct debug_obj_descr work_debug_descr;
@@ -351,26 +390,46 @@ static bool workqueue_freezing;		/* W: have wqs started freezing? */
 static DEFINE_PER_CPU(struct global_cwq, global_cwq);
 static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, gcwq_nr_running);

+/*
+ * Global cpu workqueue and nr_running counter for unbound gcwq.  The
+ * gcwq is always online, has GCWQ_DISASSOCIATED set, and all its
+ * workers have WORKER_UNBOUND set.
+ */
+static struct global_cwq unbound_global_cwq;
+static atomic_t unbound_gcwq_nr_running = ATOMIC_INIT(0);	/* always 0 */
+
 static int worker_thread(void *__worker);

 static struct global_cwq *get_gcwq(unsigned int cpu)
 {
-	return &per_cpu(global_cwq, cpu);
+	if (cpu != WORK_CPU_UNBOUND)
+		return &per_cpu(global_cwq, cpu);
+	else
+		return &unbound_global_cwq;
 }

 static atomic_t *get_gcwq_nr_running(unsigned int cpu)
 {
-	return &per_cpu(gcwq_nr_running, cpu);
+	if (cpu != WORK_CPU_UNBOUND)
+		return &per_cpu(gcwq_nr_running, cpu);
+	else
+		return &unbound_gcwq_nr_running;
 }

 static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
 					    struct workqueue_struct *wq)
 {
-#ifndef CONFIG_SMP
-	return wq->cpu_wq.single;
+	if (!(wq->flags & WQ_UNBOUND)) {
+		if (likely(cpu < nr_cpu_ids)) {
+#ifdef CONFIG_SMP
+			return per_cpu_ptr(wq->cpu_wq.pcpu, cpu);
 #else
-	return per_cpu_ptr(wq->cpu_wq.pcpu, cpu);
+			return wq->cpu_wq.single;
 #endif
+		}
+	} else if (likely(cpu == WORK_CPU_UNBOUND))
+		return wq->cpu_wq.single;
+	return NULL;
 }

 static unsigned int work_color_to_flags(int color)
@@ -453,7 +512,7 @@ static struct global_cwq *get_work_gcwq(struct work_struct *work)
 	if (cpu == WORK_CPU_NONE)
 		return NULL;

-	BUG_ON(cpu >= nr_cpu_ids);
+	BUG_ON(cpu >= nr_cpu_ids && cpu != WORK_CPU_UNBOUND);
 	return get_gcwq(cpu);
 }

@@ -869,11 +928,14 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,

 	debug_work_activate(work);

+	if (unlikely(cpu == WORK_CPU_UNBOUND))
+		cpu = raw_smp_processor_id();
+
 	/*
 	 * Determine gcwq to use.  SINGLE_CPU is inherently
 	 * NON_REENTRANT, so test it first.
 	 */
-	if (!(wq->flags & WQ_SINGLE_CPU)) {
+	if (!(wq->flags & (WQ_SINGLE_CPU | WQ_UNBOUND))) {
 		struct global_cwq *last_gcwq;

 		/*
@@ -900,7 +962,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			}
 		} else
 			spin_lock_irqsave(&gcwq->lock, flags);
-	} else {
+	} else if (!(wq->flags & WQ_UNBOUND)) {
 		unsigned int req_cpu = cpu;

 		/*
@@ -932,6 +994,9 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			spin_unlock_irqrestore(&gcwq->lock, flags);
 			goto retry;
 		}
+	} else {
+		gcwq = get_gcwq(WORK_CPU_UNBOUND);
+		spin_lock_irqsave(&gcwq->lock, flags);
 	}

 	/* gcwq determined, get cwq and queue */
@@ -1166,7 +1231,8 @@ static bool worker_maybe_bind_and_lock(struct worker *worker)
 		 * it races with cpu hotunplug operation.  Verify
 		 * against GCWQ_DISASSOCIATED.
 		 */
-		set_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));
+		if (!(gcwq->flags & GCWQ_DISASSOCIATED))
+			set_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));

 		spin_lock_irq(&gcwq->lock);
 		if (gcwq->flags & GCWQ_DISASSOCIATED)
@@ -1231,8 +1297,9 @@ static struct worker *alloc_worker(void)
  */
 static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
 {
-	int id = -1;
+	bool on_unbound_cpu = gcwq->cpu == WORK_CPU_UNBOUND;
 	struct worker *worker = NULL;
+	int id = -1;

 	spin_lock_irq(&gcwq->lock);
 	while (ida_get_new(&gcwq->worker_ida, &id)) {
@@ -1250,8 +1317,12 @@ static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
 	worker->gcwq = gcwq;
 	worker->id = id;

-	worker->task = kthread_create(worker_thread, worker, "kworker/%u:%d",
-				      gcwq->cpu, id);
+	if (!on_unbound_cpu)
+		worker->task = kthread_create(worker_thread, worker,
+					      "kworker/%u:%d", gcwq->cpu, id);
+	else
+		worker->task = kthread_create(worker_thread, worker,
+					      "kworker/u:%d", id);
 	if (IS_ERR(worker->task))
 		goto fail;

@@ -1260,10 +1331,13 @@ static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
 	 * online later on.  Make sure every worker has
 	 * PF_THREAD_BOUND set.
 	 */
-	if (bind)
+	if (bind && !on_unbound_cpu)
 		kthread_bind(worker->task, gcwq->cpu);
-	else
+	else {
 		worker->task->flags |= PF_THREAD_BOUND;
+		if (on_unbound_cpu)
+			worker->flags |= WORKER_UNBOUND;
+	}

 	return worker;
 fail:
@@ -1358,12 +1432,17 @@ static bool send_mayday(struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
 	struct workqueue_struct *wq = cwq->wq;
+	unsigned int cpu;

 	if (!(wq->flags & WQ_RESCUER))
 		return false;

 	/* mayday mayday mayday */
-	if (!cpumask_test_and_set_cpu(cwq->gcwq->cpu, wq->mayday_mask))
+	cpu = cwq->gcwq->cpu;
+	/* WORK_CPU_UNBOUND can't be set in cpumask, use cpu 0 instead */
+	if (cpu == WORK_CPU_UNBOUND)
+		cpu = 0;
+	if (!cpumask_test_and_set_cpu(cpu, wq->mayday_mask))
 		wake_up_process(wq->rescuer->task);
 	return true;
 }
@@ -1882,6 +1961,7 @@ static int rescuer_thread(void *__wq)
 	struct workqueue_struct *wq = __wq;
 	struct worker *rescuer = wq->rescuer;
 	struct list_head *scheduled = &rescuer->scheduled;
+	bool is_unbound = wq->flags & WQ_UNBOUND;
 	unsigned int cpu;

 	set_user_nice(current, RESCUER_NICE_LEVEL);
@@ -1891,8 +1971,13 @@ repeat:
 	if (kthread_should_stop())
 		return 0;

+	/*
+	 * See whether any cpu is asking for help.  Unbounded
+	 * workqueues use cpu 0 in mayday_mask for CPU_UNBOUND.
+	 */
 	for_each_cpu(cpu, wq->mayday_mask) {
-		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		unsigned int tcpu = is_unbound ? WORK_CPU_UNBOUND : cpu;
+		struct cpu_workqueue_struct *cwq = get_cwq(tcpu, wq);
 		struct global_cwq *gcwq = cwq->gcwq;
 		struct work_struct *work, *n;

@@ -2034,7 +2119,7 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 		atomic_set(&wq->nr_cwqs_to_flush, 1);
 	}

-	for_each_possible_cpu(cpu) {
+	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		struct global_cwq *gcwq = cwq->gcwq;

@@ -2344,7 +2429,7 @@ static void wait_on_work(struct work_struct *work)
 	lock_map_acquire(&work->lockdep_map);
 	lock_map_release(&work->lockdep_map);

-	for_each_possible_cpu(cpu)
+	for_each_gcwq_cpu(cpu)
 		wait_on_cpu_work(get_gcwq(cpu), work);
 }

@@ -2590,23 +2675,25 @@ static int alloc_cwqs(struct workqueue_struct *wq)
 	const size_t size = sizeof(struct cpu_workqueue_struct);
 	const size_t align = max_t(size_t, 1 << WORK_STRUCT_FLAG_BITS,
 				   __alignof__(unsigned long long));
-#ifndef CONFIG_SMP
-	void *ptr;

-	/*
-	 * Allocate enough room to align cwq and put an extra pointer
-	 * at the end pointing back to the originally allocated
-	 * pointer which will be used for free.
-	 */
-	ptr = kzalloc(size + align + sizeof(void *), GFP_KERNEL);
-	if (ptr) {
-		wq->cpu_wq.single = PTR_ALIGN(ptr, align);
-		*(void **)(wq->cpu_wq.single + 1) = ptr;
+	if (CONFIG_SMP && !(wq->flags & WQ_UNBOUND)) {
+		/* on SMP, percpu allocator can align itself */
+		wq->cpu_wq.pcpu = __alloc_percpu(size, align);
+	} else {
+		void *ptr;
+
+		/*
+		 * Allocate enough room to align cwq and put an extra
+		 * pointer at the end pointing back to the originally
+		 * allocated pointer which will be used for free.
+		 */
+		ptr = kzalloc(size + align + sizeof(void *), GFP_KERNEL);
+		if (ptr) {
+			wq->cpu_wq.single = PTR_ALIGN(ptr, align);
+			*(void **)(wq->cpu_wq.single + 1) = ptr;
+		}
 	}
-#else
-	/* On SMP, percpu allocator can align itself */
-	wq->cpu_wq.pcpu = __alloc_percpu(size, align);
-#endif
+
 	/* just in case, make sure it's actually aligned */
 	BUG_ON(!IS_ALIGNED(wq->cpu_wq.v, align));
 	return wq->cpu_wq.v ? 0 : -ENOMEM;
@@ -2614,23 +2701,25 @@ static int alloc_cwqs(struct workqueue_struct *wq)

 static void free_cwqs(struct workqueue_struct *wq)
 {
-#ifndef CONFIG_SMP
-	/* on UP, the pointer to free is stored right after the cwq */
-	if (wq->cpu_wq.single)
+	if (CONFIG_SMP && !(wq->flags & WQ_UNBOUND))
+		free_percpu(wq->cpu_wq.pcpu);
+	else if (wq->cpu_wq.single) {
+		/* the pointer to free is stored right after the cwq */
 		kfree(*(void **)(wq->cpu_wq.single + 1));
-#else
-	free_percpu(wq->cpu_wq.pcpu);
-#endif
+	}
 }

-static int wq_clamp_max_active(int max_active, const char *name)
+static int wq_clamp_max_active(int max_active, unsigned int flags,
+			       const char *name)
 {
-	if (max_active < 1 || max_active > WQ_MAX_ACTIVE)
+	int lim = flags & WQ_UNBOUND ? WQ_UNBOUND_MAX_ACTIVE : WQ_MAX_ACTIVE;
+
+	if (max_active < 1 || max_active > lim)
 		printk(KERN_WARNING "workqueue: max_active %d requested for %s "
 		       "is out of range, clamping between %d and %d\n",
-		       max_active, name, 1, WQ_MAX_ACTIVE);
+		       max_active, name, 1, lim);

-	return clamp_val(max_active, 1, WQ_MAX_ACTIVE);
+	return clamp_val(max_active, 1, lim);
 }

 struct workqueue_struct *__alloc_workqueue_key(const char *name,
@@ -2642,8 +2731,15 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	struct workqueue_struct *wq;
 	unsigned int cpu;

+	/*
+	 * Unbound workqueues aren't concurrency managed and should be
+	 * dispatched to workers immediately.
+	 */
+	if (flags & WQ_UNBOUND)
+		flags |= WQ_HIGHPRI;
+
 	max_active = max_active ?: WQ_DFL_ACTIVE;
-	max_active = wq_clamp_max_active(max_active, name);
+	max_active = wq_clamp_max_active(max_active, flags, name);

 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
 	if (!wq)
@@ -2664,7 +2760,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	if (alloc_cwqs(wq) < 0)
 		goto err;

-	for_each_possible_cpu(cpu) {
+	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		struct global_cwq *gcwq = get_gcwq(cpu);

@@ -2703,7 +2799,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	spin_lock(&workqueue_lock);

 	if (workqueue_freezing && wq->flags & WQ_FREEZEABLE)
-		for_each_possible_cpu(cpu)
+		for_each_cwq_cpu(cpu, wq)
 			get_cwq(cpu, wq)->max_active = 0;

 	list_add(&wq->list, &workqueues);
@@ -2743,7 +2839,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	spin_unlock(&workqueue_lock);

 	/* sanity check */
-	for_each_possible_cpu(cpu) {
+	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		int i;

@@ -2777,13 +2873,13 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 {
 	unsigned int cpu;

-	max_active = wq_clamp_max_active(max_active, wq->name);
+	max_active = wq_clamp_max_active(max_active, wq->flags, wq->name);

 	spin_lock(&workqueue_lock);

 	wq->saved_max_active = max_active;

-	for_each_possible_cpu(cpu) {
+	for_each_cwq_cpu(cpu, wq) {
 		struct global_cwq *gcwq = get_gcwq(cpu);

 		spin_lock_irq(&gcwq->lock);
@@ -3310,7 +3406,7 @@ void freeze_workqueues_begin(void)
 	BUG_ON(workqueue_freezing);
 	workqueue_freezing = true;

-	for_each_possible_cpu(cpu) {
+	for_each_gcwq_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct workqueue_struct *wq;

@@ -3322,7 +3418,7 @@ void freeze_workqueues_begin(void)
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);

-			if (wq->flags & WQ_FREEZEABLE)
+			if (cwq && wq->flags & WQ_FREEZEABLE)
 				cwq->max_active = 0;
 		}

@@ -3354,7 +3450,7 @@ bool freeze_workqueues_busy(void)

 	BUG_ON(!workqueue_freezing);

-	for_each_possible_cpu(cpu) {
+	for_each_gcwq_cpu(cpu) {
 		struct workqueue_struct *wq;
 		/*
 		 * nr_active is monotonically decreasing.  It's safe
@@ -3363,7 +3459,7 @@ bool freeze_workqueues_busy(void)
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);

-			if (!(wq->flags & WQ_FREEZEABLE))
+			if (!cwq || !(wq->flags & WQ_FREEZEABLE))
 				continue;

 			BUG_ON(cwq->nr_active < 0);
@@ -3396,7 +3492,7 @@ void thaw_workqueues(void)
 	if (!workqueue_freezing)
 		goto out_unlock;

-	for_each_possible_cpu(cpu) {
+	for_each_gcwq_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct workqueue_struct *wq;

@@ -3408,7 +3504,7 @@ void thaw_workqueues(void)
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);

-			if (!(wq->flags & WQ_FREEZEABLE))
+			if (!cwq || !(wq->flags & WQ_FREEZEABLE))
 				continue;

 			/* restore max_active and repopulate worklist */
@@ -3451,12 +3547,14 @@ void __init init_workqueues(void)
 	hotcpu_notifier(workqueue_cpu_callback, CPU_PRI_WORKQUEUE);

 	/* initialize gcwqs */
-	for_each_possible_cpu(cpu) {
+	for_each_gcwq_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);

 		spin_lock_init(&gcwq->lock);
 		INIT_LIST_HEAD(&gcwq->worklist);
 		gcwq->cpu = cpu;
+		if (cpu == WORK_CPU_UNBOUND)
+			gcwq->flags |= GCWQ_DISASSOCIATED;

 		INIT_LIST_HEAD(&gcwq->idle_list);
 		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)
@@ -3476,7 +3574,7 @@ void __init init_workqueues(void)
 	}

 	/* create the initial worker */
-	for_each_online_cpu(cpu) {
+	for_each_online_gcwq_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct worker *worker;

@@ -3490,5 +3588,7 @@ void __init init_workqueues(void)
 	system_wq = alloc_workqueue("events", 0, 0);
 	system_long_wq = alloc_workqueue("events_long", 0, 0);
 	system_nrt_wq = alloc_workqueue("events_nrt", WQ_NON_REENTRANT, 0);
+	system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND,
+					    WQ_UNBOUND_MAX_ACTIVE);
 	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq);
 }
-- 
1.6.4.2

