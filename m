Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab1ECOQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:16:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59857 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752800Ab1ECOQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:16:08 -0400
Date: Tue, 3 May 2011 15:16:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv1 -next] REGULATOR: Regulator module of DA9052 PMIC
 driver
Message-ID: <20110503141605.GO1762@opensource.wolfsonmicro.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5AF7A@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5AF7A@KCINPUNHJCMS01.kpit.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 07:12:21PM +0530, Ashish Jangam wrote:
> Hi Mark,
> 
> Regulator Driver for Dialog Semiconductor DA9052 PMICs.
> 
> Changes made since last submission:
> . separate ops for buck peri
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>

*Please* as has been *repeatedly* requested follow the patch submission
process in SubmittingPatches, in this case you need to check your
signoffs and the patch description.

We're now on what must be at least the 10th submission of this code and
this basic stuff is still not being done properly, and below we're still
identifying serious issues with the code.  This really does not feel at
all respectful of the time and effort reviewers put into looking at your
code.

> +/*
> +* da9052-regulator.c: Regulator driver for DA9052
> +*

Indentation.

> +#define DA9052_REGULATOR_INIT(max, min) \

This ordering is rather counterintutive, normally you'd write a range as
min, max.

> +struct regulator_init_data da9052_regulators_init[] = {
> +       /* BUCKS */

You're completely failing to understand how the regulator API works
here.  Have you ever tested this code in a running system?  Please take
a look at the API and how this struct is normally used.

> +       if (min_uV < info->min_uV || min_uV > info->max_uV)
> +                       return -EINVAL;
> +       if (max_uV < info->min_uV || max_uV > info->max_uV)
> +                       return -EINVAL;

Coding style - these indents aren't anything like the standard kernel
style.  This applies in several other points.

> +       ret = da9052_reg_update(da9052, DA9052_BUCKCORE_REG + offset,
> +                       (1 << info->volt_shift) - 1, *selector);
> +       if (ret < 0)
> +               return -EIO;

Return the actual error you got.

> +static int da9052_regulator_set_voltage(struct regulator_dev *rdev,
> +                       int min_uV, int max_uV, unsigned int *selector)
> +{

> +       /* Enable regualtor bit */
> +       if (info->supply_v_mask != 0) {
> +               ret = da9052_reg_update(da9052, DA9052_SUPPLY_REG, 0,
> +                                               info->supply_v_mask);
> +               if (ret < 0)
> +                       return -EIO;
> +       }

Why is set_voltage() enabling the regulator, or alternatively what is
this doing?

> +static int da9052_get_buckperi_voltage(struct regulator_dev *rdev)
> +{
> +       struct da9052_regulator_info *info = rdev_get_drvdata(rdev);
> +       struct da9052 *da9052 = to_da9052(rdev);
> +       int offset = rdev_get_id(rdev);
> +       int ret;
> +       int regval;
> +       int volt_uV;
> +
> +       ret = da9052_reg_read(da9052, DA9052_BUCKCORE_REG + offset);
> +
> +       if (ret < 0)
> +               return -EIO;
> +
> +       regval = ret & ((1 << info->volt_shift) - 1);
> +
> +       /* Convert regsister value into micro volt */
> +       volt_uV = da9052_list_buckperi_voltage(rdev, regval);

Just implement get_voltage_sel, this is essentialy an open coded version
of that.

> +failed:
> +       device_for_each_child(da9052->dev, NULL, da9052_remove_subdev);
> +       return;
> +}
> +EXPORT_SYMBOL(da9052_add_regulator_devices);

This should be being done as part of your MFD.
