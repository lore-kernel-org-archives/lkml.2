Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2FLIOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:14:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:4813 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab2FLIMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:12:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164501666"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] hfs: push lock_super down
Date: Tue, 12 Jun 2012 11:13:33 +0300
Message-Id: <1339488818-14461-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339488818-14461-1-git-send-email-dedekind1@gmail.com>
References: <1339488818-14461-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

HFS uses 'lock_super()'/'unlock_super()' around 'hfs_mdb_commit()' in order
to serialize MDB (Master Directory Block) changes. Push it down to
'hfs_mdb_commit()' in order to simplify the code a bit.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/hfs/inode.c |    2 --
 fs/hfs/mdb.c   |    2 ++
 fs/hfs/super.c |    4 ----
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 761ec06..daf3d63 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -645,11 +645,9 @@ static int hfs_file_fsync(struct file *filp, loff_t start, loff_t end,
 	/* sync the superblock to buffers */
 	sb = inode->i_sb;
 	if (sb->s_dirt) {
-		lock_super(sb);
 		sb->s_dirt = 0;
 		if (!(sb->s_flags & MS_RDONLY))
 			hfs_mdb_commit(sb);
-		unlock_super(sb);
 	}
 	/* .. finally sync the buffers to disk */
 	err = sync_blockdev(sb->s_bdev);
diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index 1563d5c..3f558d58 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -260,6 +260,7 @@ void hfs_mdb_commit(struct super_block *sb)
 {
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 
+	lock_super(sb);
 	if (test_and_clear_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags)) {
 		/* These parameters may have been modified, so write them back */
 		mdb->drLsMod = hfs_mtime();
@@ -317,6 +318,7 @@ void hfs_mdb_commit(struct super_block *sb)
 			size -= len;
 		}
 	}
+	unlock_super(sb);
 }
 
 void hfs_mdb_close(struct super_block *sb)
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 7b4c537..f7c06bb 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -50,21 +50,17 @@ MODULE_LICENSE("GPL");
  */
 static void hfs_write_super(struct super_block *sb)
 {
-	lock_super(sb);
 	sb->s_dirt = 0;
 
 	/* sync everything to the buffers */
 	if (!(sb->s_flags & MS_RDONLY))
 		hfs_mdb_commit(sb);
-	unlock_super(sb);
 }
 
 static int hfs_sync_fs(struct super_block *sb, int wait)
 {
-	lock_super(sb);
 	hfs_mdb_commit(sb);
 	sb->s_dirt = 0;
-	unlock_super(sb);
 
 	return 0;
 }
-- 
1.7.7.6

