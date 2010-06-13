Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0FMQGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 12:06:17 -0400
Received: from usul.saidi.cx ([204.11.33.34]:35772 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753055Ab0FMQGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 12:06:15 -0400
Date: Sun, 13 Jun 2010 09:06:11 -0700
From: Philip Langdale <philipl@overt.org>
To: maximlevitsky@gmail.com
Cc: linux-mmc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
Subject: Re: [PATCH v4] mmc: make sdhci work with ricoh mmc controller
Message-ID: <20100613090611.18bcfe08@fido5>
In-Reply-To: <4c128b3a.51a3cc0a.3161.30ab@mx.google.com>
References: <1276283286.8557.28.camel@maxim-laptop>
	<4c128b3a.51a3cc0a.3161.30ab@mx.google.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 22:15:02 +0300
maximlevitsky@gmail.com wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> The current way of disabling it is not well tested by vendor
> and has all kinds of bugs that show up on resume from ram/disk.
> 
> Old way of disabling is still supported by
> continuing to use CONFIG_MMC_RICOH_MMC.
> 
> Based on
> 'http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002085.html'
> Most of the credit for this goes to Andrew de Quincey
> 
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> CC: Andrew de Quincey <adq_dvb@lidskialf.net>
> CC: linux-mmc@vger.kernel.org <linux-mmc@vger.kernel.org>

Acked-by: Philip Langdale <philipl@overt.org>

> ---
>  drivers/mmc/host/sdhci-pci.c |   41
> +++++++++++++++++++++++++++++++++++++++++
> drivers/mmc/host/sdhci.c     |    3 ++- drivers/mmc/host/sdhci.h
> |    4 ++++ 3 files changed, 47 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-pci.c
> b/drivers/mmc/host/sdhci-pci.c index 65483fd..e021431 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -17,6 +17,7 @@
>  #include <linux/pci.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/slab.h>
> +#include <linux/device.h>
>  
>  #include <linux/mmc/host.h>
>  
> @@ -84,7 +85,30 @@ static int ricoh_probe(struct sdhci_pci_chip *chip)
>  	if (chip->pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG ||
>  	    chip->pdev->subsystem_vendor == PCI_VENDOR_ID_SONY)
>  		chip->quirks |= SDHCI_QUIRK_NO_CARD_NO_RESET;
> +	return 0;
> +}
> +
> +static int ricoh_mmc_probe_slot(struct sdhci_pci_slot *slot)
> +{
> +	slot->host->caps =
> +		((0x21 << SDHCI_TIMEOUT_CLK_SHIFT)
> +			& SDHCI_TIMEOUT_CLK_MASK) |
> +
> +		((0x21 << SDHCI_CLOCK_BASE_SHIFT)
> +			& SDHCI_CLOCK_BASE_MASK) |
>  
> +		SDHCI_TIMEOUT_CLK_UNIT |
> +		SDHCI_CAN_VDD_330 |
> +		SDHCI_CAN_DO_SDMA;
> +	return 0;
> +}
> +
> +static int ricoh_mmc_resume(struct sdhci_pci_chip *chip)
> +{
> +	/* Apply a delay to allow controller to settle */
> +	/* Otherwise it becomes confused if card state changed
> +		during suspend */
> +	msleep(500);
>  	return 0;
>  }
>  
> @@ -95,6 +119,15 @@ static const struct sdhci_pci_fixes sdhci_ricoh =
> { SDHCI_QUIRK_CLOCK_BEFORE_RESET,
>  };
>  
> +static const struct sdhci_pci_fixes sdhci_ricoh_mmc = {
> +	.probe_slot	= ricoh_mmc_probe_slot,
> +	.resume		= ricoh_mmc_resume,
> +	.quirks		= SDHCI_QUIRK_32BIT_DMA_ADDR |
> +			  SDHCI_QUIRK_CLOCK_BEFORE_RESET |
> +			  SDHCI_QUIRK_NO_CARD_NO_RESET |
> +			  SDHCI_QUIRK_MISSING_CAPS
> +};
> +
>  static const struct sdhci_pci_fixes sdhci_ene_712 = {
>  	.quirks		= SDHCI_QUIRK_SINGLE_POWER_WRITE |
>  			  SDHCI_QUIRK_BROKEN_DMA,
> @@ -374,6 +407,14 @@ static const struct pci_device_id pci_ids[]
> __devinitdata = { },
>  
>  	{
> +		.vendor         = PCI_VENDOR_ID_RICOH,
> +		.device         = 0x843,
> +		.subvendor      = PCI_ANY_ID,
> +		.subdevice      = PCI_ANY_ID,
> +		.driver_data    = (kernel_ulong_t)&sdhci_ricoh_mmc,
> +	},
> +
> +	{
>  		.vendor		= PCI_VENDOR_ID_ENE,
>  		.device		= PCI_DEVICE_ID_ENE_CB712_SD,
>  		.subvendor	= PCI_ANY_ID,
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index c6d1bd8..483b78e 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1687,7 +1687,8 @@ int sdhci_add_host(struct sdhci_host *host)
>  			host->version);
>  	}
>  
> -	caps = sdhci_readl(host, SDHCI_CAPABILITIES);
> +	caps = (host->quirks & SDHCI_QUIRK_MISSING_CAPS) ?
> host->caps :
> +		sdhci_readl(host, SDHCI_CAPABILITIES);
>  
>  	if (host->quirks & SDHCI_QUIRK_FORCE_DMA)
>  		host->flags |= SDHCI_USE_SDMA;
> diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
> index c846813..b1839a3 100644
> --- a/drivers/mmc/host/sdhci.h
> +++ b/drivers/mmc/host/sdhci.h
> @@ -240,6 +240,8 @@ struct sdhci_host {
>  #define SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN		(1<<25)
>  /* Controller cannot support End Attribute in NOP ADMA descriptor */
>  #define SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC		(1<<26)
> +/* Controller is missing device caps. Use caps provided by host */
> +#define SDHCI_QUIRK_MISSING_CAPS			(1<<27)
>  
>  	int			irq;		/* Device IRQ
> */ void __iomem *		ioaddr;		/* Mapped
> address */ @@ -292,6 +294,8 @@ struct sdhci_host {
>  
>  	struct timer_list	timer;		/* Timer for
> timeouts */ 
> +	unsigned int		caps;		/*
> Alternative capabilities */ +
>  	unsigned long		private[0]
> ____cacheline_aligned; };
>  

--phil
