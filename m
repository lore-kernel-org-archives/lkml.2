Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab1INR63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 13:58:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221Ab1INR62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 13:58:28 -0400
Date: Wed, 14 Sep 2011 13:58:09 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V4][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110914175809.GY5795@redhat.com>
References: <1315947509-6429-1-git-send-email-dzickus@redhat.com>
 <1315947509-6429-5-git-send-email-dzickus@redhat.com>
 <20110914162653.GI6063@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110914162653.GI6063@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 06:26:53PM +0200, Robert Richter wrote:
> On 13.09.11 16:58:27, Don Zickus wrote:
> > @@ -87,6 +87,16 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
> >  
> >  		handled += a->handler(type, regs);
> >  
> > +		/*
> > + 		 * Optimization: only loop once if this is not a 
> > + 		 * back-to-back NMI.  The idea is nothing is dropped
> > + 		 * on the first NMI, only on the second of a back-to-back
> > + 		 * NMI.  No need to waste cycles going through all the
> > + 		 * handlers.
> > + 		 */
> > +		if (!b2b && handled)
> > +			break;
> 
> Don, if I am not missing something, this actually does not work
> because perfctr NMIs do not re-trigger. Suppose a handler running
> before perfctr. It sets 'handled' and the chain is stopped here. To
> run through the perfctr handler the NMI must retrigger which it
> doesn't.

Your patch is incorrect.  Your dummy handler does not handle a _real_ NMI.
Which means no _real_ NMI was ever generated.  Of course perf won't work.
You just swallowed its NMI.

The change I made is for nmi handlers that actually have an NMI associated
with them.  The idea is if somebody generated an NMI, it will get handled
by a handler.  If perf comes along and generates another NMI, it should
get latched.  Upon handling the first NMI, the perf NMI should be sitting
queued up and cause the back-to-back NMI. In this case all the handlers
will be executed (to handle dropped NMIs).

My only question to you is the IBS stuff you were working on.  Does that
generate a _real_ NMI or does it just piggy back off of the perf NMI?

Cheers,
Don

> 
> I tested the above with enclosed patch.
> 
> The patch handles the nmi and then stops the chain. You see by the PMI
> count that the perfctr nmi is not handled:
> 
> Patch applied:
> 
>  # echo $(($(grep PMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
>  0
>  # echo $(($(grep NMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
>  0
>  # perf record -e cpu-cycles bash -c 'perl -e "while(1) {}" & sleep 5 ; kill $!'
>  [ perf record: Woken up 1 times to write data ]
>  [ perf record: Captured and wrote 0.011 MB perf.data (~472 samples) ]
>  # echo $(($(grep PMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
>  128
>  # echo $(($(grep NMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
>  1387
> 
> W/o the patch (tip/perf/core: 51887c8):
> 
>  # echo $(($(grep NMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
>  0
>  # echo $(($(grep PMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
>  0
>  # perf record -e cpu-cycles bash -c 'perl -e "while(1) {}" & sleep 5 ; kill $!'
>  [ perf record: Woken up 1 times to write data ]
>  [ perf record: Captured and wrote 0.194 MB perf.data (~8455 samples) ]
>  # echo $(($(grep PMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
>  4918
>  # echo $(($(grep NMI /proc/interrupts | sed -e 's/.*: *//;s/ *Non.*//;s/  */ + /g')))
>  4918
> 
> So we may not jump out the while loop.
> 
> -Robert
> 
> > +
> >  		a = next_a;
> >  	}
> >  	rcu_read_unlock();
> 
> 
> 
> From b1d68bf037cfa78f073cf71c296057ff422294f2 Mon Sep 17 00:00:00 2001
> From: Robert Richter <robert.richter@amd.com>
> Date: Wed, 14 Sep 2011 11:44:49 +0200
> Subject: [PATCH] perf_nmi_test
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c |   45 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 45 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 594d425..2255221 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -31,6 +31,7 @@
>  #include <asm/compat.h>
>  #include <asm/smp.h>
>  #include <asm/alternative.h>
> +#include <asm/hardirq.h>
>  
>  #if 0
>  #undef wrmsrl
> @@ -43,6 +44,8 @@ do {								\
>  } while (0)
>  #endif
>  
> +#define irq_stats(x)              (&per_cpu(irq_stat, x))
> +
>  /*
>   *          |   NHM/WSM    |      SNB     |
>   * register -------------------------------
> @@ -1383,6 +1386,7 @@ perf_event_nmi_handler(struct notifier_block *self,
>  	struct die_args *args = __args;
>  	unsigned int this_nmi;
>  	int handled;
> +	int cpu;
>  
>  	if (!atomic_read(&active_events))
>  		return NOTIFY_DONE;
> @@ -1408,6 +1412,9 @@ perf_event_nmi_handler(struct notifier_block *self,
>  	}
>  
>  	handled = x86_pmu.handle_irq(args->regs);
> +	cpu = smp_processor_id();
> +	trace_printk("perf: NMI: %d, PMI: %d, handled: %d\n", irq_stats(cpu)->__nmi_count,
> +		     irq_stats(cpu)->apic_perf_irqs, handled);
>  	if (!handled)
>  		return NOTIFY_DONE;
>  
> @@ -1961,3 +1968,41 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
>  
>  	return misc;
>  }
> +
> +static DEFINE_PER_CPU(unsigned long, save_rip);
> +
> +static int __kprobes perf_test_nmi_handler(struct notifier_block *self,
> +					   unsigned long cmd, void *__args)
> +{
> +	struct die_args *args = __args;
> +	bool b2b = false;
> +	int cpu = smp_processor_id();
> +
> +	if (cmd != DIE_NMI)
> +		return NOTIFY_DONE;
> +
> +	if (args->regs->ip == __this_cpu_read(save_rip))
> +		b2b = true;
> +
> +	__this_cpu_write(save_rip, args->regs->ip);
> +
> +	trace_printk("skip: NMI: %d, PMI: %d, b2b: %d\n", irq_stats(cpu)->__nmi_count,
> +		     irq_stats(cpu)->apic_perf_irqs, b2b);
> +
> +	if (!b2b)
> +		return NOTIFY_STOP;
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static __read_mostly struct notifier_block perf_test_nmi_notifier = {
> +	.notifier_call		= perf_test_nmi_handler,
> +	.priority		= NMI_LOCAL_HIGH_PRIOR,
> +};
> +
> +static __init int perf_nmi_test_init(void)
> +{
> +	return register_die_notifier(&perf_test_nmi_notifier);
> +}
> +
> +device_initcall(perf_nmi_test_init);
> -- 
> 1.7.6.1
> 
> 
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> 
