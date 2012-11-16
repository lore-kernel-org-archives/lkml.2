Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2KPPdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:33:51 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:52927 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2KPPdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:33:50 -0500
Message-ID: <50A65CD8.60802@atmel.com>
Date: Fri, 16 Nov 2012 16:33:44 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 2/6] dma: at_hdmac: check direction properly for cyclic
 transfers
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com> <1353074360-1903-3-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1353074360-1903-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 02:59 PM, Andy Shevchenko :
> dma_transfer_direction is a normal enum. It means we can't usually use the
> values as bit fields. Let's adjust this check and move it above the usage of
> the direction parameter.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

Whatever name of function is:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  drivers/dma/at_hdmac.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 13a02f4..997ae54 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -778,7 +778,7 @@ err:
>   */
>  static int
>  atc_dma_cyclic_check_values(unsigned int reg_width, dma_addr_t buf_addr,
> -		size_t period_len, enum dma_transfer_direction direction)
> +		size_t period_len)
>  {
>  	if (period_len > (ATC_BTSIZE_MAX << reg_width))
>  		goto err_out;
> @@ -786,8 +786,6 @@ atc_dma_cyclic_check_values(unsigned int reg_width, dma_addr_t buf_addr,
>  		goto err_out;
>  	if (unlikely(buf_addr & ((1 << reg_width) - 1)))
>  		goto err_out;
> -	if (unlikely(!(direction & (DMA_DEV_TO_MEM | DMA_MEM_TO_DEV))))
> -		goto err_out;
>  
>  	return 0;
>  
> @@ -886,14 +884,16 @@ atc_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
>  		return NULL;
>  	}
>  
> +	if (unlikely(!is_slave_xfer(direction)))
> +		goto err_out;
> +
>  	if (sconfig->direction == DMA_MEM_TO_DEV)
>  		reg_width = convert_buswidth(sconfig->dst_addr_width);
>  	else
>  		reg_width = convert_buswidth(sconfig->src_addr_width);
>  
>  	/* Check for too big/unaligned periods and unaligned DMA buffer */
> -	if (atc_dma_cyclic_check_values(reg_width, buf_addr,
> -					period_len, direction))
> +	if (atc_dma_cyclic_check_values(reg_width, buf_addr, period_len))
>  		goto err_out;
>  
>  	/* build cyclic linked list */
> 


-- 
Nicolas Ferre
