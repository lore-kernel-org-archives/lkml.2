Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab2JIHLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 03:11:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51911 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab2JIHLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 03:11:22 -0400
Date: Tue, 9 Oct 2012 16:11:11 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>
Subject: Re: [Patch v2 2/7] Regulator: DA9055 Regulator driver
Message-ID: <20121009071108.GV8237@opensource.wolfsonmicro.com>
References: <1349703039.17349.12.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349703039.17349.12.camel@dhruva>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 07:00:39PM +0530, Ashish Jangam wrote:

Mostly OK, but there's a few issues including yet more reimplementation
of framework features.

> +static int da9055_list_voltage(struct regulator_dev *rdev,
> +				unsigned int selector)
> +{
> +	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
> +	struct da9055_regulator_info *info = regulator->info;
> +	int volt_uV;
> +
> +	volt_uV = (selector * info->step_uV) + info->min_uV;
> +
> +	if (volt_uV > info->max_uV)
> +		return -EINVAL;
> +
> +	return volt_uV;
> +}

This is regulator_list_voltage_linear()

> +static int da9055_map_voltage(struct regulator_dev *rdev,
> +			      int min_uV, int max_uV)
> +{
> +	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
> +	struct da9055_regulator_info *info = regulator->info;
> +	int ret, sel;
> +
> +	ret = verify_range(info, min_uV, max_uV);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (min_uV < info->min_uV)
> +		min_uV = info->min_uV;
> +
> +	sel = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
> +
> +	ret = da9055_list_voltage(rdev, sel);
> +	if (ret < 0)
> +		return ret;
> +
> +	return sel;
> +}

This is regulator_map_voltage_linear().

> +             int gpio = pdata->gpio_base + pdata->gpio_ren[id];

> +		sprintf(name, "DA9055 REG %d STATE", id);

snprintf().

> +		/* Set the GPIO I/P pin for controlling the regulator state. */
> +		ret = devm_gpio_request_one(config->dev, gpio, GPIOF_DIR_IN,
> +					    name);
> +		if (ret < 0)
> +			goto err;

We never actually appear to use this GPIO anywhere...  why are we
requesting it?  Also, why is the ability to read the regulator state via
a GPIO associated with controlling it via a GPIO, it's unusual for these
things to be tied together.
