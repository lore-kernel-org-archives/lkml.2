Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab2IRGuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:50:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33832 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab2IRGuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 02:50:50 -0400
MIME-Version: 1.0
In-Reply-To: <1347867577-13170-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1347867577-13170-4-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 18 Sep 2012 12:20:49 +0530
X-Google-Sender-Auth: Hv9h-pZNjWL5eS1hUKPE-ybOCoc
Message-ID: <CAOh2x==MwD6RVnShoD0zJaAPZ814bAGDx6BEjGsK=9M+LxMxBA@mail.gmail.com>
Subject: Re: [PATCH 3/7] dw_dmac: get number of channels from hardware if possible
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 1:09 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> In case the controller has the encoded parameters feature enabled the driver
> will use it to get the number of channels. In the future it will be used for
> the other important parameters as well.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c      |   33 +++++++++++++++++++++++----------
>  drivers/dma/dw_dmac_regs.h |    4 ++++
>  2 files changed, 27 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 75ab5af..2a3b730 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1376,6 +1376,10 @@ static int __devinit dw_probe(struct platform_device *pdev)
>         struct resource         *io;
>         struct dw_dma           *dw;
>         size_t                  size;
> +       void __iomem            *regs;
> +       bool                    autocfg;
> +       unsigned int            dw_params;
> +       unsigned int            nr_channels;
>         int                     irq;
>         int                     err;
>         int                     i;
> @@ -1392,23 +1396,32 @@ static int __devinit dw_probe(struct platform_device *pdev)
>         if (irq < 0)
>                 return irq;
>
> -       size = sizeof(struct dw_dma);
> -       size += pdata->nr_channels * sizeof(struct dw_dma_chan);
> +       regs = devm_request_and_ioremap(&pdev->dev, io);
> +       if (!regs)
> +               return -EBUSY;
> +
> +       dw_params = dma_raw_readl(regs, DW_PARAMS);

Is this valid for every SoC implementation. What if this configuration
is not valid
for a particular SoC and it is invalid to access this address? Or this
gives a invalid
value instead of returning 0?

> +       autocfg = dw_params >> DW_PARAMS_EN & 0x1;
> +
> +       if (autocfg)
> +               nr_channels = (dw_params >> DW_PARAMS_NR_CHAN & 0x7) + 1;
> +       else
> +               nr_channels = pdata->nr_channels;
> +
> +       size = sizeof(struct dw_dma) + nr_channels * sizeof(struct dw_dma_chan);
>         dw = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
>         if (!dw)
>                 return -ENOMEM;
>
> -       dw->regs = devm_request_and_ioremap(&pdev->dev, io);
> -       if (!dw->regs)
> -               return -EBUSY;
> -
>         dw->clk = devm_clk_get(&pdev->dev, "hclk");
>         if (IS_ERR(dw->clk))
>                 return PTR_ERR(dw->clk);
>         clk_prepare_enable(dw->clk);
>
> +       dw->regs = regs;
> +
>         /* Calculate all channel mask before DMA setup */
> -       dw->all_chan_mask = (1 << pdata->nr_channels) - 1;
> +       dw->all_chan_mask = (1 << nr_channels) - 1;
>
>         /* force dma off, just in case */
>         dw_dma_off(dw);
> @@ -1426,7 +1439,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
>         tasklet_init(&dw->tasklet, dw_dma_tasklet, (unsigned long)dw);
>
>         INIT_LIST_HEAD(&dw->dma.channels);
> -       for (i = 0; i < pdata->nr_channels; i++) {
> +       for (i = 0; i < nr_channels; i++) {
>                 struct dw_dma_chan      *dwc = &dw->chan[i];
>
>                 dwc->chan.device = &dw->dma;
> @@ -1439,7 +1452,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
>
>                 /* 7 is highest priority & 0 is lowest. */
>                 if (pdata->chan_priority == CHAN_PRIORITY_ASCENDING)
> -                       dwc->priority = pdata->nr_channels - i - 1;
> +                       dwc->priority = nr_channels - i - 1;
>                 else
>                         dwc->priority = i;
>
> @@ -1480,7 +1493,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
>         dma_writel(dw, CFG, DW_CFG_DMA_EN);
>
>         printk(KERN_INFO "%s: DesignWare DMA Controller, %d channels\n",
> -                       dev_name(&pdev->dev), pdata->nr_channels);
> +                       dev_name(&pdev->dev), nr_channels);
>
>         dma_async_device_register(&dw->dma);
>
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> index 4633d39..0f96965 100644
> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -104,6 +104,10 @@ struct dw_dma_regs {
>  #define dma_raw_writel(addr, name, val) \
>         writel((val), (addr) + offsetof(struct dw_dma_regs, name))
>
> +/* Bitfields in DW_PARAMS */
> +#define DW_PARAMS_NR_CHAN      8               /* number of channels */
> +#define DW_PARAMS_EN           28              /* encoded parameters */
> +

Can you make this part of patch 2/7?

>  /* Bitfields in CTL_LO */
>  #define DWC_CTLL_INT_EN                (1 << 0)        /* irqs enabled? */
>  #define DWC_CTLL_DST_WIDTH(n)  ((n)<<1)        /* bytes per element */
> --
> 1.7.10.4
>
