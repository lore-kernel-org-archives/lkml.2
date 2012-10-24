Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab2JXLPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:15:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:59080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2JXLPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:15:21 -0400
Subject: Re: [PATCH] DMA: PL330: Add runtime pm support
From: Vinod Koul <vkoul@infradead.org>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: vinod.koul@intel.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jassisinghbrar@gmail.com,
        boojin.kim@samsung.com, kgene.kim@samsung.com, patches@linaro.org
In-Reply-To: <1350447151-16737-1-git-send-email-inderpal.singh@linaro.org>
References: <1350447151-16737-1-git-send-email-inderpal.singh@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 10:24:01 +0530
Message-ID: <1351054441.5263.52.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 09:42 +0530, Inderpal Singh wrote:
> At the pl330's probe point the device is already in runtime resume state.
> Hence to manage the device with runtime, the probe should do pm_runtime_put
> and remove should do pm_runtime_get to balance with probe.
> 
> And in between, the device is being get/put at alloc_chan_resources and
> free_chan_resources.
> 
> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
> ---
> This patch is based on slave-dma's next branch and on top
> of the clean up patches at [1].
> 
> [1] https://lkml.org/lkml/2012/10/5/169
> 
>  drivers/dma/pl330.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 2ee1538..5ae19ea 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -25,6 +25,7 @@
>  #include <linux/amba/pl330.h>
>  #include <linux/scatterlist.h>
>  #include <linux/of.h>
> +#include <linux/pm_runtime.h>
>  
>  #include "dmaengine.h"
>  #define PL330_MAX_CHAN		8
> @@ -2384,6 +2385,8 @@ static int pl330_alloc_chan_resources(struct dma_chan *chan)
>  	struct dma_pl330_dmac *pdmac = pch->dmac;
>  	unsigned long flags;
>  
> +	pm_runtime_get_sync(pdmac->ddma.dev);
it would be really good if we move this to tx_submit. That way you
resume the dmaengine when actual transactions happen, not when someone
requests a channel.
Yes thats a little more work, though initially we can have this way.
> +
>  	spin_lock_irqsave(&pch->lock, flags);
>  
>  	dma_cookie_init(chan);
> @@ -2392,6 +2395,7 @@ static int pl330_alloc_chan_resources(struct dma_chan *chan)
>  	pch->pl330_chid = pl330_request_channel(&pdmac->pif);
>  	if (!pch->pl330_chid) {
>  		spin_unlock_irqrestore(&pch->lock, flags);
> +		pm_runtime_put(pdmac->ddma.dev);
>  		return -ENOMEM;
>  	}
>  
> @@ -2470,6 +2474,8 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
>  		list_splice_tail_init(&pch->work_list, &pch->dmac->desc_pool);
>  
>  	spin_unlock_irqrestore(&pch->lock, flags);
> +
> +	pm_runtime_put(pch->dmac->ddma.dev);
>  }
>  
>  static enum dma_status
> @@ -2974,6 +2980,8 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  		pi->pcfg.data_bus_width / 8, pi->pcfg.num_chan,
>  		pi->pcfg.num_peri, pi->pcfg.num_events);
>  
> +	pm_runtime_put(pd->dev);
pm_runtime_put_noidle is better. Yous should also do pm_runtime_allow
here and pm_runtime_forbid in your remove.

> +
>  	return 0;
>  
>  probe_err5:
> @@ -3017,6 +3025,8 @@ static int __devexit pl330_remove(struct amba_device *adev)
>  			return -EBUSY;
>  	}
>  
> +	pm_runtime_get(pdmac->ddma.dev);
> +
>  	dma_async_device_unregister(&pdmac->ddma);
>  
>  	amba_set_drvdata(adev, NULL);


-- 
Vinod Koul
Intel Corp.

