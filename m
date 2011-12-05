Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab1LESDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:03:03 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39103 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab1LESDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:03:00 -0500
Date: Mon, 5 Dec 2011 18:02:53 +0000
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
Message-ID: <20111205180253.GB29812@localhost.localdomain>
References: <20111110162859.GA7088@oksana.dev.rtsoft.ru>
 <20111202192618.GC3037@localhost.localdomain>
 <CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com>
 <1322867573.11728.22.camel@pasglop>
 <20111205161157.GA27550@localhost.localdomain>
 <alpine.LFD.2.02.1112051236350.2357@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1112051236350.2357@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 12:40:16PM -0500, Nicolas Pitre wrote:
> On Mon, 5 Dec 2011, Dave Martin wrote:
> > On Sat, Dec 03, 2011 at 10:12:53AM +1100, Benjamin Herrenschmidt wrote:
> > > On Fri, 2011-12-02 at 11:28 -0800, Linus Torvalds wrote:
> > > > Don't *change* NO_IRQ to zero (that whole #define is broken - leave it
> > > > around as a marker of brokenness), just start removing it from all the
> > > > ARM drivers that use the OF infrastructure. Which is presumably not
> > > > all that many yet.
> > > > 
> > > > So whenever you find breakage, the fix now is to just remove NO_IRQ
> > > > tests, and replace them with "!irq".
> > > 
> > 
> > Russell, do you know whether it would make sense to set a timeline for 
> > removing NO_IRQ from ARM platforms and migrating to 0 for the no-interrupt
> > case?  I'm assuming that this mainly involves migrating existing hard-wired
> > code that deals with interrupt numbers to use irq domains.
> 
> How many drivers do use IRQ #0 to start with?  We might discover that in 
> practice there is only a very few cases where this is an issue if 0 
> would mean no IRQ.

The total number of files referring to NO_IRQ is not that huge:

arch/arm/	188 matches in 39 files
drivers/	174 matches in 84 files

Unfortunately, NO_IRQ is often not spelled "NO_IRQ".  It looks like the assumption
"irq < 0 === no irq" may be quite a lot more widespread than "NO_IRQ === no irq".
Since there's no specific thing we can grep for (and simply due to volume)
finding all such instances may be quite a bit harder.

For example, git grep 'irq.*\(>=\|<[^=]\) *0' gives

drivers/	435 matches in 314 files
arch/arm/	18 matches in 15 files

A few examples:
drivers/input/mouse/pxa930_trkball.c:   if (irq < 0) {
drivers/input/keyboard/tegra-kbc.c:     if (irq < 0) {
drivers/crypto/omap-sham.c:     if (dd->irq >= 0)

...etc., etc., although there are probably a fair number of false positives here.


whereas git grep 'irq.*\(<\|>\|<=\|>=\|==\|!=\) \+-1' gives

drivers/	68 matches in 28 files
arch/arm/	18 matches in 15 files

Examples: 


...and that's just the code which is C and is also kind enough to put
irq numbers in variables with names containing "irq".

It also doesn't catch people initialising variables or struct/array
members to -1, unadorned "-1" arguments to functions and so on... though
those are likely to appear in mostly the same files matching the above
expressions, it won't be an exact 1:1 correspondence.


Cheers
---Dave
