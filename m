Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab0KSVoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:44:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35321 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab0KSVoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:44:37 -0500
Message-ID: <4CE6EFB5.6070908@pengutronix.de>
Date: Fri, 19 Nov 2010 22:44:21 +0100
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
Subject: Re: [PATCH net-next-2.6 16/17] can: EG20T PCH: Fix incorrect return
 processing
References: <4CE6104C.3090401@dsn.okisemi.com>
In-Reply-To: <4CE6104C.3090401@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEB1ABF066803BB274EF27A16"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEB1ABF066803BB274EF27A16
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/19/2010 06:51 AM, Tomoya MORINAGA wrote:
> Fix incorrect return processing

The description is correct. But you change several things that have
nothing to do. The frist hunk fixes shared irq handlers, the others the
quota calculation in the napi handler.

Marc

>=20
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/net/can/pch_can.c |   20 ++++++++++++--------
>  1 files changed, 12 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index c612a99..48f4a2e 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
> @@ -589,10 +589,12 @@ static irqreturn_t pch_can_interrupt(int irq, voi=
d *dev_id)
>  	struct net_device *ndev =3D (struct net_device *)dev_id;
>  	struct pch_can_priv *priv =3D netdev_priv(ndev);
> =20
> -	pch_can_set_int_enables(priv, PCH_CAN_NONE);
> -	napi_schedule(&priv->napi);
> -
> -	return IRQ_HANDLED;
> +	if ((pch_can_int_pending(priv) > 0) && (dev_id !=3D NULL)) {

dev_id is always !=3D NULL, because you registered your IRQ handler with
it. (BTW: dev_id has already been dereferenced in netdev_priv(), so if
this code is executed, dev_if is !=3D NULL)

Just write:

if (!pch_can_int_pending(priv))
	return IRQ_NONE;

> +		pch_can_set_int_enables(priv, PCH_CAN_NONE);
> +		napi_schedule(&priv->napi);
> +		return IRQ_HANDLED;
> +	}
> +	return IRQ_NONE;
>  }
> =20
>  static void pch_fifo_thresh(struct pch_can_priv *priv, int obj_id)
> @@ -674,7 +676,7 @@ static int pch_can_rx_normal(struct net_device *nde=
v, u32 obj_num, int quota)
>  		if (reg & PCH_IF_MCONT_MSGLOST) {
>  			rtn =3D pch_can_rx_msg_lost(ndev, obj_num);
>  			if (!rtn)
> -				return rtn;
> +				return rcv_pkts;
>  			rcv_pkts++;
>  			quota--;
>  			obj_num++;
> @@ -777,10 +779,12 @@ static int pch_can_poll(struct napi_struct *napi,=
 int quota)
>  		goto end;
> =20
>  	if ((int_stat >=3D PCH_RX_OBJ_START) && (int_stat <=3D PCH_RX_OBJ_END=
)) {
> -		rcv_pkts +=3D pch_can_rx_normal(ndev, int_stat, quota);
> -		quota -=3D rcv_pkts;
> -		if (quota < 0)
> +		rcv_pkts =3D pch_can_rx_normal(ndev, int_stat, quota);

maybe it's better to rx as much packages in rx_normal as possible and
not return if you failed to alloc a can_frame.

> +		if (rcv_pkts < 0) {
> +			rcv_pkts =3D 0;
>  			goto end;
> +		}
> +		quota -=3D rcv_pkts;
>  	} else if ((int_stat >=3D PCH_TX_OBJ_START) &&
>  		   (int_stat <=3D PCH_TX_OBJ_END)) {
>  		/* Handle transmission interrupt */


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigEB1ABF066803BB274EF27A16
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzm77sACgkQjTAFq1RaXHP4xwCfUws0nVctYRwVZOgiVTS+s+B9
oiYAni6ymtkirqr3DxuttlVfw8vWPPD/
=9eww
-----END PGP SIGNATURE-----

--------------enigEB1ABF066803BB274EF27A16--
