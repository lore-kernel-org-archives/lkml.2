Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab1BNWjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:39:41 -0500
Received: from smtp-out.google.com ([74.125.121.67]:29410 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab1BNWji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:39:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=c24F4zkaDMPFxBGhcYAO/ca01e2JghhJreluc8/dRbNC+KyhEpTF+q/ZzqHbtpRPn4
         6D3sZPFsp8m2DEvWZI9g==
From: Venkatesh Pallipadi <venki@google.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Nick Piggin <npiggin@gmail.com>, Tim Chen <tim.c.chen@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] sched: Wholesale removal of sd_idle logic
Date: Mon, 14 Feb 2011 14:38:50 -0800
Message-Id: <1297723130-693-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297473616.2806.16.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1297473616.2806.16.camel@sbsiddha-MOBL3.sc.intel.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sd_idle logic was introduced way back in 2005 (commit 5969fe06),
as an HT optimization.

As per the discussion in the thread here
lkml subject - sched: Resolve sd_idle and first_idle_cpu Catch-22 - v1
https://patchwork.kernel.org/patch/532501/

the capacity based logic in the load balancer right now handles this
in a much cleaner way, handling more than 2 SMT siblings etc, and sd_idle
does not seem to bring any adiitional benefits. sd_idle logic also has
some bugs that has performance impact. Here is the patch that removes
the sd_idle logic altogether.

The initial patch here - https://patchwork.kernel.org/patch/532501/
applies cleanly over the below change and provides a micro-optimization
for a specific case, where an idle core can pull tasks instead of a
core with one thread being idle and other thread being busy.
It will be good to get some data on whether this micro-optimization
matters or not.

Also, there was a dependency of sched_mc_power_savings == 2, with sd_idle
logic. Copying Vaidy to know the impact of this change there.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched_fair.c |   53 ++++++++++----------------------------------------
 1 files changed, 11 insertions(+), 42 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0c26e2d..932dc13 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2610,7 +2610,6 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  * @this_cpu: Cpu for which load balance is currently performed.
  * @idle: Idle status of this_cpu
  * @load_idx: Load index of sched_domain of this_cpu for load calc.
- * @sd_idle: Idle status of the sched_domain containing group.
  * @local_group: Does group contain this_cpu.
  * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
@@ -2618,7 +2617,7 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  */
 static inline void update_sg_lb_stats(struct sched_domain *sd,
 			struct sched_group *group, int this_cpu,
-			enum cpu_idle_type idle, int load_idx, int *sd_idle,
+			enum cpu_idle_type idle, int load_idx,
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
 {
@@ -2638,9 +2637,6 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
 		struct rq *rq = cpu_rq(i);
 
-		if (*sd_idle && rq->nr_running)
-			*sd_idle = 0;
-
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
 			if (idle_cpu(i) && !first_idle_cpu) {
@@ -2755,15 +2751,13 @@ static bool update_sd_pick_busiest(struct sched_domain *sd,
  * @sd: sched_domain whose statistics are to be updated.
  * @this_cpu: Cpu for which load balance is currently performed.
  * @idle: Idle status of this_cpu
- * @sd_idle: Idle status of the sched_domain containing sg.
  * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
  */
 static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
-			enum cpu_idle_type idle, int *sd_idle,
-			const struct cpumask *cpus, int *balance,
-			struct sd_lb_stats *sds)
+			enum cpu_idle_type idle, const struct cpumask *cpus,
+			int *balance, struct sd_lb_stats *sds)
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *sg = sd->groups;
@@ -2781,7 +2775,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 
 		local_group = cpumask_test_cpu(this_cpu, sched_group_cpus(sg));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(sd, sg, this_cpu, idle, load_idx, sd_idle,
+		update_sg_lb_stats(sd, sg, this_cpu, idle, load_idx,
 				local_group, cpus, balance, &sgs);
 
 		if (local_group && !(*balance))
@@ -3033,7 +3027,6 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
  * @imbalance: Variable which stores amount of weighted load which should
  *		be moved to restore balance/put a group to idle.
  * @idle: The idle status of this_cpu.
- * @sd_idle: The idleness of sd
  * @cpus: The set of CPUs under consideration for load-balancing.
  * @balance: Pointer to a variable indicating if this_cpu
  *	is the appropriate cpu to perform load balancing at this_level.
@@ -3046,7 +3039,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 static struct sched_group *
 find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   int *sd_idle, const struct cpumask *cpus, int *balance)
+		   const struct cpumask *cpus, int *balance)
 {
 	struct sd_lb_stats sds;
 
@@ -3056,8 +3049,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 * Compute the various statistics relavent for load balancing at
 	 * this level.
 	 */
-	update_sd_lb_stats(sd, this_cpu, idle, sd_idle, cpus,
-					balance, &sds);
+	update_sd_lb_stats(sd, this_cpu, idle, cpus, balance, &sds);
 
 	/* Cases where imbalance does not exist from POV of this_cpu */
 	/* 1) this_cpu is not the appropriate cpu to perform load balancing
@@ -3193,7 +3185,7 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 /* Working cpumask for load_balance and load_balance_newidle. */
 static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
 
-static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle,
+static int need_active_balance(struct sched_domain *sd, int idle,
 			       int busiest_cpu, int this_cpu)
 {
 	if (idle == CPU_NEWLY_IDLE) {
@@ -3225,10 +3217,6 @@ static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle,
 		 * move_tasks() will succeed.  ld_moved will be true and this
 		 * active balance code will not be triggered.
 		 */
-		if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-			return 0;
-
 		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
 			return 0;
 	}
@@ -3246,7 +3234,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *balance)
 {
-	int ld_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
+	int ld_moved, all_pinned = 0, active_balance = 0;
 	struct sched_group *group;
 	unsigned long imbalance;
 	struct rq *busiest;
@@ -3255,20 +3243,10 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 
 	cpumask_copy(cpus, cpu_active_mask);
 
-	/*
-	 * When power savings policy is enabled for the parent domain, idle
-	 * sibling can pick up load irrespective of busy siblings. In this case,
-	 * let the state of idle sibling percolate up as CPU_IDLE, instead of
-	 * portraying it as CPU_NOT_IDLE.
-	 */
-	if (idle != CPU_NOT_IDLE && sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		sd_idle = 1;
-
 	schedstat_inc(sd, lb_count[idle]);
 
 redo:
-	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
+	group = find_busiest_group(sd, this_cpu, &imbalance, idle,
 				   cpus, balance);
 
 	if (*balance == 0)
@@ -3330,8 +3308,7 @@ redo:
 		if (idle != CPU_NEWLY_IDLE)
 			sd->nr_balance_failed++;
 
-		if (need_active_balance(sd, sd_idle, idle, cpu_of(busiest),
-					this_cpu)) {
+		if (need_active_balance(sd, idle, cpu_of(busiest), this_cpu)) {
 			raw_spin_lock_irqsave(&busiest->lock, flags);
 
 			/* don't kick the active_load_balance_cpu_stop,
@@ -3386,10 +3363,6 @@ redo:
 			sd->balance_interval *= 2;
 	}
 
-	if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		ld_moved = -1;
-
 	goto out;
 
 out_balanced:
@@ -3403,11 +3376,7 @@ out_one_pinned:
 			(sd->balance_interval < sd->max_interval))
 		sd->balance_interval *= 2;
 
-	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		ld_moved = -1;
-	else
-		ld_moved = 0;
+	ld_moved = 0;
 out:
 	return ld_moved;
 }
-- 
1.7.3.1

