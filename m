Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab1C3Vt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:49:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:48759 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933464Ab1C3VH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133224"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: suresh.b.siddha@intel.com, a.p.zijlstra@chello.nl, ak@linux.intel.com,
        mingo@elte.hu, efault@gmx.de, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [108/275] sched: Use group weight, idle cpu metrics to fix imbalances during idle
Message-Id: <20110330210547.5D3CF3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Commit: aae6d3ddd8b90f5b2c8d79a2b914d1706d124193 upstream

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1284760952.2676.11.camel@sbsiddha-MOBL3.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |    2 ++
 kernel/sched_fair.c   |   34 +++++++++++++++++++++++++++++++---
 3 files changed, 34 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/include/linux/sched.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/sched.h	2011-03-29 23:03:00.410289673 -0700
+++ linux-2.6.35.y/include/linux/sched.h	2011-03-29 23:03:00.437288981 -0700
@@ -856,6 +856,7 @@
 	 * single CPU.
 	 */
 	unsigned int cpu_power;
+	unsigned int group_weight;
 
 	/*
 	 * The CPUs this group covers.
Index: linux-2.6.35.y/kernel/sched_fair.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched_fair.c	2011-03-29 23:03:00.417289492 -0700
+++ linux-2.6.35.y/kernel/sched_fair.c	2011-03-29 23:03:00.439288931 -0700
@@ -2036,13 +2036,16 @@
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
@@ -2064,6 +2067,8 @@
 	unsigned long sum_nr_running; /* Nr tasks running in the group */
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long group_capacity;
+	unsigned long idle_cpus;
+	unsigned long group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
 };
@@ -2404,7 +2409,8 @@
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->nr_running;
 		sgs->sum_weighted_load += weighted_cpuload(i);
-
+		if (idle_cpu(i))
+			sgs->idle_cpus++;
 	}
 
 	/*
@@ -2440,6 +2446,7 @@
 		sgs->group_imb = 1;
 
 	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
+	sgs->group_weight = group->group_weight;
 
 	if (sgs->group_capacity > sgs->sum_nr_running)
 		sgs->group_has_capacity = 1;
@@ -2505,13 +2512,16 @@
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
@@ -2736,8 +2746,26 @@
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
Index: linux-2.6.35.y/kernel/sched.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched.c	2011-03-29 23:03:00.413289595 -0700
+++ linux-2.6.35.y/kernel/sched.c	2011-03-29 23:54:17.695549641 -0700
@@ -6839,6 +6839,8 @@
 	if (cpu != group_first_cpu(sd->groups))
 		return;
 
+	sd->groups->group_weight = cpumask_weight(sched_group_cpus(sd->groups));
+
 	child = sd->child;
 
 	sd->groups->cpu_power = 0;
