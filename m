Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab0KIOrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:47:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50672 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0KIOrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:47:17 -0500
Message-ID: <4CD95EE8.4000709@pengutronix.de>
Date: Tue, 09 Nov 2010 15:47:04 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, andrew.chih.howe.khor@intel.com,
        qi.wang@intel.com, margie.foster@intel.com, yong.y.wang@intel.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build
 warnings
References: <4CCAA3D4.8070408@dsn.okisemi.com> <4CCAC4CD.7000503@pengutronix.de> <4CCAFA68.2030903@hartkopp.net> <00fd01cb8009$5efc5fd0$66f8800a@maildom.okisemi.com>
In-Reply-To: <00fd01cb8009$5efc5fd0$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDED0AD05C532F3289BCE4BA5"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDED0AD05C532F3289BCE4BA5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/09/2010 01:26 PM, Tomoya MORINAGA wrote:
>> It's just a question if the driver for an Intel Chipset should/could i=
gnore
>> the endian problematic.
>>
>> If this is intended the driver should only appear in Kconfig depending=
 on X86
>> or little endian systems.
>=20
> This driver is for only x86 processor.
> I have no intention to support processor except x86.

Fair enough, if you do the endianess conversion correct, either with my
proposed cpu_to_be16 or with the simpler and probably unnoticeable
slower version from Oliver. With Olivers version it's a bit harder to
build a loop that just copies the number of bytes specified in dlc.

>> Besides this remark, the struct pch_can_regs could also be defined in =
a way
>> that every single CAN payload data byte could be accessed directly to =
allow
>> e.g. this code in pch_can_rx_normal():
>>
>> cf->data[0] =3D ioread8(&priv->regs->if1_data0);
>> cf->data[1] =3D ioread8(&priv->regs->if1_data1);
>> cf->data[2] =3D ioread8(&priv->regs->if1_data2);
>> (..)
>> cf->data[6] =3D ioread8(&priv->regs->if1_data6);
>> cf->data[7] =3D ioread8(&priv->regs->if1_data7);
>>
>> This is easy to understand and additionally endian aware.
>=20
> I agree. Thease codes are very simple.
> I will modify like above.
>=20
>>
>> In opposite to this:
>>
>> + if (cf->can_dlc > 2) {
>> + u32 data1 =3D *((u16 *)&cf->data[2]);
>> + iowrite32(data1, &priv->regs->if2_dataa2);
>> + }
>>
>> Which puts a little? endian u16 into the big endian register layout.
>> Sorry i'm just getting curious on this register access implementation.=

>=20
> I think cf->data is like below
> MSB----------LSB
> D3-D2-D1-D0
> D7-D6-D5-D4

No, cf->data is an array of 8 u8, so it looks this way:

D0 D1 D2 D3  D4 D5 D6 D7

> *((u16 *)&cf->data[2]) means "D3-D2".

No, it's D2 D3. This is why you need the endianess conversion.

> This order coprresponds to register order.
> data register is like below
> MSB----------LSB
> **-**-D3-D2
>=20
> ** means reserved area.

cheers, Marc


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigDED0AD05C532F3289BCE4BA5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzZXuwACgkQjTAFq1RaXHN4NgCeOZGslvtNdd4HGsJT1Waw+o/j
mnUAn3RuSd+uSU5RpGUdd4VtBs7av4R+
=sPF6
-----END PGP SIGNATURE-----

--------------enigDED0AD05C532F3289BCE4BA5--
