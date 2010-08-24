Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934042Ab0HXXVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:21:43 -0400
Received: from kroah.org ([198.145.64.141]:40903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933336Ab0HXXBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:01:40 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:03 2010
Message-Id: <20100824224503.366764920@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [024/114] perf, x86: P4 PMU -- update nmi irq statistics and unmask lvt entry properly
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Cyrill Gorcunov <gorcunov@openvz.org>

commit 1c250d709fdc8aa5bf42d90be99428a01a256a55 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/perf_event_p4.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -581,6 +581,7 @@ static int p4_pmu_handle_irq(struct pt_r
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		int overflow;
 
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
@@ -591,12 +592,14 @@ static int p4_pmu_handle_irq(struct pt_r
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
 
@@ -612,7 +615,7 @@ static int p4_pmu_handle_irq(struct pt_r
 		inc_irq_stat(apic_perf_irqs);
 	}
 
-	return handled;
+	return handled > 0;
 }
 
 /*


