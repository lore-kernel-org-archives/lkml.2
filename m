Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab1FFPjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:39:05 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:39492 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757230Ab1FFPjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:39:01 -0400
Date: Mon, 6 Jun 2011 18:36:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, Tanya Brokhman <tlinder@codeaurora.org>,
        greg@kroah.com, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 4/9] usb: Add max_speed to usb_composite_driver
 structure
Message-ID: <20110606153619.GI12242@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110606113742.GY18731@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.44L0.1106061120060.1953-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PWfwoUCx3AFJRUBq"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106061120060.1953-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PWfwoUCx3AFJRUBq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 06, 2011 at 11:25:14AM -0400, Alan Stern wrote:
> On Mon, 6 Jun 2011, Felipe Balbi wrote:
>=20
> > But we might still want to force HighSpeed even though the HW has
> > SuperSpeed support.
>=20
> That would be a useful module parameter for a SuperSpeed UDC driver. =20
> Like the parameter Tanya added to dummy-hcd.

what I meant was that if you combine a SS-capable function with a
FS-capable function, you would have to run at FS.

> >  The real solution, for the long run would be to
> > always start with pullups disabled (iow, don't connect to host
> > immediately) and only connect after the gadget driver is all
> > initialized, then we will know the gadget speed before connecting, and
> > we can have the gadget driver "request" for a particular speed from the
> > controller.
>=20
> Unfortunately this would mean changing a bunch of UDC drivers.  But I=20
> agree, it makes sense for the gadget driver to specifically ask for the=
=20
> pullups to be enabled when it is ready.
>=20
> Don't some of the existing UDC drivers fail to implement the pullup=20
> method at all?

I would have to check to answer that, but I guess it could be one goal
to 'require' that method to be valid. So we could start by:

diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index dd1571d..6c2586f 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -671,8 +671,8 @@ static inline int usb_gadget_vbus_disconnect(struct usb=
_gadget *gadge
  */
 static inline int usb_gadget_connect(struct usb_gadget *gadget)
 {
-       if (!gadget->ops->pullup)
-               return -EOPNOTSUPP;
+       BUG_ON(!gadget->ops->pullup);
+
        return gadget->ops->pullup(gadget, 1);
 }
=20
@@ -693,8 +693,8 @@ static inline int usb_gadget_connect(struct usb_gadget =
*gadget)
  */
 static inline int usb_gadget_disconnect(struct usb_gadget *gadget)
 {
-       if (!gadget->ops->pullup)
-               return -EOPNOTSUPP;
+       BUG_ON(!gadget->ops->pullup);
+
        return gadget->ops->pullup(gadget, 0);
 }
=20

and checking if anyone complains. Another approach is to grep all udc
driver for the missing pullup field and start bugging their maintainers
to implement that.

--=20
balbi

--PWfwoUCx3AFJRUBq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7PPzAAoJEAv8Txj19kN1c38H/jRXFAwNquUqXbAP34aYouul
nmOTxaOBl/iNJuDwGPfZU1RV72aSwibM2XfaP+NZbHERgInL1bsRJ5YGLZUJSXtM
9nSSDlWygqmxCHniFTBsc5+5DvHtq5B1iBIxnyrGpwvlaLEH5/9zCSn3EJYOuK66
pN40K990I9cCMV9aLgzHZiGUTYW7nHYMwidENkWAezqx5MS9ZeBoJ3SAka9Wqx4n
pGhJTGo02WksSHWDZUU84+clFlAaokvfOnSeAkuj0TtiIO9PTGOIMxjVNRzH8XSr
RZ7orl2c8Bz3Qg2GNjH7Oy+9cFuIF6haoijjKHo/j1WVU/e0Wk2F7MZaEtC6fqA=
=q1Hj
-----END PGP SIGNATURE-----

--PWfwoUCx3AFJRUBq--
