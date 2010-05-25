Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab0EYNy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:54:58 -0400
Received: from smtp.nokia.com ([192.100.105.134]:35332 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373Ab0EYNu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:50:56 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org
Subject: [PATCHv4 13/17] SYSV: do not manipulate s_dirt directly
Date: Tue, 25 May 2010 16:49:08 +0300
Message-Id: <1274795352-3551-14-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 May 2010 13:50:52.0219 (UTC) FILETIME=[4A26F0B0:01CAFC11]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/sysv/inode.c |    6 +++---
 fs/sysv/super.c |    2 +-
 fs/sysv/sysv.h  |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index 4573734..03a6387 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -61,7 +61,7 @@ static void sysv_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		sysv_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 static int sysv_remount(struct super_block *sb, int *flags, char *data)
@@ -71,7 +71,7 @@ static int sysv_remount(struct super_block *sb, int *flags, char *data)
 	if (sbi->s_forced_ro)
 		*flags |= MS_RDONLY;
 	if (!(*flags & MS_RDONLY))
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	unlock_super(sb);
 	return 0;
 }
@@ -80,7 +80,7 @@ static void sysv_put_super(struct super_block *sb)
 {
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		sysv_write_super(sb);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index 5a903da..f0d3679 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -347,7 +347,7 @@ static int complete_read_super(struct super_block *sb, int silent, int size)
 		sb->s_flags |= MS_RDONLY;
 	if (sbi->s_truncate)
 		sb->s_root->d_op = &sysv_dentry_operations;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	return 1;
 }
 
diff --git a/fs/sysv/sysv.h b/fs/sysv/sysv.h
index 94cb9b4..f0441c2 100644
--- a/fs/sysv/sysv.h
+++ b/fs/sysv/sysv.h
@@ -118,7 +118,7 @@ static inline void dirty_sb(struct super_block *sb)
 	mark_buffer_dirty(sbi->s_bh1);
 	if (sbi->s_bh1 != sbi->s_bh2)
 		mark_buffer_dirty(sbi->s_bh2);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 }
 
 
-- 
1.6.6.1

