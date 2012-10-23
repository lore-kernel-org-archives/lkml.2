Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab2JWKRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:17:46 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7933 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2JWKRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:17:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 23 Oct 2012 03:05:40 -0700
From: Pavan Kunapuli <pkunapuli@nvidia.com>
To: Jaehoon Chung <jh80.chung@samsung.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Pavan Kunapuli <pkunapuli@nvidia.com>
Date: Tue, 23 Oct 2012 15:47:37 +0530
Subject: RE: [PATCH 2/2] mmc: sdhci: Defer probe if regulator_get fails
Thread-Topic: [PATCH 2/2] mmc: sdhci: Defer probe if regulator_get fails
Thread-Index: Ac2xBsq9Lim+BJGLSoq9bXhyyK7I4gAAHSlA
Message-ID: <C79B248886DD134989C8FF6B096A91AB7EC6B8C7C9@BGMAIL01.nvidia.com>
References: <1350976709-19248-1-git-send-email-pkunapuli@nvidia.com>
 <1350976709-19248-3-git-send-email-pkunapuli@nvidia.com>
 <50866D29.1040709@samsung.com>
In-Reply-To: <50866D29.1040709@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For platforms where the board can control vmmc or vqmmc, if the regulator supplies registration is not done before sdhci probe, deferring sdhci probe would ensure that the regulators are available the next time around. For platforms where the board can't control vmmc or vqmmc, we can have a dummy regulator to make sure probe will never get deferred.

-----Original Message-----
From: Jaehoon Chung [mailto:jh80.chung@samsung.com] 
Sent: 23 October 2012 15:41
To: Pavan Kunapuli
Cc: swarren@wwwdotorg.org; linux@arm.linux.org.uk; cjb@laptop.org; linux-kernel@vger.kernel.org; linux-mmc@vger.kernel.org
Subject: Re: [PATCH 2/2] mmc: sdhci: Defer probe if regulator_get fails

I didn't understand why defer the probe?
I think that some board can't control vqmmc or vmmc.

Best Regards,
Jaehoon Chung
On 10/23/2012 04:18 PM, Pavan Kunapuli wrote:
> vmmc and vqmmc regulators control the voltage to the host and device. 
> Defer the probe if either of them is not registered.
> 
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
> 

