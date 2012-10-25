Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935163Ab2JYK0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:26:35 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:53488 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2JYK0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:26:32 -0400
Subject: [RFC PATCH 11/13] sched: Modify find_idlest_group to use PJT's
 metric
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
Date: Thu, 25 Oct 2012 15:56:06 +0530
Message-ID: <20121025102605.21022.5545.stgit@preeti.in.ibm.com>
In-Reply-To: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12102510-2000-0000-0000-0000099A7BC5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additional parameters introduced to perform this function which are
calculated using PJT's metrics and its helpers.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a5affbc..c64be1c1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3173,11 +3173,13 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		  int this_cpu, int load_idx)
 {
 	struct sched_group *idlest = NULL, *group = sd->groups;
-	unsigned long min_load = ULONG_MAX, this_load = 0;
+	unsigned long this_load = 0;
+	u64 min_sg_load = ~0ULL, this_sg_load = 0;/* Helpers for PJT's metrics */
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
 	do {
 		unsigned long load, avg_load;
+		u64 avg_sg_load;/* Helpers for PJT's metrics */
 		int local_group;
 		int i;
 
@@ -3191,6 +3193,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 
 		/* Tally up the load of all CPUs in the group */
 		avg_load = 0;
+		avg_sg_load = 0;
 
 		for_each_cpu(i, sched_group_cpus(group)) {
 			/* Bias balancing toward cpus of our domain */
@@ -3200,20 +3203,23 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 				load = target_load(i, load_idx);
 
 			avg_load += load;
+			avg_sg_load += cpu_rq(i)->cfs.runnable_load_avg;
 		}
 
 		/* Adjust by relative CPU power of the group */
 		avg_load = (avg_load * SCHED_POWER_SCALE) / group->sgp->power;
+		avg_sg_load = (avg_sg_load * SCHED_POWER_SCALE) / group->sgp->power;
 
 		if (local_group) {
 			this_load = avg_load;
-		} else if (avg_load < min_load) {
-			min_load = avg_load;
+			this_sg_load = avg_sg_load;
+		} else if (avg_sg_load < min_sg_load) {/* Decision changed to suit PJT's metric */
+			min_sg_load = avg_sg_load;
 			idlest = group;
 		}
 	} while (group = group->next, group != sd->groups);
 
-	if (!idlest || 100*this_load < imbalance*min_load)
+	if (!idlest || 100*this_sg_load < imbalance*min_sg_load)
 		return NULL;
 	return idlest;
 }

