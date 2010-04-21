Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab0DUKyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 06:54:53 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:14095 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab0DUKyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:54:51 -0400
X-SpamScore: -30
X-BigFish: VPS-30(zz1432P98dN936eM62a3L9371Pab9bhzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L183N1-02-BE2-02
X-M-MSG: 
Date: Wed, 21 Apr 2010 12:54:39 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/12] perf, x86: implement AMD IBS event configuration
Message-ID: <20100421105439.GA6450@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-12-git-send-email-robert.richter@amd.com>
 <h2obd4cb8901004190646v8231b6a1sf47d0cff6481cc5e@mail.gmail.com>
 <20100420160557.GT11907@erda.amd.com>
 <20100421084700.GU11907@erda.amd.com>
 <o2ibd4cb8901004210202i1ba91c3dlc775a9f7759ece68@mail.gmail.com>
 <20100421092145.GV11907@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100421092145.GV11907@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Apr 2010 10:54:39.0915 (UTC) FILETIME=[0A85DFB0:01CAE141]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.04.10 11:21:45, Robert Richter wrote:
> On 21.04.10 11:02:42, Stephane Eranian wrote:
> > On Wed, Apr 21, 2010 at 10:47 AM, Robert Richter <robert.richter@amd.com> wrote:
> > > On 20.04.10 18:05:57, Robert Richter wrote:
> > >> > What is the problem with directly using the period here, rejecting
> > >> > any value that is off range or with bottom 4 bits set?
> > >>
> > >> Yes, I will create an updated version of this patch.

Stephane,

please see my updated version below.

-Robert

--

>From 79738167383838eb93f0388f8b7983fe822b36c4 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Wed, 21 Apr 2010 12:43:20 +0200
Subject: [PATCH] perf, x86: implement AMD IBS event configuration

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

Except for the sample period IBS can only be set up with raw (model
specific) config values and raw data samples. The event attributes for
the syscall should be programmed like this (IBS_FETCH):

        memset(&attr, 0, sizeof(attr));
        attr.type        = PERF_TYPE_RAW;
        attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
        attr.config      = IBS_FETCH_CONFIG_DEFAULT
        attr.config     |=
                ((unsigned long long)MODEL_SPEC_TYPE_IBS_FETCH << 32)
                & MODEL_SPEC_TYPE_MASK;
        attr.model_spec  = 1;

The whole ibs example will be part of libpfm4.

The ibs interrupt handle is implemented in the next patch.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h    |   11 ++-
 arch/x86/kernel/cpu/perf_event.c     |   23 ++++
 arch/x86/kernel/cpu/perf_event_amd.c |  189 +++++++++++++++++++++++++++++++++-
 3 files changed, 214 insertions(+), 9 deletions(-)

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
index 0ad8c45..cc0fd61 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -146,6 +146,9 @@ struct cpu_hw_events {
 #define INTEL_EVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
 
+#define AMD_IBS_EVENT_CONSTRAINT(idx)	\
+	__EVENT_CONSTRAINT(0, 1ULL << (idx), 0, AMD64_NUM_COUNTERS + 1)
+
 /*
  * Constraint on the Event code + UMask + fixed-mask
  *
@@ -184,6 +187,26 @@ union perf_capabilities {
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
+static inline u8 get_model_spec_type(u64 config)
+{
+	return (config & MODEL_SPEC_TYPE_MASK) >> 32;
+}
+
+/*
  * struct x86_pmu - generic x86 pmu
  */
 struct x86_pmu {
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index a6ce6f8..0093a52 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -2,6 +2,31 @@
 
 #include <linux/pci.h>
 
+#define IBS_FETCH_CONFIG_MASK	(IBS_FETCH_RAND_EN | IBS_FETCH_MAX_CNT)
+#define IBS_OP_CONFIG_MASK	IBS_OP_MAX_CNT
+
+struct ibs_map {
+	int idx;
+	u64 cnt_mask;
+	u64 valid_mask;
+	unsigned long msr;
+};
+
+static struct ibs_map ibs_map[] = {
+	[MODEL_SPEC_TYPE_IBS_FETCH] = {
+		.idx		= X86_PMC_IDX_SPECIAL_IBS_FETCH,
+		.cnt_mask	= IBS_FETCH_MAX_CNT,
+		.valid_mask	= IBS_FETCH_CONFIG_MASK,
+		.msr		= MSR_AMD64_IBSFETCHCTL,
+	},
+	[MODEL_SPEC_TYPE_IBS_OP] = {
+		.idx		= X86_PMC_IDX_SPECIAL_IBS_OP,
+		.cnt_mask	= IBS_OP_MAX_CNT,
+		.valid_mask	= IBS_OP_CONFIG_MASK,
+		.msr		= MSR_AMD64_IBSOPCTL,
+	},
+};
+
 static DEFINE_RAW_SPINLOCK(amd_nb_lock);
 
 static __initconst const u64 amd_hw_cache_event_ids
@@ -187,6 +212,127 @@ static inline void apic_clear_ibs(void) { }
 
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
+	u8 type;
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
+	type = get_model_spec_type(event->attr.config);
+	if (type >= ARRAY_SIZE(ibs_map))
+		return -ENODEV;
+
+	map = &ibs_map[type];
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
@@ -194,7 +340,12 @@ static u64 amd_pmu_event_map(int hw_event)
 
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
@@ -208,6 +359,21 @@ static int amd_pmu_hw_config(struct perf_event *event)
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
@@ -293,10 +459,23 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
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
@@ -456,9 +635,9 @@ static void amd_pmu_cpu_dead(int cpu)
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
@@ -466,7 +645,7 @@ static __initconst const struct x86_pmu amd_pmu = {
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



-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

