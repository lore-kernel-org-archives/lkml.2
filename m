Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1LABUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 20:20:53 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:39131 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab1LABUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 20:20:52 -0500
Date: Wed, 30 Nov 2011 18:20:50 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Mike Turquette <mturquette@ti.com>
cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, paul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
In-Reply-To: <1321926047-14211-4-git-send-email-mturquette@linaro.org>
Message-ID: <alpine.DEB.2.00.1111291619110.6289@utopia.booyaka.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-4-git-send-email-mturquette@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here are some initial comments on clk_get_rate().

On Mon, 21 Nov 2011, Mike Turquette wrote:

> +/**
> + * clk_get_rate - return the rate of clk
> + * @clk: the clk whose rate is being returned
> + *
> + * Simply returns the cached rate of the clk.  Does not query the hardware.  If
> + * clk is NULL then returns 0.
> + */
> +unsigned long clk_get_rate(struct clk *clk)
> +{
> +	if (!clk)
> +		return 0;
> +
> +	return clk->rate;
> +}
> +EXPORT_SYMBOL_GPL(clk_get_rate);

This implementation of clk_get_rate() is racy, and is, in general, unsafe. 
The problem is that, in many cases, the clock's rate may change between 
the time that clk_get_rate() is called and the time that the returned 
rate is used.  This is the case for many clocks which are part of a 
larger DVFS domain, for example.

Several changes are needed to fix this:

1. When a clock user calls clk_enable() on a clock, the clock framework 
should prevent other users of the clock from changing the clock's rate.  
This should persist until the clock user calls clk_disable() (but see also 
#2 below).  This will ensure that clock users can rely on the rate 
returned by clk_get_rate(), as long as it's called between clk_enable() 
and clk_disable().  And since the clock's rate is guaranteed to remain the 
same during this time, code that cannot tolerate clock rate changes 
without special handling (such as driver code for external I/O devices) 
will work safely without further modification.

2. Since the protocol described in #1 above will prevent DVFS from working 
when the clock is part of a larger DVFS clock group, functions need to be 
added to allow and prevent other clock users from changing the clock's 
rate.  I'll use the function names "clk_allow_rate_changes(struct clk *)" 
and "clk_block_rate_changes(struct clk *)" for this discussion.  These 
functions can be used by clock users to define critical sections during 
which other entities on the system are allowed to change a clock's rate - 
even if the clock is currently enabled.  (Note that when a clock is 
prevented from changing its rate, all of the clocks from it up to the root 
of the tree should also be prevented from changing rates, since parent 
rate changes generally cause disruptions in downstream clocks.)

3. For the above changes to work, the clock framework will need to 
discriminate between different clock users' calls to clock functions like 
clk_{get,set}_rate(), etc.  Luckily this should be possible within the 
current clock interface.  clk_get() can allocate and return a new struct 
clk that clk_put() can later free.  One useful side effect of doing this 
is that the clock framework could catch unbalanced clk_{enable,disable}() 
calls.

4. clk_get_rate() must return an error when it's called in situations 
where the caller hasn't ensured that the clock's rate won't be changed by 
other entities.  For non-fixed rate clocks, these forbidden sections would 
include code between a clk_get() and a clk_enable(), or between a 
clk_disable() and a clk_put() or clk_enable(), or between a 
clk_allow_rate_changes() and clk_block_rate_changes().  The first and 
second of those three cases will require some code auditing of 
clk_get_rate() users to ensure that they are only calling it after they've 
enabled the clock.  And presumably most of them are not checking for 
error.  include/linux/clk.h doesn't define an error return value, so this 
needs to be explicitly defined in clk.h.


- Paul
