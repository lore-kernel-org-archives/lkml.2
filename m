Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527Ab0HEPJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:09:26 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47250 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab0HEPJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=MlMPr7X0/r2XYFZC2C9OF6Coz9XVnHU82dppBMlD1REVGlWj7Xma08vm46+6Ud48ug
         ooIYAj36wJmz/7Kxj+3r2bmT0kqQ92zS0hIN9TnNz29H/msJalARmAco7CtmmwU8qBZ5
         bMqb19lh3Z03ZGf8+ZAUX4mt4bgAelDhY1Z/M=
Date: Thu, 5 Aug 2010 19:09:17 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf,x86: P4 PMU -- update nmi irq statistics and unmask
	lvt entry properly
Message-ID: <20100805150917.GA6311@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case if last active performance counter is not overflowed at
moment of NMI being triggered by another counter, the irq statistics
may miss an update stage. As a more serious consequence -- apic quirk
may not be triggered so apic lvt entry stay masked.

Tested-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -656,6 +656,7 @@ static int p4_pmu_handle_irq(struct pt_r
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		int overflow;
 
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
@@ -666,12 +667,14 @@ static int p4_pmu_handle_irq(struct pt_r
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
 
@@ -687,7 +690,7 @@ static int p4_pmu_handle_irq(struct pt_r
 		inc_irq_stat(apic_perf_irqs);
 	}
 
-	return handled;
+	return handled > 0;
 }
 
 /*
