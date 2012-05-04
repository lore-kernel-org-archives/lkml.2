Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab2EDPWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:22:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:15107 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758843Ab2EDPWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:22:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="138930589"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH v3 3/4] fat: mark superblock as dirty less often
Date: Fri,  4 May 2012 18:23:37 +0300
Message-Id: <1336145018-23319-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336145018-23319-1-git-send-email-dedekind1@gmail.com>
References: <1336145018-23319-1-git-send-email-dedekind1@gmail.com>
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
 fs/fat/fatent.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index e49d274..8181548 100644
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
@@ -554,7 +553,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
 	struct fat_entry fatent;
 	struct buffer_head *bhs[MAX_BUF_PER_PAGE];
 	int i, err, nr_bhs;
-	int first_cl = cluster;
+	int first_cl = cluster, dirty_fsinfo = 0;
 
 	nr_bhs = 0;
 	fatent_init(&fatent);
@@ -592,7 +591,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
 		ops->ent_put(&fatent, FAT_ENT_FREE);
 		if (sbi->free_clusters != -1) {
 			sbi->free_clusters++;
-			mark_fsinfo_dirty(sb);
+			dirty_fsinfo = 1;
 		}
 
 		if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
@@ -622,6 +621,8 @@ error:
 	for (i = 0; i < nr_bhs; i++)
 		brelse(bhs[i]);
 	unlock_fat(sbi);
+	if (dirty_fsinfo)
+		mark_fsinfo_dirty(sb);
 
 	return err;
 }
-- 
1.7.7.6

