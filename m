Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab2KVWbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:31:46 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49161 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758452Ab2KVWbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:31:43 -0500
Date: Thu, 22 Nov 2012 10:03:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
Message-ID: <20121122100353.GD5764@n2100.arm.linux.org.uk>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com> <1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com> <CAKohpo=B_7rVwePziyNe0rTMokcib_FgEN28cy4nByAzbUyaqg@mail.gmail.com> <20121121204324.21126.99677@nucleus> <20121121205424.GA25470@core.coreip.homeip.net> <20121121223859.GQ3290@n2100.arm.linux.org.uk> <20121122021750.GD25470@core.coreip.homeip.net> <20121122093033.GA5764@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121122093033.GA5764@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 09:30:33AM +0000, Russell King - ARM Linux wrote:
> On Wed, Nov 21, 2012 at 06:17:50PM -0800, Dmitry Torokhov wrote:
> > > You've checked non-ARM architectures too?
> > 
> > Yes:
> > 
> > [dtor@dtor-d630 linux-next]$ grep -r HAVE_CLK_PREPARE .
> > ./arch/arm/Kconfig:     select HAVE_CLK_PREPARE
> > Binary file ./.git/objects/pack/pack-7dad5ee164f601f1327dc78648fa317772c2d872.pack matches
> > ./include/linux/clk.h:#ifdef CONFIG_HAVE_CLK_PREPARE
> > ./include/linux/clk.h:#ifdef CONFIG_HAVE_CLK_PREPARE
> > ./drivers/clk/Kconfig:config HAVE_CLK_PREPARE
> > ./drivers/clk/Kconfig:  select HAVE_CLK_PREPARE
> 
> Err, no you haven't, not with that grep.  What you've found are the places
> which enable this, and say "yes, I have clk_prepare".
> 
> What HAVE_CLK_PREPARE is about though is providing a transition path between
> drivers using clk_prepare() to platforms which _don't_ have a clk_prepare()
> implementation - and when it's unset, it provides a default implementation.
> 
> So, finding all those places where the symbol exists is the exact opposite
> of what you need to be doing.  You need to find those platforms which have
> CLK support, but which don't have HAVE_CLK_PREPARE selected.

Right, according to my greps under arch/arm, the following define a
clk_enable() function but do not define a clk_prepare() function:

arch/arm/mach-w90x900/clock.c
arch/arm/mach-ep93xx/clock.c
arch/arm/plat-omap/clock.c
arch/arm/plat-samsung/clock.c
arch/arm/mach-lpc32xx/clock.c
arch/arm/mach-msm/clock.c
arch/arm/mach-mmp/clock.c
arch/arm/mach-sa1100/clock.c
arch/arm/mach-at91/clock.c
arch/arm/mach-at91/at91x40.c
arch/arm/mach-pxa/clock.c
arch/arm/plat-versatile/clock.c
arch/arm/mach-davinci/clock.c

This list gets over twice as big if you widen the search to the arch/
subtree.

If any of these makes use of a driver which makes a call to clk_prepare(),
removing HAVE_CLK_PREPARE will break all those platforms.
