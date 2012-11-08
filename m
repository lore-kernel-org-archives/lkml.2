Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab2KHFK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 00:10:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56292 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab2KHFKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 00:10:54 -0500
Date: Wed, 7 Nov 2012 21:10:47 -0800
From: Tyler Hicks <tyhicks@canonical.com>
To: Li Wang <wangli@kylinos.com.cn>
Cc: Dustin Kirkland <dustin.kirkland@gazzang.com>, ecryptfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yunchuan Wen <wenyunchuan@kylinos.com.cn>
Subject: Re: [PATCH] eCryptfs: Avoid unnecessary disk read and data
 decryption during writing
Message-ID: <20121108051046.GB3403@boyd>
References: <1351597960-1503-1-git-send-email-wangli@kylinos.com.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <1351597960-1503-1-git-send-email-wangli@kylinos.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-10-30 19:52:40, Li Wang wrote:
> ecryptfs_write_begin grabs a page from page cache for writing.
> If the page contains invalid data, or data older than the
> counterpart on the disk, eCryptfs will read out the
> corresponing data from the disk into the page, decrypt them,
> then perform writing. However, for this page, if the length
> of the data to be written into is equal to page size,
> that means the whole page of data will be overwritten,
> in which case, it does not matter whatever the data were before,
> it is beneficial to perform writing directly rather than bothering
> to read and decrypt first.
>=20
> With this optimization, according to our test on a machine with
> Intel Core 2 Duo processor, iozone 'write' operation on an existing
> file with write size being multiple of page size will enjoy a steady
> 3x speedup.
>=20
> Signed-off-by: Li Wang <wangli@kylinos.com.cn>
> Signed-off-by: Yunchuan Wen <wenyunchuan@kylinos.com.cn>
> Reviewed-by: Tyler Hicks <tyhicks@canonical.com>

Thanks again, Li. I've pushed this to my next branch.

I lost track of it last time. Sorry about that!

Tyler

> ---
>  fs/ecryptfs/mmap.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
> index bd1d57f..564a1fa 100644
> --- a/fs/ecryptfs/mmap.c
> +++ b/fs/ecryptfs/mmap.c
> @@ -338,7 +338,8 @@ static int ecryptfs_write_begin(struct file *file,
>  			if (prev_page_end_size
>  			    >=3D i_size_read(page->mapping->host)) {
>  				zero_user(page, 0, PAGE_CACHE_SIZE);
> -			} else {
> +				SetPageUptodate(page);
> +			} else if (len < PAGE_CACHE_SIZE) {
>  				rc =3D ecryptfs_decrypt_page(page);
>  				if (rc) {
>  					printk(KERN_ERR "%s: Error decrypting "
> @@ -348,8 +349,8 @@ static int ecryptfs_write_begin(struct file *file,
>  					ClearPageUptodate(page);
>  					goto out;
>  				}
> +				SetPageUptodate(page);
>  			}
> -			SetPageUptodate(page);
>  		}
>  	}
>  	/* If creating a page or more of holes, zero them out via truncate.
> @@ -499,6 +500,13 @@ static int ecryptfs_write_end(struct file *file,
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
> --=20
> 1.7.6.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJQmz7WAAoJENaSAD2qAscKke8QALx/6EVtCgMM5KAh3iuEByY+
EAK7Je5jUD/hg1lCwyFuOodf1YTAf3ZN3O5PNsc8GKv1lQl/Q634aISUeWaJiSNd
KyvxCy8idfwBh91uC0cb7w9hIDLpUCwQ0xJVJaI3KuNb4NHmSJ7JYXVFzuml74iw
PAGCRX/A7VAd+iZUIAz4PVqvnEvNEj9QJyE7OMsnAFraSwo7XJNecD3nwVv5xT5C
7gjs+/i1Q5ePHx02DGsEgkPAZiiVATq1pyC8pS5EMBKLvkdAudhGib3F0EtQFu7k
fwQm+GA8+o7ZULSd6uYUdWTp4Mw0vzJIOuVNBPUVnaFR06dnwYB7YL3ecULVyBbv
e6REnV/lHNO4GC+VV8R/xmWlT4xOzf/qF8+quLUC762fv2mLOJAz67g+sKcPN30H
5YQsF7XsUO3+bi9H/vVMmBRLpecH9MPwmcwlgZTWfAjde0aYOlY1cogY+wLusKVY
lQaoXbBy192o8nUz4VsGJl+q9qT35I3YsoOZztkxX0ScdtQQHNhh9iSbNa/w4XaT
nzh4GUlweQzgnJ9iJDiTjxdCX/AhMmAtpdZ/IxYUeaeJis783DNDtIvlAvpoOI/Z
sFg5u2UCF4CCa8CeEPTbMWOeWOVVx5IdWDIriUBh7G9d6yrdYfoGCqu7qyPHGF3C
y1LrD8p8vz2sEVkUkP3e
=rhpf
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
