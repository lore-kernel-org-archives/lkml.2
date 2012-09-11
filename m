Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab2IKSFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:05:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48199 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2IKSFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:05:22 -0400
Date: Tue, 11 Sep 2012 14:06:32 -0400
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        AnilKumar <anilkumar@ti.com>
Subject: Re: [PATCH 1/2] spi: omap2-mcspi: add pinctrl support
Message-ID: <20120911180632.GN27758@beef>
References: <1347385599-27558-1-git-send-email-mporter@ti.com>
 <1347385599-27558-2-git-send-email-mporter@ti.com>
 <20120911180041.GH23092@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911180041.GH23092@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 11:00:41AM -0700, Tony Lindgren wrote:
> * Matt Porter <mporter@ti.com> [120911 10:46]:
> > Adds pinctrl support to support OMAP platforms that boot from DT
> > and rely on pinctrl support to set pinmuxes.
> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> >  drivers/spi/spi-omap2-mcspi.c |    9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> > index b2fb141..6c67cdb 100644
> > --- a/drivers/spi/spi-omap2-mcspi.c
> > +++ b/drivers/spi/spi-omap2-mcspi.c
> > @@ -38,6 +38,8 @@
> >  #include <linux/pm_runtime.h>
> >  #include <linux/of.h>
> >  #include <linux/of_device.h>
> > +#include <linux/pinctrl/consumer.h>
> > +#include <linux/err.h>
> >  
> >  #include <linux/spi/spi.h>
> >  
> > @@ -1124,6 +1126,7 @@ static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
> >  	static int		bus_num = 1;
> >  	struct device_node	*node = pdev->dev.of_node;
> >  	const struct of_device_id *match;
> > +	struct pinctrl *pinctrl;
> >  
> >  	master = spi_alloc_master(&pdev->dev, sizeof *mcspi);
> >  	if (master == NULL) {
> > @@ -1219,6 +1222,12 @@ static int __devinit omap2_mcspi_probe(struct platform_device *pdev)
> >  	if (status < 0)
> >  		goto dma_chnl_free;
> >  
> > +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> > +	if (IS_ERR(pinctrl)) {
> > +		status = PTR_ERR(pinctrl);
> > +		goto dma_chnl_free;
> > +	}
> > +
> >  	pm_runtime_use_autosuspend(&pdev->dev);
> >  	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
> >  	pm_runtime_enable(&pdev->dev);
> 
> You should just print out a warning here as most boards don't
> have pinctrl implemented at this point, or may never have.

It will not hit this error path on the boards without pinctrl due
to the second part of the series. The error check is for some really
unexpected failure in the pinctrl core and parsing functionality where
we want it to bail out.

-Matt
