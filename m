Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab0IGK30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:29:26 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:35697 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab0IGK2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:28:50 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 4/6] fs/9p: Update ACL on chmod
Date: Tue,  7 Sep 2010 15:58:22 +0530
Message-Id: <1283855304-22472-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283855304-22472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1283855304-22472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need update the acl value on chmod

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/acl.c       |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/9p/acl.h       |    5 ++++
 fs/9p/vfs_inode.c |    6 +++++
 3 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index cad38bc..203da2b 100644
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
 static int v9fs_xattr_get_acl(struct dentry *dentry, const char *name,
 			      void *buffer, size_t size, int type)
 {
diff --git a/fs/9p/acl.h b/fs/9p/acl.h
index b1414f7..0adcc43 100644
--- a/fs/9p/acl.h
+++ b/fs/9p/acl.h
@@ -17,11 +17,16 @@
 #ifdef CONFIG_9P_FS_POSIX_ACL
 extern int v9fs_get_acl(struct inode *, struct p9_fid *);
 extern int v9fs_check_acl(struct inode *inode, int mask);
+extern int v9fs_acl_chmod(struct dentry *);
 #else
 #define v9fs_check_acl NULL
 static inline int v9fs_get_acl(struct inode *inode, struct p9_fid *fid)
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
index df5c6fa..7983698 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1284,6 +1284,12 @@ int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 
 	setattr_copy(dentry->d_inode, iattr);
 	mark_inode_dirty(dentry->d_inode);
+	if (iattr->ia_valid & ATTR_MODE) {
+		/* We also want to update ACL when we update mode bits */
+		retval = v9fs_acl_chmod(dentry);
+		if (retval < 0)
+			return retval;
+	}
 	return 0;
 }
 
-- 
1.7.0.4

