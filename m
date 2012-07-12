Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab2GLIK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:10:27 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:38061 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2GLIKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:10:23 -0400
Message-ID: <4FFE8665.3080705@linux.vnet.ibm.com>
Date: Thu, 12 Jul 2012 16:10:13 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC PATCH] sched: add load balance cpumask pointer into lb_env
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071122-1396-0000-0000-0000018C5459
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

with this patch, ld_env will have a pointer of load balance cpumask,
and we don't need to pass cpus anymore.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   34 ++++++++++++++++------------------
 1 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 77f1ed7..5e6a1ef 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3102,14 +3102,16 @@ struct lb_env {
 
 	struct list_head	*tasks;
 
+	/* The set of CPUs under consideration for load-balancing */
+	struct cpumask		*cpus;
+
 	unsigned int		flags;
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
 
 	struct rq *		(*find_busiest_queue)(struct lb_env *,
-						      struct sched_group *,
-						      const struct cpumask *);
+						      struct sched_group *);
 };
 
 /*
@@ -3847,8 +3849,7 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  */
 static inline void update_sg_lb_stats(struct lb_env *env,
 			struct sched_group *group, int load_idx,
-			int local_group, const struct cpumask *cpus,
-			int *balance, struct sg_lb_stats *sgs)
+			int local_group, int *balance, struct sg_lb_stats *sgs)
 {
 	unsigned long nr_running, max_nr_running, min_nr_running;
 	unsigned long load, max_cpu_load, min_cpu_load;
@@ -3865,7 +3866,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	max_nr_running = 0;
 	min_nr_running = ~0UL;
 
-	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
+	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
 
 		nr_running = rq->nr_running;
@@ -3995,9 +3996,8 @@ static bool update_sd_pick_busiest(struct lb_env *env,
  * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
  */
-static inline void update_sd_lb_stats(struct lb_env *env,
-				      const struct cpumask *cpus,
-				      int *balance, struct sd_lb_stats *sds)
+static inline void update_sd_lb_stats(struct lb_env *env, 
+					int *balance, struct sd_lb_stats *sds)
 {
 	struct sched_domain *child = env->sd->child;
 	struct sched_group *sg = env->sd->groups;
@@ -4014,8 +4014,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 
 		local_group = cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(env, sg, load_idx, local_group,
-				   cpus, balance, &sgs);
+		update_sg_lb_stats(env, sg, load_idx, local_group, balance, &sgs);
 
 		if (local_group && !(*balance))
 			return;
@@ -4253,7 +4252,6 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
  * to restore balance.
  *
  * @env: The load balancing environment.
- * @cpus: The set of CPUs under consideration for load-balancing.
  * @balance: Pointer to a variable indicating if this_cpu
  *	is the appropriate cpu to perform load balancing at this_level.
  *
@@ -4263,7 +4261,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
  *		   put to idle by rebalancing its tasks onto our group.
  */
 static struct sched_group *
-find_busiest_group(struct lb_env *env, const struct cpumask *cpus, int *balance)
+find_busiest_group(struct lb_env *env, int *balance)
 {
 	struct sd_lb_stats sds;
 
@@ -4273,7 +4271,7 @@ find_busiest_group(struct lb_env *env, const struct cpumask *cpus, int *balance)
 	 * Compute the various statistics relavent for load balancing at
 	 * this level.
 	 */
-	update_sd_lb_stats(env, cpus, balance, &sds);
+	update_sd_lb_stats(env, balance, &sds);
 
 	/*
 	 * this_cpu is not the appropriate cpu to perform load balancing at
@@ -4356,8 +4354,7 @@ ret:
  * find_busiest_queue - find the busiest runqueue among the cpus in group.
  */
 static struct rq *find_busiest_queue(struct lb_env *env,
-				     struct sched_group *group,
-				     const struct cpumask *cpus)
+				     struct sched_group *group)
 {
 	struct rq *busiest = NULL, *rq;
 	unsigned long max_load = 0;
@@ -4372,7 +4369,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		if (!capacity)
 			capacity = fix_small_capacity(env->sd, group);
 
-		if (!cpumask_test_cpu(i, cpus))
+		if (!cpumask_test_cpu(i, env->cpus))
 			continue;
 
 		rq = cpu_rq(i);
@@ -4456,6 +4453,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.dst_grpmask	    = sched_group_cpus(sd->groups),
 		.idle		    = idle,
 		.loop_break	    = sched_nr_migrate_break,
+		.cpus		    = cpus,
 		.find_busiest_queue = find_busiest_queue,
 	};
 
@@ -4465,7 +4463,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	schedstat_inc(sd, lb_count[idle]);
 
 redo:
-	group = find_busiest_group(&env, cpus, balance);
+	group = find_busiest_group(&env, balance);
 
 	if (*balance == 0)
 		goto out_balanced;
@@ -4475,7 +4473,7 @@ redo:
 		goto out_balanced;
 	}
 
-	busiest = env.find_busiest_queue(&env, group, cpus);
+	busiest = env.find_busiest_queue(&env, group);
 	if (!busiest) {
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;
-- 
1.7.4.1

