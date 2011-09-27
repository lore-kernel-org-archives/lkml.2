Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276Ab1I0Pqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 11:46:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41109 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab1I0Pqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 11:46:33 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] udf: enable error print in udf_read_tagged().
Date: Wed, 28 Sep 2011 00:46:22 +0900
Message-Id: <1317138382-1966-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While reading metadata, if a problem occurs, Print out only one of the five case.(It also does not show a checksum properly.)
Because Currently it was disable by undef udf_debug.
If there is a problem with scratched disc or loader, the user needs to know which error happened.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/udf/misc.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 9215700..82b7ad2 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -204,6 +204,7 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 {
 	struct tag *tag_p;
 	struct buffer_head *bh = NULL;
+	u8 checksum;
 
 	/* Read the block */
 	if (block == 0xFFFFFFFF)
@@ -211,7 +212,7 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 
 	bh = udf_tread(sb, block);
 	if (!bh) {
-		udf_debug("block=%d, location=%d: read failed\n",
+		printk(KERN_ERR "block=%d, location=%d: read failed\n",
 			  block, location);
 		return NULL;
 	}
@@ -221,22 +222,24 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 	*ident = le16_to_cpu(tag_p->tagIdent);
 
 	if (location != le32_to_cpu(tag_p->tagLocation)) {
-		udf_debug("location mismatch block %u, tag %u != %u\n",
+		printk(KERN_ERR "location mismatch block %u, tag %u != %u\n",
 			  block, le32_to_cpu(tag_p->tagLocation), location);
 		goto error_out;
 	}
 
 	/* Verify the tag checksum */
-	if (udf_tag_checksum(tag_p) != tag_p->tagChecksum) {
-		printk(KERN_ERR "udf: tag checksum failed block %d\n", block);
+	checksum = udf_tag_checksum(tag_p);
+	if (checksum != tag_p->tagChecksum) {
+		printk(KERN_ERR "udf: tag checksum failed block %d, checksum 0x%02x != 0x%02x\n",
+		block, checksum, tag_p->tagChecksum);
 		goto error_out;
 	}
 
 	/* Verify the tag version */
 	if (tag_p->descVersion != cpu_to_le16(0x0002U) &&
 	    tag_p->descVersion != cpu_to_le16(0x0003U)) {
-		udf_debug("tag version 0x%04x != 0x0002 || 0x0003 block %d\n",
-			  le16_to_cpu(tag_p->descVersion), block);
+		printk(KERN_ERR "tag version 0x%04x != 0x0002 || 0x0003 block %d\n",
+		le16_to_cpu(tag_p->descVersion), block);
 		goto error_out;
 	}
 
@@ -247,7 +250,7 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 					le16_to_cpu(tag_p->descCRCLength)))
 		return bh;
 
-	udf_debug("Crc failure block %d: crc = %d, crclen = %d\n", block,
+	printk(KERN_ERR "Crc failure block %d: crc = %d, crclen = %d\n", block,
 	    le16_to_cpu(tag_p->descCRC), le16_to_cpu(tag_p->descCRCLength));
 
 error_out:
-- 
1.7.4.4

