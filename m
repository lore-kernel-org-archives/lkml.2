Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1LFUS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:18:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38191 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab1LFUS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:18:28 -0500
Date: Tue, 6 Dec 2011 12:18:01 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-wcja2z48wklzu1b0nkz0a5y7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Implement arch event mask as quirk
Git-Commit-ID: c1d6f42f1a42c721513e2f388c208e5348004f64
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 12:18:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1d6f42f1a42c721513e2f388c208e5348004f64
Gitweb:     http://git.kernel.org/tip/c1d6f42f1a42c721513e2f388c208e5348004f64
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 6 Dec 2011 14:07:15 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 20:41:06 +0100

perf, x86: Implement arch event mask as quirk

Implement the disabling of arch events as a quirk so that we can print
a message along with it. This creates some visibility into the problem
space and could allow us to work on adding more work-around like the
AAJ80 one.

Requested-by: Ingo Molnar <mingo@elte.hu>
Cc: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-wcja2z48wklzu1b0nkz0a5y7@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |    5 +-
 arch/x86/kernel/cpu/perf_event.h       |   16 ++++++-
 arch/x86/kernel/cpu/perf_event_intel.c |   80 ++++++++++++++++++++------------
 3 files changed, 68 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 66f8ba9..55889e0 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1248,6 +1248,7 @@ static void __init pmu_check_apic(void)
 
 static int __init init_hw_perf_events(void)
 {
+	struct x86_pmu_quirk *quirk;
 	struct event_constraint *c;
 	int err;
 
@@ -1276,8 +1277,8 @@ static int __init init_hw_perf_events(void)
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
-	if (x86_pmu.quirks)
-		x86_pmu.quirks();
+	for (quirk = x86_pmu.quirks; quirk; quirk = quirk->next)
+		quirk->func();
 
 	if (x86_pmu.num_counters > X86_PMC_MAX_GENERIC) {
 		WARN(1, KERN_ERR "hw perf events %d > max(%d), clipping!",
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index f49c5c2..8944062 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -261,6 +261,11 @@ union perf_capabilities {
 	u64	capabilities;
 };
 
+struct x86_pmu_quirk {
+	struct x86_pmu_quirk *next;
+	void (*func)(void);
+};
+
 /*
  * struct x86_pmu - generic x86 pmu
  */
@@ -299,7 +304,7 @@ struct x86_pmu {
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
-	void		(*quirks)(void);
+	struct x86_pmu_quirk *quirks;
 	int		perfctr_second_write;
 
 	int		(*cpu_prepare)(int cpu);
@@ -340,6 +345,15 @@ struct x86_pmu {
 	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
 };
 
+#define x86_add_quirk(func_)						\
+do {									\
+	static struct x86_pmu_quirk __quirk __initdata = {		\
+		.func = func_,						\
+	};								\
+	__quirk.next = x86_pmu.quirks;					\
+	x86_pmu.quirks = &__quirk;					\
+} while (0)
+
 #define ERF_NO_HT_SHARING	1
 #define ERF_HAS_RSP_1		2
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 201156b..2c3bf53 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1519,7 +1519,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.guest_get_msrs		= intel_guest_get_msrs,
 };
 
-static void intel_clovertown_quirks(void)
+static __init void intel_clovertown_quirk(void)
 {
 	/*
 	 * PEBS is unreliable due to:
@@ -1545,30 +1545,61 @@ static void intel_clovertown_quirks(void)
 	x86_pmu.pebs_constraints = NULL;
 }
 
-static void intel_sandybridge_quirks(void)
+static __init void intel_sandybridge_quirk(void)
 {
 	printk(KERN_WARNING "PEBS disabled due to CPU errata.\n");
 	x86_pmu.pebs = 0;
 	x86_pmu.pebs_constraints = NULL;
 }
 
-static const int intel_event_id_to_hw_id[] __initconst = {
-	PERF_COUNT_HW_CPU_CYCLES,
-	PERF_COUNT_HW_INSTRUCTIONS,
-	PERF_COUNT_HW_BUS_CYCLES,
-	PERF_COUNT_HW_CACHE_REFERENCES,
-	PERF_COUNT_HW_CACHE_MISSES,
-	PERF_COUNT_HW_BRANCH_INSTRUCTIONS,
-	PERF_COUNT_HW_BRANCH_MISSES,
+static const struct { int id; char *name; } intel_arch_events_map[] __initconst = {
+	{ PERF_COUNT_HW_CPU_CYCLES, "cpu cycles" },
+	{ PERF_COUNT_HW_INSTRUCTIONS, "instructions" },
+	{ PERF_COUNT_HW_BUS_CYCLES, "bus cycles" },
+	{ PERF_COUNT_HW_CACHE_REFERENCES, "cache references" },
+	{ PERF_COUNT_HW_CACHE_MISSES, "cache misses" },
+	{ PERF_COUNT_HW_BRANCH_INSTRUCTIONS, "branch instructions" },
+	{ PERF_COUNT_HW_BRANCH_MISSES, "branch misses" },
 };
 
+static __init void intel_arch_events_quirk(void)
+{
+	int bit;
+
+	/* disable event that reported as not presend by cpuid */
+	for_each_set_bit(bit, x86_pmu.events_mask, ARRAY_SIZE(intel_arch_events_map)) {
+		intel_perfmon_event_map[intel_arch_events_map[bit].id] = 0;
+		printk(KERN_WARNING "CPUID marked event: \'%s\' unavailable\n",
+				intel_arch_events_map[bit].name);
+	}
+}
+
+static __init void intel_nehalem_quirk(void)
+{
+	union cpuid10_ebx ebx;
+
+	ebx.full = x86_pmu.events_maskl;
+	if (ebx.split.no_branch_misses_retired) {
+		/*
+		 * Erratum AAJ80 detected, we work it around by using
+		 * the BR_MISP_EXEC.ANY event. This will over-count
+		 * branch-misses, but it's still much better than the
+		 * architectural event which is often completely bogus:
+		 */
+		intel_perfmon_event_map[PERF_COUNT_HW_BRANCH_MISSES] = 0x7f89;
+		ebx.split.no_branch_misses_retired = 0;
+		x86_pmu.events_maskl = ebx.full;
+		printk(KERN_INFO "CPU erratum AAJ80 worked around\n");
+	}
+}
+
 __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
 	union cpuid10_eax eax;
 	union cpuid10_ebx ebx;
 	unsigned int unused;
-	int version, bit;
+	int version;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 		switch (boot_cpu_data.x86) {
@@ -1599,6 +1630,9 @@ __init int intel_pmu_init(void)
 	x86_pmu.cntval_bits		= eax.split.bit_width;
 	x86_pmu.cntval_mask		= (1ULL << eax.split.bit_width) - 1;
 
+	x86_pmu.events_maskl		= ebx.full;
+	x86_pmu.events_mask_len		= eax.split.mask_length;
+
 	/*
 	 * Quirk: v2 perfmon does not report fixed-purpose events, so
 	 * assume at least 3 events:
@@ -1618,6 +1652,8 @@ __init int intel_pmu_init(void)
 
 	intel_ds_init();
 
+	x86_add_quirk(intel_arch_events_quirk); /* Install first, so it runs last */
+
 	/*
 	 * Install the hw-cache-events table:
 	 */
@@ -1627,7 +1663,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
-		x86_pmu.quirks = intel_clovertown_quirks;
+		x86_add_quirk(intel_clovertown_quirk);
 	case 22: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
 	case 23: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
 	case 29: /* six-core 45 nm xeon "Dunnington" */
@@ -1661,18 +1697,8 @@ __init int intel_pmu_init(void)
 		/* UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x1803fb1;
 
-		if (ebx.split.no_branch_misses_retired) {
-			/*
-			 * Erratum AAJ80 detected, we work it around by using
-			 * the BR_MISP_EXEC.ANY event. This will over-count
-			 * branch-misses, but it's still much better than the
-			 * architectural event which is often completely bogus:
-			 */
-			intel_perfmon_event_map[PERF_COUNT_HW_BRANCH_MISSES] = 0x7f89;
-			ebx.split.no_branch_misses_retired = 0;
+		x86_add_quirk(intel_nehalem_quirk);
 
-			pr_cont("erratum AAJ80 worked around, ");
-		}
 		pr_cont("Nehalem events, ");
 		break;
 
@@ -1712,7 +1738,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 42: /* SandyBridge */
-		x86_pmu.quirks = intel_sandybridge_quirks;
+		x86_add_quirk(intel_sandybridge_quirk);
 	case 45: /* SandyBridge, "Romely-EP" */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
@@ -1749,12 +1775,6 @@ __init int intel_pmu_init(void)
 			break;
 		}
 	}
-	x86_pmu.events_maskl		= ebx.full;
-	x86_pmu.events_mask_len		= eax.split.mask_length;
-
-	/* disable event that reported as not presend by cpuid */
-	for_each_set_bit(bit, x86_pmu.events_mask, ARRAY_SIZE(intel_event_id_to_hw_id))
-		intel_perfmon_event_map[intel_event_id_to_hw_id[bit]] = 0;
 
 	return 0;
 }
