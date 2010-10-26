Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab0JZOhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:37:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50856 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab0JZOhm (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 26 Oct 2010 10:37:42 -0400
Date: Tue, 26 Oct 2010 10:36:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, xen-devel@lists.xensource.com, tglx@linutronix.de
Subject: Re: [PATCH 5/5] xen: events: use per-cpu variable for
 cpu_evtchn_mask
Message-ID: <20101026143615.GD9557@dumpdata.com>
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
 <1288023813-31989-5-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288023813-31989-5-git-send-email-ian.campbell@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 05:23:33PM +0100, Ian Campbell wrote:
> I can't see any reason why it isn't already.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> ---
>  drivers/xen/events.c |   31 +++++++++++--------------------
>  1 files changed, 11 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 9b58505..144ff72 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -110,19 +110,9 @@ static int *pirq_to_irq;
>  static int nr_pirqs;
>  
>  static int *evtchn_to_irq;
> -struct cpu_evtchn_s {
> -	unsigned long bits[NR_EVENT_CHANNELS/BITS_PER_LONG];
> -};
>  
> -static __initdata struct cpu_evtchn_s init_evtchn_mask = {
> -	.bits[0 ... (NR_EVENT_CHANNELS/BITS_PER_LONG)-1] = ~0ul,
> -};
> -static struct cpu_evtchn_s *cpu_evtchn_mask_p = &init_evtchn_mask;
> -
> -static inline unsigned long *cpu_evtchn_mask(int cpu)
> -{
> -	return cpu_evtchn_mask_p[cpu].bits;
> -}
> +static DEFINE_PER_CPU(unsigned long [NR_EVENT_CHANNELS/BITS_PER_LONG],
> +		      cpu_evtchn_mask);
>  
>  /* Xen will never allocate port zero for any purpose. */
>  #define VALID_EVTCHN(chn)	((chn) != 0)
> @@ -301,7 +291,7 @@ static inline unsigned long active_evtchns(unsigned int cpu,
>  					   unsigned int idx)
>  {
>  	return (sh->evtchn_pending[idx] &
> -		cpu_evtchn_mask(cpu)[idx] &
> +		per_cpu(cpu_evtchn_mask, cpu)[idx] &
>  		~sh->evtchn_mask[idx]);
>  }
>  
> @@ -314,8 +304,8 @@ static void bind_evtchn_to_cpu(unsigned int chn, unsigned int cpu)
>  	cpumask_copy(irq_to_desc(irq)->affinity, cpumask_of(cpu));
>  #endif
>  
> -	__clear_bit(chn, cpu_evtchn_mask(cpu_from_irq(irq)));
> -	__set_bit(chn, cpu_evtchn_mask(cpu));
> +	__clear_bit(chn, per_cpu(cpu_evtchn_mask, cpu_from_irq(irq)));
> +	__set_bit(chn, per_cpu(cpu_evtchn_mask, cpu));
>  
>  	info_for_irq(irq)->cpu = cpu;
>  }
> @@ -332,7 +322,11 @@ static void init_evtchn_cpu_bindings(void)
>  	}
>  #endif
>  
> -	memset(cpu_evtchn_mask(0), ~0, sizeof(struct cpu_evtchn_s));
> +	printk(KERN_CRIT "%s: CPU0 at %p size %zd\n", __func__,

If this is per_cpu, wouldn't the comment 'CPU0 at' be improper?

Hmm, so we use percpu structure, but all of the event channel and such
are set for CPU0. So what is the benefit of this, when the interrupts
are _only_ happening on CPU0?

Oh, right, there is also the rebind cpu function somewhere so that the
spinlock, timers, etc are allocated on other CPUs, right?
