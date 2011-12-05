Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1LEL3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:29:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:21296 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912Ab1LEL3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:29:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="83502600"
Message-ID: <4EDCAAFB.4060209@intel.com>
Date: Mon, 05 Dec 2011 13:28:59 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Takashi Iwai <tiwai@suse.de>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: sdhci-pci: simplify error handling
References: <1322897285.3884.1.camel@phoenix>
In-Reply-To: <1322897285.3884.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/11 09:28, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/mmc/host/sdhci-pci.c |   38 ++++++++++++++++++--------------------
>  1 files changed, 18 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index 6878a94..d2e77fb 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -1012,11 +1012,8 @@ static int sdhci_pci_suspend(struct device *dev)
>  
>  		ret = sdhci_suspend_host(slot->host);
>  
> -		if (ret) {
> -			for (i--; i >= 0; i--)
> -				sdhci_resume_host(chip->slots[i]->host);
> -			return ret;
> -		}
> +		if (ret)
> +			goto err_pci_suspend;
>  
>  		slot_pm_flags = slot->host->mmc->pm_flags;
>  		if (slot_pm_flags & MMC_PM_WAKE_SDIO_IRQ)
> @@ -1027,11 +1024,8 @@ static int sdhci_pci_suspend(struct device *dev)
>  
>  	if (chip->fixes && chip->fixes->suspend) {
>  		ret = chip->fixes->suspend(chip);
> -		if (ret) {
> -			for (i = chip->num_slots - 1; i >= 0; i--)
> -				sdhci_resume_host(chip->slots[i]->host);
> -			return ret;
> -		}
> +		if (ret)
> +			goto err_pci_suspend;
>  	}
>  
>  	pci_save_state(pdev);
> @@ -1048,6 +1042,11 @@ static int sdhci_pci_suspend(struct device *dev)
>  	}
>  
>  	return 0;
> +
> +err_pci_suspend:
> +	while (--i >= 0)
> +		sdhci_resume_host(chip->slots[i]->host);
> +	return ret;
>  }
>  
>  static int sdhci_pci_resume(struct device *dev)
> @@ -1113,23 +1112,22 @@ static int sdhci_pci_runtime_suspend(struct device *dev)
>  
>  		ret = sdhci_runtime_suspend_host(slot->host);
>  
> -		if (ret) {
> -			for (i--; i >= 0; i--)
> -				sdhci_runtime_resume_host(chip->slots[i]->host);
> -			return ret;
> -		}
> +		if (ret)
> +			goto err_pci_runtime_suspend;
>  	}
>  
>  	if (chip->fixes && chip->fixes->suspend) {
>  		ret = chip->fixes->suspend(chip);
> -		if (ret) {
> -			for (i = chip->num_slots - 1; i >= 0; i--)
> -				sdhci_runtime_resume_host(chip->slots[i]->host);
> -			return ret;
> -		}
> +		if (ret)
> +			goto err_pci_runtime_suspend;
>  	}
>  
>  	return 0;
> +
> +err_pci_runtime_suspend:
> +	while (--i >= 0)
> +		sdhci_runtime_resume_host(chip->slots[i]->host);
> +	return ret;
>  }
>  
>  static int sdhci_pci_runtime_resume(struct device *dev)

