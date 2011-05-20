Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935683Ab1ETL7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 07:59:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58297 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935643Ab1ETL7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 07:59:37 -0400
Date: Fri, 20 May 2011 13:59:36 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/4] clk: Add a generic clock infrastructure
Message-ID: <20110520115936.GA10931@pengutronix.de>
References: <1305876469.325655.313573683829.0.gpush@pororo>
 <1305876469.326305.518470530485.1.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305876469.326305.518470530485.1.gpush@pororo>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:39:32 up  5:19,  6 users,  load average: 0.09, 0.04, 0.01
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d076
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

Nice to see progress in this area :)

On Fri, May 20, 2011 at 03:27:49PM +0800, Jeremy Kerr wrote:
> +
> +struct clk *clk_register(struct clk_hw_ops *ops, struct clk_hw *hw,
> +		const char *name)
> +{
> +	struct clk *clk;
> +
> +	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> +	if (!clk)
> +		return NULL;
> +
> +	clk->name = name;
> +	clk->ops = ops;
> +	clk->hw = hw;
> +	hw->clk = clk;

is it worth to add a CLK_REGISTERED flag here? Up to now clocks do not
have to be registered at all and the registering might be forgotten for
some clocks. I suppose funny things can happen when we operate on
unregistered clocks.

> +
> +	/* Query the hardware for parent and initial rate */
> +
> +	if (clk->ops->get_parent)
> +		/* We don't to lock against prepare/enable here, as
> +		 * the clock is not yet accessible from anywhere */
> +		clk->parent = clk->ops->get_parent(clk->hw);
> +
> +	if (clk->ops->recalc_rate)
> +		clk->rate = clk->ops->recalc_rate(clk->hw);

This implicitely requires that we never register a clock before its
parent is registered. This makes perfect sense but I think we should
catch it here when the user tries to register a clock with a not yet
registered parent.

> +
> +
> +	return clk;
> +}
> +EXPORT_SYMBOL_GPL(clk_register);

BTW we planned to let the linker do the job of registering static
clocks, but this is only convenience and can be added later.


Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
