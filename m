Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab2EaGgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:36:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10497 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2EaGgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:36:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7faf6d000001f49-80-4fc711626d61
Message-id: <4FC71161.9010002@samsung.com>
Date: Thu, 31 May 2012 15:36:17 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v5] regulator: MAX77686: Add Maxim 77686 regulator driver
References: <1338258051-3155-1-git-send-email-jonghwa3.lee@samsung.com>
 <20120530172652.GS9947@opensource.wolfsonmicro.com>
In-reply-to: <20120530172652.GS9947@opensource.wolfsonmicro.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jQd0kweP+BtdXcVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MyZfesxRsFKjoXH+IvYFxIm8XIyeHhICJxONZl1khbDGJC/fW
	s3UxcnEICUxnlHh0cBIjSIJXQFDix+R7LF2MHBzMAvISRy5lg4SZBdQlJs1bxAxR38ck8en7
	F6h6LYmLba+ZQWwWAVWJM2daWEBsNgE5ibdN3xhB5ogKREj86ucAMUWAbvh9vxJkDLPAO0aJ
	3bcXgLUKC/hKPOlvYgKxhQRqJXYeXMwMUs8p4CAxcXvpBEaBWUiOm4Vw3Cwkxy1gZF7FKJpa
	kFxQnJSea6RXnJhbXJqXrpecn7uJERx6z6R3MK5qsDjEKMDBqMTDa8F93F+INbGsuDL3EKME
	B7OSCK85D1CINyWxsiq1KD++qDQntfgQozQHi5I475MlO/yFBNITS1KzU1MLUotgskwcnFIN
	jPpR37qvMLXkuVm+y/CT3jjp7iu5i6aNTg9UVSRWr9+pkGDdvCq3bEpWxw/+hZ52mnq/Lt/5
	F/ud6e1zbZUfFqU6RTb7fvEwcN6fNbNCKCFJXltLNal9w09zxqB7l+osLs399+jzFhdLR62c
	vsNv55yO/BdhKivhc+TJs/Nq6UqVm86LPXFTVmIpzkg01GIuKk4EAH0K+9g5AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark,
On 2012년 05월 31일 02:26, Mark Brown wrote:

> On Tue, May 29, 2012 at 11:20:51AM +0900, Jonghwa Lee wrote:
>> Add driver for support max77686 regulator.
>> MAX77686 provides LDOs[1~26] and BUCKs[1~9]. It support to set or get the
>> volatege of regulator on max77686 chip with using regmap.
>>
>> v5
>> - Remove unnecessary initializing and variable.
>>
> 
> Don't put stuff like this in the changelog, it's useless noise in git.
> Include it after the cut as documented in SubmittingPatches.
> 


Okay, I'll do that,

>> +#ifdef CONFIG_COMMON_CLK
>> +	struct clk clk32khz_ap;
>> +	struct clk clk32khz_cp;
>> +	struct clk clk32khz_pmic;
>> +#endif
> 
> This should be a clock driver in drivers/clock.
> 


Isn't it drivers/clk ? Could you explain more about this?


>> +static int max77686_set_voltage_time_sel(struct regulator_dev *rdev,
>> +			unsigned int old_selector, unsigned int new_selector)
>> +{
>> +	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
>> +	int rid = rdev_get_id(rdev);
>> +
>> +	switch (rid) {
>> +	case MAX77686_BUCK2 ... MAX77686_BUCK4:
>> +		return (DIV_ROUND_UP(rdev->desc->uV_step
>> +			* abs(new_selector - old_selector),
>> +			max77686->ramp_delay * 1000));
>> +	}
>> +	/* Unconditionally 100 mV/us */
>> +	return (DIV_ROUND_UP(rdev->desc->uV_step
>> +		 * abs(new_selector - old_selector), 100000));
>> +}
> 
> Just do separate functions.  The above is pretty illegible.
> 


Okay I'll separate it into two functions. One for DVS BUCKs and another
for remains.

>> +	max77686->ramp_delay = MAX77686_RAMP_RATE; /* Set 0x3 for RAMP */
>> +	regmap_update_bits(max77686->iodev->regmap,
>> +					 MAX77686_REG_BUCK2CTRL1, 0xC0, 0xC0);
>> +	regmap_update_bits(max77686->iodev->regmap,
>> +					 MAX77686_REG_BUCK3CTRL1, 0xC0, 0xC0);
>> +	regmap_update_bits(max77686->iodev->regmap,
>> +					 MAX77686_REG_BUCK4CTRL1, 0xC0, 0xC0);
> 
> This still appears to not be referencing the ramp rate that's being set?


Okay, I'll remove hard coding, and will use ramp rate for setting.
