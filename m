Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab0ILFh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 01:37:58 -0400
Received: from mx6.orcon.net.nz ([219.88.242.56]:43856 "EHLO mx6.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab0ILFh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 01:37:57 -0400
From: Michael Cree <mcree@orcon.net.nz>
To: peterz@infradead.org
Cc: Michael Cree <mcree@orcon.net.nz>, mingo@redhat.com,
        dengcheng.zhu@gmail.com, yanmin_zhang@linux.intel.com,
        gorcunov@gmail.com, fweisbec@gmail.com, robert.richter@amd.com,
        ming.m.lin@intel.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, eranian@googlemail.com,
        will.deacon@arm.com, lethal@linux-sh.org, davem@davemloft.net,
        mingo@elte.hu, linux-alpha@vger.kernel.org
Subject: [PATCH] alpha:  Fix HW performance counters to be stopped properly.
Date: Sun, 12 Sep 2010 17:37:24 +1200
Message-Id: <1284269844-23251-1-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <4C8C6611.20206@orcon.net.nz>
References: <4C8C6611.20206@orcon.net.nz>
X-DSPAM-Check: by mx6.orcon.net.nz on Sun, 12 Sep 2010 17:37:51 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Sep 12 17:37:53 2010
X-DSPAM-Confidence: 0.9939
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fix a few compile errors due to undefined and duplicated
variables.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
---
 arch/alpha/kernel/perf_event.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/alpha/kernel/perf_event.c b/arch/alpha/kernel/perf_event.c
index a25fe9e..41f204f 100644
--- a/arch/alpha/kernel/perf_event.c
+++ b/arch/alpha/kernel/perf_event.c
@@ -422,9 +422,10 @@ static void maybe_change_configuration(struct cpu_hw_events *cpuc)
 static int alpha_pmu_add(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
 	int n0;
 	int ret;
-	unsigned long flags;
+	unsigned long irq_flags;
 
 	/*
 	 * The Sparc code has the IRQ disable first followed by the perf
@@ -435,7 +436,7 @@ static int alpha_pmu_add(struct perf_event *event, int flags)
 	 * final PMI to occur before we disable interrupts.
 	 */
 	perf_pmu_disable(event->pmu);
-	local_irq_save(flags);
+	local_irq_save(irq_flags);
 
 	/* Default to error to be returned */
 	ret = -EAGAIN;
@@ -458,7 +459,7 @@ static int alpha_pmu_add(struct perf_event *event, int flags)
 	if (!(flags & PERF_EF_START))
 		hwc->state |= PERF_HES_STOPPED;
 
-	local_irq_restore(flags);
+	local_irq_restore(irq_flags);
 	perf_pmu_enable(event->pmu);
 
 	return ret;
@@ -474,11 +475,11 @@ static void alpha_pmu_del(struct perf_event *event, int flags)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
-	unsigned long flags;
+	unsigned long irq_flags;
 	int j;
 
 	perf_pmu_disable(event->pmu);
-	local_irq_save(flags);
+	local_irq_save(irq_flags);
 
 	for (j = 0; j < cpuc->n_events; j++) {
 		if (event == cpuc->event[j]) {
@@ -504,7 +505,7 @@ static void alpha_pmu_del(struct perf_event *event, int flags)
 		}
 	}
 
-	local_irq_restore(flags);
+	local_irq_restore(irq_flags);
 	perf_pmu_enable(event->pmu);
 }
 
@@ -523,7 +524,7 @@ static void alpha_pmu_stop(struct perf_event *event, int flags)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	if (!(hwc->state & PERF_HES_STOPPED)) {
-		cpuc->idx_mask &= !(1UL<<hwc->idx);
+		cpuc->idx_mask &= ~(1UL<<hwc->idx);
 		hwc->state |= PERF_HES_STOPPED;
 	}
 
@@ -533,7 +534,7 @@ static void alpha_pmu_stop(struct perf_event *event, int flags)
 	}
 
 	if (cpuc->enabled)
-		wrperfmon(PERFMON_CMD_ENABLE, (1UL<<hwc->idx));
+		wrperfmon(PERFMON_CMD_DISABLE, (1UL<<hwc->idx));
 }
 
 
-- 
1.7.1

