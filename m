Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1EGCYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 22:24:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37947 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480Ab1EGCYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 22:24:19 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Timo Warns <warns@pre-sense.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Eugene Teo <eugeneteo@kernel.sg>, Richard Russon <rich@flatcap.org>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk,
        Harvey Harrison <harvey.harrison@gmail.com>, Greg KH <gregkh@suse.de>
In-Reply-To: <20110506001210.724927797@clark.kroah.org>
References: <20110506001210.724927797@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-Z1+hf+SIs0SNbWI35kPb"
Date: Sat, 07 May 2011 03:24:11 +0100
Message-ID: <1304735051.3203.87.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [patch 35/38] fs/partitions/ldm.c: fix oops
 caused by corrupted partition table
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Z1+hf+SIs0SNbWI35kPb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-05-05 at 17:11 -0700, Greg KH wrote:
> 2.6.38-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
>=20
> From: Timo Warns <Warns@pre-sense.de>
>=20
> commit c340b1d640001c8c9ecff74f68fd90422ae2448a upstream.
>=20
> The kernel automatically evaluates partition tables of storage devices.
> The code for evaluating LDM partitions (in fs/partitions/ldm.c) contains
> a bug that causes a kernel oops on certain corrupted LDM partitions.
> A kernel subsystem seems to crash, because, after the oops, the kernel no
> longer recognizes newly connected storage devices.
>=20
> The patch validates the value of vblk_size.

I don't think this actually fixes the vulnerability, and I don't think
this code works at all.

> [akpm@linux-foundation.org: coding-style fixes]
> Signed-off-by: Timo Warns <warns@pre-sense.de>
> Cc: Eugene Teo <eugeneteo@kernel.sg>
> Cc: Harvey Harrison <harvey.harrison@gmail.com>
> Cc: Richard Russon <rich@flatcap.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> ---
>  fs/partitions/ldm.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>=20
> --- a/fs/partitions/ldm.c
> +++ b/fs/partitions/ldm.c
> @@ -1299,6 +1299,11 @@ static bool ldm_frag_add (const u8 *data
> =20
>  	BUG_ON (!data || !frags);
> =20
> +	if (size < 2 * VBLK_SIZE_HEAD) {
> +		ldm_error("Value of size is to small.");
> +		return false;
> +	}
> +
>  	group =3D get_unaligned_be32(data + 0x08);
>  	rec   =3D get_unaligned_be16(data + 0x0C);
>  	num   =3D get_unaligned_be16(data + 0x0E);
> @@ -1306,6 +1311,10 @@ static bool ldm_frag_add (const u8 *data
>  		ldm_error ("A VBLK claims to have %d parts.", num);
>  		return false;
>  	}
> +	if (rec >=3D num) {
> +		ldm_error("REC value (%d) exceeds NUM value (%d)", rec, num);
> +		return false;
> +	}

This is fine for the first fragment we find, when we allocate memory
based on 'num'.  However, when we add another fragment, we need to
compare with f->num.  So there still seems to be the possibility of a
buffer overflow.

>  	list_for_each (item, frags) {
>  		f =3D list_entry (item, struct frag, list);
> @@ -1334,10 +1343,9 @@ found:
> =20
>  	f->map |=3D (1 << rec);
> =20
> -	if (num > 0) {
> -		data +=3D VBLK_SIZE_HEAD;
> -		size -=3D VBLK_SIZE_HEAD;
> -	}
> +	data +=3D VBLK_SIZE_HEAD;
> +	size -=3D VBLK_SIZE_HEAD;
> +
>
>  	memcpy (f->data+rec*(size-VBLK_SIZE_HEAD)+VBLK_SIZE_HEAD, data, size);
>=20
>  	return true;

The offset used for the destination means that the first VBLK_SIZE_HEAD
bytes of f->data are never initialised!

I suspect (without any knowledge of LDM) that the intent was to use the
header from the first fragment and drop it from the subsequent
fragments, like this:

	if (rec =3D=3D 0)
		memcpy(f->data, data, VBLK_SIZE_HEAD);
	data +=3D VBLK_SIZE_HEAD;
	size -=3D VBLK_SIZE_HEAD;
	memcpy(f->data + VBLK_SIZE_HEAD + rec * size, data, size);

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-Z1+hf+SIs0SNbWI35kPb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATcStS+e/yOyVhhEJAQoWqxAAp51CjaHfWxL1cFGRsG34++IKrl5D4eNw
6QAW4Ezgshu001mb5L5gQHJWYuOWuXEv0rP6P/luaYXYUzVa5zk8zguYTd391MYL
xRAHpRp9L3DHgwRExS0R1bypORwMyS3J8+ZSzuWN97lpRLO+8xy/XYYHL2TTaEGG
a2QJSC+CyRiwBSvYn5am/pzY+eG1qznjHGKAqOOwTB1eO/k1ni6+5uO2JdV8b7wk
+WsId70+BB4CvVS9gwPCcwww8x4J2t5gUPibQtZFHXtSVK52WxQ/iiiz+wFagYT7
RsOXaVTavf4EfjNmGGytFFPn7lBnVTUzRQGJoTo2DW5/WXiOtNew/F7szToMTbsA
czr2vpPphD+dDDWHopaNXqFRb97ZJ13v52AxWtOVaETgqOkIkQx2bcL0yFP0hcok
otZDuXinaBMm6ZJsp0eZ6wolrGMmUu3ocFwz3duKZI1nQEyMAO0bbfKpsIb1TW/1
h9CJHaE9Hx8SpK+PwrF+MUJWi+PdKUJGb+K/MXjpYpTE+g8DeR+GdGwqvqVYT95z
0ZGIOgDInfOquktoznMEX9gi2hImG9hRA00ZNcRnkBfF/+saB5miqJAdErB70P8g
RADSJcg7MQ3hUrA+9p/7k+s6RA0xwjAavkwFCrBajKs3fpmPUQ9igRyQYF+EjwBo
9CTCu3KsHWs=
=BE9V
-----END PGP SIGNATURE-----

--=-Z1+hf+SIs0SNbWI35kPb--
