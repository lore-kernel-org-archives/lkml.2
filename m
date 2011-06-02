Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1FBV61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:58:27 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45829 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab1FBV60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:58:26 -0400
Date: Thu, 2 Jun 2011 16:58:21 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Anton Salikhmetov <alexo@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: hfsplus mount regression in 2.6.38
Message-ID: <20110602215821.GA13099@thinkpad-t410>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Anton Salikhmetov <alexo@tuxera.com>, linux-kernel@vger.kernel.org
References: <20110525142521.GA32511@thinkpad-t410>
 <20110527092522.GA11600@infradead.org>
 <20110527132356.GA13908@thinkpad-t410>
 <20110527182406.GB13908@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527182406.GB13908@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 01:24:06PM -0500, Seth Forshee wrote:
> > > Basically all hardcoded uses of HFSPLUS_SECTOR_SIZE need to be replaced
> > > with a use of bdev_logical_block_size, or a per-sb variable derived from
> > > it, and the addressing needs to be accomodated to fit it.  I'd need to
> > > look into a bit more detail in what form the sectors we pass into it
> > > are in - we might have to convert them from 512byte to large units,
> > > or they might already be in it.  If they happen to be in 512 byte units
> > > we might have to do read-modify write cycles.
> > 
> > It seems reasonable to use sb->s_blocksize for this, as it shouldn't get
> > set to anything larger than the logical block size. That's what
> > sb_bread() uses in fact.
> 
> I started looking into this, and it seems like one aspect of it is a
> little nasty. My knowledge here is rudimentary at best though, so maybe
> you can comment on whether or not this situation is possible.
> 
> It looks like some of the metadata accessed via bio can reside in blocks
> adjacent to blocks containing file data, in which case it would be
> possible for some of this metadata to be present in the page cache.
> This could potentially lead to races where metadata changes are
> committed and later overwritten by stale data in the page cache. Is this
> a valid concern?

I took a crack at converting the users of direct bio to use
bdev_logical_block_size instead of HFSPLUS_SECTOR_SIZE. sb->s_blocksize
doesn't turn out to work because it may change after reading the
volume header. The patch is below; feedback is appreciated.

So far I've only done light testing, and no testing with large-sector
devices since I don't have any to test with. I'm still concerned about
duplicating data also in the page cache with this approach. Any thoughts
on whether or not this is something to be worried about?


diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index d685752..4e7f64b 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <linux/mutex.h>
 #include <linux/buffer_head.h>
+#include <linux/blkdev.h>
 #include "hfsplus_raw.h"
 
 #define DBG_BNODE_REFS	0x00000001
@@ -110,7 +111,9 @@ struct hfsplus_vh;
 struct hfs_btree;
 
 struct hfsplus_sb_info {
+	void *s_vhdr_buf;
 	struct hfsplus_vh *s_vhdr;
+	void *s_backup_vhdr_buf;
 	struct hfsplus_vh *s_backup_vhdr;
 	struct hfs_btree *ext_tree;
 	struct hfs_btree *cat_tree;
@@ -258,6 +261,15 @@ struct hfsplus_readdir_data {
 	struct hfsplus_cat_key key;
 };
 
+/*
+ * Find minimum acceptible I/O size for an hfsplus sb.
+ */
+static inline unsigned short hfsplus_min_io_size(struct super_block *sb)
+{
+	return max_t(unsigned short, bdev_logical_block_size(sb->s_bdev),
+		     HFSPLUS_SECTOR_SIZE);
+}
+
 #define hfs_btree_open hfsplus_btree_open
 #define hfs_btree_close hfsplus_btree_close
 #define hfs_btree_write hfsplus_btree_write
@@ -436,8 +448,8 @@ int hfsplus_compare_dentry(const struct dentry *parent,
 /* wrapper.c */
 int hfsplus_read_wrapper(struct super_block *);
 int hfs_part_find(struct super_block *, sector_t *, sector_t *);
-int hfsplus_submit_bio(struct block_device *bdev, sector_t sector,
-		void *data, int rw);
+int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
+		void *buf, void **data, int rw);
 
 /* time macros */
 #define __hfsp_mt2ut(t)		(be32_to_cpu(t) - 2082844800U)
diff --git a/fs/hfsplus/part_tbl.c b/fs/hfsplus/part_tbl.c
index 40ad88c..eb355d8 100644
--- a/fs/hfsplus/part_tbl.c
+++ b/fs/hfsplus/part_tbl.c
@@ -88,11 +88,12 @@ static int hfs_parse_old_pmap(struct super_block *sb, struct old_pmap *pm,
 	return -ENOENT;
 }
 
-static int hfs_parse_new_pmap(struct super_block *sb, struct new_pmap *pm,
-		sector_t *part_start, sector_t *part_size)
+static int hfs_parse_new_pmap(struct super_block *sb, void *buf,
+		struct new_pmap *pm, sector_t *part_start, sector_t *part_size)
 {
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
 	int size = be32_to_cpu(pm->pmMapBlkCnt);
+	int buf_size = hfsplus_min_io_size(sb);
 	int res;
 	int i = 0;
 
@@ -107,11 +108,14 @@ static int hfs_parse_new_pmap(struct super_block *sb, struct new_pmap *pm,
 		if (++i >= size)
 			return -ENOENT;
 
-		res = hfsplus_submit_bio(sb->s_bdev,
-					 *part_start + HFS_PMAP_BLK + i,
-					 pm, READ);
-		if (res)
-			return res;
+		pm = (struct new_pmap *)((u8 *)pm + HFSPLUS_SECTOR_SIZE);
+		if ((u8 *)pm - (u8 *)buf >= buf_size) {
+			res = hfsplus_submit_bio(sb,
+						 *part_start + HFS_PMAP_BLK + i,
+						 buf, (void **)&pm, READ);
+			if (res)
+				return res;
+		}
 	} while (pm->pmSig == cpu_to_be16(HFS_NEW_PMAP_MAGIC));
 
 	return -ENOENT;
@@ -124,15 +128,15 @@ static int hfs_parse_new_pmap(struct super_block *sb, struct new_pmap *pm,
 int hfs_part_find(struct super_block *sb,
 		sector_t *part_start, sector_t *part_size)
 {
-	void *data;
+	void *buf, *data;
 	int res;
 
-	data = kmalloc(HFSPLUS_SECTOR_SIZE, GFP_KERNEL);
-	if (!data)
+	buf = kmalloc(hfsplus_min_io_size(sb), GFP_KERNEL);
+	if (!buf)
 		return -ENOMEM;
 
-	res = hfsplus_submit_bio(sb->s_bdev, *part_start + HFS_PMAP_BLK,
-				 data, READ);
+	res = hfsplus_submit_bio(sb, *part_start + HFS_PMAP_BLK,
+				 buf, &data, READ);
 	if (res)
 		goto out;
 
@@ -141,13 +145,13 @@ int hfs_part_find(struct super_block *sb,
 		res = hfs_parse_old_pmap(sb, data, part_start, part_size);
 		break;
 	case HFS_NEW_PMAP_MAGIC:
-		res = hfs_parse_new_pmap(sb, data, part_start, part_size);
+		res = hfs_parse_new_pmap(sb, buf, data, part_start, part_size);
 		break;
 	default:
 		res = -ENOENT;
 		break;
 	}
 out:
-	kfree(data);
+	kfree(buf);
 	return res;
 }
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index b49b555..3add787 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -197,17 +197,17 @@ int hfsplus_sync_fs(struct super_block *sb, int wait)
 		write_backup = 1;
 	}
 
-	error2 = hfsplus_submit_bio(sb->s_bdev,
+	error2 = hfsplus_submit_bio(sb,
 				   sbi->part_start + HFSPLUS_VOLHEAD_SECTOR,
-				   sbi->s_vhdr, WRITE_SYNC);
+				   sbi->s_vhdr_buf, NULL, WRITE_SYNC);
 	if (!error)
 		error = error2;
 	if (!write_backup)
 		goto out;
 
-	error2 = hfsplus_submit_bio(sb->s_bdev,
+	error2 = hfsplus_submit_bio(sb,
 				  sbi->part_start + sbi->sect_count - 2,
-				  sbi->s_backup_vhdr, WRITE_SYNC);
+				  sbi->s_backup_vhdr_buf, NULL, WRITE_SYNC);
 	if (!error)
 		error2 = error;
 out:
diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 4ac88ff..0f6a89d 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -31,25 +31,65 @@ static void hfsplus_end_io_sync(struct bio *bio, int err)
 	complete(bio->bi_private);
 }
 
-int hfsplus_submit_bio(struct block_device *bdev, sector_t sector,
-		void *data, int rw)
+/*
+ * hfsplus_submit_bio - Perfrom block I/O
+ * @sb: super block of volume for I/O
+ * @sector: block to read or write, for blocks of HFSPLUS_SECTOR_SIZE bytes
+ * @buf: buffer for I/O
+ * @data: output pointer for location of requested data
+ * @rw: direction of I/O
+ *
+ * The unit of I/O is hfsplus_min_io_size(sb), which may be bigger than
+ * HFSPLUS_SECTOR_SIZE, and @buf must be sized accordingly. On reads
+ * @data will return a pointer to the start of the requested sector,
+ * which may not be the same location as @buf.
+ *
+ * If @sector is not aligned to the bdev logical block size it will
+ * be rounded down. For writes this means that @buf should contain data
+ * that starts at the rounded-down address. As long as the data was
+ * read using hfsplus_submit_bio() and the same buffer is used things
+ * will work correctly.
+ */
+int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
+		void *buf, void **data, int rw)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct bio *bio;
 	int ret = 0;
+	unsigned int io_size;
+	loff_t start;
+	int offset;
+
+	/*
+	 * Align sector to hardware sector size and find offset.
+	 */
+	io_size = hfsplus_min_io_size(sb);
+	start = (loff_t)sector << HFSPLUS_SECTOR_SHIFT;
+	offset = start & (io_size - 1);
+	sector &= ~((io_size >> HFSPLUS_SECTOR_SHIFT) - 1);
 
 	bio = bio_alloc(GFP_NOIO, 1);
 	bio->bi_sector = sector;
-	bio->bi_bdev = bdev;
+	bio->bi_bdev = sb->s_bdev;
 	bio->bi_end_io = hfsplus_end_io_sync;
 	bio->bi_private = &wait;
 
-	/*
-	 * We always submit one sector at a time, so bio_add_page must not fail.
-	 */
-	if (bio_add_page(bio, virt_to_page(data), HFSPLUS_SECTOR_SIZE,
-			 offset_in_page(data)) != HFSPLUS_SECTOR_SIZE)
-		BUG();
+	if (!(rw & WRITE) && data)
+		*data = (u8 *)buf + offset;
+
+	while (io_size > 0) {
+		unsigned int page_offset = offset_in_page(buf);
+		unsigned int len = min_t(unsigned int, PAGE_SIZE - page_offset,
+					 io_size);
+
+		ret = bio_add_page(bio, virt_to_page(buf), len, page_offset);
+		if (ret != len) {
+			ret = -EIO;
+			goto out;
+		}
+		io_size -= len;
+		buf = (u8 *)buf + len;
+	}
 
 	submit_bio(rw, bio);
 	wait_for_completion(&wait);
@@ -57,8 +97,9 @@ int hfsplus_submit_bio(struct block_device *bdev, sector_t sector,
 	if (!bio_flagged(bio, BIO_UPTODATE))
 		ret = -EIO;
 
+out:
 	bio_put(bio);
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 
 static int hfsplus_read_mdb(void *bufptr, struct hfsplus_wd *wd)
@@ -147,17 +188,17 @@ int hfsplus_read_wrapper(struct super_block *sb)
 	}
 
 	error = -ENOMEM;
-	sbi->s_vhdr = kmalloc(HFSPLUS_SECTOR_SIZE, GFP_KERNEL);
-	if (!sbi->s_vhdr)
+	sbi->s_vhdr_buf = kmalloc(hfsplus_min_io_size(sb), GFP_KERNEL);
+	if (!sbi->s_vhdr_buf)
 		goto out;
-	sbi->s_backup_vhdr = kmalloc(HFSPLUS_SECTOR_SIZE, GFP_KERNEL);
-	if (!sbi->s_backup_vhdr)
+	sbi->s_backup_vhdr_buf = kmalloc(hfsplus_min_io_size(sb), GFP_KERNEL);
+	if (!sbi->s_backup_vhdr_buf)
 		goto out_free_vhdr;
 
 reread:
-	error = hfsplus_submit_bio(sb->s_bdev,
-				   part_start + HFSPLUS_VOLHEAD_SECTOR,
-				   sbi->s_vhdr, READ);
+	error = hfsplus_submit_bio(sb, part_start + HFSPLUS_VOLHEAD_SECTOR,
+				   sbi->s_vhdr_buf, (void **)&sbi->s_vhdr,
+				   READ);
 	if (error)
 		goto out_free_backup_vhdr;
 
@@ -186,9 +227,9 @@ reread:
 		goto reread;
 	}
 
-	error = hfsplus_submit_bio(sb->s_bdev,
-				   part_start + part_size - 2,
-				   sbi->s_backup_vhdr, READ);
+	error = hfsplus_submit_bio(sb, part_start + part_size - 2,
+				   sbi->s_backup_vhdr_buf,
+				   (void **)&sbi->s_backup_vhdr, READ);
 	if (error)
 		goto out_free_backup_vhdr;
 
