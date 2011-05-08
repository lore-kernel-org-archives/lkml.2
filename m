Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab1EHSvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:51:17 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:60244 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab1EHSuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:50:21 -0400
Date: Sun, 8 May 2011 20:43:06 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/14] HPFS: Remove remaining locks
Message-ID: <alpine.DEB.2.00.1105082025250.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove remaining locks

Because of a new global per-fs lock, no other locks are needed

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 fs/hpfs/alloc.c   |   50 ++++++++++-------------------------------------
 fs/hpfs/anode.c   |    2 -
 fs/hpfs/buffer.c  |   16 ---------------
 fs/hpfs/dnode.c   |   57 +++++++++++++++++++++++-------------------------------
 fs/hpfs/ea.c      |    6 ++---
 fs/hpfs/hpfs_fn.h |   12 ++---------
 fs/hpfs/inode.c   |    5 ----
 fs/hpfs/namei.c   |   53 ++++++--------------------------------------------
 fs/hpfs/super.c   |    4 ---
 9 files changed, 50 insertions(+), 155 deletions(-)

Index: linux-2.6.39-rc5-fast/fs/hpfs/alloc.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/alloc.c	2011-05-05 01:01:56.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/alloc.c	2011-05-05 01:02:45.000000000 +0200
@@ -8,8 +8,6 @@
 
 #include "hpfs_fn.h"
 
-static int hpfs_alloc_if_possible_nolock(struct super_block *s, secno sec);
-
 /*
  * Check if a sector is allocated in bitmap
  * This is really slow. Turned on only if chk==2
@@ -75,7 +73,6 @@ static secno alloc_in_bmp(struct super_b
 		hpfs_error(s, "Bad allocation size: %d", n);
 		return 0;
 	}
-	lock_super(s);
 	if (bs != ~0x3fff) {
 		if (!(bmp = hpfs_map_bitmap(s, near >> 14, &qbh, "aib"))) goto uls;
 	} else {
@@ -143,7 +140,6 @@ static secno alloc_in_bmp(struct super_b
 	b:
 	hpfs_brelse4(&qbh);
 	uls:
-	unlock_super(s);
 	return ret;
 }
 
@@ -155,7 +151,7 @@ static secno alloc_in_bmp(struct super_b
  *				sectors
  */
 
-secno hpfs_alloc_sector(struct super_block *s, secno near, unsigned n, int forward, int lock)
+secno hpfs_alloc_sector(struct super_block *s, secno near, unsigned n, int forward)
 {
 	secno sec;
 	int i;
@@ -167,7 +163,6 @@ secno hpfs_alloc_sector(struct super_blo
 		forward = -forward;
 		f_p = 1;
 	}
-	if (lock) hpfs_lock_creation(s);
 	n_bmps = (sbi->sb_fs_size + 0x4000 - 1) >> 14;
 	if (near && near < sbi->sb_fs_size) {
 		if ((sec = alloc_in_bmp(s, near, n, f_p ? forward : forward/4))) goto ret;
@@ -214,18 +209,17 @@ secno hpfs_alloc_sector(struct super_blo
 	ret:
 	if (sec && f_p) {
 		for (i = 0; i < forward; i++) {
-			if (!hpfs_alloc_if_possible_nolock(s, sec + i + 1)) {
+			if (!hpfs_alloc_if_possible(s, sec + i + 1)) {
 				hpfs_error(s, "Prealloc doesn't work! Wanted %d, allocated at %08x, can't allocate %d", forward, sec, i);
 				sec = 0;
 				break;
 			}
 		}
 	}
-	if (lock) hpfs_unlock_creation(s);
 	return sec;
 }
 
-static secno alloc_in_dirband(struct super_block *s, secno near, int lock)
+static secno alloc_in_dirband(struct super_block *s, secno near)
 {
 	unsigned nr = near;
 	secno sec;
@@ -236,43 +230,29 @@ static secno alloc_in_dirband(struct sup
 		nr = sbi->sb_dirband_start + sbi->sb_dirband_size - 4;
 	nr -= sbi->sb_dirband_start;
 	nr >>= 2;
-	if (lock) hpfs_lock_creation(s);
 	sec = alloc_in_bmp(s, (~0x3fff) | nr, 1, 0);
-	if (lock) hpfs_unlock_creation(s);
 	if (!sec) return 0;
 	return ((sec & 0x3fff) << 2) + sbi->sb_dirband_start;
 }
 
 /* Alloc sector if it's free */
 
-static int hpfs_alloc_if_possible_nolock(struct super_block *s, secno sec)
+int hpfs_alloc_if_possible(struct super_block *s, secno sec)
 {
 	struct quad_buffer_head qbh;
 	unsigned *bmp;
-	lock_super(s);
 	if (!(bmp = hpfs_map_bitmap(s, sec >> 14, &qbh, "aip"))) goto end;
 	if (bmp[(sec & 0x3fff) >> 5] & (1 << (sec & 0x1f))) {
 		bmp[(sec & 0x3fff) >> 5] &= ~(1 << (sec & 0x1f));
 		hpfs_mark_4buffers_dirty(&qbh);
 		hpfs_brelse4(&qbh);
-		unlock_super(s);
 		return 1;
 	}
 	hpfs_brelse4(&qbh);
 	end:
-	unlock_super(s);
 	return 0;
 }
 
-int hpfs_alloc_if_possible(struct super_block *s, secno sec)
-{
-	int r;
-	hpfs_lock_creation(s);
-	r = hpfs_alloc_if_possible_nolock(s, sec);
-	hpfs_unlock_creation(s);
-	return r;
-}
-
 /* Free sectors in bitmaps */
 
 void hpfs_free_sectors(struct super_block *s, secno sec, unsigned n)
@@ -286,26 +266,22 @@ void hpfs_free_sectors(struct super_bloc
 		hpfs_error(s, "Trying to free reserved sector %08x", sec);
 		return;
 	}
-	lock_super(s);
 	sbi->sb_max_fwd_alloc += n > 0xffff ? 0xffff : n;
 	if (sbi->sb_max_fwd_alloc > 0xffffff) sbi->sb_max_fwd_alloc = 0xffffff;
 	new_map:
 	if (!(bmp = hpfs_map_bitmap(s, sec >> 14, &qbh, "free"))) {
-		unlock_super(s);
 		return;
 	}	
 	new_tst:
 	if ((bmp[(sec & 0x3fff) >> 5] >> (sec & 0x1f) & 1)) {
 		hpfs_error(s, "sector %08x not allocated", sec);
 		hpfs_brelse4(&qbh);
-		unlock_super(s);
 		return;
 	}
 	bmp[(sec & 0x3fff) >> 5] |= 1 << (sec & 0x1f);
 	if (!--n) {
 		hpfs_mark_4buffers_dirty(&qbh);
 		hpfs_brelse4(&qbh);
-		unlock_super(s);
 		return;
 	}	
 	if (!(++sec & 0x3fff)) {
@@ -381,29 +357,25 @@ void hpfs_free_dnode(struct super_block 
 		struct quad_buffer_head qbh;
 		unsigned *bmp;
 		unsigned ssec = (dno - hpfs_sb(s)->sb_dirband_start) / 4;
-		lock_super(s);
 		if (!(bmp = hpfs_map_dnode_bitmap(s, &qbh))) {
-			unlock_super(s);
 			return;
 		}
 		bmp[ssec >> 5] |= 1 << (ssec & 0x1f);
 		hpfs_mark_4buffers_dirty(&qbh);
 		hpfs_brelse4(&qbh);
-		unlock_super(s);
 	}
 }
 
 struct dnode *hpfs_alloc_dnode(struct super_block *s, secno near,
-			 dnode_secno *dno, struct quad_buffer_head *qbh,
-			 int lock)
+			 dnode_secno *dno, struct quad_buffer_head *qbh)
 {
 	struct dnode *d;
 	if (hpfs_count_one_bitmap(s, hpfs_sb(s)->sb_dmap) > FREE_DNODES_ADD) {
-		if (!(*dno = alloc_in_dirband(s, near, lock)))
-			if (!(*dno = hpfs_alloc_sector(s, near, 4, 0, lock))) return NULL;
+		if (!(*dno = alloc_in_dirband(s, near)))
+			if (!(*dno = hpfs_alloc_sector(s, near, 4, 0))) return NULL;
 	} else {
-		if (!(*dno = hpfs_alloc_sector(s, near, 4, 0, lock)))
-			if (!(*dno = alloc_in_dirband(s, near, lock))) return NULL;
+		if (!(*dno = hpfs_alloc_sector(s, near, 4, 0)))
+			if (!(*dno = alloc_in_dirband(s, near))) return NULL;
 	}
 	if (!(d = hpfs_get_4sectors(s, *dno, qbh))) {
 		hpfs_free_dnode(s, *dno);
@@ -424,7 +396,7 @@ struct fnode *hpfs_alloc_fnode(struct su
 			  struct buffer_head **bh)
 {
 	struct fnode *f;
-	if (!(*fno = hpfs_alloc_sector(s, near, 1, FNODE_ALLOC_FWD, 1))) return NULL;
+	if (!(*fno = hpfs_alloc_sector(s, near, 1, FNODE_ALLOC_FWD))) return NULL;
 	if (!(f = hpfs_get_sector(s, *fno, bh))) {
 		hpfs_free_sectors(s, *fno, 1);
 		return NULL;
@@ -441,7 +413,7 @@ struct anode *hpfs_alloc_anode(struct su
 			  struct buffer_head **bh)
 {
 	struct anode *a;
-	if (!(*ano = hpfs_alloc_sector(s, near, 1, ANODE_ALLOC_FWD, 1))) return NULL;
+	if (!(*ano = hpfs_alloc_sector(s, near, 1, ANODE_ALLOC_FWD))) return NULL;
 	if (!(a = hpfs_get_sector(s, *ano, bh))) {
 		hpfs_free_sectors(s, *ano, 1);
 		return NULL;
Index: linux-2.6.39-rc5-fast/fs/hpfs/anode.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/anode.c	2011-05-05 01:01:56.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/anode.c	2011-05-05 01:02:45.000000000 +0200
@@ -115,7 +115,7 @@ secno hpfs_add_sector_to_btree(struct su
 		}
 		se = !fnod ? node : (node + 16384) & ~16383;
 	}	
-	if (!(se = hpfs_alloc_sector(s, se, 1, fsecno*ALLOC_M>ALLOC_FWD_MAX ? ALLOC_FWD_MAX : fsecno*ALLOC_M<ALLOC_FWD_MIN ? ALLOC_FWD_MIN : fsecno*ALLOC_M, 1))) {
+	if (!(se = hpfs_alloc_sector(s, se, 1, fsecno*ALLOC_M>ALLOC_FWD_MAX ? ALLOC_FWD_MAX : fsecno*ALLOC_M<ALLOC_FWD_MIN ? ALLOC_FWD_MIN : fsecno*ALLOC_M))) {
 		brelse(bh);
 		return -1;
 	}
Index: linux-2.6.39-rc5-fast/fs/hpfs/buffer.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/buffer.c	2011-05-05 01:02:43.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/buffer.c	2011-05-05 01:02:45.000000000 +0200
@@ -9,22 +9,6 @@
 #include <linux/slab.h>
 #include "hpfs_fn.h"
 
-void hpfs_lock_creation(struct super_block *s)
-{
-#ifdef DEBUG_LOCKS
-	printk("lock creation\n");
-#endif
-	mutex_lock(&hpfs_sb(s)->hpfs_creation_de);
-}
-
-void hpfs_unlock_creation(struct super_block *s)
-{
-#ifdef DEBUG_LOCKS
-	printk("unlock creation\n");
-#endif
-	mutex_unlock(&hpfs_sb(s)->hpfs_creation_de);
-}
-
 /* Map a sector into a buffer and return pointers to it and to the buffer. */
 
 void *hpfs_map_sector(struct super_block *s, unsigned secno, struct buffer_head **bhp,
Index: linux-2.6.39-rc5-fast/fs/hpfs/dnode.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/dnode.c	2011-05-05 01:01:56.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/dnode.c	2011-05-05 01:02:45.000000000 +0200
@@ -145,9 +145,10 @@ static void set_last_pointer(struct supe
 		}
 	}
 	if (ptr) {
-		if ((d->first_free += 4) > 2048) {
-			hpfs_error(s,"set_last_pointer: too long dnode %08x", d->self);
-			d->first_free -= 4;
+		d->first_free = cpu_to_le32(le32_to_cpu(d->first_free) + 4);
+		if (le32_to_cpu(d->first_free) > 2048) {
+			hpfs_error(s, "set_last_pointer: too long dnode %08x", d->self);
+			d->first_free = cpu_to_le32(le32_to_cpu(d->first_free) - 4);
 			return;
 		}
 		de->length = 36;
@@ -184,7 +185,7 @@ struct hpfs_dirent *hpfs_add_de(struct s
 	de->not_8x3 = hpfs_is_name_long(name, namelen);
 	de->namelen = namelen;
 	memcpy(de->name, name, namelen);
-	d->first_free += d_size;
+	d->first_free = cpu_to_le32(le32_to_cpu(d->first_free) + d_size);
 	return de;
 }
 
@@ -197,8 +198,8 @@ static void hpfs_delete_de(struct super_
 		hpfs_error(s, "attempt to delete last dirent in dnode %08x", d->self);
 		return;
 	}
-	d->first_free -= de->length;
-	memmove(de, de_next_de(de), d->first_free + (char *)d - (char *)de);
+	d->first_free = cpu_to_le32(le32_to_cpu(d->first_free) - de->length);
+	memmove(de, de_next_de(de), le32_to_cpu(d->first_free) + (char *)d - (char *)de);
 }
 
 static void fix_up_ptrs(struct super_block *s, struct dnode *d)
@@ -262,7 +263,7 @@ static int hpfs_add_to_dnode(struct inod
 			kfree(nname);
 			return 1;
 		}
-	if (d->first_free + de_size(namelen, down_ptr) <= 2048) {
+	if (le32_to_cpu(d->first_free) + de_size(namelen, down_ptr) <= 2048) {
 		loff_t t;
 		copy_de(de=hpfs_add_de(i->i_sb, d, name, namelen, down_ptr), new_de);
 		t = get_pos(d, de);
@@ -286,11 +287,11 @@ static int hpfs_add_to_dnode(struct inod
 		kfree(nname);
 		return 1;
 	}	
-	memcpy(nd, d, d->first_free);
+	memcpy(nd, d, le32_to_cpu(d->first_free));
 	copy_de(de = hpfs_add_de(i->i_sb, nd, name, namelen, down_ptr), new_de);
 	for_all_poss(i, hpfs_pos_ins, get_pos(nd, de), 1);
 	h = ((char *)dnode_last_de(nd) - (char *)nd) / 2 + 10;
-	if (!(ad = hpfs_alloc_dnode(i->i_sb, d->up, &adno, &qbh1, 0))) {
+	if (!(ad = hpfs_alloc_dnode(i->i_sb, d->up, &adno, &qbh1))) {
 		hpfs_error(i->i_sb, "unable to alloc dnode - dnode tree will be corrupted");
 		hpfs_brelse4(&qbh);
 		kfree(nd);
@@ -313,9 +314,9 @@ static int hpfs_add_to_dnode(struct inod
 	down_ptr = adno;
 	set_last_pointer(i->i_sb, ad, de->down ? de_down_pointer(de) : 0);
 	de = de_next_de(de);
-	memmove((char *)nd + 20, de, nd->first_free + (char *)nd - (char *)de);
-	nd->first_free -= (char *)de - (char *)nd - 20;
-	memcpy(d, nd, nd->first_free);
+	memmove((char *)nd + 20, de, le32_to_cpu(nd->first_free) + (char *)nd - (char *)de);
+	nd->first_free = cpu_to_le32(le32_to_cpu(nd->first_free) - (char *)de - (char *)nd - 20);
+	memcpy(d, nd, le32_to_cpu(nd->first_free));
 	for_all_poss(i, hpfs_pos_del, (loff_t)dno << 4, pos);
 	fix_up_ptrs(i->i_sb, ad);
 	if (!d->root_dnode) {
@@ -326,7 +327,7 @@ static int hpfs_add_to_dnode(struct inod
 		hpfs_brelse4(&qbh1);
 		goto go_up;
 	}
-	if (!(rd = hpfs_alloc_dnode(i->i_sb, d->up, &rdno, &qbh2, 0))) {
+	if (!(rd = hpfs_alloc_dnode(i->i_sb, d->up, &rdno, &qbh2))) {
 		hpfs_error(i->i_sb, "unable to alloc dnode - dnode tree will be corrupted");
 		hpfs_brelse4(&qbh);
 		hpfs_brelse4(&qbh1);
@@ -373,7 +374,7 @@ static int hpfs_add_to_dnode(struct inod
 
 int hpfs_add_dirent(struct inode *i,
 		    const unsigned char *name, unsigned namelen,
-		    struct hpfs_dirent *new_de, int cdepth)
+		    struct hpfs_dirent *new_de)
 {
 	struct hpfs_inode_info *hpfs_inode = hpfs_i(i);
 	struct dnode *d;
@@ -403,7 +404,6 @@ int hpfs_add_dirent(struct inode *i,
 		}
 	}
 	hpfs_brelse4(&qbh);
-	if (!cdepth) hpfs_lock_creation(i->i_sb);
 	if (hpfs_check_free_dnodes(i->i_sb, FREE_DNODES_ADD)) {
 		c = 1;
 		goto ret;
@@ -411,7 +411,6 @@ int hpfs_add_dirent(struct inode *i,
 	i->i_version++;
 	c = hpfs_add_to_dnode(i, dno, name, namelen, new_de, 0);
 	ret:
-	if (!cdepth) hpfs_unlock_creation(i->i_sb);
 	return c;
 }
 
@@ -474,7 +473,7 @@ static secno move_to_top(struct inode *i
 			hpfs_brelse4(&qbh);
 			return 0;
 		}
-		dnode->first_free -= 4;
+		dnode->first_free = cpu_to_le32(le32_to_cpu(dnode->first_free) - 4);
 		de->length -= 4;
 		de->down = 0;
 		hpfs_mark_4buffers_dirty(&qbh);
@@ -517,8 +516,8 @@ static void delete_empty_dnode(struct in
 	try_it_again:
 	if (hpfs_stop_cycles(i->i_sb, dno, &c1, &c2, "delete_empty_dnode")) return;
 	if (!(dnode = hpfs_map_dnode(i->i_sb, dno, &qbh))) return;
-	if (dnode->first_free > 56) goto end;
-	if (dnode->first_free == 52 || dnode->first_free == 56) {
+	if (le32_to_cpu(dnode->first_free) > 56) goto end;
+	if (le32_to_cpu(dnode->first_free) == 52 || le32_to_cpu(dnode->first_free) == 56) {
 		struct hpfs_dirent *de_end;
 		int root = dnode->root_dnode;
 		up = dnode->up;
@@ -571,9 +570,9 @@ static void delete_empty_dnode(struct in
 		if (!down) {
 			de->down = 0;
 			de->length -= 4;
-			dnode->first_free -= 4;
+			dnode->first_free = cpu_to_le32(le32_to_cpu(dnode->first_free) - 4);
 			memmove(de_next_de(de), (char *)de_next_de(de) + 4,
-				(char *)dnode + dnode->first_free - (char *)de_next_de(de));
+				(char *)dnode + le32_to_cpu(dnode->first_free) - (char *)de_next_de(de));
 		} else {
 			struct dnode *d1;
 			struct quad_buffer_head qbh1;
@@ -585,7 +584,7 @@ static void delete_empty_dnode(struct in
 			}
 		}
 	} else {
-		hpfs_error(i->i_sb, "delete_empty_dnode: dnode %08x, first_free == %03x", dno, dnode->first_free);
+		hpfs_error(i->i_sb, "delete_empty_dnode: dnode %08x, first_free == %03x", dno, le32_to_cpu(dnode->first_free));
 		goto end;
 	}
 
@@ -635,7 +634,7 @@ static void delete_empty_dnode(struct in
 			struct hpfs_dirent *del = dnode_last_de(d1);
 			dlp = del->down ? de_down_pointer(del) : 0;
 			if (!dlp && down) {
-				if (d1->first_free > 2044) {
+				if (le32_to_cpu(d1->first_free) > 2044) {
 					if (hpfs_sb(i->i_sb)->sb_chk >= 2) {
 						printk("HPFS: warning: unbalanced dnode tree, see hpfs.txt 4 more info\n");
 						printk("HPFS: warning: terminating balancing operation\n");
@@ -649,12 +648,12 @@ static void delete_empty_dnode(struct in
 				}
 				del->length += 4;
 				del->down = 1;
-				d1->first_free += 4;
+				d1->first_free = cpu_to_le32(le32_to_cpu(d1->first_free) + 4);
 			}
 			if (dlp && !down) {
 				del->length -= 4;
 				del->down = 0;
-				d1->first_free -= 4;
+				d1->first_free = cpu_to_le32(le32_to_cpu(d1->first_free) - 4);
 			} else if (down)
 				*(dnode_secno *) ((void *) del + del->length - 4) = down;
 		} else goto endm;
@@ -670,7 +669,7 @@ static void delete_empty_dnode(struct in
 		if (!de_prev->down) {
 			de_prev->length += 4;
 			de_prev->down = 1;
-			dnode->first_free += 4;
+			dnode->first_free = cpu_to_le32(le32_to_cpu(dnode->first_free) + 4);
 		}
 		*(dnode_secno *) ((void *) de_prev + de_prev->length - 4) = ndown;
 		hpfs_mark_4buffers_dirty(&qbh);
@@ -701,7 +700,6 @@ int hpfs_remove_dirent(struct inode *i, 
 {
 	struct dnode *dnode = qbh->data;
 	dnode_secno down = 0;
-	int lock = 0;
 	loff_t t;
 	if (de->first || de->last) {
 		hpfs_error(i->i_sb, "hpfs_remove_dirent: attempt to delete first or last dirent in dnode %08x", dno);
@@ -710,11 +708,8 @@ int hpfs_remove_dirent(struct inode *i, 
 	}
 	if (de->down) down = de_down_pointer(de);
 	if (depth && (de->down || (de == dnode_first_de(dnode) && de_next_de(de)->last))) {
-		lock = 1;
-		hpfs_lock_creation(i->i_sb);
 		if (hpfs_check_free_dnodes(i->i_sb, FREE_DNODES_DEL)) {
 			hpfs_brelse4(qbh);
-			hpfs_unlock_creation(i->i_sb);
 			return 2;
 		}
 	}
@@ -727,11 +722,9 @@ int hpfs_remove_dirent(struct inode *i, 
 		dnode_secno a = move_to_top(i, down, dno);
 		for_all_poss(i, hpfs_pos_subst, 5, t);
 		if (a) delete_empty_dnode(i, a);
-		if (lock) hpfs_unlock_creation(i->i_sb);
 		return !a;
 	}
 	delete_empty_dnode(i, dno);
-	if (lock) hpfs_unlock_creation(i->i_sb);
 	return 0;
 }
 
Index: linux-2.6.39-rc5-fast/fs/hpfs/ea.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/ea.c	2011-05-05 01:01:56.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/ea.c	2011-05-05 01:02:45.000000000 +0200
@@ -266,7 +266,7 @@ void hpfs_set_ea(struct inode *inode, st
 		secno n;
 		struct buffer_head *bh;
 		char *data;
-		if (!(n = hpfs_alloc_sector(s, fno, 1, 0, 1))) return;
+		if (!(n = hpfs_alloc_sector(s, fno, 1, 0))) return;
 		if (!(data = hpfs_get_sector(s, n, &bh))) {
 			hpfs_free_sectors(s, n, 1);
 			return;
@@ -284,7 +284,7 @@ void hpfs_set_ea(struct inode *inode, st
 	if (pos >= 30000) goto bail;
 	while (((pos + 511) >> 9) > len) {
 		if (!len) {
-			if (!(fnode->ea_secno = hpfs_alloc_sector(s, fno, 1, 0, 1)))
+			if (!(fnode->ea_secno = hpfs_alloc_sector(s, fno, 1, 0)))
 				goto bail;
 			fnode->ea_anode = 0;
 			len++;
@@ -312,7 +312,7 @@ void hpfs_set_ea(struct inode *inode, st
 				fnode->ea_secno = a_s;*/
 				secno new_sec;
 				int i;
-				if (!(new_sec = hpfs_alloc_sector(s, fno, 1, 1 - ((pos + 511) >> 9), 1)))
+				if (!(new_sec = hpfs_alloc_sector(s, fno, 1, 1 - ((pos + 511) >> 9))))
 					goto bail;
 				for (i = 0; i < len; i++) {
 					struct buffer_head *bh1, *bh2;
Index: linux-2.6.39-rc5-fast/fs/hpfs/hpfs_fn.h
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/hpfs_fn.h	2011-05-05 01:02:43.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/hpfs_fn.h	2011-05-05 01:02:45.000000000 +0200
@@ -56,8 +56,6 @@ struct hpfs_inode_info {
 	unsigned i_ea_uid : 1;	/* file's uid is stored in ea */
 	unsigned i_ea_gid : 1;	/* file's gid is stored in ea */
 	unsigned i_dirty : 1;
-	struct mutex i_mutex;
-	struct mutex i_parent_mutex;
 	loff_t **i_rddir_off;
 	struct inode vfs_inode;
 };
@@ -88,8 +86,6 @@ struct hpfs_sb_info {
 	unsigned *sb_bmp_dir;		/* main bitmap directory */
 	unsigned sb_c_bitmap;		/* current bitmap */
 	unsigned sb_max_fwd_alloc;	/* max forwad allocation */
-	struct mutex hpfs_creation_de;	/* when creating dirents, nobody else
-					   can alloc blocks */
 	/*unsigned sb_mounting : 1;*/
 	int sb_timeshift;
 };
@@ -201,12 +197,12 @@ static inline unsigned tstbits(unsigned 
 /* alloc.c */
 
 int hpfs_chk_sectors(struct super_block *, secno, int, char *);
-secno hpfs_alloc_sector(struct super_block *, secno, unsigned, int, int);
+secno hpfs_alloc_sector(struct super_block *, secno, unsigned, int);
 int hpfs_alloc_if_possible(struct super_block *, secno);
 void hpfs_free_sectors(struct super_block *, secno, unsigned);
 int hpfs_check_free_dnodes(struct super_block *, int);
 void hpfs_free_dnode(struct super_block *, secno);
-struct dnode *hpfs_alloc_dnode(struct super_block *, secno, dnode_secno *, struct quad_buffer_head *, int);
+struct dnode *hpfs_alloc_dnode(struct super_block *, secno, dnode_secno *, struct quad_buffer_head *);
 struct fnode *hpfs_alloc_fnode(struct super_block *, secno, fnode_secno *, struct buffer_head **);
 struct anode *hpfs_alloc_anode(struct super_block *, secno, anode_secno *, struct buffer_head **);
 
@@ -223,8 +219,6 @@ void hpfs_remove_fnode(struct super_bloc
 
 /* buffer.c */
 
-void hpfs_lock_creation(struct super_block *);
-void hpfs_unlock_creation(struct super_block *);
 void *hpfs_map_sector(struct super_block *, unsigned, struct buffer_head **, int);
 void *hpfs_get_sector(struct super_block *, unsigned, struct buffer_head **);
 void *hpfs_map_4sectors(struct super_block *, unsigned, struct quad_buffer_head *, int);
@@ -248,7 +242,7 @@ void hpfs_del_pos(struct inode *, loff_t
 struct hpfs_dirent *hpfs_add_de(struct super_block *, struct dnode *,
 				const unsigned char *, unsigned, secno);
 int hpfs_add_dirent(struct inode *, const unsigned char *, unsigned,
-		    struct hpfs_dirent *, int);
+		    struct hpfs_dirent *);
 int hpfs_remove_dirent(struct inode *, dnode_secno, struct hpfs_dirent *, struct quad_buffer_head *, int);
 void hpfs_count_dnodes(struct super_block *, dnode_secno, int *, int *, int *);
 dnode_secno hpfs_de_as_down_as_possible(struct super_block *, dnode_secno dno);
Index: linux-2.6.39-rc5-fast/fs/hpfs/inode.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/inode.c	2011-05-05 01:01:56.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/inode.c	2011-05-05 01:02:45.000000000 +0200
@@ -187,9 +187,7 @@ void hpfs_write_inode(struct inode *i)
 		kfree(hpfs_inode->i_rddir_off);
 		hpfs_inode->i_rddir_off = NULL;
 	}
-	mutex_lock(&hpfs_inode->i_parent_mutex);
 	if (!i->i_nlink) {
-		mutex_unlock(&hpfs_inode->i_parent_mutex);
 		return;
 	}
 	parent = iget_locked(i->i_sb, hpfs_inode->i_parent_dir);
@@ -200,14 +198,11 @@ void hpfs_write_inode(struct inode *i)
 			hpfs_read_inode(parent);
 			unlock_new_inode(parent);
 		}
-		mutex_lock(&hpfs_inode->i_mutex);
 		hpfs_write_inode_nolock(i);
-		mutex_unlock(&hpfs_inode->i_mutex);
 		iput(parent);
 	} else {
 		mark_inode_dirty(i);
 	}
-	mutex_unlock(&hpfs_inode->i_parent_mutex);
 }
 
 void hpfs_write_inode_nolock(struct inode *i)
Index: linux-2.6.39-rc5-fast/fs/hpfs/namei.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/namei.c	2011-05-05 01:01:56.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/namei.c	2011-05-05 01:02:45.000000000 +0200
@@ -29,7 +29,7 @@ static int hpfs_mkdir(struct inode *dir,
 	fnode = hpfs_alloc_fnode(dir->i_sb, hpfs_i(dir)->i_dno, &fno, &bh);
 	if (!fnode)
 		goto bail;
-	dnode = hpfs_alloc_dnode(dir->i_sb, fno, &dno, &qbh0, 1);
+	dnode = hpfs_alloc_dnode(dir->i_sb, fno, &dno, &qbh0);
 	if (!dnode)
 		goto bail1;
 	memset(&dee, 0, sizeof dee);
@@ -60,8 +60,7 @@ static int hpfs_mkdir(struct inode *dir,
 	if (dee.read_only)
 		result->i_mode &= ~0222;
 
-	mutex_lock(&hpfs_i(dir)->i_mutex);
-	r = hpfs_add_dirent(dir, name, len, &dee, 0);
+	r = hpfs_add_dirent(dir, name, len, &dee);
 	if (r == 1)
 		goto bail3;
 	if (r == -1) {
@@ -101,11 +100,9 @@ static int hpfs_mkdir(struct inode *dir,
 		hpfs_write_inode_nolock(result);
 	}
 	d_instantiate(dentry, result);
-	mutex_unlock(&hpfs_i(dir)->i_mutex);
 	hpfs_unlock(dir->i_sb);
 	return 0;
 bail3:
-	mutex_unlock(&hpfs_i(dir)->i_mutex);
 	iput(result);
 bail2:
 	hpfs_brelse4(&qbh0);
@@ -168,8 +165,7 @@ static int hpfs_create(struct inode *dir
 	result->i_data.a_ops = &hpfs_aops;
 	hpfs_i(result)->mmu_private = 0;
 
-	mutex_lock(&hpfs_i(dir)->i_mutex);
-	r = hpfs_add_dirent(dir, name, len, &dee, 0);
+	r = hpfs_add_dirent(dir, name, len, &dee);
 	if (r == 1)
 		goto bail2;
 	if (r == -1) {
@@ -193,12 +189,10 @@ static int hpfs_create(struct inode *dir
 		hpfs_write_inode_nolock(result);
 	}
 	d_instantiate(dentry, result);
-	mutex_unlock(&hpfs_i(dir)->i_mutex);
 	hpfs_unlock(dir->i_sb);
 	return 0;
 
 bail2:
-	mutex_unlock(&hpfs_i(dir)->i_mutex);
 	iput(result);
 bail1:
 	brelse(bh);
@@ -254,8 +248,7 @@ static int hpfs_mknod(struct inode *dir,
 	result->i_blocks = 1;
 	init_special_inode(result, mode, rdev);
 
-	mutex_lock(&hpfs_i(dir)->i_mutex);
-	r = hpfs_add_dirent(dir, name, len, &dee, 0);
+	r = hpfs_add_dirent(dir, name, len, &dee);
 	if (r == 1)
 		goto bail2;
 	if (r == -1) {
@@ -271,12 +264,10 @@ static int hpfs_mknod(struct inode *dir,
 
 	hpfs_write_inode_nolock(result);
 	d_instantiate(dentry, result);
-	mutex_unlock(&hpfs_i(dir)->i_mutex);
 	brelse(bh);
 	hpfs_unlock(dir->i_sb);
 	return 0;
 bail2:
-	mutex_unlock(&hpfs_i(dir)->i_mutex);
 	iput(result);
 bail1:
 	brelse(bh);
@@ -333,8 +324,7 @@ static int hpfs_symlink(struct inode *di
 	result->i_op = &page_symlink_inode_operations;
 	result->i_data.a_ops = &hpfs_symlink_aops;
 
-	mutex_lock(&hpfs_i(dir)->i_mutex);
-	r = hpfs_add_dirent(dir, name, len, &dee, 0);
+	r = hpfs_add_dirent(dir, name, len, &dee);
 	if (r == 1)
 		goto bail2;
 	if (r == -1) {
@@ -352,11 +342,9 @@ static int hpfs_symlink(struct inode *di
 
 	hpfs_write_inode_nolock(result);
 	d_instantiate(dentry, result);
-	mutex_unlock(&hpfs_i(dir)->i_mutex);
 	hpfs_unlock(dir->i_sb);
 	return 0;
 bail2:
-	mutex_unlock(&hpfs_i(dir)->i_mutex);
 	iput(result);
 bail1:
 	brelse(bh);
@@ -382,8 +370,6 @@ static int hpfs_unlink(struct inode *dir
 	hpfs_lock(dir->i_sb);
 	hpfs_adjust_length(name, &len);
 again:
-	mutex_lock(&hpfs_i(inode)->i_parent_mutex);
-	mutex_lock(&hpfs_i(dir)->i_mutex);
 	err = -ENOENT;
 	de = map_dirent(dir, hpfs_i(dir)->i_dno, name, len, &dno, &qbh);
 	if (!de)
@@ -410,8 +396,6 @@ again:
 		if (rep++)
 			break;
 
-		mutex_unlock(&hpfs_i(dir)->i_mutex);
-		mutex_unlock(&hpfs_i(inode)->i_parent_mutex);
 		dentry_unhash(dentry);
 		if (!d_unhashed(dentry)) {
 			dput(dentry);
@@ -445,8 +429,6 @@ again:
 out1:
 	hpfs_brelse4(&qbh);
 out:
-	mutex_unlock(&hpfs_i(dir)->i_mutex);
-	mutex_unlock(&hpfs_i(inode)->i_parent_mutex);
 	hpfs_unlock(dir->i_sb);
 	return err;
 }
@@ -466,8 +448,6 @@ static int hpfs_rmdir(struct inode *dir,
 
 	hpfs_adjust_length(name, &len);
 	hpfs_lock(dir->i_sb);
-	mutex_lock(&hpfs_i(inode)->i_parent_mutex);
-	mutex_lock(&hpfs_i(dir)->i_mutex);
 	err = -ENOENT;
 	de = map_dirent(dir, hpfs_i(dir)->i_dno, name, len, &dno, &qbh);
 	if (!de)
@@ -505,8 +485,6 @@ static int hpfs_rmdir(struct inode *dir,
 out1:
 	hpfs_brelse4(&qbh);
 out:
-	mutex_unlock(&hpfs_i(dir)->i_mutex);
-	mutex_unlock(&hpfs_i(inode)->i_parent_mutex);
 	hpfs_unlock(dir->i_sb);
 	return err;
 }
@@ -568,12 +546,6 @@ static int hpfs_rename(struct inode *old
 
 	hpfs_lock(i->i_sb);
 	/* order doesn't matter, due to VFS exclusion */
-	mutex_lock(&hpfs_i(i)->i_parent_mutex);
-	if (new_inode)
-		mutex_lock(&hpfs_i(new_inode)->i_parent_mutex);
-	mutex_lock(&hpfs_i(old_dir)->i_mutex);
-	if (new_dir != old_dir)
-		mutex_lock(&hpfs_i(new_dir)->i_mutex);
 	
 	/* Erm? Moving over the empty non-busy directory is perfectly legal */
 	if (new_inode && S_ISDIR(new_inode->i_mode)) {
@@ -610,9 +582,7 @@ static int hpfs_rename(struct inode *old
 
 	if (new_dir == old_dir) hpfs_brelse4(&qbh);
 
-	hpfs_lock_creation(i->i_sb);
-	if ((r = hpfs_add_dirent(new_dir, new_name, new_len, &de, 1))) {
-		hpfs_unlock_creation(i->i_sb);
+	if ((r = hpfs_add_dirent(new_dir, new_name, new_len, &de))) {
 		if (r == -1) hpfs_error(new_dir->i_sb, "hpfs_rename: dirent already exists!");
 		err = r == 1 ? -ENOSPC : -EFSERROR;
 		if (new_dir != old_dir) hpfs_brelse4(&qbh);
@@ -621,20 +591,17 @@ static int hpfs_rename(struct inode *old
 	
 	if (new_dir == old_dir)
 		if (!(dep = map_dirent(old_dir, hpfs_i(old_dir)->i_dno, old_name, old_len, &dno, &qbh))) {
-			hpfs_unlock_creation(i->i_sb);
 			hpfs_error(i->i_sb, "lookup succeeded but map dirent failed at #2");
 			err = -ENOENT;
 			goto end1;
 		}
 
 	if ((r = hpfs_remove_dirent(old_dir, dno, dep, &qbh, 0))) {
-		hpfs_unlock_creation(i->i_sb);
 		hpfs_error(i->i_sb, "hpfs_rename: could not remove dirent");
 		err = r == 2 ? -ENOSPC : -EFSERROR;
 		goto end1;
 	}
-	hpfs_unlock_creation(i->i_sb);
-	
+
 	end:
 	hpfs_i(i)->i_parent_dir = new_dir->i_ino;
 	if (S_ISDIR(i->i_mode)) {
@@ -652,12 +619,6 @@ static int hpfs_rename(struct inode *old
 	hpfs_i(i)->i_conv = hpfs_sb(i->i_sb)->sb_conv;
 	hpfs_decide_conv(i, new_name, new_len);
 end1:
-	if (old_dir != new_dir)
-		mutex_unlock(&hpfs_i(new_dir)->i_mutex);
-	mutex_unlock(&hpfs_i(old_dir)->i_mutex);
-	mutex_unlock(&hpfs_i(i)->i_parent_mutex);
-	if (new_inode)
-		mutex_unlock(&hpfs_i(new_inode)->i_parent_mutex);
 	hpfs_unlock(i->i_sb);
 	return err;
 }
Index: linux-2.6.39-rc5-fast/fs/hpfs/super.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/super.c	2011-05-05 01:02:43.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/super.c	2011-05-05 01:02:45.000000000 +0200
@@ -191,8 +191,6 @@ static void init_once(void *foo)
 {
 	struct hpfs_inode_info *ei = (struct hpfs_inode_info *) foo;
 
-	mutex_init(&ei->i_mutex);
-	mutex_init(&ei->i_parent_mutex);
 	inode_init_once(&ei->vfs_inode);
 }
 
@@ -496,8 +494,6 @@ static int hpfs_fill_super(struct super_
 	mutex_init(&sbi->hpfs_mutex);
 	hpfs_lock(s);
 
-	mutex_init(&sbi->hpfs_creation_de);
-
 	uid = current_uid();
 	gid = current_gid();
 	umask = current_umask();
