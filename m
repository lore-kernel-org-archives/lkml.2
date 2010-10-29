Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277Ab0J2R6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:58:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34121 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865Ab0J2R6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:58:36 -0400
Message-ID: <4CCB0B3F.5050400@pengutronix.de>
Date: Fri, 29 Oct 2010 19:58:23 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: Oliver Hartkopp <socketcan@hartkopp.net>
CC: Tomoya <tomoya-linux@dsn.okisemi.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew.chih.howe.khor@intel.com,
        qi.wang@intel.com, margie.foster@intel.com, yong.y.wang@intel.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build
 warnings
References: <4CCAA3D4.8070408@dsn.okisemi.com> <4CCAC4CD.7000503@pengutronix.de> <4CCAFA68.2030903@hartkopp.net>
In-Reply-To: <4CCAFA68.2030903@hartkopp.net>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD922065302406494E355EB6E"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD922065302406494E355EB6E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/29/2010 06:46 PM, Oliver Hartkopp wrote:
> Indeed the access to the data registers does not seem to be endian awar=
e.
>=20
> See in pch_can_rx_normal():
>=20
> +			cf->can_dlc =3D get_can_dlc((ioread32(&priv->regs->
> +						   if1_mcont)) & 0xF);
> +			*(u16 *)(cf->data + 0) =3D ioread16(&priv->regs->
> +							  if1_dataa1);
> +			*(u16 *)(cf->data + 2) =3D ioread16(&priv->regs->
> +							  if1_dataa2);
> +			*(u16 *)(cf->data + 4) =3D ioread16(&priv->regs->
> +							  if1_datab1);
> +			*(u16 *)(cf->data + 6) =3D ioread16(&priv->regs->
> +							  if1_datab2);
>=20
> See in pch_xmit():
>=20
> +	/* Copy data to register */
> +	if (cf->can_dlc > 0) {
> +		u32 data1 =3D *((u16 *)&cf->data[0]);
> +		iowrite32(data1, &priv->regs->if2_dataa1);
> +	}
> +	if (cf->can_dlc > 2) {
> +		u32 data1 =3D *((u16 *)&cf->data[2]);
> +		iowrite32(data1, &priv->regs->if2_dataa2);
> +	}
> +	if (cf->can_dlc > 4) {
> +		u32 data1 =3D *((u16 *)&cf->data[4]);
> +		iowrite32(data1, &priv->regs->if2_datab1);
> +	}
> +	if (cf->can_dlc > 6) {
> +		u32 data1 =3D *((u16 *)&cf->data[6]);
> +		iowrite32(data1, &priv->regs->if2_datab2);
> +	}
> +
>=20
> It's just a question if the driver for an Intel Chipset should/could ig=
nore
> the endian problematic.
>=20
> If this is intended the driver should only appear in Kconfig depending =
on X86
> or little endian systems.
>=20
> Besides this remark, the struct pch_can_regs could also be defined in a=
 way
> that every single CAN payload data byte could be accessed directly to a=
llow

That _should_ work on x86. On the contrary on ARM some registers in SOCs
allow only full 32 bit access.

> e.g. this code in pch_can_rx_normal():
>=20
> cf->data[0] =3D ioread8(&priv->regs->if1_data0);
> cf->data[1] =3D ioread8(&priv->regs->if1_data1);
> cf->data[2] =3D ioread8(&priv->regs->if1_data2);
> (..)
> cf->data[6] =3D ioread8(&priv->regs->if1_data6);
> cf->data[7] =3D ioread8(&priv->regs->if1_data7);

> This is easy to understand and additionally endian aware.

or use this, (as proposed in a earlier mail)

	for (i =3D 0; i < cf->can_dlc; i +=3D 2) {
		reg =3D ioread32(&priv->regs->if1_data[i >> 1]);
		*(__be16 *)cf->data[i] =3D cpu_to_be16(reg);
	}

> In opposite to this:
>=20
> +	if (cf->can_dlc > 2) {
> +		u32 data1 =3D *((u16 *)&cf->data[2]);
> +		iowrite32(data1, &priv->regs->if2_dataa2);
> +	}
>=20
> Which puts a little? endian u16 into the big endian register layout.
> Sorry i'm just getting curious on this register access implementation.

According to the datasheet the layout is LE.

cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigD922065302406494E355EB6E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzLCz8ACgkQjTAFq1RaXHNrIwCfS+PVtWTtKoyqU8gk4IVOdn2d
p/YAn3uHRtqZgZBU3N/SUNAYrySGvYro
=ft6v
-----END PGP SIGNATURE-----

--------------enigD922065302406494E355EB6E--
