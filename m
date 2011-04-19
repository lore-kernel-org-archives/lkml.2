Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1DSIzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:55:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39239 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1DSIzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:55:18 -0400
Date: Tue, 19 Apr 2011 09:55:15 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linux-kernel@vger.kernel.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org,
        armando.visconti@st.com, shiraz.hashim@st.com, amit.goel@st.com,
        viresh.linux@gmail.com, linus.walleij@linaro.org
Subject: Re: [PATCH V2 7/7] dmaengine/dw_dmac: implement pause and resume in
 dwc_control
Message-ID: <20110419085514.GG2820@pulham.picochip.com>
References: <cover.1303194835.git.viresh.kumar@st.com>
 <a1168e413888e35badd9fab6b1626fcfe355dc9b.1303194836.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1168e413888e35badd9fab6b1626fcfe355dc9b.1303194836.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 02:02:12PM +0530, Viresh Kumar wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Some peripherals like amba-pl011 needs pause to be implemented in DMA controller
> drivers. This also returns correct status from dwc_tx_status() in case chan is
> paused.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/dw_dmac.c      |   25 +++++++++++++++++++++++--
>  drivers/dma/dw_dmac_regs.h |    1 +
>  2 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index c30f0ba..48d2d7e 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -832,8 +832,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>  	struct dw_desc		*desc, *_desc;
>  	LIST_HEAD(list);
>  
> -	/* Only supports DMA_TERMINATE_ALL */
> -	if (cmd != DMA_TERMINATE_ALL)
> +	if (cmd != DMA_TERMINATE_ALL && cmd != DMA_PAUSE && cmd != DMA_RESUME)
>  		return -ENXIO;
>  
>  	/*
> @@ -844,11 +843,30 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>  	 */
>  	spin_lock_irqsave(&dwc->lock, dwc->lflags);
>  
> +	if (cmd == DMA_RESUME) {
> +		if (dwc->paused) {
> +			channel_set_bit(dw, CH_EN, dwc->mask);
> +			while (!(dma_readl(dw, CH_EN) & dwc->mask))
> +				cpu_relax();
> +		}
> +		spin_unlock_irqrestore(&dwc->lock, dwc->lflags);
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
> +		spin_unlock_irqrestore(&dwc->lock, dwc->lflags);
> +		return 0;
> +	}

>From the Synopsys datasheet it looks to me like pausing by clearing the 
channel enable bit could cause data to be lost.  I think you need to set 
the CH_SUSP bit and wait for the FIFO_EMPTY flag to go high then disable 
the channel.

Jamie
