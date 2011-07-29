Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1G2FEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 01:04:42 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:33770 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913Ab1G2FEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 01:04:41 -0400
Date: Fri, 29 Jul 2011 08:04:38 +0300
From: Felipe Balbi <balbi@ti.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [RFC][PATCH] musb: Avoid musb_gadget_pullup "Unhandled fault"
 oops on omap4
Message-ID: <20110729050437.GB9069@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1311206974.2945.198.camel@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2CdKnS9fCwQYmJzs"
Content-Disposition: inline
In-Reply-To: <1311206974.2945.198.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2CdKnS9fCwQYmJzs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Wed, Jul 20, 2011 at 05:09:34PM -0700, John Stultz wrote:
> I've recently run across an "Unhandled fault: imprecise external abort"
> oops that is caused when a driver called usb_gadget_connect() when there
> was no cable plugged into the musb gadget port.
>=20
> You can see the oops message here:
> https://launchpadlibrarian.net/75635123/minicom.txt
>=20
> Doing some digging, it seemed the problem was triggered when reading
> from the musb registers in musb_pullup() when the device controller is
> powered down.
>=20
> Looking at other examples of where the registers were accessed, I
> noticed they were always enclosed by pm_runtime_get/put calls. So I
> added such calls to the musb_gadget_pullup() function and it seemed to
> resolve the problem.
>=20
> Now, full disclosure: this was triggered with the out-of-tree Android
> adb gadget driver. However, I suspect the same behavior could be
> triggered using the composite gadget driver as well, so I think this is
> a generic issue. However, if I'm wrong, let me know and I'll try to make
> sure the fix is done in the right place.
>=20
> If this is the right fix, it probably should be queued for 3.1 and
> 3.0-stable.
>=20
> Comments and feedback would be greatly appreciated!
>=20
>=20
> Reported-by: Zach Pfeffer <zach.pfeffer@linaro.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Applied, thanks.

improved commit log slightly:

commit 7e1bb0fdcc9b51ebec0a1e5e06ff075aab55c941
Author: John Stultz <john.stultz@linaro.org>
Date:   Wed Jul 20 17:09:34 2011 -0700

    usb: musb: fix oops on musb_gadget_pullup
   =20
    an 'unhandled fault' is causes when a gadget driver calls
    usb_gadget_connect() while the USB cable isn't plugged into
    the OTG port.
   =20
    the fault is caused by an access to MUSB's memory space
    while its clock is turned off due to pm_runtime kicking
    in.
   =20
    in order to fix the fault, we enclose musb_gadget_pullup()
    with pm_runtime_get_sync() ... pm_runtime_put() calls to
    be sure we will always reach that path with clock turned on.
   =20
    [ balbi@ti.com : simplified commit log; removed few things
        which didn't belong there ]
   =20
    Cc: stable@kernel.org
    Reported-by: Zach Pfeffer <zach.pfeffer@linaro.org>
    Signed-off-by: John Stultz <john.stultz@linaro.org>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--2CdKnS9fCwQYmJzs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOMj9lAAoJEAv8Txj19kN1pZ0IAIxreLB6eP0dgva+bpWPd4Zo
2MclClzpU/y0jpqWDzpKshuwHPThbfvBtdi+o9TDip0havUJsUQzlnZw0HhRdBSs
KMhdXFcV1y3vSshgsyPWfeIMdCwDOFM9abwkWGS3Fi9aq07c2BMHmVbU/MD0us8w
RE6C5rMRrhoQ3ozzCwoRZbHLN8/aypMViwliR/MoMNivz0cfPhWe75Yfm2lgXR05
tnI2qwi2dMBAIWdu+Gez0rdAKv/CfdpfGU9vlQLNSU9UPam2gUjveUCTpM0rPFn+
nXVW0EJcIswxlqPsjaKn82CeRDG2vj6w6BlP+eIhMgosTzZNQUnQgYkVcJ83E8E=
=SO3G
-----END PGP SIGNATURE-----

--2CdKnS9fCwQYmJzs--
