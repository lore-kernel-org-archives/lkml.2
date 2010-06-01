Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab0FAJOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 05:14:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36987 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab0FAJOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:14:46 -0400
Message-ID: <4C04CA04.6000207@pengutronix.de>
Date: Tue, 01 Jun 2010 10:51:16 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: sha@pengutronix.de
CC: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Wolfram Sang <w.sang@pengutronix.de>, Richard Zhao <linuxzsc@gmail.com>,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Arnaud Patard <apatard@mandriva.com>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] i2c-imx: do not allow interruptions when waiting for
 I2C to complete
References: <1274962561-17007-1-git-send-email-mkl@pengutronix.de>
In-Reply-To: <1274962561-17007-1-git-send-email-mkl@pengutronix.de>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5534AAF344AF88B44C80ED7F"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5534AAF344AF88B44C80ED7F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Marc Kleine-Budde wrote:
> The i2c_imx_trx_complete() function is using
> wait_event_interruptible_timeout() to wait for the I2C controller to
> signal that it has completed an I2C bus operation. If the process that
> causes the I2C operation receives a signal, the wait will be
> interrupted, returning an error. It is better to let the I2C operation
> finished before handling the signal (i.e. returning into userspace).
>=20
> It is safe to use wait_event_timeout() instead, because the timeout
> will allow the process to exit if the I2C bus hangs. It's also better
> to allow the I2C operation to finish, because unacknowledged I2C
> operations can cause the I2C bus to hang.

Ping, can someone please comment the patch and/or push upstream.

Marc
>=20
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>=20
> V2: Remove check for "result < 0" as commented by Wolfram Sang.
>=20
>  drivers/i2c/busses/i2c-imx.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.=
c
> index d1ff940..58df809 100644
> --- a/drivers/i2c/busses/i2c-imx.c
> +++ b/drivers/i2c/busses/i2c-imx.c
> @@ -161,13 +161,10 @@ static int i2c_imx_trx_complete(struct imx_i2c_st=
ruct *i2c_imx)
>  {
>  	int result;
> =20
> -	result =3D wait_event_interruptible_timeout(i2c_imx->queue,
> +	result =3D wait_event_timeout(i2c_imx->queue,
>  		i2c_imx->i2csr & I2SR_IIF, HZ / 10);
> =20
> -	if (unlikely(result < 0)) {
> -		dev_dbg(&i2c_imx->adapter.dev, "<%s> result < 0\n", __func__);
> -		return result;
> -	} else if (unlikely(!(i2c_imx->i2csr & I2SR_IIF))) {
> +	if (unlikely(!(i2c_imx->i2csr & I2SR_IIF))) {
>  		dev_dbg(&i2c_imx->adapter.dev, "<%s> Timeout\n", __func__);
>  		return -ETIMEDOUT;
>  	}
> @@ -295,7 +292,7 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_i=
d)
>  		i2c_imx->i2csr =3D temp;
>  		temp &=3D ~I2SR_IIF;
>  		writeb(temp, i2c_imx->base + IMX_I2C_I2SR);
> -		wake_up_interruptible(&i2c_imx->queue);
> +		wake_up(&i2c_imx->queue);
>  		return IRQ_HANDLED;
>  	}
> =20


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig5534AAF344AF88B44C80ED7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkwEygkACgkQjTAFq1RaXHMlDwCghEbr8akMxg3tSKVgBGrlLkEO
h90AnAw5Y7Gxgr8IKCBliRHHtDA3db2f
=O6+Z
-----END PGP SIGNATURE-----

--------------enig5534AAF344AF88B44C80ED7F--
