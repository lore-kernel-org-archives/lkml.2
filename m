Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab0EYNvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:51:25 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50281 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab0EYNvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:51:22 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHv4 05/17] EXOFS: do not manipulate s_dirt directly
Date: Tue, 25 May 2010 16:49:00 +0300
Message-Id: <1274795352-3551-6-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 May 2010 13:50:41.0203 (UTC) FILETIME=[43960830:01CAFC11]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/file.c  |    2 +-
 fs/exofs/inode.c |    2 +-
 fs/exofs/super.c |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/exofs/file.c b/fs/exofs/file.c
index 839b9dc..be38834 100644
--- a/fs/exofs/file.c
+++ b/fs/exofs/file.c
@@ -58,7 +58,7 @@ static int exofs_file_fsync(struct file *filp, struct dentry *dentry,
 	/* This is a good place to write the sb */
 	/* TODO: Sechedule an sb-sync on create */
 	sb = inode->i_sb;
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		exofs_sync_fs(sb, 1);
 
 	return ret;
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index d7c6afa..0195dcc 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1122,7 +1122,7 @@ struct inode *exofs_new_inode(struct inode *dir, int mode)
 
 	sbi = sb->s_fs_info;
 
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	inode_init_owner(inode, dir, mode);
 	inode->i_ino = sbi->s_nextid++;
 	inode->i_blkbits = EXOFS_BLKSHIFT;
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 03149b9..91a32ea 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -237,7 +237,7 @@ int exofs_sync_fs(struct super_block *sb, int wait)
 		EXOFS_ERR("%s: exofs_sbi_write failed.\n", __func__);
 		goto out;
 	}
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 out:
 	EXOFS_DBGMSG("s_nextid=0x%llx ret=%d\n", _LLU(sbi->s_nextid), ret);
@@ -251,7 +251,7 @@ static void exofs_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		exofs_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 static void _exofs_print_device(const char *msg, const char *dev_path,
@@ -286,7 +286,7 @@ static void exofs_put_super(struct super_block *sb)
 	int num_pend;
 	struct exofs_sb_info *sbi = sb->s_fs_info;
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		exofs_write_super(sb);
 
 	/* make sure there are no pending commands */
-- 
1.6.6.1

