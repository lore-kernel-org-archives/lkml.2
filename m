Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab2IRG5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:57:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35719 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957Ab2IRG5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 02:57:31 -0400
MIME-Version: 1.0
In-Reply-To: <1347867577-13170-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1347867577-13170-5-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 18 Sep 2012 12:27:31 +0530
X-Google-Sender-Auth: Qrc-g8JSn3c4Wj4WYzvWzgNNxSI
Message-ID: <CAOh2x=noPEPNNEDJG7_BRV_eeY1PWxR=8EWpOCWLp_ohS-gpdw@mail.gmail.com>
Subject: Re: [PATCH 4/7] dw_dmac: autoconfigure block_size or use platform data
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
> @@ -1380,6 +1370,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
>         bool                    autocfg;
>         unsigned int            dw_params;
>         unsigned int            nr_channels;
> +       unsigned int            max_blk_size;
>         int                     irq;
>         int                     err;
>         int                     i;
> @@ -1420,6 +1411,9 @@ static int __devinit dw_probe(struct platform_device *pdev)
>
>         dw->regs = regs;
>
> +       /* get hardware configuration parameters */
> +       max_blk_size = dma_readl(dw, MAX_BLK_SIZE);
> +

Do this only for autocfg case.

>         /* Calculate all channel mask before DMA setup */
>         dw->all_chan_mask = (1 << nr_channels) - 1;
>
> @@ -1465,6 +1459,14 @@ static int __devinit dw_probe(struct platform_device *pdev)
>                 INIT_LIST_HEAD(&dwc->free_list);
>
>                 channel_clear_bit(dw, CH_EN, dwc->mask);
> +
> +               /* hardware configuration */
> +               if (autocfg) {
> +                       dwc->block_size =
> +                               (4 << ((max_blk_size >> 4 * i) & 0xf)) - 1;

Put a comment on what are you doing here.

> +               } else {
> +                       dwc->block_size = pdata->block_size;
> +               }

Don't need {} for single line statements.

>         }
>
>         /* Clear all interrupts on all channels. */
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> index 0f96965..233f5e5 100644
> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -186,6 +186,9 @@ struct dw_dma_chan {
>
>         unsigned int            descs_allocated;
>
> +       /* hardware configuration */
> +       unsigned short          block_size;
> +

You actually don't save any memory here with short and actually makes access
to block_size more complex. keeping it int would be better i believe.

viresh
