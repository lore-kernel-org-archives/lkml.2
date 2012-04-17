Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2DQU6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:58:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54215 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2DQU6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:58:51 -0400
Message-ID: <4F8DD986.9080702@wwwdotorg.org>
Date: Tue, 17 Apr 2012 14:58:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de, shawn.guo@freescale.com, kernel@pengutronix.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH 1/3] pinctrl: pinctrl-imx: add imx pinctrl core driver
References: <1334333915-1174-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1334333915-1174-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2012 10:18 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> The driver has mux and config support while the gpio is still
> not supported.
> For select input setting, the driver will handle it internally
> and do not need user to take care of it.
> 
> The pinctrl-imx core driver will parse the dts file and dynamically
> create the pinmux functions and groups.
> 
> Each IMX SoC pinctrl driver should register pins with a pin register map
> including mux register and config register and select input map to core
> for proper operations.

> diff --git a/Documentation/devicetree/bindings/pinctrl/fsl,imx6q-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/fsl,imx6q-pinctrl.txt

> +* Freescale IOMUX Controller (IOMUXC) for i.MX
> +
> +The IOMUX Controller (IOMUXC), together with the IOMUX, enables the IC
> +to share one PAD to several functional blocks. The sharing is done by
> +multiplexing the PAD input/output signals. For each PAD there are up to
> +8 muxing options (called ALT modes). Since different modules require
> +different PAD settings (like pull up, keeper, etc) the IOMUXC controls
> +also the PAD settings parameters.
> +
> +Required properties:
> +
> +- compatible: "fsl,imx6q-iomuxc"
> +- fsl,pins : An array of strings. Each string represents the name of a pin.
> +  Refer to the following table for the availabe pins of imx6q to use.
> +- fsl,function: A string containing the name of the function to mux to the pin.

This document should really distinguish between required properties for
the top-level controller node ("compatible") and in the pin
configuration nodes ("fsl,pins", "fsl,function", and all the optional
properties below). As written, the documentation says I need "fsl,pins"
at the top-level.

Note that the documentation for fsl,function talks about a single
string, whereas the example below and the patch 3 in this series contain
an fsl,mux property that contains integers.

> +Requirements to use pinctrl-imx driver based on dt:
> +1. The pinmux function nodes should be defined under iomux controller node
> +2. The pin group nodes should be defined under function node which this group
> +   is intend to work on.
> +
> +The hierarchy is:
> +iomuxc@020e0000 {
> +	func-a {
> +		group-a {
> +			fsl,pins = "PIN_A",
> +				   "PIN_B",
> +				   ....
> +			fsl,mux = <...>,
> +			fsl,pull = <..>;
> +			fsl,drive-strength = <..>;
> +			...
> +		};
> +
> +		group-b {
> +			...
> +		};
> +		...
> +	};
> +
> +	func-b {
> +		...
> +	};
> +	...
> +};

I'd like to see some more explanation in the above part of the document.
In particular, what is the motivation for having a two-level binding
structure (group-a within func-a) rather than just having func-a
directly underneath the pin controller's node. How is a device tree
author supposed to know what to name the "func-a" and "group-a" nodes,
and how many "group-a"/"group-b" nodes should be inside a single
"func-a" node and why?

> +The function node name will be parsed as the pinmux function node, the group
> +node name will be parsed as the group name.

I don't understand that sentence. As far as I can tell, the names of the
function/group nodes aren't used for anything, at least according to the
binding documentation.

> diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile

>  obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
>  obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
>  obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
> +obj-$(CONFIG_PINCTRL_IMX)	+= pinctrl-imx.o

It might be nice to keep this list sorted as possible (admittedly COH901
isn't). Same goes for Kconfig.

> diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c

> +static const char *imx_get_group_name(struct pinctrl_dev *pctldev,
> +				       unsigned selector)
> +{
> +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> +	struct imx_pinctrl_info *info = ipmx->info;
> +
> +	if (selector >= info->ngroups)
> +		return NULL;

I think we decided to remove this error-checking from the drivers and
rely on the pinctrl core not to be bad to drivers. Certainly, a patch
from Viresh was committed to the Tegra driver to do that.

> +static int imx_pinconf_group_set(struct pinctrl_dev *pctldev,
> +				   unsigned group, unsigned long config)

> +	/* save the current group config value */
> +	info->groups[group].config = config;

This is only so imx_pinconf_group_get() can return it right? Why not
just read the value back from the register of the first pin in the group?

> +struct pinconf_ops imx_pinconf_ops = {
> +	.pin_config_get = imx_pinconf_get,
> +	.pin_config_set = imx_pinconf_set,

Given that the DT parsing code only generates group config, I'm not sure
you need to implement the per-pin config get/set; I don't think it will
ever get used?

> +static int __devinit imx_pmx_parse_functions(struct device_node *np,
> +			struct imx_pinctrl_info *info, u32 index)

Oh, I see.

You're defining the set of functions exported from the driver based on
the content of the pin configuration nodes in device tree. I must admit,
I don't like that much, and I didn't get that impression at all from
reading the binding document.

I know that there's some disagreement over whether the groups that a pin
controller driver exposes should be limited to groups that actually
exist in HW registers or not, but surely at least the functions that the
driver exposes should actually correspond directly to the function in
the HW registers?

> +#else
> +static int __devinit imx_pmx_probe_dt(struct platform_device *pdev,
> +				struct imx_pinctrl_info *info)
> +{
> +	return -ENODEV;
> +}
> +#endif

Hmm. If this driver is device-tree-only, shouldn't it depend on
CONFIG_OF in the Kconfig file? Then, you could remove all the "ifdef
CONFIG_OF" from this file. The rest of my comments assume you do want to
support CONFIG_OF-vs-not.

> +static const struct of_device_id imx_pmx_dt_ids[] = {
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, imx_pmx_dt_ids);

Other parts of the driver say "ifdef CONFIG_OF". You might want to here too.

> +static int __init imx_pmx_probe(struct platform_device *pdev)

> +	if (!devm_request_mem_region(dev, res->start, res_size, res->name))

> +	ipmx->base = devm_ioremap_nocache(dev, res->start, res_size);

You can combine those two into devm_request_and_ioremap() if you want.

> +static int __exit imx_pmx_remove(struct platform_device *pdev)

> +	platform_set_drvdata(pdev, NULL);

There's no need to clear the drvdata.

> +static struct platform_driver imx_pmx_driver = {
> +	.driver = {
> +		.name = DRIVER_NAME,
> +		.owner = THIS_MODULE,
> +		.of_match_table = imx_pmx_dt_ids,

Perhaps = of_match_ptr(imx_pmx_dt_ids)?
