Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1LEIwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 03:52:34 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:38289 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602Ab1LEIwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 03:52:33 -0500
Date: Mon, 5 Dec 2011 10:52:28 +0200
From: Felipe Balbi <balbi@ti.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: rpurdie@rpsys.net, ben-linux@fluff.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: Re: [PATCH] backlight: add regulator support for platform_lcd driver
Message-ID: <20111205085228.GF9900@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1323074921-29291-1-git-send-email-thomas.abraham@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZFKeWUZP29EKQNE"
Content-Disposition: inline
In-Reply-To: <1323074921-29291-1-git-send-email-thomas.abraham@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZFKeWUZP29EKQNE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 05, 2011 at 02:18:41PM +0530, Thomas Abraham wrote:
> The power source to the lcd panel or the lcd interface such as lvds
> transmitters could be controlled by a regulator supply. Add support
> for enabling/disabling the regulator when switching power to lcd.
>=20
> Two new elements 'min_uV' and 'max_uV' in the platform data are added
> to allow platform code to specifiy the desired output voltage from the
> regulator.
>=20
> Cc: Ben Dooks <ben-linux@fluff.org>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  drivers/video/backlight/platform_lcd.c |   29 ++++++++++++++++++++++++++=
+++
>  include/video/platform_lcd.h           |    7 +++++++
>  2 files changed, 36 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backl=
ight/platform_lcd.c
> index 302330a..ffa8108 100644
> --- a/drivers/video/backlight/platform_lcd.c
> +++ b/drivers/video/backlight/platform_lcd.c
> @@ -17,6 +17,8 @@
>  #include <linux/backlight.h>
>  #include <linux/lcd.h>
>  #include <linux/slab.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/regulator/machine.h>
> =20
>  #include <video/platform_lcd.h>
> =20
> @@ -44,11 +46,38 @@ static int platform_lcd_get_power(struct lcd_device *=
lcd)
>  static int platform_lcd_set_power(struct lcd_device *lcd, int power)
>  {
>  	struct platform_lcd *plcd =3D to_our_lcd(lcd);
> +	struct regulator *lcd_regulator;
>  	int lcd_power =3D 1;
> =20
>  	if (power =3D=3D FB_BLANK_POWERDOWN || plcd->suspended)
>  		lcd_power =3D 0;
> =20
> +	/*
> +	 * If power to lcd and/or lcd interface is controlled using a regulator,
> +	 * enable or disable the regulator based in the power setting.
> +	 */
> +	lcd_regulator =3D regulator_get(plcd->us, "vcc_lcd");
> +	if (IS_ERR(lcd_regulator)) {
> +		dev_info(plcd->us, "could not get regulator\n");
> +		goto set_power;
> +	}
> +
> +	if (lcd_power) {
> +		if (plcd->pdata->min_uV || plcd->pdata->max_uV)
> +			if (regulator_set_voltage(lcd_regulator,
> +				plcd->pdata->min_uV, plcd->pdata->max_uV))
> +				dev_info(plcd->us,
> +					"regulator voltage set failed\n");
> +
> +		if (regulator_enable(lcd_regulator))
> +			dev_info(plcd->us, "failed to enable regulator\n");
> +	} else {
> +		regulator_disable(lcd_regulator);
> +	}
> +
> +	regulator_put(lcd_regulator);

I wonder why you ->get() and ->put() everytime here. Wouldn't it be
enough to ->get() on probe() and ->put() on remove() ??

--=20
balbi

--LZFKeWUZP29EKQNE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO3IZMAAoJEIaOsuA1yqREGU4QAKCY3AIwHk59wSShGzUeGRHZ
g/IZQD1yqPi1v9mww5nynP/PnHIJbF1RJKLS9t7sQJnD6ZkUDTSKFKPucsoP92ID
SKKRAOFrHrOjC0eEvWIwaOK+veDOZdaXYEdrH9qL0+qrpjURpcXO9wmHMFteFlt3
dKHt/aOPjxp95NK7TMNGIFBBcUeJOH0Yk+fjGvPoHUJurLXA2bmr3fRLapztNBMh
y+AXH18DKiSmF5cK24++9gFfKGOJe/5p1kd+KaML00h7cRhvU7Lvv0haJlWnBGaH
9hzF9s/gvlBPNJoI5TyIZ9mZbwZNVkfc8Oqz1DQ5Srz9WIXfHTjUXwxb/f1TGs4C
F061hKnpfh4K+t18oF4ZoNRA7HmtKpgac14eUGLj1jKWOrUmieBr/hgL0/c7HH15
clm8YQubDBY3qdM8nyjtzbMu05L8vDIUqAVf2Dw/eAj6RG54G4kNKjL67NRF52Vm
uUZ4uBJnlGQiWJIVxW8VpfBZOq39S1QPAvA4OKzPvZAfr5sV/oVb9BxVS+tKcSqI
HHEZsABbsGf3ZLNNFHlMld1WqfC8Uqul9mAG8Y9vPJGp0U5nP2chUi7hBWKNYkOl
OqzmE4XET02tWyA5fEmCBzh45iPNu36xvzmsWvgqWfX5t9xiLKim81Bxfy5DCuys
zHW9mLxbQ8JC0Dp+Cptd
=argN
-----END PGP SIGNATURE-----

--LZFKeWUZP29EKQNE--
