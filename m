Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab1KRTxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:53:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57588 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab1KRTxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:53:47 -0500
Date: Fri, 18 Nov 2011 13:53:39 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Thieu Le <thieule@chromium.org>
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: Export fallocate facility to kernel modules
Message-ID: <20111118195338.GC9869@boyd>
References: <20111105170357.GA24875@boyd>
 <1321474961-17595-1-git-send-email-thieule@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
In-Reply-To: <1321474961-17595-1-git-send-email-thieule@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2011-11-16 12:22:41, Thieu Le wrote:
> Export fallocate facility so layered file systems such as ecryptfs can
> take advantage of this feature.  One example of the need for fallocate
> is by ecryptfs.  ecryptfs has recently switched to a writeback cache
> model so its dirty pages are not written to the lower file system
> immediately.  In order to ensure that space is available when the page
> is later written, ecryptfs can efficiently preallocate that space using
> vfs_fallocate().
>=20
> vfs_fallocate() does not perform all of the checkings of do_fallocate()
> because those checks are done higher in the stack.  Checking of offset and
> len are done by rw_verify_area() and generic_write_checks().  These
> functions are called by VFS before ecryptfs invokes vfs_fallocate() in its
> ecryptfs_write_end() function.  And since ecryptfs directly opens the low=
er
> file, it ensures that the file is opened with the proper flags and mode.

This looks good to me. Feel free to add my Reviewed-by. Of course, it
will need final sign-off by Al and/or Christoph.

Tyler

>=20
> Signed-off-by: Thieu Le <thieule@chromium.org>
> ---
>  fs/open.c          |   32 ++++++++++++++++++++------------
>  include/linux/fs.h |    2 ++
>  2 files changed, 22 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/open.c b/fs/open.c
> index 22c41b5..65c0049 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -214,13 +214,9 @@ SYSCALL_ALIAS(sys_ftruncate64, SyS_ftruncate64);
>  #endif /* BITS_PER_LONG =3D=3D 32 */
> =20
> =20
> -int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> +int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  {
>  	struct inode *inode =3D file->f_path.dentry->d_inode;
> -	long ret;
> -
> -	if (offset < 0 || len <=3D 0)
> -		return -EINVAL;
> =20
>  	/* Return error if mode is not supported */
>  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> @@ -231,13 +227,28 @@ int do_fallocate(struct file *file, int mode, loff_=
t offset, loff_t len)
>  	    !(mode & FALLOC_FL_KEEP_SIZE))
>  		return -EOPNOTSUPP;
> =20
> -	if (!(file->f_mode & FMODE_WRITE))
> -		return -EBADF;
> -
>  	/* It's not possible punch hole on append only file */
>  	if (mode & FALLOC_FL_PUNCH_HOLE && IS_APPEND(inode))
>  		return -EPERM;
> =20
> +	if (!file->f_op->fallocate)
> +		return -EOPNOTSUPP;
> +
> +	return file->f_op->fallocate(file, mode, offset, len);
> +}
> +EXPORT_SYMBOL(vfs_fallocate);
> +
> +int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> +{
> +	struct inode *inode =3D file->f_path.dentry->d_inode;
> +	long ret;
> +
> +	if (offset < 0 || len <=3D 0)
> +		return -EINVAL;
> +
> +	if (!(file->f_mode & FMODE_WRITE))
> +		return -EBADF;
> +
>  	if (IS_IMMUTABLE(inode))
>  		return -EPERM;
> =20
> @@ -263,10 +274,7 @@ int do_fallocate(struct file *file, int mode, loff_t=
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
> index 0c4df26..e7d26ee 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1524,6 +1524,8 @@ extern int vfs_link(struct dentry *, struct inode *=
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

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJOxrfCAAoJENaSAD2qAscKwUEQALRMUQwmAbFQ4N+FqgAyANkb
yEYLg6LXIjZEA21iGpGzNDfcat9sMrghOIbIMbq+i1WZ5Riz14hBficf/G3ArSJf
jXZYr2VUXITkX+RoYZ5d1pL4e+SFsc3PawvXX3ypq5lVHQcEM7JGw3QNLDC9jeEB
IBjdz97vq4i+b1LY1ri7w23VGRuA0v1IcNjHO2NnbQdo7ByQinJXJqxVyHoUJ7up
uMQldYr7hiS4hBxAeS6K0lEt2HwNh2I/Dsdsq+vMJhOlhlwfgGf63X9BkRtVJn93
QOH3lDr3tuNpVE485gNpxQFekrqRUVcWgXGd9a6vWrLNw1ITFS1tlChcQndpW8+X
/160g10vnZhBd81xcQlJq1nSpqTGoJYnGsyl3ow2sY7qwX3fTVTrLTjB3BWFdTUD
sKH+LbqYGtguAi3JygNa2GY2TCQ7n0YPOWTCwrAvdquA6Ss/EbFSzoOC8ez3zWnF
dredkQWT/bFftDMc0NZNYVV3oqx0H1aCJlw7+KmJ0JHS/S0TFxBlTTIvBDz80V7g
qSiEMkJI/Gxfweuit0PheswFrSqRvzCv8waet7q1Ws3Z6DYk2t74qVSX0DmOK38G
V3vcr66yX9UnexN7otOuWllVDulHzlcWM6WeaWd41kujaBW9HXCkXmy/0pE5ARX1
swY4xIlU0nY0trJqZiNa
=+ee/
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
