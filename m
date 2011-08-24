Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab1HXGqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:46:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38135 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1HXGqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:46:23 -0400
MIME-Version: 1.0
In-Reply-To: <1313747646-32294-1-git-send-email-linus.walleij@stericsson.com>
References: <1313747646-32294-1-git-send-email-linus.walleij@stericsson.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 24 Aug 2011 14:46:02 +0800
Message-ID: <CAGsJ_4zwDimvQYSq-6Xck8QvyJjnm=NhyK80tUVNC4ZuLw17+w@mail.gmail.com>
Subject: Re: [PATCH 2/4 v4] pinmux: add a driver for the U300 pinmux
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/**
> + * @dev: a pointer back to containing device
> + * @virtbase: the offset to the controller in virtual memory
> + */
> +struct u300_pmx {
> +       struct device *dev;
> +       struct pinmux_dev *pmx;

 pinctrl_dev?

> +static int u300_pmx_enable(struct pinmux_dev *pmxdev, unsigned selector)

 pinctrl_dev?

> +{
> +       struct u300_pmx *upmx;
> +
> +       if (selector >= ARRAY_SIZE(u300_pmx_funcs))
> +               return -EINVAL;
> +       upmx = pmxdev_get_drvdata(pmxdev);
> +       u300_pmx_endisable(upmx, selector, true);
> +
> +       return 0;
> +}
> +
> +static void u300_pmx_disable(struct pinmux_dev *pmxdev, unsigned selector)

 pinctrl_dev?

> +{
> +       struct u300_pmx *upmx;
> +
> +       if (selector >= ARRAY_SIZE(u300_pmx_funcs))
> +               return;
> +       upmx = pmxdev_get_drvdata(pmxdev);

pctrldev_get_drvdata?

> +       u300_pmx_endisable(upmx, selector, false);
> +}
> +
> +static int u300_pmx_list(struct pinmux_dev *pmxdev, unsigned selector)

 pinctrl_dev?

> +{
> +       if (selector >= ARRAY_SIZE(u300_pmx_funcs))
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static const char *u300_pmx_get_fname(struct pinmux_dev *pmxdev,
> +                                     unsigned selector)

 pinctrl_dev?

> +{
> +       if (selector >= ARRAY_SIZE(u300_pmx_funcs))
> +               return NULL;
> +       return u300_pmx_funcs[selector].name;
> +}
> +
> +static int u300_pmx_get_pins(struct pinmux_dev *pmxdev, unsigned selector,
> +                            unsigned ** const pins, unsigned * const num_pins)

 pinctrl_dev?

> +{
> +       if (selector >= ARRAY_SIZE(u300_pmx_funcs))
> +               return -EINVAL;
> +       *pins = (unsigned *) u300_pmx_funcs[selector].pins;
> +       *num_pins = u300_pmx_funcs[selector].num_pins;
> +       return 0;
> +}
> +
> +static void u300_dbg_show(struct pinmux_dev *pmxdev, struct seq_file *s,

 pinctrl_dev?

> +                  unsigned offset)
> +{
> +       seq_printf(s, " " DRIVER_NAME);
> +}
> +
> +static struct pinmux_ops u300_pmx_ops = {
> +       .list_functions = u300_pmx_list,
> +       .get_function_name = u300_pmx_get_fname,
> +       .get_function_pins = u300_pmx_get_pins,
> +       .enable = u300_pmx_enable,
> +       .disable = u300_pmx_disable,
> +       .dbg_show = u300_dbg_show,
> +};
> +
> +static struct pinmux_desc u300_pmx_desc = {
> +       .name = DRIVER_NAME,
> +       .pins = u300_pads,
> +       .npins = ARRAY_SIZE(u300_pads),
> +       .maxpin = U300_NUM_PADS-1,
> +       .pmxops = &u300_pmx_ops,
> +       .owner = THIS_MODULE,
> +};
> +
> +static int __init u300_pmx_probe(struct platform_device *pdev)
> +{
> +       int ret;
> +       struct u300_pmx *upmx;
> +       struct resource *res;
> +
> +       /* Create state holders etc for this driver */
> +       upmx = kzalloc(sizeof(struct u300_pmx), GFP_KERNEL);
> +       if (!upmx)
> +               return -ENOMEM;
> +
> +       upmx->dev = &pdev->dev;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res) {
> +               ret = -ENOENT;
> +               goto out_no_resource;
> +       }
> +       upmx->phybase = res->start;
> +       upmx->physize = resource_size(res);
> +
> +       if (request_mem_region(upmx->phybase, upmx->physize,
> +                              DRIVER_NAME) == NULL) {
> +               ret = -EBUSY;
> +               goto out_no_memregion;
> +       }
> +
> +       upmx->virtbase = ioremap(upmx->phybase, upmx->physize);
> +       if (!upmx->virtbase) {
> +               ret = -ENOMEM;
> +               goto out_no_remap;
> +       }
> +
> +       /* Now register the pin controller and all pins it handles */
> +       upmx->pctl = pinctrl_register(&u300_pmx_desc, &pdev->dev, upmx);
> +       if (IS_ERR(upmx->pctl)) {
> +               dev_err(&pdev->dev, "could not register U300 pinmux driver\n");
> +               ret = PTR_ERR(upmx->pmx);
> +               goto out_no_pmx;
> +       }
> +       platform_set_drvdata(pdev, upmx);
> +
> +       dev_info(&pdev->dev, "initialized U300 pinmux driver\n");
> +
> +       return 0;
> +
> +out_no_pmx:
> +       iounmap(upmx->virtbase);
> +out_no_remap:
> +       platform_set_drvdata(pdev, NULL);

where have you set drv data to non-NULL?

> +out_no_memregion:
> +       release_mem_region(upmx->phybase, upmx->physize);
> +out_no_resource:
> +       kfree(upmx);
> +       return ret;
> +}
> +

-barry
