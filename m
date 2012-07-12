Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162590Ab2GLXDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:03:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162530Ab2GLXDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:03:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>
Subject: [ 20/68] udf: Fortify loading of sparing table
Date: Thu, 12 Jul 2012 16:01:54 -0700
Message-Id: <20120712175037.226549185@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 1df2ae31c724e57be9d7ac00d78db8a5dabdd050 upstream.

Add sanity checks when loading sparing table from disk to avoid accessing
unallocated memory or writing to it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/super.c |   86 +++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 33 deletions(-)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -56,6 +56,7 @@
 #include <linux/seq_file.h>
 #include <linux/bitmap.h>
 #include <linux/crc-itu-t.h>
+#include <linux/log2.h>
 #include <asm/byteorder.h>
 
 #include "udf_sb.h"
@@ -1244,11 +1245,59 @@ out_bh:
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
@@ -1310,38 +1359,9 @@ static int udf_load_logicalvol(struct su
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


