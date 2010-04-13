Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab0DMU3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:29:09 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:25190 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab0DMU0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:26:52 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh467h2a8h87h65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0U0SD-01-CAV-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 05/12] perf, x86: pass enable bit mask to __x86_pmu_enable_event()
Date: Tue, 13 Apr 2010 22:23:14 +0200
Message-ID: <1271190201-25705-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 13 Apr 2010 20:26:35.0449 (UTC) FILETIME=[9CDED290:01CADB47]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To reuse this function for events with different enable bit masks,
this mask is part of the function's argument list now.

The function will be used later to control ibs events too.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c       |    9 +++++----
 arch/x86/kernel/cpu/perf_event_intel.c |    5 +++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9eeffad..f66f52a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -847,10 +847,10 @@ void hw_perf_enable(void)
 	x86_pmu.enable_all(added);
 }
 
-static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc)
+static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
+					  u64 enable_mask)
 {
-	wrmsrl(hwc->config_base + hwc->idx,
-			      hwc->config | ARCH_PERFMON_EVENTSEL_ENABLE);
+	wrmsrl(hwc->config_base + hwc->idx, hwc->config | enable_mask);
 }
 
 static inline void x86_pmu_disable_event(struct perf_event *event)
@@ -922,7 +922,8 @@ static void x86_pmu_enable_event(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	if (cpuc->enabled)
-		__x86_pmu_enable_event(&event->hw);
+		__x86_pmu_enable_event(&event->hw,
+				       ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a099df9..a4b56ac 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -513,7 +513,8 @@ static void intel_pmu_nhm_enable_all(int added)
 			if (!event)
 				continue;
 
-			__x86_pmu_enable_event(&event->hw);
+			__x86_pmu_enable_event(&event->hw,
+					       ARCH_PERFMON_EVENTSEL_ENABLE);
 		}
 	}
 	intel_pmu_enable_all(added);
@@ -617,7 +618,7 @@ static void intel_pmu_enable_event(struct perf_event *event)
 	if (unlikely(event->attr.precise))
 		intel_pmu_pebs_enable(event);
 
-	__x86_pmu_enable_event(hwc);
+	__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
 /*
-- 
1.7.0.3


