Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab0FFWId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 18:08:33 -0400
Received: from www.tglx.de ([62.245.132.106]:33471 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147Ab0FFWIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 18:08:32 -0400
Date: Mon, 7 Jun 2010 00:08:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Esben Haabendal <esbenhaabendal@gmail.com>
cc: Marc Zyngier <maz@misterjones.org>,
       Esben Haabendal <eha@doredevelopment.dk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, joachim.eastwood@jotron.com
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded
 interrupt handlers
In-Reply-To: <AANLkTik2so7osQJFq6NRaIFK2GVLURVozOqSsejd1K0F@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006062228120.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk> <alpine.LFD.2.00.1006042343150.2933@localhost.localdomain> <AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com> <20100605151031.2d562268@hina.wild-wind.fr.eu.org>
 <alpine.LFD.2.00.1006051732270.2933@localhost.localdomain> <AANLkTimlSBEhl58CNuScKjxbqdTwTYgqo7vrHTcd1x9G@mail.gmail.com> <alpine.LFD.2.00.1006051915290.2933@localhost.localdomain> <AANLkTimcB9vRqnNYyBh6hjHXZHcmFvw72MZUEIGfeexq@mail.gmail.com>
 <alpine.LFD.2.00.1006052155100.2933@localhost.localdomain> <AANLkTik2so7osQJFq6NRaIFK2GVLURVozOqSsejd1K0F@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.LFD.2.00.1006062335561.2933@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jun 2010, Esben Haabendal wrote:

> On Sat, Jun 5, 2010 at 10:14 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> The phy interrupt handler calls disable_irq, which does not work
> >> with an i2c irq controller (ie. the genirc buslock mutex), and I specifically
> >> got rid of the buslock for pca9535 driver (powerpc only, though).
> >
> > And that's the fundamentally wrong approach.
> 
> Well, given you haven't seen what I have done there, I don't see how you
> can be so sure ;-)

See below :)
 
> The only reason for the buslock in the pca9535 driver is to set the
> direction (ie. input) for interrupt pins.  On powerpc, I do this in the map()
> irq_chip function. So I don't see the need for buslock on powerpc.

What's so magic about powerpc. Does it magically serialize stuff ?

The buslock is there for a reason:

  The generic irq code calls irq_chip functions with irq_desc->lock
  held and interrupts disabled. So the driver _CANNOT_ access the I2C
  bus because that's blocking.

  So the irq_chip functions modify driver local state, which might be
  modified by non irq related code as well.

  After releasing desc->lock the genirq code calls the bus unlock
  function which does the I2C work and releases the buslock after it's
  done.

  Therefor we take the buslock before we take desc->lock and release
  it after unlocking desc->lock.

So your removal of buslock removes the protection of the genirq
operation, which is guaranteed to be serialized against other
callers. The driver local state is not longer protected.

That's totally unrelated to powerpc and UP, it's simply plain
wrong. And that's why I knew w/o looking at your patch. :)

You can argue to me in circles, that it is not a problem on your
particular system. I don't care at all. It does not matter as it
violates the semantics and might blow up in other usage scenarios
badly. Hint: think SMP

And that's why we have request_any_context_irq() in the first place
and want people to realize that the driver which ends up on a I2C irq
controller (which is one of the most braindead ideas hardware folks
came up with ever) needs to be audited and probably modified.

> > Just because you have not hit the problem yet does not make it non
> > existant.
> 
> Which particular problem should I be on the lookout for in pca953x
> driver?

See above.
 
> > Yeah, and at the same time you rip out the buslock. Why are you not
> > sending this patch as well ? Simply because you know that it is
> > utterly wrong and a horrible hack.
> 
> No, it was send at the same time, but to the linuxppc-dev.  I do not

You should have CC'ed me as well on that to give me the full context,
so I would have told you in the first reply why it is [pick your
favourite out of my arsenal of swear word combos] but in a more
moderate way as I would have noticed right away that you did not
realize the implications and semantics of buslock and the reasons why
you need to look at the innocent PHY driver.

> see it as utterly wrong, and I hope you will give it a look with an open
> mind, not just assuming that it is shitty crap, utterly wrong or horrible
> hack even before reading it, thanks ;-)
> 
> http://patchwork.ozlabs.org/patch/54717/
> 
> It is a longer patch, and I expect that it could be improved quite a
> bit, but I really don't see it as a fundanmentally shitty.

I do (even before looking at it). Simply because it breaks the
driver. See above.

> > But at the same time you want to sell me a patch which rips out the
> > prevention mechanism for your hack.
> 
> Which patch are you refering to?
> 
> The patch we are discussing here does not rip out any thing,
>
> It simply adds support for using existing dirvers together
> with handle_nested_irq().

It's ripping out the prevention of what you are trying to do.
 
> > The time you spent to fiddle with the generic code and ripping out the
> > buslock is probably more than it had taken to make the PHY driver
> > thread safe.
> 
> Maybe, but I am not so sure.
> 
> The phy driver calls disable_irq_nosync(), which is documented as
> "This function may be called from IRQ context."
> And with disable_irq_nosync() calling chip_bus_lock() and
> chip_bus_sync_unlock(), which definitely is not meant
> for IRQ context, I got the understanding that it was not
> the phy driver that needed fixing, but mroe the generic
> buslock stuff, which I did not have the guts to touch, as
> I understand it would be easy to get wrong.
> 
> So maybe you can help me out here, is disable_irq_nosync()
> to be improved here?  It does not seem to be fair to
> document that it can be called in IRQ context, and then
> have it designed to blow up if done so in combination
> with a genirq buslock driver.

The documentation says: It may be called from irq context.

That means it's safe to call it from the irq handler itself, contrary
to disable_irq() which would deadlock. When your handler is running in
thread context then this applies as well.

Maybe the documentation is a bit unclear about that. I'm happy to
accept a patch which improves it !
 
> > The buslock is there for a reason and if you can't use the code with
> > the disable/enable_irq() in the atomic context, then this needs to be
> > fixed there if you need to run the irq handler in thread context.
> 
> How can I disable_irq in interrupt context, with the interrupt handled
> by a genirq buslock driver?

See above.

Btw, which phy driver are you talking about ? 

Calling irq_disable_nosync() from the irq handler needs a damned good
reason and in most cases it pops up the red "Hack Alert" sign.

Thanks,

	tglx
