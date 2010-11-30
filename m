Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab0K3MF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 07:05:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56089 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0K3MF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 07:05:57 -0500
Message-ID: <4CF4E897.7090702@pengutronix.de>
Date: Tue, 30 Nov 2010 13:05:43 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andrew.chih.howe.khor@intel.com, qi.wang@intel.com,
        margie.foster@intel.com, yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 v6 06/20] can: EG20T PCH: Fix endianness
 issue
References: <4CF47BAA.2090209@dsn.okisemi.com>
In-Reply-To: <4CF47BAA.2090209@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1C480ADFCCD89B261449D7B0"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1C480ADFCCD89B261449D7B0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/30/2010 05:20 AM, Tomoya MORINAGA wrote:
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

The patch does more than fixing the endianess issue. Please split non
endianess related changes into seperate patch.

regards, Marc
>=20
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/net/can/pch_can.c |  118 +++++++++++++++++++++----------------=
--------
>  1 files changed, 55 insertions(+), 63 deletions(-)
>=20
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index 6437e60..98e7e9f 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
> @@ -134,10 +134,7 @@ struct pch_can_if_regs {
>  	u32 id1;
>  	u32 id2;
>  	u32 mcont;
> -	u32 dataa1;
> -	u32 dataa2;
> -	u32 datab1;
> -	u32 datab2;
> +	u32 data[4];./internal/TsiStandard/appl/gendata/desc.c
>  	u32 rsv[13];
>  };
> =20
> @@ -420,10 +417,10 @@ static void pch_can_clear_buffers(struct pch_can_=
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
> @@ -437,10 +434,10 @@ static void pch_can_clear_buffers(struct pch_can_=
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
> @@ -703,12 +700,13 @@ static int pch_can_rx_normal(struct net_device *n=
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
> @@ -774,12 +772,10 @@ static int pch_can_rx_normal(struct net_device *n=
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
> +			cf->data[i + 1] =3D data_reg >> 8;

this is endianess related....good

>  		}
> =20
>  		netif_receive_skb(skb);
> @@ -815,72 +811,71 @@ RX_NEXT:
> =20
>  	return rcv_pkts;
>  }
> -static int pch_can_rx_poll(struct napi_struct *napi, int quota)
> +
> +static void pch_can_tx_complete(struct net_device *ndev, u32 int_stat)=

>  {
> -	struct net_device *ndev =3D napi->dev;
>  	struct pch_can_priv *priv =3D netdev_priv(ndev);
>  	struct net_device_stats *stats =3D &(priv->ndev->stats);
>  	u32 dlc;
> +
> +	can_get_echo_skb(ndev, int_stat - PCH_RX_OBJ_END - 1);
> +	iowrite32(PCH_CMASK_RX_TX_GET | PCH_CMASK_CLRINTPND,
> +		  &priv->regs->ifregs[1].cmask);
> +	pch_can_check_if_busy(&priv->regs->ifregs[1].creq, int_stat);
> +	dlc =3D get_can_dlc(ioread32(&priv->regs->ifregs[1].mcont) &
> +			  PCH_IF_MCONT_DLC);
> +	stats->tx_bytes +=3D dlc;
> +	stats->tx_packets++;
> +	if (int_stat =3D=3D PCH_TX_OBJ_END)
> +		netif_wake_queue(ndev);
> +}

but this is something else...please split into a seperate patch.

> +
> +static int pch_can_rx_poll(struct napi_struct *napi, int quota)
> +{
> +	struct net_device *ndev =3D napi->dev;
> +	struct pch_can_priv *priv =3D netdev_priv(ndev);
>  	u32 int_stat;
>  	int rcv_pkts =3D 0;
>  	u32 reg_stat;
> =20
>  	int_stat =3D pch_can_int_pending(priv);
>  	if (!int_stat)
> -		return 0;
> +		goto end;
> =20
> -INT_STAT:
> -	if (int_stat =3D=3D PCH_STATUS_INT) {
> +	if ((int_stat =3D=3D PCH_STATUS_INT) && (quota > 0)) {
>  		reg_stat =3D ioread32(&priv->regs->stat);
>  		if (reg_stat & (PCH_BUS_OFF | PCH_LEC_ALL)) {
> -			if ((reg_stat & PCH_LEC_ALL) !=3D PCH_LEC_ALL)
> +			if (reg_stat & PCH_BUS_OFF ||
> +			   (reg_stat & PCH_LEC_ALL) !=3D PCH_LEC_ALL) {
>  				pch_can_error(ndev, reg_stat);
> +				quota--;
> +			}

dito

>  		}
> =20
> -		if (reg_stat & PCH_TX_OK) {
> -			iowrite32(PCH_CMASK_RX_TX_GET,
> -				  &priv->regs->ifregs[1].cmask);
> -			pch_can_check_if_busy(&priv->regs->ifregs[1].creq,
> -					       ioread32(&priv->regs->intr));
> +		if (reg_stat & PCH_TX_OK)
>  			pch_can_bit_clear(&priv->regs->stat, PCH_TX_OK);
> -		}

dito
> =20
>  		if (reg_stat & PCH_RX_OK)
>  			pch_can_bit_clear(&priv->regs->stat, PCH_RX_OK);
> =20
>  		int_stat =3D pch_can_int_pending(priv);
> -		if (int_stat =3D=3D PCH_STATUS_INT)
> -			goto INT_STAT;
>  	}
> =20
> -MSG_OBJ:
> +	if (quota =3D=3D 0)
> +		goto end;
> +
>  	if ((int_stat >=3D PCH_RX_OBJ_START) && (int_stat <=3D PCH_RX_OBJ_END=
)) {
> -		rcv_pkts =3D pch_can_rx_normal(ndev, int_stat);
> -		if (rcv_pkts < 0)
> -			return 0;
> +		rcv_pkts +=3D pch_can_rx_normal(ndev, int_stat);
> +		quota -=3D rcv_pkts;
> +		if (quota < 0)
> +			goto end;

same here

>  	} else if ((int_stat >=3D PCH_TX_OBJ_START) &&
>  		   (int_stat <=3D PCH_TX_OBJ_END)) {
>  		/* Handle transmission interrupt */
> -		can_get_echo_skb(ndev, int_stat - PCH_RX_OBJ_END - 1);
> -		iowrite32(PCH_CMASK_RX_TX_GET | PCH_CMASK_CLRINTPND,
> -			  &priv->regs->ifregs[1].cmask);
> -		dlc =3D ioread32(&priv->regs->ifregs[1].mcont) &
> -			       PCH_IF_MCONT_DLC;
> -		pch_can_check_if_busy(&priv->regs->ifregs[1].creq, int_stat);
> -		if (dlc > 8)
> -			dlc =3D 8;
> -		stats->tx_bytes +=3D dlc;
> -		stats->tx_packets++;
> -		if (int_stat =3D=3D PCH_TX_OBJ_END)
> -			netif_wake_queue(ndev);
> +		pch_can_tx_complete(ndev, int_stat);

same here

>  	}
> =20
> -	int_stat =3D pch_can_int_pending(priv);
> -	if (int_stat =3D=3D PCH_STATUS_INT)
> -		goto INT_STAT;
> -	else if (int_stat >=3D 1 && int_stat <=3D 32)
> -		goto MSG_OBJ;
> -
> +end:
>  	napi_complete(napi);
>  	pch_can_set_int_enables(priv, PCH_CAN_ALL);
> =20
> @@ -1013,10 +1008,10 @@ static int pch_close(struct net_device *ndev)
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
> @@ -1057,13 +1052,10 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb=
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

good.

>  	}
> =20
>  	can_put_echo_skb(skb, ndev, tx_buffer_avail - PCH_RX_OBJ_END - 1);


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig1C480ADFCCD89B261449D7B0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkz06JoACgkQjTAFq1RaXHNSYwCeNQMrFOgx7uaRd3jw17m0owdc
JVUAn3+dQ23QliI7NBOdYMQMVLVnbyTm
=QQqd
-----END PGP SIGNATURE-----

--------------enig1C480ADFCCD89B261449D7B0--
