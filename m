Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513Ab2CNU4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:56:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50167 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761374Ab2CNU4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:56:17 -0400
Date: Wed, 14 Mar 2012 15:56:03 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: Li Wang <liwang@nudt.edu.cn>
Cc: Dustin Kirkland <dustin.kirkland@gazzang.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yunchuan Wen <wenyunchuan@kylinos.com.cn>, ecryptfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eCryptfs: Fix kernel bug for writing mmaped non-eCryptfs
 file
Message-ID: <20120314205603.GA4484@boyd>
References: <1331638789-3770-1-git-send-email-liwang@nudt.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <1331638789-3770-1-git-send-email-liwang@nudt.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-03-13 19:39:49, Li Wang wrote:
> eCryptfs did not handle the writing for mmaped non-eCryptfs file.
> Instead, it put BUG_ON(!(crypt_stat->flags & ECRYPTFS_ENCRYPTED))
> on ecryptfs_writepage call path. This patch enables eCryptfs to
> deal with such case, to fully support non-eCryptfs operations as it
> claims.

Hi Li - Thanks for the patch!

Before I review/merge it, I'm curious if you use the
ecryptfs_plaintext_passthrough feature? IMO, it is a terrible design and
I've found that hardly anyone uses it. Maybe *no one*, after knowing
that mmap was broken for plaintext files...

Having to pre-create the file in the lower filesystem in order for it to
be a "plaintext" file inside the eCryptfs mount is a terrible idea. The
admin/user/application has no idea if the file is plaintext by looking
at it inside the eCryptfs mount and he/she has to examine the file in
the lower filesystem to find out. If that file is ever unlinked and then
created again, it turns into an encrypted file. There is too much
uncertainty around this feature for it to exist in a cryptographic
filesystem.

I'd really like to continue focusing on getting eCryptfs as stable as
possible and then dump the CONFIG_EXPERIMENTAL dependency at some point.
As a prerequisite to that, I'm thinking that
ecryptfs_plaintext_passthrough support should be removed, at least in
its current form. Any thoughts?

Tyler

>=20
> ---
>=20
> To make the bug present
>=20
> cd cipher // enter eCryptfs cipher text folder
> echo "123" > foo // make non-eCryptfs file
> cd ..
> mount -t ecryptfs cipher plain -o ecryptfs_passthrough // allow for non-e=
Cryptfs files to be read and written from within an eCryptfs mount
> cd plain
> run the following program
>=20
> int main()
> {
> 	int fd =3D open("foo", O_RDWR);
> 	char * addr;
> 	addr =3D (char *)mmap(NULL, 256, PROT_READ | PROT_WRITE, MAP_SHARED, fd,=
 0);
> 	add[0] =3D '3';
> 	munmap(addr, 256);
> 	close(fd);
> 	return 0;
> }
>=20
> Signed-off-by: Li Wang <liwang@nudt.edu.cn>
> Signed-off-by: Yunchuan Wen <wenyunchuan@kylinos.com.cn>
> ---
>  fs/ecryptfs/mmap.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
>=20
> diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
> index 10ec695..a4be0e9 100644
> --- a/fs/ecryptfs/mmap.c
> +++ b/fs/ecryptfs/mmap.c
> @@ -65,6 +65,32 @@ struct page *ecryptfs_get_locked_page(struct inode *in=
ode, loff_t index)
>  static int ecryptfs_writepage(struct page *page, struct writeback_contro=
l *wbc)
>  {
>  	int rc;
> +	struct inode *inode;
> +	struct ecryptfs_crypt_stat *crypt_stat;
> +
> +	inode =3D page->mapping->host;
> +	crypt_stat =3D &ecryptfs_inode_to_private(inode)->crypt_stat;
> +	if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
> +		size_t size;
> +		loff_t file_size =3D i_size_read(inode);
> +		pgoff_t end_page_index =3D file_size >> PAGE_CACHE_SHIFT;
> +
> +		if (end_page_index < page->index)
> +			size =3D 0;
> +		else if (end_page_index =3D=3D page->index)
> +			size =3D file_size & ~PAGE_CACHE_MASK;
> +		else
> +			size =3D PAGE_CACHE_SIZE;
> +
> +		rc =3D ecryptfs_write_lower_page_segment(inode, page, 0, size);
> +		if (unlikely(rc)) {
> +			ecryptfs_printk(KERN_WARNING, "Error write "
> +					"page (upper index [0x%.16lx])\n", page->index);
> +			ClearPageUptodate(page);
> +		} else
> +			SetPageUptodate(page);
> +		goto out;
> +	}
> =20
>  	/*
>  	 * Refuse to write the page out if we are called from reclaim context
> --=20
> 1.7.6.5
>=20

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPYQXiAAoJENaSAD2qAscKMaYP/1zeOjWlpI0IV9MYgvkUEn5C
LFZuOxroGWz02BN0bGlOTASD6lzCDs7srRA4lKTAuJnIZM8LkFcLLtqKNTjihcwb
E55CNdJJf2zvxuY5qSzN2L2Ev0dKzSHdjK0eU4WYQW2H1hUrMVu1mbECyAZ03ine
GqoD3hV8njJNfS/0J5XWjDln+7xssX/wrYEaRVnW0Kk6PcqJKXCaMkLTts9VonZk
Kpmd4QwFK+S34CSmFdtMnM0skHVeHGFyE7AGhjtnXz5x0EcUEbnh94yl/YZicdSp
X5AQiO3nND1yeHQfscEjodxDkGYV4c/vEKK0YZ3qkfqaFo/fRD3VpF5C2CIPTVPC
0iDvCZXTxMFCo9PKDyXy4Y5LYgHWL5NpxnegOZF8+beDHQ+6VBaLQJnwA5kHv9fb
tiByx45R8WLs411spUln/kgwqzE84fEjdRtqMlUWTuGMOC6PRFle+5gbEGYVhJqF
mbvhHlcG8imu8kuLAJI75mgq3Awekm/v8t9mWFsS/93JxopRjLzTk4rbbH+QeLIM
dA1Du2LMSX7YMCKKDDGz3gj8iqLiXqmOxbBnHALHe1YJcO+Cq4MoJ3ViY6YNVgfi
2BMvR8JX2xYBLsR8fScqEgVHU9hlafH5EuzEpDtn+c1St5Vu81ZTuo96sOi4EPUh
QwZ7FydpucTuoRwj1K0N
=A95j
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
