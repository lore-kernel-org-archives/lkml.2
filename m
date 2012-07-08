Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab2GHCB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 22:01:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51975 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123Ab2GHCB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 22:01:26 -0400
Message-ID: <1341712869.25597.203.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 02/12] random: make 'add_interrupt_randomness()' do
 something sane
From: Ben Hutchings <ben@decadent.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Date: Sun, 08 Jul 2012 03:01:09 +0100
In-Reply-To: <1341614704-24965-3-git-send-email-tytso@mit.edu>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
	 <1341614704-24965-3-git-send-email-tytso@mit.edu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xKxNZ1ZksZumTmi1E9BC"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xKxNZ1ZksZumTmi1E9BC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-07-06 at 18:44 -0400, Theodore Ts'o wrote:
> We've been moving away from add_interrupt_randomness() for various
> reasons: it's too expensive to do on every interrupt, and flooding the
> CPU with interrupts could theoretically cause bogus floods of entropy
> from a somewhat externally controllable source.
>=20
> This solves both problems by limiting the actual randomness addition
> to just once a second or after 128 interrupts, whicever comes first.

Seems to be once per 64 interrupts.  add_interrupt_randomness() calls
fast_mix() with nbytes =3D 20, so it increments fast_pool->count by 20.
add_interrupt_randomness() returns early if (fast_pool->count & 255),
and 64 * 20 =3D=3D 0x500.

[...]
> +static void fast_mix(struct fast_pool *f, const void *in, int nbytes)
> +{
> +       const char      *bytes =3D in;
> +       __u32           w;
> +       unsigned        i =3D f->count;
> +       unsigned        input_rotate =3D f->rotate;
> +
> +       while (nbytes--) {
> +               w =3D rol32(*bytes++, input_rotate & 31) ^ f->pool[i & 3]=
 ^
> +                       f->pool[(i + 1) & 3];
> +               f->pool[i & 3] =3D (w >> 3) ^ twist_table[w & 7];
> +               input_rotate +=3D (i++ & 3) ? 7 : 14;
> +       }
> +       f->count =3D i;
> +       f->rotate =3D input_rotate;
> +}
[...]

This seems like a comparatively expensive operation to add to every
interrupt. :-/

Ben.

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-xKxNZ1ZksZumTmi1E9BC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/jp5+e/yOyVhhEJAQqzbxAAmAq9tZG+oNr9X8cOmbWx+N3RiQarPZ/q
sDqJHGJpWPoUCo1olDBfKl5bVzkxYttjgkqNS3UCsBTgsYtkRMveCuMPbdQ/v3rW
ExRFsq1Du4/4ZFlrI2qGFLCc6Oc22opTx5+rSTB1ucSdg6PSpXxn3s0BSlEBAk9l
TNURdCU+ndSPZZIUhuz6dkpNJJiZI714wFruSkV5IUw5Jy8t3l2K573VqVXoRDZO
EjPhFMRl4G8+c5CAHZ36Yvjij7vUwWD5H1GaHJqPnNjctB80f9JMXjBV7A+nwrKs
2AVYty+95YVTmZpyZQBCWv+Y4no87x7efTsOe4BlORCSxdlHQcG58Md3Ax2Yx10x
E2H7Vaa59Ro1vUH8kvmcsfv7t5WAsWa97V+cXGDhhsGb3r4ICUj60CoZkFl/UtSG
jrXmSi22Ci/SXLnNt7KUUu3vdwnppNlGfRahSxgFwKBk5bQvtErNX3DKS1vMeBJo
WRYpwyd+Wv04fvv/1s7mIbH899PhnKAEN45+/OQ2ccQn2c6Fob1LG2oWleXGXyiX
hmQqg125K8p//r9Q0ttQ33JjyCxqNjTxi7aouUjX6apOPQ0lLrxvuz6GE80BHkTH
dO2qdsj3XPxbzMgYSX10lKpQ6dtR5H7+MJf5v6kkF6prJBRE9pLqKY5sVimGyo5o
XJk6qW/rqXY=
=hSrS
-----END PGP SIGNATURE-----

--=-xKxNZ1ZksZumTmi1E9BC--
