Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab0LCX4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 18:56:15 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38282 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab0LCX4N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 18:56:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Z/j3E6TU0sspROiANiEKgoYStx3ScPD1QHiJAfHF2QG7mM1Ph7wVItbI9QBXVh9Zbs
         yopg89ReZDzaa+EnUZDo/0NaDRccAQz5pT2LR5AG2HETqogkYzjIcjCwsRBX18fg2Ew0
         eCztN7Hl8jQmC049FJtGJdfbntaEnp7Qh3C9Q=
MIME-Version: 1.0
In-Reply-To: <1290510371-23077-3-git-send-email-jamie@jamieiles.com>
References: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
	<1290510371-23077-3-git-send-email-jamie@jamieiles.com>
Date: Fri, 3 Dec 2010 15:56:12 -0800
X-Google-Sender-Auth: MRNHWsTbq72ZVUTbtlmJ1s-IgGk
Message-ID: <AANLkTi=smnpvG=GAHtRS5-P3UdOE1A9RT04i8hcTb4Af@mail.gmail.com>
Subject: Re: [PATCH 2/4] dmaengine/dw_dmac: allow src/dst masters to be
 configured at runtime
From: Dan Williams <dan.j.williams@intel.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
        Jamie Iles <jamie.iles@picochip.com>, hskinnemoen@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ copying Haavard's new address ]

On Tue, Nov 23, 2010 at 3:06 AM, Jamie Iles <jamie@jamieiles.com> wrote:
> Some platforms have flexible mastering capabilities and this needs
> to be selected at runtime. If the platform has specified private
> data in the form of the dw_dma_slave then fetch the source and
> destination masters from here. If this isn't present, default to
> the previous of 0 and 1.
>
> Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
> ---
>  drivers/dma/dw_dmac.c   |   31 +++++++++++++++++--------------
>  include/linux/dw_dmac.h |    2 ++
>  2 files changed, 19 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 08c51d4..64024f1 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -32,15 +32,18 @@
>  * which does not support descriptor writeback.
>  */
>
> -/* NOTE:  DMS+SMS is system-specific. We should get this information
> - * from the platform code somehow.
> - */
> -#define DWC_DEFAULT_CTLLO      (DWC_CTLL_DST_MSIZE(0)          \
> -                               | DWC_CTLL_SRC_MSIZE(0)         \
> -                               | DWC_CTLL_DMS(0)               \
> -                               | DWC_CTLL_SMS(1)               \
> -                               | DWC_CTLL_LLP_D_EN             \
> -                               | DWC_CTLL_LLP_S_EN)
> +#define DWC_DEFAULT_CTLLO(private) ({                           \
> +                struct dw_dma_slave *__slave = (private);       \
> +                int dms = __slave ? __slave->dst_master : 0;    \
> +                int sms = __slave ? __slave->src_master : 1;    \
> +                                                                \
> +                (DWC_CTLL_DST_MSIZE(0)                         \
> +                 | DWC_CTLL_SRC_MSIZE(0)                       \
> +                 | DWC_CTLL_LLP_D_EN                           \
> +                 | DWC_CTLL_LLP_S_EN                            \
> +                 | DWC_CTLL_DMS(dms)                           \
> +                 | DWC_CTLL_SMS(sms));                         \
> +        })
>
>  /*
>  * This is configuration-dependent and usually a funny size like 4095.
> @@ -591,7 +594,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
>        else
>                src_width = dst_width = 0;
>
> -       ctllo = DWC_DEFAULT_CTLLO
> +       ctllo = DWC_DEFAULT_CTLLO(chan->private)
>                        | DWC_CTLL_DST_WIDTH(dst_width)
>                        | DWC_CTLL_SRC_WIDTH(src_width)
>                        | DWC_CTLL_DST_INC
> @@ -672,7 +675,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>
>        switch (direction) {
>        case DMA_TO_DEVICE:
> -               ctllo = (DWC_DEFAULT_CTLLO
> +               ctllo = (DWC_DEFAULT_CTLLO(chan->private)
>                                | DWC_CTLL_DST_WIDTH(reg_width)
>                                | DWC_CTLL_DST_FIX
>                                | DWC_CTLL_SRC_INC
> @@ -717,7 +720,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>                }
>                break;
>        case DMA_FROM_DEVICE:
> -               ctllo = (DWC_DEFAULT_CTLLO
> +               ctllo = (DWC_DEFAULT_CTLLO(chan->private)
>                                | DWC_CTLL_SRC_WIDTH(reg_width)
>                                | DWC_CTLL_DST_INC
>                                | DWC_CTLL_SRC_FIX
> @@ -1129,7 +1132,7 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
>                case DMA_TO_DEVICE:
>                        desc->lli.dar = dws->tx_reg;
>                        desc->lli.sar = buf_addr + (period_len * i);
> -                       desc->lli.ctllo = (DWC_DEFAULT_CTLLO
> +                       desc->lli.ctllo = (DWC_DEFAULT_CTLLO(chan->private)
>                                        | DWC_CTLL_DST_WIDTH(reg_width)
>                                        | DWC_CTLL_SRC_WIDTH(reg_width)
>                                        | DWC_CTLL_DST_FIX
> @@ -1140,7 +1143,7 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
>                case DMA_FROM_DEVICE:
>                        desc->lli.dar = buf_addr + (period_len * i);
>                        desc->lli.sar = dws->rx_reg;
> -                       desc->lli.ctllo = (DWC_DEFAULT_CTLLO
> +                       desc->lli.ctllo = (DWC_DEFAULT_CTLLO(chan->private)
>                                        | DWC_CTLL_SRC_WIDTH(reg_width)
>                                        | DWC_CTLL_DST_WIDTH(reg_width)
>                                        | DWC_CTLL_DST_INC
> diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
> index c8aad71..8014eb8 100644
> --- a/include/linux/dw_dmac.h
> +++ b/include/linux/dw_dmac.h
> @@ -52,6 +52,8 @@ struct dw_dma_slave {
>        enum dw_dma_slave_width reg_width;
>        u32                     cfg_hi;
>        u32                     cfg_lo;
> +       int                     src_master;
> +       int                     dst_master;
>  };
>
>  /* Platform-configurable bits in CFG_HI */
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
