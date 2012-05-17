Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016Ab2EQLnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 07:43:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24147 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2EQLnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 07:43:12 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7bb6ae0000006fb-ba-4fb4e44d3281
Message-id: <4FB4E44D.60502@samsung.com>
Date: Thu, 17 May 2012 20:43:09 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Oritz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, Chiwoong Byun <woong.byun@samsung.com>
Subject: Re: [PATCH v2 2/3] regulator: MAX77686: Add Maxim 77686 regulator
 driver
References: <1336719045-9765-1-git-send-email-jonghwa3.lee@samsung.com>
 <1336719045-9765-3-git-send-email-jonghwa3.lee@samsung.com>
 <20120512104338.GH1781@opensource.wolfsonmicro.com>
In-reply-to: <20120512104338.GH1781@opensource.wolfsonmicro.com>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 05월 12일 19:43, Mark Brown wrote:
Hi,Mark,
I'm sorry my reply is too late.

> On Fri, May 11, 2012 at 03:50:44PM +0900, Jonghwa Lee wrote:
>
>> +/* LDO3 ~ 5, 9 ~ 14, 16 ~ 26 (uV) */
>> +static const struct voltage_map_desc ldo_voltage_map_desc = {
>> +	.min = 800000,	.max = 3950000,	.step = 50000,	.n_bits = 6,
>> +};
>
> As I indicated I'd do in reply to Yadwinder Singh Brar's posting of a
> version of this driver the other day this is now factored out into the
> core - you should be able to set this all up using regulator_desc and
> regulator_map_voltage_linear() which will appear in -next on Monday (I
> appreciate it's not something you should have been aware of!).  This
> should also allow you to use regulator_{set,get}_voltage_regmap.
>

I'll updated it as soon as those patches are merged to mainline.

>> +	[MAX77686_EN32KHZ_AP] = NULL,
>> +	[MAX77686_EN32KHZ_CP] = NULL,
>> +	[MAX77686_P32KH] = NULL,
>
> These should be being moved over to the generic clock API now it's in
> mainline.
>
I couldn't check this yet, i'll retouch that.
>> +/*
>> + * TODO
>> + * Reaction to the LP/Standby for each regulator should be defined by
>> + * each consumer, not by the regulator device driver if it depends
>> + * on which device is attached to which regulator. Here we are
>> + * creating possible PM-wise regression with board changes.Also,
>> + * we can do the same effect without creating issues with board
>> + * changes by carefully defining .state_mem at bsp and suspend ops
>> + * callbacks.
>> + */
>
> The various set_suspend() calls are supposed to be for this, though in
> practice they're rarely used in systems so we probably need a bunch of
> work there.  We certainly don't have any aribtration between consumers
> yet.
>

When system goes into suspended mode, it doesn't need any detail to
enable or disable a regulator in MAX77686. So i think it'll be fine to
use enable/diable function whichever situation we are in. To prevent
confusion i just removed function pointers for suspending.

>> +static int max77686_reg_is_enabled(struct regulator_dev *rdev)
>> +{
>> +	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
>> +	int ret, reg, mask, pattern;
>> +	u8 val;
>> +
>> +	ret = max77686_get_enable_register(rdev, &reg, &mask, &pattern);
>> +	if (ret == -EINVAL)
>> +		return 1; /* "not controllable" */
>
> Just have separate ops structures for these regulators.
>

I think that procedure is useless, so i removed it.

>> +static int max77686_get_voltage_register(struct regulator_dev *rdev,
>> +		int *_reg, int *_shift, int *_mask)
>
>> +static int max77686_get_voltage(struct regulator_dev *rdev)
>> +{
>
> These look like they should be done using regulator_get_voltage_regmap()
> so you only need data in the driver.
>

This also will be updated ,,

>> +static inline int max77686_get_voltage_proper_val(
>> +		const struct voltage_map_desc *desc,
>> +		int min_vol, int max_vol)
>
> Pretty big function for inline, and the core will do this for you anyway
> if you use the new features I was mentioning further up.
>

I removed it, it isn't needed any more.

>> +	switch (rid) {
>> +	case MAX77686_BUCK2 ... MAX77686_BUCK4:
>> +		if (org < i)
>> +			udelay(DIV_ROUND_UP(desc->step * (i - org),
>> +						max77686->ramp_delay * 1000));
>> +		break;
>> +	case MAX77686_BUCK1:
>> +	case MAX77686_BUCK5 ... MAX77686_BUCK9:
>> +		/* Unconditionally 100 mV/us */
>> +		if (org < i)
>> +			udelay(DIV_ROUND_UP(desc->step * (i - org), 100000));
>> +		break;
>> +	default:
>> +		break;
>> +	}
>
> Implement set_voltage_time_sel() instead and let the core do the delays.
>

I applied it. And i also converted set/get_voltage() to
set/get_voltage_sel().

>> +static int max77686_reg_do_nothing(struct regulator_dev *rdev)
>> +{
>> +	return 0;
>> +}
>
> Remove this, you should never have empty functions like this.
>

Removed.

>> +	if (!pdata) {
>> +		dev_err(pdev->dev.parent, "No platform init data supplied.\n");
>> +		return -ENODEV;
>> +	}
>
> You should just carry on unless there's some strong device-specific
> reason for not doing so.
>

Modified driver to keep probing whether pdata exists or not.

>> +	max77686 = kzalloc(sizeof(struct max77686_data), GFP_KERNEL);
>> +	if (!max77686)
>> +		return -ENOMEM;
>
> devm_kzalloc().
>

Modified.

>> +	size = sizeof(struct regulator_dev *) * pdata->num_regulators;
>> +	max77686->rdev = kzalloc(size, GFP_KERNEL);
>> +	if (!max77686->rdev) {
>> +		kfree(max77686);
>> +		return -ENOMEM;
>> +	}
>
> You should just unconditionally register all regulators the chip has,
> this allows users to inspect the state of the regulators even if they're
> not being controlled by software.
>

Modified. Now driver registers all regulator unconditionally.

>> +	max77686->opmode_data = pdata->opmode_data;
>
> Shouldn't this be being handled by regulator_set_mode()?  If not what
> does it do?
>

I consider this for a while, but i decided just let it be. Because
opmode_data is only used in max77686_get_enable_register() to get
proper opcode value. To use regulator_set_mode, it needs too much
modification. Is there some strict purpose to use that, i'll change it.

>> +	printk(PMIC_DEBUG "%s: DEVICE ID=0x%x\n", __func__, data);
>
> This needs cleaning up - it should at least be a dev_ printk.
>
>> +static int __init max77686_pmic_init(void)
>> +{
>> +	printk(PMIC_DEBUG "%s\n", __func__);
>
> This can be removed too.

Those all were cleaned.


Best regards,
LEE
