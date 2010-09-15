Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab0IOKC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:02:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:39846 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab0IOKCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:02:55 -0400
Date: Wed, 15 Sep 2010 10:02:18 GMT
From: tip-bot for Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        mcree@orcon.net.nz
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mcree@orcon.net.nz,
        mingo@elte.hu
In-Reply-To: <1284269844-23251-1-git-send-email-mcree@orcon.net.nz>
References: <1284269844-23251-1-git-send-email-mcree@orcon.net.nz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] alpha: Fix HW performance counters to be stopped properly
Message-ID: <tip-65175c07653534294257f75baa03a36edad86870@git.kernel.org>
Git-Commit-ID: 65175c07653534294257f75baa03a36edad86870
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Sep 2010 10:02:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65175c07653534294257f75baa03a36edad86870
Gitweb:     http://git.kernel.org/tip/65175c07653534294257f75baa03a36edad86870
Author:     Michael Cree <mcree@orcon.net.nz>
AuthorDate: Sun, 12 Sep 2010 17:37:24 +1200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Sep 2010 10:43:59 +0200

alpha: Fix HW performance counters to be stopped properly

Also fix a few compile errors due to undefined and duplicated
variables.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1284269844-23251-1-git-send-email-mcree@orcon.net.nz>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/alpha/kernel/perf_event.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/alpha/kernel/perf_event.c b/arch/alpha/kernel/perf_event.c
index a25fe9e..1cc4968 100644
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
 
 
@@ -849,7 +850,7 @@ static void alpha_perf_event_irq_handler(unsigned long la_ptr,
 			/* Interrupts coming too quickly; "throttle" the
 			 * counter, i.e., disable it for a little while.
 			 */
-			cpuc->idx_mask &= ~(1UL<<idx);
+			alpha_pmu_stop(event, 0);
 		}
 	}
 	wrperfmon(PERFMON_CMD_ENABLE, cpuc->idx_mask);
