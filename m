Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab2JBXtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:49:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:37543 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799Ab2JBXs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:48:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,525,1344236400"; 
   d="scan'208";a="199832065"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, x86@vger.kernel.org, eranian@google.com, jolsa@redhat.com,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 03/31] perf, x86: Basic Haswell PEBS support
Date: Tue,  2 Oct 2012 16:48:23 -0700
Message-Id: <1349221731-15665-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
References: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add basic PEBS support for Haswell.
The constraints are similar to SandyBridge with a few new events.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h          |    2 ++
 arch/x86/kernel/cpu/perf_event_intel.c    |    2 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   29 +++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 8e50d8b..c1dfe5d 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -591,6 +591,8 @@ extern struct event_constraint intel_snb_pebs_event_constraints[];
 
 extern struct event_constraint intel_ivb_pebs_event_constraints[];
 
+extern struct event_constraint intel_hsw_pebs_event_constraints[];
+
 struct event_constraint *intel_pebs_constraints(struct perf_event *event);
 
 void intel_pmu_pebs_enable(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 50c43ca..ea06a4b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2116,7 +2116,7 @@ __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_nhm();
 
 		x86_pmu.event_constraints = intel_hsw_event_constraints;
-
+		x86_pmu.pebs_constraints = intel_hsw_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 9d0dae0..91c2ab7 100644
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
+	INTEL_EVENT_CONSTRAINT(0x01c5, 0xf),  /* BR_MISP_RETIRED.CONDITIONAL */
+	INTEL_EVENT_CONSTRAINT(0x04c5, 0xf),  /* BR_MISP_RETIRED.ALL_BRANCHES */
+	INTEL_EVENT_CONSTRAINT(0x20c5, 0xf),  /* BR_MISP_RETIRED.NEAR_TAKEN */
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

