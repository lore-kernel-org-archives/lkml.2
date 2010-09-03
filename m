Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab0ICNmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:42:11 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58613 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab0ICNmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:42:04 -0400
Message-Id: <20100903134156.775641950@szeredi.hu>
References: <20100903134116.039612691@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Fri, 03 Sep 2010 15:41:21 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk
Subject: [PATCH 5/6] overlay: hybrid overlay filesystem prototype
Content-Disposition: inline; filename=overlayfs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This overlay filesystem is a hybrid of entirely filesystem based
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

  mount -t overlay -olowerdir=/lower,upperdir=/upper overlay /mnt

Supported:

 - all operations

Missing:

 - ensure that filesystems part of the overlay are not modified outside
   the overlay
 - optimize directory merging and caching

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/Kconfig               |    1 
 fs/Makefile              |    1 
 fs/overlayfs/Kconfig     |    4 
 fs/overlayfs/Makefile    |    5 
 fs/overlayfs/overlayfs.c | 1890 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 1901 insertions(+)

Index: linux-2.6/fs/overlayfs/overlayfs.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/fs/overlayfs/overlayfs.c	2010-09-03 14:46:07.000000000 +0200
@@ -0,0 +1,1890 @@
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
+MODULE_DESCRIPTION("Overlay filesystem");
+MODULE_LICENSE("GPL");
+
+struct ovl_fs {
+	struct inode *symlink_inode;
+	struct inode *regular_inode;
+	struct inode *special_inode;
+	struct vfsmount *upper_mnt;
+};
+
+struct ovl_entry {
+	struct path upperpath;
+	struct path lowerpath;
+	bool opaque;
+};
+
+static const char *ovl_whiteout_xattr = "trusted.overlay.whiteout";
+static const char *ovl_opaque_xattr = "trusted.overlay.opaque";
+static const char *ovl_whiteout_symlink = "(overlay-whiteout)";
+
+static struct path *ovl_path(struct ovl_entry *ue)
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
+static bool ovl_is_whiteout(struct dentry *dentry)
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
+	res = vfs_getxattr(dentry, ovl_whiteout_xattr, &val, 1);
+	if (res == 1 && val == 'y')
+		return true;
+
+	return false;
+}
+
+static bool ovl_is_opaquedir(struct dentry *dentry)
+{
+	int res;
+	char val;
+
+	if (!S_ISDIR(dentry->d_inode->i_mode))
+		return false;
+
+	res = vfs_getxattr(dentry, ovl_opaque_xattr, &val, 1);
+	if (res == 1 && val == 'y')
+		return true;
+
+	return false;
+}
+
+struct ovl_cache_entry {
+	struct ovl_cache_entry *next;
+	struct qstr name;
+	unsigned int type;
+	u64 ino;
+	bool is_whiteout;
+};
+
+struct ovl_cache_callback {
+	struct ovl_cache_entry *list;
+	struct ovl_cache_entry **endp;
+	struct path path;
+	int count;
+	int err;
+};
+
+struct ovl_dir_file {
+	bool is_real;
+	struct ovl_cache_entry *cache;
+	struct file *realfile;
+};
+
+static int ovl_cache_add_entry(struct ovl_cache_callback *cb,
+				 const char *name, int namelen, u64 ino,
+				 unsigned int d_type, bool is_whiteout)
+{
+	struct ovl_cache_entry *p;
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
+static void ovl_cache_free(struct ovl_cache_entry *p)
+{
+	while (p) {
+		struct ovl_cache_entry *next = p->next;
+
+		kfree(p->name.name);
+		kfree(p);
+		p = next;
+	}
+}
+
+static int ovl_cache_find_entry(struct ovl_cache_entry *start,
+				  const char *name, int namelen)
+{
+	struct ovl_cache_entry *p;
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
+static int ovl_fill_lower(void *buf, const char *name, int namlen,
+			    loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct ovl_cache_callback *cb = buf;
+
+	cb->count++;
+	if (!ovl_cache_find_entry(cb->list, name, namlen))
+		cb->err = ovl_cache_add_entry(cb, name, namlen, ino, d_type, false);
+
+	return cb->err;
+}
+
+static int ovl_fill_upper(void *buf, const char *name, int namlen,
+			  loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct ovl_cache_callback *cb = buf;
+	bool is_whiteout = false;
+
+	cb->count++;
+	if (d_type == DT_LNK) {
+		struct dentry *dentry;
+
+		dentry = lookup_one_len(name, cb->path.dentry, strlen(name));
+		if (IS_ERR(dentry)) {
+			cb->err = PTR_ERR(dentry);
+			goto out;
+		}
+		is_whiteout = ovl_is_whiteout(dentry);
+		dput(dentry);
+	}
+
+	cb->err = ovl_cache_add_entry(cb, name, namlen, ino, d_type, is_whiteout);
+
+out:
+	return cb->err;
+}
+
+static int ovl_fill_cache(struct path *realpath, struct ovl_cache_callback *cb,
+			  filldir_t filler)
+{
+	const struct cred *old_cred;
+	struct cred *override_cred;
+	struct file *realfile;
+	int err;
+
+	realfile = path_open(realpath, O_RDONLY | O_DIRECTORY);
+	if (IS_ERR(realfile))
+		return PTR_ERR(realfile);
+
+	err = -ENOMEM;
+	override_cred = prepare_creds();
+	if (override_cred) {
+		/*
+		 * CAP_SYS_ADMIN for getxattr
+		 * CAP_DAC_OVERRIDE for lookup and unlink
+		 */
+		cap_raise(override_cred->cap_effective, CAP_SYS_ADMIN);
+		cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
+		old_cred = override_creds(override_cred);
+
+		do {
+			cb->count = 0;
+			cb->err = 0;
+			err = vfs_readdir(realfile, filler, cb);
+			if (err >= 0)
+				err = cb->err;
+		} while (!err && cb->count);
+
+		revert_creds(old_cred);
+		put_cred(override_cred);
+	}
+	fput(realfile);
+
+	if (err) {
+		ovl_cache_free(cb->list);
+		cb->list = NULL;
+		return err;
+	}
+
+	return 0;
+}
+
+static int ovl_readdir(struct file *file, void *buf, filldir_t filler)
+{
+	struct ovl_dir_file *od = file->private_data;
+	struct ovl_entry *ue = file->f_path.dentry->d_fsdata;
+	struct ovl_cache_entry *p;
+	loff_t off;
+	int res = 0;
+
+	if (!file->f_pos) {
+		ovl_cache_free(od->cache);
+		od->cache = NULL;
+		od->is_real = false;
+	}
+
+	if (od->is_real || !ue->lowerpath.dentry || !ue->upperpath.dentry) {
+		od->is_real = true;
+		res = vfs_readdir(od->realfile, filler, buf);
+		file->f_pos = od->realfile->f_pos;
+
+		return res;
+	}
+
+	if (!od->cache) {
+		struct ovl_cache_callback cb = {
+			.list = NULL,
+			.endp = &cb.list,
+			.path = ue->upperpath,
+		};
+
+		res = ovl_fill_cache(&ue->upperpath, &cb, ovl_fill_upper);
+		if (!res) {
+			res = ovl_fill_cache(&ue->lowerpath, &cb,
+					     ovl_fill_lower);
+		}
+		if (res)
+			return res;
+
+		od->cache = cb.list;
+	}
+
+	off = 0;
+	for (p = od->cache; p; p = p->next) {
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
+static loff_t ovl_dir_llseek(struct file *file, loff_t offset, int origin)
+{
+	loff_t res;
+	struct ovl_dir_file *od = file->private_data;
+
+	res = generic_file_llseek(od->realfile, offset, origin);
+	file->f_pos = od->realfile->f_pos;
+
+	return res;
+}
+
+static int ovl_dir_fsync(struct file *file, int datasync)
+{
+	struct ovl_dir_file *od = file->private_data;
+
+	return vfs_fsync(od->realfile, datasync);
+}
+
+static int ovl_dir_release(struct inode *inode, struct file *file)
+{
+	struct ovl_dir_file *od = file->private_data;
+
+	ovl_cache_free(od->cache);
+	fput(od->realfile);
+	kfree(od);
+
+	return 0;
+}
+
+static int ovl_dir_open(struct inode *inode, struct file *file)
+{
+	int err;
+	struct ovl_entry *ue = file->f_path.dentry->d_fsdata;
+	struct path *realpath = ovl_path(ue);
+	struct ovl_dir_file *od;
+
+	od = kzalloc(sizeof(struct ovl_dir_file), GFP_KERNEL);
+	if (!od)
+		return -ENOMEM;
+
+	od->realfile = path_open(realpath, file->f_flags);
+	if (IS_ERR(od->realfile)) {
+		err = PTR_ERR(od->realfile);
+		kfree(od);
+		return err;
+	}
+
+	file->private_data = od;
+
+	return 0;
+}
+
+static const struct file_operations ovl_dir_operations = {
+	.read		= generic_read_dir,
+	.open		= ovl_dir_open,
+	.readdir	= ovl_readdir,
+	.llseek		= ovl_dir_llseek,
+	.fsync		= ovl_dir_fsync,
+	.release	= ovl_dir_release,
+};
+
+static const struct inode_operations ovl_dir_inode_operations;
+
+static void ovl_dentry_release(struct dentry *dentry)
+{
+	struct ovl_entry *ue = dentry->d_fsdata;
+
+	if (ue) {
+		path_put(&ue->upperpath);
+		path_put(&ue->lowerpath);
+		kfree(ue);
+	}
+}
+
+static void ovl_dentry_iput(struct dentry *dentry, struct inode *inode)
+{
+	struct ovl_entry *ue = dentry->d_fsdata;
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
+static const struct dentry_operations ovl_dentry_operations = {
+	.d_release = ovl_dentry_release,
+	.d_iput = ovl_dentry_iput,
+};
+
+static struct inode *ovl_new_inode(struct super_block *sb, umode_t mode)
+{
+	struct ovl_fs *ufs = sb->s_fs_info;
+	struct inode *inode;
+
+	switch (mode & S_IFMT) {
+	case S_IFDIR:
+		inode = new_inode(sb);
+		inode->i_flags |= S_NOATIME|S_NOCMTIME;
+		inode->i_op = &ovl_dir_inode_operations;
+		inode->i_fop = &ovl_dir_operations;
+		inode->i_mode = S_IFDIR;
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
+static struct dentry *ovl_lookup_real(struct dentry *dir, struct qstr *name)
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
+static struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
+				   struct nameidata *nd)
+{
+	struct ovl_entry *pue = dentry->d_parent->d_fsdata;
+	struct ovl_entry *ue;
+	struct dentry *upperdir = pue->upperpath.dentry;
+	struct dentry *upperdentry = NULL;
+	struct dentry *lowerdir = pue->lowerpath.dentry;
+	struct dentry *lowerdentry = NULL;
+	struct inode *inode = NULL;
+	int err;
+
+	err = -ENOMEM;
+	ue = kzalloc(sizeof(struct ovl_entry), GFP_KERNEL);
+	if (!ue)
+		goto out;
+
+	if (upperdir) {
+		upperdentry = ovl_lookup_real(upperdir, &dentry->d_name);
+		err = PTR_ERR(upperdentry);
+		if (IS_ERR(upperdentry))
+			goto out_free;
+
+		if (upperdentry) {
+			const struct cred *old_cred;
+			struct cred *override_cred;
+
+			err = -ENOMEM;
+			override_cred = prepare_creds();
+			if (!override_cred)
+				goto out_dput;
+
+			/* CAP_SYS_ADMIN needed for getxattr */
+			cap_raise(override_cred->cap_effective, CAP_SYS_ADMIN);
+			old_cred = override_creds(override_cred);
+
+			if (ovl_is_opaquedir(upperdentry)) {
+				ue->opaque = true;
+			} else if (ovl_is_whiteout(upperdentry)) {
+				dput(upperdentry);
+				upperdentry = NULL;
+				ue->opaque = true;
+			}
+			revert_creds(old_cred);
+			put_cred(override_cred);
+		}
+	}
+	if (lowerdir && !ue->opaque) {
+		lowerdentry = ovl_lookup_real(lowerdir, &dentry->d_name);
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
+		inode = ovl_new_inode(dir->i_sb, realdentry->d_inode->i_mode);
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
+	dentry->d_op = &ovl_dentry_operations;
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
+static int ovl_copy_up_xattr(struct dentry *old, struct dentry *new)
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
+static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
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
+	/* FIXME: do_splice_direct() can't copy >4G */
+	/* FIXME: allow kill signal to abort */
+	/* FIXME: sparse files */
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
+static struct dentry *ovl_lookup_create(struct ovl_entry *ue,
+					struct ovl_entry *pue,
+					struct qstr *name)
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
+		const struct cred *old_cred;
+		struct cred *override_cred;
+
+		err = -ENOMEM;
+		override_cred = prepare_creds();
+		if (!override_cred)
+			goto out_dput;
+
+		/*
+		 * CAP_SYS_ADMIN for getxattr
+		 * CAP_FOWNER for unlink in sticky directory
+		 */
+		cap_raise(override_cred->cap_effective, CAP_SYS_ADMIN);
+		cap_raise(override_cred->cap_effective, CAP_FOWNER);
+		old_cred = override_creds(override_cred);
+
+		err = -ESTALE;
+		if (ovl_is_whiteout(newdentry))
+			err = vfs_unlink(upperdir, newdentry);
+
+		revert_creds(old_cred);
+		put_cred(override_cred);
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
+static int ovl_upper_create(struct dentry *parent, struct dentry *dentry,
+			    struct kstat *stat, const char *link,
+			    struct path *newpath)
+{
+	int err;
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct ovl_entry *pue = parent->d_fsdata;
+	struct inode *upperdir = pue->upperpath.dentry->d_inode;
+	struct dentry *newdentry;
+
+	newdentry = ovl_lookup_create(ue, pue, &dentry->d_name);
+	if (IS_ERR(newdentry))
+		return PTR_ERR(newdentry);
+
+	switch (stat->mode & S_IFMT) {
+	case S_IFREG:
+		err = vfs_create(upperdir, newdentry, stat->mode, NULL);
+		break;
+
+	case S_IFDIR:
+		err = vfs_mkdir(upperdir, newdentry, stat->mode);
+		break;
+
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFIFO:
+	case S_IFSOCK:
+		err = vfs_mknod(upperdir, newdentry, stat->mode, stat->rdev);
+		break;
+
+	case S_IFLNK:
+		err = vfs_symlink(upperdir, newdentry, link);
+		break;
+
+	default:
+		err = -EPERM;
+	}
+	if (!err) {
+		newpath->dentry = newdentry;
+		newpath->mnt = pue->upperpath.mnt;
+		path_get(newpath);
+	}
+
+	dput(newdentry);
+	return err;
+}
+
+static char *ovl_read_symlink(struct path *path)
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
+static int ovl_set_timestamps(struct dentry *upperdentry, struct kstat *stat)
+{
+	struct iattr attr = {
+		.ia_valid = ATTR_ATIME | ATTR_MTIME | ATTR_ATIME_SET | ATTR_MTIME_SET,
+		.ia_atime = stat->atime,
+		.ia_mtime = stat->mtime,
+	};
+
+	return notify_change(upperdentry, &attr);
+}
+
+static int ovl_set_mode(struct dentry *upperdentry, umode_t mode)
+{
+	struct iattr attr = {
+		.ia_valid = ATTR_MODE,
+		.ia_mode = mode,
+	};
+
+	return notify_change(upperdentry, &attr);
+}
+
+static int ovl_set_opaque(struct dentry *upperdentry)
+{
+	int err;
+	const struct cred *old_cred;
+	struct cred *override_cred;
+
+	override_cred = prepare_creds();
+	if (!override_cred)
+		return -ENOMEM;
+
+	/* CAP_SYS_ADMIN for setxattr of "trusted" namespace */
+	cap_raise(override_cred->cap_effective, CAP_SYS_ADMIN);
+	old_cred = override_creds(override_cred);
+	err = vfs_setxattr(upperdentry, ovl_opaque_xattr, "y", 1, 0);
+	revert_creds(old_cred);
+	put_cred(override_cred);
+
+	return err;
+}
+
+static int ovl_remove_opaque(struct dentry *upperdentry)
+{
+	int err;
+	const struct cred *old_cred;
+	struct cred *override_cred;
+
+	override_cred = prepare_creds();
+	if (!override_cred)
+		return -ENOMEM;
+
+	/* CAP_SYS_ADMIN for removexattr of "trusted" namespace */
+	cap_raise(override_cred->cap_effective, CAP_SYS_ADMIN);
+	old_cred = override_creds(override_cred);
+	err = vfs_removexattr(upperdentry, ovl_opaque_xattr);
+	revert_creds(old_cred);
+	put_cred(override_cred);
+
+	return err;
+}
+
+static int ovl_copy_up_locked(struct dentry *parent, struct dentry *dentry,
+			      struct kstat *pstat, struct kstat *stat,
+			      const char *link)
+{
+	int err;
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct ovl_entry *pue = parent->d_fsdata;
+	struct path newpath;
+	umode_t mode = stat->mode;
+
+	/*
+	 * Using upper filesystem locking to protect against copy up
+	 * racing with rename (rename means the copy up was already
+	 * successful).
+	 */
+	if (dentry->d_parent != parent) {
+		if (WARN_ON(!ue->upperpath.dentry))
+			return -ESTALE;
+
+		return 0;
+	}
+	/* Can't properly set mode on creation because of the umask */
+	stat->mode &= S_IFMT;
+
+	err  = ovl_upper_create(parent, dentry, stat, link, &newpath);
+	if (err) {
+		/* Already copied up? */
+		if (err == -EEXIST && ue->upperpath.dentry)
+			return 0;
+
+		return err;
+	}
+
+	if (S_ISREG(stat->mode)) {
+		err = ovl_copy_up_data(&ue->lowerpath, &newpath, stat->size);
+		if (err)
+			goto out_path_put;
+	}
+
+	err = ovl_copy_up_xattr(ue->lowerpath.dentry, newpath.dentry);
+	if (err)
+		goto out_path_put;
+
+	if (ue->opaque && S_ISDIR(stat->mode)) {
+		err = ovl_set_opaque(newpath.dentry);
+		if (err)
+			goto out_path_put;
+	}
+
+	mutex_lock(&newpath.dentry->d_inode->i_mutex);
+	err = ovl_set_mode(newpath.dentry, mode);
+	if (!err)
+		err = ovl_set_timestamps(newpath.dentry, stat);
+	mutex_unlock(&newpath.dentry->d_inode->i_mutex);
+	if (err)
+		goto out_path_put;
+
+	/* Restore timestamps on parent (best effort) */
+	ovl_set_timestamps(pue->upperpath.dentry, pstat);
+
+	ue->upperpath = newpath;
+	/* FIXME: release lowerpath? */
+	if (ue->lowerpath.dentry)
+		ue->opaque = true;
+
+	return 0;
+
+out_path_put:
+	path_put(&newpath);
+	return err;
+}
+
+static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry)
+{
+	int err;
+	struct kstat stat;
+	struct kstat pstat;
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct ovl_entry *pue = parent->d_fsdata;
+	struct inode *upperdir = pue->upperpath.dentry->d_inode;
+	const struct cred *old_cred;
+	struct cred *override_cred;
+	char *link = NULL;
+
+	err = vfs_getattr(ue->lowerpath.mnt, ue->lowerpath.dentry, &stat);
+	if (err)
+		return err;
+
+	err = vfs_getattr(pue->upperpath.mnt, pue->upperpath.dentry, &pstat);
+	if (err)
+		return err;
+
+	if (S_ISLNK(stat.mode)) {
+		link = ovl_read_symlink(&ue->lowerpath);
+		if (IS_ERR(link))
+			return PTR_ERR(link);
+	}
+
+	err = -ENOMEM;
+	override_cred = prepare_creds();
+	if (!override_cred)
+		goto out_free_link;
+
+	override_cred->fsuid = stat.uid;
+	override_cred->fsgid = stat.gid;
+	/*
+	 * CAP_SYS_ADMIN for copying up extended attributes
+	 * CAP_DAC_OVERRIDE for create
+	 * CAP_FOWNER for chmod, timestamp update
+	 * CAP_FSETID for chmod
+	 * CAP_MKNOD for mknod
+	 */
+	cap_raise(override_cred->cap_effective, CAP_SYS_ADMIN);
+	cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
+	cap_raise(override_cred->cap_effective, CAP_FOWNER);
+	cap_raise(override_cred->cap_effective, CAP_FSETID);
+	cap_raise(override_cred->cap_effective, CAP_MKNOD);
+	old_cred = override_creds(override_cred);
+
+	mutex_lock_nested(&upperdir->i_mutex, I_MUTEX_PARENT);
+	err = ovl_copy_up_locked(parent, dentry, &pstat, &stat, link);
+	mutex_unlock(&upperdir->i_mutex);
+
+	revert_creds(old_cred);
+	put_cred(override_cred);
+
+out_free_link:
+	if (link)
+		free_page((unsigned long) link);
+
+	return err;
+}
+
+static int ovl_copy_up(struct dentry *dentry)
+{
+	struct ovl_entry *ue = dentry->d_fsdata;
+	int err;
+
+	err = 0;
+	while (!err && !ue->upperpath.dentry) {
+		struct dentry *next = dget(dentry);
+		struct dentry *parent;
+
+		/* find the topmost dentry not yet copied up */
+		for (;;) {
+			struct ovl_entry *pue;
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
+		err = ovl_copy_up_one(parent, next);
+
+		dput(parent);
+		dput(next);
+	}
+
+	return err;
+}
+
+static int ovl_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	struct inode *inode;
+	struct ovl_entry *ue = dentry->d_fsdata;
+	int err;
+
+	/* FIXME: handle truncate efficiently */
+	err = ovl_copy_up(dentry);
+	if (err)
+		return err;
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
+static int ovl_getattr(struct vfsmount *mnt, struct dentry *dentry,
+			 struct kstat *stat)
+{
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct path *realpath = ovl_path(ue);
+
+	return vfs_getattr(realpath->mnt, realpath->dentry, stat);
+}
+
+static int ovl_dir_getattr(struct vfsmount *mnt, struct dentry *dentry,
+			 struct kstat *stat)
+{
+	int err;
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct path *realpath = ovl_path(ue);
+
+	err = vfs_getattr(realpath->mnt, realpath->dentry, stat);
+
+	stat->dev = dentry->d_sb->s_dev;
+	stat->ino = dentry->d_inode->i_ino;
+
+	/*
+	 * It's probably not worth it to count subdirs to get the
+	 * correct link count.  nlink=1 seems to pacify 'find' and
+	 * other utilities.
+	 */
+	if (ue->lowerpath.dentry && ue->upperpath.dentry)
+		stat->nlink = 1;
+
+	return err;
+}
+
+static int ovl_permission(struct dentry *dentry, int mask)
+{
+	struct ovl_entry *ue = dentry->d_fsdata;
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
+static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
+			       const char *link)
+{
+	int err;
+	struct inode *inode;
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct ovl_entry *pue = dentry->d_parent->d_fsdata;
+	struct inode *upperdir;
+	struct path newpath;
+	struct kstat stat = {
+		.mode = mode,
+		.rdev = rdev,
+	};
+
+	err = -ENOMEM;
+	inode = ovl_new_inode(dentry->d_sb, mode);
+	if (!inode)
+		goto out;
+
+	err = ovl_copy_up(dentry->d_parent);
+	if (err)
+		goto out_iput;
+
+	upperdir = pue->upperpath.dentry->d_inode;
+
+	mutex_lock_nested(&upperdir->i_mutex, I_MUTEX_PARENT);
+	err = ovl_upper_create(dentry->d_parent, dentry, &stat, link,
+			       &newpath);
+	if (err)
+		goto out_unlock;
+
+	if (ue->opaque && S_ISDIR(mode)) {
+		err = ovl_set_opaque(newpath.dentry);
+		if (err) {
+			path_put(&newpath);
+			goto out_unlock;
+		}
+	}
+	ue->upperpath = newpath;
+	d_instantiate(dentry, inode);
+	inode = NULL;
+
+out_unlock:
+	mutex_unlock(&upperdir->i_mutex);
+out_iput:
+	iput(inode);
+out:
+	return err;
+}
+
+static int ovl_create(struct inode *dir, struct dentry *dentry, int mode,
+			struct nameidata *nd)
+{
+	return ovl_create_object(dentry, (mode & 07777) | S_IFREG, 0, NULL);
+}
+
+static int ovl_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	return ovl_create_object(dentry, (mode & 07777) | S_IFDIR, 0, NULL);
+}
+
+static int ovl_mknod(struct inode *dir, struct dentry *dentry, int mode,
+		       dev_t rdev)
+{
+	return ovl_create_object(dentry, mode, rdev, NULL);
+}
+
+static int ovl_symlink(struct inode *dir, struct dentry *dentry,
+			 const char *link)
+{
+	return ovl_create_object(dentry, S_IFLNK, 0, link);
+}
+
+static void *ovl_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct path *realpath = ovl_path(ue);
+	struct inode *realinode = realpath->dentry->d_inode;
+
+	if (WARN_ON(!realinode->i_op->follow_link))
+		return ERR_PTR(-EPERM);
+
+	return realinode->i_op->follow_link(realpath->dentry, nd);
+}
+
+static void ovl_put_link(struct dentry *dentry, struct nameidata *nd, void *c)
+{
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct path *realpath = ovl_path(ue);
+	struct inode *realinode = realpath->dentry->d_inode;
+
+	if (realinode->i_op->put_link)
+		realinode->i_op->put_link(realpath->dentry, nd, c);
+}
+
+static int ovl_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
+{
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct path *realpath = ovl_path(ue);
+	struct inode *realinode = realpath->dentry->d_inode;
+
+	if (!realinode->i_op->readlink)
+		return -EINVAL;
+
+	touch_atime(realpath->mnt, realpath->dentry);
+	return realinode->i_op->readlink(realpath->dentry, buf, bufsiz);
+}
+
+static int ovl_whiteout(struct dentry *dentry)
+{
+	int err;
+	struct ovl_entry *pue = dentry->d_parent->d_fsdata;
+	struct dentry *newdentry;
+	const struct cred *old_cred;
+	struct cred *override_cred;
+
+	err = -ENOMEM;
+	override_cred = prepare_creds();
+	if (!override_cred)
+		goto out;
+
+	/*
+	 * CAP_SYS_ADMIN for setxattr
+	 * CAP_DAC_OVERRIDE for symlink creation
+	 */
+	cap_raise(override_cred->cap_effective, CAP_SYS_ADMIN);
+	cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
+	override_cred->fsuid = 0;
+	override_cred->fsgid = 0;
+	old_cred = override_creds(override_cred);
+
+	newdentry = lookup_one_len(dentry->d_name.name, pue->upperpath.dentry,
+				   dentry->d_name.len);
+	err = PTR_ERR(newdentry);
+	if (IS_ERR(newdentry))
+		goto out_put_cred;
+
+	err = -ESTALE;
+	if (WARN_ON(newdentry->d_inode))
+		goto out_dput;
+
+	err = vfs_symlink(pue->upperpath.dentry->d_inode, newdentry,
+			  ovl_whiteout_symlink);
+	if (err)
+		goto out_dput;
+
+	err = vfs_setxattr(newdentry, ovl_whiteout_xattr, "y", 1, 0);
+
+out_dput:
+	dput(newdentry);
+out_put_cred:
+	revert_creds(old_cred);
+	put_cred(override_cred);
+out:
+	return err;
+}
+
+static int ovl_unlink(struct inode *dir, struct dentry *dentry)
+{
+	int err;
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct ovl_entry *pue;
+	struct inode *upperdir;
+
+	err = ovl_copy_up(dentry->d_parent);
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
+		err = ovl_whiteout(dentry);
+out_unlock:
+	mutex_unlock(&upperdir->i_mutex);
+
+	return err;
+}
+
+static int ovl_check_empty_dir(struct dentry *dentry)
+{
+	int err;
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct ovl_cache_entry *p;
+	struct ovl_cache_callback cb = {
+		.list = NULL,
+		.endp = &cb.list,
+		.path = ue->upperpath,
+	};
+
+	if (ue->upperpath.dentry) {
+		err = ovl_fill_cache(&ue->upperpath, &cb, ovl_fill_upper);
+		if (err)
+			return err;
+	}
+	err = ovl_fill_cache(&ue->lowerpath, &cb, ovl_fill_lower);
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
+	ovl_cache_free(cb.list);
+
+	return err;
+}
+
+static int ovl_unlink_whiteout(void *buf, const char *name, int namlen,
+				 loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct ovl_cache_callback *cb = buf;
+
+	cb->count++;
+	/* check d_type to filter out "." and ".." */
+	if (d_type == DT_LNK) {
+		struct dentry *dentry;
+
+		dentry = lookup_one_len(name, cb->path.dentry, strlen(name));
+		if (IS_ERR(dentry)) {
+			cb->err = PTR_ERR(dentry);
+		} else {
+			cb->err = vfs_unlink(cb->path.dentry->d_inode, dentry);
+			dput(dentry);
+		}
+	}
+
+	return cb->err;
+}
+
+static int ovl_remove_whiteouts(struct dentry *dentry)
+{
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct ovl_cache_callback cb = {
+		.list = NULL,
+		.path = ue->upperpath,
+	};
+
+	if (!ue->upperpath.dentry)
+		return 0;
+
+	return ovl_fill_cache(&ue->upperpath, &cb, ovl_unlink_whiteout);
+}
+
+static int ovl_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	int err;
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct ovl_entry *pue;
+	struct inode *upperdir;
+
+	if (ue->lowerpath.dentry) {
+		err = ovl_check_empty_dir(dentry);
+		if (err)
+			return err;
+
+		err = ovl_copy_up(dentry->d_parent);
+		if (err)
+			return err;
+
+		err = ovl_remove_whiteouts(dentry);
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
+		err = ovl_whiteout(dentry);
+out_unlock:
+	mutex_unlock(&upperdir->i_mutex);
+
+	return err;
+}
+
+static int ovl_link(struct dentry *old, struct inode *newdir,
+		      struct dentry *new)
+{
+	int err;
+	struct dentry *newdentry;
+	struct ovl_entry *new_ue = new->d_fsdata;
+	struct ovl_entry *old_ue = old->d_fsdata;
+	struct ovl_entry *pue = new->d_parent->d_fsdata;
+	struct inode *upperdir;
+
+	err = ovl_copy_up(old);
+	if (err)
+		goto out;
+
+	err = ovl_copy_up(new->d_parent);
+	if (err)
+		goto out;
+
+	upperdir = pue->upperpath.dentry->d_inode;
+	mutex_lock_nested(&upperdir->i_mutex, I_MUTEX_PARENT);
+	newdentry = ovl_lookup_create(new_ue, pue, &new->d_name);
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
+static int ovl_rename(struct inode *olddir, struct dentry *old,
+			struct inode *newdir, struct dentry *new)
+{
+	int err;
+	struct ovl_entry *old_ue = old->d_fsdata;
+	struct ovl_entry *new_ue = new->d_fsdata;
+	struct ovl_entry *old_pue = old->d_parent->d_fsdata;
+	struct ovl_entry *new_pue = new->d_parent->d_fsdata;
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
+		err = ovl_check_empty_dir(new);
+		if (err)
+			return err;
+	}
+
+	err = ovl_copy_up(old);
+	if (err)
+		return err;
+
+	err = ovl_copy_up(new->d_parent);
+	if (err)
+		return err;
+
+	if (new_ue->lowerpath.dentry &&
+	    S_ISDIR(new_ue->lowerpath.dentry->d_inode->i_mode)) {
+		err = ovl_remove_whiteouts(new);
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
+		newdentry = ovl_lookup_create(new_ue, new_pue, &new->d_name);
+		err = PTR_ERR(newdentry);
+		if (IS_ERR(newdentry))
+			goto out_unlock;
+	}
+
+	err = -ESTALE;
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
+			err = ovl_whiteout(old);
+		if (!err && S_ISDIR(olddentry->d_inode->i_mode)) {
+			if (prev_opaque && !old_ue->opaque)
+				ovl_remove_opaque(olddentry);
+			if (!prev_opaque && old_ue->opaque)
+				err = ovl_set_opaque(olddentry);
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
+static bool ovl_is_private_xattr(const char *name)
+{
+	return strncmp(name, "trusted.overlay.", 14) == 0;
+}
+
+static int ovl_setxattr(struct dentry *dentry, const char *name,
+			  const void *value, size_t size, int flags)
+{
+	int err;
+	struct ovl_entry *ue = dentry->d_fsdata;
+
+	if (ovl_is_private_xattr(name))
+		return -ENODATA;
+
+	if (!ue->upperpath.dentry) {
+		err = ovl_copy_up(dentry);
+		if (err)
+			return err;
+	}
+
+	return vfs_setxattr(ue->upperpath.dentry, name, value, size, flags);
+}
+
+static ssize_t ovl_getxattr(struct dentry *dentry, const char *name,
+			      void *value, size_t size)
+{
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct path *realpath = ovl_path(ue);
+
+	if (ovl_is_private_xattr(name))
+		return -ENODATA;
+
+	return vfs_getxattr(realpath->dentry, name, value, size);
+}
+
+static ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
+{
+	struct ovl_entry *ue = dentry->d_fsdata;
+	struct path *realpath = ovl_path(ue);
+	ssize_t res;
+	int off;
+
+	res = vfs_listxattr(realpath->dentry, list, size);
+	if (res <= 0 || size == 0)
+		return res;
+
+	/* filter out private xattrs */
+	for (off = 0; off < res;) {
+		char *s = list + off;
+		size_t slen = strlen(s) + 1;
+
+		BUG_ON(off + slen > res);
+
+		if (ovl_is_private_xattr(s)) {
+			res -= slen;
+			memmove(s, s + slen, res - off);
+		} else {
+			off += slen;
+		}
+	}
+
+	return res;
+}
+
+static int ovl_removexattr(struct dentry *dentry, const char *name)
+{
+	int err;
+	struct ovl_entry *ue = dentry->d_fsdata;
+
+	if (ovl_is_private_xattr(name))
+		return -ENODATA;
+
+	if (!ue->upperpath.dentry) {
+		err = vfs_getxattr(ue->lowerpath.dentry, name, NULL, 0);
+		if (err < 0)
+			return err;
+
+		err = ovl_copy_up(dentry);
+		if (err)
+			return err;
+	}
+
+	return vfs_removexattr(ue->upperpath.dentry, name);
+}
+
+static const struct inode_operations ovl_dir_inode_operations = {
+	.lookup		= ovl_lookup,
+	.mkdir		= ovl_mkdir,
+	.symlink	= ovl_symlink,
+	.unlink		= ovl_unlink,
+	.rmdir		= ovl_rmdir,
+	.rename		= ovl_rename,
+	.link		= ovl_link,
+	.setattr	= ovl_setattr,
+	.create		= ovl_create,
+	.mknod		= ovl_mknod,
+	.permission	= ovl_permission,
+	.getattr	= ovl_dir_getattr,
+	.setxattr	= ovl_setxattr,
+	.getxattr	= ovl_getxattr,
+	.listxattr	= ovl_listxattr,
+	.removexattr	= ovl_removexattr,
+};
+
+static const struct inode_operations ovl_file_inode_operations = {
+	.setattr	= ovl_setattr,
+	.permission	= ovl_permission,
+	.getattr	= ovl_getattr,
+	.setxattr	= ovl_setxattr,
+	.getxattr	= ovl_getxattr,
+	.listxattr	= ovl_listxattr,
+	.removexattr	= ovl_removexattr,
+};
+
+static const struct inode_operations ovl_symlink_inode_operations = {
+	.setattr	= ovl_setattr,
+	.follow_link	= ovl_follow_link,
+	.put_link	= ovl_put_link,
+	.readlink	= ovl_readlink,
+	.getattr	= ovl_getattr,
+	.setxattr	= ovl_setxattr,
+	.getxattr	= ovl_getxattr,
+	.listxattr	= ovl_listxattr,
+	.removexattr	= ovl_removexattr,
+};
+
+static bool ovl_open_need_copy_up(struct file *file, struct ovl_entry *ue)
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
+static struct file *ovl_open(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct ovl_entry *ue = dentry->d_fsdata;
+	int err;
+
+	if (ovl_open_need_copy_up(file, ue)) {
+		err = ovl_copy_up(dentry);
+		if (err)
+			return ERR_PTR(err);
+	}
+	return path_open(ovl_path(ue), file->f_flags);
+}
+
+static const struct file_operations ovl_file_operations = {
+	.open_other	= ovl_open,
+};
+
+static void ovl_put_super(struct super_block *sb)
+{
+	struct ovl_fs *ufs = sb->s_fs_info;
+
+	if (!(sb->s_flags & MS_RDONLY))
+		mnt_drop_write(ufs->upper_mnt);
+
+	mntput(ufs->upper_mnt);
+
+	iput(ufs->symlink_inode);
+	iput(ufs->regular_inode);
+	iput(ufs->special_inode);
+	kfree(ufs);
+}
+
+static const struct super_operations ovl_super_operations = {
+	.put_super	= ovl_put_super,
+};
+
+struct ovl_config {
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
+static const match_table_t ovl_tokens = {
+	{Opt_lowerdir,			"lowerdir=%s"},
+	{Opt_upperdir,			"upperdir=%s"},
+	{Opt_err,			NULL}
+};
+
+static int ovl_parse_opt(char *opt, struct ovl_config *config)
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
+		token = match_token(p, ovl_tokens, args);
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
+static int ovl_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct inode *root_inode;
+	struct dentry *root_dentry;
+	struct ovl_entry *ue;
+	struct ovl_fs *ufs;
+	struct ovl_config config;
+	int err;
+
+	err = ovl_parse_opt((char *) data, &config);
+	if (err)
+		goto out;
+
+	err = -EINVAL;
+	if (!config.upperdir || !config.lowerdir)
+		goto out_free_config;
+
+	err = -ENOMEM;
+	ufs = kmalloc(sizeof(struct ovl_fs), GFP_KERNEL);
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
+	ufs->symlink_inode->i_op = &ovl_symlink_inode_operations;
+
+	ufs->regular_inode->i_flags |= S_NOATIME|S_NOCMTIME;
+	ufs->regular_inode->i_mode = S_IFREG;
+	ufs->regular_inode->i_op = &ovl_file_inode_operations;
+	ufs->regular_inode->i_fop = &ovl_file_operations;
+
+	ufs->special_inode->i_flags |= S_NOATIME|S_NOCMTIME;
+	ufs->special_inode->i_mode = S_IFSOCK;
+	ufs->special_inode->i_op = &ovl_file_inode_operations;
+	ufs->special_inode->i_fop = &ovl_file_operations;
+
+	root_inode = ovl_new_inode(sb, S_IFDIR);
+	if (!root_inode)
+		goto out_put_special_inode;
+
+	ue = kzalloc(sizeof(struct ovl_entry), GFP_KERNEL);
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
+	if (!(sb->s_flags & MS_RDONLY)) {
+		err = mnt_want_write(ue->upperpath.mnt);
+		if (err)
+			goto out_put_lowerpath;
+	}
+
+	err = -ENOMEM;
+	root_dentry = d_alloc_root(root_inode);
+	if (!root_dentry)
+		goto out_drop_write;
+
+	root_dentry->d_fsdata = ue;
+	root_dentry->d_op = &ovl_dentry_operations;
+
+	ufs->upper_mnt = mntget(ue->upperpath.mnt);
+
+	sb->s_op = &ovl_super_operations;
+	sb->s_root = root_dentry;
+	sb->s_fs_info = ufs;
+
+	return 0;
+
+out_drop_write:
+	if (!(sb->s_flags & MS_RDONLY))
+		mnt_drop_write(ue->upperpath.mnt);
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
+static int ovl_get_sb(struct file_system_type *fs_type,
+			int flags, const char *dev_name,
+			void *raw_data, struct vfsmount *mnt)
+{
+	return get_sb_nodev(fs_type, flags, raw_data, ovl_fill_super, mnt);
+}
+
+static struct file_system_type ovl_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "overlayfs",
+	.fs_flags	= FS_RENAME_SELF_ALLOW,
+	.get_sb		= ovl_get_sb,
+	.kill_sb	= kill_anon_super,
+};
+
+static int __init ovl_init(void)
+{
+	return register_filesystem(&ovl_fs_type);
+}
+
+static void __exit ovl_exit(void)
+{
+	unregister_filesystem(&ovl_fs_type);
+}
+
+module_init(ovl_init);
+module_exit(ovl_exit);
Index: linux-2.6/fs/Kconfig
===================================================================
--- linux-2.6.orig/fs/Kconfig	2010-09-03 14:45:57.000000000 +0200
+++ linux-2.6/fs/Kconfig	2010-09-03 14:46:00.000000000 +0200
@@ -62,6 +62,7 @@ source "fs/quota/Kconfig"
 source "fs/autofs/Kconfig"
 source "fs/autofs4/Kconfig"
 source "fs/fuse/Kconfig"
+source "fs/overlayfs/Kconfig"
 
 config CUSE
 	tristate "Character device in Userspace support"
Index: linux-2.6/fs/Makefile
===================================================================
--- linux-2.6.orig/fs/Makefile	2010-09-03 14:45:57.000000000 +0200
+++ linux-2.6/fs/Makefile	2010-09-03 14:46:00.000000000 +0200
@@ -108,6 +108,7 @@ obj-$(CONFIG_AUTOFS_FS)		+= autofs/
 obj-$(CONFIG_AUTOFS4_FS)	+= autofs4/
 obj-$(CONFIG_ADFS_FS)		+= adfs/
 obj-$(CONFIG_FUSE_FS)		+= fuse/
+obj-$(CONFIG_OVERLAYFS_FS)	+= overlayfs/
 obj-$(CONFIG_UDF_FS)		+= udf/
 obj-$(CONFIG_SUN_OPENPROMFS)	+= openpromfs/
 obj-$(CONFIG_OMFS_FS)		+= omfs/
Index: linux-2.6/fs/overlayfs/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/fs/overlayfs/Kconfig	2010-09-03 14:46:00.000000000 +0200
@@ -0,0 +1,4 @@
+config OVERLAYFS_FS
+	tristate "Overlay filesystem support"
+	help
+	  Add support for overlay filesystem.
Index: linux-2.6/fs/overlayfs/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/fs/overlayfs/Makefile	2010-09-03 14:46:00.000000000 +0200
@@ -0,0 +1,5 @@
+#
+# Makefile for the overlay filesystem.
+#
+
+obj-$(CONFIG_OVERLAYFS_FS) += overlayfs.o

-- 
