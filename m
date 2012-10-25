Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab2JYK0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:26:08 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:47294 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab2JYK0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:26:04 -0400
Subject: [RFC PATCH 06/13] sched: Changing find_busiest_queue to use PJT's
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
Date: Thu, 25 Oct 2012 15:55:38 +0530
Message-ID: <20121025102537.21022.522.stgit@preeti.in.ibm.com>
In-Reply-To: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12102510-4790-0000-0000-0000053C9457
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additional parameters which decide the busiest cpu in the chosen sched group
calculated using PJT's metric are used

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fca6606..bb1c71b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5085,7 +5085,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 				     struct sched_group *group)
 {
 	struct rq *busiest = NULL, *rq;
-	unsigned long max_load = 0;
+	u64 max_cpu_load = 0;
 	int i;
 
 	for_each_cpu(i, sched_group_cpus(group)) {
@@ -5093,6 +5093,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		unsigned long capacity = DIV_ROUND_CLOSEST(power,
 							   SCHED_POWER_SCALE);
 		unsigned long wl;
+		u64 runnable_load;/* Equivalent of wl,calculated using PJT's metric */
 
 		if (!capacity)
 			capacity = fix_small_capacity(env->sd, group);
@@ -5102,12 +5103,14 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 
 		rq = cpu_rq(i);
 		wl = weighted_cpuload(i);
+		runnable_load = cpu_rq(i)->cfs.runnable_load_avg;
 
 		/*
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu power.
+		 * The below decision is based on PJT's metric
 		 */
-		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
+		if (capacity && rq->nr_running == 1 && runnable_load > env->load_imbalance)
 			continue;
 
 		/*
@@ -5117,9 +5120,11 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * running at a lower capacity.
 		 */
 		wl = (wl * SCHED_POWER_SCALE) / power;
+		runnable_load = (runnable_load * SCHED_POWER_SCALE) / power;
 
-		if (wl > max_load) {
-			max_load = wl;
+		/* Below decision has been changed to use PJT's metric */
+		if (runnable_load > max_cpu_load) {
+			max_cpu_load = runnable_load;
 			busiest = rq;
 		}
 	}

