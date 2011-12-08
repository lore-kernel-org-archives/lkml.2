Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab1LHXOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 18:14:54 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14752 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab1LHXOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 18:14:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 08 Dec 2011 15:14:40 -0800
From: Stephen Warren <swarren@nvidia.com>
To: =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Date: Thu, 8 Dec 2011 15:14:40 -0800
Subject: RE: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32
 SoCs
Thread-Topic: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32
 SoCs
Thread-Index: Acy1+n8dk9+0rEgBT2ilUl4rEFnOhwAAki6A
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1750B77BD8@HQMAIL01.nvidia.com>
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB8NF1R1000309

Uwe Kleine-KÃ¶nig wrote at Thursday, December 08, 2011 3:41 PM:

> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig

> +config PINMUX_EFM32
> +	bool "EFM32 pinmux driver"
> +	depends on ARCH_EFM32
> +	default y
> +	select PINMUX

LinusW,

Since this is the pinctrl not pinmux subsystem now, does it make sense
to name the driver Kconfig options PINCTRL_FOO and the files pinctrl-
foo.c? I see that the coh901 driver already does that, and I followed
that convention in my Tegra pinctrl patches.

Uwe,

> diff --git a/drivers/pinctrl/pinmux-efm32.c b/drivers/pinctrl/pinmux-efm32.c

> +#define DRIVER_NAME "efm32-pinctl"

pinctrl (with an r) would match the subsystem name better.

> +static const char *efm32_pinctl_pctl_get_group_name(struct pinctrl_dev *pctldev,
> +		unsigned selector)
> +{
> +	struct efm32_pinctrl_ddata *ddata = pctldev->driver_data;
> +	const struct efm32_pinctl_pdata *pdata = ddata->pdata;
> +
> +	return pdata->groups[selector]->name;
> +}

Presumably, the set of pins, groups, and functions is determined by the
SoC HW. Platform data is usually board-specific rather than SoC specific.
You have two choices here: You could either parse this data from device
tree as Arnd suggested (and I think as the TI OMAP pinctrl driver will),
or do what I've done in the Tegra pinctrl driver, and simply put each
SoC's data into the driver and select which one to use based on the DT
compatible flag; I didn't see the point of putting data in to the DT that
was identical for every board using a given SoC.

> +struct efm32_pmx_func {
> +	const char *name;
> +	const char **groups;
> +	const unsigned ngroups;
> +	const unsigned *mode;
> +};
> +
> +static const char *efm32_us1_groups[] = {
> +	"us1_loc0",
> +	"us1_loc1",
> +	"us1_loc2",
> +};
> +
> +/* order: TX, RX, CS, CLK */
> +static const unsigned efm32_us_modes[] = {
> +	EFM32_MODE_PUSHPULL_HIGH, EFM32_MODE_INPUT,
> +	EFM32_MODE_DISABLE, EFM32_MODE_DISABLE
> +};
> +
> +#define EFM32_PMXFUNC(_name, num) {					\
> +		.name = #_name #num,					\
> +		.groups = efm32_ ## _name ## num ## _groups,		\
> +		.ngroups = ARRAY_SIZE(efm32_ ## _name ## num ## _groups),\
> +		.mode = efm32_ ## _name ## _modes,			\
> +	}
> +
> +static const struct efm32_pmx_func efm32_pmx_funcs[] = {
> +	EFM32_PMXFUNC(us, 1),
> +};

If you're getting all your information from pdata, I'm not sure why
part of it is hard-coded into the driver...

> +static int efm32_pinctrl_pmx_enable(struct pinctrl_dev *pctldev,
> +		unsigned func_selector,
> +		unsigned group_selector)
> +{
> +	struct efm32_pinctrl_ddata *ddata = pctldev->driver_data;
> +
> +	const struct efm32_pmx_func *func;
> +	const char *groupname;
> +	const struct efm32_pinctl_group *group;
> +	unsigned i;
> +
> +	efm32_pinctrl_dbg(ddata, "%s(%u, %u)\n",
> +			__func__, func_selector, group_selector);
> +
> +	func = &efm32_pmx_funcs[func_selector];
> +	groupname = func->groups[group_selector];
> +	group = efm32_pinctrl_lookup_group(pctldev, groupname);

I'm not sure that's correct; group_selector is a global identifier, not
something that can only be interpreted relative to a particular function.
In other words, shouldn't those last 3 lines be:

func = &efm32_pmx_funcs[func_selector];
group = pdata->groups[group_selector];

or something like that?

> +static int __devinit efm32_pinctrl_probe(struct platform_device *pdev)
> +{
> +	int ret = -ENOMEM;
> +	struct efm32_pinctrl_ddata *ddata;
> +	const struct resource *res;
> +
> +       	ddata = kzalloc(sizeof(*ddata), GFP_KERNEL);

I think there's an indentation error there.

If you use devm_kzalloc, and also devm_ioremap below, you can avoid
having to write some of the cleanup code at all.

> +	ddata->pinctrldev = pinctrl_register(&ddata->pinctrldesc,
> +			&pdev->dev, ddata);
> +	if (!ddata->pinctrldev) {
> +		ret = -EINVAL;
> +		dev_dbg(&pdev->dev, "failed to register pinctrl device");
> +
> +		clk_unprepare(ddata->clk);
> +err_clk_prepare:
> +
> +		clk_put(ddata->clk);
> +err_clk_get:
> +
> +		iounmap(ddata->base);
> +err_ioremap:
> +err_get_base:
> +err_platdata:
> +		kfree(ddata);
> +	} else
> +		efm32_pinctrl_dbg(ddata, "initialized (%p, %p)\n", ddata, ddata->pinctrldev);
> +
> +err_ddata_kzalloc:
> +	return ret;
> +}

That's a pretty unusual code structure. You'd usually put all the err_foo:
labels right at the end of the function, and have even that last if()
condition jump to an error:

	ddata->pinctrldev = pinctrl_register(&ddata->pinctrldesc,
			&pdev->dev, ddata);
	if (!ddata->pinctrldev) {
		ret = -EINVAL;
		dev_dbg(&pdev->dev, "failed to register pinctrl device");
		goto err_register;
	} else
		efm32_pinctrl_dbg(ddata, "initialized (%p, %p)\n", ddata, ddata->pinctrldev);

	return 0;

err_register:
	clk_unprepare(ddata->clk);
err_clk_prepare:
	clk_put(ddata->clk);
err_clk_get:
	iounmap(ddata->base);
err_ioremap:
err_get_base:
err_platdata:
	kfree(ddata);
err_ddata_kzalloc:
	return ret;
}

... that keeps all the error if() blocks looking the same.

-- 
nvpbulic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
