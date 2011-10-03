Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1JCEz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 00:55:59 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55334 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab1JCEzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 00:55:51 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 1/2] udf : enable error print in udf_read_tagged().
Date: Mon,  3 Oct 2011 13:55:37 +0900
Message-Id: <1317617737-22035-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While reading metadata, if a problem occurs,
Print out only one of the five case.(It also does not show a checksum properly.)
Because currently it have been disable by undef udf_debug.
If there is a problem with scratched disc or loader, the user needs to know which error happened.
And I use pr_fmt instead of printk by joe's suggestion. I try to modify totally it to pr_fmt also.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/udf/directory.c |    4 ++--
 fs/udf/inode.c     |   14 +++++++-------
 fs/udf/misc.c      |   17 ++++++++++-------
 fs/udf/super.c     |    2 +-
 fs/udf/truncate.c  |    5 ++---
 fs/udf/udfdecl.h   |    6 ++++--
 fs/udf/udftime.c   |    2 +-
 fs/udf/unicode.c   |    6 +++---
 8 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index 2ffdb67..a4caf7a 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -201,7 +201,7 @@ struct short_ad *udf_get_fileshortad(uint8_t *ptr, int maxoffset, uint32_t *offs
 	struct short_ad *sa;
 
 	if ((!ptr) || (!offset)) {
-		printk(KERN_ERR "udf: udf_get_fileshortad() invalidparms\n");
+		pr_err("udf_get_fileshortad() invalidparms\n");
 		return NULL;
 	}
 
@@ -223,7 +223,7 @@ struct long_ad *udf_get_filelongad(uint8_t *ptr, int maxoffset, uint32_t *offset
 	struct long_ad *la;
 
 	if ((!ptr) || (!offset)) {
-		printk(KERN_ERR "udf: udf_get_filelongad() invalidparms\n");
+		pr_err("udf_get_filelongad() invalidparms\n");
 		return NULL;
 	}
 
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 1d1358e..58665ce 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -83,7 +83,7 @@ void udf_evict_inode(struct inode *inode)
 	end_writeback(inode);
 	if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB &&
 	    inode->i_size != iinfo->i_lenExtents) {
-		printk(KERN_WARNING "UDF-fs (%s): Inode %lu (mode %o) has "
+		pr_warn("(%s): Inode %lu (mode %o) has "
 			"inode size %llu different from extent length %llu. "
 			"Filesystem need not be standards compliant.\n",
 			inode->i_sb->s_id, inode->i_ino, inode->i_mode,
@@ -1169,7 +1169,7 @@ static void __udf_read_inode(struct inode *inode)
 	 */
 	bh = udf_read_ptagged(inode->i_sb, &iinfo->i_location, 0, &ident);
 	if (!bh) {
-		printk(KERN_ERR "udf: udf_read_inode(ino %ld) failed !bh\n",
+		pr_err("udf_read_inode(ino %ld) failed !bh\n",
 		       inode->i_ino);
 		make_bad_inode(inode);
 		return;
@@ -1177,7 +1177,7 @@ static void __udf_read_inode(struct inode *inode)
 
 	if (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE &&
 	    ident != TAG_IDENT_USE) {
-		printk(KERN_ERR "udf: udf_read_inode(ino %ld) "
+		pr_err("udf_read_inode(ino %ld) "
 				"failed ident=%d\n", inode->i_ino, ident);
 		brelse(bh);
 		make_bad_inode(inode);
@@ -1218,7 +1218,7 @@ static void __udf_read_inode(struct inode *inode)
 		}
 		brelse(ibh);
 	} else if (fe->icbTag.strategyType != cpu_to_le16(4)) {
-		printk(KERN_ERR "udf: unsupported strategy type: %d\n",
+		pr_err("unsupported strategy type: %d\n",
 		       le16_to_cpu(fe->icbTag.strategyType));
 		brelse(bh);
 		make_bad_inode(inode);
@@ -1413,7 +1413,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		udf_debug("METADATA BITMAP FILE-----\n");
 		break;
 	default:
-		printk(KERN_ERR "udf: udf_fill_inode(ino %ld) failed unknown "
+		pr_err("udf_fill_inode(ino %ld) failed unknown "
 				"file type=%d\n", inode->i_ino,
 				fe->icbTag.fileType);
 		make_bad_inode(inode);
@@ -1438,7 +1438,7 @@ static int udf_alloc_i_data(struct inode *inode, size_t size)
 	iinfo->i_ext.i_data = kmalloc(size, GFP_KERNEL);
 
 	if (!iinfo->i_ext.i_data) {
-		printk(KERN_ERR "udf:udf_alloc_i_data (ino %ld) "
+		pr_err("udf_alloc_i_data (ino %ld) "
 				"no free memory\n", inode->i_ino);
 		return -ENOMEM;
 	}
@@ -1689,7 +1689,7 @@ out:
 	if (do_sync) {
 		sync_dirty_buffer(bh);
 		if (buffer_write_io_error(bh)) {
-			printk(KERN_WARNING "IO error syncing udf inode "
+			pr_warn("IO error syncing udf inode "
 				"[%s:%08lx]\n", inode->i_sb->s_id,
 				inode->i_ino);
 			err = -EIO;
diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 9215700..4f0345e 100644
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
+		pr_err("block=%d, location=%d: read failed\n",
 			  block, location);
 		return NULL;
 	}
@@ -221,22 +222,24 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 	*ident = le16_to_cpu(tag_p->tagIdent);
 
 	if (location != le32_to_cpu(tag_p->tagLocation)) {
-		udf_debug("location mismatch block %u, tag %u != %u\n",
+		pr_err("location mismatch block %u, tag %u != %u\n",
 			  block, le32_to_cpu(tag_p->tagLocation), location);
 		goto error_out;
 	}
 
 	/* Verify the tag checksum */
-	if (udf_tag_checksum(tag_p) != tag_p->tagChecksum) {
-		printk(KERN_ERR "udf: tag checksum failed block %d\n", block);
+	checksum = udf_tag_checksum(tag_p);
+	if (checksum != tag_p->tagChecksum) {
+		pr_err("tag checksum failed block %d, checksum 0x%02x != 0x%02x\n",
+		block, checksum, tag_p->tagChecksum);
 		goto error_out;
 	}
 
 	/* Verify the tag version */
 	if (tag_p->descVersion != cpu_to_le16(0x0002U) &&
 	    tag_p->descVersion != cpu_to_le16(0x0003U)) {
-		udf_debug("tag version 0x%04x != 0x0002 || 0x0003 block %d\n",
-			  le16_to_cpu(tag_p->descVersion), block);
+		pr_err("tag version 0x%04x != 0x0002 || 0x0003 block %d\n",
+		le16_to_cpu(tag_p->descVersion), block);
 		goto error_out;
 	}
 
@@ -247,7 +250,7 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 					le16_to_cpu(tag_p->descCRCLength)))
 		return bh;
 
-	udf_debug("Crc failure block %d: crc = %d, crclen = %d\n", block,
+	pr_err("Crc failure block %d: crc = %d, crclen = %d\n", block,
 	    le16_to_cpu(tag_p->descCRC), le16_to_cpu(tag_p->descCRCLength));
 
 error_out:
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 7b27b06..bbf6256 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -550,7 +550,7 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
 			uopt->dmode = option & 0777;
 			break;
 		default:
-			printk(KERN_ERR "udf: bad mount option \"%s\" "
+			pr_err("bad mount option \"%s\" "
 			       "or missing value\n", p);
 			return 0;
 		}
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index 8424308..65c11cd 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -95,8 +95,7 @@ void udf_truncate_tail_extent(struct inode *inode)
 		lbcount += elen;
 		if (lbcount > inode->i_size) {
 			if (lbcount - inode->i_size >= inode->i_sb->s_blocksize)
-				printk(KERN_WARNING
-				       "udf_truncate_tail_extent(): Too long "
+				pr_warn("udf_truncate_tail_extent(): Too long "
 				       "extent after EOF in inode %u: i_size: "
 				       "%Ld lbcount: %Ld extent %u+%u\n",
 				       (unsigned)inode->i_ino,
@@ -109,7 +108,7 @@ void udf_truncate_tail_extent(struct inode *inode)
 			extent_trunc(inode, &epos, &eloc, etype, elen, nelen);
 			epos.offset += adsize;
 			if (udf_next_aext(inode, &epos, &eloc, &elen, 1) != -1)
-				printk(KERN_ERR "udf_truncate_tail_extent(): "
+				pr_err("udf_truncate_tail_extent(): "
 				       "Extent after EOF in inode %u.\n",
 				       (unsigned)inode->i_ino);
 			break;
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index dbd52d4b..e625ae7 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -1,6 +1,8 @@
 #ifndef __UDF_DECL_H
 #define __UDF_DECL_H
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "ecma_167.h"
 #include "osta_udf.h"
 
@@ -21,7 +23,7 @@
 #ifdef UDFFS_DEBUG
 #define udf_debug(f, a...) \
 do { \
-	printk(KERN_DEBUG "UDF-fs DEBUG %s:%d:%s: ", \
+	pr_debug("DEBUG %s:%d:%s: ", \
 		__FILE__, __LINE__, __func__); \
 	printk(f, ##a); \
 } while (0)
@@ -30,7 +32,7 @@ do { \
 #endif
 
 #define udf_info(f, a...) \
-	printk(KERN_INFO "UDF-fs INFO " f, ##a);
+	pr_info("INFO " f, ##a);
 
 
 #define udf_fixed_to_variable(x) ( ( ( (x) >> 5 ) * 39 ) + ( (x) & 0x0000001F ) )
diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
index b8c828c..927c931 100644
--- a/fs/udf/udftime.c
+++ b/fs/udf/udftime.c
@@ -34,9 +34,9 @@
  * http://www.boulder.nist.gov/timefreq/pubs/bulletin/leapsecond.htm
  */
 
+#include "udfdecl.h"
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include "udfdecl.h"
 
 #define EPOCH_YEAR 1970
 
diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index d03a90b..9455dc7 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -114,7 +114,7 @@ int udf_CS0toUTF8(struct ustr *utf_o, const struct ustr *ocu_i)
 	cmp_id = ocu_i->u_cmpID;
 	if (cmp_id != 8 && cmp_id != 16) {
 		memset(utf_o, 0, sizeof(struct ustr));
-		printk(KERN_ERR "udf: unknown compression code (%d) stri=%s\n",
+		pr_err("unknown compression code (%d) stri=%s\n",
 		       cmp_id, ocu_i->u_name);
 		return 0;
 	}
@@ -242,7 +242,7 @@ try_again:
 	if (utf_cnt) {
 error_out:
 		ocu[++u_len] = '?';
-		printk(KERN_DEBUG "udf: bad UTF-8 character\n");
+		pr_debug("bad UTF-8 character\n");
 	}
 
 	ocu[length - 1] = (uint8_t)u_len + 1;
@@ -267,7 +267,7 @@ static int udf_CS0toNLS(struct nls_table *nls, struct ustr *utf_o,
 	cmp_id = ocu_i->u_cmpID;
 	if (cmp_id != 8 && cmp_id != 16) {
 		memset(utf_o, 0, sizeof(struct ustr));
-		printk(KERN_ERR "udf: unknown compression code (%d) stri=%s\n",
+		pr_err("unknown compression code (%d) stri=%s\n",
 		       cmp_id, ocu_i->u_name);
 		return 0;
 	}
-- 
1.7.4.4

