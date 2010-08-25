Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0HYKLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 06:11:23 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:15190 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0HYKLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 06:11:20 -0400
X-SpamScore: 1
X-BigFish: VPS1(z3cfcs329eqzbb2cK1b0bM1432N98dNzz1202hzz8275bhz32i)
X-WSS-ID: 0L7PCKJ-02-4TI-02
X-M-MSG: 
Date: Wed, 25 Aug 2010 11:48:19 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100825094819.GB3198@erda.amd.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100820152510.GA4167@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.08.10 11:25:10, Ingo Molnar wrote:

> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > >
> > >it's not working so well, i'm getting:
> > >
> > > Uhhuh. NMI received for unknown reason 00 on CPU 9.
> > > Do you have a strange power saving mode enabled?
> > > Dazed and confused, but trying to continue
> > >
> > >on a nehalem box, after a perf top and perf stat run.
> 
> FYI, it does not trigger on an AMD box.

Ingo,

do you mean it does not trigger false positives on AMD? Both patches
applied on top of current tip/perf/urgent (c6db67c) are working on the
systems I have.

You might use the debug patch below for diagnostics.

-Robert

--

>From 1bbb5aa64e96360529c34a593a072e1a84114f04 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Wed, 11 Aug 2010 18:14:00 +0200
Subject: [PATCH] debug

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   54 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index dd2fceb..059ef09 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1203,10 +1203,43 @@ void perf_events_lapic_init(void)
 struct pmu_nmi_state {
 	unsigned int	marked;
 	int		handled;
+	u64		timestamp;
 };
 
 static DEFINE_PER_CPU(struct pmu_nmi_state, nmi);
 
+struct nmi_debug {
+	int		cpu;
+	unsigned int	this_nmi;
+	unsigned int	marked;
+	int		handled;
+	u64		timestamp;
+	u64		delta;
+};
+
+static DEFINE_PER_CPU(struct nmi_debug[16], nmi_debug);
+
+static void nmi_handler_debug(void)
+{
+	struct nmi_debug *debug;
+	int i;
+
+	if (!printk_ratelimit())
+		return;
+
+	for (i = 0; i < 16; i++) {
+		debug = &__get_cpu_var(nmi_debug)[i];
+		printk(KERN_EMERG
+		       "cpu #%d, nmi #%d, marked #%d, handled = %d, time = %llu, delta = %llu\n",
+		       debug->cpu,
+		       debug->this_nmi,
+		       debug->marked,
+		       debug->handled,
+		       debug->timestamp,
+		       debug->delta);
+	}
+}
+
 static int __kprobes
 perf_event_nmi_handler(struct notifier_block *self,
 			 unsigned long cmd, void *__args)
@@ -1214,6 +1247,8 @@ perf_event_nmi_handler(struct notifier_block *self,
 	struct die_args *args = __args;
 	unsigned int this_nmi;
 	int handled;
+	struct nmi_debug *debug;
+	u64 timestamp;
 
 	if (!atomic_read(&active_events))
 		return NOTIFY_DONE;
@@ -1224,9 +1259,11 @@ perf_event_nmi_handler(struct notifier_block *self,
 		break;
 	case DIE_NMIUNKNOWN:
 		this_nmi = percpu_read(irq_stat.__nmi_count);
-		if (this_nmi != __get_cpu_var(nmi).marked)
+		if (this_nmi != __get_cpu_var(nmi).marked) {
+			nmi_handler_debug();
 			/* let the kernel handle the unknown nmi */
 			return NOTIFY_DONE;
+		}
 		/*
 		 * This one is a PMU back-to-back nmi. Two events
 		 * trigger 'simultaneously' raising two back-to-back
@@ -1242,10 +1279,21 @@ perf_event_nmi_handler(struct notifier_block *self,
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 
 	handled = x86_pmu.handle_irq(args->regs);
+	this_nmi = percpu_read(irq_stat.__nmi_count);
+
+	debug		= &__get_cpu_var(nmi_debug)[0xf & this_nmi];
+	debug->cpu	= smp_processor_id();
+	debug->this_nmi	= this_nmi;
+	debug->marked	= __get_cpu_var(nmi).marked;
+	debug->handled	= handled;
+	rdtscll(timestamp);
+	debug->delta    = timestamp - __get_cpu_var(nmi).timestamp;
+	__get_cpu_var(nmi).timestamp = timestamp;
+	debug->timestamp = timestamp;
+
 	if (!handled)
 		return NOTIFY_DONE;
 
-	this_nmi = percpu_read(irq_stat.__nmi_count);
 	if ((handled > 1) ||
 		/* the next nmi could be a back-to-back nmi */
 	    ((__get_cpu_var(nmi).marked == this_nmi) &&
@@ -1262,6 +1310,8 @@ perf_event_nmi_handler(struct notifier_block *self,
 		 */
 		__get_cpu_var(nmi).marked	= this_nmi + 1;
 		__get_cpu_var(nmi).handled	= handled;
+		debug->marked	= __get_cpu_var(nmi).marked;
+		debug->handled	= handled;
 	}
 
 	return NOTIFY_STOP;
-- 
1.7.1.1


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

