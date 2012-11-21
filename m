Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab2KUMv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:51:59 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49713 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab2KUMvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:51:52 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v3 10/19] perf/x86: add support for PEBS Precise Store
Date: Wed, 21 Nov 2012 13:49:36 +0100
Message-Id: <1353502185-26521-11-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353502185-26521-1-git-send-email-eranian@google.com>
References: <1353502185-26521-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for PEBS Precise Store
which is available on Intel Sandy Bridge and
Ivy Bridge processors.

To use Precise store, the proper PEBS event
must be used: mem_trans_retired:precise_stores.
For the perf tool, the generic mem-stores event
exported via sysfs can be used directly.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.h          |    5 +++
 arch/x86/kernel/cpu/perf_event_intel.c    |    2 ++
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   49 +++++++++++++++++++++++++++--
 3 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3f91411..645b864 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -66,6 +66,7 @@ struct event_constraint {
  * struct event_constraint flags
  */
 #define PERF_X86_EVENT_PEBS_LDLAT	0x1 /* ld+ldlat data address sampling */
+#define PERF_X86_EVENT_PEBS_ST		0x2 /* st data address sampling */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
@@ -242,6 +243,10 @@ struct cpu_hw_events {
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
 			   HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LDLAT)
 
+#define INTEL_PST_CONSTRAINT(c, n)	\
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
+			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST)
+
 #define EVENT_CONSTRAINT_END		\
 	EVENT_CONSTRAINT(0, 0, 0)
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 8eced4c..665e26c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -138,6 +138,7 @@ static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
 
 EVENT_ATTR_STR(mem-loads, mem_ld_nhm, "event=0x0b,umask=0x10,ldlat=3");
 EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");
+EVENT_ATTR_STR(mem-stores, mem_st_snb, "event=0xcd,umask=0x2");
 
 struct attribute *nhm_events_attrs[] = {
 	EVENT_PTR(mem_ld_nhm),
@@ -146,6 +147,7 @@ struct attribute *nhm_events_attrs[] = {
 
 struct attribute *snb_events_attrs[] = {
 	EVENT_PTR(mem_ld_snb),
+	EVENT_PTR(mem_st_snb),
 	NULL,
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 759b0c0..ed0ca3e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -69,6 +69,44 @@ static const u64 pebs_data_source[] = {
 	OP_LH | P(LVL,UNC) | P(SNOOP, NONE), /* 0x0f: uncached */
 };
 
+static u64 precise_store_data(u64 status)
+{
+	union intel_x86_pebs_dse dse;
+	u64 val = P(OP, STORE) | P(SNOOP, NA) | P(LVL, L1) | P(TLB, L2);
+
+	dse.val = status;
+
+	/*
+	 * bit 4: TLB access
+	 * 1 = stored missed 2nd level TLB
+	 *
+	 * so it either hit the walker or the OS
+	 * otherwise hit 2nd level TLB
+	 */
+	if (dse.st_stlb_miss)
+		val |= P(TLB, MISS);
+	else
+		val |= P(TLB, HIT);
+
+	/*
+	 * bit 0: hit L1 data cache
+	 * if not set, then all we know is that
+	 * it missed L1D
+	 */
+	if (dse.st_l1d_hit)
+		val |= P(LVL, HIT);
+	else
+		val |= P(LVL, MISS);
+
+	/*
+	 * bit 5: Locked prefix
+	 */
+	if (dse.st_locked)
+		val |= P(LOCK, LOCKED);
+
+	return val;
+}
+
 static u64 load_latency_data(u64 status)
 {
 	union intel_x86_pebs_dse dse;
@@ -486,6 +524,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
 	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
+	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
@@ -500,6 +539,7 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
         INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
         INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
         INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
+	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
         INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
         INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
         INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
@@ -537,6 +577,8 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 
 	if (event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT)
 		cpuc->pebs_enabled |= 1ULL << (hwc->idx + 32);
+	else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST)
+		cpuc->pebs_enabled |= 1ULL << 63;
 }
 
 void intel_pmu_pebs_disable(struct perf_event *event)
@@ -657,12 +699,13 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	struct perf_sample_data data;
 	struct pt_regs regs;
 	u64 sample_type;
-	int fll;
+	int fll, fst;
 
 	if (!intel_pmu_save_and_restart(event))
 		return;
 
 	fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
+	fst = event->hw.flags & PERF_X86_EVENT_PEBS_ST;
 
 	perf_sample_data_init(&data, 0, event->hw.last_period);
 
@@ -672,7 +715,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	/*
 	 * if PEBS-LL or PreciseStore
 	 */
-	if (fll) {
+	if (fll || fst) {
 		if (sample_type & PERF_SAMPLE_ADDR)
 			data.addr = pebs->dla;
 
@@ -688,6 +731,8 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		if (sample_type & PERF_SAMPLE_DSRC) {
 			if (fll)
 				data.dsrc.val = load_latency_data(pebs->dse);
+			else
+				data.dsrc.val = precise_store_data(pebs->dse);
 		}
 	}
 
-- 
1.7.9.5

