Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab2KJB16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:27:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:1588 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab2KJB15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:27:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,749,1344236400"; 
   d="scan'208";a="217548793"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/32] perf, x86: Basic Haswell PMU support v2
Date: Fri,  9 Nov 2012 17:27:18 -0800
Message-Id: <1352510868-7911-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
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

v2: Folded TSX bits into standard FIXED_EVENT_CONSTRAINTS
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/perf_event.h      |    3 +++
 arch/x86/kernel/cpu/perf_event.h       |    5 ++++-
 arch/x86/kernel/cpu/perf_event_intel.c |   29 +++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 4fabcdf..4003bb6 100644
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
index 115c1ea..8941899 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -219,11 +219,14 @@ struct cpu_hw_events {
  *  - inv
  *  - edge
  *  - cnt-mask
+ *  - intx
+ *  - intx_cp
  *  The other filters are supported by fixed counters.
  *  The any-thread option is supported starting with v3.
  */
+#define FIXED_EVENT_FLAGS (X86_RAW_EVENT_MASK|HSW_INTX|HSW_INTX_CHECKPOINTED)
 #define FIXED_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, (1ULL << (32+n)), X86_RAW_EVENT_MASK)
+	EVENT_CONSTRAINT(c, (1ULL << (32+n)), FIXED_EVENT_FLAGS)
 
 /*
  * Constraint on the Event code + UMask
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 93b9e11..3a08534 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -133,6 +133,17 @@ static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
 	EVENT_EXTRA_END
 };
 
+static struct event_constraint intel_hsw_event_constraints[] =
+{
+	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
+	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
+	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
+	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
+	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
+	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
+	EVENT_CONSTRAINT_END
+};
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -2107,6 +2118,24 @@ __init int intel_pmu_init(void)
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

