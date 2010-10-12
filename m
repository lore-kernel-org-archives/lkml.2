Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab0JLH4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 03:56:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44115 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab0JLH4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 03:56:37 -0400
Message-ID: <4CB414A2.8020202@pengutronix.de>
Date: Tue, 12 Oct 2010 09:56:18 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>, andrew.chih.howe.khor@intel.com,
        sameo@linux.intel.com, margie.foster@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yong.y.wang@intel.com,
        socketcan-core@lists.berlios.de, joel.clark@intel.com,
        morinaga526@dsn.okisemi.com, kok.howg.ewe@intel.com, chripell@fsfe.org,
        qi.wang@intel.com
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35
References: <002e01cb6486$2ed72cc0$66f8800a@maildom.okisemi.com>	<20101005.114506.184852374.davem@davemloft.net>	<000b01cb6503$962bc7f0$66f8800a@maildom.okisemi.com>	<20101005.200904.71120150.davem@davemloft.net>	<4CAC3D94.9010408@grandegger.com> <000c01cb69dc$5d2aaab0$66f8800a@maildom.okisemi.com>
In-Reply-To: <000c01cb69dc$5d2aaab0$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3B87C0D0490ADE06AA096FD8"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3B87C0D0490ADE06AA096FD8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Masayuki,

On 10/12/2010 09:09 AM, Masayuki Ohtake wrote:
> We have implemented our CAN driver with FIFO mode, and
> We are testing our CAN driver with FIFO mode.
> However, we have found Our CAN hardware spec is different from our anti=
cipated.
> Our CAN HW FIFO is not common FIFO.
> Using  FIFO mode, there is possibility received packets are out-of-orde=
r.

It's called a FIFO in the Documentation, but it's not a real FIFO as we
all hoped.

> e.g.
> Recv packet-A from NW and set to FIFO.
>   |A|
>=20
> Recv packet-B from NW and set to FIFO.
>   |A|B|
>=20
> Recv packet-C is about to set to FIFO
>   |A|B|(C)|
>=20
> Userspace Copies A from Driver
> Userspace Copies B from Driver
>   |   |   |(C)|
>=20
> packet-C set to FIFO (C is not head.)
> Recv packet-D from NW(Next packet is set to head)
>   |D|   |C|
>=20
> Userspace Copies D from Driver
> Userspace Copies C from Driver
> Userspace raceived packet order is like below
> A-B-D-C

I just had a small peak at the datasheet. It seems you can implement the
same scheme for rx as on the at91, if you enough rx buffers. In the at91
driver I use 8+4 =3D 12 buffers for rx. Have a look at the driver, the rx=

path is documented.

The driver uses 8 + 4 rx buffers, the trick is that a buffer in read but
_not_ marked as free, if I understand the intel datasheet correctly this
is by not resetting the NEWDAT bit. Becasue the driver doesn't free the
buffers it knows that the next CAN frame is in the next buffer. After
reading the 8th buffer, the first 8 buffers (0-7) are marked as free.
Then the driver continues to read buffers 8-11, they might have been
filled before marking 0-7 as free. Then the driver continues from the
beginning.

> So, I think normal-mode is better than FIFO-mode.

> I will revert like the following spec.
>   Rx 1 Message Object
>   Tx 1 Message Object
>=20
> Could you agree the above ?

ahh common...the hardware doesn't seem that bad :)

cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig3B87C0D0490ADE06AA096FD8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAky0FKYACgkQjTAFq1RaXHMQ6ACfRgpERnqIkP7XXRSXnDu+TAER
eIMAoI3VVKbkEHqXohLne+gutbpytZPU
=ma5k
-----END PGP SIGNATURE-----

--------------enig3B87C0D0490ADE06AA096FD8--
