Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab1LEQMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:12:12 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52364 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab1LEQMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:12:09 -0500
Date: Mon, 5 Dec 2011 16:11:57 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
Message-ID: <20111205161157.GA27550@localhost.localdomain>
References: <20111110162859.GA7088@oksana.dev.rtsoft.ru>
 <20111202192618.GC3037@localhost.localdomain>
 <CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com>
 <1322867573.11728.22.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322867573.11728.22.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 03, 2011 at 10:12:53AM +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2011-12-02 at 11:28 -0800, Linus Torvalds wrote:
> > On Fri, Dec 2, 2011 at 11:26 AM, Dave Martin <dave.martin@linaro.org> wrote:
> > >
> > > This is now broken on ARM where, for good or bad, NO_IRQ currently is
> > > used and is -1.
> > >
> > > How do we resolve it?  If we are ready to eliminate NO_IRQ from
> > > drivers/of/irq.c (or indeed, all code that uses it) and just use 0 for
> > > that case, we should surely just do it... but I'm not confident I can
> > > judge on that.
> > 
> > Just stop using NO_IRQ. First in drivers/of/irq.c, then in any drivers
> > as you notice breakage.
> 
> Agreed. In fact the whole hack in drivers/of/irq.c was to accomodate ARM
> which still uses -1, powerpc changed to 0 a long time ago.
> 
> Now that we have a generic remapper between HW and "linux" IRQ numbers,
> there is no reason to stick to -1 even on ARM.
> 
> > Don't *change* NO_IRQ to zero (that whole #define is broken - leave it
> > around as a marker of brokenness), just start removing it from all the
> > ARM drivers that use the OF infrastructure. Which is presumably not
> > all that many yet.
> > 
> > So whenever you find breakage, the fix now is to just remove NO_IRQ
> > tests, and replace them with "!irq".
> 

Russell, do you know whether it would make sense to set a timeline for 
removing NO_IRQ from ARM platforms and migrating to 0 for the no-interrupt
case?  I'm assuming that this mainly involves migrating existing hard-wired
code that deals with interrupt numbers to use irq domains.

I worry that if we just change the convention for the OF case, we'll end
up with OF-ised platform drivers which have to deal with a different no-
irq convention depending on whether they are probed as platform drivers
or through the OF framework ... and these ported or semi-ported drivers
will be intermixed with unported drivers, confusing maintainers.
 
If board code starts initialising platform data for non-OF-ised platform
drivers based on IRQ numbers fetched via the OF code, things will get
even more confused...

Cheers
---Dave

