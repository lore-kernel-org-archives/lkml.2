Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192Ab2EWJ6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:58:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33300 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756733Ab2EWJ6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:58:12 -0400
Date: Wed, 23 May 2012 10:58:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: Re: [PATCH] regulator: add new regulator driver for lp872x
Message-ID: <20120523095808.GD4085@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FA17F@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a1QUDc0q7S3U7/Jg"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FA17F@DQHE02.ent.ti.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a1QUDc0q7S3U7/Jg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 23, 2012 at 07:50:59AM +0000, Kim, Milo wrote:

> +static int lp872x_read_byte(struct lp872x *lp, u8 addr, u8 *data)
> +{
> +	int ret;
> +	unsigned int val;
> +
> +	mutex_lock(&lp->xfer_lock);
> +	ret = regmap_read(lp->regmap, addr, &val);
> +	if (ret < 0) {
> +		mutex_unlock(&lp->xfer_lock);
> +		dev_err(lp->dev, "failed to read 0x%.2x\n", addr);
> +		return ret;
> +	}
> +	mutex_unlock(&lp->xfer_lock);
> +
> +	*data = (u8)val;
> +	return 0;
> +}

This should just be a trivial wrapper around regmap_read, the regmap API
handles concurrency for you.  Similarly for all your other I/O
functions.

> +static int lp872x_ldo_list_voltage(struct regulator_dev *rdev,
> +				unsigned selector)

regulator_list_voltage_table() will appear in -next just after the merge
window.

> +static int lp872x_ldo_set_voltage_sel(struct regulator_dev *rdev,
> +				unsigned selector)

regulator_set_voltage_sel_regmap().

> +static int lp872x_ldo_get_voltage_sel(struct regulator_dev *rdev)

regulator_get_voltage_sel_regmap().

> +static int lp872x_regulator_enable(struct regulator_dev *rdev)

Your ENABLE define made the code a bit obscure but this is
regulator_enable_regmap()

> +static int lp872x_regualtor_disable(struct regulator_dev *rdev)

regulator_disable_regmap()

> +static int lp872x_regulator_is_enabled(struct regulator_dev *rdev)

regulator_is_enabled_regmap()

> +static int lp872x_buck_list_voltage(struct regulator_dev *rdev,
> +				unsigned selector)

regulator_list_voltage_table()

> +	case LP8720_ID_BUCK:
> +		if (val & LP8720_EXT_DVS_M) {
> +			pinstate = pdata->get_dvs_pin_state ?
> +				pdata->get_dvs_pin_state() : DVS_LOW;

This is a really odd implementation.  Why isn't the driver managing the
pin and what happens to the consumers that expected to set a voltage
when the pin gets changed?

> +static int lp8725_buck_enable(struct regulator_dev *rdev)

regulator_enable_regmap()

> +static int lp8725_buck_disable(struct regulator_dev *rdev)

regulator_disable_regmap()

> +static int lp8725_buck_is_enabled(struct regulator_dev *rdev)

regulator_is_enabled_regmap()

> +	for (i = 0 ; i < num ; i++) {
> +		regulator_data = lp->pdata->regulator_data + i;
> +		desc = &lp872x_regulator_desc[regulator_data->id];
> +		init_data = regulator_data->init_data;
> +
> +		rdev = regulator_register(desc, lp->dev, init_data, lp, NULL);
> +		if (IS_ERR(rdev)) {
> +			dev_err(lp->dev, "regulator register err");
> +			ret =  PTR_ERR(rdev);
> +			goto err;
> +		}

You should unconditionally register all the regulators the chip has and
match the init_data to them rather than only registering regulators you
have init_data.  This allows users to inspect unconfigured regulators
and allows the core to support things like powering off unused
regulators.

> +static const struct regmap_config lp872x_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +};

Setting max_register would get you debugfs inspection of the regmap.

> +	lp->regmap = regmap_init_i2c(cl, &lp872x_regmap_config);

devm_regmap_init_i2c().

> +/**
> + * lp872x_platform_data
> + * @general_config    (mandatory) : the value of LP872X_GENERAL_CFG register

Is the chip default never valid?

> + * @regulator_data    (mandatory) : platform regulator id and init data
> + * @num_regulators    (mandatory) : total number of platform regulators

These should be optional.

--a1QUDc0q7S3U7/Jg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvLSpAAoJEBus8iNuMP3dX00P/3FnR4OzbQh4+iMUFhOtB12P
5k9kxc+fMtSm0578imZP8dgj1pkYQHlTchqatqOpSyOx5JIe2DhtpP7L5sjcgURu
Ycla5VfBLHm0FX3J8JF8zBFv2L2841JJtG1O1HF38ZsgDGDfR0kBT6rJoQKzmrJJ
u/TTUbc0wSMaHcMui74IViWgzWzE0pXO5HoSUwqjLQN1lugK0VsJhUK6GNLE0YLu
W1sefVnzdF4x3vUUmLiZHvvtPkHP1svl1KssHhvEqJpW57opTG7lKjPOze7bQQbh
VlmmpkBUrUswwYU2amvWKjDiLdF2faeB6sesg3hGjIMEnfc7TDdhPFJyeTIkv/h/
K8W+y0MXAZeo3jedtECoLbDTudJDK1c9zfPx4imbODQtFuoGubSD87GCgR8Tj1wa
RzY8r2Gjzt0xhWzqT2m9jtQvB5Fy+uq3yYcec7XE0aKQwTre2Jn6zzJVjpwgJx5C
75cv9WbpdcARWslxpWsMIuwOT8p3ysn6hmEPYVBW3mJoOrZPGUHKapHufcr14WI5
zZsCGy4RccN5NjXSEsGn75XvX0p1lPGPhVs0HEVLP54peq/QYO/T+pOoiKSwc+R5
WE9faPqco5Hp7vYd+cGKnkD4j++5h9cNBz3B37WA78XWr+IUyJ9wH5MtVVgKpINN
AuEsqT6KWyRdkt2IKjnE
=L9nD
-----END PGP SIGNATURE-----

--a1QUDc0q7S3U7/Jg--
