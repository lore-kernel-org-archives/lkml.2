Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934226Ab1IOQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 12:56:24 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:16646
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756433Ab1IOQ4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 12:56:22 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zzc85fh1432N98dKzz1202hzz8275bhz32i668h839h34h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LRKPPR-01-50U-02
X-M-MSG: 
Date: Thu, 15 Sep 2011 18:55:43 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V4][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110915165543.GO6063@erda.amd.com>
References: <1315947509-6429-1-git-send-email-dzickus@redhat.com>
 <1315947509-6429-5-git-send-email-dzickus@redhat.com>
 <20110914162653.GI6063@erda.amd.com>
 <20110914175809.GY5795@redhat.com>
 <20110914201612.GK6063@erda.amd.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <20110914201612.GK6063@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On 14.09.11 22:16:12, Robert Richter wrote:
> On 14.09.11 13:58:09, Don Zickus wrote:
> > On Wed, Sep 14, 2011 at 06:26:53PM +0200, Robert Richter wrote:
> > > On 13.09.11 16:58:27, Don Zickus wrote:
> > > > @@ -87,6 +87,16 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
> > > >  
> > > >  		handled += a->handler(type, regs);
> > > >  
> > > > +		/*
> > > > + 		 * Optimization: only loop once if this is not a 
> > > > + 		 * back-to-back NMI.  The idea is nothing is dropped
> > > > + 		 * on the first NMI, only on the second of a back-to-back
> > > > + 		 * NMI.  No need to waste cycles going through all the
> > > > + 		 * handlers.
> > > > + 		 */
> > > > +		if (!b2b && handled)
> > > > +			break;
> > > 
> > > Don, if I am not missing something, this actually does not work
> > > because perfctr NMIs do not re-trigger. Suppose a handler running
> > > before perfctr. It sets 'handled' and the chain is stopped here. To
> > > run through the perfctr handler the NMI must retrigger which it
> > > doesn't.
> > 
> > Your patch is incorrect.  Your dummy handler does not handle a _real_ NMI.
> > Which means no _real_ NMI was ever generated.  Of course perf won't work.
> > You just swallowed its NMI.
> > 
> > The change I made is for nmi handlers that actually have an NMI associated
> > with them.  The idea is if somebody generated an NMI, it will get handled
> > by a handler.  If perf comes along and generates another NMI, it should
> > get latched.  Upon handling the first NMI, the perf NMI should be sitting
> > queued up and cause the back-to-back NMI. In this case all the handlers
> > will be executed (to handle dropped NMIs).
> 
> Yes, your thought about the latched NMI could work. Though I better
> test this with some real nmis from different sources.  Unfortunately
> this is much harder to trigger. Will give it a try. It would be a
> pretty nice optimization then.

Don,

I did some tests today with parallel IBS and perfctr sessions running.
I see cases for all combinations of NMI back-to-back sequences (see
below for the traces, the patch and attached log file):

[1] IBS - IBS 
[2] IBS - perfctr
[3] perfctr - IBS
[4] perfctr - perfctr

So we see that all cases exists. Unfortunately this is not an evidence
that the approach works in *any* case, because we don't see
potentially lost entries. This is hard to prove. But I think the can
assume it works as expected. I also asked the hw guys for
clarification. Will let you know if we must modify the algorithm.

-Robert



Some back-to-back traces:

           <...>-2358  [002]    35.807818: perf_ibs_nmi_handler: b2b: seq 335: handled: 1 (#336), last handled: 1 (#335)
           <...>-2358  [002]    35.808396: perf_ibs_nmi_handler: b2b: seq 340: handled: 1 (#341), last handled: 1 (#340) [1]
           <...>-2358  [002]    35.814160: perf_ibs_nmi_handler: b2b: seq 391: handled: 1 (#392), last handled: 1 (#391)
           <...>-2358  [002]    35.818585: perf_ibs_nmi_handler: b2b: seq 430: handled: 1 (#431), last handled: 1 (#430)

           <...>-2349  [007]    36.026940: perf_ibs_nmi_handler: b2b: seq 2338: handled: 1 (#2339), last handled: 1 (#2338)
           <...>-2349  [007]    36.027063: perf_ibs_nmi_handler: b2b: seq 2364: handled: 1 (#2365), last handled: 0 (#2364)
           <...>-2349  [007]    36.027064: perf_event_nmi_handler: b2b: seq 168: handled: 0 (#2365), last handled: 1 (#2364)
           <...>-2349  [007]    36.027066: perf_ibs_nmi_handler: b2b: seq 2365: handled: 0 (#2366), last handled: 1 (#2365)  [2]
           <...>-2349  [007]    36.027068: perf_event_nmi_handler: b2b: seq 169: handled: 1 (#2366), last handled: 0 (#2365) [2]
           <...>-2349  [007]    36.027183: perf_ibs_nmi_handler: b2b: seq 2389: handled: 0 (#2390), last handled: 0 (#2389)
           <...>-2349  [007]    36.027185: perf_event_nmi_handler: b2b: seq 193: handled: 1 (#2390), last handled: 1 (#2389)
           <...>-2349  [007]    36.027189: perf_ibs_nmi_handler: b2b: seq 2391: handled: 1 (#2392), last handled: 0 (#2391)  [3]
           <...>-2349  [007]    36.027191: perf_event_nmi_handler: b2b: seq 195: handled: 0 (#2392), last handled: 1 (#2391) [3]
           <...>-2349  [007]    36.027193: perf_ibs_nmi_handler: b2b: seq 2392: handled: 0 (#2393), last handled: 1 (#2392)
           <...>-2349  [007]    36.027195: perf_event_nmi_handler: b2b: seq 196: handled: 1 (#2393), last handled: 0 (#2392)
           <...>-2349  [007]    36.027206: perf_ibs_nmi_handler: b2b: seq 2395: handled: 0 (#2396), last handled: 0 (#2395)
           <...>-2349  [007]    36.027208: perf_event_nmi_handler: b2b: seq 199: handled: 1 (#2396), last handled: 1 (#2395)
           <...>-2349  [007]    36.027212: perf_ibs_nmi_handler: b2b: seq 2396: handled: 0 (#2397), last handled: 0 (#2396)
           <...>-2349  [007]    36.027215: perf_event_nmi_handler: b2b: seq 200: handled: 1 (#2397), last handled: 1 (#2396)
           <...>-2349  [007]    36.027218: perf_ibs_nmi_handler: b2b: seq 2397: handled: 0 (#2398), last handled: 0 (#2397)
           <...>-2349  [007]    36.027221: perf_event_nmi_handler: b2b: seq 201: handled: 1 (#2398), last handled: 1 (#2397)
           <...>-2349  [007]    36.027224: perf_ibs_nmi_handler: b2b: seq 2398: handled: 0 (#2399), last handled: 0 (#2398)
           <...>-2349  [007]    36.027227: perf_event_nmi_handler: b2b: seq 202: handled: 1 (#2399), last handled: 1 (#2398)
           <...>-2349  [007]    36.027302: perf_ibs_nmi_handler: b2b: seq 2414: handled: 0 (#2415), last handled: 0 (#2414)


           <...>-2358  [002]    36.026053: perf_ibs_nmi_handler: b2b: seq 2306: handled: 0 (#2307), last handled: 0 (#2306)
           <...>-2358  [002]    36.026056: perf_event_nmi_handler: b2b: seq 115: handled: 1 (#2307), last handled: 1 (#2306)
           <...>-2358  [002]    36.026081: perf_ibs_nmi_handler: b2b: seq 2313: handled: 0 (#2314), last handled: 0 (#2313)  [4]
           <...>-2358  [002]    36.026083: perf_event_nmi_handler: b2b: seq 121: handled: 1 (#2314), last handled: 1 (#2313) [4]
           <...>-2358  [002]    36.026115: perf_ibs_nmi_handler: b2b: seq 2320: handled: 0 (#2321), last handled: 0 (#2320)
           <...>-2358  [002]    36.026117: perf_event_nmi_handler: b2b: seq 128: handled: 1 (#2321), last handled: 1 (#2320)


> 
> > My only question to you is the IBS stuff you were working on.  Does that
> > generate a _real_ NMI or does it just piggy back off of the perf NMI?
> 
> Yes, IBS generates real NMIs, there is an own interrupt vector for
> it.
> 
> -Robert
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center

>From 215f2880d166489892865c3e9e2b46ee157a7e2d Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Thu, 15 Sep 2011 11:57:28 +0200
Subject: [PATCH] perf-nmi-test

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c         |   40 +++++++++++++++++++++++++++---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   36 ++++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 64eeac3..5830a81 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1376,15 +1376,47 @@ struct pmu_nmi_state {
 
 static DEFINE_PER_CPU(struct pmu_nmi_state, pmu_nmi);
 
+#define irq_stats(x)              (&per_cpu(irq_stat, x))
+
+struct last_nmi {
+	unsigned long	rip;
+	unsigned int 	nmi_count;
+	int		handled;
+	unsigned int	seq;
+};
+
+static DEFINE_PER_CPU(struct last_nmi, last);
+
+static void check_nmi(struct pt_regs *regs, int handled)
+{
+	int cpu = smp_processor_id();
+	unsigned int nmi_count = irq_stats(cpu)->__nmi_count;
+
+	__this_cpu_inc(last.seq);
+	if (regs->ip == __this_cpu_read(last.rip)) {
+		trace_printk("b2b: seq %d: handled: %d (#%d), last handled: %d (#%d)\n",
+			     __this_cpu_read(last.seq),
+			     handled,
+			     nmi_count,
+			     __this_cpu_read(last.handled),
+			     __this_cpu_read(last.nmi_count));
+	} else {
+		__this_cpu_write(last.rip, regs->ip);
+	}
+
+	__this_cpu_write(last.handled, handled);
+	__this_cpu_write(last.nmi_count, nmi_count);
+}
+
 static int __kprobes
 perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
-	int handled;
+	int handled = NMI_DONE;
 
-	if (!atomic_read(&active_events))
-		return NMI_DONE;
+	if (atomic_read(&active_events))
+		handled = x86_pmu.handle_irq(regs);
 
-	handled = x86_pmu.handle_irq(regs);
+	check_nmi(regs, handled);
 
 	return handled;
 }
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 11da65b..ac10a94 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -422,6 +422,38 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	return 1;
 }
 
+#define irq_stats(x)              (&per_cpu(irq_stat, x))
+
+struct last_nmi {
+	unsigned long	rip;
+	unsigned int 	nmi_count;
+	int		handled;
+	unsigned int	seq;
+};
+
+static DEFINE_PER_CPU(struct last_nmi, last);
+
+static void check_nmi(struct pt_regs *regs, int handled)
+{
+	int cpu = smp_processor_id();
+	unsigned int nmi_count = irq_stats(cpu)->__nmi_count;
+
+	__this_cpu_inc(last.seq);
+	if (regs->ip == __this_cpu_read(last.rip)) {
+		trace_printk("b2b: seq %d: handled: %d (#%d), last handled: %d (#%d)\n",
+			     __this_cpu_read(last.seq),
+			     handled,
+			     nmi_count,
+			     __this_cpu_read(last.handled),
+			     __this_cpu_read(last.nmi_count));
+	} else {
+		__this_cpu_write(last.rip, regs->ip);
+	}
+
+	__this_cpu_write(last.handled, handled);
+	__this_cpu_write(last.nmi_count, nmi_count);
+}
+
 static int __kprobes
 perf_ibs_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
@@ -433,6 +465,8 @@ perf_ibs_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 	if (handled)
 		inc_irq_stat(apic_perf_irqs);
 
+	check_nmi(regs, handled);
+
 	return handled;
 }
 
@@ -463,7 +497,7 @@ static __init int perf_event_ibs_init(void)
 
 	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
 	perf_ibs_pmu_init(&perf_ibs_op, "ibs_op");
-	register_nmi_handler(NMI_LOCAL, &perf_ibs_nmi_handler, 0, "perf_ibs");
+	register_nmi_handler(NMI_LOCAL, &perf_ibs_nmi_handler, NMI_FLAG_FIRST, "perf_ibs");
 	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", ibs_caps);
 
 	return 0;
-- 
1.7.6.1



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

--k+w/mQv8wyuph6w0
Content-Type: application/x-bzip2; name="perf-nmi-test.log.bz2"
Content-Disposition: attachment; filename="perf-nmi-test.log.bz2"
Content-Transfer-Encoding: base64
Content-Description: perf-nmi-test.log.bz2

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
bz8+//xdyRThQkK8B3Yo

--k+w/mQv8wyuph6w0--
