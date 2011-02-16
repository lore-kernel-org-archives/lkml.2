Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab1BPNvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:51:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:52719 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab1BPNvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:51:01 -0500
Date: Wed, 16 Feb 2011 13:50:36 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, venki@google.com,
        svaidy@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, venki@google.com,
        svaidy@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1297723130-693-1-git-send-email-venki@google.com>
References: <1297723130-693-1-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Wholesale removal of sd_idle logic
Message-ID: <tip-46e49b3836c7cd2ae5b5fe76fa981d0d292a52fe@git.kernel.org>
Git-Commit-ID: 46e49b3836c7cd2ae5b5fe76fa981d0d292a52fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 13:50:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46e49b3836c7cd2ae5b5fe76fa981d0d292a52fe
Gitweb:     http://git.kernel.org/tip/46e49b3836c7cd2ae5b5fe76fa981d0d292a52fe
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Mon, 14 Feb 2011 14:38:50 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Feb 2011 13:33:20 +0100

sched: Wholesale removal of sd_idle logic

sd_idle logic was introduced way back in 2005 (commit 5969fe06),
as an HT optimization.

As per the discussion in the thread here:

  lkml - sched: Resolve sd_idle and first_idle_cpu Catch-22 - v1
  https://patchwork.kernel.org/patch/532501/

The capacity based logic in the load balancer right now handles this
in a much cleaner way, handling more than 2 SMT siblings etc, and sd_idle
does not seem to bring any additional benefits. sd_idle logic also has
some bugs that has performance impact. Here is the patch that removes
the sd_idle logic altogether.

Also, there was a dependency of sched_mc_power_savings == 2, with sd_idle
logic.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Acked-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1297723130-693-1-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   53 ++++++++++----------------------------------------
 1 files changed, 11 insertions(+), 42 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0270246..d384e73 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2672,7 +2672,6 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  * @this_cpu: Cpu for which load balance is currently performed.
  * @idle: Idle status of this_cpu
  * @load_idx: Load index of sched_domain of this_cpu for load calc.
- * @sd_idle: Idle status of the sched_domain containing group.
  * @local_group: Does group contain this_cpu.
  * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
@@ -2680,7 +2679,7 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  */
 static inline void update_sg_lb_stats(struct sched_domain *sd,
 			struct sched_group *group, int this_cpu,
-			enum cpu_idle_type idle, int load_idx, int *sd_idle,
+			enum cpu_idle_type idle, int load_idx,
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
 {
@@ -2700,9 +2699,6 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
 		struct rq *rq = cpu_rq(i);
 
-		if (*sd_idle && rq->nr_running)
-			*sd_idle = 0;
-
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
 			if (idle_cpu(i) && !first_idle_cpu) {
@@ -2817,15 +2813,13 @@ static bool update_sd_pick_busiest(struct sched_domain *sd,
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
@@ -2843,7 +2837,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 
 		local_group = cpumask_test_cpu(this_cpu, sched_group_cpus(sg));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(sd, sg, this_cpu, idle, load_idx, sd_idle,
+		update_sg_lb_stats(sd, sg, this_cpu, idle, load_idx,
 				local_group, cpus, balance, &sgs);
 
 		if (local_group && !(*balance))
@@ -3095,7 +3089,6 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
  * @imbalance: Variable which stores amount of weighted load which should
  *		be moved to restore balance/put a group to idle.
  * @idle: The idle status of this_cpu.
- * @sd_idle: The idleness of sd
  * @cpus: The set of CPUs under consideration for load-balancing.
  * @balance: Pointer to a variable indicating if this_cpu
  *	is the appropriate cpu to perform load balancing at this_level.
@@ -3108,7 +3101,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 static struct sched_group *
 find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   int *sd_idle, const struct cpumask *cpus, int *balance)
+		   const struct cpumask *cpus, int *balance)
 {
 	struct sd_lb_stats sds;
 
@@ -3118,8 +3111,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 * Compute the various statistics relavent for load balancing at
 	 * this level.
 	 */
-	update_sd_lb_stats(sd, this_cpu, idle, sd_idle, cpus,
-					balance, &sds);
+	update_sd_lb_stats(sd, this_cpu, idle, cpus, balance, &sds);
 
 	/* Cases where imbalance does not exist from POV of this_cpu */
 	/* 1) this_cpu is not the appropriate cpu to perform load balancing
@@ -3255,7 +3247,7 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 /* Working cpumask for load_balance and load_balance_newidle. */
 static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
 
-static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle,
+static int need_active_balance(struct sched_domain *sd, int idle,
 			       int busiest_cpu, int this_cpu)
 {
 	if (idle == CPU_NEWLY_IDLE) {
@@ -3287,10 +3279,6 @@ static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle,
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
@@ -3308,7 +3296,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *balance)
 {
-	int ld_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
+	int ld_moved, all_pinned = 0, active_balance = 0;
 	struct sched_group *group;
 	unsigned long imbalance;
 	struct rq *busiest;
@@ -3317,20 +3305,10 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 
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
@@ -3392,8 +3370,7 @@ redo:
 		if (idle != CPU_NEWLY_IDLE)
 			sd->nr_balance_failed++;
 
-		if (need_active_balance(sd, sd_idle, idle, cpu_of(busiest),
-					this_cpu)) {
+		if (need_active_balance(sd, idle, cpu_of(busiest), this_cpu)) {
 			raw_spin_lock_irqsave(&busiest->lock, flags);
 
 			/* don't kick the active_load_balance_cpu_stop,
@@ -3448,10 +3425,6 @@ redo:
 			sd->balance_interval *= 2;
 	}
 
-	if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		ld_moved = -1;
-
 	goto out;
 
 out_balanced:
@@ -3465,11 +3438,7 @@ out_one_pinned:
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
