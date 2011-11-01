Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab1KADKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 23:10:20 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:40677 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1KADKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 23:10:19 -0400
Date: Tue, 1 Nov 2011 14:10:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Prasad Joshi <prasadjoshi.linux@gmail.com>,
        =?UTF-8?B?IkrDtnJuIEVuZ2Vs?= =?UTF-8?B?Ig==?= <joern@logfs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josef Bacik <josef@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the logfs tree with Linus' tree
Message-Id: <20111101141000.3531dbfbf0490c6d3521d6b6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_14_10_00_+1100_7LzjNqVIugOtRnGS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_14_10_00_+1100_7LzjNqVIugOtRnGS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the logfs tree got a conflict in
fs/logfs/file.c between commit 02c24a82187d ("fs: push i_mutex and
filemap_write_and_wait down into ->fsync() handlers") from Linus' tree
and commit 39da12ef4bbe ("logfs: take write mutex lock during fsync and
sync") from the logfs tree.

I have no idea what needs to be done here.  I fixed it like below to make
it build, but a better fix is needed.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/logfs/file.c
index b548c87,f85d603..0000000
--- a/fs/logfs/file.c
+++ b/fs/logfs/file.c
@@@ -219,20 -219,13 +219,22 @@@ long logfs_ioctl(struct file *file, uns
  	}
  }
 =20
 -int logfs_fsync(struct file *file, int datasync)
 +int logfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
  {
  	struct super_block *sb =3D file->f_mapping->host->i_sb;
 +	struct inode *inode =3D file->f_mapping->host;
 +	int ret;
 +
 +	ret =3D filemap_write_and_wait_range(inode->i_mapping, start, end);
 +	if (ret)
 +		return ret;
 =20
 +	mutex_lock(&inode->i_mutex);
+ 	logfs_get_wblocks(sb, NULL, WF_LOCK);
  	logfs_write_anchor(sb);
+ 	logfs_put_wblocks(sb, NULL, WF_LOCK);
 +	mutex_unlock(&inode->i_mutex);
 +
  	return 0;
  }
 =20

--Signature=_Tue__1_Nov_2011_14_10_00_+1100_7LzjNqVIugOtRnGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr2MIAAoJEECxmPOUX5FE2GIP/0xPNlty3ICEwD5TxH/zSXiP
Dwy7ClqkZlLK+sBLMFmEhsHrn7JpKWFUNekpCWSQ9yuzUppd+2zKT4Y5kblBEau/
UEWcXHf2wiiumimoAkUvl8zSLaImCQCYw/91ruA2gdDj7lryR85AIZbEhftd5p6o
9F9Wa5YDIIF9Wj87ehiPoaipr0vjG48JQovNbgnLcQo/O/I0raDOXH8W+bszTpMX
fBGObsdzy18OoeHmFHXfBCLDwtjeO+18Y5K26qZGJrgLtbLAdNKB6ZYWPhP2IJK7
tdy5UFlJCFYH4ozhDvDmQcKKgu6uUaqccr/TSv7L+VZJWkbFLUk41qxVUzXvXMNF
wQqMkH1jig4r9KeMCwSLuUQkwv+Ivxo2vISbmXga34c1hcMEVdSDIcwO51297tWr
UzB/039gQt3Ozk9sduGTGUCIiFL+tKg3oIDlfiDsUXPtPUnRKfmW7sND2Ig5rccM
OvJXoagU1wFe4ZeRX9ItB2dxkp9bhdf/2H0XJET29mo0rNGxhHhBV3QQ/darKiE6
+N5SS2nTU61JaQ793ob6W3ySqT2dEzTZBMk5IypMQWlVlSCVyWb/z+RcqoNQ1H0X
spIjMGH+3Cxh92MrBwY/WtIFonAJ40yKPaw7yFeiQx3DjQRvNHmCMF7Wt+I4i2u4
NDKfoF1pZ0N4Ywy+fqQs
=3oHY
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_14_10_00_+1100_7LzjNqVIugOtRnGS--
