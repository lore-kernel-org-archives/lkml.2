Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab2I1ICl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:02:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab2I1ICh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:02:37 -0400
Date: Fri, 28 Sep 2012 01:02:19 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-nqczclvw4g9p0us0yezui7q5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa: Detect 'big' processes
Git-Commit-ID: 1b9fc936e56d62dfbb12ab4651c0432e91c10e2a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 01:02:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b9fc936e56d62dfbb12ab4651c0432e91c10e2a
Gitweb:     http://git.kernel.org/tip/1b9fc936e56d62dfbb12ab4651c0432e91c10e2a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 16 Jul 2012 13:08:54 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Sep 2012 17:04:48 +0200

sched/numa: Detect 'big' processes

Detect 'big' processes for which the one home-node per process isn't
going to work as desired.

The current policy for such tasks is to ignore them entirely and put
the home-node back to -1 (no preference) so they'll behave as if none
of this NUMA home node awareness is there.

The current heuristic for determining if a task is 'big' is if its
consuming more than 1/2 a node's worth of cputime. We might want to
add a term here looking at the RSS of the process and compare this
against the available memory per node.

Since we now do multiple things from the task_work thing, we need to
extend the state to determine which of the things we're there for -- a
change in numa node, or a periodic poll of 'big'-ness.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: Paul Turner <pjt@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-nqczclvw4g9p0us0yezui7q5@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mm_types.h |    1 +
 include/linux/sched.h    |    4 +-
 kernel/sched/core.c      |   12 ++++--
 kernel/sched/fair.c      |   96 ++++++++++++++++++++++++++++++++++++++-------
 4 files changed, 93 insertions(+), 20 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index f407966..930c006 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -405,6 +405,7 @@ struct mm_struct {
 	struct cpumask cpumask_allocation;
 #endif
 #ifdef CONFIG_SCHED_NUMA
+	unsigned int  numa_big;
 	unsigned long numa_next_scan;
 #endif
 	struct uprobes_state uprobes_state;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 63dde76..b8f7461 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1521,8 +1521,10 @@ struct task_struct {
 #endif
 #ifdef CONFIG_SCHED_NUMA
 	int node;			/* task home node   */
-	int node_last;			/* home node filter */
+	int node_curr, node_last;	/* home node filter */
 	u64 node_stamp;			/* migration stamp  */
+	u64 numa_runtime_stamp;
+	u64 numa_walltime_stamp;
 	unsigned long numa_contrib;
 #endif /* CONFIG_SCHED_NUMA */
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fda809d..6668b0d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1535,13 +1535,18 @@ static void __sched_fork(struct task_struct *p)
 #endif
 
 #ifdef CONFIG_SCHED_NUMA
-	if (p->mm && atomic_read(&p->mm->mm_users) == 1)
+	if (p->mm && atomic_read(&p->mm->mm_users) == 1) {
+		p->mm->numa_big = 0;
 		p->mm->numa_next_scan = jiffies;
+	}
 
 	p->node = -1;
+	p->node_curr = -1;
 	p->node_last = -1;
 	p->node_stamp = 0ULL;
-#endif /* CONFIG_NUMA */
+	p->numa_runtime_stamp = 0;
+	p->numa_walltime_stamp = local_clock();
+#endif /* CONFIG_SCHED_NUMA */
 }
 
 /*
@@ -6024,8 +6029,7 @@ void sched_setnode(struct task_struct *p, int node)
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	p->node = node;
-	p->node_last = node;
+	p->node = p->node_curr = p->node_last = node;
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a1560fc..7ea50ac 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -809,14 +809,73 @@ static void account_offnode_dequeue(struct rq *rq, struct task_struct *p)
 unsigned int sysctl_sched_numa_task_period = 2500;
 
 /*
+ * Determine if a process is 'big'.
+ *
+ * Currently only looks at CPU-time used, maybe we should also add an RSS
+ * heuristic.
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
+	sd = rcu_dereference(__raw_get_cpu_var(sd_node));
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
+static inline bool need_numa_migration(struct task_struct *p)
+{
+	/*
+	 * We need to change our home-node, its been different for 2 samples.
+	 * See the whole P(n)^2 story in task_tick_numa().
+	 */
+	return p->node_curr == p->node_last && p->node != p->node_curr;
+}
+
+static void sched_setnode_process(struct task_struct *p, int node)
+{
+	struct task_struct *t = p;
+
+	rcu_read_lock();
+	do {
+		sched_setnode(t, node);
+	} while ((t = next_thread(t)) != p);
+	rcu_read_unlock();
+}
+
+/*
  * The expensive part of numa migration is done from task_work context.
  * Triggered from task_tick_numa().
  */
 void task_numa_work(struct callback_head *work)
 {
 	unsigned long migrate, next_scan, now = jiffies;
-	struct task_struct *t, *p = current;
-	int node = p->node_last;
+	struct task_struct *p = current;
+	int big;
 
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, rcu));
 
@@ -842,14 +901,19 @@ void task_numa_work(struct callback_head *work)
 	if (cmpxchg(&p->mm->numa_next_scan, migrate, next_scan) != migrate)
 		return;
 
-	rcu_read_lock();
-	t = p;
-	do {
-		sched_setnode(t, node);
-	} while ((t = next_thread(t)) != p);
-	rcu_read_unlock();
-
-	lazy_migrate_process(p->mm);
+	/*
+	 * If this task is too big, we bail on NUMA placement for the process.
+	 */
+	big = p->mm->numa_big = task_numa_big(p);
+	if (big || need_numa_migration(p)) {
+		int node = p->node_curr;
+
+		if (big)
+			node = -1;
+		sched_setnode_process(p, node);
+		if (node != -1)
+			lazy_migrate_process(p->mm);
+	}
 }
 
 /*
@@ -861,12 +925,12 @@ void task_numa_work(struct callback_head *work)
 void task_tick_numa(struct rq *rq, struct task_struct *curr)
 {
 	u64 period, now;
-	int node;
 
 	/*
 	 * We don't care about NUMA placement if we don't have memory.
+	 * We also bail on placement if we're too big.
 	 */
-	if (!curr->mm)
+	if (!curr->mm || curr->mm->numa_big)
 		return;
 
 	/*
@@ -889,9 +953,12 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 
 	if (now - curr->node_stamp > period) {
 		curr->node_stamp = now;
-		node = numa_node_id();
 
-		if (curr->node_last == node && curr->node != node) {
+		curr->node_last = curr->node_curr;
+		curr->node_curr = numa_node_id();
+
+		if (need_numa_migration(curr) ||
+		    !time_before(jiffies, curr->mm->numa_next_scan)) {
 			/*
 			 * We can re-use curr->rcu because we checked curr->mm
 			 * != NULL so release_task()->call_rcu() was not called
@@ -901,7 +968,6 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 			init_task_work(&curr->rcu, task_numa_work);
 			task_work_add(curr, &curr->rcu, true);
 		}
-		curr->node_last = node;
 	}
 }
 #else
