Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030375Ab2LIC6E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 21:58:04 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:59080 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030353Ab2LIC6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 21:58:01 -0500
Date: Sat, 8 Dec 2012 19:57:48 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Orion: Hoist bridge interrupt handling out of the
 timer
Message-ID: <20121209025748.GA10405@obsidianresearch.com>
References: <20121207225507.GB29262@obsidianresearch.com>
 <20121208112624.GD25315@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121208112624.GD25315@lunn.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2012 at 12:26:24PM +0100, Andrew Lunn wrote:
 
> 1) It should have an IRQ domain, like the other IRQ chips we have.
> 2) It should have a DT binding, like the other IRQ chips we have.

I was going to look at a DT binding for this as a follow on, since
I'll want to bind to these interrupts. 

Are you OK with keeping this patch as is and seeing DT in a follow up,
or as a series? It is already pretty big.

> 4) We than pass the watchdog interrupt via DT.

Right now the watchdog driver is coded to cause a board reset, so it
doesn't use interrupts at all. Adding interrupt support to watchdog
seems orthogonal to this?

What would it look like? For my boards I want the watchdog to panic(),
because I have another watchdog that takes care of reset, but that
won't be universal.

> We plan to remove old style platforms in the next few cycles, so its

Yay :)

> 3) We then pass the timer interrupt via DT to the timer driver.
> 3) is not so simple, because we currently don't have a timer binding
> for Orion SoC. However, with this cleanup, we are much closer to being
> able to use the 370/XP timer code.

Interesting.. The 370/XP is a more advanced version of the same timer
IP, there are several registers that driver is touching that are not
HW supported, at least on kirkwood.

It would be straightforward to add a binding in the style of
time-armada-370-xp.c, I can probably send that as a third patch.

The two DT bindings are straightforward, and my testing on Kirkwood
should cover alot - but it would be great if non-kirkwood boards could
review/test with this patch..

Do you expect a DT conversion for all orion_time_init users, or just
the one I can test or ..?

> > @@ -534,8 +535,9 @@ static void __init kirkwood_timer_init(void)
> >  {
> >  	kirkwood_tclk = kirkwood_find_tclk();
> >  
> > -	orion_time_init(BRIDGE_VIRT_BASE, BRIDGE_INT_TIMER1_CLR,
> > -			IRQ_KIRKWOOD_BRIDGE, kirkwood_tclk);
> > +	orion_bridge_irq_init(IRQ_KIRKWOOD_BRIDGE, IRQ_KIRKWOOD_BRIDGE_START,
> > +			      BRIDGE_CAUSE);
> > +	orion_time_init(IRQ_KIRKWOOD_BRIDGE_TIMER1, kirkwood_tclk);
> >  }
> 
> I think it would be better to do this in kirkwood_init_irq(). Same for
> the other platforms. 

Yes.. I left it like this because it is very easy to audit that it is
correct (ie called, and called at the correc time). When DT support is
added this will have to change again, so expecting that the next patch
will have to change things so orion_bridge_irq_init is not called for
the DT case, and the patch after so orion_time_init is not called for
the DT case, are you OK with this patch leaving it here?

> > +	u32 cause;
> > +	int i;
> > +
> > +	cause = readl(gc->reg_base) & readl(gc->reg_base + 4);
> 
> Could you add a #define for this 4. I guess its an interrupt enable
> mask? Could regs.mask be used?

I will add a define, regs.mask could be used, but since the value is
known and constant I left it as a constant as a micro-optimization.

> > +	gc = irq_alloc_generic_chip("orion_irq_edge", 1, irq_start,
> 
> Maybe the name orion_bridge would be better?

Sure

Thanks,
Jason
