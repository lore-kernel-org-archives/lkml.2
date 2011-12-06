Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab1LFLhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:37:45 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49604 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207Ab1LFLhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:37:43 -0500
Date: Tue, 6 Dec 2011 11:37:35 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pawel Moll <pawel.moll@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
        linux-ide@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
Message-ID: <20111206113735.GC2274@linaro.org>
References: <CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com>
 <1322867573.11728.22.camel@pasglop>
 <20111205161157.GA27550@localhost.localdomain>
 <alpine.LFD.2.02.1112051236350.2357@xanadu.home>
 <20111205180253.GB29812@localhost.localdomain>
 <alpine.LFD.2.02.1112051310150.2357@xanadu.home>
 <20111205192605.GD29812@localhost.localdomain>
 <alpine.LFD.2.02.1112051443190.2357@xanadu.home>
 <20111206093709.GB2274@linaro.org>
 <20111206104654.GN14542@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206104654.GN14542@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 10:46:54AM +0000, Russell King - ARM Linux wrote:
> On Tue, Dec 06, 2011 at 09:37:09AM +0000, Dave Martin wrote:
> > To clarify, you're suggesting that the meanings of all other IRQ values
> > would not change initially?  (i.e., we remap HW irq 0, if there is one,
> > to some other random number but have a 1:1 mapping for everything else).
> 
> Even better.  Avoid the first 16 IRQ numbers altogether - so that ISA
> drivers which have these numbers hard-encoded in them will see failures
> if they're expecting standard ISA IRQ numbering.
> 
> We already do that with the GIC, partly because of the hardware design.
> We do that on Footbridge based systems, because they may or may not have
> a real ISA IRQ controller.
> 
> But.. let's make one thing clear: Alan Cox and Linus have been going on
> about how IRQ0 should not be used.  Let's be crystal clear: even x86
> uses IRQ0.  It happens to be the PIC timer, and that gets claimed early
> on during the x86 boot.  So please don't tell me that x86 avoids IRQ0.
> It doesn't.  It just happens that x86 never shows IRQ0 to anything but
> the i8253 PIC driver.
> 
> So lets see how x86 squeels if we make the i8253 PIC driver reject IRQ0.
> I bet that there'd be absolute fury at such a suggestion.
> 
> When x86 sorts this out, there _might_ be some more motivation to take
> such comments seriously.  Until then it's more like a joke.

OK -- but the situation is breaking OF-based drivers on ARM platforms
today.

Based on what you've suggested, does the following policy sound
reasonable for resolving that deadlock?


1) All OF code and drivers should be migrating to use 0 instead of NO_IRQ
   for the no-interrupt case.  Code which receives irq numbers directly
   from the OF framework and refers to NO_IRQ, or expects 0 to be a valid
   needs to be fixed.

2) Where we hit a problem, board code needs to be adapted to remap HW IRQs
   0-15 to different software values.  (This could be done using irq
   domains, or not)


I'm still not sure what the correct approach is for drivers which get
irq numbers from OF indirectly -- this particularly applies to platform
and AMBA devices.

If we expect board code to start populating platform data based on 
information from the OF code, we need to fix the board not to use linux
irq 0 to describe a real HW interrupt, if it matters (as in (2)).

AMBA devices registered via of_platform_populate() already get their
irq numbers from OF.  So long as OF used to explicitly return NO_IRQ
there was no problem -- but if OF is moving to return 0 instead, we have
a potential problem for each AMBA driver which may be used by a board
which can boot without DT... if we have any scenarios where that driver
is given real irq 0.

Maybe we can fix these breakages as they occur -- I don't really know
the scale of the impact.


What are your thoughts on this?

Cheers
---Dave
