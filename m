Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0L0Pgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 10:36:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:10013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab0L0Pgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 10:36:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,234,1291622400"; 
   d="scan'208";a="587539421"
Subject: [PATCH 4/7] perf: Check if HT is supported and enabled
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Dec 2010 23:36:51 +0800
Message-Id: <1293464211.2695.104.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid the percore allocations if HT is not supported or disabled.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   44 +++++++++++++++++++++++++++----
 1 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index bc4afb1..354d1de 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1053,9 +1053,38 @@ static __initconst const struct x86_pmu core_pmu = {
 	.event_constraints	= intel_core_event_constraints,
 };
 
+/*
+ * Check if HT is capable and enabled
+ * TBD: move it to generic place, so it can be used by others
+ */
+
+static bool ht_enabled(int cpu)
+{
+	int total_logical_processors, total_cores;
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid(1, &eax, &ebx, &ecx, &edx);
+
+	/* Bit 28 in EDX indicates if it's HT capable */
+	if (!(edx & 0x10000000))
+		return false;
+
+	total_logical_processors = (ebx >> 16) & 0xff;
+
+	ecx = 0;
+	cpuid(4, &eax, &ebx, &ecx, &edx);
+	total_cores = ((eax >> 26) & 0x3f) + 1;
+
+	/* Thread nums per core */
+	return (total_logical_processors / total_cores) > 1;
+}
+
 static int intel_pmu_cpu_prepare(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
+
+	if (!ht_enabled(cpu))
+		return NOTIFY_OK;
 	
 	cpuc->per_core = kzalloc_node(sizeof(struct intel_percore), 
 				      GFP_KERNEL, cpu_to_node(cpu));
@@ -1073,6 +1102,15 @@ static void intel_pmu_cpu_starting(int cpu)
 	int core_id = topology_core_id(cpu);
 	int i;
 
+	init_debug_store_on_cpu(cpu);
+	/*
+	 * Deal with CPUs that don't clear their LBRs on power-up.
+	 */
+	intel_pmu_lbr_reset();
+
+	if (!ht_enabled(cpu))
+		return;
+
 	for_each_online_cpu(i) {
 		struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;
 
@@ -1085,12 +1123,6 @@ static void intel_pmu_cpu_starting(int cpu)
 
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





