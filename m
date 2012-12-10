Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab2LJNuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:50:54 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61980 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2LJNux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:50:53 -0500
MIME-Version: 1.0
In-Reply-To: <1355139393-6718-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355139393-6718-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 10 Dec 2012 19:20:52 +0530
Message-ID: <CAKohponkfKz-78_0AXd2X7cLKujtyZ+_w0ghS6jb-S33uE9OhQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dw_dmac: backlink to dw_dma in dw_dma_chan is superfluous
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2012 17:06, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The same information could be exctracted from the struct dma_chan.
>
> The patch introduces two helpers dwc_get_src_data_width() and
> dwc_get_dst_data_width() as well.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c      |   27 ++++++++++++++++++++-------
>  drivers/dma/dw_dmac_regs.h |    3 ---
>  2 files changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index fdae96f..a9e9a07 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -73,6 +73,22 @@ static inline unsigned int dwc_get_sms(struct dw_dma_slave *slave)
>   */
>  #define NR_DESCS_PER_CHANNEL   64
>
> +static inline unsigned int dwc_get_src_data_width(struct dma_chan *chan)
> +{
> +       struct dw_dma           *dw = to_dw_dma(chan->device);
> +       struct dw_dma_slave     *dws = chan->private;

I never liked the tabs used before the variable names in this driver.
Though have kept them while fixing existing routines.

So, i would like you to use spaces for new functions.

> +
> +       return dw->data_width[dwc_get_sms(dws)];
> +}
> +
> +static inline unsigned int dwc_get_dst_data_width(struct dma_chan *chan)
> +{
> +       struct dw_dma           *dw = to_dw_dma(chan->device);
> +       struct dw_dma_slave     *dws = chan->private;
> +
> +       return dw->data_width[dwc_get_dms(dws)];
> +}

Can you try merging these routines into a single routine, by adding a
single param?

>  /*----------------------------------------------------------------------*/
>
>  /*
> @@ -703,7 +719,6 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
>                 size_t len, unsigned long flags)
>  {
>         struct dw_dma_chan      *dwc = to_dw_dma_chan(chan);
> -       struct dw_dma_slave     *dws = chan->private;
>         struct dw_desc          *desc;
>         struct dw_desc          *first;
>         struct dw_desc          *prev;
> @@ -726,8 +741,8 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
>
>         dwc->direction = DMA_MEM_TO_MEM;
>
> -       data_width = min_t(unsigned int, dwc->dw->data_width[dwc_get_sms(dws)],
> -                                        dwc->dw->data_width[dwc_get_dms(dws)]);
> +       data_width = min(dwc_get_src_data_width(chan),
> +                        dwc_get_dst_data_width(chan));

min_t() is more efficient then min(), that's why it was used.

>         src_width = dst_width = min_t(unsigned int, data_width,
>                                       dwc_fast_fls(src | dest | len));
> @@ -792,7 +807,6 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>                 unsigned long flags, void *context)
>  {
>         struct dw_dma_chan      *dwc = to_dw_dma_chan(chan);
> -       struct dw_dma_slave     *dws = chan->private;
>         struct dma_slave_config *sconfig = &dwc->dma_sconfig;
>         struct dw_desc          *prev;
>         struct dw_desc          *first;
> @@ -826,7 +840,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>                 ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_M2P) :
>                         DWC_CTLL_FC(DW_DMA_FC_D_M2P);
>
> -               data_width = dwc->dw->data_width[dwc_get_sms(dws)];
> +               data_width = dwc_get_src_data_width(chan);
>
>                 for_each_sg(sgl, sg, sg_len, i) {
>                         struct dw_desc  *desc;
> @@ -889,7 +903,7 @@ slave_sg_todev_fill_desc:
>                 ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_P2M) :
>                         DWC_CTLL_FC(DW_DMA_FC_D_P2M);
>
> -               data_width = dwc->dw->data_width[dwc_get_dms(dws)];
> +               data_width = dwc_get_dst_data_width(chan);
>
>                 for_each_sg(sgl, sg, sg_len, i) {
>                         struct dw_desc  *desc;
> @@ -1720,7 +1734,6 @@ static int dw_probe(struct platform_device *pdev)
>
>                 channel_clear_bit(dw, CH_EN, dwc->mask);
>
> -               dwc->dw = dw;
>                 dwc->direction = DMA_TRANS_NONE;
>
>                 /* hardware configuration */
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> index f9532c2..577f2dd 100644
> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -214,9 +214,6 @@ struct dw_dma_chan {
>
>         /* configuration passed via DMA_SLAVE_CONFIG */
>         struct dma_slave_config dma_sconfig;
> -
> -       /* backlink to dw_dma */
> -       struct dw_dma           *dw;
>  };
>
>  static inline struct dw_dma_chan_regs __iomem *
> --
> 1.7.10.4
>
