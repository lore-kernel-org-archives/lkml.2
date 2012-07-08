Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab2GHDHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 23:07:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59440 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab2GHDHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 23:07:53 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH] fat: Support fallocate on fat.
Date: Sat,  7 Jul 2012 23:07:39 -0400
Message-Id: <1341716859-6768-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement preallocation via the fallocate syscall on VFAT partitions.
This patch is based on an earlier patch of the same name which had some
issues detailed below and did not get accepted.
Refer https://lkml.org/lkml/2007/12/22/130.

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
them to the fat chain. This reduces preallocation time.

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
 fs/fat/file.c  |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fat/inode.c |   10 +++++++
 2 files changed, 95 insertions(+)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index a71fe37..faf3260 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -17,8 +17,12 @@
 #include <linux/blkdev.h>
 #include <linux/fsnotify.h>
 #include <linux/security.h>
+#include <linux/falloc.h>
 #include "fat.h"
 
+static long fat_fallocate(struct file *file, int mode,
+						loff_t offset, loff_t len);
+
 static int fat_ioctl_get_attributes(struct inode *inode, u32 __user *user_attr)
 {
 	u32 attr;
@@ -175,6 +179,7 @@ const struct file_operations fat_file_operations = {
 #endif
 	.fsync		= fat_file_fsync,
 	.splice_read	= generic_file_splice_read,
+	.fallocate		= fat_fallocate,
 };
 
 static int fat_cont_expand(struct inode *inode, loff_t size)
@@ -213,6 +218,86 @@ out:
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
+		loff_t offset, loff_t len)
+{
+	int err = 0;
+	struct inode *inode = file->f_mapping->host;
+	int cluster, nr_cluster, fclus, dclus, free_bytes, nr_bytes;
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+
+	/* No support for hole punch or other fallocate flags. */
+	if (mode & ~FALLOC_FL_KEEP_SIZE)
+		return -EOPNOTSUPP;
+
+	if ((offset + len) <= MSDOS_I(inode)->mmu_private) {
+		fat_msg(sb, KERN_ERR,
+				"fat_fallocate():Blocks already allocated");
+		return -EINVAL;
+	}
+
+	if ((mode & FALLOC_FL_KEEP_SIZE)) {
+		/* First compute the number of clusters to be allocated */
+		if (inode->i_size > 0) {
+			err = fat_get_cluster(inode, FAT_ENT_EOF,
+					&fclus, &dclus);
+			if (err < 0) {
+				fat_msg(sb, KERN_ERR,
+						"fat_fallocate():fat_get_cluster() error");
+				return err;
+			}
+			free_bytes = ((fclus+1) << sbi->cluster_bits) -
+				(inode->i_size);
+			nr_bytes = (offset + len - inode->i_size) - free_bytes;
+		} else
+			nr_bytes = (offset + len - inode->i_size);
+		nr_cluster = (nr_bytes + (sbi->cluster_size - 1)) >>
+			sbi->cluster_bits;
+		mutex_lock(&inode->i_mutex);
+		/* Start the allocation.We are not zeroing out the clusters */
+		while (nr_cluster-- > 0) {
+			err = fat_alloc_clusters(inode, &cluster, 1);
+			if (err) {
+				fat_msg(sb, KERN_ERR,
+						"fat_fallocate():fat_alloc_clusters() error");
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
+					"fat_fallocate():fat_get_cluster() error");
+			goto error;
+		}
+		MSDOS_I(inode)->mmu_private = (fclus + 1) << sbi->cluster_bits;
+	} else {
+		mutex_lock(&inode->i_mutex);
+		/* This is just an expanding truncate */
+		err = fat_cont_expand(inode, (offset + len));
+		if (err) {
+			fat_msg(sb, KERN_ERR,
+					"fat_fallocate():fat_cont_expand() error");
+		}
+	}
+error:
+	mutex_unlock(&inode->i_mutex);
+	return err;
+}
+
 /* Free all clusters after the skip'th cluster. */
 static int fat_free(struct inode *inode, int skip)
 {
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index fd8e47c..3453218 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -397,8 +397,18 @@ static int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 	}
 	fat_save_attrs(inode, de->attr);
 
+	/*
+	 * calculate i_blocks and mmu_private from the actual number of
+	 * allocated clusters instead of doing it from file size.This ensures
+	 * that the preallocated disk space using FALLOC_FL_KEEP_SIZE is
+	 * persistent across remounts and writes go into the allocated clusters.
+	 */
+	fat_calc_dir_size(inode);
 	inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
 			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
+	MSDOS_I(inode)->mmu_private = inode->i_size;
+	/* restore i_size */
+	inode->i_size = le32_to_cpu(de->size);
 
 	fat_time_fat2unix(sbi, &inode->i_mtime, de->time, de->date, 0);
 	if (sbi->options.isvfat) {
-- 
1.7.9.5

