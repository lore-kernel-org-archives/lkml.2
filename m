Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2GPMqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:46:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52610 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2GPMqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:46:12 -0400
Date: Mon, 16 Jul 2012 14:46:08 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Adding support for configuring polarity in PWM framework.
Message-ID: <20120716124608.GA19148@avionic-0098.mockup.avionic-design.de>
References: <518397C60809E147AF5323E0420B992E3E960B0E@DBDE01.ent.ti.com>
 <20120716113921.GA3015@avionic-0098.adnet.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E960C32@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3E960C32@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:hcl4ROMLbv2n0TvRYMBK7fPvAPqbLakf0nQMDnK0XZr
 GeQll7sM4CILJNohidZZDL6cPerU2oJTB/01omOKTmCIuUvdzt
 0kYIkJyViXb3v27VwuN74l+KZNBsYbY839FiFiL3K52u/l5uAu
 Apk58hXNhdiHJwy5Ox7pWhgDHbfZzc+7CUCdK2OckWYAnLdxWl
 4PG6TfuSSL0b5VSzNLG4CQwZXZ4vvIdImcZpeYrXwDh91VJ8m/
 gS2B0cMDTN3nt5gdynVlDVFRLx47RzgQrmLqTZcQxFlvcEjjUy
 TFgdWqsKzlwsxtJ0ftnx9o7UPLmjmAHTe1VvdEU0Diexrhj1T0
 syzdfAPn2nE0pWa49YLgah4Da9IOV59F/cM7aBXfJ+PZhwU/Rs
 ZDwuvvr2TKqSrPAWmWUJgmCCyIao/bUbNU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 16, 2012 at 12:23:46PM +0000, Philip, Avinash wrote:
> On Mon, Jul 16, 2012 at 17:09:21, Thierry Reding wrote:
> > On Mon, Jul 16, 2012 at 11:15:50AM +0000, Philip, Avinash wrote:
> > > Hi Thierry,
> > >=20
> > > On one of the custom boards we are using, uses PWM to drive the backl=
ight. However, for
> > > this device, PWM signal needs to be inversed.
> > > So, we need to a platform data to indicate this parameter.
> > > Current PWM framework doesn't provide .support for setting polarity (=
or inverse polarity).
> > >=20
> > > Have you come across any such requirements? If so, do you have any pl=
ans to implement it?
> >=20
> > I don't have any plans to implement such a feature.
>=20
> Ok. Thanks for the quick response.
> >=20
> > > I am planning to add support for the same but want to avoid duplicati=
on of work.
> > >=20
> > > If you have no plans, then I will send a patch to support the same.
> >=20
> > I wonder how you want to implement this. You'll need special hardware
> > support for it=20
>=20
> Yes. Our custom hardware (backlight booster) requires the pwm signal to b=
e=20
> inverted.
>=20
> > you may be able to implement it in the driver itself=20
> > instead of putting it into the framework.=20
>=20
> This is a client specific data (backlight needs pwm signal inversed)=20
> and not the main device feature (not PWM IP). So we cannot send this in=
=20
> pwm platform data. This would come as call from client driver (which in=
=20
> our case is from pwm_bl.c)

Okay, I see.

> > Anyway I'm interested in seeing your patch.
>=20
> I am planning to modify PWM framework as below.
> 1. Configure PWM polarity from client driver (using platform data provide=
d=20
> to pwm backlight driver).
> 2. PWM device needs to be disabled before calling the set-polarity API.

Okay, that sounds sensible. A couple of comments though.

> This involves
>=20
> 1. PWM framework API addition.
> 	PWM frame work API support.
> 	/**
> 	 * pwm_setpolarity() - change a PWM device Polarity=09
> 	 * @pwm: PWM device
> 	 * @polarity: Configure polarity of PWM
>  	*
> 	 * polarity     - false -> "on" time defined by duty ns
> 	*              - true  -> "off' time defined by duty ns.
>  	*/
> 	int pwm_setpolarity(struct pwm_device *pwm, bool inversepol);

This should match the pwm_ops name, i.e.: pwm_set_polarity().

Making the polarity argument a boolean is slightly confusing. For
instance I'd say the logical value if I want normal behaviour would be
to set it to true, which doesn't match your example. So I propose you
define the polarity parameter as an enumeration to make its meaning more
explicit:

	enum pwm_polarity {
		PWM_POLARITY_NORMAL,
		PWM_POLARITY_INVERSE,
	};

PWM_POLARITY_{HIGH,LOW} and PWM_POLARITY_{POSITIVE,NEGATIVE} would be
other good name pairs.

> 2. Add "set_polarity" operation support in pwm_ops.
>=20
> 3. Modification in backlight driver (pwm_bl.c) to support polarity
> configuration.

We also need to think about how this could be represented in the device
tree. The most obvious choice seems to be a third cell for the specifier
and use a custom of_xlate callback for controllers that support polarity
inversion (and later perhaps other flags).

Also would you mind sharing the board setup code that you need this for?
I find it easier to get into the right mindset when looking at code that
actually uses this.

Thierry

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQBA0QAAoJEN0jrNd/PrOhGZkP/jQXQ7zWeh3wQH5k8+EMKGCb
WDjP0R0v+2mrE/Srq754GPBLoiCXPyjtmiwbJMwJTGywVK3u6AMtbS7kI5F4IVlN
fhfja4dl+eM52k7j+IJyBN9CIoAmO56d5LoCh5jOX/gw6H18ogkgP9Oe1EGoe59j
nCvCbkmssf3l1//a7dCPgl3UjPxn2MoLOpctrRer4NWVocH6m9WRY5w8n5s1Ht71
ORs6fbFH7oPhE3FwdvE4fpvOgf6kW6m48gGHSe05EklaFc78lST8Ig0r5iopNtqS
iDoRtSKzcrI2ZIRnqBvJQ0OeHXR1bFojkujN5/9tMHw/sW05ON6IylirJmPpaBic
9ed+ylta95t9amUhPtzQqwBx2IW4Xw2i/yMSov6yUCpR/xlf6lfiLj/VPmb7X/vh
9A9EA7m2HNlOslU+Y8Odoxmn6UHfKI8xMbCk3b2FRFx11DRPxjGJefQbUfE7tATa
YDpZv3iQHVrTFb9OMHPD98w/6IX0EQdNnFSHXsrs5ZI5P3DmzeKWejgITZ4CV5hg
rck5ARVAis0NIZdLcVKHgduzRXLr1kqZgmI6M1D2pGJ2fYc56DXQQ9EOEpIm4ViW
j8Ei8mS+fYJPbW8nF4teEkHCllyDR6VPBam9QQsDtT30gm6GZH5NZ8sKTStY6e6s
LFBTlU4weQxjW0b/50Of
=qO00
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
