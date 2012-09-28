Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab2I1EdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:33:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:24549 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab2I1EcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:32:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="150122857"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 01/31] perf, x86: Add PEBSv2 record support
Date: Thu, 27 Sep 2012 21:31:06 -0700
Message-Id: <1348806696-31170-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support for the v2 PEBS format. It has a superset of the v1 PEBS
fields, but has a longer record so we need to adjust the code paths.

The main advantage is the new "EventingRip" support which directly
gives the instruction, not off-by-one instruction. So with precise == 2
we use that directly and don't try to use LBRs and walking basic blocks.
This lowers the overhead significantly.

Some other features are added in later patches.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c          |    2 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  101 ++++++++++++++++++++++-------
 2 files changed, 79 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 915b876..87c2ab0 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -395,7 +395,7 @@ int x86_pmu_hw_config(struct perf_event *event)
 		 * check that PEBS LBR correction does not conflict with
 		 * whatever the user is asking with attr->branch_sample_type
 		 */
-		if (event->attr.precise_ip > 1) {
+		if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {
 			u64 *br_type = &event->attr.branch_sample_type;
 
 			if (has_branch_stack(event)) {
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index e38d97b..c8ab670 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -41,6 +41,12 @@ struct pebs_record_nhm {
 	u64 status, dla, dse, lat;
 };
 
+struct pebs_record_v2 {
+	struct pebs_record_nhm nhm;
+	u64 eventingrip;
+	u64 tsx_tuning;
+};
+
 void init_debug_store_on_cpu(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
@@ -545,8 +551,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 {
 	/*
 	 * We cast to pebs_record_core since that is a subset of
-	 * both formats and we don't use the other fields in this
-	 * routine.
+	 * both formats.
 	 */
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct pebs_record_core *pebs = __pebs;
@@ -574,7 +579,10 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	regs.bp = pebs->bp;
 	regs.sp = pebs->sp;
 
-	if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
+	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format >= 2) {
+		regs.ip = ((struct pebs_record_v2 *)pebs)->eventingrip;
+		regs.flags |= PERF_EFLAGS_EXACT;
+	} else if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
 		regs.flags |= PERF_EFLAGS_EXACT;
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
@@ -627,35 +635,21 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	__intel_pmu_pebs_event(event, iregs, at);
 }
 
-static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
+static void intel_pmu_drain_pebs_common(struct pt_regs *iregs, void *at, 
+					void *top)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
-	struct pebs_record_nhm *at, *top;
 	struct perf_event *event = NULL;
 	u64 status = 0;
-	int bit, n;
-
-	if (!x86_pmu.pebs_active)
-		return;
-
-	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
-	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
+	int bit;
 
 	ds->pebs_index = ds->pebs_buffer_base;
 
-	n = top - at;
-	if (n <= 0)
-		return;
+	for ( ; at < top; at += x86_pmu.pebs_record_size) {
+		struct pebs_record_nhm *p = at;
 
-	/*
-	 * Should not happen, we program the threshold at 1 and do not
-	 * set a reset value.
-	 */
-	WARN_ONCE(n > x86_pmu.max_pebs_events, "Unexpected number of pebs records %d\n", n);
-
-	for ( ; at < top; at++) {
-		for_each_set_bit(bit, (unsigned long *)&at->status, x86_pmu.max_pebs_events) {
+		for_each_set_bit(bit, (unsigned long *)&p->status, x86_pmu.max_pebs_events) {
 			event = cpuc->events[bit];
 			if (!test_bit(bit, cpuc->active_mask))
 				continue;
@@ -678,6 +672,61 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	}
 }
 
+static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct debug_store *ds = cpuc->ds;
+	struct pebs_record_nhm *at, *top;
+	int n;
+
+	if (!x86_pmu.pebs_active)
+		return;
+
+	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
+	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
+
+	ds->pebs_index = ds->pebs_buffer_base;
+
+	n = top - at;
+	if (n <= 0)
+		return;
+
+	/*
+	 * Should not happen, we program the threshold at 1 and do not
+	 * set a reset value.
+	 */
+	WARN_ONCE(n > x86_pmu.max_pebs_events, 
+		  "Unexpected number of pebs records %d\n", n);
+
+	return intel_pmu_drain_pebs_common(iregs, at, top);
+}
+
+static void intel_pmu_drain_pebs_v2(struct pt_regs *iregs)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct debug_store *ds = cpuc->ds;
+	struct pebs_record_v2 *at, *top;
+	int n;
+
+	if (!x86_pmu.pebs_active)
+		return;
+
+	at  = (struct pebs_record_v2 *)(unsigned long)ds->pebs_buffer_base;
+	top = (struct pebs_record_v2 *)(unsigned long)ds->pebs_index;
+
+	n = top - at;
+	if (n <= 0)
+		return;
+	/*
+	 * Should not happen, we program the threshold at 1 and do not
+	 * set a reset value.
+	 */
+	WARN_ONCE(n > x86_pmu.max_pebs_events,
+		  "Unexpected number of pebs records %d\n", n);
+
+	return intel_pmu_drain_pebs_common(iregs, at, top);
+}
+
 /*
  * BTS, PEBS probe and setup
  */
@@ -709,6 +758,12 @@ void intel_ds_init(void)
 			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
 			break;
 
+		case 2:
+			printk(KERN_CONT "PEBS fmt2%c, ", pebs_type);
+			x86_pmu.pebs_record_size = sizeof(struct pebs_record_v2);
+			x86_pmu.drain_pebs = intel_pmu_drain_pebs_v2;
+			break;
+
 		default:
 			printk(KERN_CONT "no PEBS fmt%d%c, ", format, pebs_type);
 			x86_pmu.pebs = 0;
-- 
1.7.7.6

