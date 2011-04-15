Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1DOJQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 05:16:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46601 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab1DOJQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 05:16:03 -0400
Subject: Re: [PATCHv1 5/11] REGULATOR: Regulator module of DA9052 PMIC
 driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B619753@KCINPUNHJCMS01.kpit.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B619753@KCINPUNHJCMS01.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 10:15:57 +0100
Message-ID: <1302858958.3444.11.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 17:42 +0530, Ashish Jangam wrote:
> Hi Mark,
> 
> Regulator Driver for Dialog Semiconductor DA9052 PMICs.
> 
> Changes made since last submission:
> . Change the regulator registration method
> . Ported the driver to Linux kernel 2.6.38.2 
> 

Please don't use V1 as the patch version if you have made changes since
the previous version. This makes it more difficult to review and track
the patches.  

> Linux Kernel Version: 2.6.38.2

I'm sure Mark has mentioned this before but please do make sure you
create your patches (especially a large series like this that touches
multiple subsystems) against linux-next. This makes it far easier for
maintainers to apply.

some minor formatting issues below :-

> 
> Signed-off-by: D. Chen <dchen@diasemi.com>
> ---
> diff -Naur linux-2.6.38.2/drivers/regulator/da9052-regulator.c wrk_linux-2.6.38.2/drivers/regulator/da9052-regulator.c
> --- linux-2.6.38.2/drivers/regulator/da9052-regulator.c	1970-01-01 05:00:00.000000000 +0500
> +++ wrk_linux-2.6.38.2/drivers/regulator/da9052-regulator.c	2011-04-13 13:04:03.000000000 +0500
> @@ -0,0 +1,431 @@
> +/*
> +* Regulator driver for DA9052
> +*
> +* Copyright(c) 2009 Dialog Semiconductor Ltd.
> +*
> +*Author: Dajun Chen <dchen@diasemi.com>
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License as published by
> +* the Free Software Foundation; either version 2 of the License, or
> +* (at your option) any later version.
> +*
> +*/
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/init.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/machine.h>
> +
> +#include <linux/mfd/da9052/da9052.h>
> +#include <linux/mfd/da9052/pdata.h>
> +#include <linux/mfd/da9052/reg.h>
> +
> +/* LDO and Buck index */
> +#define DA9052_BUCK_CORE	0
> +#define DA9052_BUCK_PRO	1
> +#define DA9052_BUCK_MEM	2
> +#define DA9052_BUCK_PERI	3
> +
> +#define DA9052_LDO2		5
> +#define DA9052_LDO3		6
> +
> +/* Buck step size Macros */
> +#define DA9052_BUCK_PERI_3uV_STEP		100000
> +#define DA9052_BUCK_PERI_REG_MAP_UPTO_3uV	24
> +#define DA9052_CONST_3uV			3000000
> +
> +static struct regulator_ops da9052_regulator_ops;
> +
> +static struct regulator_consumer_supply da9052_vddarm_consumers[] = {
> +	{
> +		.supply = "vcc",
> +	}
> +};
> +
> +#define DA9052_BUCKCORE_INIT(max, min) \
> +{\
> +	.constraints = {\
> +		.max_uV		= (max) * 1000,\
> +		.min_uV		= (min) * 1000,\
> +		.valid_ops_mask	= REGULATOR_CHANGE_VOLTAGE\
> +		|REGULATOR_CHANGE_STATUS | REGULATOR_CHANGE_MODE,\
> +		.valid_modes_mask = REGULATOR_MODE_NORMAL,\
> +	},\
> +	.num_consumer_supplies = ARRAY_SIZE(da9052_vddarm_consumers),\
> +	.consumer_supplies = da9052_vddarm_consumers,\
> +}
> +
> +
> +#define DA9052_REGULATOR_INIT(max, min) \
> +{\
> +	.constraints = {\
> +		.max_uV		= (max) * 1000,\
> +		.min_uV		= (min) * 1000,\
> +		.valid_ops_mask	= REGULATOR_CHANGE_VOLTAGE\
> +		|REGULATOR_CHANGE_STATUS | REGULATOR_CHANGE_MODE,\
> +		.valid_modes_mask = REGULATOR_MODE_NORMAL,\
> +	},\
> +}
> +
> +struct regulator_init_data da9052_regulators_init[] = {
> +	/* BUCKS */
> +	DA9052_BUCKCORE_INIT(2075, 500),
> +	DA9052_REGULATOR_INIT(2075, 500),
> +	DA9052_REGULATOR_INIT(2500, 925),
> +	DA9052_REGULATOR_INIT(3600, 1800),
> +	/* LDO */
> +	DA9052_REGULATOR_INIT(1800, 600),
> +	DA9052_REGULATOR_INIT(1800, 600),
> +	DA9052_REGULATOR_INIT(3300, 1725),
> +	DA9052_REGULATOR_INIT(3300, 1725),
> +	DA9052_REGULATOR_INIT(3600, 1200),
> +	DA9052_REGULATOR_INIT(3600, 1200),
> +	DA9052_REGULATOR_INIT(3600, 1200),
> +	DA9052_REGULATOR_INIT(3600, 1200),
> +	DA9052_REGULATOR_INIT(3650, 1250),
> +	DA9052_REGULATOR_INIT(3600, 1200),
> +
> +};
> +
> +#define DA9052_LDO(_id, step, sbits, ebits, mbits) \
> +{\
> +		.reg_desc	= {\
> +		.name		= "LDO" #_id,\
> +		.ops		= &da9052_regulator_ops,\
> +		.type		= REGULATOR_VOLTAGE,\
> +		.id		= _id,\
> +		.owner		= THIS_MODULE,\
> +	},\
> +		.step_uV		= (step) * 1000,\
> +		.volt_shift		= (sbits),\
> +		.enable_bit		= (ebits),\
> +		.supply_v_mask	= (mbits),\

The formatting looks a little odd here in relation to the last }.

> +}
> +
> +#define DA9052_DCDC(_id, step, sbits, ebits, mbits) \
> +{\
> +		.reg_desc	= {\
> +		.name		= "BUCK" #_id,\
> +		.ops		= &da9052_regulator_ops,\
> +		.type		= REGULATOR_VOLTAGE,\
> +		.id		= _id,\
> +		.owner		= THIS_MODULE,\
> +	},\
> +		.step_uV		= (step) * 1000,\
> +		.volt_shift		= (sbits),\
> +		.enable_bit		= (ebits),\
> +		.supply_v_mask	= (mbits),\

ditto

> +}
> +
> +struct da9052_regulator_info {
> +	struct regulator_desc reg_desc;
> +	int step_uV;
> +	unsigned char volt_shift;
> +	unsigned char enable_bit;
> +	unsigned char supply_v_mask;
> +

remove newline here.

> +};
> +
> +struct da9052_regulator {
> +	struct da9052 *da9052;
> +	struct regulator_dev *regulators[];
> +};
> +
> +struct da9052_regulator_info da9052_regulator_info[] = {
> +	/* Buck1 - 4*/
> +	DA9052_DCDC(0, 25, 6, 6, DA9052_SUPPLY_VBCOREGO),
> +	DA9052_DCDC(1, 25, 6, 6, DA9052_SUPPLY_VBPROGO),
> +	DA9052_DCDC(2, 25, 6, 6, DA9052_SUPPLY_VBMEMGO),
> +	DA9052_DCDC(3, 50, 5, 6, 0),
> +	/* LD01 - LDO10*/
> +	DA9052_LDO(4, 50, 5, 6, 0),
> +	DA9052_LDO(5, 25, 6, 6, DA9052_SUPPLY_VLDO2GO),
> +	DA9052_LDO(6, 25, 6, 6, DA9052_SUPPLY_VLDO3GO),
> +	DA9052_LDO(7, 25, 6, 6, 0),
> +	DA9052_LDO(8, 50, 6, 6, 0),
> +	DA9052_LDO(9, 50, 6, 6, 0),
> +	DA9052_LDO(10, 50, 6, 6, 0),
> +	DA9052_LDO(11, 50, 6, 6, 0),
> +	DA9052_LDO(12, 50, 6, 6, 0),
> +	DA9052_LDO(13, 50, 6, 6, 0),
> +};
> +
> +static inline struct da9052 *to_da9052(struct regulator_dev *rdev)
> +{
> +	return dev_get_drvdata(rdev_get_dev(rdev)->parent->parent);
> +
> +}
> +
> +static int da9052_regulator_uvolts_to_regVal(struct regulator_dev *rdev,
> +						unsigned int val)
> +{
> +	struct regulation_constraints *constraints = rdev->constraints;
> +	int offset = rdev_get_id(rdev);
> +	int reg_val = 0;
> +
> +	/* Care for the varying step size of BUCK PERI */
> +	if ((offset == DA9052_BUCK_PERI) && (val >= DA9052_CONST_3uV)) {
> +		reg_val = (DA9052_CONST_3uV - constraints->min_uV)/
> +				  (da9052_regulator_info[offset].step_uV);
> +		reg_val += ((val - DA9052_CONST_3uV) /
> +					(DA9052_BUCK_PERI_3uV_STEP));
> +	} else{

space after else

Regards

Liam


