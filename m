Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab2IRHLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:11:07 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52730 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab2IRHLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:11:05 -0400
MIME-Version: 1.0
In-Reply-To: <1347867577-13170-6-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1347867577-13170-6-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 18 Sep 2012 12:41:04 +0530
X-Google-Sender-Auth: e26djeVE18DLdgUOqqiL9wDzrlg
Message-ID: <CAOh2x=kRV-K+0SfBwoTkA641G9CeQWP4-4COMZKmkZGNL=1Dgw@mail.gmail.com>
Subject: Re: [PATCH 5/7] dw_dmac: autoconfigure data_width or get it via
 platform data
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
> @@ -647,7 +657,11 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
>                 return NULL;
>         }
>
> -       src_width = dst_width = dwc_fast_fls(src | dest | len);
> +       src_width = dst_width = min_t(unsigned int,
> +                                     /* For memory-to-memory transfers we
> +                                      * always use AHB master 1 */

Sorry couldn't understand your comment. :(
We use master 0 for src and master 1 for dst in memcpy.

> +                                     dwc->dw->data_width[0],
> +                                     dwc_fast_fls(src | dest | len));
>
>         ctllo = DWC_DEFAULT_CTLLO(chan)
>                         | DWC_CTLL_DST_WIDTH(dst_width)
> @@ -717,6 +731,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>         dma_addr_t              reg;
>         unsigned int            reg_width;
>         unsigned int            mem_width;
> +       unsigned int            data_width;
>         unsigned int            i;
>         struct scatterlist      *sg;
>         size_t                  total_len = 0;
> @@ -740,6 +755,8 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>                 ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_M2P) :
>                         DWC_CTLL_FC(DW_DMA_FC_D_M2P);
>
> +               data_width = dwc->dw->data_width[dwc_get_sms(dws)];
> +
>                 for_each_sg(sgl, sg, sg_len, i) {
>                         struct dw_desc  *desc;
>                         u32             len, dlen, mem;
> @@ -747,7 +764,9 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>                         mem = sg_dma_address(sg);
>                         len = sg_dma_len(sg);
>
> -                       mem_width = dwc_fast_fls(mem | len);
> +                       mem_width = min_t(unsigned int,
> +                                         data_width,
> +                                         dwc_fast_fls(mem | len));

can above three be merged into a single line or two lines?

>
>  slave_sg_todev_fill_desc:
>                         desc = dwc_desc_get(dwc);
> @@ -800,6 +819,8 @@ slave_sg_todev_fill_desc:
>                 ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_P2M) :
>                         DWC_CTLL_FC(DW_DMA_FC_D_P2M);
>
> +               data_width = dwc->dw->data_width[dwc_get_dms(dws)];
> +
>                 for_each_sg(sgl, sg, sg_len, i) {
>                         struct dw_desc  *desc;
>                         u32             len, dlen, mem;
> @@ -807,7 +828,9 @@ slave_sg_todev_fill_desc:
>                         mem = sg_dma_address(sg);
>                         len = sg_dma_len(sg);
>
> -                       mem_width = dwc_fast_fls(mem | len);
> +                       mem_width = min_t(unsigned int,
> +                                         data_width,
> +                                         dwc_fast_fls(mem | len));

ditto

>
>  slave_sg_fromdev_fill_desc:
>                         desc = dwc_desc_get(dwc);
> @@ -1413,6 +1436,17 @@ static int __devinit dw_probe(struct platform_device *pdev)
>
>         /* get hardware configuration parameters */
>         max_blk_size = dma_readl(dw, MAX_BLK_SIZE);
> +       if (autocfg)
> +               dw->nr_masters = (dw_params >> DW_PARAMS_NR_MASTER & 3) + 1;
> +       else
> +               dw->nr_masters = pdata->nr_masters;
> +       for (i = 0; i < dw->nr_masters; i++) {
> +               if (autocfg)
> +                       dw->data_width[i] =
> +                               (dw_params >> DW_PARAMS_DATA_WIDTH(i) & 3) + 2;
> +               else
> +                       dw->data_width[i] = pdata->data_width[i];
> +       }

There are many autocfg, if, else statements now in probe. Can you try
to group these
into as minimum if, else calls?

>
>         /* Calculate all channel mask before DMA setup */
>         dw->all_chan_mask = (1 << nr_channels) - 1;
> @@ -1460,6 +1494,8 @@ static int __devinit dw_probe(struct platform_device *pdev)
>
>                 channel_clear_bit(dw, CH_EN, dwc->mask);
>
> +               dwc->dw = dw;
> +
>                 /* hardware configuration */
>                 if (autocfg) {
>                         dwc->block_size =
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> index 233f5e5..9beaef0 100644
> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -106,6 +106,12 @@ struct dw_dma_regs {
>
>  /* Bitfields in DW_PARAMS */
>  #define DW_PARAMS_NR_CHAN      8               /* number of channels */
> +#define DW_PARAMS_NR_MASTER    11              /* number of AHB masters */
> +#define DW_PARAMS_DATA_WIDTH(n)        (15 + 2 * (n))
> +#define DW_PARAMS_DATA_WIDTH1  15              /* master 1 data width */
> +#define DW_PARAMS_DATA_WIDTH2  17              /* master 2 data width */
> +#define DW_PARAMS_DATA_WIDTH3  19              /* master 3 data width */
> +#define DW_PARAMS_DATA_WIDTH4  21              /* master 4 data width */
>  #define DW_PARAMS_EN           28              /* encoded parameters */
>

Do these changes in a single patch 2/7

viresh
