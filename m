Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab1ADN6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 08:58:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53814 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750897Ab1ADN6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 08:58:23 -0500
Date: Tue, 4 Jan 2011 13:56:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Anton Vorontsov <cbou@mail.ru>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v4 3/3] MFD MAX8998/LP3974: Support Charger
Message-ID: <20110104135651.GD24774@opensource.wolfsonmicro.com>
References: <20101224113805.GI27832@sortiz-mobl>
 <1294118261-18906-4-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294118261-18906-4-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 02:17:41PM +0900, MyungJoo Ham wrote:
> With the new regulator, "CHARGER", users can control charging
> current and turn on and off the charger. Note that the charger
> specification of LP3974 is different from that of MAX8998.
> 
> driver/power/max8998.c supports power supply APIs for

It's probably better to split the power supply driver into a separate
patch as there should be no build time dependency between the two.  I've
added Anton to the CCs as he is the drivers/power maintainer.

One thing that jumps out here is that there's no regulator API usage at
all in the power driver - the power driver just jumps straight in
and updates registers when it needs to do anything.  Are you sure that
the regulator API driver is needed at all, if it is I'd expect to see
use of it in the power API.

> +static const char * const manufacturers[] = {
> +	[TYPE_MAX8998] = "Maxim",
> +	[TYPE_LP3974] = "National Semiconductor",
> +	[TYPE_UNKNOWN] = "Unknown",

Normally this refers to the battery rather than the chip.

> +static void _max8998_update_eoc(struct platform_device *pdev)
> +{
> +	struct max8998_battery_data *max8998 = platform_get_drvdata(pdev);
> +	struct i2c_client *i2c = max8998->iodev->i2c;
> +	int charge_current = 0;
> +	int target_eoc_ratio;
> +	u8 val;
> +
> +	/* Nothing to do. User set EOC with % */
> +	if (max8998->eoc_in_mA == 0)
> +		return;
> +
> +	/* Not initialized. */
> +	if (!charger_current_map_desc)
> +		return;

This should be be driver data rather than a global for neatness (though
in reality the chances of more than one of these chargers in a system
are pretty low).

> --- a/drivers/regulator/max8998.c
> +++ b/drivers/regulator/max8998.c
> @@ -86,6 +86,13 @@ static const struct voltage_map_desc buck3_voltage_map_desc = {
>  static const struct voltage_map_desc buck4_voltage_map_desc = {
>  	.min = 800,	.step = 100,	.max = 2300,
>  };
> +static const int charger_current_map_desc_max8998[] = {
> +	90, 380, 475, 550, 570, 600, 700, 800
> +};
> +static const int charger_current_map_desc_lp3974[] = {
> +	100, 400, 450, 500, 550, 600, 700, 800
> +};
> +const int *charger_current_map_desc;

Ah, this is exported from the regulator driver...  That's slightly odd.
For voltages we've an enumeration API for the supported settings, we
probably ought to add that for current regulators too.

> +	dev_info(&rdev->dev, "charger current limit = %dmA (%xh)\n",
> +			chosen_current, chosen);

dev_dbg() or remove it entirely please, otherwise it might get a bit
noisy.

> +static struct regulator_ops max8998_charger_ops = {
> +	.is_enabled		= max8998_ldo_is_enabled_negated,
> +	/* enable and disable are intentionally negated */
> +	.enable			= max8998_ldo_disable,
> +	.disable		= max8998_ldo_enable,

That's really confusing...  why?
