Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab2J0OzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 10:55:00 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:38622 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab2J0Oyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 10:54:54 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 2/6] fat: restructure export operations
Date: Sat, 27 Oct 2012 23:54:42 +0900
Message-Id: <1351349682-8170-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Define two nfs export_operation structures,one for 'stale_rw' mounts and
the other for 'nostale_ro'.The former uses the generic
export_encode_fh function to encode file handle, while the latter uses
fat_encode_fh.

Since inode number is not needed for nostale_ro, remove it from struct
fat_fid and repack other needed info viz. i_pos and i_generation.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/fat.h   |    2 +
 fs/fat/inode.c |   12 ++----
 fs/fat/nfs.c   |  127 +++++++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 104 insertions(+), 37 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index febc1cca..65f9149 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -391,6 +391,8 @@ void fat_cache_destroy(void);
 
 /* fat/nfs.c */
 struct fid;
+extern const struct export_operations fat_export_ops;
+extern const struct export_operations fat_export_ops_nostale;
 extern int fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp,
 			 struct inode *parent);
 extern struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 80c6fdd..34253dc 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -18,7 +18,6 @@
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
 #include <linux/buffer_head.h>
-#include <linux/exportfs.h>
 #include <linux/mount.h>
 #include <linux/vfs.h>
 #include <linux/parser.h>
@@ -703,13 +702,6 @@ static const struct super_operations fat_sops = {
 	.show_options	= fat_show_options,
 };
 
-static const struct export_operations fat_export_ops = {
-	.encode_fh      = fat_encode_fh,
-	.fh_to_dentry	= fat_fh_to_dentry,
-	.fh_to_parent	= fat_fh_to_parent,
-	.get_parent	= fat_get_parent,
-};
-
 static int fat_show_options(struct seq_file *m, struct dentry *root)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(root->d_sb);
@@ -1118,8 +1110,10 @@ out:
 		opts->allow_utime = ~opts->fs_dmask & (S_IWGRP | S_IWOTH);
 	if (opts->unicode_xlate)
 		opts->utf8 = 0;
-	if (opts->nfs == FAT_NFS_NOSTALE_RO)
+	if (opts->nfs == FAT_NFS_NOSTALE_RO) {
 		sb->s_flags |= MS_RDONLY;
+		sb->s_export_op = &fat_export_ops_nostale;
+	}
 
 	return 0;
 }
diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index 671a75d..0abfacf 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -15,13 +15,17 @@
 #include "fat.h"
 
 struct fat_fid {
-	u32 ino;
-	u32 gen;
-	u64 i_pos;
-	u32 parent_ino;
-	u32 parent_gen;
+	u32 i_gen;
+	u32 i_pos_low;
+	u16 i_pos_hi;
+	u16 parent_i_pos_hi;
+	u32 parent_i_pos_low;
+	u32 parent_i_gen;
 } __packed;
 
+#define FILEID_FAT_WITHOUT_PARENT (offsetof(struct fat_fid, parent_i_pos_hi)/4)
+#define FILEID_FAT_WITH_PARENT (sizeof(struct fat_fid)/4)
+
 /**
  * Look up a directory inode given its starting cluster.
  */
@@ -47,15 +51,24 @@ static struct inode *fat_dget(struct super_block *sb, int i_logstart)
 	return inode;
 }
 
+static struct inode *fat_ilookup(struct super_block *sb, u64 ino, loff_t i_pos)
+{
+	if (MSDOS_SB(sb)->options.nfs == FAT_NFS_NOSTALE_RO)
+		return fat_iget(sb, i_pos);
+
+	else {
+		if ((ino < MSDOS_ROOT_INO) || (ino == MSDOS_FSINFO_INO))
+			return NULL;
+		return ilookup(sb, ino);
+	}
+}
+
 static struct inode *fat_nfs_get_inode(struct super_block *sb,
 				       u64 ino, u32 generation, loff_t i_pos)
 {
-	struct inode *inode;
 
-	if ((ino < MSDOS_ROOT_INO) || (ino == MSDOS_FSINFO_INO))
-		return NULL;
+	struct inode *inode = fat_ilookup(sb, ino, i_pos);
 
-	inode = ilookup(sb, ino);
 	if (inode && generation && (inode->i_generation != generation)) {
 		iput(inode);
 		inode = NULL;
@@ -89,7 +102,8 @@ static struct inode *fat_nfs_get_inode(struct super_block *sb,
 
 
 int
-fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
+fat_encode_fh_nostale(struct inode *inode, __u32 *fh, int *lenp,
+					struct inode *parent)
 {
 	int len = *lenp;
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
@@ -97,24 +111,26 @@ fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
 	loff_t i_pos;
 	int type = FILEID_INO32_GEN;
 
-	if (parent && (len < 5)) {
-		*lenp = 5;
+	if (parent && (len < FILEID_FAT_WITH_PARENT)) {
+		*lenp = FILEID_FAT_WITH_PARENT;
 		return 255;
-	} else if (len < 3) {
-		*lenp = 3;
+	} else if (len < FILEID_FAT_WITHOUT_PARENT) {
+		*lenp = FILEID_FAT_WITHOUT_PARENT;
 		return 255;
 	}
 
 	i_pos = fat_i_pos_read(sbi, inode);
-	*lenp = 3;
-	fid->ino = inode->i_ino;
-	fid->gen = inode->i_generation;
-	fid->i_pos = i_pos;
+	*lenp = FILEID_FAT_WITHOUT_PARENT;
+	fid->i_gen = inode->i_generation;
+	fid->i_pos_low = i_pos & 0xFFFFFFFF;
+	fid->i_pos_hi = (i_pos >> 32) & 0xFF;
 	if (parent) {
-		fid->parent_ino = parent->i_ino;
-		fid->parent_gen = parent->i_generation;
+		i_pos = fat_i_pos_read(sbi, parent);
+		fid->parent_i_pos_hi = (i_pos >> 32) & 0xFF;
+		fid->parent_i_pos_low = i_pos & 0xFFFFFFFF;
+		fid->parent_i_gen = parent->i_generation;
 		type = FILEID_INO32_GEN_PARENT;
-		*lenp = 5;
+		*lenp = FILEID_FAT_WITH_PARENT;
 	}
 
 	return type;
@@ -128,14 +144,36 @@ struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fh,
 				int fh_len, int fh_type)
 {
 	struct inode *inode = NULL;
-	struct fat_fid *fid = (struct fat_fid *)fh;
-	if (fh_len < 3)
+	if (fh_len < 2)
 		return NULL;
 
 	switch (fh_type) {
 	case FILEID_INO32_GEN:
 	case FILEID_INO32_GEN_PARENT:
-		inode = fat_nfs_get_inode(sb, fid->ino, fid->gen, fid->i_pos);
+		inode = fat_nfs_get_inode(sb, fh->i32.ino, fh->i32.gen, 0);
+		break;
+	}
+
+	return d_obtain_alias(inode);
+}
+struct dentry *fat_fh_to_dentry_nostale(struct super_block *sb, struct fid *fh,
+				int fh_len, int fh_type)
+{
+	struct inode *inode = NULL;
+	struct fat_fid *fid = (struct fat_fid *)fh;
+	loff_t i_pos;
+
+	switch (fh_type) {
+	case FILEID_INO32_GEN:
+		if (fh_len < FILEID_FAT_WITHOUT_PARENT)
+			return NULL;
+	case FILEID_INO32_GEN_PARENT:
+		if ((fh_len < FILEID_FAT_WITH_PARENT) &&
+			(fh_type == FILEID_INO32_GEN_PARENT))
+			return NULL;
+		i_pos = fid->i_pos_hi;
+		i_pos = (i_pos << 32) | (fid->i_pos_low);
+		inode = fat_nfs_get_inode(sb, 0, fid->i_gen, i_pos);
 
 		break;
 	}
@@ -147,18 +185,39 @@ struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fh,
  * Find the parent for a file specified by NFS handle.
  * This requires that the handle contain the i_ino of the parent.
  */
-struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fh,
+struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
+				int fh_len, int fh_type)
+{
+	struct inode *inode = NULL;
+
+	if (fh_len < 2)
+		return NULL;
+
+	switch (fh_type) {
+	case FILEID_INO32_GEN:
+	case FILEID_INO32_GEN_PARENT:
+		inode = fat_nfs_get_inode(sb, fid->i32.ino, fid->i32.gen, 0);
+		break;
+	}
+
+	return d_obtain_alias(inode);
+}
+
+struct dentry *fat_fh_to_parent_nostale(struct super_block *sb, struct fid *fh,
 				int fh_len, int fh_type)
 {
 	struct inode *inode = NULL;
 	struct fat_fid *fid = (struct fat_fid *)fh;
-	if (fh_len < 5)
+	loff_t i_pos;
+
+	if (fh_len < FILEID_FAT_WITH_PARENT)
 		return NULL;
 
 	switch (fh_type) {
 	case FILEID_INO32_GEN_PARENT:
-		inode = fat_nfs_get_inode(sb, fid->parent_ino, fid->parent_gen,
-						fid->i_pos);
+		i_pos = fid->parent_i_pos_hi;
+		i_pos = (i_pos << 32) | (fid->parent_i_pos_low);
+		inode = fat_nfs_get_inode(sb, 0, fid->parent_i_gen, i_pos);
 		break;
 	}
 
@@ -303,3 +362,15 @@ out:
 
 	return d_obtain_alias(parent_inode);
 }
+
+const struct export_operations fat_export_ops = {
+	.fh_to_dentry   = fat_fh_to_dentry,
+	.fh_to_parent   = fat_fh_to_parent,
+	.get_parent     = fat_get_parent,
+};
+const struct export_operations fat_export_ops_nostale = {
+	.encode_fh      = fat_encode_fh_nostale,
+	.fh_to_dentry   = fat_fh_to_dentry_nostale,
+	.fh_to_parent   = fat_fh_to_parent_nostale,
+	.get_parent     = fat_get_parent,
+};
-- 
1.7.9.5

