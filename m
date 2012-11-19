Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab2KSH1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 02:27:10 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:36183 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582Ab2KSH1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 02:27:09 -0500
Message-ID: <50A9DF8E.7030708@marvell.com>
Date: Mon, 19 Nov 2012 15:28:14 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 4/7] mfd: max8925: support dt for power supply
References: <1353307944-9805-1-git-send-email-qingx@marvell.com> <20121119070605.GA7294@lizard>
In-Reply-To: <20121119070605.GA7294@lizard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2012 07:26:59.0440 (UTC) FILETIME=[430A8700:01CDC627]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 03:06 PM, Anton Vorontsov wrote:
> On Mon, Nov 19, 2012 at 02:52:24PM +0800, Qing Xu wrote:
>> From: Qing Xu <qingx@marvell.com>
>>
>> Signed-off-by: Qing Xu <qingx@marvell.com>
>> ---
>>   drivers/power/max8925_power.c |   61 +++++++++++++++++++++++++++++++++++++---
>>   1 files changed, 56 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
>> index daa333b..aca3f68 100644
>> --- a/drivers/power/max8925_power.c
>> +++ b/drivers/power/max8925_power.c
>> @@ -426,6 +426,57 @@ static __devexit int max8925_deinit_charger(struct max8925_power_info *info)
>>   	return 0;
>>   }
>>   
>> +#ifdef CONFIG_OF
>> +static struct max8925_power_pdata*
> Need a whitespace before *.
>
>> +max8925_power_dt_init(	struct platform_device *pdev)
> Unneeded tab.
>
>> +{
>> +	struct device_node *nproot = pdev->dev.parent->of_node, *np;
> Hmmm. No, this is cryptic. One variable declaration per line please.
>
>> +	int batt_detect;
>> +	int topoff_threshold;
>> +	int fast_charge;
>> +	int no_temp_support;
>> +	int no_insert_detect;
>> +	struct max8925_power_pdata *pdata;
>> +
>> +	if (!nproot)
>> +		return pdev->dev.platform_data;
>> +
>> +	np = of_find_node_by_name(nproot, "charger");
>> +	if (!np) {
>> +		dev_err(&pdev->dev, "failed to find charger node\n");
>> +		return NULL;
>> +	}
>> +
>> +	pdata = devm_kzalloc(&pdev->dev,
>> +			sizeof(struct max8925_power_pdata),
>> +			GFP_KERNEL);
>> +
>> +	of_property_read_u32(np, "topoff-threshold", &topoff_threshold);
>> +	of_property_read_u32(np, "batt-detect", &batt_detect);
>> +	of_property_read_u32(np, "fast-charge", &fast_charge);
>> +	of_property_read_u32(np, "no-insert-detect", &no_insert_detect);
>> +	of_property_read_u32(np, "no-temp-support", &no_temp_support);
>> +
>> +	pdata->batt_detect = batt_detect;
>> +	pdata->fast_charge = fast_charge;
>> +	pdata->topoff_threshold = topoff_threshold;
>> +	pdata->no_insert_detect = no_insert_detect;
>> +	pdata->no_temp_support = no_temp_support;
>> +
>> +	return pdata;
>> +}
>> +#else
>> +static struct max8925_power_pdata*
>> +max8925_power_dt_init(	struct platform_device *pdev)
> Unneeded tab.
>
>> +{
>> +	return pdev->dev.platform_data;
>> +}
>> +#endif
>> +
>> +static char *power_supplicants[] = {
> The rest of the driver uses max8925_ prefix. Also, should it be const char
> *?
>
>> +	"max8925-battery",
>> +};
>> +
>>   static __devinit int max8925_power_probe(struct platform_device *pdev)
>>   {
>>   	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
>> @@ -433,7 +484,7 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
>>   	struct max8925_power_info *info;
>>   	int ret;
>>   
>> -	pdata = pdev->dev.platform_data;
>> +	pdata = max8925_power_dt_init(pdev);
>>   	if (!pdata) {
>>   		dev_err(&pdev->dev, "platform data isn't assigned to "
>>   			"power supply\n");
>> @@ -453,8 +504,8 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
>>   	info->ac.properties = max8925_ac_props;
>>   	info->ac.num_properties = ARRAY_SIZE(max8925_ac_props);
>>   	info->ac.get_property = max8925_ac_get_prop;
>> -	info->ac.supplied_to = pdata->supplied_to;
>> -	info->ac.num_supplicants = pdata->num_supplicants;
>> +	info->ac.supplied_to = power_supplicants;
> So you no longer able to change supplied_to via platform data. This is a
> backwards-incompatible change.
>
> Commit message should at least explain why this is safe to do (no users in
> the kernel?).
oh, I take test_power.c as example. I will remove this modification.
>> +	info->ac.num_supplicants = ARRAY_SIZE(power_supplicants);
>>   	ret = power_supply_register(&pdev->dev, &info->ac);
>>   	if (ret)
>>   		goto out;
>> @@ -465,8 +516,8 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
>>   	info->usb.properties = max8925_usb_props;
>>   	info->usb.num_properties = ARRAY_SIZE(max8925_usb_props);
>>   	info->usb.get_property = max8925_usb_get_prop;
>> -	info->usb.supplied_to = pdata->supplied_to;
>> -	info->usb.num_supplicants = pdata->num_supplicants;
>> +	info->usb.supplied_to = power_supplicants;
> Ditto.
>
>> +	info->usb.num_supplicants = ARRAY_SIZE(power_supplicants);
>>   
>>   	ret = power_supply_register(&pdev->dev, &info->usb);
>>   	if (ret)
>> -- 
>> 1.7.0.4
> Thanks,
> Anton.

