Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab0FGPHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 11:07:25 -0400
Received: from www.tglx.de ([62.245.132.106]:48836 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab0FGPHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 11:07:21 -0400
Date: Mon, 7 Jun 2010 17:06:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Esben Haabendal <eha@doredevelopment.dk>
cc: linuxppc-dev@ozlabs.org, Esben Haabendal <esbenhaabendal@gmail.com>,
       Marc Zyngier <maz@misterjones.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, joachim.eastwood@jotron.com,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded
 interrupt handlers
In-Reply-To: <1275914058.2818.8.camel@eha.doredevelopment.dk>
Message-ID: <alpine.LFD.2.00.1006071440520.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk>  <alpine.LFD.2.00.1006042343150.2933@localhost.localdomain>  <AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com>  <20100605151031.2d562268@hina.wild-wind.fr.eu.org> 
 <alpine.LFD.2.00.1006051732270.2933@localhost.localdomain>  <AANLkTimlSBEhl58CNuScKjxbqdTwTYgqo7vrHTcd1x9G@mail.gmail.com>  <alpine.LFD.2.00.1006051915290.2933@localhost.localdomain>  <AANLkTimcB9vRqnNYyBh6hjHXZHcmFvw72MZUEIGfeexq@mail.gmail.com> 
 <alpine.LFD.2.00.1006052155100.2933@localhost.localdomain>  <AANLkTik2so7osQJFq6NRaIFK2GVLURVozOqSsejd1K0F@mail.gmail.com>  <alpine.LFD.2.00.1006062228120.2933@localhost.localdomain> <1275914058.2818.8.camel@eha.doredevelopment.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jun 2010, Esben Haabendal wrote:
> On Mon, 2010-06-07 at 00:08 +0200, Thomas Gleixner wrote:
> 
> > > The only reason for the buslock in the pca9535 driver is to set the
> > > direction (ie. input) for interrupt pins.  On powerpc, I do this in the map()
> > > irq_chip function. So I don't see the need for buslock on powerpc.
> > 
> > What's so magic about powerpc. Does it magically serialize stuff ?
> > 
> > The buslock is there for a reason:
> > 
> >   The generic irq code calls irq_chip functions with irq_desc->lock
> >   held and interrupts disabled. So the driver _CANNOT_ access the I2C
> >   bus because that's blocking.
> 
> Which I don't see a need for. As I mentioned, the only I2C access done
> at this point is the write to direction register, in case new irq's
> requires switching a pin from output to input.
> 
> This can be done on irq_chip->map() on powerpc, without requiring
> other drivers to know about it.
> 
> > So the irq_chip functions modify driver local state, which might be
> >   modified by non irq related code as well.
> 
> Which is not done here.
> The irq_chip functions modify the following driver local state
> variables:
>   irq_mask (mask/unmask)
>   irq_trig_fall (set_type)
>   irq_trig_raise (set_type)
> 
> They are not (to be) modified by other functions.

That does not matter. You remove even the serialization of these
functions and the guarantee of higher level functions, that the
changed state has hit the hardware _BEFORE_ something else can change
it.

Thats what the buslock/unlock mechanism protects, and it _IS_ not
going to change, even if it could work on some UP configurations for
whatever reason. Neither is the sanity check for nested handlers going
away.

Can we please stop it here and solve the problem where it needs to be
solved? See below.

> The handler is implemented in drivers/net/phy/phy.c and is used by all
> phy drivers in drivers/net/phy/
> 
> > Calling irq_disable_nosync() from the irq handler needs a damned good
> > reason and in most cases it pops up the red "Hack Alert" sign.
> 
> Hehe, ok :-D
> 
> It might be the root to all my trouble here, so I would be very happy to
> find a solution for it.
> 
> The problem is that MDIO communication is often just as painstakingly

It's not about slow. MDIO access needs thread context.

> slow as I2C, so the phy irq handler disables the irq and schedules a
> work, which then will do the MDIO communication, and thus ack the irq,
> and finally re-enable the irq.
> 
> Hints on how to fix that would be appreciated.

Yes, the driver should be converted to threaded interrupts as MDIO
access needs thread context, but when the driver was written, there
were no threaded handlers available.

So it does nothing in the interrupt than disabling the irq line and
scheduling work. The real functions are done in thread context and
that's why it needs to disable the irq line.

That's where threaded interrupt comes handy, because threaded
interrupts do that already with the IRQF_ONESHOT flag set for direct
called irqs and in case of nested threaded interrupts, there is no
need at all, because the demux handler serializes interrupts already.

The only problem in the non nested case is, that we currently do not
allow ONESHOT for shared interrupts as this might hold off the other
device on that IRQ line for too long, but looking at this driver it
must be done anyway via the disable_irq_nosync() call in the interrupt
handler. And it needs careful synchronization across the shared
interrupts.

We can remove that restriction with an IRQF_FORCE_ONESHOT flag, which
annotates such usecases and is easy to grep for (ab)users. We have
patches in -rt already to handle that for shared interrupts, I just
need to polish them a bit.

That would remove a lot of ugly code in such drivers which is
necessary: the disable_irq_nosync() call, synchronizing with
workqueues etc.

And in your case it would remove _TWO_ I2C transfers, which is
definitely a huge performance win.

You don't have to wait for the genirq changes as in your case you can
remove the IRQF_SHARED flag until the genirq changes are available.

Maybe you understand now, why I was pretty sure upfront, that your
approach was wrong even without knowing all the gory details ? :)

Thanks,

	tglx
