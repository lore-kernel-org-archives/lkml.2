Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab0EYNv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:51:28 -0400
Received: from smtp.nokia.com ([192.100.105.134]:35398 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493Ab0EYNvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:51:20 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCHv4 02/17] AFFS: do not manipulate s_dirt directly
Date: Tue, 25 May 2010 16:48:57 +0300
Message-Id: <1274795352-3551-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 May 2010 13:50:37.0063 (UTC) FILETIME=[411E5170:01CAFC11]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 fs/affs/bitmap.c |    4 ++--
 fs/affs/super.c  |   14 +++++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index 3e26271..e55ecde 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -103,7 +103,7 @@ affs_free_block(struct super_block *sb, u32 block)
 	*(__be32 *)bh->b_data = cpu_to_be32(tmp - mask);
 
 	mark_buffer_dirty(bh);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	bm->bm_free++;
 
 	mutex_unlock(&sbi->s_bmlock);
@@ -248,7 +248,7 @@ find_bit:
 	*(__be32 *)bh->b_data = cpu_to_be32(tmp + mask);
 
 	mark_buffer_dirty(bh);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	mutex_unlock(&sbi->s_bmlock);
 
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 16a3e47..ea8d0cd 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -69,9 +69,13 @@ affs_write_super(struct super_block *sb)
 		//		if (buffer_dirty(sbi->s_bitmap[i].bm_bh)) {
 		//			clean = 0;
 		affs_commit_super(sb, clean);
-		sb->s_dirt = !clean;	/* redo until bitmap synced */
+		/* redo until bitmap synced */
+		if (clean)
+			mark_sb_clean(sb);
+		else
+			mark_sb_dirty(sb);
 	} else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 	unlock_super(sb);
 
 	pr_debug("AFFS: write_super() at %lu, clean=%d\n", get_seconds(), clean);
@@ -82,7 +86,7 @@ affs_sync_fs(struct super_block *sb, int wait)
 {
 	lock_super(sb);
 	affs_commit_super(sb, 2);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	unlock_super(sb);
 	return 0;
 }
@@ -554,8 +558,8 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 		return 0;
 	}
 	if (*flags & MS_RDONLY) {
-		sb->s_dirt = 1;
-		while (sb->s_dirt)
+		mark_sb_dirty(sb);
+		while (is_sb_dirty(sb))
 			affs_write_super(sb);
 		affs_free_bitmap(sb);
 	} else
-- 
1.6.6.1

