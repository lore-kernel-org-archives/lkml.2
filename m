Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0IQWCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:02:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:54909 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab0IQWCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:02:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,384,1280732400"; 
   d="scan'208";a="555619246"
Subject: [patch] sched: use group weight, idle cpu metrics to fix
 imbalances during idle
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Nikhil Rao <ncrao@google.com>,
        Venkatesh Pallipadi <venki@google.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 17 Sep 2010 15:02:32 -0700
Message-Id: <1284760952.2676.11.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

 include/linux/sched.h |    1 +
 kernel/sched.c        |    2 ++
 kernel/sched_fair.c   |   34 +++++++++++++++++++++++++++++++---
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1e2a6db..acc589c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -852,6 +852,7 @@ struct sched_group {
 	 * single CPU.
 	 */
 	unsigned int cpu_power, cpu_power_orig;
+	unsigned int group_weight;
 
 	/*
 	 * The CPUs this group covers.
diff --git a/kernel/sched.c b/kernel/sched.c
index ed09d4f..d12f66b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6790,6 +6790,8 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 	if (cpu != group_first_cpu(sd->groups))
 		return;
 
+	sd->groups->group_weight = cpumask_weight(sched_group_cpus(sd->groups));
+
 	child = sd->child;
 
 	sd->groups->cpu_power = 0;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a171138..a17a2f0 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2030,12 +2030,15 @@ struct sd_lb_stats {
 	unsigned long this_load;
 	unsigned long this_load_per_task;
 	unsigned long this_nr_running;
+	unsigned int  this_idle_cpus;
 
 	/* Statistics of the busiest group */
+	unsigned int  busiest_idle_cpus;
 	unsigned long max_load;
 	unsigned long busiest_load_per_task;
 	unsigned long busiest_nr_running;
 	unsigned long busiest_group_capacity;
+	unsigned int  busiest_group_weight;
 
 	int group_imb; /* Is there imbalance in this sd */
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -2057,6 +2060,8 @@ struct sg_lb_stats {
 	unsigned long sum_nr_running; /* Nr tasks running in the group */
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long group_capacity;
+	unsigned long idle_cpus;
+	unsigned long group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
 };
 
@@ -2415,7 +2420,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->nr_running;
 		sgs->sum_weighted_load += weighted_cpuload(i);
-
+		if (idle_cpu(i))
+			sgs->idle_cpus++;
 	}
 
 	/*
@@ -2454,6 +2460,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(sd, group);
+	sgs->group_weight = group->group_weight;
 }
 
 /**
@@ -2552,12 +2559,15 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			sds->this = sg;
 			sds->this_nr_running = sgs.sum_nr_running;
 			sds->this_load_per_task = sgs.sum_weighted_load;
+			sds->this_idle_cpus = sgs.idle_cpus;
 		} else if (update_sd_pick_busiest(sd, sds, sg, &sgs, this_cpu)) {
 			sds->max_load = sgs.avg_load;
 			sds->busiest = sg;
 			sds->busiest_nr_running = sgs.sum_nr_running;
+			sds->busiest_idle_cpus = sgs.idle_cpus;
 			sds->busiest_group_capacity = sgs.group_capacity;
 			sds->busiest_load_per_task = sgs.sum_weighted_load;
+			sds->busiest_group_weight = sgs.group_weight;
 			sds->group_imb = sgs.group_imb;
 		}
 
@@ -2824,8 +2834,26 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (sds.this_load >= sds.avg_load)
 		goto out_balanced;
 
-	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
-		goto out_balanced;
+	/*
+ 	 * In the CPU_NEWLY_IDLE, use imbalance_pct to be conservative.
+ 	 * And to check for busy balance use !idle_cpu instead of
+ 	 * CPU_NOT_IDLE. This is because HT siblings will use CPU_NOT_IDLE
+ 	 * even when they are idle.
+ 	 */
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
 
 	/* Looks like there is an imbalance. Compute it */
 	calculate_imbalance(&sds, this_cpu, imbalance);


