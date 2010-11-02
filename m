Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab0KBHjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:39:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41078 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933215Ab0KBHjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:39:42 -0400
Date: Tue, 2 Nov 2010 08:39:32 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>, Andrew Morton <akpm@linux-foundation.org>,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Eric =?iso-8859-15?Q?B=E9nard?= <eric@eukrea.com>,
        Fabio Estevam <fabioestevam@yahoo.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] mxcmmc: Add the ability to bind a regulator to manage
	the MMC card voltage
Message-ID: <20101102073932.GB6017@pengutronix.de>
References: <1288656337.29881.13.camel@realization>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288656337.29881.13.camel@realization>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:39:02 up 121 days, 22:49, 37 users,  load average: 0.23, 0.20,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 01:05:37AM +0100, Alberto Panizzo wrote:
> This implementation is based on the pxamci.c driver and it will
> be used to support the mx31_3ds machine.
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>

Looks good to me

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
> 
> This patch is based on the pengutronix for-rmk branch and apply to the
> linus tre, version:2.6.37-rc1
> 
> ..cc the lists, sorry for the double mail.
> 
>  drivers/mmc/host/mxcmmc.c |   48 +++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 42 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
> index 350f78e..e4637fc 100644
> --- a/drivers/mmc/host/mxcmmc.c
> +++ b/drivers/mmc/host/mxcmmc.c
> @@ -31,6 +31,7 @@
>  #include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/gpio.h>
> +#include <linux/regulator/consumer.h>
>  
>  #include <asm/dma.h>
>  #include <asm/irq.h>
> @@ -141,10 +142,45 @@ struct mxcmci_host {
>  
>  	struct work_struct	datawork;
>  	spinlock_t		lock;
> +
> +	struct regulator	*vcc;
>  };
>  
>  static void mxcmci_set_clk_rate(struct mxcmci_host *host, unsigned int clk_ios);
>  
> +static inline void mxcmci_init_ocr(struct mxcmci_host *host)
> +{
> +#ifdef CONFIG_REGULATOR
> +	host->vcc = regulator_get(mmc_dev(host->mmc), "vmmc");
> +
> +	if (IS_ERR(host->vcc)) {
> +		host->vcc = NULL;
> +	} else {
> +		host->mmc->ocr_avail = mmc_regulator_get_ocrmask(host->vcc);
> +		if (host->pdata && host->pdata->ocr_avail)
> +			dev_warn(mmc_dev(host->mmc),
> +				"pdata->ocr_avail will not be used\n");
> +	}
> +#endif
> +	if (host->vcc == NULL) {
> +		/* fall-back to platform data */
> +		if (host->pdata && host->pdata->ocr_avail)
> +			host->mmc->ocr_avail = host->pdata->ocr_avail;
> +		else
> +			host->mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
> +	}
> +}
> +
> +static inline void mxcmci_set_power(struct mxcmci_host *host, unsigned int vdd)
> +{
> +#ifdef CONFIG_REGULATOR
> +	if (host->vcc)
> +		mmc_regulator_set_ocr(host->vcc, vdd);
> +#endif
> +	if (host->pdata && host->pdata->setpower)
> +		host->pdata->setpower(mmc_dev(host->mmc), vdd);
> +}
> +
>  static inline int mxcmci_use_dma(struct mxcmci_host *host)
>  {
>  	return host->do_dma;
> @@ -680,9 +716,9 @@ static void mxcmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  		host->cmdat &= ~CMD_DAT_CONT_BUS_WIDTH_4;
>  
>  	if (host->power_mode != ios->power_mode) {
> -		if (host->pdata && host->pdata->setpower)
> -			host->pdata->setpower(mmc_dev(mmc), ios->vdd);
> +		mxcmci_set_power(host, ios->vdd);
>  		host->power_mode = ios->power_mode;
> +
>  		if (ios->power_mode == MMC_POWER_ON)
>  			host->cmdat |= CMD_DAT_CONT_INIT;
>  	}
> @@ -808,10 +844,7 @@ static int mxcmci_probe(struct platform_device *pdev)
>  	host->pdata = pdev->dev.platform_data;
>  	spin_lock_init(&host->lock);
>  
> -	if (host->pdata && host->pdata->ocr_avail)
> -		mmc->ocr_avail = host->pdata->ocr_avail;
> -	else
> -		mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
> +	mxcmci_init_ocr(host);
>  
>  	if (host->pdata && host->pdata->dat3_card_detect)
>  		host->default_irq_mask =
> @@ -916,6 +949,9 @@ static int mxcmci_remove(struct platform_device *pdev)
>  
>  	mmc_remove_host(mmc);
>  
> +	if (host->vcc)
> +		regulator_put(host->vcc);
> +
>  	if (host->pdata && host->pdata->exit)
>  		host->pdata->exit(&pdev->dev, mmc);
>  
> -- 
> 1.6.3.3
> 
> 
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
