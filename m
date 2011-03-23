Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab1CWPeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:34:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61913 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050Ab1CWPeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:34:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=uwjm/K4IDXevFCAnp0BStqo07BQf10UlaresD+yAwYj/tE2kySXNNTbUu9GduNLBLO
         W2nyrQol7dSy2tgTATLeqmsSnqdqwSUNvTM7awQ8+BnN5Aqh/KwW+b0m8d8TCRKCXujR
         QFymJRjElXEMCvtHo54Zv7OdqXYgWAclSLx/A=
MIME-Version: 1.0
Date: Wed, 23 Mar 2011 23:34:18 +0800
Message-ID: <AANLkTinWrchYyqF8qAGGQAt9JCbAj46txqK-MD2TEZe1@mail.gmail.com>
Subject: sched: new cpu schedule
From: wu junhui <wjh.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello

i have a new cpu schedule, i name it NanJing for my city.

it's O(1),
it's one queue,
it's load balance o(1),
it's fair,
it's i/o friendly,

todo:
powersave,
human interface (keyboard, mouse event) promotion,
optimalize clean,


my developing  platform is centos 5.5

rpmbuild -bp 2.6.18-194.32.1.el5 source

.config use /boot/config

i had do some test, it's work. in diff i have some explain. if
somebody interest, i can explain more later.

sorry for the last post with attatch patch.

thanks.

Wu JunHui

--- linux-2.6.18.i686_org/kernel/sched.c	2011-03-07 14:12:46.000000000 +0800
+++ linux-2.6.18.i686/kernel/sched.c	2011-03-23 10:02:06.000000000 +0800
@@ -16,6 +16,7 @@
  *		by Davide Libenzi, preemptible kernel bits by Robert Love.
  *  2003-09-03	Interactivity tuning by Con Kolivas.
  *  2004-04-02	Scheduler domains code by Nick Piggin
+ *  2011-03-06  NanJing Scheduler code by WuJunHui
  */

 #include <linux/mm.h>
@@ -75,6 +76,9 @@
 #define USER_PRIO(p)		((p)-MAX_RT_PRIO)
 #define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
+#define MAX_RQ_PRIO		(MAX_RT_PRIO + 2)
+#define OUTSIDE_PRIO		(MAX_RT_PRIO )
+#define INSIDE_PRIO		(MAX_RT_PRIO + 1)

 /*
  * Some helpers for converting nanosecond timing to jiffy resolution
@@ -90,78 +94,17 @@
  * Timeslices get refilled after they expire.
  */
 #define MIN_TIMESLICE		max(5 * HZ / 1000, 1)
-#define DEF_TIMESLICE		(100 * HZ / 1000)
-#define ON_RUNQUEUE_WEIGHT	 30
-#define CHILD_PENALTY		 95
-#define PARENT_PENALTY		100
-#define EXIT_WEIGHT		  3
-#define PRIO_BONUS_RATIO	 25
-#define MAX_BONUS		(MAX_USER_PRIO * PRIO_BONUS_RATIO / 100)
-#define INTERACTIVE_DELTA	  2
-#define MAX_SLEEP_AVG		(DEF_TIMESLICE * MAX_BONUS)
-#define STARVATION_LIMIT	(MAX_SLEEP_AVG)
-#define NS_MAX_SLEEP_AVG	(JIFFIES_TO_NS(MAX_SLEEP_AVG))
-
-/*
- * If a task is 'interactive' then we reinsert it in the active
- * array after it has expired its current timeslice. (it will not
- * continue to run immediately, it will still roundrobin with
- * other interactive tasks.)
- *
- * This part scales the interactivity limit depending on niceness.
- *
- * We scale it linearly, offset by the INTERACTIVE_DELTA delta.
- * Here are a few examples of different nice levels:
- *
- *  TASK_INTERACTIVE(-20): [1,1,1,1,1,1,1,1,1,0,0]
- *  TASK_INTERACTIVE(-10): [1,1,1,1,1,1,1,0,0,0,0]
- *  TASK_INTERACTIVE(  0): [1,1,1,1,0,0,0,0,0,0,0]
- *  TASK_INTERACTIVE( 10): [1,1,0,0,0,0,0,0,0,0,0]
- *  TASK_INTERACTIVE( 19): [0,0,0,0,0,0,0,0,0,0,0]
- *
- * (the X axis represents the possible -5 ... 0 ... +5 dynamic
- *  priority range a task can explore, a value of '1' means the
- *  task is rated interactive.)
- *
- * Ie. nice +19 tasks can never get 'interactive' enough to be
- * reinserted into the active array. And only heavily CPU-hog nice -20
- * tasks will be expired. Default nice 0 tasks are somewhere between,
- * it takes some effort for them to get interactive, but it's not
- * too hard.
- */
-
-#define CURRENT_BONUS(p) \
-	(NS_TO_JIFFIES((p)->sleep_avg) * MAX_BONUS / \
-		MAX_SLEEP_AVG)
-
-#define GRANULARITY	(10 * HZ / 1000 ? : 1)

-#ifdef CONFIG_SMP
-#define TIMESLICE_GRANULARITY(p)	(GRANULARITY * \
-		(1 << (((MAX_BONUS - CURRENT_BONUS(p)) ? : 1) - 1)) * \
-			num_online_cpus())
-#else
-#define TIMESLICE_GRANULARITY(p)	(GRANULARITY * \
-		(1 << (((MAX_BONUS - CURRENT_BONUS(p)) ? : 1) - 1)))
-#endif
+#define DEF_TIMESLICE		(100 * HZ / 1000)

 #define SCALE(v1,v1_max,v2_max) \
 	(v1) * (v2_max) / (v1_max)

-#define DELTA(p) \
-	(SCALE(TASK_NICE(p) + 20, 40, MAX_BONUS) - 20 * MAX_BONUS / 40 + \
-		INTERACTIVE_DELTA)
-
-#define TASK_INTERACTIVE(p) \
-	((p)->prio <= (p)->static_prio - DELTA(p))
-
-#define INTERACTIVE_SLEEP(p) \
-	(JIFFIES_TO_NS(MAX_SLEEP_AVG * \
-		(MAX_BONUS / 2 + DELTA((p)) + 1) / MAX_BONUS - 1))
-
 #define TASK_PREEMPTS_CURR(p, rq) \
 	((p)->prio < (rq)->curr->prio)

+#define normal_task(p) \
+	(p->static_prio < MAX_PRIO && p->static_prio > MAX_RT_PRIO-1)
 /*
  * task_timeslice() scales user-nice values [ -20 ... 0 ... 19 ]
  * to time slice values: [800ms ... 100ms ... 5ms]
@@ -193,8 +136,8 @@

 struct prio_array {
 	unsigned int nr_active;
-	DECLARE_BITMAP(bitmap, MAX_PRIO+1); /* include 1 bit for delimiter */
-	struct list_head queue[MAX_PRIO];
+	DECLARE_BITMAP(bitmap, MAX_RQ_PRIO+1); /* include 1 bit for delimiter */
+	struct list_head queue[MAX_RQ_PRIO];
 };

 /*
@@ -226,12 +169,10 @@
 	 */
 	unsigned long nr_uninterruptible;

-	unsigned long expired_timestamp;
 	unsigned long long timestamp_last_tick;
 	struct task_struct *curr, *idle;
 	struct mm_struct *prev_mm;
-	struct prio_array *active, *expired, arrays[2];
-	int best_expired_prio;
+	struct prio_array *active, arrays[1];
 	atomic_t nr_iowait;

 #ifdef CONFIG_SMP
@@ -724,16 +665,7 @@

 static inline int __normal_prio(struct task_struct *p)
 {
-	int bonus, prio;
-
-	bonus = CURRENT_BONUS(p) - MAX_BONUS / 2;
-
-	prio = p->static_prio - bonus;
-	if (prio < MAX_RT_PRIO)
-		prio = MAX_RT_PRIO;
-	if (prio > MAX_PRIO-1)
-		prio = MAX_PRIO-1;
-	return prio;
+	return OUTSIDE_PRIO;
 }

 /*
@@ -802,10 +734,8 @@

 /*
  * Calculate the expected normal priority: i.e. priority
- * without taking RT-inheritance into account. Might be
- * boosted by interactivity modifiers. Changes upon fork,
- * setprio syscalls, and whenever the interactivity
- * estimator recalculates.
+ * without taking RT-inheritance into account. Changes upon fork,
+ * setprio syscalls.
  */
 static inline int normal_prio(struct task_struct *p)
 {
@@ -821,8 +751,7 @@
 /*
  * Calculate the current priority, i.e. the priority
  * taken into account by the scheduler. This value might
- * be boosted by RT tasks, or might be boosted by
- * interactivity modifiers. Will be RT if the task got
+ * be boosted by RT tasks. Will be RT if the task got
  * RT-boosted. If not then it returns p->normal_prio.
  */
 static int effective_prio(struct task_struct *p)
@@ -843,12 +772,9 @@
  */
 static void __activate_task(struct task_struct *p, struct rq *rq)
 {
-	struct prio_array *target = rq->active;

 	trace_activate_task(p, rq);
-	if (batch_task(p))
-		target = rq->expired;
-	enqueue_task(p, target);
+	enqueue_task(p, rq->active);
 	inc_nr_running(p, rq);
 }

@@ -861,81 +787,11 @@
 	inc_nr_running(p, rq);
 }

-/*
- * Recalculate p->normal_prio and p->prio after having slept,
- * updating the sleep-average too:
- */
-static int recalc_task_prio(struct task_struct *p, unsigned long long now)
-{
-	/* Caller must always ensure 'now >= p->timestamp' */
-	unsigned long sleep_time = now - p->timestamp;
-
-	if (batch_task(p) || sched_interactive == 0)
-		sleep_time = 0;
-
-	if (likely(sleep_time > 0)) {
-		/*
-		 * This ceiling is set to the lowest priority that would allow
-		 * a task to be reinserted into the active array on timeslice
-		 * completion.
-		 */
-		unsigned long ceiling = INTERACTIVE_SLEEP(p);
-
-		if (p->mm && sleep_time > ceiling && p->sleep_avg < ceiling) {
-			/*
-			 * Prevents user tasks from achieving best priority
-			 * with one single large enough sleep.
-			 */
-			p->sleep_avg = ceiling;
-			/*
-			 * Using INTERACTIVE_SLEEP() as a ceiling places a
-			 * nice(0) task 1ms sleep away from promotion, and
-			 * gives it 700ms to round-robin with no chance of
-			 * being demoted.  This is more than generous, so
-			 * mark this sleep as non-interactive to prevent the
-			 * on-runqueue bonus logic from intervening should
-			 * this task not receive cpu immediately.
-			 */
-			p->sleep_type = SLEEP_NONINTERACTIVE;
-		} else {
-			/*
-			 * Tasks waking from uninterruptible sleep are
-			 * limited in their sleep_avg rise as they
-			 * are likely to be waiting on I/O
-			 */
-			if (p->sleep_type == SLEEP_NONINTERACTIVE && p->mm) {
-				if (p->sleep_avg >= ceiling)
-					sleep_time = 0;
-				else if (p->sleep_avg + sleep_time >=
-					 ceiling) {
-						p->sleep_avg = ceiling;
-						sleep_time = 0;
-				}
-			}
-
-			/*
-			 * This code gives a bonus to interactive tasks.
-			 *
-			 * The boost works by updating the 'average sleep time'
-			 * value here, based on ->timestamp. The more time a
-			 * task spends sleeping, the higher the average gets -
-			 * and the higher the priority boost gets as well.
-			 */
-			p->sleep_avg += sleep_time;
-
-		}
-		if (p->sleep_avg > NS_MAX_SLEEP_AVG)
-			p->sleep_avg = NS_MAX_SLEEP_AVG;
-	}
-
-	return effective_prio(p);
-}

 /*
- * activate_task - move a task to the runqueue and do priority recalculation
+ * activate_task - move a task to the runqueue
  *
- * Update all the scheduling statistics stuff. (sleep average
- * calculation, priority modifiers, etc.)
+ * Update all the scheduling statistics stuff.
  */
 static void activate_task(struct task_struct *p, struct rq *rq, int local)
 {
@@ -951,31 +807,8 @@
 	}
 #endif

-	if (!rt_task(p))
-		p->prio = recalc_task_prio(p, now);
+	p->prio = effective_prio(p);

-	/*
-	 * This checks to make sure it's not an uninterruptible task
-	 * that is now waking up.
-	 */
-	if (p->sleep_type == SLEEP_NORMAL) {
-		/*
-		 * Tasks which were woken up by interrupts (ie. hw events)
-		 * are most likely of interactive nature. So we give them
-		 * the credit of extending their sleep time to the period
-		 * of time they spend on the runqueue, waiting for execution
-		 * on a CPU, first time around:
-		 */
-		if (in_interrupt())
-			p->sleep_type = SLEEP_INTERRUPTED;
-		else {
-			/*
-			 * Normal first-time wakeups get a credit too for
-			 * on-runqueue time, but it will be weighted down:
-			 */
-			p->sleep_type = SLEEP_INTERACTIVE;
-		}
-	}
 	p->timestamp = now;

 	__activate_task(p, rq);
@@ -1049,6 +882,8 @@
 }

 #ifdef CONFIG_SMP
+/*
+move to sched.h
 struct migration_req {
 	struct list_head list;

@@ -1057,6 +892,7 @@

 	struct completion done;
 };
+*/

 /*
  * The task's runqueue lock must be held.
@@ -1236,6 +1072,126 @@
 }

 /*
+ * find_neighbor_idlest_cpu_wake - find the neighbor idlest runqueue
among the cpu.
+ * you only have to balance to you neighbor cpu. if every cpu balance
to it's neighbor,then
+ * all cpu is balance. i call it ocean balance.
+ * neighbor range must big enough to neighbor node cpu. i set it to 16.
+ */
+static int
+find_neighbor_idlest_cpu_wake( struct task_struct *p, int cpu)
+{
+	cpumask_t tmp, tmp1;
+	long load, min_load;
+	int idlest = cpu;
+	int i, j, k;
+
+	cpus_and(tmp1, p->cpus_allowed, cpu_online_map);	
+	k = cpus_weight(tmp1);
+/*
+ * wjh: XXX this code need optimalize
+ */
+	if (k > 16) {
+		cpus_clear(tmp);
+		cpu_set(cpu, tmp);
+		j=cpu;
+		for (i =0 ; i < 8; i++) {
+			j = next_cpu(j, tmp1);
+			if (j == NR_CPUS)
+				j = first_cpu(tmp1);
+			cpu_set(j, tmp);
+		}
+		for (i =0 ; i < k - 17 ; i++) {
+			j = next_cpu(j, tmp1);
+			if (j == NR_CPUS)
+				j = first_cpu(tmp1);
+		}
+		for (i =0 ; i < 8; i++) {
+			j = next_cpu(j, tmp1);
+			if (j == NR_CPUS)
+				j = first_cpu(tmp1);
+			cpu_set(j, tmp);
+		}
+	} else {
+		cpus_clear(tmp);
+		cpus_or(tmp, tmp, tmp1);
+	}
+
+	min_load = weighted_cpuload(cpu) - 1 ;
+
+	for_each_cpu_mask(i, tmp) {
+		load = weighted_cpuload(i);
+		/*
+		 *may consider migration cost, use SD information. -wjh
+		 */
+
+		if (load < min_load || (load == min_load && i == cpu)) {
+			min_load = load;
+			idlest = i;
+		}
+	}
+
+	return idlest;
+}
+
+static int
+find_neighbor_idlest_cpu_time_slice( struct task_struct *p, int cpu)
+{
+	cpumask_t tmp, tmp1;
+	long load, min_load;
+	int idlest = cpu;
+	int i, j;
+
+	cpus_and(tmp1, p->cpus_allowed, cpu_online_map);	
+	i = cpus_weight(tmp1);
+/*
+ * wjh: XXX this code need optimalize
+ */
+	if (i > 16) {
+		cpus_clear(tmp);
+		cpu_set(cpu, tmp);
+		j=cpu;
+		for (i =0 ; i < 8; i++) {
+			j = next_cpu(j, tmp1);
+			if (j == NR_CPUS)
+				j = first_cpu(tmp1);
+			cpu_set(j, tmp);
+		}
+		for (i =0 ; i < k - 17 ; i++) {
+			j = next_cpu(j, tmp1);
+			if (j == NR_CPUS)
+				j = first_cpu(tmp1);
+		}
+		for (i =0 ; i < 8; i++) {
+			j = next_cpu(j, tmp1);
+			if (j == NR_CPUS)
+				j = first_cpu(tmp1);
+			cpu_set(j, tmp);
+		}
+	} else {
+		cpus_clear(tmp);
+		cpus_or(tmp, tmp, tmp1);
+	}
+	/*
+	 * cpu affinity -1
+	 */
+	min_load = weighted_cpuload(cpu) - p->load_weight - 1 ;
+
+	for_each_cpu_mask(i, tmp) {
+		/*
+		 *may consider migration cost, use SD information. -wjh
+		 */
+		load = weighted_cpuload(i);
+
+		if (load < min_load || (load == min_load && i == cpu)) {
+			min_load = load;
+			idlest = i;
+		}
+	}
+
+	return idlest;
+}
+
+/*
  * find_idlest_queue - find the idlest runqueue among the cpus in group.
  */
 static int
@@ -1457,8 +1413,11 @@
 #ifdef CONFIG_SMP
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
-
-	new_cpu = cpu;
+/*
+ *wjh: active load balance
+ */
+	new_cpu = find_neighbor_idlest_cpu_wake(p, cpu);
+		goto out_set_cpu;

 	schedstat_inc(rq, ttwu_cnt);
 	if (cpu == this_cpu) {
@@ -1548,23 +1507,8 @@

 out_activate:
 #endif /* CONFIG_SMP */
-	if (old_state == TASK_UNINTERRUPTIBLE) {
+	if (old_state == TASK_UNINTERRUPTIBLE)
 		rq->nr_uninterruptible--;
-		/*
-		 * Tasks on involuntary sleep don't earn
-		 * sleep_avg beyond just interactive state.
-		 */
-		p->sleep_type = SLEEP_NONINTERACTIVE;
-	} else
-
-	/*
-	 * Tasks that have marked their sleep as noninteractive get
-	 * woken up with their sleep average not weighted in an
-	 * interactive way.
-	 */
-		if (old_state & TASK_NONINTERACTIVE)
-			p->sleep_type = SLEEP_NONINTERACTIVE;
-

 	activate_task(p, rq, cpu == this_cpu);
 	/*
@@ -1576,7 +1520,7 @@
 	 * to be considered on this CPU.)
 	 */
 	if (!sync || cpu != this_cpu) {
-		if (TASK_PREEMPTS_CURR(p, rq))
+		if TASK_PREEMPTS_CURR(p, rq)
 			resched_task(rq->curr);
 	}
 	success = 1;
@@ -1686,15 +1630,6 @@
 	this_cpu = smp_processor_id();
 	cpu = task_cpu(p);

-	/*
-	 * We decrease the sleep average of forking parents
-	 * and children as well, to keep max-interactive tasks
-	 * from forking tasks that are max-interactive. The parent
-	 * (current) is done further down, under its lock.
-	 */
-	p->sleep_avg = JIFFIES_TO_NS(CURRENT_BONUS(p) *
-		CHILD_PENALTY / 100 * MAX_SLEEP_AVG / MAX_BONUS);
-
 	p->prio = effective_prio(p);

 	if (likely(cpu == this_cpu)) {
@@ -1739,15 +1674,9 @@
 		if (TASK_PREEMPTS_CURR(p, rq))
 			resched_task(rq->curr);

-		/*
-		 * Parent and child are on different CPUs, now get the
-		 * parent runqueue to update the parent's ->sleep_avg:
-		 */
 		task_rq_unlock(rq, &flags);
 		this_rq = task_rq_lock(current, &flags);
 	}
-	current->sleep_avg = JIFFIES_TO_NS(CURRENT_BONUS(current) *
-		PARENT_PENALTY / 100 * MAX_SLEEP_AVG / MAX_BONUS);
 	trace_sched_wakeup_new(this_rq, p, 1);
 	task_rq_unlock(this_rq, &flags);
 }
@@ -1766,10 +1695,6 @@
 	unsigned long flags;
 	struct rq *rq;
 	struct task_struct* creator = NULL;
-	/*
-	 * If the child was a (relative-) CPU hog then decrease
-	 * the sleep_avg of the parent as well.
-	 */

         if (p->first_time_slice) {
                 creator = find_task_by_pid((pid_t)p->first_time_slice);
@@ -1779,10 +1704,6 @@
                         if (unlikely(creator->time_slice > task_timeslice(p)))
                                 creator->time_slice = task_timeslice(p);

-                        if (p->sleep_avg < creator->sleep_avg)
-                                creator->sleep_avg = creator->sleep_avg /
-		(EXIT_WEIGHT + 1) * EXIT_WEIGHT + p->sleep_avg /
-		(EXIT_WEIGHT + 1);
 	task_rq_unlock(rq, &flags);
                 }
         }
@@ -2310,7 +2231,7 @@
 	return 1;
 }

-#define rq_best_prio(rq) min((rq)->curr->prio, (rq)->best_expired_prio)
+#define rq_best_prio(rq) ((rq)->curr->prio)

 /*
  * move_tasks tries to move up to max_nr_move tasks and max_load_move weighted
@@ -2347,34 +2268,17 @@
 	 */
 	best_prio_seen = best_prio == busiest->curr->prio;

-	/*
-	 * We first consider expired tasks. Those will likely not be
-	 * executed in the near future, and they are most likely to
-	 * be cache-cold, thus switching CPUs has the least effect
-	 * on them.
-	 */
-	if (busiest->expired->nr_active) {
-		array = busiest->expired;
-		dst_array = this_rq->expired;
-	} else {
-		array = busiest->active;
-		dst_array = this_rq->active;
-	}
+	array = busiest->active;
+	dst_array = this_rq->active;

-new_array:
 	/* Start searching at priority 0: */
 	idx = 0;
 skip_bitmap:
 	if (!idx)
 		idx = sched_find_first_bit(array->bitmap);
 	else
-		idx = find_next_bit(array->bitmap, MAX_PRIO, idx);
-	if (idx >= MAX_PRIO) {
-		if (array == busiest->expired && busiest->active->nr_active) {
-			array = busiest->active;
-			dst_array = this_rq->active;
-			goto new_array;
-		}
+		idx = find_next_bit(array->bitmap, MAX_RQ_PRIO, idx);
+	if (idx >= MAX_RQ_PRIO) {
 		goto out;
 	}

@@ -3145,29 +3049,6 @@
 }

 /*
- * We place interactive tasks back into the active array, if possible.
- *
- * To guarantee that this does not starve expired tasks we ignore the
- * interactivity of a task if the first expired task had to wait more
- * than a 'reasonable' amount of time. This deadline timeout is
- * load-dependent, as the frequency of array switched decreases with
- * increasing number of running tasks. We also ignore the interactivity
- * if a better static_prio task has expired:
- */
-static inline int expired_starving(struct rq *rq)
-{
-	if (rq->curr->static_prio > rq->best_expired_prio)
-		return 1;
-	if (!STARVATION_LIMIT || !rq->expired_timestamp)
-		return 0;
-	if (sched_interactive == 1)
-		return 1;
-	if (jiffies - rq->expired_timestamp > STARVATION_LIMIT * rq->nr_running)
-		return 1;
-	return 0;
-}
-
-/*
  * Account user cpu time to a process.
  * @p: the process that the cpu time gets accounted to
  * @hardirq_offset: the offset to subtract from hardirq_count()
@@ -3251,8 +3132,10 @@
 {
 	unsigned long long now = sched_clock();
 	struct task_struct *p = current;
-	int cpu = smp_processor_id();
+	int new_cpu, cpu = smp_processor_id();
 	struct rq *rq = cpu_rq(cpu);
+	unsigned int steal_ticks;
+        unsigned long flags;

 	update_cpu_clock(p, rq, now);

@@ -3261,7 +3144,9 @@
 	if (p == rq->idle) {
 		if (wake_priority_sleeper(rq))
 			goto out;
+/* wjh: no pull balance
 		rebalance_tick(cpu, rq, SCHED_IDLE);
+*/
 		return;
 	}

@@ -3293,51 +3178,57 @@
 		}
 		goto out_unlock;
 	}
+
+/*
+ * wjh: in order nice to interactive task,INSIDE_PRIO task use more tick.
+ * maybe redefine DEF_TIMESLICE.
+ * steal_sticks = 50 - 49/rq->nr_running
+*/
+	
+	if (p->prio == INSIDE_PRIO) {
+		steal_ticks = min(rq->nr_running*2, 50);
+		if (p->time_slice > steal_ticks) {
+			p->time_slice -= steal_ticks;
+		}else {
+			p->time_slice = 1;
+		}
+	}
+
 	if (!--p->time_slice) {
 		dequeue_task(p, rq->active);
 		set_tsk_need_resched(p);
-		p->prio = effective_prio(p);
 		p->time_slice = task_timeslice(p);
 		p->first_time_slice = 0;
-
-		if (!rq->expired_timestamp)
-			rq->expired_timestamp = jiffies;
-		if (!TASK_INTERACTIVE(p) || expired_starving(rq)) {
-			enqueue_task(p, rq->expired);
-			if (p->static_prio < rq->best_expired_prio)
-				rq->best_expired_prio = p->static_prio;
-		} else
+		if normal_task(p) {
+			p->prio = INSIDE_PRIO;
 			enqueue_task(p, rq->active);
-	} else {
-		/*
-		 * Prevent a too long timeslice allowing a task to monopolize
-		 * the CPU. We do this by splitting up the timeslice into
-		 * smaller pieces.
-		 *
-		 * Note: this does not mean the task's timeslices expire or
-		 * get lost in any way, they just might be preempted by
-		 * another task of equal priority. (one with higher
-		 * priority would have preempted this task already.) We
-		 * requeue this task to the end of the list on this priority
-		 * level, which is in essence a round-robin of tasks with
-		 * equal priority.
-		 *
-		 * This only applies to tasks in the interactive
-		 * delta range with at least TIMESLICE_GRANULARITY to requeue.
-		 */
-		if (TASK_INTERACTIVE(p) && !((task_timeslice(p) -
-			p->time_slice) % TIMESLICE_GRANULARITY(p)) &&
-			(p->time_slice >= TIMESLICE_GRANULARITY(p)) &&
-			(p->array == rq->active)) {
-
-			requeue_task(p, rq->active);
-			set_tsk_need_resched(p);
+		} else {
+			enqueue_task(p, rq->active);
+			#ifdef CONFIG_SMP
+			/*
+			 * load balance
+			 */
+			new_cpu = find_neighbor_idlest_cpu_time_slice(p, cpu);
+			if (new_cpu != cpu) {
+				spin_unlock(&rq->lock);
+				rq = task_rq_lock(p, &flags);
+				if (migrate_task(p, new_cpu, &p->req)) {
+					task_rq_unlock(rq, &flags);
+					wake_up_process(rq->migration_thread);
+				} else
+					task_rq_unlock(rq, &flags);
+				goto out;
+			}
+			#endif
 		}
 	}
 out_unlock:
 	spin_unlock(&rq->lock);
 out:
-	rebalance_tick(cpu, rq, NOT_IDLE);
+/* wjh: no pull load balance
+*	rebalance_tick(cpu, rq, NOT_IDLE);
+*/
+;
 }

 #ifdef CONFIG_SCHED_SMT
@@ -3507,12 +3398,6 @@

 #endif

-static inline int interactive_sleep(enum sleep_type sleep_type)
-{
-	return (sleep_type == SLEEP_INTERACTIVE ||
-		sleep_type == SLEEP_INTERRUPTED);
-}
-
 /*
  * schedule() is the main scheduler function.
  */
@@ -3522,8 +3407,7 @@
 	struct prio_array *array;
 	struct list_head *queue;
 	unsigned long long now;
-	unsigned long run_time;
-	int cpu, idx, new_prio;
+	int cpu, idx;
 	long *switch_count;
 	struct rq *rq;

@@ -3559,18 +3443,7 @@
 	schedstat_inc(rq, sched_cnt);
 	spin_lock_irq(&rq->lock);
 	now = sched_clock();
-	if (likely((long long)(now - prev->timestamp) < NS_MAX_SLEEP_AVG)) {
-		run_time = now - prev->timestamp;
-		if (unlikely((long long)(now - prev->timestamp) < 0))
-			run_time = 0;
-	} else
-		run_time = NS_MAX_SLEEP_AVG;

-	/*
-	 * Tasks charged proportionately less run_time at high sleep_avg to
-	 * delay them losing their interactive status
-	 */
-	run_time /= (CURRENT_BONUS(prev) ? : 1);

 	if (unlikely(prev->flags & PF_DEAD))
 		prev->state = EXIT_DEAD;
@@ -3592,49 +3465,22 @@

 	cpu = smp_processor_id();
 	if (unlikely(!rq->nr_running)) {
+/* wjh: no pull loadbalance
 		idle_balance(cpu, rq);
+*/
 		if (!rq->nr_running) {
 			next = rq->idle;
-			rq->expired_timestamp = 0;
 			wake_sleeping_dependent(cpu);
 			goto switch_tasks;
 		}
 	}

 	array = rq->active;
-	if (unlikely(!array->nr_active)) {
-		/*
-		 * Switch the active and expired arrays.
-		 */
-		schedstat_inc(rq, sched_switch);
-		rq->active = rq->expired;
-		rq->expired = array;
-		array = rq->active;
-		rq->expired_timestamp = 0;
-		rq->best_expired_prio = MAX_PRIO;
-	}

 	idx = sched_find_first_bit(array->bitmap);
 	queue = array->queue + idx;
 	next = list_entry(queue->next, struct task_struct, run_list);

-	if (!rt_task(next) && interactive_sleep(next->sleep_type)) {
-		unsigned long long delta = now - next->timestamp;
-		if (unlikely((long long)(now - next->timestamp) < 0))
-			delta = 0;
-
-		if (next->sleep_type == SLEEP_INTERACTIVE)
-			delta = delta * (ON_RUNQUEUE_WEIGHT * 128 / 100) / 128;
-
-		array = next->array;
-		new_prio = recalc_task_prio(next, next->timestamp + delta);
-
-		if (unlikely(next->prio != new_prio)) {
-			dequeue_task(next, array);
-			next->prio = new_prio;
-			enqueue_task(next, array);
-		}
-	}
 	next->sleep_type = SLEEP_NORMAL;
 	if (dependent_sleeper(cpu, rq, next))
 		next = rq->idle;
@@ -3646,9 +3492,6 @@
 	clear_tsk_need_resched(prev);
 	rcu_qsctr_inc(task_cpu(prev));

-	prev->sleep_avg -= run_time;
-	if ((long)prev->sleep_avg <= 0)
-		prev->sleep_avg = 0;
 	prev->timestamp = prev->last_ran = now;

 	sched_info_switch(prev, next);
@@ -4149,12 +3992,6 @@
 	p->prio = prio;

 	if (array) {
-		/*
-		 * If changing to an RT priority then queue it
-		 * in the active array!
-		 */
-		if (rt_task(p))
-			array = rq->active;
 		enqueue_task(p, array);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
@@ -4289,6 +4126,12 @@
  */
 int task_prio(const struct task_struct *p)
 {
+/**
+ * wjh:
+	if rt_task(p)	
+		return p->prio - MAX_RT_PRIO;
+	return p->static_prio + p->prio - MAX_RT_PRIO>>1;
+ */
 	return p->prio - MAX_RT_PRIO;
 }

@@ -4352,10 +4195,6 @@
 	/*
 	 * SCHED_BATCH tasks are treated as perpetual CPU hogs:
 	 */
-	if (policy == SCHED_BATCH)
-		p->sleep_avg = 0;
-	if (policy == SCHED_NORMAL && sched_interactive == 0)
-		p->sleep_avg = 0;
 	set_load_weight(p);
 }

@@ -4733,35 +4572,21 @@
 asmlinkage long sys_sched_yield(void)
 {
 	struct rq *rq = this_rq_lock();
-	struct prio_array *array = current->array, *target = rq->expired;
+	struct prio_array *array = current->array;

 	schedstat_inc(rq, yld_cnt);
-	/*
-	 * We implement yielding by moving the task into the expired
-	 * queue.
-	 *
-	 * (special rule: RT tasks will just roundrobin in the active
-	 *  array.)
-	 */
-	if (rt_task(current))
-		target = rq->active;

-	if (array->nr_active == 1) {
+	if (array->nr_active == 1)
 		schedstat_inc(rq, yld_act_empty);
-		if (!rq->expired->nr_active)
-			schedstat_inc(rq, yld_both_empty);
-	} else if (!rq->expired->nr_active)
-		schedstat_inc(rq, yld_exp_empty);

-	if (array != target) {
-		dequeue_task(current, array);
-		enqueue_task(current, target);
-	} else
-		/*
-		 * requeue_task is cheaper so perform that if possible.
-		 */
+	if (rt_task(current))
 		requeue_task(current, array);
-
+	else {
+		dequeue_task(current, array);
+		if normal_task(current)
+			current->prio = INSIDE_PRIO;
+		enqueue_task(current, array);
+	}
 	/*
 	 * Since we are going to call schedule() anyway, there's
 	 * no need to preempt or enable interrupts:
@@ -5096,9 +4921,8 @@
 	unsigned long flags;

 	idle->timestamp = sched_clock();
-	idle->sleep_avg = 0;
 	idle->array = NULL;
-	idle->prio = idle->normal_prio = MAX_PRIO;
+	idle->prio = idle->normal_prio = MAX_RQ_PRIO;
 	idle->state = TASK_RUNNING;
 	idle->cpus_allowed = cpumask_of_cpu(cpu);
 	set_task_cpu(idle, cpu);
@@ -5451,8 +5275,8 @@
 	struct rq *rq = cpu_rq(dead_cpu);
 	unsigned int arr, i;

-	for (arr = 0; arr < 2; arr++) {
-		for (i = 0; i < MAX_PRIO; i++) {
+	for (arr = 0; arr < 1; arr++) {
+		for (i = 0; i < MAX_RQ_PRIO; i++) {
 			struct list_head *list = &rq->arrays[arr].queue[i];

 			while (!list_empty(list))
@@ -7119,8 +6943,6 @@
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
 		rq->active = rq->arrays;
-		rq->expired = rq->arrays + 1;
-		rq->best_expired_prio = MAX_PRIO;

 #ifdef CONFIG_SMP
 		rq->sd = NULL;
@@ -7134,14 +6956,14 @@
 #endif
 		atomic_set(&rq->nr_iowait, 0);

-		for (j = 0; j < 2; j++) {
+		for (j = 0; j < 1; j++) {
 			array = rq->arrays + j;
-			for (k = 0; k < MAX_PRIO; k++) {
+			for (k = 0; k < MAX_RQ_PRIO; k++) {
 				INIT_LIST_HEAD(array->queue + k);
 				__clear_bit(k, array->bitmap);
 			}
 			// delimiter for bitsearch
-			__set_bit(MAX_PRIO, array->bitmap);
+			__set_bit(MAX_RQ_PRIO, array->bitmap);
 		}
 	}


--- linux-2.6.18.i686_org/include/linux/sched.h	2011-02-28
18:45:54.000000000 +0800
+++ linux-2.6.18.i686/include/linux/sched.h	2011-03-16 21:47:44.000000000 +0800
@@ -556,6 +556,15 @@
 	return &container_of(sig, struct signal_with_aux_struct, sig)->aux;
 }

+struct migration_req {
+	struct list_head list;
+
+	struct task_struct *task;
+	int dest_cpu;
+
+	struct completion done;
+};
+
 /* Context switch must be unlocked if interrupts are to be enabled */
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 # define __ARCH_WANT_UNLOCKED_CTXSW
@@ -888,6 +897,7 @@
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	int oncpu;
 #endif
+	struct migration_req req;
 #endif
 	int load_weight;	/* for niceness load balancing purposes */
 	int prio, static_prio, normal_prio;
