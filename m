Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab2JBXxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:53:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:37543 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835Ab2JBXtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:49:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,525,1344236400"; 
   d="scan'208";a="199832073"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, x86@vger.kernel.org, eranian@google.com, jolsa@redhat.com,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 14/31] perf, x86: Avoid checkpointed counters causing excessive TSX aborts
Date: Tue,  2 Oct 2012 16:48:34 -0700
Message-Id: <1349221731-15665-15-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
References: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With checkpointed counters there can be a situation where the counter
is overflowing, aborts the transaction, is set back to a non overflowing
checkpoint, causes interupt. The interrupt doesn't see the overflow
because it has been checkpointed.  This is then a spurious PMI, typically with a
ugly NMI message.  It can also lead to excessive aborts.

Avoid this problem by:
- Using the full counter width for counting counters (previous patch)
- Forbid sampling for checkpointed counters. It's not too useful anyways,
checkpointing is mainly for counting.
- On a PMI always set back checkpointed counters to zero.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 21542bf..ede3220 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1079,6 +1079,17 @@ static void intel_pmu_enable_event(struct perf_event *event)
 int intel_pmu_save_and_restart(struct perf_event *event)
 {
 	x86_perf_event_update(event);
+	/*
+	 * For a checkpointed counter always reset back to 0.  This
+	 * avoids a situation where the counter overflows, aborts the
+	 * transaction and is then set back to shortly before the
+	 * overflow, and overflows and aborts again.
+	 */
+	if (event->hw.config & HSW_INTX_CHECKPOINTED) {
+		/* No race with NMIs because the counter should not be armed */
+		wrmsrl(event->hw.event_base, 0);
+		local64_set(&event->hw.prev_count, 0);
+	}
 	return x86_perf_event_set_period(event);
 }
 
@@ -1162,6 +1173,10 @@ again:
 		x86_pmu.drain_pebs(regs);
 	}
 
+	/* XXX move somewhere else. */
+	if (cpuc->events[2] && (cpuc->events[2]->hw.config & HSW_INTX_CHECKPOINTED))
+		status |= (1ULL << 2);
+
 	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
@@ -1627,6 +1642,16 @@ static int hsw_hw_config(struct perf_event *event)
 	if (!boot_cpu_has(X86_FEATURE_RTM) && !boot_cpu_has(X86_FEATURE_HLE))
 		return 0;
 	event->hw.config |= event->attr.config & (HSW_INTX|HSW_INTX_CHECKPOINTED);
+	if (event->hw.config & HSW_INTX_CHECKPOINTED) {
+		/*
+		 * Sampling of checkpointed events can cause situations where
+		 * the CPU constantly aborts because of a overflow, which is
+		 * then checkpointed back and ignored. Forbid checkpointing
+		 * for sampling.
+		 */
+		if (is_sampling_event(event))
+			return -EIO;
+	}
 	return 0;
 }
 
-- 
1.7.7.6

