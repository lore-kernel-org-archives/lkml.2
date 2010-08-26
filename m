Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0HZLUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 07:20:48 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49882 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab0HZLUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 07:20:19 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 1/6] fs/9p: Implement POSIX ACL permission checking function
Date: Thu, 26 Aug 2010 16:49:53 +0530
Message-Id: <1282821598-16472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACL value is fetched as a part of inode initialization
from the server and the permission checking function use the
cached value of the ACL

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/Kconfig     |   13 +++++++
 fs/9p/Makefile    |    1 +
 fs/9p/acl.c       |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/9p/acl.h       |   27 +++++++++++++++
 fs/9p/vfs_inode.c |   11 +++++-
 fs/9p/vfs_super.c |    9 ++++-
 fs/9p/xattr.c     |   48 +++++++++++++++-----------
 fs/9p/xattr.h     |    4 ++
 8 files changed, 185 insertions(+), 23 deletions(-)
 create mode 100644 fs/9p/acl.c
 create mode 100644 fs/9p/acl.h

diff --git a/fs/9p/Kconfig b/fs/9p/Kconfig
index 7952337..7e05114 100644
--- a/fs/9p/Kconfig
+++ b/fs/9p/Kconfig
@@ -17,3 +17,16 @@ config 9P_FSCACHE
 	  Choose Y here to enable persistent, read-only local
 	  caching support for 9p clients using FS-Cache
 
+
+config 9P_FS_POSIX_ACL
+	bool "9P POSIX Access Control Lists"
+	depends on 9P_FS
+	select FS_POSIX_ACL
+	help
+	  POSIX Access Control Lists (ACLs) support permissions for users and
+	  groups beyond the owner/group/world scheme.
+
+	  To learn more about Access Control Lists, visit the POSIX ACLs for
+	  Linux website <http://acl.bestbits.at/>.
+
+	  If you don't know what Access Control Lists are, say N
diff --git a/fs/9p/Makefile b/fs/9p/Makefile
index 91fba02..f8ba37e 100644
--- a/fs/9p/Makefile
+++ b/fs/9p/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_9P_FS) := 9p.o
 	xattr_user.o
 
 9p-$(CONFIG_9P_FSCACHE) += cache.o
+9p-$(CONFIG_9P_FS_POSIX_ACL) += acl.o
diff --git a/fs/9p/acl.c b/fs/9p/acl.c
new file mode 100644
index 0000000..5de599b
--- /dev/null
+++ b/fs/9p/acl.c
@@ -0,0 +1,95 @@
+/*
+ * Copyright IBM Corporation, 2010
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <net/9p/9p.h>
+#include <net/9p/client.h>
+#include <linux/slab.h>
+#include <linux/posix_acl_xattr.h>
+#include "xattr.h"
+
+static struct posix_acl *__v9fs_get_acl(struct p9_fid *fid, char *name)
+{
+	ssize_t size;
+	void *value = NULL;
+	struct posix_acl *acl = NULL;;
+
+	size = v9fs_fid_xattr_get(fid, name, NULL, 0);
+	if (size > 0) {
+		value = kzalloc(size, GFP_NOFS);
+		if (!value)
+			return ERR_PTR(-ENOMEM);
+		size = v9fs_fid_xattr_get(fid, name, value, size);
+		if (size > 0) {
+			acl = posix_acl_from_xattr(value, size);
+			if (IS_ERR(acl))
+				goto err_out;
+		}
+	} else if (size == -ENODATA || size == 0 ||
+		   size == -ENOSYS || size == -EOPNOTSUPP) {
+		acl = NULL;
+	} else
+		acl = ERR_PTR(-EIO);
+
+err_out:
+	kfree(value);
+	return acl;
+}
+
+int v9fs_get_acl(struct inode *inode, struct p9_fid *fid)
+{
+	int retval = 0;
+	struct posix_acl *pacl, *dacl;
+
+	/* get the default/access acl values and cache them */
+	dacl = __v9fs_get_acl(fid, POSIX_ACL_XATTR_DEFAULT);
+	pacl = __v9fs_get_acl(fid, POSIX_ACL_XATTR_ACCESS);
+
+	if (!IS_ERR(dacl) && !IS_ERR(pacl)) {
+		set_cached_acl(inode, ACL_TYPE_DEFAULT, dacl);
+		set_cached_acl(inode, ACL_TYPE_ACCESS, pacl);
+		posix_acl_release(dacl);
+		posix_acl_release(pacl);
+	} else
+		retval = -EIO;
+
+	return retval;
+}
+
+static struct posix_acl *v9fs_get_cached_acl(struct inode *inode, int type)
+{
+	struct posix_acl *acl;
+	/*
+	 * 9p Always cache the acl value when
+	 * instantiating the inode (v9fs_inode_from_fid)
+	 */
+	acl = get_cached_acl(inode, type);
+	BUG_ON(acl == ACL_NOT_CACHED);
+	return acl;
+}
+
+int v9fs_check_acl(struct inode *inode, int mask)
+{
+	struct posix_acl *acl = v9fs_get_cached_acl(inode, ACL_TYPE_ACCESS);
+
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl) {
+		int error = posix_acl_permission(inode, acl, mask);
+		posix_acl_release(acl);
+		return error;
+	}
+	return -EAGAIN;
+}
diff --git a/fs/9p/acl.h b/fs/9p/acl.h
new file mode 100644
index 0000000..4c63eb1
--- /dev/null
+++ b/fs/9p/acl.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright IBM Corporation, 2010
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+#ifndef FS_9P_ACL_H
+#define FS_9P_ACL_H
+
+#ifdef CONFIG_9P_FS_POSIX_ACL
+extern int v9fs_get_acl(struct inode *, struct p9_fid *);
+extern int v9fs_check_acl(struct inode *inode, int mask);
+#else
+#define v9fs_check_acl NULL
+static inline int v9fs_get_acl(struct inode *, struct p9_fid *)
+{
+	return 0;
+}
+#endif
+#endif /* FS_9P_XATTR_H */
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index b23b6a5..7f0aac1 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -36,6 +36,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/xattr.h>
+#include <linux/posix_acl.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
@@ -44,6 +45,7 @@
 #include "fid.h"
 #include "cache.h"
 #include "xattr.h"
+#include "acl.h"
 
 static const struct inode_operations v9fs_dir_inode_operations;
 static const struct inode_operations v9fs_dir_inode_operations_dotu;
@@ -498,6 +500,11 @@ v9fs_inode_dotl(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 	v9fs_vcookie_set_qid(ret, &st->qid);
 	v9fs_cache_inode_get_cookie(ret);
 #endif
+	err = v9fs_get_acl(ret, fid);
+	if (err) {
+		iput(ret);
+		goto error;
+	}
 	kfree(st);
 	return ret;
 error:
@@ -629,7 +636,6 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 			goto error;
 		}
 	}
-
 	/* instantiate inode and assign the unopened fid to the dentry */
 	inode = v9fs_inode_from_fid(v9ses, fid, dir->i_sb);
 	if (IS_ERR(inode)) {
@@ -1964,7 +1970,7 @@ static const struct inode_operations v9fs_dir_inode_operations_dotl = {
 	.getxattr = generic_getxattr,
 	.removexattr = generic_removexattr,
 	.listxattr = v9fs_listxattr,
-
+	.check_acl = v9fs_check_acl,
 };
 
 static const struct inode_operations v9fs_dir_inode_operations = {
@@ -1991,6 +1997,7 @@ static const struct inode_operations v9fs_file_inode_operations_dotl = {
 	.getxattr = generic_getxattr,
 	.removexattr = generic_removexattr,
 	.listxattr = v9fs_listxattr,
+	.check_acl = v9fs_check_acl,
 };
 
 static const struct inode_operations v9fs_symlink_inode_operations = {
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index b222953..a120a48 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -46,6 +46,7 @@
 #include "v9fs_vfs.h"
 #include "fid.h"
 #include "xattr.h"
+#include "acl.h"
 
 static const struct super_operations v9fs_super_ops, v9fs_super_ops_dotl;
 
@@ -88,6 +89,10 @@ v9fs_fill_super(struct super_block *sb, struct v9fs_session_info *v9ses,
 	sb->s_flags = flags | MS_ACTIVE | MS_SYNCHRONOUS | MS_DIRSYNC |
 	    MS_NOATIME;
 
+#ifdef CONFIG_9P_FS_POSIX_ACL
+	sb->s_flags |= MS_POSIXACL;
+#endif
+
 	save_mount_options(sb, data);
 }
 
@@ -149,7 +154,6 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 		goto release_sb;
 	}
 	sb->s_root = root;
-
 	if (v9fs_proto_dotl(v9ses)) {
 		struct p9_stat_dotl *st = NULL;
 		st = p9_client_getattr_dotl(fid, P9_STATS_BASIC);
@@ -174,6 +178,9 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 		p9stat_free(st);
 		kfree(st);
 	}
+	retval = v9fs_get_acl(inode, fid);
+	if (retval)
+		goto release_sb;
 
 	v9fs_fid_add(root, fid);
 
diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
index c434424..a3696c9 100644
--- a/fs/9p/xattr.c
+++ b/fs/9p/xattr.c
@@ -21,30 +21,13 @@
 #include "fid.h"
 #include "xattr.h"
 
-/*
- * v9fs_xattr_get()
- *
- * Copy an extended attribute into the buffer
- * provided, or compute the buffer size required.
- * Buffer is NULL to compute the size of the buffer required.
- *
- * Returns a negative error number on failure, or the number of bytes
- * used / required on success.
- */
-ssize_t v9fs_xattr_get(struct dentry *dentry, const char *name,
-		       void *buffer, size_t buffer_size)
+ssize_t v9fs_fid_xattr_get(struct p9_fid *fid, const char *name,
+			   void *buffer, size_t buffer_size)
 {
 	ssize_t retval;
 	int msize, read_count;
 	u64 offset = 0, attr_size;
-	struct p9_fid *fid, *attr_fid;
-
-	P9_DPRINTK(P9_DEBUG_VFS, "%s: name = %s value_len = %zu\n",
-		__func__, name, buffer_size);
-
-	fid = v9fs_fid_lookup(dentry);
-	if (IS_ERR(fid))
-		return PTR_ERR(fid);
+	struct p9_fid *attr_fid;
 
 	attr_fid = p9_client_xattrwalk(fid, name, &attr_size);
 	if (IS_ERR(attr_fid)) {
@@ -88,6 +71,31 @@ error:
 
 }
 
+
+/*
+ * v9fs_xattr_get()
+ *
+ * Copy an extended attribute into the buffer
+ * provided, or compute the buffer size required.
+ * Buffer is NULL to compute the size of the buffer required.
+ *
+ * Returns a negative error number on failure, or the number of bytes
+ * used / required on success.
+ */
+ssize_t v9fs_xattr_get(struct dentry *dentry, const char *name,
+		       void *buffer, size_t buffer_size)
+{
+	struct p9_fid *fid;
+
+	P9_DPRINTK(P9_DEBUG_VFS, "%s: name = %s value_len = %zu\n",
+		__func__, name, buffer_size);
+	fid = v9fs_fid_lookup(dentry);
+	if (IS_ERR(fid))
+		return PTR_ERR(fid);
+
+	return v9fs_fid_xattr_get(fid, name, buffer, buffer_size);
+}
+
 /*
  * v9fs_xattr_set()
  *
diff --git a/fs/9p/xattr.h b/fs/9p/xattr.h
index 9ddf672..ec908c6 100644
--- a/fs/9p/xattr.h
+++ b/fs/9p/xattr.h
@@ -15,10 +15,14 @@
 #define FS_9P_XATTR_H
 
 #include <linux/xattr.h>
+#include <net/9p/9p.h>
+#include <net/9p/client.h>
 
 extern const struct xattr_handler *v9fs_xattr_handlers[];
 extern struct xattr_handler v9fs_xattr_user_handler;
 
+extern ssize_t v9fs_fid_xattr_get(struct p9_fid *, const char *,
+				  void *, size_t);
 extern ssize_t v9fs_xattr_get(struct dentry *, const char *,
 			      void *, size_t);
 extern int v9fs_xattr_set(struct dentry *, const char *,
-- 
1.7.0.4

