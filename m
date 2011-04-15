Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab1DOKgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 06:36:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38587 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755545Ab1DOKgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 06:36:20 -0400
Date: Fri, 15 Apr 2011 11:36:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv1 5/11] REGULATOR: Regulator module of DA9052 PMIC driver
Message-ID: <20110415103555.GF23466@opensource.wolfsonmicro.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B619753@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B619753@KCINPUNHJCMS01.kpit.com>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 05:42:08PM +0530, Ashish Jangam wrote:

> Changes made since last submission:
> . Change the regulator registration method
> . Ported the driver to Linux kernel 2.6.38.2 

> Linux Kernel Version: 2.6.38.2

As I've repeatedly told you you should submit patches against -next.
Please stop doing this, it's getting repetitive.  A few comments from a
breif scan through:

> +static struct regulator_consumer_supply da9052_vddarm_consumers[] = {
> +	{
> +		.supply = "vcc",
> +	}
> +};

Supplies are connected to regulators using the machine driver not
drivers for specific regulators.

> +	if (offset == DA9052_BUCK_PERI) {
> +		if (regval >= DA9052_BUCK_PERI_REG_MAP_UPTO_3uV) {
> +			regval_uV = ((DA9052_BUCK_PERI_REG_MAP_UPTO_3uV *
> +				da9052_regulator_info[offset].step_uV)
> +				+ constraints->min_uV);
> +			regval_uV += (regval -
> +				DA9052_BUCK_PERI_REG_MAP_UPTO_3uV)
> +				*(DA9052_BUCK_PERI_3uV_STEP);
> +		} else {
> +			regval_uV =
> +				(regval * da9052_regulator_info[offset].step_uV)
> +				+ constraints->min_uV;
> +		}

Given this and the number of other differences it seems like you should
just define separate ops for BUCK_PERI.

> +static int da9052_regulator_set_voltage(struct regulator_dev *rdev, int min_uV,
> +				 int max_uV, unsigned *selector)
> +{
> +	struct da9052 *da9052 = to_da9052(rdev);
> +	int offset = rdev_get_id(rdev);
> +	int ret;
> +	int reg_val = 0;
> +
> +	reg_val = da9052_regulator_uvolts_to_regVal(rdev, min_uV);

You're completely ignoring the max_uV constraint here.

> +static int da9052_list_voltage(struct regulator_dev *rdev, unsigned selector)
> +{
> +	struct regulation_constraints *constraints = rdev->constraints;
> +	struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
> +	int ret;
> +
> +	ret = constraints->min_uV + info->step_uV * selector;
> +	if (ret > constraints->max_uV)
> +		return -EINVAL;

This looks *very* broken.  Why are you looking at the constraints to
determine what the selector means?
