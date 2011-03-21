Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1CUVk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 17:40:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:40715 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754378Ab1CUVk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 17:40:56 -0400
X-Greylist: delayed 1639 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Mar 2011 17:40:55 EDT
Date: Mon, 21 Mar 2011 22:13:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Daney <ddaney@caviumnetworks.com>
cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] genirq: Add chip hooks for taking CPUs on/off
 line.
In-Reply-To: <4D879869.8060405@caviumnetworks.com>
Message-ID: <alpine.LFD.2.00.1103212136430.24415@localhost6.localdomain6>
References: <1300484916-11133-1-git-send-email-ddaney@caviumnetworks.com> <1300484916-11133-2-git-send-email-ddaney@caviumnetworks.com> <alpine.LFD.2.00.1103192050400.2787@localhost6.localdomain6> <4D879869.8060405@caviumnetworks.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Mar 2011, David Daney wrote:

> On 03/19/2011 01:51 PM, Thomas Gleixner wrote:
> > On Fri, 18 Mar 2011, David Daney wrote:
> > > --- a/include/linux/irqdesc.h
> > > +++ b/include/linux/irqdesc.h
> > > @@ -178,6 +178,12 @@ static inline int irq_has_action(unsigned int irq)
> > >   	return desc->action != NULL;
> > >   }
> > > 
> > > +/* Test to see if the irq is currently enabled */
> > > +static inline int irq_desc_is_enabled(struct irq_desc *desc)
> > > +{
> > > +	return desc->depth == 0;
> > > +}
> > 
> > That want's to go into kernel/irq/internal.h
> 
> I think I need to use this in my irq_chip.irq_unmask method.
> 
> Consider this:
> 
> 
> CPU0                   CPU1
> handle_level_irq
>   lock
>   mask
>   handle_irq_event
>     unlock
>     .
>     .                  disable_irq
>     .
>     lock
>   unmask
>   unlock

handle level irq does:

	if (!(desc->istate & (IRQS_DISABLED | IRQS_ONESHOT)))
		unmask_irq(desc);
       
So it does not call unmask.

> I need to know in my .unmask method if the interrupt has been disabled.  If it
> has, I will not re-enable (unmask)it.

It wont be called :)
 
> > 
> > >   #ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
> > >   static inline int irq_balancing_disabled(unsigned int irq)
> > >   {
> > > diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> > > index c9c0601..40736f7 100644
> > > --- a/kernel/irq/chip.c
> > > +++ b/kernel/irq/chip.c
> > > @@ -689,3 +689,38 @@ void irq_modify_status(unsigned int irq, unsigned
> > > long clr, unsigned long set)
> > > 
> > >   	irq_put_desc_unlock(desc, flags);
> > >   }
> > > +
> > > +void irq_cpu_online(unsigned int irq)
> > 
> > Odd function name. It does not reflect that this is for per cpu
> > interrupts. So something like irq_xxx_per_cpu_irq(irq)
> > might be a bit more descriptive.
> 
> I am using it for per cpu interrupts, but I didn't want to impose that policy
> on others.

I can't imagine any other purpose for that.

> > Though one question remains: should we just iterate over the irq space
> > and call the online/offline callbacks when available instead of having
> > the arch code do the iteration.
> > 
> 
> That would be good I think, especially for sparse irqs.
> 
> In the case of the CPU going offline, the .irq_cpu_offline() may need to
> adjust the affinity so that the irq no longer has affinity for the off-lined
> CPU.
> 
> This is something needed even for non-per-cpu interrupts.  Also I would need a
> way to call irq_set_affinity() while holding the desc->lock.

Hmm. The offline fixup_irq() code is arch specific and usually calls
desc->irq_data.chip->irq_set_affinity under desc->lock. I have not yet
found an arch independent way to do that. Any ideas welcome.

Thanks,

	tglx


