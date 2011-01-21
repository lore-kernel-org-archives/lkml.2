Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab1AUTQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 14:16:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56686 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754855Ab1AUTQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 14:16:07 -0500
Date: Fri, 21 Jan 2011 19:16:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH 2/2] MAX8997/8966 PMIC Regulator Driver Initial Release
Message-ID: <20110121191604.GK22414@opensource.wolfsonmicro.com>
References: <1294988018-25100-1-git-send-email-myungjoo.ham@samsung.com>
 <1294988018-25100-3-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294988018-25100-3-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 03:53:38PM +0900, MyungJoo Ham wrote:
> This patch supports PMIC/Regulator part of MAX8997/MAX8966 MFD.
> In this initial release, selecting voltages or current-limit
> and switching on/off the regulators are supported.

Mostly good, a few stylistic things and this is out of date for the
current regulator API.

> +static int max8997_get_voltage(struct regulator_dev *rdev)
> +{

> +	ret = max8997_list_voltage(rdev, val);
> +	if (ret == -EINVAL) {
> +		int ldo = max8997_get_ldo(rdev);

It'd probably be easier to just define separate get_voltage() and
list_voltage() functions for these regulators.

> +static int max8997_set_voltage_ldo(struct regulator_dev *rdev,
> +               int min_uV, int max_uV)

This needs updating for the current API in -next (and 2.6.38).

> +	if ((ldo > MAX8997_BUCK7 || ldo < MAX8997_LDO1) &&
> +			ldo != MAX8997_CHARGER_CV &&
> +			ldo != MAX8997_CHARGER &&
> +			ldo != MAX8997_CHARGER_TOPOFF)
> +		return -EINVAL;
> +	if (ldo == MAX8997_BUCK6)
> +		return -EINVAL;

A switch statement for the valid regulators might be clearer.

> +static int max8997_set_voltage_buck(struct regulator_dev *rdev,
> +		int min_uV, int max_uV)

API update needed here too.

> +static int max8997_set_voltage_safeout(struct regulator_dev *rdev,
> +		int min_uV, int max_uV)
> +{

Here also.  Given that you've got a separate set_voltage() the comment
about a separate get_voltage() above seems even stronger.

> +static inline unsigned int max8997_buck_voltage(int uV)
> +{
> +	int step;
> +
> +	if (uV <= 650000)
> +		return 0x0;
> +	if (uV >= 2225000)
> +		return 0x3f;
> +
> +	step = uV - 650000;
> +	step /= 25000;
> +
> +	return step + 1;
> +}

Shouldn't this code be shared with set_voltage()?  Or...

> +		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i),
> +				max8997_buck_voltage(pdata->buck1_voltage[i]),
> +				0x3f);
> +		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i),
> +				max8997_buck_voltage(pdata->buck2_voltage[i]),
> +				0x3f);
> +		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i),
> +				max8997_buck_voltage(pdata->buck5_voltage[i]),
> +				0x3f);

...just call your set_voltage() operation directly for these?

> +		if (gpio_is_valid(pdata->buck125_gpios[0]) &&
> +				gpio_is_valid(pdata->buck125_gpios[1]) &&
> +				gpio_is_valid(pdata->buck125_gpios[2])) {

Strange indentation here.
