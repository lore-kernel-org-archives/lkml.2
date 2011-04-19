Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1DSF3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 01:29:49 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:40557 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631Ab1DSF3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 01:29:47 -0400
Message-ID: <4DAD1DA5.7010801@st.com>
Date: Tue, 19 Apr 2011 10:59:09 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        amitgoel <amit.goel@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>
Subject: Re: [PATCH] dmaengine: implement pause and resume for dw_dmac
References: <1303173092-21785-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1303173092-21785-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 06:01 AM, Linus Walleij wrote:
> It seems that the SPEAr needs this.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Thanks for sending this.
Actually i wasn't sure that disabling channel will simply pause it, and not
finish the transfer. So, didn't went for this change.

> ---
>  drivers/dma/dw_dmac.c      |   22 ++++++++++++++++++++--
>  drivers/dma/dw_dmac_regs.h |    1 +
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 9c25c7d..60ac779 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -801,8 +801,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>  	struct dw_desc		*desc, *_desc;
>  	LIST_HEAD(list);
>  
> -	/* Only supports DMA_TERMINATE_ALL */
> -	if (cmd != DMA_TERMINATE_ALL)
> +	if (cmd != DMA_TERMINATE_ALL && cmd != DMA_PAUSE && cmd != DMA_RESUME)
>  		return -ENXIO;
>  
>  	/*
> @@ -813,11 +812,30 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>  	 */
>  	spin_lock_bh(&dwc->lock);
>  
> +	if (cmd == DMA_RESUME) {
> +		if (dwc->paused) {
> +			channel_set_bit(dw, CH_EN, dwc->mask);
> +			while (!dma_readl(dw, CH_EN) & dwc->mask)

Probably should be written as
			while (!(dma_readl(dw, CH_EN) & dwc->mask))

> +				cpu_relax();
> +		}

Should return error in else part??

> +		spin_unlock_bh(&dwc->lock);
> +		return 0;
> +	}
> +
>  	channel_clear_bit(dw, CH_EN, dwc->mask);
>  
>  	while (dma_readl(dw, CH_EN) & dwc->mask)
>  		cpu_relax();
>  
> +	if (cmd == DMA_PAUSE) {
> +		dwc->paused = true;
> +		spin_unlock_bh(&dwc->lock);

I have sent another patchset in which _bh variants are replaced with irqsave
variants. To remove any conflicts, i would add your patch in my patchset, with
above mentioned changes keeping your authorship intact.

Will that be fine??

-- 
viresh
