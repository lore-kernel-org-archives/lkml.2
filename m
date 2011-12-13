Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab1LMS3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:29:00 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9889 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1LMS2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:28:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 Dec 2011 10:28:50 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>
Date: Tue, 13 Dec 2011 10:28:48 -0800
Subject: RE: [PATCH V2 1/2] pinctrl: enable pinmux for pxa series
Thread-Topic: [PATCH V2 1/2] pinctrl: enable pinmux for pxa series
Thread-Index: Acy5evfUhOJ6PSHHRWiRQEUNDe58FQARUfrg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1751860B1F@HQMAIL01.nvidia.com>
References: <1323769253-22580-1-git-send-email-haojian.zhuang@marvell.com>
 <1323769253-22580-2-git-send-email-haojian.zhuang@marvell.com>
In-Reply-To: <1323769253-22580-2-git-send-email-haojian.zhuang@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haojian Zhuang wrote at Tuesday, December 13, 2011 2:41 AM:
> Support pxa3xx/pxa168/pxa910/mmp2. Support to switch pin configuration.

>  drivers/pinctrl/Kconfig          |   15 +
>  drivers/pinctrl/Makefile         |    3 +
>  drivers/pinctrl/pinctrl-pxa3xx.c |  193 +++++++++++
>  drivers/pinctrl/pinmux-pxa168.c  |  170 ++++++++++
>  drivers/pinctrl/pinmux-pxa300.c  |  647 ++++++++++++++++++++++++++++++++++++++
>  drivers/pinctrl/pinmux-pxa910.c  |  373 ++++++++++++++++++++++

If you plan for the driver to support pin config as well as pin mux, it
may be better to name all the files pinctrl-xxx.c since they presumably
won't only contain mux information in the future.

> diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile

> +obj-$(CONFIG_PINMUX_PXA168)	+= pinmux-pxa168.o pinctrl-pxa3xx.o
> +obj-$(CONFIG_PINMUX_PXA300)	+= pinmux-pxa300.o pinctrl-pxa3xx.o
> +obj-$(CONFIG_PINMUX_PXA910)	+= pinmux-pxa910.o pinctrl-pxa3xx.o

That structure will cause problems if multiple of those Kconfig options
are enabled at once, as in a multi-SoC kernel. Instead, shouldn't this be:

obj-$(CONFIG_PINCTRL_PXA3XX)	+= pinctrl-pxa3xx.o
obj-$(CONFIG_PINMUX_PXA168)	+= pinmux-pxa168.o
obj-$(CONFIG_PINMUX_PXA300)	+= pinmux-pxa300.o
obj-$(CONFIG_PINMUX_PXA910)	+= pinmux-pxa910.o

which in turn would require Kconfig to be:

config PINCTRL_PXA3XX
	bool " PXA3XX core pinctrl driver"

config PINMUX_PXA168
	bool "PXA168 pinmux driver"
	depends on ARCH_MMP
	select PINMUX
	select PINCTRL_PXA3XX

config PINMUX_PXA300
	bool "PXA300 pinmux driver"
	depends on ARCH_PXA
	select PINMUX
	select PINCTRL_PXA3XX

config PINMUX_PXA910
	bool "PXA910 pinmux driver"
	depends on ARCH_MMP
	select PINMUX
	select PINCTRL_PXA3XX

(possibly with s/PINMUX_PXA/PINCTRL_PXA/ throughout)

> diff --git a/drivers/pinctrl/pinctrl-pxa3xx.c b/drivers/pinctrl/pinctrl-pxa3xx.c

> +static int pxa3xx_get_gpio_func(enum pxa_cpu_type cputype, unsigned int gpio)
...
> +	switch (cputype) {
...
> +	case PINMUX_PXA320:
> +		if (gpio == 56 || (gpio > 58 && gpio < 63))
> +			goto out;
> +		break;
...
> +	default:
> +		goto out;
> +	}
> +	return ret & MFPR_FUNC;
> +out:
> +	return -1;
> +}

I'd name the label "err" or similar rather than "out"; when I read "out",
I didn't realize this was an error path rather than a good exit path.

> +static int pxa3xx_pmx_request_gpio(struct pinctrl_dev *pctrldev,
> +			       struct pinctrl_gpio_range *range,
> +			       unsigned pin)
> +{
...
> +	/* write gpio function into mfpr register */
> +	data = readl_relaxed(info->virt_base + mfpr) & MFPR_FUNC_MASK;

FOO_MASK is usually the mask for the field, so you'd want to and with
~MFPR_FUNC_MASK here. Still, I see that MFPR_FUNC_MASK==~MFPR_FUNC, so
the code is correct as written, albeit confusing.

I'd suggest:
* Delete MFPR_FUNC_MASK define.
* Rename MFPR_FUNC to MFPR_FUNC_MASK.
* and with ~MFPR_FUNC_MASK instead of MFPR_FUNC_MASK here.

> +static int pxa3xx_pmx_enable(struct pinctrl_dev *pctrldev, unsigned func,
> +			     unsigned group)
> +{
> +	struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
> +	struct pxa3xx_pin_group *pin_grp = &info->grp[group];
> +	unsigned int data, pin_func;
> +	int i, mfpr;
> +
> +	for (i = 0; i < pin_grp->num_pins; i++) {
> +		mfpr = pxa3xx_get_mfpr(info, pin_grp->pins[i]);
> +		if (mfpr < 0) {
> +			dev_err(info->dev, "error pin:%d mfpr offset:%x\n",
> +				pin_grp->pins[i], mfpr);
> +			goto out;
> +		}
> +		pin_func = pin_grp->func[i];
> +		data = readl_relaxed(info->virt_base + mfpr);
> +	        data &= MFPR_FUNC_MASK;
> +		data |= pin_func;

There's an indentation problem here.

> +		writel_relaxed(data, info->virt_base + mfpr);
> +	}
> +	return 0;
> +out:
> +	return -EINVAL;
> +}

I don't see "func" used anywhere in this function. How does this code
know /which/ function to activate on the pins, or is there only a single
supported function for each pin? If so, I think you should at least
validate the "func" is the expected function for the pin.

Related, if the HW supports configuring the mux function at a per-pin
Level (as appears to be the case, since you're looping over pins above),
I'd expect that each group definition in your driver to contain a single
pin, rather than an array of pins. The set of pins/groups/functions
exposed by your driver should represent the raw HW capabilities, and not
any logical grouping of pins into e.g. a whole UART or SD port.

----------==========----------==========----------==========----------==========
Yes, looking at e.g. pinmux-pxa168.c, I believe you are creating
artificial groups, when you should be creating a group for each pin.
I wonder if the pinctrl core should grow the ability to synthesize a
group for each pin, in the case where the HW doesn't use groups. That
would remove the need for you to type out all those group definitions.
Alternatively, the mapping table lookups could first search for a group,
and if one isn't found, search for a pin of that name. Then, groups
would not be needed at all if the HW didn't use them.

> diff --git a/drivers/pinctrl/pinmux-pxa168.c b/drivers/pinctrl/pinmux-pxa168.c

> +static struct pinctrl_desc pxa168_pctrl_desc = {
> +	.name		= "pxa168-pinctrl",
...
> +static struct platform_driver pxa168_pinmux_driver = {
> +	.driver = {
> +		.name = "pxa168-pinmux",

Shouldn't those two names match?

> diff --git a/drivers/pinctrl/pinmux-pxa300.c b/drivers/pinctrl/pinmux-pxa300.c

This file appears to contain 4 sets of data without any commonality.
Shouldn't this be 4 separate files to keep the different CPUs separate?
you could still share probe() etc. by putting that in a common file, and
having that file call out to the per-CPU file to get a structure containing
the CPU-specific data. That way, I think you can probably share probe()
etc. across all 3 of the files you have now too, thus reducing the total
amount of code even if increasing the file count.

See the Tegra patches I posted for example.

> +++ b/drivers/pinctrl/pinmux-pxa300.c
...
> + *  linux/drivers/pinctrl/pinmux-pxa3xx.c

The comment doesn't match the filename.

> diff --git a/drivers/pinctrl/pinmux-pxa910.c b/drivers/pinctrl/pinmux-pxa910.c

Same comment for this file; it appears to contain the data for two
different CPUs, and there's no commonality.

-- 
nvpublic

