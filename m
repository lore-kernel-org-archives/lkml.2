Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab0HTBum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:50:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab0HTBuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:50:40 -0400
Date: Thu, 19 Aug 2010 21:50:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100820015017.GA4879@redhat.com>
References: <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100817152225.GQ26154@erda.amd.com>
 <1282214753.1926.4669.camel@laptop>
 <20100819141240.GO4879@redhat.com>
 <1282228033.2605.204.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282228033.2605.204.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 04:27:13PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-08-19 at 10:12 -0400, Don Zickus wrote:
> > On Thu, Aug 19, 2010 at 12:45:53PM +0200, Peter Zijlstra wrote:
> > > 
> > > I queued it with that part changed to:
> > 
> > I realized the other day this change doesn't cover the nehalem, core and p4
> > cases which use
> > 
> > intel_pmu_handle_irq
> > p4_pmu_handle_irq
> > 
> > as their handlers.  Though that patch can go on top of Robert's.
> 
> Something like this?

I tested this patch and Robert's on an AMD box and Nehalem box.  Both
worked as intended.  However I did notice that whenever the AMD box
detected handled >1, it was shortly followed by an unknown_nmi that was
properly eaten with Robert's logic.  Whereas on the Nehalem box I saw a
lot of 'handled > 1' messages but very very few of them were followed by
an unknown_nmi message (and those messages that did come were properly
eaten).

Maybe that is just the differences in the cpu designs.

Of course I had to make the one change I mentioned previously for the
perf_event_intel.c file (moving the handled++ logic down a few lines).

I didn't run the test on a P4 box.

Looks great, thanks guys!

Cheers,
Don

> 
> ---
> Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -713,6 +713,7 @@ static int intel_pmu_handle_irq(struct p
>  	struct cpu_hw_events *cpuc;
>  	int bit, loops;
>  	u64 ack, status;
> +	int handled = 0;
>  
>  	perf_sample_data_init(&data, 0);
>  
> @@ -743,12 +744,16 @@ again:
>  	/*
>  	 * PEBS overflow sets bit 62 in the global status register
>  	 */
> -	if (__test_and_clear_bit(62, (unsigned long *)&status))
> +	if (__test_and_clear_bit(62, (unsigned long *)&status)) {
> +		handled++;
>  		x86_pmu.drain_pebs(regs);
> +	}
>  
>  	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
>  		struct perf_event *event = cpuc->events[bit];
>  
> +		handled++;
> +
>  		if (!test_bit(bit, cpuc->active_mask))
>  			continue;
>  
> @@ -772,7 +777,7 @@ again:
>  
>  done:
>  	intel_pmu_enable_all(0);
> -	return 1;
> +	return handled;
>  }
>  
>  static struct event_constraint *
> Index: linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -673,7 +673,7 @@ static int p4_pmu_handle_irq(struct pt_r
>  		if (!overflow && (val & (1ULL << (x86_pmu.cntval_bits - 1))))
>  			continue;
>  
> -		handled += overflow;
> +		handled += !!overflow;
>  
>  		/* event overflow for sure */
>  		data.period = event->hw.last_period;
> @@ -690,7 +690,7 @@ static int p4_pmu_handle_irq(struct pt_r
>  		inc_irq_stat(apic_perf_irqs);
>  	}
>  
> -	return handled > 0;
> +	return handled;
>  }
>  
>  /*
> 
