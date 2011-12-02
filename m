Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1LBJVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 04:21:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48874 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab1LBJVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 04:21:31 -0500
Date: Fri, 2 Dec 2011 10:21:24 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: add default value for PHYS_OFFSET Kconfig setting
Message-ID: <20111202092124.GR26618@pengutronix.de>
References: <1322711557-8279-1-git-send-email-paul.gortmaker@windriver.com>
 <201112011419.46751.arnd@arndb.de>
 <CAP=VYLrp1zqyOzU-xzatF3jE3wL6wBjEDMR=sEXimP2ZvkQ0Lg@mail.gmail.com>
 <alpine.LFD.2.02.1112020005270.2357@xanadu.home>
 <alpine.LFD.2.02.1112020024370.2357@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.02.1112020024370.2357@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nicolas,

On Fri, Dec 02, 2011 at 12:33:26AM -0500, Nicolas Pitre wrote:
> On Fri, 2 Dec 2011, Nicolas Pitre wrote:
> 
> > On Thu, 1 Dec 2011, Paul Gortmaker wrote:
> > 
> > > On Thu, Dec 1, 2011 at 9:19 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > > On Thursday 01 December 2011, Paul Gortmaker wrote:
> > > >> Commit 1b9f95f8ade9efc2bd49f0e7b9dc61a038ac3eef introduced the new
> > > >> Kconfig for PHYS_OFFSET but it did not specify a default value.
> > > >>
> > > >> This has the undesired side effect of breaking an implictly used
> > > >> trick for updating defconfigs on the fly for routine buildtesting
> > > >> across all arch and all platforms, i.e.
> > > >>
> > > >>   cp /path/to/somedefconfig .config ; yes "" | make oldconfig
> > > >>
> > > >
> > > > FWIW, a better way to achieve the above is using
> > > >
> > > > make KCONFIG_ALLCONFIG=/path/to/somedefconfig listnewconfig alldefconfig
> > > >
> > > > which does not have this problem.
> > > >
> > > > Your patch looks still ok, but you might want to update your scripts
> > > > to be more robust.
> > > 
> > > Thanks -- but on the other hand, the above use case does actually
> > > emulate exactly what happens when someone runs the
> > > "make oldconfig" and simply holds down the Enter key. (yes it
> > > happens probably way more than we want to know...)
> > > 
> > > So, I guess what I'm trying to say is that the above "script" is
> > > intentionally fragile.  :)  As a use case, we shouldn't break it.
> > 
> > Well... I took a while before replying because I'm also modifying things 
> > around this, but those changes are good for a merge window not a -rc 
> > period.
> > 
> > Still, I don't think your patch is good, even as a temporary measure.  
> > The fact is that we can't just pick a random default value since it is 
> > likely to be wrong for the majority of the boards as the right answer 
> > for this option is quite varied.  So the fact that the config system 
> > insists on your entering a proper value is actually a good thing.
> > 
> > In the at91x40_defconfig case, it has CONFIG_EMBEDDED=y.  If it was not 
> > selected then you'd get CONFIG_ARM_PATCH_PHYS_VIRT=y by default and then 
> > no CONFIG_PHYS_OFFSET would be presented.
> > 
> > So the right fix here would actually consist of adding to 
> > at91x40_defconfig either CONFIG_ARM_PATCH_PHYS_VIRT=y, or a default 
> > value for CONFIG_PHYS_OFFSET which is the right value for that platform.
> 
> And it seems that at91x40 is the only defconfig with MMU=n, so the only 
> option is really to provide a default CONFIG_PHYS_OFFSET.  So what about 
> this:
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index e084b7e981..a24672924f 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -222,6 +222,7 @@ config NEED_MACH_MEMORY_H
>  config PHYS_OFFSET
>  	hex "Physical address of main memory"
>  	depends on !ARM_PATCH_PHYS_VIRT && !NEED_MACH_MEMORY_H
> +	default DRAM_BASE if !MMU
>  	help
>  	  Please provide the physical address corresponding to the
>  	  location of main memory in your system.
> 
> Eventually the DRAM_BASE config option could simply be replaced by 
> PHYS_OFFSET directly, but that's a larger change.
I'm working on a MMU-less machine, too and had that change already in my
working copy. I was about to commit and it send out later today.

So: Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
