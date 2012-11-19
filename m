Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab2KSGzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:55:17 -0500
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:56922 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462Ab2KSGzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:55:16 -0500
Message-ID: <50A9D816.7010208@marvell.com>
Date: Mon, 19 Nov 2012 14:56:22 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 4/7] mfd: max8925: support dt for power supply
References: <1352187764-9901-1-git-send-email-qingx@marvell.com> <20121119002447.GH29066@lizard.sbx05977.paloaca.wayport.net>
In-Reply-To: <20121119002447.GH29066@lizard.sbx05977.paloaca.wayport.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Nov 2012 06:55:07.0768 (UTC) FILETIME=[CF988780:01CDC622]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 08:24 AM, Anton Vorontsov wrote:
> On Tue, Nov 06, 2012 at 03:42:44PM +0800, Qing Xu wrote:
>> From: Qing Xu <qingx@marvell.com>
>>
>> Signed-off-by: Qing Xu <qingx@marvell.com>
>> ---
> W/ this patch I'm getting this warning:
>
>    CC      drivers/power/max8925_power.o
>    drivers/power/max8925_power.c: In function ‘max8925_power_probe’:
>    drivers/power/max8925_power.c:479:3: warning: statement with no effect
>    [-Wunused-value]
>
>>   drivers/power/max8925_power.c |   57 ++++++++++++++++++++++++++++++++++++----
>>   1 files changed, 51 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
>> index daa333b..dd2ac2d 100644
>> --- a/drivers/power/max8925_power.c
>> +++ b/drivers/power/max8925_power.c
>> @@ -426,14 +426,58 @@ static __devexit int max8925_deinit_charger(struct max8925_power_info *info)
>>   	return 0;
>>   }
>>   
>> +#ifdef CONFIG_OF
>> +static int max8925_power_dt_init(struct platform_device *pdev,
>> +			      struct max8925_power_pdata *pdata)
>> +{
>> +	struct device_node *nproot = pdev->dev.parent->of_node, *np;
>> +	int batt_detect, topoff_threshold, fast_charge,
>> +		no_temp_support, no_insert_detect;
> One variable declaration per line please.
>
>> +
>> +	if (!nproot)
>> +		return -ENODEV;
> Please add an empty line here.
>
>> +	np = of_find_node_by_name(nproot, "charger");
>> +	if (!np) {
>> +		dev_err(&pdev->dev, "failed to find charger node\n");
>> +		return -ENODEV;
>> +	}
> ditto.
>
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
> ditto
>
>> +	pr_err("batt_detect%d, topoff_threshold%d, fast_charge%d,no_temp_support%d, no_insert_detect%d\n",
>> +		batt_detect, topoff_threshold, fast_charge,
>> +		no_temp_support, no_insert_detect);
> pr_err, are you sure? :)
>
>> +	return 0;
>> +}
>> +#else
>> +#define max8925_power_dt_init(x, y)	(-1)
> You should make it static inline function to get rid of the warning above.
>
>> +#endif
>> +
>> +static char *power_supplicants[] = {
>> +	"max8925-battery",
>> +};
>> +
>>   static __devinit int max8925_power_probe(struct platform_device *pdev)
>>   {
>>   	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
>> -	struct max8925_power_pdata *pdata = NULL;
>> +	struct max8925_power_pdata *pdata = pdev->dev.platform_data;
>>   	struct max8925_power_info *info;
>>   	int ret;
>>   
>> -	pdata = pdev->dev.platform_data;
>> +	if (pdev->dev.parent->of_node && !pdata) {
>> +		pdata = devm_kzalloc(&pdev->dev,
>> +				     sizeof(struct max8925_power_pdata),
>> +				     GFP_KERNEL);
>>
> Please move this logic into max8925_power_dt_init().
> So it will look like
>
> 	if (!pdata)
> 		pdata = max8925_power_dt_init(pdev);
> 	if (!pdata) {
> 		dev_err(...);
> 		return ...;
> 	}
>
>> +		max8925_power_dt_init(pdev, pdata);
>> +	}
>>   	if (!pdata) {
>>   		dev_err(&pdev->dev, "platform data isn't assigned to "
>>   			"power supply\n");
>> @@ -453,8 +497,8 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
>>   	info->ac.properties = max8925_ac_props;
>>   	info->ac.num_properties = ARRAY_SIZE(max8925_ac_props);
>>   	info->ac.get_property = max8925_ac_get_prop;
>> -	info->ac.supplied_to = pdata->supplied_to;
>> -	info->ac.num_supplicants = pdata->num_supplicants;
>> +	info->ac.supplied_to = power_supplicants;
>> +	info->ac.num_supplicants = ARRAY_SIZE(power_supplicants);
>>   	ret = power_supply_register(&pdev->dev, &info->ac);
>>   	if (ret)
>>   		goto out;
>> @@ -465,8 +509,8 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
>>   	info->usb.properties = max8925_usb_props;
>>   	info->usb.num_properties = ARRAY_SIZE(max8925_usb_props);
>>   	info->usb.get_property = max8925_usb_get_prop;
>> -	info->usb.supplied_to = pdata->supplied_to;
>> -	info->usb.num_supplicants = pdata->num_supplicants;
>> +	info->usb.supplied_to = power_supplicants;
>> +	info->usb.num_supplicants = ARRAY_SIZE(power_supplicants);
>>   
>>   	ret = power_supply_register(&pdev->dev, &info->usb);
>>   	if (ret)
>> @@ -491,6 +535,7 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
>>   	info->no_insert_detect = pdata->no_insert_detect;
>>   
>>   	max8925_init_charger(chip, info);
>> +
> This change is unrelated.
>
>>   	return 0;
>>   out_battery:
>>   	power_supply_unregister(&info->battery);
>> -- 
>> 1.7.0.4
> Thanks,
> Anton.
Anton, thanks for your very careful review!
I updated in patch v2, please help to review it again.


Thanks,
Qing

