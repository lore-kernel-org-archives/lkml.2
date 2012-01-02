Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2ABXNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 18:13:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab2ABXNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 18:13:48 -0500
Date: Tue, 3 Jan 2012 10:13:35 +1100
From: NeilBrown <neilb@suse.de>
To: <b29237@freescale.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>
Subject: Re: [PATCH][RFC] 	RAID5/DMA/memcpy: zero copy the bio page when
 possible
Message-ID: <20120103101335.3f8f81bc@notabene.brown>
In-Reply-To: <1325049608-8638-1-git-send-email-b29237@freescale.com>
References: <1325049608-8638-1-git-send-email-b29237@freescale.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Zz8cUdVP/qSD7eNKg_PXgYF"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Zz8cUdVP/qSD7eNKg_PXgYF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Dec 2011 13:20:08 +0800 <b29237@freescale.com> wrote:

> From: Forrest shi <b29237@freescale.com>
>=20
> 	use bio page directly instead of copying the bio page to stripe
> 	header page when possible.
>=20
> 	Signed-off-by: Forrest Shi<b29237@freescale.com>

I'm sorry but if you want anyone to review this and comment on it you need =
to
give us a bit more help - like telling us what the purpose of the patch is.

There are a couple of hints but what is needed is a 'big picture'
description.  What is the problem you are fixing?  How are you fixing it?
What are the costs/benefits?

> @@ -754,10 +764,16 @@ ops_run_compute5(struct stripe_head *sh, struct rai=
d5_percpu *percpu)
>  		__func__, (unsigned long long)sh->sector, target);
>  	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
> =20
> -	for (i =3D disks; i--; )
> +	for (i =3D disks; i--; ) {
> +		struct r5dev *dev =3D &sh->dev[i];
> +		struct page *pg =3D dev->page;
>  		if (i !=3D target)
> -			xor_srcs[count++] =3D sh->dev[i].page;
> -
> +#ifdef CONFIG_OPTIMIZE_FSL_DMA_MEMCPY
> +			if (test_bit(R5_DirectAccess, &dev->flags))
> +				pg =3D dev->req.bi_io_vec[0].bv_page;
> +#endif
> +			xor_srcs[count++] =3D pg;
> +	}
>  	atomic_inc(&sh->count);

And something is very wrong here.  I think you need { } around the body of
the 'if' statement.

NeilBrown


--Sig_/Zz8cUdVP/qSD7eNKg_PXgYF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwI6Hznsnt1WYoG5AQJyNg//RDkgu+EIibzC+Atu4kS8wnvgpEoQ0Cyi
5NEiRUAHhcAhvf+yvm+qNQsZmEF79rwzFdMLbV9DXvMeCcnPUsxPtlXW9+8HN1uq
OIhl40fJvNddl7ryIZeqxjPcr6/MxqLxe/C9M0OnmMLtLZy7G/OmKCWJRr6a6cUP
WAjYy6Mguw8DHNpjYLRF3bJPN2zMGCtTNW8mlAAgdtLY4X92iSnSMR/LEvQw8YBf
eAwXigEIpLcLbzaPYcgP4s1TIhT+gNZVn6dN4sRrntajcWgWUBuTqicqlVZhbWSE
tX0yJvX3Y6ANCAcOFEtSQQcROiI+2TKUwBPm0Cm9FxpM5MSo9y9figkzn6M7AQJj
yq95p158HBKKeyu5rFEkyTF1yIi7tPap/0oqBVXj3RnJWyOO6t81lP/U5qka0jWL
k23EzjD5l2bWQ99vYeOpkxAN83WtvcYv5uiTq3CxnftIA9XBuzIz1gi8J6xa4LBR
pTBVtE4SBpmiUrxggs/IqklAOvVyZAibEUxJLeEXplyKQbjP1N8SlwJYOgYY+PRs
pIml5FIqO6dBXXPyE6Cf+GGc0jtXY/ZZmw7QLCwRuo7kVTgudHqYqG+E6Pu42pmk
7Vgb30aC9vdKn6H+V7kFBzFhFYd8DnYyv7Vkxjm+43+Y8hnHk8fRjK6X0zfENMcW
iG6HRpiRHd8=
=Byx3
-----END PGP SIGNATURE-----

--Sig_/Zz8cUdVP/qSD7eNKg_PXgYF--
