Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab2JYK2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:28:52 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:47302 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab2JYK0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:26:05 -0400
Subject: [RFC PATCH 05/13] sched:Calculate imbalance using PJT's metric
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
Date: Thu, 25 Oct 2012 15:55:32 +0530
Message-ID: <20121025102532.21022.18051.stgit@preeti.in.ibm.com>
In-Reply-To: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12102510-4790-0000-0000-0000053C945B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additional parameters which decide the amount of imbalance in the sched domain
calculated using PJT's metric are used.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 77363c6..fca6606 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4892,12 +4892,14 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
  */
 static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
-	unsigned long max_pull, load_above_capacity = ~0UL;
+	/* Additional parameters introduced to use PJT's metric */
+	u64 max_load_pull, load_above_busiest_capacity = ~0ULL;
 
-	sds->busiest_load_per_task /= sds->busiest_nr_running;
+	/* Calculation using PJT's metric */
+	sds->busiest_sg_load_per_task /= sds->busiest_nr_running;
 	if (sds->group_imb) {
-		sds->busiest_load_per_task =
-			min(sds->busiest_load_per_task, sds->avg_load);
+		sds->busiest_sg_load_per_task =
+			min(sds->busiest_sg_load_per_task, sds->avg_sgs_load);
 	}
 
 	/*
@@ -4905,21 +4907,24 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * max load less than avg load(as we skip the groups at or below
 	 * its cpu_power, while calculating max_load..)
 	 */
-	if (sds->max_load < sds->avg_load) {
+	if (sds->max_sg_load < sds->avg_sgs_load) {
 		env->imbalance = 0;
+		env->load_imbalance = 0;
 		return fix_small_imbalance(env, sds);
 	}
 
 	if (!sds->group_imb) {
 		/*
 		 * Don't want to pull so many tasks that a group would go idle.
+		 * Also the below change due to the integration with PJT's
+		 * metric
 		 */
-		load_above_capacity = (sds->busiest_nr_running -
+		load_above_busiest_capacity = (sds->busiest_nr_running -
 						sds->busiest_group_capacity);
 
-		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
+		load_above_busiest_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
 
-		load_above_capacity /= sds->busiest->sgp->power;
+		load_above_busiest_capacity /= sds->busiest->sgp->power;
 	}
 
 	/*
@@ -4932,11 +4937,16 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * Be careful of negative numbers as they'll appear as very large values
 	 * with unsigned longs.
 	 */
-	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
+	/*
+	 * The below maximum load to be pulled is based on the PJT's metric
+ 	 */
+	max_load_pull = min(sds->max_sg_load - sds->avg_sgs_load, load_above_busiest_capacity);
 
-	/* How much load to actually move to equalise the imbalance */
-	env->imbalance = min(max_pull * sds->busiest->sgp->power,
-		(sds->avg_load - sds->this_load) * sds->this->sgp->power)
+	/* How much load to actually move to equalise the imbalance
+ 	 * Calculated using PJT's metric
+	 */
+	env->load_imbalance = min(max_load_pull * sds->busiest->sgp->power,
+		(sds->avg_sgs_load - sds->this_sg_load) * sds->this->sgp->power)
 			/ SCHED_POWER_SCALE;
 
 	/*
@@ -4945,7 +4955,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * a think about bumping its value to force at least one task to be
 	 * moved
 	 */
-	if (env->imbalance < sds->busiest_load_per_task)
+	if (env->load_imbalance < sds->busiest_sg_load_per_task)
 		return fix_small_imbalance(env, sds);
 
 }

