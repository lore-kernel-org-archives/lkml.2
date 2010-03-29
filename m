Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0C2WU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:20:56 -0400
Received: from ozlabs.org ([203.10.76.45]:45289 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0C2WUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:20:53 -0400
Subject: Re: [PATCH 07/31] lmb: Add reserve_lmb/free_lmb
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BB0D92C.3010103@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
	 <1269830604-26214-8-git-send-email-yinghai@kernel.org>
	 <1269865322.24620.42.camel@concordia>  <4BB0D92C.3010103@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HDEZOoD6v9wUE5uRAp6r"
Date: Tue, 30 Mar 2010 09:20:52 +1100
Message-ID: <1269901252.2286.11.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HDEZOoD6v9wUE5uRAp6r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-03-29 at 09:45 -0700, Yinghai Lu wrote:
> On 03/29/2010 05:22 AM, Michael Ellerman wrote:
> > On Sun, 2010-03-28 at 19:43 -0700, Yinghai Lu wrote:
> >> They will check if the region array is big enough.
> >>
> >> __check_and_double_region_array will try to double the region if that =
array spare
> >> slots if not big enough.
> >> find_lmb_area() is used to find good postion for new region array.
> >> Old array will be copied to new array.
> >>
> >> Arch code should provide to get_max_mapped, so the new array have acce=
ssiable
> >> address
> > ..
> >> diff --git a/mm/lmb.c b/mm/lmb.c
> >> index d5d5dc4..9798458 100644
> >> --- a/mm/lmb.c
> >> +++ b/mm/lmb.c
> >> @@ -551,6 +551,95 @@ int lmb_find(struct lmb_property *res)
> >>  	return -1;
> >>  }
> >> =20
> >> +u64 __weak __init get_max_mapped(void)
> >> +{
> >> +	u64 end =3D max_low_pfn;
> >> +
> >> +	end <<=3D PAGE_SHIFT;
> >> +
> >> +	return end;
> >> +}
> >=20
> > ^ This is (sort of) what lmb.rmo_size represents. So maybe instead of
> > adding this function, we could just say that the arch code needs to set
> > rmo_size up with an appropriate value, and then use that below. Though
> > maybe that's conflating things.
>=20
> ok
>=20
> will have another patch following this patchset. to use rmo_size replace =
get_max_mapped()

No don't, Benh's idea was better. Leave rmo_size for now, we can clean
that up later.

We just need a lmb.alloc_limit and a lmb_set_alloc_limit() which arch
code calls when it knows what the alloc limit is (and can call multiple
times during boot). Or maybe it should be called "default_alloc_limit",
but that's getting a bit long winded.

>=20
> long __init_lmb lmb_add(u64 base, u64 size)
> {
>         struct lmb_region *_rgn =3D &lmb.memory;
>=20
>         /* On pSeries LPAR systems, the first LMB is our RMO region. */
>         if (base =3D=3D 0)
>                 lmb.rmo_size =3D size;
>=20
>         return lmb_add_region(_rgn, base, size);
>=20
> }
>=20
> looks scary.
> maybe later powerpc could used lmb_find and set_lmb_rmo_size in their arc=
h code.

It's not really scary, and it gives you a hint where the code came from
originally :)

We can remove that later though, with some powerpc code to detect the
first memory region before we put it into lmb.

> > ...
> >> +
> >> +void __init add_lmb_memory(u64 start, u64 end)
> >> +{
> >> +	__check_and_double_region_array(&lmb.memory, &lmb_memory_region[0], =
start, end);
> >> +	lmb_add(start, end - start);
> >> +}
> >> +
> >> +void __init reserve_lmb(u64 start, u64 end, char *name)
> >> +{
> >> +	if (start =3D=3D end)
> >> +		return;
> >> +
> >> +	if (WARN_ONCE(start > end, "reserve_lmb: wrong range [%#llx, %#llx]\=
n", start, end))
> >> +		return;
> >> +
> >> +	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[=
0], start, end);
> >> +	lmb_reserve(start, end - start);
> >> +}
> >> +
> >> +void __init free_lmb(u64 start, u64 end)
> >> +{
> >> +	if (start =3D=3D end)
> >> +		return;
> >> +
> >> +	if (WARN_ONCE(start > end, "free_lmb: wrong range [%#llx, %#llx]\n",=
 start, end))
> >> +		return;
> >> +
> >> +	/* keep punching hole, could run out of slots too */
> >> +	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[=
0], start, end);
> >> +	lmb_free(start, end - start);
> >> +}
> >=20
> > Doesn't this mean that if I call lmb_alloc() or lmb_free() too many
> > times then I'll potentially run out of space? So doesn't that
> > essentially break the existing API?
>=20
> No, I didn't touch existing API, arches other than x86 should have little=
 change about=20
> lmb.memory.region
> lmb.reserved.region
> become pointer from array.

But that's my point. You shouldn't need to touch the existing API, and
you shouldn't need to add a new parallel API. You should just be able to
add the logic for doubling the array in the lmb core, and then everyone
gets dynamically expandable lmb. I don't see any reason why we want to
have two APIs.

> > It seems to me that rather than adding these "special" routines that
> > check for enough space on the way in, instead you should be checking in
> > lmb_add_region() - which is where AFAICS all allocs/frees/reserves
> > eventually end up if they need to insert a new region.
>=20
> later i prefer to replace lmb_alloc with find_lmb_area + reserve_lmb.

Why? The existing code has been working for years and is well tested?

cheers



--=-HDEZOoD6v9wUE5uRAp6r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuxJ8MACgkQdSjSd0sB4dJnDwCguPEeNzZKR31Fp29l6JRrr8Q3
4coAnjoCf8Mo+1v3z8fdcq2NSUizR7qq
=4qcW
-----END PGP SIGNATURE-----

--=-HDEZOoD6v9wUE5uRAp6r--

