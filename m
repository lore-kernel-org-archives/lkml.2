Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2LJN52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:57:28 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:65464 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2LJN51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:57:27 -0500
MIME-Version: 1.0
In-Reply-To: <1355139393-6718-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355139393-6718-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1355139393-6718-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 10 Dec 2012 19:27:26 +0530
Message-ID: <CAKohpomBouYpmsz9M=4efzriuGLrMc43uE3quYN_wHF8stznWw@mail.gmail.com>
Subject: Re: [PATCH 2/2] dw_dmac: check for mapping errors
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
> Otherwise we get a warning in case of CONFIG_DMA_API_DEBUG=y
>
> [   45.775943] WARNING: at lib/dma-debug.c:933 check_unmap+0x5d6/0x6ac()
> [   45.782369] dw_dmac dw_dmac.0: DMA-API: device driver failed to check map error[device address=0x00000000356efcc0] [size=28 bytes] [mapped as single]
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index a9e9a07..38eea0c 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1107,6 +1107,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
>         struct dw_desc          *desc;
>         int                     i;
>         unsigned long           flags;
> +       int                     ret = 0;
>
>         dev_vdbg(chan2dev(chan), "%s\n", __func__);
>
> @@ -1131,8 +1132,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
>
>                 desc = kzalloc(sizeof(struct dw_desc), GFP_KERNEL);
>                 if (!desc) {
> -                       dev_info(chan2dev(chan),
> -                               "only allocated %d descriptors\n", i);
> +                       ret = -ENOMEM;
>                         spin_lock_irqsave(&dwc->lock, flags);
>                         break;
>                 }
> @@ -1143,6 +1143,13 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
>                 desc->txd.flags = DMA_CTRL_ACK;
>                 desc->txd.phys = dma_map_single(chan2parent(chan), &desc->lli,
>                                 sizeof(desc->lli), DMA_TO_DEVICE);
> +               ret = dma_mapping_error(chan2parent(chan), desc->txd.phys);
> +               if (ret) {
> +                       kfree(desc);
> +                       spin_lock_irqsave(&dwc->lock, flags);
> +                       break;
> +               }
> +
>                 dwc_desc_put(dwc, desc);
>
>                 spin_lock_irqsave(&dwc->lock, flags);
> @@ -1151,6 +1158,9 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
>
>         spin_unlock_irqrestore(&dwc->lock, flags);
>
> +       if (ret)
> +               dev_info(chan2dev(chan), "only allocated %d descriptors\n", i);
> +
>         dev_dbg(chan2dev(chan), "%s: allocated %d descriptors\n", __func__, i);
>
>         return i;

I would use goto with appropriate label: to avoid lock/unlock of spin_lock.
