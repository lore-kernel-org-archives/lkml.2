Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab2I1Eby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:31:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:51577 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab2I1Ebw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="199033673"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/31] perf, x86: Basic Haswell PMU support
Date: Thu, 27 Sep 2012 21:31:07 -0700
Message-Id: <1348806696-31170-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add basic Haswell PMU support.

Similar to SandyBridge, but has a few new events. Further
differences are handled in followon patches.

There are some new counter flags that need to be prevented
from being set on fixed counters.

Contains fixes from Stephane Eranian

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/perf_event.h      |    3 +++
 arch/x86/kernel/cpu/perf_event.h       |    7 +++++++
 arch/x86/kernel/cpu/perf_event_intel.c |   29 +++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index cb4e43b..c1fe6e9 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -29,6 +29,9 @@
 #define ARCH_PERFMON_EVENTSEL_INV			(1ULL << 23)
 #define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
 
+#define HSW_INTX					(1ULL << 32)
+#define HSW_INTX_CHECKPOINTED				(1ULL << 33)
+
 #define AMD_PERFMON_EVENTSEL_GUESTONLY			(1ULL << 40)
 #define AMD_PERFMON_EVENTSEL_HOSTONLY			(1ULL << 41)
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 6605a81..a135a5a 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -226,6 +226,13 @@ struct cpu_hw_events {
 	EVENT_CONSTRAINT(c, (1ULL << (32+n)), X86_RAW_EVENT_MASK)
 
 /*
+ * Also filter out TSX bits.
+ */
+#define TSX_FIXED_EVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, (1ULL << (32+n)),	\
+			 X86_RAW_EVENT_MASK|HSW_INTX|HSW_INTX_CHECKPOINTED)
+
+/*
  * Constraint on the Event code + UMask
  */
 #define INTEL_UEVENT_CONSTRAINT(c, n)	\
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0d3d63a..82bae24 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -133,6 +133,17 @@ static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
 	EVENT_EXTRA_END
 };
 
+static struct event_constraint intel_hsw_event_constraints[] =
+{
+	TSX_FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
+	TSX_FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
+	TSX_FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
+	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
+	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
+	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
+	EVENT_CONSTRAINT_END
+};
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -2074,6 +2085,24 @@ __init int intel_pmu_init(void)
 		pr_cont("SandyBridge events, ");
 		break;
 
+	case 60: /* Haswell Client */
+	case 70:
+	case 71:
+		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
+		       sizeof(hw_cache_event_ids));
+
+		intel_pmu_lbr_init_nhm();
+
+		x86_pmu.event_constraints = intel_hsw_event_constraints;
+
+		x86_pmu.extra_regs = intel_snb_extra_regs;
+		/* all extra regs are per-cpu when HT is on */
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+
+		pr_cont("Haswell events, ");
+		break;
+
 	default:
 		switch (x86_pmu.version) {
 		case 1:
-- 
1.7.7.6

