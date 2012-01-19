Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab2ASP1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:27:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55799 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab2ASP1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:27:03 -0500
Date: Thu, 19 Jan 2012 09:26:55 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Li Wang <liwang@nudt.edu.cn>
Cc: dustin.kirkland@gazzang.com, torvalds@linux-foundation.org,
        ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        john.johansen@canonical.com, akpm@linux-foundation.org
Subject: Re: [PATCH] eCryptfs: truncate optimization (sometimes upto 25000x
 fa ster)
Message-ID: <20120119152654.GB18263@boyd>
References: <1201191719207c1a8e2a0d7a3f1e88c2fb8597295f6d@nudt.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <1201191719207c1a8e2a0d7a3f1e88c2fb8597295f6d@nudt.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-01-19 17:19:20, Li Wang wrote:
> Hi,
> Many modern disk-based file systems, such as ext4,
> have the truncate optimization feature, kind of delayed allocation, that =
is,=20
> when using 'truncate' to produce a big empty file, the file system will n=
ot=20
> allocate disk space until real data are written into, as a result,=20
> the execution of truncate is very fast and the disk space are saved.=20
> However, for eCryptfs, it will actually create a equal-size file, and wri=
te zeroes into it,=20
> which results in the allocation of disk space and slow disk write operati=
ons.=20
> Since eCryptfs does not record hole information on disk, therefore,=20
> when read out a page of zeroes, eCryptfs can not distinguish actual data=
=20
> (encrypted data happened to be whole zeroes) from hole,=20
> therefore, eCryptfs can not rely on the lower file system specific trunca=
te implementation.
> However, there is one thing eCryptfs can do is that eCryptfs does record =
file size itself
> on the disk, so that it could be aware of the hole at the end of the file=
=2E=20
> The natural optimization is, while truncate to expand a file to exceed th=
e original size=20
> (which occurs in many cases while doing truncate),=20
> record the actual file size (after expansion) in the eCryptfs metadata,=
=20
> keep the original size unchanged in the lower file system.=20
> When reading, if the file size seen from eCryptfs is bigger than from=20
> the lower file system side, it must contain a hole at the end of the file=
,=20
> eCryptfs just return zeroes for that part of data, no disk operations at =
all,=20
> and return them to user application, which casues an extremely fast trunc=
ation operation.=20
> For example, we mount eCryptfs on top of ext4, run the following command=
=20
> 'truncate -s 4G dummy', for the original version, it takes eCryptfs 100 s=
econds=20
> to finish, after our optimization, it takes only 4 miro-second, brings a =
25000x speedup.
> The patch below implements the method mentioned above.

Hi Li - While I would like to see the eCryptfs truncate performance
improve, I'm not a fan of this approach. It relies too much on the
already too fragile plaintext inode size stored in the file metadata and
I don't think that is a good idea.

I also think that this approach is just delaying the inevitable. If a
file is truncated to a large size, I think it will typically receive a
write towards the end of the newly extended portion of the file soon
after the truncate. That write will become the bottleneck, as zeros
must be written out, and we've ended up just moving the performance
problem elsewhere.

Tyler

>=20
> BTW: thanks Tyler to warmly remind us regarding the patch format,
> we will follow the rules later to submit the patch. For this truncate opt=
imization issue,=20
> we think it better to first post the idea to undergo discussions, for the=
 final code,
> we will make them strictly follow the kernel patch rule.
>=20
> Cheers,
> Li Wang
>=20
> Signed-off-by: Li Wang <liwang@nudt.edu.cn>
>                Yunchuan Wen <wenyunchuan@kylinos.com.cn>
>=20
> ---
>  =20
> diff -prNu a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> --- a/fs/ecryptfs/crypto.c	2012-01-19 15:30:25.656858654 +0800
> +++ b/fs/ecryptfs/crypto.c	2012-01-19 16:59:11.492281195 +0800
> @@ -515,6 +515,7 @@ int ecryptfs_encrypt_page(struct page *p
>  			goto out;
>  		}
>  	}
> +	SetPageMappedToDisk(page);
>  	rc =3D 0;
>  out:
>  	if (enc_extent_page) {
> @@ -599,11 +600,14 @@ out:
>   */
>  int ecryptfs_decrypt_page(struct page *page)
>  {
> +	loff_t offset;
>  	struct inode *ecryptfs_inode;
>  	struct ecryptfs_crypt_stat *crypt_stat;
>  	char *enc_extent_virt;
>  	struct page *enc_extent_page =3D NULL;
>  	unsigned long extent_offset;
> +	unsigned long extent_offset_max;
> +	unsigned long zero_nums;
>  	int rc =3D 0;
> =20
>  	ecryptfs_inode =3D page->mapping->host;
> @@ -618,24 +622,39 @@ int ecryptfs_decrypt_page(struct page *p
>  		goto out;
>  	}
>  	enc_extent_virt =3D kmap(enc_extent_page);
> +
> +	ecryptfs_lower_offset_for_extent(
> +		&offset, ((page->index * (PAGE_CACHE_SIZE
> +					  / crypt_stat->extent_size))
> +			  ), crypt_stat);
> +	rc =3D ecryptfs_read_lower(enc_extent_virt, offset,
> +				 PAGE_CACHE_SIZE,
> +				 ecryptfs_inode);
> +	if (rc < 0) {
> +		ecryptfs_printk(KERN_ERR, "Error attempting "
> +				"to read lower page; rc =3D [%d]"
> +				"\n", rc);
> +		goto out;
> +	}
> +
> +	extent_offset_max =3D (rc + crypt_stat->extent_size - 1) /
> +		crypt_stat->extent_size;
> +	zero_nums =3D PAGE_CACHE_SIZE=20
> +		- extent_offset_max * crypt_stat->extent_size;
> +
> +	if (zero_nums !=3D 0) {
> +		char *address =3D kmap(page);
> +		address +=3D PAGE_CACHE_SIZE - zero_nums;
> +		memset(address, 0, zero_nums);
> +		kunmap(page);
> +	}
> +=09
> +	if (extent_offset_max =3D=3D 0)
> +		goto out;
> +
>  	for (extent_offset =3D 0;
> -	     extent_offset < (PAGE_CACHE_SIZE / crypt_stat->extent_size);
> +	     extent_offset < extent_offset_max;
>  	     extent_offset++) {
> -		loff_t offset;
> -
> -		ecryptfs_lower_offset_for_extent(
> -			&offset, ((page->index * (PAGE_CACHE_SIZE
> -						  / crypt_stat->extent_size))
> -				  + extent_offset), crypt_stat);
> -		rc =3D ecryptfs_read_lower(enc_extent_virt, offset,
> -					 crypt_stat->extent_size,
> -					 ecryptfs_inode);
> -		if (rc < 0) {
> -			ecryptfs_printk(KERN_ERR, "Error attempting "
> -					"to read lower page; rc =3D [%d]"
> -					"\n", rc);
> -			goto out;
> -		}
>  		rc =3D ecryptfs_decrypt_extent(page, crypt_stat, enc_extent_page,
>  					     extent_offset);
>  		if (rc) {
> @@ -644,6 +663,7 @@ int ecryptfs_decrypt_page(struct page *p
>  			goto out;
>  		}
>  	}
> +	SetPageMappedToDisk(page);
>  out:
>  	if (enc_extent_page) {
>  		kunmap(enc_extent_page);
> diff -prNu a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> --- a/fs/ecryptfs/inode.c	2012-01-19 15:30:25.657858641 +0800
> +++ b/fs/ecryptfs/inode.c	2012-01-19 15:35:58.822693506 +0800
> @@ -811,6 +811,7 @@ static int truncate_upper(struct dentry
>  	struct inode *inode =3D dentry->d_inode;
>  	struct ecryptfs_crypt_stat *crypt_stat;
>  	loff_t i_size =3D i_size_read(inode);
> +	loff_t i_lower_size;
>  	loff_t lower_size_before_truncate;
>  	loff_t lower_size_after_truncate;
> =20
> @@ -822,8 +823,26 @@ static int truncate_upper(struct dentry
>  	if (rc)
>  		return rc;
>  	crypt_stat =3D &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
> +	i_lower_size =3D i_size_read(ecryptfs_inode_to_lower(inode))=20
> +		- ecryptfs_lower_header_size(crypt_stat);
>  	/* Switch on growing or shrinking file */
> -	if (ia->ia_size > i_size) {
> +	if (ia->ia_size > i_lower_size) {
> +		if (crypt_stat->flags & ECRYPTFS_ENCRYPTED) {
> +			truncate_setsize(inode, ia->ia_size);
> +			lower_ia->ia_valid &=3D ~ATTR_SIZE;
> +			rc =3D ecryptfs_write_inode_size_to_metadata(inode);
> +			if (rc) {
> +				printk(KERN_ERR	"Problem with "
> +				       "ecryptfs_write_inode_size_to_metadata; "
> +					   "rc =3D [%d]\n", rc);
> +				goto out;
> +			}
> +		} else {
> +			truncate_setsize(inode, ia->ia_size);
> +			lower_ia->ia_size =3D ia->ia_size;
> +			lower_ia->ia_valid |=3D ATTR_SIZE;
> +		}
> +	} else if (ia->ia_size > i_size) {
>  		char zero[] =3D { 0x00 };
> =20
>  		lower_ia->ia_valid &=3D ~ATTR_SIZE;
> @@ -832,7 +851,7 @@ static int truncate_upper(struct dentry
>  		 * the intermediate portion of the previous end of the
>  		 * file and the new and of the file */
>  		rc =3D ecryptfs_write(inode, zero,
> -				    (ia->ia_size - 1), 1);
> +					(ia->ia_size - 1), 1);
>  	} else { /* ia->ia_size < i_size_read(inode) */
>  		/* We're chopping off all the pages down to the page
>  		 * in which ia->ia_size is located. Fill in the end of
> diff -prNu a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
> --- a/fs/ecryptfs/mmap.c	2011-10-24 15:10:05.000000000 +0800
> +++ b/fs/ecryptfs/mmap.c	2012-01-19 15:36:02.119652666 +0800
> @@ -52,6 +52,39 @@ struct page *ecryptfs_get_locked_page(st
>  	return page;
>  }
> =20
> +static int ecryptfs_fill_hole(struct inode *inode, pgoff_t end)
> +{
> +	pgoff_t index;
> +	int rc =3D 0;
> +	struct inode *lower_inode;
> +	struct ecryptfs_crypt_stat *crypt_stat;
> +
> +	lower_inode =3D ecryptfs_inode_to_lower(inode);
> +	crypt_stat =3D &ecryptfs_inode_to_private(inode)->crypt_stat;
> +
> +	index =3D (i_size_read(lower_inode) - ecryptfs_lower_header_size(crypt_=
stat))
> +		>> PAGE_CACHE_SHIFT;
> +
> +	while (index <=3D end) {
> +		struct page *page =3D ecryptfs_get_locked_page(inode, index);
> +		if (unlikely(IS_ERR(page))) {
> +			rc =3D PTR_ERR(page);
> +			goto out;
> +		}
> +		if (!PageMappedToDisk(page))
> +			rc =3D ecryptfs_encrypt_page(page);
> +		else
> +			rc =3D 0;
> +		unlock_page(page);
> +		page_cache_release(page);
> +		if (unlikely(rc))
> +			goto out;
> +		++index;
> +	}
> +out:
> +	return rc;
> +}
> +
>  /**
>   * ecryptfs_writepage
>   * @page: Page that is locked before this call is made
> @@ -74,6 +107,14 @@ static int ecryptfs_writepage(struct pag
>  		goto out;
>  	}
> =20
> +	if (page->index > 0) {
> +		rc =3D ecryptfs_fill_hole(page->mapping->host, page->index - 1);
> +		if (rc) {
> +			ClearPageUptodate(page);
> +			goto out;
> +		}
> +	}
> +
>  	rc =3D ecryptfs_encrypt_page(page);
>  	if (rc) {
>  		ecryptfs_printk(KERN_WARNING, "Error encrypting "
> diff -prNu a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
> --- a/fs/ecryptfs/read_write.c	2011-10-24 15:10:05.000000000 +0800
> +++ b/fs/ecryptfs/read_write.c	2012-01-19 15:36:02.118652694 +0800
> @@ -177,7 +177,6 @@ int ecryptfs_write(struct inode *ecryptf
>  		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
>  		flush_dcache_page(ecryptfs_page);
>  		SetPageUptodate(ecryptfs_page);
> -		unlock_page(ecryptfs_page);
>  		if (crypt_stat->flags & ECRYPTFS_ENCRYPTED)
>  			rc =3D ecryptfs_encrypt_page(ecryptfs_page);
>  		else
> @@ -185,6 +184,7 @@ int ecryptfs_write(struct inode *ecryptf
>  						ecryptfs_page,
>  						start_offset_in_page,
>  						data_offset);
> +		unlock_page(ecryptfs_page);
>  		page_cache_release(ecryptfs_page);
>  		if (rc) {
>  			printk(KERN_ERR "%s: Error encrypting "

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPGDY+AAoJENaSAD2qAscKak0QAIqSJOtuWouEJmyz+w/4RgWU
3HsmiWBggoXg4V04yqgKjfTnmO20ACkrGQhz7Tla8sIY+ERUJ8jU9+9PoZ2ZRRHD
UQkZ2gj+QN51z29Dw6aCX5nCkFxgp61cnii5aVA+3OCEmkW0+hsjHFGzVBySBxQK
EdPub2h7RyVddZkK8SEC23qiX3TJDAbK950cvDzSuWFSkEDJXt6vBY6J+uxnSY3H
L6pK/YEwvjDEsVpjzu9UWo2wPXGwXA9pnAnHeD9dQoNHYUjowk24sx7YxP5c8/IV
V5XbP2687YMRvkf2ASSUFcItdN77ys9XIObEtASRk4XI1tlQqMPuygs66omf/3Lp
vSKGNX9BwWlEdLb6mLC/XSmI1gZgMkhAJYNvw7ZxwFWD0tI4vKGWnutiGg7/Nj2w
lnaFX52K7yN0+Zn89amQdEbaJAqHvnysuWRawQdfR04XOwPoH54rcCdQeIxPb8Gh
6EdhKvs3o+zM84/HjOhnXGHa1p/7C5miZ2z7VzPY/Ytv4ooAN5syFYZT5MMu1T/S
SxRj4WQuMWaNuFqNpXVksxi5aXY77jGMrMNs+OFYdXgXj1VFo59hiGWx6iubKRLL
n9cnqoZT82hdTxxPZ1EpFWii37Aoyma/XEt+0mCR0hhPhuYGb2FuG8Ez8zgBp5qP
ilBb3kQsjmLxtgddAz/+
=Xwcw
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
