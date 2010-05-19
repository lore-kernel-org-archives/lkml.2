Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0ESVlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:41:35 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:48085 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab0ESVlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:41:32 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L2OS85-02-UV0-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] perf: implement AMD IBS (v2)
Date: Wed, 19 May 2010 23:20:17 +0200
Message-ID: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of my patch set that introduces AMD IBS for
perf.

Changes made:

* rebased to latest tip/perf/core
* dropped the approach using a model_spec flag
* introduced an attribute to specify a raw hardware event type
* renamed *_SIZE macros to *_REG_COUNT
* introduced AMD_IBS_EVENT_CONSTRAINT() macro
* ease ibs initialization code
* made code cpu hotplug capable (using hotplug hooks)
* introduced ibs_map[] to better describe an ibs event which eases
  interfaces of ibs functions
* implemented support for setup using sample_period parameter
* fixed irq statistic counter
* adjust raw sample size to end the buffer at a 64 bit boundary

See also the diff below.

-Robert

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 9e70f20..73d680c 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -388,6 +388,11 @@ __hw_perf_event_init(struct perf_event *event)
 	} else if (PERF_TYPE_HW_CACHE == event->attr.type) {
 		mapping = armpmu_map_cache_event(event->attr.config);
 	} else if (PERF_TYPE_RAW == event->attr.type) {
+		if (event->attr.raw_type) {
+			pr_debug("invalid raw type %x\n",
+				 event->attr.raw_type);
+			return -EINVAL;
+		}
 		mapping = armpmu->raw_event(event->attr.config);
 	} else {
 		pr_debug("event type %x not supported\n", event->attr.type);
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 0b1f0f2..c8fb3cf 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1036,6 +1036,8 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
 			return ERR_PTR(err);
 		break;
 	case PERF_TYPE_RAW:
+		if (event->attr.raw_type)
+			return ERR_PTR(-EINVAL);
 		ev = event->attr.config;
 		break;
 	default:
@@ -1044,9 +1046,6 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
 	event->hw.config_base = ev;
 	event->hw.idx = 0;
 
-	if (attr->model_spec)
-		return ERR_PTR(-EOPNOTSUPP);
-
 	/*
 	 * If we are not running on a hypervisor, force the
 	 * exclude_hv bit to 0 so that we don't care what
diff --git a/arch/powerpc/kernel/perf_event_fsl_emb.c b/arch/powerpc/kernel/perf_event_fsl_emb.c
index 369872f..7547e96 100644
--- a/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ b/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -452,6 +452,8 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
 		break;
 
 	case PERF_TYPE_RAW:
+		if (event->attr.raw_type)
+			return ERR_PTR(-EINVAL);
 		ev = event->attr.config;
 		break;
 
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index eef545a..482cf48 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -109,9 +109,6 @@ static int __hw_perf_event_init(struct perf_event *event)
 	if (!sh_pmu_initialized())
 		return -ENODEV;
 
-	if (attr->model_spec)
-		return -EOPNOTSUPP;
-
 	/*
 	 * All of the on-chip counters are "limited", in that they have
 	 * no interrupts, and are therefore unable to do sampling without
@@ -145,6 +142,8 @@ static int __hw_perf_event_init(struct perf_event *event)
 
 	switch (attr->type) {
 	case PERF_TYPE_RAW:
+		if (attr->raw_type)
+			return -EINVAL;
 		config = attr->config & sh_pmu->raw_event_mask;
 		break;
 	case PERF_TYPE_HW_CACHE:
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index b3ae28e..cf4ce26 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1047,9 +1047,6 @@ static int __hw_perf_event_init(struct perf_event *event)
 	} else
 		return -EOPNOTSUPP;
 
-	if (attr->model_spec)
-		return -EOPNOTSUPP;
-
 	/* We save the enable bits in the config_base.  */
 	hwc->config_base = sparc_pmu->irq_bit;
 	if (!attr->exclude_user)
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a7e4aa5..8b9929f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -113,7 +113,7 @@
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
-#define MSR_AMD64_IBSFETCH_SIZE		3
+#define MSR_AMD64_IBSFETCH_REG_COUNT	3
 #define MSR_AMD64_IBSOPCTL		0xc0011033
 #define MSR_AMD64_IBSOPRIP		0xc0011034
 #define MSR_AMD64_IBSOPDATA		0xc0011035
@@ -121,9 +121,9 @@
 #define MSR_AMD64_IBSOPDATA3		0xc0011037
 #define MSR_AMD64_IBSDCLINAD		0xc0011038
 #define MSR_AMD64_IBSDCPHYSAD		0xc0011039
-#define MSR_AMD64_IBSOP_SIZE		7
+#define MSR_AMD64_IBSOP_REG_COUNT	7
 #define MSR_AMD64_IBSCTL		0xc001103a
-#define MSR_AMD64_IBS_SIZE_MAX		MSR_AMD64_IBSOP_SIZE
+#define MSR_AMD64_IBS_REG_COUNT_MAX	MSR_AMD64_IBSOP_REG_COUNT
 
 /* Fam 10h MSRs */
 #define MSR_FAM10H_MMIO_CONF_BASE	0xc0010058
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index e787d01..dace4e2 100644
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
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3f3f0ed..fe7ba91 100644
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
@@ -186,24 +189,12 @@ union perf_capabilities {
 };
 
 /*
- * Model specific hardware events
- *
- * With the attr.model_spec bit set we can setup hardware events
- * others than generic performance counters. A special PMU 64 bit
- * config value can be passed through the perf_event interface. The
- * concept of PMU model-specific arguments was practiced already in
- * Perfmon2. The type of event (8 bits) is determinded from the config
- * value too, bit 32-39 are reserved for this.
+ * Raw hardware event types
  */
-#define MODEL_SPEC_TYPE_IBS_FETCH	0
-#define MODEL_SPEC_TYPE_IBS_OP		1
-
-#define MODEL_SPEC_TYPE_MASK		(0xFFULL << 32)
+#define PERF_RAW_IBS_FETCH	1
+#define PERF_RAW_IBS_OP		2
 
-static inline int get_model_spec_type(u64 config)
-{
-	return (config & MODEL_SPEC_TYPE_MASK) >> 32;
-}
+#define PERF_RAW_IBS_BASE	PERF_RAW_IBS_FETCH
 
 /*
  * struct x86_pmu - generic x86 pmu
@@ -405,15 +396,12 @@ static void release_pmc_hardware(void) {}
 
 static int reserve_ds_buffers(void);
 static void release_ds_buffers(void);
-static int reserve_ibs_hardware(void);
-static void release_ibs_hardware(void);
 
 static void hw_perf_event_destroy(struct perf_event *event)
 {
 	if (atomic_dec_and_mutex_lock(&active_events, &pmc_reserve_mutex)) {
 		release_pmc_hardware();
 		release_ds_buffers();
-		release_ibs_hardware();
 		mutex_unlock(&pmc_reserve_mutex);
 	}
 }
@@ -462,9 +450,6 @@ static int x86_setup_perfctr(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	u64 config;
 
-	if (attr->model_spec)
-		return -EOPNOTSUPP;
-
 	if (!hwc->sample_period) {
 		hwc->sample_period = x86_pmu.max_period;
 		hwc->last_period = hwc->sample_period;
@@ -480,8 +465,11 @@ static int x86_setup_perfctr(struct perf_event *event)
 			return -EOPNOTSUPP;
 	}
 
-	if (attr->type == PERF_TYPE_RAW)
+	if (attr->type == PERF_TYPE_RAW) {
+		if (attr->raw_type)
+			return -EINVAL;
 		return 0;
+	}
 
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, attr);
@@ -556,6 +544,8 @@ static int x86_pmu_hw_config(struct perf_event *event)
 	return x86_setup_perfctr(event);
 }
 
+static inline void init_ibs_nmi(void);
+
 /*
  * Setup the hardware configuration for a given attr_type
  */
@@ -577,13 +567,8 @@ static int __hw_perf_event_init(struct perf_event *event)
 				if (err)
 					release_pmc_hardware();
 			}
-			if (!err) {
-				err = reserve_ibs_hardware();
-				if (err) {
-					release_ds_buffers();
-					release_pmc_hardware();
-				}
-			}
+			if (!err)
+				init_ibs_nmi();
 		}
 		if (!err)
 			atomic_inc(&active_events);
@@ -1324,6 +1309,7 @@ static void __init pmu_check_apic(void)
 		return;
 
 	x86_pmu.apic = 0;
+	x86_pmu.ibs = 0;
 	pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
 	pr_info("no hardware sampling interrupt available.\n");
 }
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 78b0b34..a083174 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -2,9 +2,42 @@
 
 #include <linux/pci.h>
 
+#define IBS_FETCH_MAP_IDX	(PERF_RAW_IBS_FETCH - PERF_RAW_IBS_BASE)
+#define IBS_OP_MAP_IDX		(PERF_RAW_IBS_OP - PERF_RAW_IBS_BASE)
+
 #define IBS_FETCH_CONFIG_MASK	(IBS_FETCH_RAND_EN | IBS_FETCH_MAX_CNT)
-#define IBS_OP_CONFIG_MASK	(IBS_OP_CNT_CTL | IBS_OP_MAX_CNT)
-#define AMD64_NUM_COUNTERS	4
+#define IBS_OP_CONFIG_MASK	IBS_OP_MAX_CNT
+
+struct ibs_map {
+	int idx;
+	u64 cnt_mask;
+	u64 sample_valid;
+	u64 enable;
+	u64 valid_mask;
+	unsigned int msr;
+	int reg_count;
+};
+
+static struct ibs_map ibs_map[] = {
+	[IBS_FETCH_MAP_IDX] = {
+		.idx		= X86_PMC_IDX_SPECIAL_IBS_FETCH,
+		.cnt_mask	= IBS_FETCH_MAX_CNT,
+		.sample_valid	= IBS_FETCH_VAL,
+		.enable		= IBS_FETCH_ENABLE,
+		.valid_mask	= IBS_FETCH_CONFIG_MASK,
+		.msr		= MSR_AMD64_IBSFETCHCTL,
+		.reg_count	= MSR_AMD64_IBSFETCH_REG_COUNT,
+	},
+	[IBS_OP_MAP_IDX] = {
+		.idx		= X86_PMC_IDX_SPECIAL_IBS_OP,
+		.cnt_mask	= IBS_OP_MAX_CNT,
+		.sample_valid	= IBS_OP_VAL,
+		.enable		= IBS_OP_ENABLE,
+		.valid_mask	= IBS_OP_CONFIG_MASK,
+		.msr		= MSR_AMD64_IBSOPCTL,
+		.reg_count	= MSR_AMD64_IBSOP_REG_COUNT,
+	},
+};
 
 static DEFINE_RAW_SPINLOCK(amd_nb_lock);
 
@@ -116,28 +149,22 @@ static const u64 amd_perfmon_event_map[] =
 
 /* IBS - apic initialization, taken from oprofile, should be unified */
 
-static u8 ibs_eilvt_off;
-
-static inline void apic_init_ibs_nmi_per_cpu(void *arg)
-{
-	ibs_eilvt_off = setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
-}
-
-static inline void apic_clear_ibs_nmi_per_cpu(void *arg)
-{
-	setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
-}
+/*
+ * Currently there is no early pci ecs access implemented, so this
+ * can't be put into amd_pmu_init(). For now we initialize it in
+ * __hw_perf_event_init().
+ */
 
-static int init_ibs_nmi(void)
+static int __init_ibs_nmi(void)
 {
 #define IBSCTL_LVTOFFSETVAL		(1 << 8)
 #define IBSCTL				0x1cc
 	struct pci_dev *cpu_cfg;
 	int nodes;
 	u32 value = 0;
+	u8 ibs_eilvt_off;
 
-	/* per CPU setup */
-	on_each_cpu(apic_init_ibs_nmi_per_cpu, NULL, 1);
+	ibs_eilvt_off = setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
 
 	nodes = 0;
 	cpu_cfg = NULL;
@@ -167,36 +194,36 @@ static int init_ibs_nmi(void)
 	return 0;
 }
 
-/* uninitialize the APIC for the IBS interrupts if needed */
-static void clear_ibs_nmi(void)
-{
-	on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
-}
-
-#else
-
-static inline int init_ibs_nmi(void) { return 1; }
-static inline void clear_ibs_nmi(void) { }
-
-#endif
-
-static int reserve_ibs_hardware(void)
+static inline void init_ibs_nmi(void)
 {
 	if (!x86_pmu.ibs)
-		return 0;
-	if (init_ibs_nmi())
+		return;
+
+	if (__init_ibs_nmi())
 		/* something went wrong, disable ibs */
 		x86_pmu.ibs = 0;
-	return 0;
 }
 
-static void release_ibs_hardware(void)
+static inline void apic_init_ibs(void)
 {
-	if (!x86_pmu.ibs)
-		return;
-	clear_ibs_nmi();
+	if (x86_pmu.ibs)
+		setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
 }
 
+static inline void apic_clear_ibs(void)
+{
+	if (x86_pmu.ibs)
+		setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
+}
+
+#else
+
+static inline void init_ibs_nmi(void) { }
+static inline void apic_init_ibs(void) { }
+static inline void apic_clear_ibs(void) { }
+
+#endif
+
 static inline void amd_pmu_disable_ibs(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -233,45 +260,56 @@ static inline void amd_pmu_enable_ibs(void)
 
 static int amd_pmu_ibs_config(struct perf_event *event)
 {
-	int type;
+	int map_idx;
+	u64 max_cnt, config;
+	struct ibs_map *map;
 
 	if (!x86_pmu.ibs)
 		return -ENODEV;
 
-	if (event->hw.sample_period)
-		/*
-		 * The usage of the sample period attribute to
-		 * calculate the IBS max count value is not yet
-		 * supported, the max count must be in the raw config
-		 * value.
-		 */
-		return -ENOSYS;
-
 	if (event->attr.type != PERF_TYPE_RAW)
 		/* only raw sample types are supported */
 		return -EINVAL;
 
-	type = get_model_spec_type(event->attr.config);
-	switch (type) {
-	case MODEL_SPEC_TYPE_IBS_FETCH:
-		event->hw.config = IBS_FETCH_CONFIG_MASK & event->attr.config;
-		event->hw.idx = X86_PMC_IDX_SPECIAL_IBS_FETCH;
-		/*
-		 * dirty hack, needed for __x86_pmu_enable_event(), we
-		 * should better change event->hw.config_base into
-		 * event->hw.config_msr that already includes the index
-		 */
-		event->hw.config_base = MSR_AMD64_IBSFETCHCTL - event->hw.idx;
-		break;
-	case MODEL_SPEC_TYPE_IBS_OP:
-		event->hw.config = IBS_OP_CONFIG_MASK & event->attr.config;
-		event->hw.idx = X86_PMC_IDX_SPECIAL_IBS_OP;
-		event->hw.config_base = MSR_AMD64_IBSOPCTL - event->hw.idx;
-		break;
-	default:
+	if (event->attr.raw_type < PERF_RAW_IBS_BASE)
+		return -ENODEV;
+	map_idx = event->attr.raw_type - PERF_RAW_IBS_BASE;
+	if (map_idx >= ARRAY_SIZE(ibs_map))
 		return -ENODEV;
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
 	}
 
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
 	return 0;
 }
 
@@ -283,30 +321,33 @@ static inline void __amd_pmu_enable_ibs_event(struct hw_perf_event *hwc)
 		__x86_pmu_enable_event(hwc, IBS_OP_ENABLE);
 }
 
-static int amd_pmu_check_ibs(int idx, unsigned int msr, u64 valid,
-			     u64 reenable, int size, struct pt_regs *iregs)
+static int amd_pmu_check_ibs(struct pt_regs *iregs, int map_idx)
 {
+	struct ibs_map *map = &ibs_map[map_idx];
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct perf_event *event = cpuc->events[idx];
+	struct perf_event *event = cpuc->events[map->idx];
 	struct perf_sample_data data;
 	struct perf_raw_record raw;
 	struct pt_regs regs;
-	u64 buffer[MSR_AMD64_IBS_SIZE_MAX];
-	u64 *buf = buffer;
+	u64 buffer[MSR_AMD64_IBS_REG_COUNT_MAX];
 	int i;
+	unsigned int msr;
+	u64 *buf;
 
-	if (!test_bit(idx, cpuc->active_mask))
+	if (!test_bit(map->idx, cpuc->active_mask))
 		return 0;
 
+	msr = map->msr;
+	buf = buffer;
 	rdmsrl(msr++, *buf);
-	if (!(*buf++ & valid))
+	if (!(*buf++ & map->sample_valid))
 		return 0;
 
 	perf_sample_data_init(&data, 0);
 	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
-		for (i = 1; i < size; i++)
+		for (i = 1; i < map->reg_count; i++)
 			rdmsrl(msr++, *buf++);
-		raw.size = sizeof(u64) * size;
+		raw.size = sizeof(u32) + sizeof(u64) * map->reg_count;
 		raw.data = buffer;
 		data.raw = &raw;
 	}
@@ -316,7 +357,7 @@ static int amd_pmu_check_ibs(int idx, unsigned int msr, u64 valid,
 	if (perf_event_overflow(event, 1, &data, &regs))
 		x86_pmu_stop(event);
 	else
-		__x86_pmu_enable_event(&event->hw, reenable);
+		__x86_pmu_enable_event(&event->hw, map->enable);
 
 	return 1;
 }
@@ -331,16 +372,9 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 		return handled;
 
 	handled2 = 0;
-	handled2 += amd_pmu_check_ibs(X86_PMC_IDX_SPECIAL_IBS_FETCH,
-				      MSR_AMD64_IBSFETCHCTL, IBS_FETCH_VAL,
-				      IBS_FETCH_ENABLE, MSR_AMD64_IBSFETCH_SIZE,
-				      regs);
-	handled2 += amd_pmu_check_ibs(X86_PMC_IDX_SPECIAL_IBS_OP,
-				      MSR_AMD64_IBSOPCTL, IBS_OP_VAL,
-				      IBS_OP_ENABLE, MSR_AMD64_IBSOP_SIZE,
-				      regs);
-
-	if (handled2)
+	handled2 += amd_pmu_check_ibs(regs, IBS_FETCH_MAP_IDX);
+	handled2 += amd_pmu_check_ibs(regs, IBS_OP_MAP_IDX);
+	if (!handled && handled2)
 		inc_irq_stat(apic_perf_irqs);
 
 	return (handled || handled2);
@@ -381,7 +415,7 @@ static int amd_pmu_hw_config(struct perf_event *event)
 {
 	int ret;
 
-	if (event->attr.model_spec)
+	if (event->attr.raw_type)
 		return amd_pmu_ibs_config(event);
 
 	ret = x86_pmu_hw_config(event);
@@ -392,6 +426,9 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	if (event->attr.type != PERF_TYPE_RAW)
 		return 0;
 
+	if (event->attr.raw_type)
+		return -EINVAL;
+
 	event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
 
 	return 0;
@@ -407,10 +444,8 @@ static struct event_constraint amd_event_constraints[] =
 	 * than in the unconstrainted case to process ibs after the
 	 * generic counters in x86_schedule_events().
 	 */
-	__EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_SPECIAL_IBS_FETCH, 0,
-			   AMD64_NUM_COUNTERS + 1),
-	__EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_SPECIAL_IBS_OP, 0,
-			   AMD64_NUM_COUNTERS + 1),
+	AMD_IBS_EVENT_CONSTRAINT(X86_PMC_IDX_SPECIAL_IBS_FETCH),
+	AMD_IBS_EVENT_CONSTRAINT(X86_PMC_IDX_SPECIAL_IBS_OP),
 	EVENT_CONSTRAINT_END
 };
 
@@ -644,6 +679,8 @@ static void amd_pmu_cpu_starting(int cpu)
 	cpuc->amd_nb->refcnt++;
 
 	raw_spin_unlock(&amd_nb_lock);
+
+	apic_init_ibs();
 }
 
 static void amd_pmu_cpu_dead(int cpu)
@@ -667,6 +704,8 @@ static void amd_pmu_cpu_dead(int cpu)
 	}
 
 	raw_spin_unlock(&amd_nb_lock);
+
+	apic_clear_ibs();
 }
 
 static __initconst const struct x86_pmu amd_pmu = {
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 8a16205..dfbbe69 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -770,6 +770,9 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (event->attr.type != PERF_TYPE_RAW)
 		return 0;
 
+	if (event->attr.raw_type)
+		return -EINVAL;
+
 	if (!(event->attr.config & ARCH_PERFMON_EVENTSEL_ANY))
 		return 0;
 
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 87e1803..1001892 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -437,6 +437,11 @@ static int p4_hw_config(struct perf_event *event)
 		event->hw.config = p4_set_ht_bit(event->hw.config);
 
 	if (event->attr.type == PERF_TYPE_RAW) {
+		/* only raw perfctr config supported */
+		if (event->attr.raw_type) {
+			rc = -EINVAL;
+			goto out;
+		}
 
 		/* user data may have out-of-bound event index */
 		evnt = p4_config_unpack_event(event->attr.config);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b50f4cf..f9d2d5e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -214,16 +214,18 @@ struct perf_event_attr {
 				 *  See also PERF_RECORD_MISC_EXACT_IP
 				 */
 				precise_ip     :  2, /* skid constraint       */
-				model_spec     :  1, /* model specific hw event */
 
-				__reserved_1   : 46;
+				__reserved_1   : 47;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
 		__u32		wakeup_watermark; /* bytes before wakeup   */
 	};
 
-	__u32			bp_type;
+	union {
+		__u32		bp_type;
+		__u32		raw_type;
+	};
 	__u64			bp_addr;
 	__u64			bp_len;
 };



