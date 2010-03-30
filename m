Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab0C3OEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 10:04:46 -0400
Received: from rs22.lvs.iif.hu ([193.225.14.172]:41541 "EHLO rs22.lvs.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab0C3OEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:04:44 -0400
X-Greylist: delayed 1857 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Mar 2010 10:04:44 EDT
From: Ferenc Wagner <wferi@niif.hu>
To: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Phillip Lougher <phillip.lougher@gmail.com>,
       linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Cc: Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH 3/3] squashfs: add MTD backend
Date: Tue, 30 Mar 2010 15:32:49 +0200
Message-Id: <1269955969-26123-4-git-send-email-wferi@niif.hu>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <87mxxxltk6.fsf@tac.ki.iif.hu>
References: <87mxxxltk6.fsf@tac.ki.iif.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/squashfs/Kconfig    |    1 +
 fs/squashfs/Makefile   |    1 +
 fs/squashfs/backend.c  |   15 ++++
 fs/squashfs/mtd.c      |  179 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/squashfs.h |    4 +
 5 files changed, 200 insertions(+), 0 deletions(-)
 create mode 100644 fs/squashfs/mtd.c

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index 40a3f15..6849e70 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -1,5 +1,6 @@
 config SQUASHFS
 	tristate "SquashFS 4.0 - Squashed file system support"
+	depends on BLOCK || MTD
 	select ZLIB_INFLATE
 	help
 	  Saying Y here includes support for SquashFS 4.0 (a Compressed
diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
index 80f1cbe..8d5c0b8 100644
--- a/fs/squashfs/Makefile
+++ b/fs/squashfs/Makefile
@@ -7,3 +7,4 @@ squashfs-y += cache.o dir.o export.o file.o fragment.o id.o inode.o
 squashfs-y += namei.o super.o symlink.o zlib_wrapper.o decompressor.o backend.o
 squashfs-$(CONFIG_SQUASHFS_LZMA) += lzma_wrapper.o
 squashfs-$(CONFIG_BLOCK) += block.o
+squashfs-$(CONFIG_MTD) += mtd.o
diff --git a/fs/squashfs/backend.c b/fs/squashfs/backend.c
index b83a5e2..a6136ca 100644
--- a/fs/squashfs/backend.c
+++ b/fs/squashfs/backend.c
@@ -1,6 +1,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
+#include <linux/mtd/super.h>
 
 #include "squashfs_fs_i.h"
 #include "squashfs.h"
@@ -13,6 +14,10 @@ int squashfs_find_backend(struct file_system_type *fs_type, int flags,
 	if (!get_sb_bdev(fs_type, flags, dev_name, data, fill_bdev_super, mnt))
 		return 0;
 #endif
+#ifdef CONFIG_MTD
+	if (!get_sb_mtd(fs_type, flags, dev_name, data, fill_mtd_super, mnt))
+		return 0;
+#endif
 	WARNING("no suitable backend found\n");
 	return -EINVAL;
 }
@@ -25,6 +30,12 @@ void squashfs_kill_super(struct super_block *sb)
 		return;
 	}
 #endif
+#ifdef CONFIG_MTD
+	if (sb->s_mtd) {
+		kill_mtd_super(sb);
+		return;
+	}
+#endif
 	ERROR("squashfs_kill_super: no device behind the super block\n");
 }
 
@@ -43,6 +54,10 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 	if (sb->s_bdev)
 		return bdev_read_data(sb, buffer, index, length, next_index, srclength, pages);
 #endif
+#ifdef CONFIG_MTD
+	if (sb->s_mtd)
+		return mtd_read_data(sb, buffer, index, length, next_index, srclength, pages);
+#endif
 	ERROR("squashfs_read_data: no device behind the super block\n");
 	return -EIO;
 }
diff --git a/fs/squashfs/mtd.c b/fs/squashfs/mtd.c
new file mode 100644
index 0000000..b067616
--- /dev/null
+++ b/fs/squashfs/mtd.c
@@ -0,0 +1,179 @@
+/*
+ * mtd.c
+ */
+
+/*
+ * This file implements the low-level routines to read and decompress
+ * datablocks and metadata blocks from an MTD.
+ */
+
+#include <linux/fs.h>
+#include <linux/vfs.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/buffer_head.h>
+#include <linux/mtd/mtd.h>
+
+#include "squashfs_fs.h"
+#include "squashfs_fs_sb.h"
+#include "squashfs_fs_i.h"
+#include "squashfs.h"
+#include "decompressor.h"
+
+static int checked_mtd_read(struct mtd_info *mi, u64 index, int length,
+			    void *buf)
+{
+	int ret, retlen;
+
+	TRACE("Entering checked_mtd_read: index=0x%llx, length=%d\n",
+	      index, length);
+	ret = mi->read(mi, index, length, &retlen, buf);
+	if (ret) {
+		if (ret == -EUCLEAN || ret == -EBADMSG)
+			WARNING("checked_mtd_read(index=0x%llx, length=%d): "
+				"recoverable error %d\n", index, length, ret);
+		else {
+			ERROR("checked_mtd_read(index=0x%llx, length=%d): %d\n",
+			      index, length, ret);
+			return ret;
+		}
+	}
+	if (retlen != length) {
+		ERROR("checked_mtd_read(index=0x%llx, length=%d) short read: %d\n",
+		      index, length, retlen);
+		return -EIO;
+	}
+	return 0;
+}
+
+static int update_buffer(struct buffer_head *bh)
+{
+	struct mtd_info *mi = (struct mtd_info *)bh->b_bdev;
+	int ret = checked_mtd_read(mi, bh->b_blocknr, bh->b_size, bh->b_data);
+	if (ret)
+		return 0;
+	return 1;
+}
+
+static void put_buffer(struct buffer_head *bh)
+{
+}
+
+/*
+ * Big buffer_heads require more memory, but if a single one is enough,
+ * that can be special-cased in unlzma to avoid the extra memcpy.
+ * A better unlzma interface would be preferable, though.
+ */
+int mtd_read_data(struct super_block *sb, void **buffer, u64 index,
+		  int length, u64 *next_index, int srclength, int pages)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	struct mtd_info *mi = sb->s_mtd;
+	u64 i = index;
+	int bytes_left, compressed;
+
+	if (length) { /* Data block */
+		compressed = SQUASHFS_COMPRESSED_BLOCK(length);
+		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
+
+		TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
+			index, compressed ? "" : "un", length, srclength);
+	} else { /* Metadata block */
+		u16 metalen;
+		if ((index + 2) > msblk->bytes_used)
+			goto read_failure;
+		if (checked_mtd_read(mi, index, 2, &metalen))
+			goto read_failure;
+		i += 2;
+		length = le16_to_cpu(metalen);
+		compressed = SQUASHFS_COMPRESSED(length);
+		length = SQUASHFS_COMPRESSED_SIZE(length);
+
+		TRACE("Block @ 0x%llx, %scompressed size %d\n", index,
+				compressed ? "" : "un", length);
+	}
+	if (next_index)
+		*next_index = i + length;
+
+	if (length < 0 || length > srclength || i + length > msblk->bytes_used)
+		goto read_failure;
+
+	if (compressed) {
+		struct buffer_head **bh, *bhs;
+		int bh_num = (max_t(int, msblk->block_size, SQUASHFS_METADATA_SIZE) >>
+				msblk->devblksize_log2) + 1;
+		u_char *data;
+		int b;
+
+		bh = kmalloc(bh_num * sizeof(*bh), GFP_KERNEL);
+		if (bh == NULL)
+			return -ENOMEM;
+		bhs = kmalloc(bh_num * sizeof(*bhs), GFP_KERNEL);
+		if (bhs == NULL) {
+			kfree(bh);
+			return -ENOMEM;
+		}
+		data = kmalloc(msblk->devblksize, GFP_KERNEL);
+		if (data == NULL) {
+			kfree(bhs);
+			kfree(bh);
+			return -ENOMEM;
+		}
+
+		bytes_left = length;
+		for (b = 0; bytes_left > 0; b++) {
+			bh[b] = &bhs[b];
+			bhs[b].b_blocknr = i;
+			bhs[b].b_size = min(msblk->devblksize, bytes_left);
+			/* We know that the decompressors will use each buffer_head
+			 * only once, so update_buffer may change the data under them. */
+			bhs[b].b_data = data;
+			bhs[b].b_bdev = (void *)mi;
+			i += msblk->devblksize;
+			bytes_left -= msblk->devblksize;
+		}
+
+		length = squashfs_decompress(msblk, buffer, bh, b, 0,
+			length, srclength, pages, update_buffer, put_buffer);
+		if (length < 0) {
+			kfree(data);
+			kfree(bhs);
+			kfree(bh);
+			goto read_failure;
+		}
+	} else { /* Not compressed */
+		int page = 0;
+		bytes_left = length;
+		while (bytes_left > 0) {
+			int blk = min_t(int, bytes_left, PAGE_CACHE_SIZE);
+			if (checked_mtd_read(mi, i, blk, buffer[page++]))
+				goto read_failure;
+			bytes_left -= blk;
+			i += blk;
+		}
+	}
+	return length;
+
+read_failure:
+	ERROR("mtd_read_data failed to read block 0x%llx\n",
+	      (unsigned long long) index);
+	return -EIO;
+}
+
+int fill_mtd_super(struct super_block *sb, void *data, int silent)
+{
+	struct squashfs_sb_info *msblk;
+	char b[BDEVNAME_SIZE];
+
+	TRACE("Entering fill_mtd_super\n");
+
+	msblk = kzalloc(sizeof(*msblk), GFP_KERNEL);
+	if (!msblk)
+		return -ENOMEM;
+
+	sb->s_fs_info = msblk;
+	msblk->devblksize = PAGE_CACHE_SIZE;
+	msblk->devblksize_log2 = PAGE_CACHE_SHIFT;
+	snprintf(b, sizeof b, "mtd%d", sb->s_mtd->index);
+	return squashfs_fill_super(sb, data, silent, b, sb->s_mtd->size);
+}
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index 7c5cd72..05a85e2 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -105,6 +105,10 @@ extern const struct squashfs_decompressor squashfs_lzma_comp_ops;
 extern int fill_bdev_super(struct super_block *, void *, int);
 extern int bdev_read_data(struct super_block *, void **, u64, int, u64 *, int, int);
 
+/* mtd.c */
+extern int fill_mtd_super(struct super_block *, void *, int);
+extern int mtd_read_data(struct super_block *, void **, u64, int, u64 *, int, int);
+
 #ifndef CONFIG_BLOCK
 struct buffer_head {
 	sector_t b_blocknr;
-- 
1.6.5

