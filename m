Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab2ATTux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 14:50:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33500 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab2ATTup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 14:50:45 -0500
Date: Fri, 20 Jan 2012 13:50:41 -0600
From: Tyler Hicks <tyler.hicks@canonical.com>
To: tim.gardner@canonical.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, ecryptfs@vger.kernel.org
Subject: Re: [PATCH 1/2] ecryptfs: Improve metatdata read failure logging
Message-ID: <20120120195041.GC9156@boyd>
References: <1326301242-5817-1-git-send-email-tim.gardner@canonical.com>
 <1326301242-5817-2-git-send-email-tim.gardner@canonical.com>
 <20120112120044.GB4717@boyd>
 <4F0F0E10.1010107@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ALfTUftag+2gvp1h"
Content-Disposition: inline
In-Reply-To: <4F0F0E10.1010107@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-01-12 17:45:04, Tim Gardner wrote:
> On 01/12/2012 01:00 PM, Tyler Hicks wrote:
> >On 2012-01-11 18:00:41, Tim Gardner wrote:
> >>There are 3 read failure cases in ecryptfs_read_metadata(), but only 2
> >>of them are uniquely noted by kernel log messages. This patch
> >>identifies and logs each read failure case. It also correctly interprets
> >>a negative return value from ecryptfs_read_lower().
> >
> >I'm not sure that the negative return value was incorrectly interpreted.
> >See below.
> >
> >>
> >>Removes unnecessary variable initialization.
> >>
> >>Cc: linux-kernel@vger.kernel.org
> >>Cc: stable@vger.kernel.org
> >>Cc: Tyler Hicks<tyler.hicks@canonical.com>
> >>Signed-off-by: Tim Gardner<tim.gardner@canonical.com>
> >>---
> >>  fs/ecryptfs/crypto.c |   17 +++++++++++------
> >>  1 files changed, 11 insertions(+), 6 deletions(-)
> >>
> >>diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> >>index d3c8776..ac063bd 100644
> >>--- a/fs/ecryptfs/crypto.c
> >>+++ b/fs/ecryptfs/crypto.c
> >>@@ -1590,8 +1590,8 @@ int ecryptfs_read_and_validate_xattr_region(struc=
t dentry *dentry,
> >>   */
> >>  int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
> >>  {
> >>-	int rc =3D 0;
> >>-	char *page_virt =3D NULL;
> >>+	int rc;
> >>+	char *page_virt;
> >>  	struct inode *ecryptfs_inode =3D ecryptfs_dentry->d_inode;
> >>  	struct ecryptfs_crypt_stat *crypt_stat =3D
> >>  	&ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat;
> >>@@ -1611,10 +1611,15 @@ int ecryptfs_read_metadata(struct dentry *ecryp=
tfs_dentry)
> >>  	}
> >>  	rc =3D ecryptfs_read_lower(page_virt, 0, crypt_stat->extent_size,
> >>  				 ecryptfs_inode);
> >>-	if (rc>=3D 0)
> >>-		rc =3D ecryptfs_read_headers_virt(page_virt, crypt_stat,
> >>-						ecryptfs_dentry,
> >>-						ECRYPTFS_VALIDATE_HEADER_SIZE);
> >>+	if (rc<  0) {
> >>+		printk(KERN_ERR "%s: Could not read %u bytes\n",
> >>+			__func__, crypt_stat->extent_size);
> >>+		goto out;
> >>+	}
> >
> >This may break things a bit for users that use the
> >ecryptfs_xattr_metadata mount option (which stores the metadata in an
> >xattr, rather than the header of the file). A failure to read the lower
> >file here doesn't matter because the metadata is likely stored in an
> >xattr, which will be found with the ecryptfs_read_xattr_region() call
> >below.
> >
> >I've never liked that ecryptfs potentially looks in both the header and
> >the xattr for metadata, but that's how it has been since the very early
> >days of eCryptfs. I've wanted to change this but there is the potential
> >to break things for users who have a mixture of files with metadata in
> >the header and in the header.
> >
> >Maybe we just go whole hog for 3.3 and only look in either the header or
> >xattr for metadata, depending on whether or not ecryptfs_xattr_metadata
> >is used?
> >
> >I could live with that, but I would definitely not want something like
> >that to go to the stable kernel. Any thoughts?
> >
> >Tyler
> >
>=20
> I think you're right. Given the way the metadata checks are coded I
> think its impossible to disambiguate the 2 failure scenarios.
> However, its not really relevant that we know which one failed, only
> the inode of the metadata read that _did_ fail is important.
>=20
> How about this much simpler patch that is also suitable for stable ?
> Tested on 3.2.

Hey Tim - Sorry for the hiccup in response time. Comments below.

>=20
> rtg
> --=20
> Tim Gardner tim.gardner@canonical.com

> From 48f75c409ddc00caec88162f53c3155196b17854 Mon Sep 17 00:00:00 2001
> From: Tim Gardner <tim.gardner@canonical.com>
> Date: Thu, 12 Jan 2012 16:31:55 +0100
> Subject: [PATCH 1/1 V2] ecryptfs: Improve metadata read failure logging
>=20
> Print inode on metadata read failure. The only real
> way of dealing with metadata read failures is to delete
> the underlying file system file. Having the inode
> allows one to 'find . -inum INODE`.
>=20
> Cc: stable@vger.kernel.org
> Cc: Tyler Hicks <tyler.hicks@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  fs/ecryptfs/crypto.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> index d3c8776..326d6ab 100644
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

I doubt there is any issue with not initializing these variables in
the older, stable kernel releases, but I don't want to take the time to
verify that.

So, would you mind if I split this variable initialization part into a
separate patch not for stable? I can handle that on my end, if that's
alright with you.=20

The printk's below are safe and stable-worthy, IMO, because end-users
should really benefit from the changes.

Tyler

>  	struct inode *ecryptfs_inode =3D ecryptfs_dentry->d_inode;
>  	struct ecryptfs_crypt_stat *crypt_stat =3D
>  	    &ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat;
> @@ -1616,11 +1616,13 @@ int ecryptfs_read_metadata(struct dentry *ecryptf=
s_dentry)
>  						ecryptfs_dentry,
>  						ECRYPTFS_VALIDATE_HEADER_SIZE);
>  	if (rc) {
> +		/* metadata is not in the file header, so try xattrs */
>  		memset(page_virt, 0, PAGE_CACHE_SIZE);
>  		rc =3D ecryptfs_read_xattr_region(page_virt, ecryptfs_inode);
>  		if (rc) {
>  			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
> -			       "file header region or xattr region\n");
> +			       "file header region or xattr region, inode %lu\n",
> +				ecryptfs_inode->i_ino);
>  			rc =3D -EINVAL;
>  			goto out;
>  		}
> @@ -1629,7 +1631,8 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_=
dentry)
>  						ECRYPTFS_DONT_VALIDATE_HEADER_SIZE);
>  		if (rc) {
>  			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
> -			       "file xattr region either\n");
> +			       "file xattr region either, inode %lu\n",
> +				ecryptfs_inode->i_ino);
>  			rc =3D -EINVAL;
>  		}
>  		if (crypt_stat->mount_crypt_stat->flags
> @@ -1640,7 +1643,8 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_=
dentry)
>  			       "crypto metadata only in the extended attribute "
>  			       "region, but eCryptfs was mounted without "
>  			       "xattr support enabled. eCryptfs will not treat "
> -			       "this like an encrypted file.\n");
> +			       "this like an encrypted file, inode %lu\n",
> +				ecryptfs_inode->i_ino);
>  			rc =3D -EINVAL;
>  		}
>  	}
> --=20
> 1.7.8.3
>=20


--ALfTUftag+2gvp1h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPGcWRAAoJENaSAD2qAscKR6wP/1uLtrFGr8ETjtK5i1pqOx1U
Wh1A2xriEeMG5bROS1+ti8ykN/xcFhygmghI2BIqrQGAIv+QzF+dQh4C63NkWHuj
EowDjplhw+VTDlLO2+PQTZ/EXOOd6GuakGwKTHPot8Uumn5o5CV45IZXCd1NIIsP
Lb+meC88y+COTzmQcDZscrkEXJ0WgLtUZFJfw0oixTWtoM1plzvmFYfdxHMoQ2TZ
3rOvAF2c1VIPCRTRmgQtQPnAuxODr488+6M+Ez2i0mwcNg9hG3Mzvo+9gP8Te1lZ
PUhvtQm9yW07MiCl/3NO4SaqIBD2jgl/0KKyEp0xLHumfa5CUSPPXbxVZVZyQcbY
VWYqaFZNniJOM4IHxBPzHPCieO5Sf6wob2Cft9VYI2i2y05oTdKukw+DYt5lTorf
4ANSIQsrlXoaSoXBhbuDMzdbvfqvPDgf7GXfLCD8KtisipqqbiEkjYonmjmOeAdy
0BZvmfqZa10j574DXBcLyxLzaP4GincFAzvhDVIIwU8oS+/peD+ijjMx9ewTIHTS
R5Pt+ga+Q0pySwAjbv03uBSRaRmvpxXm9jtl7mrGnhZIPC84a/BVF7k8t57GndQb
+LrHLf6tU8RpiyfIWJHOq4DpFMimXuVzrgPxO3Cq1aR9PkaFEdh0rWLo1lXqsUKC
A5IqfRXqTaxIgwtd4+3T
=qmjN
-----END PGP SIGNATURE-----

--ALfTUftag+2gvp1h--
