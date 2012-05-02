Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab2EBJ6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:58:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36664 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2EBJ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:58:32 -0400
Date: Wed, 2 May 2012 11:58:16 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
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
Message-ID: <20120502095816.GG20478@pengutronix.de>
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:56:39 up 171 days, 17:43, 77 users,  load average: 0.24, 0.17,
 0.46
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:58:56PM -0700, Saravana Kannan wrote:
> Create a struct clk_init_data to hold all data that needs to be passed from
> the platfrom specific driver to the common clock framework during clock
> registration. Add a pointer to this struct inside clk_hw.
> 
> This has several advantages:
> * Completely hides struct clk from many clock platform drivers and static
>   clock initialization code that don't care for static initialization of
>   the struct clks.
> * For platforms that want to do complete static initialization, it removed
>   the need to directly mess with the struct clk's fields while still
>   allowing to statically allocate struct clk. This keeps the code more
>   future proof even if they include clk-private.h.
> * Simplifies the generic clk_register() function and allows adding optional
>   fields in the future without modifying the function signature.
> * Simplifies the static initialization of clocks on all platforms by
>   removing the need for forward delcarations or convoluted macros.
> 
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnd Bergman <arnd.bergmann@linaro.org>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Jamie Iles <jamie@jamieiles.com>
> Cc: Richard Zhao <richard.zhao@linaro.org>
> Cc: Saravana Kannan <skannan@codeaurora.org>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Amit Kucheria <amit.kucheria@linaro.org>
> Cc: Deepak Saxena <dsaxena@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/clk/clk-divider.c    |   14 +++--
>  drivers/clk/clk-fixed-rate.c |   14 +++--
>  drivers/clk/clk-gate.c       |   15 +++--
>  drivers/clk/clk-mux.c        |   10 +++-
>  drivers/clk/clk.c            |   91 +++++++++++++++++++------------
>  include/linux/clk-private.h  |  121 +-----------------------------------------
>  include/linux/clk-provider.h |   59 +++++++++++++-------
>  7 files changed, 129 insertions(+), 195 deletions(-)
> 
> diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
> index 6e58f11..8e97491 100644
> --- a/drivers/clk/clk-mux.c
> +++ b/drivers/clk/clk-mux.c
> @@ -95,6 +95,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
>  {
>  	struct clk_mux *mux;
>  	struct clk *clk;
> +	struct clk_init_data init;
>  
>  	/* allocate the mux */
>  	mux = kzalloc(sizeof(struct clk_mux), GFP_KERNEL);
> @@ -103,6 +104,12 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> +	init.name = name;
> +	init.ops = &clk_mux_ops;
> +	init.flags = flags;
> +	init.parent_names = parent_names;
> +	init.num_parents = num_parents;
> +
>  	/* struct clk_mux assignments */
>  	mux->reg = reg;
>  	mux->shift = shift;
> @@ -110,8 +117,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
>  	mux->flags = clk_mux_flags;
>  	mux->lock = lock;

There is a mux->hw.init = &init missing here.

Sascha

>  
> -	clk = clk_register(dev, name, &clk_mux_ops, &mux->hw,
> -			parent_names, num_parents, flags);
> +	clk = clk_register(dev, &mux->hw);
>  
>  	if (IS_ERR(clk))
>  		kfree(mux);

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
