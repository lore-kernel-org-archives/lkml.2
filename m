Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab2IUPnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:43:05 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:23080 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751541Ab2IUPnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:43:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+gTnNIoAofhCQTHaAzNBls
Date: Fri, 21 Sep 2012 08:42:47 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matt Porter <mporter@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
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
        Dan Williams <djbw@fb.com>, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [RFC PATCH 10/13] spi: omap2-mcspi:
 dma_request_slave_channel() support for DT platforms
Message-ID: <20120921154247.GZ28835@atomide.com>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-11-git-send-email-mporter@ti.com>
 <20120920220931.GJ28835@atomide.com>
 <201209210816.01473.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209210816.01473.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [120921 02:19]:
> On Thursday 20 September 2012, Tony Lindgren wrote:
> > >  /* use PIO for small transfers, avoiding DMA setup/teardown overhead and
> > > @@ -798,14 +801,26 @@ static int omap2_mcspi_request_dma(struct spi_device *spi)
> > >       dma_cap_zero(mask);
> > >       dma_cap_set(DMA_SLAVE, mask);
> > >       sig = mcspi_dma->dma_rx_sync_dev;
> > > -     mcspi_dma->dma_rx = dma_request_channel(mask, omap_dma_filter_fn, &sig);
> > > +     if (spi->dev.of_node)
> > > +             mcspi_dma->dma_rx =
> > > +                     dma_request_slave_channel(&master->dev,
> > > +                                               mcspi_dma->dma_rx_ch_name);
> > > +     else
> > > +             mcspi_dma->dma_rx =
> > > +                     dma_request_channel(mask, omap_dma_filter_fn, &sig);
> > >       if (!mcspi_dma->dma_rx) {
> > >               dev_err(&spi->dev, "no RX DMA engine channel for McSPI\n");
> > >               return -EAGAIN;
> > >       }
> > >  
> > 
> > Hmm this does not look nice.. We should be able to somehow not to care about
> > the configuration at the mcspi driver level.
> 
> I agree, but as far as I understand Vinod's plans, we would actually move
> all drivers over to dma_request_slave_channel() when we have an interface
> to register the lookup tables from platform code.
> 
> I think the above is ok for a transitional phase and we can remove the
> fallback path when we have converted all platforms using this driver
> to either use DT or move to the new style way of passing the channel
> configuration.

Can't we come up with a version of dma_request_slave_channel that works
both ways for now:

	mcspi_dma->dma_rx =
		dma_request_slave_channel_compat(mask, omap_dma_filter_fn, &sig,
					&master->dev, mcspi_dma->dma_rx_ch_name);
	...			

Then it's just question of patching away two lines later on rather than
having to add all this if else to all the drivers first, then patching
it away again.

Regards,

Tony
