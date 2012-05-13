Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab2EMNwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 09:52:51 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40996 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2EMNwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 09:52:49 -0400
Message-ID: <4FAFBCAE.1050401@gmail.com>
Date: Sun, 13 May 2012 15:52:46 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
CC: Evgeniy Dushistov <dushistov@mail.ru>
Subject: [PATCH] update i_blocks on UFS
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig0E5D073ABDF777CB149B1D92"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0E5D073ABDF777CB149B1D92
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

UFS code dosn't update i_blocks which leads to the problems ranging from =
wrong
stat/du to long symlinks (as opposed to inline ones) being damaged. This =
is
a fix.

Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 42694e1..6f7c6ea 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -34,7 +34,8 @@ static void ufs_clusteracct(struct super_block *, struc=
t ufs_cg_private_info *,
 /*
  * Free 'count' fragments from fragment number 'fragment'
  */
-void ufs_free_fragments(struct inode *inode, u64 fragment, unsigned coun=
t)
+void ufs_free_fragments(struct inode *inode, u64 fragment, unsigned coun=
t,
+			int account)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
@@ -111,7 +112,10 @@ void ufs_free_fragments(struct inode *inode, u64 fra=
gment, unsigned count)
 			fs32_add(sb, &ubh_cg_blktot(ucpi, cylno), 1);
 		}
 	}
-=09
+
+	if (account)
+		inode->i_blocks -=3D (u64) count * (u64) (sb->s_blocksize >> 9);
+
 	ubh_mark_buffer_dirty (USPI_UBH(uspi));
 	ubh_mark_buffer_dirty (UCPI_UBH(ucpi));
 	if (sb->s_flags & MS_SYNCHRONOUS)
@@ -131,7 +135,8 @@ failed:
 /*
  * Free 'count' fragments from fragment number 'fragment' (free whole bl=
ocks)
  */
-void ufs_free_blocks(struct inode *inode, u64 fragment, unsigned count)
+void ufs_free_blocks(struct inode *inode, u64 fragment, unsigned count,
+	int account)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
@@ -140,6 +145,7 @@ void ufs_free_blocks(struct inode *inode, u64 fragmen=
t, unsigned count)
 	struct ufs_cylinder_group * ucg;
 	unsigned overflow, cgno, bit, end_bit, i;
 	u64 blkno;
+	unsigned free_count =3D account ? count : 0;
 =09
 	sb =3D inode->i_sb;
 	uspi =3D UFS_SB(sb)->s_uspi;
@@ -214,6 +220,8 @@ do_more:
 		goto do_more;
 	}
=20
+	inode->i_blocks -=3D (u64) free_count * (u64) (sb->s_blocksize >> 9);
+
 	sb->s_dirt =3D 1;
 	unlock_super (sb);
 	UFSD("EXIT\n");
@@ -343,8 +351,8 @@ static void ufs_clear_frags(struct inode *inode, sect=
or_t beg, unsigned int n,
 }
=20
 u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
-			   u64 goal, unsigned count, int *err,
-			   struct page *locked_page)
+		      u64 goal, unsigned count, int *err,
+		      struct page *locked_page, int account)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
@@ -425,6 +433,10 @@ u64 ufs_new_fragments(struct inode *inode, void *p, =
u64 fragment,
 			*err =3D 0;
 			UFS_I(inode)->i_lastfrag =3D
 				max(UFS_I(inode)->i_lastfrag, fragment + count);
+			if (account)
+				inode->i_blocks +=3D (u64) count
+				  * (u64) (sb->s_blocksize >> 9);
+
 			ufs_clear_frags(inode, result + oldcount,
 					newcount - oldcount, locked_page !=3D NULL);
 		}
@@ -441,6 +453,9 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u=
64 fragment,
 		*err =3D 0;
 		UFS_I(inode)->i_lastfrag =3D max(UFS_I(inode)->i_lastfrag,
 						fragment + count);
+		if (account)
+			inode->i_blocks +=3D (u64) count
+			  * (u64) (sb->s_blocksize >> 9);
 		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
 				locked_page !=3D NULL);
 		unlock_super(sb);
@@ -481,10 +496,15 @@ u64 ufs_new_fragments(struct inode *inode, void *p,=
 u64 fragment,
 		*err =3D 0;
 		UFS_I(inode)->i_lastfrag =3D max(UFS_I(inode)->i_lastfrag,
 						fragment + count);
+		if (account)
+			inode->i_blocks +=3D (u64) count
+			  * (u64) (sb->s_blocksize >> 9);
+
 		unlock_super(sb);
 		if (newcount < request)
-			ufs_free_fragments (inode, result + newcount, request - newcount);
-		ufs_free_fragments (inode, tmp, oldcount);
+			ufs_free_fragments(inode, result + newcount,
+					   request - newcount, 0);
+		ufs_free_fragments(inode, tmp, oldcount, 0);
 		UFSD("EXIT, result %llu\n", (unsigned long long)result);
 		return result;
 	}
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 7cdd395..4d75897 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -172,7 +172,8 @@ out:
 static struct buffer_head *
 ufs_inode_getfrag(struct inode *inode, u64 fragment,
 		  sector_t new_fragment, unsigned int required, int *err,
-		  long *phys, int *new, struct page *locked_page)
+		  long *phys, int *new, struct page *locked_page,
+		  int account)
 {
 	struct ufs_inode_info *ufsi =3D UFS_I(inode);
 	struct super_block *sb =3D inode->i_sb;
@@ -231,7 +232,7 @@ repeat:
 			tmp =3D ufs_new_fragments(inode, p2, lastfrag,
 						ufs_data_ptr_to_cpu(sb, p2),
 						uspi->s_fpb - lastblockoff,
-						err, locked_page);
+						err, locked_page, account);
 			if (!tmp) {
 				if (lastfrag !=3D ufsi->i_lastfrag)
 					goto repeat;
@@ -249,7 +250,8 @@ repeat:
 		tmp =3D ufs_new_fragments (inode, p, fragment - blockoff,=20
 					 goal, required + blockoff,
 					 err,
-					 phys !=3D NULL ? locked_page : NULL);
+					 phys !=3D NULL ? locked_page : NULL,
+					 account);
 	} else if (lastblock =3D=3D block) {
 	/*
 	 * We will extend last allocated block
@@ -258,7 +260,8 @@ repeat:
 					(blockoff - lastblockoff),
 					ufs_data_ptr_to_cpu(sb, p),
 					required +  (blockoff - lastblockoff),
-					err, phys !=3D NULL ? locked_page : NULL);
+					err, phys !=3D NULL ? locked_page : NULL,
+					account);
 	} else /* (lastblock > block) */ {
 	/*
 	 * We will allocate new block before last allocated block
@@ -271,7 +274,8 @@ repeat:
 		}
 		tmp =3D ufs_new_fragments(inode, p, fragment - blockoff,
 					goal, uspi->s_fpb, err,
-					phys !=3D NULL ? locked_page : NULL);
+					phys !=3D NULL ? locked_page : NULL,
+					account);
 	}
 	if (!tmp) {
 		if ((!blockoff && ufs_data_ptr_to_cpu(sb, p)) ||
@@ -328,8 +332,9 @@ repeat2:
  */
 static struct buffer_head *
 ufs_inode_getblock(struct inode *inode, struct buffer_head *bh,
-		  u64 fragment, sector_t new_fragment, int *err,
-		  long *phys, int *new, struct page *locked_page)
+		   u64 fragment, sector_t new_fragment, int *err,
+		   long *phys, int *new, struct page *locked_page,
+		   int account)
 {
 	struct super_block *sb =3D inode->i_sb;
 	struct ufs_sb_private_info *uspi =3D UFS_SB(sb)->s_uspi;
@@ -380,7 +385,7 @@ repeat:
 	else
 		goal =3D bh->b_blocknr + uspi->s_fpb;
 	tmp =3D ufs_new_fragments(inode, p, ufs_blknum(new_fragment), goal,
-				uspi->s_fpb, err, locked_page);
+				uspi->s_fpb, err, locked_page, account);
 	if (!tmp) {
 		if (ufs_data_ptr_to_cpu(sb, p))
 			goto repeat;
@@ -456,16 +461,16 @@ int ufs_getfrag_block(struct inode *inode, sector_t=
 fragment, struct buffer_head
 	 */
 #define GET_INODE_DATABLOCK(x) \
 	ufs_inode_getfrag(inode, x, fragment, 1, &err, &phys, &new,\
-			  bh_result->b_page)
+			  bh_result->b_page, 1)
 #define GET_INODE_PTR(x) \
 	ufs_inode_getfrag(inode, x, fragment, uspi->s_fpb, &err, NULL, NULL,\
-			  bh_result->b_page)
+			  bh_result->b_page, 0)
 #define GET_INDIRECT_DATABLOCK(x) \
 	ufs_inode_getblock(inode, bh, x, fragment,	\
-			  &err, &phys, &new, bh_result->b_page)
+			   &err, &phys, &new, bh_result->b_page, 1)
 #define GET_INDIRECT_PTR(x) \
 	ufs_inode_getblock(inode, bh, x, fragment,	\
-			  &err, NULL, NULL, NULL)
+			   &err, NULL, NULL, NULL, 0)
=20
 	if (ptr < UFS_NDIR_FRAGMENT) {
 		bh =3D GET_INODE_DATABLOCK(ptr);
diff --git a/fs/ufs/truncate.c b/fs/ufs/truncate.c
index f04f89f..cb9f06c 100644
--- a/fs/ufs/truncate.c
+++ b/fs/ufs/truncate.c
@@ -115,7 +115,8 @@ static int ufs_trunc_direct(struct inode *inode)
 	frag2 -=3D frag1;
 	frag1 =3D ufs_fragnum (frag1);
=20
-	ufs_free_fragments(inode, tmp + frag1, frag2);
+	ufs_free_fragments(inode, tmp + frag1, frag2, 1);
+
 	mark_inode_dirty(inode);
 	frag_to_free =3D tmp + frag1;
=20
@@ -136,7 +137,7 @@ next1:
 		} else if (free_count > 0 && frag_to_free =3D=3D tmp - free_count)
 			free_count +=3D uspi->s_fpb;
 		else {
-			ufs_free_blocks (inode, frag_to_free, free_count);
+			ufs_free_blocks(inode, frag_to_free, free_count, 1);
 			frag_to_free =3D tmp;
 			free_count =3D uspi->s_fpb;
 		}
@@ -144,7 +145,7 @@ next1:
 	}
 =09
 	if (free_count > 0)
-		ufs_free_blocks (inode, frag_to_free, free_count);
+		ufs_free_blocks(inode, frag_to_free, free_count, 1);
=20
 	if (frag3 >=3D frag4)
 		goto next3;
@@ -159,7 +160,8 @@ next1:
 	frag4 =3D ufs_fragnum (frag4);
 	ufs_data_ptr_clear(uspi, p);
=20
-	ufs_free_fragments (inode, tmp, frag4);
+	ufs_free_fragments(inode, tmp, frag4, 1);
+
 	mark_inode_dirty(inode);
  next3:
=20
@@ -218,7 +220,7 @@ static int ufs_trunc_indirect(struct inode *inode, u6=
4 offset, void *p)
 		} else if (free_count > 0 && frag_to_free =3D=3D tmp - free_count)
 			free_count +=3D uspi->s_fpb;
 		else {
-			ufs_free_blocks (inode, frag_to_free, free_count);
+			ufs_free_blocks(inode, frag_to_free, free_count, 1);
 			frag_to_free =3D tmp;
 			free_count =3D uspi->s_fpb;
 		}
@@ -227,7 +229,7 @@ static int ufs_trunc_indirect(struct inode *inode, u6=
4 offset, void *p)
 	}
=20
 	if (free_count > 0) {
-		ufs_free_blocks (inode, frag_to_free, free_count);
+		ufs_free_blocks(inode, frag_to_free, free_count, 1);
 	}
 	for (i =3D 0; i < uspi->s_apb; i++)
 		if (!ufs_is_data_ptr_zero(uspi,
@@ -237,7 +239,7 @@ static int ufs_trunc_indirect(struct inode *inode, u6=
4 offset, void *p)
 		tmp =3D ufs_data_ptr_to_cpu(sb, p);
 		ufs_data_ptr_clear(uspi, p);
=20
-		ufs_free_blocks (inode, tmp, uspi->s_fpb);
+		ufs_free_blocks(inode, tmp, uspi->s_fpb, 0);
 		mark_inode_dirty(inode);
 		ubh_bforget(ind_ubh);
 		ind_ubh =3D NULL;
@@ -299,7 +301,7 @@ static int ufs_trunc_dindirect(struct inode *inode, u=
64 offset, void *p)
 		tmp =3D ufs_data_ptr_to_cpu(sb, p);
 		ufs_data_ptr_clear(uspi, p);
=20
-		ufs_free_blocks(inode, tmp, uspi->s_fpb);
+		ufs_free_blocks(inode, tmp, uspi->s_fpb, 0);
 		mark_inode_dirty(inode);
 		ubh_bforget(dind_bh);
 		dind_bh =3D NULL;
@@ -357,7 +359,7 @@ static int ufs_trunc_tindirect(struct inode *inode)
 		tmp =3D ufs_data_ptr_to_cpu(sb, p);
 		ufs_data_ptr_clear(uspi, p);
=20
-		ufs_free_blocks(inode, tmp, uspi->s_fpb);
+		ufs_free_blocks(inode, tmp, uspi->s_fpb, 0);
 		mark_inode_dirty(inode);
 		ubh_bforget(tind_bh);
 		tind_bh =3D NULL;
diff --git a/fs/ufs/ufs.h b/fs/ufs/ufs.h
index 528750b..88144a0 100644
--- a/fs/ufs/ufs.h
+++ b/fs/ufs/ufs.h
@@ -76,10 +76,10 @@ struct ufs_inode_info {
 #endif
=20
 /* balloc.c */
-extern void ufs_free_fragments (struct inode *, u64, unsigned);
-extern void ufs_free_blocks (struct inode *, u64, unsigned);
+extern void ufs_free_fragments(struct inode *, u64, unsigned, int);
+extern void ufs_free_blocks(struct inode *, u64, unsigned, int);
 extern u64 ufs_new_fragments(struct inode *, void *, u64, u64,
-			     unsigned, int *, struct page *);
+			     unsigned, int *, struct page *, int);
=20
 /* cylinder.c */
 extern struct ufs_cg_private_info * ufs_load_cylinder (struct super_bloc=
k *, unsigned);


--------------enig0E5D073ABDF777CB149B1D92
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+vvK4ACgkQNak7dOguQgmg6AD/TU28x3slQhmYKzLHNn8FPvvL
EyGMRULmz56KAIlgwpoA/3qNx5cL+oiWffCYCphZzyrs4oq8iJqpOjT5I+EjROk1
=Dh8F
-----END PGP SIGNATURE-----

--------------enig0E5D073ABDF777CB149B1D92--
