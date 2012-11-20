Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2KTEmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:42:36 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:44946 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2KTEmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:42:35 -0500
Message-ID: <50AB0A0F.8070802@linux.vnet.ibm.com>
Date: Tue, 20 Nov 2012 10:11:51 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        a.p.zijlstra@chello.nl, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        Morten.Rasmussen@arm.com, paul.mckenney@linaro.org,
        akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org, pjt@google.com
CC: venki@google.com, robin.randhawa@arm.com, linaro-dev@lists.linaro.org,
        suresh.b.siddha@intel.com, mjg59@srcf.ucam.org,
        deepthi@linux.vnet.ibm.com, srivatsa.bhat@linux.vnet.ibm.com,
        Arvind.Chauhan@arm.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] sched: Explicit division calls on 64-bit integers
References: <20121115164730.17426.36051.stgit@preeti.in.ibm.com>
In-Reply-To: <20121115164730.17426.36051.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12112004-1396-0000-0000-0000022FD7C3
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000295; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00192853; UDB=6.00043698; UTC=2012-11-20
 04:40:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain gcc tool chains convert the division on a 64-bit dividend into a
__aeabi_uldivmod call which does unnecessary 64-bit by 64-bit divides
although the divisor is 32-bit.This 64 by 64 bit division is not implemented
in the kernel for reasons of efficiency,which results in undefined reference
errors during link time.Hence perform the division on 64-bit dividends
using do_div() function.
The below use case is the integration of Per-entity-Load-Tracking
metric with the load balancer,where cfs_rq->runnable_load_avg,
a 64 bit unsigned integer is used to as the base metric for load balancing.

Signed-off-by: Preeti U Murthy<preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   51 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f8f3a29..7cd3096 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2982,9 +2982,13 @@ static u64 cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
+	u64 cfs_avg_load_per_task;
 
-	if (nr_running)
-		return rq->cfs.runnable_load_avg / nr_running;
+	if (nr_running) {
+		cfs_avg_load_per_task = rq->cfs.runnable_load_avg;
+		do_div(cfs_avg_load_per_task, nr_running);
+		return cfs_avg_load_per_task;
+	}
 
 	return 0;
 }
@@ -3249,7 +3253,8 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		}
 
 		/* Adjust by relative CPU power of the group */
-		avg_load = (avg_load * SCHED_POWER_SCALE) / group->sgp->power;
+		avg_load = (avg_load * SCHED_POWER_SCALE);
+		do_div(avg_load, group->sgp->power);
 
 		if (local_group) {
 			this_load = avg_load;
@@ -4756,7 +4761,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	}
 
 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->sgp->power;
+	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE);
+	do_div(sgs->avg_load, group->sgp->power);
 
 	/*
 	 * Consider the group unbalanced when the imbalance is larger
@@ -4767,8 +4773,10 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	 *      normalized nr_running number somewhere that negates
 	 *      the hierarchy?
 	 */
-	if (sgs->sum_nr_running)
-		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
+	if (sgs->sum_nr_running) {
+		avg_load_per_task = sgs->sum_weighted_load;
+		do_div(avg_load_per_task, sgs->sum_nr_running);
+	}
 
 	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task &&
 	    (max_nr_running - min_nr_running) > 1)
@@ -4953,7 +4961,7 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	u64 scaled_busy_load_per_task;
 
 	if (sds->this_nr_running) {
-		sds->this_load_per_task /= sds->this_nr_running;
+		do_div(sds->this_load_per_task, sds->this_nr_running);
 		if (sds->busiest_load_per_task >
 				sds->this_load_per_task)
 			imbn = 1;
@@ -4964,7 +4972,7 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 
 	scaled_busy_load_per_task = sds->busiest_load_per_task
 					 * SCHED_POWER_SCALE;
-	scaled_busy_load_per_task /= sds->busiest->sgp->power;
+	do_div(scaled_busy_load_per_task, sds->busiest->sgp->power);
 
 	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
 			(scaled_busy_load_per_task * imbn)) {
@@ -4985,20 +4993,21 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	pwr_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
-	tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
-		sds->busiest->sgp->power;
+	tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE);
+	do_div(tmp, sds->busiest->sgp->power);
 	if (sds->max_load > tmp)
 		pwr_move += sds->busiest->sgp->power *
 			min(sds->busiest_load_per_task, sds->max_load - tmp);
 
 	/* Amount of load we'd add */
 	if (sds->max_load * sds->busiest->sgp->power <
-		sds->busiest_load_per_task * SCHED_POWER_SCALE)
-		tmp = (sds->max_load * sds->busiest->sgp->power) /
-			sds->this->sgp->power;
-	else
-		tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
-			sds->this->sgp->power;
+		sds->busiest_load_per_task * SCHED_POWER_SCALE) {
+		tmp = (sds->max_load * sds->busiest->sgp->power);
+		do_div(tmp, sds->this->sgp->power);
+	} else {
+		tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE);
+		do_div(tmp, sds->this->sgp->power);
+	}
 	pwr_move += sds->this->sgp->power *
 			min(sds->this_load_per_task, sds->this_load + tmp);
 	pwr_move /= SCHED_POWER_SCALE;
@@ -5018,7 +5027,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 {
 	u64 max_pull, load_above_capacity = ~0ULL;
 
-	sds->busiest_load_per_task /= sds->busiest_nr_running;
+	do_div(sds->busiest_load_per_task, sds->busiest_nr_running);
 	if (sds->group_imb) {
 		sds->busiest_load_per_task =
 			min(sds->busiest_load_per_task, sds->avg_load);
@@ -5043,7 +5052,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 
 		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
 
-		load_above_capacity /= sds->busiest->sgp->power;
+		do_div(load_above_capacity, sds->busiest->sgp->power);
 	}
 
 	/*
@@ -5123,7 +5132,8 @@ find_busiest_group(struct lb_env *env, int *balance)
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto ret;
 
-	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
+	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load);
+	do_div(sds.avg_load, sds.total_pwr);
 
 	/*
 	 * If the busiest group is imbalanced the below checks don't
@@ -5223,7 +5233,8 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * the load can be moved away from the cpu that is potentially
 		 * running at a lower capacity.
 		 */
-		wl = (wl * SCHED_POWER_SCALE) / power;
+		wl = (wl * SCHED_POWER_SCALE);
+		do_div(wl, power);
 
 		if (wl > max_load) {
 			max_load = wl;


