Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab2HDKes (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 06:34:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58210 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084Ab2HDKer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 06:34:47 -0400
Date: Sat, 4 Aug 2012 11:19:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regulator: add MAX8907 driver
Message-ID: <20120804101918.GD9248@opensource.wolfsonmicro.com>
References: <1343932033-911-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343932033-911-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Stay the curse.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 12:27:13PM -0600, Stephen Warren wrote:

> The MAX8907 is an I2C-based power-management IC containing voltage
> regulators, a reset controller, a real-time clock, and a touch-screen
> controller.

> * Reworked the regulator driver to be represented as a single device that
>   provides multiple regulators, rather than as a device per regulator.  It
>   seems like this is more common?

This is mostly a reflection of the poor reuse available with most
hardware.  If you've got a bunch of regulators which can usefully
be instantiated and work out where they are by just getting a
register range or two, and especially if you've got a bunch of PMICs
with different arrangements of these things, then it's useful to
split into multiple drivers.  If each regulator needs a bunch of custom
data then there's not much point.

> +static int max8907_regulator_list_voltage(struct regulator_dev *rdev,
> +					  unsigned index)
> +{
> +	struct max8907_regulator *pmic = rdev_get_drvdata(rdev);
> +	int id = rdev_get_id(rdev);
> +	const struct max8907_regulator_info *info = &pmic->info[id];
> +
> +	return info->min_uV + info->step_uV * index;
> +}

regulator_list_voltage_linear().

> +static int max8907_regulator_ldo_set_voltage(struct regulator_dev *rdev,
> +					     int min_uV, int max_uV,
> +					     unsigned *selector)

Should use regulator_set_voltage_sel_regmap() and
regulator_map_voltage_linear().

> +static int max8907_regulator_bbat_set_voltage(struct regulator_dev *rdev,
> +					      int min_uV, int max_uV,
> +					      unsigned *selector)

Similarly for this regulator, use a linear mapping.

> +static int max8907_regulator_fixed_get_voltage(struct regulator_dev *rdev)

This one too.

> +static int max8907_regulator_wled_set_current_limit(struct regulator_dev *rdev,
> +						    int min_uA, int max_uA)

I'm really not convinced it makes much sense to represent the backlight
driver current regulators as regulators, they only get used as part of
the backlight and are usually tightly coupled to their boosts.

> +static int max8907_regulator_ldo_enable(struct regulator_dev *rdev)
> +{
> +	struct max8907_regulator *pmic = rdev_get_drvdata(rdev);
> +	int id = rdev_get_id(rdev);
> +	const struct max8907_regulator_info *info = &pmic->info[id];
> +	unsigned int reg = MAX8907_MASK_LDO_EN | MAX8907_MASK_LDO_SEQ;
> +
> +	return regmap_update_bits(rdev->regmap, info->reg_base + MAX8907_CTL,
> +				  reg, reg);

regulator_enable_regmap() and friends (and similarly for a bunch of the
others).
