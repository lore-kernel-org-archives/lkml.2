Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab2I1EiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:38:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:59149 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2I1Ebx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="227581573"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 13/31] perf, x86: Support LBR filtering by INTX/NOTX/ABORT
Date: Thu, 27 Sep 2012 21:31:18 -0700
Message-Id: <1348806696-31170-14-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add LBR filtering for branch in transaction, branch not in transaction
or transaction abort. This is exposed as new sample types.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   31 +++++++++++++++++++++++++--
 include/linux/perf_event.h                 |    5 +++-
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index ad5af13..63451b1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -85,9 +85,13 @@ enum {
 	X86_BR_JMP      = 1 << 9, /* jump */
 	X86_BR_IRQ      = 1 << 10,/* hw interrupt or trap or fault */
 	X86_BR_IND_CALL = 1 << 11,/* indirect calls */
+	X86_BR_ABORT    = 1 << 12,/* transaction abort */
+	X86_BR_INTX     = 1 << 13,/* in transaction */
+	X86_BR_NOTX     = 1 << 14,/* not in transaction */
 };
 
 #define X86_BR_PLM (X86_BR_USER | X86_BR_KERNEL)
+#define X86_BR_ANYTX (X86_BR_NOTX | X86_BR_INTX)
 
 #define X86_BR_ANY       \
 	(X86_BR_CALL    |\
@@ -99,6 +103,7 @@ enum {
 	 X86_BR_JCC     |\
 	 X86_BR_JMP	 |\
 	 X86_BR_IRQ	 |\
+	 X86_BR_ABORT	 |\
 	 X86_BR_IND_CALL)
 
 #define X86_BR_ALL (X86_BR_PLM | X86_BR_ANY)
@@ -347,6 +352,16 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 
 	if (br_type & PERF_SAMPLE_BRANCH_IND_CALL)
 		mask |= X86_BR_IND_CALL;
+
+	if (br_type & PERF_SAMPLE_BRANCH_ABORT)
+		mask |= X86_BR_ABORT;
+
+	if (br_type & PERF_SAMPLE_BRANCH_INTX)
+		mask |= X86_BR_INTX;
+
+	if (br_type & PERF_SAMPLE_BRANCH_NOTX)
+		mask |= X86_BR_NOTX;
+
 	/*
 	 * stash actual user request into reg, it may
 	 * be used by fixup code for some CPU
@@ -393,7 +408,8 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
 	/*
 	 * no LBR on this PMU
 	 */
-	if (!x86_pmu.lbr_nr || x86_pmu.intel_cap.lbr_format > LBR_FORMAT_MAX_KNOWN)
+	if (!x86_pmu.lbr_nr || 
+	    x86_pmu.intel_cap.lbr_format > LBR_FORMAT_MAX_KNOWN)
 		return -EOPNOTSUPP;
 
 	/*
@@ -421,7 +437,7 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
  * decoded (e.g., text page not present), then X86_BR_NONE is
  * returned.
  */
-static int branch_type(unsigned long from, unsigned long to)
+static int branch_type(unsigned long from, unsigned long to, int abort)
 {
 	struct insn insn;
 	void *addr;
@@ -441,6 +457,9 @@ static int branch_type(unsigned long from, unsigned long to)
 	if (from == 0 || to == 0)
 		return X86_BR_NONE;
 
+	if (abort)
+		return X86_BR_ABORT | to_plm;
+
 	if (from_plm == X86_BR_USER) {
 		/*
 		 * can happen if measuring at the user level only
@@ -577,7 +596,13 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
 		from = cpuc->lbr_entries[i].from;
 		to = cpuc->lbr_entries[i].to;
 
-		type = branch_type(from, to);
+		type = branch_type(from, to, cpuc->lbr_entries[i].abort);
+		if (type != X86_BR_NONE && (br_sel & X86_BR_ANYTX)) {
+			if (cpuc->lbr_entries[i].intx)
+				type |= X86_BR_INTX;
+			else
+				type |= X86_BR_NOTX;
+		}
 
 		/* if type does not correspond, then discard */
 		if (type == X86_BR_NONE || (br_sel & type) != type) {
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index fadd14b..5bc0e8b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -153,8 +153,11 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_ANY_CALL	= 1U << 4, /* any call branch */
 	PERF_SAMPLE_BRANCH_ANY_RETURN	= 1U << 5, /* any return branch */
 	PERF_SAMPLE_BRANCH_IND_CALL	= 1U << 6, /* indirect calls */
+	PERF_SAMPLE_BRANCH_ABORT	= 1U << 7, /* transaction aborts */
+	PERF_SAMPLE_BRANCH_INTX		= 1U << 8, /* in transaction (flag) */
+	PERF_SAMPLE_BRANCH_NOTX		= 1U << 9, /* not in transaction (flag) */
 
-	PERF_SAMPLE_BRANCH_MAX		= 1U << 7, /* non-ABI */
+	PERF_SAMPLE_BRANCH_MAX		= 1U << 10, /* non-ABI */
 };
 
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
-- 
1.7.7.6

