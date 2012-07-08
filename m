Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2GHBHF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 21:07:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51623 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748Ab2GHBHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 21:07:03 -0400
Message-ID: <1341709606.25597.182.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 07/12] random: use the arch-specific rng in
 xfer_secondary_pool
From: Ben Hutchings <ben@decadent.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, stable@vger.kernel.org
Date: Sun, 08 Jul 2012 02:06:46 +0100
In-Reply-To: <1341614704-24965-8-git-send-email-tytso@mit.edu>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
	 <1341614704-24965-8-git-send-email-tytso@mit.edu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-r7QsbIvlEsogW7sGG4hi"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-r7QsbIvlEsogW7sGG4hi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-07-06 at 18:44 -0400, Theodore Ts'o wrote:
> If the CPU supports a hardware random number generator, use it in
> xfer_secondary_pool(), where it will significantly improve things and
> where we can afford it.
>=20
> Also, remove the use of the arch-specific rng in
> add_timer_randomness(), since the call is significantly slower than
> get_cycles(), and we're much better off using it in
> xfer_secondary_pool() anyway.
[...]
> @@ -838,7 +834,11 @@ static ssize_t extract_entropy(struct entropy_store =
*r, void *buf,
>   */
>  static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
>  {
> -	__u32 tmp[OUTPUT_POOL_WORDS];
> +	union {
> +		__u32	tmp[OUTPUT_POOL_WORDS];
> +		long	hwrand[4];
> +	} u;
> +	int	i;
[...]
> +	for (i =3D 0; i < 4; i++)
> +		if (arch_get_random_long(&u.hwrand[i]))
> +			break;
> +	if (i)
> +		mix_pool_bytes(r, &u.hwrand, sizeof(u.hwrand), 0);
[...]

Surely the number of random bytes being added is i * sizeof(long), not
sizeof(u.hwrand)?

Ben.

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-r7QsbIvlEsogW7sGG4hi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/jdJue/yOyVhhEJAQq5NQ/7BLoigeocFKSaL9FqcWJc78R9371Ns6i8
scsLxlDXJPsWLRj+yv/rw1D6e7I2oEJq6/u1CCJM/Y996h1Gg1Otm57cK82rQtJG
/ZwO2l+5bW+L8Kb4zvsp8VeFx2bapIKFwM+J28WRlmo6P501B3p+L4X/y3SH7Q8H
8Rd754LFf7FKWtohlnglSgRM5umBilvU2pXCyoqcunFakKj7hi/R5LXzNrrs+DwN
EDIVSbiyyIM4IAZlpku1htDBv0iGsWtcnXC4mvO+rbF+Uqi6/wcB+CP9WU/6J9ch
BsK0P75pqwCzaZ1QrC34m0DNqIE0O/TiKdmixdBcGC/ZREyHYvFANazIzcRxyoIW
J84h41O7kq9/8ynZUPLWtjUBGC2tUINiQ0xYBmR6dBYFQr9wHFgzUJOJZggudpoO
XCoPE3CO6P8h6BzGYDEziIoy9wetHwV1UBVAGYsYKdEb/fvtT/oJ0RYprCWI+wQk
aXJ73EEThc2iGXxrRvB5RjUZuV95DHeUXyUMREaP+Vo9WfnVdJgLsu2fUmTCJbj9
vAgMy9Ghzg0l1UAYP8yvfeuGTKPcqX2ZVIiyLa/S7PMd4hjPY0xV3I/LMYPBf5Lc
A/LDnqYl5/pvmWMDWuUFL2ifQnjFN4xldCSfHEHB+zYBfZLBj0jiZTWRFMN5rd8g
aUDfiFvxSw4=
=MVAt
-----END PGP SIGNATURE-----

--=-r7QsbIvlEsogW7sGG4hi--
