Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab1JHJNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 05:13:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37648 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1JHJNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 05:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <1317629883-13582-1-git-send-email-linus.walleij@stericsson.com>
References: <1317629883-13582-1-git-send-email-linus.walleij@stericsson.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 8 Oct 2011 17:12:55 +0800
Message-ID: <CAGsJ_4yKZTRXW+qBOOCZiVZkm8UR=P=PKH=MW85fi884gtCFnQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinmux: add a driver for the U300 pinmux
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int __init u300_pmx_probe(struct platform_device *pdev)
> +{
> +       int ret;
> +       struct u300_pmx *upmx;
> +       struct resource *res;
> +
> +       /* Create state holders etc for this driver */
> +       upmx = devm_kzalloc(&pdev->dev, sizeof(struct u300_pmx), GFP_KERNEL);

and this would be "devm_kzalloc(&pdev->dev, sizeof(*upmx), GFP_KERNEL); " ?

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
> +       upmx->pctl = pinctrl_register(&u300_pmx_desc, &pdev->dev, upmx);
> +       if (IS_ERR(upmx->pctl)) {
> +               dev_err(&pdev->dev, "could not register U300 pinmux driver\n");
> +               ret = PTR_ERR(upmx->pctl);
> +               goto out_no_pmx;
> +       }
> +
> +       /* We will handle a range of GPIO pins */
> +       pinctrl_add_gpio_range(upmx->pctl, &u300_gpio_range);
> +
> +       platform_set_drvdata(pdev, upmx);
> +
> +       u300_pmx_dumpregs(upmx);
> +
> +       dev_info(&pdev->dev, "initialized U300 pinmux driver\n");
> +
> +       return 0;
> +
> +out_no_pmx:
> +       iounmap(upmx->virtbase);
> +out_no_remap:
> +       platform_set_drvdata(pdev, NULL);
> +out_no_memregion:
> +       release_mem_region(upmx->phybase, upmx->physize);
> +out_no_resource:
> +       devm_kfree(&pdev->dev, upmx);
> +       return ret;
> +}
> +
-barry
