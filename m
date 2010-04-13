Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab0DMU2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:28:39 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:41772 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab0DMU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:26:54 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i467h6bh2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0U0SG-01-CB0-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 11/12] perf, x86: implement AMD IBS event configuration
Date: Tue, 13 Apr 2010 22:23:20 +0200
Message-ID: <1271190201-25705-12-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 13 Apr 2010 20:26:35.0730 (UTC) FILETIME=[9D09B320:01CADB47]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements IBS for perf_event. It extends the AMD pmu to
handle model specific IBS events.

With the attr.model_spec bit set we can setup hardware events others
than generic performance counters. A special PMU 64 bit config value
can be passed through the perf_event interface. The concept of PMU
model-specific arguments was practiced already in Perfmon2. The type
of event (8 bits) is determinded from the config value too, bit 32-39
are reserved for this.

There are two types of IBS events for instruction fetch (IBS_FETCH)
and instruction execution (IBS_OP). Both events are implemented as
special x86 events. The event allocation is implemented by using
special event constraints for ibs. This way, the generic event
scheduler can be used to allocate ibs events.

IBS can only be set up with raw (model specific) config values and raw
data samples. The event attributes for the syscall should be
programmed like this (IBS_FETCH):

        memset(&attr, 0, sizeof(attr));
        attr.type        = PERF_TYPE_RAW;
        attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
        attr.config      = IBS_FETCH_CONFIG_DEFAULT
        attr.config     |=
                ((unsigned long long)MODEL_SPEC_TYPE_IBS_FETCH << 32)
                & MODEL_SPEC_TYPE_MASK;
        attr.model_spec  = 1;

The whole ibs example will be part of libpfm4.

The next patch implements the ibs interrupt handler.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h    |    4 +-
 arch/x86/kernel/cpu/perf_event.c     |   20 ++++
 arch/x86/kernel/cpu/perf_event_amd.c |  161 ++++++++++++++++++++++++++++++++-
 3 files changed, 179 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 9f10215..fd5c326 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -102,13 +102,15 @@ union cpuid10_edx {
 #define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
 
 /*
- * We model BTS tracing as another fixed-mode PMC.
+ * Masks for special PMU features
  *
  * We choose a value in the middle of the fixed event range, since lower
  * values are used by actual fixed events and higher values are used
  * to indicate other overflow conditions in the PERF_GLOBAL_STATUS msr.
  */
 #define X86_PMC_IDX_SPECIAL_BTS				(X86_PMC_IDX_SPECIAL + 0)
+#define X86_PMC_IDX_SPECIAL_IBS_FETCH			(X86_PMC_IDX_SPECIAL + 1)
+#define X86_PMC_IDX_SPECIAL_IBS_OP			(X86_PMC_IDX_SPECIAL + 2)
 
 /* IbsFetchCtl bits/masks */
 #define IBS_FETCH_RAND_EN		(1ULL<<57)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8f9674f..e2328f4 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -184,6 +184,26 @@ union perf_capabilities {
 };
 
 /*
+ * Model specific hardware events
+ *
+ * With the attr.model_spec bit set we can setup hardware events
+ * others than generic performance counters. A special PMU 64 bit
+ * config value can be passed through the perf_event interface. The
+ * concept of PMU model-specific arguments was practiced already in
+ * Perfmon2. The type of event (8 bits) is determinded from the config
+ * value too, bit 32-39 are reserved for this.
+ */
+#define MODEL_SPEC_TYPE_IBS_FETCH	0
+#define MODEL_SPEC_TYPE_IBS_OP		1
+
+#define MODEL_SPEC_TYPE_MASK		(0xFFULL << 32)
+
+static inline int get_model_spec_type(u64 config)
+{
+	return (config & MODEL_SPEC_TYPE_MASK) >> 32;
+}
+
+/*
  * struct x86_pmu - generic x86 pmu
  */
 struct x86_pmu {
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 27daead..3dc327c 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -2,6 +2,10 @@
 
 #include <linux/pci.h>
 
+#define IBS_FETCH_CONFIG_MASK	(IBS_FETCH_RAND_EN | IBS_FETCH_MAX_CNT)
+#define IBS_OP_CONFIG_MASK	(IBS_OP_CNT_CTL | IBS_OP_MAX_CNT)
+#define AMD64_NUM_COUNTERS	4
+
 static DEFINE_RAW_SPINLOCK(amd_nb_lock);
 
 static __initconst const u64 amd_hw_cache_event_ids
@@ -193,6 +197,118 @@ static void release_ibs_hardware(void)
 	clear_ibs_nmi();
 }
 
+static inline void amd_pmu_disable_ibs(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 val;
+
+	if (test_bit(X86_PMC_IDX_SPECIAL_IBS_FETCH, cpuc->active_mask)) {
+		rdmsrl(MSR_AMD64_IBSFETCHCTL, val);
+		val &= ~IBS_FETCH_ENABLE;
+		wrmsrl(MSR_AMD64_IBSFETCHCTL, val);
+	}
+	if (test_bit(X86_PMC_IDX_SPECIAL_IBS_OP, cpuc->active_mask)) {
+		rdmsrl(MSR_AMD64_IBSOPCTL, val);
+		val &= ~IBS_OP_ENABLE;
+		wrmsrl(MSR_AMD64_IBSOPCTL, val);
+	}
+}
+
+static inline void amd_pmu_enable_ibs(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 val;
+
+	if (test_bit(X86_PMC_IDX_SPECIAL_IBS_FETCH, cpuc->active_mask)) {
+		rdmsrl(MSR_AMD64_IBSFETCHCTL, val);
+		val |= IBS_FETCH_ENABLE;
+		wrmsrl(MSR_AMD64_IBSFETCHCTL, val);
+	}
+	if (test_bit(X86_PMC_IDX_SPECIAL_IBS_OP, cpuc->active_mask)) {
+		rdmsrl(MSR_AMD64_IBSOPCTL, val);
+		val |= IBS_OP_ENABLE;
+		wrmsrl(MSR_AMD64_IBSOPCTL, val);
+	}
+}
+
+static int amd_pmu_ibs_config(struct perf_event *event)
+{
+	int type;
+
+	if (!x86_pmu.ibs)
+		return -ENODEV;
+
+	if (event->hw.sample_period)
+		/*
+		 * The usage of the sample period attribute to
+		 * calculate the IBS max count value is not yet
+		 * supported, the max count must be in the raw config
+		 * value.
+		 */
+		return -ENOSYS;
+
+	if (event->attr.type != PERF_TYPE_RAW)
+		/* only raw sample types are supported */
+		return -EINVAL;
+
+	type = get_model_spec_type(event->attr.config);
+	switch (type) {
+	case MODEL_SPEC_TYPE_IBS_FETCH:
+		event->hw.config = IBS_FETCH_CONFIG_MASK & event->attr.config;
+		event->hw.idx = X86_PMC_IDX_SPECIAL_IBS_FETCH;
+		/*
+		 * dirty hack, needed for __x86_pmu_enable_event(), we
+		 * should better change event->hw.config_base into
+		 * event->hw.config_msr that already includes the index
+		 */
+		event->hw.config_base = MSR_AMD64_IBSFETCHCTL - event->hw.idx;
+		break;
+	case MODEL_SPEC_TYPE_IBS_OP:
+		event->hw.config = IBS_OP_CONFIG_MASK & event->attr.config;
+		event->hw.idx = X86_PMC_IDX_SPECIAL_IBS_OP;
+		event->hw.config_base = MSR_AMD64_IBSOPCTL - event->hw.idx;
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static inline void __amd_pmu_enable_ibs_event(struct hw_perf_event *hwc)
+{
+	if (hwc->idx == X86_PMC_IDX_SPECIAL_IBS_FETCH)
+		__x86_pmu_enable_event(hwc, IBS_FETCH_ENABLE);
+	else if (hwc->idx == X86_PMC_IDX_SPECIAL_IBS_OP)
+		__x86_pmu_enable_event(hwc, IBS_OP_ENABLE);
+}
+
+static void amd_pmu_disable_all(void)
+{
+	x86_pmu_disable_all();
+	amd_pmu_disable_ibs();
+}
+
+static void amd_pmu_enable_all(int added)
+{
+	x86_pmu_enable_all(added);
+	amd_pmu_enable_ibs();
+}
+
+static void amd_pmu_enable_event(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (!cpuc->enabled)
+		return;
+
+	if (hwc->idx < X86_PMC_IDX_SPECIAL)
+		__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
+	else
+		__amd_pmu_enable_ibs_event(hwc);
+}
+
 static u64 amd_pmu_event_map(int hw_event)
 {
 	return amd_perfmon_event_map[hw_event];
@@ -200,7 +316,12 @@ static u64 amd_pmu_event_map(int hw_event)
 
 static int amd_pmu_hw_config(struct perf_event *event)
 {
-	int ret = x86_pmu_hw_config(event);
+	int ret;
+
+	if (event->attr.model_spec)
+		return amd_pmu_ibs_config(event);
+
+	ret = x86_pmu_hw_config(event);
 
 	if (ret)
 		return ret;
@@ -214,6 +335,23 @@ static int amd_pmu_hw_config(struct perf_event *event)
 }
 
 /*
+ * AMD64 events - list of special events (IBS)
+ */
+static struct event_constraint amd_event_constraints[] =
+{
+	/*
+	 * The value for the weight of these constraints is higher
+	 * than in the unconstrainted case to process ibs after the
+	 * generic counters in x86_schedule_events().
+	 */
+	__EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_SPECIAL_IBS_FETCH, 0,
+			   AMD64_NUM_COUNTERS + 1),
+	__EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_SPECIAL_IBS_OP, 0,
+			   AMD64_NUM_COUNTERS + 1),
+	EVENT_CONSTRAINT_END
+};
+
+/*
  * AMD64 events are detected based on their event codes.
  */
 static inline int amd_is_nb_event(struct hw_perf_event *hwc)
@@ -299,10 +437,23 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	struct amd_nb *nb = cpuc->amd_nb;
 	struct perf_event *old = NULL;
+	struct event_constraint *c;
 	int max = x86_pmu.num_counters;
 	int i, j, k = -1;
 
 	/*
+	 * The index of special events must be set in
+	 * hw_perf_event_init(). The constraints are used for resource
+	 * allocation by the event scheduler.
+	 */
+	if (hwc->idx >= X86_PMC_IDX_SPECIAL) {
+		for_each_event_constraint(c, amd_event_constraints) {
+			if (test_bit(hwc->idx, c->idxmsk))
+				return c;
+		}
+	}
+
+	/*
 	 * if not NB event or no NB, then no constraints
 	 */
 	if (!(amd_has_nb(cpuc) && amd_is_nb_event(hwc)))
@@ -458,9 +609,9 @@ static void amd_pmu_cpu_dead(int cpu)
 static __initconst const struct x86_pmu amd_pmu = {
 	.name			= "AMD",
 	.handle_irq		= x86_pmu_handle_irq,
-	.disable_all		= x86_pmu_disable_all,
-	.enable_all		= x86_pmu_enable_all,
-	.enable			= x86_pmu_enable_event,
+	.disable_all		= amd_pmu_disable_all,
+	.enable_all		= amd_pmu_enable_all,
+	.enable			= amd_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
 	.hw_config		= amd_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
@@ -468,7 +619,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.perfctr		= MSR_K7_PERFCTR0,
 	.event_map		= amd_pmu_event_map,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
-	.num_counters		= 4,
+	.num_counters		= AMD64_NUM_COUNTERS,
 	.cntval_bits		= 48,
 	.cntval_mask		= (1ULL << 48) - 1,
 	.apic			= 1,
-- 
1.7.0.3


