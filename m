Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1LIJba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:31:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47197 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1LIJb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:31:27 -0500
Date: Fri, 9 Dec 2011 10:31:23 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32 SoCs
Message-ID: <20111209093123.GS4585@pengutronix.de>
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 03:14:40PM -0800, Stephen Warren wrote:
> Uwe Kleine-König wrote at Thursday, December 08, 2011 3:41 PM:
> 
> > diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> 
> > +config PINMUX_EFM32
> > +	bool "EFM32 pinmux driver"
> > +	depends on ARCH_EFM32
> > +	default y
> > +	select PINMUX
> 
> LinusW,
> 
> Since this is the pinctrl not pinmux subsystem now, does it make sense
> to name the driver Kconfig options PINCTRL_FOO and the files pinctrl-
> foo.c? I see that the coh901 driver already does that, and I followed
> that convention in my Tegra pinctrl patches.
+1

> 
> Uwe,
> 
> > diff --git a/drivers/pinctrl/pinmux-efm32.c b/drivers/pinctrl/pinmux-efm32.c
> 
> > +#define DRIVER_NAME "efm32-pinctl"
> 
> pinctrl (with an r) would match the subsystem name better.
yeah, I saw some names with and some without r. I can switch to the
other variant for the next round.

> > +static const char *efm32_pinctl_pctl_get_group_name(struct pinctrl_dev *pctldev,
> > +		unsigned selector)
> > +{
> > +	struct efm32_pinctrl_ddata *ddata = pctldev->driver_data;
> > +	const struct efm32_pinctl_pdata *pdata = ddata->pdata;
> > +
> > +	return pdata->groups[selector]->name;
> > +}
> 
> Presumably, the set of pins, groups, and functions is determined by the
> SoC HW. Platform data is usually board-specific rather than SoC specific.
There is nothing stoping me putting both machine and SoC specific stuff
into pdata, isn't it?

> You have two choices here: You could either parse this data from device
> tree as Arnd suggested (and I think as the TI OMAP pinctrl driver will),
> or do what I've done in the Tegra pinctrl driver, and simply put each
> SoC's data into the driver and select which one to use based on the DT
> compatible flag; I didn't see the point of putting data in to the DT that
> was identical for every board using a given SoC.
> 
> > +struct efm32_pmx_func {
> > +	const char *name;
> > +	const char **groups;
> > +	const unsigned ngroups;
> > +	const unsigned *mode;
> > +};
> > +
> > +static const char *efm32_us1_groups[] = {
> > +	"us1_loc0",
> > +	"us1_loc1",
> > +	"us1_loc2",
> > +};
> > +
> > +/* order: TX, RX, CS, CLK */
> > +static const unsigned efm32_us_modes[] = {
> > +	EFM32_MODE_PUSHPULL_HIGH, EFM32_MODE_INPUT,
> > +	EFM32_MODE_DISABLE, EFM32_MODE_DISABLE
> > +};
> > +
> > +#define EFM32_PMXFUNC(_name, num) {					\
> > +		.name = #_name #num,					\
> > +		.groups = efm32_ ## _name ## num ## _groups,		\
> > +		.ngroups = ARRAY_SIZE(efm32_ ## _name ## num ## _groups),\
> > +		.mode = efm32_ ## _name ## _modes,			\
> > +	}
> > +
> > +static const struct efm32_pmx_func efm32_pmx_funcs[] = {
> > +	EFM32_PMXFUNC(us, 1),
> > +};
> 
> If you're getting all your information from pdata, I'm not sure why
> part of it is hard-coded into the driver...
I forgot to remove these. My first running driver had all the data
hardcoded as is done here. Then I switched to platform_data.

> > +static int efm32_pinctrl_pmx_enable(struct pinctrl_dev *pctldev,
> > +		unsigned func_selector,
> > +		unsigned group_selector)
> > +{
> > +	struct efm32_pinctrl_ddata *ddata = pctldev->driver_data;
> > +
> > +	const struct efm32_pmx_func *func;
> > +	const char *groupname;
> > +	const struct efm32_pinctl_group *group;
> > +	unsigned i;
> > +
> > +	efm32_pinctrl_dbg(ddata, "%s(%u, %u)\n",
> > +			__func__, func_selector, group_selector);
> > +
> > +	func = &efm32_pmx_funcs[func_selector];
> > +	groupname = func->groups[group_selector];
> > +	group = efm32_pinctrl_lookup_group(pctldev, groupname);
> 
> I'm not sure that's correct; group_selector is a global identifier, not
> something that can only be interpreted relative to a particular function.
Ah, I thought it were relative to the function. IMHO that would make
sence. Then maybe we don't need the explicit per pin controller group
enumeration?!

> In other words, shouldn't those last 3 lines be:
> 
> func = &efm32_pmx_funcs[func_selector];
> group = pdata->groups[group_selector];
> 
> or something like that?
> 
> > +static int __devinit efm32_pinctrl_probe(struct platform_device *pdev)
> > +{
> > +	int ret = -ENOMEM;
> > +	struct efm32_pinctrl_ddata *ddata;
> > +	const struct resource *res;
> > +
> > +       	ddata = kzalloc(sizeof(*ddata), GFP_KERNEL);
> 
> I think there's an indentation error there.
uups, I shouldn't post patches that late in the night.
 
> If you use devm_kzalloc, and also devm_ioremap below, you can avoid
> having to write some of the cleanup code at all.
I'll look into that. I'm keen to save memory as long as it's reasonable
as the RAM size is quite tight. I need to do xip with (up to now) enough
flash. So a cleanup routine doesn't hurt much.
 
> > +	ddata->pinctrldev = pinctrl_register(&ddata->pinctrldesc,
> > +			&pdev->dev, ddata);
> > +	if (!ddata->pinctrldev) {
> > +		ret = -EINVAL;
> > +		dev_dbg(&pdev->dev, "failed to register pinctrl device");
> > +
> > +		clk_unprepare(ddata->clk);
> > +err_clk_prepare:
> > +
> > +		clk_put(ddata->clk);
> > +err_clk_get:
> > +
> > +		iounmap(ddata->base);
> > +err_ioremap:
> > +err_get_base:
> > +err_platdata:
> > +		kfree(ddata);
> > +	} else
> > +		efm32_pinctrl_dbg(ddata, "initialized (%p, %p)\n", ddata, ddata->pinctrldev);
> > +
> > +err_ddata_kzalloc:
> > +	return ret;
> > +}
> 
> That's a pretty unusual code structure. You'd usually put all the err_foo:
> labels right at the end of the function, and have even that last if()
> condition jump to an error:
> 
> 	ddata->pinctrldev = pinctrl_register(&ddata->pinctrldesc,
> 			&pdev->dev, ddata);
> 	if (!ddata->pinctrldev) {
> 		ret = -EINVAL;
> 		dev_dbg(&pdev->dev, "failed to register pinctrl device");
> 		goto err_register;
> 	} else
> 		efm32_pinctrl_dbg(ddata, "initialized (%p, %p)\n", ddata, ddata->pinctrldev);
> 
> 	return 0;
> 
> err_register:
> 	clk_unprepare(ddata->clk);
> err_clk_prepare:
> 	clk_put(ddata->clk);
> err_clk_get:
> 	iounmap(ddata->base);
> err_ioremap:
> err_get_base:
> err_platdata:
> 	kfree(ddata);
> err_ddata_kzalloc:
> 	return ret;
> }
> 
> ... that keeps all the error if() blocks looking the same.
personally I prefer my layout. It saves one goto :-)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
