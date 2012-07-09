Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2GIOlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:41:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38275 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381Ab2GIOiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:22 -0400
Message-Id: <20120709143120.604970315@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>
Subject: [ 27/48] udf: Fortify loading of sparing table
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 1df2ae31c724e57be9d7ac00d78db8a5dabdd050 upstream.

Add sanity checks when loading sparing table from disk to avoid accessing
unallocated memory or writing to it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/udf/super.c |   86 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 33 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index ce911f5..8d86a87 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -56,6 +56,7 @@
 #include <linux/seq_file.h>
 #include <linux/bitmap.h>
 #include <linux/crc-itu-t.h>
+#include <linux/log2.h>
 #include <asm/byteorder.h>
 
 #include "udf_sb.h"
@@ -1215,11 +1216,59 @@ out_bh:
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
+		udf_err(sb, "error loading logical volume descriptor: "
+			"Invalid packet length %u\n",
+			(unsigned)sdata->s_packet_len);
+		return -EIO;
+	}
+	if (spm->numSparingTables > 4) {
+		udf_err(sb, "error loading logical volume descriptor: "
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
@@ -1281,38 +1330,9 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
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


