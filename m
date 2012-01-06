Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab2AFF4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 00:56:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:61911 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab2AFF4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 00:56:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104094870"
Subject: Re: [PATCH 1/2] dmaengine: Fix status handling in imx-dma.
From: Vinod Koul <vinod.koul@intel.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        s.hauer@pengutronix.de, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1325506706-10028-1-git-send-email-javier.martin@vista-silicon.com>
References: <1325506706-10028-1-git-send-email-javier.martin@vista-silicon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Jan 2012 11:26:29 +0530
Message-ID: <1325829389.1540.95.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-02 at 13:18 +0100, Javier Martin wrote:
> Status must only be changed to DMA_IN_PROGRESS
> when the DMA transfer has really begun.
> 
> However, since this driver lacks of support for
> multiple descriptors a new flag has to be introduced
> to avoid the prepare function be called multiple times.
Thanks this is the right approach to fix this driver

But this will obviously break any users of this driver as they need to
call the right APIs now :D

Sacha: can you check this patch and see which users of this driver will
break. we need those fixes to go along this patch as well
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/dma/imx-dma.c |   22 +++++++++++++++-------
>  1 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index d99f71c..9a0ac14 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -43,6 +43,7 @@ struct imxdma_channel {
>  	enum dma_status			status;
>  	int				dma_request;
>  	struct scatterlist		*sg_list;
> +	bool				prepared;
>  };
>  
>  #define MAX_DMA_CHANNELS 8
> @@ -72,6 +73,7 @@ static void imxdma_irq_handler(int channel, void *data)
>  
>  	imxdmac->status = DMA_SUCCESS;
>  	imxdma_handle(imxdmac);
> +	imxdmac->prepared = false;
>  }
>  
>  static void imxdma_err_handler(int channel, void *data, int error)
> @@ -80,6 +82,7 @@ static void imxdma_err_handler(int channel, void *data, int error)
>  
>  	imxdmac->status = DMA_ERROR;
>  	imxdma_handle(imxdmac);
> +	imxdmac->prepared = false;
>  }
>  
>  static void imxdma_progression(int channel, void *data,
> @@ -89,6 +92,7 @@ static void imxdma_progression(int channel, void *data,
>  
>  	imxdmac->status = DMA_SUCCESS;
>  	imxdma_handle(imxdmac);
> +	imxdmac->prepared = false;
>  }
>  
>  static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> @@ -103,6 +107,7 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>  	case DMA_TERMINATE_ALL:
>  		imxdmac->status = DMA_ERROR;
>  		imx_dma_disable(imxdmac->imxdma_channel);
> +		imxdmac->prepared = false;
>  		return 0;
>  	case DMA_SLAVE_CONFIG:
>  		if (dmaengine_cfg->direction == DMA_FROM_DEVICE) {
> @@ -204,7 +209,7 @@ static int imxdma_alloc_chan_resources(struct dma_chan *chan)
>  	imxdmac->desc.flags = DMA_CTRL_ACK;
>  
>  	imxdmac->status = DMA_SUCCESS;
> -
> +	imxdmac->prepared = false;
>  	return 0;
>  }
>  
> @@ -230,11 +235,9 @@ static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
>  	int i, ret, dma_length = 0;
>  	unsigned int dmamode;
>  
> -	if (imxdmac->status == DMA_IN_PROGRESS)
> +	if (imxdmac->prepared)
>  		return NULL;
>  
> -	imxdmac->status = DMA_IN_PROGRESS;
> -
>  	for_each_sg(sgl, sg, sg_len, i) {
>  		dma_length += sg->length;
>  	}
> @@ -264,6 +267,8 @@ static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
>  	if (ret)
>  		return NULL;
>  
> +	imxdmac->prepared = true;
> +
>  	return &imxdmac->desc;
>  }
>  
> @@ -280,9 +285,8 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
>  	dev_dbg(imxdma->dev, "%s channel: %d buf_len=%d period_len=%d\n",
>  			__func__, imxdmac->channel, buf_len, period_len);
>  
> -	if (imxdmac->status == DMA_IN_PROGRESS)
> +	if (imxdmac->prepared)
>  		return NULL;
> -	imxdmac->status = DMA_IN_PROGRESS;
>  
>  	ret = imx_dma_setup_progression_handler(imxdmac->imxdma_channel,
>  			imxdma_progression);
> @@ -325,14 +329,18 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
>  	if (ret)
>  		return NULL;
>  
> +	imxdmac->prepared = true;
> +
>  	return &imxdmac->desc;
>  }
>  
>  static void imxdma_issue_pending(struct dma_chan *chan)
>  {
>  	/*
> -	 * Nothing to do. We only have a single descriptor
> +	 * Only change status since we have a single descriptor
>  	 */
> +	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
> +	imxdmac->status = DMA_IN_PROGRESS;
>  }
>  
>  static int __init imxdma_probe(struct platform_device *pdev)


-- 
~Vinod

