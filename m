Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2KUMvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:51:53 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33190 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab2KUMvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:51:47 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v3 08/19] perf/x86: add memory profiling via PEBS Load Latency
Date: Wed, 21 Nov 2012 13:49:34 +0100
Message-Id: <1353502185-26521-9-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353502185-26521-1-git-send-email-eranian@google.com>
References: <1353502185-26521-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for memory profiling using the
PEBS Load Latency facility.

Load accesses are sampled by HW and the instruction
address, data address, load latency, data source, tlb,
locked information can be saved in the sampling buffer
if using the PERF_SAMPLE_COST (for latency),
PERF_SAMPLE_ADDR, PERF_SAMPLE_DSRC types.

To enable PEBS Load Latency, users have to use the
model specific event:
- on NHM/WSM: MEM_INST_RETIRED:LATENCY_ABOVE_THRESHOLD
- on SNB/IVB: MEM_TRANS_RETIRED:LATENCY_ABOVE_THRESHOLD

To make things easier, this patch also exports a generic
alias via sysfs: mem-loads. It export the right event
encoding based on the host CPU and can be used directly
by the perf tool.

Loosely based on Intel's Lin Ming patch posted on LKML
in July 2011.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/include/asm/msr-index.h          |    1 +
 arch/x86/kernel/cpu/perf_event.c          |    5 +-
 arch/x86/kernel/cpu/perf_event.h          |   25 +++++-
 arch/x86/kernel/cpu/perf_event_intel.c    |   24 ++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  133 +++++++++++++++++++++++++++--
 5 files changed, 178 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index e400cdb..135b673 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -66,6 +66,7 @@
 #define MSR_IA32_PEBS_ENABLE		0x000003f1
 #define MSR_IA32_DS_AREA		0x00000600
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
+#define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
 
 #define MSR_MTRRfix64K_00000		0x00000250
 #define MSR_MTRRfix16K_80000		0x00000258
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1dbd9b1..c69317a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1367,7 +1367,7 @@ static __init struct attribute **merge_attr(struct attribute **a,
 	return new;
 }
  
-static ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
+ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
 			  char *page)
 {
 	struct perf_pmu_events_attr *pmu_attr = \
@@ -1498,6 +1498,9 @@ static int __init init_hw_perf_events(void)
 	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
 	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
 
+	if (x86_pmu.event_attrs)
+		x86_pmu_events_group.attrs = x86_pmu.event_attrs;
+
 	if (!x86_pmu.events_sysfs_show)
 		x86_pmu_events_group.attrs = &empty_attrs;
 	else
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3f10cfe..3f91411 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -46,6 +46,7 @@ enum extra_reg_type {
 	EXTRA_REG_RSP_0 = 0,	/* offcore_response_0 */
 	EXTRA_REG_RSP_1 = 1,	/* offcore_response_1 */
 	EXTRA_REG_LBR   = 2,	/* lbr_select */
+	EXTRA_REG_LDLAT = 3,	/* ld_lat_threshold */
 
 	EXTRA_REG_MAX		/* number of entries needed */
 };
@@ -61,6 +62,10 @@ struct event_constraint {
 	int	overlap;
 	int	flags;
 };
+/*
+ * struct event_constraint flags
+ */
+#define PERF_X86_EVENT_PEBS_LDLAT	0x1 /* ld+ldlat data address sampling */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
@@ -233,6 +238,10 @@ struct cpu_hw_events {
 #define INTEL_UEVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
 
+#define INTEL_PLD_CONSTRAINT(c, n)	\
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
+			   HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LDLAT)
+
 #define EVENT_CONSTRAINT_END		\
 	EVENT_CONSTRAINT(0, 0, 0)
 
@@ -262,12 +271,22 @@ struct extra_reg {
 	.msr = (ms),		\
 	.config_mask = (m),	\
 	.valid_mask = (vm),	\
-	.idx = EXTRA_REG_##i	\
+	.idx = EXTRA_REG_##i,	\
 	}
 
 #define INTEL_EVENT_EXTRA_REG(event, msr, vm, idx)	\
 	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, idx)
 
+#define INTEL_UEVENT_EXTRA_REG(event, msr, vm, idx) \
+	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT | \
+			ARCH_PERFMON_EVENTSEL_UMASK, vm, idx)
+
+#define INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(c) \
+	INTEL_UEVENT_EXTRA_REG(c, \
+			       MSR_PEBS_LD_LAT_THRESHOLD, \
+			       0xffff, \
+			       LDLAT)
+
 #define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, RSP_0)
 
 union perf_capabilities {
@@ -355,6 +374,7 @@ struct x86_pmu {
 	 */
 	int		attr_rdpmc;
 	struct attribute **format_attrs;
+	struct attribute **event_attrs;
 
 	ssize_t		(*events_sysfs_show)(char *page, u64 config);
 	struct attribute **cpu_events;
@@ -659,6 +679,9 @@ int p6_pmu_init(void);
 
 int knc_pmu_init(void);
 
+ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
+			  char *page);
+
 #else /* CONFIG_CPU_SUP_INTEL */
 
 static inline void reserve_ds_buffers(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 57d6527..1d2a7ca 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -81,6 +81,7 @@ static struct event_constraint intel_nehalem_event_constraints[] __read_mostly =
 static struct extra_reg intel_nehalem_extra_regs[] __read_mostly =
 {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
+	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x100b),
 	EVENT_EXTRA_END
 };
 
@@ -111,6 +112,7 @@ static struct extra_reg intel_westmere_extra_regs[] __read_mostly =
 {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
 	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff, RSP_1),
+	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x100b),
 	EVENT_EXTRA_END
 };
 
@@ -130,9 +132,23 @@ static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffffffffull, RSP_0),
 	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
+	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
 	EVENT_EXTRA_END
 };
 
+EVENT_ATTR_STR(mem-loads, mem_ld_nhm, "event=0x0b,umask=0x10,ldlat=3");
+EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");
+
+struct attribute *nhm_events_attrs[] = {
+	EVENT_PTR(mem_ld_nhm),
+	NULL,
+};
+
+struct attribute *snb_events_attrs[] = {
+	EVENT_PTR(mem_ld_snb),
+	NULL,
+};
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -2009,6 +2025,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.extra_regs = intel_nehalem_extra_regs;
 
+		x86_pmu.cpu_events = nhm_events_attrs;
+
 		/* UOPS_ISSUED.STALLED_CYCLES */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
@@ -2049,6 +2067,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.extra_regs = intel_westmere_extra_regs;
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 
+		x86_pmu.cpu_events = nhm_events_attrs;
+
 		/* UOPS_ISSUED.STALLED_CYCLES */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
@@ -2077,6 +2097,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
 
+		x86_pmu.cpu_events = snb_events_attrs;
+
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
@@ -2102,6 +2124,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
 
+		x86_pmu.cpu_events = snb_events_attrs;
+
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index f30d85b..759b0c0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -24,6 +24,92 @@ struct pebs_record_32 {
 
  */
 
+union intel_x86_pebs_dse {
+	u64 val;
+	struct {
+		unsigned int ld_dse:4;
+		unsigned int ld_stlb_miss:1;
+		unsigned int ld_locked:1;
+		unsigned int ld_reserved:26;
+	};
+	struct {
+		unsigned int st_l1d_hit:1;
+		unsigned int st_reserved1:3;
+		unsigned int st_stlb_miss:1;
+		unsigned int st_locked:1;
+		unsigned int st_reserved2:26;
+	};
+};
+
+
+/*
+ * Map PEBS Load Latency Data Source encodings to generic
+ * memory data source information
+ */
+#define P(a, b) PERF_MEM_S(a, b)
+#define OP_LH (P(OP, LOAD) | P(LVL, HIT))
+#define SNOOP_NONE_MISS (P(SNOOP, NONE) | P(SNOOP, MISS))
+
+static const u64 pebs_data_source[] = {
+	P(OP, LOAD) | P(LVL, MISS) | P(LVL, L3) | P(SNOOP, NA),/* 0x00:ukn L3 */
+	OP_LH | P(LVL, L1) | P(SNOOP, NONE),	/* 0x01: L1 local */
+	OP_LH | P(LVL, LFB)| P(SNOOP, NONE),	/* 0x02: LFB hit */
+	OP_LH | P(LVL, L2) | P(SNOOP, NONE),	/* 0x03: L2 hit */
+	OP_LH | P(LVL, L3) | P(SNOOP, NONE),	/* 0x04: L3 hit */
+	OP_LH | P(LVL, L3) | P(SNOOP, MISS),	/* 0x05: L3 hit, snoop miss */
+	OP_LH | P(LVL, L3) | P(SNOOP, HIT),	/* 0x06: L3 hit, snoop hit */
+	OP_LH | P(LVL, L3) | P(SNOOP, HITM),	/* 0x07: L3 hit, snoop hitm */
+	OP_LH | P(LVL, REM_CCE1) | P(SNOOP, HIT),  /* 0x08: L3 miss snoop hit */
+	OP_LH | P(LVL, REM_CCE1) | P(SNOOP, HITM), /* 0x09: L3 miss snoop hitm*/
+	OP_LH | P(LVL, LOC_RAM)  | P(SNOOP, HIT),  /* 0x0a: L3 miss, shared */
+	OP_LH | P(LVL, REM_RAM1) | P(SNOOP, HIT),  /* 0x0b: L3 miss, shared */
+	OP_LH | P(LVL, LOC_RAM)  | SNOOP_NONE_MISS,/* 0x0c: L3 miss, excl */
+	OP_LH | P(LVL, REM_RAM1) | SNOOP_NONE_MISS,/* 0x0d: L3 miss, excl */
+	OP_LH | P(LVL, IO) | P(SNOOP, NONE), /* 0x0e: I/O */
+	OP_LH | P(LVL,UNC) | P(SNOOP, NONE), /* 0x0f: uncached */
+};
+
+static u64 load_latency_data(u64 status)
+{
+	union intel_x86_pebs_dse dse;
+	u64 val;
+	int model = boot_cpu_data.x86_model;
+	int fam = boot_cpu_data.x86;
+
+	dse.val = status;
+
+	/*
+	 * use the mapping table for bit 0-3
+	 */
+	val = pebs_data_source[dse.ld_dse];
+
+	/*
+	 * Nehalem models do not support TLB, Lock infos
+	 */
+	if (fam == 0x6 && (model == 26 || model == 30
+	    || model == 31 || model == 46)) {
+		val |= P(TLB, NA) | P(LOCK, NA);
+		return val;
+	}
+	/*
+	 * bit 4: TLB access
+	 * 0 = did not miss 2nd level TLB
+	 * 1 = missed 2nd level TLB
+	 */
+	if (dse.ld_stlb_miss)
+		val |= P(TLB, MISS) | P(TLB, L2);
+	else
+		val |= P(TLB, HIT) | P(TLB,L1) | P(TLB, L2);
+
+	/*
+	 * bit 5: locked prefix
+	 */
+	if (dse.ld_locked)
+		val |= P(LOCK, LOCKED);
+
+	return val;
+}
+
 struct pebs_record_core {
 	u64 flags, ip;
 	u64 ax, bx, cx, dx;
@@ -364,7 +450,7 @@ struct event_constraint intel_atom_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_nehalem_pebs_event_constraints[] = {
-	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),    /* MEM_INST_RETIRED.* */
+	INTEL_PLD_CONSTRAINT(0x100b, 0xf),      /* MEM_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
 	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),    /* INST_RETIRED.ANY */
@@ -379,7 +465,7 @@ struct event_constraint intel_nehalem_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_westmere_pebs_event_constraints[] = {
-	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),    /* MEM_INST_RETIRED.* */
+	INTEL_PLD_CONSTRAINT(0x100b, 0xf),      /* MEM_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
 	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),    /* INSTR_RETIRED.* */
@@ -399,7 +485,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
 	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
+	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
@@ -413,7 +499,7 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
         INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
         INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
         INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
-        INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
+        INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
         INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
         INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
         INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
@@ -448,6 +534,9 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
+
+	if (event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT)
+		cpuc->pebs_enabled |= 1ULL << (hwc->idx + 32);
 }
 
 void intel_pmu_pebs_disable(struct perf_event *event)
@@ -560,20 +649,48 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs, void *__pebs)
 {
 	/*
-	 * We cast to pebs_record_core since that is a subset of
-	 * both formats and we don't use the other fields in this
-	 * routine.
+	 * We cast to pebs_record_nhm to get the load latency data
+	 * if extra_reg MSR_PEBS_LD_LAT_THRESHOLD used
 	 */
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct pebs_record_core *pebs = __pebs;
+	struct pebs_record_nhm *pebs = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
+	u64 sample_type;
+	int fll;
 
 	if (!intel_pmu_save_and_restart(event))
 		return;
 
+	fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
+
 	perf_sample_data_init(&data, 0, event->hw.last_period);
 
+	data.period = event->hw.last_period;
+	sample_type = event->attr.sample_type;
+
+	/*
+	 * if PEBS-LL or PreciseStore
+	 */
+	if (fll) {
+		if (sample_type & PERF_SAMPLE_ADDR)
+			data.addr = pebs->dla;
+
+		/*
+		 * Use latency for weight (only avail with PEBS-LL)
+		 */
+		if (fll && (sample_type & PERF_SAMPLE_WEIGHT))
+			data.weight = pebs->lat;
+
+		/*
+		 * data.dsrc encodes the data source
+		 */
+		if (sample_type & PERF_SAMPLE_DSRC) {
+			if (fll)
+				data.dsrc.val = load_latency_data(pebs->dse);
+		}
+	}
+
 	/*
 	 * We use the interrupt regs as a base because the PEBS record
 	 * does not contain a full regs set, specifically it seems to
-- 
1.7.9.5

