Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab2JYK0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:26:01 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:47263 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab2JYK0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:26:00 -0400
Subject: [RFC PATCH 04/13] sched:Decide group_imb using PJT's metric
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
Date: Thu, 25 Oct 2012 15:55:27 +0530
Message-ID: <20121025102526.21022.64324.stgit@preeti.in.ibm.com>
In-Reply-To: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12102510-4790-0000-0000-0000053C9438
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additional parameters for deciding a sched group's imbalance status
which are calculated using the per entity load tracking are used.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 67a916d..77363c6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3748,6 +3748,7 @@ struct lb_env {
 	int			new_dst_cpu;
 	enum cpu_idle_type	idle;
 	long			imbalance;
+	long long               load_imbalance; /* PJT metric equivalent of imbalance */
 	/* The set of CPUs under consideration for load-balancing */
 	struct cpumask		*cpus;
 
@@ -4513,6 +4514,11 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	unsigned long load, max_cpu_load, min_cpu_load;
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
+
+	/* Decide imb based on PJT's metric */
+	u64 cpu_runnable_load, max_cpu_runnable_load, min_cpu_runnable_load;
+	u64 avg_sg_load_per_task = 0;
+
 	int i;
 
 	if (local_group)
@@ -4521,6 +4527,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	/* Tally up the load of all CPUs in the group */
 	max_cpu_load = 0;
 	min_cpu_load = ~0UL;
+	max_cpu_runnable_load = 0;
+	min_cpu_runnable_load = ~0ULL;
 	max_nr_running = 0;
 	min_nr_running = ~0UL;
 
@@ -4545,6 +4553,12 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			if (min_cpu_load > load)
 				min_cpu_load = load;
 
+			cpu_runnable_load = cpu_rq(i)->cfs.runnable_load_avg;
+			if (cpu_runnable_load > max_cpu_runnable_load)
+				max_cpu_runnable_load = cpu_runnable_load;
+			if (min_cpu_runnable_load > cpu_runnable_load)
+				min_cpu_runnable_load = cpu_runnable_load;
+
 			if (nr_running > max_nr_running)
 				max_nr_running = nr_running;
 			if (min_nr_running > nr_running)
@@ -4604,10 +4618,13 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	 *      normalized nr_running number somewhere that negates
 	 *      the hierarchy?
 	 */
-	if (sgs->sum_nr_running)
+	if (sgs->sum_nr_running) {
 		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
+		avg_sg_load_per_task = sgs->group_cfs_runnable_load / sgs->sum_nr_running;
+	}
 
-	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task &&
+	/* The following decision is made on PJT's metric */
+	if ((max_cpu_runnable_load - min_cpu_runnable_load) >= avg_sg_load_per_task &&
 	    (max_nr_running - min_nr_running) > 1)
 		sgs->group_imb = 1;
 
@@ -5047,6 +5064,7 @@ out_balanced:
 
 ret:
 	env->imbalance = 0;
+	env->load_imbalance = 0;
 	return NULL;
 }
 

