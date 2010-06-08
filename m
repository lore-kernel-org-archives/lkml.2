Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0FHOP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 10:15:59 -0400
Received: from zmta01.cabocomm.dk ([193.200.44.52]:34428 "EHLO zmta01.irigo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab0FHOP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 10:15:57 -0400
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded
 interrupt handlers
From: Esben Haabendal <eha@doredevelopment.dk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Esben Haabendal <esbenhaabendal@gmail.com>, linuxppc-dev@ozlabs.org,
       Marc Zyngier <maz@misterjones.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, joachim.eastwood@jotron.com,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.1006080015570.2933@localhost.localdomain>
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
	 <1275914058.2818.8.camel@eha.doredevelopment.dk>
	 <alpine.LFD.2.00.1006071440520.2933@localhost.localdomain>
	 <AANLkTilPhof5cnhBCXSzKJSnWl6Vuu2fRts2pBBBNl6K@mail.gmail.com>
	 <alpine.LFD.2.00.1006080015570.2933@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: =?ISO-8859-1?Q?Dor=E9Development?= ApS
Date: Tue, 08 Jun 2010 16:15:47 +0200
Message-ID: <1276006547.2870.488.camel@eha.doredevelopment.dk>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-08 at 01:18 +0200, Thomas Gleixner wrote: 
> On Mon, 7 Jun 2010, Esben Haabendal wrote:
> > On Mon, Jun 7, 2010 at 5:06 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > Maybe you understand now, why I was pretty sure upfront, that your
> > > approach was wrong even without knowing all the gory details ? :)
> > 
> > I understand.  There is a better solution, which is to use threaded
> > interrupts where needed.
> > 
> > But I must confess that I am disappointed that you still fail to see
> > how the pca953x
> > patch actually eliminates the need for serialization. But I don't
> > think there is much
> > point in going on about that.
> 
> I return the favour of being disappointed that you are still failing
> to accept that there is a fundamental difference between "it works in
> a particular case" and semantical correctness under all
> circumstances.

No reason to do that.  I must have misunderstood you then.
I understand that the general case, I just never got the point
where you understood what I did that (I believe) makes it
actually work (not just for now, but really work), in my
particular case.

> There is no place for "it works in a particular case" in a kernel
> which runs on a gazillion of different devices unless you want to
> create a complete unmaintainable mess. The only way to avoid this is
> to be strict about semantics even if it seems unsensible for a
> particular case.

I won't argue against.  Not at all.

> Also I explained it to you in great length, that your patch violates
> the semantical guarantees of existing functions, but you ignore that
> completely.

And I answered you several times, that I understand your point,
but 


> It's Open Source, go wild and change it for your particular case - but
> don't expect that I accept patches to the generic irq code which will
> cause _me_ predictable trouble as I have to deal with the
> fallout. Neither expect, that I ack patches to users of that code
> which are semantically wrong.
> 
> Just for the record, the pca953x driver is broken vs. the local state
> protection anyway as the GPIO functions are not serialized against the
> interrupt controller functions. There is no magic which prevents that,
> neither on your system nor on any other. The GPIO function should take
> buslock when modifying local state and that's one of the reasons why
> buslock it is there and cannot go away.

Ok, so the genirq buslock should be held in fx.
pca953x_gpio_direction_input and pca953x_gpio_direction_output ?
That makes sense in combination with the currently implemented
bus_sync_unlock.

But I still fail to see why it is needed, or even desired, that the
setting of direction should be related to the genirq code at all.

I see it as a sane seperation to let the actual gpio code handle
the direction setting, and the irq code to handle the (in software)
irq mask.  Driver and/or board code should be sane enough to set
pca953x gpio's as input if/when interrupts from them are needed.
And they should do this in advance.  And by doing it this way,
there should not be any hardware state to serialize, and there
actually is no pca953x driver local state either, as the pca953x_chip
members are either exclusively managed by gpio or irq code.

> I'm anticipating that you are going to tell me that it does not matter
> on your particular powerpc combined with your usage pattern (i.e no
> GPIO users). And I tell you right away, that I'm not interested in
> this answer for well explained reasons.

No, I don't tie it to my particular usage pattern. I tell you that
I don't need it (serialization) on powerpc because my pca953x powerpc
patch have removed the need for shared local state between gpio and irq
code.

Of-course, for the pca953x driver to be acceptable, it would
be nice (or more likely, required) to unify it for other archs
also, I just don't see how to do that.

That said, I will proceed with the request_any_context_irq() in the phy
driver instead :-)  Case closed for now.

/Esben


