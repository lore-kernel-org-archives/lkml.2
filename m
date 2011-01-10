Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1AJKl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:41:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45807 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1AJKl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:41:27 -0500
Date: Mon, 10 Jan 2011 11:41:22 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20110110104122.GI12078@pengutronix.de>
References: <1294199462.347935.472473715866.0.gpush@pororo>
 <1294199462.348449.192344022926.1.gpush@pororo>
 <20110108131520.GE26617@pengutronix.de>
 <201101101043.05406.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101101043.05406.jeremy.kerr@canonical.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:27:46 up 6 days, 19:35, 40 users,  load average: 0.04, 0.07,
 0.47
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 10:43:04AM +0800, Jeremy Kerr wrote:
> Hi Sascha,
> 
> > I'm currently thinking about how to get the locking right with this
> > approach. In the current i.MX implementation we have a global lock which
> > protects the clock enable counter and also the register accesses in the
> > clock code. With the common struct clock we have a lock per clock which
> > only protects the enable counter, so we have to introduce a second lock
> > to protect the register accesses.
> 
> Are the registers shared between clocks? If not, you can just use the existing 
> per-clk lock. Otherwise it'd be reasonable to add a global register lock, 
> protecting accesses to the shared register set (and *only* protecting these 
> registers).

Yes, the registers are shared between clocks.

> 
> > The problem comes with nested calls to for example clk_enable which
> > happens when the parent clock gets enabled. currently we do this with
> > clk->enable(clk->parent) which results in an unlocked clk_enable of the
> > parent. With common struct clk we would have to call
> > clk_enable(clk_get_parent(clk) which results in taking the lock a second
> > time.
> > Any ideas how to solve this?
> 
> With the shared register lock, you just need to make sure that you don't 
> recurse to the parent while holding the lock.
> 
> For clocks with a shared register set, the general pattern would be something 
> like:
> 
> struct clk_foo {
> 	struct clk clk;
> 	u32        enable_reg;
> 	u32        enable_mask;
> 	struct clk *parent;
> };
> 
> static DEFINE_SPINLOCK(clk_foo_register_lock);
> 
> /* called with _clk->lock held */
> static int clk_foo_enable(struct clk *_clk)
> {
> 	struct clk_foo *clk = to_clk_foo(_clk);
> 	int reg, rc;
> 
> 	/* enable parent - will acquire and release the parent's per-clk lock */
> 	rc = clk_enable(clk->parent);
> 	if (rc)
> 		return rc;
> 
> 	/* do register update, under global register lock */
> 	spin_lock(&clk_foo_register_lock);
> 
> 	reg = __raw_readl(clk->reg);
> 	__raw_writel(clk->reg, reg | clk->enable_mask);
> 
> 	spin_unlock(&clk_foo_register_lock);
> 
> 	return 0;
> }
> 
> struct clk_foo_ops = {
> 	.enable = clk_foo_enable;
> 	[...]
> };

Ok, that should do it. Unfortunately this requires pushing the lock down
to the individual functions instead of taking it in some global place.

> 
> However, because clk_mxc introduces its own set of abstractions, there may be 
> some merging to do here. For my work on mx51, I've done a very basic port:
> 
>  * changed plat-mxc's struct clk to struct clk_mxc
>  * embedded struct clk into struct clk_mxc (ie, making it use the common API)
>  * separated some of the simpler clocks to separate types (eg clk_fixed,
>    clk_pll, clk_ccgr).
> 
> The goal here is to separate all of the clocks into their most basic types, 
> leaving no clk_mxc clocks remaining, then the locking should be much simpler.

I am aware of your work. In fact, I already did some work upon this. See

git://git.pengutronix.de/git/imx/linux-2.6.git clk-common

and

git://git.pengutronix.de/git/imx/linux-2.6.git clk-common-wip

The first branch converts the whole i.MX architecture to clk-common.
The second branch converts i.MX51 into the basic building blocks. See
how i.MX51 clock support looks like after the conversion:

http://git.pengutronix.de/?p=imx/linux-2.6.git;a=blob;f=arch/arm/mach-mx5/clock-mx51-mx53.c;h=60c05c9b8916ebcb856f1e3f4e8c419f878c13a3;hb=refs/heads/clk-common-wip

The following shows the basic building blocks I used:

http://git.pengutronix.de/?p=imx/linux-2.6.git;a=commitdiff;h=b2f7ef29c8d56ef3574a5040890ea0edc14dae7f

This branch must be reworked because the correct locking is missing, but
the first branch should be ready for merging once your clk-common
patches are merged. I'll post the patches for review soon. I hope it's
clear soon that your clk-common patches get merged.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
