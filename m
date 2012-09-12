Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab2ILL1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:27:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:49876 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2ILL1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:27:48 -0400
Message-ID: <1347449261.15764.9.camel@twins>
Subject: [RFC][PATCH] perf, intel: Expose SMI_COUNT as a fixed counter
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>, mingo@kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Wed, 12 Sep 2012 13:27:41 +0200
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: perf, intel: Expose SMI_COUNT as a fixed counter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Sep 12 13:10:53 CEST 2012

The Intel SMI_COUNT sadly isn't a proper PMU event but a free-running
MSR, expose it by creating another fake fixed PMC and another pseudo
event.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

Only added to wsm because that's what my testbox is ;-)

 arch/x86/include/asm/perf_event.h      |   18 ++++++++
 arch/x86/kernel/cpu/perf_event.c       |   68 +++++++++++++++++++++++++--------
 arch/x86/kernel/cpu/perf_event.h       |    9 ++++
 arch/x86/kernel/cpu/perf_event_intel.c |   42 ++++++++++++++------
 4 files changed, 109 insertions(+), 28 deletions(-)
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -131,13 +131,29 @@ struct x86_pmu_capability {
 #define INTEL_PMC_MSK_FIXED_REF_CYCLES	(1ULL << INTEL_PMC_IDX_FIXED_REF_CYCLES)
 
 /*
+ * Create a range of 'special' (fake) fixed purpose counters
+ */
+#define INTEL_PMC_IDX_FIXED_SPECIAL	(INTEL_PMC_IDX_FIXED + 16)
+#define INTEL_PMC_MSK_FIXED_SPECIAL	(1ULL << INTEL_PMC_IDX_FIXED_SPECIAL)
+
+/*
  * We model BTS tracing as another fixed-mode PMC.
  *
  * We choose a value in the middle of the fixed event range, since lower
  * values are used by actual fixed events and higher values are used
  * to indicate other overflow conditions in the PERF_GLOBAL_STATUS msr.
  */
-#define INTEL_PMC_IDX_FIXED_BTS				(INTEL_PMC_IDX_FIXED + 16)
+#define INTEL_PMC_IDX_FIXED_BTS		(INTEL_PMC_IDX_FIXED_SPECIAL + 0)
+#define INTEL_PMC_MSK_FIXED_BTS		(1ULL << INTEL_PMC_IDX_FIXED_BTS)
+
+/*
+ * We model the SMI_COUNT as another fixed-mode PMC.
+ *
+ * This MSR (34h) is a free running counter of SMIs
+ */
+#define MSR_ARCH_SMI_COUNT		0x34
+#define INTEL_PMC_IDX_FIXED_SMI_COUNT	(INTEL_PMC_IDX_FIXED_SPECIAL + 1)
+#define INTEL_PMC_MSK_FIXED_SMI_COUNT	(1ULL << INTEL_PMC_IDX_FIXED_SMI_COUNT)
 
 /*
  * IBS cpuid feature detection
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -52,22 +52,14 @@ u64 __read_mostly hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
-/*
- * Propagate event elapsed time into the generic event.
- * Can only be executed on the CPU where the event is active.
- * Returns the delta events processed.
- */
-u64 x86_perf_event_update(struct perf_event *event)
+static inline u64 __perf_event_update(struct perf_event *event,
+		u64 (*read)(struct hw_perf_event *hwc), int width)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	int shift = 64 - x86_pmu.cntval_bits;
+	int shift = 64 - width;
 	u64 prev_raw_count, new_raw_count;
-	int idx = hwc->idx;
 	s64 delta;
 
-	if (idx == INTEL_PMC_IDX_FIXED_BTS)
-		return 0;
-
 	/*
 	 * Careful: an NMI might modify the previous event value.
 	 *
@@ -77,7 +69,7 @@ u64 x86_perf_event_update(struct perf_ev
 	 */
 again:
 	prev_raw_count = local64_read(&hwc->prev_count);
-	rdpmcl(hwc->event_base_rdpmc, new_raw_count);
+	new_raw_count = read(hwc);
 
 	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
 					new_raw_count) != prev_raw_count)
@@ -100,6 +92,37 @@ u64 x86_perf_event_update(struct perf_ev
 	return new_raw_count;
 }
 
+static inline u64 x86_rdpmc(struct hw_perf_event *hwc)
+{
+	u64 count;
+
+	rdpmcl(hwc->event_base_rdpmc, count);
+
+	return count;
+}
+
+/*
+ * Propagate event elapsed time into the generic event.
+ * Can only be executed on the CPU where the event is active.
+ * Returns the delta events processed.
+ */
+u64 x86_perf_event_update(struct perf_event *event)
+{
+	int idx = event->hw.idx;
+
+	if (unlikely(idx >= INTEL_PMC_IDX_FIXED_SPECIAL)) {
+		switch (idx) {
+		case INTEL_PMC_IDX_FIXED_BTS:
+			return 0;
+
+		case INTEL_PMC_IDX_FIXED_SMI_COUNT:
+			return __perf_event_update(event, x86_rdsmi, 32);
+		}
+	}
+
+	return __perf_event_update(event, x86_rdpmc, x86_pmu.cntval_bits);
+}
+
 /*
  * Find and validate any extra registers to set up.
  */
@@ -437,8 +460,22 @@ int x86_pmu_hw_config(struct perf_event 
 	if (!event->attr.exclude_kernel)
 		event->hw.config |= ARCH_PERFMON_EVENTSEL_OS;
 
-	if (event->attr.type == PERF_TYPE_RAW)
+	if (event->attr.type == PERF_TYPE_RAW) {
+		/*
+		 * SMI_COUNT can only count..
+		 */
+		if (event->attr.config == 0x0400) {
+			if (event->attr.exclude_user ||
+			    event->attr.exclude_kernel ||
+			    event->attr.exclude_hv ||
+			    event->attr.exclude_idle ||
+			    event->attr.exclude_host ||
+			    event->attr.exclude_guest ||
+			    event->attr.sample_period)
+				return -EINVAL;
+		}
 		event->hw.config |= event->attr.config & X86_RAW_EVENT_MASK;
+	}
 
 	return x86_setup_perfctr(event);
 }
@@ -817,9 +854,10 @@ static inline void x86_assign_hw_event(s
 	hwc->last_cpu = smp_processor_id();
 	hwc->last_tag = ++cpuc->tags[i];
 
-	if (hwc->idx == INTEL_PMC_IDX_FIXED_BTS) {
+	if (hwc->idx >= INTEL_PMC_IDX_FIXED_SPECIAL) {
 		hwc->config_base = 0;
 		hwc->event_base	= 0;
+		hwc->event_base_rdpmc = 0;
 	} else if (hwc->idx >= INTEL_PMC_IDX_FIXED) {
 		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
 		hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0 + (hwc->idx - INTEL_PMC_IDX_FIXED);
@@ -925,7 +963,7 @@ int x86_perf_event_set_period(struct per
 	s64 period = hwc->sample_period;
 	int ret = 0, idx = hwc->idx;
 
-	if (idx == INTEL_PMC_IDX_FIXED_BTS)
+	if (unlikely(idx >= INTEL_PMC_IDX_FIXED_SPECIAL))
 		return 0;
 
 	/*
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -536,6 +536,15 @@ static inline void set_linear_ip(struct 
 	regs->ip = ip;
 }
 
+static inline u64 x86_rdsmi(struct hw_perf_event *hwc)
+{
+	u64 count;
+
+	rdmsrl(MSR_ARCH_SMI_COUNT, count);
+
+	return count;
+}
+
 #ifdef CONFIG_CPU_SUP_AMD
 
 int amd_pmu_init(void);
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -89,6 +89,7 @@ static struct event_constraint intel_wes
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
 	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
+	FIXED_EVENT_CONSTRAINT(0x0400, 17), /* SMI_COUNT */
 	INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
 	INTEL_EVENT_CONSTRAINT(0x60, 0x1), /* OFFCORE_REQUESTS_OUTSTANDING */
 	INTEL_EVENT_CONSTRAINT(0x63, 0x3), /* CACHE_LOCK_CYCLES */
@@ -966,10 +967,16 @@ static void intel_pmu_disable_event(stru
 	struct hw_perf_event *hwc = &event->hw;
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_BTS)) {
-		intel_pmu_disable_bts();
-		intel_pmu_drain_bts_buffer();
-		return;
+	if (unlikely(hwc->idx >= INTEL_PMC_IDX_FIXED_SPECIAL)) {
+		switch (hwc->idx) {
+		case INTEL_PMC_IDX_FIXED_BTS:
+			intel_pmu_disable_bts();
+			intel_pmu_drain_bts_buffer();
+			return;
+
+		case INTEL_PMC_IDX_FIXED_SMI_COUNT:
+			return;
+		}
 	}
 
 	cpuc->intel_ctrl_guest_mask &= ~(1ull << hwc->idx);
@@ -1029,13 +1036,21 @@ static void intel_pmu_enable_event(struc
 	struct hw_perf_event *hwc = &event->hw;
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_BTS)) {
-		if (!__this_cpu_read(cpu_hw_events.enabled))
+	if (unlikely(hwc->idx >= INTEL_PMC_IDX_FIXED_SPECIAL)) {
+		switch (hwc->idx) {
+		case INTEL_PMC_IDX_FIXED_BTS:
+			if (!__this_cpu_read(cpu_hw_events.enabled))
+				return;
+
+			intel_pmu_enable_bts(hwc->config);
 			return;
 
-		intel_pmu_enable_bts(hwc->config);
-		return;
+		case INTEL_PMC_IDX_FIXED_SMI_COUNT:
+			local64_set(&hwc->prev_count, x86_rdsmi(hwc));
+			return;
+		}
 	}
+
 	/*
 	 * must enabled before any actual event
 	 * because any event may be combined with LBR
@@ -2107,12 +2122,15 @@ __init int intel_pmu_init(void)
 
 	if (x86_pmu.event_constraints) {
 		/*
-		 * event on fixed counter2 (REF_CYCLES) only works on this
-		 * counter, so do not extend mask to generic counters
+		 * Events on fixed counter2 (REF_CYCLES) only works on this
+		 * counter, similar for the special fixed counters.
+		 *
+		 * So do not extend mask to generic counters.
 		 */
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if (c->cmask != X86_RAW_EVENT_MASK
-			    || c->idxmsk64 == INTEL_PMC_MSK_FIXED_REF_CYCLES) {
+			if (c->cmask != X86_RAW_EVENT_MASK ||
+			    c->idxmsk64 == INTEL_PMC_MSK_FIXED_REF_CYCLES ||
+			    c->idxmsk64 >= INTEL_PMC_MSK_FIXED_SPECIAL) {
 				continue;
 			}
 

