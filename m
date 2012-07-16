Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2GPQHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:07:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5198 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2GPQHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:07:50 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=tQnG0VchYtK-knbnTC4A:9 a=PUjeQqilurYA:10 a=sETkh70xTn03NYqa:21 a=FJj7F_PKEpJR8Icx:21 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342454868.6882.2.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.2.22-rt35
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Mon, 16 Jul 2012 12:07:48 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.22-rt35 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 852c3bd6c35aa3718de57c87f1a3bcd4dc69af3d


Or to build 3.2.22-rt35 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.22.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.22-rt35.patch.xz


You can also build from 3.2.22-rt34 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.22-rt34-rt35.patch.xz


Note, I've upgraded to Evolution 3.4.3 on my Debian (testing) system,
and I've had nothing but trouble. It locks up and it no longer accesses
the address book. This has caused some issues in my work flow as I use
my address book and Evolution in the RT release process :-p

Enjoy,

-- Steve


Changes from 3.2.22-rt34:

---

Carsten Emde (4):
      Latency histogramms: Cope with backwards running local trace clock
      Latency histograms: Adjust timer, if already elapsed when programmed
      Disable RT_GROUP_SCHED in PREEMPT_RT_FULL
      Latency histograms: Detect another yet overlooked sharedprio condition

Mike Galbraith (1):
      fs, jbd: pull your plug when waiting for space

Steven Rostedt (1):
      Linux 3.2.22-rt35

Thomas Gleixner (1):
      slab: Prevent local lock deadlock

Yong Zhang (1):
      perf: Make swevent hrtimer run in irq instead of softirq

----
 fs/jbd/checkpoint.c         |    2 ++
 include/linux/hrtimer.h     |    3 ++
 include/linux/sched.h       |    2 +-
 init/Kconfig                |    1 +
 kernel/events/core.c        |    1 +
 kernel/hrtimer.c            |   16 ++++++++--
 kernel/trace/latency_hist.c |   74 +++++++++++++++++++++++--------------------
 localversion-rt             |    2 +-
 mm/slab.c                   |   26 ++++++++++++---
 9 files changed, 85 insertions(+), 42 deletions(-)
---------------------------
diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index 5c93ffc..ddbd223 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -129,6 +129,8 @@ void __log_wait_for_space(journal_t *journal)
 		if (journal->j_flags & JFS_ABORT)
 			return;
 		spin_unlock(&journal->j_state_lock);
+		if (current->plug)
+			io_schedule();
 		mutex_lock(&journal->j_checkpoint_mutex);
 
 		/*
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 0e37086..7408760 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -113,6 +113,9 @@ struct hrtimer {
 	unsigned long			state;
 	struct list_head		cb_entry;
 	int				irqsafe;
+#ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
+	ktime_t 			praecox;
+#endif
 #ifdef CONFIG_TIMER_STATS
 	int				start_pid;
 	void				*start_site;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1f6b11a..0174e3a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1585,7 +1585,7 @@ struct task_struct {
 #ifdef CONFIG_WAKEUP_LATENCY_HIST
 	u64 preempt_timestamp_hist;
 #ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
-	unsigned long timer_offset;
+	long timer_offset;
 #endif
 #endif
 #endif /* CONFIG_TRACING */
diff --git a/init/Kconfig b/init/Kconfig
index dbc82d0..720c182 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -731,6 +731,7 @@ config RT_GROUP_SCHED
 	bool "Group scheduling for SCHED_RR/FIFO"
 	depends on EXPERIMENTAL
 	depends on CGROUP_SCHED
+	depends on !PREEMPT_RT_FULL
 	default n
 	help
 	  This feature lets you explicitly allocate real CPU bandwidth
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 58690af..4d9159a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5420,6 +5420,7 @@ static void perf_swevent_init_hrtimer(struct perf_event *event)
 
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hwc->hrtimer.function = perf_swevent_hrtimer;
+	hwc->hrtimer.irqsafe = 1;
 
 	/*
 	 * Since hrtimers have a fixed rate, we can do a static freq->period
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 3991464..a080e62 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1021,6 +1021,17 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 #endif
 	}
 
+#ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
+	{
+		ktime_t now = new_base->get_time();
+
+		if (ktime_to_ns(tim) < ktime_to_ns(now))
+			timer->praecox = now;
+		else
+			timer->praecox = ktime_set(0, 0);
+	}
+#endif
+
 	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
 
 	timer_stats_hrtimer_set_start_info(timer);
@@ -1458,8 +1469,9 @@ retry:
 			timer = container_of(node, struct hrtimer, node);
 
 			trace_hrtimer_interrupt(raw_smp_processor_id(),
-			    ktime_to_ns(ktime_sub(
-				hrtimer_get_expires(timer), basenow)),
+			    ktime_to_ns(ktime_sub(ktime_to_ns(timer->praecox) ?
+				timer->praecox : hrtimer_get_expires(timer),
+				basenow)),
 			    current,
 			    timer->function == hrtimer_wakeup ?
 			    container_of(timer, struct hrtimer_sleeper,
diff --git a/kernel/trace/latency_hist.c b/kernel/trace/latency_hist.c
index 9d49fcb..6a4c869 100644
--- a/kernel/trace/latency_hist.c
+++ b/kernel/trace/latency_hist.c
@@ -27,6 +27,8 @@
 #include "trace.h"
 #include <trace/events/sched.h>
 
+#define NSECS_PER_USECS 1000L
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/hist.h>
 
@@ -46,11 +48,11 @@ enum {
 struct hist_data {
 	atomic_t hist_mode; /* 0 log, 1 don't log */
 	long offset; /* set it to MAX_ENTRY_NUM/2 for a bipolar scale */
-	unsigned long min_lat;
-	unsigned long max_lat;
+	long min_lat;
+	long max_lat;
 	unsigned long long below_hist_bound_samples;
 	unsigned long long above_hist_bound_samples;
-	unsigned long long accumulate_lat;
+	long long accumulate_lat;
 	unsigned long long total_samples;
 	unsigned long long hist_array[MAX_ENTRY_NUM];
 };
@@ -152,8 +154,8 @@ static struct enable_data timerandwakeup_enabled_data = {
 static DEFINE_PER_CPU(struct maxlatproc_data, timerandwakeup_maxlatproc);
 #endif
 
-void notrace latency_hist(int latency_type, int cpu, unsigned long latency,
-			  unsigned long timeroffset, cycle_t stop,
+void notrace latency_hist(int latency_type, int cpu, long latency,
+			  long timeroffset, cycle_t stop,
 			  struct task_struct *p)
 {
 	struct hist_data *my_hist;
@@ -224,7 +226,7 @@ void notrace latency_hist(int latency_type, int cpu, unsigned long latency,
 		my_hist->hist_array[latency]++;
 
 	if (unlikely(latency > my_hist->max_lat ||
-	    my_hist->min_lat == ULONG_MAX)) {
+	    my_hist->min_lat == LONG_MAX)) {
 #if defined(CONFIG_WAKEUP_LATENCY_HIST) || \
     defined(CONFIG_MISSED_TIMER_OFFSETS_HIST)
 		if (latency_type == WAKEUP_LATENCY ||
@@ -263,15 +265,14 @@ static void *l_start(struct seq_file *m, loff_t *pos)
 		atomic_dec(&my_hist->hist_mode);
 
 		if (likely(my_hist->total_samples)) {
-			unsigned long avg = (unsigned long)
-			    div64_u64(my_hist->accumulate_lat,
+			long avg = (long) div64_s64(my_hist->accumulate_lat,
 			    my_hist->total_samples);
 			snprintf(minstr, sizeof(minstr), "%ld",
-			    (long) my_hist->min_lat - my_hist->offset);
+			    my_hist->min_lat - my_hist->offset);
 			snprintf(avgstr, sizeof(avgstr), "%ld",
-			    (long) avg - my_hist->offset);
+			    avg - my_hist->offset);
 			snprintf(maxstr, sizeof(maxstr), "%ld",
-			    (long) my_hist->max_lat - my_hist->offset);
+			    my_hist->max_lat - my_hist->offset);
 		} else {
 			strcpy(minstr, "<undef>");
 			strcpy(avgstr, minstr);
@@ -376,10 +377,10 @@ static void hist_reset(struct hist_data *hist)
 	memset(hist->hist_array, 0, sizeof(hist->hist_array));
 	hist->below_hist_bound_samples = 0ULL;
 	hist->above_hist_bound_samples = 0ULL;
-	hist->min_lat = ULONG_MAX;
-	hist->max_lat = 0UL;
+	hist->min_lat = LONG_MAX;
+	hist->max_lat = LONG_MIN;
 	hist->total_samples = 0ULL;
-	hist->accumulate_lat = 0ULL;
+	hist->accumulate_lat = 0LL;
 
 	atomic_inc(&hist->hist_mode);
 }
@@ -790,9 +791,9 @@ static notrace void probe_preemptirqsoff_hist(void *v, int reason,
 
 			stop = ftrace_now(cpu);
 			time_set++;
-			if (start && stop >= start) {
-				unsigned long latency =
-				    nsecs_to_usecs(stop - start);
+			if (start) {
+				long latency = ((long) (stop - start)) /
+				    NSECS_PER_USECS;
 
 				latency_hist(IRQSOFF_LATENCY, cpu, latency, 0,
 				    stop, NULL);
@@ -808,9 +809,9 @@ static notrace void probe_preemptirqsoff_hist(void *v, int reason,
 
 			if (!(time_set++))
 				stop = ftrace_now(cpu);
-			if (start && stop >= start) {
-				unsigned long latency =
-				    nsecs_to_usecs(stop - start);
+			if (start) {
+				long latency = ((long) (stop - start)) /
+				    NSECS_PER_USECS;
 
 				latency_hist(PREEMPTOFF_LATENCY, cpu, latency,
 				    0, stop, NULL);
@@ -827,9 +828,10 @@ static notrace void probe_preemptirqsoff_hist(void *v, int reason,
 
 			if (!time_set)
 				stop = ftrace_now(cpu);
-			if (start && stop >= start) {
-				unsigned long latency =
-				    nsecs_to_usecs(stop - start);
+			if (start) {
+				long latency = ((long) (stop - start)) /
+				    NSECS_PER_USECS;
+
 				latency_hist(PREEMPTIRQSOFF_LATENCY, cpu,
 				    latency, 0, stop, NULL);
 			}
@@ -908,7 +910,7 @@ static notrace void probe_wakeup_latency_hist_stop(void *v,
 {
 	unsigned long flags;
 	int cpu = task_cpu(next);
-	unsigned long latency;
+	long latency;
 	cycle_t stop;
 	struct task_struct *cpu_wakeup_task;
 
@@ -933,13 +935,17 @@ static notrace void probe_wakeup_latency_hist_stop(void *v,
 		goto out;
 	}
 
+	if (current->prio == cpu_wakeup_task->prio)
+		per_cpu(wakeup_sharedprio, cpu) = 1;
+
 	/*
 	 * The task we are waiting for is about to be switched to.
 	 * Calculate latency and store it in histogram.
 	 */
 	stop = ftrace_now(raw_smp_processor_id());
 
-	latency = nsecs_to_usecs(stop - next->preempt_timestamp_hist);
+	latency = ((long) (stop - next->preempt_timestamp_hist)) /
+	    NSECS_PER_USECS;
 
 	if (per_cpu(wakeup_sharedprio, cpu)) {
 		latency_hist(WAKEUP_LATENCY_SHAREDPRIO, cpu, latency, 0, stop,
@@ -975,7 +981,7 @@ static notrace void probe_hrtimer_interrupt(void *v, int cpu,
 	    (task->prio < curr->prio ||
 	    (task->prio == curr->prio &&
 	    !cpumask_test_cpu(cpu, &task->cpus_allowed)))) {
-		unsigned long latency;
+		long latency;
 		cycle_t now;
 
 		if (missed_timer_offsets_pid) {
@@ -985,7 +991,7 @@ static notrace void probe_hrtimer_interrupt(void *v, int cpu,
 		}
 
 		now = ftrace_now(cpu);
-		latency = (unsigned long) div_s64(-latency_ns, 1000);
+		latency = (long) div_s64(-latency_ns, NSECS_PER_USECS);
 		latency_hist(MISSED_TIMER_OFFSETS, cpu, latency, latency, now,
 		    task);
 #ifdef CONFIG_WAKEUP_LATENCY_HIST
@@ -1026,7 +1032,7 @@ static __init int latency_hist_init(void)
 		    &per_cpu(irqsoff_hist, i), &latency_hist_fops);
 		my_hist = &per_cpu(irqsoff_hist, i);
 		atomic_set(&my_hist->hist_mode, 1);
-		my_hist->min_lat = 0xFFFFFFFFUL;
+		my_hist->min_lat = LONG_MAX;
 	}
 	entry = debugfs_create_file("reset", 0644, dentry,
 	    (void *)IRQSOFF_LATENCY, &latency_hist_reset_fops);
@@ -1041,7 +1047,7 @@ static __init int latency_hist_init(void)
 		    &per_cpu(preemptoff_hist, i), &latency_hist_fops);
 		my_hist = &per_cpu(preemptoff_hist, i);
 		atomic_set(&my_hist->hist_mode, 1);
-		my_hist->min_lat = 0xFFFFFFFFUL;
+		my_hist->min_lat = LONG_MAX;
 	}
 	entry = debugfs_create_file("reset", 0644, dentry,
 	    (void *)PREEMPTOFF_LATENCY, &latency_hist_reset_fops);
@@ -1056,7 +1062,7 @@ static __init int latency_hist_init(void)
 		    &per_cpu(preemptirqsoff_hist, i), &latency_hist_fops);
 		my_hist = &per_cpu(preemptirqsoff_hist, i);
 		atomic_set(&my_hist->hist_mode, 1);
-		my_hist->min_lat = 0xFFFFFFFFUL;
+		my_hist->min_lat = LONG_MAX;
 	}
 	entry = debugfs_create_file("reset", 0644, dentry,
 	    (void *)PREEMPTIRQSOFF_LATENCY, &latency_hist_reset_fops);
@@ -1081,14 +1087,14 @@ static __init int latency_hist_init(void)
 		    &latency_hist_fops);
 		my_hist = &per_cpu(wakeup_latency_hist, i);
 		atomic_set(&my_hist->hist_mode, 1);
-		my_hist->min_lat = 0xFFFFFFFFUL;
+		my_hist->min_lat = LONG_MAX;
 
 		entry = debugfs_create_file(name, 0444, dentry_sharedprio,
 		    &per_cpu(wakeup_latency_hist_sharedprio, i),
 		    &latency_hist_fops);
 		my_hist = &per_cpu(wakeup_latency_hist_sharedprio, i);
 		atomic_set(&my_hist->hist_mode, 1);
-		my_hist->min_lat = 0xFFFFFFFFUL;
+		my_hist->min_lat = LONG_MAX;
 
 		sprintf(name, cpufmt_maxlatproc, i);
 
@@ -1122,7 +1128,7 @@ static __init int latency_hist_init(void)
 		    &per_cpu(missed_timer_offsets, i), &latency_hist_fops);
 		my_hist = &per_cpu(missed_timer_offsets, i);
 		atomic_set(&my_hist->hist_mode, 1);
-		my_hist->min_lat = 0xFFFFFFFFUL;
+		my_hist->min_lat = LONG_MAX;
 
 		sprintf(name, cpufmt_maxlatproc, i);
 		mp = &per_cpu(missed_timer_offsets_maxlatproc, i);
@@ -1150,7 +1156,7 @@ static __init int latency_hist_init(void)
 		    &latency_hist_fops);
 		my_hist = &per_cpu(timerandwakeup_latency_hist, i);
 		atomic_set(&my_hist->hist_mode, 1);
-		my_hist->min_lat = 0xFFFFFFFFUL;
+		my_hist->min_lat = LONG_MAX;
 
 		sprintf(name, cpufmt_maxlatproc, i);
 		mp = &per_cpu(timerandwakeup_maxlatproc, i);
diff --git a/localversion-rt b/localversion-rt
index 21988f9..366440d 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt34
+-rt35
diff --git a/mm/slab.c b/mm/slab.c
index 5f0c5ef..3bef5e5 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -739,8 +739,26 @@ slab_on_each_cpu(void (*func)(void *arg, int this_cpu), void *arg)
 {
 	unsigned int i;
 
+	get_cpu_light();
 	for_each_online_cpu(i)
 		func(arg, i);
+	put_cpu_light();
+}
+
+static void lock_slab_on(unsigned int cpu)
+{
+	if (cpu == smp_processor_id())
+		local_lock_irq(slab_lock);
+	else
+		local_spin_lock_irq(slab_lock, &per_cpu(slab_lock, cpu).lock);
+}
+
+static void unlock_slab_on(unsigned int cpu)
+{
+	if (cpu == smp_processor_id())
+		local_unlock_irq(slab_lock);
+	else
+		local_spin_unlock_irq(slab_lock, &per_cpu(slab_lock, cpu).lock);
 }
 #endif
 
@@ -2627,10 +2645,10 @@ static void do_drain(void *arg, int cpu)
 {
 	LIST_HEAD(tmp);
 
-	spin_lock_irq(&per_cpu(slab_lock, cpu).lock);
+	lock_slab_on(cpu);
 	__do_drain(arg, cpu);
 	list_splice_init(&per_cpu(slab_free_list, cpu), &tmp);
-	spin_unlock_irq(&per_cpu(slab_lock, cpu).lock);
+	unlock_slab_on(cpu);
 	free_delayed(&tmp);
 }
 #endif
@@ -4095,9 +4113,9 @@ static void do_ccupdate_local(void *info)
 #else
 static void do_ccupdate_local(void *info, int cpu)
 {
-	spin_lock_irq(&per_cpu(slab_lock, cpu).lock);
+	lock_slab_on(cpu);
 	__do_ccupdate_local(info, cpu);
-	spin_unlock_irq(&per_cpu(slab_lock, cpu).lock);
+	unlock_slab_on(cpu);
 }
 #endif
 


