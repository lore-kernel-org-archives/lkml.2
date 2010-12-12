Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0LLS3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 13:29:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51439 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab0LLS3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 13:29:33 -0500
Message-ID: <4D04EA92.2010802@pengutronix.de>
Date: Sun, 12 Dec 2010 16:30:26 +0100
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
Subject: Re: [PATCH net-next-2.6 v8 03/20] CAN : Fix endianness issue.
References: <4CFE1489.4030808@dsn.okisemi.com>
In-Reply-To: <4CFE1489.4030808@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6811D42A31640DF4F02BB901"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6811D42A31640DF4F02BB901
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/07/2010 12:03 PM, Tomoya MORINAGA wrote:
> there is endianness issue both Tx and Rx.
> Currently, data is set like below.
> Register:
> MSB--LSB
> x x D0 D1
> x x D2 D3
> x x D4 D5
> x x D6 D7
>=20
> But Data to be sent must be set like below.
> Register:
> MSB--LSB
> x x D1 D0
> x x D3 D2
> x x D5 D4
> x x D7 D6  (x means reserved area.)

Nitpick inline, please fix it, then add my Acked-by

Marc

> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/net/can/pch_can.c |   47 +++++++++++++++++++------------------=
-------
>  1 files changed, 20 insertions(+), 27 deletions(-)
>=20
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index 0b6d4f4..b17ca0c 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
> @@ -138,10 +138,7 @@ struct pch_can_if_regs {
>  	u32 id1;
>  	u32 id2;
>  	u32 mcont;
> -	u32 dataa1;
> -	u32 dataa2;
> -	u32 datab1;
> -	u32 datab2;
> +	u32 data[4];
>  	u32 rsv[13];
>  };
> =20
> @@ -424,10 +421,10 @@ static void pch_can_clear_buffers(struct pch_can_=
priv *priv)
>  		iowrite32(0x0, &priv->regs->ifregs[0].id1);
>  		iowrite32(0x0, &priv->regs->ifregs[0].id2);
>  		iowrite32(0x0, &priv->regs->ifregs[0].mcont);
> -		iowrite32(0x0, &priv->regs->ifregs[0].dataa1);
> -		iowrite32(0x0, &priv->regs->ifregs[0].dataa2);
> -		iowrite32(0x0, &priv->regs->ifregs[0].datab1);
> -		iowrite32(0x0, &priv->regs->ifregs[0].datab2);
> +		iowrite32(0x0, &priv->regs->ifregs[0].data[0]);
> +		iowrite32(0x0, &priv->regs->ifregs[0].data[1]);
> +		iowrite32(0x0, &priv->regs->ifregs[0].data[2]);
> +		iowrite32(0x0, &priv->regs->ifregs[0].data[3]);
>  		iowrite32(PCH_CMASK_RDWR | PCH_CMASK_MASK |
>  			  PCH_CMASK_ARB | PCH_CMASK_CTRL,
>  			  &priv->regs->ifregs[0].cmask);
> @@ -441,10 +438,10 @@ static void pch_can_clear_buffers(struct pch_can_=
priv *priv)
>  		iowrite32(0x0, &priv->regs->ifregs[1].id1);
>  		iowrite32(0x0, &priv->regs->ifregs[1].id2);
>  		iowrite32(0x0, &priv->regs->ifregs[1].mcont);
> -		iowrite32(0x0, &priv->regs->ifregs[1].dataa1);
> -		iowrite32(0x0, &priv->regs->ifregs[1].dataa2);
> -		iowrite32(0x0, &priv->regs->ifregs[1].datab1);
> -		iowrite32(0x0, &priv->regs->ifregs[1].datab2);
> +		iowrite32(0x0, &priv->regs->ifregs[1].data[0]);
> +		iowrite32(0x0, &priv->regs->ifregs[1].data[1]);
> +		iowrite32(0x0, &priv->regs->ifregs[1].data[2]);
> +		iowrite32(0x0, &priv->regs->ifregs[1].data[3]);
>  		iowrite32(PCH_CMASK_RDWR | PCH_CMASK_MASK |
>  			  PCH_CMASK_ARB | PCH_CMASK_CTRL,
>  			  &priv->regs->ifregs[1].cmask);
> @@ -707,12 +704,13 @@ static int pch_can_rx_normal(struct net_device *n=
dev, u32 int_stat)
>  	canid_t id;
>  	u32 ide;
>  	u32 rtr;
> -	int i, j, k;
> +	int i, k;
>  	int rcv_pkts =3D 0;
>  	struct sk_buff *skb;
>  	struct can_frame *cf;
>  	struct pch_can_priv *priv =3D netdev_priv(ndev);
>  	struct net_device_stats *stats =3D &(priv->ndev->stats);
> +	u16 data_reg;
> =20
>  	/* Reading the messsage object from the Message RAM */
>  	iowrite32(PCH_CMASK_RX_TX_GET, &priv->regs->ifregs[0].cmask);
> @@ -778,12 +776,10 @@ static int pch_can_rx_normal(struct net_device *n=
dev, u32 int_stat)
>  			      ((ioread32(&priv->regs->ifregs[0].mcont)) & 0x0f);
>  		}
> =20
> -		for (i =3D 0, j =3D 0; i < cf->can_dlc; j++) {
> -			reg =3D ioread32(&priv->regs->ifregs[0].dataa1 + j*4);
> -			cf->data[i++] =3D cpu_to_le32(reg & 0xff);
> -			if (i =3D=3D cf->can_dlc)
> -				break;
> -			cf->data[i++] =3D cpu_to_le32((reg >> 8) & 0xff);
> +		for (i =3D 0; i < cf->can_dlc; i +=3D 2) {
> +			data_reg =3D ioread16(&priv->regs->ifregs[0].data[i / 2]);
> +			cf->data[i] =3D data_reg & 0xff;

The & 0xff is not needed cf->data is only 8bit wide.

> +			cf->data[i + 1] =3D data_reg >> 8;
>  		}
> =20
>  		netif_receive_skb(skb);
> @@ -1016,10 +1012,10 @@ static int pch_close(struct net_device *ndev)
> =20
>  static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *nd=
ev)
>  {
> -	int i, j;
>  	struct pch_can_priv *priv =3D netdev_priv(ndev);
>  	struct can_frame *cf =3D (struct can_frame *)skb->data;
>  	int tx_buffer_avail =3D 0;
> +	int i;
> =20
>  	if (can_dropped_invalid_skb(ndev, skb))
>  		return NETDEV_TX_OK;
> @@ -1060,13 +1056,10 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb=
, struct net_device *ndev)
>  	if (cf->can_id & CAN_RTR_FLAG)
>  		pch_can_bit_clear(&priv->regs->ifregs[1].id2, PCH_ID2_DIR);
> =20
> -	for (i =3D 0, j =3D 0; i < cf->can_dlc; j++) {
> -		iowrite32(le32_to_cpu(cf->data[i++]),
> -			 (&priv->regs->ifregs[1].dataa1) + j*4);
> -		if (i =3D=3D cf->can_dlc)
> -			break;
> -		iowrite32(le32_to_cpu(cf->data[i++] << 8),
> -			 (&priv->regs->ifregs[1].dataa1) + j*4);
> +	/* Copy data to register */
> +	for (i =3D 0; i < cf->can_dlc; i +=3D 2) {
> +		iowrite16(cf->data[i] | (cf->data[i + 1] << 8),
> +			  &priv->regs->ifregs[1].data[i / 2]);
>  	}
> =20
>  	can_put_echo_skb(skb, ndev, tx_buffer_avail - PCH_RX_OBJ_END - 1);


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig6811D42A31640DF4F02BB901
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0E6pMACgkQjTAFq1RaXHNDhwCeNCsCUUZXijS4lSgVyfDGGdmL
o6UAnjYHFyHm6OTYEpEsLHk2cIppjg1W
=oSfo
-----END PGP SIGNATURE-----

--------------enig6811D42A31640DF4F02BB901--
