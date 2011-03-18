Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1CRCEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 22:04:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58546 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716Ab1CRCEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 22:04:41 -0400
Date: Fri, 18 Mar 2011 11:04:33 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH v5] fat: Batched discard support for fat
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
Message-id: <20110318020433.GA27263@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 18 Mar 2011 02:04:37.0133 (UTC)
 FILETIME=[D551B3D0:01CBE510]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

FAT supports batched discard as ext4.

Cited from Lukas words.
"The current solution is not ideal because of its bad performance impact.
So basic idea to improve things is to avoid discarding every time some
blocks are freed. and instead batching is together into bigger trims,
which tends to be more effective."

You can find an information in detail at following URLs.
http://lwn.net/Articles/397538/
http://lwn.net/Articles/383933/

Clearify the meaning of "len" (Cited form Lukas mail)

Let the "O" be free (bytes, blocks, whatever), and "=" be used.
Now, we have a filesystem like this.

  OOOO==O===OO===OOOOO==O===O===OOOOOOO===
  ^                                      ^
  0                                      40

This is how it supposed to wotk if you have called FITIRM with parameters:

start = 0
minlen = 2
len = 20

So you will go through (blocks, bytes...) 0 -> 20

  OOOO==O===OO===OOOOO==O===O===OOOOOOO===
  ^                   ^
  0                   20

So, you will call discard on extents:

0-3
You'll skip 6 because is smaller than minlen
10-11
15-19

instead of 

0-3
10-11
15-19
30-36

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changelog v5:
	Exit when start cluster is grater than max cluster

Changelog v4:
	Simplify the exit condition

Changelog v3:
	Adjust the minlen from queue discard_granularity
	Use the corrent len usage
Changelog v2:
	Use the given start and len as Lukas comments
	Check the queue supports discard feature
---
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index f504089..08b53e1 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -299,6 +299,7 @@ extern int fat_alloc_clusters(struct inode *inode, int *cluster,
 			      int nr_cluster);
 extern int fat_free_clusters(struct inode *inode, int cluster);
 extern int fat_count_free_clusters(struct super_block *sb);
+extern int fat_trim_fs(struct super_block *sb, struct fstrim_range *range);
 
 /* fat/file.c */
 extern long fat_generic_ioctl(struct file *filp, unsigned int cmd,
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index b47d2c9..cc89ea6 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -1,6 +1,8 @@
 /*
  * Copyright (C) 2004, OGAWA Hirofumi
  * Released under GPL v2.
+ *
+ * Batched discard support by Kyungmin Park <kyungmin.park@samsung.com>
  */
 
 #include <linux/module.h>
@@ -541,6 +543,16 @@ out:
 	return err;
 }
 
+static int fat_issue_discard(struct super_block *sb, int cluster, int nr_clus)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	sector_t block, nr_blocks;
+
+	block = fat_clus_to_blknr(sbi, cluster);
+	nr_blocks = nr_clus * sbi->sec_per_clus;
+	return sb_issue_discard(sb, block, nr_blocks, GFP_NOFS, 0);
+}
+
 int fat_free_clusters(struct inode *inode, int cluster)
 {
 	struct super_block *sb = inode->i_sb;
@@ -575,11 +587,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
 			if (cluster != fatent.entry + 1) {
 				int nr_clus = fatent.entry - first_cl + 1;
 
-				sb_issue_discard(sb,
-					fat_clus_to_blknr(sbi, first_cl),
-					nr_clus * sbi->sec_per_clus,
-					GFP_NOFS, 0);
-
+				fat_issue_discard(sb, first_cl, nr_clus);
 				first_cl = cluster;
 			}
 		}
@@ -683,3 +691,86 @@ out:
 	unlock_fat(sbi);
 	return err;
 }
+
+int fat_trim_fs(struct super_block *sb, struct fstrim_range *range)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct fatent_operations *ops = sbi->fatent_ops;
+	struct fat_entry fatent;
+	unsigned long reada_blocks, reada_mask, cur_block;
+	int err, free, count, entry;
+	int start, len, minlen, trimmed;
+
+	start = range->start >> sb->s_blocksize_bits;
+	start = start / sbi->sec_per_clus;
+	len = range->len >> sb->s_blocksize_bits;
+	len = len / sbi->sec_per_clus;
+	minlen = range->minlen >> sb->s_blocksize_bits;
+	minlen = minlen / sbi->sec_per_clus;
+	trimmed = 0;
+	count = 0;
+	err = -EINVAL;
+
+	lock_fat(sbi);
+	if (sbi->free_clusters != -1 && sbi->free_clus_valid)
+		goto out;
+
+	if (start >= sbi->max_cluster)
+		goto out;
+
+	reada_blocks = FAT_READA_SIZE >> sb->s_blocksize_bits;
+	reada_mask = reada_blocks - 1;
+	cur_block = 0;
+
+	entry = 0;
+	free = 0;
+	fatent_init(&fatent);
+
+	if (start < FAT_START_ENT)
+		start = FAT_START_ENT;
+
+	fatent_set_entry(&fatent, start);
+
+	while (count < sbi->max_cluster) {
+		if (fatent.entry >= sbi->max_cluster)
+			fatent.entry = FAT_START_ENT;
+		/* readahead of fat blocks */
+		if ((cur_block & reada_mask) == 0) {
+			unsigned long rest = sbi->fat_length - cur_block;
+			fat_ent_reada(sb, &fatent, min(reada_blocks, rest));
+		}
+		cur_block++;
+
+		err = fat_ent_read_block(sb, &fatent);
+		if (err)
+			goto out;
+
+		do {
+			if (ops->ent_get(&fatent) == FAT_ENT_FREE) {
+				free++;
+				if (!entry)
+					entry = fatent.entry;
+			} else if (entry) {
+				if (free >= minlen) {
+					fat_issue_discard(sb, entry, free);
+					trimmed += free;
+				}
+				free = 0;
+				entry = 0;
+			}
+			count++;
+			if (count >= len)
+				goto done;
+		} while (fat_ent_next(sbi, &fatent));
+	}
+done:
+	if (free >= minlen) {
+		fat_issue_discard(sb, entry, free);
+		trimmed += free;
+	}
+	range->len = (trimmed * sbi->sec_per_clus) << sb->s_blocksize_bits;
+	fatent_brelse(&fatent);
+out:
+	unlock_fat(sbi);
+	return err;
+}
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 7257752..9910aba 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -125,6 +125,36 @@ long fat_generic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return fat_ioctl_get_attributes(inode, user_attr);
 	case FAT_IOCTL_SET_ATTRIBUTES:
 		return fat_ioctl_set_attributes(filp, user_attr);
+	case FITRIM:
+	{
+		struct super_block *sb = inode->i_sb;
+		struct request_queue *q = bdev_get_queue(sb->s_bdev);
+		struct fstrim_range range;
+		int ret = 0;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (!blk_queue_discard(q))
+			return -EOPNOTSUPP;
+
+		if (copy_from_user(&range, (struct fstrim_range *)arg,
+					sizeof(range)))
+			return -EFAULT;
+
+		range.minlen = max((unsigned int)range.minlen,
+					q->limits.discard_granularity);
+		ret = fat_trim_fs(sb, &range);
+		if (ret < 0)
+			return ret;
+
+		if (copy_to_user((struct fstrim_range *)arg, &range,
+					sizeof(range)))
+			return -EFAULT;
+
+		return 0;
+	}
+
 	default:
 		return -ENOTTY;	/* Inappropriate ioctl for device */
 	}
