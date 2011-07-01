Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab1GAOWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:22:49 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:37940 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab1GAOWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:22:48 -0400
Message-ID: <4E0DD816.7070104@atmel.com>
Date: Fri, 01 Jul 2011 16:22:14 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: cjb@laptop.org, linux-mmc@vger.kernel.org,
        hans-christian.egtvedt@atmel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@avr32linux.org
Subject: Re: [PATCH V2] MMC: PM: add suspend/resume in atmel-mci
References: <201106292339.12402.rjw@sisk.pl> <1309441781-11012-1-git-send-email-nicolas.ferre@atmel.com> <20110630131342.GK11559@pengutronix.de>
In-Reply-To: <20110630131342.GK11559@pengutronix.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 30/06/2011 15:13, Uwe Kleine-König :
> Hello Nicolas,
> 
> On Thu, Jun 30, 2011 at 03:49:41PM +0200, Nicolas Ferre wrote:
>> Take care of slots while going to suspend state.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> ---
>> V2: move to pm_ops
>>
>>  drivers/mmc/host/atmel-mci.c |   47 ++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 47 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
>> index aa8039f..058f1842 100644
>> --- a/drivers/mmc/host/atmel-mci.c
>> +++ b/drivers/mmc/host/atmel-mci.c
>> @@ -1878,10 +1878,57 @@ static int __exit atmci_remove(struct platform_device *pdev)
>>  	return 0;
>>  }
>>  
>> +#ifdef CONFIG_PM
>> +static int atmci_suspend(struct device *dev)
>> +{
>> +	struct atmel_mci *host = dev_get_drvdata(dev);
>> +	struct atmel_mci_slot *slot;
>> +	int i, ret;
> slot and ret can have a more local scope.

ok.

>> +
>> +	 for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
>> +		slot = host->slot[i];
>> +		if (!slot)
>> +			continue;
>> +		ret = mmc_suspend_host(slot->mmc);
>> +		if (ret < 0) {
>> +			while (--i >= 0) {
>> +				slot = host->slot[i];
>> +				if (slot)
>> +					mmc_resume_host(host->slot[i]->mmc);
> hmm, mmc_resume_host could fail. But probably you cannot handle that in
> a sane way, do you?

Well, actually for the current implementation the only return code is... 0.
And here I try to have a king of best effort approach ;-)

>> +			}
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int atmci_resume(struct device *dev)
>> +{
>> +	struct atmel_mci *host = dev_get_drvdata(dev);
>> +	struct atmel_mci_slot *slot;
>> +	int i, ret;
>> +
>> +	for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
>> +		slot = host->slot[i];
>> +		if (!slot)
>> +			continue;
>> +		ret = mmc_resume_host(slot->mmc);
>> +		if (ret < 0)
>> +			return ret;
> Maybe you should try to resume host 5 even if resuming host 4 failed?

In fact all other drivers that are dealing with multiple slots are doing
the same... So I have difficulties to know the truth.
The question is: is it better to return an error to the "resume"
function so that we are called later again or do we have to do our best
to thaw everything out?

>> +	}
>> +
>> +	return 0;
>> +}
>> +#endif
>> +static SIMPLE_DEV_PM_OPS(atmci_pm, atmci_suspend, atmci_resume);
>> +
>> +
> For my taste a single empty line is enough.

Ok.

>>  static struct platform_driver atmci_driver = {
>>  	.remove		= __exit_p(atmci_remove),
>>  	.driver		= {
>>  		.name		= "atmel_mci",
>> +		.pm		= &atmci_pm,
>>  	},
>>  };
> 

Thanks, best regards,
-- 
Nicolas Ferre

