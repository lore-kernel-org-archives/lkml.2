Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab1HUN4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 09:56:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60138 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab1HUN4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 09:56:14 -0400
MIME-Version: 1.0
In-Reply-To: <1313747646-32294-1-git-send-email-linus.walleij@stericsson.com>
References: <1313747646-32294-1-git-send-email-linus.walleij@stericsson.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 21 Aug 2011 21:55:53 +0800
Message-ID: <CAGsJ_4wK6V0aQJd7f1geM8XnzQO+3TNCE6Q8_j=VYf_z_gcmpA@mail.gmail.com>
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

Hi Linus,
Looks pretty good. just some minors.

2011/8/19 Linus Walleij <linus.walleij@stericsson.com>:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> This adds a driver for the U300 pinmux portions of the system
> controller "SYSCON". It also serves as an example of how to use
> the pinmux subsystem. This driver also houses the platform data
> for the only supported platform.

yes. it is a good example for us to follow.

>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> +
> +static int __exit u300_pmx_remove(struct platform_device *pdev)
> +{
> +       struct u300_pmx *upmx = platform_get_drvdata(pdev);
> +
> +       if (upmx) {

why do you need to check whether upmx is not NULL. if it is NULL, we
have failed in probe().
and it is also impossible to call this remove() twice.

> +               pinmux_unregister(upmx->pmx);
> +               iounmap(upmx->virtbase);
> +               release_mem_region(upmx->phybase, upmx->physize);
> +               platform_set_drvdata(pdev, NULL);
> +               kfree(upmx);
> +       }
> +
> +       return 0;
> +}
> +
> +static struct platform_driver u300_pmx_driver = {
> +       .driver = {
> +               .name = DRIVER_NAME,
> +               .owner = THIS_MODULE,
> +       },
> +       .remove = __exit_p(u300_pmx_remove),

if you want to add deepsleep support(i mean pinmux crl will lose power
while suspending), what do you plan to add?
save U300_SYSCON_PMC1LR, U300_SYSCON_PMC1HR, U300_SYSCON_PMC2R,
U300_SYSCON_PMC3R, U300_SYSCON_PMC4R in suspend and restore them in
resume?

it is also a generic issue to pinmux.

> +/*
> + * Register definitions for the U300 Padmux control registers in the
> + * system controller
> + */
> +
> +/* PAD MUX Control register 1 (LOW) 16bit (R/W) */
> +#define U300_SYSCON_PMC1LR                                     (0x007C)
...
> +#define U300_SYSCON_PMC4R_APP_MISC_16_EMIF_1_STATIC_CS5_N      (0x0200)

do you want these "(" ")" for macros?

Thanks
barry
