Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1JJIJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:09:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53684 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751884Ab1JJII7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:08:59 -0400
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: NamJae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] udf: Convert printks to pr_<level>
Date: Mon, 10 Oct 2011 01:08:05 -0700
Message-Id: <2eb3e996c9fd511f4c3dbf6f26efa3481b70a87a.1318233879.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1318233879.git.joe@perches.com>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com> <cover.1318233879.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the current logging styles.

Convert a few printks that should have been udf_warn and udf_err.
Coalesce formats.  Add #define pr_fmt.
Move an #include "udfdecls.h" above other includes in udftime.c
so pr_fmt works correctly.  Strip prefixes from conversions as appropriate.
Reorder logging definitions in udfdecl.h

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/udf/directory.c |    4 +-
 fs/udf/inode.c     |   33 +++++++++++--------------
 fs/udf/super.c     |   67 +++++++++++++++++++++------------------------------
 fs/udf/truncate.c  |   21 +++++++---------
 fs/udf/udfdecl.h   |   38 ++++++++++++++--------------
 fs/udf/udftime.c   |    3 +-
 fs/udf/unicode.c   |    6 ++--
 7 files changed, 77 insertions(+), 95 deletions(-)

diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index 2ffdb67..4e08438 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -201,7 +201,7 @@ struct short_ad *udf_get_fileshortad(uint8_t *ptr, int maxoffset, uint32_t *offs
 	struct short_ad *sa;
 
 	if ((!ptr) || (!offset)) {
-		printk(KERN_ERR "udf: udf_get_fileshortad() invalidparms\n");
+		pr_err("%s: invalidparms\n", __func__);
 		return NULL;
 	}
 
@@ -223,7 +223,7 @@ struct long_ad *udf_get_filelongad(uint8_t *ptr, int maxoffset, uint32_t *offset
 	struct long_ad *la;
 
 	if ((!ptr) || (!offset)) {
-		printk(KERN_ERR "udf: udf_get_filelongad() invalidparms\n");
+		pr_err("%s: invalidparms\n", __func__);
 		return NULL;
 	}
 
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 1d1358e..663b04b 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -83,12 +83,10 @@ void udf_evict_inode(struct inode *inode)
 	end_writeback(inode);
 	if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB &&
 	    inode->i_size != iinfo->i_lenExtents) {
-		printk(KERN_WARNING "UDF-fs (%s): Inode %lu (mode %o) has "
-			"inode size %llu different from extent length %llu. "
-			"Filesystem need not be standards compliant.\n",
-			inode->i_sb->s_id, inode->i_ino, inode->i_mode,
-			(unsigned long long)inode->i_size,
-			(unsigned long long)iinfo->i_lenExtents);
+		udf_warn(inode->i_sb, "Inode %lu (mode %o) has inode size %llu different from extent length %llu. Filesystem need not be standards compliant.\n",
+			 inode->i_ino, inode->i_mode,
+			 (unsigned long long)inode->i_size,
+			 (unsigned long long)iinfo->i_lenExtents);
 	}
 	kfree(iinfo->i_ext.i_data);
 	iinfo->i_ext.i_data = NULL;
@@ -1169,16 +1167,15 @@ static void __udf_read_inode(struct inode *inode)
 	 */
 	bh = udf_read_ptagged(inode->i_sb, &iinfo->i_location, 0, &ident);
 	if (!bh) {
-		printk(KERN_ERR "udf: udf_read_inode(ino %ld) failed !bh\n",
-		       inode->i_ino);
+		udf_err(inode->i_sb, "(ino %ld) failed !bh\n", inode->i_ino);
 		make_bad_inode(inode);
 		return;
 	}
 
 	if (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE &&
 	    ident != TAG_IDENT_USE) {
-		printk(KERN_ERR "udf: udf_read_inode(ino %ld) "
-				"failed ident=%d\n", inode->i_ino, ident);
+		udf_err(inode->i_sb, "(ino %ld) failed ident=%d\n",
+			inode->i_ino, ident);
 		brelse(bh);
 		make_bad_inode(inode);
 		return;
@@ -1218,7 +1215,7 @@ static void __udf_read_inode(struct inode *inode)
 		}
 		brelse(ibh);
 	} else if (fe->icbTag.strategyType != cpu_to_le16(4)) {
-		printk(KERN_ERR "udf: unsupported strategy type: %d\n",
+		pr_err("unsupported strategy type: %d\n",
 		       le16_to_cpu(fe->icbTag.strategyType));
 		brelse(bh);
 		make_bad_inode(inode);
@@ -1413,9 +1410,8 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		udf_debug("METADATA BITMAP FILE-----\n");
 		break;
 	default:
-		printk(KERN_ERR "udf: udf_fill_inode(ino %ld) failed unknown "
-				"file type=%d\n", inode->i_ino,
-				fe->icbTag.fileType);
+		udf_err(inode->i_sb, "(ino %ld) failed unknown file type=%d\n",
+			inode->i_ino, fe->icbTag.fileType);
 		make_bad_inode(inode);
 		return;
 	}
@@ -1438,8 +1434,8 @@ static int udf_alloc_i_data(struct inode *inode, size_t size)
 	iinfo->i_ext.i_data = kmalloc(size, GFP_KERNEL);
 
 	if (!iinfo->i_ext.i_data) {
-		printk(KERN_ERR "udf:udf_alloc_i_data (ino %ld) "
-				"no free memory\n", inode->i_ino);
+		udf_err(inode->i_sb, "(ino %ld) no free memory\n",
+			inode->i_ino);
 		return -ENOMEM;
 	}
 
@@ -1689,9 +1685,8 @@ out:
 	if (do_sync) {
 		sync_dirty_buffer(bh);
 		if (buffer_write_io_error(bh)) {
-			printk(KERN_WARNING "IO error syncing udf inode "
-				"[%s:%08lx]\n", inode->i_sb->s_id,
-				inode->i_ino);
+			udf_warn(inode->i_sb, "IO error syncing udf inode [%08lx]\n",
+				 inode->i_ino);
 			err = -EIO;
 		}
 	}
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 622331f..ea1b44b 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -547,8 +547,7 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
 			uopt->dmode = option & 0777;
 			break;
 		default:
-			printk(KERN_ERR "udf: bad mount option \"%s\" "
-			       "or missing value\n", p);
+			pr_err("bad mount option \"%s\" or missing value\n", p);
 			return 0;
 		}
 	}
@@ -1106,11 +1105,9 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 	udf_find_vat_block(sb, p_index, type1_index, sbi->s_last_block);
 	if (!sbi->s_vat_inode &&
 	    sbi->s_last_block != blocks - 1) {
-		printk(KERN_NOTICE "UDF-fs: Failed to read VAT inode from the"
-		       " last recorded block (%lu), retrying with the last "
-		       "block of the device (%lu).\n",
-		       (unsigned long)sbi->s_last_block,
-		       (unsigned long)blocks - 1);
+		pr_notice("Failed to read VAT inode from the last recorded block (%lu), retrying with the last block of the device (%lu).\n",
+			  (unsigned long)sbi->s_last_block,
+			  (unsigned long)blocks - 1);
 		udf_find_vat_block(sb, p_index, type1_index, blocks - 1);
 	}
 	if (!sbi->s_vat_inode)
@@ -1208,8 +1205,7 @@ static int udf_load_partdesc(struct super_block *sb, sector_t block)
 	if (map->s_partition_type == UDF_METADATA_MAP25) {
 		ret = udf_load_metadata_files(sb, i);
 		if (ret) {
-			printk(KERN_ERR "UDF-fs: error loading MetaData "
-			"partition map %d\n", i);
+			pr_err("error loading MetaData partition map %d\n", i);
 			goto out_bh;
 		}
 	} else {
@@ -1222,9 +1218,7 @@ static int udf_load_partdesc(struct super_block *sb, sector_t block)
 		 * overwrite blocks instead of relocating them).
 		 */
 		sb->s_flags |= MS_RDONLY;
-		printk(KERN_NOTICE "UDF-fs: Filesystem marked read-only "
-			"because writing to pseudooverwrite partition is "
-			"not implemented.\n");
+		pr_notice("Filesystem marked read-only because writing to pseudooverwrite partition is not implemented\n");
 	}
 out_bh:
 	/* In case loading failed, we handle cleanup in udf_fill_super */
@@ -1466,9 +1460,8 @@ static noinline int udf_process_sequence(struct super_block *sb, long block,
 
 		bh = udf_read_tagged(sb, block, block, &ident);
 		if (!bh) {
-			printk(KERN_ERR "udf: Block %Lu of volume descriptor "
-			       "sequence is corrupted or we could not read "
-			       "it.\n", (unsigned long long)block);
+			pr_err("Block %llu of volume descriptor sequence is corrupted or we could not read it\n",
+			       (unsigned long long)block);
 			return 1;
 		}
 
@@ -1541,7 +1534,7 @@ static noinline int udf_process_sequence(struct super_block *sb, long block,
 	 * in a suitable order
 	 */
 	if (!vds[VDS_POS_PRIMARY_VOL_DESC].block) {
-		printk(KERN_ERR "udf: Primary Volume Descriptor not found!\n");
+		pr_err("Primary Volume Descriptor not found!\n");
 		return 1;
 	}
 	if (udf_load_pvoldesc(sb, vds[VDS_POS_PRIMARY_VOL_DESC].block))
@@ -1728,7 +1721,7 @@ static int udf_load_vrs(struct super_block *sb, struct udf_options *uopt,
 
 	if (!sb_set_blocksize(sb, uopt->blocksize)) {
 		if (!silent)
-			printk(KERN_WARNING "UDF-fs: Bad block size\n");
+			pr_warn("Bad block size\n");
 		return 0;
 	}
 	sbi->s_last_block = uopt->lastblock;
@@ -1737,7 +1730,7 @@ static int udf_load_vrs(struct super_block *sb, struct udf_options *uopt,
 		nsr_off = udf_check_vsd(sb);
 		if (!nsr_off) {
 			if (!silent)
-				printk(KERN_WARNING "UDF-fs: No VRS found\n");
+				pr_warn("No VRS found\n");
 			return 0;
 		}
 		if (nsr_off == -1)
@@ -1753,7 +1746,7 @@ static int udf_load_vrs(struct super_block *sb, struct udf_options *uopt,
 	sbi->s_anchor = uopt->anchor;
 	if (!udf_find_anchor(sb, fileset)) {
 		if (!silent)
-			printk(KERN_WARNING "UDF-fs: No anchor found\n");
+			pr_warn("No anchor found\n");
 		return 0;
 	}
 	return 1;
@@ -1974,15 +1967,14 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 		ret = udf_load_vrs(sb, &uopt, silent, &fileset);
 		if (!ret && uopt.blocksize != UDF_DEFAULT_BLOCKSIZE) {
 			if (!silent)
-				printk(KERN_NOTICE
-				       "UDF-fs: Rescanning with blocksize "
-				       "%d\n", UDF_DEFAULT_BLOCKSIZE);
+				pr_notice("Rescanning with blocksize %d\n",
+					  UDF_DEFAULT_BLOCKSIZE);
 			uopt.blocksize = UDF_DEFAULT_BLOCKSIZE;
 			ret = udf_load_vrs(sb, &uopt, silent, &fileset);
 		}
 	}
 	if (!ret) {
-		printk(KERN_WARNING "UDF-fs: No partition found (1)\n");
+		pr_warn("No partition found (1)\n");
 		goto error_out;
 	}
 
@@ -1997,8 +1989,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 				le16_to_cpu(lvidiu->maxUDFWriteRev); */
 
 		if (minUDFReadRev > UDF_MAX_READ_VERSION) {
-			printk(KERN_ERR "UDF-fs: minUDFReadRev=%x "
-					"(max is %x)\n",
+			pr_err("minUDFReadRev=%x (max is %x)\n",
 			       le16_to_cpu(lvidiu->minUDFReadRev),
 			       UDF_MAX_READ_VERSION);
 			goto error_out;
@@ -2014,28 +2005,27 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	}
 
 	if (!sbi->s_partitions) {
-		printk(KERN_WARNING "UDF-fs: No partition found (2)\n");
+		pr_warn("No partition found (2)\n");
 		goto error_out;
 	}
 
 	if (sbi->s_partmaps[sbi->s_partition].s_partition_flags &
 			UDF_PART_FLAG_READ_ONLY) {
-		printk(KERN_NOTICE "UDF-fs: Partition marked readonly; "
-				   "forcing readonly mount\n");
+		pr_notice("Partition marked readonly; forcing readonly mount\n");
 		sb->s_flags |= MS_RDONLY;
 	}
 
 	if (udf_find_fileset(sb, &fileset, &rootdir)) {
-		printk(KERN_WARNING "UDF-fs: No fileset found\n");
+		pr_warn("No fileset found\n");
 		goto error_out;
 	}
 
 	if (!silent) {
 		struct timestamp ts;
 		udf_time_to_disk_stamp(&ts, sbi->s_record_time);
-		udf_info("UDF: Mounting volume '%s', "
-			 "timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
-			 sbi->s_volume_ident, le16_to_cpu(ts.year), ts.month, ts.day,
+		udf_info("Mounting volume '%s', timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
+			 sbi->s_volume_ident,
+			 le16_to_cpu(ts.year), ts.month, ts.day,
 			 ts.hour, ts.minute, le16_to_cpu(ts.typeAndTimezone));
 	}
 	if (!(sb->s_flags & MS_RDONLY))
@@ -2046,8 +2036,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	/* perhaps it's not extensible enough, but for now ... */
 	inode = udf_iget(sb, &rootdir);
 	if (!inode) {
-		printk(KERN_ERR "UDF-fs: Error in udf_iget, block=%d, "
-				"partition=%d\n",
+		pr_err("Error in udf_iget, block=%d, partition=%d\n",
 		       rootdir.logicalBlockNum, rootdir.partitionReferenceNum);
 		goto error_out;
 	}
@@ -2055,7 +2044,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	/* Allocate a dentry for the root inode */
 	sb->s_root = d_alloc_root(inode);
 	if (!sb->s_root) {
-		printk(KERN_ERR "UDF-fs: Couldn't allocate root dentry\n");
+		pr_err("Couldn't allocate root dentry\n");
 		iput(inode);
 		goto error_out;
 	}
@@ -2095,7 +2084,7 @@ void _udf_err(struct super_block *sb, const char *function,
 	va_start(args, fmt);
 	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
 	va_end(args);
-	printk(KERN_CRIT "UDF-fs error (device %s): %s: %s",
+	pr_crit("error (device %s): %s: %s",
 	       sb->s_id, function, error_buf);
 }
 
@@ -2107,7 +2096,7 @@ void _udf_warn(struct super_block *sb, const char *function,
 	va_start(args, fmt);
 	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
 	va_end(args);
-	printk(KERN_WARNING "UDF-fs warning (device %s): %s: %s",
+	pr_warn("warning (device %s): %s: %s",
 	       sb->s_id, function, error_buf);
 }
 
@@ -2200,11 +2189,11 @@ static unsigned int udf_count_free_bitmap(struct super_block *sb,
 	bh = udf_read_ptagged(sb, &loc, 0, &ident);
 
 	if (!bh) {
-		printk(KERN_ERR "udf: udf_count_free failed\n");
+		pr_err("udf_count_free failed\n");
 		goto out;
 	} else if (ident != TAG_IDENT_SBD) {
 		brelse(bh);
-		printk(KERN_ERR "udf: udf_count_free failed\n");
+		pr_err("udf_count_free failed\n");
 		goto out;
 	}
 
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index 8424308..d6225b3 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -95,23 +95,20 @@ void udf_truncate_tail_extent(struct inode *inode)
 		lbcount += elen;
 		if (lbcount > inode->i_size) {
 			if (lbcount - inode->i_size >= inode->i_sb->s_blocksize)
-				printk(KERN_WARNING
-				       "udf_truncate_tail_extent(): Too long "
-				       "extent after EOF in inode %u: i_size: "
-				       "%Ld lbcount: %Ld extent %u+%u\n",
-				       (unsigned)inode->i_ino,
-				       (long long)inode->i_size,
-				       (long long)lbcount,
-				       (unsigned)eloc.logicalBlockNum,
-				       (unsigned)elen);
+				pr_warn("%s: Too long extent after EOF in inode %u: i_size: %lld lbcount: %lld extent %u+%u\n",
+					__func__,
+					(unsigned)inode->i_ino,
+					(long long)inode->i_size,
+					(long long)lbcount,
+					(unsigned)eloc.logicalBlockNum,
+					(unsigned)elen);
 			nelen = elen - (lbcount - inode->i_size);
 			epos.offset -= adsize;
 			extent_trunc(inode, &epos, &eloc, etype, elen, nelen);
 			epos.offset += adsize;
 			if (udf_next_aext(inode, &epos, &eloc, &elen, 1) != -1)
-				printk(KERN_ERR "udf_truncate_tail_extent(): "
-				       "Extent after EOF in inode %u.\n",
-				       (unsigned)inode->i_ino);
+				pr_err("%s: Extent after EOF in inode %u\n",
+				       __func__, (unsigned)inode->i_ino);
 			break;
 		}
 	}
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 85e15ed..f7273fb 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -1,6 +1,8 @@
 #ifndef __UDF_DECL_H
 #define __UDF_DECL_H
 
+#define pr_fmt(fmt) "UDF-fs: " fmt
+
 #include "ecma_167.h"
 #include "osta_udf.h"
 
@@ -16,18 +18,11 @@
 #define UDF_PREALLOCATE
 #define UDF_DEFAULT_PREALLOC_BLOCKS	8
 
-#undef UDFFS_DEBUG
-
-#ifdef UDFFS_DEBUG
-#define udf_debug(f, a...) \
-do { \
-	printk(KERN_DEBUG "UDF-fs DEBUG %s:%d:%s: ", \
-		__FILE__, __LINE__, __func__); \
-	printk(f, ##a); \
-} while (0)
-#else
-#define udf_debug(f, a...) /**/
-#endif
+__attribute__((format(printf, 3, 4)))
+extern void _udf_err(struct super_block *sb, const char *function,
+		     const char *fmt, ...);
+#define udf_err(sb, fmt, ...)					\
+	_udf_err(sb, __func__, fmt, ##__VA_ARGS__)
 
 __attribute__((format(printf, 3, 4)))
 extern void _udf_warn(struct super_block *sb, const char *function,
@@ -35,14 +30,19 @@ extern void _udf_warn(struct super_block *sb, const char *function,
 #define udf_warn(sb, fmt, ...)					\
 	_udf_warn(sb, __func__, fmt, ##__VA_ARGS__)
 
-__attribute__((format(printf, 3, 4)))
-extern void _udf_err(struct super_block *sb, const char *function,
-		     const char *fmt, ...);
-#define udf_err(sb, fmt, ...)					\
-	_udf_err(sb, __func__, fmt, ##__VA_ARGS__)
+#define udf_info(fmt, ...)					\
+	pr_info("INFO " fmt, ##__VA_ARGS__)
 
-#define udf_info(f, a...) \
-	printk(KERN_INFO "UDF-fs INFO " f, ##a);
+#undef UDFFS_DEBUG
+
+#ifdef UDFFS_DEBUG
+#define udf_debug(fmt, ...)					\
+	printk(KERN_DEBUG pr_fmt("%s:%d:%s: " fmt),		\
+	       __FILE__, __LINE__, __func__, ##__VA_ARGS_)
+#else
+#define udf_debug(fmt, ...)					\
+	no_printk(fmt, ##__VA_ARGS__)
+#endif
 
 #define udf_fixed_to_variable(x) ( ( ( (x) >> 5 ) * 39 ) + ( (x) & 0x0000001F ) )
 #define udf_variable_to_fixed(x) ( ( ( (x) / 39 ) << 5 ) + ( (x) % 39 ) )
diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
index b8c828c..1f11483 100644
--- a/fs/udf/udftime.c
+++ b/fs/udf/udftime.c
@@ -34,9 +34,10 @@
  * http://www.boulder.nist.gov/timefreq/pubs/bulletin/leapsecond.htm
  */
 
+#include "udfdecl.h"
+
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include "udfdecl.h"
 
 #define EPOCH_YEAR 1970
 
diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index d03a90b..44b815e 100644
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
+		printk(KERN_DEBUG pr_fmt("bad UTF-8 character\n"));
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
1.7.6.405.gc1be0

