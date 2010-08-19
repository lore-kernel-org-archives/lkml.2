Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0HSO13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:27:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0HSO11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:27:27 -0400
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100819141240.GO4879@redhat.com>
References: <20100804161046.GC5130@lenovo>
	 <20100804162026.GU3353@redhat.com> <20100804163930.GE5130@lenovo>
	 <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo>
	 <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com>
	 <20100809194829.GB26154@erda.amd.com> <20100817152225.GQ26154@erda.amd.com>
	 <1282214753.1926.4669.camel@laptop>  <20100819141240.GO4879@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 Aug 2010 16:27:13 +0200
Message-ID: <1282228033.2605.204.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 10:12 -0400, Don Zickus wrote:
> On Thu, Aug 19, 2010 at 12:45:53PM +0200, Peter Zijlstra wrote:
> > 
> > I queued it with that part changed to:
> 
> I realized the other day this change doesn't cover the nehalem, core and p4
> cases which use
> 
> intel_pmu_handle_irq
> p4_pmu_handle_irq
> 
> as their handlers.  Though that patch can go on top of Robert's.

Something like this?

---
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -713,6 +713,7 @@ static int intel_pmu_handle_irq(struct p
 	struct cpu_hw_events *cpuc;
 	int bit, loops;
 	u64 ack, status;
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
 
@@ -772,7 +777,7 @@ again:
 
 done:
 	intel_pmu_enable_all(0);
-	return 1;
+	return handled;
 }
 
 static struct event_constraint *
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
@@ -673,7 +673,7 @@ static int p4_pmu_handle_irq(struct pt_r
 		if (!overflow && (val & (1ULL << (x86_pmu.cntval_bits - 1))))
 			continue;
 
-		handled += overflow;
+		handled += !!overflow;
 
 		/* event overflow for sure */
 		data.period = event->hw.last_period;
@@ -690,7 +690,7 @@ static int p4_pmu_handle_irq(struct pt_r
 		inc_irq_stat(apic_perf_irqs);
 	}
 
-	return handled > 0;
+	return handled;
 }
 
 /*

