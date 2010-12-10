Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0LJPos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:44:48 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41387 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab0LJPor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:44:47 -0500
Date: Sat, 11 Dec 2010 00:43:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Huewe <peterhuewe@gmx.de>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/wm831x-irq: Convert to new irq_chip functions and fix build failure
Message-ID: <20101210154332.GB21712@linux-sh.org>
References: <1291937687-20243-1-git-send-email-peterhuewe@gmx.de> <12ABA93B-6923-4AF7-BF34-E070BE72A8E2@opensource.wolfsonmicro.com> <alpine.LFD.2.00.1012100233510.2653@localhost6.localdomain6> <20101210050755.GA21712@linux-sh.org> <20101210121420.GC3200@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210121420.GC3200@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 12:14:21PM +0000, Mark Brown wrote:
> On Fri, Dec 10, 2010 at 02:07:55PM +0900, Paul Mundt wrote:
> > On Fri, Dec 10, 2010 at 02:39:55AM +0100, Thomas Gleixner wrote:
> > > # git grep GENERIC_HARDIRQS_NO_DEPRECATED arch/
> > > arch/sh/Kconfig:        select GENERIC_HARDIRQS_NO_DEPRECATED
> 
> Oh dear.  Can anyone comment on why SH is selecting this?  My first
> thought is that the savings from enabling it are going to be on the
> small side so it wouldn't be a big issue to leave it off for 2.6.37
> and possibly 2.6.38 also.
> 
The "savings" are largely triggering these sorts of issues, where anyone
using deprecated functionality blows up the build and gets fixed up
incrementally, as well as stopping people from adding new users of the
deprecated API.

> If we're going to start enabling this on platforms I'd also suggest that
> we enable it on x86 in -next so that we get reasonable coverage from
> build tests.  It needs to be enabled on a major architecture to catch
> the change during development.
> 
Yes, well, now you've gotten reports on it being a build issue and your
first thought is to jut disable the option instead of marking the
deprecated API dependence as explicit in the driver? This has absolutely
nothing to do with development, it has to do with the fact the driver is
using an API that is flagged as deprecated, and going forward
architectures are going to begin to opt-in to having the deprecated parts
of the generic hardirq framework disabled outright. SH happened to be the
first to get there, but others will follow suit.

> > > Though the question remains, whether this driver is actually used with
> > > sh platforms. If yes, then pushing the already existing change to
> 
> It's not just this driver - I'd expect everything with an interrupt
> controller in drivers/mfd to have an issue here, and I don't think
> disabling them all on SH for this release is such a good approach.
> 
Again, none of this has anything to do with SH, so pretending like it an
SH "issue" is disingenuous at best. All of the offending drivers already
have a GENERIC_HARDIRQS dependency, adding a dependency that also depends
on the deprecated support for each of these doesn't exactly strike me as
being an undue burden. It is after all your driver and not my
architecture that depends on deprecated support.

> > There are no current SH boards that are using this MFD, but there's
> > certainly no technical reason for why there can't be. I'd rather avoid an
> > artificial !SH dependency, but adding in something like
> 
> > 	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
> 
> > for .37 would be fine. We do build randconfigs and so on quite regularly,
> > so it would obviously be nice not to have this break the build.
> 
> I'd rather not do that, certainly not for everything.

You depend on deprecated support, so what exactly is the issue? Are you
just not going to fix this until an architecture you are building for
happens to trigger this for you instead? You depend on a deprecated
subset of the generic hardirqs framework that has a matching Kconfig
symbol associated with it, I'm not sure how much more black and white you
want the dependency chain to be. Ideally these should have all been
flagged with a deprecated dependency when irq_chip got overhauled, but
some things do slip through.

In any event, I'm certainly not going to re-enable deprecated support to
satisfy a bunch of crap drivers with broken dependencies.
