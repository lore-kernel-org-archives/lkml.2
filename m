Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab2EIO2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:28:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40965 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863Ab2EIO2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:28:32 -0400
Date: Wed, 9 May 2012 07:28:12 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-v66ivjfqdiqdso01lqgqx6qf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Propagate 'struct lb_env'
  usage into find_busiest_group
Git-Commit-ID: bd939f45da24e25e08a8f5c993c50b1afada0fef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:28:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd939f45da24e25e08a8f5c993c50b1afada0fef
Gitweb:     http://git.kernel.org/tip/bd939f45da24e25e08a8f5c993c50b1afada0fef
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 2 May 2012 14:20:37 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:00:54 +0200

sched/fair: Propagate 'struct lb_env' usage into find_busiest_group

More function argument passing reduction.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-v66ivjfqdiqdso01lqgqx6qf@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |  175 ++++++++++++++++++++++++---------------------------
 1 files changed, 82 insertions(+), 93 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cf86f74..9bd3366 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3082,7 +3082,7 @@ struct lb_env {
 	struct rq		*dst_rq;
 
 	enum cpu_idle_type	idle;
-	long			load_move;
+	long			imbalance;
 	unsigned int		flags;
 
 	unsigned int		loop;
@@ -3218,7 +3218,7 @@ static unsigned long task_h_load(struct task_struct *p);
 static const unsigned int sched_nr_migrate_break = 32;
 
 /*
- * move_tasks tries to move up to load_move weighted load from busiest to
+ * move_tasks tries to move up to imbalance weighted load from busiest to
  * this_rq, as part of a balancing operation within domain "sd".
  * Returns 1 if successful and 0 otherwise.
  *
@@ -3231,7 +3231,7 @@ static int move_tasks(struct lb_env *env)
 	unsigned long load;
 	int pulled = 0;
 
-	if (env->load_move <= 0)
+	if (env->imbalance <= 0)
 		return 0;
 
 	while (!list_empty(tasks)) {
@@ -3257,7 +3257,7 @@ static int move_tasks(struct lb_env *env)
 		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
 			goto next;
 
-		if ((load / 2) > env->load_move)
+		if ((load / 2) > env->imbalance)
 			goto next;
 
 		if (!can_migrate_task(p, env))
@@ -3265,7 +3265,7 @@ static int move_tasks(struct lb_env *env)
 
 		move_task(p, env);
 		pulled++;
-		env->load_move -= load;
+		env->imbalance -= load;
 
 #ifdef CONFIG_PREEMPT
 		/*
@@ -3281,7 +3281,7 @@ static int move_tasks(struct lb_env *env)
 		 * We only want to steal up to the prescribed amount of
 		 * weighted load.
 		 */
-		if (env->load_move <= 0)
+		if (env->imbalance <= 0)
 			break;
 
 		continue;
@@ -3578,10 +3578,9 @@ static inline void update_sd_power_savings_stats(struct sched_group *group,
 
 /**
  * check_power_save_busiest_group - see if there is potential for some power-savings balance
+ * @env: load balance environment
  * @sds: Variable containing the statistics of the sched_domain
  *	under consideration.
- * @this_cpu: Cpu at which we're currently performing load-balancing.
- * @imbalance: Variable to store the imbalance.
  *
  * Description:
  * Check if we have potential to perform some power-savings balance.
@@ -3591,8 +3590,8 @@ static inline void update_sd_power_savings_stats(struct sched_group *group,
  * Returns 1 if there is potential to perform power-savings balance.
  * Else returns 0.
  */
-static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
-					int this_cpu, unsigned long *imbalance)
+static inline
+int check_power_save_busiest_group(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	if (!sds->power_savings_balance)
 		return 0;
@@ -3601,7 +3600,7 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 			sds->group_leader == sds->group_min)
 		return 0;
 
-	*imbalance = sds->min_load_per_task;
+	env->imbalance = sds->min_load_per_task;
 	sds->busiest = sds->group_min;
 
 	return 1;
@@ -3620,8 +3619,8 @@ static inline void update_sd_power_savings_stats(struct sched_group *group,
 	return;
 }
 
-static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
-					int this_cpu, unsigned long *imbalance)
+static inline
+int check_power_save_busiest_group(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	return 0;
 }
@@ -3765,25 +3764,22 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @sd: The sched_domain whose statistics are to be updated.
  * @group: sched_group whose statistics are to be updated.
- * @this_cpu: Cpu for which load balance is currently performed.
- * @idle: Idle status of this_cpu
  * @load_idx: Load index of sched_domain of this_cpu for load calc.
  * @local_group: Does group contain this_cpu.
  * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
  * @sgs: variable to hold the statistics for this group.
  */
-static inline void update_sg_lb_stats(struct sched_domain *sd,
-			struct sched_group *group, int this_cpu,
-			enum cpu_idle_type idle, int load_idx,
+static inline void update_sg_lb_stats(struct lb_env *env,
+			struct sched_group *group, int load_idx,
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
 {
 	unsigned long load, max_cpu_load, min_cpu_load, max_nr_running;
-	int i;
 	unsigned int balance_cpu = -1;
 	unsigned long balance_load = ~0UL;
 	unsigned long avg_load_per_task = 0;
+	int i;
 
 	if (local_group)
 		balance_cpu = group_first_cpu(group);
@@ -3827,15 +3823,15 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	 * to do the newly idle load balance.
 	 */
 	if (local_group) {
-		if (idle != CPU_NEWLY_IDLE) {
-			if (balance_cpu != this_cpu ||
+		if (env->idle != CPU_NEWLY_IDLE) {
+			if (balance_cpu != env->dst_cpu ||
 			    cmpxchg(&group->balance_cpu, -1, balance_cpu) != -1) {
 				*balance = 0;
 				return;
 			}
-			update_group_power(sd, this_cpu);
+			update_group_power(env->sd, env->dst_cpu);
 		} else if (time_after_eq(jiffies, group->sgp->next_update))
-			update_group_power(sd, this_cpu);
+			update_group_power(env->sd, env->dst_cpu);
 	}
 
 	/* Adjust by relative CPU power of the group */
@@ -3859,7 +3855,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	sgs->group_capacity = DIV_ROUND_CLOSEST(group->sgp->power,
 						SCHED_POWER_SCALE);
 	if (!sgs->group_capacity)
-		sgs->group_capacity = fix_small_capacity(sd, group);
+		sgs->group_capacity = fix_small_capacity(env->sd, group);
 	sgs->group_weight = group->group_weight;
 
 	if (sgs->group_capacity > sgs->sum_nr_running)
@@ -3877,11 +3873,10 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
  * Determine if @sg is a busier group than the previously selected
  * busiest group.
  */
-static bool update_sd_pick_busiest(struct sched_domain *sd,
+static bool update_sd_pick_busiest(struct lb_env *env,
 				   struct sd_lb_stats *sds,
 				   struct sched_group *sg,
-				   struct sg_lb_stats *sgs,
-				   int this_cpu)
+				   struct sg_lb_stats *sgs)
 {
 	if (sgs->avg_load <= sds->max_load)
 		return false;
@@ -3897,8 +3892,8 @@ static bool update_sd_pick_busiest(struct sched_domain *sd,
 	 * numbered CPUs in the group, therefore mark all groups
 	 * higher than ourself as busy.
 	 */
-	if ((sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running &&
-	    this_cpu < group_first_cpu(sg)) {
+	if ((env->sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running &&
+	    env->dst_cpu < group_first_cpu(sg)) {
 		if (!sds->busiest)
 			return true;
 
@@ -3918,28 +3913,28 @@ static bool update_sd_pick_busiest(struct sched_domain *sd,
  * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
  */
-static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
-			enum cpu_idle_type idle, const struct cpumask *cpus,
-			int *balance, struct sd_lb_stats *sds)
+static inline void update_sd_lb_stats(struct lb_env *env,
+				      const struct cpumask *cpus,
+				      int *balance, struct sd_lb_stats *sds)
 {
-	struct sched_domain *child = sd->child;
-	struct sched_group *sg = sd->groups;
+	struct sched_domain *child = env->sd->child;
+	struct sched_group *sg = env->sd->groups;
 	struct sg_lb_stats sgs;
 	int load_idx, prefer_sibling = 0;
 
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
 
-	init_sd_power_savings_stats(sd, sds, idle);
-	load_idx = get_sd_load_idx(sd, idle);
+	init_sd_power_savings_stats(env->sd, sds, env->idle);
+	load_idx = get_sd_load_idx(env->sd, env->idle);
 
 	do {
 		int local_group;
 
-		local_group = cpumask_test_cpu(this_cpu, sched_group_cpus(sg));
+		local_group = cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(sd, sg, this_cpu, idle, load_idx,
-				local_group, cpus, balance, &sgs);
+		update_sg_lb_stats(env, sg, load_idx, local_group,
+				   cpus, balance, &sgs);
 
 		if (local_group && !(*balance))
 			return;
@@ -3967,7 +3962,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			sds->this_load_per_task = sgs.sum_weighted_load;
 			sds->this_has_capacity = sgs.group_has_capacity;
 			sds->this_idle_cpus = sgs.idle_cpus;
-		} else if (update_sd_pick_busiest(sd, sds, sg, &sgs, this_cpu)) {
+		} else if (update_sd_pick_busiest(env, sds, sg, &sgs)) {
 			sds->max_load = sgs.avg_load;
 			sds->busiest = sg;
 			sds->busiest_nr_running = sgs.sum_nr_running;
@@ -3981,7 +3976,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 
 		update_sd_power_savings_stats(sg, sds, local_group, &sgs);
 		sg = sg->next;
-	} while (sg != sd->groups);
+	} while (sg != env->sd->groups);
 }
 
 /**
@@ -4009,24 +4004,23 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
  * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
  * @imbalance: returns amount of imbalanced due to packing.
  */
-static int check_asym_packing(struct sched_domain *sd,
-			      struct sd_lb_stats *sds,
-			      int this_cpu, unsigned long *imbalance)
+static int check_asym_packing(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	int busiest_cpu;
 
-	if (!(sd->flags & SD_ASYM_PACKING))
+	if (!(env->sd->flags & SD_ASYM_PACKING))
 		return 0;
 
 	if (!sds->busiest)
 		return 0;
 
 	busiest_cpu = group_first_cpu(sds->busiest);
-	if (this_cpu > busiest_cpu)
+	if (env->dst_cpu > busiest_cpu)
 		return 0;
 
-	*imbalance = DIV_ROUND_CLOSEST(sds->max_load * sds->busiest->sgp->power,
-				       SCHED_POWER_SCALE);
+	env->imbalance = DIV_ROUND_CLOSEST(
+		sds->max_load * sds->busiest->sgp->power, SCHED_POWER_SCALE);
+
 	return 1;
 }
 
@@ -4038,8 +4032,8 @@ static int check_asym_packing(struct sched_domain *sd,
  * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
  * @imbalance: Variable to store the imbalance.
  */
-static inline void fix_small_imbalance(struct sd_lb_stats *sds,
-				int this_cpu, unsigned long *imbalance)
+static inline
+void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	unsigned long tmp, pwr_now = 0, pwr_move = 0;
 	unsigned int imbn = 2;
@@ -4050,9 +4044,10 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 		if (sds->busiest_load_per_task >
 				sds->this_load_per_task)
 			imbn = 1;
-	} else
+	} else {
 		sds->this_load_per_task =
-			cpu_avg_load_per_task(this_cpu);
+			cpu_avg_load_per_task(env->dst_cpu);
+	}
 
 	scaled_busy_load_per_task = sds->busiest_load_per_task
 					 * SCHED_POWER_SCALE;
@@ -4060,7 +4055,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 
 	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
 			(scaled_busy_load_per_task * imbn)) {
-		*imbalance = sds->busiest_load_per_task;
+		env->imbalance = sds->busiest_load_per_task;
 		return;
 	}
 
@@ -4097,18 +4092,16 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 
 	/* Move if we gain throughput */
 	if (pwr_move > pwr_now)
-		*imbalance = sds->busiest_load_per_task;
+		env->imbalance = sds->busiest_load_per_task;
 }
 
 /**
  * calculate_imbalance - Calculate the amount of imbalance present within the
  *			 groups of a given sched_domain during load balance.
+ * @env: load balance environment
  * @sds: statistics of the sched_domain whose imbalance is to be calculated.
- * @this_cpu: Cpu for which currently load balance is being performed.
- * @imbalance: The variable to store the imbalance.
  */
-static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
-		unsigned long *imbalance)
+static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	unsigned long max_pull, load_above_capacity = ~0UL;
 
@@ -4124,8 +4117,8 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 	 * its cpu_power, while calculating max_load..)
 	 */
 	if (sds->max_load < sds->avg_load) {
-		*imbalance = 0;
-		return fix_small_imbalance(sds, this_cpu, imbalance);
+		env->imbalance = 0;
+		return fix_small_imbalance(env, sds);
 	}
 
 	if (!sds->group_imb) {
@@ -4153,7 +4146,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
 
 	/* How much load to actually move to equalise the imbalance */
-	*imbalance = min(max_pull * sds->busiest->sgp->power,
+	env->imbalance = min(max_pull * sds->busiest->sgp->power,
 		(sds->avg_load - sds->this_load) * sds->this->sgp->power)
 			/ SCHED_POWER_SCALE;
 
@@ -4163,8 +4156,8 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 	 * a think about bumping its value to force at least one task to be
 	 * moved
 	 */
-	if (*imbalance < sds->busiest_load_per_task)
-		return fix_small_imbalance(sds, this_cpu, imbalance);
+	if (env->imbalance < sds->busiest_load_per_task)
+		return fix_small_imbalance(env, sds);
 
 }
 
@@ -4195,9 +4188,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
  *		   put to idle by rebalancing its tasks onto our group.
  */
 static struct sched_group *
-find_busiest_group(struct sched_domain *sd, int this_cpu,
-		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   const struct cpumask *cpus, int *balance)
+find_busiest_group(struct lb_env *env, const struct cpumask *cpus, int *balance)
 {
 	struct sd_lb_stats sds;
 
@@ -4207,7 +4198,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 * Compute the various statistics relavent for load balancing at
 	 * this level.
 	 */
-	update_sd_lb_stats(sd, this_cpu, idle, cpus, balance, &sds);
+	update_sd_lb_stats(env, cpus, balance, &sds);
 
 	/*
 	 * this_cpu is not the appropriate cpu to perform load balancing at
@@ -4216,8 +4207,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!(*balance))
 		goto ret;
 
-	if ((idle == CPU_IDLE || idle == CPU_NEWLY_IDLE) &&
-	    check_asym_packing(sd, &sds, this_cpu, imbalance))
+	if ((env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE) &&
+	    check_asym_packing(env, &sds))
 		return sds.busiest;
 
 	/* There is no busy sibling group to pull tasks from */
@@ -4235,7 +4226,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
-	if (idle == CPU_NEWLY_IDLE && sds.this_has_capacity &&
+	if (env->idle == CPU_NEWLY_IDLE && sds.this_has_capacity &&
 			!sds.busiest_has_capacity)
 		goto force_balance;
 
@@ -4253,7 +4244,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (sds.this_load >= sds.avg_load)
 		goto out_balanced;
 
-	if (idle == CPU_IDLE) {
+	if (env->idle == CPU_IDLE) {
 		/*
 		 * This cpu is idle. If the busiest group load doesn't
 		 * have more tasks than the number of available cpu's and
@@ -4268,13 +4259,13 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 * In the CPU_NEWLY_IDLE, CPU_NOT_IDLE cases, use
 		 * imbalance_pct to be conservative.
 		 */
-		if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
+		if (100 * sds.max_load <= env->sd->imbalance_pct * sds.this_load)
 			goto out_balanced;
 	}
 
 force_balance:
 	/* Looks like there is an imbalance. Compute it */
-	calculate_imbalance(&sds, this_cpu, imbalance);
+	calculate_imbalance(env, &sds);
 	return sds.busiest;
 
 out_balanced:
@@ -4282,20 +4273,19 @@ out_balanced:
 	 * There is no obvious imbalance. But check if we can do some balancing
 	 * to save power.
 	 */
-	if (check_power_save_busiest_group(&sds, this_cpu, imbalance))
+	if (check_power_save_busiest_group(env, &sds))
 		return sds.busiest;
 ret:
-	*imbalance = 0;
+	env->imbalance = 0;
 	return NULL;
 }
 
 /*
  * find_busiest_queue - find the busiest runqueue among the cpus in group.
  */
-static struct rq *
-find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
-		   enum cpu_idle_type idle, unsigned long imbalance,
-		   const struct cpumask *cpus)
+static struct rq *find_busiest_queue(struct lb_env *env,
+				     struct sched_group *group,
+				     const struct cpumask *cpus)
 {
 	struct rq *busiest = NULL, *rq;
 	unsigned long max_load = 0;
@@ -4308,7 +4298,7 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 		unsigned long wl;
 
 		if (!capacity)
-			capacity = fix_small_capacity(sd, group);
+			capacity = fix_small_capacity(env->sd, group);
 
 		if (!cpumask_test_cpu(i, cpus))
 			continue;
@@ -4320,7 +4310,7 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu power.
 		 */
-		if (capacity && rq->nr_running == 1 && wl > imbalance)
+		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
 			continue;
 
 		/*
@@ -4349,17 +4339,18 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 /* Working cpumask for load_balance and load_balance_newidle. */
 DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
 
-static int need_active_balance(struct sched_domain *sd, int idle,
-			       int busiest_cpu, int this_cpu)
+static int need_active_balance(struct lb_env *env)
 {
-	if (idle == CPU_NEWLY_IDLE) {
+	struct sched_domain *sd = env->sd;
+
+	if (env->idle == CPU_NEWLY_IDLE) {
 
 		/*
 		 * ASYM_PACKING needs to force migrate tasks from busy but
 		 * higher numbered CPUs in order to pack all tasks in the
 		 * lowest numbered CPUs.
 		 */
-		if ((sd->flags & SD_ASYM_PACKING) && busiest_cpu > this_cpu)
+		if ((sd->flags & SD_ASYM_PACKING) && env->src_cpu > env->dst_cpu)
 			return 1;
 
 		/*
@@ -4400,7 +4391,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 {
 	int ld_moved, active_balance = 0;
 	struct sched_group *group;
-	unsigned long imbalance;
 	struct rq *busiest;
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
@@ -4418,8 +4408,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	schedstat_inc(sd, lb_count[idle]);
 
 redo:
-	group = find_busiest_group(sd, this_cpu, &imbalance, idle,
-				   cpus, balance);
+	group = find_busiest_group(&env, cpus, balance);
 
 	if (*balance == 0)
 		goto out_balanced;
@@ -4429,7 +4418,7 @@ redo:
 		goto out_balanced;
 	}
 
-	busiest = find_busiest_queue(sd, group, idle, imbalance, cpus);
+	busiest = find_busiest_queue(&env, group, cpus);
 	if (!busiest) {
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;
@@ -4437,7 +4426,7 @@ redo:
 
 	BUG_ON(busiest == this_rq);
 
-	schedstat_add(sd, lb_imbalance[idle], imbalance);
+	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
 	ld_moved = 0;
 	if (busiest->nr_running > 1) {
@@ -4448,7 +4437,6 @@ redo:
 		 * correctly treated as an imbalance.
 		 */
 		env.flags |= LBF_ALL_PINNED;
-		env.load_move = imbalance;
 		env.src_cpu   = busiest->cpu;
 		env.src_rq    = busiest;
 		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
@@ -4493,7 +4481,7 @@ more_balance:
 		if (idle != CPU_NEWLY_IDLE)
 			sd->nr_balance_failed++;
 
-		if (need_active_balance(sd, idle, cpu_of(busiest), this_cpu)) {
+		if (need_active_balance(&env)) {
 			raw_spin_lock_irqsave(&busiest->lock, flags);
 
 			/* don't kick the active_load_balance_cpu_stop,
@@ -4520,10 +4508,11 @@ more_balance:
 			}
 			raw_spin_unlock_irqrestore(&busiest->lock, flags);
 
-			if (active_balance)
+			if (active_balance) {
 				stop_one_cpu_nowait(cpu_of(busiest),
 					active_load_balance_cpu_stop, busiest,
 					&busiest->active_balance_work);
+			}
 
 			/*
 			 * We've kicked active balancing, reset the failure
