Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab2JTTGZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 15:06:25 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:54185 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab2JTTGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 15:06:22 -0400
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com 9F6FD83303
From: Andrea Righi <andrea@betterlinux.com>
To: Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrea Righi <andrea@betterlinux.com>
Subject: [PATCH v2 1/3] sched: introduce distinct per-cpu load average
Date: Sat, 20 Oct 2012 21:06:00 +0200
Message-Id: <1350759962-7092-2-git-send-email-andrea@betterlinux.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350759962-7092-1-git-send-email-andrea@betterlinux.com>
References: <1350759962-7092-1-git-send-email-andrea@betterlinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Account load average, nr_running and nr_uninterruptible tasks per-cpu.

The new task_struct attribute on_cpu_uninterruptible is added to
properly keep track of the cpu at deactivate time, when the task is set
to the uninterruptible sleep state.

Moreover, rq->nr_uninterruptible is converted to a percpu variable to
maintain a coherent nr_uninterruptible counter for each CPU (rather than
having a single global counter defined as the sum over all CPUs). This
adds less performance overhead than introducing atomic operations in the
wakeup/sleep path.

This feature is required by the cpusets cgroup subsystem to report the
load average per-cpuset.

Signed-off-by: Andrea Righi <andrea@betterlinux.com>
---
 include/linux/sched.h |    6 +++
 kernel/sched/core.c   |  112 ++++++++++++++++++++++++++++++++++++++++++-------
 kernel/sched/debug.c  |    3 +-
 kernel/sched/sched.h  |    8 +---
 4 files changed, 105 insertions(+), 24 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0dd42a0..e5dfe2a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -80,6 +80,8 @@ struct blk_plug;
  */
 extern unsigned long avenrun[];		/* Load averages */
 extern void get_avenrun(unsigned long *loads, unsigned long offset, int shift);
+extern void get_cpu_avenrun(unsigned long *loads, int cpu,
+				unsigned long offset, int shift);
 
 #define FSHIFT		11		/* nr of bits of precision */
 #define FIXED_1		(1<<FSHIFT)	/* 1.0 as fixed-point */
@@ -98,7 +100,9 @@ extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
 extern int nr_processes(void);
 extern unsigned long nr_running(void);
+extern unsigned long nr_running_cpu(int cpu);
 extern unsigned long nr_uninterruptible(void);
+extern unsigned long nr_uninterruptible_cpu(int cpu);
 extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
@@ -1197,6 +1201,8 @@ struct task_struct {
 #ifdef CONFIG_SMP
 	struct llist_node wake_entry;
 	int on_cpu;
+	/* Used to keep track of nr_uninterruptible tasks per-cpu */
+	int on_cpu_uninterruptible;
 #endif
 	int on_rq;
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..a1487ee 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -726,16 +726,20 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 
 void activate_task(struct rq *rq, struct task_struct *p, int flags)
 {
-	if (task_contributes_to_load(p))
-		rq->nr_uninterruptible--;
+	if (task_contributes_to_load(p)) {
+		struct rq *prev_rq = cpu_rq(p->on_cpu_uninterruptible);
+		__this_cpu_dec(*prev_rq->nr_uninterruptible);
+	}
 
 	enqueue_task(rq, p, flags);
 }
 
 void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 {
-	if (task_contributes_to_load(p))
-		rq->nr_uninterruptible++;
+	if (task_contributes_to_load(p)) {
+		__this_cpu_inc(*rq->nr_uninterruptible);
+		p->on_cpu_uninterruptible = cpu_of(rq);
+	}
 
 	dequeue_task(rq, p, flags);
 }
@@ -1277,8 +1281,10 @@ static void
 ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags)
 {
 #ifdef CONFIG_SMP
-	if (p->sched_contributes_to_load)
-		rq->nr_uninterruptible--;
+	if (p->sched_contributes_to_load) {
+		struct rq *prev_rq = cpu_rq(p->on_cpu_uninterruptible);
+		__this_cpu_dec(*prev_rq->nr_uninterruptible);
+	}
 #endif
 
 	ttwu_activate(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
@@ -1916,12 +1922,17 @@ unsigned long nr_running(void)
 	return sum;
 }
 
+unsigned long nr_running_cpu(int cpu)
+{
+	return cpu_rq(cpu)->nr_running;
+}
+
 unsigned long nr_uninterruptible(void)
 {
 	unsigned long i, sum = 0;
 
 	for_each_possible_cpu(i)
-		sum += cpu_rq(i)->nr_uninterruptible;
+		sum += nr_uninterruptible_cpu(i);
 
 	/*
 	 * Since we read the counters lockless, it might be slightly
@@ -1933,6 +1944,18 @@ unsigned long nr_uninterruptible(void)
 	return sum;
 }
 
+unsigned long nr_uninterruptible_cpu(int cpu)
+{
+	struct rq *this = cpu_rq(cpu);
+	unsigned long val = 0;
+	int i;
+
+	for_each_online_cpu(i)
+		val += per_cpu(*this->nr_uninterruptible, i);
+
+	return val;
+}
+
 unsigned long long nr_context_switches(void)
 {
 	int i;
@@ -1980,7 +2003,8 @@ unsigned long this_cpu_load(void)
  *
  *   nr_active = 0;
  *   for_each_possible_cpu(cpu)
- *   	nr_active += cpu_of(cpu)->nr_running + cpu_of(cpu)->nr_uninterruptible;
+ *	nr_active += cpu_of(cpu)->nr_running +
+ *	             (cpu_of(cpu)->nr_uninterruptible;
  *
  *   avenrun[n] = avenrun[0] * exp_n + nr_active * (1 - exp_n)
  *
@@ -2004,13 +2028,6 @@ unsigned long this_cpu_load(void)
  *    This places an upper-bound on the IRQ-off latency of the machine. Then
  *    again, being late doesn't loose the delta, just wrecks the sample.
  *
- *  - cpu_rq()->nr_uninterruptible isn't accurately tracked per-cpu because
- *    this would add another cross-cpu cacheline miss and atomic operation
- *    to the wakeup path. Instead we increment on whatever cpu the task ran
- *    when it went into uninterruptible state and decrement on whatever cpu
- *    did the wakeup. This means that only the sum of nr_uninterruptible over
- *    all cpus yields the correct result.
- *
  *  This covers the NO_HZ=n code, for extra head-aches, see the comment below.
  */
 
@@ -2035,12 +2052,15 @@ void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
 	loads[2] = (avenrun[2] + offset) << shift;
 }
 
+static DEFINE_PER_CPU(unsigned long [3], cpu_avenrun);
+
 static long calc_load_fold_active(struct rq *this_rq)
 {
 	long nr_active, delta = 0;
+	int cpu = cpu_of(this_rq);
 
 	nr_active = this_rq->nr_running;
-	nr_active += (long) this_rq->nr_uninterruptible;
+	nr_active += (long) nr_uninterruptible_cpu(cpu);
 
 	if (nr_active != this_rq->calc_load_active) {
 		delta = nr_active - this_rq->calc_load_active;
@@ -2062,6 +2082,23 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
 	return load >> FSHIFT;
 }
 
+static void calc_global_load_percpu(void)
+{
+	long active;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		unsigned long *this_avenrun = per_cpu(cpu_avenrun, cpu);
+
+		active = cpu_rq(cpu)->calc_load_active;
+		active = active > 0 ? active * FIXED_1 : 0;
+
+		this_avenrun[0] = calc_load(this_avenrun[0], EXP_1, active);
+		this_avenrun[1] = calc_load(this_avenrun[1], EXP_5, active);
+		this_avenrun[2] = calc_load(this_avenrun[2], EXP_15, active);
+	}
+}
+
 #ifdef CONFIG_NO_HZ
 /*
  * Handle NO_HZ for the global load-average.
@@ -2248,6 +2285,25 @@ calc_load_n(unsigned long load, unsigned long exp,
 	return calc_load(load, fixed_power_int(exp, FSHIFT, n), active);
 }
 
+static void calc_global_load_n_percpu(unsigned int n)
+{
+	long active;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		unsigned long *this_avenrun = per_cpu(cpu_avenrun, cpu);
+
+		active = cpu_rq(cpu)->calc_load_active;
+		active = active > 0 ? active * FIXED_1 : 0;
+
+		this_avenrun[0] = calc_load_n(this_avenrun[0],
+					      EXP_1, active, n);
+		this_avenrun[1] = calc_load_n(this_avenrun[1],
+					      EXP_5, active, n);
+		this_avenrun[2] = calc_load_n(this_avenrun[2],
+					      EXP_15, active, n);
+	}
+}
 /*
  * NO_HZ can leave us missing all per-cpu ticks calling
  * calc_load_account_active(), but since an idle CPU folds its delta into
@@ -2275,6 +2331,8 @@ static void calc_global_nohz(void)
 		avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
 		avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
 
+		calc_global_load_n_percpu(n);
+
 		calc_load_update += n * LOAD_FREQ;
 	}
 
@@ -2320,6 +2378,8 @@ void calc_global_load(unsigned long ticks)
 	avenrun[1] = calc_load(avenrun[1], EXP_5, active);
 	avenrun[2] = calc_load(avenrun[2], EXP_15, active);
 
+	calc_global_load_percpu();
+
 	calc_load_update += LOAD_FREQ;
 
 	/*
@@ -2328,6 +2388,24 @@ void calc_global_load(unsigned long ticks)
 	calc_global_nohz();
 }
 
+/**
+ * get_cpu_avenrun - get the load average array of a single cpu
+ * @loads:	pointer to dest load array
+ * @cpu:	the cpu to read the load average
+ * @offset:	offset to add
+ * @shift:	shift count to shift the result left
+ *
+ * These values are estimates at best, so no need for locking.
+ */
+void get_cpu_avenrun(unsigned long *loads, int cpu,
+			unsigned long offset, int shift)
+{
+	unsigned long *this_avenrun = per_cpu(cpu_avenrun, cpu);
+
+	loads[0] = (this_avenrun[0] + offset) << shift;
+	loads[1] = (this_avenrun[1] + offset) << shift;
+	loads[2] = (this_avenrun[2] + offset) << shift;
+}
 /*
  * Called from update_cpu_load() to periodically update this CPU's
  * active count.
@@ -6873,6 +6951,8 @@ void __init sched_init(void)
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
+		rq->nr_uninterruptible = alloc_percpu(unsigned long);
+		BUG_ON(!rq->nr_uninterruptible);
 	}
 
 	set_load_weight(&init_task);
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 6f79596..ac6c73f 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -276,7 +276,8 @@ do {									\
 		   rq->load.weight);
 	P(nr_switches);
 	P(nr_load_updates);
-	P(nr_uninterruptible);
+	SEQ_printf(m, "  .%-30s: %lu\n", "nr_uninterruptible",
+		   nr_uninterruptible_cpu(cpu));
 	PN(next_balance);
 	P(curr->pid);
 	PN(clock);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7a7db09..8a0d303 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -383,13 +383,7 @@ struct rq {
 	struct list_head leaf_rt_rq_list;
 #endif
 
-	/*
-	 * This is part of a global counter where only the total sum
-	 * over all CPUs matters. A task can increase this counter on
-	 * one CPU and if it got migrated afterwards it may decrease
-	 * it on another CPU. Always updated under the runqueue lock:
-	 */
-	unsigned long nr_uninterruptible;
+	unsigned long __percpu *nr_uninterruptible;
 
 	struct task_struct *curr, *idle, *stop;
 	unsigned long next_balance;
-- 
1.7.10.4

