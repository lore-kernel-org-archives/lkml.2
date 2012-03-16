Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031273Ab2CPM0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:26:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48236 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab2CPM0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:26:10 -0400
Date: Fri, 16 Mar 2012 20:25:45 +0800
From: Richard Zhao <richard.zhao@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Mike Turquette <mturquette@ti.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jamie Iles <jamie@jamieiles.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 3/3] clk: basic clock hardware types
Message-ID: <20120316122542.GA1774@richard-laptop>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <1331878280-2758-4-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331878280-2758-4-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> +static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
> +		unsigned long *best_parent_rate)
> +{
> +	struct clk_divider *divider = to_clk_divider(hw);
> +	int i, bestdiv = 0;
> +	unsigned long parent_rate, best = 0, now, maxdiv;
> +
> +	if (!rate)
> +		rate = 1;
> +
> +	maxdiv = (1 << divider->width);
> +
> +	if (divider->flags & CLK_DIVIDER_ONE_BASED)
> +		maxdiv--;
> +
> +	if (!best_parent_rate) {
> +		parent_rate = __clk_get_rate(__clk_get_parent(hw->clk));
> +		bestdiv = DIV_ROUND_UP(parent_rate, rate);
> +		bestdiv = bestdiv == 0 ? 1 : bestdiv;
> +		bestdiv = bestdiv > maxdiv ? maxdiv : bestdiv;
> +		return bestdiv;
> +	}
> +
> +	/*
> +	 * The maximum divider we can use without overflowing
> +	 * unsigned long in rate * i below
> +	 */
> +	maxdiv = min(ULONG_MAX / rate, maxdiv);
> +
> +	for (i = 1; i <= maxdiv; i++) {
> +		parent_rate = __clk_round_rate(__clk_get_parent(hw->clk),
> +				MULT_ROUND_UP(rate, i));
> +		now = parent_rate / i;
> +		if (now <= rate && now > best) {
> +			bestdiv = i;
> +			best = now;
> +			*best_parent_rate = parent_rate;
Better add		if (now == rate)
				break;
There may be more than one hit for (now == rate). We'd better select
smallest div, thus smallest parent_rate.

It's the same comment for v6, but not show stopper.

Thanks
Richard
> +		}
> +	}
> +
> +	if (!bestdiv) {
> +		bestdiv = (1 << divider->width);
> +		if (divider->flags & CLK_DIVIDER_ONE_BASED)
> +			bestdiv--;
> +		*best_parent_rate = __clk_round_rate(__clk_get_parent(hw->clk), 1);
> +	}
> +
> +	return bestdiv;
> +}
 
