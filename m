Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab2ARVlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:41:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52544 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2ARVk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:40:59 -0500
Date: Wed, 18 Jan 2012 15:40:51 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Li Wang <liwang@nudt.edu.cn>, ecryptfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dustin Kirkland <kirkland@canonical.com>
Subject: Re: [PATCH] eCryptfs: infinite loop bug
Message-ID: <20120118214051.GC20576@boyd>
References: <12011815300568720b5d1587bb777fed0d5b016f0854@nudt.edu.cn>
 <4F16E4BC.5080100@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <4F16E4BC.5080100@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-01-18 23:26:52, Cong Wang wrote:
> On 01/18/2012 03:30 PM, Li Wang wrote:
> >Hi,
> >   There is an infinite loop bug in eCryptfs, to make it present,
> >just truncate to generate a huge file (>=3D 4G) on a 32-bit machine
> >under the plain text foleder mounted with eCryptfs, a simple command
> >'truncate -s 4G dummy' is enough. Note: 4GB is smaller than 4G,
> >therefore the following command 'truncate -s 4GB dummy' will not trigger=
 this bug.
> >The bug comes from a data overflow, the patch below fixes it.
> >
> >
>=20
> Hi,
>=20
> Your patch is not correctly generated, you need to make the diff on
> top of the source tree.
>=20
> Also, after reviewing the code, I think there are more places need
> to fix. Can you try my patch below?

Thanks for the review and additional fixes. See my comments below.

>=20
> Thanks.
>=20
> ---->
>=20
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>=20
>=20

> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
> index a9f29b1..9ca9c17 100644
> --- a/fs/ecryptfs/ecryptfs_kernel.h
> +++ b/fs/ecryptfs/ecryptfs_kernel.h
> @@ -653,7 +653,7 @@ int ecryptfs_write_lower(struct inode *ecryptfs_inode=
, char *data,
>  			 loff_t offset, size_t size);
>  int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
>  				      struct page *page_for_lower,
> -				      size_t offset_in_page, size_t size);
> +				      loff_t offset_in_page, size_t size);
>  int ecryptfs_write(struct inode *inode, char *data, loff_t offset, size_=
t size);
>  int ecryptfs_read_lower(char *data, loff_t offset, size_t size,
>  			struct inode *ecryptfs_inode);
> diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
> index 3745f7c..93d80c4 100644
> --- a/fs/ecryptfs/read_write.c
> +++ b/fs/ecryptfs/read_write.c
> @@ -72,7 +72,7 @@ int ecryptfs_write_lower(struct inode *ecryptfs_inode, =
char *data,
>   */
>  int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
>  				      struct page *page_for_lower,
> -				      size_t offset_in_page, size_t size)
> +				      loff_t offset_in_page, size_t size)

mm/filemap.c uses unsigned long for variables used to identify an offset
into a single page. That's what I'm tempted to use for offset_in_page,
rather than loff_t.

>  {
>  	char *virt;
>  	loff_t offset;
> @@ -128,15 +128,15 @@ int ecryptfs_write(struct inode *ecryptfs_inode, ch=
ar *data, loff_t offset,
>  		pos =3D offset;
>  	while (pos < (offset + size)) {
>  		pgoff_t ecryptfs_page_idx =3D (pos >> PAGE_CACHE_SHIFT);
> -		size_t start_offset_in_page =3D (pos & ~PAGE_CACHE_MASK);
> -		size_t num_bytes =3D (PAGE_CACHE_SIZE - start_offset_in_page);
> -		size_t total_remaining_bytes =3D ((offset + size) - pos);
> +		loff_t start_offset_in_page =3D (pos & ~PAGE_CACHE_MASK);
> +		loff_t num_bytes =3D (PAGE_CACHE_SIZE - start_offset_in_page);

unsigned long should work for start_offset_in_page and num_bytes, too.

Tyler

> +		loff_t total_remaining_bytes =3D ((offset + size) - pos);
> =20
>  		if (num_bytes > total_remaining_bytes)
>  			num_bytes =3D total_remaining_bytes;
>  		if (pos < offset) {
>  			/* remaining zeros to write, up to destination offset */
> -			size_t total_remaining_zeros =3D (offset - pos);
> +			loff_t total_remaining_zeros =3D (offset - pos);
> =20
>  			if (num_bytes > total_remaining_zeros)
>  				num_bytes =3D total_remaining_zeros;


--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPFzxjAAoJENaSAD2qAscKx5oP/A9b7rNeMc50oqHsviZYPvFI
IoEpmFy+2wDNDqqIj7GtYQ724wjXrK6MdZ7fU8stSVbNeQFOOlPX9xuoupqwGg4z
k0d20gWOBLhSD5IMxkV2ot6rsH0x//kvHRFeoFkwO3j0AZWt7dwpRjVuTJdV+Bvw
9X51Lye5ljMGrVbyixZe6z1IaVEirvvGl65YU661Jymq+6UI6dFZCh8AoTckm2Rk
pumSSwCbEv7Z5FvXUmeENW9FCh4hzpiBHH8RIqBfs3O891X2s5meNkLDMZBeP3oT
oPPdFosXhWq64/hb6sltz6fdLRwzW9IGK4Ajn84WqK7OfYLYdUXnHr+0fL2H73g7
TPA8s3dbpUkgcjk1BLgBZYe2g73H48Q8R/cunl4kmgHBTZhYbc05VHn4Ng+70VRN
rugo05WKbWLrDQ3e1cw1Uyg+ulavCR5z8t+yNmPheMAKnsQQ6JskwyleGm/Q0HE/
EFbKAwbd61ikg4f4zvbjBD5yVna8umltSh4j7v+3WMDsP1JVrC7mV81RKDrwZ0gu
/Fk7uzrlKyeYzTDZENz7OZ9e5kFP1ocsiew2rVszkPj8QwDW0la6gVo1i/SfSi7K
hyNdIG3FBOLrYZEOxR3ooHNTRSJSjFsb5xTaXX+ZYyKxwrUn7N1qP6i/IimIJeef
RsQKJCf7MBjUFBG7iQb8
=9Vts
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
