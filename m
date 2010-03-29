Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0C2Ql2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:41:28 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:10975 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab0C2QlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:41:24 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i87h6bh2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L01YCH-01-GK4-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/3] perf/core, x86: undo some some *_counter* -> *_event* renames
Date: Mon, 29 Mar 2010 18:36:50 +0200
Message-ID: <1269880612-25800-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Mar 2010 16:41:02.0010 (UTC) FILETIME=[9E1DA9A0:01CACF5E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The big rename

 cdd6c48 perf: Do the big rename: Performance Counters -> Performance Events

accidentally renamed some members of stucts that were named after
registers in the spec. To avoid confusion this patch reverts some
changes. The related specs are MSR descriptions in AMD's BKDGs and the
ARCHITECTURAL PERFORMANCE MONITORING section in the Intel 64 and IA-32
Architectures Software Developer's Manuals.

This patch does:

 $ sed -i -e 's:num_events:num_counters:g' \
   arch/x86/include/asm/perf_event.h \
   arch/x86/kernel/cpu/perf_event_amd.c \
   arch/x86/kernel/cpu/perf_event.c \
   arch/x86/kernel/cpu/perf_event_intel.c \
   arch/x86/kernel/cpu/perf_event_p6.c \
   arch/x86/kernel/cpu/perf_event_p4.c \
   arch/x86/oprofile/op_model_ppro.c

 $ sed -i -e 's:event_bits:cntval_bits:g' -e 's:event_mask:cntval_mask:g' \
   arch/x86/kernel/cpu/perf_event_amd.c \
   arch/x86/kernel/cpu/perf_event.c \
   arch/x86/kernel/cpu/perf_event_intel.c \
   arch/x86/kernel/cpu/perf_event_p6.c \
   arch/x86/kernel/cpu/perf_event_p4.c

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h      |    4 +-
 arch/x86/kernel/cpu/perf_event.c       |   74 ++++++++++++++++----------------
 arch/x86/kernel/cpu/perf_event_amd.c   |   12 +++---
 arch/x86/kernel/cpu/perf_event_intel.c |   14 +++---
 arch/x86/kernel/cpu/perf_event_p4.c    |   14 +++---
 arch/x86/kernel/cpu/perf_event_p6.c    |    6 +-
 arch/x86/oprofile/op_model_ppro.c      |    4 +-
 7 files changed, 64 insertions(+), 64 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 124dddd..987bf67 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -67,7 +67,7 @@
 union cpuid10_eax {
 	struct {
 		unsigned int version_id:8;
-		unsigned int num_events:8;
+		unsigned int num_counters:8;
 		unsigned int bit_width:8;
 		unsigned int mask_length:8;
 	} split;
@@ -76,7 +76,7 @@ union cpuid10_eax {
 
 union cpuid10_edx {
 	struct {
-		unsigned int num_events_fixed:4;
+		unsigned int num_counters_fixed:4;
 		unsigned int reserved:28;
 	} split;
 	unsigned int full;
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6f66d4a..f2fc2d8 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -194,10 +194,10 @@ struct x86_pmu {
 	u64		(*event_map)(int);
 	u64		(*raw_event)(u64);
 	int		max_events;
-	int		num_events;
-	int		num_events_fixed;
-	int		event_bits;
-	u64		event_mask;
+	int		num_counters;
+	int		num_counters_fixed;
+	int		cntval_bits;
+	u64		cntval_mask;
 	int		apic;
 	u64		max_period;
 	struct event_constraint *
@@ -267,7 +267,7 @@ static u64
 x86_perf_event_update(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	int shift = 64 - x86_pmu.event_bits;
+	int shift = 64 - x86_pmu.cntval_bits;
 	u64 prev_raw_count, new_raw_count;
 	int idx = hwc->idx;
 	s64 delta;
@@ -319,12 +319,12 @@ static bool reserve_pmc_hardware(void)
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		disable_lapic_nmi_watchdog();
 
-	for (i = 0; i < x86_pmu.num_events; i++) {
+	for (i = 0; i < x86_pmu.num_counters; i++) {
 		if (!reserve_perfctr_nmi(x86_pmu.perfctr + i))
 			goto perfctr_fail;
 	}
 
-	for (i = 0; i < x86_pmu.num_events; i++) {
+	for (i = 0; i < x86_pmu.num_counters; i++) {
 		if (!reserve_evntsel_nmi(x86_pmu.eventsel + i))
 			goto eventsel_fail;
 	}
@@ -335,7 +335,7 @@ eventsel_fail:
 	for (i--; i >= 0; i--)
 		release_evntsel_nmi(x86_pmu.eventsel + i);
 
-	i = x86_pmu.num_events;
+	i = x86_pmu.num_counters;
 
 perfctr_fail:
 	for (i--; i >= 0; i--)
@@ -351,7 +351,7 @@ static void release_pmc_hardware(void)
 {
 	int i;
 
-	for (i = 0; i < x86_pmu.num_events; i++) {
+	for (i = 0; i < x86_pmu.num_counters; i++) {
 		release_perfctr_nmi(x86_pmu.perfctr + i);
 		release_evntsel_nmi(x86_pmu.eventsel + i);
 	}
@@ -546,7 +546,7 @@ static void x86_pmu_disable_all(void)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		u64 val;
 
 		if (!test_bit(idx, cpuc->active_mask))
@@ -581,7 +581,7 @@ static void x86_pmu_enable_all(int added)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		struct perf_event *event = cpuc->events[idx];
 		u64 val;
 
@@ -656,14 +656,14 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	 * assign events to counters starting with most
 	 * constrained events.
 	 */
-	wmax = x86_pmu.num_events;
+	wmax = x86_pmu.num_counters;
 
 	/*
 	 * when fixed event counters are present,
 	 * wmax is incremented by 1 to account
 	 * for one more choice
 	 */
-	if (x86_pmu.num_events_fixed)
+	if (x86_pmu.num_counters_fixed)
 		wmax++;
 
 	for (w = 1, num = n; num && w <= wmax; w++) {
@@ -713,7 +713,7 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 	struct perf_event *event;
 	int n, max_count;
 
-	max_count = x86_pmu.num_events + x86_pmu.num_events_fixed;
+	max_count = x86_pmu.num_counters + x86_pmu.num_counters_fixed;
 
 	/* current number of events already accepted */
 	n = cpuc->n_events;
@@ -903,7 +903,7 @@ x86_perf_event_set_period(struct perf_event *event)
 	atomic64_set(&hwc->prev_count, (u64)-left);
 
 	wrmsrl(hwc->event_base + idx,
-			(u64)(-left) & x86_pmu.event_mask);
+			(u64)(-left) & x86_pmu.cntval_mask);
 
 	perf_event_update_userpage(event);
 
@@ -986,7 +986,7 @@ void perf_event_print_debug(void)
 	unsigned long flags;
 	int cpu, idx;
 
-	if (!x86_pmu.num_events)
+	if (!x86_pmu.num_counters)
 		return;
 
 	local_irq_save(flags);
@@ -1010,7 +1010,7 @@ void perf_event_print_debug(void)
 	}
 	pr_info("CPU#%d: active:     %016llx\n", cpu, *(u64 *)cpuc->active_mask);
 
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		rdmsrl(x86_pmu.eventsel + idx, pmc_ctrl);
 		rdmsrl(x86_pmu.perfctr  + idx, pmc_count);
 
@@ -1023,7 +1023,7 @@ void perf_event_print_debug(void)
 		pr_info("CPU#%d:   gen-PMC%d left:  %016llx\n",
 			cpu, idx, prev_left);
 	}
-	for (idx = 0; idx < x86_pmu.num_events_fixed; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters_fixed; idx++) {
 		rdmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, pmc_count);
 
 		pr_info("CPU#%d: fixed-PMC%d count: %016llx\n",
@@ -1088,7 +1088,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
 
@@ -1096,7 +1096,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 		hwc = &event->hw;
 
 		val = x86_perf_event_update(event);
-		if (val & (1ULL << (x86_pmu.event_bits - 1)))
+		if (val & (1ULL << (x86_pmu.cntval_bits - 1)))
 			continue;
 
 		/*
@@ -1398,46 +1398,46 @@ void __init init_hw_perf_events(void)
 	if (x86_pmu.quirks)
 		x86_pmu.quirks();
 
-	if (x86_pmu.num_events > X86_PMC_MAX_GENERIC) {
+	if (x86_pmu.num_counters > X86_PMC_MAX_GENERIC) {
 		WARN(1, KERN_ERR "hw perf events %d > max(%d), clipping!",
-		     x86_pmu.num_events, X86_PMC_MAX_GENERIC);
-		x86_pmu.num_events = X86_PMC_MAX_GENERIC;
+		     x86_pmu.num_counters, X86_PMC_MAX_GENERIC);
+		x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
 	}
-	x86_pmu.intel_ctrl = (1 << x86_pmu.num_events) - 1;
-	perf_max_events = x86_pmu.num_events;
+	x86_pmu.intel_ctrl = (1 << x86_pmu.num_counters) - 1;
+	perf_max_events = x86_pmu.num_counters;
 
-	if (x86_pmu.num_events_fixed > X86_PMC_MAX_FIXED) {
+	if (x86_pmu.num_counters_fixed > X86_PMC_MAX_FIXED) {
 		WARN(1, KERN_ERR "hw perf events fixed %d > max(%d), clipping!",
-		     x86_pmu.num_events_fixed, X86_PMC_MAX_FIXED);
-		x86_pmu.num_events_fixed = X86_PMC_MAX_FIXED;
+		     x86_pmu.num_counters_fixed, X86_PMC_MAX_FIXED);
+		x86_pmu.num_counters_fixed = X86_PMC_MAX_FIXED;
 	}
 
 	x86_pmu.intel_ctrl |=
-		((1LL << x86_pmu.num_events_fixed)-1) << X86_PMC_IDX_FIXED;
+		((1LL << x86_pmu.num_counters_fixed)-1) << X86_PMC_IDX_FIXED;
 
 	perf_events_lapic_init();
 	register_die_notifier(&perf_event_nmi_notifier);
 
 	unconstrained = (struct event_constraint)
-		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_events) - 1,
-				   0, x86_pmu.num_events);
+		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
+				   0, x86_pmu.num_counters);
 
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
 			if (c->cmask != INTEL_ARCH_FIXED_MASK)
 				continue;
 
-			c->idxmsk64 |= (1ULL << x86_pmu.num_events) - 1;
-			c->weight += x86_pmu.num_events;
+			c->idxmsk64 |= (1ULL << x86_pmu.num_counters) - 1;
+			c->weight += x86_pmu.num_counters;
 		}
 	}
 
 	pr_info("... version:                %d\n",     x86_pmu.version);
-	pr_info("... bit width:              %d\n",     x86_pmu.event_bits);
-	pr_info("... generic registers:      %d\n",     x86_pmu.num_events);
-	pr_info("... value mask:             %016Lx\n", x86_pmu.event_mask);
+	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
+	pr_info("... generic registers:      %d\n",     x86_pmu.num_counters);
+	pr_info("... value mask:             %016Lx\n", x86_pmu.cntval_mask);
 	pr_info("... max period:             %016Lx\n", x86_pmu.max_period);
-	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_events_fixed);
+	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_counters_fixed);
 	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
 
 	perf_cpu_notifier(x86_pmu_notifier);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 358a8e3..9d363ce 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -158,7 +158,7 @@ static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
 	 * be removed on one CPU at a time AND PMU is disabled
 	 * when we come here
 	 */
-	for (i = 0; i < x86_pmu.num_events; i++) {
+	for (i = 0; i < x86_pmu.num_counters; i++) {
 		if (nb->owners[i] == event) {
 			cmpxchg(nb->owners+i, event, NULL);
 			break;
@@ -208,7 +208,7 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	struct amd_nb *nb = cpuc->amd_nb;
 	struct perf_event *old = NULL;
-	int max = x86_pmu.num_events;
+	int max = x86_pmu.num_counters;
 	int i, j, k = -1;
 
 	/*
@@ -286,7 +286,7 @@ static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
 	/*
 	 * initialize all possible NB constraints
 	 */
-	for (i = 0; i < x86_pmu.num_events; i++) {
+	for (i = 0; i < x86_pmu.num_counters; i++) {
 		__set_bit(i, nb->event_constraints[i].idxmsk);
 		nb->event_constraints[i].weight = 1;
 	}
@@ -370,9 +370,9 @@ static __initconst struct x86_pmu amd_pmu = {
 	.event_map		= amd_pmu_event_map,
 	.raw_event		= amd_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
-	.num_events		= 4,
-	.event_bits		= 48,
-	.event_mask		= (1ULL << 48) - 1,
+	.num_counters		= 4,
+	.cntval_bits		= 48,
+	.cntval_mask		= (1ULL << 48) - 1,
 	.apic			= 1,
 	/* use highest bit to detect overflow */
 	.max_period		= (1ULL << 47) - 1,
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 676aac2..0d68531 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -653,18 +653,18 @@ static void intel_pmu_reset(void)
 	unsigned long flags;
 	int idx;
 
-	if (!x86_pmu.num_events)
+	if (!x86_pmu.num_counters)
 		return;
 
 	local_irq_save(flags);
 
 	printk("clearing PMU state on CPU#%d\n", smp_processor_id());
 
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		checking_wrmsrl(x86_pmu.eventsel + idx, 0ull);
 		checking_wrmsrl(x86_pmu.perfctr  + idx, 0ull);
 	}
-	for (idx = 0; idx < x86_pmu.num_events_fixed; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters_fixed; idx++) {
 		checking_wrmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, 0ull);
 	}
 	if (ds)
@@ -901,16 +901,16 @@ static __init int intel_pmu_init(void)
 		x86_pmu = intel_pmu;
 
 	x86_pmu.version			= version;
-	x86_pmu.num_events		= eax.split.num_events;
-	x86_pmu.event_bits		= eax.split.bit_width;
-	x86_pmu.event_mask		= (1ULL << eax.split.bit_width) - 1;
+	x86_pmu.num_counters		= eax.split.num_counters;
+	x86_pmu.cntval_bits		= eax.split.bit_width;
+	x86_pmu.cntval_mask		= (1ULL << eax.split.bit_width) - 1;
 
 	/*
 	 * Quirk: v2 perfmon does not report fixed-purpose events, so
 	 * assume at least 3 events:
 	 */
 	if (version > 1)
-		x86_pmu.num_events_fixed = max((int)edx.split.num_events_fixed, 3);
+		x86_pmu.num_counters_fixed = max((int)edx.split.num_counters_fixed, 3);
 
 	/*
 	 * v2 and above have a perf capabilities MSR
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 0d1be36..4139100 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -483,7 +483,7 @@ static void p4_pmu_disable_all(void)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		struct perf_event *event = cpuc->events[idx];
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
@@ -540,7 +540,7 @@ static void p4_pmu_enable_all(int added)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		struct perf_event *event = cpuc->events[idx];
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
@@ -562,7 +562,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
-	for (idx = 0; idx < x86_pmu.num_events; idx++) {
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
@@ -579,7 +579,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 		p4_pmu_clear_cccr_ovf(hwc);
 
 		val = x86_perf_event_update(event);
-		if (val & (1ULL << (x86_pmu.event_bits - 1)))
+		if (val & (1ULL << (x86_pmu.cntval_bits - 1)))
 			continue;
 
 		/*
@@ -794,10 +794,10 @@ static __initconst struct x86_pmu p4_pmu = {
 	 * though leave it restricted at moment assuming
 	 * HT is on
 	 */
-	.num_events		= ARCH_P4_MAX_CCCR,
+	.num_counters		= ARCH_P4_MAX_CCCR,
 	.apic			= 1,
-	.event_bits		= 40,
-	.event_mask		= (1ULL << 40) - 1,
+	.cntval_bits		= 40,
+	.cntval_mask		= (1ULL << 40) - 1,
 	.max_period		= (1ULL << 39) - 1,
 	.hw_config		= p4_hw_config,
 	.schedule_events	= p4_pmu_schedule_events,
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index 877182c..b26fbc7 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -119,7 +119,7 @@ static __initconst struct x86_pmu p6_pmu = {
 	.apic			= 1,
 	.max_period		= (1ULL << 31) - 1,
 	.version		= 0,
-	.num_events		= 2,
+	.num_counters		= 2,
 	/*
 	 * Events have 40 bits implemented. However they are designed such
 	 * that bits [32-39] are sign extensions of bit 31. As such the
@@ -127,8 +127,8 @@ static __initconst struct x86_pmu p6_pmu = {
 	 *
 	 * See IA-32 Intel Architecture Software developer manual Vol 3B
 	 */
-	.event_bits		= 32,
-	.event_mask		= (1ULL << 32) - 1,
+	.cntval_bits		= 32,
+	.cntval_mask		= (1ULL << 32) - 1,
 	.get_event_constraints	= x86_get_event_constraints,
 	.event_constraints	= p6_event_constraints,
 };
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 2bf90fa..c8abc4d 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -239,11 +239,11 @@ static void arch_perfmon_setup_counters(void)
 	if (eax.split.version_id == 0 && current_cpu_data.x86 == 6 &&
 		current_cpu_data.x86_model == 15) {
 		eax.split.version_id = 2;
-		eax.split.num_events = 2;
+		eax.split.num_counters = 2;
 		eax.split.bit_width = 40;
 	}
 
-	num_counters = eax.split.num_events;
+	num_counters = eax.split.num_counters;
 
 	op_arch_perfmon_spec.num_counters = num_counters;
 	op_arch_perfmon_spec.num_controls = num_counters;
-- 
1.7.0.3


