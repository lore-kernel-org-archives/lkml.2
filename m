Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab1KEMaP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 08:30:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34463 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1KEMaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 08:30:12 -0400
Date: Sat, 5 Nov 2011 08:30:02 -0400
From: Tyler Hicks <tyhicks@canonical.com>
To: Thieu Le <thieule@chromium.org>
Cc: viro@zeniv.linux.org.uk, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: Export fallocate facility to kernel modules
Message-ID: <20111105123001.GA23778@boyd>
References: <1320088445-12373-1-git-send-email-thieule@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <1320088445-12373-1-git-send-email-thieule@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2011-10-31 12:14:05, Thieu Le wrote:
> Export fallocate facility so layered file systems such as ecryptfs can
> take advantage of this feature.  One example of the need for fallocate
> is by ecryptfs.  ecryptfs has recently switched to a writeback cache
> model so its dirty pages are not written to the lower file system
> immediately.  In order to ensure that space is available when the page
> is later written, ecryptfs can efficiently preallocate that space using
> vfs_fallocate().

Hi Thieu - Thanks for the patch. Something like this is definitely
needed for eCryptfs.

>=20
> vfs_fallocate() does not perform all of the checkings of do_fallocate()
> because those checks are done higher in the stack.

After taking a closer look at the checks in do_fallocate(), I don't know
that this statement is correct. The sanity checks around offset, len,
and mode aren't guaranteed to be done higher up in the stack. The
existing VFS helper functions also seem to do these types of checks. I
think the rest of the checks are redundant.

Tyler

> Checking of offset and
> len are done by rw_verify_area() and generic_write_checks().  These
> functions are called by VFS before ecryptfs invokes vfs_fallocate() in its
> ecryptfs_write_end() function.  And since ecryptfs directly opens the low=
er
> file, it ensures that the file is opened with the proper flags and mode.
>=20
> Signed-off-by: Thieu Le <thieule@chromium.org>
> ---
>  fs/open.c          |   14 ++++++++++----
>  include/linux/fs.h |    2 ++
>  2 files changed, 12 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/open.c b/fs/open.c
> index f711921..8a4ba20 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -214,6 +214,15 @@ SYSCALL_ALIAS(sys_ftruncate64, SyS_ftruncate64);
>  #endif /* BITS_PER_LONG =3D=3D 32 */
> =20
> =20
> +int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> +{
> +	if (!file->f_op->fallocate)
> +		return -EOPNOTSUPP;
> +
> +	return file->f_op->fallocate(file, mode, offset, len);
> +}
> +EXPORT_SYMBOL(vfs_fallocate);
> +
>  int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  {
>  	struct inode *inode =3D file->f_path.dentry->d_inode;
> @@ -263,10 +272,7 @@ int do_fallocate(struct file *file, int mode, loff_t=
 offset, loff_t len)
>  	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
>  		return -EFBIG;
> =20
> -	if (!file->f_op->fallocate)
> -		return -EOPNOTSUPP;
> -
> -	return file->f_op->fallocate(file, mode, offset, len);
> +	return vfs_fallocate(file, mode, offset, len);
>  }
> =20
>  SYSCALL_DEFINE(fallocate)(int fd, int mode, loff_t offset, loff_t len)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 277f497..c0e1225 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1504,6 +1504,8 @@ extern int vfs_link(struct dentry *, struct inode *=
, struct dentry *);
>  extern int vfs_rmdir(struct inode *, struct dentry *);
>  extern int vfs_unlink(struct inode *, struct dentry *);
>  extern int vfs_rename(struct inode *, struct dentry *, struct inode *, s=
truct dentry *);
> +extern int vfs_fallocate(struct file *file, int mode, loff_t offset,
> +			 loff_t len);
> =20
>  /*
>   * VFS dentry helper functions.
> --=20
> 1.7.3.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJOtSxJAAoJENaSAD2qAscKQ/cP/RjZWDBzYaIIibS7N8FxCFyA
hKI0t6WD2E5Sf7oGaMSnGwOZ2+NjAZR61juaGHpp7UKJEy6HUTCkElcyxfX8L+OM
uzlSOtEGn3mL7HcF9apxbgHaqzqi6t44niiyRM+wbOlqw3HknK18p/0pV2QUc65N
opb8iG8ElRRq/+WHznAWxsdmOBbg2AMGMgPu5s25PaAaUiy7DKabpY5WHsmORK8E
yd8ljPkHhTc25lkZ2zotRnU7zcef339BqaG0nL33yi9hdWPf6iZ6iyDtJt53MDdP
lFtGCHMf15xwXgmn7TF/m8LNzRewKlllP858PPAZQa0HJQxj47W3HVs86OdfukbZ
p+O3aSFaBykos17qwEfzWVMiLkQ1VQVCjeenB5qNBa2IG8xt3PAkoT69f5nAWoIO
fmQlHMBCTsqyRNRQTdh0J0ze3+9Q7BLvwpWAw0iHBTqwgiOf1fEBo0VTE090QyQF
OqRWVnC/hRFdSsqdhL1EbM6b6PfQ8g8z8exa4kazBBuFYHNpMV7wl7qbNCLOPXfY
1rJQyEbXb89MmisbVvE68T7kWZMixARtdKR4VfW4Xo5m0OhMU30d3rDYqFioZc0s
5jrrpl5wI8866uocWjJuBn9y7I+0gGvlL2a4vSnGneEs7o3l5A5KZINNlJMtJ22X
5vuupLuz63t1S93c28nU
=NYDf
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
