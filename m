Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab2DKLoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:44:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:58363 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758843Ab2DKLof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:44:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="87782476"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH v1 2/3] fat: mark fsinfo as dirty less often
Date: Wed, 11 Apr 2012 14:45:06 +0300
Message-Id: <1334144707-9729-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334144707-9729-1-git-send-email-dedekind1@gmail.com>
References: <1334144707-9729-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This is a preparation patch which amends several functions in fatent.c
and makes them call 'fat_mark_fsinfo_dirty()' only once at the end
versus many times in the loop as it is now. Also, this patch makes sure
'fat_mark_fsinfo_dirty()' is called only after we have unlocked the FAT
table ('unlock_fat()').

The reason for this patch is that 'fat_mark_fsinfo_dirty()' will soon
become a bit heavier so it is better to avoid calling it unnecessarily
and while having the FAT table locked.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/fat/fatent.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 153c053..8e778ef 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -503,7 +503,6 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 				sbi->prev_free = entry;
 				if (sbi->free_clusters != -1)
 					sbi->free_clusters--;
-				fat_mark_fsinfo_dirty(sb);
 
 				cluster[idx_clus] = entry;
 				idx_clus++;
@@ -525,11 +524,11 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 	/* Couldn't allocate the free entries */
 	sbi->free_clusters = 0;
 	sbi->free_clus_valid = 1;
-	fat_mark_fsinfo_dirty(sb);
 	err = -ENOSPC;
 
 out:
 	unlock_fat(sbi);
+	fat_mark_fsinfo_dirty(sb);
 	fatent_brelse(&fatent);
 	if (!err) {
 		if (inode_needs_sync(inode))
@@ -590,10 +589,8 @@ int fat_free_clusters(struct inode *inode, int cluster)
 		}
 
 		ops->ent_put(&fatent, FAT_ENT_FREE);
-		if (sbi->free_clusters != -1) {
+		if (sbi->free_clusters != -1)
 			sbi->free_clusters++;
-			fat_mark_fsinfo_dirty(sb);
-		}
 
 		if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
 			if (sb->s_flags & MS_SYNCHRONOUS) {
@@ -622,6 +619,8 @@ error:
 	for (i = 0; i < nr_bhs; i++)
 		brelse(bhs[i]);
 	unlock_fat(sbi);
+	if (!err)
+		fat_mark_fsinfo_dirty(sb);
 
 	return err;
 }
@@ -682,9 +681,10 @@ int fat_count_free_clusters(struct super_block *sb)
 	}
 	sbi->free_clusters = free;
 	sbi->free_clus_valid = 1;
-	fat_mark_fsinfo_dirty(sb);
 	fatent_brelse(&fatent);
 out:
 	unlock_fat(sbi);
+	if (!err)
+		fat_mark_fsinfo_dirty(sb);
 	return err;
 }
-- 
1.7.7.6

