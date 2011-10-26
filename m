Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab1JZN75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:59:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56287 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab1JZN7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:59:55 -0400
Date: Wed, 26 Oct 2011 15:58:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v3.2
Message-ID: <20111026135807.GA32044@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

The biggest change is Paul Turner's bandwidth control patches - they 
should not affect behavior unless you specifically ask for it.

 Thanks,

	Ingo

------------------>
Bharata B Rao (1):
      sched: Add documentation for bandwidth control

Hillf Danton (4):
      sched: Remove noop in next_prio()
      sched: Remove noop in lowest_flag_domain()
      sched, rt: Fix rq->rt.pushable_tasks bug in push_rt_task()
      sched: Remove resetting exec_start in put_prev_task_rt()

Huang Ying (4):
      llist: Make some llist functions inline
      llist: Move cpu_relax() to after the cmpxchg()
      llist: Return whether list is empty before adding in llist_add()
      irq_work: Use llist in the struct irq_work logic

Ingo Molnar (1):
      llist: Remove the platform-dependent NMI checks

Jan H. Schönherr (1):
      sched: Remove rq->avg_load_per_task

Mike Galbraith (1):
      sched: fix broken SCHED_RESET_ON_FORK handling

Nikhil Rao (1):
      sched: Add exports tracking cfs bandwidth control statistics

Paul Turner (14):
      sched: Implement hierarchical task accounting for SCHED_OTHER
      sched: Introduce primitives to account for CFS bandwidth tracking
      sched: Validate CFS quota hierarchies
      sched: Accumulate per-cfs_rq cpu usage and charge against bandwidth
      sched: Add a timer to handle CFS bandwidth refresh
      sched: Expire invalid runtime
      sched: Add support for throttling group entities
      sched: Add support for unthrottling group entities
      sched: Allow for positional tg_tree walks
      sched: Prevent interactions with throttled entities
      sched: Prevent buddy interactions with throttled entities
      sched: Migrate throttled tasks on HOTPLUG
      sched: Throttle entities exceeding their allowed bandwidth
      sched: Return unused runtime on group dequeue

Peter Zijlstra (6):
      sched, tracing: Show PREEMPT_ACTIVE state in trace_sched_switch
      llist: Add llist_next()
      sched: Convert to struct llist
      llist: Remove cpu_relax() usage in cmpxchg loops
      sched: Wrap scheduler p->cpus_allowed access
      sched: Unify the ->cpus_allowed mask copy

Stephen Rothwell (1):
      llist: Add back llist_add_batch() and llist_del_first() prototypes

Steven Rostedt (4):
      sched: Balance RT tasks when forked as well
      sched: Use pushable_tasks to determine next highest prio
      sched/cpupri: Remove the vec->lock
      sched/cpupri: Fix memory barriers for vec updates to always be in order

Suresh Siddha (2):
      sched: Use resched IPI to kick off the nohz idle balance
      sched: Request for idle balance during nohz idle load balance

Thomas Gleixner (3):
      sched: Fix idle_cpu()
      sched: Warn on rt throttling
      sched: Don't use tasklist_lock for debug prints

Wang Xingchao (1):
      sched: Remove redundant test in check_preempt_tick()

Yong Zhang (2):
      sched: Kill WAKEUP_PREEMPT
      sched/cpupri: Remove cpupri->pri_active


 Documentation/scheduler/sched-bwc.txt |  122 ++++++
 drivers/acpi/apei/Kconfig             |    1 -
 include/linux/irq_work.h              |   15 +-
 include/linux/llist.h                 |   77 +++-
 include/linux/sched.h                 |    7 +-
 include/trace/events/sched.h          |    9 +-
 init/Kconfig                          |   12 +
 kernel/irq_work.c                     |   91 ++---
 kernel/sched.c                        |  666 ++++++++++++++++++++++++-----
 kernel/sched_cpupri.c                 |   89 +++--
 kernel/sched_cpupri.h                 |    7 +-
 kernel/sched_fair.c                   |  761 ++++++++++++++++++++++++++++++---
 kernel/sched_features.h               |    5 -
 kernel/sched_rt.c                     |   99 ++---
 kernel/sched_stoptask.c               |    2 +
 kernel/sysctl.c                       |   10 +
 lib/Kconfig                           |    3 -
 lib/Makefile                          |    4 +-
 lib/llist.c                           |   74 +---
 lib/smp_processor_id.c                |    2 +-
 20 files changed, 1646 insertions(+), 410 deletions(-)
 create mode 100644 Documentation/scheduler/sched-bwc.txt

diff --git a/Documentation/scheduler/sched-bwc.txt b/Documentation/scheduler/sched-bwc.txt
new file mode 100644
index 0000000..f6b1873
--- /dev/null
+++ b/Documentation/scheduler/sched-bwc.txt
@@ -0,0 +1,122 @@
+CFS Bandwidth Control
+=====================
+
+[ This document only discusses CPU bandwidth control for SCHED_NORMAL.
+  The SCHED_RT case is covered in Documentation/scheduler/sched-rt-group.txt ]
+
+CFS bandwidth control is a CONFIG_FAIR_GROUP_SCHED extension which allows the
+specification of the maximum CPU bandwidth available to a group or hierarchy.
+
+The bandwidth allowed for a group is specified using a quota and period. Within
+each given "period" (microseconds), a group is allowed to consume only up to
+"quota" microseconds of CPU time.  When the CPU bandwidth consumption of a
+group exceeds this limit (for that period), the tasks belonging to its
+hierarchy will be throttled and are not allowed to run again until the next
+period.
+
+A group's unused runtime is globally tracked, being refreshed with quota units
+above at each period boundary.  As threads consume this bandwidth it is
+transferred to cpu-local "silos" on a demand basis.  The amount transferred
+within each of these updates is tunable and described as the "slice".
+
+Management
+----------
+Quota and period are managed within the cpu subsystem via cgroupfs.
+
+cpu.cfs_quota_us: the total available run-time within a period (in microseconds)
+cpu.cfs_period_us: the length of a period (in microseconds)
+cpu.stat: exports throttling statistics [explained further below]
+
+The default values are:
+	cpu.cfs_period_us=100ms
+	cpu.cfs_quota=-1
+
+A value of -1 for cpu.cfs_quota_us indicates that the group does not have any
+bandwidth restriction in place, such a group is described as an unconstrained
+bandwidth group.  This represents the traditional work-conserving behavior for
+CFS.
+
+Writing any (valid) positive value(s) will enact the specified bandwidth limit.
+The minimum quota allowed for the quota or period is 1ms.  There is also an
+upper bound on the period length of 1s.  Additional restrictions exist when
+bandwidth limits are used in a hierarchical fashion, these are explained in
+more detail below.
+
+Writing any negative value to cpu.cfs_quota_us will remove the bandwidth limit
+and return the group to an unconstrained state once more.
+
+Any updates to a group's bandwidth specification will result in it becoming
+unthrottled if it is in a constrained state.
+
+System wide settings
+--------------------
+For efficiency run-time is transferred between the global pool and CPU local
+"silos" in a batch fashion.  This greatly reduces global accounting pressure
+on large systems.  The amount transferred each time such an update is required
+is described as the "slice".
+
+This is tunable via procfs:
+	/proc/sys/kernel/sched_cfs_bandwidth_slice_us (default=5ms)
+
+Larger slice values will reduce transfer overheads, while smaller values allow
+for more fine-grained consumption.
+
+Statistics
+----------
+A group's bandwidth statistics are exported via 3 fields in cpu.stat.
+
+cpu.stat:
+- nr_periods: Number of enforcement intervals that have elapsed.
+- nr_throttled: Number of times the group has been throttled/limited.
+- throttled_time: The total time duration (in nanoseconds) for which entities
+  of the group have been throttled.
+
+This interface is read-only.
+
+Hierarchical considerations
+---------------------------
+The interface enforces that an individual entity's bandwidth is always
+attainable, that is: max(c_i) <= C. However, over-subscription in the
+aggregate case is explicitly allowed to enable work-conserving semantics
+within a hierarchy.
+  e.g. \Sum (c_i) may exceed C
+[ Where C is the parent's bandwidth, and c_i its children ]
+
+
+There are two ways in which a group may become throttled:
+	a. it fully consumes its own quota within a period
+	b. a parent's quota is fully consumed within its period
+
+In case b) above, even though the child may have runtime remaining it will not
+be allowed to until the parent's runtime is refreshed.
+
+Examples
+--------
+1. Limit a group to 1 CPU worth of runtime.
+
+	If period is 250ms and quota is also 250ms, the group will get
+	1 CPU worth of runtime every 250ms.
+
+	# echo 250000 > cpu.cfs_quota_us /* quota = 250ms */
+	# echo 250000 > cpu.cfs_period_us /* period = 250ms */
+
+2. Limit a group to 2 CPUs worth of runtime on a multi-CPU machine.
+
+	With 500ms period and 1000ms quota, the group can get 2 CPUs worth of
+	runtime every 500ms.
+
+	# echo 1000000 > cpu.cfs_quota_us /* quota = 1000ms */
+	# echo 500000 > cpu.cfs_period_us /* period = 500ms */
+
+	The larger period here allows for increased burst capacity.
+
+3. Limit a group to 20% of 1 CPU.
+
+	With 50ms period, 10ms quota will be equivalent to 20% of 1 CPU.
+
+	# echo 10000 > cpu.cfs_quota_us /* quota = 10ms */
+	# echo 50000 > cpu.cfs_period_us /* period = 50ms */
+
+	By using a small period here we are ensuring a consistent latency
+	response at the expense of burst capacity.
+
diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index e3f4787..f0c1ce9 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -14,7 +14,6 @@ config ACPI_APEI_GHES
 	depends on ACPI_APEI && X86
 	select ACPI_HED
 	select IRQ_WORK
-	select LLIST
 	select GENERIC_ALLOCATOR
 	help
 	  Generic Hardware Error Source provides a way to report
diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 4fa09d4..6a9e8f5 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -1,20 +1,23 @@
 #ifndef _LINUX_IRQ_WORK_H
 #define _LINUX_IRQ_WORK_H
 
+#include <linux/llist.h>
+
 struct irq_work {
-	struct irq_work *next;
+	unsigned long flags;
+	struct llist_node llnode;
 	void (*func)(struct irq_work *);
 };
 
 static inline
-void init_irq_work(struct irq_work *entry, void (*func)(struct irq_work *))
+void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 {
-	entry->next = NULL;
-	entry->func = func;
+	work->flags = 0;
+	work->func = func;
 }
 
-bool irq_work_queue(struct irq_work *entry);
+bool irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
-void irq_work_sync(struct irq_work *entry);
+void irq_work_sync(struct irq_work *work);
 
 #endif /* _LINUX_IRQ_WORK_H */
diff --git a/include/linux/llist.h b/include/linux/llist.h
index aa0c8b5..7287734 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -35,10 +35,30 @@
  *
  * The basic atomic operation of this list is cmpxchg on long.  On
  * architectures that don't have NMI-safe cmpxchg implementation, the
- * list can NOT be used in NMI handler.  So code uses the list in NMI
- * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
+ * list can NOT be used in NMI handlers.  So code that uses the list in
+ * an NMI handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
+ *
+ * Copyright 2010,2011 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation;
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/kernel.h>
+#include <asm/system.h>
+#include <asm/processor.h>
+
 struct llist_head {
 	struct llist_node *first;
 };
@@ -113,14 +133,55 @@ static inline void init_llist_head(struct llist_head *list)
  * test whether the list is empty without deleting something from the
  * list.
  */
-static inline int llist_empty(const struct llist_head *head)
+static inline bool llist_empty(const struct llist_head *head)
 {
 	return ACCESS_ONCE(head->first) == NULL;
 }
 
-void llist_add(struct llist_node *new, struct llist_head *head);
-void llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
-		     struct llist_head *head);
-struct llist_node *llist_del_first(struct llist_head *head);
-struct llist_node *llist_del_all(struct llist_head *head);
+static inline struct llist_node *llist_next(struct llist_node *node)
+{
+	return node->next;
+}
+
+/**
+ * llist_add - add a new entry
+ * @new:	new entry to be added
+ * @head:	the head for your lock-less list
+ *
+ * Return whether list is empty before adding.
+ */
+static inline bool llist_add(struct llist_node *new, struct llist_head *head)
+{
+	struct llist_node *entry, *old_entry;
+
+	entry = head->first;
+	for (;;) {
+		old_entry = entry;
+		new->next = entry;
+		entry = cmpxchg(&head->first, old_entry, new);
+		if (entry == old_entry)
+			break;
+	}
+
+	return old_entry == NULL;
+}
+
+/**
+ * llist_del_all - delete all entries from lock-less list
+ * @head:	the head of lock-less list to delete all entries
+ *
+ * If list is empty, return NULL, otherwise, delete all entries and
+ * return the pointer to the first entry.  The order of entries
+ * deleted is from the newest to the oldest added one.
+ */
+static inline struct llist_node *llist_del_all(struct llist_head *head)
+{
+	return xchg(&head->first, NULL);
+}
+
+extern bool llist_add_batch(struct llist_node *new_first,
+			    struct llist_node *new_last,
+			    struct llist_head *head);
+extern struct llist_node *llist_del_first(struct llist_head *head);
+
 #endif /* LLIST_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 41d0237..fc3e891 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -90,6 +90,7 @@ struct sched_param {
 #include <linux/task_io_accounting.h>
 #include <linux/latencytop.h>
 #include <linux/cred.h>
+#include <linux/llist.h>
 
 #include <asm/processor.h>
 
@@ -1225,7 +1226,7 @@ struct task_struct {
 	unsigned int ptrace;
 
 #ifdef CONFIG_SMP
-	struct task_struct *wake_entry;
+	struct llist_node wake_entry;
 	int on_cpu;
 #endif
 	int on_rq;
@@ -2039,6 +2040,10 @@ static inline void sched_autogroup_fork(struct signal_struct *sig) { }
 static inline void sched_autogroup_exit(struct signal_struct *sig) { }
 #endif
 
+#ifdef CONFIG_CFS_BANDWIDTH
+extern unsigned int sysctl_sched_cfs_bandwidth_slice;
+#endif
+
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index f633478..959ff18 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -100,7 +100,7 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
 	 * For all intents and purposes a preempted task is a running task.
 	 */
 	if (task_thread_info(p)->preempt_count & PREEMPT_ACTIVE)
-		state = TASK_RUNNING;
+		state = TASK_RUNNING | TASK_STATE_MAX;
 #endif
 
 	return state;
@@ -137,13 +137,14 @@ TRACE_EVENT(sched_switch,
 		__entry->next_prio	= next->prio;
 	),
 
-	TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s ==> next_comm=%s next_pid=%d next_prio=%d",
+	TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s%s ==> next_comm=%s next_pid=%d next_prio=%d",
 		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
-		__entry->prev_state ?
-		  __print_flags(__entry->prev_state, "|",
+		__entry->prev_state & (TASK_STATE_MAX-1) ?
+		  __print_flags(__entry->prev_state & (TASK_STATE_MAX-1), "|",
 				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
 				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
 				{ 128, "W" }) : "R",
+		__entry->prev_state & TASK_STATE_MAX ? "+" : "",
 		__entry->next_comm, __entry->next_pid, __entry->next_prio)
 );
 
diff --git a/init/Kconfig b/init/Kconfig
index d627783..d19b3a7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -715,6 +715,18 @@ config FAIR_GROUP_SCHED
 	depends on CGROUP_SCHED
 	default CGROUP_SCHED
 
+config CFS_BANDWIDTH
+	bool "CPU bandwidth provisioning for FAIR_GROUP_SCHED"
+	depends on EXPERIMENTAL
+	depends on FAIR_GROUP_SCHED
+	default n
+	help
+	  This option allows users to define CPU bandwidth rates (limits) for
+	  tasks running within the fair group scheduler.  Groups with no limit
+	  set are considered to be unconstrained and will run with no
+	  restriction.
+	  See tip/Documentation/scheduler/sched-bwc.txt for more information.
+
 config RT_GROUP_SCHED
 	bool "Group scheduling for SCHED_RR/FIFO"
 	depends on EXPERIMENTAL
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index c58fa7d..0e2cde4 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -17,54 +17,34 @@
  * claimed   NULL, 3 -> {pending}       : claimed to be enqueued
  * pending   next, 3 -> {busy}          : queued, pending callback
  * busy      NULL, 2 -> {free, claimed} : callback in progress, can be claimed
- *
- * We use the lower two bits of the next pointer to keep PENDING and BUSY
- * flags.
  */
 
 #define IRQ_WORK_PENDING	1UL
 #define IRQ_WORK_BUSY		2UL
 #define IRQ_WORK_FLAGS		3UL
 
-static inline bool irq_work_is_set(struct irq_work *entry, int flags)
-{
-	return (unsigned long)entry->next & flags;
-}
-
-static inline struct irq_work *irq_work_next(struct irq_work *entry)
-{
-	unsigned long next = (unsigned long)entry->next;
-	next &= ~IRQ_WORK_FLAGS;
-	return (struct irq_work *)next;
-}
-
-static inline struct irq_work *next_flags(struct irq_work *entry, int flags)
-{
-	unsigned long next = (unsigned long)entry;
-	next |= flags;
-	return (struct irq_work *)next;
-}
-
-static DEFINE_PER_CPU(struct irq_work *, irq_work_list);
+static DEFINE_PER_CPU(struct llist_head, irq_work_list);
 
 /*
  * Claim the entry so that no one else will poke at it.
  */
-static bool irq_work_claim(struct irq_work *entry)
+static bool irq_work_claim(struct irq_work *work)
 {
-	struct irq_work *next, *nflags;
+	unsigned long flags, nflags;
 
-	do {
-		next = entry->next;
-		if ((unsigned long)next & IRQ_WORK_PENDING)
+	for (;;) {
+		flags = work->flags;
+		if (flags & IRQ_WORK_PENDING)
 			return false;
-		nflags = next_flags(next, IRQ_WORK_FLAGS);
-	} while (cmpxchg(&entry->next, next, nflags) != next);
+		nflags = flags | IRQ_WORK_FLAGS;
+		if (cmpxchg(&work->flags, flags, nflags) == flags)
+			break;
+		cpu_relax();
+	}
 
 	return true;
 }
 
-
 void __weak arch_irq_work_raise(void)
 {
 	/*
@@ -75,20 +55,15 @@ void __weak arch_irq_work_raise(void)
 /*
  * Queue the entry and raise the IPI if needed.
  */
-static void __irq_work_queue(struct irq_work *entry)
+static void __irq_work_queue(struct irq_work *work)
 {
-	struct irq_work *next;
+	bool empty;
 
 	preempt_disable();
 
-	do {
-		next = __this_cpu_read(irq_work_list);
-		/* Can assign non-atomic because we keep the flags set. */
-		entry->next = next_flags(next, IRQ_WORK_FLAGS);
-	} while (this_cpu_cmpxchg(irq_work_list, next, entry) != next);
-
+	empty = llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
 	/* The list was empty, raise self-interrupt to start processing. */
-	if (!irq_work_next(entry))
+	if (empty)
 		arch_irq_work_raise();
 
 	preempt_enable();
@@ -100,16 +75,16 @@ static void __irq_work_queue(struct irq_work *entry)
  *
  * Can be re-enqueued while the callback is still in progress.
  */
-bool irq_work_queue(struct irq_work *entry)
+bool irq_work_queue(struct irq_work *work)
 {
-	if (!irq_work_claim(entry)) {
+	if (!irq_work_claim(work)) {
 		/*
 		 * Already enqueued, can't do!
 		 */
 		return false;
 	}
 
-	__irq_work_queue(entry);
+	__irq_work_queue(work);
 	return true;
 }
 EXPORT_SYMBOL_GPL(irq_work_queue);
@@ -120,34 +95,34 @@ EXPORT_SYMBOL_GPL(irq_work_queue);
  */
 void irq_work_run(void)
 {
-	struct irq_work *list;
+	struct irq_work *work;
+	struct llist_head *this_list;
+	struct llist_node *llnode;
 
-	if (this_cpu_read(irq_work_list) == NULL)
+	this_list = &__get_cpu_var(irq_work_list);
+	if (llist_empty(this_list))
 		return;
 
 	BUG_ON(!in_irq());
 	BUG_ON(!irqs_disabled());
 
-	list = this_cpu_xchg(irq_work_list, NULL);
-
-	while (list != NULL) {
-		struct irq_work *entry = list;
+	llnode = llist_del_all(this_list);
+	while (llnode != NULL) {
+		work = llist_entry(llnode, struct irq_work, llnode);
 
-		list = irq_work_next(list);
+		llnode = llist_next(llnode);
 
 		/*
-		 * Clear the PENDING bit, after this point the @entry
+		 * Clear the PENDING bit, after this point the @work
 		 * can be re-used.
 		 */
-		entry->next = next_flags(NULL, IRQ_WORK_BUSY);
-		entry->func(entry);
+		work->flags = IRQ_WORK_BUSY;
+		work->func(work);
 		/*
 		 * Clear the BUSY bit and return to the free state if
 		 * no-one else claimed it meanwhile.
 		 */
-		(void)cmpxchg(&entry->next,
-			      next_flags(NULL, IRQ_WORK_BUSY),
-			      NULL);
+		(void)cmpxchg(&work->flags, IRQ_WORK_BUSY, 0);
 	}
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
@@ -156,11 +131,11 @@ EXPORT_SYMBOL_GPL(irq_work_run);
  * Synchronize against the irq_work @entry, ensures the entry is not
  * currently in use.
  */
-void irq_work_sync(struct irq_work *entry)
+void irq_work_sync(struct irq_work *work)
 {
 	WARN_ON_ONCE(irqs_disabled());
 
-	while (irq_work_is_set(entry, IRQ_WORK_BUSY))
+	while (work->flags & IRQ_WORK_BUSY)
 		cpu_relax();
 }
 EXPORT_SYMBOL_GPL(irq_work_sync);
diff --git a/kernel/sched.c b/kernel/sched.c
index b50b0f0..24637c7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -196,10 +196,28 @@ static inline int rt_bandwidth_enabled(void)
 	return sysctl_sched_rt_runtime >= 0;
 }
 
-static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+static void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
-	ktime_t now;
+	unsigned long delta;
+	ktime_t soft, hard, now;
+
+	for (;;) {
+		if (hrtimer_active(period_timer))
+			break;
+
+		now = hrtimer_cb_get_time(period_timer);
+		hrtimer_forward(period_timer, now, period);
 
+		soft = hrtimer_get_softexpires(period_timer);
+		hard = hrtimer_get_expires(period_timer);
+		delta = ktime_to_ns(ktime_sub(hard, soft));
+		__hrtimer_start_range_ns(period_timer, soft, delta,
+					 HRTIMER_MODE_ABS_PINNED, 0);
+	}
+}
+
+static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
 	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return;
 
@@ -207,22 +225,7 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 		return;
 
 	raw_spin_lock(&rt_b->rt_runtime_lock);
-	for (;;) {
-		unsigned long delta;
-		ktime_t soft, hard;
-
-		if (hrtimer_active(&rt_b->rt_period_timer))
-			break;
-
-		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
-		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
-
-		soft = hrtimer_get_softexpires(&rt_b->rt_period_timer);
-		hard = hrtimer_get_expires(&rt_b->rt_period_timer);
-		delta = ktime_to_ns(ktime_sub(hard, soft));
-		__hrtimer_start_range_ns(&rt_b->rt_period_timer, soft, delta,
-				HRTIMER_MODE_ABS_PINNED, 0);
-	}
+	start_bandwidth_timer(&rt_b->rt_period_timer, rt_b->rt_period);
 	raw_spin_unlock(&rt_b->rt_runtime_lock);
 }
 
@@ -247,6 +250,24 @@ struct cfs_rq;
 
 static LIST_HEAD(task_groups);
 
+struct cfs_bandwidth {
+#ifdef CONFIG_CFS_BANDWIDTH
+	raw_spinlock_t lock;
+	ktime_t period;
+	u64 quota, runtime;
+	s64 hierarchal_quota;
+	u64 runtime_expires;
+
+	int idle, timer_active;
+	struct hrtimer period_timer, slack_timer;
+	struct list_head throttled_cfs_rq;
+
+	/* statistics */
+	int nr_periods, nr_throttled;
+	u64 throttled_time;
+#endif
+};
+
 /* task group related information */
 struct task_group {
 	struct cgroup_subsys_state css;
@@ -278,6 +299,8 @@ struct task_group {
 #ifdef CONFIG_SCHED_AUTOGROUP
 	struct autogroup *autogroup;
 #endif
+
+	struct cfs_bandwidth cfs_bandwidth;
 };
 
 /* task_group_lock serializes the addition/removal of task groups */
@@ -311,7 +334,7 @@ struct task_group root_task_group;
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
-	unsigned long nr_running;
+	unsigned long nr_running, h_nr_running;
 
 	u64 exec_clock;
 	u64 min_vruntime;
@@ -377,9 +400,120 @@ struct cfs_rq {
 
 	unsigned long load_contribution;
 #endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	int runtime_enabled;
+	u64 runtime_expires;
+	s64 runtime_remaining;
+
+	u64 throttled_timestamp;
+	int throttled, throttle_count;
+	struct list_head throttled_list;
+#endif
 #endif
 };
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_CFS_BANDWIDTH
+static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
+{
+	return &tg->cfs_bandwidth;
+}
+
+static inline u64 default_cfs_period(void);
+static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
+static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b);
+
+static enum hrtimer_restart sched_cfs_slack_timer(struct hrtimer *timer)
+{
+	struct cfs_bandwidth *cfs_b =
+		container_of(timer, struct cfs_bandwidth, slack_timer);
+	do_sched_cfs_slack_timer(cfs_b);
+
+	return HRTIMER_NORESTART;
+}
+
+static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
+{
+	struct cfs_bandwidth *cfs_b =
+		container_of(timer, struct cfs_bandwidth, period_timer);
+	ktime_t now;
+	int overrun;
+	int idle = 0;
+
+	for (;;) {
+		now = hrtimer_cb_get_time(timer);
+		overrun = hrtimer_forward(timer, now, cfs_b->period);
+
+		if (!overrun)
+			break;
+
+		idle = do_sched_cfs_period_timer(cfs_b, overrun);
+	}
+
+	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
+}
+
+static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	raw_spin_lock_init(&cfs_b->lock);
+	cfs_b->runtime = 0;
+	cfs_b->quota = RUNTIME_INF;
+	cfs_b->period = ns_to_ktime(default_cfs_period());
+
+	INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
+	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->period_timer.function = sched_cfs_period_timer;
+	hrtimer_init(&cfs_b->slack_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->slack_timer.function = sched_cfs_slack_timer;
+}
+
+static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	cfs_rq->runtime_enabled = 0;
+	INIT_LIST_HEAD(&cfs_rq->throttled_list);
+}
+
+/* requires cfs_b->lock, may release to reprogram timer */
+static void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	/*
+	 * The timer may be active because we're trying to set a new bandwidth
+	 * period or because we're racing with the tear-down path
+	 * (timer_active==0 becomes visible before the hrtimer call-back
+	 * terminates).  In either case we ensure that it's re-programmed
+	 */
+	while (unlikely(hrtimer_active(&cfs_b->period_timer))) {
+		raw_spin_unlock(&cfs_b->lock);
+		/* ensure cfs_b->lock is available while we wait */
+		hrtimer_cancel(&cfs_b->period_timer);
+
+		raw_spin_lock(&cfs_b->lock);
+		/* if someone else restarted the timer then we're done */
+		if (cfs_b->timer_active)
+			return;
+	}
+
+	cfs_b->timer_active = 1;
+	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
+}
+
+static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	hrtimer_cancel(&cfs_b->period_timer);
+	hrtimer_cancel(&cfs_b->slack_timer);
+}
+#else
+static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
+static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
+
+static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
+{
+	return NULL;
+}
+#endif /* CONFIG_CFS_BANDWIDTH */
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
 /* Real-Time classes' related field in a runqueue: */
 struct rt_rq {
 	struct rt_prio_array active;
@@ -510,7 +644,7 @@ struct rq {
 
 	unsigned long cpu_power;
 
-	unsigned char idle_at_tick;
+	unsigned char idle_balance;
 	/* For active balancing */
 	int post_schedule;
 	int active_balance;
@@ -520,8 +654,6 @@ struct rq {
 	int cpu;
 	int online;
 
-	unsigned long avg_load_per_task;
-
 	u64 rt_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
@@ -570,7 +702,7 @@ struct rq {
 #endif
 
 #ifdef CONFIG_SMP
-	struct task_struct *wake_list;
+	struct llist_head wake_list;
 #endif
 };
 
@@ -1272,6 +1404,18 @@ void wake_up_idle_cpu(int cpu)
 		smp_send_reschedule(cpu);
 }
 
+static inline bool got_nohz_idle_kick(void)
+{
+	return idle_cpu(smp_processor_id()) && this_rq()->nohz_balance_kick;
+}
+
+#else /* CONFIG_NO_HZ */
+
+static inline bool got_nohz_idle_kick(void)
+{
+	return false;
+}
+
 #endif /* CONFIG_NO_HZ */
 
 static u64 sched_avg_period(void)
@@ -1471,24 +1615,28 @@ static inline void dec_cpu_load(struct rq *rq, unsigned long load)
 	update_load_sub(&rq->load, load);
 }
 
-#if (defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)) || defined(CONFIG_RT_GROUP_SCHED)
+#if defined(CONFIG_RT_GROUP_SCHED) || (defined(CONFIG_FAIR_GROUP_SCHED) && \
+			(defined(CONFIG_SMP) || defined(CONFIG_CFS_BANDWIDTH)))
 typedef int (*tg_visitor)(struct task_group *, void *);
 
 /*
- * Iterate the full tree, calling @down when first entering a node and @up when
- * leaving it for the final time.
+ * Iterate task_group tree rooted at *from, calling @down when first entering a
+ * node and @up when leaving it for the final time.
+ *
+ * Caller must hold rcu_lock or sufficient equivalent.
  */
-static int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
+static int walk_tg_tree_from(struct task_group *from,
+			     tg_visitor down, tg_visitor up, void *data)
 {
 	struct task_group *parent, *child;
 	int ret;
 
-	rcu_read_lock();
-	parent = &root_task_group;
+	parent = from;
+
 down:
 	ret = (*down)(parent, data);
 	if (ret)
-		goto out_unlock;
+		goto out;
 	list_for_each_entry_rcu(child, &parent->children, siblings) {
 		parent = child;
 		goto down;
@@ -1497,19 +1645,29 @@ up:
 		continue;
 	}
 	ret = (*up)(parent, data);
-	if (ret)
-		goto out_unlock;
+	if (ret || parent == from)
+		goto out;
 
 	child = parent;
 	parent = parent->parent;
 	if (parent)
 		goto up;
-out_unlock:
-	rcu_read_unlock();
-
+out:
 	return ret;
 }
 
+/*
+ * Iterate the full tree, calling @down when first entering a node and @up when
+ * leaving it for the final time.
+ *
+ * Caller must hold rcu_lock or sufficient equivalent.
+ */
+
+static inline int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
+{
+	return walk_tg_tree_from(&root_task_group, down, up, data);
+}
+
 static int tg_nop(struct task_group *tg, void *data)
 {
 	return 0;
@@ -1569,11 +1727,9 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
 
 	if (nr_running)
-		rq->avg_load_per_task = rq->load.weight / nr_running;
-	else
-		rq->avg_load_per_task = 0;
+		return rq->load.weight / nr_running;
 
-	return rq->avg_load_per_task;
+	return 0;
 }
 
 #ifdef CONFIG_PREEMPT
@@ -1806,7 +1962,6 @@ static void activate_task(struct rq *rq, struct task_struct *p, int flags)
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, flags);
-	inc_nr_running(rq);
 }
 
 /*
@@ -1818,7 +1973,6 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, flags);
-	dec_nr_running(rq);
 }
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
@@ -2390,11 +2544,11 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 
 	/* Look for allowed, online CPU in same node. */
 	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
-		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
+		if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
 			return dest_cpu;
 
 	/* Any allowed, online CPU? */
-	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
+	dest_cpu = cpumask_any_and(tsk_cpus_allowed(p), cpu_active_mask);
 	if (dest_cpu < nr_cpu_ids)
 		return dest_cpu;
 
@@ -2431,7 +2585,7 @@ int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 	 * [ this allows ->select_task() to simply return task_cpu(p) and
 	 *   not worry about this generic constraint ]
 	 */
-	if (unlikely(!cpumask_test_cpu(cpu, &p->cpus_allowed) ||
+	if (unlikely(!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)) ||
 		     !cpu_online(cpu)))
 		cpu = select_fallback_rq(task_cpu(p), p);
 
@@ -2556,42 +2710,26 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 }
 
 #ifdef CONFIG_SMP
-static void sched_ttwu_do_pending(struct task_struct *list)
+static void sched_ttwu_pending(void)
 {
 	struct rq *rq = this_rq();
+	struct llist_node *llist = llist_del_all(&rq->wake_list);
+	struct task_struct *p;
 
 	raw_spin_lock(&rq->lock);
 
-	while (list) {
-		struct task_struct *p = list;
-		list = list->wake_entry;
+	while (llist) {
+		p = llist_entry(llist, struct task_struct, wake_entry);
+		llist = llist_next(llist);
 		ttwu_do_activate(rq, p, 0);
 	}
 
 	raw_spin_unlock(&rq->lock);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-static void sched_ttwu_pending(void)
-{
-	struct rq *rq = this_rq();
-	struct task_struct *list = xchg(&rq->wake_list, NULL);
-
-	if (!list)
-		return;
-
-	sched_ttwu_do_pending(list);
-}
-
-#endif /* CONFIG_HOTPLUG_CPU */
-
 void scheduler_ipi(void)
 {
-	struct rq *rq = this_rq();
-	struct task_struct *list = xchg(&rq->wake_list, NULL);
-
-	if (!list)
+	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
 		return;
 
 	/*
@@ -2608,25 +2746,21 @@ void scheduler_ipi(void)
 	 * somewhat pessimize the simple resched case.
 	 */
 	irq_enter();
-	sched_ttwu_do_pending(list);
+	sched_ttwu_pending();
+
+	/*
+	 * Check if someone kicked us for doing the nohz idle load balance.
+	 */
+	if (unlikely(got_nohz_idle_kick() && !need_resched())) {
+		this_rq()->idle_balance = 1;
+		raise_softirq_irqoff(SCHED_SOFTIRQ);
+	}
 	irq_exit();
 }
 
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
 {
-	struct rq *rq = cpu_rq(cpu);
-	struct task_struct *next = rq->wake_list;
-
-	for (;;) {
-		struct task_struct *old = next;
-
-		p->wake_entry = next;
-		next = cmpxchg(&rq->wake_list, old, p);
-		if (next == old)
-			break;
-	}
-
-	if (!next)
+	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
 		smp_send_reschedule(cpu);
 }
 
@@ -2848,19 +2982,23 @@ void sched_fork(struct task_struct *p)
 	p->state = TASK_RUNNING;
 
 	/*
+	 * Make sure we do not leak PI boosting priority to the child.
+	 */
+	p->prio = current->normal_prio;
+
+	/*
 	 * Revert to default priority/policy on fork if requested.
 	 */
 	if (unlikely(p->sched_reset_on_fork)) {
-		if (p->policy == SCHED_FIFO || p->policy == SCHED_RR) {
+		if (task_has_rt_policy(p)) {
 			p->policy = SCHED_NORMAL;
-			p->normal_prio = p->static_prio;
-		}
-
-		if (PRIO_TO_NICE(p->static_prio) < 0) {
 			p->static_prio = NICE_TO_PRIO(0);
-			p->normal_prio = p->static_prio;
-			set_load_weight(p);
-		}
+			p->rt_priority = 0;
+		} else if (PRIO_TO_NICE(p->static_prio) < 0)
+			p->static_prio = NICE_TO_PRIO(0);
+
+		p->prio = p->normal_prio = __normal_prio(p);
+		set_load_weight(p);
 
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
@@ -2869,11 +3007,6 @@ void sched_fork(struct task_struct *p)
 		p->sched_reset_on_fork = 0;
 	}
 
-	/*
-	 * Make sure we do not leak PI boosting priority to the child.
-	 */
-	p->prio = current->normal_prio;
-
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
@@ -4116,7 +4249,7 @@ void scheduler_tick(void)
 	perf_event_task_tick();
 
 #ifdef CONFIG_SMP
-	rq->idle_at_tick = idle_cpu(cpu);
+	rq->idle_balance = idle_cpu(cpu);
 	trigger_load_balance(rq, cpu);
 #endif
 }
@@ -4239,7 +4372,7 @@ pick_next_task(struct rq *rq)
 	 * Optimization: we know that if all tasks are in
 	 * the fair class we can call that function directly:
 	 */
-	if (likely(rq->nr_running == rq->cfs.nr_running)) {
+	if (likely(rq->nr_running == rq->cfs.h_nr_running)) {
 		p = fair_sched_class.pick_next_task(rq);
 		if (likely(p))
 			return p;
@@ -5025,7 +5158,20 @@ EXPORT_SYMBOL(task_nice);
  */
 int idle_cpu(int cpu)
 {
-	return cpu_curr(cpu) == cpu_rq(cpu)->idle;
+	struct rq *rq = cpu_rq(cpu);
+
+	if (rq->curr != rq->idle)
+		return 0;
+
+	if (rq->nr_running)
+		return 0;
+
+#ifdef CONFIG_SMP
+	if (!llist_empty(&rq->wake_list))
+		return 0;
+#endif
+
+	return 1;
 }
 
 /**
@@ -5875,7 +6021,7 @@ void show_state_filter(unsigned long state_filter)
 	printk(KERN_INFO
 		"  task                        PC stack   pid father\n");
 #endif
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	do_each_thread(g, p) {
 		/*
 		 * reset the NMI-timeout, listing all files on a slow
@@ -5891,7 +6037,7 @@ void show_state_filter(unsigned long state_filter)
 #ifdef CONFIG_SCHED_DEBUG
 	sysrq_sched_debug_show();
 #endif
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	/*
 	 * Only show locks if all tasks are dumped:
 	 */
@@ -6015,10 +6161,9 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 {
 	if (p->sched_class && p->sched_class->set_cpus_allowed)
 		p->sched_class->set_cpus_allowed(p, new_mask);
-	else {
-		cpumask_copy(&p->cpus_allowed, new_mask);
-		p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
-	}
+
+	cpumask_copy(&p->cpus_allowed, new_mask);
+	p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
 }
 
 /*
@@ -6116,7 +6261,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	if (task_cpu(p) != src_cpu)
 		goto done;
 	/* Affinity changed (again). */
-	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
+	if (!cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
 		goto fail;
 
 	/*
@@ -6197,6 +6342,30 @@ static void calc_global_load_remove(struct rq *rq)
 	rq->calc_load_active = 0;
 }
 
+#ifdef CONFIG_CFS_BANDWIDTH
+static void unthrottle_offline_cfs_rqs(struct rq *rq)
+{
+	struct cfs_rq *cfs_rq;
+
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+
+		if (!cfs_rq->runtime_enabled)
+			continue;
+
+		/*
+		 * clock_task is not advancing so we just need to make sure
+		 * there's some valid quota amount
+		 */
+		cfs_rq->runtime_remaining = cfs_b->quota;
+		if (cfs_rq_throttled(cfs_rq))
+			unthrottle_cfs_rq(cfs_rq);
+	}
+}
+#else
+static void unthrottle_offline_cfs_rqs(struct rq *rq) {}
+#endif
+
 /*
  * Migrate all tasks from the rq, sleeping tasks will be migrated by
  * try_to_wake_up()->select_task_rq().
@@ -6222,6 +6391,9 @@ static void migrate_tasks(unsigned int dead_cpu)
 	 */
 	rq->stop = NULL;
 
+	/* Ensure any throttled groups are reachable by pick_next_task */
+	unthrottle_offline_cfs_rqs(rq);
+
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
@@ -7965,6 +8137,7 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 	/* allow initial update_cfs_load() to truncate */
 	cfs_rq->load_stamp = 1;
 #endif
+	init_cfs_rq_runtime(cfs_rq);
 
 	tg->cfs_rq[cpu] = cfs_rq;
 	tg->se[cpu] = se;
@@ -8104,6 +8277,7 @@ void __init sched_init(void)
 		 * We achieve this by letting root_task_group's tasks sit
 		 * directly in rq->cfs (i.e root_task_group->se[] = NULL).
 		 */
+		init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
 		init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, NULL);
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
@@ -8133,7 +8307,6 @@ void __init sched_init(void)
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
 		rq->nohz_balance_kick = 0;
-		init_sched_softirq_csd(&per_cpu(remote_sched_softirq_cb, i));
 #endif
 #endif
 		init_rq_hrtick(rq);
@@ -8345,6 +8518,8 @@ static void free_fair_sched_group(struct task_group *tg)
 {
 	int i;
 
+	destroy_cfs_bandwidth(tg_cfs_bandwidth(tg));
+
 	for_each_possible_cpu(i) {
 		if (tg->cfs_rq)
 			kfree(tg->cfs_rq[i]);
@@ -8372,6 +8547,8 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 
 	tg->shares = NICE_0_LOAD;
 
+	init_cfs_bandwidth(tg_cfs_bandwidth(tg));
+
 	for_each_possible_cpu(i) {
 		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
 				      GFP_KERNEL, cpu_to_node(i));
@@ -8647,12 +8824,7 @@ unsigned long sched_group_shares(struct task_group *tg)
 }
 #endif
 
-#ifdef CONFIG_RT_GROUP_SCHED
-/*
- * Ensure that the real time constraints are schedulable.
- */
-static DEFINE_MUTEX(rt_constraints_mutex);
-
+#if defined(CONFIG_RT_GROUP_SCHED) || defined(CONFIG_CFS_BANDWIDTH)
 static unsigned long to_ratio(u64 period, u64 runtime)
 {
 	if (runtime == RUNTIME_INF)
@@ -8660,6 +8832,13 @@ static unsigned long to_ratio(u64 period, u64 runtime)
 
 	return div64_u64(runtime << 20, period);
 }
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+/*
+ * Ensure that the real time constraints are schedulable.
+ */
+static DEFINE_MUTEX(rt_constraints_mutex);
 
 /* Must be called with tasklist_lock held */
 static inline int tg_has_rt_tasks(struct task_group *tg)
@@ -8680,7 +8859,7 @@ struct rt_schedulable_data {
 	u64 rt_runtime;
 };
 
-static int tg_schedulable(struct task_group *tg, void *data)
+static int tg_rt_schedulable(struct task_group *tg, void *data)
 {
 	struct rt_schedulable_data *d = data;
 	struct task_group *child;
@@ -8738,16 +8917,22 @@ static int tg_schedulable(struct task_group *tg, void *data)
 
 static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 {
+	int ret;
+
 	struct rt_schedulable_data data = {
 		.tg = tg,
 		.rt_period = period,
 		.rt_runtime = runtime,
 	};
 
-	return walk_tg_tree(tg_schedulable, tg_nop, &data);
+	rcu_read_lock();
+	ret = walk_tg_tree(tg_rt_schedulable, tg_nop, &data);
+	rcu_read_unlock();
+
+	return ret;
 }
 
-static int tg_set_bandwidth(struct task_group *tg,
+static int tg_set_rt_bandwidth(struct task_group *tg,
 		u64 rt_period, u64 rt_runtime)
 {
 	int i, err = 0;
@@ -8786,7 +8971,7 @@ int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 	if (rt_runtime_us < 0)
 		rt_runtime = RUNTIME_INF;
 
-	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
 long sched_group_rt_runtime(struct task_group *tg)
@@ -8811,7 +8996,7 @@ int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
 	if (rt_period == 0)
 		return -EINVAL;
 
-	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
 long sched_group_rt_period(struct task_group *tg)
@@ -9001,6 +9186,238 @@ static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
 
 	return (u64) scale_load_down(tg->shares);
 }
+
+#ifdef CONFIG_CFS_BANDWIDTH
+static DEFINE_MUTEX(cfs_constraints_mutex);
+
+const u64 max_cfs_quota_period = 1 * NSEC_PER_SEC; /* 1s */
+const u64 min_cfs_quota_period = 1 * NSEC_PER_MSEC; /* 1ms */
+
+static int __cfs_schedulable(struct task_group *tg, u64 period, u64 runtime);
+
+static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
+{
+	int i, ret = 0, runtime_enabled;
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+
+	if (tg == &root_task_group)
+		return -EINVAL;
+
+	/*
+	 * Ensure we have at some amount of bandwidth every period.  This is
+	 * to prevent reaching a state of large arrears when throttled via
+	 * entity_tick() resulting in prolonged exit starvation.
+	 */
+	if (quota < min_cfs_quota_period || period < min_cfs_quota_period)
+		return -EINVAL;
+
+	/*
+	 * Likewise, bound things on the otherside by preventing insane quota
+	 * periods.  This also allows us to normalize in computing quota
+	 * feasibility.
+	 */
+	if (period > max_cfs_quota_period)
+		return -EINVAL;
+
+	mutex_lock(&cfs_constraints_mutex);
+	ret = __cfs_schedulable(tg, period, quota);
+	if (ret)
+		goto out_unlock;
+
+	runtime_enabled = quota != RUNTIME_INF;
+	raw_spin_lock_irq(&cfs_b->lock);
+	cfs_b->period = ns_to_ktime(period);
+	cfs_b->quota = quota;
+
+	__refill_cfs_bandwidth_runtime(cfs_b);
+	/* restart the period timer (if active) to handle new period expiry */
+	if (runtime_enabled && cfs_b->timer_active) {
+		/* force a reprogram */
+		cfs_b->timer_active = 0;
+		__start_cfs_bandwidth(cfs_b);
+	}
+	raw_spin_unlock_irq(&cfs_b->lock);
+
+	for_each_possible_cpu(i) {
+		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
+		struct rq *rq = rq_of(cfs_rq);
+
+		raw_spin_lock_irq(&rq->lock);
+		cfs_rq->runtime_enabled = runtime_enabled;
+		cfs_rq->runtime_remaining = 0;
+
+		if (cfs_rq_throttled(cfs_rq))
+			unthrottle_cfs_rq(cfs_rq);
+		raw_spin_unlock_irq(&rq->lock);
+	}
+out_unlock:
+	mutex_unlock(&cfs_constraints_mutex);
+
+	return ret;
+}
+
+int tg_set_cfs_quota(struct task_group *tg, long cfs_quota_us)
+{
+	u64 quota, period;
+
+	period = ktime_to_ns(tg_cfs_bandwidth(tg)->period);
+	if (cfs_quota_us < 0)
+		quota = RUNTIME_INF;
+	else
+		quota = (u64)cfs_quota_us * NSEC_PER_USEC;
+
+	return tg_set_cfs_bandwidth(tg, period, quota);
+}
+
+long tg_get_cfs_quota(struct task_group *tg)
+{
+	u64 quota_us;
+
+	if (tg_cfs_bandwidth(tg)->quota == RUNTIME_INF)
+		return -1;
+
+	quota_us = tg_cfs_bandwidth(tg)->quota;
+	do_div(quota_us, NSEC_PER_USEC);
+
+	return quota_us;
+}
+
+int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
+{
+	u64 quota, period;
+
+	period = (u64)cfs_period_us * NSEC_PER_USEC;
+	quota = tg_cfs_bandwidth(tg)->quota;
+
+	if (period <= 0)
+		return -EINVAL;
+
+	return tg_set_cfs_bandwidth(tg, period, quota);
+}
+
+long tg_get_cfs_period(struct task_group *tg)
+{
+	u64 cfs_period_us;
+
+	cfs_period_us = ktime_to_ns(tg_cfs_bandwidth(tg)->period);
+	do_div(cfs_period_us, NSEC_PER_USEC);
+
+	return cfs_period_us;
+}
+
+static s64 cpu_cfs_quota_read_s64(struct cgroup *cgrp, struct cftype *cft)
+{
+	return tg_get_cfs_quota(cgroup_tg(cgrp));
+}
+
+static int cpu_cfs_quota_write_s64(struct cgroup *cgrp, struct cftype *cftype,
+				s64 cfs_quota_us)
+{
+	return tg_set_cfs_quota(cgroup_tg(cgrp), cfs_quota_us);
+}
+
+static u64 cpu_cfs_period_read_u64(struct cgroup *cgrp, struct cftype *cft)
+{
+	return tg_get_cfs_period(cgroup_tg(cgrp));
+}
+
+static int cpu_cfs_period_write_u64(struct cgroup *cgrp, struct cftype *cftype,
+				u64 cfs_period_us)
+{
+	return tg_set_cfs_period(cgroup_tg(cgrp), cfs_period_us);
+}
+
+struct cfs_schedulable_data {
+	struct task_group *tg;
+	u64 period, quota;
+};
+
+/*
+ * normalize group quota/period to be quota/max_period
+ * note: units are usecs
+ */
+static u64 normalize_cfs_quota(struct task_group *tg,
+			       struct cfs_schedulable_data *d)
+{
+	u64 quota, period;
+
+	if (tg == d->tg) {
+		period = d->period;
+		quota = d->quota;
+	} else {
+		period = tg_get_cfs_period(tg);
+		quota = tg_get_cfs_quota(tg);
+	}
+
+	/* note: these should typically be equivalent */
+	if (quota == RUNTIME_INF || quota == -1)
+		return RUNTIME_INF;
+
+	return to_ratio(period, quota);
+}
+
+static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
+{
+	struct cfs_schedulable_data *d = data;
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	s64 quota = 0, parent_quota = -1;
+
+	if (!tg->parent) {
+		quota = RUNTIME_INF;
+	} else {
+		struct cfs_bandwidth *parent_b = tg_cfs_bandwidth(tg->parent);
+
+		quota = normalize_cfs_quota(tg, d);
+		parent_quota = parent_b->hierarchal_quota;
+
+		/*
+		 * ensure max(child_quota) <= parent_quota, inherit when no
+		 * limit is set
+		 */
+		if (quota == RUNTIME_INF)
+			quota = parent_quota;
+		else if (parent_quota != RUNTIME_INF && quota > parent_quota)
+			return -EINVAL;
+	}
+	cfs_b->hierarchal_quota = quota;
+
+	return 0;
+}
+
+static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
+{
+	int ret;
+	struct cfs_schedulable_data data = {
+		.tg = tg,
+		.period = period,
+		.quota = quota,
+	};
+
+	if (quota != RUNTIME_INF) {
+		do_div(data.period, NSEC_PER_USEC);
+		do_div(data.quota, NSEC_PER_USEC);
+	}
+
+	rcu_read_lock();
+	ret = walk_tg_tree(tg_cfs_schedulable_down, tg_nop, &data);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static int cpu_stats_show(struct cgroup *cgrp, struct cftype *cft,
+		struct cgroup_map_cb *cb)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+
+	cb->fill(cb, "nr_periods", cfs_b->nr_periods);
+	cb->fill(cb, "nr_throttled", cfs_b->nr_throttled);
+	cb->fill(cb, "throttled_time", cfs_b->throttled_time);
+
+	return 0;
+}
+#endif /* CONFIG_CFS_BANDWIDTH */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -9035,6 +9452,22 @@ static struct cftype cpu_files[] = {
 		.write_u64 = cpu_shares_write_u64,
 	},
 #endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	{
+		.name = "cfs_quota_us",
+		.read_s64 = cpu_cfs_quota_read_s64,
+		.write_s64 = cpu_cfs_quota_write_s64,
+	},
+	{
+		.name = "cfs_period_us",
+		.read_u64 = cpu_cfs_period_read_u64,
+		.write_u64 = cpu_cfs_period_write_u64,
+	},
+	{
+		.name = "stat",
+		.read_map = cpu_stats_show,
+	},
+#endif
 #ifdef CONFIG_RT_GROUP_SCHED
 	{
 		.name = "rt_runtime_us",
@@ -9344,4 +9777,3 @@ struct cgroup_subsys cpuacct_subsys = {
 	.subsys_id = cpuacct_subsys_id,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
-
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 2722dc1..a86cf9d 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -47,9 +47,6 @@ static int convert_prio(int prio)
 	return cpupri;
 }
 
-#define for_each_cpupri_active(array, idx)                    \
-	for_each_set_bit(idx, array, CPUPRI_NR_PRIORITIES)
-
 /**
  * cpupri_find - find the best (lowest-pri) CPU in the system
  * @cp: The cpupri context
@@ -71,11 +68,38 @@ int cpupri_find(struct cpupri *cp, struct task_struct *p,
 	int                  idx      = 0;
 	int                  task_pri = convert_prio(p->prio);
 
-	for_each_cpupri_active(cp->pri_active, idx) {
-		struct cpupri_vec *vec  = &cp->pri_to_cpu[idx];
+	if (task_pri >= MAX_RT_PRIO)
+		return 0;
 
-		if (idx >= task_pri)
-			break;
+	for (idx = 0; idx < task_pri; idx++) {
+		struct cpupri_vec *vec  = &cp->pri_to_cpu[idx];
+		int skip = 0;
+
+		if (!atomic_read(&(vec)->count))
+			skip = 1;
+		/*
+		 * When looking at the vector, we need to read the counter,
+		 * do a memory barrier, then read the mask.
+		 *
+		 * Note: This is still all racey, but we can deal with it.
+		 *  Ideally, we only want to look at masks that are set.
+		 *
+		 *  If a mask is not set, then the only thing wrong is that we
+		 *  did a little more work than necessary.
+		 *
+		 *  If we read a zero count but the mask is set, because of the
+		 *  memory barriers, that can only happen when the highest prio
+		 *  task for a run queue has left the run queue, in which case,
+		 *  it will be followed by a pull. If the task we are processing
+		 *  fails to find a proper place to go, that pull request will
+		 *  pull this task if the run queue is running at a lower
+		 *  priority.
+		 */
+		smp_rmb();
+
+		/* Need to do the rmb for every iteration */
+		if (skip)
+			continue;
 
 		if (cpumask_any_and(&p->cpus_allowed, vec->mask) >= nr_cpu_ids)
 			continue;
@@ -115,7 +139,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 {
 	int                 *currpri = &cp->cpu_to_pri[cpu];
 	int                  oldpri  = *currpri;
-	unsigned long        flags;
+	int                  do_mb = 0;
 
 	newpri = convert_prio(newpri);
 
@@ -128,32 +152,46 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 	 * If the cpu was currently mapped to a different value, we
 	 * need to map it to the new value then remove the old value.
 	 * Note, we must add the new value first, otherwise we risk the
-	 * cpu being cleared from pri_active, and this cpu could be
-	 * missed for a push or pull.
+	 * cpu being missed by the priority loop in cpupri_find.
 	 */
 	if (likely(newpri != CPUPRI_INVALID)) {
 		struct cpupri_vec *vec = &cp->pri_to_cpu[newpri];
 
-		raw_spin_lock_irqsave(&vec->lock, flags);
-
 		cpumask_set_cpu(cpu, vec->mask);
-		vec->count++;
-		if (vec->count == 1)
-			set_bit(newpri, cp->pri_active);
-
-		raw_spin_unlock_irqrestore(&vec->lock, flags);
+		/*
+		 * When adding a new vector, we update the mask first,
+		 * do a write memory barrier, and then update the count, to
+		 * make sure the vector is visible when count is set.
+		 */
+		smp_mb__before_atomic_inc();
+		atomic_inc(&(vec)->count);
+		do_mb = 1;
 	}
 	if (likely(oldpri != CPUPRI_INVALID)) {
 		struct cpupri_vec *vec  = &cp->pri_to_cpu[oldpri];
 
-		raw_spin_lock_irqsave(&vec->lock, flags);
-
-		vec->count--;
-		if (!vec->count)
-			clear_bit(oldpri, cp->pri_active);
+		/*
+		 * Because the order of modification of the vec->count
+		 * is important, we must make sure that the update
+		 * of the new prio is seen before we decrement the
+		 * old prio. This makes sure that the loop sees
+		 * one or the other when we raise the priority of
+		 * the run queue. We don't care about when we lower the
+		 * priority, as that will trigger an rt pull anyway.
+		 *
+		 * We only need to do a memory barrier if we updated
+		 * the new priority vec.
+		 */
+		if (do_mb)
+			smp_mb__after_atomic_inc();
+
+		/*
+		 * When removing from the vector, we decrement the counter first
+		 * do a memory barrier and then clear the mask.
+		 */
+		atomic_dec(&(vec)->count);
+		smp_mb__after_atomic_inc();
 		cpumask_clear_cpu(cpu, vec->mask);
-
-		raw_spin_unlock_irqrestore(&vec->lock, flags);
 	}
 
 	*currpri = newpri;
@@ -175,8 +213,7 @@ int cpupri_init(struct cpupri *cp)
 	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++) {
 		struct cpupri_vec *vec = &cp->pri_to_cpu[i];
 
-		raw_spin_lock_init(&vec->lock);
-		vec->count = 0;
+		atomic_set(&vec->count, 0);
 		if (!zalloc_cpumask_var(&vec->mask, GFP_KERNEL))
 			goto cleanup;
 	}
diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
index 9fc7d38..f6d7561 100644
--- a/kernel/sched_cpupri.h
+++ b/kernel/sched_cpupri.h
@@ -4,7 +4,6 @@
 #include <linux/sched.h>
 
 #define CPUPRI_NR_PRIORITIES	(MAX_RT_PRIO + 2)
-#define CPUPRI_NR_PRI_WORDS	BITS_TO_LONGS(CPUPRI_NR_PRIORITIES)
 
 #define CPUPRI_INVALID -1
 #define CPUPRI_IDLE     0
@@ -12,14 +11,12 @@
 /* values 2-101 are RT priorities 0-99 */
 
 struct cpupri_vec {
-	raw_spinlock_t lock;
-	int        count;
-	cpumask_var_t mask;
+	atomic_t	count;
+	cpumask_var_t	mask;
 };
 
 struct cpupri {
 	struct cpupri_vec pri_to_cpu[CPUPRI_NR_PRIORITIES];
-	long              pri_active[CPUPRI_NR_PRI_WORDS];
 	int               cpu_to_pri[NR_CPUS];
 };
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index bc8ee99..5c9e679 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -89,6 +89,20 @@ const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
  */
 unsigned int __read_mostly sysctl_sched_shares_window = 10000000UL;
 
+#ifdef CONFIG_CFS_BANDWIDTH
+/*
+ * Amount of runtime to allocate from global (tg) to local (per-cfs_rq) pool
+ * each time a cfs_rq requests quota.
+ *
+ * Note: in the case that the slice exceeds the runtime remaining (either due
+ * to consumption or the quota being specified to be smaller than the slice)
+ * we will always only issue the remaining available time.
+ *
+ * default: 5 msec, units: microseconds
+  */
+unsigned int sysctl_sched_cfs_bandwidth_slice = 5000UL;
+#endif
+
 static const struct sched_class fair_sched_class;
 
 /**************************************************************
@@ -292,6 +306,8 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+				   unsigned long delta_exec);
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -583,6 +599,8 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
+
+	account_cfs_rq_runtime(cfs_rq, delta_exec);
 }
 
 static inline void
@@ -688,6 +706,8 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+/* we need this in update_cfs_load and load-balance functions below */
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq);
 # ifdef CONFIG_SMP
 static void update_cfs_rq_load_contribution(struct cfs_rq *cfs_rq,
 					    int global_update)
@@ -710,7 +730,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 	u64 now, delta;
 	unsigned long load = cfs_rq->load.weight;
 
-	if (cfs_rq->tg == &root_task_group)
+	if (cfs_rq->tg == &root_task_group || throttled_hierarchy(cfs_rq))
 		return;
 
 	now = rq_of(cfs_rq)->clock_task;
@@ -819,7 +839,7 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq)
 
 	tg = cfs_rq->tg;
 	se = tg->se[cpu_of(rq_of(cfs_rq))];
-	if (!se)
+	if (!se || throttled_hierarchy(cfs_rq))
 		return;
 #ifndef CONFIG_SMP
 	if (likely(se->load.weight == tg->shares))
@@ -950,6 +970,8 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	se->vruntime = vruntime;
 }
 
+static void check_enqueue_throttle(struct cfs_rq *cfs_rq);
+
 static void
 enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
@@ -979,8 +1001,10 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 		__enqueue_entity(cfs_rq, se);
 	se->on_rq = 1;
 
-	if (cfs_rq->nr_running == 1)
+	if (cfs_rq->nr_running == 1) {
 		list_add_leaf_cfs_rq(cfs_rq);
+		check_enqueue_throttle(cfs_rq);
+	}
 }
 
 static void __clear_buddies_last(struct sched_entity *se)
@@ -1028,6 +1052,8 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		__clear_buddies_skip(se);
 }
 
+static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
@@ -1066,6 +1092,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	if (!(flags & DEQUEUE_SLEEP))
 		se->vruntime -= cfs_rq->min_vruntime;
 
+	/* return excess runtime on last dequeue */
+	return_cfs_rq_runtime(cfs_rq);
+
 	update_min_vruntime(cfs_rq);
 	update_cfs_shares(cfs_rq);
 }
@@ -1077,6 +1106,8 @@ static void
 check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
 	unsigned long ideal_runtime, delta_exec;
+	struct sched_entity *se;
+	s64 delta;
 
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
@@ -1095,22 +1126,17 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 	 * narrow margin doesn't have to wait for a full slice.
 	 * This also mitigates buddy induced latencies under load.
 	 */
-	if (!sched_feat(WAKEUP_PREEMPT))
-		return;
-
 	if (delta_exec < sysctl_sched_min_granularity)
 		return;
 
-	if (cfs_rq->nr_running > 1) {
-		struct sched_entity *se = __pick_first_entity(cfs_rq);
-		s64 delta = curr->vruntime - se->vruntime;
+	se = __pick_first_entity(cfs_rq);
+	delta = curr->vruntime - se->vruntime;
 
-		if (delta < 0)
-			return;
+	if (delta < 0)
+		return;
 
-		if (delta > ideal_runtime)
-			resched_task(rq_of(cfs_rq)->curr);
-	}
+	if (delta > ideal_runtime)
+		resched_task(rq_of(cfs_rq)->curr);
 }
 
 static void
@@ -1185,6 +1211,8 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 	return se;
 }
 
+static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
 	/*
@@ -1194,6 +1222,9 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 	if (prev->on_rq)
 		update_curr(cfs_rq);
 
+	/* throttle cfs_rqs exceeding runtime */
+	check_cfs_rq_runtime(cfs_rq);
+
 	check_spread(cfs_rq, prev);
 	if (prev->on_rq) {
 		update_stats_wait_start(cfs_rq, prev);
@@ -1233,10 +1264,583 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 		return;
 #endif
 
-	if (cfs_rq->nr_running > 1 || !sched_feat(WAKEUP_PREEMPT))
+	if (cfs_rq->nr_running > 1)
 		check_preempt_tick(cfs_rq, curr);
 }
 
+
+/**************************************************
+ * CFS bandwidth control machinery
+ */
+
+#ifdef CONFIG_CFS_BANDWIDTH
+/*
+ * default period for cfs group bandwidth.
+ * default: 0.1s, units: nanoseconds
+ */
+static inline u64 default_cfs_period(void)
+{
+	return 100000000ULL;
+}
+
+static inline u64 sched_cfs_bandwidth_slice(void)
+{
+	return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
+}
+
+/*
+ * Replenish runtime according to assigned quota and update expiration time.
+ * We use sched_clock_cpu directly instead of rq->clock to avoid adding
+ * additional synchronization around rq->lock.
+ *
+ * requires cfs_b->lock
+ */
+static void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
+{
+	u64 now;
+
+	if (cfs_b->quota == RUNTIME_INF)
+		return;
+
+	now = sched_clock_cpu(smp_processor_id());
+	cfs_b->runtime = cfs_b->quota;
+	cfs_b->runtime_expires = now + ktime_to_ns(cfs_b->period);
+}
+
+/* returns 0 on failure to allocate runtime */
+static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	struct task_group *tg = cfs_rq->tg;
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	u64 amount = 0, min_amount, expires;
+
+	/* note: this is a positive sum as runtime_remaining <= 0 */
+	min_amount = sched_cfs_bandwidth_slice() - cfs_rq->runtime_remaining;
+
+	raw_spin_lock(&cfs_b->lock);
+	if (cfs_b->quota == RUNTIME_INF)
+		amount = min_amount;
+	else {
+		/*
+		 * If the bandwidth pool has become inactive, then at least one
+		 * period must have elapsed since the last consumption.
+		 * Refresh the global state and ensure bandwidth timer becomes
+		 * active.
+		 */
+		if (!cfs_b->timer_active) {
+			__refill_cfs_bandwidth_runtime(cfs_b);
+			__start_cfs_bandwidth(cfs_b);
+		}
+
+		if (cfs_b->runtime > 0) {
+			amount = min(cfs_b->runtime, min_amount);
+			cfs_b->runtime -= amount;
+			cfs_b->idle = 0;
+		}
+	}
+	expires = cfs_b->runtime_expires;
+	raw_spin_unlock(&cfs_b->lock);
+
+	cfs_rq->runtime_remaining += amount;
+	/*
+	 * we may have advanced our local expiration to account for allowed
+	 * spread between our sched_clock and the one on which runtime was
+	 * issued.
+	 */
+	if ((s64)(expires - cfs_rq->runtime_expires) > 0)
+		cfs_rq->runtime_expires = expires;
+
+	return cfs_rq->runtime_remaining > 0;
+}
+
+/*
+ * Note: This depends on the synchronization provided by sched_clock and the
+ * fact that rq->clock snapshots this value.
+ */
+static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	struct rq *rq = rq_of(cfs_rq);
+
+	/* if the deadline is ahead of our clock, nothing to do */
+	if (likely((s64)(rq->clock - cfs_rq->runtime_expires) < 0))
+		return;
+
+	if (cfs_rq->runtime_remaining < 0)
+		return;
+
+	/*
+	 * If the local deadline has passed we have to consider the
+	 * possibility that our sched_clock is 'fast' and the global deadline
+	 * has not truly expired.
+	 *
+	 * Fortunately we can check determine whether this the case by checking
+	 * whether the global deadline has advanced.
+	 */
+
+	if ((s64)(cfs_rq->runtime_expires - cfs_b->runtime_expires) >= 0) {
+		/* extend local deadline, drift is bounded above by 2 ticks */
+		cfs_rq->runtime_expires += TICK_NSEC;
+	} else {
+		/* global deadline is ahead, expiration has passed */
+		cfs_rq->runtime_remaining = 0;
+	}
+}
+
+static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+				     unsigned long delta_exec)
+{
+	/* dock delta_exec before expiring quota (as it could span periods) */
+	cfs_rq->runtime_remaining -= delta_exec;
+	expire_cfs_rq_runtime(cfs_rq);
+
+	if (likely(cfs_rq->runtime_remaining > 0))
+		return;
+
+	/*
+	 * if we're unable to extend our runtime we resched so that the active
+	 * hierarchy can be throttled
+	 */
+	if (!assign_cfs_rq_runtime(cfs_rq) && likely(cfs_rq->curr))
+		resched_task(rq_of(cfs_rq)->curr);
+}
+
+static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+						   unsigned long delta_exec)
+{
+	if (!cfs_rq->runtime_enabled)
+		return;
+
+	__account_cfs_rq_runtime(cfs_rq, delta_exec);
+}
+
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->throttled;
+}
+
+/* check whether cfs_rq, or any parent, is throttled */
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->throttle_count;
+}
+
+/*
+ * Ensure that neither of the group entities corresponding to src_cpu or
+ * dest_cpu are members of a throttled hierarchy when performing group
+ * load-balance operations.
+ */
+static inline int throttled_lb_pair(struct task_group *tg,
+				    int src_cpu, int dest_cpu)
+{
+	struct cfs_rq *src_cfs_rq, *dest_cfs_rq;
+
+	src_cfs_rq = tg->cfs_rq[src_cpu];
+	dest_cfs_rq = tg->cfs_rq[dest_cpu];
+
+	return throttled_hierarchy(src_cfs_rq) ||
+	       throttled_hierarchy(dest_cfs_rq);
+}
+
+/* updated child weight may affect parent so we have to do this bottom up */
+static int tg_unthrottle_up(struct task_group *tg, void *data)
+{
+	struct rq *rq = data;
+	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
+
+	cfs_rq->throttle_count--;
+#ifdef CONFIG_SMP
+	if (!cfs_rq->throttle_count) {
+		u64 delta = rq->clock_task - cfs_rq->load_stamp;
+
+		/* leaving throttled state, advance shares averaging windows */
+		cfs_rq->load_stamp += delta;
+		cfs_rq->load_last += delta;
+
+		/* update entity weight now that we are on_rq again */
+		update_cfs_shares(cfs_rq);
+	}
+#endif
+
+	return 0;
+}
+
+static int tg_throttle_down(struct task_group *tg, void *data)
+{
+	struct rq *rq = data;
+	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
+
+	/* group is entering throttled state, record last load */
+	if (!cfs_rq->throttle_count)
+		update_cfs_load(cfs_rq, 0);
+	cfs_rq->throttle_count++;
+
+	return 0;
+}
+
+static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	struct rq *rq = rq_of(cfs_rq);
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	struct sched_entity *se;
+	long task_delta, dequeue = 1;
+
+	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+
+	/* account load preceding throttle */
+	rcu_read_lock();
+	walk_tg_tree_from(cfs_rq->tg, tg_throttle_down, tg_nop, (void *)rq);
+	rcu_read_unlock();
+
+	task_delta = cfs_rq->h_nr_running;
+	for_each_sched_entity(se) {
+		struct cfs_rq *qcfs_rq = cfs_rq_of(se);
+		/* throttled entity or throttle-on-deactivate */
+		if (!se->on_rq)
+			break;
+
+		if (dequeue)
+			dequeue_entity(qcfs_rq, se, DEQUEUE_SLEEP);
+		qcfs_rq->h_nr_running -= task_delta;
+
+		if (qcfs_rq->load.weight)
+			dequeue = 0;
+	}
+
+	if (!se)
+		rq->nr_running -= task_delta;
+
+	cfs_rq->throttled = 1;
+	cfs_rq->throttled_timestamp = rq->clock;
+	raw_spin_lock(&cfs_b->lock);
+	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
+	raw_spin_unlock(&cfs_b->lock);
+}
+
+static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	struct rq *rq = rq_of(cfs_rq);
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	struct sched_entity *se;
+	int enqueue = 1;
+	long task_delta;
+
+	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+
+	cfs_rq->throttled = 0;
+	raw_spin_lock(&cfs_b->lock);
+	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_timestamp;
+	list_del_rcu(&cfs_rq->throttled_list);
+	raw_spin_unlock(&cfs_b->lock);
+	cfs_rq->throttled_timestamp = 0;
+
+	update_rq_clock(rq);
+	/* update hierarchical throttle state */
+	walk_tg_tree_from(cfs_rq->tg, tg_nop, tg_unthrottle_up, (void *)rq);
+
+	if (!cfs_rq->load.weight)
+		return;
+
+	task_delta = cfs_rq->h_nr_running;
+	for_each_sched_entity(se) {
+		if (se->on_rq)
+			enqueue = 0;
+
+		cfs_rq = cfs_rq_of(se);
+		if (enqueue)
+			enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
+		cfs_rq->h_nr_running += task_delta;
+
+		if (cfs_rq_throttled(cfs_rq))
+			break;
+	}
+
+	if (!se)
+		rq->nr_running += task_delta;
+
+	/* determine whether we need to wake up potentially idle cpu */
+	if (rq->curr == rq->idle && rq->cfs.nr_running)
+		resched_task(rq->curr);
+}
+
+static u64 distribute_cfs_runtime(struct cfs_bandwidth *cfs_b,
+		u64 remaining, u64 expires)
+{
+	struct cfs_rq *cfs_rq;
+	u64 runtime = remaining;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(cfs_rq, &cfs_b->throttled_cfs_rq,
+				throttled_list) {
+		struct rq *rq = rq_of(cfs_rq);
+
+		raw_spin_lock(&rq->lock);
+		if (!cfs_rq_throttled(cfs_rq))
+			goto next;
+
+		runtime = -cfs_rq->runtime_remaining + 1;
+		if (runtime > remaining)
+			runtime = remaining;
+		remaining -= runtime;
+
+		cfs_rq->runtime_remaining += runtime;
+		cfs_rq->runtime_expires = expires;
+
+		/* we check whether we're throttled above */
+		if (cfs_rq->runtime_remaining > 0)
+			unthrottle_cfs_rq(cfs_rq);
+
+next:
+		raw_spin_unlock(&rq->lock);
+
+		if (!remaining)
+			break;
+	}
+	rcu_read_unlock();
+
+	return remaining;
+}
+
+/*
+ * Responsible for refilling a task_group's bandwidth and unthrottling its
+ * cfs_rqs as appropriate. If there has been no activity within the last
+ * period the timer is deactivated until scheduling resumes; cfs_b->idle is
+ * used to track this state.
+ */
+static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
+{
+	u64 runtime, runtime_expires;
+	int idle = 1, throttled;
+
+	raw_spin_lock(&cfs_b->lock);
+	/* no need to continue the timer with no bandwidth constraint */
+	if (cfs_b->quota == RUNTIME_INF)
+		goto out_unlock;
+
+	throttled = !list_empty(&cfs_b->throttled_cfs_rq);
+	/* idle depends on !throttled (for the case of a large deficit) */
+	idle = cfs_b->idle && !throttled;
+	cfs_b->nr_periods += overrun;
+
+	/* if we're going inactive then everything else can be deferred */
+	if (idle)
+		goto out_unlock;
+
+	__refill_cfs_bandwidth_runtime(cfs_b);
+
+	if (!throttled) {
+		/* mark as potentially idle for the upcoming period */
+		cfs_b->idle = 1;
+		goto out_unlock;
+	}
+
+	/* account preceding periods in which throttling occurred */
+	cfs_b->nr_throttled += overrun;
+
+	/*
+	 * There are throttled entities so we must first use the new bandwidth
+	 * to unthrottle them before making it generally available.  This
+	 * ensures that all existing debts will be paid before a new cfs_rq is
+	 * allowed to run.
+	 */
+	runtime = cfs_b->runtime;
+	runtime_expires = cfs_b->runtime_expires;
+	cfs_b->runtime = 0;
+
+	/*
+	 * This check is repeated as we are holding onto the new bandwidth
+	 * while we unthrottle.  This can potentially race with an unthrottled
+	 * group trying to acquire new bandwidth from the global pool.
+	 */
+	while (throttled && runtime > 0) {
+		raw_spin_unlock(&cfs_b->lock);
+		/* we can't nest cfs_b->lock while distributing bandwidth */
+		runtime = distribute_cfs_runtime(cfs_b, runtime,
+						 runtime_expires);
+		raw_spin_lock(&cfs_b->lock);
+
+		throttled = !list_empty(&cfs_b->throttled_cfs_rq);
+	}
+
+	/* return (any) remaining runtime */
+	cfs_b->runtime = runtime;
+	/*
+	 * While we are ensured activity in the period following an
+	 * unthrottle, this also covers the case in which the new bandwidth is
+	 * insufficient to cover the existing bandwidth deficit.  (Forcing the
+	 * timer to remain active while there are any throttled entities.)
+	 */
+	cfs_b->idle = 0;
+out_unlock:
+	if (idle)
+		cfs_b->timer_active = 0;
+	raw_spin_unlock(&cfs_b->lock);
+
+	return idle;
+}
+
+/* a cfs_rq won't donate quota below this amount */
+static const u64 min_cfs_rq_runtime = 1 * NSEC_PER_MSEC;
+/* minimum remaining period time to redistribute slack quota */
+static const u64 min_bandwidth_expiration = 2 * NSEC_PER_MSEC;
+/* how long we wait to gather additional slack before distributing */
+static const u64 cfs_bandwidth_slack_period = 5 * NSEC_PER_MSEC;
+
+/* are we near the end of the current quota period? */
+static int runtime_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
+{
+	struct hrtimer *refresh_timer = &cfs_b->period_timer;
+	u64 remaining;
+
+	/* if the call-back is running a quota refresh is already occurring */
+	if (hrtimer_callback_running(refresh_timer))
+		return 1;
+
+	/* is a quota refresh about to occur? */
+	remaining = ktime_to_ns(hrtimer_expires_remaining(refresh_timer));
+	if (remaining < min_expire)
+		return 1;
+
+	return 0;
+}
+
+static void start_cfs_slack_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	u64 min_left = cfs_bandwidth_slack_period + min_bandwidth_expiration;
+
+	/* if there's a quota refresh soon don't bother with slack */
+	if (runtime_refresh_within(cfs_b, min_left))
+		return;
+
+	start_bandwidth_timer(&cfs_b->slack_timer,
+				ns_to_ktime(cfs_bandwidth_slack_period));
+}
+
+/* we know any runtime found here is valid as update_curr() precedes return */
+static void __return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	s64 slack_runtime = cfs_rq->runtime_remaining - min_cfs_rq_runtime;
+
+	if (slack_runtime <= 0)
+		return;
+
+	raw_spin_lock(&cfs_b->lock);
+	if (cfs_b->quota != RUNTIME_INF &&
+	    cfs_rq->runtime_expires == cfs_b->runtime_expires) {
+		cfs_b->runtime += slack_runtime;
+
+		/* we are under rq->lock, defer unthrottling using a timer */
+		if (cfs_b->runtime > sched_cfs_bandwidth_slice() &&
+		    !list_empty(&cfs_b->throttled_cfs_rq))
+			start_cfs_slack_bandwidth(cfs_b);
+	}
+	raw_spin_unlock(&cfs_b->lock);
+
+	/* even if it's not valid for return we don't want to try again */
+	cfs_rq->runtime_remaining -= slack_runtime;
+}
+
+static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	if (!cfs_rq->runtime_enabled || !cfs_rq->nr_running)
+		return;
+
+	__return_cfs_rq_runtime(cfs_rq);
+}
+
+/*
+ * This is done with a timer (instead of inline with bandwidth return) since
+ * it's necessary to juggle rq->locks to unthrottle their respective cfs_rqs.
+ */
+static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
+{
+	u64 runtime = 0, slice = sched_cfs_bandwidth_slice();
+	u64 expires;
+
+	/* confirm we're still not at a refresh boundary */
+	if (runtime_refresh_within(cfs_b, min_bandwidth_expiration))
+		return;
+
+	raw_spin_lock(&cfs_b->lock);
+	if (cfs_b->quota != RUNTIME_INF && cfs_b->runtime > slice) {
+		runtime = cfs_b->runtime;
+		cfs_b->runtime = 0;
+	}
+	expires = cfs_b->runtime_expires;
+	raw_spin_unlock(&cfs_b->lock);
+
+	if (!runtime)
+		return;
+
+	runtime = distribute_cfs_runtime(cfs_b, runtime, expires);
+
+	raw_spin_lock(&cfs_b->lock);
+	if (expires == cfs_b->runtime_expires)
+		cfs_b->runtime = runtime;
+	raw_spin_unlock(&cfs_b->lock);
+}
+
+/*
+ * When a group wakes up we want to make sure that its quota is not already
+ * expired/exceeded, otherwise it may be allowed to steal additional ticks of
+ * runtime as update_curr() throttling can not not trigger until it's on-rq.
+ */
+static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
+{
+	/* an active group must be handled by the update_curr()->put() path */
+	if (!cfs_rq->runtime_enabled || cfs_rq->curr)
+		return;
+
+	/* ensure the group is not already throttled */
+	if (cfs_rq_throttled(cfs_rq))
+		return;
+
+	/* update runtime allocation */
+	account_cfs_rq_runtime(cfs_rq, 0);
+	if (cfs_rq->runtime_remaining <= 0)
+		throttle_cfs_rq(cfs_rq);
+}
+
+/* conditionally throttle active cfs_rq's from put_prev_entity() */
+static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	if (likely(!cfs_rq->runtime_enabled || cfs_rq->runtime_remaining > 0))
+		return;
+
+	/*
+	 * it's possible for a throttled entity to be forced into a running
+	 * state (e.g. set_curr_task), in this case we're finished.
+	 */
+	if (cfs_rq_throttled(cfs_rq))
+		return;
+
+	throttle_cfs_rq(cfs_rq);
+}
+#else
+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+				     unsigned long delta_exec) {}
+static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
+static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
+static inline int throttled_lb_pair(struct task_group *tg,
+				    int src_cpu, int dest_cpu)
+{
+	return 0;
+}
+#endif
+
 /**************************************************
  * CFS operations on tasks:
  */
@@ -1313,16 +1917,33 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
+
+		/*
+		 * end evaluation on encountering a throttled cfs_rq
+		 *
+		 * note: in the case of encountering a throttled cfs_rq we will
+		 * post the final h_nr_running increment below.
+		*/
+		if (cfs_rq_throttled(cfs_rq))
+			break;
+		cfs_rq->h_nr_running++;
+
 		flags = ENQUEUE_WAKEUP;
 	}
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
+		cfs_rq->h_nr_running++;
+
+		if (cfs_rq_throttled(cfs_rq))
+			break;
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
+	if (!se)
+		inc_nr_running(rq);
 	hrtick_update(rq);
 }
 
@@ -1343,6 +1964,16 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
 
+		/*
+		 * end evaluation on encountering a throttled cfs_rq
+		 *
+		 * note: in the case of encountering a throttled cfs_rq we will
+		 * post the final h_nr_running decrement below.
+		*/
+		if (cfs_rq_throttled(cfs_rq))
+			break;
+		cfs_rq->h_nr_running--;
+
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight) {
 			/*
@@ -1361,11 +1992,17 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
+		cfs_rq->h_nr_running--;
+
+		if (cfs_rq_throttled(cfs_rq))
+			break;
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 	}
 
+	if (!se)
+		dec_nr_running(rq);
 	hrtick_update(rq);
 }
 
@@ -1434,7 +2071,6 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 
 	return wl;
 }
-
 #else
 
 static inline unsigned long effective_load(struct task_group *tg, int cpu,
@@ -1547,7 +2183,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 
 		/* Skip over this group if it has no CPUs allowed */
 		if (!cpumask_intersects(sched_group_cpus(group),
-					&p->cpus_allowed))
+					tsk_cpus_allowed(p)))
 			continue;
 
 		local_group = cpumask_test_cpu(this_cpu,
@@ -1593,7 +2229,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 	int i;
 
 	/* Traverse only the allowed CPUs */
-	for_each_cpu_and(i, sched_group_cpus(group), &p->cpus_allowed) {
+	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -1637,7 +2273,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
 			break;
 
-		for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
+		for_each_cpu_and(i, sched_domain_span(sd), tsk_cpus_allowed(p)) {
 			if (idle_cpu(i)) {
 				target = i;
 				break;
@@ -1680,7 +2316,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	int sync = wake_flags & WF_SYNC;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
-		if (cpumask_test_cpu(cpu, &p->cpus_allowed))
+		if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
 			want_affine = 1;
 		new_cpu = prev_cpu;
 	}
@@ -1875,6 +2511,15 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (unlikely(se == pse))
 		return;
 
+	/*
+	 * This is possible from callers such as pull_task(), in which we
+	 * unconditionally check_prempt_curr() after an enqueue (which may have
+	 * lead to a throttle).  This both saves work and prevents false
+	 * next-buddy nomination below.
+	 */
+	if (unlikely(throttled_hierarchy(cfs_rq_of(pse))))
+		return;
+
 	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK)) {
 		set_next_buddy(pse);
 		next_buddy_marked = 1;
@@ -1883,6 +2528,12 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
 	 * wake up path.
+	 *
+	 * Note: this also catches the edge-case of curr being in a throttled
+	 * group (e.g. via set_curr_task), since update_curr() (in the
+	 * enqueue of curr) will have resulted in resched being set.  This
+	 * prevents us from potentially nominating it as a false LAST_BUDDY
+	 * below.
 	 */
 	if (test_tsk_need_resched(curr))
 		return;
@@ -1899,10 +2550,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (unlikely(p->policy != SCHED_NORMAL))
 		return;
 
-
-	if (!sched_feat(WAKEUP_PREEMPT))
-		return;
-
 	find_matching_se(&se, &pse);
 	update_curr(cfs_rq_of(se));
 	BUG_ON(!pse);
@@ -2005,7 +2652,8 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
 {
 	struct sched_entity *se = &p->se;
 
-	if (!se->on_rq)
+	/* throttled hierarchies are not runnable */
+	if (!se->on_rq || throttled_hierarchy(cfs_rq_of(se)))
 		return false;
 
 	/* Tell the scheduler that we'd really like pse to run next. */
@@ -2049,7 +2697,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
 	 * 3) are cache-hot on their current CPU.
 	 */
-	if (!cpumask_test_cpu(this_cpu, &p->cpus_allowed)) {
+	if (!cpumask_test_cpu(this_cpu, tsk_cpus_allowed(p))) {
 		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 		return 0;
 	}
@@ -2102,6 +2750,9 @@ move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
 	for_each_leaf_cfs_rq(busiest, cfs_rq) {
 		list_for_each_entry_safe(p, n, &cfs_rq->tasks, se.group_node) {
+			if (throttled_lb_pair(task_group(p),
+					      busiest->cpu, this_cpu))
+				break;
 
 			if (!can_migrate_task(p, busiest, this_cpu,
 						sd, idle, &pinned))
@@ -2217,8 +2868,13 @@ static void update_shares(int cpu)
 	 * Iterates the task_group tree in a bottom up fashion, see
 	 * list_add_leaf_cfs_rq() for details.
 	 */
-	for_each_leaf_cfs_rq(rq, cfs_rq)
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		/* throttled entities do not contribute to load */
+		if (throttled_hierarchy(cfs_rq))
+			continue;
+
 		update_shares_cpu(cfs_rq->tg, cpu);
+	}
 	rcu_read_unlock();
 }
 
@@ -2268,9 +2924,10 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		u64 rem_load, moved_load;
 
 		/*
-		 * empty group
+		 * empty group or part of a throttled hierarchy
 		 */
-		if (!busiest_cfs_rq->task_weight)
+		if (!busiest_cfs_rq->task_weight ||
+		    throttled_lb_pair(busiest_cfs_rq->tg, cpu_of(busiest), this_cpu))
 			continue;
 
 		rem_load = (u64)rem_load_move * busiest_weight;
@@ -3430,7 +4087,7 @@ redo:
 			 * moved to this_cpu
 			 */
 			if (!cpumask_test_cpu(this_cpu,
-					      &busiest->curr->cpus_allowed)) {
+					tsk_cpus_allowed(busiest->curr))) {
 				raw_spin_unlock_irqrestore(&busiest->lock,
 							    flags);
 				all_pinned = 1;
@@ -3612,22 +4269,6 @@ out_unlock:
 }
 
 #ifdef CONFIG_NO_HZ
-
-static DEFINE_PER_CPU(struct call_single_data, remote_sched_softirq_cb);
-
-static void trigger_sched_softirq(void *data)
-{
-	raise_softirq_irqoff(SCHED_SOFTIRQ);
-}
-
-static inline void init_sched_softirq_csd(struct call_single_data *csd)
-{
-	csd->func = trigger_sched_softirq;
-	csd->info = NULL;
-	csd->flags = 0;
-	csd->priv = 0;
-}
-
 /*
  * idle load balancing details
  * - One of the idle CPUs nominates itself as idle load_balancer, while
@@ -3667,7 +4308,7 @@ static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
 	struct sched_domain *sd;
 
 	for_each_domain(cpu, sd)
-		if (sd && (sd->flags & flag))
+		if (sd->flags & flag)
 			break;
 
 	return sd;
@@ -3793,11 +4434,16 @@ static void nohz_balancer_kick(int cpu)
 	}
 
 	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
-		struct call_single_data *cp;
-
 		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
-		cp = &per_cpu(remote_sched_softirq_cb, cpu);
-		__smp_call_function_single(ilb_cpu, cp, 0);
+
+		smp_mb();
+		/*
+		 * Use smp_send_reschedule() instead of resched_cpu().
+		 * This way we generate a sched IPI on the target cpu which
+		 * is idle. And the softirq performing nohz idle load balance
+		 * will be run before returning from the IPI.
+		 */
+		smp_send_reschedule(ilb_cpu);
 	}
 	return;
 }
@@ -4030,7 +4676,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	if (time_before(now, nohz.next_balance))
 		return 0;
 
-	if (rq->idle_at_tick)
+	if (idle_cpu(cpu))
 		return 0;
 
 	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);
@@ -4066,7 +4712,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 {
 	int this_cpu = smp_processor_id();
 	struct rq *this_rq = cpu_rq(this_cpu);
-	enum cpu_idle_type idle = this_rq->idle_at_tick ?
+	enum cpu_idle_type idle = this_rq->idle_balance ?
 						CPU_IDLE : CPU_NOT_IDLE;
 
 	rebalance_domains(this_cpu, idle);
@@ -4251,8 +4897,13 @@ static void set_curr_task_fair(struct rq *rq)
 {
 	struct sched_entity *se = &rq->curr->se;
 
-	for_each_sched_entity(se)
-		set_next_entity(cfs_rq_of(se), se);
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+		set_next_entity(cfs_rq, se);
+		/* ensure bandwidth has been allocated on our new cfs_rq */
+		account_cfs_rq_runtime(cfs_rq, 0);
+	}
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 2e74677..efa0a7b 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -12,11 +12,6 @@ SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
 SCHED_FEAT(START_DEBIT, 1)
 
 /*
- * Should wakeups try to preempt running tasks.
- */
-SCHED_FEAT(WAKEUP_PREEMPT, 1)
-
-/*
  * Based on load and program behaviour, see if it makes sense to place
  * a newly woken task on the same cpu as the task that woke it --
  * improve cache locality. Typically used with SYNC wakeups as
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index af11778..056cbd2 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -124,21 +124,33 @@ static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	update_rt_migration(rt_rq);
 }
 
+static inline int has_pushable_tasks(struct rq *rq)
+{
+	return !plist_head_empty(&rq->rt.pushable_tasks);
+}
+
 static void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
 {
 	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
 	plist_node_init(&p->pushable_tasks, p->prio);
 	plist_add(&p->pushable_tasks, &rq->rt.pushable_tasks);
+
+	/* Update the highest prio pushable task */
+	if (p->prio < rq->rt.highest_prio.next)
+		rq->rt.highest_prio.next = p->prio;
 }
 
 static void dequeue_pushable_task(struct rq *rq, struct task_struct *p)
 {
 	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
-}
 
-static inline int has_pushable_tasks(struct rq *rq)
-{
-	return !plist_head_empty(&rq->rt.pushable_tasks);
+	/* Update the new highest prio pushable task */
+	if (has_pushable_tasks(rq)) {
+		p = plist_first_entry(&rq->rt.pushable_tasks,
+				      struct task_struct, pushable_tasks);
+		rq->rt.highest_prio.next = p->prio;
+	} else
+		rq->rt.highest_prio.next = MAX_RT_PRIO;
 }
 
 #else
@@ -643,6 +655,7 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 
 	if (rt_rq->rt_time > runtime) {
 		rt_rq->rt_throttled = 1;
+		printk_once(KERN_WARNING "sched: RT throttling activated\n");
 		if (rt_rq_throttled(rt_rq)) {
 			sched_rt_rq_dequeue(rt_rq);
 			return 1;
@@ -698,47 +711,13 @@ static void update_curr_rt(struct rq *rq)
 
 #if defined CONFIG_SMP
 
-static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu);
-
-static inline int next_prio(struct rq *rq)
-{
-	struct task_struct *next = pick_next_highest_task_rt(rq, rq->cpu);
-
-	if (next && rt_prio(next->prio))
-		return next->prio;
-	else
-		return MAX_RT_PRIO;
-}
-
 static void
 inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
-	if (prio < prev_prio) {
-
-		/*
-		 * If the new task is higher in priority than anything on the
-		 * run-queue, we know that the previous high becomes our
-		 * next-highest.
-		 */
-		rt_rq->highest_prio.next = prev_prio;
-
-		if (rq->online)
-			cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
-
-	} else if (prio == rt_rq->highest_prio.curr)
-		/*
-		 * If the next task is equal in priority to the highest on
-		 * the run-queue, then we implicitly know that the next highest
-		 * task cannot be any lower than current
-		 */
-		rt_rq->highest_prio.next = prio;
-	else if (prio < rt_rq->highest_prio.next)
-		/*
-		 * Otherwise, we need to recompute next-highest
-		 */
-		rt_rq->highest_prio.next = next_prio(rq);
+	if (rq->online && prio < prev_prio)
+		cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
 }
 
 static void
@@ -746,9 +725,6 @@ dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
-	if (rt_rq->rt_nr_running && (prio <= rt_rq->highest_prio.next))
-		rt_rq->highest_prio.next = next_prio(rq);
-
 	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
 }
@@ -961,6 +937,8 @@ enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
+
+	inc_nr_running(rq);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
@@ -971,6 +949,8 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 	dequeue_rt_entity(rt_se);
 
 	dequeue_pushable_task(rq, p);
+
+	dec_nr_running(rq);
 }
 
 /*
@@ -1017,10 +997,12 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 	struct rq *rq;
 	int cpu;
 
-	if (sd_flag != SD_BALANCE_WAKE)
-		return smp_processor_id();
-
 	cpu = task_cpu(p);
+
+	/* For anything but wake ups, just return the task_cpu */
+	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
+		goto out;
+
 	rq = cpu_rq(cpu);
 
 	rcu_read_lock();
@@ -1059,6 +1041,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 	}
 	rcu_read_unlock();
 
+out:
 	return cpu;
 }
 
@@ -1178,7 +1161,6 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 {
 	update_curr_rt(rq);
-	p->se.exec_start = 0;
 
 	/*
 	 * The previous task needs to be made eligible for pushing
@@ -1198,7 +1180,7 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
+	    (cpu < 0 || cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) &&
 	    (p->rt.nr_cpus_allowed > 1))
 		return 1;
 	return 0;
@@ -1343,7 +1325,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 			 */
 			if (unlikely(task_rq(task) != rq ||
 				     !cpumask_test_cpu(lowest_rq->cpu,
-						       &task->cpus_allowed) ||
+						       tsk_cpus_allowed(task)) ||
 				     task_running(rq, task) ||
 				     !task->on_rq)) {
 
@@ -1394,6 +1376,7 @@ static int push_rt_task(struct rq *rq)
 {
 	struct task_struct *next_task;
 	struct rq *lowest_rq;
+	int ret = 0;
 
 	if (!rq->rt.overloaded)
 		return 0;
@@ -1426,7 +1409,7 @@ retry:
 	if (!lowest_rq) {
 		struct task_struct *task;
 		/*
-		 * find lock_lowest_rq releases rq->lock
+		 * find_lock_lowest_rq releases rq->lock
 		 * so it is possible that next_task has migrated.
 		 *
 		 * We need to make sure that the task is still on the same
@@ -1436,12 +1419,11 @@ retry:
 		task = pick_next_pushable_task(rq);
 		if (task_cpu(next_task) == rq->cpu && task == next_task) {
 			/*
-			 * If we get here, the task hasn't moved at all, but
-			 * it has failed to push.  We will not try again,
-			 * since the other cpus will pull from us when they
-			 * are ready.
+			 * The task hasn't migrated, and is still the next
+			 * eligible task, but we failed to find a run-queue
+			 * to push it to.  Do not retry in this case, since
+			 * other cpus will pull from us when ready.
 			 */
-			dequeue_pushable_task(rq, next_task);
 			goto out;
 		}
 
@@ -1460,6 +1442,7 @@ retry:
 	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, lowest_rq->cpu);
 	activate_task(lowest_rq, next_task, 0);
+	ret = 1;
 
 	resched_task(lowest_rq->curr);
 
@@ -1468,7 +1451,7 @@ retry:
 out:
 	put_task_struct(next_task);
 
-	return 1;
+	return ret;
 }
 
 static void push_rt_tasks(struct rq *rq)
@@ -1626,9 +1609,6 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 
 		update_rt_migration(&rq->rt);
 	}
-
-	cpumask_copy(&p->cpus_allowed, new_mask);
-	p->rt.nr_cpus_allowed = weight;
 }
 
 /* Assumes rq->lock is held */
@@ -1863,4 +1843,3 @@ static void print_rt_stats(struct seq_file *m, int cpu)
 	rcu_read_unlock();
 }
 #endif /* CONFIG_SCHED_DEBUG */
-
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 6f43763..8b44e7f 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -34,11 +34,13 @@ static struct task_struct *pick_next_task_stop(struct rq *rq)
 static void
 enqueue_task_stop(struct rq *rq, struct task_struct *p, int flags)
 {
+	inc_nr_running(rq);
 }
 
 static void
 dequeue_task_stop(struct rq *rq, struct task_struct *p, int flags)
 {
+	dec_nr_running(rq);
 }
 
 static void yield_task_stop(struct rq *rq)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 11d65b5..2d2ecdc 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -379,6 +379,16 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 #endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	{
+		.procname	= "sched_cfs_bandwidth_slice_us",
+		.data		= &sysctl_sched_cfs_bandwidth_slice,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+	},
+#endif
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.procname	= "prove_locking",
diff --git a/lib/Kconfig b/lib/Kconfig
index 6c695ff..32f3e5a 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -276,7 +276,4 @@ config CORDIC
 	  so its calculations are in fixed point. Modules can select this
 	  when they require this function. Module will be called cordic.
 
-config LLIST
-	bool
-
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index 3f5bc6d..a4da283 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -22,7 +22,7 @@ lib-y	+= kobject.o kref.o klist.o
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o \
-	 bsearch.o find_last_bit.o find_next_bit.o
+	 bsearch.o find_last_bit.o find_next_bit.o llist.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 
@@ -115,8 +115,6 @@ obj-$(CONFIG_CPU_RMAP) += cpu_rmap.o
 
 obj-$(CONFIG_CORDIC) += cordic.o
 
-obj-$(CONFIG_LLIST) += llist.o
-
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/llist.c b/lib/llist.c
index da44572..700cff7 100644
--- a/lib/llist.c
+++ b/lib/llist.c
@@ -3,8 +3,8 @@
  *
  * The basic atomic operation of this list is cmpxchg on long.  On
  * architectures that don't have NMI-safe cmpxchg implementation, the
- * list can NOT be used in NMI handler.  So code uses the list in NMI
- * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
+ * list can NOT be used in NMI handlers.  So code that uses the list in
+ * an NMI handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
  *
  * Copyright 2010,2011 Intel Corp.
  *   Author: Huang Ying <ying.huang@intel.com>
@@ -30,48 +30,28 @@
 #include <asm/system.h>
 
 /**
- * llist_add - add a new entry
- * @new:	new entry to be added
- * @head:	the head for your lock-less list
- */
-void llist_add(struct llist_node *new, struct llist_head *head)
-{
-	struct llist_node *entry, *old_entry;
-
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
-
-	entry = head->first;
-	do {
-		old_entry = entry;
-		new->next = entry;
-		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);
-}
-EXPORT_SYMBOL_GPL(llist_add);
-
-/**
  * llist_add_batch - add several linked entries in batch
  * @new_first:	first entry in batch to be added
  * @new_last:	last entry in batch to be added
  * @head:	the head for your lock-less list
+ *
+ * Return whether list is empty before adding.
  */
-void llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
+bool llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
 		     struct llist_head *head)
 {
 	struct llist_node *entry, *old_entry;
 
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
-
 	entry = head->first;
-	do {
+	for (;;) {
 		old_entry = entry;
 		new_last->next = entry;
-		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, new_first)) != old_entry);
+		entry = cmpxchg(&head->first, old_entry, new_first);
+		if (entry == old_entry)
+			break;
+	}
+
+	return old_entry == NULL;
 }
 EXPORT_SYMBOL_GPL(llist_add_batch);
 
@@ -93,37 +73,17 @@ struct llist_node *llist_del_first(struct llist_head *head)
 {
 	struct llist_node *entry, *old_entry, *next;
 
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
-
 	entry = head->first;
-	do {
+	for (;;) {
 		if (entry == NULL)
 			return NULL;
 		old_entry = entry;
 		next = entry->next;
-		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, next)) != old_entry);
+		entry = cmpxchg(&head->first, old_entry, next);
+		if (entry == old_entry)
+			break;
+	}
 
 	return entry;
 }
 EXPORT_SYMBOL_GPL(llist_del_first);
-
-/**
- * llist_del_all - delete all entries from lock-less list
- * @head:	the head of lock-less list to delete all entries
- *
- * If list is empty, return NULL, otherwise, delete all entries and
- * return the pointer to the first entry.  The order of entries
- * deleted is from the newest to the oldest added one.
- */
-struct llist_node *llist_del_all(struct llist_head *head)
-{
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
-
-	return xchg(&head->first, NULL);
-}
-EXPORT_SYMBOL_GPL(llist_del_all);
diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 4689cb0..503f087 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -22,7 +22,7 @@ notrace unsigned int debug_smp_processor_id(void)
 	 * Kernel threads bound to a single CPU can safely use
 	 * smp_processor_id():
 	 */
-	if (cpumask_equal(&current->cpus_allowed, cpumask_of(this_cpu)))
+	if (cpumask_equal(tsk_cpus_allowed(current), cpumask_of(this_cpu)))
 		goto out;
 
 	/*
