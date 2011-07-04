Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab1GDI0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:26:04 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:49152 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037Ab1GDI0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:26:01 -0400
Date: Mon, 4 Jul 2011 11:25:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Partha Basak <p-basak2@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Anand Gadiyar <gadiyar@ti.com>,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        Kevin Hilman <khilman@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        paul@pwsan.com, johnstul@us.ibm.com,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
Message-ID: <20110704082553.GH15044@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309546474-15363-7-git-send-email-keshava_mgowda@ti.com>
 <Pine.LNX.4.44L0.1107011504530.1624-100000@iolanthe.rowland.org>
 <11640ef76f97628579e457b5c6a74cc3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="81JctsDUVPekGcy+"
Content-Disposition: inline
In-Reply-To: <11640ef76f97628579e457b5c6a74cc3@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--81JctsDUVPekGcy+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 04, 2011 at 10:36:54AM +0530, Partha Basak wrote:
> >-----Original Message-----
> >From: Alan Stern [mailto:stern@rowland.harvard.edu]
> >Sent: Saturday, July 02, 2011 12:37 AM
> >To: Keshava Munegowda
> >Cc: linux-usb@vger.kernel.org; linux-omap@vger.kernel.org; linux-
> >kernel@vger.kernel.org; balbi@ti.com; gadiyar@ti.com;
> >sameo@linux.intel.com; parthab@india.ti.com; tony@atomide.com;
> >khilman@ti.com; b-cousson@ti.com; paul@pwsan.com; johnstul@us.ibm.com;
> >vishwanath.bs@ti.com
> >Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume
> >support of ehci and ohci
> >
> >On Sat, 2 Jul 2011, Keshava Munegowda wrote:
> >
> >> From: Keshava Munegowda <Keshava_mgowda@ti.com>
> >>
> >> The global suspend and resume functions for ehci and ohci
> >> drivers are implemented; these functions does the
> >> pm_runtime_get_sync and pm_runtime_put_sync of the
> >> parent device usbhs core driver respectively.
> >>
> >> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> >> ---
> >>  drivers/usb/host/ehci-omap.c  |   22 ++++++++++++++++++++--
> >>  drivers/usb/host/ohci-omap3.c |   21 +++++++++++++++++++++
> >>  2 files changed, 41 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-
> >omap.c
> >> index 178f63e..a02a684 100644
> >> --- a/drivers/usb/host/ehci-omap.c
> >> +++ b/drivers/usb/host/ehci-omap.c
> >> @@ -259,14 +259,32 @@ static void ehci_hcd_omap_shutdown(struct
> >platform_device *pdev)
> >>  		hcd->driver->shutdown(hcd);
> >>  }
> >>
> >> +static int omap_ehci_resume(struct device *dev)
> >> +{
> >> +	if (dev->parent)
> >> +		pm_runtime_get_sync(dev->parent);
> >> +	return 0;
> >> +}
> >> +
> >> +static int omap_ehci_suspend(struct device *dev)
> >> +{
> >> +	if (dev->parent)
> >> +		pm_runtime_put_sync(dev->parent);
> >> +	return 0;
> >> +}
> >
> >I don't see any point in these routines (and likewise for
> >omap_ohci_suspend/resume).  When the whole system is going to sleep
> >anyway, what reason is there for enabling runtime PM on the parent
> >device?
>=20
> Both for EHCI & OHCI, the clocks are owned by the parent (uhh-tll).
>=20
> Calling pm_runtime_put_sync(dev->parent) within omap_ehci_suspend
> will turn-off the parent clocks in the Suspend path.
>=20
> Similarly, calling pm_runtime_get_sync(dev->parent) within
> omap_ehci_resume
> will turn-on the parent clocks in the resume path.
>=20
> This way, all reference counting are implicit within the Runtime PM layer
> and takes care of all combinations of only EHCI insmoded, OHCI insmoded,
> both insmoded etc.
>=20
> When both EHCI & OHCI are suspended, parent clocks will actually be
> turned OFF and vice-versa.

not sure this is necessary. I would expect:

pm_runtime_get_sync(dev) to propagate up the parent tree and enable all
necessary resources to get the child in a working state. IOW, you
shouldn't need to manuall access the parent device.

Kevin ? Paul ?

--=20
balbi

--81JctsDUVPekGcy+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOEXkRAAoJEAv8Txj19kN1sBoH/R27TmiRxy57oUe/Uhme6Gsq
GhOWyoBSGPewW58lF/+GXcWMDiD8/KmMkOmJ8hO6IXbGVebeJp4spyviURmT5GqH
xZNWLQ5N6FDy981s1cSzBv9ZoLnSCCnhs2NqfpwappLYujEkOPaqyp6dl/fbFlXo
mZkRIo70WJYT8lIrHuWVlITGXoBaQslVVP8tXAahma6rvPNxJ3nVJwldYcTIcwdR
Dji5F9fdJyJvxcn06wPzXPdYLVwsVwAV333dXne2RPVjfjpZUGroWl50PWJ9TlKp
IrRwDbQPJR2tPAz5Y0cemmCxP0l4SwEMiE61t5oQYIU6VdzAsgwGyaU+LWnqcOI=
=GCbv
-----END PGP SIGNATURE-----

--81JctsDUVPekGcy+--
