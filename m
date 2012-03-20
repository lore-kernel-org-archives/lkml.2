Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab2CTHUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 03:20:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41277 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab2CTHUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 03:20:06 -0400
Date: Tue, 20 Mar 2012 08:19:57 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>, Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] clk: Fix error handling in fixed clock hardware type
 register fn
Message-ID: <20120320071957.GH3852@pengutronix.de>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
 <1332214706-675-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332214706-675-1-git-send-email-skannan@codeaurora.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:17:44 up 128 days, 15:04, 37 users,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 08:38:25PM -0700, Saravana Kannan wrote:
> If memory allocation for the parents array or the parent string fails, then
> fail the registration immediately instead of calling clk_register and
> hoping it fails there.
> 
> Return -ENOMEM on failure.
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
> There are still some memory free issues when clk_register() fails, but I will
> fix it when I fixed the other register() fns to return ENOMEM of alloc
> failure instead of a NULL.
> 
>  drivers/clk/clk-fixed-rate.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
> index 90c79fb..6423ae9 100644
> --- a/drivers/clk/clk-fixed-rate.c
> +++ b/drivers/clk/clk-fixed-rate.c
> @@ -61,22 +61,26 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
>  		parent_names = kmalloc(sizeof(char *), GFP_KERNEL);
>  
>  		if (! parent_names)
> -			goto out;
> +			goto fail_ptr;
>  
>  		len = sizeof(char) * strlen(parent_name);
>  
>  		parent_names[0] = kmalloc(len, GFP_KERNEL);
>  
>  		if (!parent_names[0])
> -			goto out;
> +			goto fail_str;
>  
>  		strncpy(parent_names[0], parent_name, len);
>  	}

It's easier to add a char *parent to struct clk_fixed and pass it to
clk_register with &fixed->parent. This saves you a kmalloc call and
makes the error path simpler. It's the same way already done in the
divider.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
