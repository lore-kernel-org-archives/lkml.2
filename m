Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab0LJRYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:24:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49770 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750916Ab0LJRYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:24:14 -0500
Date: Fri, 10 Dec 2010 17:24:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Huewe <peterhuewe@gmx.de>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/wm831x-irq: Convert to new irq_chip functions and
 fix build failure
Message-ID: <20101210172407.GF3200@rakim.wolfsonmicro.main>
References: <1291937687-20243-1-git-send-email-peterhuewe@gmx.de>
 <12ABA93B-6923-4AF7-BF34-E070BE72A8E2@opensource.wolfsonmicro.com>
 <alpine.LFD.2.00.1012100233510.2653@localhost6.localdomain6>
 <20101210050755.GA21712@linux-sh.org>
 <20101210121420.GC3200@rakim.wolfsonmicro.main>
 <20101210154332.GB21712@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210154332.GB21712@linux-sh.org>
X-Cookie: Well thaaaaaaat's okay.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 12:43:32AM +0900, Paul Mundt wrote:
> On Fri, Dec 10, 2010 at 12:14:21PM +0000, Mark Brown wrote:

> > Oh dear.  Can anyone comment on why SH is selecting this?  My first
> > thought is that the savings from enabling it are going to be on the
> > small side so it wouldn't be a big issue to leave it off for 2.6.37
> > and possibly 2.6.38 also.

> The "savings" are largely triggering these sorts of issues, where anyone
> using deprecated functionality blows up the build and gets fixed up
> incrementally, as well as stopping people from adding new users of the
> deprecated API.

OK, so disabling this for 2.6.37 and reenabling in -next wouldn't cause
any substantial disrupton to SH?  As I say I would also argue in favour
of enabling on x86 if we're pushing the changeover aggressively (Thomas
did indicate that he wants to do this, I'd send a patch but I'm unlikely
to have the time to do sufficient build testts on that platform).

> > If we're going to start enabling this on platforms I'd also suggest that
> > we enable it on x86 in -next so that we get reasonable coverage from
> > build tests.  It needs to be enabled on a major architecture to catch
> > the change during development.

> Yes, well, now you've gotten reports on it being a build issue and your
> first thought is to jut disable the option instead of marking the
> deprecated API dependence as explicit in the driver? This has absolutely

No, not at all.  As I mentioned in my previous posting this particular
driver has already been converted to use the new API (I posted the
patches about a month ago), as have all the other drivers I'm
responsible for.  What I'm saying is that doing the conversion for this
and all the other affected drivers at this point in the 2.6.37 release
cycle seems rather invasive.

The changes should be straightforward enough, and I'm reasonably happy
those I've implemented have had enough testing to be backported, but
there's a reasonable number of other drivers that are affected and the
changes aren't quite trivial enough to make the balance of risk from
introducing them right now seem good to me.

> nothing to do with development, it has to do with the fact the driver is
> using an API that is flagged as deprecated, and going forward
> architectures are going to begin to opt-in to having the deprecated parts
> of the generic hardirq framework disabled outright. SH happened to be the
> first to get there, but others will follow suit.

The API was introduced and the old one flagged as deprecated during the
2.6.37 merge window so SH has been rather...  prompt in implementing and
enforcing the conversion.  2.6.37-rc1 was the first kernel that had the
new operations for drivers to use so implementations of this would have
had to go into Linus-destined trees after the merge window or done cross
tree merges with the genirq tree prior to then.  The normal expectation
with such an API change would be that conversions would be done once the
change had propagated through Linus' tree into the relevant development
tree for the driver and only appear in mainline in the following merge
window.

I agree we should do the conversion, and if you look in -next you'll see
that I've been doing active work on carrying out the conversion for
platforms and devices I've been working on (Lennert Buytenhek did some
patches covering arch/arm so that ground to a halt a bit), but it really
doesn't seem at all realistic to expect that all cross-platform drivers
will have been converted in 2.6.37.

> > It's not just this driver - I'd expect everything with an interrupt
> > controller in drivers/mfd to have an issue here, and I don't think
> > disabling them all on SH for this release is such a good approach.

> Again, none of this has anything to do with SH, so pretending like it an
> SH "issue" is disingenuous at best. All of the offending drivers already
> have a GENERIC_HARDIRQS dependency, adding a dependency that also depends
> on the deprecated support for each of these doesn't exactly strike me as
> being an undue burden. It is after all your driver and not my
> architecture that depends on deprecated support.

It's an SH issue in the sense that SH has turned this option on in
Linus' tree very quickly, causing integration issues.

> > > for .37 would be fine. We do build randconfigs and so on quite regularly,
> > > so it would obviously be nice not to have this break the build.

> > I'd rather not do that, certainly not for everything.

> You depend on deprecated support, so what exactly is the issue? Are you
> just not going to fix this until an architecture you are building for
> happens to trigger this for you instead? You depend on a deprecated

Not at all; like I say the conversion for this particular driver is
already done but in -next rather than in Linus' tree.

> subset of the generic hardirqs framework that has a matching Kconfig
> symbol associated with it, I'm not sure how much more black and white you
> want the dependency chain to be. Ideally these should have all been
> flagged with a deprecated dependency when irq_chip got overhauled, but
> some things do slip through.

I agree that when the Kconfig option was introduced it should also have
included updates to all the relevant IRQ controller drivers and/and or
platforms, though reading the changelog for the relevant commit it seems 
clear that the intention was to provide a testing facility rather than
have the option turned on immediately so it's easy to understand why
that happened.

> In any event, I'm certainly not going to re-enable deprecated support to
> satisfy a bunch of crap drivers with broken dependencies.

I think your characterisation of unconverted drivers as "crap" is
unreasonable.  As far as I can tell the first hint that any of the
affected maintainers had that SH (or any other platform) would be
making the conversion mandatory was Peter's patch and as I discussed
above the fact that the change was only introduced into mainline during
the merge window would make conversion by the driver maintainers for
2.6.37 surprising.  Had this been so urgent that it should be done
immediately I'd have expected to see active efforts being made to push
implementation the conversion, starting from before the last merge
window, but that didn't happen at all.

Please reconsider in view of all the above.  I've no personal problem
with introducing this in -next, though I would welcome more active
efforts from platforms enabling the option to test, but I have issues
with doing so in 2.6.37.  If you refuse to disable this in the SH config
I'd much rather cherry pick the relevant changes over to Linus' tree
than leave them broken on SH for a release, though I'd personally not be
too happy about doing the same for other things where the patches
haven't been kicking around in -next.
