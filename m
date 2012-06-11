Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab2FKQ2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:28:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41999 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2FKQ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:28:12 -0400
Date: Mon, 11 Jun 2012 18:28:07 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: sonic.zhang@analog.com
Cc: Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 2/8] i2c: i2c-bfin-twi: Stop receiving operation
 immediately in last rx interrupt.
Message-ID: <20120611162807.GC3887@pengutronix.de>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
 <1337152826-9850-2-git-send-email-sonic.zhang@analog.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Content-Disposition: inline
In-Reply-To: <1337152826-9850-2-git-send-email-sonic.zhang@analog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 16, 2012 at 03:20:20PM +0800, sonic.zhang@analog.com wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>=20
> Also wake up waiting process when transfer completes.

The description says what you do, but not why it is needed. What bug was
experienced and why is this change proper? Patch 5/8 does that quite
good.

>=20
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>=20
> git-svn-id: svn://localhost/svn/linux-kernel/trunk@9105 526b6c2d-f592-453=
2-a319-5dd88ccb003d

Please remove this line.

> ---
>  drivers/i2c/busses/i2c-bfin-twi.c |   43 ++++++++++++++++++++-----------=
-----
>  1 files changed, 24 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-b=
fin-twi.c
> index e6dd3c9..376e331 100644
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> @@ -130,21 +130,25 @@ static void bfin_twi_handle_interrupt(struct bfin_t=
wi_iface *iface,
>  			}
>  			iface->transPtr++;
>  			iface->readNum--;
> -		} else if (iface->manual_stop) {
> -			/* Avoid possible bus stall -
> -			 * Flush FIFO before issuing the STOP condition
> -			 */
> -			read_RCV_DATA16(iface);
> -			write_MASTER_CTL(iface,
> -				read_MASTER_CTL(iface) | STOP);
> -		} else if (iface->cur_mode =3D=3D TWI_I2C_MODE_REPEAT &&
> -		           iface->cur_msg + 1 < iface->msg_num) {
> -			if (iface->pmsg[iface->cur_msg + 1].flags & I2C_M_RD)
> -				write_MASTER_CTL(iface,
> -					read_MASTER_CTL(iface) | RSTART | MDIR);
> -			else
> +		}
> +
> +		if (iface->readNum =3D=3D 0) {
> +			if (iface->manual_stop) {
> +				/* Avoid possible bus stall -
> +				 * Flush FIFO before issuing the STOP condition
> +				 */
> +				read_RCV_DATA16(iface);
>  				write_MASTER_CTL(iface,
> -					(read_MASTER_CTL(iface) | RSTART) & ~MDIR);
> +					read_MASTER_CTL(iface) | STOP);
> +			} else if (iface->cur_mode =3D=3D TWI_I2C_MODE_REPEAT &&
> +					iface->cur_msg + 1 < iface->msg_num) {
> +				if (iface->pmsg[iface->cur_msg + 1].flags & I2C_M_RD)
> +					write_MASTER_CTL(iface,
> +						read_MASTER_CTL(iface) | RSTART | MDIR);
> +				else
> +					write_MASTER_CTL(iface,
> +						(read_MASTER_CTL(iface) | RSTART) & ~MDIR);
> +			}
>  		}
>  	}
>  	if (twi_int_status & MERR) {
> @@ -245,12 +249,13 @@ static void bfin_twi_handle_interrupt(struct bfin_t=
wi_iface *iface,
>  				}
>  			}
> =20
> -			if (iface->pmsg[iface->cur_msg].len <=3D 255)
> -					write_MASTER_CTL(iface,
> +			if (iface->pmsg[iface->cur_msg].len <=3D 255) {
> +				write_MASTER_CTL(iface,
>  					(read_MASTER_CTL(iface) &
>  					(~(0xff << 6))) |
> -				(iface->pmsg[iface->cur_msg].len << 6));
> -			else {
> +					(iface->pmsg[iface->cur_msg].len << 6));
> +				iface->manual_stop =3D 0;
> +			} else {
>  				write_MASTER_CTL(iface,
>  					(read_MASTER_CTL(iface) |
>  					(0xff << 6)));
> @@ -264,8 +269,8 @@ static void bfin_twi_handle_interrupt(struct bfin_twi=
_iface *iface,
>  			write_INT_MASK(iface, 0);
>  			write_MASTER_CTL(iface, 0);
>  		}
> +		complete(&iface->complete);
>  	}
> -	complete(&iface->complete);
>  }
> =20
>  /* Interrupt handler */
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

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/WHJcACgkQD27XaX1/VRtkOwCgviKToQ+wjUNtXEDIfk7a2Q1m
HtMAoMtDb3eB8mISunlJnxUx5pkO87kQ
=WqQA
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
