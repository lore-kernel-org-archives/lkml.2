Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab1IIClj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 22:41:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37792 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932548Ab1IIClh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 22:41:37 -0400
Subject: Re: Bug#640964: linux-image-3.1.0-rc4-486: BUG() triggered on XO-1
 hardware
From: Ben Hutchings <ben@decadent.org.uk>
To: Andres Salomon <dilinger@queued.net>, 640964@bugs.debian.org
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 09 Sep 2011 03:41:19 +0100
In-Reply-To: <20110908174625.1b97223a@queued.net>
References: <20110908174625.1b97223a@queued.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FU6VNydLw5GmUKfv5dcA"
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315536091.23168.77.camel@deadeye>
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FU6VNydLw5GmUKfv5dcA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-09-08 at 17:46 -0700, Andres Salomon wrote:
> Package: linux-image-3.1.0-rc4-486
> Version: 3.1.0~rc4-1~experimental.1
> Severity: normal
>=20
> During boot on an OLPC XO-1, I encounter the following problem.  I
> believe it's the statement BUG_ON(a->cpuid >=3D NCAPINTS*32), though I'm
> not staring at an exact copy of linux-2.6 source.
[...]

Agreed.

Variable a is in the EBX register, value 0xc143c668.  Looking at a dump
of this kernel image, the __alt_instructions array starts with:

 c143c638 7e51bcff 1c050000 1a000503 7d51bcff  ~Q..........}Q..
 c143c648 13050000 1a000503 6653bcff 0a050000  ........fS......
 c143c658 19000503 00000000 ce55bcff 00000000  .........U......
 c143c668 9a000200 cf55bcff f1040000 e4000303  .....U..........
 ...

Converting back to C structures:

/* instr_offset, repl_offset, cpuid, instrlen, replacementlen */
{ 0xffbc517e, 0x0000051c, 0x001a, 0x05, 0x03 },
{ 0xffbc517d, 0x00000513, 0x001a, 0x05, 0x03 },
{ 0xffbc5366, 0x0000050a, 0x0019, 0x05, 0x03 },
{ 0x00000000, 0xffbc55ce, 0x0000, 0x00, 0x00 },
{ 0x0002009a, 0xffbc55cf, 0x04f1, 0x00, 0x00 },
...

Oops, we have 4 bytes of zeroes between what should be elements 2 and 3.
That results in __alt_instructions[4].cpuid =3D=3D 0x04f1 which trips the
BUG check.  This is nothing OLPC-specific; it's going to happen on any
machine trying to boot this image.

So the question is, where does that padding come from?

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-FU6VNydLw5GmUKfv5dcA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATml8z+e/yOyVhhEJAQoC4BAAmiB/t6lVOzryrW5sOgDT17rnT2T7AIJD
xZqEN+QRkA3VZfck0LYewJr8fMFokGazPC+xKWQsyQ49cqLHBjtX18ssW9e5SCQc
lorzMK5yQMO+oE/7hDxdz5ewq33qjDRnwW6HuXhFTLAHGr4Y11HaO+70CecHib4s
wjQGL1+wvkR82ZyL3bOHv7XtVkbcZiiAtp+7KWxZA2z3FYDREF4yGrmzlrymXbuI
VBj8RO9/+iE1xTJ+9T4wi15YvTBG7Uu+SWVsSIa5MIszQtgATTHc9Gn1VJqVyjU8
lAPBGZfnRZeDU/f+Kw8QrE3BywMfd18EzSe8d07uW2kcrMUbf5ve0ktgi3QVy2lX
AAWsHXs20I6Ra6YHbQrzU9y7f3eZCrFbOmEvI3gx31JeH0GDKzt59aBKJjhyClAe
icH4WGFgPEEHH1brtVePLc/Jd1DzJvRVQq4cX/Kqn7jWFX7Meb0tk23xwmuPfllP
sLY5FKmZUEn1CbYIEBd0QjJrfjnKO4in3PQ5RF8YO+9+/OIUyH/c2QA7BsThVC+L
pRyr73yQS10isMF2owDuTO4g6HC3JfhFBsa/AlAH3pe9Pf5UB9PiBhmPWKx5sB5F
75cNAdW3tyQXrC/A93dk48lwqqAW7qk/sEhqcB9v67cSQ5WApZ93lLTtNsEILcpl
Nmqi08F75W0=
=M5Bt
-----END PGP SIGNATURE-----

--=-FU6VNydLw5GmUKfv5dcA--
