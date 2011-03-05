Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1CEMCm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 07:02:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56922 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752633Ab1CEMCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 07:02:40 -0500
Date: Sat, 5 Mar 2011 12:03:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 2/2] MAX8997/8966 PMIC Regulator Driver Initial
 Release
Message-ID: <20110305120302.GC30187@opensource.wolfsonmicro.com>
References: <1299221427-4726-1-git-send-email-myungjoo.ham@samsung.com>
 <1299221427-4726-3-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299221427-4726-3-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 03:50:27PM +0900, MyungJoo Ham wrote:

Overall this looks very good.

> +	if (ldo == MAX8997_ESAFEOUT1 || ldo == MAX8997_ESAFEOUT2) {
> +		switch (selector) {
> +		case 0:
> +			return 4850000;

...

> +	if (ldo == MAX8997_CHARGER_CV) {

For these special cases it'd be cleaner to just have separate functions
rather than conditional code in the implementation used by the majority.

> +	switch (ldo) {
> +	case MAX8997_LDO1 ... MAX8997_LDO21:
> +		*reg = MAX8997_REG_LDO1CTRL + (ldo - MAX8997_LDO1);
> +		*mask = 0xC0;
> +		*pattern = 0xC0;
> +		break;
> +	case MAX8997_BUCK1:

The ldo variable is slightly misnamed, then? :)

[get_voltage]
> +
> +	ret = max8997_list_voltage(rdev, val);
> +
> +	return ret;

If you implement get_voltage_sel() you can just return the selector
directly.

> +/*
> + * Assess the damage on the voltage setting of BUCK1,2,5 by the change.
> + */
> +static int max8997_assess_side_effect(struct regulator_dev *rdev,
> +		u8 new_val, int *best)

Some more detail in the comment would be very helpful here - what sort
of damage and what sort of change?

> +	if (gpio_dvs_mode) {
> +		desc = reg_voltage_map[ldo];
> +		new_val = max8997_get_voltage_proper_val(desc, min_vol,
> +							max_vol);
> +		if (new_val < 0)
> +			return new_val;
> +
> +		damage = max8997_assess_side_effect(rdev, new_val, &new_idx);
> +
> +		if (damage < 0)
> +			return damage;
> +
> +		max8997->buck125_gpioindex = new_idx;
> +		max8997_set_gpio(max8997);
> +		*selector = new_val;
> +
> +		return 0;
> +	}
> +
> +	return max8997_set_voltage_ldo(rdev, min_uV, max_uV, selector);

Putting this in the else clause would be a little clearer.

> +/* For SAFEOUT1 and SAFEOUT2 */
> +static int max8997_set_voltage_safeout(struct regulator_dev *rdev,
> +		int min_uV, int max_uV, unsigned *selector)
> +{
> +	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
> +	struct i2c_client *i2c = max8997->iodev->i2c;
> +	int ldo = max8997_get_ldo(rdev);
> +	int reg, shift = 0, mask, ret;
> +	int i = 0;
> +	u8 val;
> +
> +	if (ldo != MAX8997_ESAFEOUT1 && ldo != MAX8997_ESAFEOUT2)
> +		return -EINVAL;
> +
> +	for (i = 0; i < ARRAY_SIZE(safeoutvolt); i++) {
> +		if (min_uV <= safeoutvolt[i] &&
> +				max_uV >= safeoutvolt[i])
> +			break;

If you implement this as a set_voltage_sel() operation it'd simplify
your code by doing this sort of lookup for you, including bounds
checking and so on.

> +static int max8997_reg_enable_suspend(struct regulator_dev *rdev)
> +{
> +	return 0;
> +}
> +

This looks odd, especially since you have a disable operation?

> +	if (ldo == MAX8997_LDO1 ||
> +			ldo == MAX8997_LDO10 ||
> +			ldo == MAX8997_LDO21) {
> +		pr_info("Conditional Power-Off for %s\n", rdev->desc->name);
> +		return max8997_update_reg(i2c, reg, 0x40, mask);
> +	}
> +
> +	pr_info("Full Power-Off for %s (%xh -> %xh)\n", rdev->desc->name,
> +			max8997->saved_states[ldo] & mask, (~pattern) & mask);

dev_info().

> +static int max8997_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = container_of(dev,
> +			struct platform_device, dev);
> +	struct max8997_data *max8997 = platform_get_drvdata(pdev);
> +	struct i2c_client *i2c = max8997->iodev->i2c;
> +	struct regulator_dev *rdev;
> +	int ret, reg, mask, pattern;
> +	int i;
> +	u8 val;
> +
> +	/* Show Error/Warning Messages for Inconsistency */
> +	for (i = 0; i < MAX8997_REG_MAX; i++) {
> +		if (max8997->saved_rdev[i]) {

We should put this into the regulator core rather than doing it in
drivers - it's not really driver specific and other regulators that
can't preserve state over suspend and resume will need it.
