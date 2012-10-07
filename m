Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2JGOHG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 10:07:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45696 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab2JGOGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 10:06:53 -0400
Date: Sun, 7 Oct 2012 22:06:50 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: yongd <yongd@marvell.com>
Cc: Chris Ball <cjb@laptop.org>, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Daniel Drake <dsd@laptop.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wilson Callan <wilson.callan@savantsystems.com>,
        Ben Dooks <ben-linux@fluff.org>, zhangfei.gao@marvell.com,
        kevin.liu@marvell.com, jlfu@marvell.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mmc: esdhc: enable polling to detect card by itself
Message-ID: <20121007140648.GA10148@S2101-09.ap.freescale.net>
References: <1348828113-19668-1-git-send-email-yongd@marvell.com>
 <1348828113-19668-2-git-send-email-yongd@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348828113-19668-2-git-send-email-yongd@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 06:28:31PM +0800, yongd wrote:
> In the current code logic, sdhci_add_host() will enable the polling
> method (set MMC_CAP_NEEDS_POLL) for a removable card (MMC_CAP_
> NONREMOVABLE is not set) whose host's internal card detection method
> is disabled for some reason (SDHCI_QUIRK_BROKEN_CARD_DETECTION is set).
> 
> However, this is improper since we can have some other card detection
> methods besides host internal card detection and polling method. For
> example, if the card detection type is ESDHC_CD_GPIO (external gpio pin
> for CD), we will keep SDHCI_QUIRK_BROKEN_CARD_DETECTION set. This is right.
> But, just as above said, sdhci_add_host() will also enable polling for such
> a card. This is redundant.
> 
At least for sdhci-esdhc-imx, SDHCI_QUIRK_BROKEN_CARD_DETECTION will
be set only when neither ESDHC_CD_GPIO nor ESDHC_CD_CONTROLLER works.

Shawn

> On the other hand, for the card with ESDHC_CD_NONE detection type(no CD, neither
> controller nor gpio, so use polling), we currently rely on sdhci_add_host() to
> enable polling for us.
> 
> Here proposed a solution for such an embarrassing case. 1st, this patch will
> de-couple polling enabling with sdhci_add_host() by doing this in host driver
> itself, just as some other vendors. 2nd, one more patch will remove such improper
> MMC_CAP_NEEDS_POLL enabling in sdhci_add_host().
> 
> Change-Id: Ia7525009d8fd188e3f0169f225e4a76ff9e94b47
> Signed-off-by: yongd <yongd@marvell.com>
> ---
>  drivers/mmc/host/sdhci-esdhc-imx.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
> index e23f813..f70079c 100644
> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -569,6 +569,7 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
>  		break;
>  
>  	case ESDHC_CD_NONE:
> +		host->mmc->caps = MMC_CAP_NEEDS_POLL;
>  		break;
>  	}
>  
> -- 
> 1.7.9.5
> 
