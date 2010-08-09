Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab0HITvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:51:53 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:17528 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab0HITvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:51:49 -0400
X-SpamScore: -6
X-BigFish: VPS-6(z3cfcs329eqz14e0M1db9M1432N98dN936eMzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L6WHOV-02-IDR-02
X-M-MSG: 
Date: Mon, 9 Aug 2010 21:48:29 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] perf, x86: try to handle unknown nmis with running perfctrs
Message-ID: <20100809194829.GB26154@erda.amd.com>
References: <1280934161.1923.1294.camel@laptop>
 <20100804151858.GB5130@lenovo>
 <20100804155002.GS3353@redhat.com>
 <20100804161046.GC5130@lenovo>
 <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100806142131.GA1874@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.08.10 10:21:31, Don Zickus wrote:
> On Fri, Aug 06, 2010 at 08:52:03AM +0200, Robert Richter wrote:

> > I was playing around with it yesterday trying to fix this. My idea is
> > to skip an unkown nmi if the privious nmi was a *handled* perfctr
> 
> You might want to add a little more logic that says *handled* _and_ had
> more than one perfctr trigger.  Most of the time only one perfctr is
> probably triggering, so you might be eating unknown_nmi's needlessly.
> 
> Just a thought.

Yes, that's true. It could be implemented on top of the patch below.

> 
> > nmi. I will probably post an rfc patch early next week.

Here it comes:

>From d2739578199d881ae6a9537c1b96a0efd1cdea43 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Thu, 5 Aug 2010 16:19:59 +0200
Subject: [PATCH] perf, x86: try to handle unknown nmis with running perfctrs

When perfctrs are running it is valid to have unhandled nmis, two
events could trigger 'simultaneously' raising two back-to-back
NMIs. If the first NMI handles both, the latter will be empty and daze
the CPU.

The solution to avoid an 'unknown nmi' massage in this case was simply
to stop the nmi handler chain when perfctrs are runnning by stating
the nmi was handled. This has the drawback that a) we can not detect
unknown nmis anymore, and b) subsequent nmi handlers are not called.

This patch addresses this. Now, we drop this unknown NMI only if the
previous NMI was handling a perfctr. Otherwise we pass it and let the
kernel handle the unknown nmi. The check runs only if no nmi handler
could handle the nmi (DIE_NMIUNKNOWN case).

We could improve this further by checking if perf was handling more
than one counter. Otherwise we may pass the unknown nmi too.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   39 +++++++++++++++++++++++++++++--------
 1 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f2da20f..c3cd159 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1200,12 +1200,16 @@ void perf_events_lapic_init(void)
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
 
+static DEFINE_PER_CPU(unsigned int, perfctr_handled);
+
 static int __kprobes
 perf_event_nmi_handler(struct notifier_block *self,
 			 unsigned long cmd, void *__args)
 {
 	struct die_args *args = __args;
 	struct pt_regs *regs;
+	unsigned int this_nmi;
+	unsigned int prev_nmi;
 
 	if (!atomic_read(&active_events))
 		return NOTIFY_DONE;
@@ -1214,7 +1218,26 @@ perf_event_nmi_handler(struct notifier_block *self,
 	case DIE_NMI:
 	case DIE_NMI_IPI:
 		break;
-
+	case DIE_NMIUNKNOWN:
+		/*
+		 * This one could be our NMI, two events could trigger
+		 * 'simultaneously' raising two back-to-back NMIs. If
+		 * the first NMI handles both, the latter will be
+		 * empty and daze the CPU.
+		 *
+		 * So, we drop this unknown NMI if the previous NMI
+		 * was handling a perfctr. Otherwise we pass it and
+		 * let the kernel handle the unknown nmi.
+		 *
+		 * Note: this could be improved if we drop unknown
+		 * NMIs only if we handled more than one perfctr in
+		 * the previous NMI.
+		 */
+		this_nmi = percpu_read(irq_stat.__nmi_count);
+		prev_nmi = __get_cpu_var(perfctr_handled);
+		if (this_nmi == prev_nmi + 1)
+			return NOTIFY_STOP;
+		return NOTIFY_DONE;
 	default:
 		return NOTIFY_DONE;
 	}
@@ -1222,14 +1245,12 @@ perf_event_nmi_handler(struct notifier_block *self,
 	regs = args->regs;
 
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	/*
-	 * Can't rely on the handled return value to say it was our NMI, two
-	 * events could trigger 'simultaneously' raising two back-to-back NMIs.
-	 *
-	 * If the first NMI handles both, the latter will be empty and daze
-	 * the CPU.
-	 */
-	x86_pmu.handle_irq(regs);
+
+	if (!x86_pmu.handle_irq(regs))
+		return NOTIFY_DONE;
+
+	/* handled */
+	__get_cpu_var(perfctr_handled) = percpu_read(irq_stat.__nmi_count);
 
 	return NOTIFY_STOP;
 }
-- 
1.7.1.1

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

