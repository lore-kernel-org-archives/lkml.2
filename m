Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2AIKvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 05:51:36 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38917 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2AIKve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 05:51:34 -0500
Date: Mon, 9 Jan 2012 10:51:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Javier Martin <javier.martin@vista-silicon.com>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 3/4] dma: imx-dma: start transfer in issue_pending
Message-ID: <20120109105106.GI21765@n2100.arm.linux.org.uk>
References: <1326101570-3716-1-git-send-email-s.hauer@pengutronix.de> <1326101570-3716-4-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326101570-3716-4-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 10:32:49AM +0100, Sascha Hauer wrote:
> The DMA API requires that transfers are started in issue_pending

DMA engine API != DMA API.

> instead of tx_submit. Fix this.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/dma/imx-dma.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index 4be55f9..217207b 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -186,8 +186,6 @@ static dma_cookie_t imxdma_tx_submit(struct dma_async_tx_descriptor *tx)
>  
>  	cookie = imxdma_assign_cookie(imxdmac);
>  
> -	imx_dma_enable(imxdmac->imxdma_channel);
> -
>  	spin_unlock_irq(&imxdmac->lock);
>  
>  	return cookie;
> @@ -332,9 +330,10 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
>  
>  static void imxdma_issue_pending(struct dma_chan *chan)
>  {
> -	/*
> -	 * Nothing to do. We only have a single descriptor
> -	 */
> +	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
> +
> +	if (imxdmac->status == DMA_IN_PROGRESS)
> +		imx_dma_enable(imxdmac->imxdma_channel);
>  }
>  
>  static int __init imxdma_probe(struct platform_device *pdev)
> -- 
> 1.7.7.3
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
