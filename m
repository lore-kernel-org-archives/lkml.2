Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab2JYK1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:27:12 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:51489 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965489Ab2JYK1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:27:08 -0400
Subject: [RFC PATCH 12/13] sched: Modify find_idlest_cpu to use PJT's metric
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
Date: Thu, 25 Oct 2012 15:56:11 +0530
Message-ID: <20121025102611.21022.23199.stgit@preeti.in.ibm.com>
In-Reply-To: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12102510-5490-0000-0000-000002581546
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additional parameters introduced to perform this function which are
calculated using PJT's metrics and its helpers.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c64be1c1..15ec528 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3230,16 +3230,18 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 static int
 find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 {
-	unsigned long load, min_load = ULONG_MAX;
+	unsigned long load;
+	u64 cpu_load, min_cpu_load = ~0ULL;
 	int idlest = -1;
 	int i;
 
 	/* Traverse only the allowed CPUs */
 	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
 		load = weighted_cpuload(i);
+		cpu_load = cpu_rq(i)->cfs.runnable_load_avg;
 
-		if (load < min_load || (load == min_load && i == this_cpu)) {
-			min_load = load;
+		if (cpu_load < min_cpu_load || (cpu_load == min_cpu_load && i == this_cpu)) {
+			min_cpu_load = cpu_load;
 			idlest = i;
 		}
 	}

