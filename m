Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1CBN25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 08:28:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60311 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab1CBN2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 08:28:55 -0500
Date: Wed, 2 Mar 2011 14:28:33 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Fabien Marteau <fabien.marteau@armadeus.com>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        =?iso-8859-15?Q?=22Uwe_Kleine-K=F6nig=22?= 
	<u.kleine-koenig@pengutronix.de>,
        Arnaud Patard <apatard@mandriva.com>, Tejun Heo <tj@kernel.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Adding mangling capability to i2c imx bus
 controller.
Message-ID: <20110302132833.GA2207@pengutronix.de>
References: <4D46D571.5010907@armadeus.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <4D46D571.5010907@armadeus.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fabien,

thanks for your patch. Nice addition.

On Mon, Jan 31, 2011 at 04:29:53PM +0100, Fabien Marteau wrote:
> Adding Mangling capability to i2c imx bus controller.

Can you give a rough description how you tested it?

> Signed-off-by: Fabien Marteau <fabien.marteau@armadeus.com>
> ---
> Index: linux-2.6.36/drivers/i2c/busses/i2c-imx.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.36.orig/drivers/i2c/busses/i2c-imx.c	2010-10-20 22:30:22.00=
0000000 +0200
> +++ linux-2.6.36/drivers/i2c/busses/i2c-imx.c	2011-01-31 16:23:34.0000000=
00 +0100
> @@ -300,17 +300,28 @@

Please use "--show-c-function" for diff/quilt. This makes reviewing a
tad easier.

>  {
>  	int i, result;
>=20
> -	dev_dbg(&i2c_imx->adapter.dev, "<%s> write slave address: addr=3D0x%x\n=
",
> -		__func__, msgs->addr << 1);
> +	if ((msgs->flags & I2C_M_NOSTART) =3D=3D 0) {

Please use !flag instead of =3D=3D 0 as it is done in the rest of the
driver.

> +		/* write slave address */
> +		if (msgs->flags & I2C_M_REV_DIR_ADDR) {
> +			dev_dbg(&i2c_imx->adapter.dev,
> +				"<%s> write slave address: addr=3D0x%x\n",
> +				__func__, msgs->addr << 1 | 0x01);
> +			writeb((msgs->addr << 1) | 0x01,
> +			       i2c_imx->base + IMX_I2C_I2DR);
> +		} else {
> +			dev_dbg(&i2c_imx->adapter.dev,
> +				"<%s> write slave address: addr=3D0x%x\n",
> +				__func__, msgs->addr << 1);
> +			writeb((msgs->addr << 1), i2c_imx->base + IMX_I2C_I2DR);
> +		}

What about:

	dev_dbg();
	writeb(msgs->addr << 1 | !!(msg->flags & I2C_M_REV_DIR_ADDR));

Hmm, probably more readable would be

	write_flag =3D (msg->flags & I2C_M_REV_DIR_ADDR) ? I2C_SMBUS_READ : I2C_SM=
BUS_WRITE

and use that? Also, not sure about the additional dev_dbg.

> +		result =3D i2c_imx_trx_complete(i2c_imx);
> +		if (result)
> +			return result;
> +		result =3D i2c_imx_acked(i2c_imx);
> +		if (result !=3D 0)

if (result)

> +			return result;
> +	}
>=20
> -	/* write slave address */
> -	writeb(msgs->addr << 1, i2c_imx->base + IMX_I2C_I2DR);
> -	result =3D i2c_imx_trx_complete(i2c_imx);
> -	if (result)
> -		return result;
> -	result =3D i2c_imx_acked(i2c_imx);
> -	if (result)
> -		return result;
>  	dev_dbg(&i2c_imx->adapter.dev, "<%s> write data\n", __func__);
>=20
>  	/* write data */
> @@ -323,7 +334,7 @@
>  		if (result)
>  			return result;
>  		result =3D i2c_imx_acked(i2c_imx);
> -		if (result)
> +		if ((result !=3D 0) && ((msgs[0].flags & I2C_M_IGNORE_NAK) =3D=3D 0))

if (result && !(msgs[0].flags & I2C_M_IGNORE_NAK))

>  			return result;
>  	}
>  	return 0;
> @@ -334,18 +345,27 @@
>  	int i, result;
>  	unsigned int temp;
>=20
> -	dev_dbg(&i2c_imx->adapter.dev,
> -		"<%s> write slave address: addr=3D0x%x\n",
> -		__func__, (msgs->addr << 1) | 0x01);
> -
> -	/* write slave address */
> -	writeb((msgs->addr << 1) | 0x01, i2c_imx->base + IMX_I2C_I2DR);
> -	result =3D i2c_imx_trx_complete(i2c_imx);
> -	if (result)
> -		return result;
> -	result =3D i2c_imx_acked(i2c_imx);
> -	if (result)
> -		return result;
> +	if ((msgs->flags & I2C_M_NOSTART) =3D=3D 0) {

!flag

> +		/* write slave address */
> +		if (msgs->flags & I2C_M_REV_DIR_ADDR) {
> +			dev_dbg(&i2c_imx->adapter.dev,
> +			"<%s> write slave address: addr=3D0x%x\n",
> +			__func__, (msgs->addr << 1));
> +			writeb((msgs->addr << 1), i2c_imx->base + IMX_I2C_I2DR);
> +		} else {
> +			dev_dbg(&i2c_imx->adapter.dev,
> +			"<%s> write slave address: addr=3D0x%x\n",
> +			__func__, (msgs->addr << 1) | 0x01);
> +			writeb((msgs->addr << 1) | 0x01,
> +			       i2c_imx->base + IMX_I2C_I2DR);
> +		}

Please fix similar to above.

> +		result =3D i2c_imx_trx_complete(i2c_imx);
> +		if (result)
> +			return result;
> +		result =3D i2c_imx_acked(i2c_imx);
> +		if (result !=3D 0)

if (result)

> +			return result;
> +	}
>=20
>  	dev_dbg(&i2c_imx->adapter.dev, "<%s> setup bus\n", __func__);
>=20
> @@ -405,7 +425,7 @@
>=20
>  	/* read/write data */
>  	for (i =3D 0; i < num; i++) {
> -		if (i) {
> +		if (i && ((msgs[i].flags & I2C_M_NOSTART) =3D=3D 0)) {

if (i && !(flag))

(Please check for other occasions, I might have missed one)

>  			dev_dbg(&i2c_imx->adapter.dev,
>  				"<%s> repeated start\n", __func__);
>  			temp =3D readb(i2c_imx->base + IMX_I2C_I2CR);
> @@ -454,7 +474,7 @@
>=20
>  static u32 i2c_imx_func(struct i2c_adapter *adapter)
>  {
> -	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
> +	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | I2C_FUNC_PROTOCOL_MANGLING;
>  }
>=20
>  static struct i2c_algorithm i2c_imx_algo =3D {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1uRgEACgkQD27XaX1/VRvEUwCgiFUIbs69N2n6lXePUWKzIRgQ
PIgAniN4TJOpGjzIEgAlKovm5UhyjbY6
=r07f
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
