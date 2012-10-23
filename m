Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab2JWIQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:16:49 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16466 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2JWIQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:16:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 23 Oct 2012 01:16:42 -0700
From: Pavan Kunapuli <pkunapuli@nvidia.com>
To: Lucas Stach <dev@lynxeye.de>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Pavan Kunapuli <pkunapuli@nvidia.com>
Date: Tue, 23 Oct 2012 13:46:36 +0530
Subject: RE: [PATCH 2/2] mmc: sdhci: Defer probe if regulator_get fails
Thread-Topic: [PATCH 2/2] mmc: sdhci: Defer probe if regulator_get fails
Thread-Index: Ac2w9BbqN+7ZDqF7Rs+T94dv99j5vgAAf7kg
Message-ID: <C79B248886DD134989C8FF6B096A91AB7EC6B8C78B@BGMAIL01.nvidia.com>
References: <1350976740-19284-1-git-send-email-pkunapuli@nvidia.com>
	 <1350976740-19284-3-git-send-email-pkunapuli@nvidia.com>
 <1350979047.20572.6.camel@tellur>
In-Reply-To: <1350979047.20572.6.camel@tellur>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9N8GuEO002054

>> Does this work with boards where we don't have any MMC supplies? Or are we just deferring the probe indefinitely there?
The probe will be deferred indefinitely.

>> For boards that power MMC unconditionally, are we supposed to add dummy regulators to make them work with this patchset?
Yes. We need to add dummy regulators for boards that power MMC unconditionally. I am not sure if there is any other solution other than using deferred probe that would guarantee regulators availability.

-----Original Message-----
From: Lucas Stach [mailto:dev@lynxeye.de] 
Sent: 23 October 2012 13:27
To: Pavan Kunapuli
Cc: swarren@wwwdotorg.org; linux@arm.linux.org.uk; cjb@laptop.org; linux-tegra@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; linux-mmc@vger.kernel.org
Subject: Re: [PATCH 2/2] mmc: sdhci: Defer probe if regulator_get fails

Am Dienstag, den 23.10.2012, 12:49 +0530 schrieb Pavan Kunapuli:
> vmmc and vqmmc regulators control the voltage to the host and device. 
> Defer the probe if either of them is not registered.
> 
Does this work with boards where we don't have any MMC supplies? Or are we just deferring the probe indefinitely there?

For boards that power MMC unconditionally, are we supposed to add dummy regulators to make them work with this patchset?

> Signed-off-by: Pavan Kunapuli <pkunapuli@nvidia.com>
> ---
>  drivers/mmc/host/sdhci.c |   25 ++++++++++++++++++++++---
>  1 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c index 
> 7922adb..925c403 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2844,11 +2844,17 @@ int sdhci_add_host(struct sdhci_host *host)
>  	    !(host->mmc->caps & MMC_CAP_NONREMOVABLE))
>  		mmc->caps |= MMC_CAP_NEEDS_POLL;
>  
> -	/* If vqmmc regulator and no 1.8V signalling, then there's no UHS */
> +	/*
> +	 * If vqmmc regulator and no 1.8V signalling, then there's no UHS.
> +	 * vqmmc regulator should be present. If it's not present,
> +	 * assume the regulator driver registration is not yet done and
> +	 * defer the probe.
> +	 */
>  	host->vqmmc = regulator_get(mmc_dev(mmc), "vqmmc");
>  	if (IS_ERR(host->vqmmc)) {
> -		pr_info("%s: no vqmmc regulator found\n", mmc_hostname(mmc));
> +		pr_err("%s: no vqmmc regulator found\n", mmc_hostname(mmc));
>  		host->vqmmc = NULL;
> +		return -EPROBE_DEFER;
>  	}
>  	else if (regulator_is_supported_voltage(host->vqmmc, 1800000, 1800000))
>  		regulator_enable(host->vqmmc);
> @@ -2903,10 +2909,17 @@ int sdhci_add_host(struct sdhci_host *host)
>  
>  	ocr_avail = 0;
>  
> +	/*
> +	 * vmmc regulator should be present. If it's not present,
> +	 * assume the regulator driver registration is not yet done
> +	 * and defer the probe.
> +	 */
>  	host->vmmc = regulator_get(mmc_dev(mmc), "vmmc");
>  	if (IS_ERR(host->vmmc)) {
> -		pr_info("%s: no vmmc regulator found\n", mmc_hostname(mmc));
> +		pr_err("%s: no vmmc regulator found\n", mmc_hostname(mmc));
>  		host->vmmc = NULL;
> +		ret = -EPROBE_DEFER;
> +		goto vmmc_err;
>  	} else
>  		regulator_enable(host->vmmc);
>  
> @@ -3121,7 +3134,13 @@ reset:
>  untasklet:
>  	tasklet_kill(&host->card_tasklet);
>  	tasklet_kill(&host->finish_tasklet);
> +vmmc_err:
> +	if (host->vqmmc) {
> +		if (regulator_is_enabled(host->vqmmc))
> +			regulator_disable(host->vqmmc);
>  
> +		regulator_put(host->vqmmc);
> +	}
>  	return ret;
>  }
>  


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
