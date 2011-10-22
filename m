Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1JVBKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 21:10:36 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:42322 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569Ab1JVBKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 21:10:35 -0400
Date: Sat, 22 Oct 2011 02:09:59 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Squashfs: Add an option to set dev block size to 4K
Message-ID: <4ea217e7.HYMdUt5MdVjknqE7%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an option to set the device block size used to 4K.

By default Squashfs sets the device block size (sb_min_blocksize) to 1K
or the smallest block size supported by the block device (if larger).
This, because blocks are packed together and unaligned in Squashfs,
should reduce latency.

This, however, gives poor performance on MTD NAND devices where
the optimal I/O size is 4K (even though the devices can support
smaller block sizes).

Using a 4K device block size may also improve overall I/O
performance for some file access patterns (e.g. sequential
accesses of files in filesystem order) on all media.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/Kconfig       |   22 ++++++++++++++++++++++
 fs/squashfs/squashfs_fs.h |    7 +++++++
 fs/squashfs/super.c       |    2 +-
 3 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index 7797218..d383dd2 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -66,6 +66,28 @@ config SQUASHFS_XZ
 
 	  If unsure, say N.
 
+config SQUASHFS_4K_DEVBLK_SIZE
+	bool "Use 4K device block size?"
+	depends on SQUASHFS
+	help
+	  By default Squashfs sets the dev block size (sb_min_blocksize)
+	  to 1K or the smallest block size supported by the block device
+	  (if larger).  This, because blocks are packed together and
+	  unaligned in Squashfs, should reduce latency.
+
+	  This, however, gives poor performance on MTD NAND devices where
+	  the optimal I/O size is 4K (even though the devices can support
+	  smaller block sizes).
+
+	  Using a 4K device block size may also improve overall I/O
+	  performance for some file access patterns (e.g. sequential
+	  accesses of files in filesystem order) on all media.
+
+	  Setting this option will force Squashfs to use a 4K device block
+	  size by default.
+	  
+	  If unsure, say N.
+
 config SQUASHFS_EMBEDDED
 	bool "Additional option for memory-constrained systems"
 	depends on SQUASHFS
diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index b4a4e53..e8e1464 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -36,6 +36,13 @@
 #define SQUASHFS_FILE_SIZE		131072
 #define SQUASHFS_FILE_LOG		17
 
+/* default size of block device I/O */
+#ifdef CONFIG_SQUASHFS_4K_DEVBLK_SIZE
+#define SQUASHFS_DEVBLK_SIZE 4096
+#else
+#define SQUASHFS_DEVBLK_SIZE 1024
+#endif
+
 #define SQUASHFS_FILE_MAX_SIZE		1048576
 #define SQUASHFS_FILE_MAX_LOG		20
 
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 7438850..2da1715 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -95,7 +95,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	msblk = sb->s_fs_info;
 
-	msblk->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
+	msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
 	msblk->devblksize_log2 = ffz(~msblk->devblksize);
 
 	mutex_init(&msblk->read_data_mutex);
-- 
1.7.4.1

