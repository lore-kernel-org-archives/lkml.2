Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab0JOUMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:12:54 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37021 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572Ab0JOUMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:12:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=Gk8VAi1DtQj+SOxIsACi5vTPqRnMv+xcc8/uIRimpHCbp1jOEAX6nADvoo3gqjR8P
	mmsAxCHCC/NoRB7o4wk2g==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH 3/4] sched: force balancing on newidle balance if local group has capacity
Date: Fri, 15 Oct 2010 13:12:29 -0700
Message-Id: <1287173550-30365-4-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287173550-30365-1-git-send-email-ncrao@google.com>
References: <1287173550-30365-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/sched_fair.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0dd1021..7d8ed95 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1764,6 +1764,10 @@ static void pull_task(struct rq *src_rq, struct task_struct *p,
 	set_task_cpu(p, this_cpu);
 	activate_task(this_rq, p, 0);
 	check_preempt_curr(this_rq, p, 0);
+
+	/* re-arm NEWIDLE balancing when moving tasks */
+	src_rq->avg_idle = this_rq->avg_idle = 2*sysctl_sched_migration_cost;
+	this_rq->idle_stamp = 0;
 }
 
 /*
@@ -2030,12 +2034,14 @@ struct sd_lb_stats {
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
@@ -2058,6 +2064,7 @@ struct sg_lb_stats {
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long group_capacity;
 	int group_imb; /* Is there an imbalance in the group ? */
+	int group_has_capacity; /* Is there extra capacity in the group? */
 };
 
 /**
@@ -2458,6 +2465,9 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(sd, group);
+
+	if (sgs->group_capacity > sgs->sum_nr_running)
+		sgs->group_has_capacity = 1;
 }
 
 /**
@@ -2556,12 +2566,14 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			sds->this = sg;
 			sds->this_nr_running = sgs.sum_nr_running;
 			sds->this_load_per_task = sgs.sum_weighted_load;
+			sds->this_has_capacity = sgs.group_has_capacity;
 		} else if (update_sd_pick_busiest(sd, sds, sg, &sgs, this_cpu)) {
 			sds->max_load = sgs.avg_load;
 			sds->busiest = sg;
 			sds->busiest_nr_running = sgs.sum_nr_running;
 			sds->busiest_group_capacity = sgs.group_capacity;
 			sds->busiest_load_per_task = sgs.sum_weighted_load;
+			sds->busiest_has_capacity = sgs.group_has_capacity;
 			sds->group_imb = sgs.group_imb;
 		}
 
@@ -2758,6 +2770,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 		return fix_small_imbalance(sds, this_cpu, imbalance);
 
 }
+
 /******* find_busiest_group() helpers end here *********************/
 
 /**
@@ -2809,6 +2822,11 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 * 4) This group is more busy than the avg busieness at this
 	 *    sched_domain.
 	 * 5) The imbalance is within the specified limit.
+	 *
+	 * Note: when doing newidle balance, if the local group has excess
+	 * capacity (i.e. nr_running < group_capacity) and the busiest group
+	 * does not have any capacity, we force a load balance to pull tasks
+	 * to the local group. In this case, we skip past checks 3, 4 and 5.
 	 */
 	if (!(*balance))
 		goto ret;
@@ -2820,6 +2838,11 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
+	/*  SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
+	if (idle == CPU_NEWLY_IDLE && sds.this_has_capacity &&
+			!sds.busiest_has_capacity)
+		goto force_balance;
+
 	if (sds.this_load >= sds.max_load)
 		goto out_balanced;
 
@@ -2831,6 +2854,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
 		goto out_balanced;
 
+force_balance:
 	/* Looks like there is an imbalance. Compute it */
 	calculate_imbalance(&sds, this_cpu, imbalance);
 	return sds.busiest;
@@ -3157,10 +3181,8 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task) {
-			this_rq->idle_stamp = 0;
+		if (pulled_task)
 			break;
-		}
 	}
 
 	raw_spin_lock(&this_rq->lock);
-- 
1.7.1

