Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0FESw4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 14:52:56 -0400
Received: from www.tglx.de ([62.245.132.106]:49152 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab0FESwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 14:52:54 -0400
Date: Sat, 5 Jun 2010 20:52:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Esben Haabendal <esbenhaabendal@gmail.com>
cc: Marc Zyngier <maz@misterjones.org>,
       Esben Haabendal <eha@doredevelopment.dk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, joachim.eastwood@jotron.com
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded
 interrupt handlers
In-Reply-To: <AANLkTimlSBEhl58CNuScKjxbqdTwTYgqo7vrHTcd1x9G@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006051915290.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk> <alpine.LFD.2.00.1006042343150.2933@localhost.localdomain> <AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com> <20100605151031.2d562268@hina.wild-wind.fr.eu.org>
 <alpine.LFD.2.00.1006051732270.2933@localhost.localdomain> <AANLkTimlSBEhl58CNuScKjxbqdTwTYgqo7vrHTcd1x9G@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Esben,

On Sat, 5 Jun 2010, Esben Haabendal wrote:

> On Sat, Jun 5, 2010 at 5:33 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Sat, 5 Jun 2010, Marc Zyngier wrote:
> >> You may want to give request_any_context_irq() a try (available since the
> >> latest merge window). It still requires your driver to be changed, but it
> >> should then work in both threaded and non-threaded cases.
> >
> > And it nicely annotates that somebody looked at the driver in
> > question. That's the rule of least surprise and does not impose checks
> > on the fast path.
> 
> What in particular should I be looking for in a driver before changing
> from request_irq() to request_any_context_irq() ?

Whether the irq handler relies on interrupts being disabled is the
most important thing. There are other constraints like
enable_irq/disable_irq calls from the driver code, which are not
allowed to run in atomic context for interrupt hanging of a i2c irq
controller.

> As for not checking in the fast path, it should be noted that this is "only"
> in handle_nested_irq(), which is only used in few interupt controller
> drivers, all of which I assume are generally not considered very "fast".

Fair enough. Still I fundamentaly dislike the automagic handling of
this and especially the irq disabled portion of it.
 
> Unless all interrupt handlers should be rewritten to be able to in both
> thread and interrupt context, I fail to se the conflict between the patch
> proposed and the work being done on request_any_context_irq().

It's not a question of conflict. It's a question of semantics.

We had and still have enough surprises in preempt-rt where we force
thread all handlers which were caused by various assumptions in the
handler code. I really prefer that the system yells in such a case
instead of letting run people into hard to debug problems silently.

The sanity check there makes the problem entirely obvious and forces
people to look at the driver for the following reasons:

 - the code has been audited for thread safety

 - the annotation of request_any_context_irq() documents that the
   audit has been done.

 - the annotation of request_any_context_irq() makes other people who
   are changing the code aware of the fact that it _is_ used in
   threaded context on some hardware.

 - in some drivers a cleanup can be done based on the threaded code,
   e.g. for drivers which use their own worker threads or rely heavily
   on workqueues.

Thanks,

	tglx
