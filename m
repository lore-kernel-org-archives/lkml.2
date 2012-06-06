Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab2FFA5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 20:57:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:2175 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab2FFA5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 20:57:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="148674931"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: eranian@google.com, a.p.zijlstra@chello.nl,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/5] perf, x86: Check LBR format capability
Date: Tue,  5 Jun 2012 17:56:49 -0700
Message-Id: <1338944211-28275-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Double check the CPU has a LBR format we support before using it.

Also I made the init functions __init while I was on it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 520b426..4176b09 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -12,6 +12,7 @@ enum {
 	LBR_FORMAT_LIP		= 0x01,
 	LBR_FORMAT_EIP		= 0x02,
 	LBR_FORMAT_EIP_FLAGS	= 0x03,
+	LBR_FORMAT_MAX		= LBR_FORMAT_EIP_FLAGS
 };
 
 /*
@@ -622,9 +623,20 @@ static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
 	[PERF_SAMPLE_BRANCH_IND_CALL]	= LBR_IND_CALL,
 };
 
+static bool lbr_common_init(void)
+{
+	if (x86_pmu.intel_cap.lbr_format > LBR_FORMAT_MAX) {
+		pr_cont("LBR has unknown format, ");
+		return false;
+	}
+}
+
 /* core */
-void intel_pmu_lbr_init_core(void)
+__init void intel_pmu_lbr_init_core(void)
 {
+	if (!lbr_common_init())
+		return;
+
 	x86_pmu.lbr_nr     = 4;
 	x86_pmu.lbr_tos    = MSR_LBR_TOS;
 	x86_pmu.lbr_from   = MSR_LBR_CORE_FROM;
@@ -638,8 +650,11 @@ void intel_pmu_lbr_init_core(void)
 }
 
 /* nehalem/westmere */
-void intel_pmu_lbr_init_nhm(void)
+__init void intel_pmu_lbr_init_nhm(void)
 {
+	if (!lbr_common_init())
+		return;
+
 	x86_pmu.lbr_nr     = 16;
 	x86_pmu.lbr_tos    = MSR_LBR_TOS;
 	x86_pmu.lbr_from   = MSR_LBR_NHM_FROM;
@@ -659,8 +674,11 @@ void intel_pmu_lbr_init_nhm(void)
 }
 
 /* sandy bridge */
-void intel_pmu_lbr_init_snb(void)
+__init void intel_pmu_lbr_init_snb(void)
 {
+	if (!lbr_common_init())
+		return;
+
 	x86_pmu.lbr_nr	 = 16;
 	x86_pmu.lbr_tos	 = MSR_LBR_TOS;
 	x86_pmu.lbr_from = MSR_LBR_NHM_FROM;
@@ -679,7 +697,7 @@ void intel_pmu_lbr_init_snb(void)
 }
 
 /* atom */
-void intel_pmu_lbr_init_atom(void)
+__init void intel_pmu_lbr_init_atom(void)
 {
 	/*
 	 * only models starting at stepping 10 seems
@@ -690,6 +708,8 @@ void intel_pmu_lbr_init_atom(void)
 		pr_cont("LBR disabled due to erratum");
 		return;
 	}
+	if (!lbr_common_init())
+		return;
 
 	x86_pmu.lbr_nr	   = 8;
 	x86_pmu.lbr_tos    = MSR_LBR_TOS;
-- 
1.7.7.6

