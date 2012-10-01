Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab2JAXDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:03:35 -0400
Received: from 1wt.eu ([62.212.114.60]:35669 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933311Ab2JAXDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:33 -0400
Message-Id: <20121001225201.501807945@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 092/180] udf: Avoid run away loop when partition table length is corrupted
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit adee11b2085bee90bd8f4f52123ffb07882d6256 upstream.

Check provided length of partition table so that (possibly maliciously)
corrupted partition table cannot cause accessing data beyond current buffer.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/udf/super.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index ee6b3af..0388d43 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1249,6 +1249,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	struct genericPartitionMap *gpm;
 	uint16_t ident;
 	struct buffer_head *bh;
+	unsigned int table_len;
 	int ret = 0;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
@@ -1257,6 +1258,14 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	BUG_ON(ident != TAG_IDENT_LVD);
 	lvd = (struct logicalVolDesc *)bh->b_data;
 
+	table_len = le32_to_cpu(lvd->mapTableLength);
+	if (sizeof(*lvd) + table_len > sb->s_blocksize) {
+		udf_error(sb, __func__, "error loading logical volume descriptor: "
+		          "Partition table too long (%u > %lu)\n", table_len,
+		          sb->s_blocksize - sizeof(*lvd));
+		goto out_bh;
+	}
+
 	i = udf_sb_alloc_partition_maps(sb, le32_to_cpu(lvd->numPartitionMaps));
 	if (i != 0) {
 		ret = i;
@@ -1264,7 +1273,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	}
 
 	for (i = 0, offset = 0;
-	     i < sbi->s_partitions && offset < le32_to_cpu(lvd->mapTableLength);
+	     i < sbi->s_partitions && offset < table_len;
 	     i++, offset += gpm->partitionMapLength) {
 		struct udf_part_map *map = &sbi->s_partmaps[i];
 		gpm = (struct genericPartitionMap *)
-- 
1.7.2.1.45.g54fbc



