Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0FFOx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:53:29 -0400
Received: from smtp.nokia.com ([192.100.105.134]:18202 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab0FFOxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:21 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCHv5 01/16] VFS: introduce helpers for the s_dirt flag
Date: Sun,  6 Jun 2010 17:50:14 +0300
Message-Id: <1275835829-1478-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 06 Jun 2010 14:53:12.0168 (UTC) FILETIME=[FC4ADE80:01CB0587]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This patch introduces 3 new VFS helpers: 'sb_mark_dirty()',
'sb_mark_clean()', and 'sb_is_dirty()'. The helpers simply
change or test the 'sb->s_dirt' flag. The plan is to make
every FS use these helpers instead of manipulating the
'sb->s_dirt' flag directly.

This patch also switches VFS and all FSes to use the new helpers.
It just mechanically changes:
sb->s_dirt = 1  to sb_mark_dirty(sb)
sb->s_dirt = 0  to sb_mark_clean(sb)
if (sb->s_dirt) to if (sb_is_dirty(sb))

This patch does not introduce any functional changes, just wraps
the 's_dirt'.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/affs/bitmap.c      |    4 ++--
 fs/affs/super.c       |   14 +++++++++-----
 fs/bfs/inode.c        |    8 ++++----
 fs/btrfs/inode.c      |    2 +-
 fs/exofs/file.c       |    2 +-
 fs/exofs/inode.c      |    2 +-
 fs/exofs/super.c      |    6 +++---
 fs/ext2/balloc.c      |    4 ++--
 fs/ext2/ialloc.c      |    4 ++--
 fs/ext2/super.c       |    6 +++---
 fs/ext2/xattr.c       |    2 +-
 fs/ext4/balloc.c      |    2 +-
 fs/ext4/file.c        |    2 +-
 fs/ext4/ialloc.c      |    4 ++--
 fs/ext4/inode.c       |    2 +-
 fs/ext4/mballoc.c     |    4 ++--
 fs/ext4/resize.c      |    4 ++--
 fs/ext4/super.c       |    6 +++---
 fs/ext4/xattr.c       |    2 +-
 fs/fat/fatent.c       |    8 ++++----
 fs/fat/inode.c        |    8 ++++----
 fs/hfs/extent.c       |    2 +-
 fs/hfs/hfs_fs.h       |    2 +-
 fs/hfs/inode.c        |    6 +++---
 fs/hfs/super.c        |    6 +++---
 fs/hfsplus/bitmap.c   |    4 ++--
 fs/hfsplus/dir.c      |    2 +-
 fs/hfsplus/inode.c    |    6 +++---
 fs/hfsplus/super.c    |   16 ++++++++--------
 fs/jffs2/os-linux.h   |    2 +-
 fs/jffs2/super.c      |    4 ++--
 fs/reiserfs/journal.c |    6 +++---
 fs/reiserfs/resize.c  |    2 +-
 fs/reiserfs/super.c   |   10 +++++-----
 fs/super.c            |    4 ++--
 fs/sync.c             |    2 +-
 fs/sysv/inode.c       |    8 ++++----
 fs/sysv/super.c       |    2 +-
 fs/sysv/sysv.h        |    2 +-
 fs/udf/super.c        |    6 +++---
 fs/udf/udfdecl.h      |    2 +-
 fs/ufs/balloc.c       |    8 ++++----
 fs/ufs/ialloc.c       |    4 ++--
 fs/ufs/super.c        |   12 ++++++------
 include/linux/fs.h    |   13 +++++++++++++
 45 files changed, 122 insertions(+), 105 deletions(-)

diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index 3e26271..feee52e 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -103,7 +103,7 @@ affs_free_block(struct super_block *sb, u32 block)
 	*(__be32 *)bh->b_data = cpu_to_be32(tmp - mask);
 
 	mark_buffer_dirty(bh);
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	bm->bm_free++;
 
 	mutex_unlock(&sbi->s_bmlock);
@@ -248,7 +248,7 @@ find_bit:
 	*(__be32 *)bh->b_data = cpu_to_be32(tmp + mask);
 
 	mark_buffer_dirty(bh);
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 
 	mutex_unlock(&sbi->s_bmlock);
 
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 16a3e47..e391eed 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -69,9 +69,13 @@ affs_write_super(struct super_block *sb)
 		//		if (buffer_dirty(sbi->s_bitmap[i].bm_bh)) {
 		//			clean = 0;
 		affs_commit_super(sb, clean);
-		sb->s_dirt = !clean;	/* redo until bitmap synced */
+		/* redo until bitmap synced */
+		if (clean)
+			sb_mark_clean(sb);
+		else
+			sb_mark_dirty(sb);
 	} else
-		sb->s_dirt = 0;
+		sb_mark_clean(sb);
 	unlock_super(sb);
 
 	pr_debug("AFFS: write_super() at %lu, clean=%d\n", get_seconds(), clean);
@@ -82,7 +86,7 @@ affs_sync_fs(struct super_block *sb, int wait)
 {
 	lock_super(sb);
 	affs_commit_super(sb, 2);
-	sb->s_dirt = 0;
+	sb_mark_clean(sb);
 	unlock_super(sb);
 	return 0;
 }
@@ -554,8 +558,8 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 		return 0;
 	}
 	if (*flags & MS_RDONLY) {
-		sb->s_dirt = 1;
-		while (sb->s_dirt)
+		sb_mark_dirty(sb);
+		while (sb_is_dirty(sb))
 			affs_write_super(sb);
 		affs_free_bitmap(sb);
 	} else
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index f22a7d3..f59220b 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -223,7 +223,7 @@ static int bfs_sync_fs(struct super_block *sb, int wait)
 
 	mutex_lock(&info->bfs_lock);
 	mark_buffer_dirty(info->si_sbh);
-	sb->s_dirt = 0;
+	sb_mark_clean(sb);
 	mutex_unlock(&info->bfs_lock);
 
 	return 0;
@@ -234,7 +234,7 @@ static void bfs_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		bfs_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		sb_mark_clean(sb);
 }
 
 static void bfs_put_super(struct super_block *s)
@@ -246,7 +246,7 @@ static void bfs_put_super(struct super_block *s)
 
 	lock_kernel();
 
-	if (s->s_dirt)
+	if (sb_is_dirty(s))
 		bfs_write_super(s);
 
 	brelse(info->si_sbh);
@@ -474,7 +474,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	brelse(bh);
 	if (!(s->s_flags & MS_RDONLY)) {
 		mark_buffer_dirty(info->si_sbh);
-		s->s_dirt = 1;
+		sb_mark_dirty(s);
 	} 
 	dump_imap("read_super", s);
 	return 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fa6ccc1..caa4ed9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2938,7 +2938,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, root, dir);
 	BUG_ON(ret);
-	dir->i_sb->s_dirt = 1;
+	sb_mark_dirty(dir->i_sb);
 
 	btrfs_free_path(path);
 	return 0;
diff --git a/fs/exofs/file.c b/fs/exofs/file.c
index fef6899..4b04e7f 100644
--- a/fs/exofs/file.c
+++ b/fs/exofs/file.c
@@ -57,7 +57,7 @@ static int exofs_file_fsync(struct file *filp, int datasync)
 	/* This is a good place to write the sb */
 	/* TODO: Sechedule an sb-sync on create */
 	sb = inode->i_sb;
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		exofs_sync_fs(sb, 1);
 
 	return ret;
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 4bb6ef8..e694184 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1152,7 +1152,7 @@ struct inode *exofs_new_inode(struct inode *dir, int mode)
 
 	sbi = sb->s_fs_info;
 
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	inode_init_owner(inode, dir, mode);
 	inode->i_ino = sbi->s_nextid++;
 	inode->i_blkbits = EXOFS_BLKSHIFT;
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 03149b9..74ccbdc 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -237,7 +237,7 @@ int exofs_sync_fs(struct super_block *sb, int wait)
 		EXOFS_ERR("%s: exofs_sbi_write failed.\n", __func__);
 		goto out;
 	}
-	sb->s_dirt = 0;
+	sb_mark_clean(sb);
 
 out:
 	EXOFS_DBGMSG("s_nextid=0x%llx ret=%d\n", _LLU(sbi->s_nextid), ret);
@@ -251,7 +251,7 @@ static void exofs_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		exofs_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		sb_mark_clean(sb);
 }
 
 static void _exofs_print_device(const char *msg, const char *dev_path,
@@ -286,7 +286,7 @@ static void exofs_put_super(struct super_block *sb)
 	int num_pend;
 	struct exofs_sb_info *sbi = sb->s_fs_info;
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		exofs_write_super(sb);
 
 	/* make sure there are no pending commands */
diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index e8766a3..13c2fd1 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -165,7 +165,7 @@ static void release_blocks(struct super_block *sb, int count)
 		struct ext2_sb_info *sbi = EXT2_SB(sb);
 
 		percpu_counter_add(&sbi->s_freeblocks_counter, count);
-		sb->s_dirt = 1;
+		sb_mark_dirty(sb);
 	}
 }
 
@@ -180,7 +180,7 @@ static void group_adjust_blocks(struct super_block *sb, int group_no,
 		free_blocks = le16_to_cpu(desc->bg_free_blocks_count);
 		desc->bg_free_blocks_count = cpu_to_le16(free_blocks + count);
 		spin_unlock(sb_bgl_lock(sbi, group_no));
-		sb->s_dirt = 1;
+		sb_mark_dirty(sb);
 		mark_buffer_dirty(bh);
 	}
 }
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 938dbc7..5bb71a2 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -81,7 +81,7 @@ static void ext2_release_inode(struct super_block *sb, int group, int dir)
 	spin_unlock(sb_bgl_lock(EXT2_SB(sb), group));
 	if (dir)
 		percpu_counter_dec(&EXT2_SB(sb)->s_dirs_counter);
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	mark_buffer_dirty(bh);
 }
 
@@ -547,7 +547,7 @@ got:
 	}
 	spin_unlock(sb_bgl_lock(sbi, group));
 
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	mark_buffer_dirty(bh2);
 	if (test_opt(sb, GRPID)) {
 		inode->i_mode = mode;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 7ff43f4..39eb5df 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -121,7 +121,7 @@ static void ext2_put_super (struct super_block * sb)
 
 	dquot_disable(sb, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		ext2_write_super(sb);
 
 	ext2_xattr_put_super(sb);
@@ -1155,7 +1155,7 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 	if (wait)
 		sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
-	sb->s_dirt = 0;
+	sb_mark_clean(sb);
 }
 
 /*
@@ -1189,7 +1189,7 @@ void ext2_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		ext2_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		sb_mark_clean(sb);
 }
 
 static int ext2_remount (struct super_block * sb, int * flags, char * data)
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 7c39157..31f66b9 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -348,7 +348,7 @@ static void ext2_xattr_update_super_block(struct super_block *sb)
 	spin_lock(&EXT2_SB(sb)->s_lock);
 	EXT2_SET_COMPAT_FEATURE(sb, EXT2_FEATURE_COMPAT_EXT_ATTR);
 	spin_unlock(&EXT2_SB(sb)->s_lock);
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 }
 
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 95b7594..4d23090 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -477,7 +477,7 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	ret = ext4_handle_dirty_metadata(handle, NULL, gd_bh);
 	if (!err)
 		err = ret;
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 
 error_return:
 	brelse(bitmap_bh);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 5313ae4..42f2a8d 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -123,7 +123,7 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 		if (!IS_ERR(cp)) {
 			memcpy(sbi->s_es->s_last_mounted, cp,
 			       sizeof(sbi->s_es->s_last_mounted));
-			sb->s_dirt = 1;
+			sb_mark_dirty(sb);
 		}
 	}
 	return dquot_file_open(inode, filp);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 25c4b31..bb0ffb1 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -279,7 +279,7 @@ out:
 		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 		if (!fatal)
 			fatal = err;
-		sb->s_dirt = 1;
+		sb_mark_dirty(sb);
 	} else
 		ext4_error(sb, "bit already cleared for inode %lu", ino);
 
@@ -965,7 +965,7 @@ got:
 	percpu_counter_dec(&sbi->s_freeinodes_counter);
 	if (S_ISDIR(mode))
 		percpu_counter_inc(&sbi->s_dirs_counter);
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 
 	if (sbi->s_log_groups_per_flex) {
 		flex_group = ext4_flex_group(sbi, group);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 19df61c..aa758cb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5295,7 +5295,7 @@ static int ext4_do_update_inode(handle_t *handle,
 			ext4_update_dynamic_rev(sb);
 			EXT4_SET_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
-			sb->s_dirt = 1;
+			sb_mark_dirty(sb);
 			ext4_handle_sync(handle);
 			err = ext4_handle_dirty_metadata(handle, NULL,
 					EXT4_SB(sb)->s_sbh);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 12b3bc0..cca55ff 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2812,7 +2812,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
 
 out_err:
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	brelse(bitmap_bh);
 	return err;
 }
@@ -4680,7 +4680,7 @@ do_more:
 		put_bh(bitmap_bh);
 		goto do_more;
 	}
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 error_return:
 	if (freed)
 		dquot_free_block(inode, freed);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 6df797e..0a90057 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -922,7 +922,7 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	}
 
 	ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 
 exit_journal:
 	mutex_unlock(&sbi->s_resize_lock);
@@ -1046,7 +1046,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	}
 	ext4_blocks_count_set(es, o_blocks_count + add);
 	ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	mutex_unlock(&EXT4_SB(sb)->s_resize_lock);
 	ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
 		   o_blocks_count + add);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e8983a..d1707a0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -653,7 +653,7 @@ static void ext4_put_super(struct super_block *sb)
 
 	lock_super(sb);
 	lock_kernel();
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		ext4_commit_super(sb, 1);
 
 	if (sbi->s_journal) {
@@ -2686,7 +2686,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #else
 		es->s_flags |= cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
 #endif
-		sb->s_dirt = 1;
+		sb_mark_dirty(sb);
 	}
 
 	if (sbi->s_blocks_per_group > blocksize * 8) {
@@ -3392,7 +3392,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 					&EXT4_SB(sb)->s_freeblocks_counter));
 	es->s_free_inodes_count = cpu_to_le32(percpu_counter_sum_positive(
 					&EXT4_SB(sb)->s_freeinodes_counter));
-	sb->s_dirt = 0;
+	sb_mark_clean(sb);
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
 	if (sync) {
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 0433800..c539104 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -458,7 +458,7 @@ static void ext4_xattr_update_super_block(handle_t *handle,
 
 	if (ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh) == 0) {
 		EXT4_SET_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_EXT_ATTR);
-		sb->s_dirt = 1;
+		sb_mark_dirty(sb);
 		ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
 	}
 }
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 81184d3..5853dca 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -498,7 +498,7 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 				sbi->prev_free = entry;
 				if (sbi->free_clusters != -1)
 					sbi->free_clusters--;
-				sb->s_dirt = 1;
+				sb_mark_dirty(sb);
 
 				cluster[idx_clus] = entry;
 				idx_clus++;
@@ -520,7 +520,7 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 	/* Couldn't allocate the free entries */
 	sbi->free_clusters = 0;
 	sbi->free_clus_valid = 1;
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	err = -ENOSPC;
 
 out:
@@ -586,7 +586,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
 		ops->ent_put(&fatent, FAT_ENT_FREE);
 		if (sbi->free_clusters != -1) {
 			sbi->free_clusters++;
-			sb->s_dirt = 1;
+			sb_mark_dirty(sb);
 		}
 
 		if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
@@ -676,7 +676,7 @@ int fat_count_free_clusters(struct super_block *sb)
 	}
 	sbi->free_clusters = free;
 	sbi->free_clus_valid = 1;
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	fatent_brelse(&fatent);
 out:
 	unlock_fat(sbi);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 7bf45ae..d589149 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -465,7 +465,7 @@ static void fat_clear_inode(struct inode *inode)
 static void fat_write_super(struct super_block *sb)
 {
 	lock_super(sb);
-	sb->s_dirt = 0;
+	sb_mark_clean(sb);
 
 	if (!(sb->s_flags & MS_RDONLY))
 		fat_clusters_flush(sb);
@@ -476,9 +476,9 @@ static int fat_sync_fs(struct super_block *sb, int wait)
 {
 	int err = 0;
 
-	if (sb->s_dirt) {
+	if (sb_is_dirty(sb)) {
 		lock_super(sb);
-		sb->s_dirt = 0;
+		sb_mark_clean(sb);
 		err = fat_clusters_flush(sb);
 		unlock_super(sb);
 	}
@@ -492,7 +492,7 @@ static void fat_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		fat_write_super(sb);
 
 	iput(sbi->fat_inode);
diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
index 2c16316..b008ba8 100644
--- a/fs/hfs/extent.c
+++ b/fs/hfs/extent.c
@@ -432,7 +432,7 @@ out:
 		if (inode->i_ino < HFS_FIRSTUSER_CNID)
 			set_bit(HFS_FLG_ALT_MDB_DIRTY, &HFS_SB(sb)->flags);
 		set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-		sb->s_dirt = 1;
+		sb_mark_dirty(sb);
 	}
 	return res;
 
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index fe35e3b..99b5866 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -251,7 +251,7 @@ static inline const char *hfs_mdb_name(struct super_block *sb)
 static inline void hfs_bitmap_dirty(struct super_block *sb)
 {
 	set_bit(HFS_FLG_BITMAP_DIRTY, &HFS_SB(sb)->flags);
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 }
 
 static inline void hfs_buffer_sync(struct buffer_head *bh)
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 14f5cb1..9d06baf 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -198,7 +198,7 @@ struct inode *hfs_new_inode(struct inode *dir, struct qstr *name, int mode)
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
 	set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 
 	return inode;
 }
@@ -213,7 +213,7 @@ void hfs_delete_inode(struct inode *inode)
 		if (HFS_I(inode)->cat_key.ParID == cpu_to_be32(HFS_ROOT_CNID))
 			HFS_SB(sb)->root_dirs--;
 		set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-		sb->s_dirt = 1;
+		sb_mark_dirty(sb);
 		return;
 	}
 	HFS_SB(sb)->file_count--;
@@ -226,7 +226,7 @@ void hfs_delete_inode(struct inode *inode)
 		}
 	}
 	set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 }
 
 void hfs_inode_read_fork(struct inode *inode, struct hfs_extent *ext,
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 0a81eb7..bf71f6f 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -52,7 +52,7 @@ MODULE_LICENSE("GPL");
 static void hfs_write_super(struct super_block *sb)
 {
 	lock_super(sb);
-	sb->s_dirt = 0;
+	sb_mark_clean(sb);
 
 	/* sync everything to the buffers */
 	if (!(sb->s_flags & MS_RDONLY))
@@ -64,7 +64,7 @@ static int hfs_sync_fs(struct super_block *sb, int wait)
 {
 	lock_super(sb);
 	hfs_mdb_commit(sb);
-	sb->s_dirt = 0;
+	sb_mark_clean(sb);
 	unlock_super(sb);
 
 	return 0;
@@ -81,7 +81,7 @@ static void hfs_put_super(struct super_block *sb)
 {
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		hfs_write_super(sb);
 	hfs_mdb_close(sb);
 	/* release the MDB's resources */
diff --git a/fs/hfsplus/bitmap.c b/fs/hfsplus/bitmap.c
index ea30afc..81e10c3 100644
--- a/fs/hfsplus/bitmap.c
+++ b/fs/hfsplus/bitmap.c
@@ -151,7 +151,7 @@ done:
 	kunmap(page);
 	*max = offset + (curr - pptr) * 32 + i - start;
 	HFSPLUS_SB(sb).free_blocks -= *max;
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	dprint(DBG_BITMAP, "-> %u,%u\n", start, *max);
 out:
 	mutex_unlock(&HFSPLUS_SB(sb).alloc_file->i_mutex);
@@ -225,7 +225,7 @@ out:
 	set_page_dirty(page);
 	kunmap(page);
 	HFSPLUS_SB(sb).free_blocks += len;
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	mutex_unlock(&HFSPLUS_SB(sb).alloc_file->i_mutex);
 
 	return 0;
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 764fd1b..a572b02 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -305,7 +305,7 @@ static int hfsplus_link(struct dentry *src_dentry, struct inode *dst_dir,
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 	HFSPLUS_SB(sb).file_count++;
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 
 	return 0;
 }
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 9bbb829..3d19930 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -333,7 +333,7 @@ struct inode *hfsplus_new_inode(struct super_block *sb, int mode)
 		HFSPLUS_SB(sb).file_count++;
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 
 	return inode;
 }
@@ -344,7 +344,7 @@ void hfsplus_delete_inode(struct inode *inode)
 
 	if (S_ISDIR(inode->i_mode)) {
 		HFSPLUS_SB(sb).folder_count--;
-		sb->s_dirt = 1;
+		sb_mark_dirty(sb);
 		return;
 	}
 	HFSPLUS_SB(sb).file_count--;
@@ -357,7 +357,7 @@ void hfsplus_delete_inode(struct inode *inode)
 		inode->i_size = 0;
 		hfsplus_file_truncate(inode);
 	}
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 }
 
 void hfsplus_inode_read_fork(struct inode *inode, struct hfsplus_fork_raw *fork)
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 74b473a..a90fc67 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -106,7 +106,7 @@ static int hfsplus_write_inode(struct inode *inode,
 	case HFSPLUS_EXT_CNID:
 		if (vhdr->ext_file.total_size != cpu_to_be64(inode->i_size)) {
 			HFSPLUS_SB(inode->i_sb).flags |= HFSPLUS_SB_WRITEBACKUP;
-			inode->i_sb->s_dirt = 1;
+			sb_mark_dirty(inode->i_sb);
 		}
 		hfsplus_inode_write_fork(inode, &vhdr->ext_file);
 		hfs_btree_write(HFSPLUS_SB(inode->i_sb).ext_tree);
@@ -114,7 +114,7 @@ static int hfsplus_write_inode(struct inode *inode,
 	case HFSPLUS_CAT_CNID:
 		if (vhdr->cat_file.total_size != cpu_to_be64(inode->i_size)) {
 			HFSPLUS_SB(inode->i_sb).flags |= HFSPLUS_SB_WRITEBACKUP;
-			inode->i_sb->s_dirt = 1;
+			sb_mark_dirty(inode->i_sb);
 		}
 		hfsplus_inode_write_fork(inode, &vhdr->cat_file);
 		hfs_btree_write(HFSPLUS_SB(inode->i_sb).cat_tree);
@@ -122,21 +122,21 @@ static int hfsplus_write_inode(struct inode *inode,
 	case HFSPLUS_ALLOC_CNID:
 		if (vhdr->alloc_file.total_size != cpu_to_be64(inode->i_size)) {
 			HFSPLUS_SB(inode->i_sb).flags |= HFSPLUS_SB_WRITEBACKUP;
-			inode->i_sb->s_dirt = 1;
+			sb_mark_dirty(inode->i_sb);
 		}
 		hfsplus_inode_write_fork(inode, &vhdr->alloc_file);
 		break;
 	case HFSPLUS_START_CNID:
 		if (vhdr->start_file.total_size != cpu_to_be64(inode->i_size)) {
 			HFSPLUS_SB(inode->i_sb).flags |= HFSPLUS_SB_WRITEBACKUP;
-			inode->i_sb->s_dirt = 1;
+			sb_mark_dirty(inode->i_sb);
 		}
 		hfsplus_inode_write_fork(inode, &vhdr->start_file);
 		break;
 	case HFSPLUS_ATTR_CNID:
 		if (vhdr->attr_file.total_size != cpu_to_be64(inode->i_size)) {
 			HFSPLUS_SB(inode->i_sb).flags |= HFSPLUS_SB_WRITEBACKUP;
-			inode->i_sb->s_dirt = 1;
+			sb_mark_dirty(inode->i_sb);
 		}
 		hfsplus_inode_write_fork(inode, &vhdr->attr_file);
 		hfs_btree_write(HFSPLUS_SB(inode->i_sb).attr_tree);
@@ -161,7 +161,7 @@ static int hfsplus_sync_fs(struct super_block *sb, int wait)
 	dprint(DBG_SUPER, "hfsplus_write_super\n");
 
 	lock_super(sb);
-	sb->s_dirt = 0;
+	sb_mark_clean(sb);
 
 	vhdr->free_blocks = cpu_to_be32(HFSPLUS_SB(sb).free_blocks);
 	vhdr->next_alloc = cpu_to_be32(HFSPLUS_SB(sb).next_alloc);
@@ -202,7 +202,7 @@ static void hfsplus_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		hfsplus_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		sb_mark_clean(sb);
 }
 
 static void hfsplus_put_super(struct super_block *sb)
@@ -213,7 +213,7 @@ static void hfsplus_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		hfsplus_write_super(sb);
 	if (!(sb->s_flags & MS_RDONLY) && HFSPLUS_SB(sb).s_vhdr) {
 		struct hfsplus_vh *vhdr = HFSPLUS_SB(sb).s_vhdr;
diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index 4791aac..b1cdf3b 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -142,7 +142,7 @@ void jffs2_nor_wbuf_flash_cleanup(struct jffs2_sb_info *c);
 
 static inline void jffs2_dirty_trigger(struct jffs2_sb_info *c)
 {
-	OFNI_BS_2SFFJ(c)->s_dirt = 1;
+	sb_mark_dirty(OFNI_BS_2SFFJ(c));
 }
 
 /* background.c */
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 511e2d6..c328018 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -59,7 +59,7 @@ static void jffs2_write_super(struct super_block *sb)
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
 
 	lock_super(sb);
-	sb->s_dirt = 0;
+	sb_mark_clean(sb);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		D1(printk(KERN_DEBUG "jffs2_write_super()\n"));
@@ -194,7 +194,7 @@ static void jffs2_put_super (struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		jffs2_write_super(sb);
 
 	mutex_lock(&c->alloc_sem);
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 19fbc81..8cfb26d 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -3337,7 +3337,7 @@ int journal_mark_dirty(struct reiserfs_transaction_handle *th,
 			       th->t_trans_id, journal->j_trans_id);
 	}
 
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 
 	prepared = test_clear_buffer_journal_prepared(bh);
 	clear_buffer_journal_restore_dirty(bh);
@@ -3632,7 +3632,7 @@ int reiserfs_flush_old_commits(struct super_block *sb)
 			do_journal_end(&th, sb, 1, COMMIT_NOW | WAIT);
 		}
 	}
-	return sb->s_dirt;
+	return sb_is_dirty(sb);
 }
 
 /*
@@ -4062,7 +4062,7 @@ static int do_journal_end(struct reiserfs_transaction_handle *th,
 	 ** it tells us if we should continue with the journal_end, or just return
 	 */
 	if (!check_journal_end(th, sb, nblocks, flags)) {
-		sb->s_dirt = 1;
+		sb_mark_dirty(sb);
 		wake_queued_writers(sb);
 		reiserfs_async_progress_wait(sb);
 		goto out;
diff --git a/fs/reiserfs/resize.c b/fs/reiserfs/resize.c
index b3a94d2..9e3caf5 100644
--- a/fs/reiserfs/resize.c
+++ b/fs/reiserfs/resize.c
@@ -203,7 +203,7 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 					  (bmap_nr_new - bmap_nr)));
 	PUT_SB_BLOCK_COUNT(s, block_count_new);
 	PUT_SB_BMAP_NR(s, bmap_would_wrap(bmap_nr_new) ? : bmap_nr_new);
-	s->s_dirt = 1;
+	sb_mark_dirty(s);
 
 	journal_mark_dirty(&th, s, SB_BUFFER_WITH_SB(s));
 
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 9822fa1..d62a75f 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -71,8 +71,8 @@ static int reiserfs_sync_fs(struct super_block *s, int wait)
 	if (!journal_begin(&th, s, 1))
 		if (!journal_end_sync(&th, s, 1))
 			reiserfs_flush_old_commits(s);
-	s->s_dirt = 0;	/* Even if it's not true.
-			 * We'll loop forever in sync_supers otherwise */
+	sb_mark_clean(s); /* Even if it's not true.
+			   * We'll loop forever in sync_supers otherwise */
 	reiserfs_write_unlock(s);
 	return 0;
 }
@@ -98,7 +98,7 @@ static int reiserfs_freeze(struct super_block *s)
 			journal_end_sync(&th, s, 1);
 		}
 	}
-	s->s_dirt = 0;
+	sb_mark_clean(s);
 	reiserfs_write_unlock(s);
 	return 0;
 }
@@ -478,7 +478,7 @@ static void reiserfs_put_super(struct super_block *s)
 
 	reiserfs_write_lock(s);
 
-	if (s->s_dirt)
+	if (sb_is_dirty(s))
 		reiserfs_write_super(s);
 
 	/* change file system state to current state if it was mounted with read-write permissions */
@@ -1307,7 +1307,7 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	err = journal_end(&th, s, 10);
 	if (err)
 		goto out_err;
-	s->s_dirt = 0;
+	sb_mark_clean(s);
 
 	if (!(*mount_flags & MS_RDONLY)) {
 		dquot_resume(s, -1);
diff --git a/fs/super.c b/fs/super.c
index 5c35bc7..76b13c6 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -364,12 +364,12 @@ void sync_supers(void)
 	list_for_each_entry_safe(sb, n, &super_blocks, s_list) {
 		if (list_empty(&sb->s_instances))
 			continue;
-		if (sb->s_op->write_super && sb->s_dirt) {
+		if (sb->s_op->write_super && sb_is_dirty(sb)) {
 			sb->s_count++;
 			spin_unlock(&sb_lock);
 
 			down_read(&sb->s_umount);
-			if (sb->s_root && sb->s_dirt)
+			if (sb->s_root && sb_is_dirty(sb))
 				sb->s_op->write_super(sb);
 			up_read(&sb->s_umount);
 
diff --git a/fs/sync.c b/fs/sync.c
index 15aa6f0..fffcd71 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -142,7 +142,7 @@ int file_fsync(struct file *filp, int datasync)
 
 	/* sync the superblock to buffers */
 	sb = inode->i_sb;
-	if (sb->s_dirt && sb->s_op->write_super)
+	if (sb_is_dirty(sb) && sb->s_op->write_super)
 		sb->s_op->write_super(sb);
 
 	/* .. finally sync the buffers to disk */
diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index d4a5380..24d63bb 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -43,7 +43,7 @@ static int sysv_sync_fs(struct super_block *sb, int wait)
 	 * then attach current time stamp.
 	 * But if the filesystem was marked clean, keep it clean.
 	 */
-	sb->s_dirt = 0;
+	sb_mark_clean(sb);
 	old_time = fs32_to_cpu(sbi, *sbi->s_sb_time);
 	if (sbi->s_type == FSTYPE_SYSV4) {
 		if (*sbi->s_sb_state == cpu_to_fs32(sbi, 0x7c269d38 - old_time))
@@ -62,7 +62,7 @@ static void sysv_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		sysv_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		sb_mark_clean(sb);
 }
 
 static int sysv_remount(struct super_block *sb, int *flags, char *data)
@@ -72,7 +72,7 @@ static int sysv_remount(struct super_block *sb, int *flags, char *data)
 	if (sbi->s_forced_ro)
 		*flags |= MS_RDONLY;
 	if (!(*flags & MS_RDONLY))
-		sb->s_dirt = 1;
+		sb_mark_dirty(sb);
 	unlock_super(sb);
 	return 0;
 }
@@ -81,7 +81,7 @@ static void sysv_put_super(struct super_block *sb)
 {
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		sysv_write_super(sb);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index 5a903da..d665dbb 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -347,7 +347,7 @@ static int complete_read_super(struct super_block *sb, int silent, int size)
 		sb->s_flags |= MS_RDONLY;
 	if (sbi->s_truncate)
 		sb->s_root->d_op = &sysv_dentry_operations;
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	return 1;
 }
 
diff --git a/fs/sysv/sysv.h b/fs/sysv/sysv.h
index 94cb9b4..b78e436 100644
--- a/fs/sysv/sysv.h
+++ b/fs/sysv/sysv.h
@@ -118,7 +118,7 @@ static inline void dirty_sb(struct super_block *sb)
 	mark_buffer_dirty(sbi->s_bh1);
 	if (sbi->s_bh1 != sbi->s_bh2)
 		mark_buffer_dirty(sbi->s_bh2);
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 }
 
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 612d1e2..e213ca4 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1941,7 +1941,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	sb->s_op = &udf_sb_ops;
 	sb->s_export_op = &udf_export_ops;
 
-	sb->s_dirt = 0;
+	sb_mark_clean(sb);
 	sb->s_magic = UDF_SUPER_MAGIC;
 	sb->s_time_gran = 1000;
 
@@ -2068,7 +2068,7 @@ static void udf_error(struct super_block *sb, const char *function,
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		/* mark sb error */
-		sb->s_dirt = 1;
+		sb_mark_dirty(sb);
 	}
 	va_start(args, fmt);
 	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
@@ -2128,7 +2128,7 @@ static int udf_sync_fs(struct super_block *sb, int wait)
 		 * the buffer for IO
 		 */
 		mark_buffer_dirty(sbi->s_lvid_bh);
-		sb->s_dirt = 0;
+		sb_mark_clean(sb);
 		sbi->s_lvid_dirty = 0;
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 2bac035..d60cd33 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -120,7 +120,7 @@ static inline void udf_updated_lvid(struct super_block *sb)
 	WARN_ON_ONCE(((struct logicalVolIntegrityDesc *)
 		     bh->b_data)->integrityType !=
 		     cpu_to_le32(LVID_INTEGRITY_TYPE_OPEN));
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	UDF_SB(sb)->s_lvid_dirty = 1;
 }
 
diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 048484f..47462e1 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -118,7 +118,7 @@ void ufs_free_fragments(struct inode *inode, u64 fragment, unsigned count)
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	
 	unlock_super (sb);
 	UFSD("EXIT\n");
@@ -218,7 +218,7 @@ do_more:
 		goto do_more;
 	}
 
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	unlock_super (sb);
 	UFSD("EXIT\n");
 	return;
@@ -562,7 +562,7 @@ static u64 ufs_add_fragments(struct inode *inode, u64 fragment,
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 
 	UFSD("EXIT, fragment %llu\n", (unsigned long long)fragment);
 	
@@ -684,7 +684,7 @@ succed:
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 
 	result += cgno * uspi->s_fpg;
 	UFSD("EXIT3, result %llu\n", (unsigned long long)result);
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index 594480e..54a2e1a 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -120,7 +120,7 @@ void ufs_free_inode (struct inode * inode)
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
 	
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 	unlock_super (sb);
 	UFSD("EXIT\n");
 }
@@ -296,7 +296,7 @@ cg_found:
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	sb_mark_dirty(sb);
 
 	inode->i_ino = cg * uspi->s_ipg + bit;
 	inode_init_owner(inode, dir, mode);
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 3ec5a9e..8554ded 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -287,7 +287,7 @@ void ufs_error (struct super_block * sb, const char * function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		sb->s_dirt = 1;
+		sb_mark_dirty(sb);
 		sb->s_flags |= MS_RDONLY;
 	}
 	va_start (args, fmt);
@@ -320,7 +320,7 @@ void ufs_panic (struct super_block * sb, const char * function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		sb->s_dirt = 1;
+		sb_mark_dirty(sb);
 	}
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
@@ -1205,7 +1205,7 @@ static int ufs_sync_fs(struct super_block *sb, int wait)
 		ufs_set_fs_state(sb, usb1, usb3,
 				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
 	ufs_put_cstotal(sb);
-	sb->s_dirt = 0;
+	sb_mark_clean(sb);
 
 	UFSD("EXIT\n");
 	unlock_kernel();
@@ -1219,7 +1219,7 @@ static void ufs_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		ufs_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		sb_mark_clean(sb);
 }
 
 static void ufs_put_super(struct super_block *sb)
@@ -1228,7 +1228,7 @@ static void ufs_put_super(struct super_block *sb)
 		
 	UFSD("ENTER\n");
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		ufs_write_super(sb);
 
 	if (!(sb->s_flags & MS_RDONLY))
@@ -1298,7 +1298,7 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 			ufs_set_fs_state(sb, usb1, usb3,
 				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
 		ubh_mark_buffer_dirty (USPI_UBH(uspi));
-		sb->s_dirt = 0;
+		sb_mark_clean(sb);
 		sb->s_flags |= MS_RDONLY;
 	} else {
 	/*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 471e1ff..68ca1b0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1783,6 +1783,19 @@ extern int get_sb_pseudo(struct file_system_type *, char *,
 	struct vfsmount *mnt);
 extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 
+static inline void sb_mark_dirty(struct super_block *sb)
+{
+	sb->s_dirt = 1;
+}
+static inline void sb_mark_clean(struct super_block *sb)
+{
+	sb->s_dirt = 0;
+}
+static inline int sb_is_dirty(struct super_block *sb)
+{
+	return sb->s_dirt;
+}
+
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops) \
 	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
-- 
1.7.0.1

