Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab1LFJa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:30:29 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33558 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901Ab1LFJa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:30:26 -0500
Date: Tue, 6 Dec 2011 09:30:00 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
        linux-ide@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
Message-ID: <20111206093000.GA2274@linaro.org>
References: <20111202192618.GC3037@localhost.localdomain>
 <CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com>
 <1322867573.11728.22.camel@pasglop>
 <20111205161157.GA27550@localhost.localdomain>
 <alpine.LFD.2.02.1112051236350.2357@xanadu.home>
 <20111205180253.GB29812@localhost.localdomain>
 <alpine.LFD.2.02.1112051310150.2357@xanadu.home>
 <4EDD1897.4030208@gmail.com>
 <20111205202125.GA32592@oksana.dev.rtsoft.ru>
 <4EDD2DE1.1050606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDD2DE1.1050606@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 02:47:29PM -0600, Rob Herring wrote:
> On 12/05/2011 02:21 PM, Anton Vorontsov wrote:
> > On Mon, Dec 05, 2011 at 01:16:39PM -0600, Rob Herring wrote:
> > [...]
> >> At least for DT enabled platforms, we could force "no irq" to be 0 in
> >> the DT irq code. Searching the dts files, I found 2 occurrences of IRQ0.
> > 
> > Please note that there are HW IRQ numbers and "Virtual" IRQ numbers.
> > dev->irq and thus the thing that we pass into request_irq() is a
> > virtual IRQ thing, a "cookie".
> > 
> > While in device tree you see real HW IRQ numbers.
> > 
> > Legal VIRQ is always > 0, while HW IRQ could be >= 0.
> > 
> 
> If this was all true, then there would be no discussion.
> 
> This is what we are working towards, but irq_chips all over the arm tree
> do not support any translation or have base fixed at compile time. Only
> a few have been converted. And some ARM platforms may never get
> converted to DT.
> 
> >> Prima2 has timer on IRQ0, and VersatileAB has watchdog on IRQ0. Prima2
> >> should be fine currently as it doesn't use the of_irq_* functions to get
> >> the timer irq, but that is an issue as it skips any translation.
> >> VersatileAB should be okay with the VIC irqdomain support.
> > 
> > It shouldn't be an issue to use of_irq_*() functions for these IRQs.
> > of_irq_*() will remap HW IRQ 0 to some other VIRQ. If it does not do
> > this currently, then it's a bug and should be fixed.
> 
> I think that's what I'm saying. It's either a bug or incomplete DT
> conversion for the platform. Either way, those should get fixed first.

Do we expect there to be any platform drivers which are shared between
legacy platforms and newer DT-ised platforms?

Those drivers would be pain points since they would need to understand
both conventions.

So far as I can see, only boards which are not DT-ised, which do not use
DT-ised drivers and which do not use drivers which use interrupts and
are either used by DT-ised boards or by arches with a non-zero NO_IRQ
could safely carry on using a non-zero NO_IRQ.  Tracking down exactly
which boards and drivers this applies to could be hard.  We could have a
CONFIG_NO_IRQ and make them depend on it, but we still have to find that
list of boards and drivers in the first place.


Otherwise, it feels like we might need a strategy for migrating pretty
much everything if we don't want to end up in a mess.

Cheers
---Dave
