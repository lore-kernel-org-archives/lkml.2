Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2JXE2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 00:28:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:54768 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2JXE2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 00:28:17 -0400
Subject: Re: [PATCH v2 3/4] DMA: PL330: Balance module remove function with
 probe
From: Vinod Koul <vkoul@infradead.org>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: vinod.koul@intel.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jassisinghbrar@gmail.com,
        boojin.kim@samsung.com, patches@linaro.org, kgene.kim@samsung.com
In-Reply-To: <1349432276-22919-4-git-send-email-inderpal.singh@linaro.org>
References: <1349432276-22919-1-git-send-email-inderpal.singh@linaro.org>
	 <1349432276-22919-4-git-send-email-inderpal.singh@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 09:44:51 +0530
Message-ID: <1351052091.5263.19.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 15:47 +0530, Inderpal Singh wrote:
> Since peripheral channel resources are not being allocated at probe,
> no need to flush the channels and free the resources in remove function.
> In case, the channel is in use by some client, return EBUSY.
> 
> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
> ---
>  drivers/dma/pl330.c |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index bf71ff7..4b7a34d 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -3009,18 +3009,21 @@ static int __devexit pl330_remove(struct amba_device *adev)
>  	if (!pdmac)
>  		return 0;
>  
> +	/* check if any client is using any channel */
> +	list_for_each_entry(pch, &pdmac->ddma.channels,
> +			chan.device_node) {
> +
> +		if (pch->chan.client_count)
> +			return -EBUSY;
> +	}
> +
>  	while (!list_empty(&pdmac->desc_pool)) {

Did you get this code executed?
I think No.

The dmaengine holds the reference to channels, so if they are in use and
not freed by client your remove wont be called. So this check is
redundant

-- 
Vinod Koul
Intel Corp.

