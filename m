Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab2GCTKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:10:04 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:49328 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2GCTKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:10:03 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=from:message-id;
	b=DlMMvu51HYTRcxiaECsARX2rTHUuZcVSvAuHCnKUALGlBWtWIC9xZVmwwb6i
	PMHqF60160dzhcIGUjlWezpSY7Y4oWjdRZyZjKjl//P3uwwLoKK8U1iOf
	3O4z1jXwkjMbwciGmd5jcYwiTl92OhoMX8Mh3UEn+6y+VwozqcTGs8=;
X-Spam-Processed: mail.digidescorp.com, Tue, 03 Jul 2012 14:10:00 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1531cb781b=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH 1/2] fat (exportfs): drop ineffective get_parent code
Date: Tue,  3 Jul 2012 14:09:35 -0500
Message-Id: <1341342576-15394-2-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reorganizes existing code for reuse by the next patch in the series.

The only functional change is to remove ineffective code from 
fat_get_dotdot_entry() and limit fat_get_parent() to immediate children of the
root (the only disconnected directory case that can be handled without a 
search). The limitation will be removed in the next patch in the series.

These changes are a slight improvement over the current situation, in that they
allow reconnection of immediate subdirectories of the root, and reporting of
ESTALE for other cases.

The reason the i_pos code in fat_get_dotdot_entry() is ineffective is
because the value is the on-disk position of a ".." directory entry.
What is needed in order to map NFS file handles back to objects is the on-disk
position of the named entry to which ".." refers.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/fs/fat/dir.c b/fs/fat/dir.c
--- a/fs/fat/dir.c	2012-07-03 07:21:58.918610460 -0500
+++ b/fs/fat/dir.c	2012-07-03 10:07:58.315967863 -0500
@@ -40,14 +40,6 @@ static inline unsigned char fat_tolower(
 	return ((c >= 'A') && (c <= 'Z')) ? c+32 : c;
 }
 
-static inline loff_t fat_make_i_pos(struct super_block *sb,
-				    struct buffer_head *bh,
-				    struct msdos_dir_entry *de)
-{
-	return ((loff_t)bh->b_blocknr << MSDOS_SB(sb)->dir_per_block_bits)
-		| (de - (struct msdos_dir_entry *)bh->b_data);
-}
-
 static inline void fat_dir_readahead(struct inode *dir, sector_t iblock,
 				     sector_t phys)
 {
@@ -876,17 +868,14 @@ static int fat_get_short_entry(struct in
  * for inode. So, this function provide the some informations only.
  */
 int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
-			 struct msdos_dir_entry **de, loff_t *i_pos)
+			 struct msdos_dir_entry **de)
 {
-	loff_t offset;
+	loff_t offset = 0;
 
-	offset = 0;
-	*bh = NULL;
+	*de = NULL;
 	while (fat_get_short_entry(dir, &offset, bh, de) >= 0) {
-		if (!strncmp((*de)->name, MSDOS_DOTDOT, MSDOS_NAME)) {
-			*i_pos = fat_make_i_pos(dir->i_sb, *bh, *de);
+		if (!strncmp((*de)->name, MSDOS_DOTDOT, MSDOS_NAME))
 			return 0;
-		}
 	}
 	return -ENOENT;
 }
diff -uprN a/fs/fat/fat.h b/fs/fat/fat.h
--- a/fs/fat/fat.h	2012-07-03 07:21:53.723637293 -0500
+++ b/fs/fat/fat.h	2012-07-03 10:07:58.325967754 -0500
@@ -169,6 +169,15 @@ static inline umode_t fat_make_mode(stru
 		return (mode & ~sbi->options.fs_fmask) | S_IFREG;
 }
 
+/* Construct i_pos from on-disk position of directory entry */
+static inline loff_t fat_make_i_pos(struct super_block *sb,
+				    struct buffer_head *bh,
+				    struct msdos_dir_entry *de)
+{
+	return ((loff_t)bh->b_blocknr << MSDOS_SB(sb)->dir_per_block_bits)
+		| (de - (struct msdos_dir_entry *)bh->b_data);
+}
+
 /* Return the FAT attribute byte for this inode */
 static inline u8 fat_make_attrs(struct inode *inode)
 {
@@ -262,7 +271,7 @@ extern int fat_subdirs(struct inode *dir
 extern int fat_scan(struct inode *dir, const unsigned char *name,
 		    struct fat_slot_info *sinfo);
 extern int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
-				struct msdos_dir_entry **de, loff_t *i_pos);
+				struct msdos_dir_entry **de);
 extern int fat_alloc_new_dir(struct inode *dir, struct timespec *ts);
 extern int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			   struct fat_slot_info *sinfo);
diff -uprN a/fs/fat/inode.c b/fs/fat/inode.c
--- a/fs/fat/inode.c	2012-07-03 07:21:53.733637243 -0500
+++ b/fs/fat/inode.c	2012-07-03 10:07:58.335967643 -0500
@@ -411,31 +411,48 @@ static int fat_fill_inode(struct inode *
 	return 0;
 }
 
+/**
+ * Create inode from specified directory entry.
+ * Do not call this directly unless intentionally bypassing the FAT dir cache.
+ */
+static struct inode *fat_build_unhashed_inode(struct super_block *sb,
+			struct msdos_dir_entry *de)
+{
+	struct inode *inode;
+
+	inode = new_inode(sb);
+	if (inode) {
+		int err;
+
+		inode->i_ino = iunique(sb, MSDOS_ROOT_INO);
+		inode->i_version = 1;
+		err = fat_fill_inode(inode, de);
+		if (err) {
+			iput(inode);
+			inode = ERR_PTR(err);
+		}
+	} else
+		inode = ERR_PTR(-ENOMEM);
+
+	return inode;
+}
+
+/**
+ * Find or create FAT dir cache inode for i_pos.
+ */
 struct inode *fat_build_inode(struct super_block *sb,
 			struct msdos_dir_entry *de, loff_t i_pos)
 {
 	struct inode *inode;
-	int err;
 
 	inode = fat_iget(sb, i_pos);
-	if (inode)
-		goto out;
-	inode = new_inode(sb);
 	if (!inode) {
-		inode = ERR_PTR(-ENOMEM);
-		goto out;
-	}
-	inode->i_ino = iunique(sb, MSDOS_ROOT_INO);
-	inode->i_version = 1;
-	err = fat_fill_inode(inode, de);
-	if (err) {
-		iput(inode);
-		inode = ERR_PTR(err);
-		goto out;
+		inode = fat_build_unhashed_inode(sb, de);
+		if (!IS_ERR(inode)) {
+			fat_attach(inode, i_pos);
+			insert_inode_hash(inode);
+		}
 	}
-	fat_attach(inode, i_pos);
-	insert_inode_hash(inode);
-out:
 	return inode;
 }
 
@@ -677,25 +694,59 @@ static const struct super_operations fat
  * of i_logstart is used to store the directory entry offset.
  */
 
+static int
+fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
+{
+	int len = *lenp;
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	loff_t i_pos;
+
+	if (len < 5) {
+		*lenp = 5;
+		return 255; /* no room */
+	}
+
+	i_pos = fat_i_pos_read(sbi, inode);
+	*lenp = 5;
+	fh[0] = inode->i_ino;
+	fh[1] = inode->i_generation;
+	fh[2] = i_pos >> 8;
+	fh[3] = ((i_pos & 0xf0) << 24) | MSDOS_I(inode)->i_logstart;
+	fh[4] = (i_pos & 0x0f) << 28;
+	if (parent)
+		fh[4] |= MSDOS_I(parent)->i_logstart;
+	return 3;
+}
+
+static int fat_is_valid_fh(int fh_len, int fh_type)
+{
+	return ((fh_len >= 5) && (fh_type == 3));
+}
+
 static struct dentry *fat_fh_to_dentry(struct super_block *sb,
 		struct fid *fid, int fh_len, int fh_type)
 {
 	struct inode *inode = NULL;
 	u32 *fh = fid->raw;
+	loff_t i_pos;
+	unsigned long i_ino;
+	__u32 i_generation;
+	int i_logstart;
 
-	if (fh_len < 5 || fh_type != 3)
+	if (!fat_is_valid_fh(fh_len, fh_type))
 		return NULL;
 
-	inode = ilookup(sb, fh[0]);
-	if (!inode || inode->i_generation != fh[1]) {
+	i_ino = fh[0];
+	i_generation = fh[1];
+	i_logstart = fh[3] & 0x0fffffff;
+
+	inode = ilookup(sb, i_ino);
+	if (!inode || inode->i_generation != i_generation) {
 		if (inode)
 			iput(inode);
 		inode = NULL;
 	}
 	if (!inode) {
-		loff_t i_pos;
-		int i_logstart = fh[3] & 0x0fffffff;
-
 		i_pos = (loff_t)fh[2] << 8;
 		i_pos |= ((fh[3] >> 24) & 0xf0) | (fh[4] >> 28);
 
@@ -728,52 +779,28 @@ static struct dentry *fat_fh_to_dentry(s
 	return d_obtain_alias(inode);
 }
 
-static int
-fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
-{
-	int len = *lenp;
-	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
-	loff_t i_pos;
-
-	if (len < 5) {
-		*lenp = 5;
-		return 255; /* no room */
-	}
-
-	i_pos = fat_i_pos_read(sbi, inode);
-	*lenp = 5;
-	fh[0] = inode->i_ino;
-	fh[1] = inode->i_generation;
-	fh[2] = i_pos >> 8;
-	fh[3] = ((i_pos & 0xf0) << 24) | MSDOS_I(inode)->i_logstart;
-	fh[4] = (i_pos & 0x0f) << 28;
-	if (parent)
-		fh[4] |= MSDOS_I(parent)->i_logstart;
-	return 3;
-}
-
-static struct dentry *fat_get_parent(struct dentry *child)
+/*
+ * NFS support:  Find the parent for a disconnected directory.
+ */
+static struct dentry *fat_get_parent(struct dentry *child_dir)
 {
-	struct super_block *sb = child->d_sb;
-	struct buffer_head *bh;
+	struct super_block *sb = child_dir->d_sb;
+	struct buffer_head *bh = NULL;
 	struct msdos_dir_entry *de;
-	loff_t i_pos;
-	struct dentry *parent;
-	struct inode *inode;
-	int err;
+	struct dentry *parent = ERR_PTR(-ESTALE);
+	int parent_logstart;
 
 	lock_super(sb);
 
-	err = fat_get_dotdot_entry(child->d_inode, &bh, &de, &i_pos);
-	if (err) {
-		parent = ERR_PTR(err);
+	if (fat_get_dotdot_entry(child_dir->d_inode, &bh, &de))
 		goto out;
-	}
-	inode = fat_build_inode(sb, de, i_pos);
-	brelse(bh);
 
-	parent = d_obtain_alias(inode);
+	parent_logstart = fat_get_start(MSDOS_SB(sb), de);
+	if (!parent_logstart)
+		parent = sb->s_root;
+
 out:
+	brelse(bh);
 	unlock_super(sb);
 
 	return parent;
diff -uprN a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
--- a/fs/fat/namei_msdos.c	2012-07-03 07:21:53.750637154 -0500
+++ b/fs/fat/namei_msdos.c	2012-07-03 10:07:58.351967464 -0500
@@ -440,7 +440,7 @@ static int do_msdos_rename(struct inode
 	struct inode *old_inode, *new_inode;
 	struct fat_slot_info old_sinfo, sinfo;
 	struct timespec ts;
-	loff_t dotdot_i_pos, new_i_pos;
+	loff_t new_i_pos;
 	int err, old_attrs, is_dir, update_dotdot, corrupt = 0;
 
 	old_sinfo.bh = sinfo.bh = dotdot_bh = NULL;
@@ -456,8 +456,8 @@ static int do_msdos_rename(struct inode
 	is_dir = S_ISDIR(old_inode->i_mode);
 	update_dotdot = (is_dir && old_dir != new_dir);
 	if (update_dotdot) {
-		if (fat_get_dotdot_entry(old_inode, &dotdot_bh, &dotdot_de,
-					 &dotdot_i_pos) < 0) {
+		err = fat_get_dotdot_entry(old_inode, &dotdot_bh, &dotdot_de);
+		if (err < 0) {
 			err = -EIO;
 			goto out;
 		}
diff -uprN a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c	2012-07-03 07:21:53.758637114 -0500
+++ b/fs/fat/namei_vfat.c	2012-07-03 10:07:58.359967376 -0500
@@ -914,7 +914,7 @@ static int vfat_rename(struct inode *old
 	struct inode *old_inode, *new_inode;
 	struct fat_slot_info old_sinfo, sinfo;
 	struct timespec ts;
-	loff_t dotdot_i_pos, new_i_pos;
+	loff_t new_i_pos;
 	int err, is_dir, update_dotdot, corrupt = 0;
 	struct super_block *sb = old_dir->i_sb;
 
@@ -929,8 +929,8 @@ static int vfat_rename(struct inode *old
 	is_dir = S_ISDIR(old_inode->i_mode);
 	update_dotdot = (is_dir && old_dir != new_dir);
 	if (update_dotdot) {
-		if (fat_get_dotdot_entry(old_inode, &dotdot_bh, &dotdot_de,
-					 &dotdot_i_pos) < 0) {
+		err = fat_get_dotdot_entry(old_inode, &dotdot_bh, &dotdot_de);
+		if (err < 0) {
 			err = -EIO;
 			goto out;
 		}

