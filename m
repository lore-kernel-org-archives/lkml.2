Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab1BJMZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:25:29 -0500
Received: from cantor.suse.de ([195.135.220.2]:33797 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab1BJMZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:25:27 -0500
From: stable-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 10 Feb 2011 10:23:28 +0100
Subject: [PATCH 24/28] sched: Use group weight, idle cpu metrics to fix
 imbalances during idle
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340644.5512.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: aae6d3ddd8b90f5b2c8d79a2b914d1706d124193 upstream
Author: Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri Sep 17 15:02:32 2010 -0700

Currently we consider a sched domain to be well balanced when the imbalance
is less than the domain's imablance_pct. As the number of cores and threads
are increasing, current values of imbalance_pct (for example 25% for a
NUMA domain) are not enough to detect imbalances like:

a) On a WSM-EP system (two sockets, each having 6 cores and 12 logical threads),
24 cpu-hogging tasks get scheduled as 13 on one socket and 11 on another
socket. Leading to an idle HT cpu.

b) On a hypothetial 2 socket NHM-EX system (each socket having 8 cores and
16 logical threads), 16 cpu-hogging tasks can get scheduled as 9 on one
socket and 7 on another socket. Leaving one core in a socket idle
whereas in another socket we have a core having both its HT siblings busy.

While this issue can be fixed by decreasing the domain's imbalance_pct
(by making it a function of number of logical cpus in the domain), it
can potentially cause more task migrations across sched groups in an
overloaded case.

Fix this by using imbalance_pct only during newly_idle and busy
load balancing. And during idle load balancing, check if there
is an imbalance in number of idle cpu's across the busiest and this
sched_group or if the busiest group has more tasks than its weight that
the idle cpu in this_group can pull.

Reported-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1284760952.2676.11.camel@sbsiddha-MOBL3.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   36 +++++++++++++++++++++++++++++++++---
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4c9c426..71849bf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -894,6 +894,7 @@ struct sched_group {
 	 * single CPU.
 	 */
 	unsigned int cpu_power;
+	unsigned int group_weight;
 
 	/*
 	 * The CPUs this group covers.
diff --git a/kernel/sched.c b/kernel/sched.c
index d8a2155..590d73b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3534,13 +3534,16 @@ struct sd_lb_stats {
 	unsigned long this_load_per_task;
 	unsigned long this_nr_running;
 	unsigned long this_has_capacity;
+	unsigned int  this_idle_cpus;
 
 	/* Statistics of the busiest group */
+	unsigned int  busiest_idle_cpus;
 	unsigned long max_load;
 	unsigned long busiest_load_per_task;
 	unsigned long busiest_nr_running;
 	unsigned long busiest_group_capacity;
 	unsigned long busiest_has_capacity;
+	unsigned int  busiest_group_weight;
 
 	int group_imb; /* Is there imbalance in this sd */
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -3562,6 +3565,8 @@ struct sg_lb_stats {
 	unsigned long sum_nr_running; /* Nr tasks running in the group */
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long group_capacity;
+	unsigned long idle_cpus;
+	unsigned long group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
 };
@@ -3905,7 +3910,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->nr_running;
 		sgs->sum_weighted_load += weighted_cpuload(i);
-
+		if (idle_cpu(i))
+			sgs->idle_cpus++;
 	}
 
 	/*
@@ -3939,6 +3945,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		sgs->group_imb = 1;
 
 	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
+	sgs->group_weight = group->group_weight;
 
 	if (sgs->group_capacity > sgs->sum_nr_running)
 		sgs->group_has_capacity = 1;
@@ -4004,13 +4011,16 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			sds->this_nr_running = sgs.sum_nr_running;
 			sds->this_load_per_task = sgs.sum_weighted_load;
 			sds->this_has_capacity = sgs.group_has_capacity;
+			sds->this_idle_cpus = sgs.idle_cpus;
 		} else if (sgs.avg_load > sds->max_load &&
 			   (sgs.sum_nr_running > sgs.group_capacity ||
 				sgs.group_imb)) {
 			sds->max_load = sgs.avg_load;
 			sds->busiest = group;
 			sds->busiest_nr_running = sgs.sum_nr_running;
+			sds->busiest_idle_cpus = sgs.idle_cpus;
 			sds->busiest_group_capacity = sgs.group_capacity;
+			sds->busiest_group_weight = sgs.group_weight;
 			sds->busiest_load_per_task = sgs.sum_weighted_load;
 			sds->busiest_has_capacity = sgs.group_has_capacity;
 			sds->group_imb = sgs.group_imb;
@@ -4235,8 +4245,26 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (sds.this_load >= sds.avg_load)
 		goto out_balanced;
 
-	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
-		goto out_balanced;
+	/*
+	 * In the CPU_NEWLY_IDLE, use imbalance_pct to be conservative.
+	 * And to check for busy balance use !idle_cpu instead of
+	 * CPU_NOT_IDLE. This is because HT siblings will use CPU_NOT_IDLE
+	 * even when they are idle.
+	 */
+	if (idle == CPU_NEWLY_IDLE || !idle_cpu(this_cpu)) {
+		if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
+			goto out_balanced;
+	} else {
+		/*
+		 * This cpu is idle. If the busiest group load doesn't
+		 * have more tasks than the number of available cpu's and
+		 * there is no imbalance between this and busiest group
+		 * wrt to idle cpu's, it is balanced.
+		 */
+		if ((sds.this_idle_cpus  <= sds.busiest_idle_cpus + 1) &&
+		    sds.busiest_nr_running <= sds.busiest_group_weight)
+			goto out_balanced;
+	}
 
 force_balance:
 	/* Looks like there is an imbalance. Compute it */
@@ -8751,6 +8779,8 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 	if (cpu != group_first_cpu(sd->groups))
 		return;
 
+	sd->groups->group_weight = cpumask_weight(sched_group_cpus(sd->groups));
+
 	child = sd->child;
 
 	sd->groups->cpu_power = 0;
-- 
1.7.4


