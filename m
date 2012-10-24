Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935350Ab2JXRfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:35:03 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56914 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816Ab2JXRfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:35:00 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: balbi@ti.com
Cc: Benoit Cousson <b-cousson@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        tony@atomide.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Date: Wed, 24 Oct 2012 10:34:32 -0700
Message-ID: <1595649.YT4eDUD2ax@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.9.2 (Linux/3.6.0+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121024165215.GA32220@arwen.pp.htv.fi>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com> <20121024161429.GA16350@core.coreip.homeip.net> <20121024165215.GA32220@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2284208.Hd1WifmENZ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2284208.Hd1WifmENZ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday, October 24, 2012 07:52:16 PM Felipe Balbi wrote:
> Hi,
> 
> On Wed, Oct 24, 2012 at 09:14:29AM -0700, Dmitry Torokhov wrote:
> 
> <snip>
> 
> > > > No, I guess we ihave different understanding of what "directly use"
> > > > means.
> > > > This particular driver does directly use interrupts: it requests it
> > > > and
> > > > performs some actions when interrupt arrives. Same goes for IO memory
> > > > -
> > > > it gets requested, then we access it. With pinctrl we do not do
> > > > anything
> > > > - we just ask another layer to configure it and that is it.
> > > 
> > > this is true for almost anything we do:
> > > 
> > > - we ask another layer to allocate memory for us
> > > - we ask another layer to call our ISR once the IRQ line is asserted
> > > - we ask another layer to handle the input events we just received
> > > - we ask another layer to transfer data through DMA for us
> > > - we ask another layer to turn regulators on and off.
> > 
> > But we are _directly_ _using_ all of these. You allocate memory and you
> > (the driver) stuff data into that memory. You ask for DMA and you take
> > the DMAed data and work with it. Not so with pinctrl in omap keypad and
> > other drivers I have seen so far.
> 
> of course we are. If we don't mux the pins to their correct setting, we
> can't realy use the HW. So while you don't see any SW control of the
> requested pins, we're still making use of them.

So we make use of CPU too, and the main power supply, and memory chips.

> 
> > > and so on. This is just how abstractions work, we group common parts in
> > > a framework so that users don't need to know the details, but still need
> > > to tell the framework when to fiddle with those resources.
> > > 
> > > > I have seen just in a few days 3 or 4 drivers having exactly the same
> > > > change - call to devm_pinctrl_get_select_default(), and I guess I will
> > > > receive the same patches for the rest of input drivers shortly.
> > > > This suggests that the operation is done at the wrong level. Do the
> > > > pin configuration as you parse DT data, the same way you set up i2c
> > > > devices registers in of_i2c.c, and leave the individual drivers that
> > > > do
> > > > not care about specifics alone.
> > > 
> > > Makes no sense to hide that from drivers. The idea here is that driver
> > > should know when it needs its pins to muxed correctly.
> > 
> > The driver also needs memory controller to be initialized, gpio chip be
> > ready and registered, DMA subsystem ready, input core reade, etc, etc,
> > etc. You however do not have every driver explicitly initialize any of
> > that; you expect certain working environment to be already operable. The
> > driver does manage resources it controls, it has ultimate knowledge
> > about, pin configuration is normally is not it. We just need to know
> > that we wired/muxed properly, otherwise we won't work. So please let
> > parent layers deal with it.
> > 
> > > 95% of the time
> > > it will be done during probe() but then again, so what ?
> > > 
> > > doing that when parsing DT, or on bus notifiers is just plain wrong.
> > > Drivers should be required to handle all of their resources.
> > 
> > All of _their_ resources, exactly. They do not own nor control pins so
> > they should not be bothered with them either. Look, when you see that
> 
> except that they *own* the pins. Now that the muxer has been setup
> properly, this particular IP owns the pins.
> 
> > potentially _every_ driver in the system needs to set up the same object
> > that it doe snot use otherwise you should realize that individual driver
> > is not the proper place to do that.
> 
> fair enough, but IMHO, we're not there yet. We can't make that claim
> yet. Besides, we don't know what's the default pin state in a system. It
> might be that certain pins start out in a way which consumes less power
> due to the internal construction of the SoC. If we set pins up before
> driver probes, and probe fails or the driver is never really used, then
> we could be falling into a situation where we're wasting power.

So what about moving this into bus code - have bus's probe() request
default pin config before probe, revert to original setup when unbinding
or probe fails. You can even plug PM switching into bus code as well.

> 
> Granted, you can undo everything you did before,

Right, the same way as we undo every other initialization when something
goes wrong.

> but I guess keeping
> track of everything we setup before probe() just to remove a couple of
> lines from drivers is wrong.

If it was just about a couple lines in a couple of drivers that would
be fine. But the way I see it eventually every driver will need to do
this.

> 
> > > > > That's why it is named "get_select_default" and not "get" only.
> > > > > This API ensure that the pin will be set to the default state, and
> > > > > this
> > > > > is all we need to do during the probe.
> > > > 
> > > > Why during the probe and not by default? Realistically, the driver
> > > > will
> > > > be loaded as long as there is a matching device and pins will need to
> > > > be
> > > > configured.
> > > 
> > > likewise memory will be allocated when matching happens, IRQs will be
> > > allocated, regulators will be turned on. So why don't we do all that by
> > > default ? Because it is wrong.
> > 
> > No, because we do not know how. The generic layer does not know the ISR
> > to install, how much memory to allocate, etc. Having regulator turned on
> > before getting to probe might not be a bad idea.
> 
> what if your driver never probes ? Will you really leave regulators on
> consuming extra, valuable power ?

If we do it right in probe() we won't consume unless the dirver is bound.

> 
> > > > > There is no point to change the mux if the driver is not probed,
> > > > > because
> > > > > potentially the pin can be use be another driver.
> > > > 
> > > > What other driver would use it? Who would chose what driver to load?
> > > 
> > > Well, you _do_ know that on a SoC we have a limited amount of pins
> > > right ?
> > > 
> > > Considering the amont of features which are packed inside a single die,
> > > it's not farfetched to assume we will have a lot less pins then we
> > > actually need, so we need muxers behind each pin in order to choose
> > > which functionality we want.
> > > 
> > > If it happens that keypad's pins are shared with another IP (e.g. GPIO),
> > > we need to give the final user (a OEM/ODM) the choice of using those
> > > pins as either keypad or GPIOs, thus the need for pinctrl framework and
> > > the calls in the drivers.
> > 
> > Right, so please walk me through, step by step, how an OEM/ODM woudl
> > select a particular configuration. Do you expect it to happen at
> > runtime, or do you expect relevant data be put in DT?
> 
> It depends, I've seen both happening, really. Also note that DT
> migration is still not complete, meaning that most (all ?) OEM/ODMs are
> still using the legacy board-file-based approach and it will still take
> them a few years to move to DT-based boot.
> 
> Another point to consider is community boards such as beaglebone which
> have tens of different "capes" to support. Depending on the cape, pins
> might have to be remuxed, so instead of adding all that code to platform
> support, just leave it all in drivers. Depending on the "cape" different
> drivers will probe() and those drivers should know how to mux pins for
> themselves.
> 
> Note that these are only the two easy examples that came to my mind, I'm
> sure we can discuss this for a long, but is it valid ? For a single line
> of code ?

Multiply by hundred of drivers - yes.

-- 
Dmitry
--nextPart2284208.Hd1WifmENZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAgAGBQJQiCa1AAoJEH70+W8r6ZYquN0P/itzNu5rNpHNKAuFJ7Cg9QUv
htvHynRRp/E4XSQ8IKi6698jMVCccX0u8Y5ZP64QxybrY4PcnDjQww0XnCOHvZ5f
JU8wWVTiM0XcJagOp92mLsiS3it4IZvdGV+I7Uf7Yh39yEFZqXvRI9V0HIHvnqTI
ZNEOAOqgX8PY/Ztw1VG776geSYYsNhxzDsYl8HovNCLdTdWt58G12OX5rWS9cKH/
xF/Stokx7U2fgUI5dkymnRdtEU+6hPQALX4w0VxUAxuvmmdHNRFx0HFFXnxqVyWH
ODFS4+/OcW0vyzR9VhB+FbWL6G501Vi2CoreTXT8dHUkEhycxXNlIz2JIpuqxQE4
zpYeb0a/op7VpxgoI6cPWBe442AkkhXtMbWH2/RdsMxiA6Ldgl9Zu2kmxghu5seq
zRs75yEBvt6L1BtA20tbVbylxTWxc3FGvGIIWxDk7yGdUQBy0aw25NIAJGhcqDaa
ERwgqjxAKyt8fdUiRwC8/A0xNTVtWz7ChWtB55xJC86WNpEmIxYo+eBE5bDCdh97
lvzsReqXzLNWx4DuGbaKTNPgGuYp/QHBkUlu+cW0iDkYV3+oM+FVhUJAfcma2lRx
kMMj3gVbcjFx7QsBg4hAXJKm+SLC0O0CRCPxazdMQKRGjjSWHPcDPFWudjTFeBkC
FA3/maluZv8LhOxXivBo
=irX9
-----END PGP SIGNATURE-----

--nextPart2284208.Hd1WifmENZ--

