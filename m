Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0ESVlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:41:47 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:37327 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab0ESVlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:41:14 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L2OS87-02-UVB-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 6/7] perf, x86: implement AMD IBS event configuration
Date: Wed, 19 May 2010 23:20:23 +0200
Message-ID: <1274304024-6551-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements IBS for perf_event. It extends the AMD pmu to
handle IBS and implements special raw events for this.

An IBS hw event can be selected by setting the event's raw type. There
are two types of IBS events for instruction fetch (IBS_FETCH) and
instruction execution (IBS_OP). Both events are implemented as special
x86 events. The event allocation is implemented by using special event
constraints for ibs. This way, the generic event scheduler can be used
to allocate ibs events.

Except for the sample period IBS can only be set up with raw config
values and raw data samples. The event attributes for the syscall
should be programmed like this (IBS_FETCH):

        memset(&attr, 0, sizeof(attr));
        attr.type        = PERF_TYPE_RAW;
        attr.raw_type    = PERF_RAW_IBS_FETCH;
        attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
        attr.config      = IBS_FETCH_CONFIG_DEFAULT;

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h    |   11 ++-
 arch/x86/kernel/cpu/perf_event.c     |   11 ++
 arch/x86/kernel/cpu/perf_event_amd.c |  194 +++++++++++++++++++++++++++++++++-
 3 files changed, 207 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 7e51c75..dace4e2 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -44,14 +44,15 @@
 #define AMD64_RAW_EVENT_MASK		\
 	(X86_RAW_EVENT_MASK          |  \
 	 AMD64_EVENTSEL_EVENT)
+#define AMD64_NUM_COUNTERS				4
 
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX			 0
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX		0
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT \
 		(1 << (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX))
 
-#define ARCH_PERFMON_BRANCH_MISSES_RETIRED			 6
+#define ARCH_PERFMON_BRANCH_MISSES_RETIRED		6
 
 /*
  * Intel "Architectural Performance Monitoring" CPUID
@@ -102,13 +103,15 @@ union cpuid10_edx {
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
index 91c48b2..fe7ba91 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -148,6 +148,9 @@ struct cpu_hw_events {
 #define INTEL_EVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
 
+#define AMD_IBS_EVENT_CONSTRAINT(idx)	\
+	__EVENT_CONSTRAINT(0, 1ULL << (idx), 0, AMD64_NUM_COUNTERS + 1)
+
 /*
  * Constraint on the Event code + UMask + fixed-mask
  *
@@ -186,6 +189,14 @@ union perf_capabilities {
 };
 
 /*
+ * Raw hardware event types
+ */
+#define PERF_RAW_IBS_FETCH	1
+#define PERF_RAW_IBS_OP		2
+
+#define PERF_RAW_IBS_BASE	PERF_RAW_IBS_FETCH
+
+/*
  * struct x86_pmu - generic x86 pmu
  */
 struct x86_pmu {
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 4f6a73a..5161745 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -2,6 +2,34 @@
 
 #include <linux/pci.h>
 
+#define IBS_FETCH_MAP_IDX	(PERF_RAW_IBS_FETCH - PERF_RAW_IBS_BASE)
+#define IBS_OP_MAP_IDX		(PERF_RAW_IBS_OP - PERF_RAW_IBS_BASE)
+
+#define IBS_FETCH_CONFIG_MASK	(IBS_FETCH_RAND_EN | IBS_FETCH_MAX_CNT)
+#define IBS_OP_CONFIG_MASK	IBS_OP_MAX_CNT
+
+struct ibs_map {
+	int idx;
+	u64 cnt_mask;
+	u64 valid_mask;
+	unsigned int msr;
+};
+
+static struct ibs_map ibs_map[] = {
+	[IBS_FETCH_MAP_IDX] = {
+		.idx		= X86_PMC_IDX_SPECIAL_IBS_FETCH,
+		.cnt_mask	= IBS_FETCH_MAX_CNT,
+		.valid_mask	= IBS_FETCH_CONFIG_MASK,
+		.msr		= MSR_AMD64_IBSFETCHCTL,
+	},
+	[IBS_OP_MAP_IDX] = {
+		.idx		= X86_PMC_IDX_SPECIAL_IBS_OP,
+		.cnt_mask	= IBS_OP_MAX_CNT,
+		.valid_mask	= IBS_OP_CONFIG_MASK,
+		.msr		= MSR_AMD64_IBSOPCTL,
+	},
+};
+
 static DEFINE_RAW_SPINLOCK(amd_nb_lock);
 
 static __initconst const u64 amd_hw_cache_event_ids
@@ -187,6 +215,129 @@ static inline void apic_clear_ibs(void) { }
 
 #endif
 
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
+	int map_idx;
+	u64 max_cnt, config;
+	struct ibs_map *map;
+
+	if (!x86_pmu.ibs)
+		return -ENODEV;
+
+	if (event->attr.type != PERF_TYPE_RAW)
+		/* only raw sample types are supported */
+		return -EINVAL;
+
+	if (event->attr.raw_type < PERF_RAW_IBS_BASE)
+		return -ENODEV;
+	map_idx = event->attr.raw_type - PERF_RAW_IBS_BASE;
+	if (map_idx >= ARRAY_SIZE(ibs_map))
+		return -ENODEV;
+
+	map = &ibs_map[map_idx];
+	config = event->attr.config;
+	if (event->hw.sample_period) {
+		if (config & map->cnt_mask)
+			/* raw max_cnt may not be set */
+			return -EINVAL;
+		if (event->hw.sample_period & 0x0f)
+			/* lower 4 bits can not be set in ibs max cnt */
+			return -EINVAL;
+		max_cnt = event->hw.sample_period >> 4;
+		if (max_cnt & ~map->cnt_mask)
+			/* out of range */
+			return -EINVAL;
+		config |= max_cnt;
+	} else {
+		max_cnt = event->attr.config & map->cnt_mask;
+	}
+
+	if (!max_cnt)
+		return -EINVAL;
+
+	if (config & ~map->valid_mask)
+		return -EINVAL;
+
+	event->hw.config = config;
+	event->hw.idx = map->idx;
+	/*
+	 * dirty hack, needed for __x86_pmu_enable_event(), we
+	 * should better change event->hw.config_base into
+	 * event->hw.config_msr that already includes the index
+	 */
+	event->hw.config_base = map->msr - event->hw.idx;
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
@@ -194,7 +345,12 @@ static u64 amd_pmu_event_map(int hw_event)
 
 static int amd_pmu_hw_config(struct perf_event *event)
 {
-	int ret = x86_pmu_hw_config(event);
+	int ret;
+
+	if (event->attr.raw_type)
+		return amd_pmu_ibs_config(event);
+
+	ret = x86_pmu_hw_config(event);
 
 	if (ret)
 		return ret;
@@ -211,6 +367,21 @@ static int amd_pmu_hw_config(struct perf_event *event)
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
+	AMD_IBS_EVENT_CONSTRAINT(X86_PMC_IDX_SPECIAL_IBS_FETCH),
+	AMD_IBS_EVENT_CONSTRAINT(X86_PMC_IDX_SPECIAL_IBS_OP),
+	EVENT_CONSTRAINT_END
+};
+
+/*
  * AMD64 events are detected based on their event codes.
  */
 static inline int amd_is_nb_event(struct hw_perf_event *hwc)
@@ -296,10 +467,23 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
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
@@ -459,9 +643,9 @@ static void amd_pmu_cpu_dead(int cpu)
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
@@ -469,7 +653,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.perfctr		= MSR_K7_PERFCTR0,
 	.event_map		= amd_pmu_event_map,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
-	.num_counters		= 4,
+	.num_counters		= AMD64_NUM_COUNTERS,
 	.cntval_bits		= 48,
 	.cntval_mask		= (1ULL << 48) - 1,
 	.apic			= 1,
-- 
1.7.1


