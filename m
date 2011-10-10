Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1JJULM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 16:11:12 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:51126 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754697Ab1JJULK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 16:11:10 -0400
Date: Mon, 10 Oct 2011 23:10:57 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        Paul Walmsley <paul@pwsan.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        khilman@ti.com, b-cousson@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
Message-ID: <20111010201055.GB8808@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111010160354.GP6685@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.44L0.1110101551510.24082-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1110101551510.24082-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 10, 2011 at 03:55:30PM -0400, Alan Stern wrote:
> On Mon, 10 Oct 2011, Felipe Balbi wrote:
>=20
> > On Mon, Oct 10, 2011 at 11:19:43AM -0400, Alan Stern wrote:
> > > On Mon, 10 Oct 2011, Felipe Balbi wrote:
> > >=20
> > > > > > do we have sibling structures today? I dont think so.
> > > > >=20
> > > > > no we don't.
> > > >=20
> > > > Ok, here's a first shot at it:
> > >=20
> > > In fact we do already have sibling lists.  They are maintained as par=
t=20
> > > of the device_private structure.  What we are missing is a=20
> > > device_for_each_sibling() routine.  It could be added pretty easily; =
it=20
> > > would be similar to device_for_each_child().
> >=20
> > care to point out where is ?
> >=20
> > 68 struct device_private {
> > 69         struct klist klist_children;
> > 70         struct klist_node knode_parent;
> -------------^  Here.  The "parent" in the name refers to where the
>                 head of the list is stored.
>=20
> > 71         struct klist_node knode_driver;
> > 72         struct klist_node knode_bus;
> > 73         void *driver_data;
> > 74         struct device *device;
> > 75 };
>=20
> From device_add():
>=20
> 	if (parent)
> 		klist_add_tail(&dev->p->knode_parent,
> 			       &parent->p->klist_children);

that's a parent -> child relationship. What we have on this case is:

 --------------                ---------------
|              |              |               |          |\
|   UHH        |  clocks, etc |    USBTLL     |          | |
|              | <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> |               | <=3D=3D=
=3D=3D=3D=3D> | | <=3D=3D=3D=3D> ports
|     -------  |              | (Transceiver- |          | |
|    |  EHCI | |              | less Link)    |          |/
|     -------  |              |               |         Port MUX
|              |              |               |
|     -------  |              |               |
|    |  OHCI | |              |               |
|     -------  |              |               |
|              |              |               |
 --------------                ---------------

It doesn't shown here, but the TLL link is completely optional. It's
mainly used for modem integration, IIRC. Still, if we're using TLL, EHCI
and OHCI will depend on a clock provided by the USBTLL block.

Clearly, USBTLL isn't either a parent of UHH, nor a parent of EHCI/OHCI
blocks. We can, from a code perspective, make USBTLL into a parent of
UHH to make things simpler, but this will mean that calling
pm_runtime_get() will also unconditionaly turn on TLL clock, unless we
add some nasty hacks to allow TLL know if *HCI port is in TLL mode.

That's why I decided for making TLL and UHH siblings, because that's a
closer relationship than parent-child.

Can you see the problem now ?

ps: the best picture is on TI's OMAP4430 TRM (it's publicly available
=66rom TI's website). So, if you want a better rendering of the
integration model, take a look at chapter 23.

--=20
balbi

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOk1FPAAoJEIaOsuA1yqREgUEP/RSMOsArmDUUQUcRiIzfDxMF
Gt5xG5mUU2/NcI789K4pwquRuD6cr59ZDc1KJVHB6OR3cOpiTNb47fxzkxLZI0h0
UJz5xnNYEGiiW+i27pKvigjlZcBI3faeMbqmwHE+Z8Lx0EI/BL7xPZili9WTVtkU
nn+ubG38uwOvTJ7m274z9jdE3o4+QRRw7j/OhLk1EBS+LVeYfSv36/b8SM87J6Bv
1bdsU3X5wnXotT3iWNtFtrbMMvKHZPAjLPbLNbMe7g2yjVYsnNHn4D9pNjRLOY3v
+jyuD17ub5QgUQsze5W3R+rwaHwG+t+jxfkbPPLS7DQY0iEHXRG7fYgDxzrYCXPr
aN152Z1ccwjwFoldbSssFdBbmlyH/YBIKlTm9m7eUUNyfDCd5JZEKKn4PLrt3JrJ
ukti9l3XYkHVnaHVUNm1sUNh9WTKcNhDLY+H2Dehi3nErmtMmdLsQf0l84fI2IMY
2THx5fZvjdSHoU423XBAxIscWFhW1BBjVSfrTOPzynAIOpnOUvHTywUELofAZGUk
tLwIKELi3q21gH3qbctor95qCK7XNeuj85DkBsiXPEsPV0ZXu/Os3Mi61X5T0uwy
bYs0kUkty2x/OK4Fd9DU8CK4JUrL3UDYtfmjF8jjD0FIn8luj64XYApg/u8lraqR
nO7xwwFR8RznWIrWwxq4
=Q7mg
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
