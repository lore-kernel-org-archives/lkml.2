Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab2JBXyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:54:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:19881 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814Ab2JBXtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:49:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,525,1344236400"; 
   d="scan'208";a="229791142"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, x86@vger.kernel.org, eranian@google.com, jolsa@redhat.com,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 16/31] perf, x86: Support weight samples for PEBS
Date: Tue,  2 Oct 2012 16:48:36 -0700
Message-Id: <1349221731-15665-17-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
References: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When a weighted sample is requested, first try to report the TSX abort cost
on Haswell. If that is not available report the memory latency. This
allows profiling both by abort cost and by memory latencies.

Memory latencies requires enabling a different PEBS mode (LL).
When both address and weight is requested address wins.

The LL mode only works for memory related PEBS events, so add a
separate event constraint table for those.

I only did this for Haswell for now, but it could be added
for several other Intel CPUs too by just adding the right
table for them.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h          |    4 ++
 arch/x86/kernel/cpu/perf_event_intel.c    |    4 ++
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   47 +++++++++++++++++++++++++++-
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 4b468ae..2f714f0 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -168,6 +168,7 @@ struct cpu_hw_events {
 	u64				perf_ctr_virt_mask;
 
 	void				*kfree_on_online;
+	u8				*memory_latency_events;
 };
 
 #define __EVENT_CONSTRAINT(c, n, m, w, o) {\
@@ -388,6 +389,7 @@ struct x86_pmu {
 	struct event_constraint *pebs_constraints;
 	void		(*pebs_aliases)(struct perf_event *event);
 	int 		max_pebs_events;
+	struct event_constraint *memory_lat_events;
 
 	/*
 	 * Intel LBR
@@ -594,6 +596,8 @@ extern struct event_constraint intel_ivb_pebs_event_constraints[];
 
 extern struct event_constraint intel_hsw_pebs_event_constraints[];
 
+extern struct event_constraint intel_hsw_memory_latency_events[];
+
 struct event_constraint *intel_pebs_constraints(struct perf_event *event);
 
 void intel_pmu_pebs_enable(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index ede3220..0b8251a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1639,6 +1639,9 @@ static int hsw_hw_config(struct perf_event *event)
 
 	if (ret)
 		return ret;
+	/* PEBS cannot capture both */
+	if (event->attr.sample_type & PERF_SAMPLE_ADDR)
+		event->attr.sample_type &= ~PERF_SAMPLE_WEIGHT;
 	if (!boot_cpu_has(X86_FEATURE_RTM) && !boot_cpu_has(X86_FEATURE_HLE))
 		return 0;
 	event->hw.config |= event->attr.config & (HSW_INTX|HSW_INTX_CHECKPOINTED);
@@ -2201,6 +2204,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.hw_config = hsw_hw_config;
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
 		x86_pmu.format_attrs = intel_hsw_formats_attr;
+		x86_pmu.memory_lat_events = intel_hsw_memory_latency_events;
 		pr_cont("Haswell events, ");
 		break;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 8c893ce..6066740 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -456,6 +456,17 @@ struct event_constraint intel_hsw_pebs_event_constraints[] = {
 	EVENT_CONSTRAINT_END
 };
 
+/* Subset of PEBS events supporting memory latency. Not used for scheduling */
+
+struct event_constraint intel_hsw_memory_latency_events[] = {
+	INTEL_EVENT_CONSTRAINT(0xcd, 0), /* MEM_TRANS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd0, 0), /* MEM_UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd1, 0), /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd2, 0), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd3, 0), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+	EVENT_CONSTRAINT_END
+};
+
 struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 {
 	struct event_constraint *c;
@@ -473,6 +484,21 @@ struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 	return &emptyconstraint;
 }
 
+static bool is_memory_lat_event(struct perf_event *event)
+{
+	struct event_constraint *c;
+
+	if (x86_pmu.intel_cap.pebs_format < 1)
+		return false;
+	if (!x86_pmu.memory_lat_events)
+		return false;
+	for_each_event_constraint(c, x86_pmu.memory_lat_events) {
+		if ((event->hw.config & c->cmask) == c->code)
+			return true;
+	}
+	return false;
+}
+
 void intel_pmu_pebs_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -480,7 +506,12 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 
-	cpuc->pebs_enabled |= 1ULL << hwc->idx;
+	/* When weight is requested enable LL instead of normal PEBS */
+	if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) &&
+		is_memory_lat_event(event))
+		cpuc->pebs_enabled |= 1ULL << (32 + hwc->idx);
+	else
+		cpuc->pebs_enabled |= 1ULL << hwc->idx;
 }
 
 void intel_pmu_pebs_disable(struct perf_event *event)
@@ -488,7 +519,11 @@ void intel_pmu_pebs_disable(struct perf_event *event)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 
-	cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
+	if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) &&
+		is_memory_lat_event(event))
+		cpuc->pebs_enabled &= ~(1ULL << (32 + hwc->idx));
+	else
+		cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
 	if (cpuc->enabled)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
 
@@ -641,6 +676,14 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		x86_pmu.intel_cap.pebs_format >= 2)
 		data.addr = ((struct pebs_record_v2 *)pebs)->nhm.dla;
 
+	if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) &&
+	    x86_pmu.intel_cap.pebs_format >= 2) {
+		data.weight = ((struct pebs_record_v2 *)pebs)->tsx_tuning &
+				0xffffffff;
+		if (!data.weight)
+			data.weight = ((struct pebs_record_v2 *)pebs)->nhm.lat;
+	}
+
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
-- 
1.7.7.6

