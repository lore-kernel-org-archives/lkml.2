Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3ACIIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 03:08:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab3ACIII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 03:08:08 -0500
Date: Thu, 3 Jan 2013 09:08:03 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v2 2/2] backlight: add new lp8788 backlight driver
Message-ID: <20130103080803.GB30631@avionic-0098.adnet.avionic-design.de>
References: <A874F61F95741C4A9BA573A70FE3998F69E108D2@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2B/JsCI69OhZNC5r"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E108D2@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:KTEXjt9P12xNHIhIXxTR27ZFA0ZWNzvpcjKl4mWoZzf
 UAw+TMyxKiCJAiTqr1tU8KgDGMK0/3o34DmNmfuImWrPS8URg3
 LHD2AKXqeYXNGbh3x8gxQQLFGAporWMNBb1hOilue2SktJkZAb
 NB7uApn3DO7D/14dxBknMpddj3Wwkme45phVwx0HpopvBpFTCW
 MrzHIQDOhKssD5AbkzRNpmpzsco3fNEX+6mb8X40zGoZPpzo4F
 3TY1nsUdY/CC3qXDXYhW7ClwlIBYYrP3nyB7eXlDdhuv0FUHCv
 KkXmvOCD6t4RRgDphgdIRQKRCmEwWSIDFf7iQIZ9+LZ8aAFx+/
 5p6x9F91CVJv8CwyJLZ7v/vKU24R6W/XvCeNSM3SEIJK/FslHj
 dRGSPsuis5cYP+hJOGHjHfubaDD5DNZUwYxQhPLrMA9CbSZ/9L
 4Q3dw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2B/JsCI69OhZNC5r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 21, 2012 at 07:55:23AM +0000, Kim, Milo wrote:
> TI LP8788 PMU supports regulators, battery charger, RTC, ADC, backlight d=
river
> and current sinks.
> This patch enables LP8788 backlight module.
>=20
> (Brightness mode)
> The brightness is controlled by PWM input or I2C register.
> All modes are supported in the driver.
>=20
> (Platform data)
> Configurable data can be defined in the platform side.
>  name                  : backlight driver name. (default: "lcd-backlight")
>  initial_brightness    : initial value of backlight brightness
>  bl_mode               : brightness control by PWM or lp8788 register
>  dim_mode              : dimming mode selection
>  full_scale            : full scale current setting
>  rise_time             : brightness ramp up step time
>  fall_time             : brightness ramp down step time
>  pwm_pol               : PWM polarity setting when bl_mode is PWM based

You might want to consider using enum pwm_polarity from linux/pwm.h
instead and convert to the driver representation internally.

I'm saying this because I'm thinking about extending the PWM framework
to allow PWM polarity and period to be specified in the PWM lookup table
so that they can be treated transparently, independent of whether they
are obtained from DT or the lookup table.

That would allow the polarity and period to be retrieved with accessors
like pwm_get_polarity() and pwm_get_period().

>  period_ns             : platform specific PWM period value. unit is nano.

If the period can be encoded in the PWM lookup table this can also go
away. But for now it's fine to keep it as the changes aren't in place
yet.

> diff --git a/drivers/video/backlight/lp8788_bl.c b/drivers/video/backligh=
t/lp8788_bl.c
[...]
> +/* register address */
> +#define LP8788_BL_CONFIG		0x96
> +#define LP8788_BL_BRIGHTNESS		0x97
> +#define LP8788_BL_RAMP			0x98
> +
> +/* mask/shift bits */
> +#define LP8788_BL_EN			BIT(0)	/* Addr 96h */
> +#define LP8788_BL_PWM_EN		BIT(5)
> +#define LP8788_BL_FULLSCALE_S		2
> +#define LP8788_BL_DIM_MODE_S		1
> +#define LP8788_BL_PWM_POLARITY_S	6
> +#define LP8788_BL_RAMP_RISE_S		4	/* Addr 98h */

The ordering of the defines confuses me. I know you've put comments in
place to explain which registers the individual bits/fields belong to,
but I think it would be much clearer if the field definitions were to
immediately follow the register addresses:

#define LP8788_BL_CONFIG		0x96
#define LP8788_BL_EN			BIT(0)
#define LP8788_BL_PWM_EN		BIT(5)
=2E..
#define LP8788_BL_RAMP			0x98
#define LP8788_BL_RAMP_RISE_S		4

While at it, maybe change the _S suffix to _SHIFT, which seems to be
more commonly used. Also the PWM_EN bit has an unfortunate name. It
doesn't enable any PWM but, judging by the code, rather configures the
hardware to use a PWM input to control brightness. Maybe something like
USE_PWM would be more accurate. Or is the name taken from the datasheet?
In that case there might be some value in keeping it.

> +static inline bool is_brightness_ctrl_by_pwm(enum lp8788_bl_ctrl_mode mo=
de)
> +{
> +	return (mode =3D=3D LP8788_BL_COMB_PWM_BASED);
> +}
> +
> +static inline bool is_brightness_ctrl_by_register(enum lp8788_bl_ctrl_mo=
de mode)
> +{
> +	return (mode =3D=3D LP8788_BL_REGISTER_ONLY ||
> +		mode =3D=3D LP8788_BL_COMB_REGISTER_BASED);
> +}
> +
> +static int lp8788_backlight_configure(struct lp8788_bl *bl)
> +{
> +	struct lp8788_backlight_platform_data *pdata =3D bl->pdata;
> +	struct lp8788_bl_config *cfg =3D &default_bl_config;
> +	int ret;
> +	u8 val;
> +
> +	/* update chip configuration if platform data exists,
> +	   otherwise use the default settings */

CodingStyle says this should be:

	/*
	 * Update chip configuration if platform data exists,
	 * otherwise use the default settings.
	 */

> +	/* brightness ramp up/down */
> +	val =3D (cfg->rise_time << LP8788_BL_RAMP_RISE_S) | cfg->fall_time;
> +	ret =3D lp8788_write_byte(bl->lp, LP8788_BL_RAMP, val);
> +	if (ret) {
> +		/* no I2C needed in case of pwm control mode */
> +		if (is_brightness_ctrl_by_pwm(cfg->bl_mode))
> +			goto no_err;
> +		else
> +			return ret;
> +	}

In that case, shouldn't you rather move the is_brightness_ctrl_by_pwm()
check up and only write the RAMP register if required? If RAMP doesn't
have any effect in PWM control mode, then you don't need to write it.

And I'd prefer if PWM was consistently spelled with all capitals in
text. There are a few other occurrences in the rest of the patch.

> +static ssize_t lp8788_get_bl_ctl_mode(struct device *dev,
> +				     struct device_attribute *attr, char *buf)
> +{
> +	struct lp8788_bl *bl =3D dev_get_drvdata(dev);
> +	enum lp8788_bl_ctrl_mode mode =3D bl->mode;
> +	char *strmode;
> +
> +	if (is_brightness_ctrl_by_pwm(mode))
> +		strmode =3D "pwm based";
> +	else if (is_brightness_ctrl_by_register(mode))
> +		strmode =3D "register based";
> +	else
> +		strmode =3D "invalid mode";
> +
> +	return scnprintf(buf, BUF_SIZE, "%s\n", strmode);
> +}

According to Documentation/filesystems/sysfs.txt, buf is always a whole
page, so you can use PAGE_SIZE instead of BUF_SIZE.

Thierry

--2B/JsCI69OhZNC5r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ5TxjAAoJEN0jrNd/PrOhMGIP/2KVKOH7skKmwyIJR4dF/k6R
Da8GVHSsdUBEeHozTeNjD0gHLO0dNvvcA41/tJ0VHcDW1m8GM3d20wSkam7s58Z1
rURGx8s0c4MGvWwdG+Wg7Du9Zm2mKM3ryPdJOyeaJLTtItaLQ4fxW3p5EwPDzrgW
F7l+34a+ThrfV9Kx6AxZGviPr/XVdHz4aF1vPKRh+XDAVPbza+rzec+vuKJV7Ix4
yxZuXeAXYd2EWAd7bUEiGf8XwCFFp/xn3N6O3xP5yKdCoZA3XqdiQetQl/Qr7Uvw
NQwbA8VJowtcCj8PFek9PR0oo4keYj1ugVdIhsjPp0UL+0RFcUq7uNy1+Satqu+p
XIPEMvn1ejxxHY4ePgUqEM6Nbm+MN/udxLA0JU4h0a0KiXmyvA+/2HFoZyMkDGFV
SgS7OZ/E2Sz/Am2GFe/d2dPXdWhcvjpudw+jxHEL1YeRzqvmJidgU4JorkGLM7mV
dyYNeaUuyzeD1xdFBoVIRBoa+z1kq7auIf01kha88NDzuFXwc0rQ+KixvTlpFpo7
SyUJH8MMhDck3NwzwkG3GGHH3/lDGw1nblhGvcj9PN9zeq2wnd/dbCvw80VhAuky
CYIP4pqFuDQ3IHl6eJq+f1T/FpE180ZgGoSRy592Snmg468PsdN864ZmOOJG8t/b
R9nUZvs9DZ96TaHsj2wY
=O+zH
-----END PGP SIGNATURE-----

--2B/JsCI69OhZNC5r--
