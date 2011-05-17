Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab1EQMa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:30:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57108 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab1EQMaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=I74vX1QsiEa0mv2s98YlMxBFRWwh995vcILBDKIxq1+E4Z2fnj8w24J1poEI5dra60
         +Y97cE8Dp0/iHAeR+nLrzYkJy44FvJwxtcosAE+tx6yEexAa999Ia22CThHUJqMlSZA2
         CUPsEAPNA/DPLSDPcAG13HwKs30rPBviJXBvk=
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        mszeredi@suse.cz, Eric Paris <eparis@redhat.com>,
        Kyle McMartin <kyle@mcmartin.ca>
Subject: [PATCH 1/7] tmpfs: implement generic xattr support
Date: Tue, 17 May 2011 14:30:46 +0200
Message-Id: <1305635452-14835-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

Implement generic xattrs for tmpfs filesystems.  The Feodra project, while
trying to replace suid apps with file capabilities, realized that tmpfs,
which is used on the build systems, does not support file capabilities and
thus cannot be used to build packages which use file capabilities.  Xattrs
are also needed for overlayfs.

The xattr interface is a bit odd.  If a filesystem does not implement any
{get,set,list}xattr functions the VFS will call into some random LSM hooks
and the running LSM can then implement some method for handling xattrs.
SELinux for example provides a method to support security.selinux but no
other security.* xattrs.

As it stands today when one enables CONFIG_TMPFS_POSIX_ACL tmpfs will have
xattr handler routines specifically to handle acls.  Because of this tmpfs
would loose the VFS/LSM helpers to support the running LSM.  To make up
for that tmpfs had stub functions that did nothing but call into the LSM
hooks which implement the helpers.

This new patch does not use the LSM fallback functions and instead just
implements a native get/set/list xattr feature for the full security.* and
trusted.* namespace like a normal filesystem.  This means that tmpfs can
now support both security.selinux and security.capability, which was not
previously possible.

The basic implementation is that I attach a:

struct shmem_xattr {
	struct list_head list; /* anchored by shmem_inode_info->xattr_list */
	char *name;
	size_t size;
	char value[0];
};

Into the struct shmem_inode_info for each xattr that is set.  This
implementation could easily support the user.* namespace as well, except
some care needs to be taken to prevent large amounts of unswappable memory
being allocated for unprivileged users.

[mszeredi@suse.cz: new config option, suport trusted.*, support symlinks]
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Acked-by: Hugh Dickins <hughd@google.com>
Tested-by: Jordi Pujol <jordipujolp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/Kconfig               |   18 +++-
 include/linux/shmem_fs.h |    8 +-
 mm/shmem.c               |  320 ++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 290 insertions(+), 56 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index f3aa9b0..979992d 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -121,9 +121,25 @@ config TMPFS
 
 	  See <file:Documentation/filesystems/tmpfs.txt> for details.
 
+config TMPFS_XATTR
+	bool "Tmpfs extended attributes"
+	depends on TMPFS
+	default n
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page, or visit
+	  <http://acl.bestbits.at/> for details).
+
+	  Currently this enables support for the trusted.* and
+	  security.* namespaces.
+
+	  If unsure, say N.
+
+	  You need this for POSIX ACL support on tmpfs.
+
 config TMPFS_POSIX_ACL
 	bool "Tmpfs POSIX Access Control Lists"
-	depends on TMPFS
+	depends on TMPFS_XATTR
 	select GENERIC_ACL
 	help
 	  POSIX Access Control Lists (ACLs) support permissions for users and
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 399be5a..2b7fec8 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -9,6 +9,8 @@
 
 #define SHMEM_NR_DIRECT 16
 
+#define SHMEM_SYMLINK_INLINE_LEN (SHMEM_NR_DIRECT * sizeof(swp_entry_t))
+
 struct shmem_inode_info {
 	spinlock_t		lock;
 	unsigned long		flags;
@@ -17,8 +19,12 @@ struct shmem_inode_info {
 	unsigned long		next_index;	/* highest alloced index + 1 */
 	struct shared_policy	policy;		/* NUMA memory alloc policy */
 	struct page		*i_indirect;	/* top indirect blocks page */
-	swp_entry_t		i_direct[SHMEM_NR_DIRECT]; /* first blocks */
+	union {
+		swp_entry_t	i_direct[SHMEM_NR_DIRECT]; /* first blocks */
+		char		inline_symlink[SHMEM_SYMLINK_INLINE_LEN];
+	};
 	struct list_head	swaplist;	/* chain of maybes on swap */
+	struct list_head	xattr_list;	/* list of shmem_xattr */
 	struct inode		vfs_inode;
 };
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 8fa27e4..eab5593c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -99,6 +99,13 @@ static struct vfsmount *shm_mnt;
 /* Pretend that each entry is of this size in directory's i_size */
 #define BOGO_DIRENT_SIZE 20
 
+struct shmem_xattr {
+	struct list_head list;	/* anchored by shmem_inode_info->xattr_list */
+	char *name;		/* xattr name */
+	size_t size;
+	char value[0];
+};
+
 /* Flag allocation requirements to shmem_getpage and shmem_swp_alloc */
 enum sgp_type {
 	SGP_READ,	/* don't exceed i_size, don't allocate page */
@@ -822,6 +829,7 @@ static int shmem_notify_change(struct dentry *dentry, struct iattr *attr)
 static void shmem_evict_inode(struct inode *inode)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct shmem_xattr *xattr, *nxattr;
 
 	if (inode->i_mapping->a_ops == &shmem_aops) {
 		truncate_inode_pages(inode->i_mapping, 0);
@@ -834,6 +842,11 @@ static void shmem_evict_inode(struct inode *inode)
 			mutex_unlock(&shmem_swaplist_mutex);
 		}
 	}
+
+	list_for_each_entry_safe(xattr, nxattr, &info->xattr_list, list) {
+		kfree(xattr->name);
+		kfree(xattr);
+	}
 	BUG_ON(inode->i_blocks);
 	shmem_free_inode(inode->i_sb);
 	end_writeback(inode);
@@ -1597,6 +1610,7 @@ static struct inode *shmem_get_inode(struct super_block *sb, const struct inode
 		spin_lock_init(&info->lock);
 		info->flags = flags & VM_NORESERVE;
 		INIT_LIST_HEAD(&info->swaplist);
+		INIT_LIST_HEAD(&info->xattr_list);
 		cache_no_acl(inode);
 
 		switch (mode & S_IFMT) {
@@ -1996,9 +2010,9 @@ static int shmem_symlink(struct inode *dir, struct dentry *dentry, const char *s
 
 	info = SHMEM_I(inode);
 	inode->i_size = len-1;
-	if (len <= (char *)inode - (char *)info) {
+	if (len <= SHMEM_SYMLINK_INLINE_LEN) {
 		/* do it inline */
-		memcpy(info, symname, len);
+		memcpy(info->inline_symlink, symname, len);
 		inode->i_op = &shmem_symlink_inline_operations;
 	} else {
 		error = shmem_getpage(inode, 0, &page, SGP_WRITE, NULL);
@@ -2024,7 +2038,7 @@ static int shmem_symlink(struct inode *dir, struct dentry *dentry, const char *s
 
 static void *shmem_follow_link_inline(struct dentry *dentry, struct nameidata *nd)
 {
-	nd_set_link(nd, (char *)SHMEM_I(dentry->d_inode));
+	nd_set_link(nd, SHMEM_I(dentry->d_inode)->inline_symlink);
 	return NULL;
 }
 
@@ -2048,63 +2062,253 @@ static void shmem_put_link(struct dentry *dentry, struct nameidata *nd, void *co
 	}
 }
 
-static const struct inode_operations shmem_symlink_inline_operations = {
-	.readlink	= generic_readlink,
-	.follow_link	= shmem_follow_link_inline,
-};
-
-static const struct inode_operations shmem_symlink_inode_operations = {
-	.readlink	= generic_readlink,
-	.follow_link	= shmem_follow_link,
-	.put_link	= shmem_put_link,
-};
-
-#ifdef CONFIG_TMPFS_POSIX_ACL
+#ifdef CONFIG_TMPFS_XATTR
 /*
- * Superblocks without xattr inode operations will get security.* xattr
- * support from the VFS "for free". As soon as we have any other xattrs
+ * Superblocks without xattr inode operations may get some security.* xattr
+ * support from the LSM "for free". As soon as we have any other xattrs
  * like ACLs, we also need to implement the security.* handlers at
  * filesystem level, though.
  */
 
-static size_t shmem_xattr_security_list(struct dentry *dentry, char *list,
-					size_t list_len, const char *name,
-					size_t name_len, int handler_flags)
+static int shmem_xattr_get(struct dentry *dentry, const char *name,
+			   void *buffer, size_t size)
 {
-	return security_inode_listsecurity(dentry->d_inode, list, list_len);
-}
+	struct shmem_inode_info *info;
+	struct shmem_xattr *xattr;
+	int ret = -ENODATA;
 
-static int shmem_xattr_security_get(struct dentry *dentry, const char *name,
-		void *buffer, size_t size, int handler_flags)
-{
-	if (strcmp(name, "") == 0)
-		return -EINVAL;
-	return xattr_getsecurity(dentry->d_inode, name, buffer, size);
+	info = SHMEM_I(dentry->d_inode);
+
+	spin_lock(&info->lock);
+	list_for_each_entry(xattr, &info->xattr_list, list) {
+		if (strcmp(name, xattr->name))
+			continue;
+
+		ret = xattr->size;
+		if (buffer) {
+			if (size < xattr->size)
+				ret = -ERANGE;
+			else
+				memcpy(buffer, xattr->value, xattr->size);
+		}
+		break;
+	}
+	spin_unlock(&info->lock);
+	return ret;
 }
 
-static int shmem_xattr_security_set(struct dentry *dentry, const char *name,
-		const void *value, size_t size, int flags, int handler_flags)
+static int shmem_xattr_set(struct dentry *dentry, const char *name,
+			   const void *value, size_t size, int flags)
 {
-	if (strcmp(name, "") == 0)
-		return -EINVAL;
-	return security_inode_setsecurity(dentry->d_inode, name, value,
-					  size, flags);
+	struct inode *inode = dentry->d_inode;
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct shmem_xattr *xattr;
+	struct shmem_xattr *new_xattr = NULL;
+	size_t len;
+	int err = 0;
+
+	/* value == NULL means remove */
+	if (value) {
+		/* wrap around? */
+		len = sizeof(*new_xattr) + size;
+		if (len <= sizeof(*new_xattr))
+			return -ENOMEM;
+
+		new_xattr = kmalloc(len, GFP_KERNEL);
+		if (!new_xattr)
+			return -ENOMEM;
+
+		new_xattr->name = kstrdup(name, GFP_KERNEL);
+		if (!new_xattr->name) {
+			kfree(new_xattr);
+			return -ENOMEM;
+		}
+
+		new_xattr->size = size;
+		memcpy(new_xattr->value, value, size);
+	}
+
+	spin_lock(&info->lock);
+	list_for_each_entry(xattr, &info->xattr_list, list) {
+		if (!strcmp(name, xattr->name)) {
+			if (flags & XATTR_CREATE) {
+				xattr = new_xattr;
+				err = -EEXIST;
+			} else if (new_xattr) {
+				list_replace(&xattr->list, &new_xattr->list);
+			} else {
+				list_del(&xattr->list);
+			}
+			goto out;
+		}
+	}
+	if (flags & XATTR_REPLACE) {
+		xattr = new_xattr;
+		err = -ENODATA;
+	} else {
+		list_add(&new_xattr->list, &info->xattr_list);
+		xattr = NULL;
+	}
+out:
+	spin_unlock(&info->lock);
+	if (xattr)
+		kfree(xattr->name);
+	kfree(xattr);
+	return err;
 }
 
-static const struct xattr_handler shmem_xattr_security_handler = {
-	.prefix = XATTR_SECURITY_PREFIX,
-	.list   = shmem_xattr_security_list,
-	.get    = shmem_xattr_security_get,
-	.set    = shmem_xattr_security_set,
-};
 
 static const struct xattr_handler *shmem_xattr_handlers[] = {
+#ifdef CONFIG_TMPFS_POSIX_ACL
 	&generic_acl_access_handler,
 	&generic_acl_default_handler,
-	&shmem_xattr_security_handler,
+#endif
 	NULL
 };
+
+static int shmem_xattr_validate(const char *name)
+{
+	struct { const char *prefix; size_t len; } arr[] = {
+		{ XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN },
+		{ XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN }
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(arr); i++) {
+		size_t preflen = arr[i].len;
+		if (strncmp(name, arr[i].prefix, preflen) == 0) {
+			if (!name[preflen])
+				return -EINVAL;
+			return 0;
+		}
+	}
+	return -EOPNOTSUPP;
+}
+
+static ssize_t shmem_getxattr(struct dentry *dentry, const char *name,
+			      void *buffer, size_t size)
+{
+	int err;
+
+	/*
+	 * If this is a request for a synthetic attribute in the system.*
+	 * namespace use the generic infrastructure to resolve a handler
+	 * for it via sb->s_xattr.
+	 */
+	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+		return generic_getxattr(dentry, name, buffer, size);
+
+	err = shmem_xattr_validate(name);
+	if (err)
+		return err;
+
+	return shmem_xattr_get(dentry, name, buffer, size);
+}
+
+static int shmem_setxattr(struct dentry *dentry, const char *name,
+			  const void *value, size_t size, int flags)
+{
+	int err;
+
+	/*
+	 * If this is a request for a synthetic attribute in the system.*
+	 * namespace use the generic infrastructure to resolve a handler
+	 * for it via sb->s_xattr.
+	 */
+	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+		return generic_setxattr(dentry, name, value, size, flags);
+
+	err = shmem_xattr_validate(name);
+	if (err)
+		return err;
+
+	if (size == 0)
+		value = "";  /* empty EA, do not remove */
+
+	return shmem_xattr_set(dentry, name, value, size, flags);
+
+}
+
+static int shmem_removexattr(struct dentry *dentry, const char *name)
+{
+	int err;
+
+	/*
+	 * If this is a request for a synthetic attribute in the system.*
+	 * namespace use the generic infrastructure to resolve a handler
+	 * for it via sb->s_xattr.
+	 */
+	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+		return generic_removexattr(dentry, name);
+
+	err = shmem_xattr_validate(name);
+	if (err)
+		return err;
+
+	return shmem_xattr_set(dentry, name, NULL, 0, XATTR_REPLACE);
+}
+
+static bool xattr_is_trusted(const char *name)
+{
+	return !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN);
+}
+
+static ssize_t shmem_listxattr(struct dentry *dentry, char *buffer, size_t size)
+{
+	bool trusted = capable(CAP_SYS_ADMIN);
+	struct shmem_xattr *xattr;
+	struct shmem_inode_info *info;
+	size_t used = 0;
+
+	info = SHMEM_I(dentry->d_inode);
+
+	spin_lock(&info->lock);
+	list_for_each_entry(xattr, &info->xattr_list, list) {
+		size_t len;
+
+		/* skip "trusted." attributes for unprivileged callers */
+		if (!trusted && xattr_is_trusted(xattr->name))
+			continue;
+
+		len = strlen(xattr->name) + 1;
+		used += len;
+		if (buffer) {
+			if (size < used) {
+				used = -ERANGE;
+				break;
+			}
+			memcpy(buffer, xattr->name, len);
+			buffer += len;
+		}
+	}
+	spin_unlock(&info->lock);
+
+	return used;
+}
+#endif /* CONFIG_TMPFS_XATTR */
+
+static const struct inode_operations shmem_symlink_inline_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= shmem_follow_link_inline,
+#ifdef CONFIG_TMPFS_XATTR
+	.setxattr	= shmem_setxattr,
+	.getxattr	= shmem_getxattr,
+	.listxattr	= shmem_listxattr,
+	.removexattr	= shmem_removexattr,
 #endif
+};
+
+static const struct inode_operations shmem_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= shmem_follow_link,
+	.put_link	= shmem_put_link,
+#ifdef CONFIG_TMPFS_XATTR
+	.setxattr	= shmem_setxattr,
+	.getxattr	= shmem_getxattr,
+	.listxattr	= shmem_listxattr,
+	.removexattr	= shmem_removexattr,
+#endif
+};
 
 static struct dentry *shmem_get_parent(struct dentry *child)
 {
@@ -2384,8 +2588,10 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_magic = TMPFS_MAGIC;
 	sb->s_op = &shmem_ops;
 	sb->s_time_gran = 1;
-#ifdef CONFIG_TMPFS_POSIX_ACL
+#ifdef CONFIG_TMPFS_XATTR
 	sb->s_xattr = shmem_xattr_handlers;
+#endif
+#ifdef CONFIG_TMPFS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
 #endif
 
@@ -2483,11 +2689,13 @@ static const struct file_operations shmem_file_operations = {
 static const struct inode_operations shmem_inode_operations = {
 	.setattr	= shmem_notify_change,
 	.truncate_range	= shmem_truncate_range,
+#ifdef CONFIG_TMPFS_XATTR
+	.setxattr	= shmem_setxattr,
+	.getxattr	= shmem_getxattr,
+	.listxattr	= shmem_listxattr,
+	.removexattr	= shmem_removexattr,
+#endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
-	.listxattr	= generic_listxattr,
-	.removexattr	= generic_removexattr,
 	.check_acl	= generic_check_acl,
 #endif
 
@@ -2505,23 +2713,27 @@ static const struct inode_operations shmem_dir_inode_operations = {
 	.mknod		= shmem_mknod,
 	.rename		= shmem_rename,
 #endif
+#ifdef CONFIG_TMPFS_XATTR
+	.setxattr	= shmem_setxattr,
+	.getxattr	= shmem_getxattr,
+	.listxattr	= shmem_listxattr,
+	.removexattr	= shmem_removexattr,
+#endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_notify_change,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
-	.listxattr	= generic_listxattr,
-	.removexattr	= generic_removexattr,
 	.check_acl	= generic_check_acl,
 #endif
 };
 
 static const struct inode_operations shmem_special_inode_operations = {
+#ifdef CONFIG_TMPFS_XATTR
+	.setxattr	= shmem_setxattr,
+	.getxattr	= shmem_getxattr,
+	.listxattr	= shmem_listxattr,
+	.removexattr	= shmem_removexattr,
+#endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_notify_change,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
-	.listxattr	= generic_listxattr,
-	.removexattr	= generic_removexattr,
 	.check_acl	= generic_check_acl,
 #endif
 };
-- 
1.7.3.4

