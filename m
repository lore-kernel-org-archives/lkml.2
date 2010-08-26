Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab0HZLUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 07:20:45 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:45979 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab0HZLUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 07:20:09 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 4/6] fs/9p: Update ACL on chmod
Date: Thu, 26 Aug 2010 16:49:56 +0530
Message-Id: <1282821598-16472-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282821598-16472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282821598-16472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need update the acl value on chmod

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/acl.c       |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/9p/acl.h       |    5 ++++
 fs/9p/vfs_inode.c |    4 +++
 3 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index fc06467..d717487 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -97,6 +97,61 @@ int v9fs_check_acl(struct inode *inode, int mask)
 	return -EAGAIN;
 }
 
+static int v9fs_set_acl(struct dentry *dentry, int type, struct posix_acl *acl)
+{
+	int retval;
+	char *name;
+	size_t size;
+	void *buffer;
+	struct inode *inode = dentry->d_inode;
+
+	set_cached_acl(inode, type, acl);
+	/* Set a setxattr request to server */
+	size = posix_acl_xattr_size(acl->a_count);
+	buffer = kmalloc(size, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+	retval = posix_acl_to_xattr(acl, buffer, size);
+	if (retval)
+		goto err_free_out;
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		name = POSIX_ACL_XATTR_ACCESS;
+		break;
+	case ACL_TYPE_DEFAULT:
+		name = POSIX_ACL_XATTR_DEFAULT;
+		break;
+	default:
+		BUG();
+	}
+	retval = v9fs_xattr_set(dentry, name, buffer, size, 0);
+err_free_out:
+	kfree(buffer);
+	return retval;
+}
+
+int v9fs_acl_chmod(struct dentry *dentry)
+{
+	int retval = 0;
+	struct posix_acl *acl, *clone;
+	struct inode *inode = dentry->d_inode;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+	acl = v9fs_get_cached_acl(inode, ACL_TYPE_ACCESS);
+	if (acl) {
+		clone = posix_acl_clone(acl, GFP_KERNEL);
+		posix_acl_release(acl);
+		if (!clone)
+			return -ENOMEM;
+		retval = posix_acl_chmod_masq(clone, inode->i_mode);
+		if (!retval)
+			retval = v9fs_set_acl(dentry, ACL_TYPE_ACCESS, clone);
+		posix_acl_release(clone);
+	}
+	return retval;
+}
+
 static size_t v9fs_xattr_list_acl_access(struct dentry *dentry, char *list,
 					 size_t list_len, const char *name,
 					 size_t name_len, int type)
diff --git a/fs/9p/acl.h b/fs/9p/acl.h
index 4c63eb1..2409e17 100644
--- a/fs/9p/acl.h
+++ b/fs/9p/acl.h
@@ -17,11 +17,16 @@
 #ifdef CONFIG_9P_FS_POSIX_ACL
 extern int v9fs_get_acl(struct inode *, struct p9_fid *);
 extern int v9fs_check_acl(struct inode *inode, int mask);
+extern int v9fs_acl_chmod(struct dentry *);
 #else
 #define v9fs_check_acl NULL
 static inline int v9fs_get_acl(struct inode *, struct p9_fid *)
 {
 	return 0;
 }
+static inline int v9fs_acl_chmod(struct dentry *dentry)
+{
+	return 0;
+}
 #endif
 #endif /* FS_9P_XATTR_H */
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 8f5bf6b..6fb80e5 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1238,6 +1238,10 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	if (retval >= 0)
 		retval = inode_setattr(dentry->d_inode, iattr);
 
+	if (!retval && (iattr->ia_valid & ATTR_MODE))
+		/* We also want to update ACL when we update mode bits */
+		retval = v9fs_acl_chmod(dentry);
+
 	return retval;
 }
 
-- 
1.7.0.4

