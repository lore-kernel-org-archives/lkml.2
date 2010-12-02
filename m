Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab0LBLcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:32:02 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11714 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab0LBLcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:32:00 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6184"; a="64970696"
Subject: Re: [PATCH v4] mmc: Make ID freq configurable
From: Sahitya Tummala <stummala@codeaurora.org>
To: Hein_Tibosch <hein_tibosch@yahoo.es>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pierre Ossman <pierre@ossman.eu>, Chris Ball <cjb@laptop.org>,
        Ben Nizette <bn@niasdigital.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
In-Reply-To: <4C80187D.9000304@yahoo.es>
References: <4C80187D.9000304@yahoo.es>
Content-Type: text/plain
Date: Thu, 02 Dec 2010 16:46:22 +0530
Message-Id: <1291288582.15187.91.camel@stummala-linux.in.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hein Tibosch,

On Fri, 2010-09-03 at 05:34 +0800, Hein_Tibosch wrote:
> In the latest releases of the mmc driver, the freq during initialization
> is set to a fixed 400 Khz. This was reportedly too fast for several
> users. As there doesn't seem to be an ideal frequency which-works-for-all,
> Pierre suggested to let the driver try several frequencies.
> 
> This patch implements that idea. It will try mmc-initialization using
> several frequencies from an array 400, 300, 200 and 100.
> I submitted it earlier but it's now adapted to and tested with kernel
> 2.6.36-rc3.
> 
> In case SDIO is broken, it'll still try to detect SDMEM, also at different
> freqs.
> 
> Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
> 
> ---
> diff -Nurp a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> --- a/drivers/mmc/core/core.c	2010-08-29 23:36:04.000000000 +0800
> +++ b/drivers/mmc/core/core.c	2010-09-03 04:28:52.000000000 +0800
> @@ -907,12 +907,7 @@ static void mmc_power_up(struct mmc_host
>  	 */
>  	mmc_delay(10);
> 
> -	if (host->f_min > 400000) {
> -		pr_warning("%s: Minimum clock frequency too high for "
> -				"identification mode\n", mmc_hostname(host));
> -		host->ios.clock = host->f_min;
> -	} else
> -		host->ios.clock = 400000;
> +	host->ios.clock = host->f_init;
> 
>  	host->ios.power_mode = MMC_POWER_ON;
>  	mmc_set_ios(host);
> @@ -1404,6 +1399,8 @@ void mmc_rescan(struct work_struct *work
>  	u32 ocr;
>  	int err;
>  	unsigned long flags;
> +	int i;
> +	unsigned freqs[] = { 400000, 300000, 200000, 100000 };
> 
>  	spin_lock_irqsave(&host->lock, flags);
> 
> @@ -1443,55 +1440,64 @@ void mmc_rescan(struct work_struct *work
>  	if (host->ops->get_cd && host->ops->get_cd(host) == 0)
>  		goto out;
> 
> -	mmc_claim_host(host);
> +	for (i = 0; i < ARRAY_SIZE(freqs); i++) {
> +		mmc_claim_host(host);
> 
> -	mmc_power_up(host);
> -	sdio_reset(host);
> -	mmc_go_idle(host);
> +		if (freqs[i] >= host->f_min)
> +			host->f_init = freqs[i];
> +		else if (i && freqs[i-1] <= host->f_min)
> +			goto out;
> +		else
> +			host->f_init = host->f_min;
> 
> -	mmc_send_if_cond(host, host->ocr_avail);
> +		printk ("mmc_rescan: trying %u Hz\n", host->f_init);
> +		mmc_power_up(host);
> +		sdio_reset(host);
> +		mmc_go_idle(host);
> 
> -	/*
> -	 * First we search for SDIO...
> -	 */
> -	err = mmc_send_io_op_cond(host, 0, &ocr);
> -	if (!err) {
> -		if (mmc_attach_sdio(host, ocr)) {
> -			mmc_claim_host(host);
> -			/* try SDMEM (but not MMC) even if SDIO is broken */
> -			if (mmc_send_app_op_cond(host, 0, &ocr))
> -				goto out_fail;
> +		mmc_send_if_cond(host, host->ocr_avail);
> +
> +		/*
> +		 * First we search for SDIO...
> +		 */
> +		err = mmc_send_io_op_cond(host, 0, &ocr);
> +		if (!err) {
> +			if (mmc_attach_sdio(host, ocr)) {
> +				mmc_claim_host(host);
> +				/* try SDMEM (but not MMC) even if SDIO is broken */
> +				if (mmc_send_app_op_cond(host, 0, &ocr))

In case of SDIO error, mmc_power_off() is getting called as part of
mmc_detach_bus().  Shouldn't we power up the host before checking for
SDMEM? Any comments?

> +					goto out_fail;
> +
> +				if (mmc_attach_sd(host, ocr))
> +					mmc_power_off(host);
> +			}
> +			goto out;
> +		}

Thanks,
Sahitya.
--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.

