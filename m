Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab1LHDxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 22:53:14 -0500
Received: from void.printf.net ([89.145.121.20]:50156 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842Ab1LHDxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 22:53:12 -0500
From: Chris Ball <cjb@laptop.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: sdhci-pci: simplify error handling
References: <1322897285.3884.1.camel@phoenix> <4EDCAAFB.4060209@intel.com>
Date: Wed, 07 Dec 2011 22:53:24 -0500
In-Reply-To: <4EDCAAFB.4060209@intel.com> (Adrian Hunter's message of "Mon, 05
	Dec 2011 13:28:59 +0200")
Message-ID: <87aa73u3bf.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 05 2011, Adrian Hunter wrote:
> On 03/12/11 09:28, Axel Lin wrote:
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
>
>> ---
>>  drivers/mmc/host/sdhci-pci.c |   38 ++++++++++++++++++--------------------
>>  1 files changed, 18 insertions(+), 20 deletions(-)
>> 
>> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
>> index 6878a94..d2e77fb 100644
>> --- a/drivers/mmc/host/sdhci-pci.c
>> +++ b/drivers/mmc/host/sdhci-pci.c
>> @@ -1012,11 +1012,8 @@ static int sdhci_pci_suspend(struct device *dev)
>>  
>>  		ret = sdhci_suspend_host(slot->host);
>>  
>> -		if (ret) {
>> -			for (i--; i >= 0; i--)
>> -				sdhci_resume_host(chip->slots[i]->host);
>> -			return ret;
>> -		}
>> +		if (ret)
>> +			goto err_pci_suspend;
>>  
>>  		slot_pm_flags = slot->host->mmc->pm_flags;
>>  		if (slot_pm_flags & MMC_PM_WAKE_SDIO_IRQ)
>> @@ -1027,11 +1024,8 @@ static int sdhci_pci_suspend(struct device *dev)
>>  
>>  	if (chip->fixes && chip->fixes->suspend) {
>>  		ret = chip->fixes->suspend(chip);
>> -		if (ret) {
>> -			for (i = chip->num_slots - 1; i >= 0; i--)
>> -				sdhci_resume_host(chip->slots[i]->host);
>> -			return ret;
>> -		}
>> +		if (ret)
>> +			goto err_pci_suspend;
>>  	}
>>  
>>  	pci_save_state(pdev);
>> @@ -1048,6 +1042,11 @@ static int sdhci_pci_suspend(struct device *dev)
>>  	}
>>  
>>  	return 0;
>> +
>> +err_pci_suspend:
>> +	while (--i >= 0)
>> +		sdhci_resume_host(chip->slots[i]->host);
>> +	return ret;
>>  }
>>  
>>  static int sdhci_pci_resume(struct device *dev)
>> @@ -1113,23 +1112,22 @@ static int sdhci_pci_runtime_suspend(struct device *dev)
>>  
>>  		ret = sdhci_runtime_suspend_host(slot->host);
>>  
>> -		if (ret) {
>> -			for (i--; i >= 0; i--)
>> -				sdhci_runtime_resume_host(chip->slots[i]->host);
>> -			return ret;
>> -		}
>> +		if (ret)
>> +			goto err_pci_runtime_suspend;
>>  	}
>>  
>>  	if (chip->fixes && chip->fixes->suspend) {
>>  		ret = chip->fixes->suspend(chip);
>> -		if (ret) {
>> -			for (i = chip->num_slots - 1; i >= 0; i--)
>> -				sdhci_runtime_resume_host(chip->slots[i]->host);
>> -			return ret;
>> -		}
>> +		if (ret)
>> +			goto err_pci_runtime_suspend;
>>  	}
>>  
>>  	return 0;
>> +
>> +err_pci_runtime_suspend:
>> +	while (--i >= 0)
>> +		sdhci_runtime_resume_host(chip->slots[i]->host);
>> +	return ret;
>>  }
>>  
>>  static int sdhci_pci_runtime_resume(struct device *dev)

Thanks, pushed to mmc-next for 3.3 with Adrian's ACK.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
