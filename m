Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0DNAKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 20:10:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14426 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab0DNAKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 20:10:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=jaMgY40XU9+7GCjoDGWjdNoig/gMAeqwwDyw4Xdn2gOzUQXiLp3CfDYug1hNNj6Vy
	xnvZCMWPS0Bv+Lgop/E7A==
Subject: [PATCH 2/3] [kidled]: Add eager injection.
To: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       linux-pm@lists.linux-foundation.org, arjan@infradead.org
From: Salman <sqazi@google.com>
Cc: csadler@google.com, ranjitm@google.com, kenchen@google.com,
       dawnchen@google.com
Date: Tue, 13 Apr 2010 17:08:43 -0700
Message-ID: <20100414000838.29004.1513.stgit@bumblebee1.mtv.corp.google.com>
In-Reply-To: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Salman Qazi <sqazi@google.com>

We add the concept of a "power interactive" task group.  This is a task
group that, for the purposes of power capping, will recieve special treatment.

When there are no power interactive tasks on the runqueue, we inject idle
cycles unless we have already met the quota.  However, when there are
power interactive tasks on the runqueue, we only inject idle cycles if we
would otherwise fail to meet the quota.  As a result, we try our very best
to not hit the interactive tasks with the idle cycles.  The power
interactivity status of a task group is determined by the boolean value
in cpu.power_interactive.

Signed-off-by: Salman Qazi <sqazi@google.com>
---
 Documentation/kidled.txt |   15 ++++
 include/linux/kidled.h   |   34 +++++++++
 include/linux/sched.h    |    3 +
 kernel/kidled.c          |  166 +++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched.c           |   80 ++++++++++++++++++++++
 5 files changed, 285 insertions(+), 13 deletions(-)

diff --git a/Documentation/kidled.txt b/Documentation/kidled.txt
index 1149e3f..564aa00 100644
--- a/Documentation/kidled.txt
+++ b/Documentation/kidled.txt
@@ -25,7 +25,7 @@ injected idle cycles are by convention reported as busy time, attributed to
 kidled.
 
 
-Operation:
+Basic Operation:
 
 The injecting component of the idle cycle injector is the kernel thread
 kidled.  The measurements to determine when to inject idle cycles is done
@@ -38,3 +38,16 @@ quota.  If that's the case, then we inject idle cycles until the end of the
 interval.
 
 
+Eager Injection:
+
+Above is true, when there is at least one tasks marked "interactive" on
+the CPU runqueue for the duration of the interval.  Marking a task
+interactive involves setting power_interactive to 1 in its parent CPU
+cgroup.  When such no such task is runnable and when we have not achieved
+the minimum idle percentage for the interval, we eagerly inject idle cycles.
+The purpose for doing so is to inject as many of the idle cycles as possible
+while the interactive tasks are not running.  Thus, when the interactive
+tasks become runnable, they are more likely to fall in an interval when we
+aren't forcing the CPU idle.
+
+
diff --git a/include/linux/kidled.h b/include/linux/kidled.h
index 7940dfa..05c4ae5 100644
--- a/include/linux/kidled.h
+++ b/include/linux/kidled.h
@@ -11,6 +11,7 @@
 #define _IDLED_H
 
 DECLARE_PER_CPU(unsigned long, cpu_lazy_inject_count);
+DECLARE_PER_CPU(unsigned long, cpu_eager_inject_count);
 
 static inline s64 current_cpu_lazy_inject_count(void)
 {
@@ -18,9 +19,16 @@ static inline s64 current_cpu_lazy_inject_count(void)
 	return __get_cpu_var(cpu_lazy_inject_count);
 }
 
+static inline s64 current_cpu_eager_inject_count(void)
+{
+	/* We update this value in the idle cycle injector */
+	return __get_cpu_var(cpu_eager_inject_count);
+}
+
 static inline s64 current_cpu_inject_count(void)
 {
-	return current_cpu_lazy_inject_count();
+	return current_cpu_lazy_inject_count() +
+		current_cpu_eager_inject_count();
 }
 
 
@@ -42,4 +50,28 @@ static inline s64 current_cpu_busy_count(void)
 void kidled_interrupt_enter(void);
 void set_cpu_idle_ratio(int cpu, long idle_time, long busy_time);
 void get_cpu_idle_ratio(int cpu, long *idle_time, long *busy_time);
+
+enum ici_enum {
+	ICI_LAZY,
+	ICI_EAGER,
+};
+
+DECLARE_PER_CPU(enum ici_enum, ici_state);
+
+static inline int ici_in_eager_mode(void)
+{
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+	return (__get_cpu_var(ici_state) == ICI_EAGER);
+#else
+	return 0;
+#endif
+}
+
+int  kidled_running(void);
+struct task_struct *get_kidled_task(int cpu);
+int  is_ici_thread(struct task_struct *p);
+void kidled_interrupt_enter(void);
+void set_cpu_idle_ratio(int cpu, long idle_time, long busy_time);
+void get_cpu_idle_ratio(int cpu, long *idle_time, long *busy_time);
+extern int should_eager_inject(void);
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 78efe7c..1f94f21 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1566,6 +1566,9 @@ struct task_struct {
 		unsigned long memsw_bytes; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+	int power_interactive;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/kernel/kidled.c b/kernel/kidled.c
index f590178..4e7aff3 100644
--- a/kernel/kidled.c
+++ b/kernel/kidled.c
@@ -45,10 +45,16 @@ struct kidled_inputs {
 };
 
 static int kidled_init_completed;
+
+DEFINE_PER_CPU(enum ici_enum, ici_state);
 static DEFINE_PER_CPU(struct task_struct *, kidled_thread);
 static DEFINE_PER_CPU(struct kidled_inputs, kidled_inputs);
 
 DEFINE_PER_CPU(unsigned long, cpu_lazy_inject_count);
+DEFINE_PER_CPU(unsigned long, cpu_eager_inject_count);
+
+static int sysctl_ici_lb_prio;
+static int ici_lb_prio_max = MAX_PRIO - MAX_RT_PRIO - 1;
 
 struct monitor_cpu_data {
 	int cpu;
@@ -58,10 +64,26 @@ struct monitor_cpu_data {
 	long max_cpu_time;
 	long clock_time;
 	long cpu_time;
+	long eager_inject_goal;
 };
 
 static DEFINE_PER_CPU(struct monitor_cpu_data, monitor_cpu_data);
 
+int get_ici_lb_prio(void)
+{
+	return sysctl_ici_lb_prio;
+}
+
+int is_ici_thread(struct task_struct *p)
+{
+	return per_cpu(kidled_thread, task_cpu(p)) == p;
+}
+
+int kidled_running(void)
+{
+	return __get_cpu_var(kidled_thread)->se.on_rq;
+}
+
 
 static DEFINE_PER_CPU(int, in_lazy_inject);
 static DEFINE_PER_CPU(unsigned long, inject_start);
@@ -98,6 +120,40 @@ static void exit_lazy_inject(void)
 	local_irq_enable();
 }
 
+static DEFINE_PER_CPU(int, in_eager_inject);
+static void __enter_eager_inject(void)
+{
+	if (!__get_cpu_var(in_eager_inject)) {
+		__get_cpu_var(inject_start) = ktime_to_ns(ktime_get());
+		__get_cpu_var(in_eager_inject) = 1;
+	}
+	enter_idle();
+}
+
+static void __exit_eager_inject(void)
+{
+	if (__get_cpu_var(in_eager_inject)) {
+		__get_cpu_var(cpu_eager_inject_count) +=
+			ktime_to_ns(ktime_get()) - __get_cpu_var(inject_start);
+		__get_cpu_var(in_eager_inject) = 0;
+	}
+	__exit_idle();
+}
+
+static void enter_eager_inject(void)
+{
+	local_irq_disable();
+	__enter_eager_inject();
+	local_irq_enable();
+}
+
+static void exit_eager_inject(void)
+{
+	local_irq_disable();
+	__exit_eager_inject();
+	local_irq_enable();
+}
+
 /* Caller must have interrupts disabled */
 void kidled_interrupt_enter(void)
 {
@@ -105,6 +161,7 @@ void kidled_interrupt_enter(void)
 		return;
 
 	__exit_lazy_inject();
+	__exit_eager_inject();
 }
 
 static DEFINE_PER_CPU(int, still_lazy_injecting);
@@ -168,8 +225,25 @@ static DEFINE_PER_CPU(int, still_monitoring);
 /*
  * Tells us when we would need to wake up next.
  */
-long get_next_timer(struct monitor_cpu_data *data)
+static void eager_inject(void)
+{
+	while (should_eager_inject() && __get_cpu_var(still_monitoring)
+			 && ici_in_eager_mode()) {
+		enter_eager_inject();
+		do_idle();
+		exit_eager_inject();
+		cond_resched();
+	}
+}
+
+/*
+ * Tells us when we would need to wake up next
+ */
+long get_next_timer(struct monitor_cpu_data *data,
+			enum ici_enum *state)
 {
+	long next_timer;
+	long rounded_eager;
 	long lazy;
 
 	lazy = min(data->max_cpu_time - data->cpu_time,
@@ -177,7 +251,19 @@ long get_next_timer(struct monitor_cpu_data *data)
 
 	lazy -= SLEEP_GRANULARITY - 1;
 
-	return lazy;
+	if (data->eager_inject_goal > 0) {
+		*state = ICI_EAGER;
+		if (!should_eager_inject())
+			rounded_eager = NSEC_PER_MSEC;
+		else
+			rounded_eager = roundup(data->eager_inject_goal,
+						SLEEP_GRANULARITY);
+		next_timer = min(lazy, rounded_eager);
+	} else {
+		*state = ICI_LAZY;
+		next_timer = lazy;
+	}
+	return next_timer;
 }
 
 /*
@@ -191,32 +277,51 @@ long get_next_timer(struct monitor_cpu_data *data)
 static enum hrtimer_restart monitor_cpu_timer_func(struct hrtimer *timer)
 {
 	long next_timer;
+	enum ici_enum old_state;
 	struct monitor_cpu_data *data = &__get_cpu_var(monitor_cpu_data);
 
 	BUG_ON(data->cpu != smp_processor_id());
 	data->clock_time = ktime_to_ns(ktime_get()) - data->base_clock_count;
 	data->cpu_time = current_cpu_busy_count() - data->base_cpu_count;
+	data->eager_inject_goal = (data->max_clock_time - data->max_cpu_time) -
+				(data->clock_time - data->cpu_time);
 
 	if ((data->max_clock_time - data->clock_time < SLEEP_GRANULARITY) ||
 	    (data->max_cpu_time - data->cpu_time < SLEEP_GRANULARITY)) {
 		__get_cpu_var(still_monitoring) = 0;
+		__get_cpu_var(ici_state) = ICI_LAZY;
 
 		wake_up_process(__get_cpu_var(kidled_thread));
 		return HRTIMER_NORESTART;
 	} else {
-		next_timer = get_next_timer(data);
+		old_state = __get_cpu_var(ici_state);
+		next_timer = get_next_timer(data, &__get_cpu_var(ici_state));
+
+		if (__get_cpu_var(ici_state) != old_state)
+			set_tsk_need_resched(current);
+
+		if (ici_in_eager_mode() && should_eager_inject() &&
+				!kidled_running())
+			wake_up_process(__get_cpu_var(kidled_thread));
 
 		hrtimer_forward_now(timer, ktime_set(0,  next_timer));
 		return HRTIMER_RESTART;
 	}
 }
 
+struct task_struct *get_kidled_task(int cpu)
+{
+	return per_cpu(kidled_thread, cpu);
+}
+
 /*
  * Allow other processes to use CPU for up to max_clock_time
  * clock time, and max_cpu_time CPU time.
  *
  * Accurate only up to resolution of hrtimers.
  *
+ * Invariant: This function should return with ici_state == ICI_LAZY.
+ *
  * @return: Clock time left
  */
 static unsigned long monitor_cpu(long max_clock_time, long max_cpu_time,
@@ -232,12 +337,14 @@ static unsigned long monitor_cpu(long max_clock_time, long max_cpu_time,
 	data->clock_time = 0;
 	data->cpu_time = 0;
 	data->cpu = smp_processor_id();
+	data->eager_inject_goal = max_clock_time - max_cpu_time;
 
-	first_timer =  get_next_timer(data);
+	first_timer =  get_next_timer(data, &__get_cpu_var(ici_state));
 	if (first_timer <= 0) {
 		if (left_cpu_time)
 			*left_cpu_time = max_cpu_time;
 
+		__get_cpu_var(ici_state) = ICI_LAZY;
 		return max_clock_time;
 	}
 
@@ -247,11 +354,19 @@ static unsigned long monitor_cpu(long max_clock_time, long max_cpu_time,
 	sleep_timer.function = monitor_cpu_timer_func;
 	hrtimer_start(&sleep_timer, ktime_set(0, first_timer),
 		      HRTIMER_MODE_REL);
-	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (!__get_cpu_var(still_monitoring))
-			break;
-		schedule();
+
+	while (__get_cpu_var(still_monitoring)) {
+		while (1) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (!__get_cpu_var(still_monitoring) ||
+			    (ici_in_eager_mode() && should_eager_inject())) {
+				set_current_state(TASK_RUNNING);
+				break;
+			}
+			schedule();
+		}
+
+		eager_inject();
 	}
 
 	__get_cpu_var(still_monitoring) = 0;
@@ -345,6 +460,25 @@ static void set_kidled_interval(int cpu, long interval)
 	spin_unlock(&per_cpu(kidled_inputs, cpu).lock);
 }
 
+static int proc_ici_lb_prio(struct ctl_table *table, int write,
+			    void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+	int cpu;
+	struct sched_param param = { .sched_priority = KIDLED_PRIO };
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	if (!ret && write) {
+		/* Make the scheduler set the load weight again */
+		for_each_online_cpu(cpu) {
+			sched_setscheduler(per_cpu(kidled_thread, cpu),
+					   SCHED_FIFO, &param);
+		}
+	}
+
+	return ret;
+}
+
 static int proc_min_idle_percent(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp,
 				 loff_t *ppos)
@@ -427,6 +561,7 @@ static void getstats(void *info)
 	stats[0] = current_cpu_idle_count();
 	stats[1] = current_cpu_busy_count();
 	stats[2] = current_cpu_lazy_inject_count();
+	stats[3] = current_cpu_eager_inject_count();
 }
 
 
@@ -434,7 +569,7 @@ static int proc_stats(struct ctl_table *table, int write,
 		      void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
-	unsigned long stats[3];
+	unsigned long stats[4];
 	int cpu = (int)((long)table->extra1);
 	struct ctl_table fake = {};
 
@@ -442,7 +577,7 @@ static int proc_stats(struct ctl_table *table, int write,
 		return -EINVAL;
 
 	fake.data = stats;
-	fake.maxlen = 3*sizeof(unsigned long);
+	fake.maxlen = 4*sizeof(unsigned long);
 
 	ret = smp_call_function_single(cpu, getstats, &stats, 1);
 	if (ret)
@@ -487,6 +622,15 @@ static int zero;
 
 struct ctl_table kidled_table[] = {
 	{
+		.procname	= "lb_prio",
+		.data		= &sysctl_ici_lb_prio,
+		.maxlen		= sizeof(int),
+		.proc_handler	= proc_ici_lb_prio,
+		.extra1		= &zero,
+		.extra2		= &ici_lb_prio_max,
+		.mode		= 0644,
+	},
+	{
 		.procname	= "cpu",
 		.mode		= 0555,
 		.child		= kidled_cpu_table,
diff --git a/kernel/sched.c b/kernel/sched.c
index 3a8fb30..486cab2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
+#include <linux/kidled.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -257,6 +258,9 @@ struct task_group {
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+	int power_interactive;
+#endif
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -626,6 +630,10 @@ struct rq {
 	/* BKL stats */
 	unsigned int bkl_count;
 #endif
+
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+	unsigned int nr_interactive;
+#endif
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
@@ -1888,6 +1896,13 @@ static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 	if (wakeup)
 		p->se.start_runtime = p->se.sum_exec_runtime;
 
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+	if (!p->se.on_rq) {
+		p->power_interactive = task_group(p)->power_interactive;
+		rq->nr_interactive += p->power_interactive;
+	}
+#endif
+
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, wakeup);
 	p->se.on_rq = 1;
@@ -1906,6 +1921,11 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 		}
 	}
 
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+	if (p->se.on_rq)
+		rq->nr_interactive -= p->power_interactive;
+#endif
+
 	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, sleep);
 	p->se.on_rq = 0;
@@ -5443,6 +5463,19 @@ static void put_prev_task(struct rq *rq, struct task_struct *prev)
 	prev->sched_class->put_prev_task(rq, prev);
 }
 
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+int curr_rq_has_interactive(void)
+{
+	return (this_rq()->nr_interactive > 0);
+}
+
+int should_eager_inject(void)
+{
+	return !curr_rq_has_interactive() && (!this_rq()->rt.rt_nr_running
+		|| ((this_rq()->rt.rt_nr_running == 1) && kidled_running()));
+}
+#endif
+
 /*
  * Pick up the highest-prio task:
  */
@@ -5452,6 +5485,23 @@ pick_next_task(struct rq *rq)
 	const struct sched_class *class;
 	struct task_struct *p;
 
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+	if (ici_in_eager_mode() && should_eager_inject() &&
+	    !kidled_running()) {
+		p = get_kidled_task(cpu_of(rq));
+
+		current->se.last_wakeup = current->se.sum_exec_runtime;
+
+#if defined(CONFIG_SMP) && defined(CONFIG_SCHEDSTATS)
+		schedstat_inc(rq, ttwu_count);
+		schedstat_inc(rq, ttwu_local);
+#endif
+
+		set_task_state(p, TASK_RUNNING);
+		activate_task(rq, p, 1);
+	}
+#endif
+
 	/*
 	 * Optimization: we know that if all tasks are in
 	 * the fair class we can call that function directly:
@@ -9567,6 +9617,9 @@ void __init sched_init(void)
 		rq = cpu_rq(i);
 		raw_spin_lock_init(&rq->lock);
 		rq->nr_running = 0;
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+		rq->nr_interactive = 0;
+#endif
 		rq->calc_load_active = 0;
 		rq->calc_load_update = jiffies + LOAD_FREQ;
 		init_cfs_rq(&rq->cfs, rq);
@@ -10604,6 +10657,26 @@ static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
 
 	return (u64) tg->shares;
 }
+
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+static u64 cpu_power_interactive_read_u64(struct cgroup *cgrp,
+					  struct cftype *cft)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	return (u64) tg->power_interactive;
+}
+
+static int cpu_power_interactive_write_u64(struct cgroup *cgrp,
+			struct cftype *cft, u64 interactive)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	if ((interactive < 0) || (interactive > 1))
+		return -EINVAL;
+
+	tg->power_interactive = interactive;
+	return 0;
+}
+#endif /* CONFIG_IDLE_CYCLE_INJECTOR */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -10637,6 +10710,13 @@ static struct cftype cpu_files[] = {
 		.read_u64 = cpu_shares_read_u64,
 		.write_u64 = cpu_shares_write_u64,
 	},
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+	{
+		.name = "power_interactive",
+		.read_u64 = cpu_power_interactive_read_u64,
+		.write_u64 = cpu_power_interactive_write_u64,
+	},
+#endif
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
 	{

