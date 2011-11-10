Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352Ab1KJM6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 07:58:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757658Ab1KJM6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 07:58:09 -0500
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: [PATCHv3 06/10] x86, perf: disable non available architectural events.
Date: Thu, 10 Nov 2011 14:57:26 +0200
Message-Id: <1320929850-10480-7-git-send-email-gleb@redhat.com>
In-Reply-To: <1320929850-10480-1-git-send-email-gleb@redhat.com>
References: <1320929850-10480-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel CPUs report non-available architectural events in cpuid leaf
0AH.EBX. Use it to disable events that are not available according
to CPU.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/include/asm/perf_event.h      |   14 ++++++++++++++
 arch/x86/kernel/cpu/perf_event.h       |    5 +++++
 arch/x86/kernel/cpu/perf_event_intel.c |   29 ++++++++++++++++++++++++-----
 3 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index f61c62f..c6998bc 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -57,6 +57,7 @@
 		(1 << (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX))
 
 #define ARCH_PERFMON_BRANCH_MISSES_RETIRED		6
+#define ARCH_PERFMON_EVENTS_COUNT			7
 
 /*
  * Intel "Architectural Performance Monitoring" CPUID
@@ -72,6 +73,19 @@ union cpuid10_eax {
 	unsigned int full;
 };
 
+union cpuid10_ebx {
+	struct {
+		unsigned int no_unhalted_core_cycles:1;
+		unsigned int no_instructions_retired:1;
+		unsigned int no_unhalted_reference_cycles:1;
+		unsigned int no_llc_reference:1;
+		unsigned int no_llc_misses:1;
+		unsigned int no_branch_instruction_retired:1;
+		unsigned int no_branch_misses_retired:1;
+	} split;
+	unsigned int full;
+};
+
 union cpuid10_edx {
 	struct {
 		unsigned int num_counters_fixed:5;
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index b9698d4..cd0ebcd 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -259,6 +259,11 @@ struct x86_pmu {
 	int		num_counters_fixed;
 	int		cntval_bits;
 	u64		cntval_mask;
+	union {
+			unsigned long events_maskl;
+			unsigned long events_mask[BITS_TO_LONGS(ARCH_PERFMON_EVENTS_COUNT)];
+	};
+	int		events_mask_len;
 	int		apic;
 	u64		max_period;
 	struct event_constraint *
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index e09ca20..301369a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1544,13 +1544,23 @@ static void intel_clovertown_quirks(void)
 	x86_pmu.pebs_constraints = NULL;
 }
 
+static int intel_event_id_to_hw_id[] = {
+	PERF_COUNT_HW_CPU_CYCLES,
+	PERF_COUNT_HW_INSTRUCTIONS,
+	PERF_COUNT_HW_BUS_CYCLES,
+	PERF_COUNT_HW_CACHE_REFERENCES,
+	PERF_COUNT_HW_CACHE_MISSES,
+	PERF_COUNT_HW_BRANCH_INSTRUCTIONS,
+	PERF_COUNT_HW_BRANCH_MISSES,
+};
+
 __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
 	union cpuid10_eax eax;
+	union cpuid10_ebx ebx;
 	unsigned int unused;
-	unsigned int ebx;
-	int version;
+	int version, bit;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 		switch (boot_cpu_data.x86) {
@@ -1566,8 +1576,8 @@ __init int intel_pmu_init(void)
 	 * Check whether the Architectural PerfMon supports
 	 * Branch Misses Retired hw_event or not.
 	 */
-	cpuid(10, &eax.full, &ebx, &unused, &edx.full);
-	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
+	cpuid(10, &eax.full, &ebx.full, &unused, &edx.full);
+	if (eax.split.mask_length < ARCH_PERFMON_EVENTS_COUNT)
 		return -ENODEV;
 
 	version = eax.split.version_id;
@@ -1643,7 +1653,7 @@ __init int intel_pmu_init(void)
 		/* UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x1803fb1;
 
-		if (ebx & 0x40) {
+		if (ebx.split.no_branch_misses_retired) {
 			/*
 			 * Erratum AAJ80 detected, we work it around by using
 			 * the BR_MISP_EXEC.ANY event. This will over-count
@@ -1651,6 +1661,7 @@ __init int intel_pmu_init(void)
 			 * architectural event which is often completely bogus:
 			 */
 			intel_perfmon_event_map[PERF_COUNT_HW_BRANCH_MISSES] = 0x7f89;
+			ebx.split.no_branch_misses_retired = 0;
 
 			pr_cont("erratum AAJ80 worked around, ");
 		}
@@ -1729,5 +1740,13 @@ __init int intel_pmu_init(void)
 			break;
 		}
 	}
+	x86_pmu.events_maskl		= ebx.full;
+	x86_pmu.events_mask_len		= eax.split.mask_length;
+
+	/* disable event that reported as not presend by cpuid */
+	for_each_set_bit(bit, x86_pmu.events_mask,
+			min(x86_pmu.events_mask_len, x86_pmu.max_events))
+		intel_perfmon_event_map[intel_event_id_to_hw_id[bit]] = 0;
+
 	return 0;
 }
-- 
1.7.7.1

