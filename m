Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2IZONw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:13:52 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39430 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2IZONv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:13:51 -0400
MIME-Version: 1.0
In-Reply-To: <1348663237-3237-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 26 Sep 2012 19:43:49 +0530
X-Google-Sender-Auth: sSRMkQwbFfN_wrvw_AP0l1Wjk3I
Message-ID: <CAOh2x=m0bnhRBSSJNJQAiu54Dyu=0=2gG=-0AstUT815_wh9Bw@mail.gmail.com>
Subject: Re: [PATCHv2 1/4] dmaengine: dw_dmac: convert to platform driver
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 6:10 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>
> This driver could be used on different platforms. Thus, we converted it to be
> a platform driver. The HAVE_CLK dependency is dropped away as well.

Commit log and patch content don't match. :(
We aren't converting it to a platform driver, it is already one.

> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/Kconfig   |    2 --
>  drivers/dma/dw_dmac.c |   21 +++++++--------------
>  2 files changed, 7 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 677cd6e..75cdcb5 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -83,9 +83,7 @@ config INTEL_IOP_ADMA
>
>  config DW_DMAC
>         tristate "Synopsys DesignWare AHB DMA support"
> -       depends on HAVE_CLK

This matches subject.

>         select DMA_ENGINE
> -       default y if CPU_AT32AP7000

This doesn't. If you want this change, do this in a separate patch.

>         help
>           Support the Synopsys DesignWare AHB DMA controller.  This
>           can be integrated in chips such as the Atmel AT32ap7000.
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index c4b0eb3..9f0129d 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1,14 +1,15 @@
>  /*
> - * Driver for the Synopsys DesignWare DMA Controller (aka DMACA on
> - * AVR32 systems.)
> + * Core driver for the Synopsys DesignWare DMA Controller
>   *
>   * Copyright (C) 2007-2008 Atmel Corporation
>   * Copyright (C) 2010-2011 ST Microelectronics
> + * Copyright (C) 2012 Intel Corporation
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   */
> +
>  #include <linux/bitops.h>
>  #include <linux/clk.h>
>  #include <linux/delay.h>
> @@ -222,7 +223,6 @@ static inline void dwc_dump_chan_regs(struct dw_dma_chan *dwc)
>                 channel_readl(dwc, CTL_LO));
>  }
>
> -

Above + and - also don't belong to this patch

>  static inline void dwc_chan_disable(struct dw_dma *dw, struct dw_dma_chan *dwc)
>  {
>         channel_clear_bit(dw, CH_EN, dwc->mask);
> @@ -1679,6 +1679,7 @@ static int dw_resume_noirq(struct device *dev)
>
>         clk_prepare_enable(dw->clk);
>         dma_writel(dw, CFG, DW_CFG_DMA_EN);
> +
>         return 0;
>  }
>
> @@ -1700,6 +1701,7 @@ MODULE_DEVICE_TABLE(of, dw_dma_id_table);
>  #endif
>
>  static struct platform_driver dw_driver = {
> +       .probe          = dw_probe,
>         .remove         = __devexit_p(dw_remove),
>         .shutdown       = dw_shutdown,
>         .driver = {
> @@ -1709,18 +1711,9 @@ static struct platform_driver dw_driver = {
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

This should be a separate patch as well

>
> +MODULE_ALIAS("platform:dw_dmac");
>  MODULE_LICENSE("GPL v2");
>  MODULE_DESCRIPTION("Synopsys DesignWare DMA Controller driver");
>  MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
> --
> 1.7.10.4
>
