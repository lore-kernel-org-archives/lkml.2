Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2FKQav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:30:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42025 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab2FKQau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:30:50 -0400
Date: Mon, 11 Jun 2012 18:30:44 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: sonic.zhang@analog.com
Cc: Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 3/8] i2c: i2c-bfin-twi: Break dead waiting loop if i2c
 device misbehaves.
Message-ID: <20120611163044.GD3887@pengutronix.de>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
 <1337152826-9850-3-git-send-email-sonic.zhang@analog.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="llIrKcgUOe3dCx0c"
Content-Disposition: inline
In-Reply-To: <1337152826-9850-3-git-send-email-sonic.zhang@analog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--llIrKcgUOe3dCx0c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 16, 2012 at 03:20:21PM +0800, sonic.zhang@analog.com wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>=20
> Some fault i2c device may hold the sda/scl line and cause i2c driver
> wait in the BUS busy loop. This patch breaks this potential dead
> loop.
>=20
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>=20
> git-svn-id: svn://localhost/svn/linux-kernel/trunk@9291 526b6c2d-f592-453=
2-a319-5dd88ccb003d

^

> ---
>  drivers/i2c/busses/i2c-bfin-twi.c |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-b=
fin-twi.c
> index 376e331..4abaf59 100644
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> @@ -294,6 +294,8 @@ static irqreturn_t bfin_twi_interrupt_entry(int irq, =
void *dev_id)
>  	return IRQ_HANDLED;
>  }
> =20
> +#define BFIN_TWI_BUSY_TIMEOUT	1000
> +

Please use a unit like microseconds for the timeout.

>  /*
>   * One i2c master transfer
>   */
> @@ -303,12 +305,16 @@ static int bfin_twi_do_master_xfer(struct i2c_adapt=
er *adap,
>  	struct bfin_twi_iface *iface =3D adap->algo_data;
>  	struct i2c_msg *pmsg;
>  	int rc =3D 0;
> +	unsigned int busy_timeout =3D BFIN_TWI_BUSY_TIMEOUT;
> =20
>  	if (!(read_CONTROL(iface) & TWI_ENA))
>  		return -ENXIO;
> =20
> -	while (read_MASTER_STAT(iface) & BUSBUSY)
> +	while (read_MASTER_STAT(iface) & BUSBUSY) {
> +		if (--busy_timeout =3D=3D 0)
> +			return -EBUSY;
>  		yield();
> +	}
> =20
>  	iface->pmsg =3D msgs;
>  	iface->msg_num =3D num;
> @@ -403,12 +409,16 @@ int bfin_twi_do_smbus_xfer(struct i2c_adapter *adap=
, u16 addr,
>  {
>  	struct bfin_twi_iface *iface =3D adap->algo_data;
>  	int rc =3D 0;
> +	unsigned int busy_timeout =3D BFIN_TWI_BUSY_TIMEOUT;
> =20
>  	if (!(read_CONTROL(iface) & TWI_ENA))
>  		return -ENXIO;
> =20
> -	while (read_MASTER_STAT(iface) & BUSBUSY)
> +	while (read_MASTER_STAT(iface) & BUSBUSY) {
> +		if (--busy_timeout =3D=3D 0)
> +			return -EBUSY;
>  		yield();
> +	}
> =20
>  	iface->writeNum =3D 0;
>  	iface->readNum =3D 0;
> --=20
> 1.7.0.4
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--llIrKcgUOe3dCx0c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/WHTQACgkQD27XaX1/VRs1wACfcn+k1UIyKSRNoMWTNnzxN8P4
BEIAn2ejx1vwzuUa3T5Sng67LpnY5f2N
=nT3+
-----END PGP SIGNATURE-----

--llIrKcgUOe3dCx0c--
