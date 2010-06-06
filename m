Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab0FFOyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:54:38 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40163 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab0FFOxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:48 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCHv5 15/16] HFS: wait for sb synchronization when needed
Date: Sun,  6 Jun 2010 17:50:28 +0300
Message-Id: <1275835829-1478-16-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 06 Jun 2010 14:53:39.0324 (UTC) FILETIME=[0C7A8BC0:01CB0588]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

HFS does not ever wait for superblock synchronization in
->put_super(), ->write_super, and ->sync_fs().

However, it should wait for synchronization in ->put_super() because
it is about to be unmounted, in ->write_super() because this is
periodic SB synchronization berformed from a separate kernel thread,
and in ->sync_fs() it should respect the 'wait' flag. This patch fixes
this.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/hfs/hfs_fs.h |    2 +-
 fs/hfs/mdb.c    |    7 +++++--
 fs/hfs/super.c  |    4 ++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 3514e7a..78f7a7e 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -205,7 +205,7 @@ extern ssize_t hfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
 /* mdb.c */
 extern int hfs_mdb_get(struct super_block *);
-extern void hfs_mdb_commit(struct super_block *);
+extern void hfs_mdb_commit(struct super_block *, int);
 extern void hfs_mdb_close(struct super_block *);
 extern void hfs_mdb_put(struct super_block *);
 
diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index 159ab88..e451b2b 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -242,7 +242,7 @@ out:
  *   called by hfs_write_super() and hfs_btree_extend().
  * Input Variable(s):
  *   struct hfs_mdb *mdb: Pointer to the hfs MDB
- *   int backup;
+ *   int wait: whether we should wait for MDB reaching the media or not;
  * Output Variable(s):
  *   NONE
  * Returns:
@@ -256,7 +256,7 @@ out:
  *   If 'backup' is non-zero then the alternate MDB is also written
  *   and the function doesn't return until it is actually on disk.
  */
-void hfs_mdb_commit(struct super_block *sb)
+void hfs_mdb_commit(struct super_block *sb, int wait)
 {
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 
@@ -273,6 +273,8 @@ void hfs_mdb_commit(struct super_block *sb)
 
 		/* write MDB to disk */
 		mark_buffer_dirty(HFS_SB(sb)->mdb_bh);
+		if (wait)
+			sync_dirty_buffer(HFS_SB(sb)->mdb_bh);
 	}
 
 	/* write the backup MDB, not returning until it is written.
@@ -311,6 +313,7 @@ void hfs_mdb_commit(struct super_block *sb)
 			len = min((int)sb->s_blocksize - off, size);
 			memcpy(bh->b_data + off, ptr, len);
 			mark_buffer_dirty(bh);
+			sync_dirty_buffer(bh);
 			brelse(bh);
 			block++;
 			off = 0;
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 2f062ea..5dad479 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -54,14 +54,14 @@ static void hfs_write_super(struct super_block *sb)
 	lock_super(sb);
 	/* sync everything to the buffers */
 	if (!(sb->s_flags & MS_RDONLY))
-		hfs_mdb_commit(sb);
+		hfs_mdb_commit(sb, 1);
 	unlock_super(sb);
 }
 
 static int hfs_sync_fs(struct super_block *sb, int wait)
 {
 	lock_super(sb);
-	hfs_mdb_commit(sb);
+	hfs_mdb_commit(sb, wait);
 	unlock_super(sb);
 
 	return 0;
-- 
1.7.0.1

