Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914Ab2EKJlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 05:41:08 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:41171 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab2EKJlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 05:41:06 -0400
Message-ID: <4FACDEAC.7000901@atmel.com>
Date: Fri, 11 May 2012 11:41:00 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, rmk <rmk@arm.linux.org.uk>,
        Mika Westerberg <mika.westerberg@iki.fi>
Subject: Re: [PATCH] dmaengine: fix cyclic dma usage
References: <1336717449.15424.1585.camel@vkoul-udesk3>
In-Reply-To: <1336717449.15424.1585.camel@vkoul-udesk3>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 08:24 AM, Vinod Koul :
> 
>>From 24db9e25a31ac46327253f11908463c48518dec8 Mon Sep 17 00:00:00 2001
> From: Vinod Koul <vinod.koul@linux.intel.com>
> Date: Fri, 11 May 2012 11:48:21 +0530
> Subject: [PATCH] dmaengine: fix cyclic dma usage
> 
> for cyclic dma, dont mark the descriptor as complete.
> Fix the remaining users of cyclic dma which do so
> 
> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>

Vinod,

Thanks for taking care of this, I have tested:
Tested-by: Nicolas Ferre <nicolas.ferre@atmel.com>
and:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


> ---
> Looking for tested by for these two
> ---
>  drivers/dma/at_hdmac.c   |    4 +++-
>  drivers/dma/ep93xx_dma.c |    4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 445fdf8..bf0d7e4 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -245,7 +245,9 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
>  	dev_vdbg(chan2dev(&atchan->chan_common),
>  		"descriptor %u complete\n", txd->cookie);
>  
> -	dma_cookie_complete(txd);
> +	/* mark the descriptor as complete for non cyclic cases only */
> +	if (!atc_chan_is_cyclic(atchan))
> +		dma_cookie_complete(txd);
>  
>  	/* move children to free_list */
>  	list_splice_init(&desc->tx_list, &atchan->free_list);
> diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
> index e6f133b..f6e9b57 100644
> --- a/drivers/dma/ep93xx_dma.c
> +++ b/drivers/dma/ep93xx_dma.c
> @@ -703,7 +703,9 @@ static void ep93xx_dma_tasklet(unsigned long data)
>  	desc = ep93xx_dma_get_active(edmac);
>  	if (desc) {
>  		if (desc->complete) {
> -			dma_cookie_complete(&desc->txd);
> +			/* mark descriptor complete for non cyclic case only */
> +			if (!test_bit(EP93XX_DMA_IS_CYCLIC, &edmac->flags))
> +				dma_cookie_complete(&desc->txd);
>  			list_splice_init(&edmac->active, &list);
>  		}
>  		callback = desc->txd.callback;


-- 
Nicolas Ferre
