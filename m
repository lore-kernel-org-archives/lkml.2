Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0HZSgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:36:03 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58060 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab0HZSf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:35:57 -0400
Message-Id: <20100826183507.402136609@szeredi.hu>
References: <20100826183340.027591901@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Thu, 26 Aug 2010 20:33:45 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk,
        jblunck@suse.de, hch@infradead.org
Subject: [PATCH 5/5] union: hybrid union filesystem prototype
Content-Disposition: inline; filename=union.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This union filesystem is a hybrid of entirely filesystem based
(unionfs, aufs) and entierly VFS based (union mounts) solutions.

The dentry tree is duplicated from the underlying filesystems, this
enables fast cached lookups without adding special support into the
VFS.  This uses slightly more memory than union mounts, but dentries
are relatively small.

Inode structures are only duplicated for directories.  Regular files,
symlinks and special files each share a single inode.  This means that
locking victim for unlink is a quasi-filesystem lock, which is
suboptimal, but could be worked around in the VFS.

Opening non directories results in the open forwarded to the
underlying filesystem.  This makes the behavior very similar to union
mounts (with the same limitations vs. fchmod/fchown on O_RDONLY file
descriptors).

Usage:

  mount -t union -olowerdir=/union/lower,upperdir=/union/upper union /mnt/union

Supported:

 - all operations

Missing:

 - upgrade credentials for copy-up
 - ensure that filesystems part of the union are not modified outside
   the union
 - optimize directory merging and caching

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/Kconfig        |    1 
 fs/Makefile       |    1 
 fs/union/Kconfig  |    4 
 fs/union/Makefile |    5 
 fs/union/union.c  | 1714 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 1725 insertions(+)

Index: linux-2.6/fs/union/union.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/fs/union/union.c	2010-08-26 19:12:09.000000000 +0200
@@ -0,0 +1,1714 @@
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/sched.h>
+#include <linux/fs_struct.h>
+#include <linux/file.h>
+#include <linux/xattr.h>
+#include <linux/security.h>
+#include <linux/mount.h>
+#include <linux/splice.h>
+#include <linux/slab.h>
+#include <linux/parser.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+
+MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
+MODULE_DESCRIPTION("Union filesystem");
+MODULE_LICENSE("GPL");
+
+struct union_fs {
+	struct inode *symlink_inode;
+	struct inode *regular_inode;
+	struct inode *special_inode;
+};
+
+struct union_entry {
+	struct path upperpath;
+	struct path lowerpath;
+	bool opaque;
+};
+
+static const char *union_whiteout_xattr = "trusted.union.whiteout";
+static const char *union_opaque_xattr = "trusted.union.opaque";
+
+static struct path *union_path(struct union_entry *ue)
+{
+	return ue->upperpath.dentry ? &ue->upperpath : &ue->lowerpath;
+}
+
+static struct file *path_open(struct path *path, int flags)
+{
+	const struct cred *cred = current_cred();
+
+	path_get(path);
+	return dentry_open(path->dentry, path->mnt, flags, cred);
+}
+
+static int union_real_readdir(struct file *file, void *buf, filldir_t filler)
+{
+	int err;
+	struct file *realfile = file->private_data;
+
+	err = vfs_readdir(realfile, filler, buf);
+	file->f_pos = realfile->f_pos;
+
+	return err;
+}
+
+static loff_t union_real_llseek(struct file *file, loff_t offset, int origin)
+{
+	loff_t res;
+	struct file *realfile = file->private_data;
+
+	res = generic_file_llseek(realfile, offset, origin);
+	file->f_pos = realfile->f_pos;
+
+	return res;
+}
+
+static int union_real_dir_fsync(struct file *file, int datasync)
+{
+	struct file *realfile = file->private_data;
+	return vfs_fsync(realfile, datasync);
+}
+
+static int union_real_dir_release(struct inode *inode, struct file *file)
+{
+	struct file *realfile = file->private_data;
+
+	fput(realfile);
+	return 0;
+}
+
+static const struct file_operations union_real_dir_operations = {
+	.read		= generic_read_dir,
+	.readdir	= union_real_readdir,
+	.llseek		= union_real_llseek,
+	.fsync		= union_real_dir_fsync,
+	.release	= union_real_dir_release,
+};
+
+static int union_real_dir_open(struct file *file)
+{
+	struct union_entry *ue = file->f_path.dentry->d_fsdata;
+	struct path *realpath = union_path(ue);
+	struct file *realfile;
+
+	realfile = path_open(realpath, file->f_flags);
+	if (IS_ERR(realfile))
+		return PTR_ERR(realfile);
+
+	file->private_data = realfile;
+	file->f_op = &union_real_dir_operations;
+
+	return 0;
+}
+
+static int union_dir_open(struct inode *inode, struct file *file)
+{
+	struct union_entry *ue = file->f_path.dentry->d_fsdata;
+
+	if (ue->upperpath.dentry && ue->lowerpath.dentry)
+		return 0;
+	else
+		return union_real_dir_open(file);
+}
+
+static bool union_is_whiteout(struct dentry *dentry)
+{
+	int res;
+	char val;
+
+	if (!dentry)
+		return false;
+	if (!dentry->d_inode)
+		return false;
+	if (!S_ISLNK(dentry->d_inode->i_mode))
+		return false;
+
+	res = vfs_getxattr(dentry, union_whiteout_xattr, &val, 1);
+	if (res == 1 && val == 'y')
+		return true;
+
+	return false;
+}
+
+static bool union_is_opaquedir(struct dentry *dentry)
+{
+	int res;
+	char val;
+
+	if (!S_ISDIR(dentry->d_inode->i_mode))
+		return false;
+
+	res = vfs_getxattr(dentry, union_opaque_xattr, &val, 1);
+	if (res == 1 && val == 'y')
+		return true;
+
+	return false;
+}
+
+struct union_cache_entry {
+	struct union_cache_entry *next;
+	struct qstr name;
+	unsigned int type;
+	u64 ino;
+	bool is_whiteout;
+};
+
+struct union_cache_callback {
+	struct union_cache_entry *list;
+	struct union_cache_entry **endp;
+	struct path path;
+	int count;
+};
+
+static int union_cache_add_entry(struct union_cache_callback *cb,
+				 const char *name, int namelen, u64 ino,
+				 unsigned int d_type, bool is_whiteout)
+{
+	struct union_cache_entry *p;
+
+	p = kmalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	p->name.name = kstrndup(name, namelen, GFP_KERNEL);
+	if (!p->name.name) {
+		kfree(p);
+		return -ENOMEM;
+	}
+	p->name.len = namelen;
+	p->name.hash = 0;
+	p->type = d_type;
+	p->ino = ino;
+	p->is_whiteout = is_whiteout;
+	p->next = NULL;
+	*cb->endp = p;
+	cb->endp = &p->next;
+
+	return 0;
+}
+
+static void union_cache_free(struct union_cache_entry *p)
+{
+	while (p) {
+		struct union_cache_entry *next = p->next;
+
+		kfree(p->name.name);
+		kfree(p);
+		p = next;
+	}
+}
+
+static int union_cache_find_entry(struct union_cache_entry *start,
+				  const char *name, int namelen)
+{
+	struct union_cache_entry *p;
+	int ret = 0;
+
+	for (p = start; p; p = p->next) {
+		if (p->name.len != namelen)
+			continue;
+		if (strncmp(p->name.name, name, namelen) == 0) {
+			ret = 1;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int union_fill_lower(void *buf, const char *name, int namlen,
+			    loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct union_cache_callback *cb = buf;
+
+	cb->count++;
+	if (!union_cache_find_entry(cb->list, name, namlen))
+		union_cache_add_entry(cb, name, namlen, ino, d_type, false);
+
+	return 0;
+}
+
+static int union_fill_upper(void *buf, const char *name, int namlen,
+			    loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct union_cache_callback *cb = buf;
+	bool is_whiteout = false;
+
+	cb->count++;
+	if (d_type == DT_LNK) {
+		struct dentry *dentry;
+
+		dentry = lookup_one_len(name, cb->path.dentry, strlen(name));
+		if (!IS_ERR(dentry)) {
+			is_whiteout = union_is_whiteout(dentry);
+			dput(dentry);
+		}
+	}
+	union_cache_add_entry(cb, name, namlen, ino, d_type, is_whiteout);
+
+	return 0;
+}
+
+static int union_fill_cache(struct path *realpath,
+			    struct union_cache_callback *cb,
+			    filldir_t filler)
+{
+	struct file *realfile;
+	int err;
+
+	realfile = path_open(realpath, O_RDONLY | O_DIRECTORY);
+	if (IS_ERR(realfile))
+		return PTR_ERR(realfile);
+
+	do {
+		cb->count = 0;
+		err = vfs_readdir(realfile, filler, cb);
+	} while (err >= 0 && cb->count);
+	fput(realfile);
+
+	if (err < 0) {
+		union_cache_free(cb->list);
+		cb->list = NULL;
+		return err;
+	}
+
+	return 0;
+}
+
+static int union_readdir(struct file *file, void *buf, filldir_t filler)
+{
+	struct union_entry *ue = file->f_path.dentry->d_fsdata;
+	struct union_cache_entry *union_cache = file->private_data;
+	struct union_cache_entry *p;
+	loff_t off;
+	int res = 0;
+
+	if (!file->f_pos && union_cache) {
+		union_cache_free(union_cache);
+		union_cache = NULL;
+	}
+
+	if (!union_cache) {
+		struct union_cache_callback cb;
+
+		cb.list = NULL;
+		cb.endp = &cb.list;
+		cb.path = ue->upperpath;
+
+		res = union_fill_cache(&ue->upperpath, &cb, union_fill_upper);
+		if (!res) {
+			res = union_fill_cache(&ue->lowerpath, &cb,
+					       union_fill_lower);
+		}
+		if (res)
+			return res;
+
+		union_cache = cb.list;
+		file->private_data = union_cache;
+	}
+
+	off = 0;
+	for (p = union_cache; p; p = p->next) {
+		int over;
+
+		if (p->is_whiteout)
+			continue;
+
+		off++;
+		if (off <= file->f_pos)
+			continue;
+
+		over = filler(buf, p->name.name, p->name.len, off - 1,
+			      p->ino, p->type);
+		if (over)
+			break;
+
+		file->f_pos = off;
+	}
+
+	return res;
+}
+
+static int union_dir_fsync(struct file *file, int datasync)
+{
+	int err;
+	struct union_entry *ue = file->f_path.dentry->d_fsdata;
+	struct file *realfile;
+
+	realfile = path_open(&ue->upperpath, O_RDONLY);
+	if (IS_ERR(realfile))
+		return PTR_ERR(realfile);
+
+	err = vfs_fsync(realfile, datasync);
+	fput(realfile);
+
+	return err;
+}
+
+static int union_dir_release(struct inode *inode, struct file *file)
+{
+	struct union_cache_entry *union_cache = file->private_data;
+
+	union_cache_free(union_cache);
+
+	return 0;
+}
+
+static const struct file_operations union_dir_operations = {
+	.read		= generic_read_dir,
+	.open		= union_dir_open,
+	.readdir	= union_readdir,
+	.llseek		= generic_file_llseek,
+	.fsync		= union_dir_fsync,
+	.release	= union_dir_release,
+};
+
+static const struct inode_operations union_dir_inode_operations;
+
+static void union_dentry_release(struct dentry *dentry)
+{
+	struct union_entry *ue = dentry->d_fsdata;
+
+	if (ue) {
+		path_put(&ue->upperpath);
+		path_put(&ue->lowerpath);
+		kfree(ue);
+	}
+}
+
+static void union_dentry_iput(struct dentry *dentry, struct inode *inode)
+{
+	struct union_entry *ue = dentry->d_fsdata;
+
+	path_put(&ue->upperpath);
+	path_put(&ue->lowerpath);
+	ue->upperpath.dentry = NULL;
+	ue->upperpath.mnt = NULL;
+	ue->lowerpath.dentry = NULL;
+	ue->lowerpath.mnt = NULL;
+	iput(inode);
+}
+
+static const struct dentry_operations union_dentry_operations = {
+	.d_release = union_dentry_release,
+	.d_iput = union_dentry_iput,
+};
+
+static struct inode *union_new_inode(struct super_block *sb, umode_t mode)
+{
+	struct union_fs *ufs = sb->s_fs_info;
+	struct inode *inode;
+
+	switch (mode & S_IFMT) {
+	case S_IFDIR:
+		inode = new_inode(sb);
+		inode->i_flags |= S_NOATIME|S_NOCMTIME;
+		inode->i_op = &union_dir_inode_operations;
+		inode->i_fop = &union_dir_operations;
+		inode->i_mode = mode & S_IFMT;
+		break;
+
+	case S_IFLNK:
+		inode = ufs->symlink_inode;
+		atomic_inc(&inode->i_count);
+		break;
+
+	case S_IFREG:
+		inode = ufs->regular_inode;
+		atomic_inc(&inode->i_count);
+		break;
+
+	case S_IFSOCK:
+	case S_IFBLK:
+	case S_IFCHR:
+	case S_IFIFO:
+		inode = ufs->special_inode;
+		atomic_inc(&inode->i_count);
+		break;
+
+	default:
+		WARN(1, "illegal file type: %i\n", mode & S_IFMT);
+		inode = NULL;
+	}
+
+	return inode;
+
+}
+
+static struct dentry *union_lookup_real(struct dentry *dir, struct qstr *name)
+{
+	struct dentry *dentry;
+
+	mutex_lock(&dir->d_inode->i_mutex);
+	dentry = lookup_one_len(name->name, dir, name->len);
+	mutex_unlock(&dir->d_inode->i_mutex);
+
+	if (IS_ERR(dentry)) {
+		if (PTR_ERR(dentry) == -ENOENT)
+			dentry = NULL;
+	} else if (!dentry->d_inode) {
+		dput(dentry);
+		dentry = NULL;
+	}
+	return dentry;
+}
+
+static struct dentry *union_lookup(struct inode *dir, struct dentry *dentry,
+				   struct nameidata *nd)
+{
+	struct union_entry *pue = dentry->d_parent->d_fsdata;
+	struct union_entry *ue;
+	struct dentry *upperdir = pue->upperpath.dentry;
+	struct dentry *upperdentry = NULL;
+	struct dentry *lowerdir = pue->lowerpath.dentry;
+	struct dentry *lowerdentry = NULL;
+	struct inode *inode = NULL;
+	int err;
+
+	err = -ENOMEM;
+	ue = kzalloc(sizeof(struct union_entry), GFP_KERNEL);
+	if (!ue)
+		goto out;
+
+	if (upperdir) {
+		upperdentry = union_lookup_real(upperdir, &dentry->d_name);
+		err = PTR_ERR(upperdentry);
+		if (IS_ERR(upperdentry))
+			goto out_free;
+
+		if (upperdentry) {
+			if (union_is_opaquedir(upperdentry))
+				ue->opaque = true;
+			else if (union_is_whiteout(upperdentry)) {
+				dput(upperdentry);
+				upperdentry = NULL;
+				ue->opaque = true;
+			}
+		}
+	}
+	if (lowerdir && !ue->opaque) {
+		lowerdentry = union_lookup_real(lowerdir, &dentry->d_name);
+		if (IS_ERR(lowerdentry)) {
+			err = PTR_ERR(lowerdentry);
+			dput(upperdentry);
+			goto out_free;
+		}
+	}
+
+	if (lowerdentry && upperdentry &&
+	    (!S_ISDIR(upperdentry->d_inode->i_mode) ||
+	     !S_ISDIR(lowerdentry->d_inode->i_mode))) {
+		dput(lowerdentry);
+		lowerdentry = NULL;
+		ue->opaque = true;
+	}
+
+	if (lowerdentry || upperdentry) {
+		struct dentry *realdentry;
+
+		realdentry = upperdentry ? upperdentry : lowerdentry;
+		inode = union_new_inode(dir->i_sb, realdentry->d_inode->i_mode);
+		if (!inode)
+			goto out_dput;
+	}
+
+	if (upperdentry) {
+		ue->upperpath.mnt = pue->upperpath.mnt;
+		ue->upperpath.dentry = upperdentry;
+		path_get(&ue->upperpath);
+		dput(upperdentry);
+	}
+	if (lowerdentry) {
+		ue->lowerpath.mnt = pue->lowerpath.mnt;
+		ue->lowerpath.dentry = lowerdentry;
+		path_get(&ue->lowerpath);
+		dput(lowerdentry);
+	}
+
+	d_add(dentry, inode);
+	dentry->d_fsdata = ue;
+	dentry->d_op = &union_dentry_operations;
+
+	return NULL;
+
+out_dput:
+	dput(upperdentry);
+	dput(lowerdentry);
+out_free:
+	kfree(ue);
+out:
+	return ERR_PTR(err);
+}
+
+static int union_copy_up_xattr(struct dentry *old, struct dentry *new)
+{
+	ssize_t list_size, size;
+	char *buf, *name, *value;
+	int error;
+
+	if (!old->d_inode->i_op->getxattr ||
+	    !new->d_inode->i_op->getxattr)
+		return 0;
+
+	list_size = vfs_listxattr(old, NULL, 0);
+	if (list_size <= 0)
+		return list_size;
+
+	buf = kzalloc(list_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	error = -ENOMEM;
+	value = kmalloc(XATTR_SIZE_MAX, GFP_KERNEL);
+	if (!value)
+		goto out;
+
+	list_size = vfs_listxattr(old, buf, list_size);
+	if (list_size <= 0) {
+		error = list_size;
+		goto out_free_value;
+	}
+
+	for (name = buf; name < (buf + list_size); name += strlen(name) + 1) {
+		size = vfs_getxattr(old, name, value, XATTR_SIZE_MAX);
+		if (size <= 0) {
+			error = size;
+			goto out_free_value;
+		}
+		error = vfs_setxattr(new, name, value, size, 0);
+		if (error)
+			goto out_free_value;
+	}
+
+out_free_value:
+	kfree(value);
+out:
+	kfree(buf);
+	return error;
+}
+
+static int union_copy_up_data(struct path *old, struct path *new, size_t len)
+{
+	struct file *old_file;
+	struct file *new_file;
+	loff_t offset = 0;
+	long bytes;
+	int error = 0;
+
+	if (len == 0)
+		return 0;
+
+	old_file = path_open(old, O_RDONLY);
+	if (IS_ERR(old_file))
+		return PTR_ERR(old_file);
+
+	new_file = path_open(new, O_WRONLY);
+	if (IS_ERR(new_file)) {
+		error = PTR_ERR(new_file);
+		goto out_fput;
+	}
+
+	bytes = do_splice_direct(old_file, &offset, new_file, len,
+				 SPLICE_F_MOVE);
+	if (bytes < 0)
+		error = bytes;
+
+	fput(new_file);
+out_fput:
+	fput(old_file);
+	return error;
+}
+
+static struct dentry *union_lookup_create(struct union_entry *ue,
+					  struct union_entry *pue,
+					  struct qstr *name)
+{
+	int err;
+	struct inode *upperdir = pue->upperpath.dentry->d_inode;
+	struct dentry *newdentry;
+
+	newdentry = lookup_one_len(name->name, pue->upperpath.dentry, name->len);
+	if (IS_ERR(newdentry))
+		return newdentry;
+
+	if (ue->opaque) {
+		err = -EINVAL;
+		if (WARN_ON(!union_is_whiteout(newdentry)))
+			goto out_dput;
+
+		err = vfs_unlink(upperdir, newdentry);
+		if (err)
+			goto out_dput;
+
+		dput(newdentry);
+		newdentry = lookup_one_len(name->name, pue->upperpath.dentry, name->len);
+		if (IS_ERR(newdentry))
+			return newdentry;
+	}
+
+	err = -EEXIST;
+	if (newdentry->d_inode)
+		goto out_dput;
+
+	return newdentry;
+
+out_dput:
+	dput(newdentry);
+	return ERR_PTR(err);
+}
+
+static int union_upper_create(struct dentry *dentry, struct iattr *attr,
+			      dev_t rdev, const char *link, struct path *src)
+{
+	int err;
+	int attr_update = ATTR_UID | ATTR_GID | ATTR_ATIME_SET | ATTR_MTIME_SET;
+	struct dentry *parent = dget_parent(dentry);
+	struct union_entry *ue = dentry->d_fsdata;
+	struct union_entry *pue = parent->d_fsdata;
+	struct inode *upperdir = pue->upperpath.dentry->d_inode;
+	struct dentry *newdentry;
+	struct path newpath;
+
+	mutex_lock_nested(&upperdir->i_mutex, I_MUTEX_PARENT);
+
+	/*
+	 * Using upper filesystem locking to protect against copy up
+	 * racing with rename (rename means the copy up was already
+	 * successful).
+	 */
+	err = -EEXIST;
+	if (dentry->d_parent != parent)
+		goto out_unlock;
+
+	newdentry = union_lookup_create(ue, pue, &dentry->d_name);
+	err = PTR_ERR(newdentry);
+	if (IS_ERR(newdentry))
+		goto out_unlock;
+
+	newpath.dentry = newdentry;
+	newpath.mnt = pue->upperpath.mnt;
+
+	switch (attr->ia_mode & S_IFMT) {
+	case S_IFREG:
+		if (src)
+			WARN_ON(!(attr->ia_valid & ATTR_SIZE));
+		else
+			WARN_ON((attr->ia_valid & ATTR_SIZE));
+
+		err = vfs_create(upperdir, newdentry, attr->ia_mode, NULL);
+		if (!err && src) {
+			attr_update |= ATTR_SIZE;
+			err = union_copy_up_data(src, &newpath, attr->ia_size);
+		}
+		break;
+
+	case S_IFDIR:
+		err = vfs_mkdir(upperdir, newdentry, attr->ia_mode);
+		break;
+
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFIFO:
+	case S_IFSOCK:
+		err = vfs_mknod(upperdir, newdentry, attr->ia_mode, rdev);
+		break;
+
+	case S_IFLNK:
+		err = vfs_symlink(upperdir, newdentry, link);
+		break;
+
+	default:
+		err = -EPERM;
+	}
+
+	if (!err && (attr->ia_valid & attr_update)) {
+		mutex_lock(&newdentry->d_inode->i_mutex);
+		err = notify_change(newdentry, attr);
+		mutex_unlock(&newdentry->d_inode->i_mutex);
+	}
+
+	if (!err && src)
+		err = union_copy_up_xattr(src->dentry, newdentry);
+
+	if (!err && ue->opaque && S_ISDIR(newdentry->d_inode->i_mode))
+		err = vfs_setxattr(newdentry, union_opaque_xattr, "y", 1, 0);
+
+	if (!err) {
+		ue->upperpath = newpath;
+		path_get(&ue->upperpath);
+		/* FIXME: release lowerpath? */
+		if (ue->lowerpath.dentry)
+			ue->opaque = true;
+	} else if (!ue->opaque) {
+		vfs_unlink(upperdir, newdentry);
+	}
+
+	dput(newdentry);
+out_unlock:
+	mutex_unlock(&upperdir->i_mutex);
+	dput(parent);
+
+	return err;
+}
+
+static char *union_read_symlink(struct path *path)
+{
+	int res;
+	char *buf;
+	struct inode *inode = path->dentry->d_inode;
+	mm_segment_t old_fs;
+
+	res = -EINVAL;
+	if (!inode->i_op->readlink)
+		goto err;
+
+	res = -ENOMEM;
+	buf = (char *) __get_free_page(GFP_KERNEL);
+	if (!buf)
+		goto err;
+
+	old_fs = get_fs();
+	set_fs(get_ds());
+	/* The cast to a user pointer is valid due to the set_fs() */
+	res = inode->i_op->readlink(path->dentry,
+				    (char __user *)buf, PAGE_SIZE - 1);
+	set_fs(old_fs);
+	if (res < 0) {
+		free_page((unsigned long) buf);
+		goto err;
+	}
+	buf[res] = '\0';
+
+	return buf;
+
+err:
+	return ERR_PTR(res);
+}
+
+static int union_copy_up_one(struct dentry *dentry, struct iattr *attr)
+{
+	int err;
+	struct union_entry *ue = dentry->d_fsdata;
+	struct inode *lowerinode = ue->lowerpath.dentry->d_inode;
+	struct iattr newattr = *attr;
+	char *link = NULL;
+
+	/* FIXME: use getattr() instead of accessing attributes directly */
+
+	/* ATTR_KILL_S*ID trumps ATTR_MODE */
+	if (newattr.ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID)) {
+		newattr.ia_mode = lowerinode->i_mode;
+		if (newattr.ia_valid & ATTR_KILL_SUID)
+			newattr.ia_mode &= ~S_ISUID;
+		if (newattr.ia_valid & ATTR_KILL_SGID)
+			newattr.ia_mode &= ~S_ISGID;
+		newattr.ia_valid &= ~(ATTR_KILL_SUID | ATTR_KILL_SGID);
+	} else if (!(newattr.ia_valid & ATTR_MODE)) {
+		newattr.ia_mode = lowerinode->i_mode;
+		newattr.ia_valid |= ATTR_MODE;
+	} else {
+		newattr.ia_mode &= 07777;
+		newattr.ia_mode |= lowerinode->i_mode & S_IFMT;
+	}
+	if (!(newattr.ia_valid & ATTR_UID)) {
+		newattr.ia_uid = lowerinode->i_uid;
+		newattr.ia_valid |= ATTR_UID;
+	}
+	if (!(newattr.ia_valid & ATTR_GID)) {
+		newattr.ia_gid = lowerinode->i_gid;
+		newattr.ia_valid |= ATTR_GID;
+	}
+	if (!(newattr.ia_valid & ATTR_SIZE)) {
+		newattr.ia_size = lowerinode->i_size;
+		newattr.ia_valid |= ATTR_SIZE;
+	}
+	if (!(newattr.ia_valid & ATTR_ATIME)) {
+		newattr.ia_atime = lowerinode->i_atime;
+		newattr.ia_valid |= ATTR_ATIME | ATTR_ATIME_SET;
+	}
+	if (!(newattr.ia_valid & ATTR_MTIME)) {
+		newattr.ia_mtime = lowerinode->i_mtime;
+		newattr.ia_valid |= ATTR_MTIME | ATTR_MTIME_SET;
+	}
+
+	newattr.ia_valid &= ~ATTR_CTIME;
+
+	if (S_ISLNK(lowerinode->i_mode)) {
+		link = union_read_symlink(&ue->lowerpath);
+		if (IS_ERR(link))
+			return PTR_ERR(link);
+	}
+
+	err = union_upper_create(dentry, &newattr, lowerinode->i_rdev, link,
+				 &ue->lowerpath);
+
+	if (link)
+		free_page((unsigned long) link);
+
+	/* Already copied up? */
+	if (err == -EEXIST && ue->upperpath.dentry)
+		err = 0;
+
+	return err;
+}
+
+static int union_copy_up_attr(struct dentry *dentry, struct iattr *attr)
+{
+	struct union_entry *ue = dentry->d_fsdata;
+	int err = 0;
+
+	while (!err && !ue->upperpath.dentry) {
+		struct dentry *next = dget(dentry);
+		struct dentry *parent;
+
+		/* find the topmost dentry not yet copied up */
+		for (;;) {
+			struct union_entry *pue;
+
+			parent = dget_parent(next);
+			pue = parent->d_fsdata;
+
+			if (pue->upperpath.dentry)
+				break;
+
+			dput(next);
+			next = parent;
+		}
+		if (next == dentry) {
+			err = union_copy_up_one(next, attr);
+		} else {
+			struct iattr noattr = { .ia_valid = 0 };
+			err = union_copy_up_one(next, &noattr);
+		}
+		dput(parent);
+		dput(next);
+	}
+	return err;
+}
+
+static int union_copy_up(struct dentry *dentry)
+{
+	struct iattr noattr = { .ia_valid = 0 };
+
+	return union_copy_up_attr(dentry, &noattr);
+}
+
+static int union_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	struct inode *inode;
+	struct union_entry *ue = dentry->d_fsdata;
+	int err;
+
+	if (!ue->upperpath.dentry)
+		return union_copy_up_attr(dentry, attr);
+
+	inode = ue->upperpath.dentry->d_inode;
+
+	mutex_lock(&inode->i_mutex);
+	err = notify_change(ue->upperpath.dentry, attr);
+	mutex_unlock(&inode->i_mutex);
+
+	return err;
+}
+
+static int union_getattr(struct vfsmount *mnt, struct dentry *dentry,
+			 struct kstat *stat)
+{
+	struct union_entry *ue = dentry->d_fsdata;
+	struct path *realpath = union_path(ue);
+
+	return vfs_getattr(realpath->mnt, realpath->dentry, stat);
+}
+
+static int union_dir_getattr(struct vfsmount *mnt, struct dentry *dentry,
+			 struct kstat *stat)
+{
+	int err;
+	struct union_entry *ue = dentry->d_fsdata;
+	struct path *realpath = union_path(ue);
+
+	err = vfs_getattr(realpath->mnt, realpath->dentry, stat);
+
+	/* FIXME: better st_ino management */
+	stat->ino = dentry->d_inode->i_ino;
+
+	return err;
+}
+
+static int union_permission(struct dentry *dentry, int mask)
+{
+	struct union_entry *ue = dentry->d_fsdata;
+	struct inode *inode;
+	int err;
+
+	if (ue->upperpath.dentry)
+		return dentry_permission(ue->upperpath.dentry, mask);
+
+	inode = ue->lowerpath.dentry->d_inode;
+	if (!(mask & MAY_WRITE) || special_file(inode->i_mode))
+		return dentry_permission(ue->lowerpath.dentry, mask);
+
+	/* Don't check for read-only fs */
+	if (mask & MAY_WRITE) {
+		if (IS_IMMUTABLE(inode))
+			return -EACCES;
+	}
+
+	if (inode->i_op->permission)
+		err = inode->i_op->permission(ue->lowerpath.dentry, mask);
+	else
+		err = generic_permission(inode, mask, inode->i_op->check_acl);
+
+	if (err)
+		return err;
+
+	return security_inode_permission(inode, mask);
+}
+
+static int union_create_object(struct dentry *dentry, int mode, dev_t rdev,
+			       const char *link)
+{
+	int err;
+	struct inode *inode;
+	struct union_entry *ue;
+	struct iattr attr = {
+		.ia_valid = ATTR_MODE,
+		.ia_mode = mode,
+	};
+
+	ue = dentry->d_fsdata;
+
+	err = -ENOMEM;
+	inode = union_new_inode(dentry->d_sb, mode);
+	if (!inode)
+		goto out;
+
+	err = union_copy_up(dentry->d_parent);
+	if (err)
+		goto out_iput;
+
+	err = union_upper_create(dentry, &attr, rdev, link, NULL);
+	if (err)
+		goto out_iput;
+
+	d_instantiate(dentry, inode);
+
+	return 0;
+
+out_iput:
+	iput(inode);
+out:
+	return err;
+}
+
+static int union_create(struct inode *dir, struct dentry *dentry, int mode,
+			struct nameidata *nd)
+{
+	return union_create_object(dentry, (mode & 07777) | S_IFREG, 0, NULL);
+}
+
+static int union_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	return union_create_object(dentry, (mode & 07777) | S_IFDIR, 0, NULL);
+}
+
+static int union_mknod(struct inode *dir, struct dentry *dentry, int mode,
+		       dev_t rdev)
+{
+	return union_create_object(dentry, mode, rdev, NULL);
+}
+
+static int union_symlink(struct inode *dir, struct dentry *dentry,
+			 const char *link)
+{
+	return union_create_object(dentry, S_IFLNK, 0, link);
+}
+
+static void *union_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	struct union_entry *ue = dentry->d_fsdata;
+	struct path *realpath = union_path(ue);
+	struct inode *realinode = realpath->dentry->d_inode;
+
+	if (!realinode->i_op->follow_link) {
+		path_put(&nd->path);
+		nd->path = *realpath;
+		path_get(&nd->path);
+		return NULL;
+	}
+
+	return realinode->i_op->follow_link(realpath->dentry, nd);
+}
+
+static void union_put_link(struct dentry *dentry, struct nameidata *nd, void *c)
+{
+	struct union_entry *ue = dentry->d_fsdata;
+	struct path *realpath = union_path(ue);
+	struct inode *realinode = realpath->dentry->d_inode;
+
+	if (!realinode->i_op->follow_link || !realinode->i_op->put_link)
+		return;
+
+	realinode->i_op->put_link(realpath->dentry, nd, c);
+}
+
+static int union_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
+{
+	struct union_entry *ue = dentry->d_fsdata;
+	struct path *realpath = union_path(ue);
+	struct inode *realinode = realpath->dentry->d_inode;
+
+	if (!realinode->i_op->readlink)
+		return -EINVAL;
+
+	touch_atime(realpath->mnt, realpath->dentry);
+	return realinode->i_op->readlink(realpath->dentry, buf, bufsiz);
+}
+
+static int union_whiteout(struct dentry *dentry)
+{
+	int err;
+	struct union_entry *pue = dentry->d_parent->d_fsdata;
+	struct dentry *newdentry;
+
+	newdentry = lookup_one_len(dentry->d_name.name, pue->upperpath.dentry,
+				   dentry->d_name.len);
+	err = PTR_ERR(newdentry);
+	if (IS_ERR(newdentry))
+		goto out;
+
+	if (WARN_ON(newdentry->d_inode))
+		goto out_dput;
+
+	err = vfs_symlink(pue->upperpath.dentry->d_inode, newdentry,
+			  "(union-whiteout)");
+	if (err)
+		goto out_dput;
+
+	err = vfs_setxattr(newdentry, union_whiteout_xattr, "y", 1, 0);
+
+out_dput:
+	dput(newdentry);
+out:
+	return err;
+}
+
+static int union_unlink(struct inode *dir, struct dentry *dentry)
+{
+	int err;
+	struct union_entry *ue = dentry->d_fsdata;
+	struct union_entry *pue;
+	struct inode *upperdir;
+
+	err = union_copy_up(dentry->d_parent);
+	if (err)
+		return err;
+
+	pue = dentry->d_parent->d_fsdata;
+	upperdir = pue->upperpath.dentry->d_inode;
+
+	mutex_lock_nested(&upperdir->i_mutex, I_MUTEX_PARENT);
+	if (ue->upperpath.dentry) {
+		err = vfs_unlink(upperdir, ue->upperpath.dentry);
+		if (err)
+			goto out_unlock;
+	} else {
+		ue->opaque = true;
+	}
+
+	if (ue->opaque)
+		err = union_whiteout(dentry);
+out_unlock:
+	mutex_unlock(&upperdir->i_mutex);
+
+	return err;
+}
+
+static int union_check_empty_dir(struct dentry *dentry)
+{
+	int err;
+	struct union_entry *ue = dentry->d_fsdata;
+	struct union_cache_callback cb;
+	struct union_cache_entry *p;
+
+	cb.list = NULL;
+	cb.endp = &cb.list;
+	cb.path = ue->upperpath;
+
+	if (ue->upperpath.dentry) {
+		err = union_fill_cache(&ue->upperpath, &cb, union_fill_upper);
+		if (err)
+			return err;
+	}
+	err = union_fill_cache(&ue->lowerpath, &cb, union_fill_lower);
+	if (err)
+		return err;
+
+	err = 0;
+	for (p = cb.list; p; p = p->next) {
+		if (p->is_whiteout)
+			continue;
+
+		if (p->name.name[0] == '.') {
+			if (p->name.len == 1)
+				continue;
+			if (p->name.len == 2 && p->name.name[1] == '.')
+				continue;
+		}
+		err = -ENOTEMPTY;
+		break;
+	}
+
+	union_cache_free(cb.list);
+
+	return err;
+}
+
+static int union_unlink_whiteout(void *buf, const char *name, int namlen,
+				 loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct union_cache_callback *cb = buf;
+
+	cb->count++;
+	if (d_type == DT_LNK) {
+		int err;
+		struct dentry *dentry;
+
+		dentry = lookup_one_len(name, cb->path.dentry, strlen(name));
+		if (IS_ERR(dentry))
+			return PTR_ERR(dentry);
+
+		err = vfs_unlink(cb->path.dentry->d_inode, dentry);
+		dput(dentry);
+
+		return err;
+	}
+
+	return 0;
+}
+
+static int union_remove_whiteouts(struct dentry *dentry)
+{
+	struct union_entry *ue = dentry->d_fsdata;
+	struct union_cache_callback cb;
+
+	if (!ue->upperpath.dentry)
+		return 0;
+
+	cb.path = ue->upperpath;
+	return union_fill_cache(&ue->upperpath, &cb, union_unlink_whiteout);
+}
+
+static int union_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	int err;
+	struct union_entry *ue = dentry->d_fsdata;
+	struct union_entry *pue;
+	struct inode *upperdir;
+
+	if (ue->lowerpath.dentry) {
+		err = union_check_empty_dir(dentry);
+		if (err)
+			return err;
+
+		err = union_copy_up(dentry->d_parent);
+		if (err)
+			return err;
+
+		err = union_remove_whiteouts(dentry);
+		if (err)
+			return err;
+	}
+
+	pue = dentry->d_parent->d_fsdata;
+	upperdir = pue->upperpath.dentry->d_inode;
+
+	mutex_lock_nested(&upperdir->i_mutex, I_MUTEX_PARENT);
+	if (ue->upperpath.dentry) {
+		err = vfs_rmdir(upperdir, ue->upperpath.dentry);
+		if (err)
+			goto out_unlock;
+	}
+	if (ue->lowerpath.dentry)
+		ue->opaque = true;
+
+	if (ue->opaque)
+		err = union_whiteout(dentry);
+out_unlock:
+	mutex_unlock(&upperdir->i_mutex);
+
+	return err;
+}
+
+static int union_link(struct dentry *old, struct inode *newdir,
+		      struct dentry *new)
+{
+	int err;
+	struct dentry *newdentry;
+	struct union_entry *new_ue = new->d_fsdata;
+	struct union_entry *old_ue = old->d_fsdata;
+	struct union_entry *pue = new->d_parent->d_fsdata;
+	struct inode *upperdir;
+
+	err = union_copy_up(old);
+	if (err)
+		goto out;
+
+	err = union_copy_up(new->d_parent);
+	if (err)
+		goto out;
+
+	upperdir = pue->upperpath.dentry->d_inode;
+	mutex_lock_nested(&upperdir->i_mutex, I_MUTEX_PARENT);
+	newdentry = union_lookup_create(new_ue, pue, &new->d_name);
+	err = PTR_ERR(newdentry);
+	if (IS_ERR(newdentry))
+		goto out_unlock;
+
+	err = vfs_link(old_ue->upperpath.dentry, upperdir, newdentry);
+	if (!err) {
+		struct inode *inode = old->d_inode;
+
+		atomic_inc(&inode->i_count);
+		d_instantiate(new, inode);
+
+		new_ue->upperpath.dentry = newdentry;
+		new_ue->upperpath.mnt = pue->upperpath.mnt;
+		path_get(&new_ue->upperpath);
+	}
+	dput(newdentry);
+out_unlock:
+	mutex_unlock(&upperdir->i_mutex);
+out:
+	return err;
+
+}
+
+static int union_rename(struct inode *olddir, struct dentry *old,
+			struct inode *newdir, struct dentry *new)
+{
+	int err;
+	struct union_entry *old_ue = old->d_fsdata;
+	struct union_entry *new_ue = new->d_fsdata;
+	struct union_entry *old_pue = old->d_parent->d_fsdata;
+	struct union_entry *new_pue = new->d_parent->d_fsdata;
+	struct dentry *old_upperdir;
+	struct dentry *new_upperdir;
+	struct dentry *olddentry;
+	struct dentry *newdentry;
+	struct dentry *trap;
+	bool prev_opaque;
+
+	/* Don't copy up directory trees */
+	if (old_ue->lowerpath.dentry &&
+	    S_ISDIR(old_ue->lowerpath.dentry->d_inode->i_mode))
+		return -EXDEV;
+
+	if (new_ue->lowerpath.dentry &&
+	    S_ISDIR(new_ue->lowerpath.dentry->d_inode->i_mode)) {
+		err = union_check_empty_dir(new);
+		if (err)
+			return err;
+	}
+
+	err = union_copy_up(old);
+	if (err)
+		return err;
+
+	err = union_copy_up(new->d_parent);
+	if (err)
+		return err;
+
+	if (new_ue->lowerpath.dentry &&
+	    S_ISDIR(new_ue->lowerpath.dentry->d_inode->i_mode)) {
+		err = union_remove_whiteouts(new);
+		if (err)
+			return err;
+	}
+
+	old_upperdir = old_pue->upperpath.dentry;
+	new_upperdir = new_pue->upperpath.dentry;
+	trap = lock_rename(new_upperdir, old_upperdir);
+
+	olddentry = old_ue->upperpath.dentry;
+	newdentry = dget(new_ue->upperpath.dentry);
+	if (!newdentry) {
+		newdentry = union_lookup_create(new_ue, new_pue, &new->d_name);
+		err = PTR_ERR(newdentry);
+		if (IS_ERR(newdentry))
+			goto out_unlock;
+	}
+
+	err = -EINVAL;
+	if (WARN_ON(olddentry == trap))
+		goto out_dput;
+	if (WARN_ON(newdentry == trap))
+		goto out_dput;
+
+	err = vfs_rename(old_upperdir->d_inode, olddentry,
+			 new_upperdir->d_inode, newdentry);
+
+	if (!err) {
+		prev_opaque = old_ue->opaque;
+		old_ue->opaque = new_ue->opaque || new_ue->lowerpath.dentry;
+		if (prev_opaque)
+			err = union_whiteout(old);
+		if (!err && S_ISDIR(olddentry->d_inode->i_mode)) {
+			if (prev_opaque && !old_ue->opaque)
+				vfs_removexattr(olddentry, union_opaque_xattr);
+			if (!prev_opaque && old_ue->opaque)
+				err = vfs_setxattr(olddentry, union_opaque_xattr, "y", 1, 0);
+		}
+	}
+
+out_dput:
+	dput(newdentry);
+out_unlock:
+	unlock_rename(new_upperdir, old_upperdir);
+	return err;
+}
+
+static bool union_is_private_xattr(const char *name)
+{
+	return strncmp(name, "trusted.union.", 14) == 0;
+}
+
+static int union_setxattr(struct dentry *dentry, const char *name,
+			  const void *value, size_t size, int flags)
+{
+	int err;
+	struct union_entry *ue = dentry->d_fsdata;
+
+	if (union_is_private_xattr(name))
+		return -ENODATA;
+
+	if (!ue->upperpath.dentry) {
+		err = union_copy_up(dentry);
+		if (err)
+			return err;
+	}
+
+	return vfs_setxattr(ue->upperpath.dentry, name, value, size, flags);
+}
+
+static ssize_t union_getxattr(struct dentry *dentry, const char *name,
+			      void *value, size_t size)
+{
+	struct union_entry *ue = dentry->d_fsdata;
+	struct path *realpath = union_path(ue);
+
+	if (union_is_private_xattr(name))
+		return -ENODATA;
+
+	return vfs_getxattr(realpath->dentry, name, value, size);
+}
+
+static ssize_t union_listxattr(struct dentry *dentry, char *list, size_t size)
+{
+	struct union_entry *ue = dentry->d_fsdata;
+	struct path *realpath = union_path(ue);
+
+	/* FIXME: filter out private xattrs */
+	return vfs_listxattr(realpath->dentry, list, size);
+}
+
+static int union_removexattr(struct dentry *dentry, const char *name)
+{
+	int err;
+	struct union_entry *ue = dentry->d_fsdata;
+
+	if (union_is_private_xattr(name))
+		return -ENODATA;
+
+	if (!ue->upperpath.dentry) {
+		err = vfs_getxattr(ue->lowerpath.dentry, name, NULL, 0);
+		if (err < 0)
+			return err;
+
+		err = union_copy_up(dentry);
+		if (err)
+			return err;
+	}
+
+	return vfs_removexattr(ue->upperpath.dentry, name);
+}
+
+static const struct inode_operations union_dir_inode_operations = {
+	.lookup		= union_lookup,
+	.mkdir		= union_mkdir,
+	.symlink	= union_symlink,
+	.unlink		= union_unlink,
+	.rmdir		= union_rmdir,
+	.rename		= union_rename,
+	.link		= union_link,
+	.setattr	= union_setattr,
+	.create		= union_create,
+	.mknod		= union_mknod,
+	.permission	= union_permission,
+	.getattr	= union_dir_getattr,
+	.setxattr	= union_setxattr,
+	.getxattr	= union_getxattr,
+	.listxattr	= union_listxattr,
+	.removexattr	= union_removexattr,
+};
+
+static const struct inode_operations union_file_inode_operations = {
+	.setattr	= union_setattr,
+	.permission	= union_permission,
+	.getattr	= union_getattr,
+	.setxattr	= union_setxattr,
+	.getxattr	= union_getxattr,
+	.listxattr	= union_listxattr,
+	.removexattr	= union_removexattr,
+};
+
+static const struct inode_operations union_symlink_inode_operations = {
+	.setattr	= union_setattr,
+	.follow_link	= union_follow_link,
+	.put_link	= union_put_link,
+	.readlink	= union_readlink,
+	.getattr	= union_getattr,
+	.setxattr	= union_setxattr,
+	.getxattr	= union_getxattr,
+	.listxattr	= union_listxattr,
+	.removexattr	= union_removexattr,
+};
+
+static bool union_open_need_copy_up(struct file *file, struct union_entry *ue)
+{
+	if (ue->upperpath.dentry)
+		return false;
+
+	if (special_file(ue->lowerpath.dentry->d_inode->i_mode))
+		return false;
+
+	if (!(file->f_mode & FMODE_WRITE) && !(file->f_flags & O_TRUNC))
+		return false;
+
+	return true;
+}
+
+static struct file *union_open(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct union_entry *ue = dentry->d_fsdata;
+	int err;
+
+	if (union_open_need_copy_up(file, ue)) {
+		err = union_copy_up(dentry);
+		if (err)
+			return ERR_PTR(err);
+	}
+	return path_open(union_path(ue), file->f_flags);
+}
+
+static const struct file_operations union_file_operations = {
+	.open_other	= union_open,
+};
+
+static void union_put_super(struct super_block *sb)
+{
+	struct union_fs *ufs = sb->s_fs_info;
+
+	iput(ufs->symlink_inode);
+	iput(ufs->regular_inode);
+	iput(ufs->special_inode);
+	kfree(ufs);
+}
+
+static const struct super_operations union_super_operations = {
+	.put_super	= union_put_super,
+};
+
+struct union_config {
+	char *lowerdir;
+	char *upperdir;
+};
+
+enum {
+	Opt_lowerdir,
+	Opt_upperdir,
+	Opt_err,
+};
+
+static const match_table_t union_tokens = {
+	{Opt_lowerdir,			"lowerdir=%s"},
+	{Opt_upperdir,			"upperdir=%s"},
+	{Opt_err,			NULL}
+};
+
+static int union_parse_opt(char *opt, struct union_config *config)
+{
+	char *p;
+
+	config->upperdir = NULL;
+	config->lowerdir = NULL;
+
+	while ((p = strsep(&opt, ",")) != NULL) {
+		int token;
+		substring_t args[MAX_OPT_ARGS];
+
+		if (!*p)
+			continue;
+
+		token = match_token(p, union_tokens, args);
+		switch (token) {
+		case Opt_upperdir:
+			kfree(config->upperdir);
+			config->upperdir = match_strdup(&args[0]);
+			if (!config->upperdir)
+				return -ENOMEM;
+			break;
+
+		case Opt_lowerdir:
+			kfree(config->lowerdir);
+			config->lowerdir = match_strdup(&args[0]);
+			if (!config->lowerdir)
+				return -ENOMEM;
+			break;
+
+		default:
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+static int union_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct inode *root_inode;
+	struct dentry *root_dentry;
+	struct union_entry *ue;
+	struct union_fs *ufs;
+	struct union_config config;
+	int err;
+
+	err = union_parse_opt((char *) data, &config);
+	if (err)
+		goto out;
+
+	err = -EINVAL;
+	if (!config.upperdir || !config.lowerdir)
+		goto out_free_config;
+
+	err = -ENOMEM;
+	ufs = kmalloc(sizeof(struct union_fs), GFP_KERNEL);
+	if (!ufs)
+		goto out_free_config;
+
+	ufs->symlink_inode = new_inode(sb);
+	if (!ufs->symlink_inode)
+		goto out_free_ufs;
+
+	ufs->regular_inode = new_inode(sb);
+	if (!ufs->regular_inode)
+		goto out_put_symlink_inode;
+
+	ufs->special_inode = new_inode(sb);
+	if (!ufs->special_inode)
+		goto out_put_regular_inode;
+
+	ufs->symlink_inode->i_flags |= S_NOATIME|S_NOCMTIME;
+	ufs->symlink_inode->i_mode = S_IFLNK;
+	ufs->symlink_inode->i_op = &union_symlink_inode_operations;
+
+	ufs->regular_inode->i_flags |= S_NOATIME|S_NOCMTIME;
+	ufs->regular_inode->i_mode = S_IFREG;
+	ufs->regular_inode->i_op = &union_file_inode_operations;
+	ufs->regular_inode->i_fop = &union_file_operations;
+
+	ufs->special_inode->i_flags |= S_NOATIME|S_NOCMTIME;
+	ufs->special_inode->i_mode = S_IFSOCK;
+	ufs->special_inode->i_op = &union_file_inode_operations;
+	ufs->special_inode->i_fop = &union_file_operations;
+
+	root_inode = union_new_inode(sb, S_IFDIR);
+	if (!root_inode)
+		goto out_put_special_inode;
+
+	ue = kzalloc(sizeof(struct union_entry), GFP_KERNEL);
+	if (ue == NULL)
+		goto out_put_root;
+
+	err = kern_path(config.upperdir, LOOKUP_FOLLOW, &ue->upperpath);
+	if (err)
+		goto out_free_ue;
+
+	err = kern_path(config.lowerdir, LOOKUP_FOLLOW, &ue->lowerpath);
+	if (err)
+		goto out_put_upperpath;
+
+	err = -ENOTDIR;
+	if (!S_ISDIR(ue->upperpath.dentry->d_inode->i_mode) ||
+	    !S_ISDIR(ue->lowerpath.dentry->d_inode->i_mode))
+		goto out_put_lowerpath;
+
+	/* FIXME: mnt_want_write() */
+
+	err = -ENOMEM;
+	root_dentry = d_alloc_root(root_inode);
+	if (!root_dentry)
+		goto out_put_lowerpath;
+
+	root_dentry->d_fsdata = ue;
+	root_dentry->d_op = &union_dentry_operations;
+
+	sb->s_op = &union_super_operations;
+	sb->s_root = root_dentry;
+	sb->s_fs_info = ufs;
+
+	return 0;
+
+out_put_lowerpath:
+	path_put(&ue->lowerpath);
+out_put_upperpath:
+	path_put(&ue->upperpath);
+out_free_ue:
+	kfree(ue);
+out_put_root:
+	iput(root_inode);
+out_put_special_inode:
+	iput(ufs->special_inode);
+out_put_regular_inode:
+	iput(ufs->regular_inode);
+out_put_symlink_inode:
+	iput(ufs->symlink_inode);
+out_free_ufs:
+	kfree(ufs);
+out_free_config:
+	kfree(config.lowerdir);
+	kfree(config.upperdir);
+out:
+	return err;
+}
+
+static int union_get_sb(struct file_system_type *fs_type,
+			int flags, const char *dev_name,
+			void *raw_data, struct vfsmount *mnt)
+{
+	return get_sb_nodev(fs_type, flags, raw_data, union_fill_super, mnt);
+}
+
+static struct file_system_type union_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "union",
+	.fs_flags	= FS_RENAME_SELF_ALLOW,
+	.get_sb		= union_get_sb,
+	.kill_sb	= kill_anon_super,
+};
+
+static int __init union_init(void)
+{
+	return register_filesystem(&union_fs_type);
+}
+
+static void __exit union_exit(void)
+{
+	unregister_filesystem(&union_fs_type);
+}
+
+module_init(union_init);
+module_exit(union_exit);
Index: linux-2.6/fs/Kconfig
===================================================================
--- linux-2.6.orig/fs/Kconfig	2010-08-26 19:05:53.000000000 +0200
+++ linux-2.6/fs/Kconfig	2010-08-26 19:11:27.000000000 +0200
@@ -62,6 +62,7 @@ source "fs/quota/Kconfig"
 source "fs/autofs/Kconfig"
 source "fs/autofs4/Kconfig"
 source "fs/fuse/Kconfig"
+source "fs/union/Kconfig"
 
 config CUSE
 	tristate "Character device in Userspace support"
Index: linux-2.6/fs/Makefile
===================================================================
--- linux-2.6.orig/fs/Makefile	2010-08-26 19:05:53.000000000 +0200
+++ linux-2.6/fs/Makefile	2010-08-26 19:11:27.000000000 +0200
@@ -108,6 +108,7 @@ obj-$(CONFIG_AUTOFS_FS)		+= autofs/
 obj-$(CONFIG_AUTOFS4_FS)	+= autofs4/
 obj-$(CONFIG_ADFS_FS)		+= adfs/
 obj-$(CONFIG_FUSE_FS)		+= fuse/
+obj-$(CONFIG_UNION_FS)		+= union/
 obj-$(CONFIG_UDF_FS)		+= udf/
 obj-$(CONFIG_SUN_OPENPROMFS)	+= openpromfs/
 obj-$(CONFIG_OMFS_FS)		+= omfs/
Index: linux-2.6/fs/union/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/fs/union/Kconfig	2010-08-26 19:11:27.000000000 +0200
@@ -0,0 +1,4 @@
+config UNION_FS
+	tristate "Union filesystem support"
+	help
+	  Add support for union filesystem.
Index: linux-2.6/fs/union/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/fs/union/Makefile	2010-08-26 19:11:27.000000000 +0200
@@ -0,0 +1,5 @@
+#
+# Makefile for the union filesystem.
+#
+
+obj-$(CONFIG_UNION_FS) += union.o

-- 
