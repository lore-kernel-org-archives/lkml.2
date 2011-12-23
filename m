Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab1LWRih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 12:38:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:38892 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757538Ab1LWRif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 12:38:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99744657"
Subject: Re: [PATCH] dmaengine: Add support for MEMCPY for imx-dma.
From: Vinod Koul <vinod.koul@intel.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        s.hauer@pengutronix.de, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1324051191-19507-1-git-send-email-javier.martin@vista-silicon.com>
References: <1324051191-19507-1-git-send-email-javier.martin@vista-silicon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Dec 2011 23:08:38 +0530
Message-ID: <1324661918.1633.35.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 16:59 +0100, Javier Martin wrote:
> MEMCPY transfers allow DMA copies from memory to
> memory. This patch has been tested with dmatest
> device driver.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/dma/imx-dma.c |   37 ++++++++++++++++++++++++++++++++++++-
>  1 files changed, 36 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index d99f71c..222cd7b 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -196,7 +196,8 @@ static int imxdma_alloc_chan_resources(struct dma_chan *chan)
>  	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
>  	struct imx_dma_data *data = chan->private;
>  
> -	imxdmac->dma_request = data->dma_request;
> +	if (data != NULL)
> +		imxdmac->dma_request = data->dma_request;
>  
>  	dma_async_tx_descriptor_init(&imxdmac->desc, chan);
>  	imxdmac->desc.tx_submit = imxdma_tx_submit;
> @@ -328,6 +329,37 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
>  	return &imxdmac->desc;
>  }
>  
> +static struct dma_async_tx_descriptor *imxdma_prep_dma_memcpy(
> +	struct dma_chan *chan, dma_addr_t dest,
> +	dma_addr_t src, size_t len, unsigned long flags)
> +{
> +	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
> +	struct imxdma_engine *imxdma = imxdmac->imxdma;
> +	int ret;
> +
> +	dev_dbg(imxdma->dev, "%s channel: %d src=0x%x dst=0x%x len=%d\n",
> +			__func__, imxdmac->channel, src, dest, len);
> +
> +	if (imxdmac->status == DMA_IN_PROGRESS)
> +		return NULL;
> +
> +	imxdmac->status = DMA_IN_PROGRESS;
why? prepare doesn't mean DMA is in progress. You can get multiple
descriptors for same channel by calling prepare multiple times.
Even one descriptor can be memcpy whereas other is slave...
In issue_pending this should be moved to DMA_IN_PROGRESS
> +
> +	ret = imx_dma_config_channel(imxdmac->imxdma_channel,
> +			       IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR,
> +			       IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR,
> +			       0, 0);
> +	if (ret)
> +		return NULL;
> +
> +	ret = imx_dma_setup_single(imxdmac->imxdma_channel, src, len,
> +				   dest, DMA_MODE_WRITE);
> +	if (ret)
> +		return NULL;
> +
> +	return &imxdmac->desc;
> +}
> +
>  static void imxdma_issue_pending(struct dma_chan *chan)
>  {
>  	/*
> @@ -348,6 +380,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
>  
>  	dma_cap_set(DMA_SLAVE, imxdma->dma_device.cap_mask);
>  	dma_cap_set(DMA_CYCLIC, imxdma->dma_device.cap_mask);
> +	dma_cap_set(DMA_MEMCPY, imxdma->dma_device.cap_mask);
>  
>  	/* Initialize channel parameters */
>  	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
> @@ -381,11 +414,13 @@ static int __init imxdma_probe(struct platform_device *pdev)
>  	imxdma->dma_device.device_tx_status = imxdma_tx_status;
>  	imxdma->dma_device.device_prep_slave_sg = imxdma_prep_slave_sg;
>  	imxdma->dma_device.device_prep_dma_cyclic = imxdma_prep_dma_cyclic;
> +	imxdma->dma_device.device_prep_dma_memcpy = imxdma_prep_dma_memcpy;
>  	imxdma->dma_device.device_control = imxdma_control;
>  	imxdma->dma_device.device_issue_pending = imxdma_issue_pending;
>  
>  	platform_set_drvdata(pdev, imxdma);
>  
> +	imxdma->dma_device.copy_align = 2; /* 2^2 = 4 bytes alignment */
>  	imxdma->dma_device.dev->dma_parms = &imxdma->dma_parms;
>  	dma_set_max_seg_size(imxdma->dma_device.dev, 0xffffff);
>  


-- 
~Vinod

