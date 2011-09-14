Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab1INQ11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:27:27 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:49475
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359Ab1INQ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:27:26 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzz8275bhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LRITOV-02-TCF-02
X-M-MSG: 
Date: Wed, 14 Sep 2011 18:26:53 +0200
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
Message-ID: <20110914162653.GI6063@erda.amd.com>
References: <1315947509-6429-1-git-send-email-dzickus@redhat.com>
 <1315947509-6429-5-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1315947509-6429-5-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.09.11 16:58:27, Don Zickus wrote:
> @@ -87,6 +87,16 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
>  
>  		handled += a->handler(type, regs);
>  
> +		/*
> + 		 * Optimization: only loop once if this is not a 
> + 		 * back-to-back NMI.  The idea is nothing is dropped
> + 		 * on the first NMI, only on the second of a back-to-back
> + 		 * NMI.  No need to waste cycles going through all the
> + 		 * handlers.
> + 		 */
> +		if (!b2b && handled)
> +			break;

Don, if I am not missing something, this actually does not work
because perfctr NMIs do not re-trigger. Suppose a handler running
before perfctr. It sets 'handled' and the chain is stopped here. To
run through the perfctr handler the NMI must retrigger which it
doesn't.

I tested the above with enclosed patch.

The patch handles the nmi and then stops the chain. You see by the PMI
count that the perfctr nmi is not handled:

Patch applied:

 # echo $(($(grep PMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
 0
 # echo $(($(grep NMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
 0
 # perf record -e cpu-cycles bash -c 'perl -e "while(1) {}" & sleep 5 ; kill $!'
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.011 MB perf.data (~472 samples) ]
 # echo $(($(grep PMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
 128
 # echo $(($(grep NMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
 1387

W/o the patch (tip/perf/core: 51887c8):

 # echo $(($(grep NMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
 0
 # echo $(($(grep PMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
 0
 # perf record -e cpu-cycles bash -c 'perl -e "while(1) {}" & sleep 5 ; kill $!'
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.194 MB perf.data (~8455 samples) ]
 # echo $(($(grep PMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
 4918
 # echo $(($(grep NMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
 4918

So we may not jump out the while loop.

-Robert

> +
>  		a = next_a;
>  	}
>  	rcu_read_unlock();



>From b1d68bf037cfa78f073cf71c296057ff422294f2 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Wed, 14 Sep 2011 11:44:49 +0200
Subject: [PATCH] perf_nmi_test

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   45 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 594d425..2255221 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -31,6 +31,7 @@
 #include <asm/compat.h>
 #include <asm/smp.h>
 #include <asm/alternative.h>
+#include <asm/hardirq.h>
 
 #if 0
 #undef wrmsrl
@@ -43,6 +44,8 @@ do {								\
 } while (0)
 #endif
 
+#define irq_stats(x)              (&per_cpu(irq_stat, x))
+
 /*
  *          |   NHM/WSM    |      SNB     |
  * register -------------------------------
@@ -1383,6 +1386,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 	struct die_args *args = __args;
 	unsigned int this_nmi;
 	int handled;
+	int cpu;
 
 	if (!atomic_read(&active_events))
 		return NOTIFY_DONE;
@@ -1408,6 +1412,9 @@ perf_event_nmi_handler(struct notifier_block *self,
 	}
 
 	handled = x86_pmu.handle_irq(args->regs);
+	cpu = smp_processor_id();
+	trace_printk("perf: NMI: %d, PMI: %d, handled: %d\n", irq_stats(cpu)->__nmi_count,
+		     irq_stats(cpu)->apic_perf_irqs, handled);
 	if (!handled)
 		return NOTIFY_DONE;
 
@@ -1961,3 +1968,41 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 
 	return misc;
 }
+
+static DEFINE_PER_CPU(unsigned long, save_rip);
+
+static int __kprobes perf_test_nmi_handler(struct notifier_block *self,
+					   unsigned long cmd, void *__args)
+{
+	struct die_args *args = __args;
+	bool b2b = false;
+	int cpu = smp_processor_id();
+
+	if (cmd != DIE_NMI)
+		return NOTIFY_DONE;
+
+	if (args->regs->ip == __this_cpu_read(save_rip))
+		b2b = true;
+
+	__this_cpu_write(save_rip, args->regs->ip);
+
+	trace_printk("skip: NMI: %d, PMI: %d, b2b: %d\n", irq_stats(cpu)->__nmi_count,
+		     irq_stats(cpu)->apic_perf_irqs, b2b);
+
+	if (!b2b)
+		return NOTIFY_STOP;
+
+	return NOTIFY_DONE;
+}
+
+static __read_mostly struct notifier_block perf_test_nmi_notifier = {
+	.notifier_call		= perf_test_nmi_handler,
+	.priority		= NMI_LOCAL_HIGH_PRIOR,
+};
+
+static __init int perf_nmi_test_init(void)
+{
+	return register_die_notifier(&perf_test_nmi_notifier);
+}
+
+device_initcall(perf_nmi_test_init);
-- 
1.7.6.1



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

