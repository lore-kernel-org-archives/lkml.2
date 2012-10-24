Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964820Ab2JXInB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:43:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33418 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933357Ab2JXImz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:42:55 -0400
Date: Wed, 24 Oct 2012 11:37:04 +0300
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Benoit Cousson <b-cousson@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121024083704.GF5665@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121022155028.GA13791@core.coreip.homeip.net>
 <508660D4.9030507@ti.com>
 <20121023200249.GA2712@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l+goss899txtYvYf"
Content-Disposition: inline
In-Reply-To: <20121023200249.GA2712@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--l+goss899txtYvYf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 23, 2012 at 01:02:49PM -0700, Dmitry Torokhov wrote:
> On Tue, Oct 23, 2012 at 11:18:12AM +0200, Benoit Cousson wrote:
> > Hi Dimitry,
> >=20
> > On 10/22/2012 05:50 PM, Dmitry Torokhov wrote:
> > > Hi Sourav,
> > >=20
> > > On Mon, Oct 22, 2012 at 06:43:00PM +0530, Sourav Poddar wrote:
> > >> Adapt keypad to use pinctrl framework.
> > >>
> > >> Tested on omap4430 sdp with 3.7-rc1 kernel.
> > >=20
> > > I do not see anything in the driver that would directly use pinctrl. =
Is
> > > there a better place to select default pin configuration; maybe when
> > > instantiating platform device?
> >=20
> > Why?
> > The devm_pinctrl_get_select_default is using the pinctrl.
>=20
> No, I guess we ihave different understanding of what "directly use" means.
> This particular driver does directly use interrupts: it requests it and
> performs some actions when interrupt arrives. Same goes for IO memory -
> it gets requested, then we access it. With pinctrl we do not do anything
> - we just ask another layer to configure it and that is it.

this is true for almost anything we do:

- we ask another layer to allocate memory for us
- we ask another layer to call our ISR once the IRQ line is asserted
- we ask another layer to handle the input events we just received
- we ask another layer to transfer data through DMA for us
- we ask another layer to turn regulators on and off.

and so on. This is just how abstractions work, we group common parts in
a framework so that users don't need to know the details, but still need
to tell the framework when to fiddle with those resources.

> I have seen just in a few days 3 or 4 drivers having exactly the same
> change - call to devm_pinctrl_get_select_default(), and I guess I will
> receive the same patches for the rest of input drivers shortly.
> This suggests that the operation is done at the wrong level. Do the
> pin configuration as you parse DT data, the same way you set up i2c
> devices registers in of_i2c.c, and leave the individual drivers that do
> not care about specifics alone.

Makes no sense to hide that from drivers. The idea here is that driver
should know when it needs its pins to muxed correctly. 95% of the time
it will be done during probe() but then again, so what ?

doing that when parsing DT, or on bus notifiers is just plain wrong.
Drivers should be required to handle all of their resources.

> > That's why it is named "get_select_default" and not "get" only.
> > This API ensure that the pin will be set to the default state, and this
> > is all we need to do during the probe.
>=20
> Why during the probe and not by default? Realistically, the driver will
> be loaded as long as there is a matching device and pins will need to be
> configured.

likewise memory will be allocated when matching happens, IRQs will be
allocated, regulators will be turned on. So why don't we do all that by
default ? Because it is wrong.

> > There is no point to change the mux if the driver is not probed, because
> > potentially the pin can be use be another driver.
>=20
> What other driver would use it? Who would chose what driver to load?

Well, you _do_ know that on a SoC we have a limited amount of pins
right ?

Considering the amont of features which are packed inside a single die,
it's not farfetched to assume we will have a lot less pins then we
actually need, so we need muxers behind each pin in order to choose
which functionality we want.

If it happens that keypad's pins are shared with another IP (e.g. GPIO),
we need to give the final user (a OEM/ODM) the choice of using those
pins as either keypad or GPIOs, thus the need for pinctrl framework and
the calls in the drivers.

--=20
balbi

--l+goss899txtYvYf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQh6iwAAoJEIaOsuA1yqRE3wsQAJDG41hRCAID1+3a4PREBdYF
cnw4MO0mIP0uZ6FvPskVLhg6v5khTHGJHyRAOJqo7nZG7mBqfRNrYfeoqZ2l1Tnx
lIOJHOR7HO+XqTh2yTA1NuFK8pxGYnMm96lwg7C1DJK4sdJRKRonAp8uAoM88Ar1
7uZveWZsGtb7AJBEo6y2lpyv3vlT+IigyA9VY537/kgCJZoW5M16mNEyWo7KEeTJ
HIliGsWHavWEoxZsSQKiUxq46zT13RAuMKb1lVvHyE087PGerulgLJftHjxBIjlm
3ErhuUJH48Y7CxhojaLxrV2wGqUmru2gVWaUQQshH/7HiAZ+eCmDhVk/r01M6ffY
L6euFAp8INWU4ABpDEkEB34KIf9uLI/aZVlO8vGmDTAhdcTFjI7ft1E/TBPC327S
kwp4m9tRLCmVUNjV0I/zNqE+jbUJ1qatCuzyuWa0tcOMnY26ezahQdmVZhgbHUYr
VTDmelWTiw69inqa9Tjcj94uEabRSyRqQpsTbBpo72pniRPhCTx3QO3iN9WQw6EU
YlkH5f46Hbx+NPta+2jJU8vOmD8u6b4l0PaQiXAPdAXbxh5y+LNBAMqHBjq7ceql
MH0j3muvHGhpliFm+cQJQK/4x9+Yv1iPYUzoCbBrM1Ej9gXVYyfEpDn5ek4PY02b
NpBjpu3zZX9P5brgrSIw
=yt0R
-----END PGP SIGNATURE-----

--l+goss899txtYvYf--
