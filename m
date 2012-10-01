Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826Ab2JAXSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:18:39 -0400
Received: from 1wt.eu ([62.212.114.60]:35434 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642Ab2JAXBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:50 -0400
Message-Id: <20121001225203.841869825@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 147/180] udf: Fortify loading of sparing table
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 1df2ae31c724e57be9d7ac00d78db8a5dabdd050 upstream.

Add sanity checks when loading sparing table from disk to avoid accessing
unallocated memory or writing to it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/udf/super.c |   86 ++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 53 insertions(+), 33 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 0388d43..f0314da 100644
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
+		udf_error(sb, __func__, "error loading logical volume descriptor: "
+			"Invalid packet length %u\n",
+			(unsigned)sdata->s_packet_len);
+		return -EIO;
+	}
+	if (spm->numSparingTables > 4) {
+		udf_error(sb, __func__, "error loading logical volume descriptor: "
+			"Too many sparing tables (%d)\n",
+			(int)spm->numSparingTables);
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
@@ -1308,38 +1357,9 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
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
1.7.2.1.45.g54fbc



