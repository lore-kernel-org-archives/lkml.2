Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab2AaDmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:42:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:38801 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab2AaDmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:42:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118350033"
Subject: Re: [PATCH] at_hdmac: bugfix for enabling channel irq
From: Vinod Koul <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Nikolaus Voss <n.voss@weinmann.de>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <4F159394.7040409@atmel.com>
References: <201201171023.q0HANwSE024485@gatekeeper.vosshq.de>
	 <4F159394.7040409@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jan 2012 09:13:25 +0530
Message-ID: <1327981405.1527.58.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 16:28 +0100, Nicolas Ferre wrote:
> On 01/17/2012 10:28 AM, Nikolaus Voss :
> > commit 463894705e4089d0ff69e7d877312d496ac70e5b deleted redundant
> > chan_id and chancnt initialization in dma drivers as this is done
> > in dma_async_device_register().
> > 
> > However, atc_enable_irq() relied on chan_id set before registering
> > the device, what left only channel 0 functional for this driver.
> > 
> > This patch introduces atc_enable/disable_chan_irq() as a variant
> > of atc_enable/disable_irq() with the channel as explicit argument.
> > 
> > Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: stable <stable@vger.kernel.org>
> 
> Vinod, can you please queue it in a "fixes" branch for 3.3. The stable
> tag is needed to address errors in 3.2 kernel series.
Thanks Applied now, and sorry for the delay

Tomorrow I will send pull request to Linus.
> 
> Nikolaus, thanks for your fix.
> 
> Best regards,
> 
> > ---
> >  drivers/dma/at_hdmac.c      |    4 ++--
> >  drivers/dma/at_hdmac_regs.h |   17 ++++++++---------
> >  2 files changed, 10 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> > index fcfa0a8..a60adbf 100644
> > --- a/drivers/dma/at_hdmac.c
> > +++ b/drivers/dma/at_hdmac.c
> > @@ -1286,7 +1286,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
> >  
> >  		tasklet_init(&atchan->tasklet, atc_tasklet,
> >  				(unsigned long)atchan);
> > -		atc_enable_irq(atchan);
> > +		atc_enable_chan_irq(atdma, i);
> >  	}
> >  
> >  	/* set base routines */
> > @@ -1353,7 +1353,7 @@ static int __exit at_dma_remove(struct platform_device *pdev)
> >  		struct at_dma_chan	*atchan = to_at_dma_chan(chan);
> >  
> >  		/* Disable interrupts */
> > -		atc_disable_irq(atchan);
> > +		atc_disable_chan_irq(atdma, chan->chan_id);
> >  		tasklet_disable(&atchan->tasklet);
> >  
> >  		tasklet_kill(&atchan->tasklet);
> > diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
> > index aa4c9ae..5aa82b4 100644
> > --- a/drivers/dma/at_hdmac_regs.h
> > +++ b/drivers/dma/at_hdmac_regs.h
> > @@ -326,28 +326,27 @@ static void atc_dump_lli(struct at_dma_chan *atchan, struct at_lli *lli)
> >  }
> >  
> >  
> > -static void atc_setup_irq(struct at_dma_chan *atchan, int on)
> > +static void atc_setup_irq(struct at_dma *atdma, int chan_id, int on)
> >  {
> > -	struct at_dma	*atdma = to_at_dma(atchan->chan_common.device);
> > -	u32		ebci;
> > +	u32 ebci;
> >  
> >  	/* enable interrupts on buffer transfer completion & error */
> > -	ebci =    AT_DMA_BTC(atchan->chan_common.chan_id)
> > -		| AT_DMA_ERR(atchan->chan_common.chan_id);
> > +	ebci =    AT_DMA_BTC(chan_id)
> > +		| AT_DMA_ERR(chan_id);
> >  	if (on)
> >  		dma_writel(atdma, EBCIER, ebci);
> >  	else
> >  		dma_writel(atdma, EBCIDR, ebci);
> >  }
> >  
> > -static inline void atc_enable_irq(struct at_dma_chan *atchan)
> > +static void atc_enable_chan_irq(struct at_dma *atdma, int chan_id)
> >  {
> > -	atc_setup_irq(atchan, 1);
> > +	atc_setup_irq(atdma, chan_id, 1);
> >  }
> >  
> > -static inline void atc_disable_irq(struct at_dma_chan *atchan)
> > +static void atc_disable_chan_irq(struct at_dma *atdma, int chan_id)
> >  {
> > -	atc_setup_irq(atchan, 0);
> > +	atc_setup_irq(atdma, chan_id, 0);
> >  }
> >  
> >  
> 
> 


-- 
~Vinod

