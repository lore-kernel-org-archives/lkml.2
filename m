Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992Ab1FWVPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 17:15:48 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:47462 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704Ab1FWVPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 17:15:47 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Christoph Hellwig <hch@tuxera.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Anton Salikhmetov <alexo@tuxera.com>,
        Al Viro <viro@zeniv.linux.org.uk>, roman@ardistech.com,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH 1/2] hfsplus: add error checking for hfs_find_init()
Date: Fri, 24 Jun 2011 01:15:01 +0400
Message-Id: <1308863702-30859-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hfs_find_init() may fail with ENOMEM, but there are places, where
the returned value is not checked. The consequences can be very
unpleasant, e.g. kfree uninitialized pointer and
inappropriate mutex unlocking.

The patch adds checks for errors in hfs_find_init().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/hfsplus/catalog.c |   18 +++++++++++++-----
 fs/hfsplus/dir.c     |   10 ++++++++--
 fs/hfsplus/extents.c |   25 +++++++++++++++++--------
 fs/hfsplus/inode.c   |   12 +++++++-----
 fs/hfsplus/super.c   |   16 ++++++++++------
 5 files changed, 55 insertions(+), 26 deletions(-)

diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
index b4ba1b3..6255de0 100644
--- a/fs/hfsplus/catalog.c
+++ b/fs/hfsplus/catalog.c
@@ -212,7 +212,9 @@ int hfsplus_create_cat(u32 cnid, struct inode *dir,
 
 	dprint(DBG_CAT_MOD, "create_cat: %s,%u(%d)\n",
 		str->name, cnid, inode->i_nlink);
-	hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
+	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
+	if (err)
+		goto err_init;
 
 	hfsplus_cat_build_key(sb, fd.search_key, cnid, NULL);
 	entry_size = hfsplus_fill_cat_thread(sb, &entry,
@@ -255,6 +257,7 @@ err1:
 		hfs_brec_remove(&fd);
 err2:
 	hfs_find_exit(&fd);
+err_init:
 	return err;
 }
 
@@ -269,7 +272,9 @@ int hfsplus_delete_cat(u32 cnid, struct inode *dir, struct qstr *str)
 
 	dprint(DBG_CAT_MOD, "delete_cat: %s,%u\n",
 		str ? str->name : NULL, cnid);
-	hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
+	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
+	if (err)
+		goto fail_init;
 
 	if (!str) {
 		int len;
@@ -335,7 +340,7 @@ int hfsplus_delete_cat(u32 cnid, struct inode *dir, struct qstr *str)
 	hfsplus_mark_inode_dirty(dir, HFSPLUS_I_CAT_DIRTY);
 out:
 	hfs_find_exit(&fd);
-
+fail_init:
 	return err;
 }
 
@@ -347,12 +352,14 @@ int hfsplus_rename_cat(u32 cnid,
 	struct hfs_find_data src_fd, dst_fd;
 	hfsplus_cat_entry entry;
 	int entry_size, type;
-	int err = 0;
+	int err;
 
 	dprint(DBG_CAT_MOD, "rename_cat: %u - %lu,%s - %lu,%s\n",
 		cnid, src_dir->i_ino, src_name->name,
 		dst_dir->i_ino, dst_name->name);
-	hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &src_fd);
+	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &src_fd);
+	if (err)
+		goto fail_init;
 	dst_fd = src_fd;
 
 	/* find the old dir entry and read the data */
@@ -417,5 +424,6 @@ int hfsplus_rename_cat(u32 cnid,
 out:
 	hfs_bnode_put(dst_fd.bnode);
 	hfs_find_exit(&src_fd);
+fail_init:
 	return err;
 }
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 4df5059..6c2ea98 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -38,7 +38,9 @@ static struct dentry *hfsplus_lookup(struct inode *dir, struct dentry *dentry,
 	sb = dir->i_sb;
 
 	dentry->d_fsdata = NULL;
-	hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
+	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
+	if (err)
+		goto fail_init;
 	hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, &dentry->d_name);
 again:
 	err = hfs_brec_read(&fd, &entry, sizeof(entry));
@@ -115,6 +117,7 @@ out:
 	return NULL;
 fail:
 	hfs_find_exit(&fd);
+fail_init:
 	return ERR_PTR(err);
 }
 
@@ -132,7 +135,9 @@ static int hfsplus_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	if (filp->f_pos >= inode->i_size)
 		return 0;
 
-	hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
+	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
+	if (err)
+		goto fail_init;
 	hfsplus_cat_build_key(sb, fd.search_key, inode->i_ino, NULL);
 	err = hfs_brec_find(&fd);
 	if (err)
@@ -234,6 +239,7 @@ next:
 	memcpy(&rd->key, fd.key, sizeof(struct hfsplus_cat_key));
 out:
 	hfs_find_exit(&fd);
+fail_init:
 	return err;
 }
 
diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index b1991a2..6db4586 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -124,9 +124,10 @@ static void hfsplus_ext_write_extent_locked(struct inode *inode)
 	if (HFSPLUS_I(inode)->extent_state & HFSPLUS_EXT_DIRTY) {
 		struct hfs_find_data fd;
 
-		hfs_find_init(HFSPLUS_SB(inode->i_sb)->ext_tree, &fd);
-		__hfsplus_ext_write_extent(inode, &fd);
-		hfs_find_exit(&fd);
+		if (!hfs_find_init(HFSPLUS_SB(inode->i_sb)->ext_tree, &fd)) {
+			__hfsplus_ext_write_extent(inode, &fd);
+			hfs_find_exit(&fd);
+		}
 	}
 }
 
@@ -194,9 +195,11 @@ static int hfsplus_ext_read_extent(struct inode *inode, u32 block)
 	    block < hip->cached_start + hip->cached_blocks)
 		return 0;
 
-	hfs_find_init(HFSPLUS_SB(inode->i_sb)->ext_tree, &fd);
-	res = __hfsplus_ext_cache_extent(&fd, inode, block);
-	hfs_find_exit(&fd);
+	res = hfs_find_init(HFSPLUS_SB(inode->i_sb)->ext_tree, &fd);
+	if (!res) {
+		res = __hfsplus_ext_cache_extent(&fd, inode, block);
+		hfs_find_exit(&fd);
+	}
 	return res;
 }
 
@@ -371,7 +374,9 @@ int hfsplus_free_fork(struct super_block *sb, u32 cnid,
 	if (total_blocks == blocks)
 		return 0;
 
-	hfs_find_init(HFSPLUS_SB(sb)->ext_tree, &fd);
+	res = hfs_find_init(HFSPLUS_SB(sb)->ext_tree, &fd);
+	if (res)
+		return res;
 	do {
 		res = __hfsplus_ext_read_extent(&fd, ext_entry, cnid,
 						total_blocks, type);
@@ -523,7 +528,11 @@ void hfsplus_file_truncate(struct inode *inode)
 		goto out;
 
 	mutex_lock(&hip->extents_lock);
-	hfs_find_init(HFSPLUS_SB(sb)->ext_tree, &fd);
+	res = hfs_find_init(HFSPLUS_SB(sb)->ext_tree, &fd);
+	if (res) {
+		mutex_unlock(&hip->extents_lock);
+		return;
+	}
 	while (1) {
 		if (alloc_cnt == hip->first_blocks) {
 			hfsplus_free_extents(sb, hip->first_extents,
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index b248a6c..010cd36 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -195,11 +195,13 @@ static struct dentry *hfsplus_file_lookup(struct inode *dir,
 	hip->flags = 0;
 	set_bit(HFSPLUS_I_RSRC, &hip->flags);
 
-	hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
-	err = hfsplus_find_cat(sb, dir->i_ino, &fd);
-	if (!err)
-		err = hfsplus_cat_read_inode(inode, &fd);
-	hfs_find_exit(&fd);
+	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
+	if (!err) {
+		err = hfsplus_find_cat(sb, dir->i_ino, &fd);
+		if (!err)
+			err = hfsplus_cat_read_inode(inode, &fd);
+		hfs_find_exit(&fd);
+	}
 	if (err) {
 		iput(inode);
 		return ERR_PTR(err);
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index b49b555..07a0502 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -73,11 +73,13 @@ struct inode *hfsplus_iget(struct super_block *sb, unsigned long ino)
 
 	if (inode->i_ino >= HFSPLUS_FIRSTUSER_CNID ||
 	    inode->i_ino == HFSPLUS_ROOT_CNID) {
-		hfs_find_init(HFSPLUS_SB(inode->i_sb)->cat_tree, &fd);
-		err = hfsplus_find_cat(inode->i_sb, inode->i_ino, &fd);
-		if (!err)
-			err = hfsplus_cat_read_inode(inode, &fd);
-		hfs_find_exit(&fd);
+		err = hfs_find_init(HFSPLUS_SB(inode->i_sb)->cat_tree, &fd);
+		if (!err) {
+			err = hfsplus_find_cat(inode->i_sb, inode->i_ino, &fd);
+			if (!err)
+				err = hfsplus_cat_read_inode(inode, &fd);
+			hfs_find_exit(&fd);
+		}
 	} else {
 		err = hfsplus_system_read_inode(inode);
 	}
@@ -447,7 +449,9 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 
 	str.len = sizeof(HFSP_HIDDENDIR_NAME) - 1;
 	str.name = HFSP_HIDDENDIR_NAME;
-	hfs_find_init(sbi->cat_tree, &fd);
+	err = hfs_find_init(sbi->cat_tree, &fd);
+	if (err)
+		goto out_put_root;
 	hfsplus_cat_build_key(sb, fd.search_key, HFSPLUS_ROOT_CNID, &str);
 	if (!hfs_brec_read(&fd, &entry, sizeof(entry))) {
 		hfs_find_exit(&fd);
-- 
1.7.4.1

