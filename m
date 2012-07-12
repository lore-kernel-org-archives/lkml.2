Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161855Ab2GLXl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:41:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759623Ab2GLWi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:38:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>
Subject: [ 051/187] udf: Avoid run away loop when partition table length is corrupted
Date: Thu, 12 Jul 2012 15:33:27 -0700
Message-Id: <20120712191527.082415314@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit adee11b2085bee90bd8f4f52123ffb07882d6256 upstream.

Check provided length of partition table so that (possibly maliciously)
corrupted partition table cannot cause accessing data beyond current buffer.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/super.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1225,6 +1225,7 @@ static int udf_load_logicalvol(struct su
 	struct genericPartitionMap *gpm;
 	uint16_t ident;
 	struct buffer_head *bh;
+	unsigned int table_len;
 	int ret = 0;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
@@ -1232,13 +1233,20 @@ static int udf_load_logicalvol(struct su
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


