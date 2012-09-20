Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab2ITWJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:09:48 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54944 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752211Ab2ITWJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:09:46 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1828y6tAaqShYZ595uqp5NN
Date: Thu, 20 Sep 2012 15:09:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Matt Porter <mporter@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [RFC PATCH 10/13] spi: omap2-mcspi:
 dma_request_slave_channel() support for DT platforms
Message-ID: <20120920220931.GJ28835@atomide.com>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-11-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348152226-13588-11-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Porter <mporter@ti.com> [120920 07:43]:
> For platforms with DT populated, use dma_request_slave_channel()
> to acquire the DMA channel. For !DT platforms, we fall back to
> explicitly passing the omap_dma_filter_fn() to dma_request_channel().
> Once all platforms boot from DT, the dma_request_channel() path can
> be dropped.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  drivers/spi/spi-omap2-mcspi.c |   68 +++++++++++++++++++++++++++++------------
>  1 file changed, 48 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index 9502566..1cf1072 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -104,6 +104,9 @@ struct omap2_mcspi_dma {
>  
>  	struct completion dma_tx_completion;
>  	struct completion dma_rx_completion;
> +
> +	char dma_rx_ch_name[14];
> +	char dma_tx_ch_name[14];
>  };
>  
>  /* use PIO for small transfers, avoiding DMA setup/teardown overhead and
> @@ -798,14 +801,26 @@ static int omap2_mcspi_request_dma(struct spi_device *spi)
>  	dma_cap_zero(mask);
>  	dma_cap_set(DMA_SLAVE, mask);
>  	sig = mcspi_dma->dma_rx_sync_dev;
> -	mcspi_dma->dma_rx = dma_request_channel(mask, omap_dma_filter_fn, &sig);
> +	if (spi->dev.of_node)
> +		mcspi_dma->dma_rx =
> +			dma_request_slave_channel(&master->dev,
> +						  mcspi_dma->dma_rx_ch_name);
> +	else
> +		mcspi_dma->dma_rx =
> +			dma_request_channel(mask, omap_dma_filter_fn, &sig);
>  	if (!mcspi_dma->dma_rx) {
>  		dev_err(&spi->dev, "no RX DMA engine channel for McSPI\n");
>  		return -EAGAIN;
>  	}
>  

Hmm this does not look nice.. We should be able to somehow not to care about
the configuration at the mcspi driver level.

Regards,

Tony
