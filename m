Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399Ab2CUQP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:15:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:3092 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759183Ab2CUQPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:15:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121560135"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] ext2: introduce own superblock dirty flag
Date: Wed, 21 Mar 2012 18:14:35 +0200
Message-Id: <1332346475-1441-9-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
References: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

We finally do not need VFS's 's_dirt' flag in ext2 - introduce our own
's_dirty' flag instead.

Note: the final goal is to get rid of the 'sync_supers()' kernel thread which
wakes up every 5 seconds and even if there is nothing to do. Thus, we are
pushing superblock management from VFS down to file-systems.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext2/super.c            |   16 ++++++++--------
 include/linux/ext2_fs_sb.h |    1 +
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 4eee017..bb12634 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1162,7 +1162,7 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 {
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 
-	sb->s_dirt = 0;
+	sbi->s_dirty = 0;
 	/*
 	 * Make sure we first mark the superblock as clean and then start
 	 * writing it out.
@@ -1213,7 +1213,7 @@ void ext2_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		ext2_sync_fs(sb, 1);
 	else {
-		sb->s_dirt = 0;
+		EXT2_SB(sb)->s_dirty = 0;
 		smp_wmb();
 	}
 }
@@ -1239,7 +1239,7 @@ static void write_super(struct work_struct *work)
 	kfree(sbwork);
 
 	smp_rmb();
-	if (sb->s_dirt)
+	if (EXT2_SB(sb)->s_dirty)
 		return;
 
 	ext2_write_super(sb);
@@ -1251,12 +1251,12 @@ void ext2_mark_super_dirty(struct super_block *sb)
 	struct sb_delayed_work *sbwork;
 	unsigned long delay;
 
-	/* Make sure we see 's_dirt' changes ASAP */
+	/* Make sure we see 's_dirty' changes ASAP */
 	smp_rmb();
-	if (sb->s_dirt == 1)
+	if (sbi->s_dirty == 1)
 		return;
-	sb->s_dirt = 1;
-	/* Make other CPUs see the 's_dirt' change as soon as possible */
+	sbi->s_dirty = 1;
+	/* Make other CPUs see the 's_dirty' change as soon as possible */
 	smp_wmb();
 
 	sbwork = kmalloc(sizeof(struct sb_delayed_work), GFP_NOFS);
@@ -1266,7 +1266,7 @@ void ext2_mark_super_dirty(struct super_block *sb)
 		 * trouble anyway, and the SB will be written out on unmount or
 		 * we may be luckier next time it is marked as dirty.
 		 */
-		sb->s_dirt = 2;
+		sbi->s_dirty = 2;
 		return;
 	}
 
diff --git a/include/linux/ext2_fs_sb.h b/include/linux/ext2_fs_sb.h
index 75aa40e..5938744 100644
--- a/include/linux/ext2_fs_sb.h
+++ b/include/linux/ext2_fs_sb.h
@@ -99,6 +99,7 @@ struct ext2_sb_info {
 	u32 s_next_generation;
 	unsigned long s_dir_count;
 	u8 *s_debts;
+	int s_dirty;
 	/* workqueue for synchronizing the superblock */
 	struct workqueue_struct *sync_super_wq;
 	struct percpu_counter s_freeblocks_counter;
-- 
1.7.7.6

