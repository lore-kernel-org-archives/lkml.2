Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab2ENXWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 19:22:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758267Ab2ENXWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 19:22:16 -0400
Date: Tue, 15 May 2012 09:22:01 +1000
From: NeilBrown <neilb@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] floppy: remove floppy-specific O_EXCL handling
Message-ID: <20120515092201.4d00b4f5@notabene.brown>
In-Reply-To: <alpine.LNX.2.00.1205142326010.15448@pobox.suse.cz>
References: <alpine.LNX.2.00.1205131059410.15448@pobox.suse.cz>
	<20120514162521.GA2366@google.com>
	<alpine.LNX.2.00.1205142237590.15448@pobox.suse.cz>
	<20120514211913.GL2366@google.com>
	<alpine.LNX.2.00.1205142326010.15448@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/u4hnTsATvSvzzGJEAt.9EBl"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/u4hnTsATvSvzzGJEAt.9EBl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 May 2012 23:38:27 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wro=
te:

> On Mon, 14 May 2012, Tejun Heo wrote:
>=20
> > > Because since
> > >=20
> > > 	commit e525fd89d380c4a94c0d63913a1dd1a593ed25e7
> > > 	Author: Tejun Heo <tj@kernel.org>
> > > 	Date:   Sat Nov 13 11:55:17 2010 +0100
> > >=20
> > > 	    block: make blkdev_get/put() handle exclusive access
> > >=20
> > > mount of /dev/fd0 actually causes the fd0 block device be claimed wit=
h=20
> > > _EXCL. Before this commit, you are able to mount /dev/fd0 and then op=
en()=20
> > > it afterward. After this commit you can't any more, because mounting=
=20
> > > /dev/fd0 already passes O_EXCL to floppy_open(), and thus noone else =
can=20
> > > open(/dev/fd0) any more.
> > >=20
> > > My commit brings things back into shape, i.e. you can, equally to oth=
er=20
> > > block devices, both mount it and open() it afterwards.
> >=20
> > Ah, that makes sense.  Maybe it's a good idea to note why the change
> > is necessary in the commit message too?
>=20
> Makes sense. Please find the updated patch below. Andrew, Jens, are you=20
> going to pick it up, please?
> Thanks.
>=20
>=20
>=20
>=20
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] floppy: remove floppy-specific O_EXCL handling
>=20
> Block layer now handles O_EXCL in a generic way for block devices.
>=20
> The semantics is however different for floppy and all other block devices,
> as floppy driver contains its own O_EXCL handling.
>=20
> The semantics for all-but-floppy bdevs is "there can be at most one O_EXC=
L=20
> open of this file", while for floppy bdev the semantics is "if someone ha=
s=20
> the bdev open with O_EXCL, noone else can open it".
>=20
> There is actual userspace-observable change in behavior because of this=20
> since commit e525fd89d380c ("block: make blkdev_get/put() handle exclusiv=
e=20
> access") -- on kernels containing this commit, mount of /dev/fd0 causes=20
> the fd0 block device be claimed with _EXCL, preventing subsequent=20
> open(/dev/fd0).
>=20
> Bring things back into shape, i.e. make it possible, analogically to othe=
r=20
> block devices, to mount the floppy and open() it afterwards -- remove the=
=20
> floppy-specific handling and let the generic bdev code O_EXCL handling=20
> take over.
>=20
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/block/floppy.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index b0b00d7..fe694f8 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -3650,13 +3650,7 @@ static int floppy_open(struct block_device *bdev, =
fmode_t mode)
>  		set_bit(FD_VERIFY_BIT, &UDRS->flags);
>  	}
> =20
> -	if (UDRS->fd_ref =3D=3D -1 || (UDRS->fd_ref && (mode & FMODE_EXCL)))
> -		goto out2;
> -
> -	if (mode & FMODE_EXCL)
> -		UDRS->fd_ref =3D -1;
> -	else
> -		UDRS->fd_ref++;
> +	UDRS->fd_ref++;
> =20
>  	opened_bdev[drive] =3D bdev;
> =20


As we not longer set fd_ref to -1, you should also remove:

	if (UDRS->fd_ref < 0)
		UDRS->fd_ref =3D 0;
	else=20

from floppy_release(), and the 'out:' section of floppy_open().

With those changes:
   Acked-by: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown

--Sig_/u4hnTsATvSvzzGJEAt.9EBl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7GTmTnsnt1WYoG5AQLcdBAAqw5NWRRDL2aZzwx56GRBzsctcq2tx9kR
rQHBFfIO85Ig28EyqSj/8DWCYpYZy9E+f9FJULFLjiTMoaJOgfak9TXWiLqx4qHb
R5vCvC/e53GmOODkM9JffJXH6JDdEvLI7yT40RGJdfNsDFf/NRYX5sjGUEB96UNI
+13AkWJv0kxeP8kHRunCJsUoaoAgu14nXgvN+kwj9kAmxc215Jn7PYlyB7Aa1GPV
J5KnomOU7GxLwMt0VO/aHurU76mT0F9mausd7abTy+pbKF9Rb/OpvNufLGFiIg2x
vJ4YLXUDmtCuuLiM0i5TuS+3HlCr79nN5wW3TBH10UZ0OxkjjYNUF0SSSDyDrDs3
zqKZxFGX52B8UTFDoJTf0VWMbI8ZyKh1jPNQz+GZQ5bKCSX2g0vFLACMNsiC7NpS
gU7K+Tw81Tvt2ziIpRDH/kkKrZ8MS4mCt5GTmQQZ+Z0xBM6hOaN/PWZsd9Di7sTK
GizoclyJt4RBbZT2fsgt3nRtI2ieNiDvyPOOmQ308x0RnD08bhgpdWx+wbkGORi1
d3mKO6iAklReysIL/5vbrSlQKkxgSmeVmCtNtaunl0hBvmCXk0KnUMVSoklJ//rI
a0xj6qHQSbQlEj4Tuqgbhw8q8bC16AXnzdRqOBgdHpXuACr1oGg1Id67WhalXZ3B
ExJ/C6mra9Y=
=NLJs
-----END PGP SIGNATURE-----

--Sig_/u4hnTsATvSvzzGJEAt.9EBl--
