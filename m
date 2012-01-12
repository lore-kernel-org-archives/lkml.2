Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2ALMAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 07:00:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58262 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab2ALMAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 07:00:48 -0500
Date: Thu, 12 Jan 2012 13:00:45 +0100
From: Tyler Hicks <tyler.hicks@canonical.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, ecryptfs@vger.kernel.org
Subject: Re: [PATCH 1/2] ecryptfs: Improve metatdata read failure logging
Message-ID: <20120112120044.GB4717@boyd>
References: <1326301242-5817-1-git-send-email-tim.gardner@canonical.com>
 <1326301242-5817-2-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <1326301242-5817-2-git-send-email-tim.gardner@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-01-11 18:00:41, Tim Gardner wrote:
> There are 3 read failure cases in ecryptfs_read_metadata(), but only 2
> of them are uniquely noted by kernel log messages. This patch
> identifies and logs each read failure case. It also correctly interprets
> a negative return value from ecryptfs_read_lower().

I'm not sure that the negative return value was incorrectly interpreted.
See below.

>=20
> Removes unnecessary variable initialization.
>=20
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: Tyler Hicks <tyler.hicks@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  fs/ecryptfs/crypto.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> index d3c8776..ac063bd 100644
> --- a/fs/ecryptfs/crypto.c
> +++ b/fs/ecryptfs/crypto.c
> @@ -1590,8 +1590,8 @@ int ecryptfs_read_and_validate_xattr_region(struct =
dentry *dentry,
>   */
>  int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
>  {
> -	int rc =3D 0;
> -	char *page_virt =3D NULL;
> +	int rc;
> +	char *page_virt;
>  	struct inode *ecryptfs_inode =3D ecryptfs_dentry->d_inode;
>  	struct ecryptfs_crypt_stat *crypt_stat =3D
>  	    &ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat;
> @@ -1611,10 +1611,15 @@ int ecryptfs_read_metadata(struct dentry *ecryptf=
s_dentry)
>  	}
>  	rc =3D ecryptfs_read_lower(page_virt, 0, crypt_stat->extent_size,
>  				 ecryptfs_inode);
> -	if (rc >=3D 0)
> -		rc =3D ecryptfs_read_headers_virt(page_virt, crypt_stat,
> -						ecryptfs_dentry,
> -						ECRYPTFS_VALIDATE_HEADER_SIZE);
> +	if (rc < 0) {
> +		printk(KERN_ERR "%s: Could not read %u bytes\n",
> +			__func__, crypt_stat->extent_size);
> +		goto out;
> +	}

This may break things a bit for users that use the
ecryptfs_xattr_metadata mount option (which stores the metadata in an
xattr, rather than the header of the file). A failure to read the lower
file here doesn't matter because the metadata is likely stored in an
xattr, which will be found with the ecryptfs_read_xattr_region() call
below.

I've never liked that ecryptfs potentially looks in both the header and
the xattr for metadata, but that's how it has been since the very early
days of eCryptfs. I've wanted to change this but there is the potential
to break things for users who have a mixture of files with metadata in
the header and in the header.

Maybe we just go whole hog for 3.3 and only look in either the header or
xattr for metadata, depending on whether or not ecryptfs_xattr_metadata
is used?

I could live with that, but I would definitely not want something like
that to go to the stable kernel. Any thoughts?

Tyler

> +
> +	rc =3D ecryptfs_read_headers_virt(page_virt, crypt_stat,
> +					ecryptfs_dentry,
> +					ECRYPTFS_VALIDATE_HEADER_SIZE);
>  	if (rc) {
>  		memset(page_virt, 0, PAGE_CACHE_SIZE);
>  		rc =3D ecryptfs_read_xattr_region(page_virt, ecryptfs_inode);
> --=20
> 1.7.8.3
>=20

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPDstsAAoJENaSAD2qAscKmEAP/0bMm8SIiI14k5S+DaoYljLV
Uv3wg2coBpa71aSbFJeK7ZY7vRQJl3zQuZ8u5OFkhSf/l5Bk/EM2dOhLJTuWhSCb
uv9B0Smv04YM/wAywea+s/vfiTPqPM6Vnbwxg9LlN3bx+OoZx0WaFZWc+Fatl5g4
SD+22hZLT+SVORvc/bxf778WvJ5ypxjGV+moQ87v9tTqrRWgw3cKHBi8WEY/dauG
Mtpnu2kk3AjvWl4adTGBHyc1kRpWwV4h52B1qbamm4NheMIUM1t1UeQexX6XpT5T
QZT9Jwqq2FYPDGnI9O4iRQ7sGhqtLWh9cUtZzOj/s6cEvUoa63K1RBMaxrnT70Yi
cOPcfUR6egl+BAuTzItco3KHsq2j5sqfc8ui+mkiKOF2bbky5T9ZyqLn5Gl3K+C7
meqygxvMhzLLb1IwZAo3km0vO5ZmRGTQLbAaF5KTbXA5PMOC9HaFcUa1wuhtu+1y
7wXwyzQz+HHUtFHdbfEmRyqJzM3qQe2LSQsalsShco8qYM8Q5i5MUTw/aiULCaxN
RknDL2A7x1uGeGkNyeIKetPTXhRUjGQFXmAQWUmhARyRYE01PKqj9FuYzYhhPbsl
0ejFDK2bDLF2F79ZvbGprU1pJhqbi7rjyQh8CCg6/6cd5QTh+fxbUdiirEiRVThN
aoLQ5chMRFOD4RjMrQwq
=wEBl
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
