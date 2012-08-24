Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2HXB2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 21:28:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40016 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2HXB2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:28:31 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fc66d0000043b7-17-5036d8bdf3b8
Message-id: <5036D8BA.7090904@samsung.com>
Date: Fri, 24 Aug 2012 10:28:26 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mike Turquette <mturquette@ti.com>,
        Xiaoguang Chen <chenxg@marvell.com>
Subject: Re: [PATCH 2/2] devfreq: exynos4: Support initialization of freq_table
 and max_state of devfreq's profile.
References: <1345099767-13467-1-git-send-email-jonghwa3.lee@samsung.com>
 <1345099767-13467-3-git-send-email-jonghwa3.lee@samsung.com>
 <201208240022.04846.rjw@sisk.pl>
In-reply-to: <201208240022.04846.rjw@sisk.pl>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t9jAd29N8wCDBqWq1hc3jWHzeJz7xFG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKuPvnAWHBcuOLj2++sDYxf+LsYOTkkBEwkDp1+ywhh
	i0lcuLeerYuRi0NIYBGjxIZlC5lBErwCghI/Jt9j6WLk4GAWkJc4cikbJMwsoC4xad4iZoj6
	l4wS87avhqrXkujp2QlmswioSjw6N4sJxGYTkJN42/SNEWSOqECExK9+DpCwCFDJlif/2UHm
	MAu0Mkm8ar8JtktYoFTiwrkgiPmrgO75dpsVJM4poCuxanX2BEaBWUium4Vw3Swk1y1gZF7F
	KJpakFxQnJSea6hXnJhbXJqXrpecn7uJERyGz6R2MK5ssDjEKMDBqMTDu6PFLECINbGsuDL3
	EKMEB7OSCO/X+UAh3pTEyqrUovz4otKc1OJDjNIcLErivPx9hgFCAumJJanZqakFqUUwWSYO
	TqkGRv+73btLri977lricP32vN9vHiTxVd42XvqRRW7nbbPdt389NDr1cvIngW//Bdk2Hnoi
	tkRXfa6ShWCD8YdzJh6q97TYow/2a9QY21c77hSxCuLL4ZH+rp568Em0kFj2B7ti6bZJbzyS
	psckXyjNCPDUFr9Vn8T0PGnRx2fTvp0weudjbGDnp8RSnJFoqMVcVJwIAIxCblA/AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 08월 24일 07:22, Rafael J. Wysocki wrote:
> On Thursday, August 16, 2012, Jonghwa Lee wrote:
>> This patch initializes freq_table and max_state of devfreq's profile.
>> They will be used for creating transition table.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Does that depend on [1/2]?
>
> Rafael

Not exactly, but it shows that required procedure for using function
included in patch[1/2].


Thanks.

>
>> ---
>>  drivers/devfreq/exynos4_bus.c |   30 +++++++++++++++++++++++++++++-
>>  1 files changed, 29 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
>> index 88ddc77..9c08855 100644
>> --- a/drivers/devfreq/exynos4_bus.c
>> +++ b/drivers/devfreq/exynos4_bus.c
>> @@ -985,7 +985,8 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
>>  	struct busfreq_data *data;
>>  	struct opp *opp;
>>  	struct device *dev = &pdev->dev;
>> -	int err = 0;
>> +	int err = 0, i;
>> +	unsigned int *freq_table;
>>  
>>  	data = kzalloc(sizeof(struct busfreq_data), GFP_KERNEL);
>>  	if (data == NULL) {
>> @@ -1042,6 +1043,33 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
>>  
>>  	platform_set_drvdata(pdev, data);
>>  
>> +	switch (data->type) {
>> +	case TYPE_BUSF_EXYNOS4210:
>> +		freq_table = devm_kzalloc(&pdev->dev, sizeof(unsigned int) * EX4210_LV_NUM,
>> +					GFP_KERNEL);
>> +
>> +		for (i = 0; i < EX4210_LV_NUM; i++)
>> +			freq_table[i] = exynos4210_busclk_table[i].clk;
>> +
>> +		exynos4_devfreq_profile.max_state = EX4210_LV_NUM;
>> +		break;
>> +	case TYPE_BUSF_EXYNOS4x12:
>> +		freq_table = devm_kzalloc(&pdev->dev, sizeof(unsigned int) * EX4x12_LV_NUM,
>> +					GFP_KERNEL);
>> +
>> +		for (i = 0; i < EX4x12_LV_NUM; i++)
>> +			freq_table[i] = exynos4x12_mifclk_table[i].clk;
>> +
>> +		exynos4_devfreq_profile.max_state = EX4x12_LV_NUM;
>> +		break;
>> +	default:
>> +		dev_err(dev, "Cannot determine the device id %d\n", data->type);
>> +		err = -EINVAL;
>> +		goto err_opp_add;
>> +	}
>> +
>> +	exynos4_devfreq_profile.freq_table = freq_table;
>> +
>>  	busfreq_mon_reset(data);
>>  
>>  	data->devfreq = devfreq_add_device(dev, &exynos4_devfreq_profile,
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

