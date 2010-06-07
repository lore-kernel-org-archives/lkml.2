Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897Ab0FGMe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:34:29 -0400
Received: from zmta01.cabocomm.dk ([193.200.44.52]:46401 "EHLO zmta01.irigo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab0FGMe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:34:28 -0400
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded
 interrupt handlers
From: Esben Haabendal <eha@doredevelopment.dk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linuxppc-dev@ozlabs.org, Esben Haabendal <esbenhaabendal@gmail.com>,
       Marc Zyngier <maz@misterjones.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, joachim.eastwood@jotron.com
In-Reply-To: <alpine.LFD.2.00.1006062228120.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk>
	 <alpine.LFD.2.00.1006042343150.2933@localhost.localdomain>
	 <AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com>
	 <20100605151031.2d562268@hina.wild-wind.fr.eu.org>
	 <alpine.LFD.2.00.1006051732270.2933@localhost.localdomain>
	 <AANLkTimlSBEhl58CNuScKjxbqdTwTYgqo7vrHTcd1x9G@mail.gmail.com>
	 <alpine.LFD.2.00.1006051915290.2933@localhost.localdomain>
	 <AANLkTimcB9vRqnNYyBh6hjHXZHcmFvw72MZUEIGfeexq@mail.gmail.com>
	 <alpine.LFD.2.00.1006052155100.2933@localhost.localdomain>
	 <AANLkTik2so7osQJFq6NRaIFK2GVLURVozOqSsejd1K0F@mail.gmail.com>
	 <alpine.LFD.2.00.1006062228120.2933@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: =?ISO-8859-1?Q?Dor=E9Development?= ApS
Date: Mon, 07 Jun 2010 14:34:18 +0200
Message-ID: <1275914058.2818.8.camel@eha.doredevelopment.dk>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 00:08 +0200, Thomas Gleixner wrote:

> > The only reason for the buslock in the pca9535 driver is to set the
> > direction (ie. input) for interrupt pins.  On powerpc, I do this in the map()
> > irq_chip function. So I don't see the need for buslock on powerpc.
> 
> What's so magic about powerpc. Does it magically serialize stuff ?
> 
> The buslock is there for a reason:
> 
>   The generic irq code calls irq_chip functions with irq_desc->lock
>   held and interrupts disabled. So the driver _CANNOT_ access the I2C
>   bus because that's blocking.

Which I don't see a need for. As I mentioned, the only I2C access done
at this point is the write to direction register, in case new irq's
requires switching a pin from output to input.

This can be done on irq_chip->map() on powerpc, without requiring
other drivers to know about it.

> So the irq_chip functions modify driver local state, which might be
>   modified by non irq related code as well.

Which is not done here.
The irq_chip functions modify the following driver local state
variables:
  irq_mask (mask/unmask)
  irq_trig_fall (set_type)
  irq_trig_raise (set_type)

They are not (to be) modified by other functions.

> After releasing desc->lock the genirq code calls the bus unlock
>   function which does the I2C work and releases the buslock after it's
>   done.

See above. No I2C work is needed.

> Therefor we take the buslock before we take desc->lock and release
>   it after unlocking desc->lock.
> 
> So your removal of buslock removes the protection of the genirq
> operation, which is guaranteed to be serialized against other
> callers. The driver local state is not longer protected.

But I don't see what I need to protect against. No other
code is touching driver local state that is also touched by
the genirq operations.  Or what am I overseeing here?

> That's totally unrelated to powerpc and UP, it's simply plain
> wrong. And that's why I knew w/o looking at your patch. :)

Well, it seems to me that you have a few wrong assumptions about
what the genirq operations in the patched pca953x driver is
doing, which might warrant a second look at my patch ;-)

> You can argue to me in circles, that it is not a problem on your
> particular system. I don't care at all. It does not matter as it
> violates the semantics and might blow up in other usage scenarios
> badly. Hint: think SMP
> 
> And that's why we have request_any_context_irq() in the first place
> and want people to realize that the driver which ends up on a I2C irq
> controller (which is one of the most braindead ideas hardware folks
> came up with ever) needs to be audited and probably modified.

I totally agree with the last part. I have asked (and convinced) the
hardware people to change that for next revision :-)

> > > Just because you have not hit the problem yet does not make it non
> > > existant.
> > 
> > Which particular problem should I be on the lookout for in pca953x
> > driver?
> 
> See above.

Ok, but I believe that these issues have been dealt with by removing the
need to do I2C work in the irq_chip functions, and by restricting the
driver local state to be only touched by irq_chip functions.  Unless I
am overlooking something more, I fail to see the need for the buslock
in this case (not the general case). 

> > > Yeah, and at the same time you rip out the buslock. Why are you not
> > > sending this patch as well ? Simply because you know that it is
> > > utterly wrong and a horrible hack.
> > 
> > No, it was send at the same time, but to the linuxppc-dev.  I do not
> 
> You should have CC'ed me as well on that to give me the full context,
> so I would have told you in the first reply why it is [pick your
> favourite out of my arsenal of swear word combos] but in a more
> moderate way as I would have noticed right away that you did not
> realize the implications and semantics of buslock and the reasons why
> you need to look at the innocent PHY driver.

Sorry about that.

But your explanations of the buslock in this thread
fits very well with my understanding prior to posting here, so I might
not be as mis-guided in my attempt.

> > see it as utterly wrong, and I hope you will give it a look with an open
> > mind, not just assuming that it is shitty crap, utterly wrong or horrible
> > hack even before reading it, thanks ;-)
> > 
> > http://patchwork.ozlabs.org/patch/54717/
> > 
> > It is a longer patch, and I expect that it could be improved quite a
> > bit, but I really don't see it as a fundanmentally shitty.
> 
> I do (even before looking at it). Simply because it breaks the
> driver. See above.

Well, I would be very interested in finding out in more detail where it
is broken, as I have replied above to the concerns for I2C work and
driver local state race conditions.  I am very open about having
overlooked something, but I would prefer to know exactly what is wrong.
If nothing else, just to be a bit better of next time I enter this
area :-)

> > > But at the same time you want to sell me a patch which rips out the
> > > prevention mechanism for your hack.
> > 
> > Which patch are you refering to?
> > 
> > The patch we are discussing here does not rip out any thing,
> >
> > It simply adds support for using existing dirvers together
> > with handle_nested_irq().
> 
> It's ripping out the prevention of what you are trying to do.

Still, the patch handle_nested_thread() does not rip anything out.
The pca953x.c patch does, but I see it as two different things.

Am I right that you are NAK'ing this patch due to your concerns about
the pca953x.c patch?  If so and if I can convince you that the pca953x.c
patch actually might be heading in a sane direction, you will be
willing to look at this patch again?

Of-course, if anyone implemented an interrupt controller in a thread_fn,
but without I2C or any other need for buslock, the patch proposed here
could make sense.  I don't know about any such driver though... 

> > So maybe you can help me out here, is disable_irq_nosync()
> > to be improved here?  It does not seem to be fair to
> > document that it can be called in IRQ context, and then
> > have it designed to blow up if done so in combination
> > with a genirq buslock driver.
> 
> The documentation says: It may be called from irq context.
> 
> That means it's safe to call it from the irq handler itself, contrary
> to disable_irq() which would deadlock. When your handler is running in
> thread context then this applies as well.
> 
> Maybe the documentation is a bit unclear about that. I'm happy to
> accept a patch which improves it !

But when does it make sense to call functions which are not valid in irq
context from a function which are allowed to be called from irq context?
At least, the principles of least surprise is violated.

Should the documentation be amended with a not on disable_irq(_nosync),
that it must not be called from irq context on interrupts which are
handled by genirq buslock enabled drivers? 

> > > The buslock is there for a reason and if you can't use the code with
> > > the disable/enable_irq() in the atomic context, then this needs to be
> > > fixed there if you need to run the irq handler in thread context.
> > 
> > How can I disable_irq in interrupt context, with the interrupt handled
> > by a genirq buslock driver?
> 
> See above.

Where above?  You mean that I can call disable_irq_nosync() from irq
context?  But it calls chip_bus_lock() which calls mutex_lock().  How
is that going to work?

> Btw, which phy driver are you talking about ? 

The handler is implemented in drivers/net/phy/phy.c and is used by all
phy drivers in drivers/net/phy/

> Calling irq_disable_nosync() from the irq handler needs a damned good
> reason and in most cases it pops up the red "Hack Alert" sign.

Hehe, ok :-D

It might be the root to all my trouble here, so I would be very happy to
find a solution for it.

The problem is that MDIO communication is often just as painstakingly
slow as I2C, so the phy irq handler disables the irq and schedules a
work, which then will do the MDIO communication, and thus ack the irq,
and finally re-enable the irq.

Hints on how to fix that would be appreciated.

/Esben



