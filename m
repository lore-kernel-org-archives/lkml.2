Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1LBUX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:23:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48722 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1LBUX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:23:27 -0500
Date: Fri, 2 Dec 2011 20:23:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
Message-ID: <20111202202306.GF19739@n2100.arm.linux.org.uk>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-4-git-send-email-mturquette@linaro.org> <alpine.DEB.2.00.1111291619110.6289@utopia.booyaka.com> <20111201084547.GD19739@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1112012352000.6289@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112012352000.6289@utopia.booyaka.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 10:13:10AM -0700, Paul Walmsley wrote:
> Hi Russell,
> 
> On Thu, 1 Dec 2011, Russell King - ARM Linux wrote:
> 
> > On Wed, Nov 30, 2011 at 06:20:50PM -0700, Paul Walmsley wrote:
> > > 1. When a clock user calls clk_enable() on a clock, the clock framework 
> > > should prevent other users of the clock from changing the clock's rate.  
> > > This should persist until the clock user calls clk_disable() (but see also 
> > > #2 below).  This will ensure that clock users can rely on the rate 
> > > returned by clk_get_rate(), as long as it's called between clk_enable() 
> > > and clk_disable().  And since the clock's rate is guaranteed to remain the 
> > > same during this time, code that cannot tolerate clock rate changes 
> > > without special handling (such as driver code for external I/O devices) 
> > > will work safely without further modification.
> > 
> > So, if you have a PLL whose parent clock is not used by anything else.
> > You want to program it to a certain rate.
> > 
> > You call clk_disable() on the PLL clock.
> 
> The approach described wouldn't require the PLL to be disabled before 
> changing its rate.  If there are no other users of the PLL, or if the 
> other users of the PLL have indicated that it's safe for others to change 
> the PLL's rate, the clock framework would allow the PLL rate change, even 
> if the PLL is enabled.  (modulo any notifier activity, and assuming that 
> the underlying PLL hardware allows its frequency to be reprogrammed while 
> the PLL is enabled)
> 
> > This walks up the tree and disables the parent.  You then try to set the 
> > rate using clk_set_rate(). clk_set_rate() in this circumstance can't 
> > wait for the PLL to lock because it can't - there's no reference clock 
> > for it.
> 
> As an aside, this seems like a good time to mention that the behavior of 
> clk_set_rate() on a disabled clock needs to be clarified.

It's more complicated than that.  Clocks have more states than just
enabled and disabled.

There is:
- unprepared
- prepared and disabled
- prepared and enabled

Implementations can chose at which point to enable their PLLs and wait
for them to lock - but if they want to sleep while waiting, they must
do this in the prepare method, not the enable method (remember, enable
is to be callable from atomic contexts.)

So, it's entirely possible that a prepared clock will have the PLLs up
and running, which means that clk_set_rate() can also wait for the PLL
to stablize (which would be a good idea.)

Now... we can say that PLLs should be locked when the prepare method
returns, or whenever clk_set_rate() returns.  The problem with that is
there's a race condition between clk_enable() and clk_set_rate() - if
we allow clk_set_rate() to sleep waiting for the PLL to lock, a
concurrent clk_enable() can't be prevented from returning because
that would involve holding a spinlock...

I think this is just one of those unsolvable issues - if you have
concurrent users of a PLL there's not much you can do - race free - to
prevent the PLL changing beneath some user.
