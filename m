Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab2AYXFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 18:05:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51609 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab2AYXFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 18:05:50 -0500
Date: Wed, 25 Jan 2012 17:05:45 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Li Wang <liwang@nudt.edu.cn>
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] eCryptfs: write optimization
Message-ID: <20120125230545.GI16865@boyd>
References: <527503333.04197@eyou.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3CAnR4CLEnEWqRMR"
Content-Disposition: inline
In-Reply-To: <527503333.04197@eyou.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3CAnR4CLEnEWqRMR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-01-25 23:08:58, Li Wang wrote:
> Hi,
>   ecryptfs_write_begin() grabs a page from page cache for writing.=20
> If the page does not contain valid data, or the data are older than=20
> the counterpart on the disk, eCryptfs will read out the corresponding dat=
a=20
> from the disk into the eCryptfs page cache, decrypt them,=20
> then perform writing. However, for current page, if the length of=20
> the data to be written into is equal to page size, that means the whole=
=20
> page of data will be overwritten, in which case, it does not matter whate=
ver=20
> the data were before, it is beneficial to perform writing directly.
>=20
> This is useful while using eCryptfs in backup situation, user copies file
> out from eCryptfs folder, modifies, and copies the revised file back to
> replace the original one.=20
>=20
> With this optimization, according to our test, iozone 'write' operation o=
n an existing=20
> file with write size being multiple of page size will enjoy a steady 3x s=
peedup.

I've coded this same optimization up once before and did see the nice
performance boost it provides.

What stopped me from committing it is that I noticed a short copy is
possible during the iov_iter_copy_from_user_atomic() call in
generic_perform_write().

I didn't ever follow up to figure out the best way to handle the short
copy in ecryptfs_write_end() and then forgot about it all. :/

How do you propose that case be handled? I suppose we could *detect* it
by not marking the page uptodate in ecryptfs_write_begin() and then if
ecryptfs_write_end() sees a non-uptodate page and len is less than
PAGE_CACHE_SIZE, we would know a short copy happened. But I'm not sure
what the acceptable options are to *handle* that case. Just return an
error? Try to fill the page in ecryptfs_write_end() (ugly, IMO)?

Adding linux-fsdevel for suggestions, since I assume other filesystems
may be doing this.

Tyler

>=20
> Signed-off-by: Li Wang <liwang@nudt.edu.cn>
> 		Yunchuan Wen <wenyunchuan@kylinos.com.cn>
>=20
> ---
>=20
>  fs/ecryptfs/mmap.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
> index 6a44148..9724ef2 100644
> --- a/fs/ecryptfs/mmap.c
> +++ b/fs/ecryptfs/mmap.c
> @@ -346,7 +346,8 @@ static int ecryptfs_write_begin(struct file *file,
>  			if (prev_page_end_size
>  			    >=3D i_size_read(page->mapping->host)) {
>  				zero_user(page, 0, PAGE_CACHE_SIZE);
> -			} else {
> +				SetPageUptodate(page);
> +			} else if (len < PAGE_CACHE_SIZE) {
>  				rc =3D ecryptfs_decrypt_page(page);
>  				if (rc) {
>  					printk(KERN_ERR "%s: Error decrypting "
> @@ -356,8 +357,8 @@ static int ecryptfs_write_begin(struct file *file,
>  					ClearPageUptodate(page);
>  					goto out;
>  				}
> +				SetPageUptodate(page);
>  			}
> -			SetPageUptodate(page);
>  		}
>  	}
>  	/* If creating a page or more of holes, zero them out via truncate. =20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--3CAnR4CLEnEWqRMR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPIIrJAAoJENaSAD2qAscK4xkP/i+2Wr9/I2p0SKF+7w8nzJ3i
T1iogUqN0SEnkQsgg5cSrRlV4YxG9vR9bJK7HUysra9HxoyrU+UGjAyfrOIs9MDk
u+HVvslZKEBsftQPWvAoWgBnwr36CYumEykYyn2FyrLAcxgg7DQ/6g5B+9TqLoAR
5FNqad/UnFmNTB3WD/eMI98dWV3rGErm8svU6YsrZcjoMj0hReKbdDrK8dPWskVC
jlBvSjApQFFYbyLZPZnFcJX7VqSBSr9kczbIy91LXZUtqJQaueQIhI3kWstaseLV
Le2CxKF34lFjcPVZ9IvCbpsWlxU48IzcpkXrMwX+wl4ZstmEaWMZYjAkHd00C1FO
RoBnmn37YIE1FxNfRo3qtVBLHwFxuIcgY1zSUtMSPykQfnvLfXBHiYUjw5LDXeRi
huGvqYfTJBHATunEfaewNq1VwD0Jwsq9TMgdl8tubsLUw9hI9zxqG7Bha1aP/tbP
jVBh/ArTpgKiOu5CTj31OIOeWxLvz8cQcpQJ+wivEq/lCe9r9Fd8/iIUrUH3yJUl
E+wVKuuZbf5HGFA9az1nyq4BxvPscrDrtUFY6VBdT2CsdF4rerpvSvl68hPTos0b
PHCnH6QFHP+evrflANsQzLGWky6aVrYkbxlFQlqc/4fgRvOO9TffgKtHdN9UoHYJ
K3FGFyp7DS8vGvlg4hh6
=/oYB
-----END PGP SIGNATURE-----

--3CAnR4CLEnEWqRMR--
