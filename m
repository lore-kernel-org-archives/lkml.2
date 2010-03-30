Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab0C3OVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 10:21:36 -0400
Received: from rs22.lvs.iif.hu ([193.225.14.172]:44929 "EHLO rs22.lvs.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631Ab0C3OVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:21:00 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Phillip Lougher <phillip.lougher@gmail.com>,
       linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Cc: Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH 2/3] squashfs: gather everything block device specific into block.c
Date: Tue, 30 Mar 2010 15:32:48 +0200
Message-Id: <1269955969-26123-3-git-send-email-wferi@niif.hu>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <87mxxxltk6.fsf@tac.ki.iif.hu>
References: <87mxxxltk6.fsf@tac.ki.iif.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use buffer_head structures for communicating with the decompressors,
so provide a basic definition even if CONFIG_BLOCK=n (which results in
a backendless - ie. useless - squashfs right now).
---
 fs/squashfs/Kconfig    |    1 -
 fs/squashfs/Makefile   |    5 +++--
 fs/squashfs/backend.c  |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/backend.h  |   12 ++++++++++++
 fs/squashfs/block.c    |   33 +++++++++++++++++++++------------
 fs/squashfs/squashfs.h |   18 +++++++++++++++++-
 fs/squashfs/super.c    |   45 ++++++++++-----------------------------------
 7 files changed, 111 insertions(+), 51 deletions(-)
 create mode 100644 fs/squashfs/backend.c
 create mode 100644 fs/squashfs/backend.h

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index 7ec5d7e..40a3f15 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -1,6 +1,5 @@
 config SQUASHFS
 	tristate "SquashFS 4.0 - Squashed file system support"
-	depends on BLOCK
 	select ZLIB_INFLATE
 	help
 	  Saying Y here includes support for SquashFS 4.0 (a Compressed
diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
index 45aaefd..80f1cbe 100644
--- a/fs/squashfs/Makefile
+++ b/fs/squashfs/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_SQUASHFS) += squashfs.o
-squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
-squashfs-y += namei.o super.o symlink.o zlib_wrapper.o decompressor.o
+squashfs-y += cache.o dir.o export.o file.o fragment.o id.o inode.o
+squashfs-y += namei.o super.o symlink.o zlib_wrapper.o decompressor.o backend.o
 squashfs-$(CONFIG_SQUASHFS_LZMA) += lzma_wrapper.o
+squashfs-$(CONFIG_BLOCK) += block.o
diff --git a/fs/squashfs/backend.c b/fs/squashfs/backend.c
new file mode 100644
index 0000000..b83a5e2
--- /dev/null
+++ b/fs/squashfs/backend.c
@@ -0,0 +1,48 @@
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/buffer_head.h>
+
+#include "squashfs_fs_i.h"
+#include "squashfs.h"
+#include "backend.h"
+
+int squashfs_find_backend(struct file_system_type *fs_type, int flags,
+			  const char *dev_name, void *data, struct vfsmount *mnt)
+{
+#ifdef CONFIG_BLOCK
+	if (!get_sb_bdev(fs_type, flags, dev_name, data, fill_bdev_super, mnt))
+		return 0;
+#endif
+	WARNING("no suitable backend found\n");
+	return -EINVAL;
+}
+
+void squashfs_kill_super(struct super_block *sb)
+{
+#ifdef CONFIG_BLOCK
+	if (sb->s_bdev) {
+		kill_block_super(sb);
+		return;
+	}
+#endif
+	ERROR("squashfs_kill_super: no device behind the super block\n");
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
+		       int length, u64 *next_index, int srclength, int pages)
+{
+#ifdef CONFIG_BLOCK
+	if (sb->s_bdev)
+		return bdev_read_data(sb, buffer, index, length, next_index, srclength, pages);
+#endif
+	ERROR("squashfs_read_data: no device behind the super block\n");
+	return -EIO;
+}
diff --git a/fs/squashfs/backend.h b/fs/squashfs/backend.h
new file mode 100644
index 0000000..54c973e
--- /dev/null
+++ b/fs/squashfs/backend.h
@@ -0,0 +1,12 @@
+#ifndef BACKEND_H
+#define BACKEND_H
+
+#include <linux/fs.h>
+#include <linux/vfs.h>
+
+int squashfs_find_backend(struct file_system_type *, int, const char *,
+			  void *, struct vfsmount *);
+void squashfs_kill_super(struct super_block *);
+int squashfs_read_data(struct super_block *, void **, u64, int, u64 *, int, int);
+
+#endif
diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index c7e5881..f16bf27 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -23,7 +23,7 @@
 
 /*
  * This file implements the low-level routines to read and decompress
- * datablocks and metadata blocks.
+ * datablocks and metadata blocks from a block device.
  */
 
 #include <linux/fs.h>
@@ -75,16 +75,7 @@ static struct buffer_head *get_block_length(struct super_block *sb,
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
+int bdev_read_data(struct super_block *sb, void **buffer, u64 index,
 			int length, u64 *next_index, int srclength, int pages)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
@@ -203,8 +194,26 @@ block_release:
 		put_bh(bh[k]);
 
 read_failure:
-	ERROR("squashfs_read_data failed to read block 0x%llx\n",
+	ERROR("bdev_read_data failed to read block 0x%llx\n",
 					(unsigned long long) index);
 	kfree(bh);
 	return -EIO;
 }
+
+int fill_bdev_super(struct super_block *sb, void *data, int silent)
+{
+	struct squashfs_sb_info *msblk;
+	char b[BDEVNAME_SIZE];
+
+	TRACE("Entering fill_bdev_super\n");
+
+	msblk = kzalloc(sizeof(*msblk), GFP_KERNEL);
+	if (!msblk)
+		return -ENOMEM;
+
+	sb->s_fs_info = msblk;
+	msblk->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
+	msblk->devblksize_log2 = ffz(~msblk->devblksize);
+	return squashfs_fill_super(sb, data, silent, bdevname(sb->s_bdev, b),
+				   i_size_read(sb->s_bdev->bd_inode));
+}
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index d094886..7c5cd72 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -32,7 +32,7 @@ static inline struct squashfs_inode_info *squashfs_i(struct inode *inode)
 	return list_entry(inode, struct squashfs_inode_info, vfs_inode);
 }
 
-/* block.c */
+/* backend.c */
 extern int squashfs_read_data(struct super_block *, void **, u64, int, u64 *,
 				int, int);
 
@@ -73,6 +73,9 @@ extern struct inode *squashfs_iget(struct super_block *, long long,
 				unsigned int);
 extern int squashfs_read_inode(struct inode *, long long);
 
+/* super.c */
+extern int squashfs_fill_super(struct super_block *, void *, int, const char *, int);
+
 /*
  * Inodes, files and decompressor operations
  */
@@ -97,3 +100,16 @@ extern const struct squashfs_decompressor squashfs_zlib_comp_ops;
 
 /* lzma wrapper.c */
 extern const struct squashfs_decompressor squashfs_lzma_comp_ops;
+
+/* block.c */
+extern int fill_bdev_super(struct super_block *, void *, int);
+extern int bdev_read_data(struct super_block *, void **, u64, int, u64 *, int, int);
+
+#ifndef CONFIG_BLOCK
+struct buffer_head {
+	sector_t b_blocknr;
+	size_t b_size;
+	char *b_data;
+	void *b_bdev;
+};
+#endif
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 3550aec..7c896ca 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -42,6 +42,7 @@
 #include "squashfs_fs_i.h"
 #include "squashfs.h"
 #include "decompressor.h"
+#include "backend.h"
 
 static struct file_system_type squashfs_fs_type;
 static const struct super_operations squashfs_super_ops;
@@ -73,11 +74,11 @@ static const struct squashfs_decompressor *supported_squashfs_filesystem(short
 }
 
 
-static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
+int squashfs_fill_super(struct super_block *sb, void *data, int silent,
+			const char *name, int size)
 {
-	struct squashfs_sb_info *msblk;
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	struct squashfs_super_block *sblk = NULL;
-	char b[BDEVNAME_SIZE];
 	struct inode *root;
 	long long root_inode;
 	unsigned short flags;
@@ -87,22 +88,12 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	TRACE("Entered squashfs_fill_superblock\n");
 
-	sb->s_fs_info = kzalloc(sizeof(*msblk), GFP_KERNEL);
-	if (sb->s_fs_info == NULL) {
-		ERROR("Failed to allocate squashfs_sb_info\n");
-		return -ENOMEM;
-	}
-	msblk = sb->s_fs_info;
-
 	sblk = kzalloc(sizeof(*sblk), GFP_KERNEL);
 	if (sblk == NULL) {
 		ERROR("Failed to allocate squashfs_super_block\n");
-		goto failure;
+		return -ENOMEM;
 	}
 
-	msblk->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
-	msblk->devblksize_log2 = ffz(~msblk->devblksize);
-
 	mutex_init(&msblk->read_data_mutex);
 	mutex_init(&msblk->meta_index_mutex);
 
@@ -126,8 +117,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_magic = le32_to_cpu(sblk->s_magic);
 	if (sb->s_magic != SQUASHFS_MAGIC) {
 		if (!silent)
-			ERROR("Can't find a SQUASHFS superblock on %s\n",
-						bdevname(sb->s_bdev, b));
+			ERROR("Can't find a SQUASHFS superblock on %s\n", name);
 		goto failed_mount;
 	}
 
@@ -149,8 +139,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	/* Check the filesystem does not extend beyond the end of the
 	   block device */
 	msblk->bytes_used = le64_to_cpu(sblk->bytes_used);
-	if (msblk->bytes_used < 0 || msblk->bytes_used >
-			i_size_read(sb->s_bdev->bd_inode))
+	if (msblk->bytes_used < 0 || msblk->bytes_used > size)
 		goto failed_mount;
 
 	/* Check block size for sanity */
@@ -182,7 +171,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	msblk->inodes = le32_to_cpu(sblk->inodes);
 	flags = le16_to_cpu(sblk->flags);
 
-	TRACE("Found valid superblock on %s\n", bdevname(sb->s_bdev, b));
+	TRACE("Found valid superblock on %s\n", name);
 	TRACE("Inodes are %scompressed\n", SQUASHFS_UNCOMPRESSED_INODES(flags)
 				? "un" : "");
 	TRACE("Data is %scompressed\n", SQUASHFS_UNCOMPRESSED_DATA(flags)
@@ -304,11 +293,6 @@ failed_mount:
 	sb->s_fs_info = NULL;
 	kfree(sblk);
 	return err;
-
-failure:
-	kfree(sb->s_fs_info);
-	sb->s_fs_info = NULL;
-	return -ENOMEM;
 }
 
 
@@ -361,15 +345,6 @@ static void squashfs_put_super(struct super_block *sb)
 }
 
 
-static int squashfs_get_sb(struct file_system_type *fs_type, int flags,
-				const char *dev_name, void *data,
-				struct vfsmount *mnt)
-{
-	return get_sb_bdev(fs_type, flags, dev_name, data, squashfs_fill_super,
-				mnt);
-}
-
-
 static struct kmem_cache *squashfs_inode_cachep;
 
 
@@ -442,8 +417,8 @@ static void squashfs_destroy_inode(struct inode *inode)
 static struct file_system_type squashfs_fs_type = {
 	.owner = THIS_MODULE,
 	.name = "squashfs",
-	.get_sb = squashfs_get_sb,
-	.kill_sb = kill_block_super,
+	.get_sb = squashfs_find_backend,
+	.kill_sb = squashfs_kill_super,
 	.fs_flags = FS_REQUIRES_DEV
 };
 
-- 
1.6.5

