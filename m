Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0L0PlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 10:41:00 -0500
Received: from mga03.intel.com ([143.182.124.21]:25673 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab0L0Pk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 10:40:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,234,1291622400"; 
   d="scan'208";a="366932221"
Subject: [PATCH 7/7] perf: Add load latency monitoring on Intel
 Nehalem/Westmere v2
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Dec 2010 23:39:57 +0800
Message-Id: <1293464397.2695.109.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 change logs:
- generic load latency data source encoding
- sample more load latency data(data address/latency value/data source)
- remove the hw_perf_event::extra_flags 
- increment MAX_EXTRA_REGS to 3


This patch adds load latency monitoring on Intel Nehalem/Westmere.
It's applied on top of tip/master(1f7107c8) and Andi's offcore
patchsets are needed(see PATCH 0-3).

The load latency on Intel Nehalem/Westmere is monitored by event
MEM_INST_RETIRED.LATENCY_ABOVE_THRESHOLD(0x100b). It measures latency
from micro-operation (uop) dispatch to when data is globally observable
(GO).

To monitor load latency, both the PEBS_EN_CTRx and LL_EN_CTRx bits must
be set in IA32_PEBS_ENABLE register. And an extra MSR
MSR_PEBS_LD_LAT_THRESHOLD must be programmed with the desired latency
threshold in core clock cycles. Loads with latencies greater than this
value are counted.

The latency threshold is encoded in the upper 32 bits of
perf_event_attr::config and 'p' modifier must be used to enabel PEBS.

The default latency threshold is 3, as Intel manual says, "The minimum
value that may be programmed in this register is 3 (the minimum
detectable load latency is 4 core clock cycles)."

Usage:

# perf top -e r100b:p

#Monitor load latency > 51 cycles
# perf top -e r510000100b:p

Any comment is appropriated.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/include/asm/msr-index.h          |    2 +
 arch/x86/include/asm/perf_event.h         |   26 ++++++++++++++++
 arch/x86/kernel/cpu/perf_event.c          |    7 ++++
 arch/x86/kernel/cpu/perf_event_intel.c    |    6 +++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   47 +++++++++++++++++++++++++----
 include/linux/perf_event.h                |    8 ++++-
 6 files changed, 87 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index c3c42b1..174127d 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -54,6 +54,8 @@
 #define MSR_IA32_DS_AREA		0x00000600
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
 
+#define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
+
 #define MSR_MTRRfix64K_00000		0x00000250
 #define MSR_MTRRfix16K_80000		0x00000258
 #define MSR_MTRRfix16K_A0000		0x00000259
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index d9d4dae..e01259f 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -75,6 +75,32 @@ union cpuid10_edx {
 	unsigned int full;
 };
 
+/*
+ * Load latency data source encoding
+ */
+
+/* Bits(0-1) {L1, L2, L3, RAM} or {unknown, IO, uncached} */
+#define LD_LAT_L1			0x00
+#define LD_LAT_L2			0x01
+#define LD_LAT_L3			0x02
+#define LD_LAT_RAM			0x03
+#define LD_LAT_UNKNOWN			0x00
+#define LD_LAT_IO			0x01
+#define LD_LAT_UNCACHED			0x02
+
+/* Bits(2-3) {not-used, snoop, local, remote} */
+#define LD_LAT_NOT_USED			(0x00 << 2)
+#define LD_LAT_SNOOP			(0x01 << 2)
+#define LD_LAT_LOCAL			(0x02 << 2)
+#define LD_LAT_REMOTE			(0x03 << 2)
+
+/* Bits(4-5) {modified, exclusive, shared, invalid} */
+#define LD_LAT_MODIFIED			(0x00 << 4)
+#define LD_LAT_EXCLUSIVE		(0x01 << 4)
+#define LD_LAT_SHARED			(0x02 << 4)
+#define LD_LAT_INVALID			(0x03 << 4)
+
+#define LD_LAT_RESERVED			0x3F
 
 /*
  * Fixed-purpose performance events:
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ed6ff11..713695e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -208,6 +208,9 @@ struct extra_reg {
 	}
 #define INTEL_EVENT_EXTRA_REG(event, msr, vm, es)	\
 	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, es)
+#define INTEL_EVENT_EXTRA_REG2(event, msr, vm, es)	\
+	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT | \
+			ARCH_PERFMON_EVENTSEL_UMASK, vm, es)
 #define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, 0)
 
 union perf_capabilities {
@@ -384,6 +387,10 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
 		if (extra & ~er->valid_mask)
 			return -EINVAL;
 		event->hw.extra_config = extra;
+
+		/* The minimum value that may be programmed into MSR_PEBS_LD_LAT is 3 */
+		if (er->msr == MSR_PEBS_LD_LAT_THRESHOLD && extra < 3)
+			event->hw.extra_config = 3;
 		break;
 	}
 	return 0;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0a67425..6df225a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1,6 +1,6 @@
 #ifdef CONFIG_CPU_SUP_INTEL
 
-#define MAX_EXTRA_REGS 2
+#define MAX_EXTRA_REGS 3
 
 /* 
  * Per register state.
@@ -90,6 +90,8 @@ static struct extra_reg intel_nehalem_extra_regs[] =
 {
 	/* OFFCORE_RESPONSE */
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, 32),
+	/* MEM_INST_RETIRED.LATENCY_ABOVE_THRESHOLD */
+	INTEL_EVENT_EXTRA_REG2(0x100b, MSR_PEBS_LD_LAT_THRESHOLD, 0xffff, 32),
 	EVENT_EXTRA_END
 };
 
@@ -117,6 +119,8 @@ static struct extra_reg intel_westmere_extra_regs[] =
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, 32),
 	/* OFFCORE_RESPONSE_1 */
 	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff, 32),
+	/* MEM_INST_RETIRED.LATENCY_ABOVE_THRESHOLD */
+	INTEL_EVENT_EXTRA_REG2(0x100b, MSR_PEBS_LD_LAT_THRESHOLD, 0xffff, 32),
 	EVENT_EXTRA_END
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index b7dcd9f..06c6107 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -1,5 +1,26 @@
 #ifdef CONFIG_CPU_SUP_INTEL
 
+/* Indexed by Intel load latency data source encoding value */
+
+static u64 intel_load_latency_data[] = {
+	LD_LAT_UNKNOWN,					/* 0x00: Unknown L3 */
+	LD_LAT_L1 | LD_LAT_LOCAL,			/* 0x01: L1-local */
+	LD_LAT_L2 | LD_LAT_SNOOP,			/* 0x02: L2-snoop */
+	LD_LAT_L2 | LD_LAT_LOCAL,			/* 0x03: L2-local */
+	LD_LAT_L3 | LD_LAT_SNOOP | LD_LAT_INVALID,	/* 0x04: L3-snoop, no coherency actions */
+	LD_LAT_L3 | LD_LAT_SNOOP | LD_LAT_SHARED,	/* 0x05: L3-snoop, found no M */
+	LD_LAT_L3 | LD_LAT_SNOOP | LD_LAT_MODIFIED,	/* 0x06: L3-snoop, found M */
+	LD_LAT_RESERVED,				/* 0x07: reserved */
+	LD_LAT_RAM | LD_LAT_SNOOP | LD_LAT_SHARED,	/* 0x08: L3-miss, snoop, shared */
+	LD_LAT_RESERVED,				/* 0x09: reserved */
+	LD_LAT_RAM | LD_LAT_LOCAL | LD_LAT_SHARED,	/* 0x0A: L3-miss, local, shared */
+	LD_LAT_RAM | LD_LAT_REMOTE | LD_LAT_SHARED,	/* 0x0B: L3-miss, remote, shared */
+	LD_LAT_RAM | LD_LAT_LOCAL | LD_LAT_EXCLUSIVE,	/* 0x0C: L3-miss, local, exclusive */
+	LD_LAT_RAM | LD_LAT_REMOTE | LD_LAT_EXCLUSIVE,	/* 0x0D: L3-miss, remote, exclusive */
+	LD_LAT_IO,					/* 0x0E: IO */
+	LD_LAT_UNCACHED,				/* 0x0F: Uncached */
+};
+
 /* The maximal number of PEBS events: */
 #define MAX_PEBS_EVENTS		4
 
@@ -376,6 +397,7 @@ static struct event_constraint intel_core_pebs_events[] = {
 };
 
 static struct event_constraint intel_nehalem_pebs_events[] = {
+	PEBS_EVENT_CONSTRAINT(0x100b, 0xf), /* MEM_INST_RETIRED.LATENCY_ABOVE_THRESHOLD */
 	PEBS_EVENT_CONSTRAINT(0x00c0, 0xf), /* INSTR_RETIRED.ANY */
 	PEBS_EVENT_CONSTRAINT(0xfec1, 0xf), /* X87_OPS_RETIRED.ANY */
 	PEBS_EVENT_CONSTRAINT(0x00c5, 0xf), /* BR_INST_RETIRED.MISPRED */
@@ -414,6 +436,8 @@ static void intel_pmu_pebs_enable(struct perf_event *event)
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
+	if (hwc->extra_reg == MSR_PEBS_LD_LAT_THRESHOLD)
+		cpuc->pebs_enabled |= 1ULL << (hwc->idx + 32);
 	WARN_ON_ONCE(cpuc->enabled);
 
 	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
@@ -426,6 +450,8 @@ static void intel_pmu_pebs_disable(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 
 	cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
+	if (hwc->extra_reg == MSR_PEBS_LD_LAT_THRESHOLD)
+		cpuc->pebs_enabled &= ~(1ULL << (hwc->idx + 32));
 	if (cpuc->enabled)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
 
@@ -541,14 +567,10 @@ static int intel_pmu_save_and_restart(struct perf_event *event);
 static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs, void *__pebs)
 {
-	/*
-	 * We cast to pebs_record_core since that is a subset of
-	 * both formats and we don't use the other fields in this
-	 * routine.
-	 */
-	struct pebs_record_core *pebs = __pebs;
+	struct pebs_record_nhm *pebs = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
+	u64 sample_type;
 
 	if (!intel_pmu_save_and_restart(event))
 		return;
@@ -556,6 +578,19 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	perf_sample_data_init(&data, 0);
 	data.period = event->hw.last_period;
 
+	if (event->hw.extra_reg == MSR_PEBS_LD_LAT_THRESHOLD) {
+		sample_type = event->attr.sample_type;
+
+		if (sample_type & PERF_SAMPLE_ADDR)
+			data.addr = pebs->dla;
+
+		if (sample_type & PERF_SAMPLE_LATENCY)
+			data.latency = pebs->lat;
+
+		if (sample_type & PERF_SAMPLE_LATENCY_DATA)
+			data.latency_data = intel_load_latency_data[pebs->dse];
+	}
+
 	/*
 	 * We use the interrupt regs as a base because the PEBS record
 	 * does not contain a full regs set, specifically it seems to
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d24d9ab..9428a1b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -124,9 +124,11 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_CPU				= 1U << 7,
 	PERF_SAMPLE_PERIOD			= 1U << 8,
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
-	PERF_SAMPLE_RAW				= 1U << 10,
+	PERF_SAMPLE_LATENCY			= 1U << 10,
+	PERF_SAMPLE_LATENCY_DATA		= 1U << 11,
+	PERF_SAMPLE_RAW				= 1U << 12,
 
-	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
 };
 
 /*
@@ -958,6 +960,8 @@ struct perf_sample_data {
 	}				tid_entry;
 	u64				time;
 	u64				addr;
+	u64				latency;
+	u64				latency_data;
 	u64				id;
 	u64				stream_id;
 	struct {
-- 
1.7.3





