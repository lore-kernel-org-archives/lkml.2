Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab2I1IBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:01:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38095 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2I1IBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:01:43 -0400
Date: Fri, 28 Sep 2012 01:01:23 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-s248lool1ytyeul5g1qow8ih@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa:
  Implement NUMA home-node selection code
Git-Commit-ID: 4ae834f767c59b42cdf2a5077a18388525ba78b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 01:01:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ae834f767c59b42cdf2a5077a18388525ba78b2
Gitweb:     http://git.kernel.org/tip/4ae834f767c59b42cdf2a5077a18388525ba78b2
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 16 Jul 2012 11:22:09 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Sep 2012 17:04:47 +0200

sched/numa: Implement NUMA home-node selection code

Now that we have infrastructure in place to migrate pages back to
their home-node, and migrate memory towards the home-node, we need to
set the home-node.

Instead of creating a seconday control loop, fully rely on the
existing load-balancer to do the right thing. The home-node selection
logic will simply pick the node the task has been found to run on
for two consequtive samples (see task_tick_numa).

This means NUMA placement is directly related to regular placement.
The home-node logic in the load-balancer tries to keep a task on the
home-node wheras the fairness and work-conserving constraints will try
and move it away.

The balance between these two 'forces' is what will result in the NUMA
placement.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: Paul Turner <pjt@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-s248lool1ytyeul5g1qow8ih@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/init_task.h |    3 +-
 include/linux/mm_types.h  |    3 +
 include/linux/sched.h     |   16 +++--
 kernel/sched/core.c       |   16 ++++-
 kernel/sched/fair.c       |  174 +++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/features.h   |    1 +
 kernel/sched/sched.h      |   33 ++++++---
 kernel/sysctl.c           |   13 +++-
 8 files changed, 233 insertions(+), 26 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 18906c1..36aca4e 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -145,7 +145,8 @@ extern struct task_group root_task_group;
 
 #ifdef CONFIG_SCHED_NUMA
 # define INIT_TASK_NUMA(tsk)						\
-	.node = -1,
+	.node = -1,							\
+	.node_last = -1,
 #else
 # define INIT_TASK_NUMA(tsk)
 #endif
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index bf78672..f407966 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -404,6 +404,9 @@ struct mm_struct {
 #ifdef CONFIG_CPUMASK_OFFSTACK
 	struct cpumask cpumask_allocation;
 #endif
+#ifdef CONFIG_SCHED_NUMA
+	unsigned long numa_next_scan;
+#endif
 	struct uprobes_state uprobes_state;
 };
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8755ef1..63dde76 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1520,8 +1520,12 @@ struct task_struct {
 	short pref_node_fork;
 #endif
 #ifdef CONFIG_SCHED_NUMA
-	int node;
-#endif
+	int node;			/* task home node   */
+	int node_last;			/* home node filter */
+	u64 node_stamp;			/* migration stamp  */
+	unsigned long numa_contrib;
+#endif /* CONFIG_SCHED_NUMA */
+
 	struct rcu_head rcu;
 
 	/*
@@ -2037,22 +2041,22 @@ extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
 extern unsigned int sysctl_sched_shares_window;
+extern unsigned int sysctl_sched_numa_task_period;
 
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
index f7e7432..fda809d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1533,6 +1533,15 @@ static void __sched_fork(struct task_struct *p)
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
 #endif
+
+#ifdef CONFIG_SCHED_NUMA
+	if (p->mm && atomic_read(&p->mm->mm_users) == 1)
+		p->mm->numa_next_scan = jiffies;
+
+	p->node = -1;
+	p->node_last = -1;
+	p->node_stamp = 0ULL;
+#endif /* CONFIG_NUMA */
 }
 
 /*
@@ -5996,9 +6005,9 @@ static struct sched_domain_topology_level *sched_domain_topology = default_topol
  * Requeues a task ensuring its on the right load-balance list so
  * that it might get migrated to its new home.
  *
- * Note that we cannot actively migrate ourselves since our callers
- * can be from atomic context. We rely on the regular load-balance
- * mechanisms to move us around -- its all preference anyway.
+ * Since home-node is pure preference there's no hard migrate to force
+ * us anywhere, this also allows us to call this from atomic context if
+ * required.
  */
 void sched_setnode(struct task_struct *p, int node)
 {
@@ -6016,6 +6025,7 @@ void sched_setnode(struct task_struct *p, int node)
 		p->sched_class->put_prev_task(rq, p);
 
 	p->node = node;
+	p->node_last = node;
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 29c4704..a1560fc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -27,6 +27,8 @@
 #include <linux/profile.h>
 #include <linux/interrupt.h>
 #include <linux/random.h>
+#include <linux/mempolicy.h>
+#include <linux/task_work.h>
 
 #include <trace/events/sched.h>
 
@@ -774,6 +776,149 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 /**************************************************
+ * Scheduling class numa methods.
+ *
+ * The purpose of the NUMA bits are to maintain compute (task) and data
+ * (memory) locality. We try and achieve this by making tasks stick to
+ * a particular node (their home node) but if fairness mandates they run
+ * elsewhere for long enough, we let the memory follow them.
+ *
+ * Tasks start out with their home-node unset (-1) this effectively means
+ * they act !NUMA until we've established the task is busy enough to bother
+ * with placement.
+ */
+
+static unsigned long task_h_load(struct task_struct *p);
+
+#ifdef CONFIG_SCHED_NUMA
+static void account_offnode_enqueue(struct rq *rq, struct task_struct *p)
+{
+	p->numa_contrib = task_h_load(p);
+	rq->offnode_weight += p->numa_contrib;
+	rq->offnode_running++;
+}
+static void account_offnode_dequeue(struct rq *rq, struct task_struct *p)
+{
+	rq->offnode_weight -= p->numa_contrib;
+	rq->offnode_running--;
+}
+
+/*
+ * numa task sample period in ms: 2.5s
+ */
+unsigned int sysctl_sched_numa_task_period = 2500;
+
+/*
+ * The expensive part of numa migration is done from task_work context.
+ * Triggered from task_tick_numa().
+ */
+void task_numa_work(struct callback_head *work)
+{
+	unsigned long migrate, next_scan, now = jiffies;
+	struct task_struct *t, *p = current;
+	int node = p->node_last;
+
+	WARN_ON_ONCE(p != container_of(work, struct task_struct, rcu));
+
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
+	 * Enforce maximal migration frequency..
+	 */
+	migrate = p->mm->numa_next_scan;
+	if (time_before(now, migrate))
+		return;
+
+	next_scan = now + 2*msecs_to_jiffies(sysctl_sched_numa_task_period);
+	if (cmpxchg(&p->mm->numa_next_scan, migrate, next_scan) != migrate)
+		return;
+
+	rcu_read_lock();
+	t = p;
+	do {
+		sched_setnode(t, node);
+	} while ((t = next_thread(t)) != p);
+	rcu_read_unlock();
+
+	lazy_migrate_process(p->mm);
+}
+
+/*
+ * Sample task location from hardirq context (tick), this has minimal bias with
+ * obvious exceptions of frequency interference and tick avoidance techniques.
+ * If this were to become a problem we could move this sampling into the
+ * sleep/wakeup path -- but we'd prefer to avoid that for obvious reasons.
+ */
+void task_tick_numa(struct rq *rq, struct task_struct *curr)
+{
+	u64 period, now;
+	int node;
+
+	/*
+	 * We don't care about NUMA placement if we don't have memory.
+	 */
+	if (!curr->mm)
+		return;
+
+	/*
+	 * Sample our node location every @sysctl_sched_numa_task_period
+	 * runtime ms. We use a two stage selection in order to filter
+	 * unlikely locations.
+	 *
+	 * If P(n) is the probability we're on node 'n', then the probability
+	 * we sample the same node twice is P(n)^2. This quadric squishes small
+	 * values and makes it more likely we end up on nodes where we have
+	 * significant presence.
+	 *
+	 * Using runtime rather than walltime has the dual advantage that
+	 * we (mostly) drive the selection from busy threads and that the
+	 * task needs to have done some actual work before we bother with
+	 * NUMA placement.
+	 */
+	now = curr->se.sum_exec_runtime;
+	period = (u64)sysctl_sched_numa_task_period * NSEC_PER_MSEC;
+
+	if (now - curr->node_stamp > period) {
+		curr->node_stamp = now;
+		node = numa_node_id();
+
+		if (curr->node_last == node && curr->node != node) {
+			/*
+			 * We can re-use curr->rcu because we checked curr->mm
+			 * != NULL so release_task()->call_rcu() was not called
+			 * yet and exit_task_work() is called before
+			 * exit_notify().
+			 */
+			init_task_work(&curr->rcu, task_numa_work);
+			task_work_add(curr, &curr->rcu, true);
+		}
+		curr->node_last = node;
+	}
+}
+#else
+static void account_offnode_enqueue(struct rq *rq, struct task_struct *p)
+{
+}
+
+static void account_offnode_dequeue(struct rq *rq, struct task_struct *p)
+{
+}
+
+static void task_tick_numa(struct rq *rq, struct task_struct *curr)
+{
+}
+#endif /* CONFIG_SCHED_NUMA */
+
+/**************************************************
  * Scheduling class queueing methods:
  */
 
@@ -784,9 +929,19 @@ account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	if (!parent_entity(se))
 		update_load_add(&rq_of(cfs_rq)->load, se->load.weight);
 #ifdef CONFIG_SMP
-	if (entity_is_task(se))
-		list_add(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
-#endif
+	if (entity_is_task(se)) {
+		struct rq *rq = rq_of(cfs_rq);
+		struct task_struct *p = task_of(se);
+		struct list_head *tasks = &rq->cfs_tasks;
+
+		if (offnode_task(p)) {
+			account_offnode_enqueue(rq, p);
+			tasks = offnode_tasks(rq);
+		}
+
+		list_add(&se->group_node, tasks);
+	}
+#endif /* CONFIG_SMP */
 	cfs_rq->nr_running++;
 }
 
@@ -796,8 +951,14 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
 		update_load_sub(&rq_of(cfs_rq)->load, se->load.weight);
-	if (entity_is_task(se))
+	if (entity_is_task(se)) {
+		struct task_struct *p = task_of(se);
+
 		list_del_init(&se->group_node);
+
+		if (offnode_task(p))
+			account_offnode_dequeue(rq_of(cfs_rq), p);
+	}
 	cfs_rq->nr_running--;
 }
 
@@ -3293,8 +3454,6 @@ static int move_one_task(struct lb_env *env)
 	return 0;
 }
 
-static unsigned long task_h_load(struct task_struct *p);
-
 static const unsigned int sched_nr_migrate_break = 32;
 
 /*
@@ -5174,6 +5333,9 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 		cfs_rq = cfs_rq_of(se);
 		entity_tick(cfs_rq, se, queued);
 	}
+
+	if (sched_feat_numa(NUMA))
+		task_tick_numa(rq, curr);
 }
 
 /*
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index a5cc07b..fa6a0ac 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -63,6 +63,7 @@ SCHED_FEAT(RT_RUNTIME_SHARE, true)
 SCHED_FEAT(LB_MIN, false)
 
 #ifdef CONFIG_SCHED_NUMA
+SCHED_FEAT(NUMA,           true)
 SCHED_FEAT(NUMA_HOT,       true)
 SCHED_FEAT(NUMA_BIAS,      true)
 SCHED_FEAT(NUMA_PULL,      true)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 74c37e6..bc5fc3e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -475,15 +475,6 @@ struct rq {
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
@@ -501,6 +492,30 @@ DECLARE_PER_CPU(struct rq, runqueues);
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
+#ifdef CONFIG_SCHED_NUMA
+static inline bool offnode_task(struct task_struct *t)
+{
+	return t->node != -1 && t->node != cpu_to_node(task_cpu(t));
+}
+
+static inline struct list_head *offnode_tasks(struct rq *rq)
+{
+	return &rq->offnode_tasks;
+}
+
+void sched_setnode(struct task_struct *p, int node);
+#else /* CONFIG_SCHED_NUMA */
+static inline bool offnode_task(struct task_struct *t)
+{
+	return false;
+}
+
+static inline struct list_head *offnode_tasks(struct rq *rq)
+{
+	return NULL;
+}
+#endif /* CONFIG_SCHED_NUMA */
+
 #ifdef CONFIG_SMP
 
 #define rcu_dereference_check_sched_domain(p) \
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 81c7b1a..c08b95e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -297,6 +297,7 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &min_wakeup_granularity_ns,
 		.extra2		= &max_wakeup_granularity_ns,
 	},
+#ifdef CONFIG_SMP
 	{
 		.procname	= "sched_tunable_scaling",
 		.data		= &sysctl_sched_tunable_scaling,
@@ -343,7 +344,17 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
-#endif
+#endif /* CONFIG_SMP */
+#ifdef CONFIG_SCHED_NUMA
+	{
+		.procname	= "sched_numa_task_period_ms",
+		.data		= &sysctl_sched_numa_task_period,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif /* CONFIG_SCHED_NUMA */
+#endif /* CONFIG_SCHED_DEBUG */
 	{
 		.procname	= "sched_rt_period_us",
 		.data		= &sysctl_sched_rt_period,
