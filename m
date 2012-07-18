Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2GRKeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:34:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38130 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2GRKeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:34:18 -0400
Message-ID: <1342607317.7530.9.camel@brekeke>
Subject: Re: [PATCH 2/5] ubi: Limit amount of reserved eraseblocks for bad
 PEB handling
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 18 Jul 2012 13:28:37 +0300
In-Reply-To: <1341389164-24409-3-git-send-email-shmulik.ladkani@gmail.com>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
	 <1341389164-24409-3-git-send-email-shmulik.ladkani@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-j6wGsMTPxMqubVCHVU4E"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-j6wGsMTPxMqubVCHVU4E
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-04 at 11:06 +0300, Shmulik Ladkani wrote:
> @@ -1045,20 +1046,14 @@ static int erase_worker(struct ubi_device *ubi, s=
truct ubi_work *wl_wrk,
>  	}
> =20
>  	spin_lock(&ubi->volumes_lock);
> -	need =3D ubi->beb_rsvd_level - ubi->beb_rsvd_pebs + 1;
> -	if (need > 0) {
> -		need =3D ubi->avail_pebs >=3D need ? need : ubi->avail_pebs;
> -		ubi->avail_pebs -=3D need;
> -		ubi->rsvd_pebs +=3D need;
> -		ubi->beb_rsvd_pebs +=3D need;
> -		if (need > 0)
> -			ubi_msg("reserve more %d PEBs", need);
> -	}
> -
>  	if (ubi->beb_rsvd_pebs =3D=3D 0) {
> -		spin_unlock(&ubi->volumes_lock);
> -		ubi_err("no reserved physical eraseblocks");
> -		goto out_ro;
> +		if (ubi->avail_pebs =3D=3D 0) {
> +			spin_unlock(&ubi->volumes_lock);
> +			ubi_err("no reserved/available physical eraseblocks");
> +			goto out_ro;
> +		}
> +		ubi->avail_pebs -=3D 1;
> +		available_consumed =3D 1;
>  	}
>  	spin_unlock(&ubi->volumes_lock);

The whole thing will become simpler if we first mark the PEB as bad
unconditionally (because it _is_ bad), then grab the lock and do all the
re-calculations.

> =20
> @@ -1068,11 +1063,23 @@ static int erase_worker(struct ubi_device *ubi, s=
truct ubi_work *wl_wrk,
>  		goto out_ro;
> =20
>  	spin_lock(&ubi->volumes_lock);
> -	ubi->beb_rsvd_pebs -=3D 1;
> +	if (ubi->beb_rsvd_pebs > 0) {
> +		if (available_consumed) {
> +			/*
> +			 * Some PEBs were added to the reserved pool since we
> +			 * last checked. Use a PEB from the reserved pool.
> +			 */
> +			ubi->avail_pebs +=3D 1;
> +			available_consumed =3D 0;
> +		}
> +		ubi->beb_rsvd_pebs -=3D 1;
> +	}
>  	ubi->bad_peb_count +=3D 1;
>  	ubi->good_peb_count -=3D 1;
>  	ubi_calculate_reserved(ubi);

We do not need to call this function from here, right?

--=20
Best Regards,
Artem Bityutskiy

--=-j6wGsMTPxMqubVCHVU4E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQBo/VAAoJECmIfjd9wqK0B0wQAJJUPGzIx/eTiqD9tVB1gN8T
dylzQHURoPb6p1phSHzEJYZYuGYEWyP5x86oW3JQ4T7jN5gbrnLJ76bsRUR5Lrs7
YV54giVyBXvyyoecaHKsGcf3mxQKV+0DuBjGXEL0+IwUGmCfxmzFehZ5ko1gA41C
JAb0ziu7pRMI2kntBDnk9iaxZpdEhxzjCXvrjNUhaDoxSzmnXvfOI1iVgmsa09+k
EKxB0KxK4/Hcesaaa8nBNF3lhozrdmN/K9H5Y1fdlciyzwFfXreMbydwR5Ay7cwP
mZG9zu5gtRu8WZGYhe+Km9kaLEIhVeBzK8lvwmvqadppysx+0ybpy+BwfMWJAdiM
Hwb7wgjQYv/wr0TGFEl8d8P8iXapB3aMbbtO1fjcBqmPa84El9UdCTkd8TmOOulY
mAS8zzkgHgMcPjYdzYQhseV1YbM6RAJqkifCqa06+3+lhOcoEfu0Xzot7gp5MCDm
iu64MXPbYX8pxQp6Xls9qrmxcZZphldV8WBWfy6xXbr9CMeAVZl6CDE/PpAr0u9P
yx8QMDnikGLjccPhTPBQxP8nY0lQRvCjO6SjIXJvtqG3dIaI4weC0kveBVByfycc
d7uFhlBfieYRM7mGJkiJFG0A31VU/2chYcd6hojA0mxK7P2miUh2bYwJUcNzcD01
oaluoDd2+nBa5w8NI4aP
=uu8C
-----END PGP SIGNATURE-----

--=-j6wGsMTPxMqubVCHVU4E--

