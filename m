Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab2IUSgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:36:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36685 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541Ab2IUSc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:32:26 -0400
From: morten.rasmussen@arm.com
To: paulmck@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        suresh.b.siddha@intel.com
Cc: morten.rasmussen@arm.com, linaro-sched-sig@lists.linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 03/10] sched: Forced task migration on heterogeneous systems
Date: Fri, 21 Sep 2012 19:32:18 +0100
Message-Id: <1348252345-5642-4-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 21 Sep 2012 18:32:24.0647 (UTC) FILETIME=[71F26570:01CD9827]
X-MC-Unique: 112092119322500401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8LIaPjn011392

From: Morten Rasmussen <morten.rasmussen@arm.com>

This patch introduces forced task migration for moving suitable
currently running tasks between hmp_domains. Task behaviour is likely
to change over time. Tasks running in a less capable hmp_domain may
change to become more demanding and should therefore be migrated up.
They are unlikely go through the select_task_rq_fair() path anytime
soon and therefore need special attention.

This patch introduces a period check (SCHED_TICK) of the currently
running task on all runqueues and sets up a forced migration using
stop_machine_no_wait() if the task needs to be migrated.

Ideally, this should not be implemented by polling all runqueues.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c  |  196 +++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/sched.h |    3 +
 2 files changed, 198 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d80de46..490f1f0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3744,7 +3744,6 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 1) task is cache cold, or
 	 * 2) too many balance attempts have failed.
 	 */
-
 	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
 	if (!tsk_cache_hot ||
 		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
@@ -5516,6 +5515,199 @@ static unsigned int hmp_down_migration(int cpu, struct sched_entity *se)
 	return 0;
 }
 
+/*
+ * hmp_can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
+ * Ideally this function should be merged with can_migrate_task() to avoid
+ * redundant code.
+ */
+static int hmp_can_migrate_task(struct task_struct *p, struct lb_env *env)
+{
+	int tsk_cache_hot = 0;
+
+	/*
+	 * We do not migrate tasks that are:
+	 * 1) running (obviously), or
+	 * 2) cannot be migrated to this CPU due to cpus_allowed
+	 */
+	if (!cpumask_test_cpu(env->dst_cpu, tsk_cpus_allowed(p))) {
+		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
+		return 0;
+	}
+	env->flags &= ~LBF_ALL_PINNED;
+
+	if (task_running(env->src_rq, p)) {
+		schedstat_inc(p, se.statistics.nr_failed_migrations_running);
+		return 0;
+	}
+
+	/*
+	 * Aggressive migration if:
+	 * 1) task is cache cold, or
+	 * 2) too many balance attempts have failed.
+	 */
+
+	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
+	if (!tsk_cache_hot ||
+		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
+#ifdef CONFIG_SCHEDSTATS
+		if (tsk_cache_hot) {
+			schedstat_inc(env->sd, lb_hot_gained[env->idle]);
+			schedstat_inc(p, se.statistics.nr_forced_migrations);
+		}
+#endif
+		return 1;
+	}
+
+	return 1;
+}
+
+/*
+ * move_specific_task tries to move a specific task.
+ * Returns 1 if successful and 0 otherwise.
+ * Called with both runqueues locked.
+ */
+static int move_specific_task(struct lb_env *env, struct task_struct *pm)
+{
+	struct task_struct *p, *n;
+
+	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
+	if (throttled_lb_pair(task_group(p), env->src_rq->cpu,
+				env->dst_cpu))
+		continue;
+
+		if (!hmp_can_migrate_task(p, env))
+			continue;
+		/* Check if we found the right task */
+		if (p != pm)
+			continue;
+
+		move_task(p, env);
+		/*
+		 * Right now, this is only the third place move_task()
+		 * is called, so we can safely collect move_task()
+		 * stats here rather than inside move_task().
+		 */
+		schedstat_inc(env->sd, lb_gained[env->idle]);
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * hmp_active_task_migration_cpu_stop is run by cpu stopper and used to
+ * migrate a specific task from one runqueue to another.
+ * hmp_force_up_migration uses this to push a currently running task
+ * off a runqueue.
+ * Based on active_load_balance_stop_cpu and can potentially be merged.
+ */
+static int hmp_active_task_migration_cpu_stop(void *data)
+{
+	struct rq *busiest_rq = data;
+	struct task_struct *p = busiest_rq->migrate_task;
+	int busiest_cpu = cpu_of(busiest_rq);
+	int target_cpu = busiest_rq->push_cpu;
+	struct rq *target_rq = cpu_rq(target_cpu);
+	struct sched_domain *sd;
+
+	raw_spin_lock_irq(&busiest_rq->lock);
+	/* make sure the requested cpu hasn't gone down in the meantime */
+	if (unlikely(busiest_cpu != smp_processor_id() ||
+		!busiest_rq->active_balance)) {
+		goto out_unlock;
+	}
+	/* Is there any task to move? */
+	if (busiest_rq->nr_running <= 1)
+		goto out_unlock;
+	/* Task has migrated meanwhile, abort forced migration */
+	if (task_rq(p) != busiest_rq)
+		goto out_unlock;
+	/*
+	 * This condition is "impossible", if it occurs
+	 * we need to fix it. Originally reported by
+	 * Bjorn Helgaas on a 128-cpu setup.
+	 */
+	BUG_ON(busiest_rq == target_rq);
+
+	/* move a task from busiest_rq to target_rq */
+	double_lock_balance(busiest_rq, target_rq);
+
+	/* Search for an sd spanning us and the target CPU. */
+	rcu_read_lock();
+	for_each_domain(target_cpu, sd) {
+		if (cpumask_test_cpu(busiest_cpu, sched_domain_span(sd)))
+			break;
+	}
+
+	if (likely(sd)) {
+		struct lb_env env = {
+			.sd		= sd,
+			.dst_cpu	= target_cpu,
+			.dst_rq		= target_rq,
+			.src_cpu	= busiest_rq->cpu,
+			.src_rq		= busiest_rq,
+			.idle		= CPU_IDLE,
+		};
+
+		schedstat_inc(sd, alb_count);
+
+		if (move_specific_task(&env, p))
+			schedstat_inc(sd, alb_pushed);
+		else
+			schedstat_inc(sd, alb_failed);
+	}
+	rcu_read_unlock();
+	double_unlock_balance(busiest_rq, target_rq);
+out_unlock:
+	busiest_rq->active_balance = 0;
+	raw_spin_unlock_irq(&busiest_rq->lock);
+	return 0;
+}
+
+static DEFINE_SPINLOCK(hmp_force_migration);
+
+/*
+ * hmp_force_up_migration checks runqueues for tasks that need to
+ * be actively migrated to a faster cpu.
+ */
+static void hmp_force_up_migration(int this_cpu)
+{
+	int cpu;
+	struct sched_entity *curr;
+	struct rq *target;
+	unsigned long flags;
+	unsigned int force;
+	struct task_struct *p;
+
+	if (!spin_trylock(&hmp_force_migration))
+		return;
+	for_each_online_cpu(cpu) {
+		force = 0;
+		target = cpu_rq(cpu);
+		raw_spin_lock_irqsave(&target->lock, flags);
+		curr = target->cfs.curr;
+		if (!curr || !entity_is_task(curr)) {
+			raw_spin_unlock_irqrestore(&target->lock, flags);
+			continue;
+		}
+		p = task_of(curr);
+		if (hmp_up_migration(cpu, curr)) {
+			if (!target->active_balance) {
+				target->active_balance = 1;
+				target->push_cpu = hmp_select_faster_cpu(p, cpu);
+				target->migrate_task = p;
+				force = 1;
+			}
+		}
+		raw_spin_unlock_irqrestore(&target->lock, flags);
+		if (force)
+			stop_one_cpu_nowait(cpu_of(target),
+				hmp_active_task_migration_cpu_stop,
+				target, &target->active_balance_work);
+	}
+	spin_unlock(&hmp_force_migration);
+}
+#else
+static void hmp_force_up_migration(int this_cpu) { }
 #endif /* CONFIG_SCHED_HMP */
 
 /*
@@ -5529,6 +5721,8 @@ static void run_rebalance_domains(struct softirq_action *h)
 	enum cpu_idle_type idle = this_rq->idle_balance ?
 						CPU_IDLE : CPU_NOT_IDLE;
 
+	hmp_force_up_migration(this_cpu);
+
 	rebalance_domains(this_cpu, idle);
 
 	/*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4990d9e..92858e9 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -425,6 +425,9 @@ struct rq {
 	int active_balance;
 	int push_cpu;
 	struct cpu_stop_work active_balance_work;
+#ifdef CONFIG_SCHED_HMP
+	struct task_struct *migrate_task;
+#endif
 	/* cpu of this runqueue: */
 	int cpu;
 	int online;
-- 
1.7.9.5


