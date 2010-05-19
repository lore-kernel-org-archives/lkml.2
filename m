Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab0ESVlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:41:07 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:15823 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab0ESVlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:41:04 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h2a8h43h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L2OS85-02-UV5-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/7] perf, x86: modify some code to allow the introduction of ibs events
Date: Wed, 19 May 2010 23:20:20 +0200
Message-ID: <1274304024-6551-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The changes are needed to introduce ibs events that are implemented as
special x86 events.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 75c0a44..e64502c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -283,7 +283,7 @@ x86_perf_event_update(struct perf_event *event)
 	int idx = hwc->idx;
 	s64 delta;
 
-	if (idx == X86_PMC_IDX_SPECIAL_BTS)
+	if (idx >= X86_PMC_IDX_SPECIAL)
 		return 0;
 
 	/*
@@ -775,10 +775,10 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	hwc->last_cpu = smp_processor_id();
 	hwc->last_tag = ++cpuc->tags[i];
 
-	if (hwc->idx == X86_PMC_IDX_SPECIAL_BTS) {
-		hwc->config_base = 0;
-		hwc->event_base	= 0;
-	} else if (hwc->idx >= X86_PMC_IDX_FIXED) {
+	if (hwc->idx < X86_PMC_IDX_FIXED) {
+		hwc->config_base = x86_pmu.eventsel;
+		hwc->event_base  = x86_pmu.perfctr;
+	} else if (hwc->idx < X86_PMC_IDX_SPECIAL) {
 		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
 		/*
 		 * We set it so that event_base + idx in wrmsr/rdmsr maps to
@@ -786,9 +786,9 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 		 */
 		hwc->event_base =
 			MSR_ARCH_PERFMON_FIXED_CTR0 - X86_PMC_IDX_FIXED;
-	} else {
-		hwc->config_base = x86_pmu.eventsel;
-		hwc->event_base  = x86_pmu.perfctr;
+	} else if (hwc->idx == X86_PMC_IDX_SPECIAL_BTS) {
+		hwc->config_base = 0;
+		hwc->event_base	= 0;
 	}
 }
 
@@ -891,7 +891,7 @@ x86_perf_event_set_period(struct perf_event *event)
 	s64 period = hwc->sample_period;
 	int ret = 0, idx = hwc->idx;
 
-	if (idx == X86_PMC_IDX_SPECIAL_BTS)
+	if (idx >= X86_PMC_IDX_SPECIAL_BTS)
 		return 0;
 
 	/*
-- 
1.7.1


