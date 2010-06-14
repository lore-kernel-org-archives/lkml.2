Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab0FNIcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:32:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54072 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab0FNIcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:32:32 -0400
Date: Mon, 14 Jun 2010 10:32:14 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Walker <dwalker@codeaurora.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: ARM defconfig files
Message-ID: <20100614083214.GA2104@pengutronix.de>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk> <1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com> <alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[Added linux-arm-kernel ML to Cc, note that it's moderated for
non-subscribers.]

On Thu, Jun 03, 2010 at 11:21:59AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 3 Jun 2010, Daniel Walker wrote:
> > 
> > I don't see how we can do without defconfigs altogether tho. I mean , if
> > you want to run a Beagle board or a Nexus one we can't just give the
> > users a slim ARM config and let them troll through 1000's of drivers
> > trying to find just those ones that work on their given board.
> 
> Well, you also don't need the full defconfig's with the kernel.
> 
> Right now they are just noise. They actually _hide_ things, because 
> diffstat (and dirstat) information becomes pointless, and the diffs become 
> totally unreadable by any human (trust me - when the choice is between 
> "search for next relevant diff" or "blast it, I can't be bothered with 
> walking through this crap", quite often the choice is the latter).
I wrote a script that throws out all unneeded lines in all arm
defconfigs that don't influence the resulting .config for .34 and
.35-rc1 and compared .34<->.35-rc with .34-reduced<->.35-rc1-reduced.

Here are the results:

	$ git diff --dirstat v2.6.34 v2.6.35-rc1 arch/arm
	  11.8% arch/arm/configs/
	  10.0% arch/arm/mach-msm/
	  10.8% arch/arm/mach-omap2/
	   4.8% arch/arm/mach-pxa/
	   4.5% arch/arm/mach-s5pc100/
	   3.3% arch/arm/mach-s5pv210/
	   4.4% arch/arm/mach-spear3xx/
	   3.1% arch/arm/mach-ux500/
	   5.1% arch/arm/plat-s5pc1xx/
	   3.1% arch/arm/plat-samsung/
	  38.2% arch/arm/

	$ git diff --dirstat arm/defconfig/reduced-v2.6.34 arm/defconfig/reduced-v2.6.35-rc1 arch/arm
	   3.1% arch/arm/mach-davinci/
	  11.3% arch/arm/mach-msm/
	  12.2% arch/arm/mach-omap2/
	   5.4% arch/arm/mach-pxa/
	   5.1% arch/arm/mach-s5pc100/
	   3.7% arch/arm/mach-s5pv210/
	   5.0% arch/arm/mach-spear3xx/
	   3.5% arch/arm/mach-ux500/
	   5.8% arch/arm/plat-s5pc1xx/
	   3.5% arch/arm/plat-samsung/
	  40.9% arch/arm/

	$ git diff --dirstat=0 arm/defconfig/reduced-v2.6.34 arm/defconfig/reduced-v2.6.35-rc1 arch/arm | grep config
	   1.1% arch/arm/configs/

	$ git diff --shortstat v2.6.35-rc1 arm/defconfig/reduced-v2.6.35-rc1
	 177 files changed, 652 insertions(+), 194157 deletions(-)

(The insertions above are only moved lines I think, I didn't check them
all.)

The branches arm/defconfig/reduced-v2.6.34 and
arm/defconfig/reduced-v2.6.35-rc1 are available at my repo at
git://git.pengutronix.de/git/ukl/linux-2.6.git .  (There is a gitweb at
http://git.pengutronix.de/?p=ukl/linux-2.6.git)

So maintaining these minimal defconfigs would have reduced the defconfig
noise from 11.8% down to 1.1%.  And probably it could be considerably
reduced further with constructs like:

	config HAVE_MTD_NAND_MXC
		bool

	config MTD_NAND_MXC
		tristate "MXC NAND support"
		...
		default m if HAVE_MTD_NAND_MXC
		help
		  ...

	...
	config MACH_MX27ADS
		...
		select HAVE_MTD_NAND_MXC

.  Compared with selecting everything in Kconfig files this approach
allows further tweaking of a config.  (E.g. "I have a mx27ads machine,
but I don't need nand support.")  Compared with the SAT-Solver it's an
idea that works today.

One downside of this approach (when done with my script only) is that
too much is removed.  E.g. in mx3_defconfig CONFIG_ARCH_MX3 is removed.
This is OK from a logical POV but then changing the default of the
corresponding choice (and I intend to do that in the near future) would
break this defconfig.

I can share my script and I'm willing to support maintaining the
minimality of the defconfig files if they are an acceptable (maybe
intermediate) step for Linus.

Together with the efforts to reduce the number of defconfigs as thought
about in other mails of this thread the situation should become quite
better for Linus.  (I'm currently working on merging support for all
Freescale SoCs into a single mach- directory and so merge mx1_defconfig,
mx21_defconfig, mx27_defconfig, mx31pdk_defconfig, mx3_defconfig and
mx51_defconfig.)

Linus: I would really appreciate if you wouldn't remove all (or nearly
all) defconfig files.  I think you would force a quicker solution to
this problem, but during that time the ARM community would loose compile
coverage.

Thoughts on this?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
