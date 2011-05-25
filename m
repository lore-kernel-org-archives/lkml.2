Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1EYK3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:29:54 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:50534 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512Ab1EYK3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:29:53 -0400
Date: Wed, 25 May 2011 13:29:47 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110525102945.GN14556@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <011d01cc19ff$616055c0$24210140$@org>
 <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org>
 <013201cc1a96$bdda7910$398f6b30$@org>
 <20110525092124.GI14556@legolas.emea.dhcp.ti.com>
 <015801cc1abd$ca534e20$5ef9ea60$@org>
 <20110525092743.GK14556@legolas.emea.dhcp.ti.com>
 <018e01cc1ac0$2b09b040$811d10c0$@org>
 <20110525094902.GM14556@legolas.emea.dhcp.ti.com>
 <01a601cc1ac2$f0041a00$d00c4e00$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqN4RWvJTb9VNux/"
Content-Disposition: inline
In-Reply-To: <01a601cc1ac2$f0041a00$d00c4e00$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tqN4RWvJTb9VNux/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 25, 2011 at 01:03:00PM +0300, Tanya Brokhman wrote:
> > > No, I'm afraid we're talking about different things here.
> > > As far as dummy_hcd is concerned:
> > > Dummy_hcd has a new module parameter that should be set to true if
> > the
> > > developer wishes the gadget driver to be connected to a SS root hub.
> > > Since at the moment most of the gadget drivers woun't work at SS
> > > connection (lack of SS descriptors) the default of this parameter is
> > > true and thus the connected gadget driver will be enumerated over a
> > HS
> > > root hub. Users don't have to remember t set anything in order to be
> > > able to work with dummy_hcd and the existing gadget drivers just as
> > they did up until now.
> > >
> > > We did add a new feature flag (CONFIG_USB_GADGET_SUPERSPEED) that is
> > > set during compilation. If that flag is defined, then (and only
> > then!)
> > > will the
> > > driver->speed be set to SS by composite_bind. Please keep in mind the
> >=20
> > and that's the only thing I'm asking you to remove :-)
>=20
> You want to remove the following change from in composite.c:
>=20
> @@ -1386,6 +1604,9 @@ int usb_composite_probe(struct usb_composite_driver
> *driver,
>  		driver->iProduct =3D driver->name;
>  	composite_driver.function =3D  (char *) driver->name;
>  	composite_driver.driver.name =3D driver->name;
> +#ifdef CONFIG_USB_GADGET_SUPERSPEED
> +	composite_driver.speed =3D USB_SPEED_SUPER; #endif /*=20
> +CONFIG_USB_GADGET_SUPERSPEED */
>  	composite =3D driver;
>  	composite_gadget_bind =3D bind;
>=20
> Right? I'm sorry, but I really don't understand why... :( Removing it is =
the
> same as not defining CONFIG_USB_GADGET_SUPERSPEED.

we still want to build a SuperSpeed dummy_hcd but have HS gadget drivers
:-)

> > we should be to compile dummy_hcd in SuperSpeed and still have high-
> > speed gadget drivers :-)
>=20
> But this is the case right now. Or do you mean that you want to load (not
> compile) the dummy_hcd with is_super_speed=3D1 and still be able to enume=
rate
> HS gadgets?

that too.

> > > following:
> > > 1. if CONFIG_USB_GADGET_SUPERSPEED=3Dtrue, existing gadget drivers are
> > > still functional with dummy_hcd since as I already mentioned, they
> > > will be enumerated through HS root hub and thus the gadget.speed will
> > be set to HS.
> > > This is true for all gadget drivers, including the once that don't
> > > define SS descriptors.
> >=20
> > only due the module parameter, right ?
>=20
> Due to the module parameter default value being FALSE, yes.

Ok, so let's take your approach but change the speed in the gadget
driver structure, put your ifdef somewhere like here:

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 1ba4bef..d02d6e8 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1224,7 +1224,11 @@ composite_resume(struct usb_gadget *gadget)
 /*------------------------------------------------------------------------=
-*/
=20
 static struct usb_gadget_driver composite_driver =3D {
+#ifdef CONFIG_USB_GADGET_SUPERSPEED
+       .speed          =3D USB_SPEE_SUPER,
+#else
        .speed          =3D USB_SPEED_HIGH,
+#endif
=20
        .unbind         =3D composite_unbind,
=20

--=20
balbi

--tqN4RWvJTb9VNux/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3NoZAAoJEAv8Txj19kN17EgH/Rchr6LEGv0vGwiX171wyGsu
gV0mJFTbAttvJIYe8xhST4Rpsc6gqNh+KuxavCSqj/okSyRclGD8hM7hmKBc0hw4
/IUVwR3QBk3HqZH2SR7X05hAkpbOlRJo4IHTfTo2pMkqft8bztl9GT/pVLy1eZEw
mjfqMnAfi1bdTLf/skRQJ51z0J7nyPArZdytlOACIvFWq/IwkoF31RTNRGZ//ZMs
dWuwUTFUA4Czoto7SbnRWgWiieGXfGpBadlQuovrUe9iN9wIY/XvlJGbJFl6wjuN
bpXtcP2LkXwx7/96qYZ776cMYTNlqEhN9MnXaHV0ccutahH1+AE9E1PgrBl8MTE=
=3Elv
-----END PGP SIGNATURE-----

--tqN4RWvJTb9VNux/--
