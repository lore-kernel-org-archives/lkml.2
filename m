Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2GaTpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 15:45:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:58942 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2GaTot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 15:44:49 -0400
Message-Id: <20120731192809.369386517@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 31 Jul 2012 21:12:21 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 17/19] sched, numa: Detect big processes
References: <20120731191204.540691987@chello.nl>
Content-Disposition: inline; filename=numa-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect 'big' processes for which the one home-node per process isn't
going to work as desired.

The current policy for such tasks is to ignore them entirely and put
the home-node back to -1 (no preference) so they'll behave as if none
of this NUMA nonsense is there.

The current heuristic for determining if a task is 'big' is if its
consuming more than 1/2 a node's worth of cputime. We might want to
add a term here looking at the RSS of the process and compare this
against the available memory per node.

Cc: Rik van Riel <riel@redhat.com>
Cc: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/mm_types.h |    1 
 include/linux/sched.h    |    2 +
 kernel/sched/core.c      |    6 ++++-
 kernel/sched/fair.c      |   49 +++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 55 insertions(+), 3 deletions(-)
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -389,6 +389,7 @@ struct mm_struct {
 	struct cpumask cpumask_allocation;
 #endif
 #ifdef CONFIG_NUMA
+	unsigned int  numa_big;
 	unsigned long numa_next_scan;
 #endif
 	struct uprobes_state uprobes_state;
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1525,6 +1525,8 @@ struct task_struct {
 	int node_last;			/* home node filter */
 #ifdef CONFIG_SMP
 	u64 node_stamp;			/* migration stamp  */
+	u64 numa_runtime_stamp;
+	u64 numa_walltime_stamp;
 	unsigned long numa_contrib;
 #endif /* CONFIG_SMP  */
 #endif /* CONFIG_NUMA */
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1724,13 +1724,17 @@ static void __sched_fork(struct task_str
 #endif
 
 #ifdef CONFIG_NUMA
-	if (p->mm && atomic_read(&p->mm->mm_users) == 1)
+	if (p->mm && atomic_read(&p->mm->mm_users) == 1) {
+		p->mm->numa_big = 0;
 		p->mm->numa_next_scan = jiffies;
+	}
 
 	p->node = -1;
 	p->node_last = -1;
 #ifdef CONFIG_SMP
 	p->node_stamp = 0ULL;
+	p->numa_runtime_stamp = 0;
+	p->numa_walltime_stamp = local_clock();
 #endif /* CONFIG_SMP */
 #endif /* CONFIG_NUMA */
 }
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -803,11 +803,47 @@ static void account_offnode_dequeue(stru
 }
 
 /*
- * numa task sample period in ms
+ * numa task sample period in ms: 2.5s
  */
 unsigned int sysctl_sched_numa_task_period = 2500;
 
 /*
+ * Determine if a process is 'big'.
+ */
+static bool task_numa_big(struct task_struct *p)
+{
+	struct sched_domain *sd;
+	struct task_struct *t;
+	u64 walltime = local_clock();
+	u64 runtime = 0;
+	int weight = 0;
+
+	rcu_read_lock();
+	t = p;
+	do {
+		if (t->sched_class == &fair_sched_class)
+			runtime += t->se.sum_exec_runtime;
+	} while ((t = next_thread(t)) != p);
+
+	sd = rcu_dereference(__get_cpu_var(sd_node));
+	if (sd)
+		weight = sd->span_weight;
+	rcu_read_unlock();
+
+	runtime -= p->numa_runtime_stamp;
+	walltime -= p->numa_walltime_stamp;
+
+	p->numa_runtime_stamp += runtime;
+	p->numa_walltime_stamp += walltime;
+
+	/*
+	 * We're 'big' when we burn more than half a node's worth
+	 * of cputime.
+	 */
+	return runtime > walltime * max(1, weight / 2);
+}
+
+/*
  * The expensive part of numa migration is done from task_work context.
  */
 void task_numa_work(struct callback_head *work)
@@ -815,6 +851,7 @@ void task_numa_work(struct callback_head
 	unsigned long migrate, next_scan, now = jiffies;
 	struct task_struct *t, *p = current;
 	int node = p->node_last;
+	int big;
 
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, rcu));
 
@@ -835,6 +872,13 @@ void task_numa_work(struct callback_head
 	if (cmpxchg(&p->mm->numa_next_scan, migrate, next_scan) != migrate)
 		return;
 
+	/*
+	 * If this task is too big, we bail on NUMA placement of the process.
+	 */
+	big = p->mm->numa_big = task_numa_big(p);
+	if (big)
+		node = -1;
+
 	rcu_read_lock();
 	t = p;
 	do {
@@ -858,8 +902,9 @@ void task_tick_numa(struct rq *rq, struc
 
 	/*
 	 * We don't care about NUMA placement if we don't have memory.
+	 * We also bail on placement if we're too big.
 	 */
-	if (!curr->mm)
+	if (!curr->mm || curr->mm->numa_big)
 		return;
 
 	/*


