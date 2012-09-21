Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab2IUSfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:35:51 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56443 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab2IUSfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:35:45 -0400
Date: Fri, 21 Sep 2012 14:37:29 -0400
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 10/13] spi: omap2-mcspi: dma_request_slave_channel()
 support for DT platforms
Message-ID: <20120921183729.GI16522@beef>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-11-git-send-email-mporter@ti.com>
 <20120920220931.GJ28835@atomide.com>
 <201209210816.01473.arnd@arndb.de>
 <20120921154247.GZ28835@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921154247.GZ28835@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 08:42:47AM -0700, Tony Lindgren wrote:
> * Arnd Bergmann <arnd@arndb.de> [120921 02:19]:
> > On Thursday 20 September 2012, Tony Lindgren wrote:
> > > >  /* use PIO for small transfers, avoiding DMA setup/teardown overhead and
> > > > @@ -798,14 +801,26 @@ static int omap2_mcspi_request_dma(struct spi_device *spi)
> > > >       dma_cap_zero(mask);
> > > >       dma_cap_set(DMA_SLAVE, mask);
> > > >       sig = mcspi_dma->dma_rx_sync_dev;
> > > > -     mcspi_dma->dma_rx = dma_request_channel(mask, omap_dma_filter_fn, &sig);
> > > > +     if (spi->dev.of_node)
> > > > +             mcspi_dma->dma_rx =
> > > > +                     dma_request_slave_channel(&master->dev,
> > > > +                                               mcspi_dma->dma_rx_ch_name);
> > > > +     else
> > > > +             mcspi_dma->dma_rx =
> > > > +                     dma_request_channel(mask, omap_dma_filter_fn, &sig);
> > > >       if (!mcspi_dma->dma_rx) {
> > > >               dev_err(&spi->dev, "no RX DMA engine channel for McSPI\n");
> > > >               return -EAGAIN;
> > > >       }
> > > >  
> > > 
> > > Hmm this does not look nice.. We should be able to somehow not to care about
> > > the configuration at the mcspi driver level.
> > 
> > I agree, but as far as I understand Vinod's plans, we would actually move
> > all drivers over to dma_request_slave_channel() when we have an interface
> > to register the lookup tables from platform code.
> > 
> > I think the above is ok for a transitional phase and we can remove the
> > fallback path when we have converted all platforms using this driver
> > to either use DT or move to the new style way of passing the channel
> > configuration.
> 
> Can't we come up with a version of dma_request_slave_channel that works
> both ways for now:
> 
> 	mcspi_dma->dma_rx =
> 		dma_request_slave_channel_compat(mask, omap_dma_filter_fn, &sig,
> 					&master->dev, mcspi_dma->dma_rx_ch_name);
> 	...			
> 
> Then it's just question of patching away two lines later on rather than
> having to add all this if else to all the drivers first, then patching
> it away again.

I think that something like that is workable with the implementation
simply checking for of_node to do the right thing.

-Matt
