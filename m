Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab3AHXmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:42:11 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53815 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757151Ab3AHXkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:40:17 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 59/77] udf: Fortify loading of sparing table
Date: Tue, 8 Jan 2013 18:35:38 -0500
Message-ID: <1357688156-25387-60-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1df2ae31c724e57be9d7ac00d78db8a5dabdd050 upstream.

Add sanity checks when loading sparing table from disk to avoid accessing
unallocated memory or writing to it.

Signed-off-by: Jan Kara <jack@suse.cz>
[PG: in 2.6.34 udf_err() is called udf_error()]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/udf/super.c | 86 ++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 33 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 1e4543c..4551ad2 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -57,6 +57,7 @@
 #include <linux/seq_file.h>
 #include <linux/bitmap.h>
 #include <linux/crc-itu-t.h>
+#include <linux/log2.h>
 #include <asm/byteorder.h>
 
 #include "udf_sb.h"
@@ -1239,11 +1240,59 @@ out_bh:
 	return ret;
 }
 
+static int udf_load_sparable_map(struct super_block *sb,
+				 struct udf_part_map *map,
+				 struct sparablePartitionMap *spm)
+{
+	uint32_t loc;
+	uint16_t ident;
+	struct sparingTable *st;
+	struct udf_sparing_data *sdata = &map->s_type_specific.s_sparing;
+	int i;
+	struct buffer_head *bh;
+
+	map->s_partition_type = UDF_SPARABLE_MAP15;
+	sdata->s_packet_len = le16_to_cpu(spm->packetLength);
+	if (!is_power_of_2(sdata->s_packet_len)) {
+		udf_error(sb, "error loading logical volume descriptor: "
+			  "Invalid packet length %u\n",
+			  (unsigned)sdata->s_packet_len);
+		return -EIO;
+	}
+	if (spm->numSparingTables > 4) {
+		udf_error(sb, "error loading logical volume descriptor: "
+			  "Too many sparing tables (%d)\n",
+			  (int)spm->numSparingTables);
+		return -EIO;
+	}
+
+	for (i = 0; i < spm->numSparingTables; i++) {
+		loc = le32_to_cpu(spm->locSparingTable[i]);
+		bh = udf_read_tagged(sb, loc, loc, &ident);
+		if (!bh)
+			continue;
+
+		st = (struct sparingTable *)bh->b_data;
+		if (ident != 0 ||
+		    strncmp(st->sparingIdent.ident, UDF_ID_SPARING,
+			    strlen(UDF_ID_SPARING)) ||
+		    sizeof(*st) + le16_to_cpu(st->reallocationTableLen) >
+							sb->s_blocksize) {
+			brelse(bh);
+			continue;
+		}
+
+		sdata->s_spar_map[i] = bh;
+	}
+	map->s_partition_func = udf_get_pblock_spar15;
+	return 0;
+}
+
 static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 			       struct kernel_lb_addr *fileset)
 {
 	struct logicalVolDesc *lvd;
-	int i, j, offset;
+	int i, offset;
 	uint8_t type;
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct genericPartitionMap *gpm;
@@ -1299,38 +1348,9 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 			} else if (!strncmp(upm2->partIdent.ident,
 						UDF_ID_SPARABLE,
 						strlen(UDF_ID_SPARABLE))) {
-				uint32_t loc;
-				struct sparingTable *st;
-				struct sparablePartitionMap *spm =
-					(struct sparablePartitionMap *)gpm;
-
-				map->s_partition_type = UDF_SPARABLE_MAP15;
-				map->s_type_specific.s_sparing.s_packet_len =
-						le16_to_cpu(spm->packetLength);
-				for (j = 0; j < spm->numSparingTables; j++) {
-					struct buffer_head *bh2;
-
-					loc = le32_to_cpu(
-						spm->locSparingTable[j]);
-					bh2 = udf_read_tagged(sb, loc, loc,
-							     &ident);
-					map->s_type_specific.s_sparing.
-							s_spar_map[j] = bh2;
-
-					if (bh2 == NULL)
-						continue;
-
-					st = (struct sparingTable *)bh2->b_data;
-					if (ident != 0 || strncmp(
-						st->sparingIdent.ident,
-						UDF_ID_SPARING,
-						strlen(UDF_ID_SPARING))) {
-						brelse(bh2);
-						map->s_type_specific.s_sparing.
-							s_spar_map[j] = NULL;
-					}
-				}
-				map->s_partition_func = udf_get_pblock_spar15;
+				if (udf_load_sparable_map(sb, map,
+				    (struct sparablePartitionMap *)gpm) < 0)
+					goto out_bh;
 			} else if (!strncmp(upm2->partIdent.ident,
 						UDF_ID_METADATA,
 						strlen(UDF_ID_METADATA))) {
-- 
1.7.12.1

