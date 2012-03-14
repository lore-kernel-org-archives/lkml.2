Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab2CNINd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:13:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:60778 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758815Ab2CNIN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:13:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="128789283"
Message-ID: <4F60532E.4070103@intel.com>
Date: Wed, 14 Mar 2012 10:13:34 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: Chris Ball <cjb@laptop.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/3] mmc: sdhci: check interrupt flags in ISR again
References: <1331659002-13743-1-git-send-email-alexander.stein@systec-electronic.com> <1331659002-13743-2-git-send-email-alexander.stein@systec-electronic.com> <4F604B16.606@intel.com> <1994979.AaWWmIIAYQ@ws-stein>
In-Reply-To: <1994979.AaWWmIIAYQ@ws-stein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/12 09:53, Alexander Stein wrote:
> Hello,
> 
> Am Mittwoch, 14. März 2012, 09:39:02 schrieb Adrian Hunter:
>> On 13/03/12 19:16, Alexander Stein wrote:
>>> When using MSI it is possible that a new MSI is sent while an earlier
>>> MSI is currently handled. In this case SDHCI_INT_STATUS only contains
>>> SDHCI_INT_RESPONSE and the ISR would not be called again. But at the end
>>> of the ISR SDHCI_INT_DATA_END is now also pending which would be
>>> ignored.
>>>
>>> Fix this by rereading the interrupt flags in the ISR until no interrupt
>>> we care is pending.
>>>
>>> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
>> [...]
>>> @@ -2336,6 +2338,14 @@ static irqreturn_t sdhci_irq(int irq, void
>>> *dev_id)> 
>>>  		sdhci_writel(host, SDHCI_INT_BUS_POWER, SDHCI_INT_STATUS);
>>>  	
>>>  	}
>>>
>>> +	intmask_unhandled = intmask;
>>> +
>>> +	intmask = sdhci_readl(host, SDHCI_INT_STATUS);
>>> +
>>> +	/* Do interrupt handling again if we got new flags */
>>> +	if (intmask & ~intmask_unhandled)
>>> +		goto again;
>>> +
>>>
>>>  	intmask &= ~SDHCI_INT_BUS_POWER;
>>>  	
>>>  	if (intmask & SDHCI_INT_CARD_INT)
>>
>> Why not just replace mmiowb() i.e.
>>
>>
>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>> index 8d66706..da8a101 100644
>> --- a/drivers/mmc/host/sdhci.c
>> +++ b/drivers/mmc/host/sdhci.c
>> @@ -2353,7 +2353,9 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
>>
>>         result = IRQ_HANDLED;
>>
>> -       mmiowb();
>> +       intmask = sdhci_readl(host, SDHCI_INT_STATUS);
>> +       if (intmask)
>> +               goto again;
>>  out:
>>         spin_unlock(&host->lock);
>>
> 
> Well, I chose this way to only printk the error once. With your suggestion it 
> might be printed in each loop, dunno how often/fast these IRQ stats are set 
> again after clearing. This would end in an endless loop if error flags are set 
> again fast enough, but see below.
> But in general I like this approach.
> 
>> But maybe it would be safer limiting the number of loops i.e.
>>
>>
>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>> index 8d66706..d88247d 100644
>> --- a/drivers/mmc/host/sdhci.c
>> +++ b/drivers/mmc/host/sdhci.c
>> @@ -2268,7 +2268,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
>>         irqreturn_t result;
>>         struct sdhci_host *host = dev_id;
>>         u32 intmask;
>> -       int cardint = 0;
>> +       int cardint = 0, max_loops = 16;
>>
>>         spin_lock(&host->lock);
>>
>> @@ -2353,7 +2353,9 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
>>
>>         result = IRQ_HANDLED;
>>
>> -       mmiowb();
>> +       intmask = sdhci_readl(host, SDHCI_INT_STATUS);
>> +       if (intmask && --max_loops)
>> +               goto again;
>>  out:
>>         spin_unlock(&host->lock);
> 
> The actual problem I saw was a CMD6 command with an R1b response where the IRQ 
> for the 'not busy' event was sent during ISR for the response. So I think 
> normally this should only occur once.
> Regarding error flags I masked the unhandled flags out in order to print an 
> error only once, even if they might be set again in the next loop. With a 
> simple check on intmask they might occur up to 16 times in the kernel log.
> IMHO it makes no sense to repeatedly print errors about interrupt flags we 
> don't handle.
> 
> Suggestions to get a more clean way?

I don't know about clean, but there is this:


diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 8d66706..e0909da 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2267,8 +2267,8 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 {
        irqreturn_t result;
        struct sdhci_host *host = dev_id;
-       u32 intmask;
-       int cardint = 0;
+       u32 intmask, unexpected = 0;
+       int cardint = 0, max_loops = 16;

        spin_lock(&host->lock);

@@ -2344,19 +2344,24 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
        intmask &= ~SDHCI_INT_CARD_INT;

        if (intmask) {
-               pr_err("%s: Unexpected interrupt 0x%08x.\n",
-                       mmc_hostname(host->mmc), intmask);
-               sdhci_dumpregs(host);
-
+               unexpected |= intmask;
                sdhci_writel(host, intmask, SDHCI_INT_STATUS);
        }

        result = IRQ_HANDLED;

-       mmiowb();
+       intmask = sdhci_readl(host, SDHCI_INT_STATUS);
+       if (intmask && --max_loops)
+               goto again;
 out:
        spin_unlock(&host->lock);

+       if (unexpected) {
+               pr_err("%s: Unexpected interrupt 0x%08x.\n",
+                       mmc_hostname(host->mmc), unexpected);
+               sdhci_dumpregs(host);
+       }
+
        /*
         * We have to delay this as it calls back into the driver.
         */
