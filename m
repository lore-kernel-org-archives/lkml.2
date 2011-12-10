Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1LJX25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 18:28:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36604 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1LJX2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 18:28:45 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com
Subject: [PATCH 1/4] perf_events: enable raw event support for Intel unhalted_reference_cycles event
Date: Sun, 11 Dec 2011 00:28:51 +0100
Message-Id: <1323559734-3488-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1323559734-3488-1-git-send-email-eranian@google.com>
References: <1323559734-3488-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the encoding and definitions necessary for the
unhalted_reference_cycles event avaialble since Intel Core 2 processors.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/include/asm/perf_event.h      |   15 ++++++++-------
 arch/x86/kernel/cpu/perf_event.c       |    8 +++++++-
 arch/x86/kernel/cpu/perf_event_intel.c |   15 +++++----------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index b50e9d1..096c975 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -112,23 +112,24 @@ struct x86_pmu_capability {
 /*
  * All 3 fixed-mode PMCs are configured via this single MSR:
  */
-#define MSR_ARCH_PERFMON_FIXED_CTR_CTRL			0x38d
+#define MSR_ARCH_PERFMON_FIXED_CTR_CTRL	0x38d
 
 /*
  * The counts are available in three separate MSRs:
  */
 
 /* Instr_Retired.Any: */
-#define MSR_ARCH_PERFMON_FIXED_CTR0			0x309
-#define X86_PMC_IDX_FIXED_INSTRUCTIONS			(X86_PMC_IDX_FIXED + 0)
+#define MSR_ARCH_PERFMON_FIXED_CTR0	0x309
+#define X86_PMC_IDX_FIXED_INSTRUCTIONS	(X86_PMC_IDX_FIXED + 0)
 
 /* CPU_CLK_Unhalted.Core: */
-#define MSR_ARCH_PERFMON_FIXED_CTR1			0x30a
-#define X86_PMC_IDX_FIXED_CPU_CYCLES			(X86_PMC_IDX_FIXED + 1)
+#define MSR_ARCH_PERFMON_FIXED_CTR1	0x30a
+#define X86_PMC_IDX_FIXED_CPU_CYCLES	(X86_PMC_IDX_FIXED + 1)
 
 /* CPU_CLK_Unhalted.Ref: */
-#define MSR_ARCH_PERFMON_FIXED_CTR2			0x30b
-#define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
+#define MSR_ARCH_PERFMON_FIXED_CTR2	0x30b
+#define X86_PMC_IDX_FIXED_REF_CYCLES	(X86_PMC_IDX_FIXED + 2)
+#define X86_PMC_MSK_FIXED_REF_CYCLES	(1ULL << X86_PMC_IDX_FIXED_REF_CYCLES)
 
 /*
  * We model BTS tracing as another fixed-mode PMC.
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 930fe48..5adce10 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1304,9 +1304,15 @@ static int __init init_hw_perf_events(void)
 				   0, x86_pmu.num_counters, 0);
 
 	if (x86_pmu.event_constraints) {
+		/*
+		 * event on fixed counter2 (REF_CYCLES) only works on this
+		 * counter, so do not extend mask to generic counters
+		 */
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if (c->cmask != X86_RAW_EVENT_MASK)
+			if (c->cmask != X86_RAW_EVENT_MASK
+			    || c->idxmsk64 == X86_PMC_MSK_FIXED_REF_CYCLES) {
 				continue;
+			}
 
 			c->idxmsk64 |= (1ULL << x86_pmu.num_counters) - 1;
 			c->weight += x86_pmu.num_counters;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 2c3bf53..61f865f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -45,12 +45,7 @@ static struct event_constraint intel_core2_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
-	/*
-	 * Core2 has Fixed Counter 2 listed as CPU_CLK_UNHALTED.REF and event
-	 * 0x013c as CPU_CLK_UNHALTED.BUS and specifies there is a fixed
-	 * ratio between these counters.
-	 */
-	/* FIXED_EVENT_CONSTRAINT(0x013c, 2),  CPU_CLK_UNHALTED.REF */
+	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
 	INTEL_EVENT_CONSTRAINT(0x10, 0x1), /* FP_COMP_OPS_EXE */
 	INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
 	INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */
@@ -68,7 +63,7 @@ static struct event_constraint intel_nehalem_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
-	/* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
+	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
 	INTEL_EVENT_CONSTRAINT(0x40, 0x3), /* L1D_CACHE_LD */
 	INTEL_EVENT_CONSTRAINT(0x41, 0x3), /* L1D_CACHE_ST */
 	INTEL_EVENT_CONSTRAINT(0x42, 0x3), /* L1D_CACHE_LOCK */
@@ -90,7 +85,7 @@ static struct event_constraint intel_westmere_event_constraints[] __read_mostly 
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
-	/* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
+	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
 	INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
 	INTEL_EVENT_CONSTRAINT(0x60, 0x1), /* OFFCORE_REQUESTS_OUTSTANDING */
 	INTEL_EVENT_CONSTRAINT(0x63, 0x3), /* CACHE_LOCK_CYCLES */
@@ -102,7 +97,7 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
-	/* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
+	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
 	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
 	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
@@ -125,7 +120,7 @@ static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
-	/* FIXED_EVENT_CONSTRAINT(0x013c, 2), CPU_CLK_UNHALTED.REF */
+	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
 	EVENT_CONSTRAINT_END
 };
 
-- 
1.7.1

