Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729Ab0JZOuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:50:14 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:2153 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab0JZOuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:50:12 -0400
X-IronPort-AV: E=Sophos;i="4.58,241,1286164800"; 
   d="scan'208";a="119745268"
Subject: Re: [PATCH 5/5] xen: events: use per-cpu variable for
 cpu_evtchn_mask
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <20101026143615.GD9557@dumpdata.com>
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
	 <1288023813-31989-5-git-send-email-ian.campbell@citrix.com>
	 <20101026143615.GD9557@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 26 Oct 2010 15:50:08 +0100
Message-ID: <1288104608.8361.15.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 15:36 +0100, Konrad Rzeszutek Wilk wrote:
> On Mon, Oct 25, 2010 at 05:23:33PM +0100, Ian Campbell wrote:
> > I can't see any reason why it isn't already.
> > 
> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > ---
> >  drivers/xen/events.c |   31 +++++++++++--------------------
> >  1 files changed, 11 insertions(+), 20 deletions(-)
> > 
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index 9b58505..144ff72 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -110,19 +110,9 @@ static int *pirq_to_irq;
> >  static int nr_pirqs;
> >  
> >  static int *evtchn_to_irq;
> > -struct cpu_evtchn_s {
> > -	unsigned long bits[NR_EVENT_CHANNELS/BITS_PER_LONG];
> > -};
> >  
> > -static __initdata struct cpu_evtchn_s init_evtchn_mask = {
> > -	.bits[0 ... (NR_EVENT_CHANNELS/BITS_PER_LONG)-1] = ~0ul,
> > -};
> > -static struct cpu_evtchn_s *cpu_evtchn_mask_p = &init_evtchn_mask;
> > -
> > -static inline unsigned long *cpu_evtchn_mask(int cpu)
> > -{
> > -	return cpu_evtchn_mask_p[cpu].bits;
> > -}
> > +static DEFINE_PER_CPU(unsigned long [NR_EVENT_CHANNELS/BITS_PER_LONG],
> > +		      cpu_evtchn_mask);
> >  
> >  /* Xen will never allocate port zero for any purpose. */
> >  #define VALID_EVTCHN(chn)	((chn) != 0)
> > @@ -301,7 +291,7 @@ static inline unsigned long active_evtchns(unsigned int cpu,
> >  					   unsigned int idx)
> >  {
> >  	return (sh->evtchn_pending[idx] &
> > -		cpu_evtchn_mask(cpu)[idx] &
> > +		per_cpu(cpu_evtchn_mask, cpu)[idx] &
> >  		~sh->evtchn_mask[idx]);
> >  }
> >  
> > @@ -314,8 +304,8 @@ static void bind_evtchn_to_cpu(unsigned int chn, unsigned int cpu)
> >  	cpumask_copy(irq_to_desc(irq)->affinity, cpumask_of(cpu));
> >  #endif
> >  
> > -	__clear_bit(chn, cpu_evtchn_mask(cpu_from_irq(irq)));
> > -	__set_bit(chn, cpu_evtchn_mask(cpu));
> > +	__clear_bit(chn, per_cpu(cpu_evtchn_mask, cpu_from_irq(irq)));
> > +	__set_bit(chn, per_cpu(cpu_evtchn_mask, cpu));
> >  
> >  	info_for_irq(irq)->cpu = cpu;
> >  }
> > @@ -332,7 +322,11 @@ static void init_evtchn_cpu_bindings(void)
> >  	}
> >  #endif
> >  
> > -	memset(cpu_evtchn_mask(0), ~0, sizeof(struct cpu_evtchn_s));
> > +	printk(KERN_CRIT "%s: CPU0 at %p size %zd\n", __func__,
> 
> If this is per_cpu, wouldn't the comment 'CPU0 at' be improper?

Oops, that was just debug anyway.

> Hmm, so we use percpu structure, but all of the event channel and such
> are set for CPU0. So what is the benefit of this, when the interrupts
> are _only_ happening on CPU0?

All event channels start off bound to VCPU0 so we need to initialise
cpu_evtchn_mask(0) to have all ones and leave all the other CPU's
bitmaps with all zeros.

> Oh, right, there is also the rebind cpu function somewhere so that the
> spinlock, timers, etc are allocated on other CPUs, right?

All evtchn's start off bound to VCPU 0 but the kernel can rebind as
necessary.

Ian.

