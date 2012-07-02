Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2GBGrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 02:47:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52436 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab2GBGrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 02:47:37 -0400
Date: Mon, 2 Jul 2012 08:46:24 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org, Mitch Bradley <wmb@firmworks.com>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
Message-ID: <20120702064624.GA8683@avionic-0098.mockup.avionic-design.de>
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com>
 <20120630183742.GE23990@avionic-0098.adnet.avionic-design.de>
 <4FF116F0.5070602@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <4FF116F0.5070602@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:hHexCSLajcylD7I0DdBJRalzSTDtHPoenYqkz8fDjsr
 3lsOPSPPdszI37zcLIHg028WiylHoy3jkOHORiDLsr+r3ReajC
 T/L0EnxqTOwB1jssPppiWFM0ddgc5l2fYF+mAC55jVWX0065Iz
 Ja6KpM5WPCUFF3RGs2ICtXrEkG8Y0vz8jdye5JF8PxXUnlhqlP
 +Up1fgln8ZHTaO/3Lj/M/hC0ck/E4fZG+K9cbOcSm8m7NonX7O
 vChyO0YuiG+2fOHyMEs/G+fP55+JWyru2HX+y78iFeyQJOSyYO
 OZedm3ND/1pJO1XldOTno+HcSIVhJ/GhYaRil5MPvqdLoOoddO
 nV6URRujCiklttvdV2Jh4Ayd3310u2vQtOOf85X4mRM4Wuajm7
 kpf1n8wY0AzLyODqwLNw5gVmplb7ojlRns=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 02, 2012 at 12:35:12PM +0900, Alexandre Courbot wrote:
> On 07/01/2012 03:37 AM, Thierry Reding wrote:>> +	ret =3D
> of_get_named_gpio(node, "enable-gpios", 0);
> >> +	if (ret >=3D 0) {
> >> +		data->enable_gpio =3D of_get_named_gpio(node, "enable-gpios", 0);
> >
> > Can't you just reuse the value of ret here?
>=20
> Yes, definitely.
>=20
> >> +	pb->enable_gpio =3D -EINVAL;
> >
> > Perhaps initialize this to -1? Assigning standard error codes to a GPIO
> > doesn't make much sense.
>=20
> Documentation/gpio.txt states the following:
>=20
> "If you want to initialize a structure with an invalid GPIO number, use
> some negative number (perhaps "-EINVAL"); that will never be valid."
>=20
> gpio_is_valid() seems to be happy with any negative value, but
> -EINVAL seems to be a convention here.

I would have thought something like -1 would be good enough to represent
an invalid GPIO, but if there's already a convention then we should
follow it.

> >> +	/* optional GPIO that enables/disables the backlight */
> >> +	int enable_gpio;
> >> +	/* 0 (default initialization value) is a valid GPIO number.
> Make use of
> >> +	 * control gpio explicit to avoid bad surprises. */
> >> +	bool use_enable_gpio;
> >
> > It's a shame we have to add workarounds like this...
>=20
> Yeah, I hate that too. :/ I see nothing better to do unfortunately.
>=20
> Other remarks from Stephen made me realize that this patch has two
> major flaws:
>=20
> 1) The GPIO and regulator are fixed, optional entites ; this should
> cover most cases but is not very flexible.
> 2) Some (most?) backlight specify timings between turning power
> on/enabling PWM/enabling backlight. Even the order of things may be
> different. This patch totally ignores that.
>=20
> So instead of having fixed "power-supply" and "enable-gpio"
> properties, how about having properties describing the power-on and
> power-off sequences which odd cells alternate between phandles to
> regulators/gpios/pwm and delays in microseconds before continuing
> the sequence. For example:
>=20
> power-on =3D <&pwm 2 5000000
> 	    10000
> 	    &backlight_reg
> 	    0
> 	    &gpio 28 0>;
> power-off =3D <&gpio 28 0
> 	     0
> 	     &backlight_reg
> 	     10000
> 	     &pwm 2 0>;
>=20
> Here the power-on sequence would translate to, power on the second
> PWM with a duty-cycle of 5ms, wait 10ms, then enable the backlight
> regulator and GPIO 28 without delay. Power-off is the exact
> opposite. The nice thing with this scheme is that you can reorder
> the sequence at will and support the weirdest setups.

I generally like the idea. I'm Cc'ing the devicetree-discuss mailing
list, let's see what people there think about it. I've also added Mitch
Bradley who already helped a lot with the initial binding.

> What I don't know (device tree newbie here!) is:
> 1) Is it legal to refer the same phandle several times in the same node?
> 2) Is it ok to mix phandles of different types with integer values?
> The DT above compiled, but can you e.g. resolve a regulator phandle
> in the middle of a property?

I believe these shouldn't be a problem.

> 3) Can you "guess" the type of a phandle before parsing it? Here the
> first phandle is a GPIO, but it could as well be the regulator. Do
> we have means to know that in the driver code?

That isn't possible. But you could for instance use a cell to specify
the type of the following phandle.

> Sorry for the long explanation, but I really wonder if doing this is
> possible at all. If it is, then I think that's the way to do for
> backlight initialization.

OTOH we basically end up describing a code sequence in the DT. But as
you mention above sometimes the hardware requires specific timing
parameters so this might actually be a kind of valid sequence to
describe in the DT.

Thierry

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP8UPAAAoJEN0jrNd/PrOh5vQP/iTyzdqQzt0jr0JkmF4GtUZ9
bq8+ZK+QksmheZWiOs3qWhSM0ZXBwbCBQOj79fYwYEOgrK7cZf8jNGiWruGetTC7
ahCT9VQSqUus3p/Ws7L9PD66napcN54rSdp/ZybyWMO2RP328m7Ocfjzhml0nlr2
vfmh8ErXBqa+DfVCR0bvMegAEhNRTGSyQTOGNKJT9sDWfXiAVfpQQLbUTfhRs8xd
/5VVTDFTLT+2a1CW6Y+4io0oGMOQuWeD7+pPkT7UCjz8J2V7yHtfRjsHxpZfKTcQ
i47E/K2M+hXtA2Ct0kUnUIvtRzka9bxKGXxMsEJaWyKPgHZxCYVpUT9LPAxkDve1
K9TByGaOJTdxjJf772fBthZO6uIKp0l59MFxhrdFVwUOhi2A84gHdXggKPht6Nm6
2Is7GxIk0UixJJRt97cerCSFw40crnezBzQlvNdndfjlyodTRjR1z620KlHBPA+y
gcYQ0Lav0QB6JrD+B1Cx8gRoVJCft5y6r5mKAhQ13Dou4uLHLTQW0xd8M07dfp8u
M8MF0WyydD0b1vEq23NFCiR0GVCERYY6yfj5zQ1RwKQHa1ftLtvZ+pSIclprztDV
/eex4Oj/XGnyDAhPpK8Pp6zZwLW6ji+G1PaNucISw6IlszQ1OqYhQNQbNrMHmEZN
XoRd4bJ85aUZR+DVMSSi
=1aKk
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
