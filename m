Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2KWO6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 09:58:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53232 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab2KWO6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 09:58:50 -0500
Date: Fri, 23 Nov 2012 15:58:45 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 2/3] pwm: New driver to support PWMs on TWL4030/6030
 series of PMICs
Message-ID: <20121123145844.GA16810@avionic-0098.adnet.avionic-design.de>
References: <1353405382-9226-1-git-send-email-peter.ujfalusi@ti.com>
 <1353405382-9226-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <1353405382-9226-3-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:mzfyoTcOr8tFaf6dnffByUvLB5m4XIPfCUutMJIDpxA
 lX8ZL6gYMdDoWCsxp4hTcN8b7a0HKVrfJJ/Sit7Hf5ZXo4avPU
 xWEm3mj2TQ1iiV6iV0yCxDrnLmVlXvJptpPZupXXewrPq27ZWY
 69CnOeQLUU+peTGHjFB/Q086pgPYMvoJyNz7Mo3tNC5lTRmyiF
 V6eSA8ntnt2ZOAOld4SuJ7v6Yd3EYTskU4+QDSGPRlJ72iC4Bc
 OJO9nAzCQuwzk/cfOW2q3siRbra4IYLxO6rj7sIvAr5YzZin+7
 /9ThZkEXA68xyeZ9qYv/dUAft5BAsyTLbOxUg5Tkcc6LbEd3jm
 Af74Er0gAFlUTBOKaAqqwHJdXtX6cMoKXAQZ6cK8iqDRuEZBRP
 jPRSn9ILj7EEbE5K4t9/dlWlO5y03qAoeaamFobPQ38WVXwxLx
 PGRS+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 20, 2012 at 10:56:21AM +0100, Peter Ujfalusi wrote:
> The driver supports the following PWM outputs:
> TWL4030 PWM0 and PWM1
> TWL6030 PWM1 and PWM2
>=20
> On TWL4030 the PWM signals are muxed. Upon requesting the PWM the driver
> will select the correct mux so the PWM can be used. When the PWM has been
> freed the original configuration going to be restored.

"configuration is going to be"

> +config PWM_TWL
> +	tristate "TWL4030/6030 PWM support"
> +	select HAVE_PWM

Why do you select HAVE_PWM?

> +static int twl_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +			      int duty_ns, int period_ns)
> +{
> +	int duty_cycle =3D DIV_ROUND_UP(duty_ns * TWL_PWM_MAX, period_ns);
> +	u8 pwm_config[2] =3D {1, 0};
> +	int base, ret;
> +
> +	/*
> +	 * To configure the duty period:
> +	 * On-cycle is set to 1 (the minimum allowed value)
> +	 * The off time of 0 is not configurable, so the mapping is:
> +	 * 0 -> off cycle =3D 2,
> +	 * 1 -> off cycle =3D 2,
> +	 * 2 -> off cycle =3D 3,
> +	 * 126 - > off cycle 127,
> +	 * 127 - > off cycle 1
> +	 * When on cycle =3D=3D off cycle the PWM will be always on
> +	 */
> +	duty_cycle +=3D 1;

The canonical form to write this would be "duty_cycle++", but maybe it
would even be better to add it to the expression that defines
duty_cycle?

> +static int twl4030_pwm_enable(struct pwm_chip *chip, struct pwm_device *=
pwm)
> +{
> +	int ret;
> +	u8 val;
> +
> +	ret =3D twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL4030_GPBR1_REG);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s: Failed to read GPBR1\n", pwm->label);
> +		return ret;
> +	}
> +
> +	val |=3D TWL4030_PWM_TOGGLE(pwm->hwpwm, TWL4030_PWMXCLK_ENABLE);
> +
> +	ret =3D twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_GPBR1_REG);
> +	if (ret < 0)
> +		dev_err(chip->dev, "%s: Failed to enable PWM\n", pwm->label);
> +
> +	val |=3D TWL4030_PWM_TOGGLE(pwm->hwpwm, TWL4030_PWMX_ENABLE);
> +
> +	ret =3D twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_GPBR1_REG);
> +	if (ret < 0)
> +		dev_err(chip->dev, "%s: Failed to enable PWM\n", pwm->label);
> +
> +	return ret;
> +}

Does this perhaps need some locking to make sure the read-modify-write
sequence isn't interrupted?

> +static void twl4030_pwm_disable(struct pwm_chip *chip, struct pwm_device=
 *pwm)
> +{
> +	int ret;
> +	u8 val;
> +
> +	ret =3D twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL4030_GPBR1_REG);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s: Failed to read GPBR1\n", pwm->label);
> +		return;
> +	}
> +
> +	val &=3D ~TWL4030_PWM_TOGGLE(pwm->hwpwm, TWL4030_PWMX_ENABLE);
> +
> +	ret =3D twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_GPBR1_REG);
> +	if (ret < 0)
> +		dev_err(chip->dev, "%s: Failed to disable PWM\n", pwm->label);
> +
> +	val &=3D ~TWL4030_PWM_TOGGLE(pwm->hwpwm, TWL4030_PWMXCLK_ENABLE);
> +
> +	ret =3D twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_GPBR1_REG);
> +	if (ret < 0)
> +		dev_err(chip->dev, "%s: Failed to disable PWM\n", pwm->label);
> +}

Same here.

> +static int twl4030_pwm_request(struct pwm_chip *chip, struct pwm_device =
*pwm)
> +{
> +	struct twl_pwm_chip *twl =3D container_of(chip, struct twl_pwm_chip,
> +						chip);

This could use a macro like to_twl(chip).

> +	int ret;
> +	u8 val, mask, bits;
> +
> +	ret =3D twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL4030_PMBR1_REG);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s: Failed to read PMBR1\n", pwm->label);
> +		return ret;
> +	}
> +
> +	if (pwm->hwpwm) {
> +		/* PWM 1 */
> +		mask =3D TWL4030_GPIO7_VIBRASYNC_PWM1_MASK;
> +		bits =3D TWL4030_GPIO7_VIBRASYNC_PWM1_PWM1;
> +	} else {
> +		/* PWM 0 */
> +		mask =3D TWL4030_GPIO6_PWM0_MUTE_MASK;
> +		bits =3D TWL4030_GPIO6_PWM0_MUTE_PWM0;
> +	}
> +
> +	/* Save the current MUX configuration for the PWM */
> +	twl->twl4030_pwm_mux &=3D ~mask;
> +	twl->twl4030_pwm_mux |=3D (val & mask);
> +
> +	/* Select PWM functionality */
> +	val &=3D ~mask;
> +	val |=3D bits;
> +
> +	ret =3D twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_PMBR1_REG);
> +	if (ret < 0)
> +		dev_err(chip->dev, "%s: Failed to request PWM\n", pwm->label);
> +
> +	return ret;
> +}

Again, more read-modify-write without locking.

> +
> +static void twl4030_pwm_free(struct pwm_chip *chip, struct pwm_device *p=
wm)
> +{
> +	struct twl_pwm_chip *twl =3D container_of(chip, struct twl_pwm_chip,
> +						chip);
> +	int ret;
> +	u8 val, mask;
> +
> +	ret =3D twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL4030_PMBR1_REG);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s: Failed to read PMBR1\n", pwm->label);
> +		return;
> +	}
> +
> +	if (pwm->hwpwm)
> +		/* PWM 1 */
> +		mask =3D TWL4030_GPIO7_VIBRASYNC_PWM1_MASK;
> +	else
> +		/* PWM 0 */
> +		mask =3D TWL4030_GPIO6_PWM0_MUTE_MASK;

I'm not sure how useful these comments are. You have both an explicit
check for pwm->hwpwm to make it obvious that it isn't 0 and the mask
macros contain the PWM0 and PWM1 substrings respectively.

You could make it even more explicit perhaps by turning the check into:

	if (pwm->hwpwm =3D=3D 1)

But either way I think you can drop the /* PWM 1 */ and /* PWM 0 */
comments.

> +
> +	/* Restore the MUX configuration for the PWM */
> +	val &=3D ~mask;
> +	val |=3D (twl->twl4030_pwm_mux & mask);
> +
> +	ret =3D twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_PMBR1_REG);
> +	if (ret < 0)
> +		dev_err(chip->dev, "%s: Failed to free PWM\n", pwm->label);
> +}
> +
> +static int twl6030_pwm_enable(struct pwm_chip *chip, struct pwm_device *=
pwm)
> +{
> +	struct twl_pwm_chip *twl =3D container_of(chip, struct twl_pwm_chip,
> +						chip);
> +	int ret;
> +	u8 val;
> +
> +	val =3D twl->twl6030_toggle3;
> +	val |=3D TWL6030_PWM_TOGGLE(pwm->hwpwm, TWL6030_PWMXS | TWL6030_PWMXEN);
> +	val &=3D ~TWL6030_PWM_TOGGLE(pwm->hwpwm, TWL6030_PWMXR);
> +
> +	ret =3D twl_i2c_write_u8(TWL6030_MODULE_ID1, val, TWL6030_TOGGLE3_REG);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s: Failed to enable PWM\n", pwm->label);
> +		return ret;
> +	}
> +
> +	twl->twl6030_toggle3 =3D val;
> +
> +	return 0;
> +}
> +
> +static void twl6030_pwm_disable(struct pwm_chip *chip, struct pwm_device=
 *pwm)
> +{
> +	struct twl_pwm_chip *twl =3D container_of(chip, struct twl_pwm_chip,
> +						chip);
> +	int ret;
> +	u8 val;
> +
> +	val =3D twl->twl6030_toggle3;
> +	val |=3D TWL6030_PWM_TOGGLE(pwm->hwpwm, TWL6030_PWMXR);
> +	val &=3D ~TWL6030_PWM_TOGGLE(pwm->hwpwm, TWL6030_PWMXS | TWL6030_PWMXEN=
);
> +
> +	ret =3D twl_i2c_write_u8(TWL6030_MODULE_ID1, val, TWL6030_TOGGLE3_REG);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s: Failed to read TOGGLE3\n", pwm->label);
> +		return;
> +	}
> +
> +	val |=3D TWL6030_PWM_TOGGLE(pwm->hwpwm, TWL6030_PWMXS | TWL6030_PWMXEN);
> +
> +	ret =3D twl_i2c_write_u8(TWL6030_MODULE_ID1, val, TWL6030_TOGGLE3_REG);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s: Failed to disable PWM\n", pwm->label);
> +		return;
> +	}
> +
> +	twl->twl6030_toggle3 =3D val;
> +}
> +
> +static struct pwm_ops twl_pwm_ops =3D {
> +	.config =3D twl_pwm_config,
> +};

It might actually be worth to split this into two pwm_ops structures,
one for 4030 and one for 6030. In that case you would still be able to
make them const, which probably outweighs the space savings here.

Actually, I think this is even potentially buggy since you may have more
than one instance of this driver. For instance if you have a TWL6030 and
a TWL4030 in a single system this will break horribly since you'll over-
write the pwm_ops of one of them.

> +	if (twl_class_is_4030()) {
> +		twl_pwm_ops.enable =3D twl4030_pwm_enable;
> +		twl_pwm_ops.disable =3D twl4030_pwm_disable;
> +		twl_pwm_ops.request =3D twl4030_pwm_request;
> +		twl_pwm_ops.free =3D twl4030_pwm_free;

This would become:

		twl->chip.ops =3D &twl4030_pwm_ops;

> +	} else {
> +		twl_pwm_ops.enable =3D twl6030_pwm_enable;
> +		twl_pwm_ops.disable =3D twl6030_pwm_disable;

and:
		twl->chip.ops =3D &twl6030_pwm_ops;

> +static struct of_device_id twl_pwm_of_match[] =3D {
> +	{ .compatible =3D "ti,twl4030-pwm" },
> +	{ .compatible =3D "ti,twl6030-pwm" },
> +};
> +
> +MODULE_DEVICE_TABLE(of, twl_pwm_of_match);

Nit: I think the blank line between "};" and "MODULE_DEVICE_TABLE(...)"
can go away. And you might want to protect this with an "#ifdef
CONFIG_OF" since you don't depend on OF.

Thierry

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQr48kAAoJEN0jrNd/PrOhEQ8P/ib0KABVnAiOnU7W5E8DVIMw
QxiyM4mjzCNHvr+tAwYAk6cYngcbSVxNQcHkh/v6gu7rdfKIecuYYZIuJ+ky821L
+RZcH9PWKfZk2vl9adxWezli9pOhIGlYqvLNQXDGw18afyMH1wRxVP7gkY/kANEI
mdgMaLxXYc3JQS5undMU5mnShwy2Q0TUaMf0isVU4wJeUKlCGJIgvvECftq3SQ9u
7TvkE0zayu1Pzfz+s4RiGe2nLNjwYbF2wekQbr/lImsUxzZ4LHM+htK3PMH1J3zq
mz+opdCAhFoF5oK6bxWxdnNDABGtMNjZlEyWKaxgUDKvbBJYgJI4DSRCaZ/NMMBB
YXDiQgK08r1QbPs8o18bs/5kvryrnhA3FCgvty75LSD2HiA9O1mjIOgcgd1q40+p
0YAxsqLwsj2cZsERlZjOle6uKhPHY/fyvFWb7rYl6llnNO9nXObsPVloOKfRWngU
52+TzkHspdlkYrtQBEuhfaZGz7OnZFn7bESyzSsQPTIyoz8ewWGLaHj2ev7Vvhqv
0x6wRmKP9bOuhmVreOFM703pD/gAbAUo7S3gSoWzOrZmWS4wUwLA5HUwmbh3CmrP
gd2g2WtvBooO0KR4V9diHkGaY3dtardTEUXwdpaCkHFD4nMgjM93/PGCh2KMBtYo
/3sRUailrpChUSW5enxe
=uj7x
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
