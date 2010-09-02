Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0IBTIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:08:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407Ab0IBTIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:08:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: peterz@infradead.org, robert.richter@amd.com, gorcunov@gmail.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
        ming.m.lin@intel.com, yinghai@kernel.org, andi@firstfloor.org,
        eranian@google.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/3] perf, x86: Fix handle_irq return values
Date: Thu,  2 Sep 2010 15:07:49 -0400
Message-Id: <1283454469-1909-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Now that we rely on the number of handled overflows, ensure all handle_irq
implementations actually return the right number.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1282228033.2605.204.camel@laptop>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    9 +++++++--
 arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 1297bf1..ee05c90 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -713,6 +713,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	struct cpu_hw_events *cpuc;
 	int bit, loops;
 	u64 status;
+	int handled = 0;
 
 	perf_sample_data_init(&data, 0);
 
@@ -743,12 +744,16 @@ again:
 	/*
 	 * PEBS overflow sets bit 62 in the global status register
 	 */
-	if (__test_and_clear_bit(62, (unsigned long *)&status))
+	if (__test_and_clear_bit(62, (unsigned long *)&status)) {
+		handled++;
 		x86_pmu.drain_pebs(regs);
+	}
 
 	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
+		handled++;
+
 		if (!test_bit(bit, cpuc->active_mask))
 			continue;
 
@@ -770,7 +775,7 @@ again:
 
 done:
 	intel_pmu_enable_all(0);
-	return 1;
+	return handled;
 }
 
 static struct event_constraint *
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index febb12c..d470c91 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -690,7 +690,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 		inc_irq_stat(apic_perf_irqs);
 	}
 
-	return handled > 0;
+	return handled;
 }
 
 /*
-- 
1.7.2.2

