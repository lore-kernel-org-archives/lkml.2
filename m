Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab2JMObP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 10:31:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55810 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2JMObN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 10:31:13 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH v2] fat: editions to support fat_fallocate()
Date: Sat, 13 Oct 2012 23:31:01 +0900
Message-Id: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement preallocation via the fallocate syscall on VFAT partitions.
This patch is based on an earlier patch of the same name which had some
issues detailed below and did not get accepted. Refer
https://lkml.org/lkml/2007/12/22/130.

a)The preallocated space was not persistent across remounts when the
FALLOC_FL_KEEP_SIZE flag was set. Also, writes to the file allocated new
clusters instead of using the preallocated area.

Consider the scenario:
mount-->preallocate space for a file --> unmount.
In the old patch,the preallocated space was not reflected for that
file (verified using the 'du' command).

This is now fixed with modifications to fat_fill_inode().

b)There was no need to zero out the clusters when the flag was set.

Instead of doing an expanding truncate, just allocate clusters and add
them to the fat chain. This reduces preallocation time.If the file is
seeked beyond the current file size(i_size) at the time of writing, zero
out the bytes from i_size to the seek point at write time.

Compatibility with windows:
There are no issues when FALLOC_FL_KEEP_SIZE is not set
because it just does an expanding truncate. Thus reading from the
preallocated area on windows returns null until data is written to it.

When a file with preallocated area using the FALLOC_FL_KEEP_SIZE was
written to on windows, the windows driver freed-up the preallocated
clusters and allocated new clusters for the new data. The freed up
clusters gets reflected in the free space available for the partition
which can be seen from the Volume properties.

The windows chkdsk tool also does not report any errors on a
disk containing files with preallocated space.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Ravishankar N <cyberax82@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/fat/file.c  |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fat/inode.c |   59 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 141 insertions(+)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index 1f81cb4..cae2eec 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -17,8 +17,11 @@
 #include <linux/blkdev.h>
 #include <linux/fsnotify.h>
 #include <linux/security.h>
+#include <linux/falloc.h>
 #include "fat.h"
 
+static long fat_fallocate(struct file *file, int mode,
+				loff_t offset, loff_t len);
 static int fat_ioctl_get_attributes(struct inode *inode, u32 __user *user_attr)
 {
 	u32 attr;
@@ -174,6 +177,7 @@ const struct file_operations fat_file_operations = {
 #endif
 	.fsync		= fat_file_fsync,
 	.splice_read	= generic_file_splice_read,
+	.fallocate      = fat_fallocate,
 };
 
 static int fat_cont_expand(struct inode *inode, loff_t size)
@@ -211,7 +215,85 @@ static int fat_cont_expand(struct inode *inode, loff_t size)
 out:
 	return err;
 }
+/*
+ * preallocate space for a file. This implements fat's fallocate file
+ * operation, which gets called from sys_fallocate system call. User
+ * space requests len bytes at offset.If FALLOC_FL_KEEP_SIZE is set
+ * we just allocate clusters without zeroing them out.Otherwise we
+ * allocate and zero out clusters via an expanding truncate.
+ */
+static long fat_fallocate(struct file *file, int mode,
+				loff_t offset, loff_t len)
+{
+	int err = 0;
+	struct inode *inode = file->f_mapping->host;
+	int cluster, nr_cluster, fclus, dclus, free_bytes, nr_bytes;
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
+	/* No support for hole punch or other fallocate flags. */
+	if (mode & ~FALLOC_FL_KEEP_SIZE)
+		return -EOPNOTSUPP;
+
+	if ((offset + len) <= MSDOS_I(inode)->mmu_private) {
+		fat_msg(sb, KERN_ERR,
+			"fat_fallocate():Blocks already allocated");
+		return -EINVAL;
+	}
+
+	if ((mode & FALLOC_FL_KEEP_SIZE)) {
+		/* First compute the number of clusters to be allocated */
+		if (inode->i_size > 0) {
+			err = fat_get_cluster(inode, FAT_ENT_EOF,
+					      &fclus, &dclus);
+			if (err < 0) {
+				fat_msg(sb, KERN_ERR,
+					"fat_fallocate():fat_get_cluster() error");
+				return err;
+			}
+			free_bytes = ((fclus+1) << sbi->cluster_bits)-
+				     (inode->i_size);
+			nr_bytes = (offset + len - inode->i_size) - free_bytes;
+		} else
+			nr_bytes = (offset + len - inode->i_size);
+		nr_cluster = (nr_bytes + (sbi->cluster_size - 1)) >>
+			     sbi->cluster_bits;
+		mutex_lock(&inode->i_mutex);
+		/* Start the allocation.We are not zeroing out the clusters */
+		while (nr_cluster-- > 0) {
+			err = fat_alloc_clusters(inode, &cluster, 1);
+			if (err) {
+				fat_msg(sb, KERN_ERR,
+					"fat_fallocate():fat_alloc_clusters() error");
+				goto error;
+			}
+			err = fat_chain_add(inode, cluster, 1);
+			if (err) {
+				fat_free_clusters(inode, cluster);
+				goto error;
+			}
+		}
+		/* update mmu_private to allow writing to allocated clusters */
+		err = fat_get_cluster(inode, FAT_ENT_EOF, &fclus, &dclus);
+		if (err < 0) {
+			fat_msg(sb, KERN_ERR,
+				"fat_fallocate():fat_get_cluster() error");
+			goto error;
+		}
+		MSDOS_I(inode)->mmu_private = (fclus + 1) << sbi->cluster_bits;
+	} else {
+		mutex_lock(&inode->i_mutex);
+		/* This is just an expanding truncate */
+		err = fat_cont_expand(inode, (offset + len));
+		if (err) {
+			fat_msg(sb, KERN_ERR,
+				"fat_fallocate():fat_cont_expand() error");
+		}
+	}
+error:
+	mutex_unlock(&inode->i_mutex);
+	return err;
+}
 /* Free all clusters after the skip'th cluster. */
 static int fat_free(struct inode *inode, int skip)
 {
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 80c6fdd..4a2d929 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -151,11 +151,58 @@ static void fat_write_failed(struct address_space *mapping, loff_t to)
 	}
 }
 
+static int fat_zero_falloc_area(struct file *file,
+				struct address_space *mapping, loff_t pos)
+{
+	struct page *page;
+	struct inode *inode = mapping->host;
+	loff_t curpos = inode->i_size;
+	size_t count = pos-curpos;
+	int err;
+	do {
+		unsigned offset, bytes;
+		void *fsdata;
+
+		offset = (curpos & (PAGE_CACHE_SIZE - 1));
+		bytes = PAGE_CACHE_SIZE - offset;
+		if (bytes > count)
+			bytes = count;
+
+		err = pagecache_write_begin(NULL, mapping, curpos, bytes,
+					AOP_FLAG_UNINTERRUPTIBLE,
+					&page, &fsdata);
+		if (err)
+			break;
+
+		zero_user(page, offset, bytes);
+
+		err = pagecache_write_end(NULL, mapping, curpos, bytes, bytes,
+					page, fsdata);
+		WARN_ON(err <= 0);
+		curpos += bytes;
+		count -= bytes;
+		err = 0;
+	} while (count);
+
+	return -err;
+}
+
 static int fat_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
 {
 	int err;
+	struct inode *inode = mapping->host;
+	struct super_block *sb = inode->i_sb;
+	loff_t mmu_private_actual = MSDOS_I(inode)->mmu_private;
+	loff_t mmu_private_ideal = (inode->i_size + (sb->s_blocksize-1)) &
+					 ~(sb->s_blocksize-1);
+
+	if ((mmu_private_actual > mmu_private_ideal) && (pos > inode->i_size)) {
+		err = fat_zero_falloc_area(file, mapping, pos);
+		if (err)
+			fat_msg(sb, KERN_ERR, "error zeroing fallocated area");
+	}
 
 	*pagep = NULL;
 	err = cont_write_begin(file, mapping, pos, len, flags,
@@ -422,6 +469,15 @@ static int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 		inode->i_op = &fat_file_inode_operations;
 		inode->i_fop = &fat_file_operations;
 		inode->i_mapping->a_ops = &fat_aops;
+		/*
+		 * calculate mmu_private and i_blocks from the actual number of
+		 * allocated clusters instead of doing it from file size.This
+		 * ensures that the preallocated disk space with
+		 * FALLOC_FL_KEEP_SIZE is persistent across remounts and writes
+		 * go into the preallocated clusters.Doing this changes i_size
+		 * which we restore below.
+		 */
+		fat_calc_dir_size(inode);
 		MSDOS_I(inode)->mmu_private = inode->i_size;
 	}
 	if (de->attr & ATTR_SYS) {
@@ -432,6 +488,9 @@ static int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 
 	inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
 			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
+	/* restore i_size */
+	if (!(de->attr & ATTR_DIR))
+		inode->i_size = le32_to_cpu(de->size);
 
 	fat_time_fat2unix(sbi, &inode->i_mtime, de->time, de->date, 0);
 	if (sbi->options.isvfat) {
-- 
1.7.9.5

