Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab2JLEvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 00:51:07 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60681 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab2JLEvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 00:51:02 -0400
Subject: [RFC PATCH 1/2] sched:Prevent movement of short running tasks
 during load balancing
To: linux-kernel@vger.kernel.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: peterz@infradead.org, svaidy@linux.vnet.ibm.com, pjt@google.com
Date: Fri, 12 Oct 2012 10:20:41 +0530
Message-ID: <20121012045041.18271.43770.stgit@preeti.in.ibm.com>
In-Reply-To: <20121012044618.18271.88332.stgit@preeti.in.ibm.com>
References: <20121012044618.18271.88332.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12101204-8256-0000-0000-0000048CE31A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent sched groups with low load as tracked by PJT's metrics
from being candidates of the load balance routine.This metric is chosen to be
1024+15%*1024.But using PJT's metrics it has been observed that even when
three 10% tasks are running,the load sometimes does not exceed this
threshold.The call should be taken if the tasks can afford to be throttled.

This is why an additional metric has been included,which can determine how
long we can tolerate tasks not being moved even if the load is low.

Signed-off-by:  Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dbddcf6..dd0fb28 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4188,6 +4188,7 @@ struct sd_lb_stats {
  */
 struct sg_lb_stats {
 	unsigned long avg_load; /*Avg load across the CPUs of the group */
+	u64 avg_cfs_runnable_load; /* Equivalent of avg_load but calculated using pjt's metric */
 	unsigned long group_load; /* Total load over the CPUs of the group */
 	unsigned long sum_nr_running; /* Nr tasks running in the group */
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
@@ -4504,6 +4505,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	unsigned long load, max_cpu_load, min_cpu_load;
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
+	u64 group_load = 0; /* computed using PJT's metric */
 	int i;
 
 	if (local_group)
@@ -4548,6 +4550,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		if (idle_cpu(i))
 			sgs->idle_cpus++;
 
+		group_load += cpu_rq(i)->cfs.runnable_load_avg;
 		update_sg_numa_stats(sgs, rq);
 	}
 
@@ -4572,6 +4575,19 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->sgp->power;
 
 	/*
+	 * Check if the sched group has not crossed the threshold.
+	 *
+	 * Also check if the sched_group although being within the threshold,is not
+	 * queueing too many tasks.If yes to both,then make it an
+	 * invalid candidate for load balancing
+	 *
+	 * The below condition is included as a tunable to meet performance and power needs
+	 */
+	sgs->avg_cfs_runnable_load = (group_load * SCHED_POWER_SCALE) / group->sgp->power;
+	if (sgs->avg_cfs_runnable_load <= 1178 && sgs->sum_nr_running <= 2)
+		sgs->avg_cfs_runnable_load = 0;
+
+	/*
 	 * Consider the group unbalanced when the imbalance is larger
 	 * than the average weight of a task.
 	 *

