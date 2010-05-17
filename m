Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0EQT3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:29:40 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:51382 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782Ab0EQT3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:29:39 -0400
Message-ID: <4BF19895.7020708@lougher.demon.co.uk>
Date: Mon, 17 May 2010 20:27:17 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] squashfs: add xattr id support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds support for mapping xattr ids (stored in inodes)
into the on-disk location of the xattrs themselves.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/Makefile         |    2 +
  fs/squashfs/squashfs.h       |    6 +++
  fs/squashfs/squashfs_fs.h    |   32 +++++++++++++-
  fs/squashfs/squashfs_fs_sb.h |    3 +
  fs/squashfs/super.c          |   22 ++++++++-
  fs/squashfs/xattr_id.c       |  100 ++++++++++++++++++++++++++++++++++++++++++
  6 files changed, 161 insertions(+), 4 deletions(-)
  create mode 100644 fs/squashfs/xattr_id.c

diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
index df8a19e..c0da4a1 100644
--- a/fs/squashfs/Makefile
+++ b/fs/squashfs/Makefile
@@ -5,3 +5,5 @@
  obj-$(CONFIG_SQUASHFS) += squashfs.o
  squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
  squashfs-y += namei.o super.o symlink.o zlib_wrapper.o decompressor.o
+squashfs-y += xattr_id.o
+
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index fe2587a..133befe 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -73,6 +73,12 @@ extern struct inode *squashfs_iget(struct super_block *, long long,
  				unsigned int);
  extern int squashfs_read_inode(struct inode *, long long);

+/* xattr_id.c */
+extern int squashfs_xattr_lookup(struct super_block *, unsigned int, int *,
+				int *, long long *);
+extern __le64 *squashfs_read_xattr_id_table(struct super_block *, u64,
+				u64 *, int *);
+
  /*
   * Inodes, files and decompressor operations
   */
diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index 7902424..c654e86 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -174,6 +174,24 @@

  #define SQUASHFS_ID_BLOCK_BYTES(A)	(SQUASHFS_ID_BLOCKS(A) *\
  					sizeof(u64))
+/* xattr id lookup table defines */
+#define SQUASHFS_XATTR_BYTES(A)		((A) * sizeof(struct squashfs_xattr_id))
+
+#define SQUASHFS_XATTR_BLOCK(A)		(SQUASHFS_XATTR_BYTES(A) / \
+					SQUASHFS_METADATA_SIZE)
+
+#define SQUASHFS_XATTR_BLOCK_OFFSET(A)	(SQUASHFS_XATTR_BYTES(A) % \
+					SQUASHFS_METADATA_SIZE)
+
+#define SQUASHFS_XATTR_BLOCKS(A)	((SQUASHFS_XATTR_BYTES(A) + \
+					SQUASHFS_METADATA_SIZE - 1) / \
+					SQUASHFS_METADATA_SIZE)
+
+#define SQUASHFS_XATTR_BLOCK_BYTES(A)	(SQUASHFS_XATTR_BLOCKS(A) *\
+					sizeof(u64))
+#define SQUASHFS_XATTR_BLK(A)		((unsigned int) ((A) >> 16))
+
+#define SQUASHFS_XATTR_OFFSET(A)	((unsigned int) ((A) & 0xffff))

  /* cached data constants for filesystem */
  #define SQUASHFS_CACHED_BLKS		8
@@ -228,7 +246,7 @@ struct squashfs_super_block {
  	__le64			root_inode;
  	__le64			bytes_used;
  	__le64			id_table_start;
-	__le64			xattr_table_start;
+	__le64			xattr_id_table_start;
  	__le64			inode_table_start;
  	__le64			directory_table_start;
  	__le64			fragment_table_start;
@@ -377,4 +395,16 @@ struct squashfs_fragment_entry {
  	unsigned int		unused;
  };

+struct squashfs_xattr_id {
+	__le64			xattr;
+	__le32			count;
+	__le32			size;
+};
+
+struct squashfs_xattr_id_table {
+	__le64			xattr_table_start;
+	__le32			xattr_ids;
+	__le32			unused;
+};
+
  #endif
diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
index 2e77dc5..d9037a5 100644
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -61,6 +61,7 @@ struct squashfs_sb_info {
  	int					next_meta_index;
  	__le64					*id_table;
  	__le64					*fragment_index;
+	__le64					*xattr_id_table;
  	struct mutex				read_data_mutex;
  	struct mutex				meta_index_mutex;
  	struct meta_index			*meta_index;
@@ -68,9 +69,11 @@ struct squashfs_sb_info {
  	__le64					*inode_lookup_table;
  	u64					inode_table;
  	u64					directory_table;
+	u64					xattr_table;
  	unsigned int				block_size;
  	unsigned short				block_log;
  	long long				bytes_used;
  	unsigned int				inodes;
+	int					xattr_ids;
  };
  #endif
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 48b6f4a..c4dfc39 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -36,6 +36,7 @@
  #include <linux/init.h>
  #include <linux/module.h>
  #include <linux/magic.h>
+#include <linux/xattr.h>

  #include "squashfs_fs.h"
  #include "squashfs_fs_sb.h"
@@ -82,7 +83,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
  	long long root_inode;
  	unsigned short flags;
  	unsigned int fragments;
-	u64 lookup_table_start;
+	u64 lookup_table_start, xattr_id_table_start;
  	int err;

  	TRACE("Entered squashfs_fill_superblock\n");
@@ -143,7 +144,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
  	 * Check if there's xattrs in the filesystem.  These are not
  	 * supported in this version, so warn that they will be ignored.
  	 */
-	if (le64_to_cpu(sblk->xattr_table_start) != SQUASHFS_INVALID_BLK)
+	if (le64_to_cpu(sblk->xattr_id_table_start) != SQUASHFS_INVALID_BLK)
  		ERROR("Xattrs in filesystem, these will be ignored\n");

  	/* Check the filesystem does not extend beyond the end of the
@@ -253,7 +254,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
  allocate_lookup_table:
  	lookup_table_start = le64_to_cpu(sblk->lookup_table_start);
  	if (lookup_table_start == SQUASHFS_INVALID_BLK)
-		goto allocate_root;
+		goto allocate_xattr_table;

  	/* Allocate and read inode lookup table */
  	msblk->inode_lookup_table = squashfs_read_inode_lookup_table(sb,
@@ -266,6 +267,19 @@ allocate_lookup_table:

  	sb->s_export_op = &squashfs_export_ops;

+allocate_xattr_table:
+	xattr_id_table_start = le64_to_cpu(sblk->xattr_id_table_start);
+	if (xattr_id_table_start == SQUASHFS_INVALID_BLK)
+		goto allocate_root;
+
+	/* Allocate and read xattr id lookup table */
+	msblk->xattr_id_table = squashfs_read_xattr_id_table(sb,
+		xattr_id_table_start, &msblk->xattr_table, &msblk->xattr_ids);
+	if (IS_ERR(msblk->xattr_id_table)) {
+		err = PTR_ERR(msblk->xattr_id_table);
+		msblk->xattr_id_table = NULL;
+		goto failed_mount;
+	}
  allocate_root:
  	root = new_inode(sb);
  	if (!root) {
@@ -301,6 +315,7 @@ failed_mount:
  	kfree(msblk->inode_lookup_table);
  	kfree(msblk->fragment_index);
  	kfree(msblk->id_table);
+	kfree(msblk->xattr_id_table);
  	kfree(sb->s_fs_info);
  	sb->s_fs_info = NULL;
  	kfree(sblk);
@@ -355,6 +370,7 @@ static void squashfs_put_super(struct super_block *sb)
  		kfree(sbi->fragment_index);
  		kfree(sbi->meta_index);
  		kfree(sbi->inode_lookup_table);
+		kfree(sbi->xattr_id_table);
  		kfree(sb->s_fs_info);
  		sb->s_fs_info = NULL;
  	}
diff --git a/fs/squashfs/xattr_id.c b/fs/squashfs/xattr_id.c
new file mode 100644
index 0000000..a741012
--- /dev/null
+++ b/fs/squashfs/xattr_id.c
@@ -0,0 +1,100 @@
+/*
+ * Squashfs - a compressed read only filesystem for Linux
+ *
+ * Copyright (c) 2010
+ * Phillip Lougher <phillip@lougher.demon.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2,
+ * or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * xattr_id.c
+ */
+
+/*
+ * This file implements code to map the 32-bit xattr id stored in the inode
+ * into the on disk location of the xattr data.
+ */
+
+#include <linux/fs.h>
+#include <linux/vfs.h>
+#include <linux/slab.h>
+
+#include "squashfs_fs.h"
+#include "squashfs_fs_sb.h"
+#include "squashfs_fs_i.h"
+#include "squashfs.h"
+
+/*
+ * Map xattr id using the xattr id look up table
+ */
+int squashfs_xattr_lookup(struct super_block *sb, unsigned int index,
+		int *count, int *size, long long *xattr)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	int block = SQUASHFS_XATTR_BLOCK(index);
+	int offset = SQUASHFS_XATTR_BLOCK_OFFSET(index);
+	u64 start_block = le64_to_cpu(msblk->xattr_id_table[block]);
+	struct squashfs_xattr_id id;
+	int err;
+
+	err = squashfs_read_metadata(sb, &id, &start_block, &offset,
+							sizeof(id));
+	if (err < 0)
+		return err;
+
+	*xattr = le64_to_cpu(id.xattr);
+	*size = le32_to_cpu(id.size);
+	*count = le32_to_cpu(id.count);
+	return 0;
+}
+
+
+/*
+ * Read uncompressed xattr id lookup table indexes from disk into memory
+ */
+__le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 start,
+		u64 *xattr_table_start, int *xattr_ids)
+{
+	unsigned int len;
+	__le64 *xid_table;
+	struct squashfs_xattr_id_table id_table;
+	int err;
+
+	err = squashfs_read_table(sb, &id_table, start, sizeof(id_table));
+	if (err < 0) {
+		ERROR("unable to read xattr id table\n");
+		return ERR_PTR(err);
+	}
+	*xattr_table_start = le64_to_cpu(id_table.xattr_table_start);
+	*xattr_ids = le32_to_cpu(id_table.xattr_ids);
+	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
+
+	TRACE("In read_xattr_index_table, length %d\n", len);
+
+	/* Allocate xattr id lookup table indexes */
+	xid_table = kmalloc(len, GFP_KERNEL);
+	if (xid_table == NULL) {
+		ERROR("Failed to allocate xattr id index table\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	err = squashfs_read_table(sb, xid_table, start + sizeof(id_table), len);
+	if (err < 0) {
+		ERROR("unable to read xattr id index table\n");
+		kfree(xid_table);
+		return ERR_PTR(err);
+	}
+
+	return xid_table;
+}
-- 
1.6.3.3

