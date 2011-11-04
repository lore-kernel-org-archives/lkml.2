Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab1KDPYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 11:24:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51195 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255Ab1KDPYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 11:24:47 -0400
Message-ID: <1320420256.3079.172.camel@deadeye>
Subject: Re: [050/107] block: check for proper length of iov entries earlier
 in blk_rq_map_user_iov()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>, Dan Carpenter <dan.carpenter@oracle.com>,
        Xiaotian Feng <dfeng@redhat.com>, Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Date: Fri, 04 Nov 2011 15:24:16 +0000
In-Reply-To: <20111102221454.703920975@clark.kroah.org>
References: <20111102221600.GA26650@kroah.com>
	 <20111102221454.703920975@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-NvDnDARS41BtUjQPzbhC"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NvDnDARS41BtUjQPzbhC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-11-02 at 15:14 -0700, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let u=
s know.
>=20
> ------------------
>=20
> From: Xiaotian Feng <dfeng@redhat.com>
>=20
> commit 5478755616ae2ef1ce144dded589b62b2a50d575 upstream.
>=20
> commit 9284bcf checks for proper length of iov entries in
> blk_rq_map_user_iov(). But if the map is unaligned, kernel
> will break out the loop without checking for the proper length.
> So we need to check the proper length before the unalign check.

This will catch an unaligned zero-length entry.  But there's still no
check for zero-length iov entries *after* the unaligned entry.

[...]
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -201,12 +201,13 @@ int blk_rq_map_user_iov(struct request_q
>  	for (i =3D 0; i < iov_count; i++) {
>  		unsigned long uaddr =3D (unsigned long)iov[i].iov_base;
> =20
> +		if (!iov[i].iov_len)
> +			return -EINVAL;
> +
>  		if (uaddr & queue_dma_alignment(q)) {
>  			unaligned =3D 1;
>  			break;

I think the correct fix is just to remove the 'break'.

Ben.

>  		}
> -		if (!iov[i].iov_len)
> -			return -EINVAL;
>  	}
> =20
>  	if (unaligned || (q->dma_pad_mask & len) || map_data)
>=20

--=20
Ben Hutchings
Sturgeon's Law: Ninety percent of everything is crap.

--=-NvDnDARS41BtUjQPzbhC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATrQDoOe/yOyVhhEJAQryCRAAhsYMffnFhKE9VRzFJ2fFK09dfS0I8+UV
cFcpKBiY7meugDw3OraH4xJ7S2ImI+iDkmvZTKDtXzKTM28f+1PgFK40qvyAN//w
GAxmSaUMQ9D6KeyBWK01h5cg/RUlEghjWF1chMkL7zdYL/TcwagSMcoje2OFuF/E
ArWvMPYtn/diKs43PBojTu2rOmc+4i9/F0Nxci0o63fja8sa7NQ+8K27OqIC4Nv2
nWODE255ZHflPxTHtbyCpx7B5UJPptwR+Pv71+A/tzny45g11ZuHLMfjuhUEWBv5
z5ku4qZTN66K7XK5Ys7zzarRQNjujyJgPsSR9LDMhCpYI9ih3Uq6LeEyz+3yc2r6
25wBdRcD6Y4Am2+sZONGZF8IkuipYQiMyLJfL57Ht46PJHMUDNdEIlBgv/fqAXmW
LdAFSHKI1YgFCaS6q2ToHQTDFNT1BYmeVRFDeMLkVoNcMxc12UzEUTrkWQ5vlJKy
CquNUAPjgZ6ClqjZmQ1cx+sitGTAR8+qKCKqsInhod9uE9USDcyA06K/8IxnNQ4c
JUhtKGuFqIZmNCPXVWlsthp1QdIIqwEM9ZBXtCUvnf4nHX5usJM95cswKOAz7FtS
PuN3Gtz5toOXnzc2BuLB1Li1aV8u3uj3xv1feChu6zAuyrfkVrHGSROV33A4n1lV
kXOaGk3j2Is=
=yLAY
-----END PGP SIGNATURE-----

--=-NvDnDARS41BtUjQPzbhC--
