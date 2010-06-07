Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0FGBAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 21:00:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46754 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab0FGBAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 21:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VSeTtMVHePbQxem6PMUO6aPtZDpjpdNfc3rj52eYAo3/6hslxTaoQFf9P0RpLMLYjq
         RnIQC+jluNL17zDU1YEdtPKM8IAOcEPDocE3bYmMKp6q12vt0WV6Z4HwXjKRLYRxapYC
         IhapMCsK5wYdjtOPg0D90ryTc5wOZkZaU8vPg=
Subject: Re: [PATCH 1/2] mmc: make sdhci work with ricoh mmc controller
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
In-Reply-To: <b99ba230e4a7f8b2174d7f52f1e7324c@localhost>
References: <1275859475.3151.4.camel@maxim-laptop>
	 <1275859731-2898-1-git-send-email-maximlevitsky@gmail.com>
	 <b99ba230e4a7f8b2174d7f52f1e7324c@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 03:37:32 +0300
Message-ID: <1275871052.24091.7.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-06 at 19:11 -0400, Philip Langdale wrote: 
> On Mon,  7 Jun 2010 00:28:50 +0300, Maxim Levitsky
> <maximlevitsky@gmail.com> wrote:
> > The current way of disabling it is not well tested by vendor
> > and has all kinds of bugs that show up on resume from ram/disk.
> > 
> > Old way of disabling is still supported by
> > continuing to use CONFIG_MMC_RICOH_MMC.
> > 
> > Based on
> > 'http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002085.html'
> > Most of the credit for this goes to Andrew de Quincey
> > 
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > CC: Andrew de Quincey <adq_dvb@lidskialf.net>
> > CC: linux-mmc@vger.kernel.org <linux-mmc@vger.kernel.org>
> 
> ACK with one change to add a #define for the device ID.
I am not sure about this.
When I submitted a driver for xD part I was told that unless device is
shared by several pieces of code, its not ok to add it to pci_ids.c.
The device is I was told can be hardcoded in the driver.
Nothing against changing it. 
> 
> > ---
> >  drivers/mmc/host/sdhci-pci.c |   31 +++++++++++++++++++++++++++++++
> >  drivers/mmc/host/sdhci.c     |    3 ++-
> >  drivers/mmc/host/sdhci.h     |    4 ++++
> >  3 files changed, 37 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> > index 65483fd..c4bcaeb 100644
> > --- a/drivers/mmc/host/sdhci-pci.c
> > +++ b/drivers/mmc/host/sdhci-pci.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/pci.h>
> >  #include <linux/dma-mapping.h>
> >  #include <linux/slab.h>
> > +#include <linux/device.h>
> >  
> >  #include <linux/mmc/host.h>
> >  
> > @@ -84,7 +85,21 @@ static int ricoh_probe(struct sdhci_pci_chip *chip)
> >  	if (chip->pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG ||
> >  	    chip->pdev->subsystem_vendor == PCI_VENDOR_ID_SONY)
> >  		chip->quirks |= SDHCI_QUIRK_NO_CARD_NO_RESET;
> > +	return 0;
> > +}
> > +
> > +static int ricoh_mmc_probe_slot(struct sdhci_pci_slot *slot)
> > +{
> > +	slot->host->caps =
> > +		((0x21 << SDHCI_TIMEOUT_CLK_SHIFT)
> > +			& SDHCI_TIMEOUT_CLK_MASK) |
> >  
> > +		((0x21 << SDHCI_CLOCK_BASE_SHIFT)
> > +			& SDHCI_CLOCK_BASE_MASK) |
> > +
> > +		SDHCI_TIMEOUT_CLK_UNIT |
> > +		SDHCI_CAN_VDD_330 |
> > +		SDHCI_CAN_DO_SDMA;
> >  	return 0;
> >  }
> 
> As we discussed, highspeed works. Of course, sdhci never sets the MMC
> highspeed flag so the cap is irrelevant. We'd need another quirk to
> indicate highspeed MMC is supported.
> 
> This can be done in a separate patch.
Sure, but maybe we can enable this for SD/SDHC too?

> 
> > @@ -95,6 +110,14 @@ static const struct sdhci_pci_fixes sdhci_ricoh = {
> >  			  SDHCI_QUIRK_CLOCK_BEFORE_RESET,
> >  };
> >  
> > +static const struct sdhci_pci_fixes sdhci_ricoh_mmc = {
> > +	.probe_slot	= ricoh_mmc_probe_slot,
> > +	.quirks		= SDHCI_QUIRK_32BIT_DMA_ADDR |
> > +			  SDHCI_QUIRK_CLOCK_BEFORE_RESET |
> > +			  SDHCI_QUIRK_NO_CARD_NO_RESET |
> > +			  SDHCI_QUIRK_MISSING_CAPS
> > +};
> > +
> >  static const struct sdhci_pci_fixes sdhci_ene_712 = {
> >  	.quirks		= SDHCI_QUIRK_SINGLE_POWER_WRITE |
> >  			  SDHCI_QUIRK_BROKEN_DMA,
> > @@ -374,6 +397,14 @@ static const struct pci_device_id pci_ids[]
> > __devinitdata = {
> >  	},
> >  
> >  	{
> > +		.vendor         = PCI_VENDOR_ID_RICOH,
> > +		.device         = 0x843,
> > +		.subvendor      = PCI_ANY_ID,
> > +		.subdevice      = PCI_ANY_ID,
> > +		.driver_data    = (kernel_ulong_t)&sdhci_ricoh_mmc,
> > +	},
> > +
> > +	{
> 
> It seems we generally want to add a #define for the device ID.
> The ENE device below has one.
> 
> >  		.vendor		= PCI_VENDOR_ID_ENE,
> >  		.device		= PCI_DEVICE_ID_ENE_CB712_SD,
> >  		.subvendor	= PCI_ANY_ID,
> > diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> > index c6d1bd8..483b78e 100644
> > --- a/drivers/mmc/host/sdhci.c
> > +++ b/drivers/mmc/host/sdhci.c
> > @@ -1687,7 +1687,8 @@ int sdhci_add_host(struct sdhci_host *host)
> >  			host->version);
> >  	}
> >  
> > -	caps = sdhci_readl(host, SDHCI_CAPABILITIES);
> > +	caps = (host->quirks & SDHCI_QUIRK_MISSING_CAPS) ? host->caps :
> > +		sdhci_readl(host, SDHCI_CAPABILITIES);
> >  
> >  	if (host->quirks & SDHCI_QUIRK_FORCE_DMA)
> >  		host->flags |= SDHCI_USE_SDMA;
> > diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
> > index c846813..b1839a3 100644
> > --- a/drivers/mmc/host/sdhci.h
> > +++ b/drivers/mmc/host/sdhci.h
> > @@ -240,6 +240,8 @@ struct sdhci_host {
> >  #define SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN		(1<<25)
> >  /* Controller cannot support End Attribute in NOP ADMA descriptor */
> >  #define SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC		(1<<26)
> > +/* Controller is missing device caps. Use caps provided by host */
> > +#define SDHCI_QUIRK_MISSING_CAPS			(1<<27)
> >  
> >  	int			irq;		/* Device IRQ */
> >  	void __iomem *		ioaddr;		/* Mapped address */
> > @@ -292,6 +294,8 @@ struct sdhci_host {
> >  
> >  	struct timer_list	timer;		/* Timer for timeouts */
> >  
> > +	unsigned int		caps;		/* Alternative capabilities */
> > +
> >  	unsigned long		private[0] ____cacheline_aligned;
> >  };
> 
> --phil

Best regards,
Maxim Levitsky

