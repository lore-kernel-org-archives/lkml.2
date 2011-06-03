Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab1FCUDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 16:03:19 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:46441 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1FCUDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 16:03:17 -0400
Date: Fri, 3 Jun 2011 14:03:16 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cbouatmailru@gmail.com,
        w.sang@pengutronix.de, cjb@laptop.org, arnd@arndb.de,
        sfr@canb.auug.org.au, patches@linaro.org,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH] mmc: sdhci: change sdhci-pltfm into a module
Message-ID: <20110603200316.GB17972@ponder.secretlab.ca>
References: <20110601130431.59f4f0d4.sfr@canb.auug.org.au>
 <1306983470-18588-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306983470-18588-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 10:57:50AM +0800, Shawn Guo wrote:
> From: Shawn Guo <shawn.guo@freescale.com>
> 
> There are a couple of problems left from the sdhci pltfm and OF
> consolidation changes.
> 
> * When building more than one sdhci-pltfm based drivers in the same
>   image, linker will give multiple definition error on the sdhci-pltfm
>   helper functions.  For example right now, building sdhci-of-esdhc
>   and sdhci-of-hlwd together is a valid combination from Kconfig view.
> 
> * With the current build method, there is error with building the
>   drivers as module, but module installation fails with modprobe.
> 
> The patch fixes above problems by changing sdhci-pltfm into a module.
> To avoid EXPORT_SYMBOL on so many big endian IO accessors, it moves
> these accessors into sdhci-pltfm.h as the 'static inline' functions.
> As a result, sdhci.h needs to be included in sdhci-pltfm.h, and in
> turn can be removed from individual drivers which already include
> sdhci-pltfm.h.

Mostly looks good.  One comment below about a static inline, but
otherwise you can add my:

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> +static inline void sdhci_be32bs_writew(struct sdhci_host *host,
> +				       u16 val, int reg)
> +{
> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +	int base = reg & ~0x3;
> +	int shift = (reg & 0x2) * 8;
> +
> +	switch (reg) {
> +	case SDHCI_TRANSFER_MODE:
> +		/*
> +		 * Postpone this write, we must do it together with a
> +		 * command write that is down below.
> +		 */
> +		pltfm_host->xfer_mode_shadow = val;
> +		return;
> +	case SDHCI_COMMAND:
> +		sdhci_be32bs_writel(host,
> +				    val << 16 | pltfm_host->xfer_mode_shadow,
> +				    SDHCI_TRANSFER_MODE);
> +		return;
> +	}
> +	clrsetbits_be32(host->ioaddr + base, 0xffff << shift, val << shift);
> +}

This is really too big to be a static inline.  Go ahead and make it an
exported symbol.  Personally, I wouldn't worry about it and just exporting all
of these accessors.  Making them inline doesn't buy much anyway since
they are used to initialize an ops table, and making them inline
forces each driver to instantiate its own copy.

g.

> +
> +static inline void sdhci_be32bs_writeb(struct sdhci_host *host, u8 val, int reg)
> +{
> +	int base = reg & ~0x3;
> +	int shift = (reg & 0x3) * 8;
> +
> +	clrsetbits_be32(host->ioaddr + base , 0xff << shift, val << shift);
> +}
> +#endif /* CONFIG_MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER */
>  
>  extern void sdhci_get_of_property(struct platform_device *pdev);
>  
> diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
> index 1f66aca..18b0bd3 100644
> --- a/drivers/mmc/host/sdhci-tegra.c
> +++ b/drivers/mmc/host/sdhci-tegra.c
> @@ -24,7 +24,6 @@
>  #include <mach/gpio.h>
>  #include <mach/sdhci.h>
>  
> -#include "sdhci.h"
>  #include "sdhci-pltfm.h"
>  
>  static u32 tegra_sdhci_readl(struct sdhci_host *host, int reg)
> -- 
> 1.7.4.1
> 
> 
