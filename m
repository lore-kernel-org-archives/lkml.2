Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab2HRJn1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 05:43:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44563 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab2HRJnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 05:43:20 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 3/4] fat (exportfs): rebuild directory-inode if fat_dget()
Date: Sat, 18 Aug 2012 05:43:11 -0400
Message-Id: <1345282991-7637-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch enables rebuilding of directory inodes which are not present
in the cache.This is done by traversing the disk clusters to find the
directory entry of the parent directory and using its i_pos to build the
inode.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/nfs.c |  134 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 130 insertions(+), 4 deletions(-)

diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index 44678e4..a3685d6 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -97,6 +97,93 @@ struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
 }
 
 /*
+ * Read the directory entries of 'search_clus' and find the entry
+ * which contains 'match_ipos' for the starting cluster.If the entry
+ * is found, rebuild its inode.
+ */
+static struct inode *fat_traverse_cluster(struct super_block *sb,
+				int search_clus, int match_ipos)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct buffer_head *bh;
+	sector_t blknr;
+	int parent_ipos, search_ipos;
+	int i;
+	struct msdos_dir_entry *de;
+	struct inode *inode = NULL;
+	int iterations = sbi->cluster_size >> sb->s_blocksize_bits;
+	blknr = fat_clus_to_blknr(sbi, search_clus);
+
+	do {
+		bh = sb_bread(sb, blknr);
+		if (!bh) {
+			fat_msg(sb, KERN_ERR,
+				"unable to read block(%llu) while traversing cluster(%d)",
+				(llu)blknr, search_clus);
+			inode = ERR_PTR(-EIO);
+			goto out;
+		}
+		de = (struct msdos_dir_entry *)bh->b_data;
+		for (i = 0; i < sbi->dir_per_block; i++) {
+			if (de[i].name[0] == FAT_ENT_FREE) {
+				/*Reached end of directory*/
+				brelse(bh);
+				inode = ERR_PTR(-ENODATA);
+				goto out;
+			}
+			if (de[i].name[0] == DELETED_FLAG)
+				continue;
+			if (de[i].attr == ATTR_EXT)
+				continue;
+			if (!(de[i].attr & ATTR_DIR))
+				continue;
+			else {
+				search_ipos = fat_get_start(sbi, &de[i]);
+				if (search_ipos == match_ipos) {
+					/*Success.Now build the inode*/
+					parent_ipos = (loff_t)i +
+					 (blknr << sbi->dir_per_block_bits);
+					inode = fat_build_inode(sb, &de[i],
+								parent_ipos);
+					brelse(bh);
+					goto out;
+				}
+			}
+		}
+		brelse(bh);
+		blknr += 1;
+	} while (--iterations > 0);
+out:
+	return inode;
+}
+
+/*
+ * Read the FAT to find the next cluster in the chain
+ * corresponding to 'search_clus'.
+ */
+static int fat_read_next_clus(struct super_block *sb, int search_clus)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	/*bits 31 to 7 give relative sector number*/
+	sector_t blknr = search_clus >> 7;
+	/*bits 6 to 0 give offset*/
+	unsigned int offset = search_clus & 0x7F;
+	__le32 *address;
+	unsigned int next_cluster;
+	struct buffer_head *bh = sb_bread(sb, blknr + sbi->fat_start);
+	if (!bh) {
+		fat_msg(sb, KERN_ERR,
+			"unable to read block(%llu) for finding the next cluster in FAT chain",
+			(llu)blknr);
+		return -EIO;
+	}
+	address = (__le32 *) bh->b_data;
+	next_cluster = (le32_to_cpu(address[offset])) & 0x0FFFFFFF;
+	brelse(bh);
+	return next_cluster;
+}
+
+/*
  * Find the parent for a directory that is not currently connected to
  * the filesystem root.
  *
@@ -105,15 +192,54 @@ struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
 struct dentry *fat_get_parent(struct dentry *child_dir)
 {
 	struct super_block *sb = child_dir->d_sb;
-	struct buffer_head *bh = NULL;
+	struct buffer_head *dotdot_bh = NULL, *parent_bh = NULL;
 	struct msdos_dir_entry *de;
 	struct inode *parent_inode = NULL;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int parent_logstart;
+	int search_clus, clus_to_match;
+	sector_t blknr;
 
-	if (!fat_get_dotdot_entry(child_dir->d_inode, &bh, &de)) {
-		int parent_logstart = fat_get_start(MSDOS_SB(sb), de);
+	if (!fat_get_dotdot_entry(child_dir->d_inode, &dotdot_bh, &de)) {
+		parent_logstart = fat_get_start(sbi, de);
 		parent_inode = fat_dget(sb, parent_logstart);
+		if (parent_inode || !sbi->options.nfs)
+			goto out;
+		if (!parent_logstart)
+			/*logstart of dotdot entry is zero if
+			* if the directory's parent is root
+			*/
+			parent_inode = sb->s_root->d_inode;
+		else {
+			blknr = fat_clus_to_blknr(sbi, parent_logstart);
+			parent_bh = sb_bread(sb, blknr);
+			if (!parent_bh) {
+				fat_msg(sb, KERN_ERR,
+					"unable to read cluster of parent directory");
+				goto out;
+			}
+			de = (struct msdos_dir_entry *) parent_bh->b_data;
+			clus_to_match = fat_get_start(sbi, &de[0]);
+			search_clus = fat_get_start(sbi, &de[1]);
+			if (!search_clus)
+				search_clus = sbi->root_cluster;
+			brelse(parent_bh);
+			do {
+				parent_inode = fat_traverse_cluster(sb,
+						search_clus, clus_to_match);
+				if (IS_ERR(parent_inode))
+					break;
+				if (parent_inode)
+					break;
+				search_clus = fat_read_next_clus(sb,
+								search_clus);
+				if (search_clus < 0)
+					break;
+			} while (search_clus != FAT_ENT_EOF);
+		}
 	}
-	brelse(bh);
+out:
+	brelse(dotdot_bh);
 
 	return d_obtain_alias(parent_inode);
 }
-- 
1.7.9.5

