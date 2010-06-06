Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126Ab0FFO4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:56:36 -0400
Received: from smtp.nokia.com ([192.100.105.134]:18220 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869Ab0FFOxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:30 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCHv5 08/16] BFS: clean up the superblock usage
Date: Sun,  6 Jun 2010 17:50:21 +0300
Message-Id: <1275835829-1478-9-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 06 Jun 2010 14:53:25.0099 (UTC) FILETIME=[03FFFBB0:01CB0588]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

BFS superblocks contains only static information and is never
changed. However, the BFS code for some misterious reasons
marked its buffer head as dirty from time to time, but nothing
in that buffer was ever changed.

This patch removes all the BFS superblock manipulation, simply
because it is not needed. It removes:

1. The si_sbh filed from 'struct bfs_sb_info' because it is not needed.
   We only need to read the SB once on mount to get the start of
   data blocks and the FS size. After this, we can forget about the
   SB.
2. All instances of 'mark_buffer_dirty()' because the SB is never
   changed.
3. The ->sync_fs method because there is nothing to sync except the
   inodes, which are synched by VFS.
4. The ->write_super method because the SB is never changed.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/bfs/bfs.h   |    1 -
 fs/bfs/file.c  |    3 ---
 fs/bfs/inode.c |   46 +++++++---------------------------------------
 3 files changed, 7 insertions(+), 43 deletions(-)

diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
index 7109e45..f7f87e2 100644
--- a/fs/bfs/bfs.h
+++ b/fs/bfs/bfs.h
@@ -17,7 +17,6 @@ struct bfs_sb_info {
 	unsigned long si_lf_eblk;
 	unsigned long si_lasti;
 	unsigned long *si_imap;
-	struct buffer_head *si_sbh;		/* buffer header w/superblock */
 	struct mutex bfs_lock;
 };
 
diff --git a/fs/bfs/file.c b/fs/bfs/file.c
index 88b9a3f..5c8ffce 100644
--- a/fs/bfs/file.c
+++ b/fs/bfs/file.c
@@ -70,7 +70,6 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 	struct super_block *sb = inode->i_sb;
 	struct bfs_sb_info *info = BFS_SB(sb);
 	struct bfs_inode_info *bi = BFS_I(inode);
-	struct buffer_head *sbh = info->si_sbh;
 
 	phys = bi->i_sblock + block;
 	if (!create) {
@@ -112,7 +111,6 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 		info->si_freeb -= phys - bi->i_eblock;
 		info->si_lf_eblk = bi->i_eblock = phys;
 		mark_inode_dirty(inode);
-		mark_buffer_dirty(sbh);
 		err = 0;
 		goto out;
 	}
@@ -147,7 +145,6 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 	 */
 	info->si_freeb -= bi->i_eblock - bi->i_sblock + 1 - inode->i_blocks;
 	mark_inode_dirty(inode);
-	mark_buffer_dirty(sbh);
 	map_bh(bh_result, sb, phys);
 out:
 	mutex_unlock(&info->bfs_lock);
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index f59220b..fe152dd 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -31,7 +31,6 @@ MODULE_LICENSE("GPL");
 #define dprintf(x...)
 #endif
 
-static void bfs_write_super(struct super_block *s);
 void dump_imap(const char *prefix, struct super_block *s);
 
 struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
@@ -209,34 +208,12 @@ static void bfs_delete_inode(struct inode *inode)
 	 * "last block of the last file" even if there is no
 	 * real file there, saves us 1 gap.
 	 */
-	if (info->si_lf_eblk == bi->i_eblock) {
+	if (info->si_lf_eblk == bi->i_eblock)
 		info->si_lf_eblk = bi->i_sblock - 1;
-		mark_buffer_dirty(info->si_sbh);
-	}
 	mutex_unlock(&info->bfs_lock);
 	clear_inode(inode);
 }
 
-static int bfs_sync_fs(struct super_block *sb, int wait)
-{
-	struct bfs_sb_info *info = BFS_SB(sb);
-
-	mutex_lock(&info->bfs_lock);
-	mark_buffer_dirty(info->si_sbh);
-	sb_mark_clean(sb);
-	mutex_unlock(&info->bfs_lock);
-
-	return 0;
-}
-
-static void bfs_write_super(struct super_block *sb)
-{
-	if (!(sb->s_flags & MS_RDONLY))
-		bfs_sync_fs(sb, 1);
-	else
-		sb_mark_clean(sb);
-}
-
 static void bfs_put_super(struct super_block *s)
 {
 	struct bfs_sb_info *info = BFS_SB(s);
@@ -246,10 +223,6 @@ static void bfs_put_super(struct super_block *s)
 
 	lock_kernel();
 
-	if (sb_is_dirty(s))
-		bfs_write_super(s);
-
-	brelse(info->si_sbh);
 	mutex_destroy(&info->bfs_lock);
 	kfree(info->si_imap);
 	kfree(info);
@@ -321,8 +294,6 @@ static const struct super_operations bfs_sops = {
 	.write_inode	= bfs_write_inode,
 	.delete_inode	= bfs_delete_inode,
 	.put_super	= bfs_put_super,
-	.write_super	= bfs_write_super,
-	.sync_fs	= bfs_sync_fs,
 	.statfs		= bfs_statfs,
 };
 
@@ -349,7 +320,7 @@ void dump_imap(const char *prefix, struct super_block *s)
 
 static int bfs_fill_super(struct super_block *s, void *data, int silent)
 {
-	struct buffer_head *bh;
+	struct buffer_head *bh, *sbh;
 	struct bfs_super_block *bfs_sb;
 	struct inode *inode;
 	unsigned i, imap_len;
@@ -365,10 +336,10 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 
 	sb_set_blocksize(s, BFS_BSIZE);
 
-	info->si_sbh = sb_bread(s, 0);
-	if (!info->si_sbh)
+	sbh = sb_bread(s, 0);
+	if (!sbh)
 		goto out;
-	bfs_sb = (struct bfs_super_block *)info->si_sbh->b_data;
+	bfs_sb = (struct bfs_super_block *)sbh->b_data;
 	if (le32_to_cpu(bfs_sb->s_magic) != BFS_MAGIC) {
 		if (!silent)
 			printf("No BFS filesystem on %s (magic=%08x)\n", 
@@ -472,10 +443,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 			info->si_lf_eblk = eblock;
 	}
 	brelse(bh);
-	if (!(s->s_flags & MS_RDONLY)) {
-		mark_buffer_dirty(info->si_sbh);
-		sb_mark_dirty(s);
-	} 
+	brelse(sbh);
 	dump_imap("read_super", s);
 	return 0;
 
@@ -485,7 +453,7 @@ out3:
 out2:
 	kfree(info->si_imap);
 out1:
-	brelse(info->si_sbh);
+	brelse(sbh);
 out:
 	mutex_destroy(&info->bfs_lock);
 	kfree(info);
-- 
1.7.0.1

