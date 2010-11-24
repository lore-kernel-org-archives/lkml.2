Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0KXNkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:40:05 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55685 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab0KXNkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:40:02 -0500
Message-ID: <4CED15AA.5070708@pengutronix.de>
Date: Wed, 24 Nov 2010 14:39:54 +0100
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
Subject: Re: [PATCH net-next-2.6 16/17 v3] can: EG20T PCH: Fix incorrect return
 processing
References: <4CED0412.60305@dsn.okisemi.com>
In-Reply-To: <4CED0412.60305@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF08E56C1365F8FF642E447FC"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF08E56C1365F8FF642E447FC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/24/2010 01:24 PM, Tomoya MORINAGA wrote:
> Fix incorrect return processing

see comments inline

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
d
> *dev_id)
>  	struct net_device *ndev =3D (struct net_device *)dev_id;
>  	struct pch_can_priv *priv =3D netdev_priv(ndev);
>=20
> -	pch_can_set_int_enables(priv, PCH_CAN_NONE);
> -	napi_schedule(&priv->napi);
> -
> -	return IRQ_HANDLED;
> +	if ((pch_can_int_pending(priv) > 0) && (dev_id !=3D NULL)) {
> +		pch_can_set_int_enables(priv, PCH_CAN_NONE);
> +		napi_schedule(&priv->napi);
> +		return IRQ_HANDLED;
> +	}
> +	return IRQ_NONE;

My comment from the first review still applied here:

dev_id is always !=3D NULL, because you registered your IRQ handler with
it. (BTW: dev_id has already been dereferenced in netdev_priv(), so if
this code is executed, dev_if is !=3D NULL)

Just write:

if (!pch_can_int_pending(priv))
	return IRQ_NONE;

>  }
>=20
>  static void pch_fifo_thresh(struct pch_can_priv *priv, int obj_id)
> @@ -674,7 +676,7 @@ static int pch_can_rx_normal(struct net_device
> *ndev, u32 obj_num, int quota)
>  		if (reg & PCH_IF_MCONT_MSGLOST) {
>  			rtn =3D pch_can_rx_msg_lost(ndev, obj_num);
>  			if (!rtn)
> -				return rtn;
> +				return rcv_pkts;
>  			rcv_pkts++;
>  			quota--;
>  			obj_num++;
> @@ -777,10 +779,12 @@ static int pch_can_poll(struct napi_struct *napi,=

> int quota)
>  		goto end;
>=20
>  	if ((int_stat >=3D PCH_RX_OBJ_START) && (int_stat <=3D PCH_RX_OBJ_END=
)) {
> -		rcv_pkts +=3D pch_can_rx_normal(ndev, int_stat, quota);
> -		quota -=3D rcv_pkts;
> -		if (quota < 0)
> +		rcv_pkts =3D pch_can_rx_normal(ndev, int_stat, quota);
> +		if (rcv_pkts < 0) {
> +			rcv_pkts =3D 0;
>  			goto end;
> +		}
> +		quota -=3D rcv_pkts;

you introduced the problem in patch "[PATCH net-next-2.6 6/17 v3] can:
EG20T PCH: Fix endianness issue", please don't do this in the first place=
=2E

( This is an example why you should split your patches and give them
proper subject.)

>  	} else if ((int_stat >=3D PCH_TX_OBJ_START) &&
>  		   (int_stat <=3D PCH_TX_OBJ_END)) {
>  		/* Handle transmission interrupt */

cheers, Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigF08E56C1365F8FF642E447FC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkztFaoACgkQjTAFq1RaXHOADgCeKOgCffM/yrSmtjJ6JWVExEKQ
zNgAnAw1QsachcTpFR2XJU3bP6d3PEdd
=FPCH
-----END PGP SIGNATURE-----

--------------enigF08E56C1365F8FF642E447FC--
