Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab0FEUOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 16:14:52 -0400
Received: from www.tglx.de ([62.245.132.106]:54275 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab0FEUOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 16:14:51 -0400
Date: Sat, 5 Jun 2010 22:14:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Esben Haabendal <esbenhaabendal@gmail.com>
cc: Marc Zyngier <maz@misterjones.org>,
       Esben Haabendal <eha@doredevelopment.dk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, joachim.eastwood@jotron.com
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded
 interrupt handlers
In-Reply-To: <AANLkTimcB9vRqnNYyBh6hjHXZHcmFvw72MZUEIGfeexq@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006052155100.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk> <alpine.LFD.2.00.1006042343150.2933@localhost.localdomain> <AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com> <20100605151031.2d562268@hina.wild-wind.fr.eu.org>
 <alpine.LFD.2.00.1006051732270.2933@localhost.localdomain> <AANLkTimlSBEhl58CNuScKjxbqdTwTYgqo7vrHTcd1x9G@mail.gmail.com> <alpine.LFD.2.00.1006051915290.2933@localhost.localdomain> <AANLkTimcB9vRqnNYyBh6hjHXZHcmFvw72MZUEIGfeexq@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010, Esben Haabendal wrote:
> On Sat, Jun 5, 2010 at 8:52 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Esben,
> >
> > On Sat, 5 Jun 2010, Esben Haabendal wrote:
> >
> >> On Sat, Jun 5, 2010 at 5:33 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> > On Sat, 5 Jun 2010, Marc Zyngier wrote:
> >> >> You may want to give request_any_context_irq() a try (available since the
> >> >> latest merge window). It still requires your driver to be changed, but it
> >> >> should then work in both threaded and non-threaded cases.
> >> >
> >> > And it nicely annotates that somebody looked at the driver in
> >> > question. That's the rule of least surprise and does not impose checks
> >> > on the fast path.
> >>
> >> What in particular should I be looking for in a driver before changing
> >> from request_irq() to request_any_context_irq() ?
> >
> > Whether the irq handler relies on interrupts being disabled is the
> > most important thing. There are other constraints like
> > enable_irq/disable_irq calls from the driver code, which are not
> > allowed to run in atomic context for interrupt hanging of a i2c irq
> > controller.
> 
> Yes, I were hit by this also.
> 
> The phy interrupt handler calls disable_irq, which does not work
> with an i2c irq controller (ie. the genirc buslock mutex), and I specifically
> got rid of the buslock for pca9535 driver (powerpc only, though).

And that's the fundamentally wrong approach.
 
> This is really a drawback of the genirq buslock IMHO.

No, it avoids races even on UP. It's there for a reason and there was
a huge discussion about this last year.

Just because you have not hit the problem yet does not make it non
existant.

> >> As for not checking in the fast path, it should be noted that this is "only"
> >> in handle_nested_irq(), which is only used in few interupt controller
> >> drivers, all of which I assume are generally not considered very "fast".
> >
> > Fair enough. Still I fundamentaly dislike the automagic handling of
> > this and especially the irq disabled portion of it.
> 
> Yes, it would be better to not have irq disabled.
> But not really much worse than with other interrupt controllers,
> where the handler would be running in interrupt context anyway.

That's a totally different playground.
 
> So until all handlers are rewritten to run threaded, I believe
> something like the proposed patch will give value to people
> with i2c irq controllers. Hopefully, not to many people are unlucky
> enough to have this, but anyway...

No it does not, as it just encourages people to disable buslocks and
do simliar shitty crap. 
 
> >> Unless all interrupt handlers should be rewritten to be able to in both
> >> thread and interrupt context, I fail to se the conflict between the patch
> >> proposed and the work being done on request_any_context_irq().
> >
> > It's not a question of conflict. It's a question of semantics.
> >
> > We had and still have enough surprises in preempt-rt where we force
> > thread all handlers which were caused by various assumptions in the
> > handler code. I really prefer that the system yells in such a case
> > instead of letting run people into hard to debug problems silently.
> 
> I fully appreciate that.  And for exactly that reason (combined with
> a tight timeschedule), I really just need to have the phy interrupt handler
> running unchanged with the i2c irq controller.

Yeah, and at the same time you rip out the buslock. Why are you not
sending this patch as well ? Simply because you know that it is
utterly wrong and a horrible hack. 

But at the same time you want to sell me a patch which rips out the
prevention mechanism for your hack. 

The time you spent to fiddle with the generic code and ripping out the
buslock is probably more than it had taken to make the PHY driver
thread safe.

The buslock is there for a reason and if you can't use the code with
the disable/enable_irq() in the atomic context, then this needs to be
fixed there if you need to run the irq handler in thread context.

Sorry, no dice.

Thanks,

	tglx
