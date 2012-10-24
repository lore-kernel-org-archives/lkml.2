Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2JXFGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:06:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:54964 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab2JXFGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:06:16 -0400
Subject: Re: [PATCH v2 1/4] DMA: PL330: Free memory allocated for
 peripheral channels
From: Vinod Koul <vkoul@infradead.org>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: vinod.koul@intel.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jassisinghbrar@gmail.com,
        boojin.kim@samsung.com, patches@linaro.org, kgene.kim@samsung.com
In-Reply-To: <1349432276-22919-2-git-send-email-inderpal.singh@linaro.org>
References: <1349432276-22919-1-git-send-email-inderpal.singh@linaro.org>
	 <1349432276-22919-2-git-send-email-inderpal.singh@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 09:35:50 +0530
Message-ID: <1351051550.5263.15.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 15:47 +0530, Inderpal Singh wrote:
> The allocated memory for peripheral channels is not being freed upon
> failure in probe and in module's remove funtion. It will lead to memory
> leakage. Hence free the allocated memory.
> 
> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
> ---
>  drivers/dma/pl330.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 2ebd4cd..10c6b6a 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2962,7 +2962,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  	ret = dma_async_device_register(pd);
>  	if (ret) {
>  		dev_err(&adev->dev, "unable to register DMAC\n");
> -		goto probe_err4;
> +		goto probe_err5;
>  	}
>  
>  	dev_info(&adev->dev,
> @@ -2975,6 +2975,8 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  
>  	return 0;
>  
> +probe_err5:
> +	kfree(pdmac->peripherals);
>  probe_err4:
>  	pl330_del(pi);
>  probe_err3:
> @@ -3025,6 +3027,7 @@ static int __devexit pl330_remove(struct amba_device *adev)
>  	res = &adev->res;
>  	release_mem_region(res->start, resource_size(res));
>  
> +	kfree(pdmac->peripherals);
>  	kfree(pdmac);
>  
>  	return 0;

This looks fine, but if you use devm_ functions then you dont need to do
all this.
Can you do that conversion instead?

-- 
Vinod Koul
Intel Corp.

