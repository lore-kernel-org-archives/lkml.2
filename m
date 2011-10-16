Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1JPIKD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 04:10:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:31313 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab1JPIKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 04:10:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,353,1315206000"; 
   d="scan'208";a="27096746"
Subject: Re: [PATCH 07/10] spi, serial: move to dma_transfer_direction
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Grant Likely <grant.likely@secretlab.ca>,
        Alan Cox <alan@linux.intel.com>
In-Reply-To: <20111015190015.GB3128@mwesterb-mobl.ger.corp.intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
	 <1318570705-17595-8-git-send-email-vinod.koul@intel.com>
	 <20111015190015.GB3128@mwesterb-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Oct 2011 13:31:33 +0530
Message-ID: <1318752093.23438.46.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-15 at 22:00 +0300, Mika Westerberg wrote:
> On Fri, Oct 14, 2011 at 11:08:22AM +0530, Vinod Koul wrote:
> 
> > diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
> > index 1cf6454..8754a39 100644
> > --- a/drivers/spi/spi-ep93xx.c
> > +++ b/drivers/spi/spi-ep93xx.c
> > @@ -550,6 +550,7 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
> >  	struct dma_async_tx_descriptor *txd;
> >  	enum dma_slave_buswidth buswidth;
> >  	struct dma_slave_config conf;
> > +	enum dma_transfer_direction slave_dirn;
> >  	struct scatterlist *sg;
> >  	struct sg_table *sgt;
> >  	struct dma_chan *chan;
> > @@ -572,6 +573,7 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
> >  
> >  		conf.src_addr = espi->sspdr_phys;
> >  		conf.src_addr_width = buswidth;
> > +		slave_dirn = DEV_TO_MEM;
> >  	} else {
> >  		chan = espi->dma_tx;
> >  		buf = t->tx_buf;
> > @@ -579,6 +581,7 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
> >  
> >  		conf.dst_addr = espi->sspdr_phys;
> >  		conf.dst_addr_width = buswidth;
> > +		slave_dirn = MEM_TO_DEV;
> >  	}
> >  
> >  	ret = dmaengine_slave_config(chan, &conf);
> > @@ -630,7 +633,7 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
> >  		return ERR_PTR(-ENOMEM);
> >  
> >  	txd = chan->device->device_prep_slave_sg(chan, sgt->sgl, nents,
> > -						 dir, DMA_CTRL_ACK);
> > +						 slave_dirn, DMA_CTRL_ACK);
> >  	if (!txd) {
> >  		dma_unmap_sg(chan->device->dev, sgt->sgl, sgt->nents, dir);
> >  		return ERR_PTR(-ENOMEM);
> 
> Can you also change the ep93xx_spi_setup_dma() function to use these new
> values? Like the patch below.
> 
> Otherwise,
> 
> Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
Thanks, I will add the below patche as well.

> 
> diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
> index 66c3d9b..d97583f 100644
> --- a/drivers/spi/spi-ep93xx.c
> +++ b/drivers/spi/spi-ep93xx.c
> @@ -982,7 +982,7 @@ static int ep93xx_spi_setup_dma(struct ep93xx_spi *espi)
>  	dma_cap_set(DMA_SLAVE, mask);
>  
>  	espi->dma_rx_data.port = EP93XX_DMA_SSP;
> -	espi->dma_rx_data.direction = DMA_FROM_DEVICE;
> +	espi->dma_rx_data.direction = DEV_TO_MEM;
>  	espi->dma_rx_data.name = "ep93xx-spi-rx";
>  
>  	espi->dma_rx = dma_request_channel(mask, ep93xx_spi_dma_filter,
> @@ -993,7 +993,7 @@ static int ep93xx_spi_setup_dma(struct ep93xx_spi *espi)
>  	}
>  
>  	espi->dma_tx_data.port = EP93XX_DMA_SSP;
> -	espi->dma_tx_data.direction = DMA_TO_DEVICE;
> +	espi->dma_tx_data.direction = MEM_TO_DEV;
>  	espi->dma_tx_data.name = "ep93xx-spi-tx";
>  
>  	espi->dma_tx = dma_request_channel(mask, ep93xx_spi_dma_filter,


-- 
~Vinod

