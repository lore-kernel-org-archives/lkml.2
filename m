Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0LLS3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 13:29:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51420 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab0LLS32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 13:29:28 -0500
Message-ID: <4D04E75D.10704@pengutronix.de>
Date: Sun, 12 Dec 2010 16:16:45 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Wolfgang Grandegger <wg@grandegger.com>, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew.chih.howe.khor@intel.com, qi.wang@intel.com,
        margie.foster@intel.com, yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 v8 18/20] CAN : Optimize "if" condition in
 rx/tx	processing
References: <4CFE166D.8040805@dsn.okisemi.com>
In-Reply-To: <4CFE166D.8040805@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0B4D4768880F210FDDDD36B2"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0B4D4768880F210FDDDD36B2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/07/2010 12:11 PM, Tomoya MORINAGA wrote:
> For reduce "if" condition, easy to read/understand the code,
> optimize "if" condition in rx/tx processing.
>=20
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  drivers/net/can/pch_can.c |   26 ++++++++++----------------
>  1 files changed, 10 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index 8efbe35..dcd8f00 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
> @@ -746,19 +746,16 @@ static int pch_can_poll(struct napi_struct *napi,=
 int quota)
> =20
>  	if (int_stat =3D=3D PCH_STATUS_INT) {
>  		reg_stat =3D ioread32(&priv->regs->stat);
> -		if (reg_stat & (PCH_BUS_OFF | PCH_LEC_ALL)) {
> -			if (reg_stat & PCH_BUS_OFF ||
> -			   (reg_stat & PCH_LEC_ALL) !=3D PCH_LEC_ALL) {
> -				pch_can_error(ndev, reg_stat);
> -				quota--;
> -			}
> -		}
> =20
> -		if (reg_stat & PCH_TX_OK)
> -			pch_can_bit_clear(&priv->regs->stat, PCH_TX_OK);
> +		if ((reg_stat & (PCH_BUS_OFF | PCH_LEC_ALL)) &&
> +		   ((reg_stat & PCH_LEC_ALL) !=3D PCH_LEC_ALL)) {
> +			pch_can_error(ndev, reg_stat);
> +			quota--;
> +		}
> =20
> -		if (reg_stat & PCH_RX_OK)
> -			pch_can_bit_clear(&priv->regs->stat, PCH_RX_OK);
> +		if (reg_stat & (PCH_TX_OK | PCH_RX_OK))
> +			pch_can_bit_clear(&priv->regs->stat,
> +					  reg_stat & (PCH_TX_OK | PCH_RX_OK));
> =20
>  		int_stat =3D pch_can_int_pending(priv);
>  	}
> @@ -900,14 +897,13 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb, =
struct net_device *ndev)
>  	if (can_dropped_invalid_skb(ndev, skb))
>  		return NETDEV_TX_OK;
> =20
> +	tx_obj_no =3D priv->tx_obj;
>  	if (priv->tx_obj =3D=3D PCH_TX_OBJ_END) {
>  		if (ioread32(&priv->regs->treq2) & PCH_TREQ2_TX_MASK)
>  			netif_stop_queue(ndev);
> =20
> -		tx_obj_no =3D priv->tx_obj;
>  		priv->tx_obj =3D PCH_TX_OBJ_START;
>  	} else {
> -		tx_obj_no =3D priv->tx_obj;
>  		priv->tx_obj++;
>  	}
> =20
> @@ -926,9 +922,7 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb, st=
ruct net_device *ndev)
>  	id2 |=3D PCH_ID_MSGVAL;
> =20
>  	/* If remote frame has to be transmitted.. */
> -	if (cf->can_id & CAN_RTR_FLAG)
> -		id2 &=3D ~PCH_ID2_DIR;
> -	else
> +	if (!(cf->can_id & CAN_RTR_FLAG))
>  		id2 |=3D PCH_ID2_DIR;
> =20
>  	iowrite32(id2, &priv->regs->ifregs[1].id2);


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig0B4D4768880F210FDDDD36B2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0E510ACgkQjTAFq1RaXHO/sgCgj2dWDPB8BiY2qtu4i+jWOdYg
GUgAoJgdMuYmkTeQm/D9AoTJr87xm8hj
=z6zT
-----END PGP SIGNATURE-----

--------------enig0B4D4768880F210FDDDD36B2--
