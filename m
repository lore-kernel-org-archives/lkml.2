Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0CQLxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 07:53:51 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:8172 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab0CQLwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 07:52:55 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KZFCZV-02-31H-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/4] perf/core, x86: remove duplicate perf_event_mask variable
Date: Wed, 17 Mar 2010 12:49:13 +0100
Message-ID: <1268826553-19518-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1268826553-19518-1-git-send-email-robert.richter@amd.com>
References: <1268826553-19518-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 17 Mar 2010 11:52:37.0794 (UTC) FILETIME=[570AD820:01CAC5C8]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same information is stored also in x86_pmu.intel_ctrl. This patch
removes perf_event_mask and instead uses x86_pmu.intel_ctrl directly.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 104292a..c97d5b5 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -75,8 +75,6 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	return len;
 }
 
-static u64 perf_event_mask __read_mostly;
-
 struct event_constraint {
 	union {
 		unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
@@ -1406,7 +1404,7 @@ void __init init_hw_perf_events(void)
 		     x86_pmu.num_events, X86_PMC_MAX_GENERIC);
 		x86_pmu.num_events = X86_PMC_MAX_GENERIC;
 	}
-	perf_event_mask = (1 << x86_pmu.num_events) - 1;
+	x86_pmu.intel_ctrl = (1 << x86_pmu.num_events) - 1;
 	perf_max_events = x86_pmu.num_events;
 
 	if (x86_pmu.num_events_fixed > X86_PMC_MAX_FIXED) {
@@ -1415,9 +1413,8 @@ void __init init_hw_perf_events(void)
 		x86_pmu.num_events_fixed = X86_PMC_MAX_FIXED;
 	}
 
-	perf_event_mask |=
+	x86_pmu.intel_ctrl |=
 		((1LL << x86_pmu.num_events_fixed)-1) << X86_PMC_IDX_FIXED;
-	x86_pmu.intel_ctrl = perf_event_mask;
 
 	perf_events_lapic_init();
 	register_die_notifier(&perf_event_nmi_notifier);
@@ -1442,7 +1439,7 @@ void __init init_hw_perf_events(void)
 	pr_info("... value mask:             %016Lx\n", x86_pmu.event_mask);
 	pr_info("... max period:             %016Lx\n", x86_pmu.max_period);
 	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_events_fixed);
-	pr_info("... event mask:             %016Lx\n", perf_event_mask);
+	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
 
 	perf_cpu_notifier(x86_pmu_notifier);
 }
-- 
1.7.0


