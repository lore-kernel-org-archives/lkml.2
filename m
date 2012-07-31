Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab2GaJNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:13:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51804 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab2GaJNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:13:40 -0400
Date: Tue, 31 Jul 2012 11:13:24 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Simon Glass <sjg@chromium.org>, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
Message-ID: <20120731091324.GA15557@avionic-0098.adnet.avionic-design.de>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
 <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
 <CAPnjgZ0H2xrJcL-ytMaX11iYrrhCg7LEM00u_NgEaveM4gHMPw@mail.gmail.com>
 <50179933.9090501@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <50179933.9090501@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Zgo2nAbDyh6dT4yEFyFK6pUAkegsqFt6pteNIRsOMcO
 XyLXtLQpwqXpQMFC0qQNbwhbiIBimJnBDqyUNtaoc4LFYc8C4W
 ZPr6dsWHw05EYF/8NgEmila8xXyp9KoBnPVspGNtipROg+Mm3Z
 IY6VlYjteNsipOL8sMu3e2fSwcYOApI++hRLgMxuio7W9ko1aO
 nfATtKTPI8wKTw+23y/Ka7AOuqPYBDTQQ7jsfdaPoQNwenivTr
 DL4eVx0J0OgUWzqRBgLoWio2EdPliJL3wOTRwVlSdX790IAEma
 XkbTdejP6HZYUZ8xKo/ZNyQdqXbdp5iJVh40IcrTh02EIKeluf
 eFbP7DZQ5hnT+jDVWcmqmM06P3fCCUGQlE4qWNtZqcMBJFAyJj
 POhnBIwPfPOKDgwTWCnWU+tABhM68w70Fa0To7TKwG9S7nLJbl
 HOnK6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 31, 2012 at 05:37:07PM +0900, Alex Courbot wrote:
> Hi Simon,
>=20
> On 07/30/2012 08:00 PM, Simon Glass wrote:
> >For the delay, I think milliseconds is reasonable. I suppose there is
> >no reasonable need for microseconds?
>=20
> I don't see any need for microseconds myself - anybody sees use for
> finer-grained delays?
>=20
> Btw, I noticed I was using mdelay instead of msleep - caught and fixed th=
at.

You might want to take a look at Documentation/timers/timers-howto.txt.
msleep() isn't very accurate for periods shorter than 20 ms.

> >>+Device tree
> >>+-----------
> >>+All the same, power sequences can be encoded as device tree nodes. The=
 following
> >>+properties and nodes are equivalent to the platform data defined previ=
ously:
> >>+
> >>+               power-supply =3D <&mydevice_reg>;
> >>+               enable-gpio =3D <&gpio 6 0>;
> >>+
> >>+               power-on-sequence {
> >>+                       regulator@0 {
> >>+                               id =3D "power";
> >
> >Is there a reason not to put the phandle here, like:
> >
> >                                    id =3D <&mydevice_reg>;
> >
> >(or maybe 'device' instead of id?)
>=20
> There is one reason, but it might be a bad one. On Tegra, PWM
> phandle uses an extra cell to encode the duty-cycle the PWM should
> have when we call get_pwm().

This is not only the case on Tegra, but it is the default unless a
driver specifically overrides it. The second cell specifies the index of
the PWM device within the PWM chip. The third cell doesn't specify the
duty cycle but the period of the PWM.

> This makes it possible to address the
> same PWM with different phandles (and different duty cycles),

How so? A phandle will always refer to a PWM chip. Paired with the
second cell, of_pwm_request() will resolve that into the correct PWM
device.

> which
> causes an issue to know whether a PWM is already used in a sequence
> (potentially resulting in multiple get_pwm calls on the same PWM,
> and also opens the door to ambiguities in behavior (what is the
> correct duty-cycle to use if several different values are passed?)

You can't request a PWM multiple times. The second call well return
-EBUSY, or rather ERR_PTR(-EBUSY).

Thierry

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQF6G0AAoJEN0jrNd/PrOhMyUQAJfxn3CN8jL9eOfJvuydRKbI
qtkNVM0Nf64njMM7HJeluKRH49Uz3hyCIQizb1yGO+M/Hw7dcWVOtod98RkVYj6V
SdQPslaFZ8dLbkvgk096HK3W4yFQDWfBKjSxOyhkZbMpW0X0UPCH8oIJjIvnDjU6
L+h14m32KM05G34fkWX1HEd0ZxQKFH6C26JG4NCoZAwUUyrnpzlpB3r6dW6vCcIq
h0oLjpSKpbjW/A+4i8eHddVU1BCIF6uVz66xYxV5Bk+LyYOxo5xgC641WK9hqVUt
HN9jjZFNVVEUHRCAKUFsXDl1xTd0MLnnCSqdtwaKWOIEY85GnN9qdmcoqAniU9os
J4AU1MlOQH28pwqXpOqE2I3qtziRc58JTkW1byu6i+3KXHv9BtM6asAg7q368Bas
ZVQXL1rG9RXAqnExfsIKp4/FGACNLcMRBs20U0pAmvxRWWvqBJU3Qgmhd/E6gZvo
JTv6bS0lkCQVoXLExtLkX8fNyQQ/Qjuv5Si7FqJKXeaRTeTomc7HevLi1FCmOCL2
LbGgY3psQtLHIpVILJ5HuYklO3qDYhN7S2wamymOBHLnvkr4+FwTjLEI6ssi31SA
J+JgYwWDrf4uDFcJHzUfievMPHAare/iwtkkNanZQgqPtwH0t5CdAmqFxoYLeGzx
AQggMaS+7U+NoQMl1L7m
=rfpZ
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
