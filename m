Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab0EQTfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:35:41 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:52239 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754606Ab0EQTfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:35:40 -0400
Message-ID: <4BF19A03.1060506@lougher.demon.co.uk>
Date: Mon, 17 May 2010 20:33:23 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] squashfs: add xattr support configure option
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/Kconfig    |   11 +++++++++++
  fs/squashfs/Makefile   |    2 +-
  fs/squashfs/inode.c    |    1 +
  fs/squashfs/namei.c    |    1 +
  fs/squashfs/squashfs.h |    6 ------
  fs/squashfs/super.c    |    4 +++-
  fs/squashfs/symlink.c  |    1 +
  fs/squashfs/xattr.h    |   45 +++++++++++++++++++++++++++++++++++++++++++++
  8 files changed, 63 insertions(+), 8 deletions(-)
  create mode 100644 fs/squashfs/xattr.h

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index 25a00d1..cc6ce8a 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -26,6 +26,17 @@ config SQUASHFS

  	  If unsure, say N.

+config SQUASHFS_XATTRS
+	bool "Squashfs XATTR support"
+	depends on SQUASHFS
+	default n
+	help
+	  Saying Y here includes support for extended attributes (xattrs).
+	  Xattrs are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page).
+
+	  If unsure, say N.
+
  config SQUASHFS_EMBEDDED

  	bool "Additional option for memory-constrained systems"
diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
index 56684d4..2cee3e9 100644
--- a/fs/squashfs/Makefile
+++ b/fs/squashfs/Makefile
@@ -5,5 +5,5 @@
  obj-$(CONFIG_SQUASHFS) += squashfs.o
  squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
  squashfs-y += namei.o super.o symlink.o zlib_wrapper.o decompressor.o
-squashfs-y += xattr.o xattr_id.o
+squashfs-$(CONFIG_SQUASHFS_XATTRS) += xattr.o xattr_id.o

diff --git a/fs/squashfs/inode.c b/fs/squashfs/inode.c
index 2507011..62e63ad 100644
--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -46,6 +46,7 @@
  #include "squashfs_fs_sb.h"
  #include "squashfs_fs_i.h"
  #include "squashfs.h"
+#include "xattr.h"

  /*
   * Initialise VFS inode with the base inode information common to all
diff --git a/fs/squashfs/namei.c b/fs/squashfs/namei.c
index 32f5b54..7a9464d 100644
--- a/fs/squashfs/namei.c
+++ b/fs/squashfs/namei.c
@@ -63,6 +63,7 @@
  #include "squashfs_fs_sb.h"
  #include "squashfs_fs_i.h"
  #include "squashfs.h"
+#include "xattr.h"

  /*
   * Lookup name in the directory index, returning the location of the metadata
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index 7d23810..305ce15 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -76,12 +76,6 @@ extern int squashfs_read_inode(struct inode *, long long);
  /* xattr.c */
  extern ssize_t squashfs_listxattr(struct dentry *, char *, size_t);

-/* xattr_id.c */
-extern int squashfs_xattr_lookup(struct super_block *, unsigned int, int *,
-				int *, long long *);
-extern __le64 *squashfs_read_xattr_id_table(struct super_block *, u64,
-				u64 *, int *);
-
  /*
   * Inodes, files,  decompressor and xattr operations
   */
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index b6425ac..88b4f86 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -43,6 +43,7 @@
  #include "squashfs_fs_i.h"
  #include "squashfs.h"
  #include "decompressor.h"
+#include "xattr.h"

  static struct file_system_type squashfs_fs_type;
  static const struct super_operations squashfs_super_ops;
@@ -272,7 +273,8 @@ allocate_xattr_table:
  	if (IS_ERR(msblk->xattr_id_table)) {
  		err = PTR_ERR(msblk->xattr_id_table);
  		msblk->xattr_id_table = NULL;
-		goto failed_mount;
+		if (err != -ENOTSUPP)
+			goto failed_mount;
  	}
  allocate_root:
  	root = new_inode(sb);
diff --git a/fs/squashfs/symlink.c b/fs/squashfs/symlink.c
index a7ee68a..ec86434 100644
--- a/fs/squashfs/symlink.c
+++ b/fs/squashfs/symlink.c
@@ -41,6 +41,7 @@
  #include "squashfs_fs_sb.h"
  #include "squashfs_fs_i.h"
  #include "squashfs.h"
+#include "xattr.h"

  static int squashfs_symlink_readpage(struct file *file, struct page *page)
  {
diff --git a/fs/squashfs/xattr.h b/fs/squashfs/xattr.h
new file mode 100644
index 0000000..4a96366
--- /dev/null
+++ b/fs/squashfs/xattr.h
@@ -0,0 +1,45 @@
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
+ * xattr.h
+ */
+
+#ifdef CONFIG_SQUASHFS_XATTRS
+extern __le64 *squashfs_read_xattr_id_table(struct super_block *, u64,
+		u64 *, int *);
+extern int squashfs_xattr_lookup(struct super_block *, unsigned int, int *,
+		int *, long long *);
+#else
+static inline __le64 *squashfs_read_xattr_id_table(struct super_block *sb,
+		u64 start, u64 *xattr_table_start, int *xattr_ids)
+{
+	ERROR("Xattrs in filesystem, these will be ignored\n");
+	return ERR_PTR(-ENOTSUPP);
+}
+
+static inline int squashfs_xattr_lookup(struct super_block *sb,
+		unsigned int index, int *count, int *size, long long *xattr)
+{
+	return 0;
+}
+#define squashfs_listxattr NULL
+#define generic_getxattr NULL
+#define squashfs_xattr_handlers NULL
+#endif
-- 
1.6.3.3

