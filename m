Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab2HTFFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:05:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57237 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab2HTFFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 01:05:04 -0400
Date: Mon, 20 Aug 2012 07:04:52 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <bryan.wu@canonical.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds-lm3530: replace pwm platform functions with generic
 pwm functions
Message-ID: <20120820050452.GA16729@avionic-0098.adnet.avionic-design.de>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:DGftl7qKZ36UwglWF39AEA56kDXfbaxnTrx4iP0kGv7
 be2uO2seMOtAs2v17otUYtMiDiKoBtne0lOdawgsdY04ba1oOI
 BSBl++/aybz3XDmBls8QBMORDRgXpXPJPAT+sol9kVlmeOOpWF
 14EhZ0uY1AC54VMoojiIzjDCwRyXr6ElIEKELCqqdu1y9d1Zpo
 YGWhramsQyr9JcLff9Hy1bwf2PW4Gp4/APQFXhrZhSuyl2l7jh
 L0UhDJwbfkyR0Jp79/m4URjl/NSKDcUdEvKIlESZ/5B/v65Ocj
 6Xmz01pVDXx0b8+29YLNzeJ4v/nilwapkJZEE3CvTLRxk8jaMl
 um5IKiCVkTMAoR4wonXcCenqYkoeu+mtvz7zju4a3wh1PuRiY9
 8wN610IRtAU4s1c1hn6wC1osQcqkGZaTVk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 20, 2012 at 04:02:05AM +0000, Kim, Milo wrote:
> use generic pwm functions for changing the duty rather than the platform =
data

pwm -> PWM, duty -> duty-cycle

There are more occurrences of "pwm"scattered through the file, please
fix those as well.

> @@ -153,6 +158,64 @@ static int lm3530_get_mode_from_str(const char *str)
>  	return -1;
>  }
> =20
> +#ifdef CONFIG_PWM
> +static int lm3530_pwm_request(struct lm3530_data *drvdata)
> +{
> +	int pwm_id;
> +
> +	/* if the pwm device exists, skip requesting the device */
> +	if (drvdata->pwm)
> +		return 0;
> +
> +	pwm_id =3D drvdata->pdata ? drvdata->pdata->pwm_id : 0;
> +
> +	drvdata->pwm =3D pwm_request(pwm_id, "lm3530-pwm");

Please don't use pwm_id and pwm_request() for new code. You should be
using pwm_get() along with a corresponding PWM_LOOKUP() entry.

> +	drvdata->period_ns =3D drvdata->pdata ? drvdata->pdata->period_ns : 0;
> +
> +	return IS_ERR(drvdata->pwm) ? PTR_ERR(drvdata->pwm) : 0;

This is "PTR_RET(drvdata->pwm)".

> +}
> +
> +static void lm3530_pwm_set(struct lm3530_data *drvdata,
> +			int brightness, int max_brightness)
> +{
> +	struct pwm_device *pwm =3D drvdata->pwm;
> +
> +	if (pwm) {

Maybe this check should be:

	if (pwm && drvdata->period_ns > 0)

> @@ -363,9 +418,15 @@ static ssize_t lm3530_mode_set(struct device *dev, s=
truct device_attribute
> =20
>  	drvdata->mode =3D mode;
> =20
> -	/* set pwm to low if unnecessary */
> -	if (mode !=3D LM3530_BL_MODE_PWM && pwm->pwm_set_intensity)
> -		pwm->pwm_set_intensity(0, max_brightness);
> +	/* if new mode is pwm, then request a pwm device.
> +	   otherwise, set pwm to low */
> +	if (mode =3D=3D LM3530_BL_MODE_PWM) {
> +		err =3D lm3530_pwm_request(drvdata);
> +		if (err)
> +			return err;
> +	} else {
> +		lm3530_pwm_set(drvdata, 0, max_brightness);
> +	}

Don't you need to free the PWM if mode is set to !LM3530_BL_MODE_PWM?

Thierry

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQMcV0AAoJEN0jrNd/PrOhuQEP/36NKcQAovH3fKVioEoc2FpD
4xq12Sk0MvZIDHxOh9HaEdxxOXzpT6JFpnE7fh5QLvyo5OJPEshJVMZhaTSG7VnO
MxMN1W60HrhDs445Y3yPgQjPRpBxk53398YBDjNARnnzyvCcx8auEEFsSAjB03JR
xfX9UiM3BgWmq08yy3jv+98STkvy8ilTvhU3M/RUGCDgk41N9SvaCa85Xib1bvTh
FmRXudPBttZkhpGQnRO/ckv8e/OOiB0GwhAm3O6wamweH8I6zMqawftORKM4Izyg
Sv8C1FrNOhEFtML68aOm3mW/evDnoerRL2U2UUXYP+TuElFYfWpEbzILAz0BZP6H
IXU/xZmPalau6HfuRIpuEvu2LPMCxf7zUQ5wJYsGcbiZQF6TgK4FKEdgl9AUr8Xw
pZ6lEFvkDgQmGPIr53uCBDTVdaryZtFVKipfKTYtO54WN73L4tsMFKtg98Nc7bZV
dZKjctTmCxENcaQA9ShNFFnXTR1/9CS2uXgxtFbedl4Ms/1CQs5kRe1UBaowm+fX
LD2syrecA4DREWmDw8vGtlzBCAWbHS0ZjzdA4KK1UG/0j3ZfVnl8ilRJLVHNUgcW
MFAwjBxxzz1LHEGBC6nPF1YF1kYKX9v+yRNKykZ85lskyP+1/nq0FlWFKEB0g+F4
suUgd0rV4SjpA5sj6QOl
=nDP7
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
