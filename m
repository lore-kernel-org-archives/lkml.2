Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab3AHXk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:40:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:64291 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab3AHXkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:40:20 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 60/77] udf: Avoid run away loop when partition table length is corrupted
Date: Tue, 8 Jan 2013 18:35:39 -0500
Message-ID: <1357688156-25387-61-git-send-email-paul.gortmaker@windriver.com>
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

commit adee11b2085bee90bd8f4f52123ffb07882d6256 upstream.

Check provided length of partition table so that (possibly maliciously)
corrupted partition table cannot cause accessing data beyond current buffer.

Signed-off-by: Jan Kara <jack@suse.cz>
[PG: in 2.6.34 udf_err() is called udf_error()]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/udf/super.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 4551ad2..a48725b 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1298,6 +1298,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	struct genericPartitionMap *gpm;
 	uint16_t ident;
 	struct buffer_head *bh;
+	unsigned int table_len;
 	int ret = 0;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
@@ -1305,6 +1306,13 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 		return 1;
 	BUG_ON(ident != TAG_IDENT_LVD);
 	lvd = (struct logicalVolDesc *)bh->b_data;
+	table_len = le32_to_cpu(lvd->mapTableLength);
+	if (sizeof(*lvd) + table_len > sb->s_blocksize) {
+		udf_error(sb, "error loading logical volume descriptor: "
+			  "Partition table too long (%u > %lu)\n", table_len,
+			sb->s_blocksize - sizeof(*lvd));
+		goto out_bh;
+	}
 
 	i = udf_sb_alloc_partition_maps(sb, le32_to_cpu(lvd->numPartitionMaps));
 	if (i != 0) {
@@ -1313,7 +1321,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	}
 
 	for (i = 0, offset = 0;
-	     i < sbi->s_partitions && offset < le32_to_cpu(lvd->mapTableLength);
+	     i < sbi->s_partitions && offset < table_len;
 	     i++, offset += gpm->partitionMapLength) {
 		struct udf_part_map *map = &sbi->s_partmaps[i];
 		gpm = (struct genericPartitionMap *)
-- 
1.7.12.1

