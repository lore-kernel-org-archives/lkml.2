Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1KEREN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 13:04:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44023 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab1KEREL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 13:04:11 -0400
Date: Sat, 5 Nov 2011 13:04:01 -0400
From: Tyler Hicks <tyhicks@canonical.com>
To: Thieu Le <thieule@chromium.org>
Cc: viro@zeniv.linux.org.uk, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: Export fallocate facility to kernel modules
Message-ID: <20111105170357.GA24875@boyd>
References: <1320088445-12373-1-git-send-email-thieule@chromium.org>
 <20111105123001.GA23778@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20111105123001.GA23778@boyd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2011-11-05 08:30:02, Tyler Hicks wrote:
> On 2011-10-31 12:14:05, Thieu Le wrote:
> > Export fallocate facility so layered file systems such as ecryptfs can
> > take advantage of this feature.  One example of the need for fallocate
> > is by ecryptfs.  ecryptfs has recently switched to a writeback cache
> > model so its dirty pages are not written to the lower file system
> > immediately.  In order to ensure that space is available when the page
> > is later written, ecryptfs can efficiently preallocate that space using
> > vfs_fallocate().
>=20
> Hi Thieu - Thanks for the patch. Something like this is definitely
> needed for eCryptfs.
>=20
> >=20
> > vfs_fallocate() does not perform all of the checkings of do_fallocate()
> > because those checks are done higher in the stack.
>=20
> After taking a closer look at the checks in do_fallocate(), I don't know
> that this statement is correct. The sanity checks around offset, len,
> and mode aren't guaranteed to be done higher up in the stack. The
> existing VFS helper functions also seem to do these types of checks. I
> think the rest of the checks are redundant.

I obviously goofed up here. Thieu states where offset and len are
checked in his following sentence. Not sure how I missed that. My
apologies.

However, I do still think that we need the fallocate mode checks in
vfs_fallocate().

Tyler

> > Checking of offset and
> > len are done by rw_verify_area() and generic_write_checks().  These
> > functions are called by VFS before ecryptfs invokes vfs_fallocate() in =
its
> > ecryptfs_write_end() function.  And since ecryptfs directly opens the l=
ower
> > file, it ensures that the file is opened with the proper flags and mode.
> >=20
> > Signed-off-by: Thieu Le <thieule@chromium.org>
> > ---
> >  fs/open.c          |   14 ++++++++++----
> >  include/linux/fs.h |    2 ++
> >  2 files changed, 12 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/fs/open.c b/fs/open.c
> > index f711921..8a4ba20 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -214,6 +214,15 @@ SYSCALL_ALIAS(sys_ftruncate64, SyS_ftruncate64);
> >  #endif /* BITS_PER_LONG =3D=3D 32 */
> > =20
> > =20
> > +int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t l=
en)
> > +{
> > +	if (!file->f_op->fallocate)
> > +		return -EOPNOTSUPP;
> > +
> > +	return file->f_op->fallocate(file, mode, offset, len);
> > +}
> > +EXPORT_SYMBOL(vfs_fallocate);
> > +
> >  int do_fallocate(struct file *file, int mode, loff_t offset, loff_t le=
n)
> >  {
> >  	struct inode *inode =3D file->f_path.dentry->d_inode;
> > @@ -263,10 +272,7 @@ int do_fallocate(struct file *file, int mode, loff=
_t offset, loff_t len)
> >  	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0=
))
> >  		return -EFBIG;
> > =20
> > -	if (!file->f_op->fallocate)
> > -		return -EOPNOTSUPP;
> > -
> > -	return file->f_op->fallocate(file, mode, offset, len);
> > +	return vfs_fallocate(file, mode, offset, len);
> >  }
> > =20
> >  SYSCALL_DEFINE(fallocate)(int fd, int mode, loff_t offset, loff_t len)
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 277f497..c0e1225 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1504,6 +1504,8 @@ extern int vfs_link(struct dentry *, struct inode=
 *, struct dentry *);
> >  extern int vfs_rmdir(struct inode *, struct dentry *);
> >  extern int vfs_unlink(struct inode *, struct dentry *);
> >  extern int vfs_rename(struct inode *, struct dentry *, struct inode *,=
 struct dentry *);
> > +extern int vfs_fallocate(struct file *file, int mode, loff_t offset,
> > +			 loff_t len);
> > =20
> >  /*
> >   * VFS dentry helper functions.
> > --=20
> > 1.7.3.1
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html



--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJOtWx9AAoJENaSAD2qAscKXW0QAMzYJrqGbdNzDE4gku4PhyN8
sbPHkkTCanmuUBILOQuSYUJn/1oKu3AxlDhBCK+geGqtzVbTYuBY1H3K5xKIxk8o
J1MT7bnbQW24jpt8jMDTllfUYM2dbzl/7HnIo0tU0Px92D5JbWhKxaWyy132bs9i
dwcTKPjc+cz0CuCq8CpohKzmHxDhV6MRtvgU0EK+J8ZG30YPUFutGh4D8TYXDB2K
SsZzMsJQWMkZPVY30jHcA9BsYkYOULgIywz8vgk7Ohy22Zg/n1Bs3TivnXarplNy
KrxOc/dMrpgrXvKSMEYIQPA3uD8bHtOTe/2yLkMIuRqYSMdfwmu+MoSyfMxUgPpu
+DpWt3lwK/GamJv7tE3sgHXNZKa//xVEx8D8CoLY6dNGAFfGzJsHybS5VMKvEN+Y
5AXtGG8sBMsjyV8b3hAfvfl93JblMVNPfhkSIJ9OINzesaQPHiKeBQOwlBDUuyK3
4gygRd04JgZNmOx+NNwoy+ue9j/up7ZJebmvzQpstLnn9jVod41bPsWdLCtf8dXw
UVQmtDRJcDYxAWj1JmVt33qUK/cPuz3Ph8/zJUaSlSgllm/JTfwOxNBPIZyNe5Ck
vyGrCSbe+CqUFS7ETxa2bOVfkMqzrtFTNrTNEgsVmJN3lZ99+D25AQ4wEbweAQ0v
ZbrSjwX6ESMtb+djJYiQ
=HtQ3
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
