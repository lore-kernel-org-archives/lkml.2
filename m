Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0FCQLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:11:23 -0400
Received: from usul.saidi.cx ([204.11.33.34]:57623 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756558Ab0FCQLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:11:20 -0400
Date: Thu, 3 Jun 2010 09:11:13 -0700
From: Philip Langdale <philipl@overt.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, adq_dvb@lidskialf.net,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] mmc: make sdhci work with ricoh mmc controller
Message-ID: <20100603091113.7b1d6fc0@fido5>
In-Reply-To: <1275527787-3783-1-git-send-email-maximlevitsky@gmail.com>
References: <1275516180.30272.4.camel@maxim-laptop>
	<1275527787-3783-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Jun 2010 04:16:27 +0300
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> The current way of disabling it is not well tested by vendor
> and has all kinds of bugs that show up on resume from ram/disk.
> 
> Old way of disabling is still supported by
> continuing to use CONFIG_MMC_RICOH_MMC.
>
> Based on
> 'http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002085.html'

As long as this doesn't limit the performance of MMC cards, I can't
complain.

BTW, the new PCIe native controllers from Ricoh don't require the
MMC controller to be disabled - the SD controller sees the cards by
default; I guess some bit has to be twiddled by the MMC driver.

> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> CC: adq_dvb@lidskialf.net
> CC: linux-mmc@vger.kernel.org <linux-mmc@vger.kernel.org>
> ---
>  drivers/mmc/host/sdhci-pci.c |   34
> ++++++++++++++++++++++++++++++++++ drivers/mmc/host/sdhci.c     |
> 5 ++++- drivers/mmc/host/sdhci.h     |    2 ++
>  3 files changed, 40 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-pci.c
> b/drivers/mmc/host/sdhci-pci.c index 65483fd..3843780 100644
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
> @@ -85,6 +86,26 @@ static int ricoh_probe(struct sdhci_pci_chip *chip)
>  	    chip->pdev->subsystem_vendor == PCI_VENDOR_ID_SONY)
>  		chip->quirks |= SDHCI_QUIRK_NO_CARD_NO_RESET;
>  
> +	/* To disable hardware races against MMC part */
> +	device_disable_async_suspend(&chip->pci_dev->dev);
> +	return 0;
> +}

It would be nice if this could be more selective so it only happens
if it's really needed.

> +
> +static int ricoh_mmc_probe_slot(struct sdhci_pci_slot *slot)
> +{
> +	slot->host->caps =
> +		((0x21 << SDHCI_TIMEOUT_CLK_SHIFT)
> +			& SDHCI_TIMEOUT_CLK_MASK) |
> +
> +		((0x21 << SDHCI_CLOCK_BASE_SHIFT)
> +			& SDHCI_CLOCK_BASE_MASK) |
> +
> +		SDHCI_TIMEOUT_CLK_UNIT |
> +		SDHCI_CAN_VDD_330 |
> +		SDHCI_CAN_DO_SDMA ;

Have you been able to establish if 4bit and high-speed operations
work correctly through the MMC controller? I note that you didn't
set SDHCI_CAN_DO_HISPD.

> +
> +	/* To disable hardware races against SDHC part */
> +	device_disable_async_suspend(&slot->chip->pci_dev->dev);
>  	return 0;
>  }
>  
> @@ -95,6 +116,11 @@ static const struct sdhci_pci_fixes sdhci_ricoh =
> { SDHCI_QUIRK_CLOCK_BEFORE_RESET,
>  };
>  
> +static const struct sdhci_pci_fixes sdhci_ricoh_mmc = {
> +	.probe_slot	= ricoh_mmc_probe_slot,
> +	.quirks		= SDHCI_QUIRK_NO_CARD_NO_RESET,
> +};
> +
>  static const struct sdhci_pci_fixes sdhci_ene_712 = {
>  	.quirks		= SDHCI_QUIRK_SINGLE_POWER_WRITE |
>  			  SDHCI_QUIRK_BROKEN_DMA,
> @@ -374,6 +400,14 @@ static const struct pci_device_id pci_ids[]
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
> index c6d1bd8..dbd9367 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1687,7 +1687,10 @@ int sdhci_add_host(struct sdhci_host *host)
>  			host->version);
>  	}
>  
> -	caps = sdhci_readl(host, SDHCI_CAPABILITIES);
> +	if (host->caps)
> +		caps = host->caps;
> +	else
> +		caps = sdhci_readl(host, SDHCI_CAPABILITIES);

I'd prefer keying this off an explicit quirk.

>  
>  	if (host->quirks & SDHCI_QUIRK_FORCE_DMA)
>  		host->flags |= SDHCI_USE_SDMA;
> diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
> index c846813..b41581a 100644
> --- a/drivers/mmc/host/sdhci.h
> +++ b/drivers/mmc/host/sdhci.h
> @@ -292,6 +292,8 @@ struct sdhci_host {
>  
>  	struct timer_list	timer;		/* Timer for
> timeouts */ 
> +	unsigned int		caps;		/*
> Alternative capabilities */ +
>  	unsigned long		private[0]
> ____cacheline_aligned; };
>  

--phil
