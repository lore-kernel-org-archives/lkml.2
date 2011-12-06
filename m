Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1LFURm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:17:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38182 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab1LFURl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:17:41 -0500
Date: Tue, 6 Dec 2011 12:17:16 -0800
From: tip-bot for Gleb Natapov <gleb@redhat.com>
Message-ID: <tip-ffb871bc9156ee2e5cf442f61250c5bd6aad17e3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1320929850-10480-7-git-send-email-gleb@redhat.com>
References: <1320929850-10480-7-git-send-email-gleb@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf: Disable non available architectural events
Git-Commit-ID: ffb871bc9156ee2e5cf442f61250c5bd6aad17e3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 12:17:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffb871bc9156ee2e5cf442f61250c5bd6aad17e3
Gitweb:     http://git.kernel.org/tip/ffb871bc9156ee2e5cf442f61250c5bd6aad17e3
Author:     Gleb Natapov <gleb@redhat.com>
AuthorDate: Thu, 10 Nov 2011 14:57:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 20:41:05 +0100

x86, perf: Disable non available architectural events

Intel CPUs report non-available architectural events in cpuid leaf
0AH.EBX. Use it to disable events that are not available according
to CPU.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1320929850-10480-7-git-send-email-gleb@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/perf_event.h      |   14 ++++++++++++++
 arch/x86/kernel/cpu/perf_event.h       |    5 +++++
 arch/x86/kernel/cpu/perf_event_intel.c |   28 +++++++++++++++++++++++-----
 3 files changed, 42 insertions(+), 5 deletions(-)

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
index 51a985c..f49c5c2 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -285,6 +285,11 @@ struct x86_pmu {
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
index 8d601b1..201156b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1552,13 +1552,23 @@ static void intel_sandybridge_quirks(void)
 	x86_pmu.pebs_constraints = NULL;
 }
 
+static const int intel_event_id_to_hw_id[] __initconst = {
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
@@ -1574,8 +1584,8 @@ __init int intel_pmu_init(void)
 	 * Check whether the Architectural PerfMon supports
 	 * Branch Misses Retired hw_event or not.
 	 */
-	cpuid(10, &eax.full, &ebx, &unused, &edx.full);
-	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
+	cpuid(10, &eax.full, &ebx.full, &unused, &edx.full);
+	if (eax.split.mask_length < ARCH_PERFMON_EVENTS_COUNT)
 		return -ENODEV;
 
 	version = eax.split.version_id;
@@ -1651,7 +1661,7 @@ __init int intel_pmu_init(void)
 		/* UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x1803fb1;
 
-		if (ebx & 0x40) {
+		if (ebx.split.no_branch_misses_retired) {
 			/*
 			 * Erratum AAJ80 detected, we work it around by using
 			 * the BR_MISP_EXEC.ANY event. This will over-count
@@ -1659,6 +1669,7 @@ __init int intel_pmu_init(void)
 			 * architectural event which is often completely bogus:
 			 */
 			intel_perfmon_event_map[PERF_COUNT_HW_BRANCH_MISSES] = 0x7f89;
+			ebx.split.no_branch_misses_retired = 0;
 
 			pr_cont("erratum AAJ80 worked around, ");
 		}
@@ -1738,5 +1749,12 @@ __init int intel_pmu_init(void)
 			break;
 		}
 	}
+	x86_pmu.events_maskl		= ebx.full;
+	x86_pmu.events_mask_len		= eax.split.mask_length;
+
+	/* disable event that reported as not presend by cpuid */
+	for_each_set_bit(bit, x86_pmu.events_mask, ARRAY_SIZE(intel_event_id_to_hw_id))
+		intel_perfmon_event_map[intel_event_id_to_hw_id[bit]] = 0;
+
 	return 0;
 }
