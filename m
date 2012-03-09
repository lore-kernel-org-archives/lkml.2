Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab2CINXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:23:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58660 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2CINXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:23:14 -0500
Date: Fri, 9 Mar 2012 05:22:46 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-c5cc2cd906ea9fe73e3c93f9ad824996faa278cc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1328826068-11713-6-git-send-email-eranian@google.com>
References: <1328826068-11713-6-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf/x86:
  Add Intel LBR mappings for PERF_SAMPLE_BRANCH filters
Git-Commit-ID: c5cc2cd906ea9fe73e3c93f9ad824996faa278cc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:22:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5cc2cd906ea9fe73e3c93f9ad824996faa278cc
Gitweb:     http://git.kernel.org/tip/c5cc2cd906ea9fe73e3c93f9ad824996faa278cc
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 9 Feb 2012 23:20:55 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Mar 2012 14:55:41 +0100

perf/x86: Add Intel LBR mappings for PERF_SAMPLE_BRANCH filters

This patch adds the mappings from the generic PERF_SAMPLE_BRANCH_*
filters to the actual Intel x86LBR filters, whenever they exist.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328826068-11713-6-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.h           |    2 +
 arch/x86/kernel/cpu/perf_event_intel.c     |    2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  103 +++++++++++++++++++++++++++-
 3 files changed, 104 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 9b9c580..4e94897 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -539,6 +539,8 @@ void intel_pmu_lbr_init_nhm(void);
 
 void intel_pmu_lbr_init_atom(void);
 
+void intel_pmu_lbr_init_snb(void);
+
 int p4_pmu_init(void);
 
 int p6_pmu_init(void);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 97f7bb5..b0db016 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1757,7 +1757,7 @@ __init int intel_pmu_init(void)
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
-		intel_pmu_lbr_init_nhm();
+		intel_pmu_lbr_init_snb();
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_event_constraints;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 6710a51..e54a063 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -14,6 +14,49 @@ enum {
 };
 
 /*
+ * Intel LBR_SELECT bits
+ * Intel Vol3a, April 2011, Section 16.7 Table 16-10
+ *
+ * Hardware branch filter (not available on all CPUs)
+ */
+#define LBR_KERNEL_BIT		0 /* do not capture at ring0 */
+#define LBR_USER_BIT		1 /* do not capture at ring > 0 */
+#define LBR_JCC_BIT		2 /* do not capture conditional branches */
+#define LBR_REL_CALL_BIT	3 /* do not capture relative calls */
+#define LBR_IND_CALL_BIT	4 /* do not capture indirect calls */
+#define LBR_RETURN_BIT		5 /* do not capture near returns */
+#define LBR_IND_JMP_BIT		6 /* do not capture indirect jumps */
+#define LBR_REL_JMP_BIT		7 /* do not capture relative jumps */
+#define LBR_FAR_BIT		8 /* do not capture far branches */
+
+#define LBR_KERNEL	(1 << LBR_KERNEL_BIT)
+#define LBR_USER	(1 << LBR_USER_BIT)
+#define LBR_JCC		(1 << LBR_JCC_BIT)
+#define LBR_REL_CALL	(1 << LBR_REL_CALL_BIT)
+#define LBR_IND_CALL	(1 << LBR_IND_CALL_BIT)
+#define LBR_RETURN	(1 << LBR_RETURN_BIT)
+#define LBR_REL_JMP	(1 << LBR_REL_JMP_BIT)
+#define LBR_IND_JMP	(1 << LBR_IND_JMP_BIT)
+#define LBR_FAR		(1 << LBR_FAR_BIT)
+
+#define LBR_PLM (LBR_KERNEL | LBR_USER)
+
+#define LBR_SEL_MASK	0x1ff	/* valid bits in LBR_SELECT */
+#define LBR_NOT_SUPP	-1	/* LBR filter not supported */
+#define LBR_IGN		0	/* ignored */
+
+#define LBR_ANY		 \
+	(LBR_JCC	|\
+	 LBR_REL_CALL	|\
+	 LBR_IND_CALL	|\
+	 LBR_RETURN	|\
+	 LBR_REL_JMP	|\
+	 LBR_IND_JMP	|\
+	 LBR_FAR)
+
+#define LBR_FROM_FLAG_MISPRED  (1ULL << 63)
+
+/*
  * We only support LBR implementations that have FREEZE_LBRS_ON_PMI
  * otherwise it becomes near impossible to get a reliable stack.
  */
@@ -151,8 +194,6 @@ static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
 	cpuc->lbr_stack.nr = i;
 }
 
-#define LBR_FROM_FLAG_MISPRED  (1ULL << 63)
-
 /*
  * Due to lack of segmentation in Linux the effective address (offset)
  * is the same as the linear address, allowing us to merge the LIP and EIP
@@ -200,26 +241,84 @@ void intel_pmu_lbr_read(void)
 		intel_pmu_lbr_read_64(cpuc);
 }
 
+/*
+ * Map interface branch filters onto LBR filters
+ */
+static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
+	[PERF_SAMPLE_BRANCH_ANY]	= LBR_ANY,
+	[PERF_SAMPLE_BRANCH_USER]	= LBR_USER,
+	[PERF_SAMPLE_BRANCH_KERNEL]	= LBR_KERNEL,
+	[PERF_SAMPLE_BRANCH_HV]		= LBR_IGN,
+	[PERF_SAMPLE_BRANCH_ANY_RETURN]	= LBR_RETURN | LBR_REL_JMP
+					| LBR_IND_JMP | LBR_FAR,
+	/*
+	 * NHM/WSM erratum: must include REL_JMP+IND_JMP to get CALL branches
+	 */
+	[PERF_SAMPLE_BRANCH_ANY_CALL] =
+	 LBR_REL_CALL | LBR_IND_CALL | LBR_REL_JMP | LBR_IND_JMP | LBR_FAR,
+	/*
+	 * NHM/WSM erratum: must include IND_JMP to capture IND_CALL
+	 */
+	[PERF_SAMPLE_BRANCH_IND_CALL] = LBR_IND_CALL | LBR_IND_JMP,
+};
+
+static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
+	[PERF_SAMPLE_BRANCH_ANY]	= LBR_ANY,
+	[PERF_SAMPLE_BRANCH_USER]	= LBR_USER,
+	[PERF_SAMPLE_BRANCH_KERNEL]	= LBR_KERNEL,
+	[PERF_SAMPLE_BRANCH_HV]		= LBR_IGN,
+	[PERF_SAMPLE_BRANCH_ANY_RETURN]	= LBR_RETURN | LBR_FAR,
+	[PERF_SAMPLE_BRANCH_ANY_CALL]	= LBR_REL_CALL | LBR_IND_CALL
+					| LBR_FAR,
+	[PERF_SAMPLE_BRANCH_IND_CALL]	= LBR_IND_CALL,
+};
+
+/* core */
 void intel_pmu_lbr_init_core(void)
 {
 	x86_pmu.lbr_nr     = 4;
 	x86_pmu.lbr_tos    = MSR_LBR_TOS;
 	x86_pmu.lbr_from   = MSR_LBR_CORE_FROM;
 	x86_pmu.lbr_to     = MSR_LBR_CORE_TO;
+
+	pr_cont("4-deep LBR, ");
 }
 
+/* nehalem/westmere */
 void intel_pmu_lbr_init_nhm(void)
 {
 	x86_pmu.lbr_nr     = 16;
 	x86_pmu.lbr_tos    = MSR_LBR_TOS;
 	x86_pmu.lbr_from   = MSR_LBR_NHM_FROM;
 	x86_pmu.lbr_to     = MSR_LBR_NHM_TO;
+
+	x86_pmu.lbr_sel_mask = LBR_SEL_MASK;
+	x86_pmu.lbr_sel_map  = nhm_lbr_sel_map;
+
+	pr_cont("16-deep LBR, ");
 }
 
+/* sandy bridge */
+void intel_pmu_lbr_init_snb(void)
+{
+	x86_pmu.lbr_nr	 = 16;
+	x86_pmu.lbr_tos	 = MSR_LBR_TOS;
+	x86_pmu.lbr_from = MSR_LBR_NHM_FROM;
+	x86_pmu.lbr_to   = MSR_LBR_NHM_TO;
+
+	x86_pmu.lbr_sel_mask = LBR_SEL_MASK;
+	x86_pmu.lbr_sel_map  = snb_lbr_sel_map;
+
+	pr_cont("16-deep LBR, ");
+}
+
+/* atom */
 void intel_pmu_lbr_init_atom(void)
 {
 	x86_pmu.lbr_nr	   = 8;
 	x86_pmu.lbr_tos    = MSR_LBR_TOS;
 	x86_pmu.lbr_from   = MSR_LBR_CORE_FROM;
 	x86_pmu.lbr_to     = MSR_LBR_CORE_TO;
+
+	pr_cont("8-deep LBR, ");
 }
