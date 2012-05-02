Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab2EBQec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 12:34:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33436 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab2EBQeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 12:34:31 -0400
Message-ID: <4FA1620A.3040700@gmail.com>
Date: Wed, 02 May 2012 18:34:18 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] UFS i_blocks handling
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig233712449CA86577FE9326A9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig233712449CA86577FE9326A9
Content-Type: multipart/mixed;
 boundary="------------090401060109080302090603"

This is a multi-part message in MIME format.
--------------090401060109080302090603
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Current UFS code doesn't maintain i_blocks. It creates 2 glitches:
1) state always says that no blocks are allocated
2) long symlinks are corrupted.
For (2) in GRUB there is a workaround to check whether link is a fast
link based on its length (link is considered a fast one if its size is
small to fit in inline space and i_blocks =3D=3D 0) however neither Linux=

nor BSD-using OS have such workaround and this should be fixed anyway.
Please consider attached patch. It may be of bad quality, I haven't
learned the code in question in more details.
Please CC me when answering.

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------090401060109080302090603
Content-Type: text/x-diff;
 name="ufs.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="ufs.diff"

diff -ur linux-source-3.2/fs/ufs/balloc.c /home/phcoder/projects/ufs/ball=
oc.c
--- linux-source-3.2/fs/ufs/balloc.c	2012-04-23 00:31:32.000000000 +0200
+++ /home/phcoder/projects/ufs/balloc.c	2012-05-02 18:24:25.444822068 +02=
00
@@ -147,6 +147,8 @@
=20
 	UFSD("ENTER, fragment %llu, count %u\n",
 	     (unsigned long long)fragment, count);
+
+	inode->i_blocks -=3D count;
 =09
 	if ((fragment & uspi->s_fpbmask) || (count & uspi->s_fpbmask)) {
 		ufs_error (sb, "ufs_free_blocks", "internal error, "
@@ -423,6 +425,7 @@
 		if (result) {
 			ufs_cpu_to_data_ptr(sb, p, result);
 			*err =3D 0;
+			inode->i_blocks +=3D count;
 			UFS_I(inode)->i_lastfrag =3D
 				max(UFS_I(inode)->i_lastfrag, fragment + count);
 			ufs_clear_frags(inode, result + oldcount,

--------------090401060109080302090603--

--------------enig233712449CA86577FE9326A9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+hYhAACgkQNak7dOguQgnV2AD8Ceq8+Tsb6ZrBSJP1aRkcO+F5
pgWAjlNKbFouYNwO6wgBAL7rYxlCrl545KUo4oty496sH4AtvFj/v7S5+d/I92Qf
=kfrF
-----END PGP SIGNATURE-----

--------------enig233712449CA86577FE9326A9--
