Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2EVEgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 00:36:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18323 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2EVEgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 00:36:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7faf6d000001f49-0a-4fbb17d7a9d9
Message-id: <4FBB17D7.8080107@samsung.com>
Date: Tue, 22 May 2012 13:36:39 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Samuel Oritz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Gridwodd <lrg@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>
Subject: Re: [PATCH v4 2/3] regulator: MAX77686: Add Maxim 77686 regulator
 driver
References: <1337593907-6615-1-git-send-email-jonghwa3.lee@samsung.com>
 <1337593907-6615-3-git-send-email-jonghwa3.lee@samsung.com>
 <alpine.DEB.2.00.1205211404350.15733@chino.kir.corp.google.com>
In-reply-to: <alpine.DEB.2.00.1205211404350.15733@chino.kir.corp.google.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jAd0b4rv9DRo0LS7vmsPmwOjxeZNc
	AGMUl01Kak5mWWqRvl0CV8a0RRuZC27wVZzaNY+tgfE9dxcjJ4eEgInE42N7WCBsMYkL99az
	dTFycQgJLGKUmP7yNBNIgldAUOLH5HtARRwczALyEkcuZYOEmQXUJSbNW8QMUd/HJLH/ygE2
	iHotiRU/brOC2CwCqhLzXt4Bi7MJyEm8bfrGCDJHVCBC4lc/B0hYREBDom3Gf7C9zAIvmST+
	Xp8AtldYIFjiRtdGqIOOM0rcP/6CESTBKeAjcfLDLZYJjAKzkNw3C+G+WUjuW8DIvIpRNLUg
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjOPyeSe9gXNVgcYhRgINRiYd3J99ufyHWxLLiytxDjBIc
	zEoivJvadvkL8aYkVlalFuXHF5XmpBYfYpTmYFES532yZIe/kEB6YklqdmpqQWoRTJaJg1Oq
	gTGlXW/i4duyclcvn3h86KLvtJkHFly8yXmmbeaGp7ernBfmLxR1eCNQyD13susJE7eZ37s5
	VtRU5DvWxyYs/7JjmdNCt5l1djkT7KT2KzT87fK+tCXwJd9vltAz7tPDo/c6Z1gaKJhUlF+1
	mfTjp0Crj9PB92xOKt419tOFtE/mFHtIK1jvs1diKc5INNRiLipOBACaV65XOwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 05월 22일 06:06, David Rientjes wrote:

> On Mon, 21 May 2012, Jonghwa Lee wrote:
>> +static __devinit int max77686_pmic_probe(struct platform_device *pdev)
>> +{
>> +	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
>> +	struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
>> +	struct regulator_dev **rdev;
>> +	struct max77686_data *max77686;
>> +	struct regulator_init_data **init_data;
>> +	int i, size;
>> +	int ret = 0;
>> +	struct regulator_config config;
>> +	unsigned int data = 0;
>> +
>> +	dev_dbg(&pdev->dev, "%s\n", __func__);
>> +
>> +	max77686 = devm_kzalloc(&pdev->dev, sizeof(struct max77686_data),
>> +				GFP_KERNEL);
>> +	if (!max77686)
>> +		return -ENOMEM;
>> +
>> +	size = sizeof(struct regulator_dev *) * MAX77686_REGULATORS;
>> +	max77686->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
>> +	if (!max77686->rdev)
>> +		return -ENOMEM;
> 
> Does this leak max77686?
>


It uses devm_kzalloc which automatically frees memory allocation when
the driver is detached. So we don't need to worry about it.

 
>> +
>> +	rdev = max77686->rdev;
>> +	max77686->dev = &pdev->dev;
>> +	max77686->iodev = iodev;
>> +	if (pdata)
>> +		max77686->num_regulators = pdata->num_regulators;
>> +	platform_set_drvdata(pdev, max77686);
>> +	init_data = devm_kzalloc(&pdev->dev,
>> +				sizeof(struct regulator_init_data *)
>> +					 * MAX77686_REGULATORS, GFP_KERNEL);
> 
> No error handling, which will cause a NULL pointer later when you use this 
> array.
> 


Okay, now i applied it.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


Thanks and Regard
