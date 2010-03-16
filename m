Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966254Ab0CPNiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:38:23 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:48034 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966233Ab0CPNiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:38:04 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: RFC: direct MTD support for SquashFS
Date: Tue, 16 Mar 2010 14:38:02 +0100
Message-ID: <87vdcwv139.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Hi,

In embedded systems, SquashFS over MTD would be a considerable win, as
that would permit configuring without CONFIG_BLOCK.  Please find
attached a naive patch against 2.6.33 for this.  It does not handle bad
MTD blocks, that could be handled by gluebi (once you're willing to take
the UBI overhead), or by a custom solution later.

For now, 2.6.34 gained pluggable decompressors, so this patch does not
apply anymore, though the main idea holds.  My questions: is the
community interested in integrating something like this, should this
patch transformed into something acceptable, or am I a total lunatic?
I don't know a thing about filesystem development, but willing to learn
and refactor.  Comments welcome.
-- 
Thanks,
Feri.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-squashfs-add-direct-MTD-support.patch

>From 27c686fd47a7ed4edef1ecbe9bb26402774df4a6 Mon Sep 17 00:00:00 2001
From: Ferenc Wagner <wferi@niif.hu>
Date: Tue, 16 Mar 2010 11:49:12 +0100
Subject: [PATCH] squashfs: add direct MTD support

---
 fs/squashfs/Kconfig |    2 +-
 fs/squashfs/block.c |  178 +++++++++++++++++++++++++++++++++++++++++++++++---
 fs/squashfs/super.c |   51 ++++++++++++---
 3 files changed, 210 insertions(+), 21 deletions(-)

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index 25a00d1..c23e2eb 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -1,6 +1,6 @@
 config SQUASHFS
 	tristate "SquashFS 4.0 - Squashed file system support"
-	depends on BLOCK
+	depends on MTD
 	select ZLIB_INFLATE
 	help
 	  Saying Y here includes support for SquashFS 4.0 (a Compressed
diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 2a79603..681d5d0 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -33,12 +33,15 @@
 #include <linux/string.h>
 #include <linux/buffer_head.h>
 #include <linux/zlib.h>
+#include <linux/mtd/mtd.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
 #include "squashfs.h"
 
+#ifdef CONFIG_BLOCK
+
 /*
  * Read the metadata block length, this is stored in the first two
  * bytes of the metadata block.
@@ -70,16 +73,7 @@ static struct buffer_head *get_block_length(struct super_block *sb,
 	return bh;
 }
 
-
-/*
- * Read and decompress a metadata block or datablock.  Length is non-zero
- * if a datablock is being read (the size is stored elsewhere in the
- * filesystem), otherwise the length is obtained from the first two bytes of
- * the metadata block.  A bit in the length field indicates if the block
- * is stored uncompressed in the filesystem (usually because compression
- * generated a larger block - this does occasionally happen with zlib).
- */
-int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
+static int squashfs_read_block_data(struct super_block *sb, void **buffer, u64 index,
 			int length, u64 *next_index, int srclength, int pages)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
@@ -263,8 +257,170 @@ block_release:
 		put_bh(bh[k]);
 
 read_failure:
-	ERROR("squashfs_read_data failed to read block 0x%llx\n",
+	ERROR("squashfs_read_block_data failed to read block 0x%llx\n",
 					(unsigned long long) index);
 	kfree(bh);
 	return -EIO;
 }
+
+#endif
+
+static int checked_mtd_read(struct mtd_info *mtd, u64 index, int length,
+				u_char *buf)
+{
+	int ret, retlen;
+
+	ret = mtd->read(mtd, index, length, &retlen, buf);
+	TRACE("checked_mtd_read(index=0x%llx, length=%d): %d\n",
+		index, length, ret);
+	if (ret && ret != -EUCLEAN && ret != -EBADMSG)
+		return ret;
+	if (retlen != length)
+		return -EIO;
+	return 0;
+}
+
+static int fill_in(struct mtd_info *mtd, z_stream *z, u_char *buf, u64 index,
+		int *bytes_read, int length)
+{
+	z->next_in = buf;
+	z->avail_in = min(length - (*bytes_read), (int) PAGE_CACHE_SIZE);
+	if (checked_mtd_read(mtd, index + *bytes_read, z->avail_in, buf))
+		return -1;
+	*bytes_read += z->avail_in;
+	TRACE("fill: avail_in=%d (%x..%x)\n", z->avail_in,
+		buf[0], buf[z->avail_in-1]);
+	return 0;
+}
+
+static int squashfs_read_mtd_data(struct super_block *sb, void **buffer,
+	u64 index, int length, u64 *next_index, int srclength, int pages)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	struct mtd_info *mtd = sb->s_mtd;
+	static u_char buf[PAGE_CACHE_SIZE]; /* mostly for decompression */
+	int compressed, bytes_read = 0, page = 0;
+
+	if (length) { /* datablock */
+		compressed = SQUASHFS_COMPRESSED_BLOCK(length);
+		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
+		TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
+			index, compressed ? "" : "un", length, srclength);
+	} else { /* metadata block */
+		if ((index + 2) > msblk->bytes_used)
+			goto read_failure;
+		if (checked_mtd_read(mtd, index, 2, buf))
+			goto read_failure;
+		length = buf[0] + 256 * buf[1];
+		compressed = SQUASHFS_COMPRESSED(length);
+		length = SQUASHFS_COMPRESSED_SIZE(length);
+		TRACE("Block @ 0x%llx, %scompressed size %d\n", index,
+				compressed ? "" : "un", length);
+		index += 2;
+	}
+	if (next_index)
+		*next_index = index + length;
+	if (length < 0 || length > srclength ||
+			(index + length) > msblk->bytes_used)
+		goto read_failure;
+	if (compressed) {
+		int zlib_err = 0;
+		z_stream *z = &msblk->stream;
+
+		mutex_lock(&msblk->read_data_mutex);
+
+		if (fill_in(mtd, z, buf, index, &bytes_read, length))
+			goto release_mutex;
+		z->next_out = buffer[page++];
+		z->avail_out = PAGE_CACHE_SIZE;
+
+		zlib_err = zlib_inflateInit(z);
+		if (zlib_err != Z_OK) {
+			ERROR("zlib_inflateInit returned unexpected result"
+				" 0x%x, srclength %d\n", zlib_err, srclength);
+			goto release_mutex;
+		}
+
+		while (1) {
+			zlib_err = zlib_inflate(z, Z_SYNC_FLUSH);
+			if (zlib_err != Z_OK)
+				break;
+			if (z->avail_out == 0) {
+				if (page < pages) {
+					z->next_out = buffer[page++];
+					z->avail_out = PAGE_CACHE_SIZE;
+					continue;
+				} else {
+					ERROR("zlib_inflate run out of space\n");
+					goto release_mutex;
+				}
+			}
+			if (z->avail_in == 0) {
+				if (bytes_read < length) {
+					if (fill_in(mtd, z, buf, index,
+							&bytes_read, length))
+						goto release_mutex;
+					continue;
+				} else {
+					ERROR("zlib_inflate run out of input\n");
+					goto release_mutex;
+				}
+			}
+			ERROR("should not be here\n");
+			break;
+		}
+
+		if (zlib_err != Z_STREAM_END) {
+			ERROR("zlib_inflate error %d, data probably corrupt\n",
+				zlib_err);
+			goto release_mutex;
+		}
+
+		zlib_err = zlib_inflateEnd(z);
+		if (zlib_err != Z_OK) {
+			ERROR("zlib_inflateEnd error %d, data probably corrupt\n",
+				zlib_err);
+			goto release_mutex;
+		}
+		length = z->total_out;
+		mutex_unlock(&msblk->read_data_mutex);
+	} else { /* not compressed */
+		while (bytes_read < length) {
+			int blk = min(length - bytes_read, (int) PAGE_CACHE_SIZE);
+			if (checked_mtd_read(mtd, index + bytes_read, blk,
+						buffer[page++]))
+				goto read_failure;
+			bytes_read += blk;
+		}
+	}
+
+	return length;
+
+release_mutex:
+	mutex_unlock(&msblk->read_data_mutex);
+
+read_failure:
+	ERROR("squashfs_read_mtd_data failed to read block 0x%llx\n",
+					(unsigned long long) index);
+	return -EIO;
+}
+
+/*
+ * Read and decompress a metadata block or datablock.  Length is non-zero
+ * if a datablock is being read (the size is stored elsewhere in the
+ * filesystem), otherwise the length is obtained from the first two bytes of
+ * the metadata block.  A bit in the length field indicates if the block
+ * is stored uncompressed in the filesystem (usually because compression
+ * generated a larger block - this does occasionally happen with zlib).
+ */
+int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
+			int length, u64 *next_index, int srclength, int pages)
+{
+#ifdef CONFIG_BLOCK
+	if (sb->s_bdev)
+		return squashfs_read_block_data(sb, buffer, index,
+				length, next_index, srclength, pages);
+#endif
+	return squashfs_read_mtd_data(sb, buffer, index,
+				length, next_index, srclength, pages);
+}
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 6c197ef..558a2fa 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -37,6 +37,7 @@
 #include <linux/module.h>
 #include <linux/zlib.h>
 #include <linux/magic.h>
+#include <linux/mtd/super.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
@@ -65,6 +66,15 @@ static int supported_squashfs_filesystem(short major, short minor, short comp)
 	return 0;
 }
 
+static const char *devname(struct super_block *sb, char *buffer)
+{
+#ifdef CONFIG_BLOCK
+	if (sb->s_bdev)
+		return bdevname(sb->s_bdev, buffer);
+#endif
+	snprintf(buffer, BDEVNAME_SIZE, "MTD%d", sb->s_mtd->index);
+	return buffer;
+}
 
 static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 {
@@ -100,8 +110,12 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto failure;
 	}
 
-	msblk->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
-	msblk->devblksize_log2 = ffz(~msblk->devblksize);
+#ifdef CONFIG_BLOCK
+	if (sb->s_bdev) {
+		msblk->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
+		msblk->devblksize_log2 = ffz(~msblk->devblksize);
+	}
+#endif
 
 	mutex_init(&msblk->read_data_mutex);
 	mutex_init(&msblk->meta_index_mutex);
@@ -125,7 +139,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (sb->s_magic != SQUASHFS_MAGIC) {
 		if (!silent)
 			ERROR("Can't find a SQUASHFS superblock on %s\n",
-						bdevname(sb->s_bdev, b));
+				devname(sb, b));
 		err = -EINVAL;
 		goto failed_mount;
 	}
@@ -147,10 +161,11 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 		ERROR("Xattrs in filesystem, these will be ignored\n");
 
 	/* Check the filesystem does not extend beyond the end of the
-	   block device */
+	   device */
 	msblk->bytes_used = le64_to_cpu(sblk->bytes_used);
 	if (msblk->bytes_used < 0 || msblk->bytes_used >
-			i_size_read(sb->s_bdev->bd_inode))
+			(sb->s_bdev ? i_size_read(sb->s_bdev->bd_inode)
+				: sb->s_mtd->size))
 		goto failed_mount;
 
 	/* Check block size for sanity */
@@ -182,7 +197,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	msblk->inodes = le32_to_cpu(sblk->inodes);
 	flags = le16_to_cpu(sblk->flags);
 
-	TRACE("Found valid superblock on %s\n", bdevname(sb->s_bdev, b));
+	TRACE("Found valid superblock on %s\n", devname(sb, b));
 	TRACE("Inodes are %scompressed\n", SQUASHFS_UNCOMPRESSED_INODES(flags)
 				? "un" : "");
 	TRACE("Data is %scompressed\n", SQUASHFS_UNCOMPRESSED_DATA(flags)
@@ -362,10 +377,28 @@ static int squashfs_get_sb(struct file_system_type *fs_type, int flags,
 				const char *dev_name, void *data,
 				struct vfsmount *mnt)
 {
-	return get_sb_bdev(fs_type, flags, dev_name, data, squashfs_fill_super,
-				mnt);
+	int ret;
+
+#ifdef CONFIG_BLOCK
+	ret = get_sb_bdev(fs_type, flags, dev_name, data, squashfs_fill_super, mnt);
+	ERROR("get_sb_bdev returned %x = %d\n", ret, ret);
+	if (!ret)
+		return 0;
+#endif
+	ret = get_sb_mtd(fs_type, flags, dev_name, data, squashfs_fill_super, mnt);
+	ERROR("get_sb_mtd returned %x = %d\n", ret, ret);
+	return ret;
 }
 
+static void kill_squash_super(struct super_block *sb)
+{
+#ifdef CONFIG_BLOCK
+	if (sb->s_bdev)
+		kill_block_super(sb);
+	else
+#endif
+		kill_mtd_super(sb);
+}
 
 static struct kmem_cache *squashfs_inode_cachep;
 
@@ -440,7 +473,7 @@ static struct file_system_type squashfs_fs_type = {
 	.owner = THIS_MODULE,
 	.name = "squashfs",
 	.get_sb = squashfs_get_sb,
-	.kill_sb = kill_block_super,
+	.kill_sb = kill_squash_super,
 	.fs_flags = FS_REQUIRES_DEV
 };
 
-- 
1.5.6.5


--=-=-=--
