Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917Ab2JaWUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:20:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35004 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502Ab2JaWUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:20:02 -0400
Date: Thu, 1 Nov 2012 00:14:02 +0200
From: Felipe Balbi <balbi@ti.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        <linux-kernel@vger.kernel.org>, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        <linux-omap@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121031221402.GA29490@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com>
 <20121031175219.GH12739@atomide.com>
 <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com>
 <20121031180935.GL12739@atomide.com>
 <50918223.6080003@ti.com>
 <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com>
 <20121031212639.GQ12739@atomide.com>
 <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 31, 2012 at 11:36:25PM +0200, Pantelis Antoniou wrote:
> > * Pantelis Antoniou <panto@antoniou-consulting.com> [121031 13:14]:
> >> On Oct 31, 2012, at 9:55 PM, Benoit Cousson wrote:
> >>>=20
> >>> Yeah, I do agree. I'm confused as well. Only OMAP IPs under PRCM cont=
rol
> >>> could have an hwmod and thus must be handled by an omap_device.
> >>>=20
> >>> Any devices that is created later cannot be omap_device. The DT core
> >>> will create regular platform_device for them.
> >>>=20
> >>> Since cape is an external board, it should have nothing to do with
> >>> omap_device.
> >>>=20
> >>> Looking at your patch:
> >>> da8xx-dt: Create da8xx DT adapter device
> >>>=20
> >>> I understand why you do that, but in fact that patch does not make se=
nse
> >>> to me :-(
> >>>=20
> >>> Why do you have to create an omap_device from the driver probe?
> >>>=20
> >>=20
> >> The problem is that capes are not external boards in the normal sense
> >> as a PCI board is. In the PCI case the hardware that implements the=20
> >> desired functionality is on the PCI board, while in the cape case the
> >> hardware module is in the SoC. The cape most of the times is quite
> >> simple and contains passive components, leds or some kind of I2C/SPI d=
evices.
> >=20
> > Ah now I see, you're talking about the beaglebone extension
> > boards :)
> >=20
> > The way to deal with those properly is to just edit the
> > board .dts entry to include omap-beaglebone-cape-xyz.dtsi
> > whatever.
> >=20
>=20
> That is what is being done...
> This is the fallout.
>=20
> >> You can't instantiate the omap_device early in the boot process like i=
t was done up to=20
> >> now in the board file. You can only do that later in the boot process =
(for built-in=20
> >> cape drivers), or even after user-space has booted and the matching ca=
pe driver module
> >> has been loaded.
> >=20
> > Yes you can, just edit the .dts file for the extension
> > board you have connected. This stuff should be DT
> > only for sure, let's not even start adding platform_data
> > entries for that.
> >=20
> > The omap_device entries for the omap internal devices
> > will be created automatically during startup based on the
> > .dts. Note that you can set status =3D "disabled" for the
> > omap internal devices in the .dts file, the devices are
> > there in the hardware.
> >=20
> > If you are sure the extension boards are safely hot
> > pluggable, then all you need is some interface to enable
> > and disable devices after booting. But that should be
> > done in Linux generic way.
> >=20
> > So we should not export any omap_hwmod or omap_device
> > things, and want to keep it __init only, and local to
> > arch/arm/mach-omap2.
> >=20
>=20
> I disagree. This is not something that is handled by just
> editing the dts. The way it is handled, is in the Linux
> generic way, we have a proper bus, and the drivers as compiled
> as standalone file.=20

when you have an actual bus, that'd be correct.

> We're hitting a use case that wasn't there in omap until now.
>=20
> There a a whole bunch of conflicting capes. There's no
> way to instantiate them together. They must be instantiated
> only after their EEPROMs are read and they are matched
> to their corresponding cape drivers.

why this requirement of instantiating them only after reading EEPROMs ?

It's unnecessary to add that requirement, just do what Tony said
(include my-awesome-cape.dtsi to bone.dts) and all i2c/spi devices
should be created automatically.

The thing is that there is no such thing as a cape-device. The cape is
just a collection of I2C, 1-wire and SPI devices anyway. What we should
instantiate is bmp085, tls2550, sht21, instead of instantiating
beagle-bone-weather-cape.

What's the problem in just instantiating all of those from bone.dts ?
Expose the EEPROMs to userland so whatever SW you guys have running on
the bone can figure out what features to expose to the SDK which the
user sees, but the kernel doesn't need to know that there is a
weather-cape attached to the bone.

--=20
balbi

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkaKpAAoJEIaOsuA1yqREv/cP/2DU7WZTW4vGCbcoziwvFopQ
Lm9TsurDc6SQwRRSWICHyOEctrlYIOo4tcAlF4fl0pN8pGCCvu0lIkfESSOSoLvM
6ro0gjKSL+Dp/5bkYSPcF0PtTN3B4PEsyBBfTnbm7/wKJQPH1YM2iiR6puBB+2or
SK21JKbrLDnsRmUMNZuQf53Wxeb7GaJGCnIbf2TYVT8TO1r27Hn46MAlRTHBScAd
dF9UClTFUjWK9TkX5IcpLAn3g5VA6Q1N2R9rguWN6uWfyNklThy2jYooN4xaqT+a
9HDQpf1RhIC1ubiJj9Xo8qbeuq2NLsRe6Htm6ziOg83hgn9edKYQda24dxuZblIa
qReHGxzCkWDTW+nD91FM9UIcX20s7VJPs+z0vzwL4JPPPY/3MbLA6RaBYHpK9gz3
aEjDHQVmvKSJqjsQ3SVJ/p1Aikhv8/C8zFOvWCE2mRz1db4XxgX3frQjjEzepINJ
Zu1mQh6nhM+fdlIgd4+hkAu6Sn7fMQ2L4jdAW/Um/9vdkRbLTl0CSLp+VauoVyvf
o61SI7o/d+ZmyAcBZ6DLjkcODs3TlQS43FlT/4doeotP7sUf0cetnhvxxMAdgMSW
p82JIud6on/SaLYcvOzjyPY1JmV9bomRPEWOGmwyWE3R/XQGVWvP6BsiW78S7eBG
C4Vx3UVEdDILtOxuHj2S
=hscY
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
