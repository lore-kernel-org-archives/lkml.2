Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0CWUsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 16:48:01 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:34515 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab0CWUr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:47:59 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Phillip Lougher <phillip.lougher@gmail.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: RFC: direct MTD support for SquashFS
In-Reply-To: Ferenc Wagner's message of "Tue\, 23 Mar 2010 12\:35\:02 +0100"
References: <87vdcwv139.fsf@tac.ki.iif.hu>
	<87ljdsibqe.fsf@macbook.be.48ers.dk> <87r5nhziss.fsf@tac.ki.iif.hu>
	<bffbecbb1003181440kc78f4dbvd25d4e2ea17b52e5@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Date: Tue, 23 Mar 2010 21:47:39 +0100
Message-ID: <8739zqpxxw.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Now with the patch series, sorry.

Ferenc Wagner <wferi@niif.hu> writes:

> I've got one more patch, which I forgot to export, to pull out the
> common logic from the backend init functions back into squashfs_read_data().
> With the bdev backend, that entails reading the first block twice in a
> row most of the time.  This again could be worked around by extending
> the backend interface, but I'm not sure if it's worth it.

Here it is.  I also corrected the name of SQUASHFS_METADATA_SIZE, so it
may as well compile now.
-- 
Regards,
Feri.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=squashfs-mtd.mbox

>From 1318e378d15008c89971f4c300738bd46d0fd2ba Mon Sep 17 00:00:00 2001
From: Ferenc Wagner <wferi@niif.hu>
Date: Thu, 18 Mar 2010 03:12:01 +0100
Subject: [PATCH] squashfs: add backend plugin framework

---
 fs/squashfs/Makefile         |    3 +-
 fs/squashfs/backend.c        |   24 +++++++++
 fs/squashfs/backend.h        |   22 ++++++++
 fs/squashfs/bdev.c           |  110 ++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/squashfs.h       |    9 +++-
 fs/squashfs/squashfs_fs_sb.h |    2 +
 6 files changed, 168 insertions(+), 2 deletions(-)
 create mode 100644 fs/squashfs/backend.c
 create mode 100644 fs/squashfs/backend.h
 create mode 100644 fs/squashfs/bdev.c

diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
index 45aaefd..0f02891 100644
--- a/fs/squashfs/Makefile
+++ b/fs/squashfs/Makefile
@@ -4,5 +4,6 @@
 
 obj-$(CONFIG_SQUASHFS) += squashfs.o
 squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
-squashfs-y += namei.o super.o symlink.o zlib_wrapper.o decompressor.o
+squashfs-y += namei.o super.o symlink.o zlib_wrapper.o decompressor.o backend.o
 squashfs-$(CONFIG_SQUASHFS_LZMA) += lzma_wrapper.o
+squashfs-$(CONFIG_BLOCK) += bdev.o
diff --git a/fs/squashfs/backend.c b/fs/squashfs/backend.c
new file mode 100644
index 0000000..4411c60
--- /dev/null
+++ b/fs/squashfs/backend.c
@@ -0,0 +1,24 @@
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
index 0000000..ca3ffe1
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
+				int silent, int (*add_bend)(struct super_block *))
+{
+	return -1;
+}
diff --git a/fs/squashfs/bdev.c b/fs/squashfs/bdev.c
new file mode 100644
index 0000000..c1d4389
--- /dev/null
+++ b/fs/squashfs/bdev.c
@@ -0,0 +1,110 @@
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
+	bh = kcalloc((max_t(int, msblk->block_size, SQUASHFS_METADATA_SIZE)
+		      >> bdev->devblksize_log2) + 1,
+		     sizeof(*bh), GFP_KERNEL);
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
+static int add_bdev_backend(struct super_block *sb)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	struct squashfs_bdev *bdev = kzalloc(sizeof(*bdev), GFP_KERNEL);
+
+	if (!bdev)
+		return -ENOMEM;
+
+	bdev->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
+	bdev->devblksize_log2 = ffz(~bdev->devblksize);
+
+	msblk->backend = &squashfs_bdev_ops;
+	msblk->backend_data = bdev;
+	return 0;
+}
+
+static int fill_bdev_super(struct super_block *sb, void *data, int silent)
+{
+	return squashfs_fill_super2(sb, data, silent, add_bdev_backend);
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
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index d094886..0e74175 100644
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
@@ -97,3 +101,6 @@ extern const struct squashfs_decompressor squashfs_zlib_comp_ops;
 
 /* lzma wrapper.c */
 extern const struct squashfs_decompressor squashfs_lzma_comp_ops;
+
+/* bdev.c */
+extern const struct squashfs_backend squashfs_bdev_ops;
diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
index 7533350..5662d9b 100644
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


>From 3d469f3f3f2ecaacc8d99a142899216879099867 Mon Sep 17 00:00:00 2001
From: Ferenc Wagner <wferi@niif.hu>
Date: Sat, 20 Mar 2010 15:58:21 +0100
Subject: [PATCH] squashfs: thread initialization through the backend framework

This necessitated introducing the killsb callback.
The read path is still untouched.
---
 fs/squashfs/backend.c  |   22 +++++++++++++++-----
 fs/squashfs/backend.h  |   11 ++++-----
 fs/squashfs/bdev.c     |    3 +-
 fs/squashfs/squashfs.h |    6 ++--
 fs/squashfs/super.c    |   49 +++++++++++++++++++++--------------------------
 5 files changed, 48 insertions(+), 43 deletions(-)

diff --git a/fs/squashfs/backend.c b/fs/squashfs/backend.c
index 4411c60..49fa6fa 100644
--- a/fs/squashfs/backend.c
+++ b/fs/squashfs/backend.c
@@ -11,14 +11,24 @@ const struct squashfs_backend *backends[] = {
 	NULL
 };
 
-const struct squashfs_backend *
-squashfs_find_backend(struct file_system_type *fs_type, int flags,
+int squashfs_find_backend(struct file_system_type *fs_type, int flags,
 			const char *dev_name, void *data, struct vfsmount *mnt)
 {
 	const struct squashfs_backend **b;
+	int err;
 
-	for (b = backends; *b; b++)
-		if (!(*b)->probe(fs_type, flags, dev_name, data, mnt))
-			break;
-	return *b;
+	for (b = backends; *b; b++) {
+		err = (*b)->probe(fs_type, flags, dev_name, data, mnt);
+		if (!err)
+			return 0;
+	}
+	ERROR("No suitable backend found\n");
+	return -ENODEV;
+}
+
+void squashfs_kill_super(struct super_block *sb)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+
+	msblk->backend->killsb(sb);
 }
diff --git a/fs/squashfs/backend.h b/fs/squashfs/backend.h
index ca3ffe1..02c4bcd 100644
--- a/fs/squashfs/backend.h
+++ b/fs/squashfs/backend.h
@@ -9,14 +9,13 @@ struct squashfs_backend {
 	ssize_t	(*read)(struct squashfs_sb_info *, void **, size_t);
 	int	(*probe)(struct file_system_type *, int, const char *,
 				void*, struct vfsmount *);
+	void    (*killsb)(struct super_block *);
 	void	(*kill)(struct squashfs_sb_info *);
 	loff_t  (*size)(const struct super_block *);
 	const char *(*devname)(const struct super_block *, char *);
 };
 
-/* Dummy, until the original is nuked */
-static inline int squashfs_fill_super2(struct super_block *sb, void *data,
-				int silent, int (*add_bend)(struct super_block *))
-{
-	return -1;
-}
+int squashfs_find_backend(struct file_system_type *, int,
+			const char *, void *, struct vfsmount *);
+
+void squashfs_kill_super(struct super_block *);
diff --git a/fs/squashfs/bdev.c b/fs/squashfs/bdev.c
index c1d4389..0ee09f8 100644
--- a/fs/squashfs/bdev.c
+++ b/fs/squashfs/bdev.c
@@ -69,7 +69,7 @@ static int add_bdev_backend(struct super_block *sb)
 
 static int fill_bdev_super(struct super_block *sb, void *data, int silent)
 {
-	return squashfs_fill_super2(sb, data, silent, add_bdev_backend);
+	return squashfs_fill_super(sb, data, silent, add_bdev_backend);
 }
 
 static int bdev_probe(struct file_system_type *fs_type, int flags,
@@ -104,6 +104,7 @@ const struct squashfs_backend squashfs_bdev_ops = {
 	.free	= bdev_free,
 	.read	= bdev_read,
 	.probe	= bdev_probe,
+	.killsb	= kill_block_super,
 	.kill	= bdev_kill,
 	.size	= bdev_size,
 	.devname= bdev_devname
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index 0e74175..24c4b9e 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -73,10 +73,10 @@ extern struct inode *squashfs_iget(struct super_block *, long long,
 				unsigned int);
 extern int squashfs_read_inode(struct inode *, long long);
 
-/* super.c
+/* super.c */
 int squashfs_fill_super(struct super_block *, void *, int,
-                        struct squashfs_backend *);
-*/
+                        int (*)(struct super_block *));
+
 /*
  * Inodes, files, backend and decompressor operations
  */
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 3550aec..710179f 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -42,6 +42,7 @@
 #include "squashfs_fs_i.h"
 #include "squashfs.h"
 #include "decompressor.h"
+#include "backend.h"
 
 static struct file_system_type squashfs_fs_type;
 static const struct super_operations squashfs_super_ops;
@@ -73,7 +74,8 @@ static const struct squashfs_decompressor *supported_squashfs_filesystem(short
 }
 
 
-static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
+int squashfs_fill_super(struct super_block *sb, void *data, int silent,
+			int (*add_backend)(struct super_block *))
 {
 	struct squashfs_sb_info *msblk;
 	struct squashfs_super_block *sblk = NULL;
@@ -97,11 +99,15 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	sblk = kzalloc(sizeof(*sblk), GFP_KERNEL);
 	if (sblk == NULL) {
 		ERROR("Failed to allocate squashfs_super_block\n");
-		goto failure;
+		err = -ENOMEM;
+		goto free_msblk;
 	}
 
 	msblk->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
 	msblk->devblksize_log2 = ffz(~msblk->devblksize);
+	err = add_backend(sb);
+	if (err)
+		goto free_sblk;
 
 	mutex_init(&msblk->read_data_mutex);
 	mutex_init(&msblk->meta_index_mutex);
@@ -127,7 +133,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (sb->s_magic != SQUASHFS_MAGIC) {
 		if (!silent)
 			ERROR("Can't find a SQUASHFS superblock on %s\n",
-						bdevname(sb->s_bdev, b));
+					msblk->backend->devname(sb, b));
 		goto failed_mount;
 	}
 
@@ -146,11 +152,10 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (le64_to_cpu(sblk->xattr_table_start) != SQUASHFS_INVALID_BLK)
 		ERROR("Xattrs in filesystem, these will be ignored\n");
 
-	/* Check the filesystem does not extend beyond the end of the
-	   block device */
+	/* Check the filesystem does not extend beyond the end of the device */
 	msblk->bytes_used = le64_to_cpu(sblk->bytes_used);
 	if (msblk->bytes_used < 0 || msblk->bytes_used >
-			i_size_read(sb->s_bdev->bd_inode))
+			msblk->backend->size(sb))
 		goto failed_mount;
 
 	/* Check block size for sanity */
@@ -182,7 +187,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	msblk->inodes = le32_to_cpu(sblk->inodes);
 	flags = le16_to_cpu(sblk->flags);
 
-	TRACE("Found valid superblock on %s\n", bdevname(sb->s_bdev, b));
+	TRACE("Found valid superblock on %s\n", msblk->backend->devname(sb, b));
 	TRACE("Inodes are %scompressed\n", SQUASHFS_UNCOMPRESSED_INODES(flags)
 				? "un" : "");
 	TRACE("Data is %scompressed\n", SQUASHFS_UNCOMPRESSED_DATA(flags)
@@ -297,18 +302,16 @@ failed_mount:
 	squashfs_cache_delete(msblk->fragment_cache);
 	squashfs_cache_delete(msblk->read_page);
 	squashfs_decompressor_free(msblk, msblk->stream);
-	kfree(msblk->inode_lookup_table);
+	kfree(msblk->inode_lookup_table); /* FIXME: squashfs_put_super has meta_index instead */
 	kfree(msblk->fragment_index);
 	kfree(msblk->id_table);
-	kfree(sb->s_fs_info);
-	sb->s_fs_info = NULL;
+	msblk->backend->kill(msblk);
+free_sblk:
 	kfree(sblk);
-	return err;
-
-failure:
-	kfree(sb->s_fs_info);
+free_msblk:
+	kfree(msblk);
 	sb->s_fs_info = NULL;
-	return -ENOMEM;
+	return err;
 }
 
 
@@ -353,7 +356,8 @@ static void squashfs_put_super(struct super_block *sb)
 		kfree(sbi->id_table);
 		kfree(sbi->fragment_index);
 		kfree(sbi->meta_index);
-		kfree(sb->s_fs_info);
+		sbi->backend->kill(sbi);
+		kfree(sbi);
 		sb->s_fs_info = NULL;
 	}
 
@@ -361,15 +365,6 @@ static void squashfs_put_super(struct super_block *sb)
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
 
 
@@ -442,8 +437,8 @@ static void squashfs_destroy_inode(struct inode *inode)
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
1.5.6.5


>From 32d8c56b48b79a37a2b8204c1a14767287ea6044 Mon Sep 17 00:00:00 2001
From: Ferenc Wagner <wferi@niif.hu>
Date: Sun, 21 Mar 2010 02:08:58 +0100
Subject: [PATCH] squashfs: read uncompressed blocks through the backend framework

Avoid double free on the temporary decompression hack-path; this may
leak buffer heads if decompression exits early.
---
 fs/squashfs/backend.h        |    4 +-
 fs/squashfs/bdev.c           |  191 ++++++++++++++++++++++++++++++++++++++----
 fs/squashfs/block.c          |  167 ++++++++-----------------------------
 fs/squashfs/lzma_wrapper.c   |    2 +
 fs/squashfs/squashfs_fs_sb.h |    2 -
 fs/squashfs/super.c          |    5 +-
 6 files changed, 216 insertions(+), 155 deletions(-)

diff --git a/fs/squashfs/backend.h b/fs/squashfs/backend.h
index 02c4bcd..308fe6d 100644
--- a/fs/squashfs/backend.h
+++ b/fs/squashfs/backend.h
@@ -4,9 +4,9 @@
 #include "squashfs_fs_sb.h"
 
 struct squashfs_backend {
-	void	*(*init)(struct squashfs_sb_info *, u64, size_t);
+	int	(*init)(struct super_block *, u64, int, int, u64 *, int *);
 	void	(*free)(struct squashfs_sb_info *);
-	ssize_t	(*read)(struct squashfs_sb_info *, void **, size_t);
+	int	(*read)(struct super_block *, void *, int);
 	int	(*probe)(struct file_system_type *, int, const char *,
 				void*, struct vfsmount *);
 	void    (*killsb)(struct super_block *);
diff --git a/fs/squashfs/bdev.c b/fs/squashfs/bdev.c
index 0ee09f8..497029b 100644
--- a/fs/squashfs/bdev.c
+++ b/fs/squashfs/bdev.c
@@ -8,47 +8,200 @@
 struct squashfs_bdev {
 	int devblksize;			/* FIXME: == s->s_blocksize(_bits)? */
 	unsigned short devblksize_log2;
-	size_t bytes_left;
+	int length;
+	int bytes_read;
 	struct buffer_head **bh;
 	int bh_index;			/* number of consumed buffer_heads */
 	int offset;			/* offset of next byte in buffer_head */
+	int b;				/* total number of buffer heads */
 };
 
-/* A backend is initialized for each SquashFS block read operation,
- * making further sequential reads possible from the block.
+/*
+ * Read the metadata block length, this is stored in the first two
+ * bytes of the metadata block.
  */
-static void *bdev_init(struct squashfs_sb_info *msblk, u64 index, size_t length)
+static struct buffer_head *get_block_length(struct super_block *sb,
+			u64 *cur_index, int *offset, int *length)
 {
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	struct squashfs_bdev *bdev = msblk->backend_data;
 	struct buffer_head *bh;
 
+	TRACE("get_block_length: cur_index=0x%llx, offset=%d\n",
+		(unsigned long long)*cur_index, *offset);
+	bh = sb_bread(sb, *cur_index);
+	if (bh == NULL)
+		return NULL;
+
+	if (bdev->devblksize - *offset == 1) {
+		*length = (unsigned char) bh->b_data[*offset];
+		put_bh(bh);
+		bh = sb_bread(sb, ++(*cur_index));
+		if (bh == NULL)
+			return NULL;
+		*length |= (unsigned char) bh->b_data[0] << 8;
+		*offset = 1;
+	} else {
+		*length = (unsigned char) bh->b_data[*offset] |
+			(unsigned char) bh->b_data[*offset + 1] << 8;
+		*offset += 2;
+	}
+
+	TRACE("get_block_length: length=%d, offset=%d\n", *length, *offset);
+	return bh;
+}
+
+/*
+ * Read a metadata block or datablock into memory.  Length is non-zero
+ * if a datablock is being read (the size is stored elsewhere in the
+ * filesystem), otherwise the length is obtained from the first two bytes of
+ * the metadata block.  A bit in the length field indicates if the block
+ * is stored uncompressed in the filesystem (usually because compression
+ * generated a larger block - this does occasionally happen with zlib).
+ */
+static int bdev_init(struct super_block *sb, u64 index, int length,
+			int srclength, u64 *next_index, int *compressed)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	struct squashfs_bdev *bdev = msblk->backend_data;
+	struct buffer_head **bh;
+	u64 cur_index;			/* sector of next byte */
+	int bytes;			/* number of bytes handled */
+	int b;				/* for counting buffer heads */
+
+	TRACE("Entering bdev_init: index=0x%llx, length=0x%x, srclength=%d\n",
+		index, length, srclength);
 	bh = kcalloc((max_t(int, msblk->block_size, SQUASHFS_METADATA_SIZE)
 		      >> bdev->devblksize_log2) + 1,
 		     sizeof(*bh), GFP_KERNEL);
-	if (!bh)
-		goto nomem;
+	if (bh == NULL)
+		return -ENOMEM;
+
+	bdev->offset = index & ((1 << bdev->devblksize_log2) - 1);
+	cur_index = index >> bdev->devblksize_log2;
+	if (length) { /* FIXME: this logic and the comment above should be pulled out! */
+		/*
+		 * Datablock.
+		 */
+		bytes = -bdev->offset;
+		*compressed = SQUASHFS_COMPRESSED_BLOCK(length);
+		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
+		if (next_index)
+			*next_index = index + length;
+
+		TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
+			index, *compressed ? "" : "un", length, srclength);
 
-	/* different preread for data blocks and metadata blocks */
+		if (length < 0 || length > srclength ||
+				(index + length) > msblk->bytes_used)
+			goto read_failure;
 
+		for (b = 0; bytes < length; b++, cur_index++) {
+			bh[b] = sb_getblk(sb, cur_index);
+			if (bh[b] == NULL)
+				goto block_release;
+			bytes += bdev->devblksize;
+		}
+		ll_rw_block(READ, b, bh);
+	} else {
+		/*
+		 * Metadata block.
+		 */
+		if ((index + 2) > msblk->bytes_used)
+			goto read_failure;
+
+		bh[0] = get_block_length(sb, &cur_index, &bdev->offset, &length);
+		if (bh[0] == NULL)
+			goto read_failure;
+		b = 1;
+
+		bytes = bdev->devblksize - bdev->offset;
+		*compressed = SQUASHFS_COMPRESSED(length);
+		length = SQUASHFS_COMPRESSED_SIZE(length);
+		if (next_index)
+			*next_index = index + length + 2;
+
+		TRACE("Block @ 0x%llx, %scompressed size %d\n", index,
+				*compressed ? "" : "un", length);
+
+		if (length < 0 || length > srclength ||
+					(index + length) > msblk->bytes_used)
+			goto block_release;
+
+		for (; bytes < length; b++) {
+			bh[b] = sb_getblk(sb, ++cur_index);
+			if (bh[b] == NULL)
+				goto block_release;
+			bytes += bdev->devblksize;
+		}
+		ll_rw_block(READ, b - 1, bh + 1);
+	}
+
+	bdev->bh = bh;
+	bdev->length = length;
+	bdev->bytes_read = 0;
+	bdev->b = b;
 	bdev->bh_index = 0;
-	bdev->bytes_left = length;
-	return bdev;
+	TRACE("bdev_init: allocated %d buffer heads at %p, returning length=%d",
+	      b, bh, length);
+	return length;
 
-nomem:
-	ERROR("failed to allocate buffer_heads\n");
-	return NULL;
+block_release:
+	while (b--)
+		put_bh(bh[b]);
+read_failure:
+	ERROR("bdev_init failed to read block 0x%llx\n",
+					(unsigned long long) index);
+	kfree(bh);
+	return -EIO;
 }
 
 static void bdev_free(struct squashfs_sb_info *msblk)
 {
 	struct squashfs_bdev *bdev = msblk->backend_data;
+
+	TRACE("bdev_free: bh=%p, bh_index=%d, b=%d\n",
+		bdev->bh, bdev->bh_index, bdev->b);
+	while (bdev->bh_index < bdev->b)
+		put_bh(bdev->bh[bdev->bh_index++]);
 	kfree(bdev->bh);
-	bdev->bh = 0; /* FIXME: to make bdev_kill universal (see there) */
+	bdev->bh = NULL;
 }
 
-static ssize_t bdev_read(struct squashfs_sb_info *msblk, void **buf, size_t len)
+static int bdev_read(struct super_block *sb, void *buf, int len)
 {
-	return -ENOSYS;
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	struct squashfs_bdev *bdev = msblk->backend_data;
+	struct buffer_head *bh = bdev->bh[bdev->bh_index];
+	int in_block = bdev->devblksize - bdev->offset;
+
+	TRACE("bdev_read: buf=%p, len=%d, length=%d, bytes_read=%d, in_block=%d, bh_index=%d, offset=%d\n",
+	      buf, len, bdev->length, bdev->bytes_read, in_block, bdev->bh_index, bdev->offset);
+	if (bdev->bytes_read == bdev->length) /* EOF */
+		return 0;
+	if (bdev->bytes_read + len > bdev->length)
+		len = bdev->length - bdev->bytes_read;
+	if (bdev->bytes_read == 0 || bdev->offset == 0) {
+		TRACE("bdev_read: wait_on_buffer %d\n", bdev->bh_index);
+		wait_on_buffer(bh);
+		if (!buffer_uptodate(bh))
+			return -EIO;
+	}
+	if (len < in_block) {
+		TRACE("bdev_read: copying %d bytes", len);
+		memcpy(buf, bh->b_data + bdev->offset, len);
+		bdev->offset += len;
+		bdev->bytes_read += len;
+		return len;
+	} else {
+		TRACE("bdev_read: copying %d bytes", in_block);
+		memcpy(buf, bh->b_data + bdev->offset, in_block);
+		put_bh(bh);
+		bdev->bh_index++;
+		bdev->offset = 0;
+		bdev->bytes_read += in_block;
+		return in_block;
+	}
 }
 
 static int add_bdev_backend(struct super_block *sb)
@@ -56,6 +209,7 @@ static int add_bdev_backend(struct super_block *sb)
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	struct squashfs_bdev *bdev = kzalloc(sizeof(*bdev), GFP_KERNEL);
 
+	TRACE("add_bdev_backend\n");
 	if (!bdev)
 		return -ENOMEM;
 
@@ -83,9 +237,12 @@ static int bdev_probe(struct file_system_type *fs_type, int flags,
 static void bdev_kill(struct squashfs_sb_info *msblk)
 {
 	struct squashfs_bdev *bdev = msblk->backend_data;
+
+	TRACE("bdev_kill: bdev=%p\n", bdev);
 	if (bdev) {
-		kfree(bdev->bh); /* FIXME: can this be nonzero? cf. bdev_free */
+		bdev_free(msblk);
 		kfree(bdev);
+		bdev = NULL;
 	}
 }
 
@@ -105,7 +262,7 @@ const struct squashfs_backend squashfs_bdev_ops = {
 	.read	= bdev_read,
 	.probe	= bdev_probe,
 	.killsb	= kill_block_super,
-	.kill	= bdev_kill,
+	.kill	= bdev_kill, /* FIXME: is this needed at all? */
 	.size	= bdev_size,
 	.devname= bdev_devname
 };
diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 6f9914d..8787aac 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -37,37 +37,19 @@
 #include "squashfs_fs_i.h"
 #include "squashfs.h"
 #include "decompressor.h"
-/*
- * Read the metadata block length, this is stored in the first two
- * bytes of the metadata block.
- */
-static struct buffer_head *get_block_length(struct super_block *sb,
-			u64 *cur_index, int *offset, int *length)
-{
-	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	struct buffer_head *bh;
-
-	bh = sb_bread(sb, *cur_index);
-	if (bh == NULL)
-		return NULL;
-
-	if (msblk->devblksize - *offset == 1) {
-		*length = (unsigned char) bh->b_data[*offset];
-		put_bh(bh);
-		bh = sb_bread(sb, ++(*cur_index));
-		if (bh == NULL)
-			return NULL;
-		*length |= (unsigned char) bh->b_data[0] << 8;
-		*offset = 1;
-	} else {
-		*length = (unsigned char) bh->b_data[*offset] |
-			(unsigned char) bh->b_data[*offset + 1] << 8;
-		*offset += 2;
-	}
-
-	return bh;
-}
-
+#include "backend.h"
+
+/* FIXME: here for a temporary cheat only */
+struct squashfs_bdev {
+	int devblksize;			/* FIXME: == s->s_blocksize(_bits)? */
+	unsigned short devblksize_log2;
+	int length;
+	int bytes_read;
+	struct buffer_head **bh;
+	int bh_index;			/* number of consumed buffer_heads */
+	int offset;			/* offset of next byte in buffer_head */
+	int b;				/* total number of buffer heads */
+};
 
 /*
  * Read and decompress a metadata block or datablock.  Length is non-zero
@@ -80,124 +62,47 @@ static struct buffer_head *get_block_length(struct super_block *sb,
 int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 			int length, u64 *next_index, int srclength, int pages)
 {
+	int compressed;
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	struct buffer_head **bh;
-	int offset = index & ((1 << msblk->devblksize_log2) - 1);
-	u64 cur_index = index >> msblk->devblksize_log2;
-	int bytes, compressed, b = 0, k = 0, page = 0, avail;
-
-
-	bh = kcalloc((msblk->block_size >> msblk->devblksize_log2) + 1,
-				sizeof(*bh), GFP_KERNEL);
-	if (bh == NULL)
-		return -ENOMEM;
-
-	if (length) {
-		/*
-		 * Datablock.
-		 */
-		bytes = -offset;
-		compressed = SQUASHFS_COMPRESSED_BLOCK(length);
-		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
-		if (next_index)
-			*next_index = index + length;
-
-		TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
-			index, compressed ? "" : "un", length, srclength);
 
-		if (length < 0 || length > srclength ||
-				(index + length) > msblk->bytes_used)
-			goto read_failure;
-
-		for (b = 0; bytes < length; b++, cur_index++) {
-			bh[b] = sb_getblk(sb, cur_index);
-			if (bh[b] == NULL)
-				goto block_release;
-			bytes += msblk->devblksize;
-		}
-		ll_rw_block(READ, b, bh);
-	} else {
-		/*
-		 * Metadata block.
-		 */
-		if ((index + 2) > msblk->bytes_used)
-			goto read_failure;
-
-		bh[0] = get_block_length(sb, &cur_index, &offset, &length);
-		if (bh[0] == NULL)
-			goto read_failure;
-		b = 1;
-
-		bytes = msblk->devblksize - offset;
-		compressed = SQUASHFS_COMPRESSED(length);
-		length = SQUASHFS_COMPRESSED_SIZE(length);
-		if (next_index)
-			*next_index = index + length + 2;
-
-		TRACE("Block @ 0x%llx, %scompressed size %d\n", index,
-				compressed ? "" : "un", length);
-
-		if (length < 0 || length > srclength ||
-					(index + length) > msblk->bytes_used)
-			goto block_release;
-
-		for (; bytes < length; b++) {
-			bh[b] = sb_getblk(sb, ++cur_index);
-			if (bh[b] == NULL)
-				goto block_release;
-			bytes += msblk->devblksize;
-		}
-		ll_rw_block(READ, b - 1, bh + 1);
-	}
+	length = msblk->backend->init(sb, index, length, srclength,
+					next_index, &compressed);
+	if (length < 0)
+		return length;
 
 	if (compressed) {
-		length = squashfs_decompress(msblk, buffer, bh, b, offset,
-			length, srclength, pages);
+		struct squashfs_bdev *bdev = msblk->backend_data;
+		length = squashfs_decompress(msblk, buffer, bdev->bh, bdev->b,
+				bdev->offset, length, srclength, pages);
+		bdev->bh_index = bdev->b; /* temporary hack to avoid double free */
 		if (length < 0)
 			goto read_failure;
 	} else {
 		/*
 		 * Block is uncompressed.
 		 */
-		int i, in, pg_offset = 0;
-
-		for (i = 0; i < b; i++) {
-			wait_on_buffer(bh[i]);
-			if (!buffer_uptodate(bh[i]))
-				goto block_release;
-		}
-
-		for (bytes = length; k < b; k++) {
-			in = min(bytes, msblk->devblksize - offset);
-			bytes -= in;
-			while (in) {
-				if (pg_offset == PAGE_CACHE_SIZE) {
-					page++;
-					pg_offset = 0;
-				}
-				avail = min_t(int, in, PAGE_CACHE_SIZE -
-						pg_offset);
-				memcpy(buffer[page] + pg_offset,
-						bh[k]->b_data + offset, avail);
-				in -= avail;
-				pg_offset += avail;
-				offset += avail;
+		int read, page = 0, pg_offset = 0;
+
+		while ((read = msblk->backend->read(sb, buffer[page] + pg_offset,
+						PAGE_CACHE_SIZE - pg_offset))) {
+			if (read < 0)
+				goto read_failure;
+			TRACE("copied %d bytes\n", read);
+			pg_offset += read;
+			if (pg_offset == PAGE_CACHE_SIZE) {
+				page++;
+				pg_offset = 0;
 			}
-			offset = 0;
-			put_bh(bh[k]);
 		}
 	}
 
-	kfree(bh);
+	msblk->backend->free(msblk);
+	TRACE("squashfs_read_data: returning length=%d\n", length);
 	return length;
 
-block_release:
-	for (; k < b; k++)
-		put_bh(bh[k]);
-
 read_failure:
 	ERROR("squashfs_read_data failed to read block 0x%llx\n",
 					(unsigned long long) index);
-	kfree(bh);
+	msblk->backend->free(msblk);
 	return -EIO;
 }
diff --git a/fs/squashfs/lzma_wrapper.c b/fs/squashfs/lzma_wrapper.c
index 9fa617d..439798f 100644
--- a/fs/squashfs/lzma_wrapper.c
+++ b/fs/squashfs/lzma_wrapper.c
@@ -94,6 +94,8 @@ static int lzma_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 	void *buff = stream->input;
 	int avail, i, bytes = length, res;
 
+	TRACE("lzma_uncompress: bh=%p, b=%d, offset=%d, length=%d, srclength=%d,"
+		" pages=%d\n", bh, b, offset, length, srclength, pages);
 	mutex_lock(&lzma_mutex);
 
 	for (i = 0; i < b; i++) {
diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
index 5662d9b..87958fc 100644
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -55,8 +55,6 @@ struct squashfs_sb_info {
 	const struct squashfs_decompressor	*decompressor;
 	const struct squashfs_backend		*backend;
 	void					*backend_data;
-	int					devblksize;
-	int					devblksize_log2;
 	struct squashfs_cache			*block_cache;
 	struct squashfs_cache			*fragment_cache;
 	struct squashfs_cache			*read_page;
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 710179f..cb561bf 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -87,7 +87,7 @@ int squashfs_fill_super(struct super_block *sb, void *data, int silent,
 	u64 lookup_table_start;
 	int err;
 
-	TRACE("Entered squashfs_fill_superblock\n");
+	TRACE("Entered squashfs_fill_superblock, silent=%d\n", silent);
 
 	sb->s_fs_info = kzalloc(sizeof(*msblk), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
@@ -103,8 +103,6 @@ int squashfs_fill_super(struct super_block *sb, void *data, int silent,
 		goto free_msblk;
 	}
 
-	msblk->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
-	msblk->devblksize_log2 = ffz(~msblk->devblksize);
 	err = add_backend(sb);
 	if (err)
 		goto free_sblk;
@@ -305,6 +303,7 @@ failed_mount:
 	kfree(msblk->inode_lookup_table); /* FIXME: squashfs_put_super has meta_index instead */
 	kfree(msblk->fragment_index);
 	kfree(msblk->id_table);
+	TRACE("squasfs_fill_super: killing backend, err=%d\n", err);
 	msblk->backend->kill(msblk);
 free_sblk:
 	kfree(sblk);
-- 
1.5.6.5


>From 7bad4e58afdc8c5e21dafcd538a1390e30176b0a Mon Sep 17 00:00:00 2001
From: Ferenc Wagner <wferi@niif.hu>
Date: Sun, 21 Mar 2010 22:38:00 +0100
Subject: [PATCH] squashfs: move the decompressors to the backend framework

---
 fs/squashfs/block.c        |   17 +----------------
 fs/squashfs/decompressor.h |   12 +++++-------
 fs/squashfs/lzma_wrapper.c |   27 +++++++++------------------
 fs/squashfs/zlib_wrapper.c |   44 ++++++++++++++++++--------------------------
 4 files changed, 33 insertions(+), 67 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 8787aac..1c85063 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -39,18 +39,6 @@
 #include "decompressor.h"
 #include "backend.h"
 
-/* FIXME: here for a temporary cheat only */
-struct squashfs_bdev {
-	int devblksize;			/* FIXME: == s->s_blocksize(_bits)? */
-	unsigned short devblksize_log2;
-	int length;
-	int bytes_read;
-	struct buffer_head **bh;
-	int bh_index;			/* number of consumed buffer_heads */
-	int offset;			/* offset of next byte in buffer_head */
-	int b;				/* total number of buffer heads */
-};
-
 /*
  * Read and decompress a metadata block or datablock.  Length is non-zero
  * if a datablock is being read (the size is stored elsewhere in the
@@ -71,10 +59,7 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 		return length;
 
 	if (compressed) {
-		struct squashfs_bdev *bdev = msblk->backend_data;
-		length = squashfs_decompress(msblk, buffer, bdev->bh, bdev->b,
-				bdev->offset, length, srclength, pages);
-		bdev->bh_index = bdev->b; /* temporary hack to avoid double free */
+		length = squashfs_decompress(sb, buffer, length, pages);
 		if (length < 0)
 			goto read_failure;
 	} else {
diff --git a/fs/squashfs/decompressor.h b/fs/squashfs/decompressor.h
index 7425f80..06b4233 100644
--- a/fs/squashfs/decompressor.h
+++ b/fs/squashfs/decompressor.h
@@ -26,8 +26,7 @@
 struct squashfs_decompressor {
 	void	*(*init)(struct squashfs_sb_info *);
 	void	(*free)(void *);
-	int	(*decompress)(struct squashfs_sb_info *, void **,
-		struct buffer_head **, int, int, int, int, int);
+	int	(*decompress)(struct super_block *, void **, int, int);
 	int	id;
 	char	*name;
 	int	supported;
@@ -45,11 +44,10 @@ static inline void squashfs_decompressor_free(struct squashfs_sb_info *msblk,
 		msblk->decompressor->free(s);
 }
 
-static inline int squashfs_decompress(struct squashfs_sb_info *msblk,
-	void **buffer, struct buffer_head **bh, int b, int offset, int length,
-	int srclength, int pages)
+static inline int squashfs_decompress(struct super_block *sb,
+	void **buffer, int length, int pages)
 {
-	return msblk->decompressor->decompress(msblk, buffer, bh, b, offset,
-		length, srclength, pages);
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	return msblk->decompressor->decompress(sb, buffer, length, pages);
 }
 #endif
diff --git a/fs/squashfs/lzma_wrapper.c b/fs/squashfs/lzma_wrapper.c
index 439798f..da571ce 100644
--- a/fs/squashfs/lzma_wrapper.c
+++ b/fs/squashfs/lzma_wrapper.c
@@ -32,6 +32,7 @@
 #include "squashfs_fs_i.h"
 #include "squashfs.h"
 #include "decompressor.h"
+#include "backend.h"
 
 struct squashfs_lzma {
 	void	*input;
@@ -86,29 +87,23 @@ static void lzma_free(void *strm)
 }
 
 
-static int lzma_uncompress(struct squashfs_sb_info *msblk, void **buffer,
-	struct buffer_head **bh, int b, int offset, int length, int srclength,
-	int pages)
+static int lzma_uncompress(struct super_block *sb, void **buffer,
+			   int length, int pages)
 {
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	struct squashfs_lzma *stream = msblk->stream;
 	void *buff = stream->input;
 	int avail, i, bytes = length, res;
 
-	TRACE("lzma_uncompress: bh=%p, b=%d, offset=%d, length=%d, srclength=%d,"
-		" pages=%d\n", bh, b, offset, length, srclength, pages);
+	TRACE("lzma_uncompress: length=%d, pages=%d\n", length, pages);
 	mutex_lock(&lzma_mutex);
 
-	for (i = 0; i < b; i++) {
-		wait_on_buffer(bh[i]);
-		if (!buffer_uptodate(bh[i]))
-			goto block_release;
-
-		avail = min(bytes, msblk->devblksize - offset);
-		memcpy(buff, bh[i]->b_data + offset, avail);
+	while ((avail = msblk->backend->read(sb, buff, length))) {
+		if (avail < 0)
+			goto failed;
+		TRACE("read %d bytes\n", avail);
 		buff += avail;
 		bytes -= avail;
-		offset = 0;
-		put_bh(bh[i]);
 	}
 
 	lzma_error = 0;
@@ -131,10 +126,6 @@ static int lzma_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 	mutex_unlock(&lzma_mutex);
 	return res;
 
-block_release:
-	for (; i < b; i++)
-		put_bh(bh[i]);
-
 failed:
 	mutex_unlock(&lzma_mutex);
 
diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
index 4dd70e0..70c7571 100644
--- a/fs/squashfs/zlib_wrapper.c
+++ b/fs/squashfs/zlib_wrapper.c
@@ -31,6 +31,7 @@
 #include "squashfs_fs_i.h"
 #include "squashfs.h"
 #include "decompressor.h"
+#include "backend.h"
 
 static void *zlib_init(struct squashfs_sb_info *dummy)
 {
@@ -61,13 +62,18 @@ static void zlib_free(void *strm)
 }
 
 
-static int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
-	struct buffer_head **bh, int b, int offset, int length, int srclength,
-	int pages)
+static int zlib_uncompress(struct super_block *sb, void **buffer,
+	int length, int pages)
 {
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	int zlib_err = 0, zlib_init = 0;
-	int avail, bytes, k = 0, page = 0;
+	int bytes, page = 0;
 	z_stream *stream = msblk->stream;
+	/* Copying is required by the backend interface for now. */
+	void *input = kmalloc (PAGE_CACHE_SIZE, GFP_KERNEL);
+
+	if (!input)
+		return -ENOMEM;
 
 	mutex_lock(&msblk->read_data_mutex);
 
@@ -76,22 +82,13 @@ static int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 
 	bytes = length;
 	do {
-		if (stream->avail_in == 0 && k < b) {
-			avail = min(bytes, msblk->devblksize - offset);
-			bytes -= avail;
-			wait_on_buffer(bh[k]);
-			if (!buffer_uptodate(bh[k]))
+		if (stream->avail_in == 0) {
+			stream->avail_in = msblk->backend->read(sb, input, PAGE_CACHE_SIZE);
+			if (!stream->avail_in) {
+				ERROR("unexpected end of input\n");
 				goto release_mutex;
-
-			if (avail == 0) {
-				offset = 0;
-				put_bh(bh[k++]);
-				continue;
 			}
-
-			stream->next_in = bh[k]->b_data + offset;
-			stream->avail_in = avail;
-			offset = 0;
+			stream->next_in = input;
 		}
 
 		if (stream->avail_out == 0 && page < pages) {
@@ -103,8 +100,7 @@ static int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 			zlib_err = zlib_inflateInit(stream);
 			if (zlib_err != Z_OK) {
 				ERROR("zlib_inflateInit returned unexpected "
-					"result 0x%x, srclength %d\n",
-					zlib_err, srclength);
+					"result 0x%x\n", zlib_err);
 				goto release_mutex;
 			}
 			zlib_init = 1;
@@ -112,8 +108,6 @@ static int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 
 		zlib_err = zlib_inflate(stream, Z_SYNC_FLUSH);
 
-		if (stream->avail_in == 0 && k < b)
-			put_bh(bh[k++]);
 	} while (zlib_err == Z_OK);
 
 	if (zlib_err != Z_STREAM_END) {
@@ -128,14 +122,12 @@ static int zlib_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 	}
 
 	mutex_unlock(&msblk->read_data_mutex);
+	kfree(input);
 	return stream->total_out;
 
 release_mutex:
 	mutex_unlock(&msblk->read_data_mutex);
-
-	for (; k < b; k++)
-		put_bh(bh[k]);
-
+	kfree(input);
 	return -EIO;
 }
 
-- 
1.5.6.5


>From 9cb2a2373ab4b7a5519c5a2ef816894e28778196 Mon Sep 17 00:00:00 2001
From: Ferenc Wagner <wferi@niif.hu>
Date: Tue, 23 Mar 2010 02:21:27 +0100
Subject: [PATCH] squashfs: add mtd backend

---
 fs/squashfs/Kconfig    |    2 +-
 fs/squashfs/Makefile   |    1 +
 fs/squashfs/backend.c  |    3 +
 fs/squashfs/mtd.c      |  167 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/squashfs.h |    3 +
 5 files changed, 175 insertions(+), 1 deletions(-)
 create mode 100644 fs/squashfs/mtd.c

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index 7ec5d7e..6849e70 100644
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
index 0f02891..b6dd60e 100644
--- a/fs/squashfs/Makefile
+++ b/fs/squashfs/Makefile
@@ -7,3 +7,4 @@ squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
 squashfs-y += namei.o super.o symlink.o zlib_wrapper.o decompressor.o backend.o
 squashfs-$(CONFIG_SQUASHFS_LZMA) += lzma_wrapper.o
 squashfs-$(CONFIG_BLOCK) += bdev.o
+squashfs-$(CONFIG_MTD) += mtd.o
diff --git a/fs/squashfs/backend.c b/fs/squashfs/backend.c
index 49fa6fa..56037e3 100644
--- a/fs/squashfs/backend.c
+++ b/fs/squashfs/backend.c
@@ -8,6 +8,9 @@ const struct squashfs_backend *backends[] = {
 #ifdef CONFIG_BLOCK
 	&squashfs_bdev_ops,
 #endif
+#ifdef CONFIG_MTD
+	&squashfs_mtd_ops,
+#endif
 	NULL
 };
 
diff --git a/fs/squashfs/mtd.c b/fs/squashfs/mtd.c
new file mode 100644
index 0000000..c9ba361
--- /dev/null
+++ b/fs/squashfs/mtd.c
@@ -0,0 +1,167 @@
+#include <linux/fs.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/super.h>
+
+#include "squashfs_fs_i.h"
+#include "squashfs.h"
+#include "backend.h"
+
+struct squashfs_mtd {
+	u64 index;
+	int length;
+	int bytes_read;
+};
+
+static int checked_mtd_read(struct super_block *sb, u64 index, int length,
+			    void *buf)
+{
+	struct mtd_info *mi = sb->s_mtd;
+	int ret, retlen;
+
+	TRACE("Entering checked_mtd_read: index=0x%llx, length=%d\n",
+	      index, length);
+	ret = mi->read(mi, index, length, &retlen, buf);
+	if (ret) {
+		if (ret != -EUCLEAN && ret != -EBADMSG) {
+			ERROR("checked_mtd_read(index=0x%llx, length=%d): %d\n",
+			      index, length, ret);
+			return ret;
+		} else
+			WARNING("checked_mtd_read(index=0x%llx, length=%d): "
+				"recoverable error %d\n", index, length, ret);
+	}
+	if (retlen != length) {
+		ERROR("checked_mtd_read(index=0x%llx, length=%d) short read: %d\n",
+		      index, length, retlen);
+		return -EIO;
+	}
+	return 0;
+}
+
+static int mtd_init(struct super_block *sb, u64 index, int length,
+		    int srclength, u64 *next_index, int *compressed)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	struct squashfs_mtd *mtd = msblk->backend_data;
+
+	TRACE("Entering mtd_init: index=0x%llx, length=0x%x, srclength=%d\n",
+		index, length, srclength);
+
+	if (length) { /* datablock */
+		*compressed = SQUASHFS_COMPRESSED_BLOCK(length);
+		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
+		if (next_index)
+			*next_index = index + length;
+		TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
+			index, *compressed ? "" : "un", length, srclength);
+	} else { /* metadata block */
+		u16 metalen;
+		if ((index + 2) > msblk->bytes_used)
+			goto read_failure;
+		if (checked_mtd_read(sb, index, 2, &metalen))
+			goto read_failure;
+		length = le16_to_cpu(metalen);
+		*compressed = SQUASHFS_COMPRESSED(length);
+		length = SQUASHFS_COMPRESSED_SIZE(length);
+		if (next_index)
+			*next_index = index + length + 2;
+		TRACE("Block @ 0x%llx, %scompressed size %d\n", index,
+				*compressed ? "" : "un", length);
+		index += 2;
+	}
+	if (length < 0 || length > srclength ||
+			(index + length) > msblk->bytes_used)
+		goto read_failure;
+
+	mtd->index = index;
+	mtd->length = length;
+	mtd->bytes_read = 0;
+	return length;
+
+read_failure:
+	ERROR("mtd_init failed to read block 0x%llx\n",
+					(unsigned long long) index);
+	return -EIO;
+}
+
+static void mtd_free(struct squashfs_sb_info *msblk)
+{
+	TRACE("mtd_free: no op\n");
+}
+
+static int mtd_read(struct super_block *sb, void *buf, int len)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	struct squashfs_mtd *mtd = msblk->backend_data;
+	int err;
+
+	TRACE("mtd_read: buf=%p, len=%d, length=%d, bytes_read=%d\n",
+	      buf, len, mtd->length, mtd->bytes_read);
+
+	if (mtd->bytes_read == mtd->length) /* EOF */
+		return 0;
+	if (mtd->bytes_read + len > mtd->length)
+		len = mtd->length - mtd->bytes_read;
+	TRACE("mtd_read: copying %d bytes", len);
+	err = checked_mtd_read(sb, mtd->index + mtd->bytes_read, len, buf);
+	if (err)
+		return err;
+	mtd->bytes_read += len;
+	return len;
+}
+
+static int add_mtd_backend(struct super_block *sb)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	struct squashfs_mtd *mtd = kzalloc(sizeof(*mtd), GFP_KERNEL);
+
+	TRACE("add_mtd_backend\n");
+	if (!mtd)
+		return -ENOMEM;
+
+	msblk->backend = &squashfs_mtd_ops;
+	msblk->backend_data = mtd;
+	return 0;
+}
+
+static int fill_mtd_super(struct super_block *sb, void *data, int silent)
+{
+	return squashfs_fill_super(sb, data, silent, add_mtd_backend);
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
+	TRACE("mtd_kill: mtd=%p\n", msblk->backend_data);
+	mtd_free(msblk);
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
+	.killsb = kill_mtd_super,
+	.kill	= mtd_kill,
+	.size	= mtd_size,
+	.devname= mtd_devname
+};
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index 24c4b9e..fc3a57a 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -104,3 +104,6 @@ extern const struct squashfs_decompressor squashfs_lzma_comp_ops;
 
 /* bdev.c */
 extern const struct squashfs_backend squashfs_bdev_ops;
+
+/* mtd.c */
+extern const struct squashfs_backend squashfs_mtd_ops;
-- 
1.5.6.5


>From 294602c4fed7319aeb5c44fff5bb8649f1f37b6e Mon Sep 17 00:00:00 2001
From: Ferenc Wagner <wferi@niif.hu>
Date: Tue, 23 Mar 2010 10:21:40 +0100
Subject: [PATCH] squashfs: pull out common logic of backend init functions

---
 fs/squashfs/backend.h |    2 +-
 fs/squashfs/bdev.c    |  155 +++++++++----------------------------------------
 fs/squashfs/block.c   |   33 ++++++++++-
 fs/squashfs/mtd.c     |   38 +-----------
 4 files changed, 62 insertions(+), 166 deletions(-)

diff --git a/fs/squashfs/backend.h b/fs/squashfs/backend.h
index 308fe6d..5beba00 100644
--- a/fs/squashfs/backend.h
+++ b/fs/squashfs/backend.h
@@ -4,7 +4,7 @@
 #include "squashfs_fs_sb.h"
 
 struct squashfs_backend {
-	int	(*init)(struct super_block *, u64, int, int, u64 *, int *);
+	int	(*init)(struct super_block *, u64, int);
 	void	(*free)(struct squashfs_sb_info *);
 	int	(*read)(struct super_block *, void *, int);
 	int	(*probe)(struct file_system_type *, int, const char *,
diff --git a/fs/squashfs/bdev.c b/fs/squashfs/bdev.c
index 497029b..20065b7 100644
--- a/fs/squashfs/bdev.c
+++ b/fs/squashfs/bdev.c
@@ -16,156 +16,55 @@ struct squashfs_bdev {
 	int b;				/* total number of buffer heads */
 };
 
-/*
- * Read the metadata block length, this is stored in the first two
- * bytes of the metadata block.
- */
-static struct buffer_head *get_block_length(struct super_block *sb,
-			u64 *cur_index, int *offset, int *length)
+static void bdev_free(struct squashfs_sb_info *msblk)
 {
-	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	struct squashfs_bdev *bdev = msblk->backend_data;
-	struct buffer_head *bh;
-
-	TRACE("get_block_length: cur_index=0x%llx, offset=%d\n",
-		(unsigned long long)*cur_index, *offset);
-	bh = sb_bread(sb, *cur_index);
-	if (bh == NULL)
-		return NULL;
 
-	if (bdev->devblksize - *offset == 1) {
-		*length = (unsigned char) bh->b_data[*offset];
-		put_bh(bh);
-		bh = sb_bread(sb, ++(*cur_index));
-		if (bh == NULL)
-			return NULL;
-		*length |= (unsigned char) bh->b_data[0] << 8;
-		*offset = 1;
-	} else {
-		*length = (unsigned char) bh->b_data[*offset] |
-			(unsigned char) bh->b_data[*offset + 1] << 8;
-		*offset += 2;
-	}
-
-	TRACE("get_block_length: length=%d, offset=%d\n", *length, *offset);
-	return bh;
+	TRACE("bdev_free: bh=%p, bh_index=%d, b=%d\n",
+		bdev->bh, bdev->bh_index, bdev->b);
+	while (bdev->bh_index < bdev->b)
+		put_bh(bdev->bh[bdev->bh_index++]);
+	kfree(bdev->bh);
+	bdev->bh = NULL;
 }
 
-/*
- * Read a metadata block or datablock into memory.  Length is non-zero
- * if a datablock is being read (the size is stored elsewhere in the
- * filesystem), otherwise the length is obtained from the first two bytes of
- * the metadata block.  A bit in the length field indicates if the block
- * is stored uncompressed in the filesystem (usually because compression
- * generated a larger block - this does occasionally happen with zlib).
- */
-static int bdev_init(struct super_block *sb, u64 index, int length,
-			int srclength, u64 *next_index, int *compressed)
+static int bdev_init(struct super_block *sb, u64 index, int length)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	struct squashfs_bdev *bdev = msblk->backend_data;
-	struct buffer_head **bh;
 	u64 cur_index;			/* sector of next byte */
 	int bytes;			/* number of bytes handled */
-	int b;				/* for counting buffer heads */
 
-	TRACE("Entering bdev_init: index=0x%llx, length=0x%x, srclength=%d\n",
-		index, length, srclength);
-	bh = kcalloc((max_t(int, msblk->block_size, SQUASHFS_METADATA_SIZE)
-		      >> bdev->devblksize_log2) + 1,
-		     sizeof(*bh), GFP_KERNEL);
-	if (bh == NULL)
+	TRACE("Entering bdev_init: index=0x%llx, length=0x%x\n",
+		index, length);
+	bdev->bh = kcalloc((max_t(int, msblk->block_size, SQUASHFS_METADATA_SIZE)
+			    >> bdev->devblksize_log2) + 1,
+			   sizeof(*bdev->bh), GFP_KERNEL);
+	if (bdev->bh == NULL)
 		return -ENOMEM;
 
 	bdev->offset = index & ((1 << bdev->devblksize_log2) - 1);
 	cur_index = index >> bdev->devblksize_log2;
-	if (length) { /* FIXME: this logic and the comment above should be pulled out! */
-		/*
-		 * Datablock.
-		 */
-		bytes = -bdev->offset;
-		*compressed = SQUASHFS_COMPRESSED_BLOCK(length);
-		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
-		if (next_index)
-			*next_index = index + length;
-
-		TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
-			index, *compressed ? "" : "un", length, srclength);
-
-		if (length < 0 || length > srclength ||
-				(index + length) > msblk->bytes_used)
-			goto read_failure;
-
-		for (b = 0; bytes < length; b++, cur_index++) {
-			bh[b] = sb_getblk(sb, cur_index);
-			if (bh[b] == NULL)
-				goto block_release;
-			bytes += bdev->devblksize;
-		}
-		ll_rw_block(READ, b, bh);
-	} else {
-		/*
-		 * Metadata block.
-		 */
-		if ((index + 2) > msblk->bytes_used)
-			goto read_failure;
-
-		bh[0] = get_block_length(sb, &cur_index, &bdev->offset, &length);
-		if (bh[0] == NULL)
-			goto read_failure;
-		b = 1;
-
-		bytes = bdev->devblksize - bdev->offset;
-		*compressed = SQUASHFS_COMPRESSED(length);
-		length = SQUASHFS_COMPRESSED_SIZE(length);
-		if (next_index)
-			*next_index = index + length + 2;
 
-		TRACE("Block @ 0x%llx, %scompressed size %d\n", index,
-				*compressed ? "" : "un", length);
-
-		if (length < 0 || length > srclength ||
-					(index + length) > msblk->bytes_used)
-			goto block_release;
+	bdev->bh_index = 0;
+	bdev->length = length;
+	bdev->bytes_read = 0;
 
-		for (; bytes < length; b++) {
-			bh[b] = sb_getblk(sb, ++cur_index);
-			if (bh[b] == NULL)
-				goto block_release;
-			bytes += bdev->devblksize;
+	bytes = -bdev->offset;
+	for (bdev->b = 0; bytes < length; bdev->b++, cur_index++) {
+		if ((bdev->bh[bdev->b] = sb_getblk(sb, cur_index)) == NULL) {
+			ERROR("bdev_init failed to read block 0x%llx\n",
+			      (unsigned long long) index);
+			bdev_free(msblk);
+			return -EIO;
 		}
-		ll_rw_block(READ, b - 1, bh + 1);
+		bytes += bdev->devblksize;
 	}
+	ll_rw_block(READ, bdev->b, bdev->bh);
 
-	bdev->bh = bh;
-	bdev->length = length;
-	bdev->bytes_read = 0;
-	bdev->b = b;
-	bdev->bh_index = 0;
 	TRACE("bdev_init: allocated %d buffer heads at %p, returning length=%d",
-	      b, bh, length);
+	      bdev->b, bdev->bh, length);
 	return length;
-
-block_release:
-	while (b--)
-		put_bh(bh[b]);
-read_failure:
-	ERROR("bdev_init failed to read block 0x%llx\n",
-					(unsigned long long) index);
-	kfree(bh);
-	return -EIO;
-}
-
-static void bdev_free(struct squashfs_sb_info *msblk)
-{
-	struct squashfs_bdev *bdev = msblk->backend_data;
-
-	TRACE("bdev_free: bh=%p, bh_index=%d, b=%d\n",
-		bdev->bh, bdev->bh_index, bdev->b);
-	while (bdev->bh_index < bdev->b)
-		put_bh(bdev->bh[bdev->bh_index++]);
-	kfree(bdev->bh);
-	bdev->bh = NULL;
 }
 
 static int bdev_read(struct super_block *sb, void *buf, int len)
diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 1c85063..eb33770 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -53,8 +53,37 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 	int compressed;
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 
-	length = msblk->backend->init(sb, index, length, srclength,
-					next_index, &compressed);
+	if (length) { /* Data block */
+		compressed = SQUASHFS_COMPRESSED_BLOCK(length);
+		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
+		TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
+			index, compressed ? "" : "un", length, srclength);
+	} else { /* Metadata block */
+		int read;
+		u16 metalen;
+
+		length = msblk->backend->init(sb, index, 2);
+		if (length < 0)
+			return length;
+		read = msblk->backend->read(sb, &metalen, 2);
+		if (read != 2)
+			goto read_failure;
+		msblk->backend->free(msblk);
+		length = le16_to_cpu(metalen);
+		compressed = SQUASHFS_COMPRESSED(length);
+		length = SQUASHFS_COMPRESSED_SIZE(length);
+		index += 2;
+		TRACE("Block @ 0x%llx, %scompressed size %d\n", index,
+				compressed ? "" : "un", length);
+	}
+	if (length < 0 || length > srclength ||
+	    (index + length) > msblk->bytes_used)
+		goto read_failure;
+
+	if (next_index)
+		*next_index = index + length;
+
+	length = msblk->backend->init(sb, index, length);
 	if (length < 0)
 		return length;
 
diff --git a/fs/squashfs/mtd.c b/fs/squashfs/mtd.c
index c9ba361..99f2d35 100644
--- a/fs/squashfs/mtd.c
+++ b/fs/squashfs/mtd.c
@@ -38,50 +38,18 @@ static int checked_mtd_read(struct super_block *sb, u64 index, int length,
 	return 0;
 }
 
-static int mtd_init(struct super_block *sb, u64 index, int length,
-		    int srclength, u64 *next_index, int *compressed)
+static int mtd_init(struct super_block *sb, u64 index, int length)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	struct squashfs_mtd *mtd = msblk->backend_data;
 
-	TRACE("Entering mtd_init: index=0x%llx, length=0x%x, srclength=%d\n",
-		index, length, srclength);
-
-	if (length) { /* datablock */
-		*compressed = SQUASHFS_COMPRESSED_BLOCK(length);
-		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
-		if (next_index)
-			*next_index = index + length;
-		TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
-			index, *compressed ? "" : "un", length, srclength);
-	} else { /* metadata block */
-		u16 metalen;
-		if ((index + 2) > msblk->bytes_used)
-			goto read_failure;
-		if (checked_mtd_read(sb, index, 2, &metalen))
-			goto read_failure;
-		length = le16_to_cpu(metalen);
-		*compressed = SQUASHFS_COMPRESSED(length);
-		length = SQUASHFS_COMPRESSED_SIZE(length);
-		if (next_index)
-			*next_index = index + length + 2;
-		TRACE("Block @ 0x%llx, %scompressed size %d\n", index,
-				*compressed ? "" : "un", length);
-		index += 2;
-	}
-	if (length < 0 || length > srclength ||
-			(index + length) > msblk->bytes_used)
-		goto read_failure;
+	TRACE("Entering mtd_init: index=0x%llx, length=0x%x\n",
+		index, length);
 
 	mtd->index = index;
 	mtd->length = length;
 	mtd->bytes_read = 0;
 	return length;
-
-read_failure:
-	ERROR("mtd_init failed to read block 0x%llx\n",
-					(unsigned long long) index);
-	return -EIO;
 }
 
 static void mtd_free(struct squashfs_sb_info *msblk)
-- 
1.5.6.5


--=-=-=--
