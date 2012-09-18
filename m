Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab2IRHRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:17:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56226 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976Ab2IRHRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:17:54 -0400
MIME-Version: 1.0
In-Reply-To: <1347867577-13170-8-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1347867577-13170-8-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 18 Sep 2012 12:47:53 +0530
X-Google-Sender-Auth: _Vz8Er-GKRWTZfGNbZ2YaE9EVIg
Message-ID: <CAOh2x=m3-XYEjJTh02AmnzoKJODAFf+OyQXtXaAdKTx3=GLrdg@mail.gmail.com>
Subject: Re: [PATCH 7/7] dw_dmac: introduce software emulation of LLP transfers
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
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 00958ad..fa23711 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -229,10 +229,29 @@ static inline void dwc_chan_disable(struct dw_dma *dw, struct dw_dma_chan *dwc)
>
>  /*----------------------------------------------------------------------*/
>
> +/* Perform single block transfer */
> +static inline void dwc_do_single_block(struct dw_dma_chan *dwc,
> +                                      struct dw_desc *desc)
> +{
> +       struct dw_dma   *dw = to_dw_dma(dwc->chan.device);
> +       u32             ctllo;
> +
> +       /* Software emulation of LLP mode relies on interrupts to continue
> +        * multi block transfer. */
> +       ctllo = desc->lli.ctllo | DWC_CTLL_INT_EN;
> +
> +       channel_writel(dwc, SAR, desc->lli.sar);
> +       channel_writel(dwc, DAR, desc->lli.dar);
> +       channel_writel(dwc, CTL_LO, ctllo);
> +       channel_writel(dwc, CTL_HI, desc->lli.ctlhi);
> +       channel_set_bit(dw, CH_EN, dwc->mask);
> +}
> +
>  /* Called with dwc->lock held and bh disabled */
>  static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
>  {
>         struct dw_dma   *dw = to_dw_dma(dwc->chan.device);
> +       unsigned long   was_soft_llp;
>
>         /* ASSERT:  channel is idle */
>         if (dma_readl(dw, CH_EN) & dwc->mask) {
> @@ -244,6 +263,26 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
>                 return;
>         }
>
> +       if (dwc->nollp) {
> +               was_soft_llp = test_and_set_bit(DW_DMA_IS_SOFT_LLP,
> +                                               &dwc->flags);
> +               if (was_soft_llp) {
> +                       dev_err(chan2dev(&dwc->chan),
> +                               "BUG: Attempted to start new LLP transfer "
> +                               "inside ongoing one\n");
> +                       return;
> +               }
> +
> +               dwc_initialize(dwc);
> +
> +               dwc->tx_list = &first->tx_list;
> +               dwc->tx_node_active = first->tx_list.next;
> +
> +               dwc_do_single_block(dwc, first);
> +
> +               return;
> +       }
> +
>         dwc_initialize(dwc);
>
>         channel_writel(dwc, LLP, first->txd.phys);
> @@ -555,8 +594,36 @@ static void dw_dma_tasklet(unsigned long data)
>                         dwc_handle_cyclic(dw, dwc, status_err, status_xfer);
>                 else if (status_err & (1 << i))
>                         dwc_handle_error(dw, dwc);
> -               else if (status_xfer & (1 << i))
> +               else if (status_xfer & (1 << i)) {
> +                       unsigned long flags;
> +
> +                       spin_lock_irqsave(&dwc->lock, flags);
> +                       if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags)) {
> +                               if (dwc->tx_node_active != dwc->tx_list) {
> +                                       struct dw_desc *desc =
> +                                               list_entry(dwc->tx_node_active,
> +                                                          struct dw_desc,
> +                                                          desc_node);

can come in single line.

> +
> +                                       dma_writel(dw, CLEAR.XFER, dwc->mask);
> +
> +                                       /* move pointer to next descriptor */
> +                                       dwc->tx_node_active =
> +                                               dwc->tx_node_active->next;
> +
> +                                       dwc_do_single_block(dwc, desc);
> +
> +                                       spin_unlock_irqrestore(&dwc->lock, flags);
> +                                       continue;
> +                               } else {
> +                                       /* we are done here */
> +                                       clear_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags);
> +                               }
> +                       }
> +                       spin_unlock_irqrestore(&dwc->lock, flags);
> +
>                         dwc_scan_descriptors(dw, dwc);
> +               }
>         }
>
>         /*
> @@ -647,12 +714,6 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
>         unsigned int            dst_width;
>         u32                     ctllo;
>
> -       if (dwc->nollp) {
> -               dev_dbg(chan2dev(&dwc->chan),
> -                               "channel doesn't support LLP transfers\n");
> -               return NULL;
> -       }
> -

:)
You should actually merge 6/7 with 7/7... You can't revert something
in the same patchset.

viresh
