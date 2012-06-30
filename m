Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab2F3Shz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 14:37:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65316 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2F3Shx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 14:37:53 -0400
Date: Sat, 30 Jun 2012 20:37:42 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
Message-ID: <20120630183742.GE23990@avionic-0098.adnet.avionic-design.de>
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d8Lz2Tf5e5STOWUP"
Content-Disposition: inline
In-Reply-To: <1340976167-27298-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:jdViOFKISi6IkPB2DDrQtpgr70irmT56lhXwxEI2QKV
 7lN2IIykSL2L5r1sfNcAWgkqE2jvW2EDe9pOqZ4WDVifn+QmLg
 SAl0jFMYPN2svibgYDHAjb0SVHG2p9wwdugrZ/6QyLTYelEA8s
 HZNqdB72yIcrG5ykmMeiB48M04OUfy98UTT1rSnjc1jldjTeJJ
 xEj85Oy9mK0RpInNziOUm7Hikbz6EPsacqRcJKMxJvW2FooYjE
 SG4i7CjRmWZovHiHDMlEh/lAjvo4UyU4VjuCr0OOI+j8Fwo56F
 nEWqQP+fllrSgmgf7umLZdOEWd97uNsdiBL9Ht86Y5ujWA0jW+
 gNLsWFN4hxrFd4nkLJfmCET7N3LisYBK9B3ZLFNi4zwP2LfCDN
 lIp8HFdNQun1bqmhES8W3xO/Pzs0Ia2hng=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d8Lz2Tf5e5STOWUP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 29, 2012 at 10:22:47PM +0900, Alexandre Courbot wrote:
> Add support for an optional power regulator and enable/disable GPIO.
> This scheme is commonly used in embedded systems.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

I've added some comments in addition to those by Stephen.

[...]
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/p=
wm_bl.c
> index 057389d..821e03e 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
[...]
> @@ -141,11 +178,14 @@ static int pwm_backlight_parse_dt(struct device *de=
v,
>  		data->max_brightness--;
>  	}
> =20
> -	/*
> -	 * TODO: Most users of this driver use a number of GPIOs to control
> -	 *       backlight power. Support for specifying these needs to be
> -	 *       added.
> -	 */
> +	ret =3D of_get_named_gpio(node, "enable-gpios", 0);
> +	if (ret >=3D 0) {
> +		data->enable_gpio =3D of_get_named_gpio(node, "enable-gpios", 0);

Can't you just reuse the value of ret here?

[...]
> @@ -231,6 +271,22 @@ static int pwm_backlight_probe(struct platform_devic=
e *pdev)
>  	if (data->pwm_period_ns > 0)
>  		pwm_set_period(pb->pwm, data->pwm_period_ns);
> =20
> +
> +	pb->power_reg =3D devm_regulator_get(&pdev->dev, "power");
> +	if (IS_ERR(pb->power_reg))
> +		return PTR_ERR(pb->power_reg);
> +
> +	pb->enable_gpio =3D -EINVAL;

Perhaps initialize this to -1? Assigning standard error codes to a GPIO
doesn't make much sense.

[...]
> diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
> index 56f4a86..5ae2cd0 100644
> --- a/include/linux/pwm_backlight.h
> +++ b/include/linux/pwm_backlight.h
> @@ -18,6 +18,11 @@ struct platform_pwm_backlight_data {
>  	void (*notify_after)(struct device *dev, int brightness);
>  	void (*exit)(struct device *dev);
>  	int (*check_fb)(struct device *dev, struct fb_info *info);
> +	/* optional GPIO that enables/disables the backlight */
> +	int enable_gpio;
> +	/* 0 (default initialization value) is a valid GPIO number. Make use of
> +	 * control gpio explicit to avoid bad surprises. */
> +	bool use_enable_gpio;

It's a shame we have to add workarounds like this...

Also the canonical form to write multi-line comments would be:

	/*
	 * 0 (default ...
	 * ... surprises.
	 */

Thierry

--d8Lz2Tf5e5STOWUP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP70d2AAoJEN0jrNd/PrOhU3YP/3L2cNuL0cfRTwXEGz65lGWL
WeMsAA48uFnLUboPCJzr6ivrcdLzOPKDY80YCgxUItiyyUoCfHQifNYf4aiXN2D4
4FXwSOAu/WjCPOaShGU1fNbs08QgWoFRO2My8lFzs6vDUpFbyyU7IiWHMtv6XGVI
ddk9A6/uxRwp9XqrN9IhEjywyo/jHA6Q39Y9VhIupvZBtMpbqsqTba7da4XprWzN
9jzYqYfs0Vs5dEy0k8T2s01wjDGymviba/DLvWD35CVNGKX6XGYo88lOWWyEf7tj
/oFL34OxE9pd9dEZcPVDC9GMNV5F5pfNAZtuK1vMkUJdtuVOkYJnNLm9xfclyhjS
K2VvDXqsG+40Z0WX2LyJwwd+RCcnVu7hpVJcCK/ys9tW7yB5+c01b605een6nW3c
yI0ba2/Fz98YlUk1olYDf+GyatObRpqDk6LkMWsYb6kyYi3MSHg4tIYCguGV7NJl
XHQC111nRKF+GqUskyTnk6ytZGSa6CWDAUuEt1Zwe+d7iBapbeTWSFLOrUFPNSTX
e7HiHLHLCdaagbIcX5+rufya8YnS/7mVs7lgoSt8oCj+UCRMBS24MSUPwlMf/NQo
1qQ04Pokk/fUjodltrbTVbMxGTpG4r2PCbIqOIP78gX59guRaCzZAWYqh5zciRSC
zybrQVwdOEI/jdmpcfmq
=Bqai
-----END PGP SIGNATURE-----

--d8Lz2Tf5e5STOWUP--
