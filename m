Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab2CUW03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:26:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49747 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab2CUW02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:26:28 -0400
Date: Wed, 21 Mar 2012 23:26:22 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] clk: wm831x: Add initial WM831x clock driver
Message-ID: <20120321222622.GG29317@pengutronix.de>
References: <1332360082-25092-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1332360082-25092-4-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332360082-25092-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:53:49 up 130 days,  5:40, 39 users,  load average: 0.08, 0.09,
 0.09
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 08:01:22PM +0000, Mark Brown wrote:
> The WM831x and WM832x series of PMICs contain a flexible clocking
> subsystem intended to provide always on and system core clocks.  It
> features:
> 
> - A 32.768kHz crystal oscillator which can optionally be used to pass
>   through an externally generated clock.
> - A FLL which can be clocked from either the 32.768kHz oscillator or
>   the CLKIN pin.
> - A CLKOUT pin which can bring out either the oscillator or the FLL
>   output.
> - The 32.768kHz clock can also optionally be brought out on the GPIO
>   pins of the device.
> 
> This driver fully supports the 32.768kHz oscillator and CLKOUT.  The FLL
> is supported only in AUTO mode, the full flexibility of the FLL cannot
> currently be used.
> 
> Due to a lack of access to systems where the core SoC has been converted
> to use the generic clock API this driver has been compile tested only.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

[...]

> +
> +static unsigned long wm831x_clkout_recalc_rate(struct clk_hw *hw,
> +					       unsigned long parent_rate)
> +{
> +	return parent_rate;
> +}

You should be able to drop this. The clock framework will use the parent
rate automatically if recalc_rate is not present.

> +
> +static int wm831x_clkout_set_parent(struct clk_hw *hw, u8 parent)
> +{
> +	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
> +						  clkout_hw);
> +	struct wm831x *wm831x = clkdata->wm831x;
> +
> +	if (parent > ARRAY_SIZE(wm831x_clkout_parents))
> +		return -EINVAL;

Unless you mistrust the clock framework isn't necessary. The framework
checks this already.

> +
> +static __devinit int wm831x_clk_probe(struct platform_device *pdev)
> +{
> +	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
> +	struct wm831x_clk *clkdata;
> +	int ret;
> +
> +	clkdata = devm_kzalloc(&pdev->dev, sizeof(*clkdata), GFP_KERNEL);
> +	if (!clkdata)
> +		return -ENOMEM;
> +
> +	/* XTAL_ENA can only be set via OTP/InstantConfig so just read once */
> +	ret = wm831x_reg_read(wm831x, WM831X_CLOCK_CONTROL_2);
> +	if (ret < 0) {
> +		dev_err(wm831x->dev, "Unable to read CLOCK_CONTROL_2: %d\n",
> +			ret);
> +		return ret;
> +	}
> +	clkdata->xtal_ena = ret & WM831X_XTAL_ENA;
> +
> +	if (!clk_register(&pdev->dev, "xtal", &wm831x_xtal_ops,
> +			  &clkdata->xtal_hw, NULL, 0, CLK_IS_ROOT))
> +		return -EINVAL;

The clock names are unique identifiers for the clock, so clocks in
drivers should probably have dev_name encoded into them.

You could also use the fixed rate generic clock here.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
