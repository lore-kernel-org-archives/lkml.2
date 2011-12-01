Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab1LAIqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:46:12 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47362 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab1LAIqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:46:10 -0500
Date: Thu, 1 Dec 2011 08:45:47 +0000
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
Message-ID: <20111201084547.GD19739@n2100.arm.linux.org.uk>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-4-git-send-email-mturquette@linaro.org> <alpine.DEB.2.00.1111291619110.6289@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111291619110.6289@utopia.booyaka.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 06:20:50PM -0700, Paul Walmsley wrote:
> 1. When a clock user calls clk_enable() on a clock, the clock framework 
> should prevent other users of the clock from changing the clock's rate.  
> This should persist until the clock user calls clk_disable() (but see also 
> #2 below).  This will ensure that clock users can rely on the rate 
> returned by clk_get_rate(), as long as it's called between clk_enable() 
> and clk_disable().  And since the clock's rate is guaranteed to remain the 
> same during this time, code that cannot tolerate clock rate changes 
> without special handling (such as driver code for external I/O devices) 
> will work safely without further modification.

So, if you have a PLL whose parent clock is not used by anything else.
You want to program it to a certain rate.

You call clk_disable() on the PLL clock.  This walks up the tree and
disables the parent.  You then try to set the rate using clk_set_rate().
clk_set_rate() in this circumstance can't wait for the PLL to lock
because it can't - there's no reference clock for it.

You then call clk_enable().  The PLL now takes its time to lock.  You
can't sleep in clk_enable() because it might be called from atomic
contexts, so you have to spin waiting for this.

Overloading clk_disable/clk_enable in this way is a bad solution to
this problem.
