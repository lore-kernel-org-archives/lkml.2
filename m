Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab2KJBeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:34:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:1588 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab2KJB15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:27:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,749,1344236400"; 
   d="scan'208";a="217548794"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 03/32] perf, x86: Basic Haswell PEBS support v3
Date: Fri,  9 Nov 2012 17:27:19 -0800
Message-Id: <1352510868-7911-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add basic PEBS support for Haswell.
The constraints are similar to SandyBridge with a few new events.

v2: Readd missing pebs_aliases
v3: Readd missing hunk. Fix some constraints.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h          |    2 ++
 arch/x86/kernel/cpu/perf_event_intel.c    |    6 ++++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   29 +++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 8941899..1567b0d 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -596,6 +596,8 @@ extern struct event_constraint intel_snb_pebs_event_constraints[];
 
 extern struct event_constraint intel_ivb_pebs_event_constraints[];
 
+extern struct event_constraint intel_hsw_pebs_event_constraints[];
+
 struct event_constraint *intel_pebs_constraints(struct perf_event *event);
 
 void intel_pmu_pebs_enable(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 3a08534..634f639 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -826,7 +826,8 @@ static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
 		return true;
 
 	/* implicit branch sampling to correct PEBS skid */
-	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
+	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1 &&
+	    x86_pmu.intel_cap.pebs_format < 2)
 		return true;
 
 	return false;
@@ -2127,8 +2128,9 @@ __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_hsw_event_constraints;
-
+		x86_pmu.pebs_constraints = intel_hsw_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_snb_extra_regs;
+		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 9d0dae0..16d7c58 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -427,6 +427,35 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
         EVENT_CONSTRAINT_END
 };
 
+struct event_constraint intel_hsw_pebs_event_constraints[] = {
+	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+	INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
+	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
+	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x01c5, 0xf), /* BR_MISP_RETIRED.CONDITIONAL */
+	INTEL_UEVENT_CONSTRAINT(0x04c5, 0xf), /* BR_MISP_RETIRED.ALL_BRANCHES */
+	INTEL_UEVENT_CONSTRAINT(0x20c5, 0xf), /* BR_MISP_RETIRED.NEAR_TAKEN */
+	INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf), /* MEM_UOPS_RETIRED.STLB_MISS_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
+	INTEL_UEVENT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
+	INTEL_UEVENT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L3_HIT */
+	INTEL_UEVENT_CONSTRAINT(0x40d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.HIT_LFB */
+	INTEL_UEVENT_CONSTRAINT(0x01d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_MISS */
+	INTEL_UEVENT_CONSTRAINT(0x02d2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HIT */
+	INTEL_UEVENT_CONSTRAINT(0x02d3, 0xf), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.LOCAL_DRAM */
+	INTEL_UEVENT_CONSTRAINT(0x04c8, 0xf), /* HLE_RETIRED.Abort */
+	INTEL_UEVENT_CONSTRAINT(0x04c9, 0xf), /* RTM_RETIRED.Abort */
+
+	EVENT_CONSTRAINT_END
+};
+
 struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 {
 	struct event_constraint *c;
-- 
1.7.7.6

