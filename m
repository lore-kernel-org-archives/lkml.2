Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab2EVMDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:03:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55614 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab2EVMDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:03:07 -0400
Message-ID: <4FBB8076.7010709@linaro.org>
Date: Tue, 22 May 2012 13:03:02 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: Re: [PATCH 1/3] power/ab8500_charger: harden platform data check
References: <1334304949-18301-1-git-send-email-linus.walleij@stericsson.com> <CACRpkdaM=OecD=M_J9X9shYKQkWO03mhb2BFxCWOeocr8_m=DQ@mail.gmail.com> <4F9C1CF5.3050706@linaro.org> <20120505120835.GA26976@lizard> <4FBB79D5.7030108@linaro.org> <20120522115638.GA19506@lizard>
In-Reply-To: <20120522115638.GA19506@lizard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

> On Tue, May 22, 2012 at 12:34:45PM +0100, Lee Jones wrote:
>> Hi Anton,
>>
>> I see that this didn't make it into any of the v3.4-rc:s, hence v3.4
>> was released broken. Do you know when they're likely to make it into
>> Mainline?
>
> You probably should have told me that you needed these patches in
> v3.4, because neither Linus' nor yours patch description did not
> tell that these were urgent fixes (and not some stuff you'd just
> like to have for the future).

Ah, I see. I'm sorry this wasn't communicated clearly enough.

> But now I see that ab8500 mfd core driver in v3.4 seem to register
> the charger and stuff w/o platform data already, so we'd need
> at least 'Harden platform data check' patches back-ported into
> -stable.

Right.

> Now once Linus Torvalds pull battery tree, I'll ask Greg KH to
> cherry-pick the patches into -stable.

Thanks Anton.

Are these queued up for the v3.5 merge window also?

Kind regards,
Lee

>>> - - - -
>>> commit 2aac3de19b72608f474c90034185c2be4908728f
>>> Author: Lee Jones<lee.jones@linaro.org>
>>> Date:   Sat May 5 04:38:19 2012 -0700
>>>
>>>      ab8500: Clean up probe routines
>>>
>>>      These patches clean up some ugliness and brings the variable
>>>      initialisation formatting more into line with other drivers.
>>>
>>>      Signed-off-by: Lee Jones<lee.jones@linaro.org>
>>>      Signed-off-by: Anton Vorontsov<anton.vorontsov@linaro.org>
>>>
>>> diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
>>> index e266f03..bba3cca 100644
>>> --- a/drivers/power/ab8500_btemp.c
>>> +++ b/drivers/power/ab8500_btemp.c
>>> @@ -964,10 +964,15 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
>>>   {
>>>   	int irq, i, ret = 0;
>>>   	u8 val;
>>> -	struct abx500_bm_plat_data *plat_data;
>>> +	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
>>> +	struct ab8500_btemp *di;
>>> +
>>> +	if (!plat_data) {
>>> +		dev_err(&pdev->dev, "No platform data\n");
>>> +		return -EINVAL;
>>> +	}
>>>
>>> -	struct ab8500_btemp *di =
>>> -		kzalloc(sizeof(struct ab8500_btemp), GFP_KERNEL);
>>> +	di = kzalloc(sizeof(*di), GFP_KERNEL);
>>>   	if (!di)
>>>   		return -ENOMEM;
>>>
>>> @@ -977,13 +982,12 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
>>>   	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
>>>
>>>   	/* get btemp specific platform data */
>>> -	plat_data = pdev->dev.platform_data;
>>> -	if (!plat_data || !plat_data->btemp) {
>>> +	di->pdata = plat_data->btemp;
>>> +	if (!di->pdata) {
>>>   		dev_err(di->dev, "no btemp platform data supplied\n");
>>>   		ret = -EINVAL;
>>>   		goto free_device_info;
>>>   	}
>>> -	di->pdata = plat_data->btemp;
>>>
>>>   	/* get battery specific platform data */
>>>   	di->bat = plat_data->battery;
>>> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
>>> index 79dc584..d2303d0 100644
>>> --- a/drivers/power/ab8500_charger.c
>>> +++ b/drivers/power/ab8500_charger.c
>>> @@ -2534,10 +2534,15 @@ static int __devexit ab8500_charger_remove(struct platform_device *pdev)
>>>   static int __devinit ab8500_charger_probe(struct platform_device *pdev)
>>>   {
>>>   	int irq, i, charger_status, ret = 0;
>>> -	struct abx500_bm_plat_data *plat_data;
>>> +	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
>>> +	struct ab8500_charger *di;
>>>
>>> -	struct ab8500_charger *di =
>>> -		kzalloc(sizeof(struct ab8500_charger), GFP_KERNEL);
>>> +	if (!plat_data) {
>>> +		dev_err(&pdev->dev, "No platform data\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	di = kzalloc(sizeof(*di), GFP_KERNEL);
>>>   	if (!di)
>>>   		return -ENOMEM;
>>>
>>> @@ -2550,13 +2555,12 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
>>>   	spin_lock_init(&di->usb_state.usb_lock);
>>>
>>>   	/* get charger specific platform data */
>>> -	plat_data = pdev->dev.platform_data;
>>> -	if (!plat_data || !plat_data->charger) {
>>> +	di->pdata = plat_data->charger;
>>> +	if (!di->pdata) {
>>>   		dev_err(di->dev, "no charger platform data supplied\n");
>>>   		ret = -EINVAL;
>>>   		goto free_device_info;
>>>   	}
>>> -	di->pdata = plat_data->charger;
>>>
>>>   	/* get battery specific platform data */
>>>   	di->bat = plat_data->battery;
>>> diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
>>> index 0ebea39..bf02225 100644
>>> --- a/drivers/power/ab8500_fg.c
>>> +++ b/drivers/power/ab8500_fg.c
>>> @@ -2446,10 +2446,15 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
>>>   {
>>>   	int i, irq;
>>>   	int ret = 0;
>>> -	struct abx500_bm_plat_data *plat_data;
>>> +	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
>>> +	struct ab8500_fg *di;
>>> +
>>> +	if (!plat_data) {
>>> +		dev_err(&pdev->dev, "No platform data\n");
>>> +		return -EINVAL;
>>> +	}
>>>
>>> -	struct ab8500_fg *di =
>>> -		kzalloc(sizeof(struct ab8500_fg), GFP_KERNEL);
>>> +	di = kzalloc(sizeof(*di), GFP_KERNEL);
>>>   	if (!di)
>>>   		return -ENOMEM;
>>>
>>> @@ -2461,13 +2466,12 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
>>>   	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
>>>
>>>   	/* get fg specific platform data */
>>> -	plat_data = pdev->dev.platform_data;
>>> -	if (!plat_data || !plat_data->fg) {
>>> +	di->pdata = plat_data->fg;
>>> +	if (!di->pdata) {
>>>   		dev_err(di->dev, "no fg platform data supplied\n");
>>>   		ret = -EINVAL;
>>>   		goto free_device_info;
>>>   	}
>>> -	di->pdata = plat_data->fg;
>>>
>>>   	/* get battery specific platform data */
>>>   	di->bat = plat_data->battery;
>>
>>
>> --
>> Lee Jones
>> Linaro ST-Ericsson Landing Team Lead
>> M: +44 77 88 633 515
>> Linaro.org │ Open source software for ARM SoCs
>> Follow Linaro: Facebook | Twitter | Blog
>


-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
