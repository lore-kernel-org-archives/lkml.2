Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1JJIIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:08:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42804 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752455Ab1JJIIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:08:36 -0400
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: NamJae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] udf: Rename udf_error to udf_err
Date: Mon, 10 Oct 2011 01:08:03 -0700
Message-Id: <fced9ea9f590d664a08a1f5425adfc5afa1d5949.1318233879.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1318233879.git.joe@perches.com>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com> <cover.1318233879.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename udf_error to udf_err for consistency with normal logging
uses of pr_err.

Rename function udf_err to _udf_err.
Remove __func__ from uses and move __func__ to a new udf_err
macro that calls _udf_err.
Some of the udf_error uses had \n terminations, some did not so
standardize \n's to udf_err uses, remove \n from _udf_err function.
Coalesce udf_err formats.
One message prefixed with udf_read_super is now prefixed with
udf_fill_super.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/udf/misc.c    |   25 +++++++++++--------------
 fs/udf/super.c   |   27 +++++++++++----------------
 fs/udf/udfdecl.h |    7 ++++---
 3 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 87667f8..645f02d 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -212,8 +212,8 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 
 	bh = udf_tread(sb, block);
 	if (!bh) {
-		udf_error(sb, __func__, "read failed, block=%u, location=%d\n",
-			  block, location);
+		udf_err(sb, "read failed, block=%u, location=%d\n",
+			block, location);
 		return NULL;
 	}
 
@@ -222,27 +222,24 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 	*ident = le16_to_cpu(tag_p->tagIdent);
 
 	if (location != le32_to_cpu(tag_p->tagLocation)) {
-		udf_error(sb, __func__,
-			  "location mismatch, block %u, tag %u != %u\n",
-			  block, le32_to_cpu(tag_p->tagLocation), location);
+		udf_err(sb, "location mismatch, block %u, tag %u != %u\n",
+			block, le32_to_cpu(tag_p->tagLocation), location);
 		goto error_out;
 	}
 
 	/* Verify the tag checksum */
 	checksum = udf_tag_checksum(tag_p);
 	if (checksum != tag_p->tagChecksum) {
-		udf_error(sb, __func__,
-			  "tag checksum failed, block %u: 0x%02x != 0x%02x\n",
-			  block, checksum, tag_p->tagChecksum);
+		udf_err(sb, "tag checksum failed, block %u: 0x%02x != 0x%02x\n",
+			block, checksum, tag_p->tagChecksum);
 		goto error_out;
 	}
 
 	/* Verify the tag version */
 	if (tag_p->descVersion != cpu_to_le16(0x0002U) &&
 	    tag_p->descVersion != cpu_to_le16(0x0003U)) {
-		udf_error(sb, __func__,
-			  "tag version 0x%04x != 0x0002 || 0x0003, block %u\n",
-			  le16_to_cpu(tag_p->descVersion), block);
+		udf_err(sb, "tag version 0x%04x != 0x0002 || 0x0003, block %u\n",
+			le16_to_cpu(tag_p->descVersion), block);
 		goto error_out;
 	}
 
@@ -253,9 +250,9 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 					le16_to_cpu(tag_p->descCRCLength)))
 		return bh;
 
-	udf_error(sb, __func__, "crc failure, block %u: crc = %d, crclen = %d\n",
-		  block, le16_to_cpu(tag_p->descCRC),
-		  le16_to_cpu(tag_p->descCRCLength));
+	udf_err(sb, "crc failure, block %u: crc = %d, crclen = %d\n",
+		block, le16_to_cpu(tag_p->descCRC),
+		le16_to_cpu(tag_p->descCRCLength));
 
 error_out:
 	brelse(bh);
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 80f47ce..76cc08f 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -242,9 +242,8 @@ static int udf_sb_alloc_partition_maps(struct super_block *sb, u32 count)
 	sbi->s_partmaps = kcalloc(count, sizeof(struct udf_part_map),
 				  GFP_KERNEL);
 	if (!sbi->s_partmaps) {
-		udf_error(sb, __func__,
-			  "Unable to allocate space for %d partition maps",
-			  count);
+		udf_err(sb, "Unable to allocate space for %d partition maps\n",
+			count);
 		sbi->s_partitions = 0;
 		return -ENOMEM;
 	}
@@ -879,8 +878,7 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 
 	if (mdata->s_mirror_fe == NULL) {
 		if (fe_error) {
-			udf_error(sb, __func__, "mirror inode efe not found "
-			"and metadata inode is missing too, exiting...");
+			udf_err(sb, "mirror inode efe not found and metadata inode is missing too, exiting...\n");
 			goto error_exit;
 		} else
 			udf_warning(sb, __func__, "mirror inode efe not found,"
@@ -915,8 +913,7 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 					"not found but it's ok since the disc"
 					" is mounted read-only");
 			else {
-				udf_error(sb, __func__, "bitmap inode efe not "
-					"found and attempted read-write mount");
+				udf_err(sb, "bitmap inode efe not found and attempted read-write mount\n");
 				goto error_exit;
 			}
 		}
@@ -969,9 +966,8 @@ static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
 		bitmap = vzalloc(size); /* TODO: get rid of vzalloc */
 
 	if (bitmap == NULL) {
-		udf_error(sb, __func__,
-			  "Unable to allocate space for bitmap "
-			  "and %d buffer_head pointers", nr_groups);
+		udf_err(sb, "Unable to allocate space for bitmap and %d buffer_head pointers\n",
+			nr_groups);
 		return NULL;
 	}
 
@@ -1935,8 +1931,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 
 	if (uopt.flags & (1 << UDF_FLAG_UTF8) &&
 	    uopt.flags & (1 << UDF_FLAG_NLS_MAP)) {
-		udf_error(sb, "udf_read_super",
-			  "utf8 cannot be combined with iocharset\n");
+		udf_err(sb, "utf8 cannot be combined with iocharset\n");
 		goto error_out;
 	}
 #ifdef CONFIG_UDF_NLS
@@ -2094,8 +2089,8 @@ error_out:
 	return -EINVAL;
 }
 
-void udf_error(struct super_block *sb, const char *function,
-	       const char *fmt, ...)
+void _udf_err(struct super_block *sb, const char *function,
+	      const char *fmt, ...)
 {
 	va_list args;
 
@@ -2106,8 +2101,8 @@ void udf_error(struct super_block *sb, const char *function,
 	va_start(args, fmt);
 	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
 	va_end(args);
-	printk(KERN_CRIT "UDF-fs error (device %s): %s: %s\n",
-		sb->s_id, function, error_buf);
+	printk(KERN_CRIT "UDF-fs error (device %s): %s: %s",
+	       sb->s_id, function, error_buf);
 }
 
 void udf_warning(struct super_block *sb, const char *function,
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 81e66af..7bc3ba1 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -33,13 +33,14 @@ __attribute__((format(printf, 3, 4)))
 extern void udf_warning(struct super_block *, const char *, const char *, ...);
 
 __attribute__((format(printf, 3, 4)))
-extern void udf_error(struct super_block *sb, const char *function,
-		      const char *fmt, ...);
+extern void _udf_err(struct super_block *sb, const char *function,
+		     const char *fmt, ...);
+#define udf_err(sb, fmt, ...)					\
+	_udf_err(sb, __func__, fmt, ##__VA_ARGS__)
 
 #define udf_info(f, a...) \
 	printk(KERN_INFO "UDF-fs INFO " f, ##a);
 
-
 #define udf_fixed_to_variable(x) ( ( ( (x) >> 5 ) * 39 ) + ( (x) & 0x0000001F ) )
 #define udf_variable_to_fixed(x) ( ( ( (x) / 39 ) << 5 ) + ( (x) % 39 ) )
 
-- 
1.7.6.405.gc1be0

