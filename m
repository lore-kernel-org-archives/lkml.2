Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab1DFOFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:05:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49337 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755986Ab1DFOFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:05:20 -0400
Date: Wed, 6 Apr 2011 23:05:26 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv1 5/11] REGULATOR: Regulator module of DA9052 PMIC driver
Message-ID: <20110406140525.GB2810@opensource.wolfsonmicro.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B451F17@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B451F17@KCINPUNHJCMS01.kpit.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 06:19:15PM +0530, Ashish Jangam wrote:

> Linux Kernel Version: 2.6.37

There is no point in submitting against old kernel versions, new drivers
can only be included in current development kernls (current development
targets 2.6.40).  The 2.6.37 code is getting on for a year out of date
here.  There's some API updates required before the driver will compile
with current kernels.

> +struct da9052_regulator_info da9052_regulator_info[] = {
> +	/* Buck1 - 4*/
> +	DA9052_DCDC(0, 25, 6, 6),
> +
> +	DA9052_DCDC(1, 25, 6, 6),
> +
> +	DA9052_DCDC(2, 25, 6, 6),
> +
> +	DA9052_DCDC(3, 50, 5, 6),

You should be able to loose a lot of the blank lines in this table.

> +static inline int da9052_regulator_uvolts_to_regVal(struct regulator_dev *rdev,
> +						unsigned int val)

MixedCase identifiers aren't the Linux kernel style.

> +static int da9052_regulator_set_voltage(struct regulator_dev *rdev, int min_uV,
> +				 int max_uV)
> +{
> +	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
> +	struct regulation_constraints *constraints = rdev->constraints;
> +	int offset = rdev_get_id(rdev);
> +	int ret;
> +	int reg_val = 0;
> +
> +	/* Compare voltage range */
> +	if (min_uV > max_uV)
> +		return -EINVAL;
> +
> +	if (min_uV < constraints->min_uV || min_uV > constraints->max_uV)
> +		return -EINVAL;
> +	if (max_uV < constraints->min_uV || max_uV > constraints->max_uV)
> +		return -EINVAL;

The core will take care of all this for you.

> +	/* Set the GO LDO/BUCk bits so that the voltage changes */
> +	switch (offset) {
> +	case DA9052_LDO2:
> +		ret = da9052_reg_update(regulator->da9052,
> +				DA9052_SUPPLY_REG, 0,
> +				DA9052_SUPPLY_VLDO2GO);
> +		if (ret < 0)
> +			return -EIO;
> +	break;

This case statement looks like it should be looking up information in
the driver private data instead.

> +static struct regulator_ops da9052_regulator_ops = {
> +	.is_enabled		= da9052_regulator_is_enabled,
> +	.enable		= da9052_regulator_enable,
> +	.disable		= da9052_regulator_disable,
> +	.get_voltage	= da9052_regulator_get_voltage,
> +	.set_voltage	= da9052_regulator_set_voltage,
> +};

You should also implement list_voltage().

> +	for (i = 0; i < ARRAY_SIZE(da9052_regulator_info); i++) {
> +		init_data = &da9052_regulators_init[i];
> +		init_data->driver_data = da9052;
> +		pdev->dev.platform_data = init_data;
> +		regulator->regulators[i] = regulator_register(
> +					&da9052_regulator_info[i].reg_desc,
> +					&pdev->dev,
> +					pdev->dev.platform_data,
> +					regulator
> +					);
> +		if (IS_ERR(regulator->regulators[i])) {
> +			ret = PTR_ERR(regulator->regulators[i]);
> +			dev_err(da9052->dev, "Failed to register regulator[%d] \
> +					   %d \n", i+1, ret);
> +			goto err;
> +		}

It's easier and less error prone to just register all the regulators
then look the constraints up in a flat array.
