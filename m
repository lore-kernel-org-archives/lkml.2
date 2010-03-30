Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0C3J2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 05:28:40 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:32828 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab0C3J2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 05:28:37 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz98dN936eM62a3Lab9bha706l1422izz1202hzzz32i6bh2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0L038ZC-01-1AR-02
X-M-MSG: 
Date: Tue, 30 Mar 2010 11:28:21 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf/core, x86: implement ARCH_PERFMON_EVENTSEL
 bit masks
Message-ID: <20100330092821.GH11907@erda.amd.com>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
 <1269880612-25800-4-git-send-email-robert.richter@amd.com>
 <1269881338.12097.361.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1269881338.12097.361.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 30 Mar 2010 09:28:22.0215 (UTC) FILETIME=[57490D70:01CACFEB]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.03.10 18:48:58, Peter Zijlstra wrote:
> Could you fold this with your 2/3 and create x86_pmu_raw_event() which
> lives in arch/x86/kernel/cpu/perf_event.c, that's more consistent wrt
> the X86_RAW_EVENT_MASK name and that way you don't need to re-order the
> #include ""s either.

The patch below replaces patches 2 and 3.

-Robert

---

>From 2d77650a4dc5ded763dc3c120381bdbe5a0be911 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Wed, 17 Mar 2010 12:32:37 +0100
Subject: [PATCH] perf/core, x86: implement ARCH_PERFMON_EVENTSEL bit masks

ARCH_PERFMON_EVENTSEL bit masks are often used in the kernel. This
patch adds macros for the bit masks and removes local defines. The
function intel_pmu_raw_event() becomes x86_pmu_raw_event() which is
generic for x86 models and same also for p6. Duplicate code is
removed.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h      |   58 ++++++++++++++------------------
 arch/x86/kernel/cpu/perf_event.c       |   19 +++++++++--
 arch/x86/kernel/cpu/perf_event_amd.c   |   15 +--------
 arch/x86/kernel/cpu/perf_event_intel.c |   22 +-----------
 arch/x86/kernel/cpu/perf_event_p6.c    |   20 +----------
 5 files changed, 45 insertions(+), 89 deletions(-)

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
index f2fc2d8..4e8d233 100644
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
@@ -436,6 +444,11 @@ static int x86_hw_config(struct perf_event_attr *attr, struct hw_perf_event *hwc
 	return 0;
 }
 
+static u64 x86_pmu_raw_event(u64 hw_event)
+{
+	return hw_event & X86_RAW_EVENT_MASK;
+}
+
 /*
  * Setup the hardware configuration for a given attr_type
  */
@@ -1424,7 +1437,7 @@ void __init init_hw_perf_events(void)
 
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
index 0d68531..b65cfc3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -452,24 +452,6 @@ static __initconst u64 atom_hw_cache_event_ids
  },
 };
 
-static u64 intel_pmu_raw_event(u64 hw_event)
-{
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
-}
-
 static void intel_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -788,7 +770,7 @@ static __initconst struct x86_pmu core_pmu = {
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
 	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
 	.event_map		= intel_pmu_event_map,
-	.raw_event		= intel_pmu_raw_event,
+	.raw_event		= x86_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
 	.apic			= 1,
 	/*
@@ -827,7 +809,7 @@ static __initconst struct x86_pmu intel_pmu = {
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
 	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
 	.event_map		= intel_pmu_event_map,
-	.raw_event		= intel_pmu_raw_event,
+	.raw_event		= x86_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
 	.apic			= 1,
 	/*
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index b26fbc7..03c139a 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -27,24 +27,6 @@ static u64 p6_pmu_event_map(int hw_event)
  */
 #define P6_NOP_EVENT			0x0000002EULL
 
-static u64 p6_pmu_raw_event(u64 hw_event)
-{
-#define P6_EVNTSEL_EVENT_MASK		0x000000FFULL
-#define P6_EVNTSEL_UNIT_MASK		0x0000FF00ULL
-#define P6_EVNTSEL_EDGE_MASK		0x00040000ULL
-#define P6_EVNTSEL_INV_MASK		0x00800000ULL
-#define P6_EVNTSEL_REG_MASK		0xFF000000ULL
-
-#define P6_EVNTSEL_MASK			\
-	(P6_EVNTSEL_EVENT_MASK |	\
-	 P6_EVNTSEL_UNIT_MASK  |	\
-	 P6_EVNTSEL_EDGE_MASK  |	\
-	 P6_EVNTSEL_INV_MASK   |	\
-	 P6_EVNTSEL_REG_MASK)
-
-	return hw_event & P6_EVNTSEL_MASK;
-}
-
 static struct event_constraint p6_event_constraints[] =
 {
 	INTEL_EVENT_CONSTRAINT(0xc1, 0x1),	/* FLOPS */
@@ -114,7 +96,7 @@ static __initconst struct x86_pmu p6_pmu = {
 	.eventsel		= MSR_P6_EVNTSEL0,
 	.perfctr		= MSR_P6_PERFCTR0,
 	.event_map		= p6_pmu_event_map,
-	.raw_event		= p6_pmu_raw_event,
+	.raw_event		= x86_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(p6_perfmon_event_map),
 	.apic			= 1,
 	.max_period		= (1ULL << 31) - 1,
-- 
1.7.0.3



-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

