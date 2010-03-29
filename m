Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab0C2MWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:22:07 -0400
Received: from ozlabs.org ([203.10.76.45]:52877 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab0C2MWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:22:03 -0400
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
In-Reply-To: <1269830604-26214-8-git-send-email-yinghai@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
	 <1269830604-26214-8-git-send-email-yinghai@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TQbj0n2iPsbqgcOW5MA3"
Date: Mon, 29 Mar 2010 23:22:02 +1100
Message-ID: <1269865322.24620.42.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TQbj0n2iPsbqgcOW5MA3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-03-28 at 19:43 -0700, Yinghai Lu wrote:
> They will check if the region array is big enough.
>=20
> __check_and_double_region_array will try to double the region if that arr=
ay spare
> slots if not big enough.
> find_lmb_area() is used to find good postion for new region array.
> Old array will be copied to new array.
>=20
> Arch code should provide to get_max_mapped, so the new array have accessi=
able
> address
..
> diff --git a/mm/lmb.c b/mm/lmb.c
> index d5d5dc4..9798458 100644
> --- a/mm/lmb.c
> +++ b/mm/lmb.c
> @@ -551,6 +551,95 @@ int lmb_find(struct lmb_property *res)
>  	return -1;
>  }
> =20
> +u64 __weak __init get_max_mapped(void)
> +{
> +	u64 end =3D max_low_pfn;
> +
> +	end <<=3D PAGE_SHIFT;
> +
> +	return end;
> +}

^ This is (sort of) what lmb.rmo_size represents. So maybe instead of
adding this function, we could just say that the arch code needs to set
rmo_size up with an appropriate value, and then use that below. Though
maybe that's conflating things.

...
> +
> +void __init add_lmb_memory(u64 start, u64 end)
> +{
> +	__check_and_double_region_array(&lmb.memory, &lmb_memory_region[0], sta=
rt, end);
> +	lmb_add(start, end - start);
> +}
> +
> +void __init reserve_lmb(u64 start, u64 end, char *name)
> +{
> +	if (start =3D=3D end)
> +		return;
> +
> +	if (WARN_ONCE(start > end, "reserve_lmb: wrong range [%#llx, %#llx]\n",=
 start, end))
> +		return;
> +
> +	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0],=
 start, end);
> +	lmb_reserve(start, end - start);
> +}
> +
> +void __init free_lmb(u64 start, u64 end)
> +{
> +	if (start =3D=3D end)
> +		return;
> +
> +	if (WARN_ONCE(start > end, "free_lmb: wrong range [%#llx, %#llx]\n", st=
art, end))
> +		return;
> +
> +	/* keep punching hole, could run out of slots too */
> +	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0],=
 start, end);
> +	lmb_free(start, end - start);
> +}

Doesn't this mean that if I call lmb_alloc() or lmb_free() too many
times then I'll potentially run out of space? So doesn't that
essentially break the existing API?

It seems to me that rather than adding these "special" routines that
check for enough space on the way in, instead you should be checking in
lmb_add_region() - which is where AFAICS all allocs/frees/reserves
eventually end up if they need to insert a new region.

cheers



--=-TQbj0n2iPsbqgcOW5MA3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuwm2kACgkQdSjSd0sB4dJ7HQCdF4DqETB+tl8eaA0Veh+PEXtz
7HwAn1aX8kXWHq+QwSqbloEU+IXmR8us
=QWyD
-----END PGP SIGNATURE-----

--=-TQbj0n2iPsbqgcOW5MA3--

