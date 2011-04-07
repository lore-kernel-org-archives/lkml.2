Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab1DGSG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 14:06:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54328 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab1DGSGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 14:06:55 -0400
Date: Thu, 7 Apr 2011 11:06:50 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>,
        Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, khali@linux-fr.org,
        ben-linux@fluff.org, Peter Korsgaard <jacmet@sunsite.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mocean Laboratories <info@mocean-labs.com>
Subject: Re: [PATCH 07/19] timberdale: mfd_cell is now implicitly available
 to drivers
Message-ID: <20110407180650.GA3261@angua.secretlab.ca>
References: <20110405030428.GB29522@ponder.secretlab.ca>
 <20110406152322.GA2757@sortiz-mobl>
 <20110406155805.GA20095@suse.de>
 <20110406170537.GB2757@sortiz-mobl>
 <20110406175647.GA8048@suse.de>
 <20110406184733.GD2757@sortiz-mobl>
 <20110406185902.GN25654@legolas.emea.dhcp.ti.com>
 <20110407133717.GA3923@sortiz-mobl>
 <20110407143515.GC26452@angua.secretlab.ca>
 <20110407150322.GB3923@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110407150322.GB3923@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 05:03:23PM +0200, Samuel Ortiz wrote:
> On Thu, Apr 07, 2011 at 07:35:15AM -0700, Grant Likely wrote:
> > > Below is a patch for the Xilinx SPI example. Although this would fix the
> > > issue, we'd still have to do that on device per device basis. I had a similar
> > > solution where MFD drivers would set a flag for sub drivers that don't need
> > > any of the MFD bits. In that case the MFD core code would just forward the
> > > platform data, instead of embedding it through an MFD cell.
> > 
> > platform_data is already a fiddly bit where you don't know what
> > structure type platform_data points at; it is implicitly known and
> > easy to get wrong.  This solution makes me *very* nervous
> > because it would become even easier to get a mismatch on the
> > platform_data pointer type.
> How would that be more error prone than say a board file instantiating a
> platform device after having set the platform_data pointer to point to an
> implicitely know structure reference ?

Yes, platform_data is already troublesome, but at least current
convention is a 1:1 relationship between driver and platform_data
type.  I still hate it and want something better, but it is what we
have.  The problem with what having a different platform_data pointer
depending on the instantiation means that it adds yet another level of
decision that needs to be made and is very easy to get wrong.

So, yes, platform_data is bad.  I don't want to see it get any worse.

> 
> Cheers,
> Samuel.
> 
> P.S.: Would you be ok with something like the patch below ?

Not really because it requires the driver to make the correct decision
about the platform_data type depending on the driver name.  It is easy
to get wrong and the compiler cannot help you catch it.

I've talked with Greg, and adding the mfd_cell pointer to
platform_device will be okay in the short term.  In the long term I'm
looking at creating a better way of attaching type-safe data to
devices that will pretty much eliminate this issue.

> 
> > > ---
> > >  drivers/mfd/timberdale.c |    8 ++++----
> > >  drivers/spi/xilinx_spi.c |   19 ++++++++++++++++++-
> > >  include/linux/mfd/core.h |    3 +++
> > >  3 files changed, 25 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
> > > index 94c6c8a..c9220ce 100644
> > > --- a/drivers/mfd/timberdale.c
> > > +++ b/drivers/mfd/timberdale.c
> > > @@ -416,7 +416,7 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
> > >  		.mfd_data = &timberdale_radio_platform_data,
> > >  	},
> > >  	{
> > > -		.name = "xilinx_spi",
> > > +		.name = "mfd_xilinx_spi",
> > >  		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
> > >  		.resources = timberdale_spi_resources,
> > >  		.mfd_data = &timberdale_xspi_platform_data,
> > > @@ -476,7 +476,7 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
> > >  		.mfd_data = &timberdale_radio_platform_data,
> > >  	},
> > >  	{
> > > -		.name = "xilinx_spi",
> > > +		.name = "mfd_xilinx_spi",
> > >  		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
> > >  		.resources = timberdale_spi_resources,
> > >  		.mfd_data = &timberdale_xspi_platform_data,
> > > @@ -526,7 +526,7 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
> > >  		.mfd_data = &timberdale_radio_platform_data,
> > >  	},
> > >  	{
> > > -		.name = "xilinx_spi",
> > > +		.name = "mfd_xilinx_spi",
> > >  		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
> > >  		.resources = timberdale_spi_resources,
> > >  		.mfd_data = &timberdale_xspi_platform_data,
> > > @@ -570,7 +570,7 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
> > >  		.mfd_data = &timberdale_radio_platform_data,
> > >  	},
> > >  	{
> > > -		.name = "xilinx_spi",
> > > +		.name = "mfd_xilinx_spi",
> > >  		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
> > >  		.resources = timberdale_spi_resources,
> > >  		.mfd_data = &timberdale_xspi_platform_data,
> > > diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
> > > index c69c6f2..3287b84 100644
> > > --- a/drivers/spi/xilinx_spi.c
> > > +++ b/drivers/spi/xilinx_spi.c
> > > @@ -471,7 +471,11 @@ static int __devinit xilinx_spi_probe(struct platform_device *dev)
> > >  	struct spi_master *master;
> > >  	u8 i;
> > >  
> > > -	pdata = mfd_get_data(dev);
> > > +	if (platform_get_device_id(dev) &&
> > > +	    platform_get_device_id(dev)->driver_data & MFD_PLATFORM_DEVICE)
> > > +		pdata = mfd_get_data(dev);
> > > +	else
> > > +		pdata = dev->dev.platform_data;
> > >  	if (pdata) {
> > >  		num_cs = pdata->num_chipselect;
> > >  		little_endian = pdata->little_endian;
> > > @@ -530,6 +534,18 @@ static int __devexit xilinx_spi_remove(struct platform_device *dev)
> > >  /* work with hotplug and coldplug */
> > >  MODULE_ALIAS("platform:" XILINX_SPI_NAME);
> > >  
> > > +static const struct platform_device_id xilinx_spi_id_table[] = {
> > > +	{
> > > +		.name	= XILINX_SPI_NAME,
> > > +	},
> > > +	{
> > > +		.name	= "mfd_xilinx_spi",
> > > +		.driver_data = MFD_PLATFORM_DEVICE,
> > > +	},
> > > +	{  },	/* Terminating Entry */
> > > +};
> > > +MODULE_DEVICE_TABLE(platform, xilinx_spi_id_table);
> > > +
> > >  static struct platform_driver xilinx_spi_driver = {
> > >  	.probe = xilinx_spi_probe,
> > >  	.remove = __devexit_p(xilinx_spi_remove),
> > > @@ -538,6 +554,7 @@ static struct platform_driver xilinx_spi_driver = {
> > >  		.owner = THIS_MODULE,
> > >  		.of_match_table = xilinx_spi_of_match,
> > >  	},
> > > +	.id_table	= xilinx_spi_id_table,
> > >  };
> > >  
> > >  static int __init xilinx_spi_pltfm_init(void)
> > > diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
> > > index ad1b19a..13f31f4 100644
> > > --- a/include/linux/mfd/core.h
> > > +++ b/include/linux/mfd/core.h
> > > @@ -89,6 +89,9 @@ static inline const struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
> > >  	return pdev->dev.platform_data;
> > >  }
> > >  
> > > +/* */
> > > +#define MFD_PLATFORM_DEVICE BIT(0)
> > > +
> > >  /*
> > >   * Given a platform device that's been created by mfd_add_devices(), fetch
> > >   * the .mfd_data entry from the mfd_cell that created it.
> > > 
> > > 
> > > -- 
> > > Intel Open Source Technology Centre
> > > http://oss.intel.com/
> 
> -- 
> Intel Open Source Technology Centre
> http://oss.intel.com/
