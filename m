Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2FLQra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:47:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:44922 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab2FLQr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:47:28 -0400
Date: Tue, 12 Jun 2012 18:47:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] irq/core changes for v3.5
In-Reply-To: <CA+55aFxNy2-DnWVDUiOuF+NncRBUC=frZN+CTLsJ+o2ofXtZYQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1206121732230.3086@ionos>
References: <20120522032554.GA11358@gmail.com> <Pine.LNX.4.64.1206121201130.6800@axis700.grange> <alpine.LFD.2.02.1206121639420.3086@ionos> <CA+55aFxNy2-DnWVDUiOuF+NncRBUC=frZN+CTLsJ+o2ofXtZYQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2012, Linus Torvalds wrote:

> On Tue, Jun 12, 2012 at 5:56 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Thinking more about it, it's probably the best thing to simply force
> > the IRQF_ONESHOT flag if it's missing.
> 
> No, that's just crazy.
> 
> Now you make broken shit code work, and then you break the *correct*
> code that didn't want threading and didn't set IRQF_ONESHOT.

That correct code is totally unaffected. We only force set it for the
case which *requests* a threaded irq w/o a primary handler and w/o
supplying the ONESHOT flag.

> Just face it: if somebody doesn't have an interrupt-time function
> pointer, they need to rethink their code. It's a mistake. It's broken
> shit.

We explicitely made it that way to prevent people from implementing
the same function which just returns IRQ_WAKE_THREAD over and over.

This was done in the first place for irqs where the device which
raised the interrupt cannot be accessed from hard interrupt context
(stuff behind serial busses, i2c, spi ....)

The only choice those people had before we provided threaded
interrupts in the core was having a primary handler which called
disable_irq_nosync() and then woke an handling thread, which then
reenabled the irq line with enable_irq().

That allowed us to remove a lot of crappy, broken and racy kthread
code from drivers that way and consolidated the handling into the core
code.

Yes, in hindsight I should have enforced IRQF_ONESHOT for those
callers which have a NULL primary handler right from the beginning,
but that doesn't help much now.

> Why pander to crap? What is the advantage of allowing people to think
> that they don't need an interrupt-time function? It's a fundamentaly
> broken model, since it *cannot* work tgether with another driver that
> wants to have the normal semantics and happens to share the irq.

The vast majority of that stuff is embedded. Shared interupt lines are
almost non existent in that space. It's just x86 which is full of that
shared nonsense.

If it's shared between a normal semantics device and one which
requires the oneshot semantics, the core has already a sanity check
for those cases and always had.

If you really need a threaded handler which shares the interrupt line
with a non threaded one, then you definitely need a primary handler
which can disable the irq at the device level, but that was always
a requirement.

I just checked all the drivers in question with coccinelle.

Only a total of 8 drivers set IRQF_SHARED. 5 of them are for the same
ARM platform on which none of the irqs can be shared. So IRQF_SHARED
there is bogus. One other is for ARM stuff as well, which does not
have shared interrupts either. The two remaining are "general purpose"
drivers which also originated from embedded and are unlikely to show
up on a PC platform.

I did not bother to check the few ones which use platform data, but
those are definitely embedded ones as well, which won't have shared
interrupts either.

So now we have the choice of:

   - Leaving the current check and regress 90+ drivers

   - Leaving the current check and fix 90+ broken drivers

   - Reverting it and end up with no protection at all

   - Forcing the flag and risking the wreckage of two oddball drivers
     _IF_ they ever show up on a PC platform.

I definitely prefer option #4 as it makes the most sense.

Thanks,

	tglx
