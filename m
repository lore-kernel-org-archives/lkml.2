Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab1BJM32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:29:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab1BJMY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:24:57 -0500
From: stable-bot for Nikhil Rao <ncrao@google.com>
Date: Thu, 10 Feb 2011 10:23:25 +0100
Subject: [PATCH 11/28] sched: Force balancing on newidle balance if local
 group has capacity
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340643.5512.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: fab476228ba37907ad75216d0fd9732ada9c119e upstream
Author: Nikhil Rao <ncrao@google.com>
AuthorDate: Fri Oct 15 13:12:29 2010 -0700

This patch forces a load balance on a newly idle cpu when the local group has
extra capacity and the busiest group does not have any. It improves system
utilization when balancing tasks with a large weight differential.

Under certain situations, such as a niced down task (i.e. nice = -15) in the
presence of nr_cpus NICE0 tasks, the niced task lands on a sched group and
kicks away other tasks because of its large weight. This leads to sub-optimal
utilization of the machine. Even though the sched group has capacity, it does
not pull tasks because sds.this_load >> sds.max_load, and f_b_g() returns NULL.

With this patch, if the local group has extra capacity, we shortcut the checks
in f_b_g() and try to pull a task over. A sched group has extra capacity if the
group capacity is greater than the number of running tasks in that group.

Thanks to Mike Galbraith for discussions leading to this patch and for the
insight to reuse SD_NEWIDLE_BALANCE.

Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1287173550-30365-4-git-send-email-ncrao@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d985956..f33788b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3208,6 +3208,10 @@ static void pull_task(struct rq *src_rq, struct task_struct *p,
 	set_task_cpu(p, this_cpu);
 	activate_task(this_rq, p, 0);
 	check_preempt_curr(this_rq, p, 0);
+
+	/* re-arm NEWIDLE balancing when moving tasks */
+	src_rq->avg_idle = this_rq->avg_idle = 2*sysctl_sched_migration_cost;
+	this_rq->idle_stamp = 0;
 }
 
 /*
@@ -3425,12 +3429,14 @@ struct sd_lb_stats {
 	unsigned long this_load;
 	unsigned long this_load_per_task;
 	unsigned long this_nr_running;
+	unsigned long this_has_capacity;
 
 	/* Statistics of the busiest group */
 	unsigned long max_load;
 	unsigned long busiest_load_per_task;
 	unsigned long busiest_nr_running;
 	unsigned long busiest_group_capacity;
+	unsigned long busiest_has_capacity;
 
 	int group_imb; /* Is there imbalance in this sd */
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -3453,6 +3459,7 @@ struct sg_lb_stats {
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long group_capacity;
 	int group_imb; /* Is there an imbalance in the group ? */
+	int group_has_capacity; /* Is there extra capacity in the group? */
 };
 
 /**
@@ -3822,6 +3829,9 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		sgs->group_imb = 1;
 
 	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
+
+	if (sgs->group_capacity > sgs->sum_nr_running)
+		sgs->group_has_capacity = 1;
 }
 
 /**
@@ -3878,6 +3888,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			sds->this = group;
 			sds->this_nr_running = sgs.sum_nr_running;
 			sds->this_load_per_task = sgs.sum_weighted_load;
+			sds->this_has_capacity = sgs.group_has_capacity;
 		} else if (sgs.avg_load > sds->max_load &&
 			   (sgs.sum_nr_running > sgs.group_capacity ||
 				sgs.group_imb)) {
@@ -3886,6 +3897,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			sds->busiest_nr_running = sgs.sum_nr_running;
 			sds->busiest_group_capacity = sgs.group_capacity;
 			sds->busiest_load_per_task = sgs.sum_weighted_load;
+			sds->busiest_has_capacity = sgs.group_has_capacity;
 			sds->group_imb = sgs.group_imb;
 		}
 
@@ -4031,6 +4043,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 		return fix_small_imbalance(sds, this_cpu, imbalance);
 
 }
+
 /******* find_busiest_group() helpers end here *********************/
 
 /**
@@ -4082,6 +4095,11 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 * 4) This group is more busy than the avg busieness at this
 	 *    sched_domain.
 	 * 5) The imbalance is within the specified limit.
+	 *
+	 * Note: when doing newidle balance, if the local group has excess
+	 * capacity (i.e. nr_running < group_capacity) and the busiest group
+	 * does not have any capacity, we force a load balance to pull tasks
+	 * to the local group. In this case, we skip past checks 3, 4 and 5.
 	 */
 	if (balance && !(*balance))
 		goto ret;
@@ -4089,6 +4107,11 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
+	/*  SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
+	if (idle == CPU_NEWLY_IDLE && sds.this_has_capacity &&
+			!sds.busiest_has_capacity)
+		goto force_balance;
+
 	if (sds.this_load >= sds.max_load)
 		goto out_balanced;
 
@@ -4100,6 +4123,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
 		goto out_balanced;
 
+force_balance:
 	/* Looks like there is an imbalance. Compute it */
 	calculate_imbalance(&sds, this_cpu, imbalance);
 	return sds.busiest;
@@ -4515,10 +4539,8 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task) {
-			this_rq->idle_stamp = 0;
+		if (pulled_task)
 			break;
-		}
 	}
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
-- 
1.7.4


