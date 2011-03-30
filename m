Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab1C3TVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:21:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932169Ab1C3TVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:21:53 -0400
MIME-Version: 1.0
In-Reply-To: <201103301906.42429.arnd@arndb.de>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Mar 2011 12:21:32 -0700
Message-ID: <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 10:06 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> I'm still new to the ARM world, but I think one real problem is the way
> that all platforms have their own trees with a very flat hierarchy --
> a lot of people directly ask Linus to pull their trees, and the main
> way to sort out conflicts is linux-next. The number of platforms in the
> ARM arch is still increasing, so I assume that this only gets worse.

As far as I'm concerned, the biggest issuee is that some of the ARM
crap is just CRAP. It's idiotic tables that get updated by multiple
people, and in totally nonsensical ways. When I see conflicts in those
damn clock-data files, I just go mental. Those files are an
abomination.

Why the hell is the clock-data for fifty (number taken out of my ass)
different clocking rules in one array? And why do we have eight
different files of that kind of crap for omap2?

THAT is an example of something that is totally and utterly screwed
up. Those kinds of random board-level detail files abound in the ARM
tree. They should either be in a per-board file, or (much better) the
ARM people should have standardized this ten f*cking years ago, and
put it in a bootloader or something that just initializes the crap so
that the kernel doesn't have to have random tables like that at all.

ARM right now i a nightmare, and most of it is because ARM hardware
manufacturers are morons. But the way the ARM tree is then laid out
has made that even more painful, and the decision to put all the crazy
board details in the kernel tables instead of trying to have a
per-board boot loader that fills in the details is just crazy.

Look at the dirstat for arch/ in just the current merge window
(cut-off at 5% just to not get too much):

[torvalds@i5 linux]$ git diff -C --dirstat=5 --cumulative v2.6.38.. arch
  14.0% arch/arm/mach-omap2/
   5.8% arch/arm/plat-mxc/include/mach/
   6.3% arch/arm/plat-mxc/
  57.1% arch/arm/
   5.4% arch/m68k/
   9.6% arch/unicore32/
   6.9% arch/x86/
 100.0% arch/

almost *SIXTY* percent of all arch updates were to ARM code. And
that's despite the fact that one of those architectures (unicore32) is
a totally new architecture, and despite m68k having gone through a
first-level unification of nommu and mmu code!

And was this just a fluke? No. Doing the same for 2.3.37..38 gives
58.3% for arch/arm (and in that release we had a blackfin unification
effort, otherwise arm would have been an even bigger percentage).

That's ridiculous. It's entirely due to the whole f*cked-up arm ecosystem.

Something needs to be done. A small part is to make sure the source
code is more hierarchical, so that we don't have those crazy shared
data-files that are ugly as hell and get conflicts because different
boards all think they need to care.

But the larger problem is that somebody really REALLY needs to think
about how to get those crazy board details out of the kernel entirely.
Having per-board drivers for real hardware is sane - having to have
per-board detail files for clock chips is just crazy. Split off that
thing a "Linux ARM second-stage bootloader" project that has the
per-board tables or something. Don't pollute the main kernel with
crazy details like this.

Because as far as I can tell, most of that board support really is
about crazy details that the kernel shouldn't even care about. Come up
with a table that describes them, have one common parsing routine, and
push the table into a bootloader. And get rid of having to add a board
file for every crazy random piece of hardware that nobody really cares
about.

Or something.

                          Linus
