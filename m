Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab0C2QlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:41:24 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:30652
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754598Ab0C2QlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:41:20 -0400
X-SpamScore: 2
X-BigFish: VPS2(zzab9bh1422izz1202hzzz32i87h2a8h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L01YCE-02-CO9-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/3] perf/core, x86: implement ARCH_PERFMON_EVENTSEL bit masks
Date: Mon, 29 Mar 2010 18:36:52 +0200
Message-ID: <1269880612-25800-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Mar 2010 16:41:00.0901 (UTC) FILETIME=[9D747150:01CACF5E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_PERFMON_EVENTSEL bit masks are offen used in the kernel. This
patch adds macros for the bit masks and removes local defines.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h      |   58 ++++++++++++++------------------
 arch/x86/kernel/cpu/perf_event.c       |   14 ++++++--
 arch/x86/kernel/cpu/perf_event_amd.c   |   15 +--------
 arch/x86/kernel/cpu/perf_event_intel.c |   15 +--------
 4 files changed, 38 insertions(+), 64 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 987bf67..f6d43db 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -18,39 +18,31 @@
 #define MSR_ARCH_PERFMON_EVENTSEL0			     0x186
 #define MSR_ARCH_PERFMON_EVENTSEL1			     0x187
 
-#define ARCH_PERFMON_EVENTSEL_ENABLE			  (1 << 22)
-#define ARCH_PERFMON_EVENTSEL_ANY			  (1 << 21)
-#define ARCH_PERFMON_EVENTSEL_INT			  (1 << 20)
-#define ARCH_PERFMON_EVENTSEL_OS			  (1 << 17)
-#define ARCH_PERFMON_EVENTSEL_USR			  (1 << 16)
-
-/*
- * Includes eventsel and unit mask as well:
- */
-
-
-#define INTEL_ARCH_EVTSEL_MASK		0x000000FFULL
-#define INTEL_ARCH_UNIT_MASK		0x0000FF00ULL
-#define INTEL_ARCH_EDGE_MASK		0x00040000ULL
-#define INTEL_ARCH_INV_MASK		0x00800000ULL
-#define INTEL_ARCH_CNT_MASK		0xFF000000ULL
-#define INTEL_ARCH_EVENT_MASK	(INTEL_ARCH_UNIT_MASK|INTEL_ARCH_EVTSEL_MASK)
-
-/*
- * filter mask to validate fixed counter events.
- * the following filters disqualify for fixed counters:
- *  - inv
- *  - edge
- *  - cnt-mask
- *  The other filters are supported by fixed counters.
- *  The any-thread option is supported starting with v3.
- */
-#define INTEL_ARCH_FIXED_MASK \
-	(INTEL_ARCH_CNT_MASK| \
-	 INTEL_ARCH_INV_MASK| \
-	 INTEL_ARCH_EDGE_MASK|\
-	 INTEL_ARCH_UNIT_MASK|\
-	 INTEL_ARCH_EVENT_MASK)
+#define ARCH_PERFMON_EVENTSEL_EVENT			0x000000FFULL
+#define ARCH_PERFMON_EVENTSEL_UMASK			0x0000FF00ULL
+#define ARCH_PERFMON_EVENTSEL_USR			(1ULL << 16)
+#define ARCH_PERFMON_EVENTSEL_OS			(1ULL << 17)
+#define ARCH_PERFMON_EVENTSEL_EDGE			(1ULL << 18)
+#define ARCH_PERFMON_EVENTSEL_INT			(1ULL << 20)
+#define ARCH_PERFMON_EVENTSEL_ANY			(1ULL << 21)
+#define ARCH_PERFMON_EVENTSEL_ENABLE			(1ULL << 22)
+#define ARCH_PERFMON_EVENTSEL_INV			(1ULL << 23)
+#define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
+
+#define AMD64_EVENTSEL_EVENT	\
+	(ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
+#define INTEL_ARCH_EVENT_MASK	\
+	(ARCH_PERFMON_EVENTSEL_UMASK | ARCH_PERFMON_EVENTSEL_EVENT)
+
+#define X86_RAW_EVENT_MASK		\
+	(ARCH_PERFMON_EVENTSEL_EVENT |	\
+	 ARCH_PERFMON_EVENTSEL_UMASK |	\
+	 ARCH_PERFMON_EVENTSEL_EDGE  |	\
+	 ARCH_PERFMON_EVENTSEL_INV   |	\
+	 ARCH_PERFMON_EVENTSEL_CMASK)
+#define AMD64_RAW_EVENT_MASK		\
+	(X86_RAW_EVENT_MASK          |  \
+	 AMD64_EVENTSEL_EVENT)
 
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 81218d0..ec25568 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -142,13 +142,21 @@ struct cpu_hw_events {
  * Constraint on the Event code.
  */
 #define INTEL_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVTSEL_MASK)
+	EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
 
 /*
  * Constraint on the Event code + UMask + fixed-mask
+ *
+ * filter mask to validate fixed counter events.
+ * the following filters disqualify for fixed counters:
+ *  - inv
+ *  - edge
+ *  - cnt-mask
+ *  The other filters are supported by fixed counters.
+ *  The any-thread option is supported starting with v3.
  */
 #define FIXED_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, (1ULL << (32+n)), INTEL_ARCH_FIXED_MASK)
+	EVENT_CONSTRAINT(c, (1ULL << (32+n)), X86_RAW_EVENT_MASK)
 
 /*
  * Constraint on the Event code + UMask
@@ -1424,7 +1432,7 @@ void __init init_hw_perf_events(void)
 
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if (c->cmask != INTEL_ARCH_FIXED_MASK)
+			if (c->cmask != X86_RAW_EVENT_MASK)
 				continue;
 
 			c->idxmsk64 |= (1ULL << x86_pmu.num_counters) - 1;
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 9d363ce..30e799a 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -113,20 +113,7 @@ static u64 amd_pmu_event_map(int hw_event)
 
 static u64 amd_pmu_raw_event(u64 hw_event)
 {
-#define K7_EVNTSEL_EVENT_MASK	0xF000000FFULL
-#define K7_EVNTSEL_UNIT_MASK	0x00000FF00ULL
-#define K7_EVNTSEL_EDGE_MASK	0x000040000ULL
-#define K7_EVNTSEL_INV_MASK	0x000800000ULL
-#define K7_EVNTSEL_REG_MASK	0x0FF000000ULL
-
-#define K7_EVNTSEL_MASK			\
-	(K7_EVNTSEL_EVENT_MASK |	\
-	 K7_EVNTSEL_UNIT_MASK  |	\
-	 K7_EVNTSEL_EDGE_MASK  |	\
-	 K7_EVNTSEL_INV_MASK   |	\
-	 K7_EVNTSEL_REG_MASK)
-
-	return hw_event & K7_EVNTSEL_MASK;
+	return hw_event & AMD64_RAW_EVENT_MASK;
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 6c5d83f..2f13e7a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -454,20 +454,7 @@ static __initconst u64 atom_hw_cache_event_ids
 
 static u64 intel_pmu_raw_event(u64 hw_event)
 {
-#define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
-#define CORE_EVNTSEL_UNIT_MASK		0x0000FF00ULL
-#define CORE_EVNTSEL_EDGE_MASK		0x00040000ULL
-#define CORE_EVNTSEL_INV_MASK		0x00800000ULL
-#define CORE_EVNTSEL_REG_MASK		0xFF000000ULL
-
-#define CORE_EVNTSEL_MASK		\
-	(INTEL_ARCH_EVTSEL_MASK |	\
-	 INTEL_ARCH_UNIT_MASK   |	\
-	 INTEL_ARCH_EDGE_MASK   |	\
-	 INTEL_ARCH_INV_MASK    |	\
-	 INTEL_ARCH_CNT_MASK)
-
-	return hw_event & CORE_EVNTSEL_MASK;
+	return hw_event & X86_RAW_EVENT_MASK;
 }
 
 static void intel_pmu_disable_all(void)
-- 
1.7.0.3


