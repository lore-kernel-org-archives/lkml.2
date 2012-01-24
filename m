Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab2AXGdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 01:33:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43181 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2AXGc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 01:32:59 -0500
Date: Tue, 24 Jan 2012 00:32:47 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Li Wang <liwang@nudt.edu.cn>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        john.johansen@canonical.com, dustin.kirkland@gazzang.com,
        Cong Wang <xiyou.wangcong@gmail.com>, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] eCryptfs: Check inode changes in setattr
Message-ID: <20120124063246.GA5692@boyd>
References: <1327098907-28963-1-git-send-email-tyhicks@canonical.com>
 <527098189.19032@eyou.net>
 <120121155758aecba8095c7be7e9983b250416d86f0c@nudt.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <120121155758aecba8095c7be7e9983b250416d86f0c@nudt.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-01-21 15:57:58, Li Wang wrote:
> Hi Tyler,
>   Please consider the following two things,

Hello - Thanks for the review!

> 1. While invoking inode_newsize_ok/inode_change_ok, it just make sure the=
 new file size seen from
> eCryptfs will not exceed the whatever kinds of file size limit, what abou=
t the new size does not
> exceed the limit, plus ecryptfs_lower_header_size will. Therefore the saf=
est way is to check the
> new size seen from lower file system, which is ecryptfs_lower_header_size=
 bigger. =20
> 2. The senmatics of sb->s_maxbytes, is the maximum file size allowed by t=
he file system=20
> repsented by sb. For eCryptfs, it should be lower_sb->s_maxbytes - ecrypt=
fs_lower_header_size,=20
> rather than equal to lower_sb->s_maxbytes. However, the ecryptfs_lower_he=
ader_size is different
> file by file, not a file system wide constant. It is, kind of nasty and w=
e cannot trust it.=20
> Combined with the reason 1, we prefer to execute an extra new size check =
on lower inode
> after inode_change_ok on ecryptfs inode. For ecryptfs_truncate, directly =
perform new size check
> on lower inode.=20
>   Please check the patch below.

I generally agree with this description, but have some comments below
regarding implementation details.

>=20
> Cheers,
> Li Wang
>=20
> Signed-off-by: Li Wang <liwang@nudt.edu.cn>
>                Yunchuan Wen <wenyunchuan@kylinos.com.cn>
>=20
> ---
>=20
> diff -prNu a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> --- a/fs/ecryptfs/inode.c	2012-01-05 07:55:44.000000000 +0800
> +++ b/fs/ecryptfs/inode.c	2012-01-21 15:55:21.000000000 +0800
> @@ -841,18 +841,6 @@ static int truncate_upper(struct dentry=20
>  		size_t num_zeros =3D (PAGE_CACHE_SIZE
>  				    - (ia->ia_size & ~PAGE_CACHE_MASK));
> =20
> -
> -		/*
> -		 * XXX(truncate) this should really happen at the begginning
> -		 * of ->setattr.  But the code is too messy to that as part
> -		 * of a larger patch.  ecryptfs is also totally missing out
> -		 * on the inode_change_ok check at the beginning of
> -		 * ->setattr while would include this.
> -		 */
> -		rc =3D inode_newsize_ok(inode, ia->ia_size);
> -		if (rc)
> -			goto out;
> -
>  		if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
>  			truncate_setsize(inode, ia->ia_size);
>  			lower_ia->ia_size =3D ia->ia_size;
> @@ -916,8 +904,14 @@ int ecryptfs_truncate(struct dentry *den
>  {
>  	struct iattr ia =3D { .ia_valid =3D ATTR_SIZE, .ia_size =3D new_length =
};
>  	struct iattr lower_ia =3D { .ia_valid =3D 0 };
> +	struct ecryptfs_crypt_stat *crypt_stat;
>  	int rc;
> -
> +=09
> +	crypt_stat =3D &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
> +	rc =3D inode_newsize_ok(ecryptfs_inode_to_lower(dentry->d_inode), new_l=
ength + ecryptfs_lower_header_size(crypt_stat));

A few issues here..

1) This is not taking into account the padding added to the last
encryption extent. It can range between 0 and
(ECRYPTFS_DEFAULT_EXTENT_SIZE - 1) bytes.

2) To call inode_newsize_ok() on the lower inode, we'd need to be
holding its i_mutex.

3) I'm not comfortable calling inode_newsize_ok() directly on the lower
inode. I suppose that some filesystems may need a chance to get i_size up to
date (that's what eCryptfs is potentially doing at the start of
->setattr() when reading the metadata). Since
inode_change_ok()/inode_newsize_ok() is not called by the VFS, that
implies to me that it is not safe for us to just blindly call into with
another filesystem's inodes.

So, I say that we do something along these lines:

inode_newsize_ok(ecryptfs_inode, upper_size_to_lower_size(ia->ia_size));

It isn't ideal, but I'd rather not open code our own version of
inode_newsize_ok().

> +	if (rc)
> +		return rc;
> +=09
>  	rc =3D truncate_upper(dentry, &ia, &lower_ia);
>  	if (!rc && lower_ia.ia_valid & ATTR_SIZE) {
>  		struct dentry *lower_dentry =3D ecryptfs_dentry_to_lower(dentry);
> @@ -997,6 +991,15 @@ static int ecryptfs_setattr(struct dentr
>  		}
>  	}
>  	mutex_unlock(&crypt_stat->cs_mutex);
> +=09
> +	rc =3D inode_change_ok(inode, ia);
> +	if (rc)
> +		goto out;
> +	if (ia->ia_valid & ATTR_SIZE)
> +		rc =3D inode_newsize_ok(lower_inode, ia->ia_size + ecryptfs_lower_head=
er_size(crypt_stat));

I think that all of the points above apply here, as well.

I'll try to get a patch out in response to this email.

Tyler

> +	if (rc)
> +		goto out;
> +=09
>  	if (S_ISREG(inode->i_mode)) {
>  		rc =3D filemap_write_and_wait(inode->i_mapping);
>  		if (rc)
>=20
>=20
>=20
>=20
>=20
> ---------- Origin message ----------
> >From=EF=BC=9A"Tyler Hicks" <tyhicks@canonical.com>
> >To=EF=BC=9Aecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux=
-fsdevel@vger.kernel.org
> >Subject=EF=BC=9A[PATCH 2/3] eCryptfs: Check inode changes in setattr
> >Date=EF=BC=9A2012-01-21 06:35:06
>=20
> Most filesystems call inode_change_ok() very early in ->setattr(), but
> eCryptfs didn't call it at all. It allowed the lower filesystem to make
> the call in its ->setattr() function. Then, eCryptfs would copy the
> appropriate inode attributes from the lower inode to the eCryptfs inode.
>=20
> This patch changes that and actually calls inode_change_ok() on the
> eCryptfs inode, fairly early in ecryptfs_setattr(). Ideally, the call
> would happen earlier in ecryptfs_setattr(), but there is some possible
> inode initialization that must happen first.
>=20
> Since the call was already being made on the lower inode, the change in
> functionality should be minimal, except for the case of a file extending
> truncate call. In that case, inode_newsize_ok() was never being
> called on the eCryptfs inode. Rather than inode_newsize_ok() catching
> errors early on, eCryptfs would encrypt zeroed pages and write them to
> the lower filesystem until the lower filesystem's write path caught the
> error in generic_write_checks().
>=20
> In summary this change prevents eCryptfs truncate operations (and the
> resulting page encryptions), which would exceed the lower filesystem=20

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPHlCOAAoJENaSAD2qAscKUr4P/RzCwUT2Qz5t/u0eXzdoBnM/
rwkoydHd6Gc0OVvPiHDWzBNJQfajr2pADju5BKA2ldtLlDJDYwaoLoFlJtxdnkW1
PaXL3pExPg2RnxmGUdx9aKOUqi5TWGRjQeJp2QucWaRuy3n9QMCf7lRMK5Fn4biJ
RIUoDH47J+f7U/ERNh+26AWJdnFp/Sxr5lhBpSoa6xRq+gl7eu3RhR4Uzca6KUv+
C2E6eVOu70mMiskwj/clo2CQ8ZRLcF0OhVFcHy+AfxjbVdX3bjH4FmukYrg6PY99
PLtNRctcbQBEFDNysrwnJaQrDtdK5FOyVD3xRTs+mf2VNAHwKPUrxBWzHIrKef0B
nmd76Gtco79Vyrlzd2g6kEU6e1BPaJzK/ZizEyzT7mbCUKL0pFInPGWfwocu3+KQ
FXxD2dkCaYZg2ViSc1QurDFPJ5rj/GpapgItdc/jrj6XuTLP0w9qtNljX2h5FG2A
lLdjPZi1Su/3jOeSilOSTuL+VFtTYD9AGyqB92XX56be0DecvfFy0Qrgj4jMbciP
5R5IzdVypgD/oA83x+Z1C2V5Su17gZqjZVx2MG+GqEfb8namUIawCsnGEh7xC3Zj
Tm30ku4NBa3GKslm8HzfqEMFRdFS4V6m80s3uuKd0QmuWewcAjV3JUQ3NcVfA0VE
6WHZPPtaqr7BZKkXv9dD
=82Z/
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
