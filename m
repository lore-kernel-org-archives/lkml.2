Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab2DSPaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 11:30:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38328 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab2DSPaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 11:30:12 -0400
Date: Thu, 19 Apr 2012 23:28:59 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, s.hauer@pengutronix.de, shawn.guo@freescale.com,
        kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Subject: Re: [PATCH 1/3] pinctrl: pinctrl-imx: add imx pinctrl core driver
Message-ID: <20120419152857.GE22219@S2101-09.ap.freescale.net>
References: <1334333915-1174-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334333915-1174-1-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 12:18:33AM +0800, Dong Aisheng wrote:
> +config PINCTRL_IMX
> +	bool "Freescale IMX core pinctrl driver"
> +	depends on ARCH_MXC
> +
I would expect it just be:

config PINCTRL_IMX
        bool

It should be selected by PINCTRL_IMX6Q, which should in turn be
selected by arch/soc config.  Neither PINCTRL_IMX nor PINCTRL_IMX6Q
should be user visible option.

> +	/* generate mux map */
> +	parent = of_get_parent(np);
> +	if (!parent)
> +		return -EINVAL;
> +

You need to call of_node_put(parent), when you are done with the node.

> +	info->ngroups = 0;
> +	for_each_child_of_node(np, child)
> +		info->ngroups += of_get_child_count(child);
> +	info->groups = devm_kzalloc(&pdev->dev, nfuncs * sizeof(struct imx_pin_group),

s/nfuncs/info->ngroups?

> +static inline void imx_pmx_desc_init(struct pinctrl_desc *pmx_desc,
> +				const struct imx_pinctrl_info *info)
> +{
> +	pmx_desc->pins = info->pins;
> +	pmx_desc->npins = info->npins;
> +}
> +
I do not see much point with this inline function.

> +/**
> + * struct imx_pmx_func - describes IMX pinmux functions
> + * @name: the name of this specific function
> + * @groups: corresponding pin groups
> + */
> +struct imx_pmx_func {
> +	const char *name;
> +	const char **groups;
> +	unsigned num_groups;

Missed from kernel doc above.

If you make kernel doc, you need to make it perfectly right :)

> +};
> +
> +/**
> + * struct imx_pin_reg - describe a pin reg map
> + * The last 3 members are used for select input setting
> + * @pid: pin id
> + * @mux_reg: mux register offset
> + * @conf_reg: config register offset
> + * @mux: mux mode
> + * @input_reg: select input register offset for this mux if any
> + *  0 if no select input setting needed.
> + * @input_val: the value set to select input register
> + */
> +struct imx_pin_reg {
> +	unsigned int pid;
> +	unsigned int mux_reg;
> +	unsigned int conf_reg;
> +	unsigned int mux_mode;

Name mismatch with kernel doc.

> +	unsigned int input_reg;
> +	unsigned int input_val;
> +};
> +
> +/*
> + * struct imx_config_properties - describes the available dt pin config properties
> + * @property: the property name of a config
> + * @off: the bit offset of this config in pin config register
> + */
> +struct imx_config_properties {
> +	const char *property;
> +	const unsigned int off;
> +	const unsigned int mask;

Missed from kernel doc above.

> +};
> +
> +struct imx_pinctrl_info {
> +	struct device *dev;
> +	u32 type;

Since you have "enum imx_pinctrl_type", shouldn't it be used here?

Regards,
Shawn

> +	const struct pinctrl_pin_desc *pins;
> +	unsigned int npins;
> +	const struct imx_pin_reg *pin_regs;
> +	unsigned int npin_regs;
> +	const struct imx_config_properties *conf_properties;
> +	unsigned int nconf_properties;
> +	struct imx_pin_group *groups;
> +	unsigned int ngroups;
> +	struct imx_pmx_func *functions;
> +	unsigned int nfunctions;
> +};
> +
