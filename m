Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2DMOTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:19:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:60837 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab2DMOTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:19:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="88726513"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH v2 2/4] fat: introduce mark_fsinfo_dirty helper
Date: Fri, 13 Apr 2012 17:19:53 +0300
Message-Id: <1334326795-2446-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This is a preparation patch which introduces a 'mark_fsinfo_dirty()'
helper function which just sets the 's_dirt' flag to 1 so far. I'll add more
code to this helper later, so I do not mark it as 'inline'.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/fat/fatent.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 2e81ac0..e49d274 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -308,6 +308,11 @@ void fat_ent_access_init(struct super_block *sb)
 	}
 }
 
+static void mark_fsinfo_dirty(struct super_block *sb)
+{
+	sb->s_dirt = 1;
+}
+
 static inline int fat_ent_update_ptr(struct super_block *sb,
 				     struct fat_entry *fatent,
 				     int offset, sector_t blocknr)
@@ -498,7 +503,7 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 				sbi->prev_free = entry;
 				if (sbi->free_clusters != -1)
 					sbi->free_clusters--;
-				sb->s_dirt = 1;
+				mark_fsinfo_dirty(sb);
 
 				cluster[idx_clus] = entry;
 				idx_clus++;
@@ -520,7 +525,7 @@ int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 	/* Couldn't allocate the free entries */
 	sbi->free_clusters = 0;
 	sbi->free_clus_valid = 1;
-	sb->s_dirt = 1;
+	mark_fsinfo_dirty(sb);
 	err = -ENOSPC;
 
 out:
@@ -587,7 +592,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
 		ops->ent_put(&fatent, FAT_ENT_FREE);
 		if (sbi->free_clusters != -1) {
 			sbi->free_clusters++;
-			sb->s_dirt = 1;
+			mark_fsinfo_dirty(sb);
 		}
 
 		if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
@@ -677,7 +682,7 @@ int fat_count_free_clusters(struct super_block *sb)
 	}
 	sbi->free_clusters = free;
 	sbi->free_clus_valid = 1;
-	sb->s_dirt = 1;
+	mark_fsinfo_dirty(sb);
 	fatent_brelse(&fatent);
 out:
 	unlock_fat(sbi);
-- 
1.7.7.6

