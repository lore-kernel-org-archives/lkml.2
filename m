Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0FCQjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:39:21 -0400
Received: from usul.saidi.cx ([204.11.33.34]:50123 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753430Ab0FCQjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:39:20 -0400
X-Greylist: delayed 1680 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2010 12:39:19 EDT
Date: Thu, 3 Jun 2010 09:39:14 -0700
From: Philip Langdale <philipl@overt.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, adq_dvb@lidskialf.net,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] mmc: make sdhci work with ricoh mmc controller
Message-ID: <20100603093914.3397ac42@fido5>
In-Reply-To: <1275582709.2563.19.camel@maxim-laptop>
References: <1275516180.30272.4.camel@maxim-laptop>
	<1275527787-3783-1-git-send-email-maximlevitsky@gmail.com>
	<20100603091113.7b1d6fc0@fido5>
	<1275582709.2563.19.camel@maxim-laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jun 2010 19:31:49 +0300
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Thu, 2010-06-03 at 09:11 -0700, Philip Langdale wrote: 
> > On Thu,  3 Jun 2010 04:16:27 +0300
> > Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > 
> > > The current way of disabling it is not well tested by vendor
> > > and has all kinds of bugs that show up on resume from ram/disk.
> > > 
> > > Old way of disabling is still supported by
> > > continuing to use CONFIG_MMC_RICOH_MMC.
> > >
> > > Based on
> > > 'http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002085.html'
> > 
> > As long as this doesn't limit the performance of MMC cards, I can't
> > complain.
> > 
> > BTW, the new PCIe native controllers from Ricoh don't require the
> > MMC controller to be disabled - the SD controller sees the cards by
> > default; I guess some bit has to be twiddled by the MMC driver.
> Can I distinguish between this and newer controllers.
> Could you help me with that?

I'll check in on it tomorrow - I don't have access to a relevant machine
today, but I'm pretty sure they changed the PCI ID so it won't be a
problem.

> 
> > 
> > > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > > CC: adq_dvb@lidskialf.net
> > > CC: linux-mmc@vger.kernel.org <linux-mmc@vger.kernel.org>
> > > ---
> > >  drivers/mmc/host/sdhci-pci.c |   34
> > > ++++++++++++++++++++++++++++++++++ drivers/mmc/host/sdhci.c     |
> > > 5 ++++- drivers/mmc/host/sdhci.h     |    2 ++
> > >  3 files changed, 40 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/mmc/host/sdhci-pci.c
> > > b/drivers/mmc/host/sdhci-pci.c index 65483fd..3843780 100644
> > > --- a/drivers/mmc/host/sdhci-pci.c
> > > +++ b/drivers/mmc/host/sdhci-pci.c
> > > @@ -17,6 +17,7 @@
> > >  #include <linux/pci.h>
> > >  #include <linux/dma-mapping.h>
> > >  #include <linux/slab.h>
> > > +#include <linux/device.h>
> > >  
> > >  #include <linux/mmc/host.h>
> > >  
> > > @@ -85,6 +86,26 @@ static int ricoh_probe(struct sdhci_pci_chip
> > > *chip) chip->pdev->subsystem_vendor == PCI_VENDOR_ID_SONY)
> > >  		chip->quirks |= SDHCI_QUIRK_NO_CARD_NO_RESET;
> > >  
> > > +	/* To disable hardware races against MMC part */
> > > +	device_disable_async_suspend(&chip->pci_dev->dev);
> > > +	return 0;
> > > +}
> > 
> > It would be nice if this could be more selective so it only happens
> > if it's really needed.
> Same as above

Not sure how to do it in an elegant way. The probe function could search
the PCI bus for the other device - ugh. But if you can't reproduce the
race, then we don't need to worry.

> > 
> > > +
> > > +static int ricoh_mmc_probe_slot(struct sdhci_pci_slot *slot)
> > > +{
> > > +	slot->host->caps =
> > > +		((0x21 << SDHCI_TIMEOUT_CLK_SHIFT)
> > > +			& SDHCI_TIMEOUT_CLK_MASK) |
> > > +
> > > +		((0x21 << SDHCI_CLOCK_BASE_SHIFT)
> > > +			& SDHCI_CLOCK_BASE_MASK) |
> > > +
> > > +		SDHCI_TIMEOUT_CLK_UNIT |
> > > +		SDHCI_CAN_VDD_330 |
> > > +		SDHCI_CAN_DO_SDMA ;
> > 
> > Have you been able to establish if 4bit and high-speed operations
> > work correctly through the MMC controller? I note that you didn't
> > set SDHCI_CAN_DO_HISPD.
> Didn't test that yet, will do.
> I hope my MMCPlus card can do high-speed.

I should get a chance today to test this as well; I'll let you know
what I see.

> > 
> > > +
> > > +	/* To disable hardware races against SDHC part */
> > > +	device_disable_async_suspend(&slot->chip->pci_dev->dev);
> > >  	return 0;
> > >  }
> > >  
> > > @@ -95,6 +116,11 @@ static const struct sdhci_pci_fixes
> > > sdhci_ricoh = { SDHCI_QUIRK_CLOCK_BEFORE_RESET,
> > >  };
> > >  
> > > +static const struct sdhci_pci_fixes sdhci_ricoh_mmc = {
> > > +	.probe_slot	= ricoh_mmc_probe_slot,
> > > +	.quirks		= SDHCI_QUIRK_NO_CARD_NO_RESET,
> > > +};
> > > +
> > >  static const struct sdhci_pci_fixes sdhci_ene_712 = {
> > >  	.quirks		= SDHCI_QUIRK_SINGLE_POWER_WRITE |
> > >  			  SDHCI_QUIRK_BROKEN_DMA,
> > > @@ -374,6 +400,14 @@ static const struct pci_device_id pci_ids[]
> > > __devinitdata = { },
> > >  
> > >  	{
> > > +		.vendor         = PCI_VENDOR_ID_RICOH,
> > > +		.device         = 0x843,
> > > +		.subvendor      = PCI_ANY_ID,
> > > +		.subdevice      = PCI_ANY_ID,
> > > +		.driver_data    =
> > > (kernel_ulong_t)&sdhci_ricoh_mmc,
> > > +	},
> > > +
> > > +	{
> > >  		.vendor		= PCI_VENDOR_ID_ENE,
> > >  		.device		=
> > > PCI_DEVICE_ID_ENE_CB712_SD, .subvendor	= PCI_ANY_ID,
> > > diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> > > index c6d1bd8..dbd9367 100644
> > > --- a/drivers/mmc/host/sdhci.c
> > > +++ b/drivers/mmc/host/sdhci.c
> > > @@ -1687,7 +1687,10 @@ int sdhci_add_host(struct sdhci_host *host)
> > >  			host->version);
> > >  	}
> > >  
> > > -	caps = sdhci_readl(host, SDHCI_CAPABILITIES);
> > > +	if (host->caps)
> > > +		caps = host->caps;
> > > +	else
> > > +		caps = sdhci_readl(host, SDHCI_CAPABILITIES);
> > 
> > I'd prefer keying this off an explicit quirk.
> Could you explain?
> 
> Do you mean I should add SDHCI_QUIRK_MISSING_CAPS ?
> This is fine.
> 
> If you mean that I should create a SDHCI_QUIRK_RICOH_MMC_CAPS,
> and hardcode caps in sdhci, I kind of disagree, too ugly :-)

I meant SDHCI_QUIRK_MISSING_CAPS. :-)

Use host->caps but only when the QUIRK is set.

> 
> Btw, suspend/resume races seem to disappear. Maybe I didn't install
> the kernel (will test more) 
> > >  
> > >  	if (host->quirks & SDHCI_QUIRK_FORCE_DMA)
> > >  		host->flags |= SDHCI_USE_SDMA;
> > > diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
> > > index c846813..b41581a 100644
> > > --- a/drivers/mmc/host/sdhci.h
> > > +++ b/drivers/mmc/host/sdhci.h
> > > @@ -292,6 +292,8 @@ struct sdhci_host {
> > >  
> > >  	struct timer_list	timer;		/* Timer
> > > for timeouts */ 
> > > +	unsigned int		caps;		/*
> > > Alternative capabilities */ +
> > >  	unsigned long		private[0]
> > > ____cacheline_aligned; };
> > >  
> > 
> > --phil
> 
> 
> Best regards,
> Maxim Levitsky
> 
> 

--phil
