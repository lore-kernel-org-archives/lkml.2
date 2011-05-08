Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab1EHSqR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:46:17 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:44993 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150Ab1EHSqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:46:14 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix msecs_to_jiffies() to not return values greater than MAX_JIFFY_OFFSET
Date: Sun, 08 May 2011 20:46:02 +0200
Message-ID: <2449315.uFq6U1Y0gp@donald.sf-tec.de>
User-Agent: KMail/4.6 beta5 (Linux/2.6.37-12-desktop; KDE/4.6.3; i686; ; )
In-Reply-To: <alpine.LFD.2.00.1103292103070.2774@localhost6.localdomain6>
References: <2120287.WTetKHanc4@donald.sf-tec.de> <alpine.LFD.2.00.1103292103070.2774@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4326514.ih5fhWiH25"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart4326514.ih5fhWiH25
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Am Dienstag, 29. M=E4rz 2011, 21:42:59 schrieb Thomas Gleixner:
> On Tue, 29 Mar 2011, Rolf Eike Beer wrote:
> > The documentation of msecs_to_jiffies() says:
> >  * - negative values mean 'infinite timeout' (MAX_JIFFY_OFFSET)
> >  *
> >  * - 'too large' values [that would result in larger than
> >  *   MAX_JIFFY_OFFSET values] mean 'infinite timeout' too.
> >=20
> > But when you pass in e.g. MAX_JIFFY_OFFSET + 1000 for HZ =3D 1000 i=
t will
> > not return MAX_JIFFY_OFFSET, but the bigger value. This makes sure =
that
> > the value
>=20
> That's only true for 32 bit.
>=20
> > returned from this function can never be bigger than MAX_JIFFY_OFFS=
ET.
> > Also use DIV_ROUND_UP() in one place where that is open coded.
> >=20
> >  unsigned long msecs_to_jiffies(const unsigned int m)
> >  {
> >=20
> > +=09unsigned long r;
> >=20
> >  =09/*
> >  =09
> >  =09 * Negative value, means infinite timeout:
> >  =09 */
> >=20
> > @@ -445,7 +446,7 @@ unsigned long msecs_to_jiffies(const unsigned i=
nt m)
> >=20
> >  =09 * round multiple of HZ, divide with the factor between them,
> >  =09 * but round upwards:
> >  =09 */
> >=20
> > -=09return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ);
> > +=09r =3D DIV_ROUND_UP(m, MSEC_PER_SEC / HZ);
> >=20
> >  #elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
> > =20
> >  =09/*
> >  =09
> >  =09 * HZ is larger than 1000, and HZ is a nice round multiple of
> >=20
> > @@ -457,7 +458,7 @@ unsigned long msecs_to_jiffies(const unsigned i=
nt m)
> >=20
> >  =09if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
> >  =09
> >  =09=09return MAX_JIFFY_OFFSET;
> >=20
> > -=09return m * (HZ / MSEC_PER_SEC);
> > +=09r =3D m * (HZ / MSEC_PER_SEC);
>=20
> For this case the jiffies_to_msec() check should be sufficient.
>=20
> >  #else
> > =20
> >  =09/*
> >  =09
> >  =09 * Generic case - multiply, round and divide. But first
> >=20
> > @@ -467,9 +468,10 @@ unsigned long msecs_to_jiffies(const unsigned =
int
> > m)
> >=20
> >  =09if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET)=
)
> >  =09
> >  =09=09return MAX_JIFFY_OFFSET;
>=20
> Hmm, this check is silly. MUL32 is chosen, so that we cannot overflow=
.
>=20
> > -=09return (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
> > +=09r =3D (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
> >=20
>   =09=09>> MSEC_TO_HZ_SHR32;
> > =20
> >  #endif
> >=20
> > +=09return min_t(unsigned long, r, MAX_JIFFY_OFFSET);
> >=20
> >  }
> >  EXPORT_SYMBOL(msecs_to_jiffies);
>=20
> I start to wonder whether we really need these three variants or
> whether we just could go with that MUL/SHIFT based implementation and=

> a final check for MAX_JIFFY_OFFSET. That would boil down to:
>=20
> unsigned long msecs_to_jiffies(const unsigned int m)
> {
> =09u64 res =3D (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32) >> MSEC_TO_H=
Z_SHR32;
>=20
> =09return min_t(unsigned long, (unsigned long)res, MAX_JIFFY_OFFSET);=

> }
>=20
> That'd avoid the whole division and msecs_to_jiffies() is not really =
a
> high precision function.

Ping? Is anyone going to either take my patch or do it's own reworking =
of that=20
function?

Eike
--nextPart4326514.ih5fhWiH25
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk3G5PIACgkQXKSJPmm5/E6tLwCggxvZB6FM7BxAJ/adTuoccYP8
a74An2qWN5i2IJKQjBQEiC6BEhCNsYHn
=Icpz
-----END PGP SIGNATURE-----

--nextPart4326514.ih5fhWiH25--

