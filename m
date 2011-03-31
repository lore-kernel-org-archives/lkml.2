Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab1CaPxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:53:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57284 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1CaPxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:53:16 -0400
Date: Thu, 31 Mar 2011 09:53:12 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 4/5] mmc: sdhci: consolidate sdhci-of-esdhc and
 sdhci-esdhc-imx
Message-ID: <20110331155312.GC26709@ponder.secretlab.ca>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
 <1301042931-4869-5-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301042931-4869-5-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 04:48:50PM +0800, Shawn Guo wrote:
> This patch is to consolidate SDHCI driver for Freescale eSDHC
> controller found on both MPCxxx and i.MX platforms.  It turns
> sdhci-of-esdhc.c and sdhci-esdhc-imx.c into one sdhci-esdhc.c,
> which gets the same pair of .probe and .remove serving two cases.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  drivers/mmc/host/Kconfig           |   38 ++--
>  drivers/mmc/host/Makefile          |    3 +-
>  drivers/mmc/host/sdhci-esdhc-imx.c |  210 ------------------
>  drivers/mmc/host/sdhci-esdhc.c     |  413 ++++++++++++++++++++++++++++++++++++
>  drivers/mmc/host/sdhci-of-esdhc.c  |  162 --------------

This patch would be easier to review if it was split into two patches;
first rename sdhci-esdhc-imx.c to sdhci-esdhc.c without any changes to
the .c code, and then a second patch to merge the ppc bits into the
imx version.

> +#if defined(CONFIG_OF)
> +#include <linux/of_device.h>
> +static const struct of_device_id sdhci_esdhc_dt_ids[] = {
> +#ifdef CONFIG_MMC_SDHCI_ESDHC_IMX
> +	{ .compatible = "fsl,imx-esdhc", .data = &sdhci_esdhc_imx_pdata },
> +#endif
> +#ifdef CONFIG_MMC_SDHCI_ESDHC_MPC
> +	{ .compatible = "fsl,mpc8379-esdhc", .data = &sdhci_esdhc_mpc_pdata },
> +	{ .compatible = "fsl,mpc8536-esdhc", .data = &sdhci_esdhc_mpc_pdata },
> +	{ .compatible = "fsl,esdhc", .data = &sdhci_esdhc_mpc_pdata },
> +#endif
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(platform, sdhci_esdhc_dt_ids);
> +
> +static const struct of_device_id *
> +sdhci_esdhc_get_of_device_id(struct platform_device *pdev)
> +{
> +	return of_match_device(sdhci_esdhc_dt_ids, &pdev->dev);

You can add an empty implementation of of_match_device() to
linux/of_device.h.  That would eliminate the need for this function.

g.
