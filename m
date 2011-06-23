Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398Ab1FWSNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:13:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:34499 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933337Ab1FWRga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Timo Warns <warns@pre-sense.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 110/247] fs/partitions: Validate map_count in Mac partition tables
Date: Thu, 23 Jun 2011 13:32:58 -0400
Message-Id: <1308850515-15242-51-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Timo Warns <warns@pre-sense.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit fa7ea87a057958a8b7926c1a60a3ca6d696328ed upstream.

Validate number of blocks in map and remove redundant variable.

Signed-off-by: Timo Warns <warns@pre-sense.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/partitions/mac.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/partitions/mac.c b/fs/partitions/mac.c
index d4a0fad..5765198 100644
--- a/fs/partitions/mac.c
+++ b/fs/partitions/mac.c
@@ -29,10 +29,9 @@ static inline void mac_fix_string(char *stg, int len)
 
 int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 {
-	int slot = 1;
 	Sector sect;
 	unsigned char *data;
-	int blk, blocks_in_map;
+	int slot, blocks_in_map;
 	unsigned secsize;
 #ifdef CONFIG_PPC_PMAC
 	int found_root = 0;
@@ -59,10 +58,14 @@ int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 		put_dev_sector(sect);
 		return 0;		/* not a MacOS disk */
 	}
-	printk(" [mac]");
 	blocks_in_map = be32_to_cpu(part->map_count);
-	for (blk = 1; blk <= blocks_in_map; ++blk) {
-		int pos = blk * secsize;
+	if (blocks_in_map < 0 || blocks_in_map >= DISK_MAX_PARTS) {
+		put_dev_sector(sect);
+		return 0;
+	}
+	printk(" [mac]");
+	for (slot = 1; slot <= blocks_in_map; ++slot) {
+		int pos = slot * secsize;
 		put_dev_sector(sect);
 		data = read_dev_sector(bdev, pos/512, &sect);
 		if (!data)
@@ -113,13 +116,11 @@ int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 			}
 
 			if (goodness > found_root_goodness) {
-				found_root = blk;
+				found_root = slot;
 				found_root_goodness = goodness;
 			}
 		}
 #endif /* CONFIG_PPC_PMAC */
-
-		++slot;
 	}
 #ifdef CONFIG_PPC_PMAC
 	if (found_root_goodness)
-- 
1.7.4.4

