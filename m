Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab1GDH5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 03:57:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:47700 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab1GDH4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 03:56:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,471,1304319600"; 
   d="scan'208";a="23490041"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] perf, x86: Add Intel Nhm/Wsm/Snb load latency support
Date: Mon,  4 Jul 2011 08:02:03 +0000
Message-Id: <1309766525-14089-3-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements Intel memory load event for Nehalem/Westmere/SandyBridge.

$ perf mem -t load record make -j8

<building kernel ..., monitoring memory load opeartion>

$ perf mem -t load report

Memory load operation statistics
================================
                      L1-local: total latency=   28027, count=    3355(avg=8)
                      L2-snoop: total latency=    1430, count=      29(avg=49)
                      L2-local: total latency=     124, count=       8(avg=15)
             L3-snoop, found M: total latency=     452, count=       4(avg=113)
          L3-snoop, found no M: total latency=       0, count=       0(avg=0)
L3-snoop, no coherency actions: total latency=     875, count=      18(avg=48)
        L3-miss, snoop, shared: total latency=       0, count=       0(avg=0)
     L3-miss, local, exclusive: total latency=       0, count=       0(avg=0)
        L3-miss, local, shared: total latency=       0, count=       0(avg=0)
    L3-miss, remote, exclusive: total latency=       0, count=       0(avg=0)
       L3-miss, remote, shared: total latency=       0, count=       0(avg=0)
                    Unknown L3: total latency=       0, count=       0(avg=0)
                            IO: total latency=       0, count=       0(avg=0)
                      Uncached: total latency=     464, count=      30(avg=15)

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/include/asm/msr-index.h          |    2 +
 arch/x86/kernel/cpu/perf_event.c          |   10 ++++++
 arch/x86/kernel/cpu/perf_event_intel.c    |   20 +++++++++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   49 ++++++++++++++++++++++++++--
 4 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 485b4f1..da93a9d 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -60,6 +60,8 @@
 #define MSR_IA32_DS_AREA		0x00000600
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
 
+#define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
+
 #define MSR_MTRRfix64K_00000		0x00000250
 #define MSR_MTRRfix16K_80000		0x00000258
 #define MSR_MTRRfix16K_A0000		0x00000259
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3a0338b..ce380a7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -207,6 +207,9 @@ struct extra_reg {
 #define INTEL_EVENT_EXTRA_REG(event, msr, vm)	\
 	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm)
 #define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0)
+#define INTEL_EVENT_EXTRA_REG2(event, msr, vm)    \
+	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT | \
+			ARCH_PERFMON_EVENTSEL_UMASK, vm)
 
 union perf_capabilities {
 	struct {
@@ -406,6 +409,11 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
 			continue;
 		if (event->attr.config1 & ~er->valid_mask)
 			return -EINVAL;
+
+		/* The minimum value that may be programmed into MSR_PEBS_LD_LAT is 3 */
+		if (er->msr == MSR_PEBS_LD_LAT_THRESHOLD && event->attr.config1 < 3)
+			return -EINVAL;
+
 		event->hw.extra_reg = er->msr;
 		event->hw.extra_config = event->attr.config1;
 		break;
@@ -617,6 +625,8 @@ static int x86_setup_perfctr(struct perf_event *event)
 	if (config == -1LL)
 		return -EINVAL;
 
+	x86_pmu_extra_regs(config, event);
+
 	/*
 	 * Branch tracing:
 	 */
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 41178c8..dde9041 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1,6 +1,6 @@
 #ifdef CONFIG_CPU_SUP_INTEL
 
-#define MAX_EXTRA_REGS 2
+#define MAX_EXTRA_REGS 3
 
 /*
  * Per register state.
@@ -89,6 +89,7 @@ static struct event_constraint intel_nehalem_event_constraints[] __read_mostly =
 static struct extra_reg intel_nehalem_extra_regs[] __read_mostly =
 {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff),
+	INTEL_EVENT_EXTRA_REG2(0x100b, MSR_PEBS_LD_LAT_THRESHOLD, 0xffff),
 	EVENT_EXTRA_END
 };
 
@@ -123,10 +124,17 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 	EVENT_CONSTRAINT_END
 };
 
+static struct extra_reg intel_snb_extra_regs[] __read_mostly =
+{
+	INTEL_EVENT_EXTRA_REG2(0x01cd, MSR_PEBS_LD_LAT_THRESHOLD, 0xffff),
+	EVENT_EXTRA_END
+};
+
 static struct extra_reg intel_westmere_extra_regs[] __read_mostly =
 {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff),
 	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff),
+	INTEL_EVENT_EXTRA_REG2(0x100b, MSR_PEBS_LD_LAT_THRESHOLD, 0xffff),
 	EVENT_EXTRA_END
 };
 
@@ -1445,6 +1453,9 @@ static __init int intel_pmu_init(void)
 		/* UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x1803fb1;
 
+		/* Memory load latency */
+		intel_perfmon_event_map[PERF_COUNT_HW_MEM_LOAD] = 0x100b;
+
 		if (ebx & 0x40) {
 			/*
 			 * Erratum AAJ80 detected, we work it around by using
@@ -1491,6 +1502,9 @@ static __init int intel_pmu_init(void)
 		/* UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x1803fb1;
 
+		/* Memory load latency */
+		intel_perfmon_event_map[PERF_COUNT_HW_MEM_LOAD] = 0x100b;
+
 		pr_cont("Westmere events, ");
 		break;
 
@@ -1502,12 +1516,16 @@ static __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_events;
+		x86_pmu.extra_regs = intel_snb_extra_regs;
 
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
 		/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x18001b1;
 
+		/* Memory load latency */
+		intel_perfmon_event_map[PERF_COUNT_HW_MEM_LOAD] = 0x01cd;
+
 		pr_cont("SandyBridge events, ");
 		break;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index bab491b..d2d3155 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -1,5 +1,28 @@
 #ifdef CONFIG_CPU_SUP_INTEL
 
+/* Indexed by Intel load latency data source encoding value */
+
+static u64 load_latency_data_source[] = {
+	MEM_LOAD_UNKNOWN | MEM_LOAD_TOGGLE,			/* 0x00: Unknown L3 */
+	MEM_LOAD_L1 | MEM_LOAD_LOCAL,				/* 0x01: L1-local */
+	MEM_LOAD_L2 | MEM_LOAD_SNOOP,				/* 0x02: L2-snoop */
+	MEM_LOAD_L2 | MEM_LOAD_LOCAL,				/* 0x03: L2-local */
+	MEM_LOAD_L3 | MEM_LOAD_SNOOP | MEM_LOAD_INVALID,	/* 0x04: L3-snoop, no coherency actions */
+	MEM_LOAD_L3 | MEM_LOAD_SNOOP | MEM_LOAD_SHARED,		/* 0x05: L3-snoop, found no M */
+	MEM_LOAD_L3 | MEM_LOAD_SNOOP | MEM_LOAD_MODIFIED,	/* 0x06: L3-snoop, found M */
+	MEM_LOAD_RESERVED,					/* 0x07: reserved */
+	MEM_LOAD_RAM | MEM_LOAD_SNOOP | MEM_LOAD_SHARED,	/* 0x08: L3-miss, snoop, shared */
+	MEM_LOAD_RESERVED,					/* 0x09: reserved */
+	MEM_LOAD_RAM | MEM_LOAD_LOCAL | MEM_LOAD_SHARED,	/* 0x0A: L3-miss, local, shared */
+	MEM_LOAD_RAM | MEM_LOAD_REMOTE | MEM_LOAD_SHARED,	/* 0x0B: L3-miss, remote, shared */
+	MEM_LOAD_RAM | MEM_LOAD_LOCAL | MEM_LOAD_EXCLUSIVE,	/* 0x0C: L3-miss, local, exclusive */
+	MEM_LOAD_RAM | MEM_LOAD_REMOTE | MEM_LOAD_EXCLUSIVE,	/* 0x0D: L3-miss, remote, exclusive */
+	MEM_LOAD_IO | MEM_LOAD_TOGGLE,				/* 0x0E: IO */
+	MEM_LOAD_UNCACHED | MEM_LOAD_TOGGLE,			/* 0x0F: Uncached */
+};
+
+#define LOAD_LATENCY_DATA_SOURCE_MASK	0x0FULL
+
 /* The maximal number of PEBS events: */
 #define MAX_PEBS_EVENTS		4
 
@@ -454,6 +477,8 @@ static void intel_pmu_pebs_enable(struct perf_event *event)
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
+	if (hwc->extra_reg == MSR_PEBS_LD_LAT_THRESHOLD)
+		cpuc->pebs_enabled |= 1ULL << (hwc->idx + 32);
 	WARN_ON_ONCE(cpuc->enabled);
 
 	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
@@ -466,6 +491,8 @@ static void intel_pmu_pebs_disable(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 
 	cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
+	if (hwc->extra_reg == MSR_PEBS_LD_LAT_THRESHOLD)
+		cpuc->pebs_enabled &= ~(1ULL << (hwc->idx + 32));
 	if (cpuc->enabled)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
 
@@ -582,13 +609,13 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs, void *__pebs)
 {
 	/*
-	 * We cast to pebs_record_core since that is a subset of
-	 * both formats and we don't use the other fields in this
-	 * routine.
+	 * We cast to pebs_record_nhm to get the load latency data
+	 * if extra_reg MSR_PEBS_LD_LAT_THRESHOLD used
 	 */
-	struct pebs_record_core *pebs = __pebs;
+	struct pebs_record_nhm *pebs = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
+	u64 sample_type;
 
 	if (!intel_pmu_save_and_restart(event))
 		return;
@@ -596,6 +623,20 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	perf_sample_data_init(&data, 0);
 	data.period = event->hw.last_period;
 
+	if (event->attr.config == PERF_COUNT_HW_MEM_LOAD) {
+		sample_type = event->attr.sample_type;
+
+		if (sample_type & PERF_SAMPLE_ADDR)
+			data.addr = pebs->dla;
+
+		if (sample_type & PERF_SAMPLE_LATENCY)
+			data.latency = pebs->lat;
+
+		if (sample_type & PERF_SAMPLE_EXTRA)
+			data.extra = load_latency_data_source[pebs->dse &
+					LOAD_LATENCY_DATA_SOURCE_MASK];
+	}
+
 	/*
 	 * We use the interrupt regs as a base because the PEBS record
 	 * does not contain a full regs set, specifically it seems to
-- 
1.7.5.1

