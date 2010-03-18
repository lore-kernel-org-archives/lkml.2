Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab0CRQzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:55:38 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:44522 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab0CRQzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:55:09 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: RFC: direct MTD support for SquashFS
References: <87vdcwv139.fsf@tac.ki.iif.hu>
	<87ljdsibqe.fsf@macbook.be.48ers.dk>
Date: Thu, 18 Mar 2010 17:38:43 +0100
In-Reply-To: <87ljdsibqe.fsf@macbook.be.48ers.dk> (Peter Korsgaard's message
	of "Tue, 16 Mar 2010 15:26:33 +0100")
Message-ID: <87r5nhziss.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Peter Korsgaard <jacmet@sunsite.dk> writes:

>>>>>> "Ferenc" == Ferenc Wagner <wferi@niif.hu> writes:
>
>  Ferenc> In embedded systems, SquashFS over MTD would be a considerable
>  Ferenc> win, as that would permit configuring without CONFIG_BLOCK.
>  Ferenc> Please find attached a naive patch against 2.6.33 for this.  It
>  Ferenc> does not handle bad MTD blocks, that could be handled by gluebi
>  Ferenc> (once you're willing to take the UBI overhead), or by a custom
>  Ferenc> solution later.
>
>  Ferenc> For now, 2.6.34 gained pluggable decompressors, so this patch
>  Ferenc> does not apply anymore, though the main idea holds.  My
>  Ferenc> questions: is the community interested in integrating something
>  Ferenc> like this, should this patch transformed into something
>  Ferenc> acceptable, or am I a total lunatic?  I don't know a thing
>  Ferenc> about filesystem development, but willing to learn and
>  Ferenc> refactor.  Comments welcome.
>
> Nice, I have been thinking about that as well. What kind of size savings
> are you getting with this?

I could only compare apples to oranges before porting the patch to the
LZMA variant.  So I refrain from that for a couple of days yet.  But
meanwhile I started adding a pluggable backend framework to SquashFS,
and would much appreciate some comments about the applicability of this
idea.  The patch is (intended to be) a no-op, applies on top of current
git (a3d3203e4bb40f253b1541e310dc0f9305be7c84).
-- 
Thanks,
Feri.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-squashfs-add-backend-plugin-framework.patch

>From bbed39c4402d563598dc8034514fd66648f835f5 Mon Sep 17 00:00:00 2001
From: Ferenc Wagner <wferi@niif.hu>
Date: Thu, 18 Mar 2010 03:12:01 +0100
Subject: [PATCH] squashfs: add backend plugin framework

---
 fs/squashfs/Kconfig          |    2 +-
 fs/squashfs/Makefile         |    4 +-
 fs/squashfs/backend.c        |   27 ++++++++++
 fs/squashfs/backend.h        |   22 +++++++++
 fs/squashfs/bdev.c           |  108 ++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/mtd.c            |   82 ++++++++++++++++++++++++++++++++
 fs/squashfs/squashfs.h       |   12 ++++-
 fs/squashfs/squashfs_fs_sb.h |    2 +
 8 files changed, 256 insertions(+), 3 deletions(-)
 create mode 100644 fs/squashfs/backend.c
 create mode 100644 fs/squashfs/backend.h
 create mode 100644 fs/squashfs/bdev.c
 create mode 100644 fs/squashfs/mtd.c

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index 25a00d1..5a0de30 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -1,6 +1,6 @@
 config SQUASHFS
 	tristate "SquashFS 4.0 - Squashed file system support"
-	depends on BLOCK
+	depends on BLOCK || MTD
 	select ZLIB_INFLATE
 	help
 	  Saying Y here includes support for SquashFS 4.0 (a Compressed
diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
index df8a19e..49230e3 100644
--- a/fs/squashfs/Makefile
+++ b/fs/squashfs/Makefile
@@ -4,4 +4,6 @@
 
 obj-$(CONFIG_SQUASHFS) += squashfs.o
 squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
-squashfs-y += namei.o super.o symlink.o zlib_wrapper.o decompressor.o
+squashfs-y += namei.o super.o symlink.o zlib_wrapper.o decompressor.o backend.o
+squashfs-$(CONFIG_BLOCK) += bdev.o
+squashfs-$(CONFIG_MTD) += mtd.o
diff --git a/fs/squashfs/backend.c b/fs/squashfs/backend.c
new file mode 100644
index 0000000..1b197c8
--- /dev/null
+++ b/fs/squashfs/backend.c
@@ -0,0 +1,27 @@
+#include <linux/fs.h>
+
+#include "squashfs_fs_i.h"
+#include "squashfs.h"
+#include "backend.h"
+
+const struct squashfs_backend *backends[] = {
+#ifdef CONFIG_BLOCK
+	&squashfs_bdev_ops,
+#endif
+#ifdef CONFIG_MTD
+	&squashfs_mtd_ops,
+#endif
+	NULL
+};
+
+const struct squashfs_backend *
+squashfs_find_backend(struct file_system_type *fs_type, int flags,
+			const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	const struct squashfs_backend **b;
+
+	for (b = backends; *b; b++)
+		if (!(*b)->probe(fs_type, flags, dev_name, data, mnt))
+			break;
+	return *b;
+}
diff --git a/fs/squashfs/backend.h b/fs/squashfs/backend.h
new file mode 100644
index 0000000..58c3476
--- /dev/null
+++ b/fs/squashfs/backend.h
@@ -0,0 +1,22 @@
+#include <linux/fs.h>
+#include <linux/vfs.h>
+
+#include "squashfs_fs_sb.h"
+
+struct squashfs_backend {
+	void	*(*init)(struct squashfs_sb_info *, u64, size_t);
+	void	(*free)(struct squashfs_sb_info *);
+	ssize_t	(*read)(struct squashfs_sb_info *, void **, size_t);
+	int	(*probe)(struct file_system_type *, int, const char *,
+				void*, struct vfsmount *);
+	void	(*kill)(struct squashfs_sb_info *);
+	loff_t  (*size)(const struct super_block *);
+	const char *(*devname)(const struct super_block *, char *);
+};
+
+/* Dummy, until the original is nuked */
+static inline int squashfs_fill_super2(struct super_block *sb, void *data,
+				int silent, const struct squashfs_backend *ops)
+{
+	return -1;
+}
diff --git a/fs/squashfs/bdev.c b/fs/squashfs/bdev.c
new file mode 100644
index 0000000..8ba2322
--- /dev/null
+++ b/fs/squashfs/bdev.c
@@ -0,0 +1,108 @@
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+
+#include "squashfs_fs_i.h"
+#include "squashfs.h"
+#include "backend.h"
+
+struct squashfs_bdev {
+	int devblksize;			/* FIXME: == s->s_blocksize(_bits)? */
+	unsigned short devblksize_log2;
+	size_t bytes_left;
+	struct buffer_head **bh;
+	int bh_index;			/* number of consumed buffer_heads */
+	int offset;			/* offset of next byte in buffer_head */
+};
+
+/* A backend is initialized for each SquashFS block read operation,
+ * making further sequential reads possible from the block.
+ */
+static void *bdev_init(struct squashfs_sb_info *msblk, u64 index, size_t length)
+{
+	struct squashfs_bdev *bdev = msblk->backend_data;
+	struct buffer_head *bh;
+
+	bh = kcalloc((msblk->block_size >> bdev->devblksize_log2) + 1,
+			sizeof(*bh), GFP_KERNEL);
+	if (!bh)
+		goto nomem;
+
+	/* different preread for data blocks and metadata blocks */
+
+	bdev->bh_index = 0;
+	bdev->bytes_left = length;
+	return bdev;
+
+nomem:
+	ERROR("failed to allocate buffer_heads\n");
+	return NULL;
+}
+
+static void bdev_free(struct squashfs_sb_info *msblk)
+{
+	struct squashfs_bdev *bdev = msblk->backend_data;
+	kfree(bdev->bh);
+	bdev->bh = 0; /* FIXME: to make bdev_kill universal (see there) */
+}
+
+static ssize_t bdev_read(struct squashfs_sb_info *msblk, void **buf, size_t len)
+{
+	return -ENOSYS;
+}
+
+static int fill_bdev_super(struct super_block *sb, void *data, int silent)
+{
+	struct squashfs_sb_info *msblk;
+	struct squashfs_bdev *bdev;
+	int err = squashfs_fill_super2(sb, data, silent, &squashfs_bdev_ops);
+	if (err)
+		return err;
+
+	bdev = kzalloc(sizeof(*bdev), GFP_KERNEL);
+	if (!bdev)
+		return -ENOMEM;
+
+	bdev->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
+	bdev->devblksize_log2 = ffz(~bdev->devblksize);
+
+	msblk = sb->s_fs_info;
+	msblk->backend_data = bdev;
+	return 0;
+}
+
+static int bdev_probe(struct file_system_type *fs_type, int flags,
+			const char *dev_name, void *data,
+			struct vfsmount *mnt)
+{
+	return get_sb_bdev(fs_type, flags, dev_name, data,
+				fill_bdev_super, mnt);
+}
+
+static void bdev_kill(struct squashfs_sb_info *msblk)
+{
+	struct squashfs_bdev *bdev = msblk->backend_data;
+	if (bdev) {
+		kfree(bdev->bh); /* FIXME: can this be nonzero? cf. bdev_free */
+		kfree(bdev);
+	}
+}
+
+static loff_t bdev_size(const struct super_block *sb)
+{
+	return i_size_read(sb->s_bdev->bd_inode);
+}
+
+static const char *bdev_devname(const struct super_block *sb, char *buffer)
+{
+	return bdevname(sb->s_bdev, buffer);
+}
+
+const struct squashfs_backend squashfs_bdev_ops = {
+	.init	= bdev_init,
+	.free	= bdev_free,
+	.read	= bdev_read,
+	.probe	= bdev_probe,
+	.kill	= bdev_kill,
+	.size	= bdev_size,
+	.devname= bdev_devname
+};
diff --git a/fs/squashfs/mtd.c b/fs/squashfs/mtd.c
new file mode 100644
index 0000000..c63b4f8
--- /dev/null
+++ b/fs/squashfs/mtd.c
@@ -0,0 +1,82 @@
+#include <linux/fs.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/super.h>
+
+#include "squashfs_fs_i.h"
+#include "squashfs.h"
+#include "backend.h"
+
+struct squashfs_mtd {
+	size_t bytes_left;
+};
+
+/* A backend is initialized for each SquashFS block read operation,
+ * making further sequential reads possible from the block.
+ */
+static void *mtd_init(struct squashfs_sb_info *msblk, u64 index, size_t length)
+{
+	struct squashfs_mtd *mtd = msblk->backend_data;
+
+	mtd->bytes_left = length;
+	return mtd;
+}
+
+static void mtd_free(struct squashfs_sb_info *msblk)
+{
+}
+
+static ssize_t mtd_read(struct squashfs_sb_info *msblk, void **buf, size_t len)
+{
+	return -ENOSYS;
+}
+
+static int fill_mtd_super(struct super_block *sb, void *data, int silent)
+{
+	struct squashfs_sb_info *msblk;
+	struct squashfs_mtd *mtd;
+	int err = squashfs_fill_super2(sb, data, silent, &squashfs_mtd_ops);
+	if (err)
+		return err;
+
+	mtd = kzalloc(sizeof(*mtd), GFP_KERNEL);
+	if (!mtd)
+		return -ENOMEM;
+
+	msblk = sb->s_fs_info;
+	msblk->backend_data = mtd;
+	return 0;
+}
+
+static int mtd_probe(struct file_system_type *fs_type, int flags,
+			const char *dev_name, void *data,
+			struct vfsmount *mnt)
+{
+	return get_sb_mtd(fs_type, flags, dev_name, data,
+				fill_mtd_super, mnt);
+}
+
+static void mtd_kill(struct squashfs_sb_info *msblk)
+{
+	kfree(msblk->backend_data);
+}
+
+static loff_t mtd_size(const struct super_block *sb)
+{
+	return sb->s_mtd->size;
+}
+
+static const char *mtd_devname(const struct super_block *sb, char *buffer)
+{
+	snprintf(buffer, BDEVNAME_SIZE, "MTD%d", sb->s_mtd->index);
+	return buffer;
+}
+
+const struct squashfs_backend squashfs_mtd_ops = {
+	.init	= mtd_init,
+	.free	= mtd_free,
+	.read	= mtd_read,
+	.probe	= mtd_probe,
+	.kill	= mtd_kill,
+	.size	= mtd_size,
+	.devname= mtd_devname
+};
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index fe2587a..3efa18f 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -73,8 +73,12 @@ extern struct inode *squashfs_iget(struct super_block *, long long,
 				unsigned int);
 extern int squashfs_read_inode(struct inode *, long long);
 
+/* super.c
+int squashfs_fill_super(struct super_block *, void *, int,
+                        struct squashfs_backend *);
+*/
 /*
- * Inodes, files and decompressor operations
+ * Inodes, files, backend and decompressor operations
  */
 
 /* dir.c */
@@ -94,3 +98,9 @@ extern const struct address_space_operations squashfs_symlink_aops;
 
 /* zlib_wrapper.c */
 extern const struct squashfs_decompressor squashfs_zlib_comp_ops;
+
+/* bdev.c */
+extern const struct squashfs_backend squashfs_bdev_ops;
+
+/* mtd.c */
+extern const struct squashfs_backend squashfs_mtd_ops;
diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
index 2e77dc5..378b0ad 100644
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -53,6 +53,8 @@ struct squashfs_cache_entry {
 
 struct squashfs_sb_info {
 	const struct squashfs_decompressor	*decompressor;
+	const struct squashfs_backend		*backend;
+	void					*backend_data;
 	int					devblksize;
 	int					devblksize_log2;
 	struct squashfs_cache			*block_cache;
-- 
1.5.6.5


--=-=-=--
