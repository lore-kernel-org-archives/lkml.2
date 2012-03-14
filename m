Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116Ab2CNIyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:54:35 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:41799
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759827Ab2CNIyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:54:31 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 14 Mar 2012 16:54:14 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        <linaro-dev@lists.linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>, <patches@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH v6 3/3] clk: basic clock hardware types
Message-ID: <20120314085413.GG3261@b20223-02.ap.freescale.net>
References: <1331366064-1273-1-git-send-email-mturquette@linaro.org>
 <1331366064-1273-4-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1331366064-1273-4-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

> +static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
> +		unsigned long *best_parent_rate)
> +{
> +	struct clk_divider *divider = to_clk_divider(hw);
> +	int i, bestdiv = 0;
> +	unsigned long parent_rate, best = 0, now, maxdiv;
> +
> +	maxdiv = (1 << divider->width);
> +
> +	if (divider->flags & CLK_DIVIDER_ONE_BASED)
> +		maxdiv--;
> +
> +	if (!(__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT)) {
> +		parent_rate = __clk_get_rate(__clk_get_parent(hw->clk));
> +		bestdiv = parent_rate / rate;
> +		bestdiv = bestdiv == 0 ? 1 : bestdiv;
> +		bestdiv = bestdiv > maxdiv ? maxdiv : bestdiv;
> +		goto out;
> +	}
> +
> +	/*
> +	 * The maximum divider we can use without overflowing
> +	 * unsigned long in rate * i below
> +	 */
> +	maxdiv = min(ULONG_MAX / rate, maxdiv);
> +
> +	for (i = 1; i <= maxdiv; i++) {
> +		int div;
> +		parent_rate = __clk_round_rate(__clk_get_parent(hw->clk),
> +				rate * i);
> +		div = parent_rate / rate;
> +		div = div > maxdiv ? maxdiv : div;
> +		div = div < 1 ? 1 : div;
> +		now = parent_rate / div;
> +
> +		if (now <= rate && now >= best) {
> +			bestdiv = div;
> +			best = now;
> +			*best_parent_rate = parent_rate;
			if (now == rate)
				break;
we don't need it to loop to end, and smaller parent_rate is better.
> +		}
> +	}
> +
> +	if (!bestdiv) {
> +		bestdiv = (1 << divider->width);
> +		parent_rate = __clk_round_rate(__clk_get_parent(hw->clk), 1);
> +	} else {
> +		parent_rate = best * bestdiv;
> +	}
> +
> +out:
> +	if (best_parent_rate)
> +		*best_parent_rate = parent_rate;
> +
> +	return bestdiv;
> +}

