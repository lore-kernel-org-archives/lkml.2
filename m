Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1BBRCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 12:02:18 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:44790
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612Ab1BBRCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 12:02:17 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LG019D-02-KEU-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/5] perf, x86: Use helper function in x86_pmu_enable_all()
Date: Wed, 2 Feb 2011 17:40:56 +0100
Message-ID: <1296664860-10886-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
References: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper function in x86_pmu_enable_all() to minimize access to
x86_pmu.eventsel in the fast path. The counter's msr address is now
calculated using struct hw_perf_event. Later we add code that
calculates the msr addresses with a table lookup which shouldn't be
done in the fast path.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4d98789..70d6d8f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -642,21 +642,24 @@ static void x86_pmu_disable(struct pmu *pmu)
 	x86_pmu.disable_all();
 }
 
+static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
+					  u64 enable_mask)
+{
+	wrmsrl(hwc->config_base + hwc->idx, hwc->config | enable_mask);
+}
+
 static void x86_pmu_enable_all(int added)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
-		struct perf_event *event = cpuc->events[idx];
-		u64 val;
+		struct hw_perf_event *hwc = &cpuc->events[idx]->hw;
 
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
 
-		val = event->hw.config;
-		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
-		wrmsrl(x86_pmu.eventsel + idx, val);
+		__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
 	}
 }
 
@@ -915,12 +918,6 @@ static void x86_pmu_enable(struct pmu *pmu)
 	x86_pmu.enable_all(added);
 }
 
-static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
-					  u64 enable_mask)
-{
-	wrmsrl(hwc->config_base + hwc->idx, hwc->config | enable_mask);
-}
-
 static inline void x86_pmu_disable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
-- 
1.7.3.4


