Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab1JCWR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 18:17:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37143 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752414Ab1JCWRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 18:17:51 -0400
Message-ID: <1317680270.13927.13.camel@Joe-Laptop>
Subject: Re: [PATCH 1/2 v2] udf : enable error print in udf_read_tagged().
From: Joe Perches <joe@perches.com>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
Date: Mon, 03 Oct 2011 15:17:50 -0700
In-Reply-To: <CAKYAXd9HMPQYiab7r5jjKoMyxArrfkoF74zBfwdBndA5PYQO6A@mail.gmail.com>
References: <1317626352-29971-1-git-send-email-linkinjeon@gmail.com>
	 <1317646666.3866.3.camel@Joe-Laptop>
	 <CAKYAXd9HMPQYiab7r5jjKoMyxArrfkoF74zBfwdBndA5PYQO6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 22:58 +0900, NamJae Jeon wrote:
> 2011/10/3 Joe Perches <joe@perches.com>:
> > On Mon, 2011-10-03 at 16:19 +0900, Namjae Jeon wrote:
> >> And I use pr_fmt instead of printk by joe's suggestion. I try to modify totally it to pr_fmt also.
> > []
> >> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
> > []
> >> @@ -19,18 +21,15 @@
> >>  #undef UDFFS_DEBUG
> >>
> >>  #ifdef UDFFS_DEBUG
> >> -#define udf_debug(f, a...) \
> >> -do { \
> >> -     printk(KERN_DEBUG "UDF-fs DEBUG %s:%d:%s: ", \
> >> -             __FILE__, __LINE__, __func__); \
> >> -     printk(f, ##a); \
> >> -} while (0)
> >> +#define udf_debug(fmt, ...)  \
> >> +     pr_debug("DEBUG %s:%d:%s: ", fmt,       \
> >> +             __FILE__, __LINE__, __func__, __VA_ARGS__);
> >
> > This doesn't compile properly if UDFFS_DEBUG is
> > #defined.
> >
> > No comma should be between "DEBUG %s:%d:%s: " and fmt.
> Hi. Joe.
> oops! it's my mistake.
> I  sent v3 patch again.
> Would you review one more ?

It looks OK except for a few issues.

The udf_debug macro doesn't need a semicolon after
pr_debug(foo); it should be pr_debug(foo)
Same for udf_info.

The output prefixes are a mixture of "udf: " and "UDF-fs: "

Some lines are printed with 2 newlines.

I've done the patch below on top of your patch.
It should fix up these trivial things.

Perhaps you'll inspect this too.

Convert printks to pr_<level>.
Coalesce formats.
Rename udf_warning to udf_warn.
Add __attribute__((format(printf... verification to udf_warn.
Rename udf_error to udf_err.
Remove static from udf_err for consistency with other udf_<level> uses.
Use printf extension "%pV" in udf_warn and udf_err
Remove now unused static char error_buf[1024].
Add no_printk to udf_debug when not #define UDF_DEBUG.
Align multiline arguments to open parenthesis.
Add newline to message formats where appropriate.

---

 fs/udf/balloc.c    |    9 +-
 fs/udf/directory.c |    9 +-
 fs/udf/inode.c     |    3 +-
 fs/udf/namei.c     |    6 +-
 fs/udf/partition.c |   12 ++--
 fs/udf/super.c     |  213 ++++++++++++++++++++++++----------------------------
 fs/udf/udfdecl.h   |   26 ++++---
 7 files changed, 132 insertions(+), 146 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 95518a9..48bd5c7 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -59,8 +59,8 @@ static int __load_block_bitmap(struct super_block *sb,
 	int nr_groups = bitmap->s_nr_groups;
 
 	if (block_group >= nr_groups) {
-		udf_debug("block_group (%d) > nr_groups (%d)\n", block_group,
-			  nr_groups);
+		udf_debug("block_group (%d) > nr_groups (%d)\n",
+			  block_group, nr_groups);
 	}
 
 	if (bitmap->s_block_bitmap[block_group]) {
@@ -155,7 +155,7 @@ static void udf_bitmap_free_blocks(struct super_block *sb,
 			if (udf_set_bit(bit + i, bh->b_data)) {
 				udf_debug("bit %ld already set\n", bit + i);
 				udf_debug("byte=%2x\n",
-					((char *)bh->b_data)[(bit + i) >> 3]);
+					  ((char *)bh->b_data)[(bit + i) >> 3]);
 			}
 		}
 		udf_add_free_space(sb, sbi->s_partition, count);
@@ -369,7 +369,8 @@ static void udf_table_free_blocks(struct super_block *sb,
 	if (bloc->logicalBlockNum + count < count ||
 	    (bloc->logicalBlockNum + count) > partmap->s_partition_len) {
 		udf_debug("%d < %d || %d + %d > %d\n",
-			  bloc->logicalBlockNum, 0, bloc->logicalBlockNum, count,
+			  bloc->logicalBlockNum, 0,
+			  bloc->logicalBlockNum, count,
 			  partmap->s_partition_len);
 		goto error_return;
 	}
diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index a4caf7a..73136e6 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -162,8 +162,8 @@ struct fileIdentDesc *udf_get_fileident(void *buffer, int bufsize, int *offset)
 	int padlen;
 
 	if ((!buffer) || (!offset)) {
-		udf_debug("invalidparms\n, buffer=%p, offset=%p\n", buffer,
-			  offset);
+		udf_debug("invalidparms, buffer=%p, offset=%p\n",
+			  buffer, offset);
 		return NULL;
 	}
 
@@ -175,9 +175,8 @@ struct fileIdentDesc *udf_get_fileident(void *buffer, int bufsize, int *offset)
 	if (fi->descTag.tagIdent != cpu_to_le16(TAG_IDENT_FID)) {
 		udf_debug("0x%x != TAG_IDENT_FID\n",
 			  le16_to_cpu(fi->descTag.tagIdent));
-		udf_debug("offset: %u sizeof: %lu bufsize: %u\n",
-			  *offset, (unsigned long)sizeof(struct fileIdentDesc),
-			  bufsize);
+		udf_debug("offset: %u sizeof: %zu bufsize: %u\n",
+			  *offset, sizeof(struct fileIdentDesc), bufsize);
 		return NULL;
 	}
 	if ((*offset + sizeof(struct fileIdentDesc)) > bufsize)
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 58665ce..6621c2a 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1982,8 +1982,7 @@ int8_t udf_current_aext(struct inode *inode, struct extent_position *epos,
 		*elen = le32_to_cpu(lad->extLength) & UDF_EXTENT_LENGTH_MASK;
 		break;
 	default:
-		udf_debug("alloc_type = %d unsupported\n",
-				iinfo->i_alloc_type);
+		udf_debug("alloc_type = %d unsupported\n", iinfo->i_alloc_type);
 		return -1;
 	}
 
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index f1dce84..bd936c9 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -799,9 +799,9 @@ static int udf_rmdir(struct inode *dir, struct dentry *dentry)
 	if (retval)
 		goto end_rmdir;
 	if (inode->i_nlink != 2)
-		udf_warning(inode->i_sb, "udf_rmdir",
-			    "empty directory has nlink != 2 (%d)",
-			    inode->i_nlink);
+		udf_warn(inode->i_sb, "udf_rmdir",
+			 "empty directory has nlink != 2 (%d)\n",
+			 inode->i_nlink);
 	clear_nlink(inode);
 	inode->i_size = 0;
 	inode_dec_link_count(dir);
diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index a71090e..849039a 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -33,8 +33,8 @@ uint32_t udf_get_pblock(struct super_block *sb, uint32_t block,
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct udf_part_map *map;
 	if (partition >= sbi->s_partitions) {
-		udf_debug("block=%d, partition=%d, offset=%d: "
-			  "invalid partition\n", block, partition, offset);
+		udf_debug("block=%d, partition=%d, offset=%d: invalid partition\n",
+			  block, partition, offset);
 		return 0xFFFFFFFF;
 	}
 	map = &sbi->s_partmaps[partition];
@@ -60,8 +60,8 @@ uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block,
 	vdata = &map->s_type_specific.s_virtual;
 
 	if (block > vdata->s_num_entries) {
-		udf_debug("Trying to access block beyond end of VAT "
-			  "(%d max %d)\n", block, vdata->s_num_entries);
+		udf_debug("Trying to access block beyond end of VAT (%d max %d)\n",
+			  block, vdata->s_num_entries);
 		return 0xFFFFFFFF;
 	}
 
@@ -322,8 +322,8 @@ uint32_t udf_get_pblock_meta25(struct super_block *sb, uint32_t block,
 	BUG_ON(!inode);
 	retblk = udf_try_read_meta(inode, block, partition, offset);
 	if (retblk == 0xFFFFFFFF) {
-		udf_warning(sb, __func__, "error reading from METADATA, "
-			"trying to read from MIRROR");
+		udf_warn(sb, __func__,
+			 "error reading from METADATA, trying to read from MIRROR\n");
 		inode = mdata->s_mirror_fe;
 		if (!inode)
 			return 0xFFFFFFFF;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index bbf6256..ab921f9 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -75,8 +75,6 @@
 
 #define UDF_DEFAULT_BLOCKSIZE 2048
 
-static char error_buf[1024];
-
 /* These are the "meat" - everything else is stuffing */
 static int udf_fill_super(struct super_block *, void *, int);
 static void udf_put_super(struct super_block *);
@@ -92,8 +90,6 @@ static void udf_close_lvid(struct super_block *);
 static unsigned int udf_count_free(struct super_block *);
 static int udf_statfs(struct dentry *, struct kstatfs *);
 static int udf_show_options(struct seq_file *, struct vfsmount *);
-static void udf_error(struct super_block *sb, const char *function,
-		      const char *fmt, ...);
 
 struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi)
 {
@@ -244,9 +240,9 @@ static int udf_sb_alloc_partition_maps(struct super_block *sb, u32 count)
 	sbi->s_partmaps = kcalloc(count, sizeof(struct udf_part_map),
 				  GFP_KERNEL);
 	if (!sbi->s_partmaps) {
-		udf_error(sb, __func__,
-			  "Unable to allocate space for %d partition maps",
-			  count);
+		udf_err(sb, __func__,
+			"Unable to allocate space for %d partition maps\n",
+			count);
 		sbi->s_partitions = 0;
 		return -ENOMEM;
 	}
@@ -550,8 +546,7 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
 			uopt->dmode = option & 0777;
 			break;
 		default:
-			pr_err("bad mount option \"%s\" "
-			       "or missing value\n", p);
+			pr_err("bad mount option \"%s\" or missing value\n", p);
 			return 0;
 		}
 	}
@@ -645,20 +640,16 @@ static loff_t udf_check_vsd(struct super_block *sb)
 				udf_debug("ISO9660 Boot Record found\n");
 				break;
 			case 1:
-				udf_debug("ISO9660 Primary Volume Descriptor "
-					  "found\n");
+				udf_debug("ISO9660 Primary Volume Descriptor found\n");
 				break;
 			case 2:
-				udf_debug("ISO9660 Supplementary Volume "
-					  "Descriptor found\n");
+				udf_debug("ISO9660 Supplementary Volume Descriptor found\n");
 				break;
 			case 3:
-				udf_debug("ISO9660 Volume Partition Descriptor "
-					  "found\n");
+				udf_debug("ISO9660 Volume Partition Descriptor found\n");
 				break;
 			case 255:
-				udf_debug("ISO9660 Volume Descriptor Set "
-					  "Terminator found\n");
+				udf_debug("ISO9660 Volume Descriptor Set Terminator found\n");
 				break;
 			default:
 				udf_debug("ISO9660 VRS (%u) found\n",
@@ -809,8 +800,7 @@ static int udf_load_pvoldesc(struct super_block *sb, sector_t block)
 			      pvoldesc->recordingDateAndTime)) {
 #ifdef UDFFS_DEBUG
 		struct timestamp *ts = &pvoldesc->recordingDateAndTime;
-		udf_debug("recording time %04u/%02u/%02u"
-			  " %02u:%02u (%x)\n",
+		udf_debug("recording time %04u/%02u/%02u %02u:%02u (%x)\n",
 			  le16_to_cpu(ts->year), ts->month, ts->day, ts->hour,
 			  ts->minute, le16_to_cpu(ts->typeAndTimezone));
 #endif
@@ -821,7 +811,7 @@ static int udf_load_pvoldesc(struct super_block *sb, sector_t block)
 			strncpy(UDF_SB(sb)->s_volume_ident, outstr->u_name,
 				outstr->u_len > 31 ? 31 : outstr->u_len);
 			udf_debug("volIdent[] = '%s'\n",
-					UDF_SB(sb)->s_volume_ident);
+				  UDF_SB(sb)->s_volume_ident);
 		}
 
 	if (!udf_build_ustr(instr, pvoldesc->volSetIdent, 128))
@@ -853,18 +843,16 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 	addr.partitionReferenceNum = map->s_partition_num;
 
 	udf_debug("Metadata file location: block = %d part = %d\n",
-			  addr.logicalBlockNum, addr.partitionReferenceNum);
+		  addr.logicalBlockNum, addr.partitionReferenceNum);
 
 	mdata->s_metadata_fe = udf_iget(sb, &addr);
 
 	if (mdata->s_metadata_fe == NULL) {
-		udf_warning(sb, __func__, "metadata inode efe not found, "
-				"will try mirror inode.");
+		udf_warn(sb, __func__, "metadata inode efe not found, will try mirror inode\n");
 		fe_error = 1;
 	} else if (UDF_I(mdata->s_metadata_fe)->i_alloc_type !=
 		 ICBTAG_FLAG_AD_SHORT) {
-		udf_warning(sb, __func__, "metadata inode efe does not have "
-			"short allocation descriptors!");
+		udf_warn(sb, __func__, "metadata inode efe does not have short allocation descriptors!\n");
 		fe_error = 1;
 		iput(mdata->s_metadata_fe);
 		mdata->s_metadata_fe = NULL;
@@ -875,22 +863,22 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 	addr.partitionReferenceNum = map->s_partition_num;
 
 	udf_debug("Mirror metadata file location: block = %d part = %d\n",
-			  addr.logicalBlockNum, addr.partitionReferenceNum);
+		  addr.logicalBlockNum, addr.partitionReferenceNum);
 
 	mdata->s_mirror_fe = udf_iget(sb, &addr);
 
 	if (mdata->s_mirror_fe == NULL) {
 		if (fe_error) {
-			udf_error(sb, __func__, "mirror inode efe not found "
-			"and metadata inode is missing too, exiting...");
+			udf_err(sb, __func__,
+				"mirror inode efe not found and metadata inode is missing too, exiting...\n");
 			goto error_exit;
 		} else
-			udf_warning(sb, __func__, "mirror inode efe not found,"
-					" but metadata inode is OK");
+			udf_warn(sb, __func__,
+				 "mirror inode efe not found, but metadata inode is OK\n");
 	} else if (UDF_I(mdata->s_mirror_fe)->i_alloc_type !=
 		 ICBTAG_FLAG_AD_SHORT) {
-		udf_warning(sb, __func__, "mirror inode efe does not have "
-			"short allocation descriptors!");
+		udf_warn(sb, __func__,
+			 "mirror inode efe does not have short allocation descriptors!\n");
 		iput(mdata->s_mirror_fe);
 		mdata->s_mirror_fe = NULL;
 		if (fe_error)
@@ -907,18 +895,17 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 		addr.partitionReferenceNum = map->s_partition_num;
 
 		udf_debug("Bitmap file location: block = %d part = %d\n",
-			addr.logicalBlockNum, addr.partitionReferenceNum);
+			  addr.logicalBlockNum, addr.partitionReferenceNum);
 
 		mdata->s_bitmap_fe = udf_iget(sb, &addr);
 
 		if (mdata->s_bitmap_fe == NULL) {
 			if (sb->s_flags & MS_RDONLY)
-				udf_warning(sb, __func__, "bitmap inode efe "
-					"not found but it's ok since the disc"
-					" is mounted read-only");
+				udf_warn(sb, __func__,
+					 "bitmap inode efe not found but it's ok since the disc is mounted read-only\n");
 			else {
-				udf_error(sb, __func__, "bitmap inode efe not "
-					"found and attempted read-write mount");
+				udf_err(sb, __func__,
+					"bitmap inode efe not found and attempted read-write mount\n");
 				goto error_exit;
 			}
 		}
@@ -971,9 +958,9 @@ static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
 		bitmap = vzalloc(size); /* TODO: get rid of vzalloc */
 
 	if (bitmap == NULL) {
-		udf_error(sb, __func__,
-			  "Unable to allocate space for bitmap "
-			  "and %d buffer_head pointers", nr_groups);
+		udf_err(sb, __func__,
+			"Unable to allocate space for bitmap and %d buffer_head pointers\n",
+			nr_groups);
 		return NULL;
 	}
 
@@ -1003,8 +990,8 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 	if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_OVERWRITABLE))
 		map->s_partition_flags |= UDF_PART_FLAG_OVERWRITABLE;
 
-	udf_debug("Partition (%d type %x) starts at physical %d, "
-		  "block length %d\n", p_index,
+	udf_debug("Partition (%d type %x) starts at physical %d, block length %d\n",
+		  p_index,
 		  map->s_partition_type, map->s_partition_root,
 		  map->s_partition_len);
 
@@ -1023,12 +1010,12 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 		map->s_uspace.s_table = udf_iget(sb, &loc);
 		if (!map->s_uspace.s_table) {
 			udf_debug("cannot load unallocSpaceTable (part %d)\n",
-					p_index);
+				  p_index);
 			return 1;
 		}
 		map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_TABLE;
 		udf_debug("unallocSpaceTable (part %d) @ %ld\n",
-				p_index, map->s_uspace.s_table->i_ino);
+			  p_index, map->s_uspace.s_table->i_ino);
 	}
 
 	if (phd->unallocSpaceBitmap.extLength) {
@@ -1041,8 +1028,8 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 		bitmap->s_extPosition = le32_to_cpu(
 				phd->unallocSpaceBitmap.extPosition);
 		map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_BITMAP;
-		udf_debug("unallocSpaceBitmap (part %d) @ %d\n", p_index,
-						bitmap->s_extPosition);
+		udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
+			  p_index, bitmap->s_extPosition);
 	}
 
 	if (phd->partitionIntegrityTable.extLength)
@@ -1058,13 +1045,13 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 		map->s_fspace.s_table = udf_iget(sb, &loc);
 		if (!map->s_fspace.s_table) {
 			udf_debug("cannot load freedSpaceTable (part %d)\n",
-				p_index);
+				  p_index);
 			return 1;
 		}
 
 		map->s_partition_flags |= UDF_PART_FLAG_FREED_TABLE;
 		udf_debug("freedSpaceTable (part %d) @ %ld\n",
-				p_index, map->s_fspace.s_table->i_ino);
+			  p_index, map->s_fspace.s_table->i_ino);
 	}
 
 	if (phd->freedSpaceBitmap.extLength) {
@@ -1077,8 +1064,8 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 		bitmap->s_extPosition = le32_to_cpu(
 				phd->freedSpaceBitmap.extPosition);
 		map->s_partition_flags |= UDF_PART_FLAG_FREED_BITMAP;
-		udf_debug("freedSpaceBitmap (part %d) @ %d\n", p_index,
-					bitmap->s_extPosition);
+		udf_debug("freedSpaceBitmap (part %d) @ %d\n",
+			  p_index, bitmap->s_extPosition);
 	}
 	return 0;
 }
@@ -1118,11 +1105,9 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 	udf_find_vat_block(sb, p_index, type1_index, sbi->s_last_block);
 	if (!sbi->s_vat_inode &&
 	    sbi->s_last_block != blocks - 1) {
-		printk(KERN_NOTICE "UDF-fs: Failed to read VAT inode from the"
-		       " last recorded block (%lu), retrying with the last "
-		       "block of the device (%lu).\n",
-		       (unsigned long)sbi->s_last_block,
-		       (unsigned long)blocks - 1);
+		pr_notice("Failed to read VAT inode from the last recorded block (%lu), retrying with the last block of the device (%lu)\n",
+			  (unsigned long)sbi->s_last_block,
+			  (unsigned long)blocks - 1);
 		udf_find_vat_block(sb, p_index, type1_index, blocks - 1);
 	}
 	if (!sbi->s_vat_inode)
@@ -1220,8 +1205,7 @@ static int udf_load_partdesc(struct super_block *sb, sector_t block)
 	if (map->s_partition_type == UDF_METADATA_MAP25) {
 		ret = udf_load_metadata_files(sb, i);
 		if (ret) {
-			printk(KERN_ERR "UDF-fs: error loading MetaData "
-			"partition map %d\n", i);
+			pr_err("error loading MetaData partition map %d\n", i);
 			goto out_bh;
 		}
 	} else {
@@ -1234,9 +1218,7 @@ static int udf_load_partdesc(struct super_block *sb, sector_t block)
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
@@ -1344,9 +1326,8 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 				struct metadataPartitionMap *mdm =
 						(struct metadataPartitionMap *)
 						&(lvd->partitionMaps[offset]);
-				udf_debug("Parsing Logical vol part %d "
-					"type %d  id=%s\n", i, type,
-					UDF_ID_METADATA);
+				udf_debug("Parsing Logical vol part %d type %d  id=%s\n",
+					  i, type, UDF_ID_METADATA);
 
 				map->s_partition_type = UDF_METADATA_MAP25;
 				map->s_partition_func = udf_get_pblock_meta25;
@@ -1365,21 +1346,20 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 					mdm->flags & 0x01;
 
 				udf_debug("Metadata Ident suffix=0x%x\n",
-					(le16_to_cpu(
-					 ((__le16 *)
-					      mdm->partIdent.identSuffix)[0])));
+					  le16_to_cpu(*(__le16 *)
+						       mdm->partIdent.identSuffix));
 				udf_debug("Metadata part num=%d\n",
-					le16_to_cpu(mdm->partitionNum));
+					  le16_to_cpu(mdm->partitionNum));
 				udf_debug("Metadata part alloc unit size=%d\n",
-					le32_to_cpu(mdm->allocUnitSize));
+					  le32_to_cpu(mdm->allocUnitSize));
 				udf_debug("Metadata file loc=%d\n",
-					le32_to_cpu(mdm->metadataFileLoc));
+					  le32_to_cpu(mdm->metadataFileLoc));
 				udf_debug("Mirror file loc=%d\n",
-				       le32_to_cpu(mdm->metadataMirrorFileLoc));
+					  le32_to_cpu(mdm->metadataMirrorFileLoc));
 				udf_debug("Bitmap file loc=%d\n",
-				       le32_to_cpu(mdm->metadataBitmapFileLoc));
+					  le32_to_cpu(mdm->metadataBitmapFileLoc));
 				udf_debug("Duplicate Flag: %d %d\n",
-					mdata->s_dup_md_flag, mdm->flags);
+					  mdata->s_dup_md_flag, mdm->flags);
 			} else {
 				udf_debug("Unknown ident: %s\n",
 					  upm2->partIdent.ident);
@@ -1397,8 +1377,8 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 		struct long_ad *la = (struct long_ad *)&(lvd->logicalVolContentsUse[0]);
 
 		*fileset = lelb_to_cpu(la->extLocation);
-		udf_debug("FileSet found in LogicalVolDesc at block=%d, "
-			  "partition=%d\n", fileset->logicalBlockNum,
+		udf_debug("FileSet found in LogicalVolDesc at block=%d, partition=%d\n",
+			  fileset->logicalBlockNum,
 			  fileset->partitionReferenceNum);
 	}
 	if (lvd->integritySeqExt.extLength)
@@ -1478,9 +1458,8 @@ static noinline int udf_process_sequence(struct super_block *sb, long block,
 
 		bh = udf_read_tagged(sb, block, block, &ident);
 		if (!bh) {
-			printk(KERN_ERR "udf: Block %Lu of volume descriptor "
-			       "sequence is corrupted or we could not read "
-			       "it.\n", (unsigned long long)block);
+			pr_err("Block %lu of volume descriptor sequence is corrupted or we could not read it\n",
+			       (unsigned long)block);
 			return 1;
 		}
 
@@ -1553,7 +1532,7 @@ static noinline int udf_process_sequence(struct super_block *sb, long block,
 	 * in a suitable order
 	 */
 	if (!vds[VDS_POS_PRIMARY_VOL_DESC].block) {
-		printk(KERN_ERR "udf: Primary Volume Descriptor not found!\n");
+		pr_err("Primary Volume Descriptor not found!\n");
 		return 1;
 	}
 	if (udf_load_pvoldesc(sb, vds[VDS_POS_PRIMARY_VOL_DESC].block))
@@ -1740,7 +1719,7 @@ static int udf_load_vrs(struct super_block *sb, struct udf_options *uopt,
 
 	if (!sb_set_blocksize(sb, uopt->blocksize)) {
 		if (!silent)
-			printk(KERN_WARNING "UDF-fs: Bad block size\n");
+			pr_warn("Bad block size\n");
 		return 0;
 	}
 	sbi->s_last_block = uopt->lastblock;
@@ -1749,12 +1728,11 @@ static int udf_load_vrs(struct super_block *sb, struct udf_options *uopt,
 		nsr_off = udf_check_vsd(sb);
 		if (!nsr_off) {
 			if (!silent)
-				printk(KERN_WARNING "UDF-fs: No VRS found\n");
+				pr_warn("No VRS found\n");
 			return 0;
 		}
 		if (nsr_off == -1)
-			udf_debug("Failed to read byte 32768. Assuming open "
-				  "disc. Skipping validity check\n");
+			udf_debug("Failed to read byte 32768. Assuming open disc. Skipping validity check\n");
 		if (!sbi->s_last_block)
 			sbi->s_last_block = udf_get_last_block(sb);
 	} else {
@@ -1765,7 +1743,7 @@ static int udf_load_vrs(struct super_block *sb, struct udf_options *uopt,
 	sbi->s_anchor = uopt->anchor;
 	if (!udf_find_anchor(sb, fileset)) {
 		if (!silent)
-			printk(KERN_WARNING "UDF-fs: No anchor found\n");
+			pr_warn("No anchor found\n");
 		return 0;
 	}
 	return 1;
@@ -1937,8 +1915,8 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 
 	if (uopt.flags & (1 << UDF_FLAG_UTF8) &&
 	    uopt.flags & (1 << UDF_FLAG_NLS_MAP)) {
-		udf_error(sb, "udf_read_super",
-			  "utf8 cannot be combined with iocharset\n");
+		udf_err(sb, "udf_read_super",
+			"utf8 cannot be combined with iocharset\n");
 		goto error_out;
 	}
 #ifdef CONFIG_UDF_NLS
@@ -1987,15 +1965,14 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
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
 
@@ -2010,8 +1987,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 				le16_to_cpu(lvidiu->maxUDFWriteRev); */
 
 		if (minUDFReadRev > UDF_MAX_READ_VERSION) {
-			printk(KERN_ERR "UDF-fs: minUDFReadRev=%x "
-					"(max is %x)\n",
+			pr_err("minUDFReadRev=%x (max is %x)\n",
 			       le16_to_cpu(lvidiu->minUDFReadRev),
 			       UDF_MAX_READ_VERSION);
 			goto error_out;
@@ -2027,27 +2003,25 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
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
+		udf_info("Mounting volume '%s', timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
 			 sbi->s_volume_ident, le16_to_cpu(ts.year), ts.month, ts.day,
 			 ts.hour, ts.minute, le16_to_cpu(ts.typeAndTimezone));
 	}
@@ -2059,8 +2033,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	/* perhaps it's not extensible enough, but for now ... */
 	inode = udf_iget(sb, &rootdir);
 	if (!inode) {
-		printk(KERN_ERR "UDF-fs: Error in udf_iget, block=%d, "
-				"partition=%d\n",
+		pr_err("Error in udf_iget, block=%d, partition=%d\n",
 		       rootdir.logicalBlockNum, rootdir.partitionReferenceNum);
 		goto error_out;
 	}
@@ -2068,7 +2041,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	/* Allocate a dentry for the root inode */
 	sb->s_root = d_alloc_root(inode);
 	if (!sb->s_root) {
-		printk(KERN_ERR "UDF-fs: Couldn't allocate root dentry\n");
+		pr_err("Couldn't allocate root dentry\n");
 		iput(inode);
 		goto error_out;
 	}
@@ -2096,32 +2069,40 @@ error_out:
 	return -EINVAL;
 }
 
-static void udf_error(struct super_block *sb, const char *function,
-		      const char *fmt, ...)
+void udf_err(struct super_block *sb, const char *function,
+	     const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
-	if (!(sb->s_flags & MS_RDONLY)) {
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (!(sb->s_flags & MS_RDONLY))
 		/* mark sb error */
 		sb->s_dirt = 1;
-	}
-	va_start(args, fmt);
-	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
+
+	pr_crit("error (device %s): %s: %pV", sb->s_id, function, &vaf);
+
 	va_end(args);
-	printk(KERN_CRIT "UDF-fs error (device %s): %s: %s\n",
-		sb->s_id, function, error_buf);
 }
 
-void udf_warning(struct super_block *sb, const char *function,
-		 const char *fmt, ...)
+void udf_warn(struct super_block *sb, const char *function,
+	      const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
-	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	pr_warn("warning (device %s): %s: %pV", sb->s_id, function, &vaf);
+
 	va_end(args);
-	printk(KERN_WARNING "UDF-fs warning (device %s): %s: %s\n",
-	       sb->s_id, function, error_buf);
 }
 
 static void udf_put_super(struct super_block *sb)
@@ -2213,11 +2194,11 @@ static unsigned int udf_count_free_bitmap(struct super_block *sb,
 	bh = udf_read_ptagged(sb, &loc, 0, &ident);
 
 	if (!bh) {
-		printk(KERN_ERR "udf: udf_count_free failed\n");
+		pr_err("udf: udf_count_free failed\n");
 		goto out;
 	} else if (ident != TAG_IDENT_SBD) {
 		brelse(bh);
-		printk(KERN_ERR "udf: udf_count_free failed\n");
+		pr_err("udf: udf_count_free failed\n");
 		goto out;
 	}
 
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index f77c813..f1010b2 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -20,18 +20,26 @@
 
 #undef UDFFS_DEBUG
 
+__attribute__((format(printf, 3, 4)))
+void udf_err(struct super_block *sb, const char *function,
+	     const char *fmt, ...);
+
+__attribute__((format(printf, 3, 4)))
+void udf_warn(struct super_block *sb, const char *function,
+	      const char *fmt, ...);
+
+#define udf_info(fmt, ...)					\
+	pr_info("INFO " fmt, ##__VA_ARGS__)
+
 #ifdef UDFFS_DEBUG
-#define udf_debug(fmt, ...)	\
-	pr_debug("DEBUG %s:%d:%s: " fmt,	\
-		__FILE__, __LINE__, __func__, ##__VA_ARGS__);
+#define udf_debug(fmt, ...)					\
+	pr_debug("DEBUG %s:%d:%s: " fmt,			\
+		 __FILE__, __LINE__, __func__, ##__VA_ARGS__)
 #else
-#define udf_debug(fmt, ...) /**/
+#define udf_debug(fmt, ...)					\
+	no_printk(KERN_DEBUG fmt, ##__VA_ARGS__)
 #endif
 
-#define udf_info(f, a...) \
-	pr_info("INFO " f, ##a);
-
-
 #define udf_fixed_to_variable(x) ( ( ( (x) >> 5 ) * 39 ) + ( (x) & 0x0000001F ) )
 #define udf_variable_to_fixed(x) ( ( ( (x) / 39 ) << 5 ) + ( (x) % 39 ) )
 
@@ -111,8 +119,6 @@ struct extent_position {
 
 /* super.c */
 
-__attribute__((format(printf, 3, 4)))
-extern void udf_warning(struct super_block *, const char *, const char *, ...);
 static inline void udf_updated_lvid(struct super_block *sb)
 {
 	struct buffer_head *bh = UDF_SB(sb)->s_lvid_bh;
-- 
1.7.6.405.gc1be0



