Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781Ab2FHDDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 23:03:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42287 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883Ab2FHDDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 23:03:20 -0400
Message-ID: <1339124589.21665.106.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 64/82] ext4: dont trash state flags in EXT4_IOC_SETFLAGS
From: Ben Hutchings <ben@decadent.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tao Ma <boyu.mt@taobao.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date: Fri, 08 Jun 2012 04:03:09 +0100
In-Reply-To: <20120607040345.775333506@linuxfoundation.org>
References: <20120607040345.775333506@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-GADwr6tY2eHlYutDQ/gv"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GADwr6tY2eHlYutDQ/gv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-06-07 at 13:04 +0900, Greg KH wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Theodore Ts'o <tytso@mit.edu>
>=20
> commit 79906964a187c405db72a3abc60eb9b50d804fbc upstream.
>=20
> In commit 353eb83c we removed i_state_flags with 64-bit longs, But
> when handling the EXT4_IOC_SETFLAGS ioctl, we replace i_flags
> directly, which trashes the state flags which are stored in the high
> 32-bits of i_flags on 64-bit platforms.  So use the the
> ext4_{set,clear}_inode_flags() functions which use atomic bit
> manipulation functions instead.
[...]
> @@ -115,8 +115,14 @@ long ext4_ioctl(struct file *filp, unsig
>  		if (err)
>  			goto flags_err;
> =20
> -		flags =3D flags & EXT4_FL_USER_MODIFIABLE;
> -		flags |=3D oldflags & ~EXT4_FL_USER_MODIFIABLE;
> +		for (i =3D 0, mask =3D 1; i < 32; i++, mask <<=3D 1) {
> +			if (!(mask & EXT4_FL_USER_MODIFIABLE))
> +				continue;
> +			if (mask & flags)
> +				ext4_set_inode_flag(inode, i);
> +			else
> +				ext4_clear_inode_flag(inode, i);
> +		}
>  		ei->i_flags =3D flags;
[...]

Shouldn't this last assignment have been deleted?

Ben.

--=20
Ben Hutchings
I haven't lost my mind; it's backed up on tape somewhere.

--=-GADwr6tY2eHlYutDQ/gv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9Frbee/yOyVhhEJAQpa/g/8DpPEOmSnkeAIPq0xNlaYiErPauGP47bp
5+WYhXqQ7R/D9s+0mWOCAY0Xfz4E+cRa3kmGfKzl2MQi2scuYNaiFFno+lvTqsos
+E2YadFp7HrPdMB5p+aHh6CdYw7B06WW6cC3SJU7y/oWAtmMxq1nW0SOq/uzQZ7J
z5rucx/c6iILw1OXC1VRczy5SemFoygx3PKMori+JxNaUlx7xYDYEfHkk6OAQ/fr
xMsTjgcKfftKjIyiPWs+45UBlbde66tV45CMYfWKDgU8sgbn4ng877qoykR5ZtLo
vEbFUpqBmfFgJQ6DLuGou57T1+RRhZ/Y5pH+meSrr6myoHsp+LGUgoSx8yDBu6/I
v31jhQEhjJCEYjMzfC1zUcnEOQGtX4x2qDLReTqq2aXw/IqotqBCp/d7/qucYICb
ckQhqci61bDW7GV4TmJK3qCCtAWbEeff63t17G1O0x+GmmMsa6cPJIjr+io9VgAe
U5RiwNu41vsRTEN547mTd05N1oD4MdxdeE6NyrYQ+0f647wUbAEcZlraSf4w9Yca
PW0VukfTF8nTHnW31tC6nKlE3R8KeZfZl6Nw2SzrsUoN5VaJzwicnxlX0HkBMRGh
y1JTYQ6hu9VAxOjIWHHyGi1Cj0GBdsWpbyfscXZSo1KgvI14ySrOQ2OCDvllEitS
WMsjIDq2cs4=
=lomi
-----END PGP SIGNATURE-----

--=-GADwr6tY2eHlYutDQ/gv--
