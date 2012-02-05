Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab2BESnf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 13:43:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35439 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab2BESnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 13:43:33 -0500
Date: Sun, 5 Feb 2012 12:43:14 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Li Wang <liwang@nudt.edu.cn>
Cc: ecryptfs@vger.kernel.org, wenyunchuan@kylinos.com.cn,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] eCryptfs: Write optimization for non-uptodate page
Message-ID: <20120205184313.GA4020@boyd>
References: <000801cce41b$927ae800$b770b800$@edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <000801cce41b$927ae800$b770b800$@edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-02-05 23:33:51, Li Wang wrote:
> ecryptfs_write_begin() grabs a page from page cache for writing.=20
> If the page does not contain valid data, or the data are older than=20
> the counterpart on the disk, eCryptfs will read out the corresponding dat=
a=20
> from the disk into the eCryptfs page cache, decrypt them,=20
> then perform writing. However, for current page, if the length of=20
> the data to be written into is equal to page size, that means the whole=
=20
> page of data will be overwritten, in which case, it does not matter whate=
ver
>=20
> the data were before, it is beneficial to perform writing directly.
>=20
> This is especially useful while using eCryptfs in backup situation, user
> copies file
> out from eCryptfs folder, modifies, and copies the revised file back to
> replace the original one.=20
>=20
> With this optimization, according to our test on a machine with IntelR Co=
re
> T 2 Duo processor,=20
> iozone 'write' operation on an existing file with write size being multip=
le
> of page size will=20
> enjoy a steady 3x speedup.

Looks like your email client is incorrectly wrapping some lines.

>=20
> Signed-off-by: Li Wang <liwang@nudt.edu.cn>
> Signed-off-by: Yunchuan Wen <wenyunchuan@kylinos.com.cn>
> Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
>=20
> ---=20
>=20
> Changes from v1:
>=20
> The new version adds the code to handle short copy issue which may occure
> in iov_iter_copy_from_user_atomic(). The idea is to let ecryptfs_write_en=
d()
> return zero,
> in order to give iov_iter_fault_in_readable() a chance to handle the page
> fault=20
> for the current iovec, then restart the copy operation.
>=20
>  fs/ecryptfs/mmap.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
> index 10ec695..c6f665e 100644
> --- a/fs/ecryptfs/mmap.c
> +++ b/fs/ecryptfs/mmap.c
> @@ -350,7 +350,8 @@ static int ecryptfs_write_begin(struct file *file,
>  			if (prev_page_end_size
>  			    >=3D i_size_read(page->mapping->host)) {
>  				zero_user(page, 0, PAGE_CACHE_SIZE);
> -			} else {
> +				SetPageUptodate(page);
> +			} else if (len < PAGE_CACHE_SIZE) {
>  				rc =3D ecryptfs_decrypt_page(page);
>  				if (rc) {
>  					printk(KERN_ERR "%s: Error
> decrypting "

The patch didn't even apply because of this bad line wrap.

Looks like you've still got mail client issues, but I went ahead and
fixed everything up on my end. I just ask that you get these issues
straightened out soon. `git send-email` is a great way to send patches.
Give it a try.

I really appreciate you taking the time to fix up the commit message!

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git#next

BTW, since this isn't a bug fix, it will live in -next until the 3.4
merge window.

Tyler

> @@ -360,8 +361,8 @@ static int ecryptfs_write_begin(struct file *file,
>  					ClearPageUptodate(page);
>  					goto out;
>  				}
> +				SetPageUptodate(page);
>  			}
> -			SetPageUptodate(page);
>  		}
>  	}
>  	/* If creating a page or more of holes, zero them out via truncate.
> @@ -512,6 +513,13 @@ static int ecryptfs_write_end(struct file *file,
>  		}
>  		goto out;
>  	}
> +	if (!PageUptodate(page)) {
> +		if (copied < PAGE_CACHE_SIZE) {
> +			rc =3D 0;
> +			goto out;
> +		}
> +		SetPageUptodate(page);
> +	}
>  	/* Fills in zeros if 'to' goes beyond inode size */
>  	rc =3D fill_zeros_to_end_of_page(page, to);
>  	if (rc) {
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPLs3BAAoJENaSAD2qAscKDqEQAKzjJzyeBer9jxPVa3Drbgoi
Y0bSadimLwRP9/i45rR1OUG685ucig1PwPtplOgeSqCIJEidiQHsKbplL+itiXjY
GReKo1b6cm8xM8P2WINyf5XnMTxdlFU5xDp5CjKXK6bkQys4TGyB/2D+6Cx0VJ2x
0T1vh0srPP2+Hn8aW0VzfKaSu45rOKp4oHDVZ+0HIPmXOCWUamjw03AYQeIBnPm+
wVT7B3S4R2zN5jvZ/wL0VQtyfIiybtdKgcxnWvjm0aN2vsU4dNw8FEOBu4OmGUX0
3S24ao+j+ABixio0qadtOY2DTpuDeslCyzU9lnpavDsAGPwmdbIX+LEQPu0ZP26d
VGOxWSsekeclTX592Er3u9bBYAa7513oXiHIsxomsMYOqOuLQXP/+TLXCXq+e+Y9
AD5v2ghd1h3F32i0JTKupy7MLN/obZStCU/mswQMCOPaVyGqzrPB61CvWMrgIU6U
+IZrSoBI4mpgJnfBD6Of6UjQ0WJtlQsDxWpKeCEUF4NTCC9Qhnz0gBGqPFtLhvNa
jZ8+ynRprIY1rkI1nxtSEDlMXUSncDFxU8PMkBWxmjMROcPk2VANdD3t5Pgn4nhu
Q7+9mnoQeKXP1cE9/X4co9+QwMwgt3rT2s8e1gHwgOB2XmqBPRQgkUHuveam0tIw
bQQSzAw1lZD9n10zt8bm
=QEFQ
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
