Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab2I1S0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:26:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51347 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672Ab2I1S0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:26:52 -0400
Message-ID: <5065EBEA.2020707@linaro.org>
Date: Fri, 28 Sep 2012 12:26:50 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 27/57] power: sysfs interface update
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org> <1348589574-25655-28-git-send-email-mathieu.poirier@linaro.org> <20120927072049.GK8836@lizard>
In-Reply-To: <20120927072049.GK8836@lizard>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-09-27 01:20 AM, Anton Vorontsov wrote:
> On Tue, Sep 25, 2012 at 10:12:24AM -0600, mathieu.poirier@linaro.org wrote:
>> From: Michel JAOUEN <michel.jaouen@stericsson.com>
>>
>> Add new sysfs interface to get current charge status
>>
>> Signed-off-by: Michel JAOUEN <michel.jaouen@stericsson.com>
>> Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>> Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
>> Reviewed-by: Olivier CLERGEAUD <olivier.clergeaud@stericsson.com>
>> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
>> ---
>>  drivers/power/ab8500_charger.c  |    3 +++
>>  drivers/power/abx500_chargalg.c |   24 +++++++++++++++++++++++-
>>  2 files changed, 26 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
>> index 4129599..0a781a0 100644
>> --- a/drivers/power/ab8500_charger.c
>> +++ b/drivers/power/ab8500_charger.c
>> @@ -2759,6 +2759,9 @@ static int ab8500_charger_usb_notifier_call(struct notifier_block *nb,
>>  	enum ab8500_usb_state bm_usb_state;
>>  	unsigned mA = *((unsigned *)power);
>>  
>> +	if (di == NULL)
>> +		return NOTIFY_DONE;
>> +
> 
> I'd write !di.

Not sure I agree with you here.  If di is NULL there is nothing to work
with and as such, exit.

> 
> [...]
>> +static ssize_t abx500_chargalg_sysfs_show(struct kobject *kobj,
>> +	struct attribute *attr, char *buf)
>> +{
>> +	struct abx500_chargalg *di = container_of(kobj,
>> +		struct abx500_chargalg, chargalg_kobject);
>> +
>> +	if ((di->susp_status.ac_suspended == true) &&
>> +		(di->susp_status.usb_suspended == true))
>> +		return sprintf(buf, "0\n");
>> +	else
>> +		return sprintf(buf, "1\n");
> 
> just
> 
> return sprintf(buf, "%d\n", di->susp_status.ac_suspended &&
> 			    di->susp_status.usb_suspended);

Much cleaner yes.

> 
>> +}
>> +
>>  /* Exposure to the sysfs interface */
>>  
>>  /**
>> @@ -1749,7 +1770,7 @@ static ssize_t abx500_chargalg_sysfs_charger(struct kobject *kobj,
>>  static struct attribute abx500_chargalg_en_charger = \
>>  {
>>  	.name = "chargalg",
>> -	.mode = S_IWUGO,
>> +	.mode = S_IRUGO | S_IWUSR,
>>  };
>>  
>>  static struct attribute *abx500_chargalg_chg[] = {
>> @@ -1758,6 +1779,7 @@ static struct attribute *abx500_chargalg_chg[] = {
>>  };
>>  
>>  static const struct sysfs_ops abx500_chargalg_sysfs_ops = {
>> +	.show = abx500_chargalg_sysfs_show,
>>  	.store = abx500_chargalg_sysfs_charger,
>>  };
>>  
>> -- 
>> 1.7.5.4

