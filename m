Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934842Ab2JXQ76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:59:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55937 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab2JXQ7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:59:55 -0400
Date: Wed, 24 Oct 2012 19:52:16 +0300
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121024165215.GA32220@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121022155028.GA13791@core.coreip.homeip.net>
 <508660D4.9030507@ti.com>
 <20121023200249.GA2712@core.coreip.homeip.net>
 <20121024083704.GF5665@arwen.pp.htv.fi>
 <20121024161429.GA16350@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20121024161429.GA16350@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 24, 2012 at 09:14:29AM -0700, Dmitry Torokhov wrote:

<snip>

> > > No, I guess we ihave different understanding of what "directly use" m=
eans.
> > > This particular driver does directly use interrupts: it requests it a=
nd
> > > performs some actions when interrupt arrives. Same goes for IO memory=
 -
> > > it gets requested, then we access it. With pinctrl we do not do anyth=
ing
> > > - we just ask another layer to configure it and that is it.
> >=20
> > this is true for almost anything we do:
> >=20
> > - we ask another layer to allocate memory for us
> > - we ask another layer to call our ISR once the IRQ line is asserted
> > - we ask another layer to handle the input events we just received
> > - we ask another layer to transfer data through DMA for us
> > - we ask another layer to turn regulators on and off.
>=20
> But we are _directly_ _using_ all of these. You allocate memory and you
> (the driver) stuff data into that memory. You ask for DMA and you take
> the DMAed data and work with it. Not so with pinctrl in omap keypad and
> other drivers I have seen so far.

of course we are. If we don't mux the pins to their correct setting, we
can't realy use the HW. So while you don't see any SW control of the
requested pins, we're still making use of them.

> > and so on. This is just how abstractions work, we group common parts in
> > a framework so that users don't need to know the details, but still need
> > to tell the framework when to fiddle with those resources.
> >=20
> > > I have seen just in a few days 3 or 4 drivers having exactly the same
> > > change - call to devm_pinctrl_get_select_default(), and I guess I will
> > > receive the same patches for the rest of input drivers shortly.
> > > This suggests that the operation is done at the wrong level. Do the
> > > pin configuration as you parse DT data, the same way you set up i2c
> > > devices registers in of_i2c.c, and leave the individual drivers that =
do
> > > not care about specifics alone.
> >=20
> > Makes no sense to hide that from drivers. The idea here is that driver
> > should know when it needs its pins to muxed correctly.
>=20
> The driver also needs memory controller to be initialized, gpio chip be
> ready and registered, DMA subsystem ready, input core reade, etc, etc,
> etc. You however do not have every driver explicitly initialize any of
> that; you expect certain working environment to be already operable. The
> driver does manage resources it controls, it has ultimate knowledge
> about, pin configuration is normally is not it. We just need to know
> that we wired/muxed properly, otherwise we won't work. So please let
> parent layers deal with it.
>=20
> > 95% of the time
> > it will be done during probe() but then again, so what ?
> >=20
> > doing that when parsing DT, or on bus notifiers is just plain wrong.
> > Drivers should be required to handle all of their resources.
>=20
> All of _their_ resources, exactly. They do not own nor control pins so
> they should not be bothered with them either. Look, when you see that

except that they *own* the pins. Now that the muxer has been setup
properly, this particular IP owns the pins.

> potentially _every_ driver in the system needs to set up the same object
> that it doe snot use otherwise you should realize that individual driver
> is not the proper place to do that.

fair enough, but IMHO, we're not there yet. We can't make that claim
yet. Besides, we don't know what's the default pin state in a system. It
might be that certain pins start out in a way which consumes less power
due to the internal construction of the SoC. If we set pins up before
driver probes, and probe fails or the driver is never really used, then
we could be falling into a situation where we're wasting power.

Granted, you can undo everything you did before, but I guess keeping
track of everything we setup before probe() just to remove a couple of
lines from drivers is wrong.

> > > > That's why it is named "get_select_default" and not "get" only.
> > > > This API ensure that the pin will be set to the default state, and =
this
> > > > is all we need to do during the probe.
> > >=20
> > > Why during the probe and not by default? Realistically, the driver wi=
ll
> > > be loaded as long as there is a matching device and pins will need to=
 be
> > > configured.
> >=20
> > likewise memory will be allocated when matching happens, IRQs will be
> > allocated, regulators will be turned on. So why don't we do all that by
> > default ? Because it is wrong.
>=20
> No, because we do not know how. The generic layer does not know the ISR
> to install, how much memory to allocate, etc. Having regulator turned on
> before getting to probe might not be a bad idea.

what if your driver never probes ? Will you really leave regulators on
consuming extra, valuable power ?

> > > > There is no point to change the mux if the driver is not probed, be=
cause
> > > > potentially the pin can be use be another driver.
> > >=20
> > > What other driver would use it? Who would chose what driver to load?
> >=20
> > Well, you _do_ know that on a SoC we have a limited amount of pins
> > right ?
> >=20
> > Considering the amont of features which are packed inside a single die,
> > it's not farfetched to assume we will have a lot less pins then we
> > actually need, so we need muxers behind each pin in order to choose
> > which functionality we want.
> >=20
> > If it happens that keypad's pins are shared with another IP (e.g. GPIO),
> > we need to give the final user (a OEM/ODM) the choice of using those
> > pins as either keypad or GPIOs, thus the need for pinctrl framework and
> > the calls in the drivers.
>=20
> Right, so please walk me through, step by step, how an OEM/ODM woudl
> select a particular configuration. Do you expect it to happen at
> runtime, or do you expect relevant data be put in DT?

It depends, I've seen both happening, really. Also note that DT
migration is still not complete, meaning that most (all ?) OEM/ODMs are
still using the legacy board-file-based approach and it will still take
them a few years to move to DT-based boot.

Another point to consider is community boards such as beaglebone which
have tens of different "capes" to support. Depending on the cape, pins
might have to be remuxed, so instead of adding all that code to platform
support, just leave it all in drivers. Depending on the "cape" different
drivers will probe() and those drivers should know how to mux pins for
themselves.

Note that these are only the two easy examples that came to my mind, I'm
sure we can discuss this for a long, but is it valid ? For a single line
of code ?

--=20
balbi

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiBy/AAoJEIaOsuA1yqREKhgP/2HPkjFA3DqQF4lWu5kKMSY+
MRSgvQGfHd4wCjJ82xrNb0OL3h6+eAI9dozRVoGzihOSRm/S4IxOI/mGxX5RO2tr
UlYteiXT+XkM6NJzEU8wT0tynzHl9QD29R+rGC6bqWvJI/rksvAYXjCKNfIHb8n9
Pgg2wRzeEQWPfyd1mTbA8xuE3v0QZduwnUekQsoPdOQVXi62Eho3VFrGSPF0DBxM
cgaehANRqgjXk1gYH+h4/ps6PGZiYB0wvWW0+klk/7kiI3B4Wnp4BqfERcGsvaFl
okyDTBfOEdKBXY5VELRH33fWSZdbhfIEcimQQc2z9GpqN9tZl25Yt5N0/tALLntb
K9ozInsHSHmsuVhiOhtIv6AL1YlitsGXXU8NRMp6nsKNWb7v85jm3cnkJDWu6kQF
EGS3kNYj5/zDFCtlDKaihVYKU4z+FOOeEXIk0oimzYo0deGMi8oa9mLtw5TsE16d
WutidKSEKE9zL/FSClBlOFXBU5/+PXj42cwjPyRgUXCtDgE8A6qIfSsfk8za/qA0
apvmelHrzpzZEpDAYGZN45wYx1HXOidj6vo6S1JgiD3JRCxxb/idRF6cDn2yGAgj
E9kfKNsPiOzRFypeUc0SIfdy2urSDqtuM9wuMPmWoUkptULeNAlFPUeskt7VhPGG
YlGuL6IzYZ54vIZeJViC
=xxWy
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
