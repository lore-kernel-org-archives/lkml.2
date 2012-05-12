Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab2ELKno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 06:43:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37081 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780Ab2ELKnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 06:43:43 -0400
Date: Sat, 12 May 2012 11:43:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Oritz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, Chiwoong Byun <woong.byun@samsung.com>
Subject: Re: [PATCH v2 2/3] regulator: MAX77686: Add Maxim 77686 regulator
 driver
Message-ID: <20120512104338.GH1781@opensource.wolfsonmicro.com>
References: <1336719045-9765-1-git-send-email-jonghwa3.lee@samsung.com>
 <1336719045-9765-3-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPDwMsyfds7q4mrK"
Content-Disposition: inline
In-Reply-To: <1336719045-9765-3-git-send-email-jonghwa3.lee@samsung.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPDwMsyfds7q4mrK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 11, 2012 at 03:50:44PM +0900, Jonghwa Lee wrote:

> +/* LDO3 ~ 5, 9 ~ 14, 16 ~ 26 (uV) */
> +static const struct voltage_map_desc ldo_voltage_map_desc = {
> +	.min = 800000,	.max = 3950000,	.step = 50000,	.n_bits = 6,
> +};

As I indicated I'd do in reply to Yadwinder Singh Brar's posting of a
version of this driver the other day this is now factored out into the
core - you should be able to set this all up using regulator_desc and
regulator_map_voltage_linear() which will appear in -next on Monday (I
appreciate it's not something you should have been aware of!).  This
should also allow you to use regulator_{set,get}_voltage_regmap.

> +	[MAX77686_EN32KHZ_AP] = NULL,
> +	[MAX77686_EN32KHZ_CP] = NULL,
> +	[MAX77686_P32KH] = NULL,

These should be being moved over to the generic clock API now it's in
mainline.

> +/*
> + * TODO
> + * Reaction to the LP/Standby for each regulator should be defined by
> + * each consumer, not by the regulator device driver if it depends
> + * on which device is attached to which regulator. Here we are
> + * creating possible PM-wise regression with board changes.Also,
> + * we can do the same effect without creating issues with board
> + * changes by carefully defining .state_mem at bsp and suspend ops
> + * callbacks.
> + */

The various set_suspend() calls are supposed to be for this, though in
practice they're rarely used in systems so we probably need a bunch of
work there.  We certainly don't have any aribtration between consumers
yet.

> +static int max77686_reg_is_enabled(struct regulator_dev *rdev)
> +{
> +	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
> +	int ret, reg, mask, pattern;
> +	u8 val;
> +
> +	ret = max77686_get_enable_register(rdev, &reg, &mask, &pattern);
> +	if (ret == -EINVAL)
> +		return 1; /* "not controllable" */

Just have separate ops structures for these regulators.

> +static int max77686_get_voltage_register(struct regulator_dev *rdev,
> +		int *_reg, int *_shift, int *_mask)

> +static int max77686_get_voltage(struct regulator_dev *rdev)
> +{

These look like they should be done using regulator_get_voltage_regmap()
so you only need data in the driver.

> +static inline int max77686_get_voltage_proper_val(
> +		const struct voltage_map_desc *desc,
> +		int min_vol, int max_vol)

Pretty big function for inline, and the core will do this for you anyway
if you use the new features I was mentioning further up.

> +	switch (rid) {
> +	case MAX77686_BUCK2 ... MAX77686_BUCK4:
> +		if (org < i)
> +			udelay(DIV_ROUND_UP(desc->step * (i - org),
> +						max77686->ramp_delay * 1000));
> +		break;
> +	case MAX77686_BUCK1:
> +	case MAX77686_BUCK5 ... MAX77686_BUCK9:
> +		/* Unconditionally 100 mV/us */
> +		if (org < i)
> +			udelay(DIV_ROUND_UP(desc->step * (i - org), 100000));
> +		break;
> +	default:
> +		break;
> +	}

Implement set_voltage_time_sel() instead and let the core do the delays.

> +static int max77686_reg_do_nothing(struct regulator_dev *rdev)
> +{
> +	return 0;
> +}

Remove this, you should never have empty functions like this.

> +	if (!pdata) {
> +		dev_err(pdev->dev.parent, "No platform init data supplied.\n");
> +		return -ENODEV;
> +	}

You should just carry on unless there's some strong device-specific
reason for not doing so.

> +	max77686 = kzalloc(sizeof(struct max77686_data), GFP_KERNEL);
> +	if (!max77686)
> +		return -ENOMEM;

devm_kzalloc().

> +	size = sizeof(struct regulator_dev *) * pdata->num_regulators;
> +	max77686->rdev = kzalloc(size, GFP_KERNEL);
> +	if (!max77686->rdev) {
> +		kfree(max77686);
> +		return -ENOMEM;
> +	}

You should just unconditionally register all regulators the chip has,
this allows users to inspect the state of the regulators even if they're
not being controlled by software.

> +	max77686->opmode_data = pdata->opmode_data;

Shouldn't this be being handled by regulator_set_mode()?  If not what
does it do?

> +	printk(PMIC_DEBUG "%s: DEVICE ID=0x%x\n", __func__, data);

This needs cleaning up - it should at least be a dev_ printk.

> +static int __init max77686_pmic_init(void)
> +{
> +	printk(PMIC_DEBUG "%s\n", __func__);

This can be removed too.

--ZPDwMsyfds7q4mrK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPrj7TAAoJEBus8iNuMP3dULYQAIIHAA779S6UteBpqLlMHbZi
wzab5KWJaMx98pJrFbbwyEbVWGeiYL1HxfpsOF6MsFUiuRfdqbHiuEZsp9O+mHpL
irTPHtZEPQXFjxWLUdc7vXDJSNZH2e6GxDkaTQvKKi3hY0K6YXVLRi2+tMolzCx0
J/6IAEoqfA19NqF6KqGtjy940xkRCd+KJ8+/gLXB5K7Bdw6qvcH/Q3hFTE0MdqHQ
NKDPsIDMAZ4FiJs0MB/NmVtK5ggRU8vr2NCfRAsTqC4ni/cLhTgsFowsF8vkpoqY
0AhF9Sm8OHwc6FN03a2Uhm29FDPsS8e+fXJl9CpdSXM9Q4O1kEEV14nM5uFWG+QJ
k32zPzUdkWHfuvOi1oI9AwROtTewP0jQSYijJhf2S5CkW8LVYaTBWXeTIk3N8j9m
bB7NLeNGixgwYBwR9V2WgWPlzye8MkeVa0RwLHUK8AwymBQ9YbEqapZQp0QotINq
KwKwSFz6oHN0BCbReNe4LKg+T94BxXwvMLeFbhy53/zDXD68FyetUx4PtBw2Jx+7
A6D6mdNHUoaeUB/TE4E5vLP/r+7rfVoWehPflRaZsGY9tdqvC6t1qNvN0DQbZzmV
5vGU+l3VH6W93dJbEP+hpiMgOWB7sMocT71XPNraY5zw9aSLuh6pLkkTIPaAQiR8
mf5KuuCzouN9OAbq/09T
=NwIy
-----END PGP SIGNATURE-----

--ZPDwMsyfds7q4mrK--
