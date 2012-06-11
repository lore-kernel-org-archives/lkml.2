Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab2FKTF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:05:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60875 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2FKTF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:05:58 -0400
Date: Mon, 11 Jun 2012 21:05:50 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 09/14] i2c: Add Device Tree support to the Nomadik I2C
 driver
Message-ID: <20120611190550.GK3887@pengutronix.de>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
 <1339428307-3850-10-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OX2aLCKeO1apYW07"
Content-Disposition: inline
In-Reply-To: <1339428307-3850-10-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OX2aLCKeO1apYW07
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 11, 2012 at 04:25:02PM +0100, Lee Jones wrote:
> Here we move the i2c-nomadik's default settings into the driver
> rather than specifying them from platform code. At the time of
> this writing we only have one user, the u8500. As new users are
> added, it is expected that they will be Device Tree compliant.
> If this is the case, we will look up their initialisation values
> by compatible entry, then apply them forthwith.
>=20
> Cc: linux-i2c@vger.kernel.org
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/i2c/busses/i2c-nomadik.c |   40 ++++++++++++++++++++++++++++++++=
+++++-
>  1 file changed, 39 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-no=
madik.c
> index a92440d..1ffdf67 100644
> --- a/drivers/i2c/busses/i2c-nomadik.c
> +++ b/drivers/i2c/busses/i2c-nomadik.c
> @@ -23,6 +23,7 @@
>  #include <linux/io.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/of_device.h>
> =20
>  #include <plat/i2c.h>
> =20
> @@ -899,15 +900,51 @@ static const struct i2c_algorithm nmk_i2c_algo =3D {
>  	.functionality	=3D nmk_i2c_functionality
>  };
> =20
> +static struct nmk_i2c_controller u8500_i2c =3D {
> +       /*
> +        * slave data setup time, which is
> +        * 250 ns,100ns,10ns which is 14,6,2
> +        * respectively for a 48 Mhz
> +        * i2c clock
> +        */
> +       .slsu           =3D 0xe,
> +       /* Tx FIFO threshold */

Please put these comments directly after the members they describe.

And make sure you use tabs for indentation all over the patch instead of
spaces. checkpatch.pl will help you to get the formal things right.

> +       .tft            =3D 1,
> +       /* Rx FIFO threshold */
> +       .rft            =3D 8,
> +       /* std. mode operation */
> +       .clk_freq       =3D 100000,
> +       .timeout        =3D 200,	/* Slave response timeout(ms) */
> +       .sm             =3D I2C_FREQ_MODE_FAST,
> +};
> +
> +
> +static const struct of_device_id nmk_gpio_match[] =3D {
> +	{ .compatible =3D "st,nomadik-i2c", .data =3D &u8500_i2c, },
> +	{}
> +};
> +
>  static int __devinit nmk_i2c_probe(struct platform_device *pdev)
>  {
>  	int ret =3D 0;
>  	struct resource *res;
> -	struct nmk_i2c_controller *pdata =3D
> +	const struct nmk_i2c_controller *pdata =3D
>  			pdev->dev.platform_data;
> +        const struct of_device_id *of_id =3D
> +                        of_match_device(nmk_gpio_match, &pdev->dev);
>  	struct nmk_i2c_dev	*dev;
>  	struct i2c_adapter *adap;
> =20
> +	if (!pdata) {
> +		if (of_id && of_id->data)
> +			/* Looks like we're booting via Device Tree. */
> +			pdata =3D of_id->data;
> +		else
> +			/* No i2c configuration found, using the default. */
> +			pdata =3D &u8500_i2c;
> +	}
> +
>  	dev =3D kzalloc(sizeof(struct nmk_i2c_dev), GFP_KERNEL);
>  	if (!dev) {
>  		dev_err(&pdev->dev, "cannot allocate memory\n");
> @@ -1043,6 +1080,7 @@ static struct platform_driver nmk_i2c_driver =3D {
>  		.owner =3D THIS_MODULE,
>  		.name =3D DRIVER_NAME,
>  		.pm =3D &nmk_i2c_pm,
> +		.of_match_table =3D nmk_gpio_match,
>  	},
>  	.probe =3D nmk_i2c_probe,
>  	.remove =3D __devexit_p(nmk_i2c_remove),
> --=20

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--OX2aLCKeO1apYW07
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/WQY4ACgkQD27XaX1/VRu0rwCgk7ygEwn1KJx72o3I8FGSppey
aRMAnA5eofGrGBbKWGnxN2ZWpSGRCC8b
=hkdw
-----END PGP SIGNATURE-----

--OX2aLCKeO1apYW07--
