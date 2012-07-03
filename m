Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab2GCTKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:10:15 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:49337 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073Ab2GCTKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:10:10 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=from:message-id;
	b=qG17uqoDG37yPBHVUI5O8gZLIPpHPgj4nC8rPrPoY9KLpKTwHS8DbE8uP1sL
	iz3PBdSiFz0u3phkqVWA/DxUom7mtqhvsIRRKXxwzEn1U8FDU+/IVXsqa
	rB6mEf9GUsPujKSk65mZqLAxyBv7vxQ4EuVTTqjDovwwICZvWLtaYA=;
X-Spam-Processed: mail.digidescorp.com, Tue, 03 Jul 2012 14:10:06 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1531cb781b=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted inodes/dentries
Date: Tue,  3 Jul 2012 14:09:36 -0500
Message-Id: <1341342576-15394-3-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to support reconstruction of evicted inodes.
We walk the on-disk structures where necessary to fill in information
not available in the NFS file handle.

One important point is that when reconstructing an inode, in order to avoid the
*client* declaring ESTALE we have to ensure that the NFS file handle of the
reconstruction is identical to that of the original. 

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/fs/fat/dir.c b/fs/fat/dir.c
--- a/fs/fat/dir.c	2012-07-03 08:38:17.077404182 -0500
+++ b/fs/fat/dir.c	12:57:02.506715436 -0500
@@ -532,6 +532,194 @@ end_of_dir:
 
 EXPORT_SYMBOL_GPL(fat_search_long);
 
+/**
+ * Fetch the name associated with the specified location (i_pos or i_logstart)
+ * and parent dir.
+ *
+ * On entry, the superblock is assumed locked.
+ *
+ * Returns 0 on success, -ENOENT if child cannot be found,
+ * -ENOMEM on malloc failure
+ */
+static int fat_name_for_loc(struct inode *parent, char *name, int name_size,
+			    loff_t child_loc, int is_logstart)
+{
+	struct super_block *sb = parent->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int isvfat = sbi->options.isvfat;
+	struct buffer_head *bh = NULL;
+	wchar_t *unicode = NULL;
+	struct msdos_dir_entry *de;
+	loff_t cpos = 0;
+	int err = -ENOENT;
+	loff_t cur_loc;
+
+	if (!is_logstart && !child_loc) {
+		fat_msg(sb, KERN_WARNING, "%s: i_pos == 0", __func__);
+		return -ENOENT;
+	}
+
+	while (1) {
+		unsigned char nr_slots = 0;
+
+		if (fat_get_entry(parent, &cpos, &bh, &de))
+			break;
+
+parse_record:
+		if (isvfat) {
+			if (de->name[0] == DELETED_FLAG)
+				continue;
+			if (de->attr != ATTR_EXT && (de->attr & ATTR_VOLUME))
+				continue;
+			if (de->attr != ATTR_EXT && IS_FREE(de->name))
+				continue;
+		} else {
+			/* Subtle point: also skips over extended entries */
+			if ((de->attr & ATTR_VOLUME) || IS_FREE(de->name))
+				continue;
+		}
+
+		if (de->attr == ATTR_EXT) {
+			int status = fat_parse_long(parent, &cpos, &bh, &de,
+						    &unicode, &nr_slots);
+			if (status < 0) {
+				err = status;
+				break;
+			} else if (status == PARSE_INVALID)
+				continue;
+			else if (status == PARSE_NOT_LONGNAME) {
+				nr_slots = 0;
+				goto parse_record;
+			} else if (status == PARSE_EOF)
+				break;
+
+			/* At this point, we
+			 * (a) have a long name, and
+			 * (2) are hopefully gazing at the matching shortname
+			 */
+			goto parse_record;
+		}
+
+		/* Here, we have a shortname entry */
+
+		cur_loc = is_logstart ? fat_get_start(sbi, de)
+				      : fat_make_i_pos(sb, bh, de);
+
+		if (cur_loc == child_loc) {
+			if (nr_slots) {
+				fat_uni_to_x8(sb, unicode, name, name_size);
+				err = 0;
+			} else {
+				int short_len;
+				if (name_size < FAT_MAX_SHORT_SIZE) {
+					err = -ENOMEM;
+					break;
+				}
+
+				short_len = fat_parse_short(sb, de, name,
+							sbi->options.dotsOK);
+				if (short_len) {
+					name[short_len] = '\0';
+					err = 0;
+				}
+			}
+			break;
+		}
+	}
+
+	brelse(bh);
+
+	if (unicode)
+		__putname(unicode);
+
+	return err;
+}
+
+static int fat_name_for_ipos(struct inode *parent, char *name,
+			     int name_size, loff_t child_ipos)
+{
+	return fat_name_for_loc(parent, name, name_size, child_ipos, 0);
+}
+
+static int fat_name_for_logstart(struct inode *parent, char *name,
+				 int name_size, loff_t child_logstart)
+{
+	return fat_name_for_loc(parent, name, name_size, child_logstart, 1);
+}
+
+/**
+ * NFS helper: retrieve the name of an anonymous (disconnected) child using
+ * its i_pos or i_logstart and knowledge of its parent
+ *
+ * Returns 0 on success, -ENOENT if child cannot be found,
+ * -ENOMEM on malloc failure
+ */
+int fat_get_name(struct dentry *parent, char *name,
+		 struct dentry *child)
+{
+	struct super_block *sb = parent->d_inode->i_sb;
+
+	loff_t child_loc = MSDOS_I(child->d_inode)->i_pos;
+	int err;
+
+	lock_super(sb);
+
+	if (child_loc) {
+		err = fat_name_for_ipos(parent->d_inode, name, NAME_MAX+1,
+					child_loc);
+	} else {
+		child_loc = MSDOS_I(child->d_inode)->i_logstart;
+		err = fat_name_for_logstart(parent->d_inode, name, NAME_MAX+1,
+					    child_loc);
+	}
+
+	unlock_super(sb);
+	return err;
+}
+
+/**
+ * Find the directory entry that specifies a particular location
+ * (start cluster or i_pos).
+ * On entry, the superblock is assumed locked.
+ * The caller is responsible for releasing the buffer_head.
+ */
+int fat_lookup_loc(struct inode *parent, loff_t loc,
+		   struct buffer_head **bh, struct msdos_dir_entry **de,
+		   int is_logstart)
+{
+	struct super_block *sb = parent->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	loff_t cpos = 0;
+	int err = -ENOENT;
+
+	*de = NULL;	/* Force scan from beginning of directory */
+
+	while (1) {
+		if (fat_get_entry(parent, &cpos, bh, de))
+			break;
+
+		if (IS_FREE((*de)->name))
+			continue;
+
+		if ((*de)->attr == ATTR_EXT)
+			continue;
+
+		if (is_logstart) {
+			if (fat_get_start(sbi, *de) == (int) loc) {
+				err = 0;
+				break;
+			}
+		} else {
+			if (fat_make_i_pos(sb, *bh, *de) == loc) {
+				err = 0;
+				break;
+			}
+		}
+	}
+
+	return err;
+}
+
 struct fat_ioctl_filldir_callback {
 	void __user *dirent;
 	int result;
diff -uprN a/fs/fat/fat.h b/fs/fat/fat.h
--- a/fs/fat/fat.h	2012-07-03 08:37:51.890543883 -0500
+++ b/fs/fat/fat.h	2012-07-03 12:56:58.154737489 -0500
@@ -276,6 +276,25 @@ extern int fat_alloc_new_dir(struct inod
 extern int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			   struct fat_slot_info *sinfo);
 extern int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo);
+extern int fat_get_name(struct dentry *parent, char *name,
+			struct dentry *child);
+extern int fat_lookup_loc(struct inode *parent, loff_t loc,
+			       struct buffer_head **bh,
+			       struct msdos_dir_entry **de, int is_logstart);
+
+static inline int fat_lookup_logstart(struct inode *parent, int i_logstart,
+				      struct buffer_head **bh,
+				      struct msdos_dir_entry **de)
+{
+	return fat_lookup_loc(parent, (loff_t)i_logstart, bh, de, 1);
+}
+
+static inline int fat_lookup_ipos(struct inode *parent, loff_t i_pos,
+				  struct buffer_head **bh,
+				  struct msdos_dir_entry **de)
+{
+	return fat_lookup_loc(parent, i_pos, bh, de, 0);
+}
 
 /* fat/fatent.c */
 struct fat_entry {
diff -uprN a/fs/fat/inode.c b/fs/fat/inode.c
--- a/fs/fat/inode.c	2012-07-03 10:07:37.494122152 -0500
+++ b/fs/fat/inode.c	2012-07-03 12:56:51.242772517 -0500
@@ -723,6 +723,67 @@ static int fat_is_valid_fh(int fh_len, i
 	return ((fh_len >= 5) && (fh_type == 3));
 }
 
+/**
+ * NFS helper: try to rebuild an inode that has been evicted from the caches,
+ * using some of the original information.
+ *
+ * It is important that the rebuilt inode have the same NFS file handle
+ * (signature) as the evicted one, otherwise NFS clients will detect the
+ * mismatch and report ESTALE.
+ *
+ * NOTE: This function must NOT be called to reconstitute a cached inode.
+ *
+ * On entry, the superblock is assumed locked.
+ */
+static struct inode *fat_reconstitute_inode(struct inode *parent,
+					    unsigned long i_ino, loff_t i_pos,
+					    int i_logstart, __u32 i_generation)
+{
+	struct super_block   *sb  = parent->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct buffer_head *bh = NULL;
+	struct msdos_dir_entry *de;
+	struct inode *inode = NULL;
+	int found_logstart;
+	int err;
+
+	/* Find the directory entry (on-disk inode)
+	 * NOTE: must use i_pos here in case we have been called for a
+	 * zero-length file, since all zero-length files have logstart == 0
+	 */
+	if (fat_lookup_ipos(parent, i_pos, &bh, &de))
+		goto out;
+
+	found_logstart = fat_get_start(sbi, de);
+	if (found_logstart != i_logstart)
+		goto out;
+
+	/* Now do the reconstruction */
+	inode = new_inode(sb);
+	if (!inode)
+		goto out;
+
+	inode->i_ino = i_ino;
+	inode->i_version = 1;
+	err = fat_fill_inode(inode, de);
+	if (err || ((inode->i_generation ^ i_generation) & 1)) {
+		/* Error calculating directory size,
+		 * or found a file where we expected a directory,
+		 * or found a directory where we expected a file
+		 */
+		iput(inode);
+		inode = NULL;
+		goto out;
+	}
+	inode->i_generation = i_generation;
+	fat_attach(inode, i_pos);
+	insert_inode_hash(inode);
+out:
+	brelse(bh);
+
+	return inode;
+}
+
 static struct dentry *fat_fh_to_dentry(struct super_block *sb,
 		struct fid *fid, int fh_len, int fh_type)
 {
@@ -732,6 +793,7 @@ static struct dentry *fat_fh_to_dentry(s
 	unsigned long i_ino;
 	__u32 i_generation;
 	int i_logstart;
+	int cache_hit;
 
 	if (!fat_is_valid_fh(fh_len, fh_type))
 		return NULL;
@@ -741,6 +803,7 @@ static struct dentry *fat_fh_to_dentry(s
 	i_logstart = fh[3] & 0x0fffffff;
 
 	inode = ilookup(sb, i_ino);
+	cache_hit = !!inode;
 	if (!inode || inode->i_generation != i_generation) {
 		if (inode)
 			iput(inode);
@@ -756,30 +819,152 @@ static struct dentry *fat_fh_to_dentry(s
 		 */
 
 		inode = fat_iget(sb, i_pos);
+		cache_hit |= !!inode;
 		if (inode && MSDOS_I(inode)->i_logstart != i_logstart) {
 			iput(inode);
 			inode = NULL;
 		}
 	}
 
-	/*
-	 * For now, do nothing if the inode is not found.
-	 *
-	 * What we could do is:
-	 *
-	 *	- follow the file starting at fh[4], and record the ".." entry,
-	 *	  and the name of the fh[2] entry.
-	 *	- then follow the ".." file finding the next step up.
-	 *
-	 * This way we build a path to the root of the tree. If this works, we
-	 * lookup the path and so get this inode into the cache.  Finally try
-	 * the fat_iget lookup again.  If that fails, then we are totally out
-	 * of luck.  But all that is for another day
-	 */
+	if (!inode && !cache_hit) {
+		/* Last chance:
+		 * Try to reconstitute the inode using the information
+		 * available in the file handle.
+		 */
+		struct msdos_dir_entry parent_de;
+		struct inode *parent;
+		int parent_logstart = fh[4] & 0x0fffffff;
+
+		memset(&parent_de, 0, sizeof(parent_de));
+		parent_de.name[0] = 'X';  /* Anything to make it !IS_FREE() */
+		parent_de.attr    = ATTR_DIR;
+		fat_set_start(&parent_de, parent_logstart);
+
+		lock_super(sb);
+
+		parent = fat_build_unhashed_inode(sb, &parent_de);
+		if (IS_ERR(parent))
+			inode = parent;		/* Relay the error code */
+		else {
+			inode = fat_reconstitute_inode(parent, i_ino, i_pos,
+						       i_logstart,
+						       i_generation);
+			iput(parent);
+		}
+
+		unlock_super(sb);
+	}
 	return d_obtain_alias(inode);
 }
 
 /*
+ * NFS support: try to get the dentry for a directory.
+ *
+ * @sb:		superblock
+ * @de:		on-disk directory entry of interest
+ * @logstart:	Start cluster of the directory
+ * @bh:		Buffer space
+ */
+struct dentry *fat_lookup_dir(struct super_block *sb,
+			      struct msdos_dir_entry *de,
+			      int logstart, struct buffer_head **bh)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct inode *root_inode = sb->s_root->d_inode;
+	struct inode *temp_inode, *inode, *parent = NULL;
+	struct dentry *dir = NULL;
+	struct msdos_dir_entry *parent_de;
+	int parent_logstart;
+	loff_t i_pos;
+	int err;
+
+	temp_inode = fat_build_unhashed_inode(sb, de);
+	if (IS_ERR(temp_inode)) {
+		err = PTR_ERR(temp_inode);
+		temp_inode = NULL;
+		goto out;
+	}
+
+	err = fat_get_dotdot_entry(temp_inode, bh, &parent_de);
+	if (err)
+		goto out;
+
+	parent_logstart = fat_get_start(sbi, parent_de);
+	if (!parent_logstart)
+		parent = root_inode;
+	else {
+		parent = fat_build_unhashed_inode(sb, parent_de);
+		if (IS_ERR(parent)) {
+			err = PTR_ERR(parent);
+			parent = NULL;
+			goto out;
+		}
+	}
+
+	err = fat_lookup_logstart(parent, logstart, bh, &parent_de);
+	if (err)
+		goto out;
+
+	/* Only a cached inode will do.
+	 * There is no point in building an inode from scratch because it will
+	 * have a different NFS file handle than the last one reported to the
+	 * client. Clients don't like that and fail operations with ESTALE.
+	 */
+	i_pos = fat_make_i_pos(sb, *bh, parent_de);
+	inode = fat_iget(sb, i_pos);
+
+	dir = d_obtain_alias(inode);
+	if (!IS_ERR(dir))
+		dir->d_op = sb->s_root->d_op;
+
+out:
+	if (parent != root_inode)
+		iput(parent);
+	iput(temp_inode);
+
+	if (err) {
+		if (err == -ENOENT)
+			err = -ESTALE;
+		return ERR_PTR(err);
+	} else
+		return dir;
+}
+
+/*
+ * NFS support: Find the parent for a file specified by NFS handle.
+ */
+struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
+				int fh_len, int fh_type)
+{
+	u32 *fh = fid->raw;
+	struct msdos_dir_entry parent_de;
+	struct buffer_head *bh = NULL;
+	struct dentry *parent = NULL;
+	int parent_logstart;
+
+	if (!fat_is_valid_fh(fh_len, fh_type))
+		return NULL;
+
+	parent_logstart = fh[4] & 0x0fffffff;
+	if (!parent_logstart)
+		return sb->s_root;
+
+	memset(&parent_de, 0, sizeof(parent_de));
+	parent_de.name[0] = 'X';  /* Anything to make it !IS_FREE() */
+	parent_de.attr    = ATTR_DIR;
+	fat_set_start(&parent_de, parent_logstart);
+
+	lock_super(sb);
+
+	parent = fat_lookup_dir(sb, &parent_de, parent_logstart, &bh);
+	brelse(bh);
+
+	unlock_super(sb);
+
+	return parent;
+}
+
+/*
  * NFS support:  Find the parent for a disconnected directory.
  */
 static struct dentry *fat_get_parent(struct dentry *child_dir)
@@ -798,7 +983,8 @@ static struct dentry *fat_get_parent(str
 	parent_logstart = fat_get_start(MSDOS_SB(sb), de);
 	if (!parent_logstart)
 		parent = sb->s_root;
-
+	else
+		parent = fat_lookup_dir(sb, de, parent_logstart, &bh);
 out:
 	brelse(bh);
 	unlock_super(sb);
@@ -809,7 +995,9 @@ out:
 static const struct export_operations fat_export_ops = {
 	.encode_fh	= fat_encode_fh,
 	.fh_to_dentry	= fat_fh_to_dentry,
+	.fh_to_parent	= fat_fh_to_parent,
 	.get_parent	= fat_get_parent,
+	.get_name	= fat_get_name
 };
 
 static int fat_show_options(struct seq_file *m, struct dentry *root)

