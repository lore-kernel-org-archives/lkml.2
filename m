Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab2JYKbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:31:32 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58205 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab2JYKbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:31:31 -0400
Subject: [RFC PATCH 01/13] sched:Prevent movement of short running tasks
 during load balancing
To: svaidy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: mingo@kernel.org, venki@google.com, robin.randhawa@arm.com,
        linaro-dev@lists.linaro.org, a.p.zijlstra@chello.nl,
        mjg59@srcf.ucam.org, viresh.kumar@linaro.org,
        akpm@linux-foundation.org, amit.kucheria@linaro.org,
        deepthi@linux.vnet.ibm.com, paul.mckenney@linaro.org,
        arjan@linux.intel.com, paulmck@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        tglx@linutronix.de, Arvind.Chauhan@arm.com, pjt@google.com,
        Morten.Rasmussen@arm.com, linux-arm-kernel@lists.infradead.org,
        suresh.b.siddha@intel.com
Date: Thu, 25 Oct 2012 15:54:52 +0530
Message-ID: <20121025102452.21022.70635.stgit@preeti.in.ibm.com>
In-Reply-To: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12102510-0260-0000-0000-000002091570
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
index dbddcf6..e02dad4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4188,6 +4188,7 @@ struct sd_lb_stats {
  */
 struct sg_lb_stats {
 	unsigned long avg_load; /*Avg load across the CPUs of the group */
+	u64 avg_cfs_runnable_load; /* Equivalent of avg_load but calculated using PJT's metric */
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

