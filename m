Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2K3GsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 01:48:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62178 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2K3GsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 01:48:09 -0500
Date: Fri, 30 Nov 2012 07:47:52 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] gpio: New driver for GPO emulation using PWM generators
Message-ID: <20121130064752.GB26474@avionic-0098.adnet.avionic-design.de>
References: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com>
 <20121123075537.A14713E0A91@localhost>
 <50AF3E21.4000009@ti.com>
 <50AF4584.7020604@ti.com>
 <20121126154600.765E03E1AFD@localhost>
 <50B5D161.6010200@ti.com>
 <20121129161024.EEA803E0912@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <20121129161024.EEA803E0912@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:q5Iqs0Xl3iurOWnpWRo4zTlpgjDxd43/oY1AtTCUOwj
 0lrZNapoiSGpWj9YrqpI5kUWpN3taYaEaL1TrlYyK0QgcPTP0r
 ndswHwz2Ox6Er017LVC9R2BTyyNz5mNu1wkxY67TntXeUIvyu6
 LLp10C1VCfJc9PQrV9iyGv1QJtOHcX0ropSeqThHAr61cMhh7u
 6zTOrgEL1vjD0SqP5n6R2ppkUcCFJsK5dzp2nTwERSQlvPJu0v
 X/Yj127+DvqFMKbi6WvBFWm60botPyXzM+EZCrh5fGQ5qgkssS
 UOaGB9ru31dGwjkzQoniAs4RoyKF2rf8r2kFJXQ+UBP/u3yFHP
 ByGL8m1ig8XfPnfMuOjeDds67BrHXN7TTbaqG1YpvywxAawiUG
 9gNbbXcwyoptE5WdiYO+KDMLzjuln0/lLw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2012 at 04:10:24PM +0000, Grant Likely wrote:
> On Wed, 28 Nov 2012 09:54:57 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com=
> wrote:
> > Hi Grant, Lars, Thierry,
> >=20
> > On 11/26/2012 04:46 PM, Grant Likely wrote:
> > > You're effectively asking the pwm layer to behave like a gpio (which
> > > is completely reasonable). Having a completely separate translation n=
ode
> > > really doesn't make sense because it is entirely a software construct.
> > > In fact, the way your using it is *entirely* to make the Linux driver
> > > model instantiate the translation code. It has *nothing* to do with t=
he
> > > structure of the hardware. It makes complete sense that if a PWM is
> > > going to be used as a GPIO, then the PWM node should conform to the G=
PIO
> > > binding.
> >=20
> > I understand your point around this. I might say I agree with it as wel=
l...
> > I spent yesterday with prototyping and I'm not really convinced that it=
 is a
> > good approach from C code point of view. I got it working, yes.
> > In essence this is what I have on top of the slightly modified gpio-pwm=
=2Ec
> > driver I have submitted:
> >=20
> > DTS files:
> > twl_pwm: pwm {
> > 	/* provides two PWMs (id 0, 1 for PWM1 and PWM2) */
> > 	compatible =3D "ti,twl6030-pwm";
> > 	#pwm-cells =3D <2>;
> >=20
> > 	/* Enable GPIO us of the PWMs */
> > 	gpio-controller =3D <1>;
>=20
> This line should be simply (the property shouldn't have any data):
> 	gpio-controller;
>=20
> > 	#gpio-cells =3D <2>;
> > 	pwm,period_ns =3D <7812500>;
>=20
> Nit: property names should use '-' instead of '_'.
>=20
> > };
> >=20
> > leds {
> > 	compatible =3D "gpio-leds";
> > 	backlight {
> > 		label =3D "omap4::backlight";
> > 		gpios =3D <&twl_pwm 1 0>; /* PWM1 of twl6030 */
> > 	};
> >=20
> > 	keypad {
> > 		label =3D "omap4::keypad";
> > 		gpios =3D <&twl_pwm 0 0>; /* PWM0 of twl6030 */
> > 	};
> > };
> >=20
> > The bulk of the code in drivers/pwm/core.c to create the pwm-gpo device=
 when
> > it is requested going to look something like this. I have removed the e=
rror
> > checks for now and I still don't have the code to clean up the allocated
> > memory for the created device on error, or in case the module is unload=
ed. We
> > should also prevent the pwm core from removal when the pwm-gpo driver i=
s loaded.
> > We need to create the platform device for gpo-pwm, create the pdata str=
ucture
> > for it and fill it in. We also need to hand craft the pwm_lookup table =
so we
> > can use pwm_get() to request the PWM. I have other minor changes around=
 this
> > to get things working when we booted with DT.
> > So the function to do the heavy lifting is something like this:
> > static void of_pwmchip_as_gpio(struct pwm_chip *chip)
> > {
> > 	struct platform_device *pdev;
> > 	struct gpio_pwm *gpos;
> > 	struct gpio_pwm_pdata *pdata;
> > 	struct pwm_lookup *lookup;
> > 	char gpodev_name[15];
> > 	int i;
> > 	u32 gpio_mode =3D 0;
> > 	u32 period_ns =3D 0;
> >=20
> > 	of_property_read_u32(chip->dev->of_node, "gpio-controller",
> > 			     &gpio_mode);
> > 	if (!gpio_mode)
> > 		return;
> >=20
> > 	of_property_read_u32(chip->dev->of_node, "pwm,period_ns", &period_ns);
> > 	if (!period_ns) {
> > 		dev_err(chip->dev,
> > 			"period_ns is not specified for GPIO use\n");
> > 		return;
> > 	}
>=20
> This property name seems ambiguous. What do you need to encode here? It
> looks like there is a specific PWM period used for the 'on' state. What
> about the 'off' state? Would different pwm outputs have different
> frequencies required for GPIO usage.
>=20
> Actually, I'm a bit surprised here that a period value is needed at all.
> I would expect if a PWM is used as a GPIO then the driver would already
> know how to set it up that way.

Just to make sure we're talking about the same thing here: if a PWM is
used as GPIO the assumption is that it would be set to 0% duty-cycle
when the GPIO value is set to 0 and 100% duty-cycle when set to the 1.
The period will still need to be set here, otherwise how would the PWM
core know what the hardware even supports?

Unless you're proposing to not include that in the PWM core but rather
in individual drivers. Then I suppose the driver could choose some
sensible default.

One other problem is that some PWM devices cannot be setup to achieve a
0% or 100% duty-cycle but instead will toggle for at least one period.
This would be another argument in favour of moving the functionality to
the individual drivers, perhaps with some functionality provided by the
core to do the gpio_chip registration (a period could be passed to that
function at registration time), which will likely be the same for all
hardware that can and wants to support this feature.

Thierry

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQuFaYAAoJEN0jrNd/PrOhfVUQAL2WpF6BqK5HHY9A0K4L71K5
BHuw5dm4I82ejsggkMj2HsPLcci65vcTK7y7AldiAMWOuXPxiKqKZPj2PFhcFxPZ
MpHdy8tPkR7Y+iwkY7Lxv6j+QrF2nRZzW+2siAAldqqzcHx3my7rF2kl6iFGao0T
qyIB31Ye385bgfm9EGDcLLLirernrae/r+i1nZv2fF+7xbb3AU4UFxJ9NIxeoeIQ
Cs4UpDEgrHMkVX8F2Y+vs+5ZfudQ7ZmCtyC9fWGhtHwYELOi8wnj4Yc6xz96+21g
sKqng8ugCdUN8PgHI+kB9hiUSir0y5TnoKsy3Ko16spRgxyshVbPxlvg8EEfRVtT
Zl0eLy53LB69GqiaxPs/ZZZ+6o5c20IFmZFLzwe71SXrzb0FOAdnJcctDlZopL0m
yGufaQi6XrdbfwtQlBE7SMq1tXV3NqJDNPtHmwUe7/i+xwNDvS8HRjcoxr7GYj1g
EIAo9SJBMHrPKygKUBJBYz9Tz2l1IchM/l/Q0k3Moz8LGhDArk9qMspqGrEGI+bE
QN5BPv9cuTmDrAH3Sf9aJQnh2Aqh7iYxM9nelOdjZzEQ2e2eWmQ2gy7ujvsp3ZeR
GYAcAsK64iTc6Hxg9I7PXsRiIJBSBuySIBeXztmMlEDxYdMG6M1h1usXDcbcWj/b
UbQF0/lYhEtysrpLCsMv
=LGVD
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
