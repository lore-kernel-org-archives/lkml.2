Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab2IZDud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 23:50:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44042 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2IZDuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 23:50:32 -0400
MIME-Version: 1.0
In-Reply-To: <1348575190-11761-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348575190-11761-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 26 Sep 2012 09:20:31 +0530
X-Google-Sender-Auth: setIsqiKIhqL4TOLvAR2w6FUpUI
Message-ID: <CAOh2x=kEDfY_DaBdbeY+CREiRJDH5yeNLUUuSpGTZcdWtZEd7g@mail.gmail.com>
Subject: Re: [PATCHv1 2/6] dmaengine: dw_dmac: add driver for Atmel AT32
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 5:43 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>
> This driver should be usable on all platforms that depend on clk API.

This is not what you mentioned in subject :(

> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/Kconfig        |    9 +++
>  drivers/dma/Makefile       |    1 +
>  drivers/dma/dw_dmac.c      |   23 +------
>  drivers/dma/dw_dmac_at32.c |  150 ++++++++++++++++++++++++++++++++++++++++++++

I don't agree with the naming used here. There is nothing AT32
specific here. It is actively used
by SPEAr. It should be named dw_dmac_platform.c or *pltfm.c

>  4 files changed, 162 insertions(+), 21 deletions(-)
>  create mode 100644 drivers/dma/dw_dmac_at32.c
>
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index df32537..e47cc90 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -89,6 +89,15 @@ config DW_DMAC
>           Support the Synopsys DesignWare AHB DMA controller.  This
>           can be integrated in chips such as the Atmel AT32ap7000.
>
> +config DW_DMAC_AT32
> +       tristate "Synopsys DesignWare AHB DMA support for Atmel"

:(

> +       depends on HAVE_CLK

Even this is not a must for all users of platform driver. So can leave this.

> +       select DW_DMAC
> +       default y if CPU_AT32AP7000
> +       help
> +         Support the Synopsys DesignWare AHB DMA controller in the chips
> +         such as the Atmel AT32ap7000.
> +
>  config AT_HDMAC
>         tristate "Atmel AHB DMA support"
>         depends on ARCH_AT91

> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index d9344a7..9c8a500 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -18,7 +18,6 @@
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> -#include <linux/of.h>
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> @@ -1681,35 +1680,17 @@ static const struct dev_pm_ops dw_dev_pm_ops = {
>         .poweroff_noirq = dw_suspend_noirq,
>  };
>
> -#ifdef CONFIG_OF
> -static const struct of_device_id dw_dma_id_table[] = {
> -       { .compatible = "snps,dma-spear1340" },
> -       {}
> -};
> -MODULE_DEVICE_TABLE(of, dw_dma_id_table);
> -#endif
> -
>  static struct platform_driver dw_driver = {
> +       .probe          = dw_probe,
>         .remove         = __devexit_p(dw_remove),
>         .shutdown       = dw_shutdown,
>         .driver = {
>                 .name   = "dw_dmac",
>                 .pm     = &dw_dev_pm_ops,
> -               .of_match_table = of_match_ptr(dw_dma_id_table),
>         },
>  };
>
> -static int __init dw_init(void)
> -{
> -       return platform_driver_probe(&dw_driver, dw_probe);
> -}
> -subsys_initcall(dw_init);
> -
> -static void __exit dw_exit(void)
> -{
> -       platform_driver_unregister(&dw_driver);
> -}
> -module_exit(dw_exit);
> +module_platform_driver(dw_driver);

Shouldn't this be a separate patch?

>
>  MODULE_LICENSE("GPL v2");
>  MODULE_DESCRIPTION("Synopsys DesignWare DMA Controller driver");
> diff --git a/drivers/dma/dw_dmac_at32.c b/drivers/dma/dw_dmac_at32.c
> new file mode 100644
> index 0000000..7bc7ac4
> --- /dev/null
> +++ b/drivers/dma/dw_dmac_at32.c
> @@ -0,0 +1,150 @@
> +/*
> + * Driver for the Synopsys DesignWare DMA Controller

How is this file different from dw_dmac.c?

> + *
> + * The driver is based on the excerpts from the original dw_dmac.c. That's why
> + * the same copyright holders are mentioned here as well.
> + *
> + * Copyright (C) 2007-2008 Atmel Corporation
> + * Copyright (C) 2010-2011 ST Microelectronics
> + * Copyright (C) 2012 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/clk.h>
> +#include <linux/of.h>
> +#include <linux/dw_dmac.h>
> +
> +struct dw_at32 {
> +       struct platform_device  *pdev;
> +       struct clk              *clk;
> +};
> +
> +static int __init dw_at32_probe(struct platform_device *pdev)
> +{
> +       struct dw_at32                  *at32;
> +       struct platform_device          *pd;
> +       struct dw_dma_platform_data     *pdata = pdev->dev.platform_data;
> +       static int                      instance;
> +       int                             ret;
> +
> +       at32 = devm_kzalloc(&pdev->dev, sizeof(*at32), GFP_KERNEL);
> +       if (!at32) {
> +               dev_err(&pdev->dev, "can't allocate memory\n");
> +               return -ENOMEM;
> +       }
> +
> +       pd = platform_device_alloc("dw_dmac", instance);
> +       if (!pd) {
> +               dev_err(&pdev->dev, "can't allocate dw_dmac platform device\n");
> +               return -ENOMEM;
> +       }

Why create another device? Why not simply call dw_probe() from here?
