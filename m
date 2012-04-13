Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2DMOT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:19:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:60837 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab2DMOT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:19:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="88726519"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH v2 3/4] fat: mark superblock as dirty less often
Date: Fri, 13 Apr 2012 17:19:54 +0300
Message-Id: <1334326795-2446-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch is a preparation for further changes. It touches few functions
in fatent.c and prevents them from marking the superblock as dirty
unnecessarily often. Namely, instead of marking it as dirty in the internal
tight loops - do it only once at the end of the functions. And instead of
marking it as dirty while holding the FAT table lock, do it outside the lock.

The reason for this patch is that marking the superblock as dirty will soon
become a little bit heavier operation, so it is cleaner to do this only when it
is necessary.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/fat/fatent.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index e49d274..85a1ec4 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -503,7 +503,6 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 				sbi->prev_free = entry;
 				if (sbi->free_clusters != -1)
 					sbi->free_clusters--;
-				mark_fsinfo_dirty(sb);
 
 				cluster[idx_clus] = entry;
 				idx_clus++;
@@ -525,11 +524,11 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 	/* Couldn't allocate the free entries */
 	sbi->free_clusters = 0;
 	sbi->free_clus_valid = 1;
-	mark_fsinfo_dirty(sb);
 	err = -ENOSPC;
 
 out:
 	unlock_fat(sbi);
+	mark_fsinfo_dirty(sb);
 	fatent_brelse(&fatent);
 	if (!err) {
 		if (inode_needs_sync(inode))
@@ -590,10 +589,8 @@ int fat_free_clusters(struct inode *inode, int cluster)
 		}
 
 		ops->ent_put(&fatent, FAT_ENT_FREE);
-		if (sbi->free_clusters != -1) {
+		if (sbi->free_clusters != -1)
 			sbi->free_clusters++;
-			mark_fsinfo_dirty(sb);
-		}
 
 		if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
 			if (sb->s_flags & MS_SYNCHRONOUS) {
@@ -622,6 +619,8 @@ error:
 	for (i = 0; i < nr_bhs; i++)
 		brelse(bhs[i]);
 	unlock_fat(sbi);
+	if (!err)
+		mark_fsinfo_dirty(sb);
 
 	return err;
 }
@@ -682,9 +681,10 @@ int fat_count_free_clusters(struct super_block *sb)
 	}
 	sbi->free_clusters = free;
 	sbi->free_clus_valid = 1;
-	mark_fsinfo_dirty(sb);
 	fatent_brelse(&fatent);
 out:
 	unlock_fat(sbi);
+	if (!err)
+		mark_fsinfo_dirty(sb);
 	return err;
 }
-- 
1.7.7.6

