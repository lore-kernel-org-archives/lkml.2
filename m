Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab2JWNWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:22:16 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19747 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab2JWNWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:22:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 23 Oct 2012 06:10:05 -0700
From: Philip Rakity <prakity@nvidia.com>
To: Pavan Kunapuli <pkunapuli@nvidia.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Date: Tue, 23 Oct 2012 15:21:58 +0200
Subject: Re: [PATCH 2/2] mmc: sdhci: Defer probe if regulator_get fails
Thread-Topic: [PATCH 2/2] mmc: sdhci: Defer probe if regulator_get fails
Thread-Index: Ac2xIV+9hU4xejnCTaCP36bCKSYrgQ==
Message-ID: <4F1DF342-A2C4-434A-B878-A11374089E6E@nvidia.com>
References: <1350976740-19284-1-git-send-email-pkunapuli@nvidia.com>
 <1350976740-19284-3-git-send-email-pkunapuli@nvidia.com>
In-Reply-To: <1350976740-19284-3-git-send-email-pkunapuli@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 23 Oct 2012, at 09:19, Pavan Kunapuli <pkunapuli@nvidia.com> wrote:

> vmmc and vqmmc regulators control the voltage to
> the host and device. Defer the probe if either of
> them is not registered.
> 
> Signed-off-by: Pavan Kunapuli <pkunapuli@nvidia.com>
> ---
> drivers/mmc/host/sdhci.c |   25 ++++++++++++++++++++++---
> 1 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 7922adb..925c403 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2844,11 +2844,17 @@ int sdhci_add_host(struct sdhci_host *host)
> 	    !(host->mmc->caps & MMC_CAP_NONREMOVABLE))
> 		mmc->caps |= MMC_CAP_NEEDS_POLL;
> 
> -	/* If vqmmc regulator and no 1.8V signalling, then there's no UHS */
> +	/*
> +	 * If vqmmc regulator and no 1.8V signalling, then there's no UHS.
> +	 * vqmmc regulator should be present. If it's not present,
> +	 * assume the regulator driver registration is not yet done and
> +	 * defer the probe.
> +	 */
> 	host->vqmmc = regulator_get(mmc_dev(mmc), "vqmmc");
> 	if (IS_ERR(host->vqmmc)) {
> -		pr_info("%s: no vqmmc regulator found\n", mmc_hostname(mmc));
> +		pr_err("%s: no vqmmc regulator found\n", mmc_hostname(mmc));
> 		host->vqmmc = NULL;
> +		return -EPROBE_DEFER;

Some systems exist where vmmc regulator exists and vqmmc regulator does not.  The vmmc regular is fixed at 3.3v.  
Deferring the probe will cause issues.

> 	}
> 	else if (regulator_is_supported_voltage(host->vqmmc, 1800000, 1800000))
> 		regulator_enable(host->vqmmc);
> @@ -2903,10 +2909,17 @@ int sdhci_add_host(struct sdhci_host *host)
> 
> 	ocr_avail = 0;
> 
> +	/*
> +	 * vmmc regulator should be present. If it's not present,
> +	 * assume the regulator driver registration is not yet done
> +	 * and defer the probe.
> +	 */
> 	host->vmmc = regulator_get(mmc_dev(mmc), "vmmc");
> 	if (IS_ERR(host->vmmc)) {
> -		pr_info("%s: no vmmc regulator found\n", mmc_hostname(mmc));
> +		pr_err("%s: no vmmc regulator found\n", mmc_hostname(mmc));
> 		host->vmmc = NULL;
> +		ret = -EPROBE_DEFER;
> +		goto vmmc_err;
> 	} else
> 		regulator_enable(host->vmmc);
> 
> @@ -3121,7 +3134,13 @@ reset:
> untasklet:
> 	tasklet_kill(&host->card_tasklet);
> 	tasklet_kill(&host->finish_tasklet);
> +vmmc_err:
> +	if (host->vqmmc) {
> +		if (regulator_is_enabled(host->vqmmc))
> +			regulator_disable(host->vqmmc);
> 
> +		regulator_put(host->vqmmc);
> +	}
> 	return ret;
> }
> 
> -- 
> 1.7.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

