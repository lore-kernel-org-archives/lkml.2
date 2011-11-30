Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1K3CTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:19:19 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54852 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932083Ab1K3CTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:19:16 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 25/28] libfs: checkpatch wanking
Date: Tue, 29 Nov 2011 18:14:23 -0800
Message-Id: <00ed3e8d6ec223a707a6b0374d4a8dab61966909.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One warning for kstrtoll remains.

$ ./scripts/checkpatch.pl -f --terse --nosummary fs/libfs.c | \
  cut -f3- -d":" | sort | uniq -c
      1  ERROR: "foo * bar" should be "foo *bar"
      2  ERROR: spaces required around that '=' (ctx:VxV)
      2  ERROR: switch and case should be at the same indent
      3  ERROR: trailing whitespace
     34  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
     11  WARNING: line over 80 characters
      7  WARNING: please, no space before tabs
      1  WARNING: simple_strtoll is obsolete, use kstrtoll instead
      1  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/libfs.c |  208 +++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 107 insertions(+), 101 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index ad1532f..c224d14 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -15,8 +15,7 @@
 #include <linux/exportfs.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
-
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "internal.h"
 
@@ -33,6 +32,7 @@ int simple_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	stat->blocks = inode->i_mapping->nrpages << (PAGE_CACHE_SHIFT - 9);
 	return 0;
 }
+EXPORT_SYMBOL(simple_getattr);
 
 int simple_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
@@ -41,6 +41,7 @@ int simple_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_namelen = NAME_MAX;
 	return 0;
 }
+EXPORT_SYMBOL(simple_statfs);
 
 /*
  * Retaining negative dentries for an in-memory filesystem just wastes
@@ -55,7 +56,8 @@ static int simple_delete_dentry(const struct dentry *dentry)
  * Lookup the data. This is trivial - if the dentry didn't already
  * exist, we know it is negative.  Set d_op to delete negative dentries.
  */
-struct dentry *simple_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+struct dentry *simple_lookup(struct inode *dir, struct dentry *dentry,
+			     struct nameidata *nd)
 {
 	static const struct dentry_operations simple_dentry_operations = {
 		.d_delete = simple_delete_dentry,
@@ -67,6 +69,7 @@ struct dentry *simple_lookup(struct inode *dir, struct dentry *dentry, struct na
 	d_add(dentry, NULL);
 	return NULL;
 }
+EXPORT_SYMBOL(simple_lookup);
 
 int dcache_dir_open(struct inode *inode, struct file *file)
 {
@@ -76,26 +79,28 @@ int dcache_dir_open(struct inode *inode, struct file *file)
 
 	return file->private_data ? 0 : -ENOMEM;
 }
+EXPORT_SYMBOL(dcache_dir_open);
 
 int dcache_dir_close(struct inode *inode, struct file *file)
 {
 	dput(file->private_data);
 	return 0;
 }
+EXPORT_SYMBOL(dcache_dir_close);
 
 loff_t dcache_dir_lseek(struct file *file, loff_t offset, int origin)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	mutex_lock(&dentry->d_inode->i_mutex);
 	switch (origin) {
-		case 1:
-			offset += file->f_pos;
-		case 0:
-			if (offset >= 0)
-				break;
-		default:
-			mutex_unlock(&dentry->d_inode->i_mutex);
-			return -EINVAL;
+	case 1:
+		offset += file->f_pos;
+	case 0:
+		if (offset >= 0)
+			break;
+	default:
+		mutex_unlock(&dentry->d_inode->i_mutex);
+		return -EINVAL;
 	}
 	if (offset != file->f_pos) {
 		file->f_pos = offset;
@@ -110,8 +115,10 @@ loff_t dcache_dir_lseek(struct file *file, loff_t offset, int origin)
 			p = dentry->d_subdirs.next;
 			while (n && p != &dentry->d_subdirs) {
 				struct dentry *next;
-				next = list_entry(p, struct dentry, d_u.d_child);
-				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
+				next = list_entry(p, struct dentry,
+						  d_u.d_child);
+				spin_lock_nested(&next->d_lock,
+						 DENTRY_D_LOCK_NESTED);
 				if (simple_positive(next))
 					n--;
 				spin_unlock(&next->d_lock);
@@ -124,6 +131,7 @@ loff_t dcache_dir_lseek(struct file *file, loff_t offset, int origin)
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	return offset;
 }
+EXPORT_SYMBOL(dcache_dir_lseek);
 
 /* Relationship between i_mode and the DT_xxx types */
 static inline unsigned char dt_type(struct inode *inode)
@@ -137,7 +145,7 @@ static inline unsigned char dt_type(struct inode *inode)
  * both impossible due to the lock on directory.
  */
 
-int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
+int dcache_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct dentry *cursor = filp->private_data;
@@ -146,58 +154,61 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	int i = filp->f_pos;
 
 	switch (i) {
-		case 0:
-			ino = dentry->d_inode->i_ino;
-			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
-				break;
-			filp->f_pos++;
-			i++;
-			/* fallthrough */
-		case 1:
-			ino = parent_ino(dentry);
-			if (filldir(dirent, "..", 2, i, ino, DT_DIR) < 0)
-				break;
-			filp->f_pos++;
-			i++;
-			/* fallthrough */
-		default:
-			spin_lock(&dentry->d_lock);
-			if (filp->f_pos == 2)
-				list_move(q, &dentry->d_subdirs);
-
-			for (p=q->next; p != &dentry->d_subdirs; p=p->next) {
-				struct dentry *next;
-				next = list_entry(p, struct dentry, d_u.d_child);
-				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
-				if (!simple_positive(next)) {
-					spin_unlock(&next->d_lock);
-					continue;
-				}
-
-				spin_unlock(&next->d_lock);
-				spin_unlock(&dentry->d_lock);
-				if (filldir(dirent, next->d_name.name, 
-					    next->d_name.len, filp->f_pos, 
-					    next->d_inode->i_ino, 
-					    dt_type(next->d_inode)) < 0)
-					return 0;
-				spin_lock(&dentry->d_lock);
-				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
-				/* next is still alive */
-				list_move(q, p);
+	case 0:
+		ino = dentry->d_inode->i_ino;
+		if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
+			break;
+		filp->f_pos++;
+		i++;
+		/* fallthrough */
+	case 1:
+		ino = parent_ino(dentry);
+		if (filldir(dirent, "..", 2, i, ino, DT_DIR) < 0)
+			break;
+		filp->f_pos++;
+		i++;
+		/* fallthrough */
+	default:
+		spin_lock(&dentry->d_lock);
+		if (filp->f_pos == 2)
+			list_move(q, &dentry->d_subdirs);
+
+		for (p = q->next; p != &dentry->d_subdirs; p = p->next) {
+			struct dentry *next;
+			next = list_entry(p, struct dentry, d_u.d_child);
+			spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
+			if (!simple_positive(next)) {
 				spin_unlock(&next->d_lock);
-				p = q;
-				filp->f_pos++;
+				continue;
 			}
+
+			spin_unlock(&next->d_lock);
 			spin_unlock(&dentry->d_lock);
+			if (filldir(dirent, next->d_name.name,
+				    next->d_name.len, filp->f_pos,
+				    next->d_inode->i_ino,
+				    dt_type(next->d_inode)) < 0)
+				return 0;
+			spin_lock(&dentry->d_lock);
+			spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
+			/* next is still alive */
+			list_move(q, p);
+			spin_unlock(&next->d_lock);
+			p = q;
+			filp->f_pos++;
+		}
+		spin_unlock(&dentry->d_lock);
 	}
 	return 0;
 }
+EXPORT_SYMBOL(dcache_readdir);
 
-ssize_t generic_read_dir(struct file *filp, char __user *buf, size_t siz, loff_t *ppos)
+ssize_t generic_read_dir(struct file *filp, char __user *buf, size_t siz,
+			 loff_t *ppos)
 {
 	return -EISDIR;
 }
+EXPORT_SYMBOL(generic_read_dir);
 
 const struct file_operations simple_dir_operations = {
 	.open		= dcache_dir_open,
@@ -207,10 +218,12 @@ const struct file_operations simple_dir_operations = {
 	.readdir	= dcache_readdir,
 	.fsync		= noop_fsync,
 };
+EXPORT_SYMBOL(simple_dir_operations);
 
 const struct inode_operations simple_dir_inode_operations = {
 	.lookup		= simple_lookup,
 };
+EXPORT_SYMBOL(simple_dir_inode_operations);
 
 static const struct super_operations simple_super_operations = {
 	.statfs		= simple_statfs,
@@ -265,8 +278,10 @@ Enomem:
 	deactivate_locked_super(s);
 	return ERR_PTR(-ENOMEM);
 }
+EXPORT_SYMBOL(mount_pseudo);
 
-int simple_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
+int simple_link(struct dentry *old_dentry, struct inode *dir,
+		struct dentry *dentry)
 {
 	struct inode *inode = old_dentry->d_inode;
 
@@ -277,6 +292,7 @@ int simple_link(struct dentry *old_dentry, struct inode *dir, struct dentry *den
 	d_instantiate(dentry, inode);
 	return 0;
 }
+EXPORT_SYMBOL(simple_link);
 
 int simple_empty(struct dentry *dentry)
 {
@@ -297,6 +313,7 @@ out:
 	spin_unlock(&dentry->d_lock);
 	return ret;
 }
+EXPORT_SYMBOL(simple_empty);
 
 int simple_unlink(struct inode *dir, struct dentry *dentry)
 {
@@ -307,6 +324,7 @@ int simple_unlink(struct inode *dir, struct dentry *dentry)
 	dput(dentry);
 	return 0;
 }
+EXPORT_SYMBOL(simple_unlink);
 
 int simple_rmdir(struct inode *dir, struct dentry *dentry)
 {
@@ -318,6 +336,7 @@ int simple_rmdir(struct inode *dir, struct dentry *dentry)
 	drop_nlink(dir);
 	return 0;
 }
+EXPORT_SYMBOL(simple_rmdir);
 
 int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
 		struct inode *new_dir, struct dentry *new_dentry)
@@ -344,6 +363,7 @@ int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	return 0;
 }
+EXPORT_SYMBOL(simple_rename);
 
 /**
  * simple_setattr - setattr for simple filesystem
@@ -386,6 +406,7 @@ int simple_readpage(struct file *file, struct page *page)
 	unlock_page(page);
 	return 0;
 }
+EXPORT_SYMBOL(simple_readpage);
 
 int simple_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
@@ -409,17 +430,18 @@ int simple_write_begin(struct file *file, struct address_space *mapping,
 	}
 	return 0;
 }
+EXPORT_SYMBOL(simple_write_begin);
 
 /**
  * simple_write_end - .write_end helper for non-block-device FSes
  * @available: See .write_end of address_space_operations
- * @file: 		"
- * @mapping: 		"
- * @pos: 		"
- * @len: 		"
- * @copied: 		"
- * @page: 		"
- * @fsdata: 		"
+ * @file:		"
+ * @mapping:		"
+ * @pos:		"
+ * @len:		"
+ * @copied:		"
+ * @page:		"
+ * @fsdata:		"
  *
  * simple_write_end does the minimum needed for updating a page after writing is
  * done. It has the same API signature as the .write_end of
@@ -460,6 +482,7 @@ int simple_write_end(struct file *file, struct address_space *mapping,
 
 	return copied;
 }
+EXPORT_SYMBOL(simple_write_end);
 
 /*
  * the inodes created here are not hashed. If you use iunique to generate
@@ -528,10 +551,12 @@ out:
 	dput(root);
 	return -ENOMEM;
 }
+EXPORT_SYMBOL(simple_fill_super);
 
 static DEFINE_SPINLOCK(pin_fs_lock);
 
-int simple_pin_fs(struct file_system_type *type, struct vfsmount **mount, int *count)
+int simple_pin_fs(struct file_system_type *type, struct vfsmount **mount,
+		  int *count)
 {
 	struct vfsmount *mnt = NULL;
 	spin_lock(&pin_fs_lock);
@@ -550,6 +575,7 @@ int simple_pin_fs(struct file_system_type *type, struct vfsmount **mount, int *c
 	mntput(mnt);
 	return 0;
 }
+EXPORT_SYMBOL(simple_pin_fs);
 
 void simple_release_fs(struct vfsmount **mount, int *count)
 {
@@ -561,6 +587,7 @@ void simple_release_fs(struct vfsmount **mount, int *count)
 	spin_unlock(&pin_fs_lock);
 	mntput(mnt);
 }
+EXPORT_SYMBOL(simple_release_fs);
 
 /**
  * simple_read_from_buffer - copy data from the buffer to user space
@@ -595,6 +622,7 @@ ssize_t simple_read_from_buffer(void __user *to, size_t count, loff_t *ppos,
 	*ppos = pos + count;
 	return count;
 }
+EXPORT_SYMBOL(simple_read_from_buffer);
 
 /**
  * simple_write_to_buffer - copy data from user space to the buffer
@@ -629,6 +657,7 @@ ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
 	*ppos = pos + count;
 	return count;
 }
+EXPORT_SYMBOL(simple_write_to_buffer);
 
 /**
  * memory_read_from_buffer - copy data from the buffer
@@ -660,6 +689,7 @@ ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
 
 	return count;
 }
+EXPORT_SYMBOL(memory_read_from_buffer);
 
 /*
  * Transaction based IO.
@@ -681,8 +711,10 @@ void simple_transaction_set(struct file *file, size_t n)
 	smp_mb();
 	ar->size = n;
 }
+EXPORT_SYMBOL(simple_transaction_set);
 
-char *simple_transaction_get(struct file *file, const char __user *buf, size_t size)
+char *simple_transaction_get(struct file *file, const char __user *buf,
+			     size_t size)
 {
 	struct simple_transaction_argresp *ar;
 	static DEFINE_SPINLOCK(simple_transaction_lock);
@@ -712,8 +744,10 @@ char *simple_transaction_get(struct file *file, const char __user *buf, size_t s
 
 	return ar->data;
 }
+EXPORT_SYMBOL(simple_transaction_get);
 
-ssize_t simple_transaction_read(struct file *file, char __user *buf, size_t size, loff_t *pos)
+ssize_t simple_transaction_read(struct file *file, char __user *buf,
+				size_t size, loff_t *pos)
 {
 	struct simple_transaction_argresp *ar = file->private_data;
 
@@ -721,12 +755,14 @@ ssize_t simple_transaction_read(struct file *file, char __user *buf, size_t size
 		return 0;
 	return simple_read_from_buffer(buf, size, pos, ar->data, ar->size);
 }
+EXPORT_SYMBOL(simple_transaction_read);
 
 int simple_transaction_release(struct inode *inode, struct file *file)
 {
 	free_page((unsigned long)file->private_data);
 	return 0;
 }
+EXPORT_SYMBOL(simple_transaction_release);
 
 /* Simple attribute files */
 
@@ -762,12 +798,14 @@ int simple_attr_open(struct inode *inode, struct file *file,
 
 	return nonseekable_open(inode, file);
 }
+EXPORT_SYMBOL_GPL(simple_attr_open);
 
 int simple_attr_release(struct inode *inode, struct file *file)
 {
 	kfree(file->private_data);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(simple_attr_release);
 
 /* read from the buffer that is filled with the get function */
 ssize_t simple_attr_read(struct file *file, char __user *buf,
@@ -803,6 +841,7 @@ out:
 	mutex_unlock(&attr->mutex);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(simple_attr_read);
 
 /* interpret the buffer as a number to call the set function with */
 ssize_t simple_attr_write(struct file *file, const char __user *buf,
@@ -835,6 +874,7 @@ out:
 	mutex_unlock(&attr->mutex);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(simple_attr_write);
 
 /**
  * generic_fh_to_dentry - generic helper for the fh_to_dentry export operation
@@ -973,38 +1013,4 @@ int noop_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	return 0;
 }
-
-EXPORT_SYMBOL(dcache_dir_close);
-EXPORT_SYMBOL(dcache_dir_lseek);
-EXPORT_SYMBOL(dcache_dir_open);
-EXPORT_SYMBOL(dcache_readdir);
-EXPORT_SYMBOL(generic_read_dir);
-EXPORT_SYMBOL(mount_pseudo);
-EXPORT_SYMBOL(simple_write_begin);
-EXPORT_SYMBOL(simple_write_end);
-EXPORT_SYMBOL(simple_dir_inode_operations);
-EXPORT_SYMBOL(simple_dir_operations);
-EXPORT_SYMBOL(simple_empty);
-EXPORT_SYMBOL(simple_fill_super);
-EXPORT_SYMBOL(simple_getattr);
-EXPORT_SYMBOL(simple_link);
-EXPORT_SYMBOL(simple_lookup);
-EXPORT_SYMBOL(simple_pin_fs);
-EXPORT_SYMBOL(simple_readpage);
-EXPORT_SYMBOL(simple_release_fs);
-EXPORT_SYMBOL(simple_rename);
-EXPORT_SYMBOL(simple_rmdir);
-EXPORT_SYMBOL(simple_statfs);
 EXPORT_SYMBOL(noop_fsync);
-EXPORT_SYMBOL(simple_unlink);
-EXPORT_SYMBOL(simple_read_from_buffer);
-EXPORT_SYMBOL(simple_write_to_buffer);
-EXPORT_SYMBOL(memory_read_from_buffer);
-EXPORT_SYMBOL(simple_transaction_set);
-EXPORT_SYMBOL(simple_transaction_get);
-EXPORT_SYMBOL(simple_transaction_read);
-EXPORT_SYMBOL(simple_transaction_release);
-EXPORT_SYMBOL_GPL(simple_attr_open);
-EXPORT_SYMBOL_GPL(simple_attr_release);
-EXPORT_SYMBOL_GPL(simple_attr_read);
-EXPORT_SYMBOL_GPL(simple_attr_write);
-- 
1.7.6.405.gc1be0

