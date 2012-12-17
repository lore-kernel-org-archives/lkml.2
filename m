Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751074Ab2LQDMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 22:12:05 -0500
Received: from mga03.intel.com ([143.182.124.21]:26323 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab2LQDMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 22:12:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,297,1355126400"; 
   d="scan'208";a="232404002"
Message-ID: <50CE8DDB.5080506@intel.com>
Date: Mon, 17 Dec 2012 11:13:31 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>, peterz@infradead.org,
        mingo@kernel.org
CC: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, preeti@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        arjan@linux.intel.com, amit.kucheria@linaro.org,
        viresh.kumar@linaro.org
Subject: Re: [RFC PATCH v2 3/6] sched: pack small tasks
References: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org>  <1355319092-30980-4-git-send-email-vincent.guittot@linaro.org>  <50C93AC1.1060202@intel.com>  <CAKfTPtB9iz1ePsS+juQVRhuWREYB1duGWRJT7ya8XBXPhC-mkw@mail.gmail.com>  <50C9E552.1010600@intel.com> <1355460356.5777.12.camel@marge.simpson.net>
In-Reply-To: <1355460356.5777.12.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> CPU is a bug that slipped into domain degeneration.  You should have
> SIBLING/MC/NUMA (chasing that down is on todo).

Uh, the SD_PREFER_SIBLING on cpu domain is recovered by myself for a share
 memory benchmark regression. But consider all the situations, I think the
 flag is better to be removed.

============
>From 96bee9a03b2048f2686fbd7de0e2aee458dbd917 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Mon, 17 Dec 2012 09:42:57 +0800
Subject: [PATCH 01/18] sched: remove SD_PERFER_SIBLING flag

The flag was introduced in commit b5d978e0c7e79a. Its purpose seems
trying to fullfill one node first in NUMA machine via pulling tasks
from other nodes when the node has capacity.

Its advantage is when few tasks share memories among them, pulling
together is helpful on locality, so has performance gain. The shortage
is it will keep unnecessary task migrations thrashing among different
nodes, that reduces the performance gain, and just hurt performance if
tasks has no memory cross.

Thinking about the sched numa balancing patch is coming. The small
advantage are meaningless to us, So better to remove this flag.

Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h    |  1 -
 include/linux/topology.h |  2 --
 kernel/sched/core.c      |  1 -
 kernel/sched/fair.c      | 19 +------------------
 4 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5dafac3..6dca96c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -836,7 +836,6 @@ enum cpu_idle_type {
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
-#define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 
 extern int __weak arch_sd_sibiling_asym_packing(void);
diff --git a/include/linux/topology.h b/include/linux/topology.h
index d3cf0d6..15864d1 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -100,7 +100,6 @@ int arch_update_cpu_topology(void);
 				| 1*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| 0*SD_PREFER_SIBLING			\
 				| arch_sd_sibling_asym_packing()	\
 				,					\
 	.last_balance		= jiffies,				\
@@ -162,7 +161,6 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| 1*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5dae0d2..8ed2784 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6014,7 +6014,6 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					| 0*SD_SHARE_CPUPOWER
 					| 0*SD_SHARE_PKG_RESOURCES
 					| 1*SD_SERIALIZE
-					| 0*SD_PREFER_SIBLING
 					| sd_local_flags(level)
 					,
 		.last_balance		= jiffies,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 59e072b..5d175f2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4339,13 +4339,9 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 static inline void update_sd_lb_stats(struct lb_env *env,
 					int *balance, struct sd_lb_stats *sds)
 {
-	struct sched_domain *child = env->sd->child;
 	struct sched_group *sg = env->sd->groups;
 	struct sg_lb_stats sgs;
-	int load_idx, prefer_sibling = 0;
-
-	if (child && child->flags & SD_PREFER_SIBLING)
-		prefer_sibling = 1;
+	int load_idx;
 
 	load_idx = get_sd_load_idx(env->sd, env->idle);
 
@@ -4362,19 +4358,6 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 		sds->total_load += sgs.group_load;
 		sds->total_pwr += sg->sgp->power;
 
-		/*
-		 * In case the child domain prefers tasks go to siblings
-		 * first, lower the sg capacity to one so that we'll try
-		 * and move all the excess tasks away. We lower the capacity
-		 * of a group only if the local group has the capacity to fit
-		 * these excess tasks, i.e. nr_running < group_capacity. The
-		 * extra check prevents the case where you always pull from the
-		 * heaviest group when it is already under-utilized (possible
-		 * with a large weight task outweighs the tasks on the system).
-		 */
-		if (prefer_sibling && !local_group && sds->this_has_capacity)
-			sgs.group_capacity = min(sgs.group_capacity, 1UL);
-
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
 			sds->this = sg;
-- 
1.7.12


> 
> -Mike
> 

