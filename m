Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab1D0MTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 08:19:10 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53088 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758966Ab1D0MTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 08:19:08 -0400
Date: Wed, 27 Apr 2011 08:19:02 -0400
From: Eric B Munson <emunson@mgebm.net>
To: David Laight <David.Laight@ACULAB.COM>
Cc: benh@kernel.crashing.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@elte.hu, acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org, stable@kernel.org
Subject: Re: [PATCH V4] POWER: perf_event: Skip updating kernel counters if
 register value shrinks
Message-ID: <20110427121902.GA2936@mgebm.net>
References: <1302891150-8121-1-git-send-email-emunson@mgebm.net>
 <AE90C24D6B3A694183C094C60CF0A2F6D8ACFA@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8ACFA@saturn3.aculab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Apr 2011, David Laight wrote:

> I keep telling Eric that the code below is incorrect
> modulo arithimetic...

But it isn't, and it doesn't have trouble with 2^32 - 1.  Here is one done =
by
hand:

Counter is at 0xffffffff and is rolled over to 0x101 (258 counted items so
that we miss the test for rollback).

 0x00000000ffffffff  (Remember counters are 32 bit, but we store them in 64)
-0x0000000000000101
=3D0xffffffff00000102

After the mask we have 0x00000000000102, the actual difference between the
counters.

>=20
> > +static u64 check_and_compute_delta(u64 prev, u64 val)
> > +{
> > +	u64 delta =3D (val - prev) & 0xfffffffful;
> > +
> > +	/*
> > +	 * POWER7 can roll back counter values, if the new value is
> smaller
> > +	 * than the previous value it will cause the delta and the
> counter to
> > +	 * have bogus values unless we rolled a counter over.  If a
> coutner is
> > +	 * rolled back, it will be smaller, but within 256, which is the
> maximum
> > +	 * number of events to rollback at once.  If we dectect a
> rollback
> > +	 * return 0.  This can lead to a small lack of precision in the
> > +	 * counters.
> > +	 */
> > +	if (prev > val && (prev - val) < 256)
> > +		delta =3D 0;
> > +
> > +	return delta;
>=20
> The code should detect rollback by looking at the value of 'delta'
> otherwise there are horrid end effects near 2^32-1.
>=20
> For instance:
> 	u32 delta =3D val - prev;
> 	return delta & 0x80000000 ? 0 : delta;
>=20
>=20
>    David
>=20
>=20
>=20
>=20

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNuAm2AAoJEH65iIruGRnNJXUIAMmRQhchWoC5zG6wCyZ4O9Na
K28xPGqGF9JHka0P7AL5M5pJtaZxG8uu2bGb/hAYKSh+v99PUxT8YFaFTII4X0Ns
ZbS13ErCrn+tq7uuF/IVFztG7SsZCLoYlE/AIcNzYGyGT053Jo5oqjloyfRpmv6Z
NtqDUSiuF58bEP7NnNO7Pl3uOJAcrO1NZ+285DPXq1qeQk6SaT5t8TQlOcKFuhYU
ajiSBYVgc//EF0ih4uCmoPZch1lKILwZk28Dj5jfoSNDU6Ab9k3Rw760p5HFKz0s
eNIM0qGg7zLZhicJaOcZvsaCuvRRVWEX5hm06gSTb6i7OyTFjO9JGRduhakQJ8o=
=caaf
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
