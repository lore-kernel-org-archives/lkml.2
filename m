Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab0LLS3p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 13:29:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51430 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0LLS3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 13:29:31 -0500
Message-ID: <4D04E98E.5090800@pengutronix.de>
Date: Sun, 12 Dec 2010 16:26:06 +0100
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
Subject: Re: [PATCH net-next-2.6 v8 01/20] CAN : Add flow control processing.
References: <4CFE13E4.2020707@dsn.okisemi.com>
In-Reply-To: <4CFE13E4.2020707@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig779C94C24F67452167BA05DC"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig779C94C24F67452167BA05DC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/07/2010 12:00 PM, Tomoya MORINAGA wrote:
> Currently, there is no flow control processing.
> Thus, Add flow control processing as
> when there is no empty of tx buffer,
> netif_stop_queue is called.
> When there is empty buffer, netif_wake_queue is called.

See comment inline.

> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/net/can/pch_can.c |   31 ++++++++++++-------------------
>  1 files changed, 12 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index a9b6a65..f0f1404 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
> @@ -102,6 +102,10 @@
> =20
>  #define PCH_FIFO_THRESH		16
> =20
> +/* TxRqst2 show status of MsgObjNo.17~32 */
> +#define PCH_TREQ2_TX_MASK	(((1 << PCH_TX_OBJ_NUM) - 1) <<\
> +							(PCH_RX_OBJ_END - 16))
> +
>  enum pch_ifreg {
>  	PCH_RX_IFREG,
>  	PCH_TX_IFREG,
> @@ -871,6 +875,8 @@ MSG_OBJ:
>  			dlc =3D 8;
>  		stats->tx_bytes +=3D dlc;
>  		stats->tx_packets++;
> +		if (int_stat =3D=3D PCH_TX_OBJ_END)
> +			netif_wake_queue(ndev);
>  	}
> =20
>  	int_stat =3D pch_can_int_pending(priv);
> @@ -1009,18 +1015,6 @@ static int pch_close(struct net_device *ndev)
>  	return 0;
>  }
> =20
> -static int pch_get_msg_obj_sts(struct net_device *ndev, u32 obj_id)
> -{
> -	u32 buffer_status =3D 0;
> -	struct pch_can_priv *priv =3D netdev_priv(ndev);
> -
> -	/* Getting the message object status. */
> -	buffer_status =3D (u32) pch_can_get_buffer_status(priv);
> -
> -	return buffer_status & obj_id;
> -}
> -
> -
>  static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *nd=
ev)
>  {
>  	int i, j;
> @@ -1031,17 +1025,16 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb=
, struct net_device *ndev)
>  	if (can_dropped_invalid_skb(ndev, skb))
>  		return NETDEV_TX_OK;
> =20
> -	if (priv->tx_obj =3D=3D PCH_TX_OBJ_END) { /* Point tail Obj */
> -		while (pch_get_msg_obj_sts(ndev, (((1 << PCH_TX_OBJ_NUM)-1) <<
> -					   PCH_RX_OBJ_NUM)))
> -			udelay(500);
> +	if (priv->tx_obj =3D=3D PCH_TX_OBJ_END) {
> +		if (ioread32(&priv->regs->treq2) & PCH_TREQ2_TX_MASK)
> +			netif_stop_queue(ndev);

David asked you in his previous review to implement a pure software
solution without relying on the hardware because it tends to be racy.

> =20
> -		priv->tx_obj =3D PCH_TX_OBJ_START; /* Point head of Tx Obj ID */
> -		tx_buffer_avail =3D priv->tx_obj; /* Point Tail of Tx Obj */
> +		tx_buffer_avail =3D priv->tx_obj;
> +		priv->tx_obj =3D PCH_TX_OBJ_START;
>  	} else {
>  		tx_buffer_avail =3D priv->tx_obj;
> +		priv->tx_obj++;
>  	}
> -	priv->tx_obj++;
> =20
>  	/* Reading the Msg Obj from the Msg RAM to the Interface register. */=

>  	iowrite32(PCH_CMASK_RX_TX_GET, &priv->regs->ifregs[1].cmask);

cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig779C94C24F67452167BA05DC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0E6ZEACgkQjTAFq1RaXHOkfQCfYOcWycuoEAr7Uw0+WHk9gMl1
H3gAnjbrhyelv3OHgGbx/4+tRRgejrVL
=viGG
-----END PGP SIGNATURE-----

--------------enig779C94C24F67452167BA05DC--
