Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab1CQWR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:17:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57731 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab1CQWR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:17:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O25Xa/fl4UUDEeCF9YMYRSi6W4ZkPzaQ8JhbW8OwwdfMjsAxNlQXmvYP4qYhL+3ClN
         5QrLFSGllhcwGHgpaVfT+/gYIbdtUHLJQxzCNnYstIO8bXg7T8qB/bTeXI6oDSTZo9Q2
         Lh0DS/W0mFXR6j4OLwQc/Wn9nPTW5Nc3J2mpg=
Date: Fri, 18 Mar 2011 00:19:26 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas =?iso-8859-1?Q?Bie=DFmann?= 
	<andreas.devel@googlemail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Anton Altaparmakov <aia21@cantab.net>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH] fs-writeback: fix NULL pointer dereference in
 __mark_inode_dirty
Message-ID: <20110317221925.GA4841@swordfish>
References: <1298906733-31427-1-git-send-email-biessmann@corscience.de>
 <20110228154314.GA4675@swordfish.minsk.epam.com>
 <4D6BC666.4010603@gmail.com>
 <20110228162909.GB4675@swordfish.minsk.epam.com>
 <AANLkTimARkrtmBBgtXmNA=MOD94FWQ8x-qcmLJ8mdQ6o@mail.gmail.com>
 <4D6E016B.50600@gmail.com>
 <20110317140401.4f06793e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20110317140401.4f06793e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello,

On (03/17/11 14:04), Andrew Morton wrote:
>[..]
> afaik this regression didn't get fixed.  Jens put out a patch for
> George to test but there hasn't been any feedback on that yet.  Could
> you guys please give it a spin?
>


Sorry for rather long reply. Seem to work fine for me.=20

Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>


Thanks,
	Sergey

=20
> From: Jens Axboe <axboe@kernel.dk>
>=20
> When we move the potential dirty list entries to the
> default_backing_dev_info, reassign the sb->s_bdi as well.=20
> default_backing_dev_info will always be around.  I hope this can fix it up
> for 2.6.38 and we can add the proper ref counting for .39.
>=20
> Cc: Anton Altaparmakov <aia21@cam.ac.uk>
> Cc: George Spelvin <linux@horizon.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Andreas Biemann <biessmann@corscience.de>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Tested-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
> Cc: <stable@kernel.org>		[2.6.38.x]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  fs/super.c       |    2 ++
>  fs/sync.c        |    4 ++--
>  mm/backing-dev.c |    2 +-
>  3 files changed, 5 insertions(+), 3 deletions(-)
>=20
> diff -puN fs/super.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb fs/super=
=2Ec
> --- a/fs/super.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb
> +++ a/fs/super.c
> @@ -72,6 +72,7 @@ static struct super_block *alloc_super(s
>  #else
>  		INIT_LIST_HEAD(&s->s_files);
>  #endif
> +		s->s_bdi =3D &default_backing_dev_info;
>  		INIT_LIST_HEAD(&s->s_instances);
>  		INIT_HLIST_BL_HEAD(&s->s_anon);
>  		INIT_LIST_HEAD(&s->s_inodes);
> @@ -1006,6 +1007,7 @@ vfs_kern_mount(struct file_system_type *
>  	}
>  	BUG_ON(!mnt->mnt_sb);
>  	WARN_ON(!mnt->mnt_sb->s_bdi);
> +	WARN_ON(mnt->mnt_sb->s_bdi =3D=3D &default_backing_dev_info);
>  	mnt->mnt_sb->s_flags |=3D MS_BORN;
> =20
>  	error =3D security_sb_kern_mount(mnt->mnt_sb, flags, secdata);
> diff -puN fs/sync.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb fs/sync.c
> --- a/fs/sync.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb
> +++ a/fs/sync.c
> @@ -33,7 +33,7 @@ static int __sync_filesystem(struct supe
>  	 * This should be safe, as we require bdi backing to actually
>  	 * write out data in the first place
>  	 */
> -	if (!sb->s_bdi || sb->s_bdi =3D=3D &noop_backing_dev_info)
> +	if (sb->s_bdi =3D=3D &noop_backing_dev_info)
>  		return 0;
> =20
>  	if (sb->s_qcop && sb->s_qcop->quota_sync)
> @@ -79,7 +79,7 @@ EXPORT_SYMBOL_GPL(sync_filesystem);
> =20
>  static void sync_one_sb(struct super_block *sb, void *arg)
>  {
> -	if (!(sb->s_flags & MS_RDONLY) && sb->s_bdi)
> +	if (!(sb->s_flags & MS_RDONLY))
>  		__sync_filesystem(sb, *(int *)arg);
>  }
>  /*
> diff -puN mm/backing-dev.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb mm=
/backing-dev.c
> --- a/mm/backing-dev.c~vfs-fix-null-pointer-oops-in-sync_inodes_sb
> +++ a/mm/backing-dev.c
> @@ -598,7 +598,7 @@ static void bdi_prune_sb(struct backing_
>  	spin_lock(&sb_lock);
>  	list_for_each_entry(sb, &super_blocks, s_list) {
>  		if (sb->s_bdi =3D=3D bdi)
> -			sb->s_bdi =3D NULL;
> +			sb->s_bdi =3D &default_backing_dev_info;
>  	}
>  	spin_unlock(&sb_lock);
>  }
> _
>=20
>=20
> btw, Christoph: would this not have been be a less hacky hack?
>=20
> --- a/fs/fs-writeback.c~a
> +++ a/fs/fs-writeback.c
> @@ -73,7 +73,7 @@ static inline struct backing_dev_info *i
>  {
>  	struct super_block *sb =3D inode->i_sb;
> =20
> -	if (strcmp(sb->s_type->name, "bdev") =3D=3D 0)
> +	if (sb =3D=3D blockdev_superblock)
>  		return inode->i_mapping->backing_dev_info;
> =20
>  	return sb->s_bdi;
> _
>=20

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk2CiO0ACgkQfKHnntdSXjThhgP9Hov0Iz2wqrfbtLReScenIJAp
zdNsXCx4si8DRVbOV5OY67KR5KcoFYix1D/AvqpcL3QcqAvsA01pLqBhSSraptkV
Gmi5Q23i81mSTvWHzSA5OaETUgxc6xyipodMpY7RQ1ZRGIR86z6luYKfa08CQKvU
zxemwwRrIa9MDUMyTWQ=
=DFzv
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
