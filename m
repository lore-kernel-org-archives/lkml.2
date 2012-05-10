Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab2EJXRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:17:55 -0400
Received: from mail.grid-net.com ([97.65.115.2]:35481 "EHLO mail.grid-net.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932780Ab2EJXRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:17:35 -0400
From: Subodh Nijsure <snijsure@grid-net.com>
To: <linux-mtd@lists.infradead.org>, <linux-security-module@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <snijsure@grid-net.com>
Subject: [PATCH v3] Add security.* XATTR support for the UBIFS
Date: Thu, 10 May 2012 16:17:22 -0700
Message-ID: <1336691842-32281-1-git-send-email-snijsure@grid-net.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.0.120]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fix couple of bugs in UBIFS extended attribute length calculation.

Changes in v3:
	 Remove #ifdef CONFIG_UBIFS_FS_XATTR

Changes in v2:
         Instead of just handling security.selinux extended attribute handle
         all security.* attributes.

TESTING: Tested on  MX28 based platforms using Micron MT29F2G08ABAEAH4 NAND
         With these change we are able to label UBIFS filesystem with
         security.selinux and run system with selinux enabled.
         This change also allows one to set other security.* extended
         attributesr, such as security.smack security.evm, security.ima
         Ran integck test on UBI filesystem.

Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
---
 fs/ubifs/dir.c     |   31 +++++++++++
 fs/ubifs/file.c    |    4 ++
 fs/ubifs/journal.c |   12 +++-
 fs/ubifs/super.c   |    1 +
 fs/ubifs/ubifs.h   |    9 +++
 fs/ubifs/xattr.c   |  152 ++++++++++++++++++++++++++++++++++++++++++++++------
 6 files changed, 190 insertions(+), 19 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index ad6e550..cec3ffab 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -292,6 +292,14 @@ static int ubifs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 
 	ubifs_release_budget(c, &req);
 	insert_inode_hash(inode);
+
+	err = ubifs_init_security(dir, inode, &dentry->d_name);
+	if (err) {
+		ubifs_err("cannot initialize extended attribute, error %d",
+			  err);
+		goto out_cancel;
+	}
+
 	d_instantiate(dentry, inode);
 	return 0;
 
@@ -753,6 +761,13 @@ static int ubifs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	mutex_unlock(&dir_ui->ui_mutex);
 
 	ubifs_release_budget(c, &req);
+
+	err = ubifs_init_security(dir, inode, &dentry->d_name);
+	if (err) {
+		ubifs_err("cannot initialize extended attribute, error %d",
+			  err);
+		goto out_cancel;
+	}
 	d_instantiate(dentry, inode);
 	return 0;
 
@@ -830,6 +845,14 @@ static int ubifs_mknod(struct inode *dir, struct dentry *dentry,
 
 	ubifs_release_budget(c, &req);
 	insert_inode_hash(inode);
+
+	err = ubifs_init_security(dir, inode, &dentry->d_name);
+	if (err) {
+		ubifs_err("cannot initialize extended attribute, error %d",
+			  err);
+		goto out_cancel;
+	}
+
 	d_instantiate(dentry, inode);
 	return 0;
 
@@ -906,6 +929,14 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 
 	ubifs_release_budget(c, &req);
 	insert_inode_hash(inode);
+
+	err = ubifs_init_security(dir, inode, &dentry->d_name);
+	if (err) {
+		ubifs_err("cannot initialize extended attribute, error %d",
+			  err);
+		goto out_cancel;
+	}
+
 	d_instantiate(dentry, inode);
 	return 0;
 
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 0fe640c..8629da0 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1573,6 +1573,10 @@ const struct inode_operations ubifs_symlink_inode_operations = {
 	.follow_link = ubifs_follow_link,
 	.setattr     = ubifs_setattr,
 	.getattr     = ubifs_getattr,
+	.setxattr    = ubifs_symlink_setxattr,
+	.getxattr    = ubifs_symlink_getxattr,
+	.listxattr   = ubifs_listxattr,
+	.removexattr = ubifs_removexattr,
 };
 
 const struct file_operations ubifs_file_operations = {
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index bc75e9d..5086823 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -553,7 +553,8 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 
 	dbg_jnl("ino %lu, dent '%.*s', data len %d in dir ino %lu",
 		inode->i_ino, nm->len, nm->name, ui->data_len, dir->i_ino);
-	ubifs_assert(dir_ui->data_len == 0);
+	if (!xent)
+		ubifs_assert(dir_ui->data_len == 0);
 	ubifs_assert(mutex_is_locked(&dir_ui->ui_mutex));
 
 	dlen = UBIFS_DENT_NODE_SZ + nm->len + 1;
@@ -572,7 +573,11 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 
 	aligned_dlen = ALIGN(dlen, 8);
 	aligned_ilen = ALIGN(ilen, 8);
-	len = aligned_dlen + aligned_ilen + UBIFS_INO_NODE_SZ;
+	/* Make sure to account for dir_ui+data_len in length calculation
+	 * in case there is extended attribute.
+	 */
+	len = aligned_dlen + aligned_ilen +
+	      UBIFS_INO_NODE_SZ + dir_ui->data_len;
 	dent = kmalloc(len, GFP_NOFS);
 	if (!dent)
 		return -ENOMEM;
@@ -649,7 +654,8 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 
 	ino_key_init(c, &ino_key, dir->i_ino);
 	ino_offs += aligned_ilen;
-	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs, UBIFS_INO_NODE_SZ);
+	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs,
+			    UBIFS_INO_NODE_SZ + dir_ui->data_len);
 	if (err)
 		goto out_ro;
 
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 76e4e05..228c69d 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2061,6 +2061,7 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 	if (c->max_inode_sz > MAX_LFS_FILESIZE)
 		sb->s_maxbytes = c->max_inode_sz = MAX_LFS_FILESIZE;
 	sb->s_op = &ubifs_super_operations;
+	sb->s_xattr = ubifs_xattr_handlers;
 
 	mutex_lock(&c->umount_mutex);
 	err = mount_ubifs(c);
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 93d59ac..60b57f7 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -36,6 +36,7 @@
 #include <linux/mtd/ubi.h>
 #include <linux/pagemap.h>
 #include <linux/backing-dev.h>
+#include <linux/security.h>
 #include "ubifs-media.h"
 
 /* Version of this UBIFS implementation */
@@ -1454,6 +1455,7 @@ extern spinlock_t ubifs_infos_lock;
 extern atomic_long_t ubifs_clean_zn_cnt;
 extern struct kmem_cache *ubifs_inode_slab;
 extern const struct super_operations ubifs_super_operations;
+extern const struct xattr_handler *ubifs_xattr_handlers[];
 extern const struct address_space_operations ubifs_file_address_operations;
 extern const struct file_operations ubifs_file_operations;
 extern const struct inode_operations ubifs_file_inode_operations;
@@ -1736,10 +1738,17 @@ int ubifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
 
 /* xattr.c */
+
 int ubifs_setxattr(struct dentry *dentry, const char *name,
 		   const void *value, size_t size, int flags);
+int ubifs_init_security(struct inode *dentry, struct inode *inode,
+			const struct qstr *qstr);
+int ubifs_symlink_setxattr(struct dentry *dentry, const char *name,
+			   const void *value, size_t size, int flags);
 ssize_t ubifs_getxattr(struct dentry *dentry, const char *name, void *buf,
 		       size_t size);
+ssize_t ubifs_symlink_getxattr(struct dentry *dentry, const char *name,
+			       void *buf, size_t size);
 ssize_t ubifs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 int ubifs_removexattr(struct dentry *dentry, const char *name);
 
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index 85b2722..49c426a 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -107,6 +107,7 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
 				.new_ino_d = ALIGN(size, 8), .dirtied_ino = 1,
 				.dirtied_ino_d = ALIGN(host_ui->data_len, 8) };
 
+	ubifs_assert(mutex_is_locked(&host_ui->ui_mutex));
 	if (host_ui->xattr_cnt >= MAX_XATTRS_PER_INODE)
 		return -ENOSPC;
 	/*
@@ -146,18 +147,14 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
 	inode->i_size = ui->ui_size = size;
 	ui->data_len = size;
 
-	mutex_lock(&host_ui->ui_mutex);
 	host->i_ctime = ubifs_current_time(host);
 	host_ui->xattr_cnt += 1;
 	host_ui->xattr_size += CALC_DENT_SIZE(nm->len);
 	host_ui->xattr_size += CALC_XATTR_BYTES(size);
 	host_ui->xattr_names += nm->len;
-
 	err = ubifs_jnl_update(c, host, nm, inode, 0, 1);
 	if (err)
 		goto out_cancel;
-	mutex_unlock(&host_ui->ui_mutex);
-
 	ubifs_release_budget(c, &req);
 	insert_inode_hash(inode);
 	iput(inode);
@@ -167,7 +164,6 @@ out_cancel:
 	host_ui->xattr_cnt -= 1;
 	host_ui->xattr_size -= CALC_DENT_SIZE(nm->len);
 	host_ui->xattr_size -= CALC_XATTR_BYTES(size);
-	mutex_unlock(&host_ui->ui_mutex);
 out_free:
 	make_bad_inode(inode);
 	iput(inode);
@@ -209,11 +205,11 @@ static int change_xattr(struct ubifs_info *c, struct inode *host,
 		goto out_free;
 	}
 	inode->i_size = ui->ui_size = size;
-	ui->data_len = size;
 
 	mutex_lock(&host_ui->ui_mutex);
 	host->i_ctime = ubifs_current_time(host);
 	host_ui->xattr_size -= CALC_XATTR_BYTES(ui->data_len);
+	ui->data_len = size;
 	host_ui->xattr_size += CALC_XATTR_BYTES(size);
 
 	/*
@@ -293,18 +289,16 @@ static struct inode *iget_xattr(struct ubifs_info *c, ino_t inum)
 	return ERR_PTR(-EINVAL);
 }
 
-int ubifs_setxattr(struct dentry *dentry, const char *name,
-		   const void *value, size_t size, int flags)
+static int __ubifs_setxattr(struct inode *host, const char *name,
+			    const void *value, size_t size, int flags)
 {
-	struct inode *inode, *host = dentry->d_inode;
+	struct inode *inode;
 	struct ubifs_info *c = host->i_sb->s_fs_info;
 	struct qstr nm = { .name = name, .len = strlen(name) };
 	struct ubifs_dent_node *xent;
 	union ubifs_key key;
 	int err, type;
 
-	dbg_gen("xattr '%s', host ino %lu ('%.*s'), size %zd", name,
-		host->i_ino, dentry->d_name.len, dentry->d_name.name, size);
 	ubifs_assert(mutex_is_locked(&host->i_mutex));
 
 	if (size > UBIFS_MAX_INO_DATA)
@@ -356,10 +350,29 @@ out_free:
 	return err;
 }
 
-ssize_t ubifs_getxattr(struct dentry *dentry, const char *name, void *buf,
-		       size_t size)
+int ubifs_symlink_setxattr(struct dentry *dentry, const char *name,
+			   const void *value, size_t size, int flags)
 {
-	struct inode *inode, *host = dentry->d_inode;
+	struct inode *host = dentry->d_inode;
+	dbg_gen("xattr '%s', host ino %lu ('%.*s'), size %zd", name,
+		host->i_ino, dentry->d_name.len, dentry->d_name.name, size);
+	return __ubifs_setxattr(host, name, value, size, flags);
+}
+
+int ubifs_setxattr(struct dentry *dentry, const char *name,
+		   const void *value, size_t size, int flags)
+{
+	struct inode *host = dentry->d_inode;
+	dbg_gen("xattr '%s', host ino %lu ('%.*s'), size %zd", name,
+		host->i_ino, dentry->d_name.len, dentry->d_name.name, size);
+	return __ubifs_setxattr(host, name, value, size, flags);
+}
+
+static
+ssize_t __ubifs_getxattr(struct inode *host, const char *name, void *buf,
+			 size_t size)
+{
+	struct inode *inode;
 	struct ubifs_info *c = host->i_sb->s_fs_info;
 	struct qstr nm = { .name = name, .len = strlen(name) };
 	struct ubifs_inode *ui;
@@ -367,8 +380,8 @@ ssize_t ubifs_getxattr(struct dentry *dentry, const char *name, void *buf,
 	union ubifs_key key;
 	int err;
 
-	dbg_gen("xattr '%s', ino %lu ('%.*s'), buf size %zd", name,
-		host->i_ino, dentry->d_name.len, dentry->d_name.name, size);
+	dbg_gen("xattr '%s', ino %lu  buf size %zd", name,
+		host->i_ino, size);
 
 	err = check_namespace(&nm);
 	if (err < 0)
@@ -416,6 +429,25 @@ out_unlock:
 	return err;
 }
 
+ssize_t ubifs_symlink_getxattr(struct dentry *dentry, const char *name,
+			       void *buf, size_t size)
+{
+	struct inode *host = dentry->d_inode;
+	dbg_gen("xattr '%s', ino %lu ('%.*s'), buf size %zd", name,
+		host->i_ino, dentry->d_name.len, dentry->d_name.name, size);
+	return __ubifs_getxattr(host, name, buf, size);
+}
+
+ssize_t ubifs_getxattr(struct dentry *dentry, const char *name, void *buf,
+		       size_t size)
+{
+	struct inode *host = dentry->d_inode;
+	dbg_gen("xattr '%s', ino %lu ('%.*s'), buf size %zd", name,
+		host->i_ino, dentry->d_name.len, dentry->d_name.name, size);
+	return __ubifs_getxattr(host, name, buf, size);
+}
+
+
 ssize_t ubifs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 {
 	union ubifs_key key;
@@ -568,3 +600,91 @@ out_free:
 	kfree(xent);
 	return err;
 }
+
+size_t
+ubifs_security_listxattr(struct dentry *d, char *list, size_t list_size,
+			 const char *name, size_t name_len, int flags)
+{
+	const int prefix_len = XATTR_SECURITY_PREFIX_LEN;
+	const size_t total_len = prefix_len + name_len + 1;
+	if (list && total_len <= list_size) {
+		memcpy(list, XATTR_SECURITY_PREFIX, prefix_len);
+		memcpy(list+prefix_len, name, name_len);
+		list[prefix_len + name_len] = '\0';
+	}
+	return total_len;
+}
+
+
+int ubifs_security_getxattr(struct dentry *d, const char *name,
+			    void *buffer, size_t size, int flags)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	return __ubifs_getxattr(d->d_inode, name, buffer, size);
+}
+
+
+int ubifs_security_setxattr(struct dentry *d, const char *name,
+			    const void *value, size_t size,
+			    int flags, int handler_flags)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	return __ubifs_setxattr(d->d_inode, name, value,
+				size, flags);
+}
+
+struct xattr_handler ubifs_xattr_security_handler = {
+	.prefix = XATTR_SECURITY_PREFIX,
+	.list   = ubifs_security_listxattr,
+	.get    = ubifs_security_getxattr,
+	.set    = ubifs_security_setxattr,
+};
+
+const struct xattr_handler *ubifs_xattr_handlers[] = {
+	&ubifs_xattr_security_handler,
+	NULL
+};
+
+static int ubifs_initxattrs(struct inode *inode,
+			    const struct xattr *xattr_array, void *fs_info)
+{
+	const struct xattr *xattr;
+	char *name;
+	int err = 0;
+
+	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+		name = kmalloc(XATTR_SECURITY_PREFIX_LEN +
+			       strlen(xattr->name) + 1, GFP_NOFS);
+		if (!name) {
+			err = -ENOMEM;
+			break;
+		}
+		strcpy(name, XATTR_SECURITY_PREFIX);
+		strcpy(name + XATTR_SECURITY_PREFIX_LEN, xattr->name);
+		err = __ubifs_setxattr(inode, name, xattr->value,
+				       xattr->value_len, 0);
+		kfree(name);
+		if (err < 0)
+			break;
+	}
+	return err;
+}
+
+int
+ubifs_init_security(struct inode *dentry, struct inode *inode,
+		   const struct qstr *qstr)
+{
+	struct ubifs_inode *dir_ui = ubifs_inode(inode);
+	int err = 0;
+
+	mutex_lock(&dir_ui->ui_mutex);
+	mutex_lock(&inode->i_mutex);
+
+	err = security_inode_init_security(inode, dentry, qstr,
+					   &ubifs_initxattrs, 0);
+	mutex_unlock(&inode->i_mutex);
+	mutex_unlock(&dir_ui->ui_mutex);
+	return err;
+}
-- 
1.7.5.4
