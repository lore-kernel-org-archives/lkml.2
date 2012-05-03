Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959Ab2ECXDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 19:03:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48934 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758908Ab2ECXDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 19:03:13 -0400
Date: Fri, 4 May 2012 01:03:08 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
Message-ID: <20120503230308.GA13016@glitch>
Mail-Followup-To: Saravana Kannan <skannan@codeaurora.org>,
	Mike Turquette <mturquette@linaro.org>,
	Arnd Bergman <arnd.bergmann@linaro.org>,
	linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
	Paul Walmsley <paul@pwsan.com>,
	Russell King <linux@arm.linux.org.uk>,
	Linus Walleij <linus.walleij@stericsson.com>,
	Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Richard Zhao <richard.zhao@linaro.org>,
	Grant Likely <grant.likely@secretlab.ca>,
	Deepak Saxena <dsaxena@linaro.org>,
	Amit Kucheria <amit.kucheria@linaro.org>,
	Jamie Iles <jamie@jamieiles.com>,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Shawn Guo <shawn.guo@freescale.com>
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:58:56PM -0700, Saravana Kannan wrote:
>
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index 90627e4..8ea11b4 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -167,6 +167,7 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
>  {
>  	struct clk_divider *div;
>  	struct clk *clk;
> +	struct clk_init_data init;
>  
>  	/* allocate the divider */
>  	div = kzalloc(sizeof(struct clk_divider), GFP_KERNEL);
> @@ -175,19 +176,22 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> +	init.name = name;
> +	init.ops = &clk_divider_ops;
> +	init.flags = flags;
> +	init.parent_names = (parent_name ? &parent_name: NULL);
> +	init.num_parents = (parent_name ? 1 : 0);
> +
>  	/* struct clk_divider assignments */
>  	div->reg = reg;
>  	div->shift = shift;
>  	div->width = width;
>  	div->flags = clk_divider_flags;
>  	div->lock = lock;
> +	div->hw.init = &init;
>  
>  	/* register the clock */
> -	clk = clk_register(dev, name,
> -			&clk_divider_ops, &div->hw,
> -			(parent_name ? &parent_name: NULL),
> -			(parent_name ? 1 : 0),
> -			flags);
> +	clk = clk_register(dev, &div->hw);
>  
>  	if (IS_ERR(clk))
>  		kfree(div);

I would prefer to rip the parent _settings_ configuration out of
clk_register(). It's optional right? And passing a single parent is a
common case.

Three cases:

  1) one parent:
     __clk_register_parent(clk, parent_name);
     clk_register(dev, name, &ops, flags);

  2) many parents:
     __clk_register_parents(clk, parent_names, num_parents);
     clk_register(dev, name, &ops, flags);

  3) no parents:
     clk_register(dev, name, &ops, flags);

You may also want to move the whole parent initialization into
__clk_register_parents() and call it after clk_register(), it would
simplify some error paths.

This pattern could be used also with other common clocks registration
functions (fixed rate, divider, mux, etc) that may have complex
initializations and/or optional parameters that cannot go all on the
same function call.

cheers,
Domenico
