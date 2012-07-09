Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2GIOll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:41:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38278 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481Ab2GIOiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:22 -0400
Message-Id: <20120709143120.461951078@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>
Subject: [ 26/48] udf: Avoid run away loop when partition table length is corrupted
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

commit adee11b2085bee90bd8f4f52123ffb07882d6256 upstream.

Check provided length of partition table so that (possibly maliciously)
corrupted partition table cannot cause accessing data beyond current buffer.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/udf/super.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 9da6f4e..ce911f5 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1225,6 +1225,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	struct genericPartitionMap *gpm;
 	uint16_t ident;
 	struct buffer_head *bh;
+	unsigned int table_len;
 	int ret = 0;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
@@ -1232,13 +1233,20 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 		return 1;
 	BUG_ON(ident != TAG_IDENT_LVD);
 	lvd = (struct logicalVolDesc *)bh->b_data;
+	table_len = le32_to_cpu(lvd->mapTableLength);
+	if (sizeof(*lvd) + table_len > sb->s_blocksize) {
+		udf_err(sb, "error loading logical volume descriptor: "
+			"Partition table too long (%u > %lu)\n", table_len,
+			sb->s_blocksize - sizeof(*lvd));
+		goto out_bh;
+	}
 
 	ret = udf_sb_alloc_partition_maps(sb, le32_to_cpu(lvd->numPartitionMaps));
 	if (ret)
 		goto out_bh;
 
 	for (i = 0, offset = 0;
-	     i < sbi->s_partitions && offset < le32_to_cpu(lvd->mapTableLength);
+	     i < sbi->s_partitions && offset < table_len;
 	     i++, offset += gpm->partitionMapLength) {
 		struct udf_part_map *map = &sbi->s_partmaps[i];
 		gpm = (struct genericPartitionMap *)


