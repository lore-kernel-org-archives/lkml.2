Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340Ab2JYK1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:27:24 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:53598 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422800Ab2JYK1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:27:18 -0400
Subject: [RFC PATCH 13/13] sched: Modifying wake_affine to use PJT's metric
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
Date: Thu, 25 Oct 2012 15:56:22 +0530
Message-ID: <20121025102622.21022.59828.stgit@preeti.in.ibm.com>
In-Reply-To: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12102510-1618-0000-0000-000002B617BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additional parameters introduced to perform this function which are
calculated using PJT's metrics and its helpers.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 15ec528..b4b572c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2931,19 +2931,6 @@ static unsigned long power_of(int cpu)
 	return cpu_rq(cpu)->cpu_power;
 }
 
-static unsigned long cpu_avg_load_per_task(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
-
-	if (nr_running) {
-		return rq->load.weight / nr_running;
-	}
-
-	return 0;
-}
-
-
 static void task_waking_fair(struct task_struct *p)
 {
 	struct sched_entity *se = &p->se;
@@ -3085,16 +3072,18 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
 	s64 this_load, load;
 	int idx, this_cpu, prev_cpu;
-	unsigned long tl_per_task;
+	u64 tl_per_task; /* Modified to reflect PJT's metric */
 	struct task_group *tg;
-	unsigned long weight;
+	unsigned long weight, nr_running;
 	int balanced;
 
 	idx	  = sd->wake_idx;
 	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
-	load	  = source_load(prev_cpu, idx);
-	this_load = target_load(this_cpu, idx);
+	/* Both of the below have been modified to use PJT's metric */
+	load      = cpu_rq(prev_cpu)->cfs.runnable_load_avg;
+	this_load = cpu_rq(this_cpu)->cfs.runnable_load_avg;
+	nr_running = cpu_rq(this_cpu)->nr_running;
 
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
@@ -3104,6 +3093,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	if (sync) {
 		tg = task_group(current);
 		weight = current->se.load.weight;
+		weight = current->se.avg.load_avg_contrib;
 
 		this_load += effective_load(tg, this_cpu, -weight, -weight);
 		load += effective_load(tg, prev_cpu, 0, -weight);
@@ -3111,6 +3101,8 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 	tg = task_group(p);
 	weight = p->se.load.weight;
+	/* The below change to reflect PJT's metric */
+	weight = p->se.avg.load_avg_contrib;
 
 	/*
 	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
@@ -3146,11 +3138,15 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 		return 1;
 
 	schedstat_inc(p, se.statistics.nr_wakeups_affine_attempts);
-	tl_per_task = cpu_avg_load_per_task(this_cpu);
+	/* Below modification to use PJT's metric */
+	if (nr_running)
+		tl_per_task = cpu_rq(this_cpu)->cfs.runnable_load_avg / nr_running;
+	else
+		tl_per_task = 0;
 
 	if (balanced ||
 	    (this_load <= load &&
-	     this_load + target_load(prev_cpu, idx) <= tl_per_task)) {
+	     this_load + cpu_rq(prev_cpu)->cfs.runnable_load_avg <= tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and

