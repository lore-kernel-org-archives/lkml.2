Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1GDMoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 08:44:07 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:44234 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab1GDMoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 08:44:06 -0400
Message-ID: <4E11B57B.4040000@atmel.com>
Date: Mon, 04 Jul 2011 14:43:39 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: balbi@ti.com
CC: cjb@laptop.org, linux-mmc@vger.kernel.org,
        hans-christian.egtvedt@atmel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@avr32linux.org,
        u.kleine-koenig@pengutronix.de
Subject: Re: [PATCH V3] MMC: PM: add suspend/resume in atmel-mci
References: <1309530754.4373.3.camel@hcegtvedt.norway.atmel.com> <1309779505-25509-1-git-send-email-nicolas.ferre@atmel.com> <20110704110651.GC2820@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110704110651.GC2820@legolas.emea.dhcp.ti.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 04/07/2011 13:06, Felipe Balbi :
> Hi,
> 
> On Mon, Jul 04, 2011 at 01:38:25PM +0200, Nicolas Ferre wrote:
>> Take care of slots while going to suspend state.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>> V3: take care of each slot SUSPENDED state
>>     (adding a status bit in the slot "flags")
>> V2: move to pm_ops
>>
>>  drivers/mmc/host/atmel-mci.c |   60 ++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 60 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
>> index aa8039f..ed63bcd 100644
>> --- a/drivers/mmc/host/atmel-mci.c
>> +++ b/drivers/mmc/host/atmel-mci.c
>> @@ -203,6 +203,7 @@ struct atmel_mci_slot {
>>  #define ATMCI_CARD_PRESENT	0
>>  #define ATMCI_CARD_NEED_INIT	1
>>  #define ATMCI_SHUTDOWN		2
>> +#define ATMCI_SUSPENDED		3
>>  
>>  	int			detect_pin;
>>  	int			wp_pin;
>> @@ -1878,10 +1879,69 @@ static int __exit atmci_remove(struct platform_device *pdev)
>>  	return 0;
>>  }
>>  
>> +#ifdef CONFIG_PM
>> +static int atmci_suspend(struct device *dev)
>> +{
>> +	struct atmel_mci *host = dev_get_drvdata(dev);
>> +	int i;
>> +
>> +	 for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
>> +		struct atmel_mci_slot *slot = host->slot[i];
>> +		int ret;
>> +
>> +		if (!slot)
>> +			continue;
>> +		ret = mmc_suspend_host(slot->mmc);
>> +		if (ret < 0) {
>> +			while (--i >= 0) {
>> +				slot = host->slot[i];
>> +				if (slot
>> +				&& test_bit(ATMCI_SUSPENDED, &slot->flags)) {
>> +					mmc_resume_host(host->slot[i]->mmc);
>> +					clear_bit(ATMCI_SUSPENDED, &slot->flags);
>> +				}
>> +			}
>> +			return ret;
>> +		} else {
>> +			set_bit(ATMCI_SUSPENDED, &slot->flags);
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int atmci_resume(struct device *dev)
>> +{
>> +	struct atmel_mci *host = dev_get_drvdata(dev);
>> +	int i;
>> +	int ret = 0;
>> +
>> +	for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
>> +		struct atmel_mci_slot *slot = host->slot[i];
>> +		int err;
>> +
>> +		slot = host->slot[i];
>> +		if (!slot)
>> +			continue;
>> +		if (!test_bit(ATMCI_SUSPENDED, &slot->flags))
>> +			continue;
>> +		err = mmc_resume_host(slot->mmc);
>> +		if (err < 0)
>> +			ret = err;
>> +		else
>> +			clear_bit(ATMCI_SUSPENDED, &slot->flags);
>> +	}
>> +
>> +	return ret;
>> +}
>> +#endif
>> +static SIMPLE_DEV_PM_OPS(atmci_pm, atmci_suspend, atmci_resume);
> 
> if you disable CONFIG_PM this won't work. atmci_resume and atmci_suspend
> will be undefined.
> 
>>  static struct platform_driver atmci_driver = {
>>  	.remove		= __exit_p(atmci_remove),
>>  	.driver		= {
>>  		.name		= "atmel_mci",
>> +		.pm		= &atmci_pm,
> 
> this pointer will also be invalid.
> 
> what most people do is:
> 
> #ifdef CONFIG_PM
> 
> suspend()
> resume()
> 
> static SIMPLE_DEV_PM_OPS(atmci_pm, suspend, resume);
> 
> #define DEV_PM_OPS	(&atmci_pm)
> #else
> #define DEV_PM_OPS	NULL
> #endif

Yes, sure that makes sense.

Thanks, I will cook a V4.

Best regards,
-- 
Nicolas Ferre

