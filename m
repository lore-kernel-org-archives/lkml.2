Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab1JEU1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 16:27:15 -0400
Received: from smtp209.alice.it ([82.57.200.105]:41818 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab1JEU1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 16:27:14 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Oct 2011 16:27:13 EDT
Date: Wed, 5 Oct 2011 22:21:43 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [sparse stuff] bug in lp3944_led_set_brightness()
Message-Id: <20111005222143.665f7a7e922dbb2b2541007a@studenti.unina.it>
In-Reply-To: <20111005093248.GA6792@mwanda>
References: <20111005093248.GA6792@mwanda>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__5_Oct_2011_22_21_43_+0200_UAbZ2PtMPzAVTnJ0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Oct_2011_22_21_43_+0200_UAbZ2PtMPzAVTnJ0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 5 Oct 2011 12:32:48 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> Hi Antonio,
>=20
> I was going through some Sparse warnings and this one seems pretty
> valid.
>=20
> drivers/leds/leds-lp3944.c +292 23:
> 	warning: mixing different enum types
>=20
>    284  static void lp3944_led_set_brightness(struct led_classdev *led_cd=
ev,
>    285                                        enum led_brightness brightn=
ess)
>    286  {
>    287          struct lp3944_led_data *led =3D ldev_to_led(led_cdev);
>    288 =20
>    289          dev_dbg(&led->client->dev, "%s: %s, %d\n",
>    290                  __func__, led_cdev->name, brightness);
>    291 =20
>    292          led->status =3D brightness;
>                 ^^^^^^^^^^^^^^^^^^^^^^^^
>    293          schedule_work(&led->work);
>    294  }
>
>
> led->status should be values between 0-3.  brightness is 0, 127 and
> 255.
>=20

Hi Dan, thanks for reporting that.

AFAICS this is not a problem _in_practice_ as lp3944_led_set_brightness
() is called by the leds framework with brightness values already
limited by max_brightness, so it is always 0 or 1 in our case. The
sparse warning is not pretty tho, so I guess we can safely get rid of it
anyways with:

	led->status =3D !!brightness;

keeping track of LP3944_LED_STATUS_OFF and LP3944_LED_STATUS_ON only in
lp3944_led_set_brightness() is OK, as the handling of DIM (blinking)
mode[s] is in lp3944_led_set_blink().

I am following up with a patch in that direction tomorrow, after a test
on the actual hardware.

This is the rationale behind the current code if it is of any interest:
in the development phase of the driver I was abusing brightness =3D {2,3}
to trigger the hardware blinking function, but then I set the
max_brightness to 1 and so this abusing mechanism became inactive and I
must have forgotten about it.

Thanks again.

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__5_Oct_2011_22_21_43_+0200_UAbZ2PtMPzAVTnJ0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6MvFcACgkQ5xr2akVTsAG+dgCePLwURZVQQ80ecCgNCghS2COh
e4oAn271qcGbrrY7yir7YCTnqgAQL0n1
=YVgE
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Oct_2011_22_21_43_+0200_UAbZ2PtMPzAVTnJ0--
