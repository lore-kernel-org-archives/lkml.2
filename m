Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1CAQs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:48:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:13192 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756911Ab1CAQs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:48:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,248,1297065600"; 
   d="scan'208";a="892623886"
Subject: [PATCH v2 4/4] perf: Avoid the percore allocations if HT is not
 capable
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 00:48:25 +0800
Message-Id: <1298998105.2170.68.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to do percore allocations if HT is not capable

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index e82a7f9..ac1d100 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1089,10 +1089,18 @@ static __initconst const struct x86_pmu core_pmu = {
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
@@ -1109,6 +1117,15 @@ static void intel_pmu_cpu_starting(int cpu)
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
 
@@ -1121,12 +1138,6 @@ static void intel_pmu_cpu_starting(int cpu)
 
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





