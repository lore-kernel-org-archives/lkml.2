Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab2J0V7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:59:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50258 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759083Ab2J0V7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:59:18 -0400
Date: Sat, 27 Oct 2012 22:59:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <dchen@diasemi.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 2/7] Regulator: DA9055 Regulator driver
Message-ID: <20121027215850.GI4564@opensource.wolfsonmicro.com>
References: <1349950164.7957.23.camel@dhruva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NqSa+Xr3J/G6Hhls"
Content-Disposition: inline
In-Reply-To: <1349950164.7957.23.camel@dhruva>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NqSa+Xr3J/G6Hhls
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 11, 2012 at 03:39:24PM +0530, Ashish Jangam wrote:

> This is the Regulator patch for the DA9055 PMIC and has got dependency on
> the DA9055 MFD core.

Always submit patches with subject lines appropriate for the subsystem,
this helps get your patch noticed.  People do things like search their
mailboxes for subsystem prefixes when looking for things they need to
review.

> This patch support all of the DA9055 regulators. The output voltages are
> fully programmable through I2C interface only. The platform data with reg=
ulation
> constraints is passed down from the board to the regulator.
>=20
> +	switch (mode) {
> +	case REGULATOR_MODE_FAST:
> +		val =3D DA9055_BUCK_MODE_SYNC << info->mode.shift;
> +		break;
> +	case REGULATOR_MODE_NORMAL:
> +		val =3D DA9055_BUCK_MODE_AUTO << info->mode.shift;
> +		break;
> +	case REGULATOR_MODE_IDLE:
> +	case REGULATOR_MODE_STANDBY:
> +		val =3D DA9055_BUCK_MODE_SLEEP << info->mode.shift;
> +		break;

_IDLE and _STANDBY should have different effects if they're both
implemented; pick one.  From the rest of the code it looks like it
should be _STANDBY.

> +	switch (mode) {
> +	case REGULATOR_MODE_NORMAL:
> +	case REGULATOR_MODE_FAST:
> +		val =3D DA9055_LDO_MODE_SYNC;
> +		break;
> +	case REGULATOR_MODE_IDLE:
> +	case REGULATOR_MODE_STANDBY:
> +		val =3D DA9055_LDO_MODE_SLEEP;
> +	}

Similarly here.  You're also missing a break;

> +	/* Get the voltage for the activer register set A/B */
> +	if (ret =3D=3D DA9055_REGUALTOR_SET_A)
> +		ret =3D da9055_reg_read(regulator->da9055, volt.reg_a);
> +	else
> +		ret =3D da9055_reg_read(regulator->da9055, volt.reg_b);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	sel =3D ((ret & volt.v_mask) - volt.v_offset);

Why not just use the register values directly and refuse to write ones
That are too low?  This would simplify things a little as you'd only
need to check=20

> +	/* Set the voltage */
> +	if (ret =3D=3D DA9055_REGUALTOR_SET_A)
> +		return da9055_regulator_set_voltage_bits(rdev, info->volt.reg_a,
> +							 selector);
> +
> +	return da9055_regulator_set_voltage_bits(rdev, info->volt.reg_b,
> +						 selector);

This is confusingly written - it should be either a switch or an if/else
really.

> +	/* Select register set B for suspend voltage ramping. */
> +	ret =3D da9055_reg_update(regulator->da9055, info->conf.reg,
> +				info->conf.sel_mask, DA9055_SEL_REG_B);
> +	if (ret < 0)
> +		return ret;

This doesn't seem like it plays nicely with the GPIO selection in normal
set_voltage() - does it need to check to see if register set B might be
used in normal operation and refuse to run if it could?

> +	for (i =3D 0; i < ARRAY_SIZE(da9055_regulator_info); i++) {
> +		info =3D &da9055_regulator_info[i];
> +		if (info->reg_desc.id =3D=3D id)
> +			return info;
> +		}
> +

The indentation here is *very* messed up.  I'd suggest not omitting any
braces.

--NqSa+Xr3J/G6Hhls
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjFklAAoJELSic+t+oim9kv8P/13h7ip42gMObREcdmJQZZDX
bkqQnT7JzAk44lVgooUsI05MvcuMblWtyZt9vDkQncm5k7tlLV7o8QvXVdiCSa7w
o8a1XRwPPrX2R26OjGDsWfNU/Y3AZKeWoI/KGl1JhblbmN5bFt0W48u+f4y8S7Qz
xMxBJi/PANe0Af2DqEkhl6CSBGie05hGmb+mYyY+YpEP2XwshWN70EadforsPeCZ
VqwUKEXJZ36ntIFPZQ3kG1lo3gIZW0UQPOMhCA7TPcZg5Sqj3qCIdZawH8hOOC24
FsvQO28If47O82zrCCFvBcBmf28hWXH9yjodA2C9eAzeS9ddJMZSems2Rkn2n+FK
rl7IEDiDdO0Ty0kp6wHVymi7WXScQ2n5AFyGGMsvLq624tTbd7PRcXcS9TZ3+3Vh
iTPGD4tQ0DLcudRhHCmeNe9/rCFhPbojFluy+qCwKX3qjVhZ07/I22EvFIeScVp8
7x8fFEHmvLPEOllKbr7g0CTegBwFDv30YLYFFknqVM4dAvVdRxWvBCc4sWLkhGSw
mEVaJWn+4f+tQPTCU/QfX94+w/Au4rU0U9IfURO9maeq2TvRmvbn+aTZ/0V4EaCB
05kC0Es+d9kWcLYQahWMMid4IV/t/Wy2OhdTCmjp5OIxqNuhuLoLae00LnUSY4CH
r9QAhKTFZYUTIRKRYCbR
=ffMU
-----END PGP SIGNATURE-----

--NqSa+Xr3J/G6Hhls--
