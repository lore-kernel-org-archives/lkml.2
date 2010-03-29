Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0C2QlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:41:19 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:19744
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754598Ab0C2QlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:41:16 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i2a8h87h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L01YCF-01-GK3-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/3] perf/core, x86: removing p6_pmu_raw_event()
Date: Mon, 29 Mar 2010 18:36:51 +0200
Message-ID: <1269880612-25800-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Mar 2010 16:41:00.0917 (UTC) FILETIME=[9D76E250:01CACF5E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is the same as intel_pmu_raw_event(). This patch removes
the duplicate code.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c       |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c |    2 ++
 arch/x86/kernel/cpu/perf_event_p6.c    |   20 +-------------------
 3 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f2fc2d8..81218d0 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1320,11 +1320,11 @@ undo:
 }
 
 #include "perf_event_amd.c"
-#include "perf_event_p6.c"
 #include "perf_event_p4.c"
 #include "perf_event_intel_lbr.c"
 #include "perf_event_intel_ds.c"
 #include "perf_event_intel.c"
+#include "perf_event_p6.c"
 
 static int __cpuinit
 x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0d68531..6c5d83f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -842,6 +842,8 @@ static __initconst struct x86_pmu intel_pmu = {
 	.cpu_dying		= intel_pmu_cpu_dying,
 };
 
+static __init int p6_pmu_init(void);
+
 static void intel_clovertown_quirks(void)
 {
 	/*
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index b26fbc7..8cdd054 100644
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
+	.raw_event		= intel_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(p6_perfmon_event_map),
 	.apic			= 1,
 	.max_period		= (1ULL << 31) - 1,
-- 
1.7.0.3


