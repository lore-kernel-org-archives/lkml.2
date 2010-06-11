Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab0FKPJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 11:09:24 -0400
Received: from smtp.nokia.com ([192.100.122.233]:47705 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab0FKPJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 11:09:20 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] AFFS: wait for sb synchronization when needed
Date: Fri, 11 Jun 2010 18:05:20 +0300
Message-Id: <1276268720-7398-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1276268720-7398-1-git-send-email-dedekind1@gmail.com>
References: <1276268720-7398-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 11 Jun 2010 15:09:15.0702 (UTC) FILETIME=[0EAB3D60:01CB0978]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

AFFS does not ever wait for superblock synchronization in
->put_super(), ->write_super, and ->sync_fs().

However, it should wait for synchronization in ->put_super() because
it is about to be unmounted, in ->write_super() because this is
periodic SB synchronization performed from a separate kernel thread,
and in ->sync_fs() it should respect the 'wait' flag. This patch fixes
the situation.

Also, in ->put_super(), do not write the SB if it is not dirty.

Tested-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/affs/super.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index 8447451..9f6fbee 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -26,7 +26,7 @@ static int affs_statfs(struct dentry *dentry, struct kstatfs *buf);
 static int affs_remount (struct super_block *sb, int *flags, char *data);
 
 static void
-affs_commit_super(struct super_block *sb, int clean)
+affs_commit_super(struct super_block *sb, int wait, int clean)
 {
 	struct affs_sb_info *sbi = AFFS_SB(sb);
 	struct buffer_head *bh = sbi->s_root_bh;
@@ -36,6 +36,8 @@ affs_commit_super(struct super_block *sb, int clean)
 	secs_to_datestamp(get_seconds(), &tail->disk_change);
 	affs_fix_checksum(sb, bh);
 	mark_buffer_dirty(bh);
+	if (wait)
+		sync_dirty_buffer(bh);
 }
 
 static void
@@ -46,8 +48,8 @@ affs_put_super(struct super_block *sb)
 
 	lock_kernel();
 
-	if (!(sb->s_flags & MS_RDONLY))
-		affs_commit_super(sb, 1);
+	if (!(sb->s_flags & MS_RDONLY) && sb->s_dirt)
+		affs_commit_super(sb, 1, 1);
 
 	kfree(sbi->s_prefix);
 	affs_free_bitmap(sb);
@@ -63,7 +65,7 @@ affs_write_super(struct super_block *sb)
 {
 	lock_super(sb);
 	if (!(sb->s_flags & MS_RDONLY))
-		affs_commit_super(sb, 2);
+		affs_commit_super(sb, 1, 2);
 	sb->s_dirt = 0;
 	unlock_super(sb);
 
@@ -74,7 +76,7 @@ static int
 affs_sync_fs(struct super_block *sb, int wait)
 {
 	lock_super(sb);
-	affs_commit_super(sb, 2);
+	affs_commit_super(sb, wait, 2);
 	sb->s_dirt = 0;
 	unlock_super(sb);
 	return 0;
-- 
1.7.0.1

