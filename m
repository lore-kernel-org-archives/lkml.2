Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2BCHFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:05:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56854 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab2BCHFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:05:20 -0500
Date: Fri, 3 Feb 2012 01:05:14 -0600
From: "'Tyler Hicks'" <tyhicks@canonical.com>
To: Li Wang <liwang@nudt.edu.cn>
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] eCryptfs: write optimization
Message-ID: <20120203070514.GA27331@boyd>
References: <527531938.27851@eyou.net>
 <527553462.07149@eyou.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <527553462.07149@eyou.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-01-26 13:04:34, Li Wang wrote:
> Hi,
>   The new version adds the code to handle short copy issue which may occu=
re
> in iov_iter_copy_from_user_atomic(). The idea is to let ecryptfs_write_en=
d() return zero,
> therefore, give iov_iter_fault_in_readable() a chance to handle the page =
fault=20
> for the current iovec, then restart the copy operation.

Hi Li - This approach looks like it will work. Thanks for reworking the
patch! I've been testing it and it seems to be holding up.

I'd like you to respin the patch one last time to fix up the commit
message. You've gotten several eCryptfs patches in now, and I expect
more from you in the future, so I'd like to be able to simply apply
your patches rather than having to fix up the commit message myself.

Keep in mind that the commit message should make sense to someone
reading the "git log" years from now. This particular message only makes
sense if someone looks at my review of v1 of this patch. You would want
to put this type of text underneath the --- separator below because that
text automatically gets stripped out when I used "git am" to apply your
patch.

Check out Documentation/SubmittingPatches for suggestions on writing
good commit messages.

>=20
> Cheers,
> Li Wang
>=20
> Signed-off-by: Li Wang <liwang@nudt.edu.cn>
>                Yunchuan Wen <wenyunchuan@kylinos.com.cn>

You always seem to list Yunchuan. You'll need another Signed-off-by: tag
on that line. Does Yunchuan help in the development of the patches or
just perform review? See Documentation/development-process/5.Posting to
identify the correct tag to use for either situation. Also, you may want
to cc Yunchuan on these patches.

Sorry to hold up this patch with "process" stuff, but getting the right
commit message is important. Thanks!

Tyler

>=20
> ---
> =20
> fs/ecryptfs/mmap.c |   12 ++++++++++--
> 1 files changed, 10 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
> index 6a44148..b3fa499 100644
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
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPK4cqAAoJENaSAD2qAscKB10P/ApPVvvW+j3tZ9gHIMrHBYoB
tTJa0hcQM3cOc7ZHiQCCXlbmgPpHnowSqQflym3GQ36xtpH+IJ8Pr1NAaKsxqEjo
BullTG5zHB6lGsnmLbtsBmq2FCBrAySGLThhoMgal7j0Mzp055WNFUlrAhHMU7N6
DVhGqC+MyppHGHUndAQ8hYosgtXtvXj/oR4V6ldbsg4COQU4JXEvElk2dQE9mkxZ
2E3z1kB6POLaLiaFX2y47E+tpPJU9GHT4Ilw9I//A/Ci1U9bSaTg+az94PQWT/pn
NwpURIF6smaNRE8lWW6Z9d/hcLUP0NESglSIAUbAvAh1GKaLt3O3M4Da9CXh5u4f
SlGZ/XmnluUnveoTIPKX/Ug49hIEPfQNEdGKvYGgv7Bq2M0guQy2MYsaJNVcfXZh
tbvLOx2FwJ/ctfFJm98Zx+K6LQk7eM1pTXeoneDjVEU4D/bVwZ3Ef6JO9NJYmoh2
KsZfXJo9r8+Fsvc+kau/75mhuMG9za7zdKFg0zXJKxVUcTwqK8Z8Z2PFsgZXs64Q
PseJUKDw8mZ73MAeSweM3LruDRwAjUaKZt6af+dqa15GdH+ytPK4p5csqfl7sZVW
VblkkmTeCwIbTPAEV1CuFaqXLUZP+IpTdN9F8dlbmm9UorNkO5ROHTxhimsBN3R7
MnKzFLEsHulvdw11tmoX
=0oH8
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
