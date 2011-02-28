Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1B1XcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:32:25 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:39642 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753728Ab1B1XcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:32:24 -0500
Message-ID: <4D6C3095.3050006@lougher.demon.co.uk>
Date: Mon, 28 Feb 2011 23:32:37 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] Squashfs: extend decompressor framework to handle compression
 options
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Extend decompressor framework to handle compression options stored in
the filesystem.  These options can be used by the relevant decompressor
at initialisation time to over-ride defaults.

The presence of compression options in the filesystem is indicated by
the COMP_OPT filesystem flag.  If present the data is read from the
filesystem and passed to the decompressor init function.  The decompressor
init function signature has been extended to take this data.

Also update the init function signature in the glib, lzo and xz
decompressor wrappers.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/decompressor.c |   34 ++++++++++++++++++++++++++++++++++
  fs/squashfs/decompressor.h |    7 +------
  fs/squashfs/lzo_wrapper.c  |    4 ++--
  fs/squashfs/squashfs.h     |    1 +
  fs/squashfs/squashfs_fs.h  |    4 ++++
  fs/squashfs/super.c        |   11 +++++++----
  fs/squashfs/xz_wrapper.c   |    5 +++--
  fs/squashfs/zlib_wrapper.c |    4 ++--
  8 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/fs/squashfs/decompressor.c b/fs/squashfs/decompressor.c
index a5940e5..e921bd2 100644
--- a/fs/squashfs/decompressor.c
+++ b/fs/squashfs/decompressor.c
@@ -23,6 +23,7 @@

  #include <linux/types.h>
  #include <linux/mutex.h>
+#include <linux/slab.h>
  #include <linux/buffer_head.h>

  #include "squashfs_fs.h"
@@ -74,3 +75,36 @@ const struct squashfs_decompressor *squashfs_lookup_decompressor(int id)

  	return decompressor[i];
  }
+
+
+void *squashfs_decompressor_init(struct super_block *sb, unsigned short flags)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	void *strm, *buffer = NULL;
+	int length = 0;
+
+	/*
+	 * Read decompressor specific options from file system if present
+	 */
+	if (SQUASHFS_COMP_OPTS(flags)) {
+		buffer = kmalloc(PAGE_CACHE_SIZE, GFP_KERNEL);
+		if (buffer == NULL)
+			return ERR_PTR(-ENOMEM);
+
+		length = squashfs_read_data(sb, &buffer,
+			sizeof(struct squashfs_super_block), 0, NULL,
+			PAGE_CACHE_SIZE, 1);
+
+		if (length < 0) {
+			strm = ERR_PTR(length);
+			goto finished;
+		}
+	}
+
+	strm = msblk->decompressor->init(msblk, buffer, length);
+
+finished:
+	kfree(buffer);
+
+	return strm;
+}
diff --git a/fs/squashfs/decompressor.h b/fs/squashfs/decompressor.h
index 3b305a7..099745a 100644
--- a/fs/squashfs/decompressor.h
+++ b/fs/squashfs/decompressor.h
@@ -24,7 +24,7 @@
   */

  struct squashfs_decompressor {
-	void	*(*init)(struct squashfs_sb_info *);
+	void	*(*init)(struct squashfs_sb_info *, void *, int);
  	void	(*free)(void *);
  	int	(*decompress)(struct squashfs_sb_info *, void **,
  		struct buffer_head **, int, int, int, int, int);
@@ -33,11 +33,6 @@ struct squashfs_decompressor {
  	int	supported;
  };

-static inline void *squashfs_decompressor_init(struct squashfs_sb_info *msblk)
-{
-	return msblk->decompressor->init(msblk);
-}
-
  static inline void squashfs_decompressor_free(struct squashfs_sb_info *msblk,
  	void *s)
  {
diff --git a/fs/squashfs/lzo_wrapper.c b/fs/squashfs/lzo_wrapper.c
index 7da759e..00f4dfc 100644
--- a/fs/squashfs/lzo_wrapper.c
+++ b/fs/squashfs/lzo_wrapper.c
@@ -37,7 +37,7 @@ struct squashfs_lzo {
  	void	*output;
  };

-static void *lzo_init(struct squashfs_sb_info *msblk)
+static void *lzo_init(struct squashfs_sb_info *msblk, void *buff, int len)
  {
  	int block_size = max_t(int, msblk->block_size, SQUASHFS_METADATA_SIZE);

@@ -58,7 +58,7 @@ failed2:
  failed:
  	ERROR("Failed to allocate lzo workspace\n");
  	kfree(stream);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
  }


diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index ba729d8..1f2e608 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -48,6 +48,7 @@ extern int squashfs_read_table(struct super_block *, void *, u64, int);

  /* decompressor.c */
  extern const struct squashfs_decompressor *squashfs_lookup_decompressor(int);
+extern void *squashfs_decompressor_init(struct super_block *, unsigned short);

  /* export.c */
  extern __le64 *squashfs_read_inode_lookup_table(struct super_block *, u64,
diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index 39533fe..4582c56 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -57,6 +57,7 @@
  #define SQUASHFS_ALWAYS_FRAG		5
  #define SQUASHFS_DUPLICATE		6
  #define SQUASHFS_EXPORT			7
+#define SQUASHFS_COMP_OPT		10

  #define SQUASHFS_BIT(flag, bit)		((flag >> bit) & 1)

@@ -81,6 +82,9 @@
  #define SQUASHFS_EXPORTABLE(flags)		SQUASHFS_BIT(flags, \
  						SQUASHFS_EXPORT)

+#define SQUASHFS_COMP_OPTS(flags)		SQUASHFS_BIT(flags, \
+						SQUASHFS_COMP_OPT)
+
  /* Max number of types and file types */
  #define SQUASHFS_DIR_TYPE		1
  #define SQUASHFS_REG_TYPE		2
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 20700b9..95467db 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -199,10 +199,6 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)

  	err = -ENOMEM;

-	msblk->stream = squashfs_decompressor_init(msblk);
-	if (msblk->stream == NULL)
-		goto failed_mount;
-
  	msblk->block_cache = squashfs_cache_init("metadata",
  			SQUASHFS_CACHED_BLKS, SQUASHFS_METADATA_SIZE);
  	if (msblk->block_cache == NULL)
@@ -215,6 +211,13 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
  		goto failed_mount;
  	}

+	msblk->stream = squashfs_decompressor_init(sb, flags);
+	if (IS_ERR(msblk->stream)) {
+		err = PTR_ERR(msblk->stream);
+		msblk->stream = NULL;
+		goto failed_mount;
+	}
+
  	/* Allocate and read id index table */
  	msblk->id_table = squashfs_read_id_index_table(sb,
  		le64_to_cpu(sblk->id_table_start), le16_to_cpu(sblk->no_ids));
diff --git a/fs/squashfs/xz_wrapper.c b/fs/squashfs/xz_wrapper.c
index c4eb400..397adea 100644
--- a/fs/squashfs/xz_wrapper.c
+++ b/fs/squashfs/xz_wrapper.c
@@ -38,7 +38,8 @@ struct squashfs_xz {
  	struct xz_buf buf;
  };

-static void *squashfs_xz_init(struct squashfs_sb_info *msblk)
+static void *squashfs_xz_init(struct squashfs_sb_info *msblk, void *buff,
+	int len)
  {
  	int block_size = max_t(int, msblk->block_size, SQUASHFS_METADATA_SIZE);

@@ -55,7 +56,7 @@ static void *squashfs_xz_init(struct squashfs_sb_info *msblk)
  failed:
  	ERROR("Failed to allocate xz workspace\n");
  	kfree(stream);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
  }


diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
index 4661ae2..195b0d0 100644
--- a/fs/squashfs/zlib_wrapper.c
+++ b/fs/squashfs/zlib_wrapper.c
@@ -32,7 +32,7 @@
  #include "squashfs.h"
  #include "decompressor.h"

-static void *zlib_init(struct squashfs_sb_info *dummy)
+static void *zlib_init(struct squashfs_sb_info *dummy, void *buff, int len)
  {
  	z_stream *stream = kmalloc(sizeof(z_stream), GFP_KERNEL);
  	if (stream == NULL)
@@ -47,7 +47,7 @@ static void *zlib_init(struct squashfs_sb_info *dummy)
  failed:
  	ERROR("Failed to allocate zlib workspace\n");
  	kfree(stream);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
  }


-- 
1.7.1

