Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2FLOX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:23:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab2FLOVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:21:02 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@suse.cz,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 25/27] ext2: Implement freezing
Date: Tue, 12 Jun 2012 16:20:46 +0200
Message-Id: <1339510848-16992-26-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339510848-16992-1-git-send-email-jack@suse.cz>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only missing piece to make freezing work reliably with ext2 is to
stop iput() of unlinked inode from deleting the inode on frozen filesystem.
So add a necessary protection to ext2_evict_inode().

We also provide appropriate ->freeze_fs and ->unfreeze_fs functions.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c |    5 ++++-
 fs/ext2/super.c |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 264d315..6363ac6 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -79,6 +79,7 @@ void ext2_evict_inode(struct inode * inode)
 	truncate_inode_pages(&inode->i_data, 0);
 
 	if (want_delete) {
+		sb_start_intwrite(inode->i_sb);
 		/* set dtime */
 		EXT2_I(inode)->i_dtime	= get_seconds();
 		mark_inode_dirty(inode);
@@ -98,8 +99,10 @@ void ext2_evict_inode(struct inode * inode)
 	if (unlikely(rsv))
 		kfree(rsv);
 
-	if (want_delete)
+	if (want_delete) {
 		ext2_free_inode(inode);
+		sb_end_intwrite(inode->i_sb);
+	}
 }
 
 typedef struct {
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index b3621cb..25232c1 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -42,6 +42,8 @@ static void ext2_sync_super(struct super_block *sb,
 static int ext2_remount (struct super_block * sb, int * flags, char * data);
 static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf);
 static int ext2_sync_fs(struct super_block *sb, int wait);
+static int ext2_freeze(struct super_block *sb);
+static int ext2_unfreeze(struct super_block *sb);
 
 void ext2_error(struct super_block *sb, const char *function,
 		const char *fmt, ...)
@@ -305,6 +307,8 @@ static const struct super_operations ext2_sops = {
 	.evict_inode	= ext2_evict_inode,
 	.put_super	= ext2_put_super,
 	.sync_fs	= ext2_sync_fs,
+	.freeze_fs	= ext2_freeze,
+	.unfreeze_fs	= ext2_unfreeze,
 	.statfs		= ext2_statfs,
 	.remount_fs	= ext2_remount,
 	.show_options	= ext2_show_options,
@@ -1194,6 +1198,35 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	return 0;
 }
 
+static int ext2_freeze(struct super_block *sb)
+{
+	struct ext2_sb_info *sbi = EXT2_SB(sb);
+
+	/*
+	 * Open but unlinked files present? Keep EXT2_VALID_FS flag cleared
+	 * because we have unattached inodes and thus filesystem is not fully
+	 * consistent.
+	 */
+	if (atomic_long_read(&sb->s_remove_count)) {
+		ext2_sync_fs(sb, 1);
+		return 0;
+	}
+	/* Set EXT2_FS_VALID flag */
+	spin_lock(&sbi->s_lock);
+	sbi->s_es->s_state = cpu_to_le16(sbi->s_mount_state);
+	spin_unlock(&sbi->s_lock);
+	ext2_sync_super(sb, sbi->s_es, 1);
+
+	return 0;
+}
+
+static int ext2_unfreeze(struct super_block *sb)
+{
+	/* Just write sb to clear EXT2_VALID_FS flag */
+	ext2_write_super(sb);
+
+	return 0;
+}
 
 void ext2_write_super(struct super_block *sb)
 {
-- 
1.7.1

