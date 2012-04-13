Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2DMOTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:19:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:23882 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab2DMOT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:19:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="88726534"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH v2 4/4] fat: switch to fsinfo_inode
Date: Fri, 13 Apr 2012 17:19:55 +0300
Message-Id: <1334326795-2446-5-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Currently FAT file-system maps the VFS "superblock" abstraction to the FSINFO
block. The FSINFO block contains non-essential data about the amount of free
clusters and the next free cluster. FAT file-system can always find out this
information by scanning the FAT table, but having it in the FSINFO block may
speed things up sometimes. So FAT file-system relies on the VFS superblock
write-out services to make sure the FSINFO block is written out to the media
from time to time.

The whole "superblock write-out" VFS infrastructure is served by the
'sync_supers()' kernel thread, which wakes up every 5 (by default) seconds and
writes out all dirty superblock using the '->write_super()' call-back. But the
problem with this thread is that it wastes power by waking up the system every
5 seconds no matter what. So we want to kill it completely and thus, we need to
make file-systems to stop using the '->write_super' VFS service, and then
remove it together with the kernel thread.

This patch switches the FAT FSINFO block management from
'->write_super()'/'->s_dirt' to 'fsinfo_inode'/'->write_inode'. Now, instead of
setting the 's_dirt' flag, we just mark the special 'fsinfo_inode' inode as
dirty and let VFS invoke the '->write_inode' call-back when needed, where we
write-out the FSINFO block.

This patch also makes sure we do not mark the 'fsinfo_inode' inode as dirty if
we are not FAT32 (FAT16 and FAT12 do not have the FSINFO block) or if we are in
R/O mode.

As a bonus, we can also remove the '->sync_fs()' and '->write_super()' FAT
call-back function because they become unneeded.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/fat/fatent.c |    7 ++++++-
 fs/fat/inode.c  |   42 ++++++++++++------------------------------
 2 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 85a1ec4..efa1000 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -310,7 +310,12 @@ void fat_ent_access_init(struct super_block *sb)
 
 static void mark_fsinfo_dirty(struct super_block *sb)
 {
-	sb->s_dirt = 1;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+
+	if (sb->s_flags & MS_RDONLY || sbi->fat_bits != 32)
+		return;
+
+	__mark_inode_dirty(sbi->fsinfo_inode, I_DIRTY_SYNC);
 }
 
 static inline int fat_ent_update_ptr(struct super_block *sb,
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 91e9a8a..9a87ec4 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -459,37 +459,10 @@ static void fat_evict_inode(struct inode *inode)
 	fat_detach(inode);
 }
 
-static void fat_write_super(struct super_block *sb)
-{
-	lock_super(sb);
-	sb->s_dirt = 0;
-
-	if (!(sb->s_flags & MS_RDONLY))
-		fat_clusters_flush(sb);
-	unlock_super(sb);
-}
-
-static int fat_sync_fs(struct super_block *sb, int wait)
-{
-	int err = 0;
-
-	if (sb->s_dirt) {
-		lock_super(sb);
-		sb->s_dirt = 0;
-		err = fat_clusters_flush(sb);
-		unlock_super(sb);
-	}
-
-	return err;
-}
-
 static void fat_put_super(struct super_block *sb)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
-	if (sb->s_dirt)
-		fat_write_super(sb);
-
 	iput(sbi->fsinfo_inode);
 	iput(sbi->fat_inode);
 
@@ -662,7 +635,18 @@ retry:
 
 static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	return __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+	int err;
+
+	if (inode->i_ino == MSDOS_FSINFO_INO) {
+		struct super_block *sb = inode->i_sb;
+
+		lock_super(sb);
+		err = fat_clusters_flush(sb);
+		unlock_super(sb);
+	} else
+		err = __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+
+	return err;
 }
 
 int fat_sync_inode(struct inode *inode)
@@ -679,8 +663,6 @@ static const struct super_operations fat_sops = {
 	.write_inode	= fat_write_inode,
 	.evict_inode	= fat_evict_inode,
 	.put_super	= fat_put_super,
-	.write_super	= fat_write_super,
-	.sync_fs	= fat_sync_fs,
 	.statfs		= fat_statfs,
 	.remount_fs	= fat_remount,
 
-- 
1.7.7.6

