Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1CCC0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:26:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:26958 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab1CCC0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:26:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,256,1297065600"; 
   d="scan'208";a="663266696"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 4/4] perf: Avoid the percore allocations if HT is not capable
Date: Thu,  3 Mar 2011 10:34:50 +0800
Message-Id: <1299119690-13991-5-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1299119690-13991-4-git-send-email-ming.m.lin@intel.com>
References: <1299119690-13991-1-git-send-email-ming.m.lin@intel.com>
 <1299119690-13991-2-git-send-email-ming.m.lin@intel.com>
 <1299119690-13991-3-git-send-email-ming.m.lin@intel.com>
 <1299119690-13991-4-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to do percore allocations if HT is not capable

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index aaac4a9..4bee70a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1201,10 +1201,18 @@ static __initconst const struct x86_pmu core_pmu = {
 	.event_constraints	= intel_core_event_constraints,
 };
 
+static bool ht_capable(void)
+{
+	return boot_cpu_has(X86_FEATURE_HT) && smp_num_siblings > 1;
+}
+
 static int intel_pmu_cpu_prepare(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
 
+	if (!ht_capable())
+		return NOTIFY_OK;
+
 	cpuc->per_core = kzalloc_node(sizeof(struct intel_percore),
 				      GFP_KERNEL, cpu_to_node(cpu));
 	if (!cpuc->per_core)
@@ -1221,6 +1229,15 @@ static void intel_pmu_cpu_starting(int cpu)
 	int core_id = topology_core_id(cpu);
 	int i;
 
+	init_debug_store_on_cpu(cpu);
+	/*
+	 * Deal with CPUs that don't clear their LBRs on power-up.
+	 */
+	intel_pmu_lbr_reset();
+
+	if (!ht_capable())
+		return;
+
 	for_each_cpu(i, topology_thread_cpumask(cpu)) {
 		struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;
 
@@ -1233,12 +1250,6 @@ static void intel_pmu_cpu_starting(int cpu)
 
 	cpuc->per_core->core_id = core_id;
 	cpuc->per_core->refcnt++;
-
-	init_debug_store_on_cpu(cpu);
-	/*
-	 * Deal with CPUs that don't clear their LBRs on power-up.
-	 */
-	intel_pmu_lbr_reset();
 }
 
 static void intel_pmu_cpu_dying(int cpu)
-- 
1.7.3

