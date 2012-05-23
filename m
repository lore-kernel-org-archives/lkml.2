Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab2EWKkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:40:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:33976 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab2EWKj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:39:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="156058244"
Message-ID: <1337769818.2483.202.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBIFS: introduce struct ubifs_keymap
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 23 May 2012 13:43:38 +0300
In-Reply-To: <alpine.DEB.2.00.1205211640320.3833@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205211640320.3833@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-GaDQGK5mK/XlhuhgdjHr"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GaDQGK5mK/XlhuhgdjHr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2012-05-21 at 16:41 +0200, Joel Reardon wrote:
> +/*
> + * This file is part of UBIFS.
> + *
> + * Copyright (C) 2006-2008 Nokia Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms of the GNU General Public License version 2 as publis=
hed by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but W=
ITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License alo=
ng with
> + * this program; if not, write to the Free Software Foundation, Inc., 51
> + * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
> + *
> + * Authors: Adrian Hunter
> + *	    Artem Bityutskiy (=D0=91=D0=B8=D1=82=D1=8E=D1=86=D0=BA=D0=B8=D0=
=B9 =D0=90=D1=80=D1=82=D1=91=D0=BC)
> + */

Please, add another copyright and different author names.

> +
> +/*
> + * The file implements the key storage, assignment, and deletion for UBI=
FS's
> + * secure deletion enhancement. For more information, read
> + * Documentation/filesystems/ubifsec.txt
> + */
> +
> +#include <linux/random.h>
> +#include "ubifs.h"
> +
> +#define RETURN_VAL_IF(v, e) do { if ((e)) return (v); } while (0)
> +#define RETURN_ON_ERR(e) do { if ((e)) return (e); } while (0)

In the Linux kernel we do not do things like this.

> +static void pos_to_eb_offset(const long long ksa_pos,
> +			     int *ksa_leb, int *ksa_offset)
> +{
> +	*ksa_offset =3D 0xffffffff & ksa_pos;
> +	*ksa_leb =3D 0xffffffff & (ksa_pos >> 32);
> +}

Throughout whole UBIFS we use shorter 'offs' for offsets - in variables
and function names. Please, be consistent with that and and use
'ksa_offs'.

> +
> +/**
> + * eb_offset_to_pos - convert a ksa_leb and offset to ksa_pos
> + * @ksa_leb: gets the KSA LEB number for the key position
> + * @ksa_offset: gets the KSA LEB offset for the key position
> + *
> + * This function converts the LEB number and offset for a key into the 6=
4-bit
> + * key position value.
> + */
> +static long long eb_offset_to_pos(int ksa_leb, int ksa_offset)

I suggest different names: 'ksa_pos_couple()' (or 'ksa_pos_join()') and
'ksa_pos_decouple()', how does it sound to you?

> +{
> +	return (((long long) ksa_leb) << 32) + ksa_offset;

Sorry for being that picky, but for some reason in UBIFS we never have a
space between the cast and the identifier.

BTW, cast has higher priority that the shift, so you could have less
brackets, but not sure it would me more readable, so it is up to you.

> +}
> +
> +/**
> + * generate_key - generate a new encryption key
> + * @km: keymap structure to know the key size
> + * @to: key-size-sized buffer to hold the new key.
> + *
> + * This function generates a new random key and places it in the to fiel=
d. The
> + * keymap stores the size of the key used as a field. We assume that
> + * get_random_bytes() will always yield cryptographically-suitable rando=
m
> + * data. If this ever changes, this will need to be updated.
> + */
> +static void generate_key(struct ubifs_keymap *km, u8 *to)
> +{
> +	get_random_bytes(to, km->key_size);
> +}
> +
> +/**
> + * keymap_init - construct and initialize a struct keymap
> + * @c: the ubifs info context to put the keymap into
> + *
> + * This function allocates a keymap data structure and initializes its f=
ields.
> + * The ubifs_info context @c is passed as a parameter and its @km field =
is set
> + * to the keymap that is preprared by this function. If memory cannot be
> + * allocated, it returns -ENOMEM. Otherwise it returns 0.
> + */
> +int keymap_init(struct ubifs_info *c)
> +{
> +	struct ubifs_keymap *km;
> +
> +	c->km =3D NULL;

Useless assignment.

> +	km =3D kmalloc(sizeof(struct ubifs_keymap), GFP_NOFS);
> +	RETURN_VAL_IF(-ENOMEM, !km);

Please, do not do things like this in the linux kernel - we prefer to
open-code error checking for readability. Our eyes are not designed to
read weird constructs like this macro :-) Check how we allocate memory
in UBIFS and do it similarly. In general, try to follow the UBIFS style.

> +
> +	km->key_size =3D UBIFS_CRYPTO_KEYSIZE;
> +	km->keys_per_leb =3D c->leb_size / km->key_size;
> +	km->ksa_size =3D 0;
> +	km->ksa_first =3D 0;
> +	km->unused =3D 0;
> +	km->deleted =3D 0;

Do not set fields to zero - allocate the whole thing with kzalloc()
instead.

> +
> +	c->km =3D km;
> +	return 0;
> +}
> +
> +/**
> + * keymap_free - destruct and free memory used by a struct keymap
> + * @c: the ubifs info context that contanis the keymap
> + *
> + * This function frees the memory being used by the keymap.
> + */
> +void keymap_free(struct ubifs_info *c)
> +{
> +	kfree(c->km);
> +	c->km =3D NULL;

Please, kill this helper so far and do not set c->km to NULL. Call
kfree(c->km) directly from whenever you need. If it grows - you can
create a helper later.

> +}

If init/free are called only during=20

> +/* keymap.c */
> +int keymap_init(struct ubifs_info *c);
> +void keymap_free(struct ubifs_info *c);
> +
> +/* keymap.c */
> +int keymap_init(struct ubifs_info *c);
> +void keymap_free(struct ubifs_info *c);

2 times the same?

--=20
Best Regards,
Artem Bityutskiy

--=-GaDQGK5mK/XlhuhgdjHr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPvL9aAAoJECmIfjd9wqK0HhsP/0MYk+lUoXBnwWscX+5+AS6I
mEDwfSYlCl2boX00J+5q3RRobAjUc1LDI8wjMyvvpFNo3A5igJemgZEZPsFn1nBm
WoXimAAiDyP6L2AKJo+Q+LtTTF2Jj+SxbKfT0ZMxSz/4DNyaMHLePHA1vxjs0+X2
Chc/8pa6DamRMnE+HoexRMW+0nGPY4rd7j8FlF+uDznmGzf8Xci8X16hAchNNmZy
nqQHVKpelQ49RRcNZMdbOmnjGA50q9zUk7TgStIewpUtuACo3chCh3T+dFdNZtgo
pbpRwDw0QslG0QdVKGFiAr2bIFSuY5ZrpNaxo6O2hwhf8pMZSuFqQtWm6BxMVOw1
2tAlnr4yfUVV9ETYExpvUrXiVhjYgLuegBI4g89kxhz7L6eZ1xJxU88Opg7n+KoZ
AFSvtWevKS+hWJ1ZAMbtXWAKcxKTQCYI146XzwpeMfs0ZM1g2E/oityZTbv+rK8j
F+N9waiTtmPMsVLMJpYGQkFXZbKR8Ns6U79ZdQxyBDT918/F/g/WiF6AvBX4DzEZ
3d4PdSSzbuX3VbA46osEWbOfNSNtfMmBqZNiKrzAfcEMGNYAQzxP4QV4np7eqrDk
1WQrHgn0iz1hgsfFdqLH8zDOiqhDXMbw36iOf29lj9BJJ6Qndyjr473tOMcAqECT
p3410N8hxGoHtIoTBd1F
=K+qn
-----END PGP SIGNATURE-----

--=-GaDQGK5mK/XlhuhgdjHr--

