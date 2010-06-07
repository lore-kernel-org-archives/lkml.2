Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab0FGXSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 19:18:43 -0400
Received: from www.tglx.de ([62.245.132.106]:60047 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab0FGXSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 19:18:42 -0400
Date: Tue, 8 Jun 2010 01:18:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Esben Haabendal <esbenhaabendal@gmail.com>
cc: Esben Haabendal <eha@doredevelopment.dk>, linuxppc-dev@ozlabs.org,
       Marc Zyngier <maz@misterjones.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, joachim.eastwood@jotron.com,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded
 interrupt handlers
In-Reply-To: <AANLkTilPhof5cnhBCXSzKJSnWl6Vuu2fRts2pBBBNl6K@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006080015570.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk> <alpine.LFD.2.00.1006042343150.2933@localhost.localdomain> <AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com> <20100605151031.2d562268@hina.wild-wind.fr.eu.org>
 <alpine.LFD.2.00.1006051732270.2933@localhost.localdomain> <AANLkTimlSBEhl58CNuScKjxbqdTwTYgqo7vrHTcd1x9G@mail.gmail.com> <alpine.LFD.2.00.1006051915290.2933@localhost.localdomain> <AANLkTimcB9vRqnNYyBh6hjHXZHcmFvw72MZUEIGfeexq@mail.gmail.com>
 <alpine.LFD.2.00.1006052155100.2933@localhost.localdomain> <AANLkTik2so7osQJFq6NRaIFK2GVLURVozOqSsejd1K0F@mail.gmail.com> <alpine.LFD.2.00.1006062228120.2933@localhost.localdomain> <1275914058.2818.8.camel@eha.doredevelopment.dk>
 <alpine.LFD.2.00.1006071440520.2933@localhost.localdomain> <AANLkTilPhof5cnhBCXSzKJSnWl6Vuu2fRts2pBBBNl6K@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jun 2010, Esben Haabendal wrote:
> On Mon, Jun 7, 2010 at 5:06 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Maybe you understand now, why I was pretty sure upfront, that your
> > approach was wrong even without knowing all the gory details ? :)
> 
> I understand.  There is a better solution, which is to use threaded
> interrupts where needed.
> 
> But I must confess that I am disappointed that you still fail to see
> how the pca953x
> patch actually eliminates the need for serialization. But I don't
> think there is much
> point in going on about that.

I return the favour of being disappointed that you are still failing
to accept that there is a fundamental difference between "it works in
a particular case" and semantical correctness under all
circumstances.

There is no place for "it works in a particular case" in a kernel
which runs on a gazillion of different devices unless you want to
create a complete unmaintainable mess. The only way to avoid this is
to be strict about semantics even if it seems unsensible for a
particular case.

Also I explained it to you in great length, that your patch violates
the semantical guarantees of existing functions, but you ignore that
completely.

It's Open Source, go wild and change it for your particular case - but
don't expect that I accept patches to the generic irq code which will
cause _me_ predictable trouble as I have to deal with the
fallout. Neither expect, that I ack patches to users of that code
which are semantically wrong.

Just for the record, the pca953x driver is broken vs. the local state
protection anyway as the GPIO functions are not serialized against the
interrupt controller functions. There is no magic which prevents that,
neither on your system nor on any other. The GPIO function should take
buslock when modifying local state and that's one of the reasons why
buslock it is there and cannot go away.

I'm anticipating that you are going to tell me that it does not matter
on your particular powerpc combined with your usage pattern (i.e no
GPIO users). And I tell you right away, that I'm not interested in
this answer for well explained reasons.

> Oh, I still think that the disable_irq_nosync documentaiton is misleading.
> Functions that are allowed in a particular context should not call functions
> that are not allowed to be called in that context. But now I know :-)

As I said before: I agree and I'm happy to accept a patch to fix that
documentation problem.

Thanks,

	tglx
