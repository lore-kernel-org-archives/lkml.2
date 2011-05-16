Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab1EPOqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:46:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46405 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab1EPOqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:46:09 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v5 02/21] xattr: define vfs_getxattr_alloc and vfs_xattr_cmp
Date: Mon, 16 May 2011 10:44:56 -0400
Message-Id: <1305557115-15652-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfs_getxattr_alloc() and vfs_xattr_cmp() are two new kernel xattr helper
functions.  vfs_getxattr_alloc() first allocates memory for the requested
xattr and then retrieves it. vfs_xattr_cmp() compares a given value with
the contents of an extended attribute.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 fs/xattr.c            |   58 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/xattr.h |    5 +++-
 2 files changed, 62 insertions(+), 1 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index a19acdb..6da0c8c 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -159,6 +159,64 @@ out_noalloc:
 }
 EXPORT_SYMBOL_GPL(xattr_getsecurity);
 
+/*
+ * vfs_getxattr_alloc - allocate memory, if necessary, before calling getxattr
+ *
+ * Allocate memory, if not already allocated, or re-allocate correct size,
+ * before retrieving the extended attribute.
+ *
+ * Returns the result of alloc, if failed, or the getxattr operation.
+ */
+ssize_t
+vfs_getxattr_alloc(struct dentry *dentry, const char *name, char **xattr_value,
+		   size_t xattr_size, gfp_t flags)
+{
+	struct inode *inode = dentry->d_inode;
+	char *value = *xattr_value;
+	int error;
+
+	error = xattr_permission(inode, name, MAY_READ);
+	if (error)
+		return error;
+
+	if (!inode->i_op->getxattr)
+		return -EOPNOTSUPP;
+
+	error = inode->i_op->getxattr(dentry, name, NULL, 0);
+	if (error < 0)
+		return error;
+
+	if (!value || (error > xattr_size)) {
+		value = krealloc(*xattr_value, error + 1, flags);
+		if (!value)
+			return -ENOMEM;
+		memset(value, 0, error + 1);
+	}
+
+	error = inode->i_op->getxattr(dentry, name, value, error);
+	*xattr_value = value;
+	return error;
+}
+
+/* Compare an extended attribute value with the given value */
+int vfs_xattr_cmp(struct dentry *dentry, const char *xattr_name,
+		  const char *value, size_t size, gfp_t flags)
+{
+	char *xattr_value = NULL;
+	int rc;
+
+	rc = vfs_getxattr_alloc(dentry, xattr_name, &xattr_value, 0, flags);
+	if (rc < 0)
+		return rc;
+
+	if ((rc != size) || (memcmp(xattr_value, value, rc) != 0))
+		rc = -EINVAL;
+	else
+		rc = 0;
+	kfree(xattr_value);
+	return rc;
+}
+
 ssize_t
 vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
 {
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 6050783..953a0d5 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -78,7 +78,10 @@ ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer,
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);
 int generic_setxattr(struct dentry *dentry, const char *name, const void *value, size_t size, int flags);
 int generic_removexattr(struct dentry *dentry, const char *name);
-
+ssize_t vfs_getxattr_alloc(struct dentry *dentry, const char *name,
+			   char **xattr_value, size_t size, gfp_t flags);
+int vfs_xattr_cmp(struct dentry *dentry, const char *xattr_name,
+		  const char *value, size_t size, gfp_t flags);
 #endif  /*  __KERNEL__  */
 
 #endif	/* _LINUX_XATTR_H */
-- 
1.7.3.4

