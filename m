Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab1LFJhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:37:21 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46170 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901Ab1LFJhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:37:18 -0500
Date: Tue, 6 Dec 2011 09:37:09 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
        Pawel Moll <pawel.moll@arm.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
Message-ID: <20111206093709.GB2274@linaro.org>
References: <20111110162859.GA7088@oksana.dev.rtsoft.ru>
 <20111202192618.GC3037@localhost.localdomain>
 <CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com>
 <1322867573.11728.22.camel@pasglop>
 <20111205161157.GA27550@localhost.localdomain>
 <alpine.LFD.2.02.1112051236350.2357@xanadu.home>
 <20111205180253.GB29812@localhost.localdomain>
 <alpine.LFD.2.02.1112051310150.2357@xanadu.home>
 <20111205192605.GD29812@localhost.localdomain>
 <alpine.LFD.2.02.1112051443190.2357@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1112051443190.2357@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 02:49:01PM -0500, Nicolas Pitre wrote:

[...]

> > > > Unfortunately, NO_IRQ is often not spelled "NO_IRQ".  It looks like the assumption
> > > > "irq < 0 === no irq" may be quite a lot more widespread than "NO_IRQ === no irq".
> > > > Since there's no specific thing we can grep for (and simply due to volume)
> > > > finding all such instances may be quite a bit harder.
> > > [...]
> > > 
> > > ARgh.
> > > 
> > > My point was about current actual usage of the IRQ numbered 0 which 
> > > probably prompted the introduction of NO_IRQ in the first place.  What I 
> > > was saying is that the number of occurrences where IRQ #0 is currently 
> > > used into drivers that would get confused if 0 would mean no IRQ is 
> > > probably quite small.
> > 
> > Ah, I misunderstood -- that's a separate issue, but also an important one.
> > I guess this applies to a fair number of older boards.  One way of fixing
> > this would be to migrate those boards to use irq domains -- but those boards
> > may be sporadically maintained.
> >  
> > > But as you illustrated, there is a large number of drivers that already 
> > > assume no IRQ is < 0, even if they don't use any IRQ #0 themselves.  
> > > That is a much bigger problem to fix.
> > 
> > My concern is that as soon as we start to change this in significant
> > volume, a _lot_ of stuff is going to break.  Everywhere that an irq value
> > is passed from one piece of code to another, there is a potential
> > interface mismatch -- there seems to be no single place where we can
> > apply a conversion and fix everything.
> 
> No need to convert everything.
> 
> First move is to make irq=0 meaning no IRQ.  That means making things 
> like:
> 
> 	if (irq < 0)
> 	if (irq >= 0)
> 
> into
> 
> 	if (irq <= 0)
> 	if (irq > 0)
> 
> And replace NO_IRQ with 0.
>
> That change shouldn't break anything, except those drivers which are 1) 
> being passed an actual IRQ #0 and 2) testing for no IRQ.  I suspect that 
> those conditions aren't very common together.

To clarify, you're suggesting that the meanings of all other IRQ values
would not change initially?  (i.e., we remap HW irq 0, if there is one,
to some other random number but have a 1:1 mapping for everything else).


That could make sense as an approach.

Cheers
---Dave
