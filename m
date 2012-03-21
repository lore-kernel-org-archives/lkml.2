Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430Ab2CUQQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:16:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:3098 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759109Ab2CUQPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:15:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121560127"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/8] ext2: cleanup ext2_sync_super a bit
Date: Wed, 21 Mar 2012 18:14:34 +0200
Message-Id: <1332346475-1441-8-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
References: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

We have many 'EXT2_SB()' in 'ext2_sync_super()' and I am going to introduce a
new one. The code will be a bit nicer if I introduce an 'sbi' pointer instead.
So this patch is just a tiny preparational cleanup.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext2/super.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 95dc25f..4eee017 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1160,6 +1160,8 @@ static void ext2_clear_super_error(struct super_block *sb)
 static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 			    int wait)
 {
+	struct ext2_sb_info *sbi = EXT2_SB(sb);
+
 	sb->s_dirt = 0;
 	/*
 	 * Make sure we first mark the superblock as clean and then start
@@ -1168,15 +1170,15 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 	smp_wmb();
 
 	ext2_clear_super_error(sb);
-	spin_lock(&EXT2_SB(sb)->s_lock);
+	spin_lock(&sbi->s_lock);
 	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
 	es->s_wtime = cpu_to_le32(get_seconds());
 	/* unlock before we do IO */
-	spin_unlock(&EXT2_SB(sb)->s_lock);
-	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
+	spin_unlock(&sbi->s_lock);
+	mark_buffer_dirty(sbi->s_sbh);
 	if (wait)
-		sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
+		sync_dirty_buffer(sbi->s_sbh);
 }
 
 /*
-- 
1.7.7.6

