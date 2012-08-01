Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab2HAQpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:45:42 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:35827 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2HAQpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:45:41 -0400
Date: Wed, 1 Aug 2012 09:35:53 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: qiang.liu@freescale.com
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, dan.j.williams@gmail.com,
        Vinod Koul <vinod.koul@intel.com>, herbert@gondor.hengli.com.au,
        Dan Williams <dan.j.williams@intel.com>, davem@davemloft.net
Subject: Re: [PATCH v5 2/6] fsl-dma: remove attribute DMA_INTERRUPT of
 dmaengine
Message-ID: <20120801163553.GC11359@ovro.caltech.edu>
References: <1343810948-25343-1-git-send-email-qiang.liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343810948-25343-1-git-send-email-qiang.liu@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (ovro.ovro.caltech.edu); Wed, 01 Aug 2012 09:35:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 04:49:08PM +0800, qiang.liu@freescale.com wrote:
> From: Qiang Liu <qiang.liu@freescale.com>
> 
> Delete attribute DMA_INTERRUPT because fsl-dma doesn't support this function,
> exception will be thrown if talitos is used to offload xor at the same time.
> 

I have no problem with this patch.

However, it ***WILL BREAK*** both drivers in drivers/misc/carma. Please
add my patch 7/7 titled "[PATCH 7/7] carma: remove unnecessary
DMA_INTERRUPT capability" to your series. I suggest placing it
immediately after this patch in your series.

The carma drivers use the fsldma driver exclusively.

> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Li Yang <leoli@freescale.com>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>
> ---
>  drivers/dma/fsldma.c |   31 -------------------------------
>  1 files changed, 0 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 8f84761..4f2f212 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -543,35 +543,6 @@ static void fsl_dma_free_chan_resources(struct dma_chan *dchan)
>  }
> 
>  static struct dma_async_tx_descriptor *
> -fsl_dma_prep_interrupt(struct dma_chan *dchan, unsigned long flags)
> -{
> -	struct fsldma_chan *chan;
> -	struct fsl_desc_sw *new;
> -
> -	if (!dchan)
> -		return NULL;
> -
> -	chan = to_fsl_chan(dchan);
> -
> -	new = fsl_dma_alloc_descriptor(chan);
> -	if (!new) {
> -		chan_err(chan, "%s\n", msg_ld_oom);
> -		return NULL;
> -	}
> -
> -	new->async_tx.cookie = -EBUSY;
> -	new->async_tx.flags = flags;
> -
> -	/* Insert the link descriptor to the LD ring */
> -	list_add_tail(&new->node, &new->tx_list);
> -
> -	/* Set End-of-link to the last link descriptor of new list */
> -	set_ld_eol(chan, new);
> -
> -	return &new->async_tx;
> -}
> -
> -static struct dma_async_tx_descriptor *
>  fsl_dma_prep_memcpy(struct dma_chan *dchan,
>  	dma_addr_t dma_dst, dma_addr_t dma_src,
>  	size_t len, unsigned long flags)
> @@ -1352,12 +1323,10 @@ static int __devinit fsldma_of_probe(struct platform_device *op)
>  	fdev->irq = irq_of_parse_and_map(op->dev.of_node, 0);
> 
>  	dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
> -	dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
>  	dma_cap_set(DMA_SG, fdev->common.cap_mask);
>  	dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
>  	fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
>  	fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
> -	fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;
>  	fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
>  	fdev->common.device_prep_dma_sg = fsl_dma_prep_sg;
>  	fdev->common.device_tx_status = fsl_tx_status;
> --
> 1.7.5.1
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
