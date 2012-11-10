Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2KJBcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:32:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:1588 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab2KJB2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:28:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,749,1344236400"; 
   d="scan'208";a="217548797"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 13/32] perf, x86: Avoid checkpointed counters causing excessive TSX aborts v3
Date: Fri,  9 Nov 2012 17:27:29 -0800
Message-Id: <1352510868-7911-14-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
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

v2: Add unlikely. Add comment
v3: Allow large sampling periods with CP for KVM
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   34 ++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index bc21bce..9b4dda5 100644
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
+	if (unlikely(event->hw.config & HSW_INTX_CHECKPOINTED)) {
+		/* No race with NMIs because the counter should not be armed */
+		wrmsrl(event->hw.event_base, 0);
+		local64_set(&event->hw.prev_count, 0);
+	}
 	return x86_perf_event_set_period(event);
 }
 
@@ -1162,6 +1173,15 @@ again:
 		x86_pmu.drain_pebs(regs);
 	}
 
+	/*
+ 	 * To avoid spurious interrupts with perf stat always reset checkpointed
+ 	 * counters.
+ 	 *
+	 * XXX move somewhere else.
+	 */
+	if (cpuc->events[2] && (cpuc->events[2]->hw.config & HSW_INTX_CHECKPOINTED))
+		status |= (1ULL << 2);
+
 	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
@@ -1615,6 +1635,20 @@ static int hsw_hw_config(struct perf_event *event)
 	     ((event->hw.config & ARCH_PERFMON_EVENTSEL_ANY) ||
 	      event->attr.precise_ip > 0))
 		return -EIO;
+	if (event->hw.config & HSW_INTX_CHECKPOINTED) {
+		/*
+		 * Sampling of checkpointed events can cause situations where
+		 * the CPU constantly aborts because of a overflow, which is
+		 * then checkpointed back and ignored. Forbid checkpointing
+		 * for sampling.
+		 *
+		 * But still allow a long sampling period, so that perf stat
+		 * from KVM works.
+		 */
+		if (event->attr.sample_period > 0 &&
+		    event->attr.sample_period < 0x7fffffff)
+			return -EIO;
+	}
 	return 0;
 }
 
-- 
1.7.7.6

