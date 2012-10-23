Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979Ab2JWKLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:11:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28263 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab2JWKL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:11:29 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-59-50866d4fe3c2
Message-id: <50866D29.1040709@samsung.com>
Date: Tue, 23 Oct 2012 19:10:49 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827
 Thunderbird/15.0
MIME-version: 1.0
To: Pavan Kunapuli <pkunapuli@nvidia.com>
Cc: swarren@wwwdotorg.org, linux@arm.linux.org.uk, cjb@laptop.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH 2/2] mmc: sdhci: Defer probe if regulator_get fails
References: <1350976709-19248-1-git-send-email-pkunapuli@nvidia.com>
 <1350976709-19248-3-git-send-email-pkunapuli@nvidia.com>
In-reply-to: <1350976709-19248-3-git-send-email-pkunapuli@nvidia.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jAV3/3LYAgx2/jCwu75rDZnHkfz+j
	A5PH501yAYxRXDYpqTmZZalF+nYJXBlT589gKzgmXPHn3G22Bsaj/F2MnBwSAiYSM9+9YoGw
	xSQu3FvP1sXIxSEksIhR4t26qSwQzktGic4LTWBVvAJaEj8WNILZLAKqEodn/GYHsdkEdCS2
	fzvOBGKLCoRILJn7lR2iXlDix+R7YPUiApoSb2/9BathFqiRmD3lI5gtLOAusWjhPjYQW0ig
	XmLynCtgNqeAq8Tz3RsZIep1JPa3TmODsOUlNq95yzyBUWAWkhWzkJTNQlK2gJF5FaNoakFy
	QXFSeq6hXnFibnFpXrpecn7uJkZwMD6T2sG4ssHiEKMAB6MSD6/FkdYAIdbEsuLK3EOMEhzM
	SiK8pvZtAUK8KYmVValF+fFFpTmpxYcYpTlYlMR5mz1SAoQE0hNLUrNTUwtSi2CyTBycUg2M
	B57xa3AGme2QP6kwYd+l5E9lhU99Tq35W3vz/dOLdZUrDCRZTj6O3Pe5fUWh4WLRq0vmnT29
	QlpTo3q/c26A+Lb9/y7PXXHqIE9xs3XJ/ZNKj5ueXjl4+rL7xsYOSdYjbaV/ku+lCb/L+nNY
	6zE7+4M1j3Nz7i5nkboa6JX7qTb1QerFh6/Ue5RYijMSDbWYi4oTAXMiappCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't understand why defer the probe?
I think that some board can't control vqmmc or vmmc.

Best Regards,
Jaehoon Chung
On 10/23/2012 04:18 PM, Pavan Kunapuli wrote:
> vmmc and vqmmc regulators control the voltage to
> the host and device. Defer the probe if either of
> them is not registered.
> 
> Signed-off-by: Pavan Kunapuli <pkunapuli@nvidia.com>
> ---
>  drivers/mmc/host/sdhci.c |   25 ++++++++++++++++++++++---
>  1 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 7922adb..925c403 100644
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

