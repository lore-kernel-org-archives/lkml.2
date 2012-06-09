Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab2FIAwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 20:52:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59124 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934451Ab2FIAvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 20:51:05 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 4/9] affs: use memweight()
Date: Sat,  9 Jun 2012 09:50:33 +0900
Message-Id: <1339203038-13069-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
References: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use memweight() to count the total number of bits set in memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-fsdevel@vger.kernel.org
---
No changes from v1

 fs/affs/bitmap.c |   28 ++--------------------------
 1 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index 3e26271..3dfdcd2 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -10,30 +10,6 @@
 #include <linux/slab.h>
 #include "affs.h"
 
-/* This is, of course, shamelessly stolen from fs/minix */
-
-static const int nibblemap[] = { 0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4 };
-
-static u32
-affs_count_free_bits(u32 blocksize, const void *data)
-{
-	const u32 *map;
-	u32 free;
-	u32 tmp;
-
-	map = data;
-	free = 0;
-	for (blocksize /= 4; blocksize > 0; blocksize--) {
-		tmp = *map++;
-		while (tmp) {
-			free += nibblemap[tmp & 0xf];
-			tmp >>= 4;
-		}
-	}
-
-	return free;
-}
-
 u32
 affs_count_free_blocks(struct super_block *sb)
 {
@@ -317,7 +293,7 @@ int affs_init_bitmap(struct super_block *sb, int *flags)
 			goto out;
 		}
 		pr_debug("AFFS: read bitmap block %d: %d\n", blk, bm->bm_key);
-		bm->bm_free = affs_count_free_bits(sb->s_blocksize - 4, bh->b_data + 4);
+		bm->bm_free = memweight(bh->b_data + 4, sb->s_blocksize - 4);
 
 		/* Don't try read the extension if this is the last block,
 		 * but we also need the right bm pointer below
@@ -367,7 +343,7 @@ int affs_init_bitmap(struct super_block *sb, int *flags)
 
 	/* recalculate bitmap count for last block */
 	bm--;
-	bm->bm_free = affs_count_free_bits(sb->s_blocksize - 4, bh->b_data + 4);
+	bm->bm_free = memweight(bh->b_data + 4, sb->s_blocksize - 4);
 
 out:
 	affs_brelse(bh);
-- 
1.7.7.6

