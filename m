Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab2CKLeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 07:34:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59328 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2CKLeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 07:34:22 -0400
Date: Sun, 11 Mar 2012 12:34:14 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Mike Turquette <mturquette@ti.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v6 2/3] clk: introduce the common clock framework
Message-ID: <20120311113414.GM3852@pengutronix.de>
References: <1331366064-1273-1-git-send-email-mturquette@linaro.org>
 <1331366064-1273-3-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331366064-1273-3-git-send-email-mturquette@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:25:29 up 119 days, 19:12, 16 users,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

I was about to give my tested-by when I decided to test the set_rate
function. Unfortunately this is broken for several reasons. I'll try
to come up with a fixup series later the day.

On Fri, Mar 09, 2012 at 11:54:23PM -0800, Mike Turquette wrote:
> +
> +/**
> + * DOC: Using the CLK_SET_RATE_PARENT flag
> + *
> + * __clk_set_rate changes the child's rate before the parent's to more
> + * easily handle failure conditions.
> + *
> + * This means clk might run out of spec for a short time if its rate is
> + * increased before the parent's rate is updated.
> + *
> + * To prevent this consider setting the CLK_SET_RATE_GATE flag on any
> + * clk where you also set the CLK_SET_RATE_PARENT flag
> + *
> + * PRE_RATE_CHANGE notifications are supposed to stack as a rate change
> + * request propagates up the clk tree.  This reflects the different
> + * rates that a downstream clk might experience if left enabled while
> + * upstream parents change their rates.
> + */
> +static struct clk *__clk_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	struct clk *fail_clk = NULL;
> +	int ret = NOTIFY_DONE;
> +	unsigned long old_rate = clk->rate;
> +	unsigned long new_rate;
> +	unsigned long parent_old_rate;
> +	unsigned long parent_new_rate = 0;
> +	struct clk *child;
> +	struct hlist_node *tmp;
> +
> +	/* bail early if we can't change rate while clk is enabled */
> +	if ((clk->flags & CLK_SET_RATE_GATE) && clk->enable_count)
> +		return clk;
> +
> +	/* find the new rate and see if parent rate should change too */
> +	WARN_ON(!clk->ops->round_rate);
> +
> +	new_rate = clk->ops->round_rate(clk->hw, rate, &parent_new_rate);

You don't need a WARN_ON when you derefence clk->ops->round_rate anyway.
Also, even when the current clock does not have a set_rate function it
can still change its rate when the CLK_SET_RATE_PARENT is set.

> +
> +	/* NOTE: pre-rate change notifications will stack */
> +	if (clk->notifier_count)
> +		ret = __clk_notify(clk, PRE_RATE_CHANGE, clk->rate, new_rate);
> +
> +	if (ret == NOTIFY_BAD)
> +		return clk;
> +
> +	/* speculate rate changes down the tree */
> +	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
> +		ret = __clk_speculate_rates(child, new_rate);
> +		if (ret == NOTIFY_BAD)
> +			return clk;
> +	}
> +
> +	/* change the rate of this clk */
> +	if (clk->ops->set_rate)
> +		ret = clk->ops->set_rate(clk->hw, new_rate);

I don't know the reason why you change the child clock before the parent
clock, but it cannot work since this clock will change its rate based on
the old parent rate and not the new one.

There are more things, as said I'll try to come up with a fixup series.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
