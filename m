Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab2IZScU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:32:20 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:58618 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757203Ab2IZScS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:32:18 -0400
Date: Wed, 26 Sep 2012 21:27:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: balbi@ti.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] usb: phy: omap-usb2: enable 960Mhz clock for omap5
Message-ID: <20120926182719.GA10326@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
 <1348054229-27362-5-git-send-email-kishon@ti.com>
 <20120919115647.GI3772@arwen.pp.htv.fi>
 <CAAe_U6Kr8t1=T7MGMjAe+1n6S-NncypnPkXYqA2_FtVK=uxULA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <CAAe_U6Kr8t1=T7MGMjAe+1n6S-NncypnPkXYqA2_FtVK=uxULA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 26, 2012 at 11:10:48AM +0530, ABRAHAM, KISHON VIJAY wrote:
> Hi,
>=20
> On Wed, Sep 19, 2012 at 5:26 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Wed, Sep 19, 2012 at 05:00:29PM +0530, Kishon Vijay Abraham I wrote:
> >> "usb_otg_ss_refclk960m" is needed by usb2 phy present in omap5. For
> >> omap4, the clk_get of this clock will fail since it does not have this
> >> clock.
> >>
> >> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >> ---
> >>  Documentation/devicetree/bindings/usb/usb-phy.txt |    3 +++
> >>  drivers/usb/phy/omap-usb2.c                       |   28 ++++++++++++=
++++++++-
> >>  2 files changed, 30 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Docum=
entation/devicetree/bindings/usb/usb-phy.txt
> >> index 7c5fd89..d5626de 100644
> >> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
> >> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
> >> @@ -24,6 +24,9 @@ Required properties:
> >>  add the address of control module phy power register until a driver f=
or
> >>  control module is added
> >>
> >> +Optional properties:
> >> + - has960mhzclk: should be added if the phy needs 960mhz clock
> >> +
> >>  This is usually a subnode of ocp2scp to which it is connected.
> >>
> >>  usb3phy@4a084400 {
> >> diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb2.c
> >> index d36c282..d6612ba 100644
> >> --- a/drivers/usb/phy/omap-usb2.c
> >> +++ b/drivers/usb/phy/omap-usb2.c
> >> @@ -146,6 +146,7 @@ static int __devinit omap_usb2_probe(struct platfo=
rm_device *pdev)
> >>       struct omap_usb                 *phy;
> >>       struct usb_otg                  *otg;
> >>       struct resource                 *res;
> >> +     struct device_node              *np =3D pdev->dev.of_node;
> >>
> >>       phy =3D devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
> >>       if (!phy) {
> >> @@ -190,6 +191,15 @@ static int __devinit omap_usb2_probe(struct platf=
orm_device *pdev)
> >>       }
> >>       clk_prepare(phy->wkupclk);
> >>
> >> +     if (of_property_read_bool(np, "has960mhzclk")) {
> >> +             phy->optclk =3D devm_clk_get(phy->dev, "usb_otg_ss_refcl=
k960m");
> >> +             if (IS_ERR(phy->optclk)) {
> >> +                     dev_err(&pdev->dev, "unable to get refclk960m\n"=
);
> >> +                     return PTR_ERR(phy->optclk);
> >> +             }
> >> +             clk_prepare(phy->optclk);
> >> +     }
> >
> > instead, can't you just always try to get the clock but ignore the error
> > if it fails ?
>=20
> This clock is needed for usb2 to work in dwc3 (omap5). So we have to
> report the error in case we dont get the clock no?

sure, but you don't need to bail out. Print a warning message such as:

dev_dbg(&pdev->dev, "couldn't get refclk960m, trying without\n");

or something similar. Then you don't need to add this has960mhzclk flag
to dts files.

--=20
balbi

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQY0kGAAoJEIaOsuA1yqREqOkQAJLgbl+Qzx0vNAuiLUlTZzUo
5IreLh+VV0iuRGxD0uBFprT9ALzFVJn7hF0eDFf99iclA/nTVVEVol2OFiMUpzZC
gIpk64q1Ryn/8gN0uGlQgvOaJu3fkxL1NxC5lmbaggIrT6J63taL1+jLawt0GDCz
XXdcb6UKp/psj72BSmmrrBPJajmiP9/Jnh3r3/E8sTsbxgaQfEqG6avKjS+n+TVN
u0BDeOSRT1gch+Dh4zf7J1cRZnlgIdMokHAIaYFHGliiTOVJh7OE2Bki0kwvN5y4
EyPl/eBVj/UIQQkTyitd1V7+Psv2rruQ2Hp9Y+Kd3Dq8XfAeop/1URq0ltB3p5ob
lOCYspdNOkZtypcaOUN3iK1PvKDWqrEaH+4wJu+IzPbLe/ayTzaZ+R1AyhrsxHEn
0RQM4abY7U9BLzqk3aFvP9UThgcec4awsINi5wwb9+HJ4up0dGNf8PTsY33plEHC
ahh2oYEtshUCPHD3ukFxPuk6Yil6/UnSlfcn94pFwTUUwO/3TJ4o+WkvcIwdafnY
4BcHOeJbRjIzDpMDTA/KXt8s0QToeYVibFtaoaY9T7mQaCIsE3kmFfBfoQs4bygn
eWTdrlWCaNUruyqym8VQvpE9/Qri849em91RFn3fRc7bYEF+GIDmki1myD8jC4eh
FQvaj3Zt9tTSNXfKXrEE
=hi1m
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
