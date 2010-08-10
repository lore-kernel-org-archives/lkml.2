Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0HJHK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 03:10:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:55307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab0HJHKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 03:10:23 -0400
Date: Tue, 10 Aug 2010 07:09:48 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, gorcunov@openvz.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20100805150917.GA6311@lenovo>
References: <20100805150917.GA6311@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: P4 PMU -- update nmi irq statistics and unmask lvt entry properly
Message-ID: <tip-1c250d709fdc8aa5bf42d90be99428a01a256a55@git.kernel.org>
Git-Commit-ID: 1c250d709fdc8aa5bf42d90be99428a01a256a55
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 10 Aug 2010 07:09:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c250d709fdc8aa5bf42d90be99428a01a256a55
Gitweb:     http://git.kernel.org/tip/1c250d709fdc8aa5bf42d90be99428a01a256a55
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Thu, 5 Aug 2010 19:09:17 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Aug 2010 22:53:50 +0200

perf, x86: P4 PMU -- update nmi irq statistics and unmask lvt entry properly

In case if last active performance counter is not overflowed at
moment of NMI being triggered by another counter, the irq
statistics may miss an update stage. As a more serious
consequence -- apic quirk may not be triggered so apic lvt entry
stay masked.

Tested-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100805150917.GA6311@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 107711b..febb12c 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -656,6 +656,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		int overflow;
 
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
@@ -666,12 +667,14 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 		WARN_ON_ONCE(hwc->idx != idx);
 
 		/* it might be unflagged overflow */
-		handled = p4_pmu_clear_cccr_ovf(hwc);
+		overflow = p4_pmu_clear_cccr_ovf(hwc);
 
 		val = x86_perf_event_update(event);
-		if (!handled && (val & (1ULL << (x86_pmu.cntval_bits - 1))))
+		if (!overflow && (val & (1ULL << (x86_pmu.cntval_bits - 1))))
 			continue;
 
+		handled += overflow;
+
 		/* event overflow for sure */
 		data.period = event->hw.last_period;
 
@@ -687,7 +690,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 		inc_irq_stat(apic_perf_irqs);
 	}
 
-	return handled;
+	return handled > 0;
 }
 
 /*
