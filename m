Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2J1RLF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 13:11:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab2J1RLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 13:11:02 -0400
Date: Sun, 28 Oct 2012 10:10:42 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-8ejt0ioj62k5ruf5zd2ix9zu@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com, tglx@linutronix.de,
        rientjes@google.com
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        aarcange@redhat.com, tglx@linutronix.de, rientjes@google.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched, numa, mm:
  Add fault driven placement and migration policy
Git-Commit-ID: f7a688de2312e39cb456df3844f3996cc8c8ba5d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 28 Oct 2012 10:10:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7a688de2312e39cb456df3844f3996cc8c8ba5d
Gitweb:     http://git.kernel.org/tip/f7a688de2312e39cb456df3844f3996cc8c8ba5d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 9 Oct 2012 13:46:22 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 28 Oct 2012 17:31:15 +0100

sched, numa, mm: Add fault driven placement and migration policy

As per the problem/design document Documentation/scheduler/numa-problem.txt
implement 3ac & 4.

( A pure 3a was found too unstable, I did briefly try 3bc
  but found no significant improvement. )

Implement a per-task memory placement scheme relying on a regular
PROT_NONE 'migration' fault to scan the memory space of the procress
and uses a two stage migration scheme to reduce the invluence of
unlikely usage relations.

It relies on the assumption that the compute part is tied to a
paticular task and builds a task<->page relation set to model the
compute<->data relation.

In the previous patch we made memory migrate towards where the task
is running, here we select the node on which most memory is located
as the preferred node to run on.

This creates a feed-back control loop between trying to schedule a
task on a node and migrating memory towards the node the task is
scheduled on.

Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Suggested-by: Rik van Riel <riel@redhat.com>
Fixes-by: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-8ejt0ioj62k5ruf5zd2ix9zu@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mm_types.h |    4 +
 include/linux/sched.h    |   35 +++++++--
 kernel/sched/core.c      |   16 ++++
 kernel/sched/fair.c      |  187 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/features.h  |    1 +
 kernel/sched/sched.h     |   31 ++++++--
 kernel/sysctl.c          |   31 +++++++-
 mm/huge_memory.c         |    7 +-
 mm/memory.c              |    4 +-
 9 files changed, 294 insertions(+), 22 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5f0af06..bef4c5e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -403,6 +403,10 @@ struct mm_struct {
 #ifdef CONFIG_CPUMASK_OFFSTACK
 	struct cpumask cpumask_allocation;
 #endif
+#ifdef CONFIG_SCHED_NUMA
+	unsigned long numa_next_scan;
+	int numa_scan_seq;
+#endif
 	struct uprobes_state uprobes_state;
 };
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 73ac299..2ff86ae 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1481,9 +1481,16 @@ struct task_struct {
 	short pref_node_fork;
 #endif
 #ifdef CONFIG_SCHED_NUMA
-	int node;
+	int node;			/* task home node   */
+	int numa_scan_seq;
+	int numa_migrate_seq;
+	unsigned int numa_scan_period;
+	u64 node_stamp;			/* migration stamp  */
 	unsigned long numa_contrib;
-#endif
+	unsigned long *numa_faults;
+	struct callback_head numa_work;
+#endif /* CONFIG_SCHED_NUMA */
+
 	struct rcu_head rcu;
 
 	/*
@@ -1558,15 +1565,24 @@ struct task_struct {
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
+#ifdef CONFIG_SCHED_NUMA
 static inline int tsk_home_node(struct task_struct *p)
 {
-#ifdef CONFIG_SCHED_NUMA
 	return p->node;
+}
+
+extern void task_numa_fault(int node, int pages);
 #else
+static inline int tsk_home_node(struct task_struct *p)
+{
 	return -1;
-#endif
 }
 
+static inline void task_numa_fault(int node, int pages)
+{
+}
+#endif /* CONFIG_SCHED_NUMA */
+
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
@@ -2004,6 +2020,10 @@ enum sched_tunable_scaling {
 };
 extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
 
+extern unsigned int sysctl_sched_numa_scan_period_min;
+extern unsigned int sysctl_sched_numa_scan_period_max;
+extern unsigned int sysctl_sched_numa_settle_count;
+
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
@@ -2014,18 +2034,17 @@ extern unsigned int sysctl_sched_shares_window;
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
 		loff_t *ppos);
-#endif
-#ifdef CONFIG_SCHED_DEBUG
+
 static inline unsigned int get_sysctl_timer_migration(void)
 {
 	return sysctl_timer_migration;
 }
-#else
+#else /* CONFIG_SCHED_DEBUG */
 static inline unsigned int get_sysctl_timer_migration(void)
 {
 	return 1;
 }
-#endif
+#endif /* CONFIG_SCHED_DEBUG */
 extern unsigned int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 590b063..91cc1a5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1533,6 +1533,21 @@ static void __sched_fork(struct task_struct *p)
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
 #endif
+
+#ifdef CONFIG_SCHED_NUMA
+	if (p->mm && atomic_read(&p->mm->mm_users) == 1) {
+		p->mm->numa_next_scan = jiffies;
+		p->mm->numa_scan_seq = 0;
+	}
+
+	p->node = -1;
+	p->node_stamp = 0ULL;
+	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
+	p->numa_migrate_seq = p->mm ? p->mm->numa_scan_seq - 1 : 0;
+	p->numa_faults = NULL;
+	p->numa_scan_period = sysctl_sched_numa_scan_period_min;
+	p->numa_work.next = &p->numa_work;
+#endif /* CONFIG_SCHED_NUMA */
 }
 
 /*
@@ -1774,6 +1789,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
+		task_numa_free(prev);
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d2137d8..bfe07cd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -27,6 +27,8 @@
 #include <linux/profile.h>
 #include <linux/interrupt.h>
 #include <linux/random.h>
+#include <linux/mempolicy.h>
+#include <linux/task_work.h>
 
 #include <trace/events/sched.h>
 
@@ -775,6 +777,21 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 /**************************************************
  * Scheduling class numa methods.
+ *
+ * The purpose of the NUMA bits are to maintain compute (task) and data
+ * (memory) locality. We try and achieve this by making tasks stick to
+ * a particular node (their home node) but if fairness mandates they run
+ * elsewhere for long enough, we let the memory follow them.
+ *
+ * Tasks start out with their home-node unset (-1) this effectively means
+ * they act !NUMA until we've established the task is busy enough to bother
+ * with placement.
+ *
+ * We keep a home-node per task and use periodic fault scans to try and
+ * estalish a task<->page relation. This assumes the task<->page relation is a
+ * compute<->data relation, this is false for things like virt. and n:m
+ * threading solutions but its the best we can do given the information we
+ * have.
  */
 
 #ifdef CONFIG_SMP
@@ -805,6 +822,169 @@ static void account_numa_dequeue(struct rq *rq, struct task_struct *p)
 	} else
 		rq->onnode_running--;
 }
+
+/*
+ * numa task sample period in ms: 5s
+ */
+unsigned int sysctl_sched_numa_scan_period_min = 5000;
+unsigned int sysctl_sched_numa_scan_period_max = 5000*16;
+
+/*
+ * Wait for the 2-sample stuff to settle before migrating again
+ */
+unsigned int sysctl_sched_numa_settle_count = 2;
+
+static void task_numa_placement(struct task_struct *p)
+{
+	unsigned long faults, max_faults = 0;
+	int node, max_node = -1;
+	int seq = ACCESS_ONCE(p->mm->numa_scan_seq);
+
+	if (p->numa_scan_seq == seq)
+		return;
+
+	p->numa_scan_seq = seq;
+
+	for (node = 0; node < nr_node_ids; node++) {
+		faults = p->numa_faults[node];
+
+		if (faults > max_faults) {
+			max_faults = faults;
+			max_node = node;
+		}
+
+		p->numa_faults[node] /= 2;
+	}
+
+	if (max_node == -1)
+		return;
+
+	if (p->node != max_node) {
+		p->numa_scan_period = sysctl_sched_numa_scan_period_min;
+		if (sched_feat(NUMA_SETTLE) &&
+		    (seq - p->numa_migrate_seq) <= (int)sysctl_sched_numa_settle_count)
+			return;
+		p->numa_migrate_seq = seq;
+		sched_setnode(p, max_node);
+	} else {
+		p->numa_scan_period = min(sysctl_sched_numa_scan_period_max,
+				p->numa_scan_period * 2);
+	}
+}
+
+/*
+ * Got a PROT_NONE fault for a page on @node.
+ */
+void task_numa_fault(int node, int pages)
+{
+	struct task_struct *p = current;
+
+	if (unlikely(!p->numa_faults)) {
+		int size = sizeof(unsigned long) * nr_node_ids;
+
+		p->numa_faults = kzalloc(size, GFP_KERNEL);
+		if (!p->numa_faults)
+			return;
+	}
+
+	task_numa_placement(p);
+
+	p->numa_faults[node] += pages;
+}
+
+/*
+ * The expensive part of numa migration is done from task_work context.
+ * Triggered from task_tick_numa().
+ */
+void task_numa_work(struct callback_head *work)
+{
+	unsigned long migrate, next_scan, now = jiffies;
+	struct task_struct *p = current;
+	struct mm_struct *mm = p->mm;
+
+	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
+
+	work->next = work; /* protect against double add */
+	/*
+	 * Who cares about NUMA placement when they're dying.
+	 *
+	 * NOTE: make sure not to dereference p->mm before this check,
+	 * exit_task_work() happens _after_ exit_mm() so we could be called
+	 * without p->mm even though we still had it when we enqueued this
+	 * work.
+	 */
+	if (p->flags & PF_EXITING)
+		return;
+
+	/*
+	 * Enforce maximal scan/migration frequency..
+	 */
+	migrate = mm->numa_next_scan;
+	if (time_before(now, migrate))
+		return;
+
+	next_scan = now + 2*msecs_to_jiffies(sysctl_sched_numa_scan_period_min);
+	if (cmpxchg(&mm->numa_next_scan, migrate, next_scan) != migrate)
+		return;
+
+	ACCESS_ONCE(mm->numa_scan_seq)++;
+	{
+		struct vm_area_struct *vma;
+
+		down_write(&mm->mmap_sem);
+		for (vma = mm->mmap; vma; vma = vma->vm_next) {
+			if (!vma_migratable(vma))
+				continue;
+			change_protection(vma, vma->vm_start, vma->vm_end, vma_prot_none(vma), 0);
+		}
+		up_write(&mm->mmap_sem);
+	}
+}
+
+/*
+ * Drive the periodic memory faults..
+ */
+void task_tick_numa(struct rq *rq, struct task_struct *curr)
+{
+	struct callback_head *work = &curr->numa_work;
+	u64 period, now;
+
+	/*
+	 * We don't care about NUMA placement if we don't have memory.
+	 */
+	if (!curr->mm || (curr->flags & PF_EXITING) || work->next != work)
+		return;
+
+	/*
+	 * Using runtime rather than walltime has the dual advantage that
+	 * we (mostly) drive the selection from busy threads and that the
+	 * task needs to have done some actual work before we bother with
+	 * NUMA placement.
+	 */
+	now = curr->se.sum_exec_runtime;
+	period = (u64)curr->numa_scan_period * NSEC_PER_MSEC;
+
+	if (now - curr->node_stamp > period) {
+		curr->node_stamp = now;
+
+		/*
+		 * We are comparing runtime to wall clock time here, which
+		 * puts a maximum scan frequency limit on the task work.
+		 *
+		 * This, together with the limits in task_numa_work() filters
+		 * us from over-sampling if there are many threads: if all
+		 * threads happen to come in at the same time we don't create a
+		 * spike in overhead.
+		 *
+		 * We also avoid multiple threads scanning at once in parallel to
+		 * each other.
+		 */
+		if (!time_before(jiffies, curr->mm->numa_next_scan)) {
+			init_task_work(work, task_numa_work); /* TODO: move this into sched_fork() */
+			task_work_add(curr, work, true);
+		}
+	}
+}
 #else
 #ifdef CONFIG_SMP
 static struct list_head *account_numa_enqueue(struct rq *rq, struct task_struct *p)
@@ -816,6 +996,10 @@ static struct list_head *account_numa_enqueue(struct rq *rq, struct task_struct
 static void account_numa_dequeue(struct rq *rq, struct task_struct *p)
 {
 }
+
+static void task_tick_numa(struct rq *rq, struct task_struct *curr)
+{
+}
 #endif /* CONFIG_SCHED_NUMA */
 
 /**************************************************
@@ -5265,6 +5449,9 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 		cfs_rq = cfs_rq_of(se);
 		entity_tick(cfs_rq, se, queued);
 	}
+
+	if (sched_feat_numa(NUMA))
+		task_tick_numa(rq, curr);
 }
 
 /*
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 64ead49..f8a7aeb 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -69,5 +69,6 @@ SCHED_FEAT(NUMA_TTWU_BIAS, false)
 SCHED_FEAT(NUMA_TTWU_TO,   false)
 SCHED_FEAT(NUMA_PULL,      true)
 SCHED_FEAT(NUMA_PULL_BIAS, true)
+SCHED_FEAT(NUMA_SETTLE,    true)
 #endif
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 57dba39..e68cef1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3,6 +3,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
+#include <linux/slab.h>
 
 #include "cpupri.h"
 
@@ -476,15 +477,6 @@ struct rq {
 #endif
 };
 
-static inline struct list_head *offnode_tasks(struct rq *rq)
-{
-#ifdef CONFIG_SCHED_NUMA
-	return &rq->offnode_tasks;
-#else
-	return NULL;
-#endif
-}
-
 static inline int cpu_of(struct rq *rq)
 {
 #ifdef CONFIG_SMP
@@ -502,6 +494,27 @@ DECLARE_PER_CPU(struct rq, runqueues);
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
+#ifdef CONFIG_SCHED_NUMA
+static inline struct list_head *offnode_tasks(struct rq *rq)
+{
+	return &rq->offnode_tasks;
+}
+
+static inline void task_numa_free(struct task_struct *p)
+{
+	kfree(p->numa_faults);
+}
+#else /* CONFIG_SCHED_NUMA */
+static inline struct list_head *offnode_tasks(struct rq *rq)
+{
+	return NULL;
+}
+
+static inline void task_numa_free(struct task_struct *p)
+{
+}
+#endif /* CONFIG_SCHED_NUMA */
+
 #ifdef CONFIG_SMP
 
 #define rcu_dereference_check_sched_domain(p) \
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 26f65ea..5403b50 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -256,9 +256,11 @@ static int min_sched_granularity_ns = 100000;		/* 100 usecs */
 static int max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 static int min_wakeup_granularity_ns;			/* 0 usecs */
 static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
+#ifdef CONFIG_SMP
 static int min_sched_tunable_scaling = SCHED_TUNABLESCALING_NONE;
 static int max_sched_tunable_scaling = SCHED_TUNABLESCALING_END-1;
-#endif
+#endif /* CONFIG_SMP */
+#endif /* CONFIG_SCHED_DEBUG */
 
 #ifdef CONFIG_COMPACTION
 static int min_extfrag_threshold;
@@ -301,6 +303,7 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &min_wakeup_granularity_ns,
 		.extra2		= &max_wakeup_granularity_ns,
 	},
+#ifdef CONFIG_SMP
 	{
 		.procname	= "sched_tunable_scaling",
 		.data		= &sysctl_sched_tunable_scaling,
@@ -347,7 +350,31 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
-#endif
+#endif /* CONFIG_SMP */
+#ifdef CONFIG_SCHED_NUMA
+	{
+		.procname	= "sched_numa_scan_period_min_ms",
+		.data		= &sysctl_sched_numa_scan_period_min,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "sched_numa_scan_period_max_ms",
+		.data		= &sysctl_sched_numa_scan_period_max,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "sched_numa_settle_count",
+		.data		= &sysctl_sched_numa_settle_count,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif /* CONFIG_SCHED_NUMA */
+#endif /* CONFIG_SCHED_DEBUG */
 	{
 		.procname	= "sched_rt_period_us",
 		.data		= &sysctl_sched_rt_period,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3ff121d..7361fd9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -774,9 +774,10 @@ fixup:
 
 unlock:
 	spin_unlock(&mm->page_table_lock);
-	if (page)
+	if (page) {
+		task_numa_fault(page_to_nid(page), HPAGE_PMD_NR);
 		put_page(page);
-
+	}
 	return;
 
 migrate:
@@ -845,6 +846,8 @@ migrate:
 
 	put_page(page);			/* Drop the rmap reference */
 
+	task_numa_fault(node, HPAGE_PMD_NR);
+
 	if (lru)
 		put_page(page);		/* drop the LRU isolation reference */
 
diff --git a/mm/memory.c b/mm/memory.c
index b2e3b79..3ecfeca 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3512,8 +3512,10 @@ out_pte_upgrade_unlock:
 out_unlock:
 	pte_unmap_unlock(ptep, ptl);
 out:
-	if (page)
+	if (page) {
+		task_numa_fault(page_nid, 1);
 		put_page(page);
+	}
 
 	return 0;
 
