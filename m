Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab1LNVrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:47:42 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39503 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab1LNVrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:47:41 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdY=Zerp+ULAdv4PHD+u-65PrAci7rQRbkso5KE05UqdOA@mail.gmail.com>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
 <1323878622-26602-3-git-send-email-b29396@freescale.com> <CACRpkdY=Zerp+ULAdv4PHD+u-65PrAci7rQRbkso5KE05UqdOA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Dec 2011 14:47:18 -0700
X-Google-Sender-Auth: h0L7vMpG4u-hpDj_WP9sOjk3tJU
Message-ID: <CACxGe6tG8CF5AwD0Xn5_O-Ddw-waFbBWB-gubov4DfZY76Ak8A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/4] pinctrl: imx: add pinmux imx driver
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de, shawn.guo@freescale.com, kernel@pengutronix.de,
        rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:00 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Wed, Dec 14, 2011 at 5:03 PM, Dong Aisheng <b29396@freescale.com> wrote:
>
>> The driver contains the initial support for imx53 and
>> imx6q.
>
> Cool! Comments below...
>
>> --- /dev/null
>> +++ b/drivers/pinctrl/pinmux-imx-core.c
>
> We should start naming these pinctrl-* rather than pinmux-*
> so just rename it.
>
> Until here it looks like business as usual..
>
>> +#ifdef CONFIG_OF
>> +static int __devinit imx_pmx_parse_functions(struct device_node *np,
>> +                       struct imx_pinctrl_info *info, u32 num)
>> +{
>> +       struct imx_pmx_func *function;
>> +       struct imx_pin_group *group;
>> +       int ret, len;
>> +
>> +       dev_dbg(info->dev, "parse function %d\n", num);
>> +
>> +       group = &info->groups[num];
>> +       function = &info->functions[num];
>> +
>> +       /* Initialise group */
>> +       ret = of_property_read_string(np, "grp_name", &group->name);
>> +       if (ret) {
>> +               dev_err(info->dev, "failed to get grp_name\n");
>> +               return ret;
>> +       }
>> +
>> +       ret = of_property_read_u32(np, "num_pins", &group->num_pins);
>> +       if (ret) {
>> +               dev_err(info->dev, "failed to get num_pins\n");
>> +               return ret;
>> +       }
>> +
>> +       ret = of_property_read_u32(np, "num_mux", &group->num_mux);
>> +       if (ret) {
>> +               dev_err(info->dev, "failed to get num_mux\n");
>> +               return ret;
>> +       }
>> +
>> +       if (group->num_pins != group->num_mux)
>> +               return -EINVAL;
>> +
>> +       group->pins = devm_kzalloc(info->dev, group->num_pins * sizeof(unsigned int),
>> +                               GFP_KERNEL);
>> +       group->mux_mode = devm_kzalloc(info->dev, group->num_mux * sizeof(unsigned int),
>> +                               GFP_KERNEL);
>> +       if (!group->pins || !group->mux_mode)
>> +               return -ENOMEM;
>> +
>> +       /* sanity check */
>> +       if (of_get_property(np, "grp_pins", &len) &&
>> +               len != group->num_pins * sizeof(unsigned int)) {
>> +               dev_err(info->dev, "wrong pins number?\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (of_get_property(np, "grp_mux", &len) &&
>> +               len != group->num_mux * sizeof(unsigned int)) {
>> +               dev_err(info->dev, "wrong pin mux number?\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       ret = of_property_read_u32_array(np, "grp_pins",
>> +                       group->pins, group->num_pins);
>> +       if (ret) {
>> +               dev_err(info->dev, "failed to get grp_pins\n");
>> +               return ret;
>> +       }
>> +
>> +       ret = of_property_read_u32_array(np, "grp_mux",
>> +                       group->mux_mode, group->num_mux);
>> +       if (ret) {
>> +               dev_err(info->dev, "failed to get grp_mux\n");
>> +               return ret;
>> +       }
>> +
>> +       /* Initialise function */
>> +       ret = of_property_read_string(np, "func_name", &function->name);
>> +       if (ret) {
>> +               dev_err(info->dev, "failed to get func_name\n");
>> +               return ret;
>> +       }
>> +
>> +       function->groups = devm_kzalloc(info->dev, sizeof(char **), GFP_KERNEL);
>> +       function->num_groups = 1;
>> +       function->groups[0] = group->name;
>> +
>> +       dev_dbg(info->dev, "func_name %s grp_name %s num_groups %d\n",
>> +                               function->name, function->groups[0],
>> +                               function->num_groups);
>> +
>> +       return 0;
>> +}
>> +
>> +static int __devinit imx_pmx_probe_dt(struct platform_device *pdev,
>> +                               struct imx_pinctrl_info *info)
>> +{
>> +       struct device_node *np = pdev->dev.of_node;
>> +       struct device_node *child = NULL;
>> +       int ret, i;
>> +       u32 nfuncs = 0;
>> +
>> +       if (!np)
>> +               return -ENODEV;
>> +
>> +       nfuncs = of_get_child_number(np);
>> +       if (nfuncs <= 0) {
>> +               dev_err(&pdev->dev, "no functions defined\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       info->nfunctions = nfuncs;
>> +       info->functions = devm_kzalloc(&pdev->dev, nfuncs * sizeof(struct imx_pmx_func),
>> +                                       GFP_KERNEL);
>> +       if (!info->functions)
>> +               return -ENOMEM;
>> +
>> +       /* DT file only passes one group per one function */
>> +       info->ngroups = nfuncs;
>> +       info->groups = devm_kzalloc(&pdev->dev, nfuncs * sizeof(struct imx_pin_group),
>> +                                       GFP_KERNEL);
>> +       if (!info->groups)
>> +               return -ENOMEM;
>> +
>> +       child = NULL;
>> +       i = 0;
>> +       for_each_child_of_node(np, child) {
>> +               ret = imx_pmx_parse_functions(child, info, i++);
>> +               if (ret) {
>> +                       dev_err(&pdev->dev, "failed to parse function\n");
>> +                       return ret;
>> +               }
>> +       }
>> +
>> +       return 0;
>> +}
>> +#else
>> +static int __devinit imx_pmx_probe_dt(struct platform_device *pdev,
>> +                               struct imx_pinctrl_info *info)
>> +{
>> +       return -ENODEV;
>> +}
>> +#endif
>
> Looks clever to me! And I think we have agreed that this probing
> must be inside each driver.
>
> Can we have a look at the corresponding device tree?

... and binding documentation.  While on that topic, the convention is
for property names to use dash '-' characters, not underscores '_'.
The properties I see here are using the later.

g.
