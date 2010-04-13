Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0DMU1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:27:19 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:17572 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab0DMU1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:27:00 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i87h467h6bh2a8h64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0U0SJ-02-H0T-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 08/12] perf, x86: modify some code to allow the introduction of ibs events
Date: Tue, 13 Apr 2010 22:23:17 +0200
Message-ID: <1271190201-25705-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 13 Apr 2010 20:26:35.0605 (UTC) FILETIME=[9CF6A050:01CADB47]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
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
index 2a7c2fc..67b99a9 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -281,7 +281,7 @@ x86_perf_event_update(struct perf_event *event)
 	int idx = hwc->idx;
 	s64 delta;
 
-	if (idx == X86_PMC_IDX_SPECIAL_BTS)
+	if (idx >= X86_PMC_IDX_SPECIAL)
 		return 0;
 
 	/*
@@ -758,10 +758,10 @@ static inline void x86_assign_hw_event(struct perf_event *event,
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
@@ -769,9 +769,9 @@ static inline void x86_assign_hw_event(struct perf_event *event,
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
 
@@ -874,7 +874,7 @@ x86_perf_event_set_period(struct perf_event *event)
 	s64 period = hwc->sample_period;
 	int ret = 0, idx = hwc->idx;
 
-	if (idx == X86_PMC_IDX_SPECIAL_BTS)
+	if (idx >= X86_PMC_IDX_SPECIAL_BTS)
 		return 0;
 
 	/*
-- 
1.7.0.3


