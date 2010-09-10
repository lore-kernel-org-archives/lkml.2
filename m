Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0IJNxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 09:53:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:56274 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0IJNxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 09:53:06 -0400
Subject: Re: [PATCH 0/3 v2] nmi perf fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, robert.richter@amd.com, gorcunov@gmail.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
        ming.m.lin@intel.com, yinghai@kernel.org, andi@firstfloor.org,
        eranian@google.com
In-Reply-To: <1284125693.402.58.camel@laptop>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
	 <1284118900.402.35.camel@laptop>  <1284125693.402.58.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Sep 2010 15:52:50 +0200
Message-ID: <1284126770.402.60.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 15:34 +0200, Peter Zijlstra wrote:
> > I'll look at getting a trace of the thing, but if any of you has a
> > bright idea...
> 
           <...>-3164  [000]    51.658621: perf_event_nmi_handler: NMI: 14146 6078 1
           <...>-3164  [000]    51.658622: x86_pmu_handle_irq: OVERFLOW: 1
           <...>-3164  [000]    51.658622: x86_pmu_handle_irq: HANDLED: 1
           <...>-3164  [000]    51.658624: perf_event_nmi_handler: NMI-handled(1): 14146 6078 1
           <...>-3164  [000]    51.658625: perf_event_nmi_handler: NMI-stop: 14146 6078 1
           <...>-3164  [000]    51.658627: perf_event_nmi_handler: NMI: 14147 6078 1
           <...>-3164  [000]    51.658627: x86_pmu_handle_irq: OVERFLOW: 1
           <...>-3164  [000]    51.658628: x86_pmu_handle_irq: HANDLED: 1
           <...>-3164  [000]    51.658631: perf_event_nmi_handler: NMI-handled(1): 14147 6078 1
           <...>-3164  [000]    51.658631: perf_event_nmi_handler: NMI-stop: 14147 6078 1
           <...>-3164  [000]    51.658633: perf_event_nmi_handler: NMI: 14148 6078 1
           <...>-3164  [000]    51.658634: perf_event_nmi_handler: NMI-handled(0): 14148 6078 1
           <...>-3164  [000]    51.658635: perf_event_nmi_handler: NMI: 14148 6078 1
           <...>-3164  [000]    51.658636: perf_event_nmi_handler: NMI-handled(0): 14148 6078 1
           <...>-3164  [000]    51.658637: perf_event_nmi_handler: NMI: 14148 6078 1
           <...>-3164  [000]    51.658637: perf_event_nmi_handler: NMI-fail

That seems to be clear enough.. no idea where that extra NMI comes from.
Robert any clue?

---
 arch/x86/kernel/cpu/perf_event.c |   39 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index de6569c..5e9921c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1127,6 +1127,20 @@ static void x86_pmu_disable(struct perf_event *event)
 	perf_event_update_userpage(event);
 }
 
+static int pmc_overflow(int idx)
+{
+	u64 val;
+
+	rdmsrl(x86_pmu.eventsel + idx, val);
+	if ((val & (ARCH_PERFMON_EVENTSEL_ENABLE | ARCH_PERFMON_EVENTSEL_INT)) ==
+		  (ARCH_PERFMON_EVENTSEL_ENABLE | ARCH_PERFMON_EVENTSEL_INT)) {
+		rdmsrl(x86_pmu.perfctr + idx, val);
+		return !(val & (1ULL << (x86_pmu.cntval_bits - 1)));
+	}
+
+	return 0;
+}
+
 static int x86_pmu_handle_irq(struct pt_regs *regs)
 {
 	struct perf_sample_data data;
@@ -1141,6 +1155,8 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		if (pmc_overflow(idx))
+			trace_printk("OVERFLOW: %d\n", idx);
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
 
@@ -1154,6 +1170,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 		/*
 		 * event overflow
 		 */
+		trace_printk("HANDLED: %d\n", idx);
 		handled++;
 		data.period	= event->hw.last_period;
 
@@ -1215,6 +1232,11 @@ perf_event_nmi_handler(struct notifier_block *self,
 	unsigned int this_nmi;
 	int handled;
 
+	trace_printk("NMI: %d %d %d\n",
+			percpu_read(irq_stat.__nmi_count),
+			__get_cpu_var(pmu_nmi).marked,
+			__get_cpu_var(pmu_nmi).handled);
+
 	if (!atomic_read(&active_events))
 		return NOTIFY_DONE;
 
@@ -1224,9 +1246,12 @@ perf_event_nmi_handler(struct notifier_block *self,
 		break;
 	case DIE_NMIUNKNOWN:
 		this_nmi = percpu_read(irq_stat.__nmi_count);
-		if (this_nmi != __get_cpu_var(pmu_nmi).marked)
+		if (this_nmi != __get_cpu_var(pmu_nmi).marked) {
+			trace_printk("NMI-fail\n");
 			/* let the kernel handle the unknown nmi */
 			return NOTIFY_DONE;
+		}
+		trace_printk("NMI-consume\n");
 		/*
 		 * This one is a PMU back-to-back nmi. Two events
 		 * trigger 'simultaneously' raising two back-to-back
@@ -1242,6 +1267,13 @@ perf_event_nmi_handler(struct notifier_block *self,
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 
 	handled = x86_pmu.handle_irq(args->regs);
+
+	trace_printk("NMI-handled(%d): %d %d %d\n",
+			handled,
+			percpu_read(irq_stat.__nmi_count),
+			__get_cpu_var(pmu_nmi).marked,
+			__get_cpu_var(pmu_nmi).handled);
+
 	if (!handled)
 		return NOTIFY_DONE;
 
@@ -1264,6 +1296,11 @@ perf_event_nmi_handler(struct notifier_block *self,
 		__get_cpu_var(pmu_nmi).handled	= handled;
 	}
 
+	trace_printk("NMI-stop: %d %d %d\n",
+			percpu_read(irq_stat.__nmi_count),
+			__get_cpu_var(pmu_nmi).marked,
+			__get_cpu_var(pmu_nmi).handled);
+
 	return NOTIFY_STOP;
 }
 

