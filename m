Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab0KPXFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:05:10 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43127 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab0KPXFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:05:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=RGExPS0eF2UgNpcqSpsQzA335TTEPV3E+CdWGqtj4ERSgcrJ4KJrpPLldGhyasfe6o
         tS727gyrQmewUemfZK6Dlq3OkgoWFe4HGYfBsl4a+0fwBylJ71QoOSkBnRUcO9bZsZQg
         PDHuNgqPgfxCkMinl0lhsn9uQ59Zu3pV4o6sI=
From: Alessio Igor Bogani <abogani@texware.it>
To: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 2/3] udf: Use of s_alloc_mutex to serialize udf_relocate_blocks() execution
Date: Wed, 17 Nov 2010 00:04:26 +0100
Message-Id: <1289948667-2197-2-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20101116180544.GA29896@infradead.org>
References: <20101116180544.GA29896@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/udf/partition.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index 745eb20..a71090e 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -25,6 +25,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/buffer_head.h>
+#include <linux/mutex.h>
 
 uint32_t udf_get_pblock(struct super_block *sb, uint32_t block,
 			uint16_t partition, uint32_t offset)
@@ -159,7 +160,9 @@ int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	u16 reallocationTableLen;
 	struct buffer_head *bh;
+	int ret = 0;
 
+	mutex_lock(&sbi->s_alloc_mutex);
 	for (i = 0; i < sbi->s_partitions; i++) {
 		struct udf_part_map *map = &sbi->s_partmaps[i];
 		if (old_block > map->s_partition_root &&
@@ -175,8 +178,10 @@ int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
 					break;
 				}
 
-			if (!st)
-				return 1;
+			if (!st) {
+				ret = 1;
+				goto out;
+			}
 
 			reallocationTableLen =
 					le16_to_cpu(st->reallocationTableLen);
@@ -207,14 +212,16 @@ int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
 						     ((old_block -
 							map->s_partition_root) &
 						     (sdata->s_packet_len - 1));
-					return 0;
+					ret = 0;
+					goto out;
 				} else if (origLoc == packet) {
 					*new_block = le32_to_cpu(
 							entry->mappedLocation) +
 						     ((old_block -
 							map->s_partition_root) &
 						     (sdata->s_packet_len - 1));
-					return 0;
+					ret = 0;
+					goto out;
 				} else if (origLoc > packet)
 					break;
 			}
@@ -251,20 +258,24 @@ int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
 					      st->mapEntry[k].mappedLocation) +
 					((old_block - map->s_partition_root) &
 					 (sdata->s_packet_len - 1));
-				return 0;
+				ret = 0;
+				goto out;
 			}
 
-			return 1;
+			ret = 1;
+			goto out;
 		} /* if old_block */
 	}
 
 	if (i == sbi->s_partitions) {
 		/* outside of partitions */
 		/* for now, fail =) */
-		return 1;
+		ret = 1;
 	}
 
-	return 0;
+out:
+	mutex_unlock(&sbi->s_alloc_mutex);
+	return ret;
 }
 
 static uint32_t udf_try_read_meta(struct inode *inode, uint32_t block,
-- 
1.7.0.4

