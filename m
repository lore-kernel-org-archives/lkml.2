Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab2EHV2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:28:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59816 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2EHV2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:28:38 -0400
Message-ID: <4FA99001.8080800@gmail.com>
Date: Tue, 08 May 2012 23:28:33 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix race condition in AFFS
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig6E0AB62795F55B7D28938F9B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6E0AB62795F55B7D28938F9B
Content-Type: multipart/mixed;
 boundary="------------070005000907060002030403"

This is a multi-part message in MIME format.
--------------070005000907060002030403
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

AFFS preallocates few blocks per inode as an optimisation. Unfortunately
there is a race condition and the same blocks ends up being allocated
for both data and metadata, metadata gets overwritten and so the file is
partially unreadable. Here is a fix.
Please indicate if this isn't the right place to submit this or my
previous fs-related patches.

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------070005000907060002030403
Content-Type: text/x-diff;
 name="affs-race.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="affs-race.diff"

=3D=3D=3D modified file 'affs.h'
--- affs.h	2012-05-07 16:42:19 +0000
+++ affs.h	2012-05-08 21:24:08 +0000
@@ -66,8 +66,11 @@ struct affs_inode_info {
 	struct buffer_head *i_ext_bh;		/* bh of last extended block */
 	loff_t	 mmu_private;
 	u32	 i_protect;			/* unused attribute bits */
+
 	u32	 i_lastalloc;			/* last allocated block */
 	int	 i_pa_cnt;			/* number of preallocated blocks */
+	struct mutex i_alloc;		        /* Protects last 2 fields. */
+
 	struct inode vfs_inode;
 };
=20

=3D=3D=3D modified file 'bitmap.c'
--- bitmap.c	2012-05-06 21:40:49 +0000
+++ bitmap.c	2012-05-08 21:24:08 +0000
@@ -151,12 +151,18 @@ affs_alloc_block(struct inode *inode, u3
=20
 	pr_debug("AFFS: balloc(inode=3D%lu,goal=3D%u): ", inode->i_ino, goal);
=20
+	mutex_lock(&AFFS_I (inode)->i_alloc);
+
 	if (AFFS_I(inode)->i_pa_cnt) {
-		pr_debug("%d\n", AFFS_I(inode)->i_lastalloc+1);
+		u32 ret;
 		AFFS_I(inode)->i_pa_cnt--;
-		return ++AFFS_I(inode)->i_lastalloc;
+		ret =3D ++AFFS_I(inode)->i_lastalloc;
+		mutex_unlock(&AFFS_I (inode)->i_alloc);
+		return ret;
 	}
=20
+	mutex_unlock(&AFFS_I (inode)->i_alloc);
+
 	if (!goal || goal > sbi->s_partition_size) {
 		if (goal)
 			affs_warning(sb, "affs_balloc", "invalid goal %d", goal);
@@ -230,16 +236,22 @@ find_bit:
 	bit =3D ffs(tmp & mask) - 1;
 	blk +=3D bit + sbi->s_reserved;
 	mask2 =3D mask =3D 1 << (bit & 31);
-	AFFS_I(inode)->i_lastalloc =3D blk;
=20
-	/* prealloc as much as possible within this word */
-	while ((mask2 <<=3D 1)) {
-		if (!(tmp & mask2))
-			break;
-		AFFS_I(inode)->i_pa_cnt++;
-		mask |=3D mask2;
+	mutex_lock(&AFFS_I (inode)->i_alloc);
+	if (!AFFS_I(inode)->i_pa_cnt) {
+		AFFS_I(inode)->i_lastalloc =3D blk;
+
+		/* prealloc as much as possible within this word */
+		while ((mask2 <<=3D 1)) {
+			if (!(tmp & mask2))
+				break;
+			AFFS_I(inode)->i_pa_cnt++;
+			mask |=3D mask2;
+		}
+		bm->bm_free -=3D AFFS_I(inode)->i_pa_cnt + 1;
 	}
-	bm->bm_free -=3D AFFS_I(inode)->i_pa_cnt + 1;
+
+	mutex_unlock(&AFFS_I (inode)->i_alloc);
=20
 	*data =3D cpu_to_be32(tmp & ~mask);
=20

=3D=3D=3D modified file 'file.c'
--- file.c	2012-05-06 21:40:49 +0000
+++ file.c	2012-05-08 21:24:08 +0000
@@ -795,12 +795,21 @@ void
 affs_free_prealloc(struct inode *inode)
 {
 	struct super_block *sb =3D inode->i_sb;
+	u32 first, cnt;
=20
 	pr_debug("AFFS: free_prealloc(ino=3D%lu)\n", inode->i_ino);
=20
-	while (AFFS_I(inode)->i_pa_cnt) {
-		AFFS_I(inode)->i_pa_cnt--;
-		affs_free_block(sb, ++AFFS_I(inode)->i_lastalloc);
+	mutex_lock(&AFFS_I (inode)->i_alloc);
+	first =3D AFFS_I(inode)->i_lastalloc;
+	cnt =3D AFFS_I(inode)->i_pa_cnt;
+	AFFS_I(inode)->i_lastalloc +=3D cnt;
+	AFFS_I(inode)->i_pa_cnt =3D 0;
+
+	mutex_unlock(&AFFS_I (inode)->i_alloc);
+
+	while (cnt) {
+		cnt--;
+		affs_free_block(sb, ++first);
 	}
 }
=20

=3D=3D=3D modified file 'inode.c'
--- inode.c	2012-05-07 16:23:07 +0000
+++ inode.c	2012-05-08 21:24:08 +0000
@@ -70,6 +70,7 @@ struct inode *affs_iget(struct super_blo
 	AFFS_I(inode)->mmu_private =3D 0;
 	AFFS_I(inode)->i_lastalloc =3D 0;
 	AFFS_I(inode)->i_pa_cnt =3D 0;
+	mutex_init(&AFFS_I (inode)->i_alloc);
=20
 	if (sbi->s_flags & SF_SETMODE)
 		inode->i_mode =3D sbi->s_mode;
@@ -326,6 +327,7 @@ affs_new_inode(struct inode *dir)
 	AFFS_I(inode)->i_pa_cnt =3D 0;
 	AFFS_I(inode)->i_extcnt =3D 1;
 	AFFS_I(inode)->i_ext_last =3D ~1;
+	mutex_init(&AFFS_I (inode)->i_alloc);
=20
 	insert_inode_hash(inode);
=20


--------------070005000907060002030403--

--------------enig6E0AB62795F55B7D28938F9B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+pkAEACgkQNak7dOguQgk3JAD7BlkTB8x8NXR31QSOGqEsaL7S
iusNEAQSyj0Fi8Ap6mIA/1CaD/epsD51SvsTX3uS9ZMxKSCmxykGVcd8VQvDQB56
=nZaQ
-----END PGP SIGNATURE-----

--------------enig6E0AB62795F55B7D28938F9B--
