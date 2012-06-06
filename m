Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab2FFE3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 00:29:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:2883 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab2FFE3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 00:29:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161543791"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: eranian@google.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 3/5] perf, x86: Check LBR format capability
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	<1338944211-28275-3-git-send-email-andi@firstfloor.org>
Date: Tue, 05 Jun 2012 21:29:12 -0700
In-Reply-To: <1338944211-28275-3-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Tue, 5 Jun 2012 17:56:49 -0700")
Message-ID: <m262b5jc6f.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> Double check the CPU has a LBR format we support before using it.

Sorry this was an outdated version with a missing return. Here's
the correct one.

---

From: Andi Kleen <ak@linux.intel.com>
Date: Tue, 29 May 2012 20:00:05 -0700
Subject: [PATCH] perf, x86: Check LBR format capability

Double check the CPU has a LBR format we support before using it.

Also I made the init functions __init while I was on it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 520b426..753eed9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -12,6 +12,7 @@ enum {
 	LBR_FORMAT_LIP		= 0x01,
 	LBR_FORMAT_EIP		= 0x02,
 	LBR_FORMAT_EIP_FLAGS	= 0x03,
+	LBR_FORMAT_MAX		= LBR_FORMAT_EIP_FLAGS
 };
 
 /*
@@ -622,9 +623,21 @@ static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
 	[PERF_SAMPLE_BRANCH_IND_CALL]	= LBR_IND_CALL,
 };
 
+static bool lbr_common_init(void)
+{
+	if (x86_pmu.intel_cap.lbr_format > LBR_FORMAT_MAX) {
+		pr_cont("LBR has unknown format, ");
+		return false;
+	}
+	return true;
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
@@ -638,8 +651,11 @@ void intel_pmu_lbr_init_core(void)
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
@@ -659,8 +675,11 @@ void intel_pmu_lbr_init_nhm(void)
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
@@ -679,7 +698,7 @@ void intel_pmu_lbr_init_snb(void)
 }
 
 /* atom */
-void intel_pmu_lbr_init_atom(void)
+__init void intel_pmu_lbr_init_atom(void)
 {
 	/*
 	 * only models starting at stepping 10 seems
@@ -690,6 +709,8 @@ void intel_pmu_lbr_init_atom(void)
 		pr_cont("LBR disabled due to erratum");
 		return;
 	}
+	if (!lbr_common_init())
+		return;
 
 	x86_pmu.lbr_nr	   = 8;
 	x86_pmu.lbr_tos    = MSR_LBR_TOS;



-- 
ak@linux.intel.com -- Speaking for myself only
