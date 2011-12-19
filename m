Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1LSPtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:49:40 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:43646 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab1LSPtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:49:39 -0500
Date: Mon, 19 Dec 2011 17:49:32 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "open list:DESIGNWARE USB3 D..." <linux-omap@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:AMD GEODE CS5536..." <linux-geode@lists.infradead.org>
Subject: Re: [PATCH 1/9] usb: gadget: add generic map/unmap request utilities
Message-ID: <20111219154931.GA30355@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1324290632-23758-2-git-send-email-balbi@ti.com>
 <Pine.LNX.4.44L0.1112191018320.1746-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1112191018320.1746-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 19, 2011 at 10:19:46AM -0500, Alan Stern wrote:
> On Mon, 19 Dec 2011, Felipe Balbi wrote:
>=20
> > such utilities are currently duplicated on all UDC
> > drivers basically with the same structure. Let's group
> > all implementations into one generic implementation
> > and get rid of that duplication.
> >=20
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  drivers/usb/gadget/udc-core.c |   53 +++++++++++++++++++++++++++++++++=
++++++++
> >  include/linux/usb/gadget.h    |   10 +++++++
> >  2 files changed, 63 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-cor=
e.c
> > index 0b0d12c..2031c11 100644
> > --- a/drivers/usb/gadget/udc-core.c
> > +++ b/drivers/usb/gadget/udc-core.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/device.h>
> >  #include <linux/list.h>
> >  #include <linux/err.h>
> > +#include <linux/dma-mapping.h>
> > =20
> >  #include <linux/usb/ch9.h>
> >  #include <linux/usb/gadget.h>
> > @@ -49,6 +50,58 @@ static DEFINE_MUTEX(udc_lock);
> > =20
> >  /* -------------------------------------------------------------------=
------ */
> > =20
> > +int usb_gadget_map_request(struct usb_gadget *gadget,
> > +		struct usb_request *req, int direction)
> > +{
> > +	if (req->length =3D=3D 0)
> > +		return 0;
> > +
> > +	if (req->num_sgs) {
> > +		int     mapped;
> > +
> > +		mapped =3D dma_map_sg(&gadget->dev, req->sg, req->num_sgs,
> > +				direction ? DMA_TO_DEVICE
> > +				: DMA_FROM_DEVICE);
> > +		if (mapped =3D=3D 0) {
> > +			dev_err(&gadget->dev, "failed to map SGs\n");
> > +			return -EFAULT;
> > +		}
> > +
> > +		req->num_mapped_sgs =3D mapped;
> > +	} else {
> > +		req->dma =3D dma_map_single(&gadget->dev, req->buf, req->length,
> > +				direction ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
> > +
> > +		if (dma_mapping_error(&gadget->dev, req->dma)) {
> > +			dev_err(&gadget->dev, "failed to map buffer\n");
> > +			return -EFAULT;
> > +		}
> > +	}
> > +
> > +	return 0;
>=20
> You forgot to set req->mapped.

actually there's no 'mapped' field on struct usb_request. That's a
nonsense added to all struct my_controller_request just because of that
DMA_ADDR_INVALID hackery. I'm dropping that completely. There were no
gadget drivers allocating memory from coherent or mapping requests
themselves, so req->mapped becomes useless.

--=20
balbi

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO710LAAoJEIaOsuA1yqRERuIQAKIJ6NBilrtS0X5N9ktt5nTr
a93Ak0JtzTEL5pNF5quJ5nrgJU+yt+C8Occ4eUNpodq+tPMmGeQpqGRUBrd7Fivl
ac+JycgE+asJRP8K9964sQ2wqlOKVPE62avHwinl7d1UjBm6ZUYQIBGI5TfblfsE
LDfKffwNmuu05bL2FXVCnDK+sxqSQf+M60mJvhJ6e+D5M/a10sPB7MMhhGSA8oZ/
+5/8AHbVgUBWMfrFJkwk3ksn8+ANs9jmyo8vW2yghQUayQPYLwHSPV4En1tLTgYF
2gYWcbkPY7OTw+TxWC7Zv+I4zAA8Pz+3otn9UqOb0IrlQDI4oPEt/JWxVVlGnJ+r
ie3qroCFm4TRqT4BXGoUc60UePAjzEZ1fvoUbtN0gYhbFsOPwbRvKe5M9h8mv3+V
ssDOJXQOBFT6VW8T3A2UsbF3kKkpF8rQkvZlhhRJ5SCefbkZy4DASRoZXFScHFSQ
Q58anz+ZvWRfFIHQpQvz1tQjvNdJT33A2dPln9joG+Xou4cWvuVWGfv2Wv/Acms2
ytCgAQOlY4zgb7i5vs1yUe5av/J2FEjTdKa/aiPeYyiVDAMAjcaBO3ljJVrRrZZ0
WDO8BtKgbDBjJavDmGiQUeCGEEmsIqqsi482Op6MZHnexydJLveffSlz2NeMw65n
/NWctikQXFidqXEGkCFD
=UgH/
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
