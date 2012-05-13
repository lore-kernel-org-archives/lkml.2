Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2EMNot (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 09:44:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34281 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2EMNos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 09:44:48 -0400
Message-ID: <4FAFBAC1.20603@gmail.com>
Date: Sun, 13 May 2012 15:44:33 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <josef@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH v2] Fix AFFS race condition.
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigF34186AFEB0EAF991B2B2D91"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF34186AFEB0EAF991B2B2D91
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

AFFS code preallocates several blocks as an optimisation. Unfortunately
it's not protected by lock so the same blocks may end up allocated twice.=

Here is a fix.

Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 45a0ce4..fc1d4ca 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -66,6 +66,8 @@ struct affs_inode_info {
 	u32	 i_protect;			/* unused attribute bits */
 	u32	 i_lastalloc;			/* last allocated block */
 	int	 i_pa_cnt;			/* number of preallocated blocks */
+	spinlock_t i_alloc;		        /* Protects last 2 fields. */
+
 	struct inode vfs_inode;
 };
=20
diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index 3e26271..3341bde 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -151,12 +151,18 @@ affs_alloc_block(struct inode *inode, u32 goal)
=20
 	pr_debug("AFFS: balloc(inode=3D%lu,goal=3D%u): ", inode->i_ino, goal);
=20
+	spin_lock(&AFFS_I(inode)->i_alloc);
+
 	if (AFFS_I(inode)->i_pa_cnt) {
-		pr_debug("%d\n", AFFS_I(inode)->i_lastalloc+1);
+		u32 ret;
 		AFFS_I(inode)->i_pa_cnt--;
-		return ++AFFS_I(inode)->i_lastalloc;
+		ret =3D ++AFFS_I(inode)->i_lastalloc;
+		spin_unlock(&AFFS_I(inode)->i_alloc);
+		return ret;
 	}
=20
+	spin_unlock(&AFFS_I(inode)->i_alloc);
+
 	if (!goal || goal > sbi->s_partition_size) {
 		if (goal)
 			affs_warning(sb, "affs_balloc", "invalid goal %d", goal);
@@ -230,16 +236,22 @@ find_bit:
 	bit =3D ffs(tmp & mask) - 1;
 	blk +=3D bit + sbi->s_reserved;
 	mask2 =3D mask =3D 1 << (bit & 31);
-	AFFS_I(inode)->i_lastalloc =3D blk;
-
-	/* prealloc as much as possible within this word */
-	while ((mask2 <<=3D 1)) {
-		if (!(tmp & mask2))
-			break;
-		AFFS_I(inode)->i_pa_cnt++;
-		mask |=3D mask2;
+
+	spin_lock(&AFFS_I(inode)->i_alloc);
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
+	spin_unlock(&AFFS_I(inode)->i_alloc);
=20
 	*data =3D cpu_to_be32(tmp & ~mask);
=20
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 2f4c935..829e976 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
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
+	spin_lock(&AFFS_I(inode)->i_alloc);
+	first =3D AFFS_I(inode)->i_lastalloc;
+	cnt =3D AFFS_I(inode)->i_pa_cnt;
+	AFFS_I(inode)->i_lastalloc +=3D cnt;
+	AFFS_I(inode)->i_pa_cnt =3D 0;
+
+	spin_unlock(&AFFS_I(inode)->i_alloc);
+
+	while (cnt) {
+		cnt--;
+		affs_free_block(sb, ++first);
 	}
 }
=20
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 0782653..1df3c95 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -91,6 +91,7 @@ static struct inode *affs_alloc_inode(struct super_bloc=
k *sb)
 	i->i_lc =3D NULL;
 	i->i_ext_bh =3D NULL;
 	i->i_pa_cnt =3D 0;
+	spin_lock_init(&i->i_alloc);
=20
 	return &i->vfs_inode;
 }


--------------enigF34186AFEB0EAF991B2B2D91
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+vuswACgkQNak7dOguQglqowEAhNTC+5diy9GjwY01vOD8sPo/
yDKrZuCk8eJTqnHkkYIA/iEolGezERODBwgLlCmtJjaNM5TatgLKddyA1WTfw+5H
=JrEp
-----END PGP SIGNATURE-----

--------------enigF34186AFEB0EAF991B2B2D91--
