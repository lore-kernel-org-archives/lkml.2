Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab1EHSvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:51:14 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:49687 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226Ab1EHSuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:50:21 -0400
Date: Sun, 8 May 2011 20:44:26 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 11/14] HPFS: Fix endianity. Make hpfs work on big-endian
 machines
Message-ID: <alpine.DEB.2.00.1105082030020.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix endianity. Make hpfs work on big-endian machines.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 fs/hpfs/alloc.c   |   68 +++++++---------
 fs/hpfs/anode.c   |  136 ++++++++++++++++-----------------
 fs/hpfs/dir.c     |   20 ++--
 fs/hpfs/dnode.c   |  127 +++++++++++++++----------------
 fs/hpfs/ea.c      |  129 ++++++++++++++++---------------
 fs/hpfs/hpfs.h    |  219 ++++++++++++++++++++++++++++++++++++------------------
 fs/hpfs/hpfs_fn.h |   27 +++---
 fs/hpfs/inode.c   |   34 ++++----
 fs/hpfs/map.c     |   56 +++++++------
 fs/hpfs/namei.c   |   50 ++++++------
 fs/hpfs/super.c   |   50 ++++++------
 11 files changed, 498 insertions(+), 418 deletions(-)

Index: linux-2.6.39-rc5-fast/fs/hpfs/alloc.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/alloc.c	2011-05-05 01:02:45.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/alloc.c	2011-05-05 01:02:57.000000000 +0200
@@ -16,9 +16,9 @@
 static int chk_if_allocated(struct super_block *s, secno sec, char *msg)
 {
 	struct quad_buffer_head qbh;
-	unsigned *bmp;
+	u32 *bmp;
 	if (!(bmp = hpfs_map_bitmap(s, sec >> 14, &qbh, "chk"))) goto fail;
-	if ((bmp[(sec & 0x3fff) >> 5] >> (sec & 0x1f)) & 1) {
+	if ((cpu_to_le32(bmp[(sec & 0x3fff) >> 5]) >> (sec & 0x1f)) & 1) {
 		hpfs_error(s, "sector '%s' - %08x not allocated in bitmap", msg, sec);
 		goto fail1;
 	}
@@ -26,7 +26,7 @@ static int chk_if_allocated(struct super
 	if (sec >= hpfs_sb(s)->sb_dirband_start && sec < hpfs_sb(s)->sb_dirband_start + hpfs_sb(s)->sb_dirband_size) {
 		unsigned ssec = (sec - hpfs_sb(s)->sb_dirband_start) / 4;
 		if (!(bmp = hpfs_map_dnode_bitmap(s, &qbh))) goto fail;
-		if ((bmp[ssec >> 5] >> (ssec & 0x1f)) & 1) {
+		if ((le32_to_cpu(bmp[ssec >> 5]) >> (ssec & 0x1f)) & 1) {
 			hpfs_error(s, "sector '%s' - %08x not allocated in directory bitmap", msg, sec);
 			goto fail1;
 		}
@@ -82,10 +82,6 @@ static secno alloc_in_bmp(struct super_b
 		ret = bs + nr;
 		goto rt;
 	}
-	/*if (!tstbits(bmp, nr + n, n + forward)) {
-		ret = bs + nr + n;
-		goto rt;
-	}*/
 	q = nr + n; b = 0;
 	while ((a = tstbits(bmp, q, n + forward)) != 0) {
 		q += a;
@@ -102,14 +98,14 @@ static secno alloc_in_bmp(struct super_b
 		goto rt;
 	}
 	nr >>= 5;
-	/*for (i = nr + 1; i != nr; i++, i &= 0x1ff) {*/
+	/*for (i = nr + 1; i != nr; i++, i &= 0x1ff) */
 	i = nr;
 	do {
-		if (!bmp[i]) goto cont;
-		if (n + forward >= 0x3f && bmp[i] != -1) goto cont;
+		if (!le32_to_cpu(bmp[i])) goto cont;
+		if (n + forward >= 0x3f && le32_to_cpu(bmp[i]) != 0xffffffff) goto cont;
 		q = i<<5;
 		if (i > 0) {
-			unsigned k = bmp[i-1];
+			unsigned k = le32_to_cpu(bmp[i-1]);
 			while (k & 0x80000000) {
 				q--; k <<= 1;
 			}
@@ -129,12 +125,12 @@ static secno alloc_in_bmp(struct super_b
 	} while (i != nr);
 	rt:
 	if (ret) {
-		if (hpfs_sb(s)->sb_chk && ((ret >> 14) != (bs >> 14) || (bmp[(ret & 0x3fff) >> 5] | ~(((1 << n) - 1) << (ret & 0x1f))) != 0xffffffff)) {
+		if (hpfs_sb(s)->sb_chk && ((ret >> 14) != (bs >> 14) || (le32_to_cpu(bmp[(ret & 0x3fff) >> 5]) | ~(((1 << n) - 1) << (ret & 0x1f))) != 0xffffffff)) {
 			hpfs_error(s, "Allocation doesn't work! Wanted %d, allocated at %08x", n, ret);
 			ret = 0;
 			goto b;
 		}
-		bmp[(ret & 0x3fff) >> 5] &= ~(((1 << n) - 1) << (ret & 0x1f));
+		bmp[(ret & 0x3fff) >> 5] &= cpu_to_le32(~(((1 << n) - 1) << (ret & 0x1f)));
 		hpfs_mark_4buffers_dirty(&qbh);
 	}
 	b:
@@ -240,10 +236,10 @@ static secno alloc_in_dirband(struct sup
 int hpfs_alloc_if_possible(struct super_block *s, secno sec)
 {
 	struct quad_buffer_head qbh;
-	unsigned *bmp;
+	u32 *bmp;
 	if (!(bmp = hpfs_map_bitmap(s, sec >> 14, &qbh, "aip"))) goto end;
-	if (bmp[(sec & 0x3fff) >> 5] & (1 << (sec & 0x1f))) {
-		bmp[(sec & 0x3fff) >> 5] &= ~(1 << (sec & 0x1f));
+	if (le32_to_cpu(bmp[(sec & 0x3fff) >> 5]) & (1 << (sec & 0x1f))) {
+		bmp[(sec & 0x3fff) >> 5] &= cpu_to_le32(~(1 << (sec & 0x1f)));
 		hpfs_mark_4buffers_dirty(&qbh);
 		hpfs_brelse4(&qbh);
 		return 1;
@@ -258,7 +254,7 @@ int hpfs_alloc_if_possible(struct super_
 void hpfs_free_sectors(struct super_block *s, secno sec, unsigned n)
 {
 	struct quad_buffer_head qbh;
-	unsigned *bmp;
+	u32 *bmp;
 	struct hpfs_sb_info *sbi = hpfs_sb(s);
 	/*printk("2 - ");*/
 	if (!n) return;
@@ -273,12 +269,12 @@ void hpfs_free_sectors(struct super_bloc
 		return;
 	}	
 	new_tst:
-	if ((bmp[(sec & 0x3fff) >> 5] >> (sec & 0x1f) & 1)) {
+	if ((le32_to_cpu(bmp[(sec & 0x3fff) >> 5]) >> (sec & 0x1f) & 1)) {
 		hpfs_error(s, "sector %08x not allocated", sec);
 		hpfs_brelse4(&qbh);
 		return;
 	}
-	bmp[(sec & 0x3fff) >> 5] |= 1 << (sec & 0x1f);
+	bmp[(sec & 0x3fff) >> 5] |= cpu_to_le32(1 << (sec & 0x1f));
 	if (!--n) {
 		hpfs_mark_4buffers_dirty(&qbh);
 		hpfs_brelse4(&qbh);
@@ -303,13 +299,13 @@ int hpfs_check_free_dnodes(struct super_
 	int n_bmps = (hpfs_sb(s)->sb_fs_size + 0x4000 - 1) >> 14;
 	int b = hpfs_sb(s)->sb_c_bitmap & 0x0fffffff;
 	int i, j;
-	unsigned *bmp;
+	u32 *bmp;
 	struct quad_buffer_head qbh;
 	if ((bmp = hpfs_map_dnode_bitmap(s, &qbh))) {
 		for (j = 0; j < 512; j++) {
 			unsigned k;
-			if (!bmp[j]) continue;
-			for (k = bmp[j]; k; k >>= 1) if (k & 1) if (!--n) {
+			if (!le32_to_cpu(bmp[j])) continue;
+			for (k = le32_to_cpu(bmp[j]); k; k >>= 1) if (k & 1) if (!--n) {
 				hpfs_brelse4(&qbh);
 				return 0;
 			}
@@ -328,10 +324,10 @@ int hpfs_check_free_dnodes(struct super_
 	chk_bmp:
 	if (bmp) {
 		for (j = 0; j < 512; j++) {
-			unsigned k;
-			if (!bmp[j]) continue;
+			u32 k;
+			if (!le32_to_cpu(bmp[j])) continue;
 			for (k = 0xf; k; k <<= 4)
-				if ((bmp[j] & k) == k) {
+				if ((le32_to_cpu(bmp[j]) & k) == k) {
 					if (!--n) {
 						hpfs_brelse4(&qbh);
 						return 0;
@@ -355,12 +351,12 @@ void hpfs_free_dnode(struct super_block 
 		hpfs_free_sectors(s, dno, 4);
 	} else {
 		struct quad_buffer_head qbh;
-		unsigned *bmp;
+		u32 *bmp;
 		unsigned ssec = (dno - hpfs_sb(s)->sb_dirband_start) / 4;
 		if (!(bmp = hpfs_map_dnode_bitmap(s, &qbh))) {
 			return;
 		}
-		bmp[ssec >> 5] |= 1 << (ssec & 0x1f);
+		bmp[ssec >> 5] |= cpu_to_le32(1 << (ssec & 0x1f));
 		hpfs_mark_4buffers_dirty(&qbh);
 		hpfs_brelse4(&qbh);
 	}
@@ -382,13 +378,13 @@ struct dnode *hpfs_alloc_dnode(struct su
 		return NULL;
 	}
 	memset(d, 0, 2048);
-	d->magic = DNODE_MAGIC;
-	d->first_free = 52;
+	d->magic = cpu_to_le32(DNODE_MAGIC);
+	d->first_free = cpu_to_le32(52);
 	d->dirent[0] = 32;
 	d->dirent[2] = 8;
 	d->dirent[30] = 1;
 	d->dirent[31] = 255;
-	d->self = *dno;
+	d->self = cpu_to_le32(*dno);
 	return d;
 }
 
@@ -402,10 +398,10 @@ struct fnode *hpfs_alloc_fnode(struct su
 		return NULL;
 	}	
 	memset(f, 0, 512);
-	f->magic = FNODE_MAGIC;
-	f->ea_offs = 0xc4;
+	f->magic = cpu_to_le32(FNODE_MAGIC);
+	f->ea_offs = cpu_to_le16(0xc4);
 	f->btree.n_free_nodes = 8;
-	f->btree.first_free = 8;
+	f->btree.first_free = cpu_to_le16(8);
 	return f;
 }
 
@@ -419,10 +415,10 @@ struct anode *hpfs_alloc_anode(struct su
 		return NULL;
 	}
 	memset(a, 0, 512);
-	a->magic = ANODE_MAGIC;
-	a->self = *ano;
+	a->magic = cpu_to_le32(ANODE_MAGIC);
+	a->self = cpu_to_le32(*ano);
 	a->btree.n_free_nodes = 40;
 	a->btree.n_used_nodes = 0;
-	a->btree.first_free = 8;
+	a->btree.first_free = cpu_to_le16(8);
 	return a;
 }
Index: linux-2.6.39-rc5-fast/fs/hpfs/hpfs.h
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/hpfs.h	2011-05-05 01:02:51.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/hpfs.h	2011-05-05 01:02:57.000000000 +0200
@@ -19,6 +19,10 @@
    For definitive information on HPFS, ask somebody else -- this is guesswork.
    There are certain to be many mistakes. */
 
+#if !defined(__LITTLE_ENDIAN) && !defined(__BIG_ENDIAN)
+#error unknown endian
+#endif
+
 /* Notation */
 
 typedef u32 secno;			/* sector number, partition relative */
@@ -86,7 +90,6 @@ struct hpfs_super_block
   secno badblocks;			/* bad block list */
   u32 zero3;				/* 0 */
   time32_t last_chkdsk;			/* date last checked, 0 if never */
-  /*u32 zero4;*/			/* 0 */
   time32_t last_optimize;		/* date last optimized, 0 if never */
   secno n_dir_band;			/* number of sectors in dir band */
   secno dir_band_start;			/* first sector in dir band */
@@ -109,21 +112,44 @@ struct hpfs_spare_block
   u32 magic;				/* f991 1849 */
   u32 magic1;				/* fa52 29c5, more magic? */
 
-  unsigned dirty: 1;			/* 0 clean, 1 "improperly stopped" */
-  unsigned sparedir_used: 1;		/* spare dirblks used */
-  unsigned hotfixes_used: 1;		/* hotfixes used */
-  unsigned bad_sector: 1;		/* bad sector, corrupted disk (???) */
-  unsigned bad_bitmap: 1;		/* bad bitmap */
-  unsigned fast: 1;			/* partition was fast formatted */
-  unsigned old_wrote: 1;		/* old version wrote to partion */
-  unsigned old_wrote_1: 1;		/* old version wrote to partion (?) */
-  unsigned install_dasd_limits: 1;	/* HPFS386 flags */
-  unsigned resynch_dasd_limits: 1;
-  unsigned dasd_limits_operational: 1;
-  unsigned multimedia_active: 1;
-  unsigned dce_acls_active: 1;
-  unsigned dasd_limits_dirty: 1;
-  unsigned flag67: 2;
+#ifdef __LITTLE_ENDIAN
+  u8 dirty: 1;				/* 0 clean, 1 "improperly stopped" */
+  u8 sparedir_used: 1;			/* spare dirblks used */
+  u8 hotfixes_used: 1;			/* hotfixes used */
+  u8 bad_sector: 1;			/* bad sector, corrupted disk (???) */
+  u8 bad_bitmap: 1;			/* bad bitmap */
+  u8 fast: 1;				/* partition was fast formatted */
+  u8 old_wrote: 1;			/* old version wrote to partion */
+  u8 old_wrote_1: 1;			/* old version wrote to partion (?) */
+#else
+  u8 old_wrote_1: 1;			/* old version wrote to partion (?) */
+  u8 old_wrote: 1;			/* old version wrote to partion */
+  u8 fast: 1;				/* partition was fast formatted */
+  u8 bad_bitmap: 1;			/* bad bitmap */
+  u8 bad_sector: 1;			/* bad sector, corrupted disk (???) */
+  u8 hotfixes_used: 1;			/* hotfixes used */
+  u8 sparedir_used: 1;			/* spare dirblks used */
+  u8 dirty: 1;				/* 0 clean, 1 "improperly stopped" */
+#endif
+
+#ifdef __LITTLE_ENDIAN
+  u8 install_dasd_limits: 1;		/* HPFS386 flags */
+  u8 resynch_dasd_limits: 1;
+  u8 dasd_limits_operational: 1;
+  u8 multimedia_active: 1;
+  u8 dce_acls_active: 1;
+  u8 dasd_limits_dirty: 1;
+  u8 flag67: 2;
+#else
+  u8 flag67: 2;
+  u8 dasd_limits_dirty: 1;
+  u8 dce_acls_active: 1;
+  u8 multimedia_active: 1;
+  u8 dasd_limits_operational: 1;
+  u8 resynch_dasd_limits: 1;
+  u8 install_dasd_limits: 1;		/* HPFS386 flags */
+#endif
+
   u8 mm_contlgulty;
   u8 unused;
 
@@ -255,10 +281,18 @@ struct dnode {
   u32 magic;				/* 77e4 0aae */
   u32 first_free;			/* offset from start of dnode to
 					   first free dir entry */
-  unsigned root_dnode:1;		/* Is it root dnode? */
-  unsigned increment_me:31;		/* some kind of activity counter?
-					   Neither HPFS.IFS nor CHKDSK cares
+#ifdef __LITTLE_ENDIAN
+  u8 root_dnode: 1;			/* Is it root dnode? */
+  u8 increment_me: 7;			/* some kind of activity counter? */
+					/* Neither HPFS.IFS nor CHKDSK cares
+					   if you change this word */
+#else
+  u8 increment_me: 7;			/* some kind of activity counter? */
+					/* Neither HPFS.IFS nor CHKDSK cares
 					   if you change this word */
+  u8 root_dnode: 1;			/* Is it root dnode? */
+#endif
+  u8 increment_me2[3];
   secno up;				/* (root dnode) directory's fnode
 					   (nonroot) parent dnode */
   dnode_secno self;			/* pointer to this dnode */
@@ -266,33 +300,59 @@ struct dnode {
 };
 
 struct hpfs_dirent {
-  u16 length;			/* offset to next dirent */
-  unsigned first: 1;			/* set on phony ^A^A (".") entry */
-  unsigned has_acl: 1;
-  unsigned down: 1;			/* down pointer present (after name) */
-  unsigned last: 1;			/* set on phony \377 entry */
-  unsigned has_ea: 1;			/* entry has EA */
-  unsigned has_xtd_perm: 1;		/* has extended perm list (???) */
-  unsigned has_explicit_acl: 1;
-  unsigned has_needea: 1;		/* ?? some EA has NEEDEA set
+  u16 length;				/* offset to next dirent */
+
+#ifdef __LITTLE_ENDIAN
+  u8 first: 1;				/* set on phony ^A^A (".") entry */
+  u8 has_acl: 1;
+  u8 down: 1;				/* down pointer present (after name) */
+  u8 last: 1;				/* set on phony \377 entry */
+  u8 has_ea: 1;				/* entry has EA */
+  u8 has_xtd_perm: 1;			/* has extended perm list (???) */
+  u8 has_explicit_acl: 1;
+  u8 has_needea: 1;			/* ?? some EA has NEEDEA set
 					   I have no idea why this is
 					   interesting in a dir entry */
-  unsigned read_only: 1;		/* dos attrib */
-  unsigned hidden: 1;			/* dos attrib */
-  unsigned system: 1;			/* dos attrib */
-  unsigned flag11: 1;			/* would be volume label dos attrib */
-  unsigned directory: 1;		/* dos attrib */
-  unsigned archive: 1;			/* dos attrib */
-  unsigned not_8x3: 1;			/* name is not 8.3 */
-  unsigned flag15: 1;
+#else
+  u8 has_needea: 1;			/* ?? some EA has NEEDEA set
+					   I have no idea why this is
+					   interesting in a dir entry */
+  u8 has_explicit_acl: 1;
+  u8 has_xtd_perm: 1;			/* has extended perm list (???) */
+  u8 has_ea: 1;				/* entry has EA */
+  u8 last: 1;				/* set on phony \377 entry */
+  u8 down: 1;				/* down pointer present (after name) */
+  u8 has_acl: 1;
+  u8 first: 1;				/* set on phony ^A^A (".") entry */
+#endif
+
+#ifdef __LITTLE_ENDIAN
+  u8 read_only: 1;			/* dos attrib */
+  u8 hidden: 1;				/* dos attrib */
+  u8 system: 1;				/* dos attrib */
+  u8 flag11: 1;				/* would be volume label dos attrib */
+  u8 directory: 1;			/* dos attrib */
+  u8 archive: 1;			/* dos attrib */
+  u8 not_8x3: 1;			/* name is not 8.3 */
+  u8 flag15: 1;
+#else
+  u8 flag15: 1;
+  u8 not_8x3: 1;			/* name is not 8.3 */
+  u8 archive: 1;			/* dos attrib */
+  u8 directory: 1;			/* dos attrib */
+  u8 flag11: 1;				/* would be volume label dos attrib */
+  u8 system: 1;				/* dos attrib */
+  u8 hidden: 1;				/* dos attrib */
+  u8 read_only: 1;			/* dos attrib */
+#endif
+
   fnode_secno fnode;			/* fnode giving allocation info */
   time32_t write_date;			/* mtime */
   u32 file_size;			/* file length, bytes */
   time32_t read_date;			/* atime */
   time32_t creation_date;			/* ctime */
   u32 ea_size;				/* total EA length, bytes */
-  unsigned char no_of_acls : 3;		/* number of ACL's */
-  unsigned char reserver : 5;
+  u8 no_of_acls;			/* number of ACL's (low 3 bits) */
   u8 ix;				/* code page index (of filename), see
 					   struct code_page_data */
   u8 namelen, name[1];			/* file name */
@@ -328,21 +388,33 @@ struct bplus_internal_node
 
 struct bplus_header
 {
-  unsigned hbff: 1;	/* high bit of first free entry offset */
-  unsigned flag1: 1;
-  unsigned flag2: 1;
-  unsigned flag3: 1;
-  unsigned flag4: 1;
-  unsigned fnode_parent: 1;		/* ? we're pointed to by an fnode,
+#ifdef __LITTLE_ENDIAN
+  u8 hbff: 1;			/* high bit of first free entry offset */
+  u8 flag1234: 4;
+  u8 fnode_parent: 1;			/* ? we're pointed to by an fnode,
 					   the data btree or some ea or the
 					   main ea bootage pointer ea_secno */
 					/* also can get set in fnodes, which
 					   may be a chkdsk glitch or may mean
 					   this bit is irrelevant in fnodes,
 					   or this interpretation is all wet */
-  unsigned binary_search: 1;		/* suggest binary search (unused) */
-  unsigned internal: 1;			/* 1 -> (internal) tree of anodes
+  u8 binary_search: 1;			/* suggest binary search (unused) */
+  u8 internal: 1;			/* 1 -> (internal) tree of anodes
 					   0 -> (leaf) list of extents */
+#else
+  u8 internal: 1;			/* 1 -> (internal) tree of anodes
+					   0 -> (leaf) list of extents */
+  u8 binary_search: 1;			/* suggest binary search (unused) */
+  u8 fnode_parent: 1;			/* ? we're pointed to by an fnode,
+					   the data btree or some ea or the
+					   main ea bootage pointer ea_secno */
+					/* also can get set in fnodes, which
+					   may be a chkdsk glitch or may mean
+					   this bit is irrelevant in fnodes,
+					   or this interpretation is all wet */
+  u8 flag1234: 4;
+  u8 hbff: 1;			/* high bit of first free entry offset */
+#endif
   u8 fill[3];
   u8 n_free_nodes;			/* free nodes in following array */
   u8 n_used_nodes;			/* used nodes in following array */
@@ -379,23 +451,25 @@ struct fnode
   secno ea_secno;			/* first sector of disk-resident ea's*/
   u16 ea_size_s;			/* length of fnode-resident ea's */
 
-  unsigned flag0: 1;
-  unsigned ea_anode: 1;			/* 1 -> ea_secno is an anode */
-  unsigned flag2: 1;
-  unsigned flag3: 1;
-  unsigned flag4: 1;
-  unsigned flag5: 1;
-  unsigned flag6: 1;
-  unsigned flag7: 1;
-  unsigned dirflag: 1;			/* 1 -> directory.  first & only extent
+#ifdef __LITTLE_ENDIAN
+  u8 flag0: 1;
+  u8 ea_anode: 1;			/* 1 -> ea_secno is an anode */
+  u8 flag234567: 6;
+#else
+  u8 flag234567: 6;
+  u8 ea_anode: 1;			/* 1 -> ea_secno is an anode */
+  u8 flag0: 1;
+#endif
+
+#ifdef __LITTLE_ENDIAN
+  u8 dirflag: 1;			/* 1 -> directory.  first & only extent
+					   points to dnode. */
+  u8 flag9012345: 7;
+#else
+  u8 flag9012345: 7;
+  u8 dirflag: 1;			/* 1 -> directory.  first & only extent
 					   points to dnode. */
-  unsigned flag9: 1;
-  unsigned flag10: 1;
-  unsigned flag11: 1;
-  unsigned flag12: 1;
-  unsigned flag13: 1;
-  unsigned flag14: 1;
-  unsigned flag15: 1;
+#endif
 
   struct bplus_header btree;		/* b+ tree, 8 extents or 12 subtrees */
   union {
@@ -456,16 +530,21 @@ struct anode
 
 struct extended_attribute
 {
-  unsigned indirect: 1;			/* 1 -> value gives sector number
+#ifdef __LITTLE_ENDIAN
+  u8 indirect: 1;			/* 1 -> value gives sector number
 					   where real value starts */
-  unsigned anode: 1;			/* 1 -> sector is an anode
+  u8 anode: 1;				/* 1 -> sector is an anode
 					   that points to fragmented value */
-  unsigned flag2: 1;
-  unsigned flag3: 1;
-  unsigned flag4: 1;
-  unsigned flag5: 1;
-  unsigned flag6: 1;
-  unsigned needea: 1;			/* required ea */
+  u8 flag23456: 5;
+  u8 needea: 1;				/* required ea */
+#else
+  u8 needea: 1;				/* required ea */
+  u8 flag23456: 5;
+  u8 anode: 1;				/* 1 -> sector is an anode
+					   that points to fragmented value */
+  u8 indirect: 1;			/* 1 -> value gives sector number
+					   where real value starts */
+#endif
   u8 namelen;				/* length of name, bytes */
   u16 valuelen;				/* length of value, bytes */
   u8 name[0];
Index: linux-2.6.39-rc5-fast/fs/hpfs/hpfs_fn.h
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/hpfs_fn.h	2011-05-05 01:02:47.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/hpfs_fn.h	2011-05-05 01:02:58.000000000 +0200
@@ -84,7 +84,6 @@ struct hpfs_sb_info {
 	unsigned *sb_bmp_dir;		/* main bitmap directory */
 	unsigned sb_c_bitmap;		/* current bitmap */
 	unsigned sb_max_fwd_alloc;	/* max forwad allocation */
-	/*unsigned sb_mounting : 1;*/
 	int sb_timeshift;
 };
 
@@ -100,7 +99,7 @@ struct quad_buffer_head {
 static inline dnode_secno de_down_pointer (struct hpfs_dirent *de)
 {
   CHKCOND(de->down,("HPFS: de_down_pointer: !de->down\n"));
-  return *(dnode_secno *) ((void *) de + de->length - 4);
+  return le32_to_cpu(*(dnode_secno *) ((void *) de + le16_to_cpu(de->length) - 4));
 }
 
 /* The first dir entry in a dnode */
@@ -114,41 +113,41 @@ static inline struct hpfs_dirent *dnode_
 
 static inline struct hpfs_dirent *dnode_end_de (struct dnode *dnode)
 {
-  CHKCOND(dnode->first_free>=0x14 && dnode->first_free<=0xa00,("HPFS: dnode_end_de: dnode->first_free = %d\n",(int)dnode->first_free));
-  return (void *) dnode + dnode->first_free;
+  CHKCOND(le32_to_cpu(dnode->first_free)>=0x14 && le32_to_cpu(dnode->first_free)<=0xa00,("HPFS: dnode_end_de: dnode->first_free = %x\n",(unsigned)le32_to_cpu(dnode->first_free)));
+  return (void *) dnode + le32_to_cpu(dnode->first_free);
 }
 
 /* The dir entry after dir entry de */
 
 static inline struct hpfs_dirent *de_next_de (struct hpfs_dirent *de)
 {
-  CHKCOND(de->length>=0x20 && de->length<0x800,("HPFS: de_next_de: de->length = %d\n",(int)de->length));
-  return (void *) de + de->length;
+  CHKCOND(le16_to_cpu(de->length)>=0x20 && le16_to_cpu(de->length)<0x800,("HPFS: de_next_de: de->length = %x\n",(unsigned)le16_to_cpu(de->length)));
+  return (void *) de + le16_to_cpu(de->length);
 }
 
 static inline struct extended_attribute *fnode_ea(struct fnode *fnode)
 {
-	return (struct extended_attribute *)((char *)fnode + fnode->ea_offs + fnode->acl_size_s);
+	return (struct extended_attribute *)((char *)fnode + le16_to_cpu(fnode->ea_offs) + le16_to_cpu(fnode->acl_size_s));
 }
 
 static inline struct extended_attribute *fnode_end_ea(struct fnode *fnode)
 {
-	return (struct extended_attribute *)((char *)fnode + fnode->ea_offs + fnode->acl_size_s + fnode->ea_size_s);
+	return (struct extended_attribute *)((char *)fnode + le16_to_cpu(fnode->ea_offs) + le16_to_cpu(fnode->acl_size_s) + le16_to_cpu(fnode->ea_size_s));
 }
 
 static inline struct extended_attribute *next_ea(struct extended_attribute *ea)
 {
-	return (struct extended_attribute *)((char *)ea + 5 + ea->namelen + ea->valuelen);
+	return (struct extended_attribute *)((char *)ea + 5 + ea->namelen + le16_to_cpu(ea->valuelen));
 }
 
 static inline secno ea_sec(struct extended_attribute *ea)
 {
-	return *(secno *)((char *)ea + 9 + ea->namelen);
+	return le32_to_cpu(*((secno *)((char *)ea + 9 + ea->namelen)));
 }
 
 static inline secno ea_len(struct extended_attribute *ea)
 {
-	return *(secno *)((char *)ea + 5 + ea->namelen);
+	return le32_to_cpu(*((secno *)((char *)ea + 5 + ea->namelen)));
 }
 
 static inline char *ea_data(struct extended_attribute *ea)
@@ -173,13 +172,13 @@ static inline void copy_de(struct hpfs_d
 	dst->not_8x3 = n;
 }
 
-static inline unsigned tstbits(unsigned *bmp, unsigned b, unsigned n)
+static inline unsigned tstbits(u32 *bmp, unsigned b, unsigned n)
 {
 	int i;
 	if ((b >= 0x4000) || (b + n - 1 >= 0x4000)) return n;
-	if (!((bmp[(b & 0x3fff) >> 5] >> (b & 0x1f)) & 1)) return 1;
+	if (!((le32_to_cpu(bmp[(b & 0x3fff) >> 5]) >> (b & 0x1f)) & 1)) return 1;
 	for (i = 1; i < n; i++)
-		if (/*b+i < 0x4000 &&*/ !((bmp[((b+i) & 0x3fff) >> 5] >> ((b+i) & 0x1f)) & 1))
+		if (!((le32_to_cpu(bmp[((b+i) & 0x3fff) >> 5]) >> ((b+i) & 0x1f)) & 1))
 			return i + 1;
 	return 0;
 }
Index: linux-2.6.39-rc5-fast/fs/hpfs/map.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/map.c	2011-05-05 01:01:52.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/map.c	2011-05-05 01:02:58.000000000 +0200
@@ -21,7 +21,7 @@ unsigned int *hpfs_map_bitmap(struct sup
 		hpfs_error(s, "hpfs_map_bitmap called with bad parameter: %08x at %s", bmp_block, id);
 		return NULL;
 	}
-	sec = hpfs_sb(s)->sb_bmp_dir[bmp_block];
+	sec = le32_to_cpu(hpfs_sb(s)->sb_bmp_dir[bmp_block]);
 	if (!sec || sec > hpfs_sb(s)->sb_fs_size-4) {
 		hpfs_error(s, "invalid bitmap block pointer %08x -> %08x at %s", bmp_block, sec, id);
 		return NULL;
@@ -46,18 +46,18 @@ unsigned char *hpfs_load_code_page(struc
 	struct code_page_data *cpd;
 	struct code_page_directory *cp = hpfs_map_sector(s, cps, &bh, 0);
 	if (!cp) return NULL;
-	if (cp->magic != CP_DIR_MAGIC) {
-		printk("HPFS: Code page directory magic doesn't match (magic = %08x)\n", cp->magic);
+	if (le32_to_cpu(cp->magic) != CP_DIR_MAGIC) {
+		printk("HPFS: Code page directory magic doesn't match (magic = %08x)\n", le32_to_cpu(cp->magic));
 		brelse(bh);
 		return NULL;
 	}
-	if (!cp->n_code_pages) {
+	if (!le32_to_cpu(cp->n_code_pages)) {
 		printk("HPFS: n_code_pages == 0\n");
 		brelse(bh);
 		return NULL;
 	}
-	cpds = cp->array[0].code_page_data;
-	cpi = cp->array[0].index;
+	cpds = le32_to_cpu(cp->array[0].code_page_data);
+	cpi = le16_to_cpu(cp->array[0].index);
 	brelse(bh);
 
 	if (cpi >= 3) {
@@ -66,12 +66,12 @@ unsigned char *hpfs_load_code_page(struc
 	}
 	
 	if (!(cpd = hpfs_map_sector(s, cpds, &bh, 0))) return NULL;
-	if ((unsigned)cpd->offs[cpi] > 0x178) {
+	if (le16_to_cpu(cpd->offs[cpi]) > 0x178) {
 		printk("HPFS: Code page index out of sector\n");
 		brelse(bh);
 		return NULL;
 	}
-	ptr = (unsigned char *)cpd + cpd->offs[cpi] + 6;
+	ptr = (unsigned char *)cpd + le16_to_cpu(cpd->offs[cpi]) + 6;
 	if (!(cp_table = kmalloc(256, GFP_KERNEL))) {
 		printk("HPFS: out of memory for code page table\n");
 		brelse(bh);
@@ -125,7 +125,7 @@ struct fnode *hpfs_map_fnode(struct supe
 		if (hpfs_sb(s)->sb_chk) {
 			struct extended_attribute *ea;
 			struct extended_attribute *ea_end;
-			if (fnode->magic != FNODE_MAGIC) {
+			if (le32_to_cpu(fnode->magic) != FNODE_MAGIC) {
 				hpfs_error(s, "bad magic on fnode %08lx",
 					(unsigned long)ino);
 				goto bail;
@@ -138,7 +138,7 @@ struct fnode *hpfs_map_fnode(struct supe
 					    (unsigned long)ino);
 					goto bail;
 				}
-				if (fnode->btree.first_free !=
+				if (le16_to_cpu(fnode->btree.first_free) !=
 				    8 + fnode->btree.n_used_nodes * (fnode->btree.internal ? 8 : 12)) {
 					hpfs_error(s,
 					    "bad first_free pointer in fnode %08lx",
@@ -146,12 +146,12 @@ struct fnode *hpfs_map_fnode(struct supe
 					goto bail;
 				}
 			}
-			if (fnode->ea_size_s && ((signed int)fnode->ea_offs < 0xc4 ||
-			   (signed int)fnode->ea_offs + fnode->acl_size_s + fnode->ea_size_s > 0x200)) {
+			if (le16_to_cpu(fnode->ea_size_s) && (le16_to_cpu(fnode->ea_offs) < 0xc4 ||
+			   le16_to_cpu(fnode->ea_offs) + le16_to_cpu(fnode->acl_size_s) + le16_to_cpu(fnode->ea_size_s) > 0x200)) {
 				hpfs_error(s,
 					"bad EA info in fnode %08lx: ea_offs == %04x ea_size_s == %04x",
 					(unsigned long)ino,
-					fnode->ea_offs, fnode->ea_size_s);
+					le16_to_cpu(fnode->ea_offs), le16_to_cpu(fnode->ea_size_s));
 				goto bail;
 			}
 			ea = fnode_ea(fnode);
@@ -178,16 +178,20 @@ struct anode *hpfs_map_anode(struct supe
 	if (hpfs_sb(s)->sb_chk) if (hpfs_chk_sectors(s, ano, 1, "anode")) return NULL;
 	if ((anode = hpfs_map_sector(s, ano, bhp, ANODE_RD_AHEAD)))
 		if (hpfs_sb(s)->sb_chk) {
-			if (anode->magic != ANODE_MAGIC || anode->self != ano) {
+			if (le32_to_cpu(anode->magic) != ANODE_MAGIC) {
 				hpfs_error(s, "bad magic on anode %08x", ano);
 				goto bail;
 			}
+			if (le32_to_cpu(anode->self) != ano) {
+				hpfs_error(s, "self pointer invalid on anode %08x", ano);
+				goto bail;
+			}
 			if ((unsigned)anode->btree.n_used_nodes + (unsigned)anode->btree.n_free_nodes !=
 			    (anode->btree.internal ? 60 : 40)) {
 				hpfs_error(s, "bad number of nodes in anode %08x", ano);
 				goto bail;
 			}
-			if (anode->btree.first_free !=
+			if (le16_to_cpu(anode->btree.first_free) !=
 			    8 + anode->btree.n_used_nodes * (anode->btree.internal ? 8 : 12)) {
 				hpfs_error(s, "bad first_free pointer in anode %08x", ano);
 				goto bail;
@@ -219,26 +223,26 @@ struct dnode *hpfs_map_dnode(struct supe
 			unsigned p, pp = 0;
 			unsigned char *d = (unsigned char *)dnode;
 			int b = 0;
-			if (dnode->magic != DNODE_MAGIC) {
+			if (le32_to_cpu(dnode->magic) != DNODE_MAGIC) {
 				hpfs_error(s, "bad magic on dnode %08x", secno);
 				goto bail;
 			}
-			if (dnode->self != secno)
-				hpfs_error(s, "bad self pointer on dnode %08x self = %08x", secno, dnode->self);
+			if (le32_to_cpu(dnode->self) != secno)
+				hpfs_error(s, "bad self pointer on dnode %08x self = %08x", secno, le32_to_cpu(dnode->self));
 			/* Check dirents - bad dirents would cause infinite
 			   loops or shooting to memory */
-			if (dnode->first_free > 2048/* || dnode->first_free < 84*/) {
-				hpfs_error(s, "dnode %08x has first_free == %08x", secno, dnode->first_free);
+			if (le32_to_cpu(dnode->first_free) > 2048) {
+				hpfs_error(s, "dnode %08x has first_free == %08x", secno, le32_to_cpu(dnode->first_free));
 				goto bail;
 			}
-			for (p = 20; p < dnode->first_free; p += d[p] + (d[p+1] << 8)) {
+			for (p = 20; p < le32_to_cpu(dnode->first_free); p += d[p] + (d[p+1] << 8)) {
 				struct hpfs_dirent *de = (struct hpfs_dirent *)((char *)dnode + p);
-				if (de->length > 292 || (de->length < 32) || (de->length & 3) || p + de->length > 2048) {
+				if (le16_to_cpu(de->length) > 292 || (le16_to_cpu(de->length) < 32) || (le16_to_cpu(de->length) & 3) || p + le16_to_cpu(de->length) > 2048) {
 					hpfs_error(s, "bad dirent size in dnode %08x, dirent %03x, last %03x", secno, p, pp);
 					goto bail;
 				}
-				if (((31 + de->namelen + de->down*4 + 3) & ~3) != de->length) {
-					if (((31 + de->namelen + de->down*4 + 3) & ~3) < de->length && s->s_flags & MS_RDONLY) goto ok;
+				if (((31 + de->namelen + de->down*4 + 3) & ~3) != le16_to_cpu(de->length)) {
+					if (((31 + de->namelen + de->down*4 + 3) & ~3) < le16_to_cpu(de->length) && s->s_flags & MS_RDONLY) goto ok;
 					hpfs_error(s, "namelen does not match dirent size in dnode %08x, dirent %03x, last %03x", secno, p, pp);
 					goto bail;
 				}
@@ -251,7 +255,7 @@ struct dnode *hpfs_map_dnode(struct supe
 				pp = p;
 				
 			}
-			if (p != dnode->first_free) {
+			if (p != le32_to_cpu(dnode->first_free)) {
 				hpfs_error(s, "size on last dirent does not match first_free; dnode %08x", secno);
 				goto bail;
 			}
@@ -277,7 +281,7 @@ dnode_secno hpfs_fnode_dno(struct super_
 	if (!fnode)
 		return 0;
 
-	dno = fnode->u.external[0].disk_secno;
+	dno = le32_to_cpu(fnode->u.external[0].disk_secno);
 	brelse(bh);
 	return dno;
 }
Index: linux-2.6.39-rc5-fast/fs/hpfs/super.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/super.c	2011-05-05 01:02:55.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/super.c	2011-05-05 01:02:58.000000000 +0200
@@ -135,7 +135,7 @@ static unsigned count_bitmaps(struct sup
 	n_bands = (hpfs_sb(s)->sb_fs_size + 0x3fff) >> 14;
 	count = 0;
 	for (n = 0; n < n_bands; n++)
-		count += hpfs_count_one_bitmap(s, hpfs_sb(s)->sb_bmp_dir[n]);
+		count += hpfs_count_one_bitmap(s, le32_to_cpu(hpfs_sb(s)->sb_bmp_dir[n]));
 	return count;
 }
 
@@ -509,9 +509,9 @@ static int hpfs_fill_super(struct super_
 	if (!(spareblock = hpfs_map_sector(s, 17, &bh2, 0))) goto bail3;
 
 	/* Check magics */
-	if (/*bootblock->magic != BB_MAGIC
-	    ||*/ superblock->magic != SB_MAGIC
-	    || spareblock->magic != SP_MAGIC) {
+	if (/*le16_to_cpu(bootblock->magic) != BB_MAGIC
+	    ||*/ le32_to_cpu(superblock->magic) != SB_MAGIC
+	    || le32_to_cpu(spareblock->magic) != SP_MAGIC) {
 		if (!silent) printk("HPFS: Bad magic ... probably not HPFS\n");
 		goto bail4;
 	}
@@ -532,12 +532,12 @@ static int hpfs_fill_super(struct super_
 	s->s_op = &hpfs_sops;
 	s->s_d_op = &hpfs_dentry_operations;
 
-	sbi->sb_root = superblock->root;
-	sbi->sb_fs_size = superblock->n_sectors;
-	sbi->sb_bitmaps = superblock->bitmaps;
-	sbi->sb_dirband_start = superblock->dir_band_start;
-	sbi->sb_dirband_size = superblock->n_dir_band;
-	sbi->sb_dmap = superblock->dir_band_bitmap;
+	sbi->sb_root = le32_to_cpu(superblock->root);
+	sbi->sb_fs_size = le32_to_cpu(superblock->n_sectors);
+	sbi->sb_bitmaps = le32_to_cpu(superblock->bitmaps);
+	sbi->sb_dirband_start = le32_to_cpu(superblock->dir_band_start);
+	sbi->sb_dirband_size = le32_to_cpu(superblock->n_dir_band);
+	sbi->sb_dmap = le32_to_cpu(superblock->dir_band_bitmap);
 	sbi->sb_uid = uid;
 	sbi->sb_gid = gid;
 	sbi->sb_mode = 0777 & ~umask;
@@ -555,7 +555,7 @@ static int hpfs_fill_super(struct super_
 	sbi->sb_max_fwd_alloc = 0xffffff;
 	
 	/* Load bitmap directory */
-	if (!(sbi->sb_bmp_dir = hpfs_load_bitmap_directory(s, superblock->bitmaps)))
+	if (!(sbi->sb_bmp_dir = hpfs_load_bitmap_directory(s, le32_to_cpu(superblock->bitmaps))))
 		goto bail4;
 	
 	/* Check for general fs errors*/
@@ -573,7 +573,7 @@ static int hpfs_fill_super(struct super_
 		mark_buffer_dirty(bh2);
 	}
 
-	if (spareblock->hotfixes_used || spareblock->n_spares_used) {
+	if (le32_to_cpu(spareblock->hotfixes_used) || le32_to_cpu(spareblock->n_spares_used)) {
 		if (errs >= 2) {
 			printk("HPFS: Hotfixes not supported here, try chkdsk\n");
 			mark_dirty(s, 0);
@@ -583,7 +583,7 @@ static int hpfs_fill_super(struct super_
 		if (errs == 0) printk("HPFS: Proceeding, but your filesystem will be probably corrupted by this driver...\n");
 		else printk("HPFS: This driver may read bad files or crash when operating on disk with hotfixes.\n");
 	}
-	if (spareblock->n_dnode_spares != spareblock->n_dnode_spares_free) {
+	if (le32_to_cpu(spareblock->n_dnode_spares) != le32_to_cpu(spareblock->n_dnode_spares_free)) {
 		if (errs >= 2) {
 			printk("HPFS: Spare dnodes used, try chkdsk\n");
 			mark_dirty(s, 0);
@@ -594,17 +594,17 @@ static int hpfs_fill_super(struct super_
 	}
 	if (chk) {
 		unsigned a;
-		if (superblock->dir_band_end - superblock->dir_band_start + 1 != superblock->n_dir_band ||
-		    superblock->dir_band_end < superblock->dir_band_start || superblock->n_dir_band > 0x4000) {
+		if (le32_to_cpu(superblock->dir_band_end) - le32_to_cpu(superblock->dir_band_start) + 1 != le32_to_cpu(superblock->n_dir_band) ||
+		    le32_to_cpu(superblock->dir_band_end) < le32_to_cpu(superblock->dir_band_start) || le32_to_cpu(superblock->n_dir_band) > 0x4000) {
 			hpfs_error(s, "dir band size mismatch: dir_band_start==%08x, dir_band_end==%08x, n_dir_band==%08x",
-				superblock->dir_band_start, superblock->dir_band_end, superblock->n_dir_band);
+				le32_to_cpu(superblock->dir_band_start), le32_to_cpu(superblock->dir_band_end), le32_to_cpu(superblock->n_dir_band));
 			goto bail4;
 		}
 		a = sbi->sb_dirband_size;
 		sbi->sb_dirband_size = 0;
-		if (hpfs_chk_sectors(s, superblock->dir_band_start, superblock->n_dir_band, "dir_band") ||
-		    hpfs_chk_sectors(s, superblock->dir_band_bitmap, 4, "dir_band_bitmap") ||
-		    hpfs_chk_sectors(s, superblock->bitmaps, 4, "bitmaps")) {
+		if (hpfs_chk_sectors(s, le32_to_cpu(superblock->dir_band_start), le32_to_cpu(superblock->n_dir_band), "dir_band") ||
+		    hpfs_chk_sectors(s, le32_to_cpu(superblock->dir_band_bitmap), 4, "dir_band_bitmap") ||
+		    hpfs_chk_sectors(s, le32_to_cpu(superblock->bitmaps), 4, "bitmaps")) {
 			mark_dirty(s, 0);
 			goto bail4;
 		}
@@ -612,8 +612,8 @@ static int hpfs_fill_super(struct super_
 	} else printk("HPFS: You really don't want any checks? You are crazy...\n");
 
 	/* Load code page table */
-	if (spareblock->n_code_pages)
-		if (!(sbi->sb_cp_table = hpfs_load_code_page(s, spareblock->code_page_dir)))
+	if (le32_to_cpu(spareblock->n_code_pages))
+		if (!(sbi->sb_cp_table = hpfs_load_code_page(s, le32_to_cpu(spareblock->code_page_dir))))
 			printk("HPFS: Warning: code page support is disabled\n");
 
 	brelse(bh2);
@@ -642,13 +642,13 @@ static int hpfs_fill_super(struct super_
 	if (!de)
 		hpfs_error(s, "unable to find root dir");
 	else {
-		root->i_atime.tv_sec = local_to_gmt(s, de->read_date);
+		root->i_atime.tv_sec = local_to_gmt(s, le32_to_cpu(de->read_date));
 		root->i_atime.tv_nsec = 0;
-		root->i_mtime.tv_sec = local_to_gmt(s, de->write_date);
+		root->i_mtime.tv_sec = local_to_gmt(s, le32_to_cpu(de->write_date));
 		root->i_mtime.tv_nsec = 0;
-		root->i_ctime.tv_sec = local_to_gmt(s, de->creation_date);
+		root->i_ctime.tv_sec = local_to_gmt(s, le32_to_cpu(de->creation_date));
 		root->i_ctime.tv_nsec = 0;
-		hpfs_i(root)->i_ea_size = de->ea_size;
+		hpfs_i(root)->i_ea_size = le16_to_cpu(de->ea_size);
 		hpfs_i(root)->i_parent_dir = root->i_ino;
 		if (root->i_size == -1)
 			root->i_size = 2048;
Index: linux-2.6.39-rc5-fast/fs/hpfs/anode.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/anode.c	2011-05-05 01:02:45.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/anode.c	2011-05-05 01:02:58.000000000 +0200
@@ -22,8 +22,8 @@ secno hpfs_bplus_lookup(struct super_blo
 	if (hpfs_sb(s)->sb_chk) if (hpfs_stop_cycles(s, a, &c1, &c2, "hpfs_bplus_lookup")) return -1;
 	if (btree->internal) {
 		for (i = 0; i < btree->n_used_nodes; i++)
-			if (btree->u.internal[i].file_secno > sec) {
-				a = btree->u.internal[i].down;
+			if (le32_to_cpu(btree->u.internal[i].file_secno) > sec) {
+				a = le32_to_cpu(btree->u.internal[i].down);
 				brelse(bh);
 				if (!(anode = hpfs_map_anode(s, a, &bh))) return -1;
 				btree = &anode->btree;
@@ -34,18 +34,18 @@ secno hpfs_bplus_lookup(struct super_blo
 		return -1;
 	}
 	for (i = 0; i < btree->n_used_nodes; i++)
-		if (btree->u.external[i].file_secno <= sec &&
-		    btree->u.external[i].file_secno + btree->u.external[i].length > sec) {
-			a = btree->u.external[i].disk_secno + sec - btree->u.external[i].file_secno;
+		if (le32_to_cpu(btree->u.external[i].file_secno) <= sec &&
+		    le32_to_cpu(btree->u.external[i].file_secno) + le32_to_cpu(btree->u.external[i].length) > sec) {
+			a = le32_to_cpu(btree->u.external[i].disk_secno) + sec - le32_to_cpu(btree->u.external[i].file_secno);
 			if (hpfs_sb(s)->sb_chk) if (hpfs_chk_sectors(s, a, 1, "data")) {
 				brelse(bh);
 				return -1;
 			}
 			if (inode) {
 				struct hpfs_inode_info *hpfs_inode = hpfs_i(inode);
-				hpfs_inode->i_file_sec = btree->u.external[i].file_secno;
-				hpfs_inode->i_disk_sec = btree->u.external[i].disk_secno;
-				hpfs_inode->i_n_secs = btree->u.external[i].length;
+				hpfs_inode->i_file_sec = le32_to_cpu(btree->u.external[i].file_secno);
+				hpfs_inode->i_disk_sec = le32_to_cpu(btree->u.external[i].disk_secno);
+				hpfs_inode->i_n_secs = le32_to_cpu(btree->u.external[i].length);
 			}
 			brelse(bh);
 			return a;
@@ -83,8 +83,8 @@ secno hpfs_add_sector_to_btree(struct su
 		return -1;
 	}
 	if (btree->internal) {
-		a = btree->u.internal[n].down;
-		btree->u.internal[n].file_secno = -1;
+		a = le32_to_cpu(btree->u.internal[n].down);
+		btree->u.internal[n].file_secno = cpu_to_le32(-1);
 		mark_buffer_dirty(bh);
 		brelse(bh);
 		if (hpfs_sb(s)->sb_chk)
@@ -94,15 +94,15 @@ secno hpfs_add_sector_to_btree(struct su
 		goto go_down;
 	}
 	if (n >= 0) {
-		if (btree->u.external[n].file_secno + btree->u.external[n].length != fsecno) {
+		if (le32_to_cpu(btree->u.external[n].file_secno) + le32_to_cpu(btree->u.external[n].length) != fsecno) {
 			hpfs_error(s, "allocated size %08x, trying to add sector %08x, %cnode %08x",
-				btree->u.external[n].file_secno + btree->u.external[n].length, fsecno,
+				le32_to_cpu(btree->u.external[n].file_secno) + le32_to_cpu(btree->u.external[n].length), fsecno,
 				fnod?'f':'a', node);
 			brelse(bh);
 			return -1;
 		}
-		if (hpfs_alloc_if_possible(s, se = btree->u.external[n].disk_secno + btree->u.external[n].length)) {
-			btree->u.external[n].length++;
+		if (hpfs_alloc_if_possible(s, se = le32_to_cpu(btree->u.external[n].disk_secno) + le32_to_cpu(btree->u.external[n].length))) {
+			btree->u.external[n].length = cpu_to_le32(le32_to_cpu(btree->u.external[n].length) + 1);
 			mark_buffer_dirty(bh);
 			brelse(bh);
 			return se;
@@ -119,16 +119,16 @@ secno hpfs_add_sector_to_btree(struct su
 		brelse(bh);
 		return -1;
 	}
-	fs = n < 0 ? 0 : btree->u.external[n].file_secno + btree->u.external[n].length;
+	fs = n < 0 ? 0 : le32_to_cpu(btree->u.external[n].file_secno) + le32_to_cpu(btree->u.external[n].length);
 	if (!btree->n_free_nodes) {
-		up = a != node ? anode->up : -1;
+		up = a != node ? le32_to_cpu(anode->up) : -1;
 		if (!(anode = hpfs_alloc_anode(s, a, &na, &bh1))) {
 			brelse(bh);
 			hpfs_free_sectors(s, se, 1);
 			return -1;
 		}
 		if (a == node && fnod) {
-			anode->up = node;
+			anode->up = cpu_to_le32(node);
 			anode->btree.fnode_parent = 1;
 			anode->btree.n_used_nodes = btree->n_used_nodes;
 			anode->btree.first_free = btree->first_free;
@@ -137,9 +137,9 @@ secno hpfs_add_sector_to_btree(struct su
 			btree->internal = 1;
 			btree->n_free_nodes = 11;
 			btree->n_used_nodes = 1;
-			btree->first_free = (char *)&(btree->u.internal[1]) - (char *)btree;
-			btree->u.internal[0].file_secno = -1;
-			btree->u.internal[0].down = na;
+			btree->first_free = cpu_to_le16((char *)&(btree->u.internal[1]) - (char *)btree);
+			btree->u.internal[0].file_secno = cpu_to_le32(-1);
+			btree->u.internal[0].down = cpu_to_le32(na);
 			mark_buffer_dirty(bh);
 		} else if (!(ranode = hpfs_alloc_anode(s, /*a*/0, &ra, &bh2))) {
 			brelse(bh);
@@ -153,15 +153,15 @@ secno hpfs_add_sector_to_btree(struct su
 		btree = &anode->btree;
 	}
 	btree->n_free_nodes--; n = btree->n_used_nodes++;
-	btree->first_free += 12;
-	btree->u.external[n].disk_secno = se;
-	btree->u.external[n].file_secno = fs;
-	btree->u.external[n].length = 1;
+	btree->first_free = cpu_to_le16(le16_to_cpu(btree->first_free) + 12);
+	btree->u.external[n].disk_secno = cpu_to_le32(se);
+	btree->u.external[n].file_secno = cpu_to_le32(fs);
+	btree->u.external[n].length = cpu_to_le32(1);
 	mark_buffer_dirty(bh);
 	brelse(bh);
 	if ((a == node && fnod) || na == -1) return se;
 	c2 = 0;
-	while (up != -1) {
+	while (up != (anode_secno)-1) {
 		struct anode *new_anode;
 		if (hpfs_sb(s)->sb_chk)
 			if (hpfs_stop_cycles(s, up, &c1, &c2, "hpfs_add_sector_to_btree #2")) return -1;
@@ -174,47 +174,47 @@ secno hpfs_add_sector_to_btree(struct su
 		}
 		if (btree->n_free_nodes) {
 			btree->n_free_nodes--; n = btree->n_used_nodes++;
-			btree->first_free += 8;
-			btree->u.internal[n].file_secno = -1;
-			btree->u.internal[n].down = na;
-			btree->u.internal[n-1].file_secno = fs;
+			btree->first_free = cpu_to_le16(le16_to_cpu(btree->first_free) + 8);
+			btree->u.internal[n].file_secno = cpu_to_le32(-1);
+			btree->u.internal[n].down = cpu_to_le32(na);
+			btree->u.internal[n-1].file_secno = cpu_to_le32(fs);
 			mark_buffer_dirty(bh);
 			brelse(bh);
 			brelse(bh2);
 			hpfs_free_sectors(s, ra, 1);
 			if ((anode = hpfs_map_anode(s, na, &bh))) {
-				anode->up = up;
+				anode->up = cpu_to_le32(up);
 				anode->btree.fnode_parent = up == node && fnod;
 				mark_buffer_dirty(bh);
 				brelse(bh);
 			}
 			return se;
 		}
-		up = up != node ? anode->up : -1;
-		btree->u.internal[btree->n_used_nodes - 1].file_secno = /*fs*/-1;
+		up = up != node ? le32_to_cpu(anode->up) : -1;
+		btree->u.internal[btree->n_used_nodes - 1].file_secno = cpu_to_le32(/*fs*/-1);
 		mark_buffer_dirty(bh);
 		brelse(bh);
 		a = na;
 		if ((new_anode = hpfs_alloc_anode(s, a, &na, &bh))) {
 			anode = new_anode;
-			/*anode->up = up != -1 ? up : ra;*/
+			/*anode->up = cpu_to_le32(up != -1 ? up : ra);*/
 			anode->btree.internal = 1;
 			anode->btree.n_used_nodes = 1;
 			anode->btree.n_free_nodes = 59;
-			anode->btree.first_free = 16;
-			anode->btree.u.internal[0].down = a;
-			anode->btree.u.internal[0].file_secno = -1;
+			anode->btree.first_free = cpu_to_le16(16);
+			anode->btree.u.internal[0].down = cpu_to_le32(a);
+			anode->btree.u.internal[0].file_secno = cpu_to_le32(-1);
 			mark_buffer_dirty(bh);
 			brelse(bh);
 			if ((anode = hpfs_map_anode(s, a, &bh))) {
-				anode->up = na;
+				anode->up = cpu_to_le32(na);
 				mark_buffer_dirty(bh);
 				brelse(bh);
 			}
 		} else na = a;
 	}
 	if ((anode = hpfs_map_anode(s, na, &bh))) {
-		anode->up = node;
+		anode->up = cpu_to_le32(node);
 		if (fnod) anode->btree.fnode_parent = 1;
 		mark_buffer_dirty(bh);
 		brelse(bh);
@@ -232,14 +232,14 @@ secno hpfs_add_sector_to_btree(struct su
 		}
 		btree = &fnode->btree;
 	}
-	ranode->up = node;
-	memcpy(&ranode->btree, btree, btree->first_free);
+	ranode->up = cpu_to_le32(node);
+	memcpy(&ranode->btree, btree, le16_to_cpu(btree->first_free));
 	if (fnod) ranode->btree.fnode_parent = 1;
 	ranode->btree.n_free_nodes = (ranode->btree.internal ? 60 : 40) - ranode->btree.n_used_nodes;
 	if (ranode->btree.internal) for (n = 0; n < ranode->btree.n_used_nodes; n++) {
 		struct anode *unode;
-		if ((unode = hpfs_map_anode(s, ranode->u.internal[n].down, &bh1))) {
-			unode->up = ra;
+		if ((unode = hpfs_map_anode(s, le32_to_cpu(ranode->u.internal[n].down), &bh1))) {
+			unode->up = cpu_to_le32(ra);
 			unode->btree.fnode_parent = 0;
 			mark_buffer_dirty(bh1);
 			brelse(bh1);
@@ -248,11 +248,11 @@ secno hpfs_add_sector_to_btree(struct su
 	btree->internal = 1;
 	btree->n_free_nodes = fnod ? 10 : 58;
 	btree->n_used_nodes = 2;
-	btree->first_free = (char *)&btree->u.internal[2] - (char *)btree;
-	btree->u.internal[0].file_secno = fs;
-	btree->u.internal[0].down = ra;
-	btree->u.internal[1].file_secno = -1;
-	btree->u.internal[1].down = na;
+	btree->first_free = cpu_to_le16((char *)&btree->u.internal[2] - (char *)btree);
+	btree->u.internal[0].file_secno = cpu_to_le32(fs);
+	btree->u.internal[0].down = cpu_to_le32(ra);
+	btree->u.internal[1].file_secno = cpu_to_le32(-1);
+	btree->u.internal[1].down = cpu_to_le32(na);
 	mark_buffer_dirty(bh);
 	brelse(bh);
 	mark_buffer_dirty(bh2);
@@ -279,7 +279,7 @@ void hpfs_remove_btree(struct super_bloc
 	go_down:
 	d2 = 0;
 	while (btree1->internal) {
-		ano = btree1->u.internal[pos].down;
+		ano = le32_to_cpu(btree1->u.internal[pos].down);
 		if (level) brelse(bh);
 		if (hpfs_sb(s)->sb_chk)
 			if (hpfs_stop_cycles(s, ano, &d1, &d2, "hpfs_remove_btree #1"))
@@ -290,7 +290,7 @@ void hpfs_remove_btree(struct super_bloc
 		pos = 0;
 	}
 	for (i = 0; i < btree1->n_used_nodes; i++)
-		hpfs_free_sectors(s, btree1->u.external[i].disk_secno, btree1->u.external[i].length);
+		hpfs_free_sectors(s, le32_to_cpu(btree1->u.external[i].disk_secno), le32_to_cpu(btree1->u.external[i].length));
 	go_up:
 	if (!level) return;
 	brelse(bh);
@@ -298,13 +298,13 @@ void hpfs_remove_btree(struct super_bloc
 		if (hpfs_stop_cycles(s, ano, &c1, &c2, "hpfs_remove_btree #2")) return;
 	hpfs_free_sectors(s, ano, 1);
 	oano = ano;
-	ano = anode->up;
+	ano = le32_to_cpu(anode->up);
 	if (--level) {
 		if (!(anode = hpfs_map_anode(s, ano, &bh))) return;
 		btree1 = &anode->btree;
 	} else btree1 = btree;
 	for (i = 0; i < btree1->n_used_nodes; i++) {
-		if (btree1->u.internal[i].down == oano) {
+		if (le32_to_cpu(btree1->u.internal[i].down) == oano) {
 			if ((pos = i + 1) < btree1->n_used_nodes)
 				goto go_down;
 			else
@@ -411,7 +411,7 @@ void hpfs_truncate_btree(struct super_bl
 		if (fno) {
 			btree->n_free_nodes = 8;
 			btree->n_used_nodes = 0;
-			btree->first_free = 8;
+			btree->first_free = cpu_to_le16(8);
 			btree->internal = 0;
 			mark_buffer_dirty(bh);
 		} else hpfs_free_sectors(s, f, 1);
@@ -421,22 +421,22 @@ void hpfs_truncate_btree(struct super_bl
 	while (btree->internal) {
 		nodes = btree->n_used_nodes + btree->n_free_nodes;
 		for (i = 0; i < btree->n_used_nodes; i++)
-			if (btree->u.internal[i].file_secno >= secs) goto f;
+			if (le32_to_cpu(btree->u.internal[i].file_secno) >= secs) goto f;
 		brelse(bh);
 		hpfs_error(s, "internal btree %08x doesn't end with -1", node);
 		return;
 		f:
 		for (j = i + 1; j < btree->n_used_nodes; j++)
-			hpfs_ea_remove(s, btree->u.internal[j].down, 1, 0);
+			hpfs_ea_remove(s, le32_to_cpu(btree->u.internal[j].down), 1, 0);
 		btree->n_used_nodes = i + 1;
 		btree->n_free_nodes = nodes - btree->n_used_nodes;
-		btree->first_free = 8 + 8 * btree->n_used_nodes;
+		btree->first_free = cpu_to_le16(8 + 8 * btree->n_used_nodes);
 		mark_buffer_dirty(bh);
-		if (btree->u.internal[i].file_secno == secs) {
+		if (btree->u.internal[i].file_secno == cpu_to_le32(secs)) {
 			brelse(bh);
 			return;
 		}
-		node = btree->u.internal[i].down;
+		node = le32_to_cpu(btree->u.internal[i].down);
 		brelse(bh);
 		if (hpfs_sb(s)->sb_chk)
 			if (hpfs_stop_cycles(s, node, &c1, &c2, "hpfs_truncate_btree"))
@@ -446,25 +446,25 @@ void hpfs_truncate_btree(struct super_bl
 	}	
 	nodes = btree->n_used_nodes + btree->n_free_nodes;
 	for (i = 0; i < btree->n_used_nodes; i++)
-		if (btree->u.external[i].file_secno + btree->u.external[i].length >= secs) goto ff;
+		if (le32_to_cpu(btree->u.external[i].file_secno) + le32_to_cpu(btree->u.external[i].length) >= secs) goto ff;
 	brelse(bh);
 	return;
 	ff:
-	if (secs <= btree->u.external[i].file_secno) {
+	if (secs <= le32_to_cpu(btree->u.external[i].file_secno)) {
 		hpfs_error(s, "there is an allocation error in file %08x, sector %08x", f, secs);
 		if (i) i--;
 	}
-	else if (btree->u.external[i].file_secno + btree->u.external[i].length > secs) {
-		hpfs_free_sectors(s, btree->u.external[i].disk_secno + secs -
-			btree->u.external[i].file_secno, btree->u.external[i].length
-			- secs + btree->u.external[i].file_secno); /* I hope gcc optimizes this :-) */
-		btree->u.external[i].length = secs - btree->u.external[i].file_secno;
+	else if (le32_to_cpu(btree->u.external[i].file_secno) + le32_to_cpu(btree->u.external[i].length) > secs) {
+		hpfs_free_sectors(s, le32_to_cpu(btree->u.external[i].disk_secno) + secs -
+			le32_to_cpu(btree->u.external[i].file_secno), le32_to_cpu(btree->u.external[i].length)
+			- secs + le32_to_cpu(btree->u.external[i].file_secno)); /* I hope gcc optimizes this :-) */
+		btree->u.external[i].length = cpu_to_le32(secs - le32_to_cpu(btree->u.external[i].file_secno));
 	}
 	for (j = i + 1; j < btree->n_used_nodes; j++)
-		hpfs_free_sectors(s, btree->u.external[j].disk_secno, btree->u.external[j].length);
+		hpfs_free_sectors(s, le32_to_cpu(btree->u.external[j].disk_secno), le32_to_cpu(btree->u.external[j].length));
 	btree->n_used_nodes = i + 1;
 	btree->n_free_nodes = nodes - btree->n_used_nodes;
-	btree->first_free = 8 + 12 * btree->n_used_nodes;
+	btree->first_free = cpu_to_le16(8 + 12 * btree->n_used_nodes);
 	mark_buffer_dirty(bh);
 	brelse(bh);
 }
@@ -480,12 +480,12 @@ void hpfs_remove_fnode(struct super_bloc
 	struct extended_attribute *ea_end;
 	if (!(fnode = hpfs_map_fnode(s, fno, &bh))) return;
 	if (!fnode->dirflag) hpfs_remove_btree(s, &fnode->btree);
-	else hpfs_remove_dtree(s, fnode->u.external[0].disk_secno);
+	else hpfs_remove_dtree(s, le32_to_cpu(fnode->u.external[0].disk_secno));
 	ea_end = fnode_end_ea(fnode);
 	for (ea = fnode_ea(fnode); ea < ea_end; ea = next_ea(ea))
 		if (ea->indirect)
 			hpfs_ea_remove(s, ea_sec(ea), ea->anode, ea_len(ea));
-	hpfs_ea_ext_remove(s, fnode->ea_secno, fnode->ea_anode, fnode->ea_size_l);
+	hpfs_ea_ext_remove(s, le32_to_cpu(fnode->ea_secno), fnode->ea_anode, le32_to_cpu(fnode->ea_size_l));
 	brelse(bh);
 	hpfs_free_sectors(s, fno, 1);
 }
Index: linux-2.6.39-rc5-fast/fs/hpfs/dir.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/dir.c	2011-05-05 01:02:47.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/dir.c	2011-05-05 01:02:58.000000000 +0200
@@ -88,9 +88,9 @@ static int hpfs_readdir(struct file *fil
 			hpfs_error(inode->i_sb, "not a directory, fnode %08lx",
 					(unsigned long)inode->i_ino);
 		}
-		if (hpfs_inode->i_dno != fno->u.external[0].disk_secno) {
+		if (hpfs_inode->i_dno != le32_to_cpu(fno->u.external[0].disk_secno)) {
 			e = 1;
-			hpfs_error(inode->i_sb, "corrupted inode: i_dno == %08x, fnode -> dnode == %08x", hpfs_inode->i_dno, fno->u.external[0].disk_secno);
+			hpfs_error(inode->i_sb, "corrupted inode: i_dno == %08x, fnode -> dnode == %08x", hpfs_inode->i_dno, le32_to_cpu(fno->u.external[0].disk_secno));
 		}
 		brelse(bh);
 		if (e) {
@@ -156,7 +156,7 @@ static int hpfs_readdir(struct file *fil
 			goto again;
 		}
 		tempname = hpfs_translate_name(inode->i_sb, de->name, de->namelen, lc, de->not_8x3);
-		if (filldir(dirent, tempname, de->namelen, old_pos, de->fnode, DT_UNKNOWN) < 0) {
+		if (filldir(dirent, tempname, de->namelen, old_pos, le32_to_cpu(de->fnode), DT_UNKNOWN) < 0) {
 			filp->f_pos = old_pos;
 			if (tempname != de->name) kfree(tempname);
 			hpfs_brelse4(&qbh);
@@ -221,7 +221,7 @@ struct dentry *hpfs_lookup(struct inode 
 	 * Get inode number, what we're after.
 	 */
 
-	ino = de->fnode;
+	ino = le32_to_cpu(de->fnode);
 
 	/*
 	 * Go find or make an inode.
@@ -236,7 +236,7 @@ struct dentry *hpfs_lookup(struct inode 
 		hpfs_init_inode(result);
 		if (de->directory)
 			hpfs_read_inode(result);
-		else if (de->ea_size && hpfs_sb(dir->i_sb)->sb_eas)
+		else if (le32_to_cpu(de->ea_size) && hpfs_sb(dir->i_sb)->sb_eas)
 			hpfs_read_inode(result);
 		else {
 			result->i_mode |= S_IFREG;
@@ -261,19 +261,19 @@ struct dentry *hpfs_lookup(struct inode 
 	 */
 
 	if (!result->i_ctime.tv_sec) {
-		if (!(result->i_ctime.tv_sec = local_to_gmt(dir->i_sb, de->creation_date)))
+		if (!(result->i_ctime.tv_sec = local_to_gmt(dir->i_sb, le32_to_cpu(de->creation_date))))
 			result->i_ctime.tv_sec = 1;
 		result->i_ctime.tv_nsec = 0;
-		result->i_mtime.tv_sec = local_to_gmt(dir->i_sb, de->write_date);
+		result->i_mtime.tv_sec = local_to_gmt(dir->i_sb, le32_to_cpu(de->write_date));
 		result->i_mtime.tv_nsec = 0;
-		result->i_atime.tv_sec = local_to_gmt(dir->i_sb, de->read_date);
+		result->i_atime.tv_sec = local_to_gmt(dir->i_sb, le32_to_cpu(de->read_date));
 		result->i_atime.tv_nsec = 0;
-		hpfs_result->i_ea_size = de->ea_size;
+		hpfs_result->i_ea_size = le32_to_cpu(de->ea_size);
 		if (!hpfs_result->i_ea_mode && de->read_only)
 			result->i_mode &= ~0222;
 		if (!de->directory) {
 			if (result->i_size == -1) {
-				result->i_size = de->file_size;
+				result->i_size = le32_to_cpu(de->file_size);
 				result->i_data.a_ops = &hpfs_aops;
 				hpfs_i(result)->mmu_private = result->i_size;
 			/*
Index: linux-2.6.39-rc5-fast/fs/hpfs/dnode.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/dnode.c	2011-05-05 01:02:45.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/dnode.c	2011-05-05 01:02:58.000000000 +0200
@@ -14,11 +14,11 @@ static loff_t get_pos(struct dnode *d, s
 	struct hpfs_dirent *de_end = dnode_end_de(d);
 	int i = 1;
 	for (de = dnode_first_de(d); de < de_end; de = de_next_de(de)) {
-		if (de == fde) return ((loff_t) d->self << 4) | (loff_t)i;
+		if (de == fde) return ((loff_t) le32_to_cpu(d->self) << 4) | (loff_t)i;
 		i++;
 	}
 	printk("HPFS: get_pos: not_found\n");
-	return ((loff_t)d->self << 4) | (loff_t)1;
+	return ((loff_t)le32_to_cpu(d->self) << 4) | (loff_t)1;
 }
 
 void hpfs_add_pos(struct inode *inode, loff_t *pos)
@@ -130,30 +130,30 @@ static void set_last_pointer(struct supe
 {
 	struct hpfs_dirent *de;
 	if (!(de = dnode_last_de(d))) {
-		hpfs_error(s, "set_last_pointer: empty dnode %08x", d->self);
+		hpfs_error(s, "set_last_pointer: empty dnode %08x", le32_to_cpu(d->self));
 		return;
 	}
 	if (hpfs_sb(s)->sb_chk) {
 		if (de->down) {
 			hpfs_error(s, "set_last_pointer: dnode %08x has already last pointer %08x",
-				d->self, de_down_pointer(de));
+				le32_to_cpu(d->self), de_down_pointer(de));
 			return;
 		}
-		if (de->length != 32) {
-			hpfs_error(s, "set_last_pointer: bad last dirent in dnode %08x", d->self);
+		if (le16_to_cpu(de->length) != 32) {
+			hpfs_error(s, "set_last_pointer: bad last dirent in dnode %08x", le32_to_cpu(d->self));
 			return;
 		}
 	}
 	if (ptr) {
 		d->first_free = cpu_to_le32(le32_to_cpu(d->first_free) + 4);
 		if (le32_to_cpu(d->first_free) > 2048) {
-			hpfs_error(s, "set_last_pointer: too long dnode %08x", d->self);
+			hpfs_error(s, "set_last_pointer: too long dnode %08x", le32_to_cpu(d->self));
 			d->first_free = cpu_to_le32(le32_to_cpu(d->first_free) - 4);
 			return;
 		}
-		de->length = 36;
+		de->length = cpu_to_le16(36);
 		de->down = 1;
-		*(dnode_secno *)((char *)de + 32) = ptr;
+		*(dnode_secno *)((char *)de + 32) = cpu_to_le32(ptr);
 	}
 }
 
@@ -169,7 +169,7 @@ struct hpfs_dirent *hpfs_add_de(struct s
 	for (de = dnode_first_de(d); de < de_end; de = de_next_de(de)) {
 		int c = hpfs_compare_names(s, name, namelen, de->name, de->namelen, de->last);
 		if (!c) {
-			hpfs_error(s, "name (%c,%d) already exists in dnode %08x", *name, namelen, d->self);
+			hpfs_error(s, "name (%c,%d) already exists in dnode %08x", *name, namelen, le32_to_cpu(d->self));
 			return NULL;
 		}
 		if (c < 0) break;
@@ -177,11 +177,10 @@ struct hpfs_dirent *hpfs_add_de(struct s
 	memmove((char *)de + d_size, de, (char *)de_end - (char *)de);
 	memset(de, 0, d_size);
 	if (down_ptr) {
-		*(int *)((char *)de + d_size - 4) = down_ptr;
+		*(dnode_secno *)((char *)de + d_size - 4) = cpu_to_le32(down_ptr);
 		de->down = 1;
 	}
-	de->length = d_size;
-	if (down_ptr) de->down = 1;
+	de->length = cpu_to_le16(d_size);
 	de->not_8x3 = hpfs_is_name_long(name, namelen);
 	de->namelen = namelen;
 	memcpy(de->name, name, namelen);
@@ -195,10 +194,10 @@ static void hpfs_delete_de(struct super_
 			   struct hpfs_dirent *de)
 {
 	if (de->last) {
-		hpfs_error(s, "attempt to delete last dirent in dnode %08x", d->self);
+		hpfs_error(s, "attempt to delete last dirent in dnode %08x", le32_to_cpu(d->self));
 		return;
 	}
-	d->first_free = cpu_to_le32(le32_to_cpu(d->first_free) - de->length);
+	d->first_free = cpu_to_le32(le32_to_cpu(d->first_free) - le16_to_cpu(de->length));
 	memmove(de, de_next_de(de), le32_to_cpu(d->first_free) + (char *)d - (char *)de);
 }
 
@@ -206,14 +205,14 @@ static void fix_up_ptrs(struct super_blo
 {
 	struct hpfs_dirent *de;
 	struct hpfs_dirent *de_end = dnode_end_de(d);
-	dnode_secno dno = d->self;
+	dnode_secno dno = le32_to_cpu(d->self);
 	for (de = dnode_first_de(d); de < de_end; de = de_next_de(de))
 		if (de->down) {
 			struct quad_buffer_head qbh;
 			struct dnode *dd;
 			if ((dd = hpfs_map_dnode(s, de_down_pointer(de), &qbh))) {
-				if (dd->up != dno || dd->root_dnode) {
-					dd->up = dno;
+				if (le32_to_cpu(dd->up) != dno || dd->root_dnode) {
+					dd->up = cpu_to_le32(dno);
 					dd->root_dnode = 0;
 					hpfs_mark_4buffers_dirty(&qbh);
 				}
@@ -291,7 +290,7 @@ static int hpfs_add_to_dnode(struct inod
 	copy_de(de = hpfs_add_de(i->i_sb, nd, name, namelen, down_ptr), new_de);
 	for_all_poss(i, hpfs_pos_ins, get_pos(nd, de), 1);
 	h = ((char *)dnode_last_de(nd) - (char *)nd) / 2 + 10;
-	if (!(ad = hpfs_alloc_dnode(i->i_sb, d->up, &adno, &qbh1))) {
+	if (!(ad = hpfs_alloc_dnode(i->i_sb, le32_to_cpu(d->up), &adno, &qbh1))) {
 		hpfs_error(i->i_sb, "unable to alloc dnode - dnode tree will be corrupted");
 		hpfs_brelse4(&qbh);
 		kfree(nd);
@@ -315,19 +314,20 @@ static int hpfs_add_to_dnode(struct inod
 	set_last_pointer(i->i_sb, ad, de->down ? de_down_pointer(de) : 0);
 	de = de_next_de(de);
 	memmove((char *)nd + 20, de, le32_to_cpu(nd->first_free) + (char *)nd - (char *)de);
-	nd->first_free = cpu_to_le32(le32_to_cpu(nd->first_free) - (char *)de - (char *)nd - 20);
+	nd->first_free = cpu_to_le32(le32_to_cpu(nd->first_free) - ((char *)de - (char *)nd - 20));
 	memcpy(d, nd, le32_to_cpu(nd->first_free));
 	for_all_poss(i, hpfs_pos_del, (loff_t)dno << 4, pos);
 	fix_up_ptrs(i->i_sb, ad);
 	if (!d->root_dnode) {
-		dno = ad->up = d->up;
+		ad->up = d->up;
+		dno = le32_to_cpu(ad->up);
 		hpfs_mark_4buffers_dirty(&qbh);
 		hpfs_brelse4(&qbh);
 		hpfs_mark_4buffers_dirty(&qbh1);
 		hpfs_brelse4(&qbh1);
 		goto go_up;
 	}
-	if (!(rd = hpfs_alloc_dnode(i->i_sb, d->up, &rdno, &qbh2))) {
+	if (!(rd = hpfs_alloc_dnode(i->i_sb, le32_to_cpu(d->up), &rdno, &qbh2))) {
 		hpfs_error(i->i_sb, "unable to alloc dnode - dnode tree will be corrupted");
 		hpfs_brelse4(&qbh);
 		hpfs_brelse4(&qbh1);
@@ -339,7 +339,7 @@ static int hpfs_add_to_dnode(struct inod
 	i->i_blocks += 4;
 	rd->root_dnode = 1;
 	rd->up = d->up;
-	if (!(fnode = hpfs_map_fnode(i->i_sb, d->up, &bh))) {
+	if (!(fnode = hpfs_map_fnode(i->i_sb, le32_to_cpu(d->up), &bh))) {
 		hpfs_free_dnode(i->i_sb, rdno);
 		hpfs_brelse4(&qbh);
 		hpfs_brelse4(&qbh1);
@@ -348,10 +348,11 @@ static int hpfs_add_to_dnode(struct inod
 		kfree(nname);
 		return 1;
 	}
-	fnode->u.external[0].disk_secno = rdno;
+	fnode->u.external[0].disk_secno = cpu_to_le32(rdno);
 	mark_buffer_dirty(bh);
 	brelse(bh);
-	d->up = ad->up = hpfs_i(i)->i_dno = rdno;
+	hpfs_i(i)->i_dno = rdno;
+	d->up = ad->up = cpu_to_le32(rdno);
 	d->root_dnode = ad->root_dnode = 0;
 	hpfs_mark_4buffers_dirty(&qbh);
 	hpfs_brelse4(&qbh);
@@ -436,9 +437,9 @@ static secno move_to_top(struct inode *i
 				return 0;
 		if (!(dnode = hpfs_map_dnode(i->i_sb, dno, &qbh))) return 0;
 		if (hpfs_sb(i->i_sb)->sb_chk) {
-			if (dnode->up != chk_up) {
+			if (le32_to_cpu(dnode->up) != chk_up) {
 				hpfs_error(i->i_sb, "move_to_top: up pointer from %08x should be %08x, is %08x",
-					dno, chk_up, dnode->up);
+					dno, chk_up, le32_to_cpu(dnode->up));
 				hpfs_brelse4(&qbh);
 				return 0;
 			}
@@ -454,7 +455,7 @@ static secno move_to_top(struct inode *i
 		hpfs_brelse4(&qbh);
 	}
 	while (!(de = dnode_pre_last_de(dnode))) {
-		dnode_secno up = dnode->up;
+		dnode_secno up = le32_to_cpu(dnode->up);
 		hpfs_brelse4(&qbh);
 		hpfs_free_dnode(i->i_sb, dno);
 		i->i_size -= 2048;
@@ -474,7 +475,7 @@ static secno move_to_top(struct inode *i
 			return 0;
 		}
 		dnode->first_free = cpu_to_le32(le32_to_cpu(dnode->first_free) - 4);
-		de->length -= 4;
+		de->length = cpu_to_le16(le16_to_cpu(de->length) - 4);
 		de->down = 0;
 		hpfs_mark_4buffers_dirty(&qbh);
 		dno = up;
@@ -482,12 +483,12 @@ static secno move_to_top(struct inode *i
 	t = get_pos(dnode, de);
 	for_all_poss(i, hpfs_pos_subst, t, 4);
 	for_all_poss(i, hpfs_pos_subst, t + 1, 5);
-	if (!(nde = kmalloc(de->length, GFP_NOFS))) {
+	if (!(nde = kmalloc(le16_to_cpu(de->length), GFP_NOFS))) {
 		hpfs_error(i->i_sb, "out of memory for dirent - directory will be corrupted");
 		hpfs_brelse4(&qbh);
 		return 0;
 	}
-	memcpy(nde, de, de->length);
+	memcpy(nde, de, le16_to_cpu(de->length));
 	ddno = de->down ? de_down_pointer(de) : 0;
 	hpfs_delete_de(i->i_sb, dnode, de);
 	set_last_pointer(i->i_sb, dnode, ddno);
@@ -520,7 +521,7 @@ static void delete_empty_dnode(struct in
 	if (le32_to_cpu(dnode->first_free) == 52 || le32_to_cpu(dnode->first_free) == 56) {
 		struct hpfs_dirent *de_end;
 		int root = dnode->root_dnode;
-		up = dnode->up;
+		up = le32_to_cpu(dnode->up);
 		de = dnode_first_de(dnode);
 		down = de->down ? de_down_pointer(de) : 0;
 		if (hpfs_sb(i->i_sb)->sb_chk) if (root && !down) {
@@ -544,13 +545,13 @@ static void delete_empty_dnode(struct in
 				return;
 			    }
 			if ((d1 = hpfs_map_dnode(i->i_sb, down, &qbh1))) {
-				d1->up = up;
+				d1->up = cpu_to_le32(up);
 				d1->root_dnode = 1;
 				hpfs_mark_4buffers_dirty(&qbh1);
 				hpfs_brelse4(&qbh1);
 			}
 			if ((fnode = hpfs_map_fnode(i->i_sb, up, &bh))) {
-				fnode->u.external[0].disk_secno = down;
+				fnode->u.external[0].disk_secno = cpu_to_le32(down);
 				mark_buffer_dirty(bh);
 				brelse(bh);
 			}
@@ -569,16 +570,16 @@ static void delete_empty_dnode(struct in
 		for_all_poss(i, hpfs_pos_subst, ((loff_t)dno << 4) | 1, ((loff_t)up << 4) | p);
 		if (!down) {
 			de->down = 0;
-			de->length -= 4;
+			de->length = cpu_to_le16(le16_to_cpu(de->length) - 4);
 			dnode->first_free = cpu_to_le32(le32_to_cpu(dnode->first_free) - 4);
 			memmove(de_next_de(de), (char *)de_next_de(de) + 4,
 				(char *)dnode + le32_to_cpu(dnode->first_free) - (char *)de_next_de(de));
 		} else {
 			struct dnode *d1;
 			struct quad_buffer_head qbh1;
-			*(dnode_secno *) ((void *) de + de->length - 4) = down;
+			*(dnode_secno *) ((void *) de + le16_to_cpu(de->length) - 4) = down;
 			if ((d1 = hpfs_map_dnode(i->i_sb, down, &qbh1))) {
-				d1->up = up;
+				d1->up = cpu_to_le32(up);
 				hpfs_mark_4buffers_dirty(&qbh1);
 				hpfs_brelse4(&qbh1);
 			}
@@ -595,18 +596,18 @@ static void delete_empty_dnode(struct in
 		struct quad_buffer_head qbh1;
 		if (!de_next->down) goto endm;
 		ndown = de_down_pointer(de_next);
-		if (!(de_cp = kmalloc(de->length, GFP_NOFS))) {
+		if (!(de_cp = kmalloc(le16_to_cpu(de->length), GFP_NOFS))) {
 			printk("HPFS: out of memory for dtree balancing\n");
 			goto endm;
 		}
-		memcpy(de_cp, de, de->length);
+		memcpy(de_cp, de, le16_to_cpu(de->length));
 		hpfs_delete_de(i->i_sb, dnode, de);
 		hpfs_mark_4buffers_dirty(&qbh);
 		hpfs_brelse4(&qbh);
 		for_all_poss(i, hpfs_pos_subst, ((loff_t)up << 4) | p, 4);
 		for_all_poss(i, hpfs_pos_del, ((loff_t)up << 4) | p, 1);
 		if (de_cp->down) if ((d1 = hpfs_map_dnode(i->i_sb, de_down_pointer(de_cp), &qbh1))) {
-			d1->up = ndown;
+			d1->up = cpu_to_le32(ndown);
 			hpfs_mark_4buffers_dirty(&qbh1);
 			hpfs_brelse4(&qbh1);
 		}
@@ -646,38 +647,38 @@ static void delete_empty_dnode(struct in
 					printk("HPFS: warning: unbalanced dnode tree, see hpfs.txt 4 more info\n");
 					printk("HPFS: warning: goin'on\n");
 				}
-				del->length += 4;
+				del->length = cpu_to_le16(le16_to_cpu(del->length) + 4);
 				del->down = 1;
 				d1->first_free = cpu_to_le32(le32_to_cpu(d1->first_free) + 4);
 			}
 			if (dlp && !down) {
-				del->length -= 4;
+				del->length = cpu_to_le16(le16_to_cpu(del->length) - 4);
 				del->down = 0;
 				d1->first_free = cpu_to_le32(le32_to_cpu(d1->first_free) - 4);
 			} else if (down)
-				*(dnode_secno *) ((void *) del + del->length - 4) = down;
+				*(dnode_secno *) ((void *) del + le16_to_cpu(del->length) - 4) = cpu_to_le32(down);
 		} else goto endm;
-		if (!(de_cp = kmalloc(de_prev->length, GFP_NOFS))) {
+		if (!(de_cp = kmalloc(le16_to_cpu(de_prev->length), GFP_NOFS))) {
 			printk("HPFS: out of memory for dtree balancing\n");
 			hpfs_brelse4(&qbh1);
 			goto endm;
 		}
 		hpfs_mark_4buffers_dirty(&qbh1);
 		hpfs_brelse4(&qbh1);
-		memcpy(de_cp, de_prev, de_prev->length);
+		memcpy(de_cp, de_prev, le16_to_cpu(de_prev->length));
 		hpfs_delete_de(i->i_sb, dnode, de_prev);
 		if (!de_prev->down) {
-			de_prev->length += 4;
+			de_prev->length = cpu_to_le16(le16_to_cpu(de_prev->length) + 4);
 			de_prev->down = 1;
 			dnode->first_free = cpu_to_le32(le32_to_cpu(dnode->first_free) + 4);
 		}
-		*(dnode_secno *) ((void *) de_prev + de_prev->length - 4) = ndown;
+		*(dnode_secno *) ((void *) de_prev + le16_to_cpu(de_prev->length) - 4) = cpu_to_le32(ndown);
 		hpfs_mark_4buffers_dirty(&qbh);
 		hpfs_brelse4(&qbh);
 		for_all_poss(i, hpfs_pos_subst, ((loff_t)up << 4) | (p - 1), 4);
 		for_all_poss(i, hpfs_pos_subst, ((loff_t)up << 4) | p, ((loff_t)up << 4) | (p - 1));
 		if (down) if ((d1 = hpfs_map_dnode(i->i_sb, de_down_pointer(de), &qbh1))) {
-			d1->up = ndown;
+			d1->up = cpu_to_le32(ndown);
 			hpfs_mark_4buffers_dirty(&qbh1);
 			hpfs_brelse4(&qbh1);
 		}
@@ -744,8 +745,8 @@ void hpfs_count_dnodes(struct super_bloc
 	ptr = 0;
 	go_up:
 	if (!(dnode = hpfs_map_dnode(s, dno, &qbh))) return;
-	if (hpfs_sb(s)->sb_chk) if (odno && odno != -1 && dnode->up != odno)
-		hpfs_error(s, "hpfs_count_dnodes: bad up pointer; dnode %08x, down %08x points to %08x", odno, dno, dnode->up);
+	if (hpfs_sb(s)->sb_chk) if (odno && odno != -1 && le32_to_cpu(dnode->up) != odno)
+		hpfs_error(s, "hpfs_count_dnodes: bad up pointer; dnode %08x, down %08x points to %08x", odno, dno, le32_to_cpu(dnode->up));
 	de = dnode_first_de(dnode);
 	if (ptr) while(1) {
 		if (de->down) if (de_down_pointer(de) == ptr) goto process_de;
@@ -769,7 +770,7 @@ void hpfs_count_dnodes(struct super_bloc
 	if (!de->first && !de->last && n_items) (*n_items)++;
 	if ((de = de_next_de(de)) < dnode_end_de(dnode)) goto next_de;
 	ptr = dno;
-	dno = dnode->up;
+	dno = le32_to_cpu(dnode->up);
 	if (dnode->root_dnode) {
 		hpfs_brelse4(&qbh);
 		return;
@@ -817,8 +818,8 @@ dnode_secno hpfs_de_as_down_as_possible(
 			return d;
 	if (!(de = map_nth_dirent(s, d, 1, &qbh, NULL))) return dno;
 	if (hpfs_sb(s)->sb_chk)
-		if (up && ((struct dnode *)qbh.data)->up != up)
-			hpfs_error(s, "hpfs_de_as_down_as_possible: bad up pointer; dnode %08x, down %08x points to %08x", up, d, ((struct dnode *)qbh.data)->up);
+		if (up && le32_to_cpu(((struct dnode *)qbh.data)->up) != up)
+			hpfs_error(s, "hpfs_de_as_down_as_possible: bad up pointer; dnode %08x, down %08x points to %08x", up, d, le32_to_cpu(((struct dnode *)qbh.data)->up));
 	if (!de->down) {
 		hpfs_brelse4(&qbh);
 		return d;
@@ -867,7 +868,7 @@ struct hpfs_dirent *map_pos_dirent(struc
 	/* Going up */
 	if (dnode->root_dnode) goto bail;
 
-	if (!(up_dnode = hpfs_map_dnode(inode->i_sb, dnode->up, &qbh0)))
+	if (!(up_dnode = hpfs_map_dnode(inode->i_sb, le32_to_cpu(dnode->up), &qbh0)))
 		goto bail;
 
 	end_up_de = dnode_end_de(up_dnode);
@@ -875,16 +876,16 @@ struct hpfs_dirent *map_pos_dirent(struc
 	for (up_de = dnode_first_de(up_dnode); up_de < end_up_de;
 	     up_de = de_next_de(up_de)) {
 		if (!(++c & 077)) hpfs_error(inode->i_sb,
-			"map_pos_dirent: pos crossed dnode boundary; dnode = %08x", dnode->up);
+			"map_pos_dirent: pos crossed dnode boundary; dnode = %08x", le32_to_cpu(dnode->up));
 		if (up_de->down && de_down_pointer(up_de) == dno) {
-			*posp = ((loff_t) dnode->up << 4) + c;
+			*posp = ((loff_t) le32_to_cpu(dnode->up) << 4) + c;
 			hpfs_brelse4(&qbh0);
 			return de;
 		}
 	}
 	
 	hpfs_error(inode->i_sb, "map_pos_dirent: pointer to dnode %08x not found in parent dnode %08x",
-		dno, dnode->up);
+		dno, le32_to_cpu(dnode->up));
 	hpfs_brelse4(&qbh0);
 	
 	bail:
@@ -1010,17 +1011,17 @@ struct hpfs_dirent *map_fnode_dirent(str
 		/*name2[15] = 0xff;*/
 		name1len = 15; name2len = 256;
 	}
-	if (!(upf = hpfs_map_fnode(s, f->up, &bh))) {
+	if (!(upf = hpfs_map_fnode(s, le32_to_cpu(f->up), &bh))) {
 		kfree(name2);
 		return NULL;
 	}	
 	if (!upf->dirflag) {
 		brelse(bh);
-		hpfs_error(s, "fnode %08x has non-directory parent %08x", fno, f->up);
+		hpfs_error(s, "fnode %08x has non-directory parent %08x", fno, le32_to_cpu(f->up));
 		kfree(name2);
 		return NULL;
 	}
-	dno = upf->u.external[0].disk_secno;
+	dno = le32_to_cpu(upf->u.external[0].disk_secno);
 	brelse(bh);
 	go_down:
 	downd = 0;
@@ -1042,7 +1043,7 @@ struct hpfs_dirent *map_fnode_dirent(str
 		return NULL;
 	}
 	next_de:
-	if (de->fnode == fno) {
+	if (le32_to_cpu(de->fnode) == fno) {
 		kfree(name2);
 		return de;
 	}
@@ -1058,7 +1059,7 @@ struct hpfs_dirent *map_fnode_dirent(str
 		goto go_down;
 	}
 	f:
-	if (de->fnode == fno) {
+	if (le32_to_cpu(de->fnode) == fno) {
 		kfree(name2);
 		return de;
 	}
@@ -1067,7 +1068,7 @@ struct hpfs_dirent *map_fnode_dirent(str
 	if ((de = de_next_de(de)) < de_end) goto next_de;
 	if (d->root_dnode) goto not_found;
 	downd = dno;
-	dno = d->up;
+	dno = le32_to_cpu(d->up);
 	hpfs_brelse4(qbh);
 	if (hpfs_sb(s)->sb_chk)
 		if (hpfs_stop_cycles(s, downd, &d1, &d2, "map_fnode_dirent #2")) {
Index: linux-2.6.39-rc5-fast/fs/hpfs/ea.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/ea.c	2011-05-05 01:02:45.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/ea.c	2011-05-05 01:02:58.000000000 +0200
@@ -24,7 +24,7 @@ void hpfs_ea_ext_remove(struct super_blo
 		}
 		if (hpfs_ea_read(s, a, ano, pos, 4, ex)) return;
 		if (ea->indirect) {
-			if (ea->valuelen != 8) {
+			if (le16_to_cpu(ea->valuelen) != 8) {
 				hpfs_error(s, "ea->indirect set while ea->valuelen!=8, %s %08x, pos %08x",
 					ano ? "anode" : "sectors", a, pos);
 				return;
@@ -33,7 +33,7 @@ void hpfs_ea_ext_remove(struct super_blo
 				return;
 			hpfs_ea_remove(s, ea_sec(ea), ea->anode, ea_len(ea));
 		}
-		pos += ea->namelen + ea->valuelen + 5;
+		pos += ea->namelen + le16_to_cpu(ea->valuelen) + 5;
 	}
 	if (!ano) hpfs_free_sectors(s, a, (len+511) >> 9);
 	else {
@@ -82,14 +82,14 @@ int hpfs_read_ea(struct super_block *s, 
 		if (!strcmp(ea->name, key)) {
 			if (ea->indirect)
 				goto indirect;
-			if (ea->valuelen >= size)
+			if (le16_to_cpu(ea->valuelen) >= size)
 				return -EINVAL;
-			memcpy(buf, ea_data(ea), ea->valuelen);
-			buf[ea->valuelen] = 0;
+			memcpy(buf, ea_data(ea), le16_to_cpu(ea->valuelen));
+			buf[le16_to_cpu(ea->valuelen)] = 0;
 			return 0;
 		}
-	a = fnode->ea_secno;
-	len = fnode->ea_size_l;
+	a = le32_to_cpu(fnode->ea_secno);
+	len = le32_to_cpu(fnode->ea_size_l);
 	ano = fnode->ea_anode;
 	pos = 0;
 	while (pos < len) {
@@ -106,14 +106,14 @@ int hpfs_read_ea(struct super_block *s, 
 		if (!strcmp(ea->name, key)) {
 			if (ea->indirect)
 				goto indirect;
-			if (ea->valuelen >= size)
+			if (le16_to_cpu(ea->valuelen) >= size)
 				return -EINVAL;
-			if (hpfs_ea_read(s, a, ano, pos + 4 + ea->namelen + 1, ea->valuelen, buf))
+			if (hpfs_ea_read(s, a, ano, pos + 4 + ea->namelen + 1, le16_to_cpu(ea->valuelen), buf))
 				return -EIO;
-			buf[ea->valuelen] = 0;
+			buf[le16_to_cpu(ea->valuelen)] = 0;
 			return 0;
 		}
-		pos += ea->namelen + ea->valuelen + 5;
+		pos += ea->namelen + le16_to_cpu(ea->valuelen) + 5;
 	}
 	return -ENOENT;
 indirect:
@@ -138,16 +138,16 @@ char *hpfs_get_ea(struct super_block *s,
 		if (!strcmp(ea->name, key)) {
 			if (ea->indirect)
 				return get_indirect_ea(s, ea->anode, ea_sec(ea), *size = ea_len(ea));
-			if (!(ret = kmalloc((*size = ea->valuelen) + 1, GFP_NOFS))) {
+			if (!(ret = kmalloc((*size = le16_to_cpu(ea->valuelen)) + 1, GFP_NOFS))) {
 				printk("HPFS: out of memory for EA\n");
 				return NULL;
 			}
-			memcpy(ret, ea_data(ea), ea->valuelen);
-			ret[ea->valuelen] = 0;
+			memcpy(ret, ea_data(ea), le16_to_cpu(ea->valuelen));
+			ret[le16_to_cpu(ea->valuelen)] = 0;
 			return ret;
 		}
-	a = fnode->ea_secno;
-	len = fnode->ea_size_l;
+	a = le32_to_cpu(fnode->ea_secno);
+	len = le32_to_cpu(fnode->ea_size_l);
 	ano = fnode->ea_anode;
 	pos = 0;
 	while (pos < len) {
@@ -164,18 +164,18 @@ char *hpfs_get_ea(struct super_block *s,
 		if (!strcmp(ea->name, key)) {
 			if (ea->indirect)
 				return get_indirect_ea(s, ea->anode, ea_sec(ea), *size = ea_len(ea));
-			if (!(ret = kmalloc((*size = ea->valuelen) + 1, GFP_NOFS))) {
+			if (!(ret = kmalloc((*size = le16_to_cpu(ea->valuelen)) + 1, GFP_NOFS))) {
 				printk("HPFS: out of memory for EA\n");
 				return NULL;
 			}
-			if (hpfs_ea_read(s, a, ano, pos + 4 + ea->namelen + 1, ea->valuelen, ret)) {
+			if (hpfs_ea_read(s, a, ano, pos + 4 + ea->namelen + 1, le16_to_cpu(ea->valuelen), ret)) {
 				kfree(ret);
 				return NULL;
 			}
-			ret[ea->valuelen] = 0;
+			ret[le16_to_cpu(ea->valuelen)] = 0;
 			return ret;
 		}
-		pos += ea->namelen + ea->valuelen + 5;
+		pos += ea->namelen + le16_to_cpu(ea->valuelen) + 5;
 	}
 	return NULL;
 }
@@ -202,13 +202,13 @@ void hpfs_set_ea(struct inode *inode, st
 			if (ea->indirect) {
 				if (ea_len(ea) == size)
 					set_indirect_ea(s, ea->anode, ea_sec(ea), data, size);
-			} else if (ea->valuelen == size) {
+			} else if (le16_to_cpu(ea->valuelen) == size) {
 				memcpy(ea_data(ea), data, size);
 			}
 			return;
 		}
-	a = fnode->ea_secno;
-	len = fnode->ea_size_l;
+	a = le32_to_cpu(fnode->ea_secno);
+	len = le32_to_cpu(fnode->ea_size_l);
 	ano = fnode->ea_anode;
 	pos = 0;
 	while (pos < len) {
@@ -228,41 +228,41 @@ void hpfs_set_ea(struct inode *inode, st
 					set_indirect_ea(s, ea->anode, ea_sec(ea), data, size);
 			}
 			else {
-				if (ea->valuelen == size)
+				if (le16_to_cpu(ea->valuelen) == size)
 					hpfs_ea_write(s, a, ano, pos + 4 + ea->namelen + 1, size, data);
 			}
 			return;
 		}
-		pos += ea->namelen + ea->valuelen + 5;
+		pos += ea->namelen + le16_to_cpu(ea->valuelen) + 5;
 	}
-	if (!fnode->ea_offs) {
-		/*if (fnode->ea_size_s) {
+	if (!le16_to_cpu(fnode->ea_offs)) {
+		/*if (le16_to_cpu(fnode->ea_size_s)) {
 			hpfs_error(s, "fnode %08x: ea_size_s == %03x, ea_offs == 0",
-				inode->i_ino, fnode->ea_size_s);
+				inode->i_ino, le16_to_cpu(fnode->ea_size_s));
 			return;
 		}*/
-		fnode->ea_offs = 0xc4;
+		fnode->ea_offs = cpu_to_le16(0xc4);
 	}
-	if (fnode->ea_offs < 0xc4 || fnode->ea_offs + fnode->acl_size_s + fnode->ea_size_s > 0x200) {
+	if (le16_to_cpu(fnode->ea_offs) < 0xc4 || le16_to_cpu(fnode->ea_offs) + le16_to_cpu(fnode->acl_size_s) + le16_to_cpu(fnode->ea_size_s) > 0x200) {
 		hpfs_error(s, "fnode %08lx: ea_offs == %03x, ea_size_s == %03x",
 			(unsigned long)inode->i_ino,
-			fnode->ea_offs, fnode->ea_size_s);
+			le32_to_cpu(fnode->ea_offs), le16_to_cpu(fnode->ea_size_s));
 		return;
 	}
-	if ((fnode->ea_size_s || !fnode->ea_size_l) &&
-	     fnode->ea_offs + fnode->acl_size_s + fnode->ea_size_s + strlen(key) + size + 5 <= 0x200) {
+	if ((le16_to_cpu(fnode->ea_size_s) || !le32_to_cpu(fnode->ea_size_l)) &&
+	     le16_to_cpu(fnode->ea_offs) + le16_to_cpu(fnode->acl_size_s) + le16_to_cpu(fnode->ea_size_s) + strlen(key) + size + 5 <= 0x200) {
 		ea = fnode_end_ea(fnode);
 		*(char *)ea = 0;
 		ea->namelen = strlen(key);
-		ea->valuelen = size;
+		ea->valuelen = cpu_to_le16(size);
 		strcpy(ea->name, key);
 		memcpy(ea_data(ea), data, size);
-		fnode->ea_size_s += strlen(key) + size + 5;
+		fnode->ea_size_s = cpu_to_le16(le16_to_cpu(fnode->ea_size_s) + strlen(key) + size + 5);
 		goto ret;
 	}
 	/* Most the code here is 99.9993422% unused. I hope there are no bugs.
 	   But what .. HPFS.IFS has also bugs in ea management. */
-	if (fnode->ea_size_s && !fnode->ea_size_l) {
+	if (le16_to_cpu(fnode->ea_size_s) && !le32_to_cpu(fnode->ea_size_l)) {
 		secno n;
 		struct buffer_head *bh;
 		char *data;
@@ -271,25 +271,26 @@ void hpfs_set_ea(struct inode *inode, st
 			hpfs_free_sectors(s, n, 1);
 			return;
 		}
-		memcpy(data, fnode_ea(fnode), fnode->ea_size_s);
-		fnode->ea_size_l = fnode->ea_size_s;
-		fnode->ea_size_s = 0;
-		fnode->ea_secno = n;
-		fnode->ea_anode = 0;
+		memcpy(data, fnode_ea(fnode), le16_to_cpu(fnode->ea_size_s));
+		fnode->ea_size_l = cpu_to_le32(le16_to_cpu(fnode->ea_size_s));
+		fnode->ea_size_s = cpu_to_le16(0);
+		fnode->ea_secno = cpu_to_le32(n);
+		fnode->ea_anode = cpu_to_le32(0);
 		mark_buffer_dirty(bh);
 		brelse(bh);
 	}
-	pos = fnode->ea_size_l + 5 + strlen(key) + size;
-	len = (fnode->ea_size_l + 511) >> 9;
+	pos = le32_to_cpu(fnode->ea_size_l) + 5 + strlen(key) + size;
+	len = (le32_to_cpu(fnode->ea_size_l) + 511) >> 9;
 	if (pos >= 30000) goto bail;
 	while (((pos + 511) >> 9) > len) {
 		if (!len) {
-			if (!(fnode->ea_secno = hpfs_alloc_sector(s, fno, 1, 0)))
-				goto bail;
+			secno q = hpfs_alloc_sector(s, fno, 1, 0);
+			if (!q) goto bail;
+			fnode->ea_secno = cpu_to_le32(q);
 			fnode->ea_anode = 0;
 			len++;
 		} else if (!fnode->ea_anode) {
-			if (hpfs_alloc_if_possible(s, fnode->ea_secno + len)) {
+			if (hpfs_alloc_if_possible(s, le32_to_cpu(fnode->ea_secno) + len)) {
 				len++;
 			} else {
 				/* Aargh... don't know how to create ea anodes :-( */
@@ -298,18 +299,18 @@ void hpfs_set_ea(struct inode *inode, st
 				anode_secno a_s;
 				if (!(anode = hpfs_alloc_anode(s, fno, &a_s, &bh)))
 					goto bail;
-				anode->up = fno;
+				anode->up = cpu_to_le32(fno);
 				anode->btree.fnode_parent = 1;
 				anode->btree.n_free_nodes--;
 				anode->btree.n_used_nodes++;
-				anode->btree.first_free += 12;
-				anode->u.external[0].disk_secno = fnode->ea_secno;
-				anode->u.external[0].file_secno = 0;
-				anode->u.external[0].length = len;
+				anode->btree.first_free = cpu_to_le16(le16_to_cpu(anode->btree.first_free) + 12);
+				anode->u.external[0].disk_secno = cpu_to_le32(le32_to_cpu(fnode->ea_secno));
+				anode->u.external[0].file_secno = cpu_to_le32(0);
+				anode->u.external[0].length = cpu_to_le32(len);
 				mark_buffer_dirty(bh);
 				brelse(bh);
 				fnode->ea_anode = 1;
-				fnode->ea_secno = a_s;*/
+				fnode->ea_secno = cpu_to_le32(a_s);*/
 				secno new_sec;
 				int i;
 				if (!(new_sec = hpfs_alloc_sector(s, fno, 1, 1 - ((pos + 511) >> 9))))
@@ -317,7 +318,7 @@ void hpfs_set_ea(struct inode *inode, st
 				for (i = 0; i < len; i++) {
 					struct buffer_head *bh1, *bh2;
 					void *b1, *b2;
-					if (!(b1 = hpfs_map_sector(s, fnode->ea_secno + i, &bh1, len - i - 1))) {
+					if (!(b1 = hpfs_map_sector(s, le32_to_cpu(fnode->ea_secno) + i, &bh1, len - i - 1))) {
 						hpfs_free_sectors(s, new_sec, (pos + 511) >> 9);
 						goto bail;
 					}
@@ -331,13 +332,13 @@ void hpfs_set_ea(struct inode *inode, st
 					mark_buffer_dirty(bh2);
 					brelse(bh2);
 				}
-				hpfs_free_sectors(s, fnode->ea_secno, len);
-				fnode->ea_secno = new_sec;
+				hpfs_free_sectors(s, le32_to_cpu(fnode->ea_secno), len);
+				fnode->ea_secno = cpu_to_le32(new_sec);
 				len = (pos + 511) >> 9;
 			}
 		}
 		if (fnode->ea_anode) {
-			if (hpfs_add_sector_to_btree(s, fnode->ea_secno,
+			if (hpfs_add_sector_to_btree(s, le32_to_cpu(fnode->ea_secno),
 						     0, len) != -1) {
 				len++;
 			} else {
@@ -349,17 +350,17 @@ void hpfs_set_ea(struct inode *inode, st
 	h[1] = strlen(key);
 	h[2] = size & 0xff;
 	h[3] = size >> 8;
-	if (hpfs_ea_write(s, fnode->ea_secno, fnode->ea_anode, fnode->ea_size_l, 4, h)) goto bail;
-	if (hpfs_ea_write(s, fnode->ea_secno, fnode->ea_anode, fnode->ea_size_l + 4, h[1] + 1, key)) goto bail;
-	if (hpfs_ea_write(s, fnode->ea_secno, fnode->ea_anode, fnode->ea_size_l + 5 + h[1], size, data)) goto bail;
-	fnode->ea_size_l = pos;
+	if (hpfs_ea_write(s, le32_to_cpu(fnode->ea_secno), fnode->ea_anode, le32_to_cpu(fnode->ea_size_l), 4, h)) goto bail;
+	if (hpfs_ea_write(s, le32_to_cpu(fnode->ea_secno), fnode->ea_anode, le32_to_cpu(fnode->ea_size_l) + 4, h[1] + 1, key)) goto bail;
+	if (hpfs_ea_write(s, le32_to_cpu(fnode->ea_secno), fnode->ea_anode, le32_to_cpu(fnode->ea_size_l) + 5 + h[1], size, data)) goto bail;
+	fnode->ea_size_l = cpu_to_le32(pos);
 	ret:
 	hpfs_i(inode)->i_ea_size += 5 + strlen(key) + size;
 	return;
 	bail:
-	if (fnode->ea_secno)
-		if (fnode->ea_anode) hpfs_truncate_btree(s, fnode->ea_secno, 1, (fnode->ea_size_l + 511) >> 9);
-		else hpfs_free_sectors(s, fnode->ea_secno + ((fnode->ea_size_l + 511) >> 9), len - ((fnode->ea_size_l + 511) >> 9));
-	else fnode->ea_secno = fnode->ea_size_l = 0;
+	if (le32_to_cpu(fnode->ea_secno))
+		if (fnode->ea_anode) hpfs_truncate_btree(s, le32_to_cpu(fnode->ea_secno), 1, (le32_to_cpu(fnode->ea_size_l) + 511) >> 9);
+		else hpfs_free_sectors(s, le32_to_cpu(fnode->ea_secno) + ((le32_to_cpu(fnode->ea_size_l) + 511) >> 9), len - ((le32_to_cpu(fnode->ea_size_l) + 511) >> 9));
+	else fnode->ea_secno = fnode->ea_size_l = cpu_to_le32(0);
 }
 	
Index: linux-2.6.39-rc5-fast/fs/hpfs/inode.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/inode.c	2011-05-05 01:02:53.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/inode.c	2011-05-05 01:02:58.000000000 +0200
@@ -115,8 +115,8 @@ void hpfs_read_inode(struct inode *i)
 		i->i_mode |= S_IFDIR;
 		i->i_op = &hpfs_dir_iops;
 		i->i_fop = &hpfs_dir_ops;
-		hpfs_inode->i_parent_dir = fnode->up;
-		hpfs_inode->i_dno = fnode->u.external[0].disk_secno;
+		hpfs_inode->i_parent_dir = le32_to_cpu(fnode->up);
+		hpfs_inode->i_dno = le32_to_cpu(fnode->u.external[0].disk_secno);
 		if (hpfs_sb(sb)->sb_chk >= 2) {
 			struct buffer_head *bh0;
 			if (hpfs_map_fnode(sb, hpfs_inode->i_parent_dir, &bh0)) brelse(bh0);
@@ -132,7 +132,7 @@ void hpfs_read_inode(struct inode *i)
 		i->i_op = &hpfs_file_iops;
 		i->i_fop = &hpfs_file_ops;
 		i->i_nlink = 1;
-		i->i_size = fnode->file_size;
+		i->i_size = le32_to_cpu(fnode->file_size);
 		i->i_blocks = ((i->i_size + 511) >> 9) + 1;
 		i->i_data.a_ops = &hpfs_aops;
 		hpfs_i(i)->mmu_private = i->i_size;
@@ -143,7 +143,7 @@ void hpfs_read_inode(struct inode *i)
 static void hpfs_write_inode_ea(struct inode *i, struct fnode *fnode)
 {
 	struct hpfs_inode_info *hpfs_inode = hpfs_i(i);
-	/*if (fnode->acl_size_l || fnode->acl_size_s) {
+	/*if (le32_to_cpu(fnode->acl_size_l) || le16_to_cpu(fnode->acl_size_s)) {
 		   Some unknown structures like ACL may be in fnode,
 		   we'd better not overwrite them
 		hpfs_error(i->i_sb, "fnode %08x has some unknown HPFS386 stuctures", i->i_ino);
@@ -218,30 +218,30 @@ void hpfs_write_inode_nolock(struct inod
 		}
 	} else de = NULL;
 	if (S_ISREG(i->i_mode)) {
-		fnode->file_size = i->i_size;
-		if (de) de->file_size = i->i_size;
+		fnode->file_size = cpu_to_le32(i->i_size);
+		if (de) de->file_size = cpu_to_le32(i->i_size);
 	} else if (S_ISDIR(i->i_mode)) {
-		fnode->file_size = 0;
-		if (de) de->file_size = 0;
+		fnode->file_size = cpu_to_le32(0);
+		if (de) de->file_size = cpu_to_le32(0);
 	}
 	hpfs_write_inode_ea(i, fnode);
 	if (de) {
-		de->write_date = gmt_to_local(i->i_sb, i->i_mtime.tv_sec);
-		de->read_date = gmt_to_local(i->i_sb, i->i_atime.tv_sec);
-		de->creation_date = gmt_to_local(i->i_sb, i->i_ctime.tv_sec);
+		de->write_date = cpu_to_le32(gmt_to_local(i->i_sb, i->i_mtime.tv_sec));
+		de->read_date = cpu_to_le32(gmt_to_local(i->i_sb, i->i_atime.tv_sec));
+		de->creation_date = cpu_to_le32(gmt_to_local(i->i_sb, i->i_ctime.tv_sec));
 		de->read_only = !(i->i_mode & 0222);
-		de->ea_size = hpfs_inode->i_ea_size;
+		de->ea_size = cpu_to_le32(hpfs_inode->i_ea_size);
 		hpfs_mark_4buffers_dirty(&qbh);
 		hpfs_brelse4(&qbh);
 	}
 	if (S_ISDIR(i->i_mode)) {
 		if ((de = map_dirent(i, hpfs_inode->i_dno, "\001\001", 2, NULL, &qbh))) {
-			de->write_date = gmt_to_local(i->i_sb, i->i_mtime.tv_sec);
-			de->read_date = gmt_to_local(i->i_sb, i->i_atime.tv_sec);
-			de->creation_date = gmt_to_local(i->i_sb, i->i_ctime.tv_sec);
+			de->write_date = cpu_to_le32(gmt_to_local(i->i_sb, i->i_mtime.tv_sec));
+			de->read_date = cpu_to_le32(gmt_to_local(i->i_sb, i->i_atime.tv_sec));
+			de->creation_date = cpu_to_le32(gmt_to_local(i->i_sb, i->i_ctime.tv_sec));
 			de->read_only = !(i->i_mode & 0222);
-			de->ea_size = /*hpfs_inode->i_ea_size*/0;
-			de->file_size = 0;
+			de->ea_size = cpu_to_le32(/*hpfs_inode->i_ea_size*/0);
+			de->file_size = cpu_to_le32(0);
 			hpfs_mark_4buffers_dirty(&qbh);
 			hpfs_brelse4(&qbh);
 		} else
Index: linux-2.6.39-rc5-fast/fs/hpfs/namei.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/namei.c	2011-05-05 01:02:47.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/namei.c	2011-05-05 01:02:58.000000000 +0200
@@ -37,8 +37,8 @@ static int hpfs_mkdir(struct inode *dir,
 	if (!(mode & 0222)) dee.read_only = 1;
 	/*dee.archive = 0;*/
 	dee.hidden = name[0] == '.';
-	dee.fnode = fno;
-	dee.creation_date = dee.write_date = dee.read_date = gmt_to_local(dir->i_sb, get_seconds());
+	dee.fnode = cpu_to_le32(fno);
+	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(gmt_to_local(dir->i_sb, get_seconds()));
 	result = new_inode(dir->i_sb);
 	if (!result)
 		goto bail2;
@@ -46,7 +46,7 @@ static int hpfs_mkdir(struct inode *dir,
 	result->i_ino = fno;
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
 	hpfs_i(result)->i_dno = dno;
-	result->i_ctime.tv_sec = result->i_mtime.tv_sec = result->i_atime.tv_sec = local_to_gmt(dir->i_sb, dee.creation_date);
+	result->i_ctime.tv_sec = result->i_mtime.tv_sec = result->i_atime.tv_sec = local_to_gmt(dir->i_sb, le32_to_cpu(dee.creation_date));
 	result->i_ctime.tv_nsec = 0; 
 	result->i_mtime.tv_nsec = 0; 
 	result->i_atime.tv_nsec = 0; 
@@ -69,21 +69,21 @@ static int hpfs_mkdir(struct inode *dir,
 	}
 	fnode->len = len;
 	memcpy(fnode->name, name, len > 15 ? 15 : len);
-	fnode->up = dir->i_ino;
+	fnode->up = cpu_to_le32(dir->i_ino);
 	fnode->dirflag = 1;
 	fnode->btree.n_free_nodes = 7;
 	fnode->btree.n_used_nodes = 1;
-	fnode->btree.first_free = 0x14;
-	fnode->u.external[0].disk_secno = dno;
-	fnode->u.external[0].file_secno = -1;
+	fnode->btree.first_free = cpu_to_le16(0x14);
+	fnode->u.external[0].disk_secno = cpu_to_le32(dno);
+	fnode->u.external[0].file_secno = cpu_to_le32(-1);
 	dnode->root_dnode = 1;
-	dnode->up = fno;
+	dnode->up = cpu_to_le32(fno);
 	de = hpfs_add_de(dir->i_sb, dnode, "\001\001", 2, 0);
-	de->creation_date = de->write_date = de->read_date = gmt_to_local(dir->i_sb, get_seconds());
+	de->creation_date = de->write_date = de->read_date = cpu_to_le32(gmt_to_local(dir->i_sb, get_seconds()));
 	if (!(mode & 0222)) de->read_only = 1;
 	de->first = de->directory = 1;
 	/*de->hidden = de->system = 0;*/
-	de->fnode = fno;
+	de->fnode = cpu_to_le32(fno);
 	mark_buffer_dirty(bh);
 	brelse(bh);
 	hpfs_mark_4buffers_dirty(&qbh0);
@@ -137,8 +137,8 @@ static int hpfs_create(struct inode *dir
 	if (!(mode & 0222)) dee.read_only = 1;
 	dee.archive = 1;
 	dee.hidden = name[0] == '.';
-	dee.fnode = fno;
-	dee.creation_date = dee.write_date = dee.read_date = gmt_to_local(dir->i_sb, get_seconds());
+	dee.fnode = cpu_to_le32(fno);
+	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(gmt_to_local(dir->i_sb, get_seconds()));
 
 	result = new_inode(dir->i_sb);
 	if (!result)
@@ -152,7 +152,7 @@ static int hpfs_create(struct inode *dir
 	result->i_fop = &hpfs_file_ops;
 	result->i_nlink = 1;
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
-	result->i_ctime.tv_sec = result->i_mtime.tv_sec = result->i_atime.tv_sec = local_to_gmt(dir->i_sb, dee.creation_date);
+	result->i_ctime.tv_sec = result->i_mtime.tv_sec = result->i_atime.tv_sec = local_to_gmt(dir->i_sb, le32_to_cpu(dee.creation_date));
 	result->i_ctime.tv_nsec = 0;
 	result->i_mtime.tv_nsec = 0;
 	result->i_atime.tv_nsec = 0;
@@ -173,7 +173,7 @@ static int hpfs_create(struct inode *dir
 	}
 	fnode->len = len;
 	memcpy(fnode->name, name, len > 15 ? 15 : len);
-	fnode->up = dir->i_ino;
+	fnode->up = cpu_to_le32(dir->i_ino);
 	mark_buffer_dirty(bh);
 	brelse(bh);
 
@@ -225,8 +225,8 @@ static int hpfs_mknod(struct inode *dir,
 	if (!(mode & 0222)) dee.read_only = 1;
 	dee.archive = 1;
 	dee.hidden = name[0] == '.';
-	dee.fnode = fno;
-	dee.creation_date = dee.write_date = dee.read_date = gmt_to_local(dir->i_sb, get_seconds());
+	dee.fnode = cpu_to_le32(fno);
+	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(gmt_to_local(dir->i_sb, get_seconds()));
 
 	result = new_inode(dir->i_sb);
 	if (!result)
@@ -235,7 +235,7 @@ static int hpfs_mknod(struct inode *dir,
 	hpfs_init_inode(result);
 	result->i_ino = fno;
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
-	result->i_ctime.tv_sec = result->i_mtime.tv_sec = result->i_atime.tv_sec = local_to_gmt(dir->i_sb, dee.creation_date);
+	result->i_ctime.tv_sec = result->i_mtime.tv_sec = result->i_atime.tv_sec = local_to_gmt(dir->i_sb, le32_to_cpu(dee.creation_date));
 	result->i_ctime.tv_nsec = 0;
 	result->i_mtime.tv_nsec = 0;
 	result->i_atime.tv_nsec = 0;
@@ -256,7 +256,7 @@ static int hpfs_mknod(struct inode *dir,
 	}
 	fnode->len = len;
 	memcpy(fnode->name, name, len > 15 ? 15 : len);
-	fnode->up = dir->i_ino;
+	fnode->up = cpu_to_le32(dir->i_ino);
 	mark_buffer_dirty(bh);
 
 	insert_inode_hash(result);
@@ -300,8 +300,8 @@ static int hpfs_symlink(struct inode *di
 	memset(&dee, 0, sizeof dee);
 	dee.archive = 1;
 	dee.hidden = name[0] == '.';
-	dee.fnode = fno;
-	dee.creation_date = dee.write_date = dee.read_date = gmt_to_local(dir->i_sb, get_seconds());
+	dee.fnode = cpu_to_le32(fno);
+	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(gmt_to_local(dir->i_sb, get_seconds()));
 
 	result = new_inode(dir->i_sb);
 	if (!result)
@@ -309,7 +309,7 @@ static int hpfs_symlink(struct inode *di
 	result->i_ino = fno;
 	hpfs_init_inode(result);
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
-	result->i_ctime.tv_sec = result->i_mtime.tv_sec = result->i_atime.tv_sec = local_to_gmt(dir->i_sb, dee.creation_date);
+	result->i_ctime.tv_sec = result->i_mtime.tv_sec = result->i_atime.tv_sec = local_to_gmt(dir->i_sb, le32_to_cpu(dee.creation_date));
 	result->i_ctime.tv_nsec = 0;
 	result->i_mtime.tv_nsec = 0;
 	result->i_atime.tv_nsec = 0;
@@ -332,7 +332,7 @@ static int hpfs_symlink(struct inode *di
 	}
 	fnode->len = len;
 	memcpy(fnode->name, name, len > 15 ? 15 : len);
-	fnode->up = dir->i_ino;
+	fnode->up = cpu_to_le32(dir->i_ino);
 	hpfs_set_ea(result, fnode, "SYMLINK", symlink, strlen(symlink));
 	mark_buffer_dirty(bh);
 	brelse(bh);
@@ -382,7 +382,7 @@ again:
 	if (de->directory)
 		goto out1;
 
-	fno = de->fnode;
+	fno = le32_to_cpu(de->fnode);
 	r = hpfs_remove_dirent(dir, dno, de, &qbh, 1);
 	switch (r) {
 	case 1:
@@ -465,7 +465,7 @@ static int hpfs_rmdir(struct inode *dir,
 	if (n_items)
 		goto out1;
 
-	fno = de->fnode;
+	fno = le32_to_cpu(de->fnode);
 	r = hpfs_remove_dirent(dir, dno, de, &qbh, 1);
 	switch (r) {
 	case 1:
@@ -608,7 +608,7 @@ static int hpfs_rename(struct inode *old
 		drop_nlink(old_dir);
 	}
 	if ((fnode = hpfs_map_fnode(i->i_sb, i->i_ino, &bh))) {
-		fnode->up = new_dir->i_ino;
+		fnode->up = cpu_to_le32(new_dir->i_ino);
 		fnode->len = new_len;
 		memcpy(fnode->name, new_name, new_len>15?15:new_len);
 		if (new_len < 15) memset(&fnode->name[new_len], 0, 15 - new_len);
