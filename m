Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1GXXnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 19:43:49 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:48042 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596Ab1GXXnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 19:43:46 -0400
X-Greylist: delayed 2797 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jul 2011 19:43:46 EDT
Message-ID: <4E2CA357.2030507@lougher.demon.co.uk>
Date: Sun, 24 Jul 2011 23:57:27 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] Squashfs: Make ZLIB compression support optional
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Squashfs now supports XZ and LZO compression in addition to ZLIB.
As such it no longer makes sense to always include ZLIB support.
In particular embedded systems may only use LZO or XZ compression, and
the ability to exclude ZLIB support will reduce kernel size.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
  fs/squashfs/Kconfig        |   14 +++++++++++++-
  fs/squashfs/Makefile       |    3 ++-
  fs/squashfs/decompressor.c |    6 ++++++
  fs/squashfs/decompressor.h |    4 ++++
  fs/squashfs/squashfs.h     |    3 ---
  5 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index 7797218..1360d4f 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -1,7 +1,6 @@
  config SQUASHFS
  	tristate "SquashFS 4.0 - Squashed file system support"
  	depends on BLOCK
-	select ZLIB_INFLATE
  	help
  	  Saying Y here includes support for SquashFS 4.0 (a Compressed
  	  Read-Only File System).  Squashfs is a highly compressed read-only
@@ -36,6 +35,19 @@ config SQUASHFS_XATTR

  	  If unsure, say N.

+config SQUASHFS_ZLIB
+	bool "Include support for ZLIB compressed file systems"
+	depends on SQUASHFS
+	select ZLIB_INFLATE
+	default y
+	help
+	  ZLIB compression is the standard compression used by Squashfs
+	  file systems.  It offers a good trade-off between compression
+	  achieved and the amount of CPU time and memory necessary to
+	  compress and decompress.
+
+	  If unsure, say Y.
+
  config SQUASHFS_LZO
  	bool "Include support for LZO compressed file systems"
  	depends on SQUASHFS
diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
index cecf2be..110b047 100644
--- a/fs/squashfs/Makefile
+++ b/fs/squashfs/Makefile
@@ -4,7 +4,8 @@

  obj-$(CONFIG_SQUASHFS) += squashfs.o
  squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
-squashfs-y += namei.o super.o symlink.o zlib_wrapper.o decompressor.o
+squashfs-y += namei.o super.o symlink.o decompressor.o
  squashfs-$(CONFIG_SQUASHFS_XATTR) += xattr.o xattr_id.o
  squashfs-$(CONFIG_SQUASHFS_LZO) += lzo_wrapper.o
  squashfs-$(CONFIG_SQUASHFS_XZ) += xz_wrapper.o
+squashfs-$(CONFIG_SQUASHFS_ZLIB) += zlib_wrapper.o
diff --git a/fs/squashfs/decompressor.c b/fs/squashfs/decompressor.c
index 9f1b0bb..3f6271d 100644
--- a/fs/squashfs/decompressor.c
+++ b/fs/squashfs/decompressor.c
@@ -52,6 +52,12 @@ static const struct squashfs_decompressor squashfs_xz_comp_ops = {
  };
  #endif

+#ifndef CONFIG_SQUASHFS_ZLIB
+static const struct squashfs_decompressor squashfs_zlib_comp_ops = {
+	NULL, NULL, NULL, ZLIB_COMPRESSION, "zlib", 0
+};
+#endif
+
  static const struct squashfs_decompressor squashfs_unknown_comp_ops = {
  	NULL, NULL, NULL, 0, "unknown", 0
  };
diff --git a/fs/squashfs/decompressor.h b/fs/squashfs/decompressor.h
index 8ba70cf..330073e 100644
--- a/fs/squashfs/decompressor.h
+++ b/fs/squashfs/decompressor.h
@@ -56,4 +56,8 @@ extern const struct squashfs_decompressor squashfs_xz_comp_ops;
  extern const struct squashfs_decompressor squashfs_lzo_comp_ops;
  #endif

+#ifdef CONFIG_SQUASHFS_ZLIB
+extern const struct squashfs_decompressor squashfs_zlib_comp_ops;
+#endif
+
  #endif
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index e3be6a7..d126651 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -97,6 +97,3 @@ extern const struct inode_operations squashfs_symlink_inode_ops;

  /* xattr.c */
  extern const struct xattr_handler *squashfs_xattr_handlers[];
-
-/* zlib_wrapper.c */
-extern const struct squashfs_decompressor squashfs_zlib_comp_ops;
-- 
1.7.1

