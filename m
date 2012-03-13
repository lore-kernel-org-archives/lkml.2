Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab2CMEov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:44:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35096 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab2CMEos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:44:48 -0400
Date: Mon, 12 Mar 2012 21:44:19 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-zk04ihygwxn7qqrlpaf73b0r@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix load-balance wreckage
Git-Commit-ID: 5d6523ebd2f67de9d23285aad7f3910e7b0aee83
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 12 Mar 2012 21:44:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d6523ebd2f67de9d23285aad7f3910e7b0aee83
Gitweb:     http://git.kernel.org/tip/5d6523ebd2f67de9d23285aad7f3910e7b0aee83
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 10 Mar 2012 00:07:36 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Mar 2012 20:43:15 +0100

sched: Fix load-balance wreckage

Commit 367456c ("sched: Ditch per cgroup task lists for
load-balancing") completely wrecked load-balancing due to
a few silly mistakes.

Correct those and remove more pointless code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-zk04ihygwxn7qqrlpaf73b0r@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |  110 ++++++++++++++++++---------------------------------
 1 files changed, 39 insertions(+), 71 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a0424fc..def17aa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -784,7 +784,7 @@ account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		update_load_add(&rq_of(cfs_rq)->load, se->load.weight);
 #ifdef CONFIG_SMP
 	if (entity_is_task(se))
-		list_add(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
+		list_add_tail(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
 #endif
 	cfs_rq->nr_running++;
 }
@@ -3071,7 +3071,6 @@ static unsigned long __read_mostly max_load_balance_interval = HZ/10;
 
 #define LBF_ALL_PINNED	0x01
 #define LBF_NEED_BREAK	0x02
-#define LBF_ABORT	0x04
 
 struct lb_env {
 	struct sched_domain	*sd;
@@ -3083,7 +3082,7 @@ struct lb_env {
 	struct rq		*dst_rq;
 
 	enum cpu_idle_type	idle;
-	unsigned long		max_load_move;
+	long			load_move;
 	unsigned int		flags;
 
 	unsigned int		loop;
@@ -3216,39 +3215,47 @@ static int move_one_task(struct lb_env *env)
 
 static unsigned long task_h_load(struct task_struct *p);
 
-static unsigned long balance_tasks(struct lb_env *env)
+/*
+ * move_tasks tries to move up to load_move weighted load from busiest to
+ * this_rq, as part of a balancing operation within domain "sd".
+ * Returns 1 if successful and 0 otherwise.
+ *
+ * Called with both runqueues locked.
+ */
+static int move_tasks(struct lb_env *env)
 {
-	long rem_load_move = env->max_load_move;
-	struct task_struct *p, *n;
+	struct list_head *tasks = &env->src_rq->cfs_tasks;
+	struct task_struct *p;
 	unsigned long load;
 	int pulled = 0;
 
-	if (env->max_load_move == 0)
-		goto out;
+	if (env->load_move <= 0)
+		return 0;
+
+	while (!list_empty(tasks)) {
+		p = list_first_entry(tasks, struct task_struct, se.group_node);
 
-	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
 		env->loop++;
 		/* We've more or less seen every task there is, call it quits */
-		if (env->loop > env->loop_max) {
-			env->flags |= LBF_ABORT;
+		if (env->loop > env->loop_max)
 			break;
-		}
-		/* take a beather every nr_migrate tasks */
+
+		/* take a breather every nr_migrate tasks */
 		if (env->loop > env->loop_break) {
 			env->loop_break += sysctl_sched_nr_migrate;
 			env->flags |= LBF_NEED_BREAK;
 			break;
 		}
 
-		if (throttled_lb_pair(task_group(p), env->src_rq->cpu,
-					env->dst_cpu))
+		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
 			goto next;
 
 		load = task_h_load(p);
+
 		if (load < 16 && !env->sd->nr_balance_failed)
 			goto next;
 
-		if ((load * 2) > rem_load_move)
+		if ((load / 2) > env->load_move)
 			goto next;
 
 		if (!can_migrate_task(p, env))
@@ -3256,7 +3263,7 @@ static unsigned long balance_tasks(struct lb_env *env)
 
 		move_task(p, env);
 		pulled++;
-		rem_load_move -= load;
+		env->load_move -= load;
 
 #ifdef CONFIG_PREEMPT
 		/*
@@ -3264,24 +3271,22 @@ static unsigned long balance_tasks(struct lb_env *env)
 		 * kernels will stop after the first task is pulled to minimize
 		 * the critical section.
 		 */
-		if (env->idle == CPU_NEWLY_IDLE) {
-			env->flags |= LBF_ABORT;
+		if (env->idle == CPU_NEWLY_IDLE)
 			break;
-		}
 #endif
 
 		/*
 		 * We only want to steal up to the prescribed amount of
 		 * weighted load.
 		 */
-		if (rem_load_move <= 0)
+		if (env->load_move <= 0)
 			break;
 
 		continue;
 next:
-		list_move_tail(&p->se.group_node, &env->src_rq->cfs_tasks);
+		list_move_tail(&p->se.group_node, tasks);
 	}
-out:
+
 	/*
 	 * Right now, this is one of only two places move_task() is called,
 	 * so we can safely collect move_task() stats here rather than
@@ -3289,7 +3294,7 @@ out:
 	 */
 	schedstat_add(env->sd, lb_gained[env->idle], pulled);
 
-	return env->max_load_move - rem_load_move;
+	return pulled;
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -3399,43 +3404,6 @@ static unsigned long task_h_load(struct task_struct *p)
 }
 #endif
 
-/*
- * move_tasks tries to move up to max_load_move weighted load from busiest to
- * this_rq, as part of a balancing operation within domain "sd".
- * Returns 1 if successful and 0 otherwise.
- *
- * Called with both runqueues locked.
- */
-static int move_tasks(struct lb_env *env)
-{
-	unsigned long max_load_move = env->max_load_move;
-	unsigned long total_load_moved = 0, load_moved;
-
-	update_h_load(cpu_of(env->src_rq));
-	do {
-		env->max_load_move = max_load_move - total_load_moved;
-		load_moved = balance_tasks(env);
-		total_load_moved += load_moved;
-
-		if (env->flags & (LBF_NEED_BREAK|LBF_ABORT))
-			break;
-
-#ifdef CONFIG_PREEMPT
-		/*
-		 * NEWIDLE balancing is a source of latency, so preemptible
-		 * kernels will stop after the first task is pulled to minimize
-		 * the critical section.
-		 */
-		if (env->idle == CPU_NEWLY_IDLE && env->dst_rq->nr_running) {
-			env->flags |= LBF_ABORT;
-			break;
-		}
-#endif
-	} while (load_moved && max_load_move > total_load_moved);
-
-	return total_load_moved > 0;
-}
-
 /********** Helpers for find_busiest_group ************************/
 /*
  * sd_lb_stats - Structure to store the statistics of a sched_domain
@@ -4477,31 +4445,31 @@ redo:
 		 * correctly treated as an imbalance.
 		 */
 		env.flags |= LBF_ALL_PINNED;
-		env.max_load_move = imbalance;
+		env.load_move = imbalance;
 		env.src_cpu = busiest->cpu;
 		env.src_rq = busiest;
 		env.loop_max = busiest->nr_running;
 
+more_balance:
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
-		ld_moved = move_tasks(&env);
+		if (!env.loop)
+			update_h_load(env.src_cpu);
+		ld_moved += move_tasks(&env);
 		double_rq_unlock(this_rq, busiest);
 		local_irq_restore(flags);
 
+		if (env.flags & LBF_NEED_BREAK) {
+			env.flags &= ~LBF_NEED_BREAK;
+			goto more_balance;
+		}
+
 		/*
 		 * some other cpu did the load balance for us.
 		 */
 		if (ld_moved && this_cpu != smp_processor_id())
 			resched_cpu(this_cpu);
 
-		if (env.flags & LBF_ABORT)
-			goto out_balanced;
-
-		if (env.flags & LBF_NEED_BREAK) {
-			env.flags &= ~LBF_NEED_BREAK;
-			goto redo;
-		}
-
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(env.flags & LBF_ALL_PINNED)) {
 			cpumask_clear_cpu(cpu_of(busiest), cpus);
