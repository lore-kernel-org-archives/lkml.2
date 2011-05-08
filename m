Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1EHSvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:51:21 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:56129 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab1EHSuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:50:21 -0400
Date: Sun, 8 May 2011 20:42:54 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/14] HPFS: Introduce a global mutex and lock it on every
 callback from VFS.
Message-ID: <alpine.DEB.2.00.1105082024500.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a global mutex and lock it on every callback from VFS.

Performance doesn't matter, reviewing the whole code for locking correctness
would be too complicated, so simply lock it all.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 fs/hpfs/buffer.c  |    8 ++++++++
 fs/hpfs/file.c    |   27 +++++++++++++++++++--------
 fs/hpfs/hpfs_fn.h |   24 +++++++++++++++---------
 fs/hpfs/super.c   |   10 +++++++++-
 4 files changed, 51 insertions(+), 18 deletions(-)

Index: linux-2.6.39-rc5-fast/fs/hpfs/hpfs_fn.h
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/hpfs_fn.h	2011-05-05 01:01:57.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/hpfs_fn.h	2011-05-05 01:02:43.000000000 +0200
@@ -63,6 +63,7 @@ struct hpfs_inode_info {
 };
 
 struct hpfs_sb_info {
+	struct mutex hpfs_mutex;	/* global hpfs lock */
 	ino_t sb_root;			/* inode number of root dir */
 	unsigned sb_fs_size;		/* file system size, sectors */
 	unsigned sb_bitmaps;		/* sector number of bitmap list */
@@ -346,21 +347,26 @@ static inline time32_t gmt_to_local(stru
 /*
  * Locking:
  *
- * hpfs_lock() is a leftover from the big kernel lock.
- * Right now, these functions are empty and only left
- * for documentation purposes. The file system no longer
- * works on SMP systems, so the lock is not needed
- * any more.
+ * hpfs_lock() locks the whole filesystem. It must be taken
+ * on any method called by the VFS.
  *
- * If someone is interested in making it work again, this
- * would be the place to start by adding a per-superblock
- * mutex and fixing all the bugs and performance issues
- * caused by that.
+ * We don't do any per-file locking anymore, it is hard to
+ * review and HPFS is not performance-sensitive anyway.
  */
 static inline void hpfs_lock(struct super_block *s)
 {
+	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	mutex_lock(&sbi->hpfs_mutex);
 }
 
 static inline void hpfs_unlock(struct super_block *s)
 {
+	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	mutex_unlock(&sbi->hpfs_mutex);
+}
+
+static inline void hpfs_lock_assert(struct super_block *s)
+{
+	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	WARN_ON(!mutex_is_locked(&sbi->hpfs_mutex));
 }
Index: linux-2.6.39-rc5-fast/fs/hpfs/super.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/super.c	2011-05-05 01:02:36.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/super.c	2011-05-05 01:02:43.000000000 +0200
@@ -102,9 +102,12 @@ static void hpfs_put_super(struct super_
 {
 	struct hpfs_sb_info *sbi = hpfs_sb(s);
 
+	hpfs_lock(s);
+	unmark_dirty(s);
+	hpfs_unlock(s);
+
 	kfree(sbi->sb_cp_table);
 	kfree(sbi->sb_bmp_dir);
-	unmark_dirty(s);
 	s->s_fs_info = NULL;
 	kfree(sbi);
 }
@@ -490,6 +493,9 @@ static int hpfs_fill_super(struct super_
 	sbi->sb_bmp_dir = NULL;
 	sbi->sb_cp_table = NULL;
 
+	mutex_init(&sbi->hpfs_mutex);
+	hpfs_lock(s);
+
 	mutex_init(&sbi->hpfs_creation_de);
 
 	uid = current_uid();
@@ -669,6 +675,7 @@ static int hpfs_fill_super(struct super_
 			root->i_blocks = 5;
 		hpfs_brelse4(&qbh);
 	}
+	hpfs_unlock(s);
 	return 0;
 
 bail4:	brelse(bh2);
@@ -676,6 +683,7 @@ bail3:	brelse(bh1);
 bail2:	brelse(bh0);
 bail1:
 bail0:
+	hpfs_unlock(s);
 	kfree(sbi->sb_bmp_dir);
 	kfree(sbi->sb_cp_table);
 	s->s_fs_info = NULL;
Index: linux-2.6.39-rc5-fast/fs/hpfs/file.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/file.c	2011-05-05 01:01:57.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/file.c	2011-05-05 01:02:43.000000000 +0200
@@ -48,38 +48,46 @@ static secno hpfs_bmap(struct inode *ino
 static void hpfs_truncate(struct inode *i)
 {
 	if (IS_IMMUTABLE(i)) return /*-EPERM*/;
-	hpfs_lock(i->i_sb);
+	hpfs_lock_assert(i->i_sb);
+
 	hpfs_i(i)->i_n_secs = 0;
 	i->i_blocks = 1 + ((i->i_size + 511) >> 9);
 	hpfs_i(i)->mmu_private = i->i_size;
 	hpfs_truncate_btree(i->i_sb, i->i_ino, 1, ((i->i_size + 511) >> 9));
 	hpfs_write_inode(i);
 	hpfs_i(i)->i_n_secs = 0;
-	hpfs_unlock(i->i_sb);
 }
 
 static int hpfs_get_block(struct inode *inode, sector_t iblock, struct buffer_head *bh_result, int create)
 {
+	int r;
 	secno s;
+	hpfs_lock(inode->i_sb);
 	s = hpfs_bmap(inode, iblock);
 	if (s) {
 		map_bh(bh_result, inode->i_sb, s);
-		return 0;
+		goto ret_0;
 	}
-	if (!create) return 0;
+	if (!create) goto ret_0;
 	if (iblock<<9 != hpfs_i(inode)->mmu_private) {
 		BUG();
-		return -EIO;
+		r = -EIO;
+		goto ret_r;
 	}
 	if ((s = hpfs_add_sector_to_btree(inode->i_sb, inode->i_ino, 1, inode->i_blocks - 1)) == -1) {
 		hpfs_truncate_btree(inode->i_sb, inode->i_ino, 1, inode->i_blocks - 1);
-		return -ENOSPC;
+		r = -ENOSPC;
+		goto ret_r;
 	}
 	inode->i_blocks++;
 	hpfs_i(inode)->mmu_private += 512;
 	set_buffer_new(bh_result);
 	map_bh(bh_result, inode->i_sb, s);
-	return 0;
+	ret_0:
+	r = 0;
+	ret_r:
+	hpfs_unlock(inode->i_sb);
+	return r;
 }
 
 static int hpfs_writepage(struct page *page, struct writeback_control *wbc)
@@ -130,8 +138,11 @@ static ssize_t hpfs_file_write(struct fi
 	ssize_t retval;
 
 	retval = do_sync_write(file, buf, count, ppos);
-	if (retval > 0)
+	if (retval > 0) {
+		hpfs_lock(file->f_path.dentry->d_sb);
 		hpfs_i(file->f_path.dentry->d_inode)->i_dirty = 1;
+		hpfs_unlock(file->f_path.dentry->d_sb);
+	}
 	return retval;
 }
 
Index: linux-2.6.39-rc5-fast/fs/hpfs/buffer.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/buffer.c	2011-05-05 01:01:57.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/buffer.c	2011-05-05 01:02:43.000000000 +0200
@@ -32,6 +32,8 @@ void *hpfs_map_sector(struct super_block
 {
 	struct buffer_head *bh;
 
+	hpfs_lock_assert(s);
+
 	cond_resched();
 
 	*bhp = bh = sb_bread(s, secno);
@@ -50,6 +52,8 @@ void *hpfs_get_sector(struct super_block
 	struct buffer_head *bh;
 	/*return hpfs_map_sector(s, secno, bhp, 0);*/
 
+	hpfs_lock_assert(s);
+
 	cond_resched();
 
 	if ((*bhp = bh = sb_getblk(s, secno)) != NULL) {
@@ -70,6 +74,8 @@ void *hpfs_map_4sectors(struct super_blo
 	struct buffer_head *bh;
 	char *data;
 
+	hpfs_lock_assert(s);
+
 	cond_resched();
 
 	if (secno & 3) {
@@ -125,6 +131,8 @@ void *hpfs_get_4sectors(struct super_blo
 {
 	cond_resched();
 
+	hpfs_lock_assert(s);
+
 	if (secno & 3) {
 		printk("HPFS: hpfs_get_4sectors: unaligned read\n");
 		return NULL;
