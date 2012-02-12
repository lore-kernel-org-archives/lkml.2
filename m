Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab2BLSwm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 13:52:42 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44872 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab2BLSwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 13:52:40 -0500
MIME-Version: 1.0
Date: Mon, 13 Feb 2012 00:52:39 +0600
Message-ID: <CADZ9YHhOfVm7qNj6oznmRCUuyyA4BQfmsd-M7FzrmWB9SxMgzg@mail.gmail.com>
Subject: [ANNOUNCEMENT] The Barbershop Load Distribution algorithm for Linux
 kernel scheduler.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Here, I'm going to introduce an alternative load distribution
algorithm for Linux kernel scheduler. This technique is named as
"The Barbershop Load Distribution Algorigthm" or BLD for short and
will be refered as BLD from here on. As it's name implies,
 it only tries to distribute the load properly by tracking lowest and
highest loaded rq of the system. This technique never tries to
 balance the system load at idle context, which is done by the current
scheduler. The motivation behind this technique is to
distribute load properly amonst the CPUs in a way as if load balancer
isn't needed and to make load distribution easier.

Naming Reason and it's origin:
------------------------------------------
 To keep it small, this section is skipped. Interested reader should
look at rk-devel.blogspot.com and bld release with some performance
results could be found at http://code.google.com/p/bld/.

Description
----------------
 BLD is best described as a O(1) CPU picking technique. Which is done
by reordering CPU runqueues based on runqueue loads.
 In other words, it keeps the scheduler aware of the load changes,
which helps scheduler to keep runqueues in an order. This
technique doesn't depend on scheduler ticks. The two most simple
things in this technique are: load tracking and runqueue ordering;
these are relatively simpler operations. Load tracking will be done
whenever a load change happens on the system and based on
this load change runqueue will be ordered. So, if we have an ordered
runqueue from lowest to highest, then picking the less (or even
busiest) runqueue is easy. Scheduler can pick the lowest runqueue
without calculation and comparison at the time of placing a task
in a runqueue. And while trying to distribute load at sched_exec and
sched_fork our best choice is to pick the lowest busiest runqueue
of the system. And in this way, system remains balanced without doing
any load balancing. At the time of try_to_wake_up picking the idlest
runqueue is topmost priority but it has been done as per domain basis
to utilize CPU cache properly and it's an area where more
concentration is requires.


Implementation
----------------------
It's been implemented as config option and could be found under
"General setup"->
"An alternative CPU load distributor". If this option is enabled, then
current load balancing
code will be disabled.

 As described above, BLD needs to do two things:
      a) load tracking i.e load change;
      b) ordering runqueues

 a) track load: To track load we need to hook at activate_task() and
deactivate_task(). At this particular point load tracking is done,
which simply calculates the current rq load and updates it accordingly.
Runqueue loads are found by simply calling weighted_cpuload(). While
trying to keep balance at task wakeup, simply calculating weighted_cpuload()
isn't enough and needs to accumulate sleeping tasks into account.

 b) ordering runqueues: Ordering runqueues are simple and done by
linking runqueues based on load from lowest to highest. Ordering
runqueues are done after a runqueue load has been updated and makes
necessary comparision with loaded runqueues to make it
ordered. This ordering operations doesn't depend on number of
runqueues i.e CPUs and it's a constant time operation.

Runqueues are kept on a doubly linked list based on load we get from
weighted_cpuload(), which makes easier to access less busiest
queue and highest busiest queue. Maintaining runqueues with linked
list are feasible for keeping it in order and maintaining large no of
runqueues. This linked list's operations are protected with a single
read-write spinlock.

O(1) CPU picking at sched_fork() and sched_exec()
--------------------------------------------------------------------------
 At this point we've an ordered runqueues, where we can access with
help of runqueue head pointer. Current implementation doesn't
seperates offline CPU from online CPU (when HOTPLUG is enabled), so it
checks whether the first CPU of rq head is online or not. So,
CPU picking is also a O(1) operation (with side effect of CPU getting
offline, it's avoidable), when we are balancing from sched_fork and
sched_exec. At this particular moment we're allowed to move a task on
any CPU of the system, cause we've zero cache footprint.

CPU picking at task wakeup:
----------------------------------------
While picking a CPU at task waking, the lowest loaded CPU of a
particular domain will be choosen. In this way, it tries to utilize
CPU resources - this is a bit over cautious technique and an area which
needs more attention. Simply picking the lowest loaded runqueue of the
system isn't appropriate in this case. When CPU affinity is set for a
particular task, the lowest loaded CPU will be returned from task's
affinity mask by finding out the lowest loaded CPU.

Remarks
--------------
 Current implementation requires a *lot* of cleanup and it's been
messed up with #ifdef's. So, implementation is ugly and very basic.
It needs to be tested in other architechtures. So, I'm fully unware
how it'll *really* run on other architectures. So, if it hangs/crashes
your system while testing don't blaim me too hard ;-). It also wasn't
tested to make sure how it'll react upon different system settings
available on Linux kernel, like - cgroups settings, various schedule domain
flags etc . Current locking schemes might be guilty of heavy lock
contention for large systems, perhaps it could be reduced by introducing more
fine grained locking scheme. And more work is required for task waking
up balancing. It shows good performance for kernel building sort of
loads. But has some downfall for that sort of loads which is a 'single
process creates various numbers of threads' (1:N). It shows better
fairness - test was made by running "for i in `seq 1 5` ; do
tools/perf/perf bench sched pipe & done;wait" (found from previous
lkml post by Ingo Molnar).

 Personally, I was worried about CFS gets hurt by this load
distribution technique, but looking at the fairness test (perf bench
sched pipe) shows that it improves fairness. Current scheduler is a result of
years of dedicated effort of numbers of developers and a lot of
scheduler modification has been done by introducing huristics and
showing good results as per performance measuring tools. But the case
for BLD isn't same - it introduces an approach which shows how cpu load can be
distributed evenly without worrying too much about how many
number of CPUs exists and putting negative impact on system
performance isn't abnormal. So, rather simply looking at performance
results, I'd suggest readers to think about "current load balancing
approach" vs. "BLD load distribution approach" (although BLD performance
is not *bad* as per my testings).

Bld kernel size will reduced a lot, but as said before - a lot of code
cleanup is required
that's why I'm not showing it here.

And finally, my writing skills are not that good, so there might be
repetitive sentences, spelling mistakes etc. Please be patient if you
started to feel disgusting. I try to explain all the details about
this technique
and if any confusion, I think looking at the patch will give you a clear idea.

 So, please test it. Any comments, suggestions are highly expected. Anything,
that I should've mentioned? Can't remember ...


Thanks,
Rakib.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/init/Kconfig b/init/Kconfig
index 3f42cd6..98c9622 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -68,6 +68,14 @@ config BROKEN_ON_SMP
 	depends on BROKEN || !SMP
 	default y

+config BLD
+	bool "An alternate CPU load distributor"
+	depends on EXPERIMENTAL && SMP
+	default y
+	help
+	  This is an alternate CPU load distribution technique based
+	  on The Barbershop Load Distribution algorithm.
+
 config INIT_ENV_ARG_LIMIT
 	int
 	default 32 if !UML
diff --git a/kernel/sched/bld.h b/kernel/sched/bld.h
new file mode 100644
index 0000000..31ac23f
--- /dev/null
+++ b/kernel/sched/bld.h
@@ -0,0 +1,112 @@
+#ifdef CONFIG_BLD
+
+static DEFINE_RWLOCK(disp_list_lock);
+static LIST_HEAD(rq_head);
+
+static inline int list_is_first(const struct list_head *list,
+				const struct list_head *head)
+{
+	return list == head->next;
+}
+
+static inline int select_cpu_for_wakeup(struct task_struct *p, int
sd_flags, int wake_flags)
+{
+	int cpu = smp_processor_id(), prev_cpu = task_cpu(p), i;
+	/*bool sync = wake_flags & WF_SYNC; */
+	unsigned long load, min_load = ULONG_MAX;
+	struct cpumask *mask;
+
+	if (wake_flags & WF_SYNC) {
+		if (cpu == prev_cpu)
+			return cpu;
+		mask = sched_group_cpus(cpu_rq(prev_cpu)->sd->groups);
+	} else
+		mask = sched_domain_span(cpu_rq(prev_cpu)->sd);
+	
+	for_each_cpu(i, mask) {
+		load = cpu_rq(i)->load.weight;
+		if (load < min_load) {
+			min_load = load;
+			cpu = i;
+		}
+	}
+	return cpu;
+}
+
+static int bld_select_task_rq(struct task_struct *p, int sd_flags,
int wake_flags)
+{
+	struct rq *tmp;
+	unsigned long flag;
+	unsigned int cpu = smp_processor_id();
+
+	if (&p->cpus_allowed) {
+		struct cpumask *taskmask;
+		unsigned long min_load = ULONG_MAX, load, i;
+		taskmask = tsk_cpus_allowed(p);
+		for_each_cpu(i, taskmask) {
+			load = cpu_rq(i)->load.weight;
+			if (load < min_load) {
+				min_load = load;
+				cpu = i;
+			}
+		}
+	} else	if (sd_flags & SD_BALANCE_WAKE) {
+		cpu = select_cpu_for_wakeup(p, sd_flags, wake_flags);
+		return cpu;
+	} else {
+		read_lock_irqsave(&disp_list_lock, flag);
+		list_for_each_entry(tmp, &rq_head, disp_load_balance) {
+			cpu = cpu_of(tmp);
+			if (cpu_online(cpu))
+				break;
+		}
+		read_unlock_irqrestore(&disp_list_lock, flag);
+	}
+	return cpu;
+}
+
+static void bld_track_load_activate(struct rq *rq)
+{
+	unsigned long  flag;
+	rq->this_cpu_load = rq->load.weight;
+
+	if (rq->pos != 2) {	/* if rq isn't the last one */
+		struct rq *last;
+		write_lock_irqsave(&disp_list_lock, flag);
+		last = list_entry(rq_head.prev, struct rq, disp_load_balance);
+		if (rq->this_cpu_load > last->this_cpu_load) {
+			list_del(&rq->disp_load_balance);
+			list_add_tail(&rq->disp_load_balance, &rq_head);
+			rq->pos = 2; last->pos = 1;
+		}
+		write_unlock_irqrestore(&disp_list_lock, flag);
+	}
+}
+
+static void bld_track_load_deactivate(struct rq *rq)
+{
+	unsigned long flag;
+	
+	rq->this_cpu_load = rq->load.weight;
+
+	if (rq->pos != 0) { /* If rq isn't first one */
+		struct rq *first;
+		first = list_entry(rq_head.prev, struct rq, disp_load_balance);
+		write_lock_irqsave(&disp_list_lock, flag);
+		if (rq->this_cpu_load <= first->this_cpu_load) {
+			list_del(&rq->disp_load_balance);
+			list_add_tail(&rq->disp_load_balance, &rq_head);
+			rq->pos = 0; first->pos = 1;
+		}
+		write_unlock_irqrestore(&disp_list_lock, flag);
+	}
+}
+#else
+static inline void bld_track_load_activate(struct rq *rq)
+{
+}
+
+static inline void bld_track_load_deactivate(struct rq *rq)
+{
+}
+#endif /* CONFIG_BLD */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..cff20e1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -24,6 +24,8 @@
  *  2007-07-01  Group scheduling enhancements by Srivatsa Vaddagiri
  *  2007-11-29  RT balancing improvements by Steven Rostedt, Gregory Haskins,
  *              Thomas Gleixner, Mike Kravetz
+ *  2012-Feb	The Barbershop Load Distribution (BLD) algorithm, an alternate
+ *  		load distribution algorithm by Rakib Mullick.
  */

 #include <linux/mm.h>
@@ -81,6 +83,7 @@

 #include "sched.h"
 #include "../workqueue_sched.h"
+#include "bld.h"

 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
@@ -578,6 +581,7 @@ unlock:
  */
 void wake_up_idle_cpu(int cpu)
 {
+#ifndef CONFIG_BLD
 	struct rq *rq = cpu_rq(cpu);

 	if (cpu == smp_processor_id())
@@ -604,6 +608,7 @@ void wake_up_idle_cpu(int cpu)
 	smp_mb();
 	if (!tsk_is_polling(rq->idle))
 		smp_send_reschedule(cpu);
+#endif
 }

 static inline bool got_nohz_idle_kick(void)
@@ -730,6 +735,7 @@ void activate_task(struct rq *rq, struct
task_struct *p, int flags)
 		rq->nr_uninterruptible--;

 	enqueue_task(rq, p, flags);
+	bld_track_load_activate(rq);
 }

 void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
@@ -738,6 +744,7 @@ void deactivate_task(struct rq *rq, struct
task_struct *p, int flags)
 		rq->nr_uninterruptible++;

 	dequeue_task(rq, p, flags);
+	bld_track_load_deactivate(rq);
 }

 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
@@ -1297,7 +1304,12 @@ static int select_fallback_rq(int cpu, struct
task_struct *p)
 static inline
 int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 {
-	int cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
+	int cpu;
+#ifdef CONFIG_BLD
+	cpu = bld_select_task_rq(p, sd_flags, wake_flags);
+#else
+	cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
+#endif

 	/*
 	 * In order not to call set_task_cpu() on a blocking task we need
@@ -1453,7 +1465,11 @@ static void sched_ttwu_pending(void)

 void scheduler_ipi(void)
 {
+#ifndef CONFIG_BLD
 	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
+#else
+	if (llist_empty(&this_rq()->wake_list))
+#endif
 		return;

 	/*
@@ -1475,10 +1491,12 @@ void scheduler_ipi(void)
 	/*
 	 * Check if someone kicked us for doing the nohz idle load balance.
 	 */
+#ifndef CONFIG_BLD
 	if (unlikely(got_nohz_idle_kick() && !need_resched())) {
 		this_rq()->idle_balance = 1;
 		raise_softirq_irqoff(SCHED_SOFTIRQ);
 	}
+#endif
 	irq_exit();
 }

@@ -1518,12 +1536,14 @@ static void ttwu_queue(struct task_struct *p, int cpu)
 	struct rq *rq = cpu_rq(cpu);

 #if defined(CONFIG_SMP)
+#ifndef CONFIG_BLD
 	if (sched_feat(TTWU_QUEUE) && !ttwu_share_cache(smp_processor_id(), cpu)) {
 		sched_clock_cpu(cpu); /* sync clocks x-cpu */
 		ttwu_queue_remote(p, cpu);
 		return;
 	}
 #endif
+#endif

 	raw_spin_lock(&rq->lock);
 	ttwu_do_activate(rq, p, 0);
@@ -2269,6 +2289,7 @@ calc_load_n(unsigned long load, unsigned long exp,
  */
 static void calc_global_nohz(unsigned long ticks)
 {
+#ifndef CONFIG_BLD
 	long delta, active, n;

 	if (time_before(jiffies, calc_load_update))
@@ -2310,6 +2331,7 @@ static void calc_global_nohz(unsigned long ticks)
 	 * age us 4 cycles, and the test in calc_global_load() will
 	 * pick up the final one.
 	 */
+#endif
 }
 #else
 void calc_load_account_idle(struct rq *this_rq)
@@ -3003,8 +3025,10 @@ void scheduler_tick(void)

 #ifdef CONFIG_SMP
 	rq->idle_balance = idle_cpu(cpu);
+#ifndef CONFIG_BLD
 	trigger_load_balance(rq, cpu);
 #endif
+#endif
 }

 notrace unsigned long get_parent_ip(unsigned long addr)
@@ -3194,8 +3218,10 @@ need_resched:

 	pre_schedule(rq, prev);

+#ifndef CONFIG_BLD
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
+#endif

 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
@@ -6938,6 +6964,11 @@ void __init sched_init(void)
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
+#ifdef CONFIG_BLD
+		INIT_LIST_HEAD(&rq->disp_load_balance);
+		list_add_tail(&rq->disp_load_balance, &rq_head);
+		rq->pos = 0;
+#endif
 	}

 	set_load_weight(&init_task);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c6414f..f2624ce 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5609,7 +5609,9 @@ void print_cfs_stats(struct seq_file *m, int cpu)
 __init void init_sched_fair_class(void)
 {
 #ifdef CONFIG_SMP
+#ifndef CONFIG_BLD
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
+#endif /* BLD */

 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 98c0c26..bd7e4c6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -474,6 +474,17 @@ struct rq {
 #ifdef CONFIG_SMP
 	struct llist_head wake_list;
 #endif
+#ifdef CONFIG_BLD
+	unsigned long this_cpu_load;
+	struct list_head disp_load_balance;
+	/* It indicates whether, rq is first or last
+	 * or in the middle based on load from rq_head.
+	 * 0 - First rq
+	 * 1 - rq stays middle
+	 * 2 - last rq
+	 */
+	char pos;
+#endif
 };

 static inline int cpu_of(struct rq *rq)
