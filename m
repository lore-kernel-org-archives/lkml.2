Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab2IZDmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 23:42:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38288 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2IZDmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 23:42:13 -0400
MIME-Version: 1.0
In-Reply-To: <1348575190-11761-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348575190-11761-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 26 Sep 2012 09:12:13 +0530
X-Google-Sender-Auth: LCgFQ8b6iMYWOUW3RuCyCeAnLz0
Message-ID: <CAOh2x=mhHzGennpHCnwHOG3rmNXv4NuK4ExSe0Se45zCowicnQ@mail.gmail.com>
Subject: Re: [PATCHv1 1/6] dmaengine: dw_dmac: Remove clk API dependency
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
> Not all platforms support clk API.
>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/Kconfig        |    1 -
>  drivers/dma/dw_dmac.c      |   18 +++---------------
>  drivers/dma/dw_dmac_regs.h |    1 -
>  3 files changed, 3 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 677cd6e..df32537 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -83,7 +83,6 @@ config INTEL_IOP_ADMA
>
>  config DW_DMAC
>         tristate "Synopsys DesignWare AHB DMA support"
> -       depends on HAVE_CLK
>         select DMA_ENGINE
>         default y if CPU_AT32AP7000
>         help

This change is good.

> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 9316d03..d9344a7 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1,9 +1,9 @@
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

these too.

> @@ -12,7 +12,6 @@
>  #define VERBOSE_DEBUG
>  #define DEBUG
>  #include <linux/bitops.h>
> -#include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/dmaengine.h>
>  #include <linux/dma-mapping.h>
> @@ -224,7 +223,6 @@ static inline void dwc_dump_chan_regs(struct dw_dma_chan *dwc)
>                 channel_readl(dwc, CTL_LO));
>  }
>
> -
>  static inline void dwc_chan_disable(struct dw_dma *dw, struct dw_dma_chan *dwc)
>  {
>         channel_clear_bit(dw, CH_EN, dwc->mask);
> @@ -1508,11 +1506,6 @@ static int __devinit dw_probe(struct platform_device *pdev)
>         if (!dw)
>                 return -ENOMEM;
>
> -       dw->clk = devm_clk_get(&pdev->dev, "hclk");
> -       if (IS_ERR(dw->clk))
> -               return PTR_ERR(dw->clk);
> -       clk_prepare_enable(dw->clk);
> -
>         dw->regs = regs;
>
>         /* get hardware configuration parameters */
> @@ -1657,19 +1650,14 @@ static int __devexit dw_remove(struct platform_device *pdev)
>
>  static void dw_shutdown(struct platform_device *pdev)
>  {
> -       struct dw_dma   *dw = platform_get_drvdata(pdev);
> -
>         dw_dma_off(platform_get_drvdata(pdev));
> -       clk_disable_unprepare(dw->clk);
>  }
>
>  static int dw_suspend_noirq(struct device *dev)
>  {
>         struct platform_device *pdev = to_platform_device(dev);
> -       struct dw_dma   *dw = platform_get_drvdata(pdev);
>
>         dw_dma_off(platform_get_drvdata(pdev));
> -       clk_disable_unprepare(dw->clk);
>
>         return 0;
>  }
> @@ -1679,8 +1667,8 @@ static int dw_resume_noirq(struct device *dev)
>         struct platform_device *pdev = to_platform_device(dev);
>         struct dw_dma   *dw = platform_get_drvdata(pdev);
>
> -       clk_prepare_enable(dw->clk);
>         dma_writel(dw, CFG, DW_CFG_DMA_EN);
> +
>         return 0;
>  }
>
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> index ff39fa6..50e0b63 100644
> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -229,7 +229,6 @@ struct dw_dma {
>         struct dma_device       dma;
>         void __iomem            *regs;
>         struct tasklet_struct   tasklet;
> -       struct clk              *clk;
>
>         u8                      all_chan_mask;

But not these. There are dummy clk routines available now for platforms which
don't support clk framework. So, even if your platform doesn't support clk
framework, you should be able to compile your code.

--
viresh
