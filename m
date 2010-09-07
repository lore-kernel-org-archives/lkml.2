Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0IGK3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:29:13 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48995 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab0IGK2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:28:43 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 2/6] fs/9p: Add xattr callbacks for POSIX ACL
Date: Tue,  7 Sep 2010 15:58:20 +0530
Message-Id: <1283855304-22472-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283855304-22472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1283855304-22472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement fetching POSIX ACL from the server

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/acl.c   |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/9p/xattr.c |    4 ++++
 fs/9p/xattr.h |    2 ++
 3 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index a8c0136..4293b45 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -94,3 +94,44 @@ int v9fs_check_acl(struct inode *inode, int mask)
 	}
 	return -EAGAIN;
 }
+
+static int v9fs_xattr_get_acl(struct dentry *dentry, const char *name,
+			      void *buffer, size_t size, int type)
+{
+	struct posix_acl *acl;
+	int error;
+
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+
+	acl = v9fs_get_cached_acl(dentry->d_inode, type);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+	error = posix_acl_to_xattr(acl, buffer, size);
+	posix_acl_release(acl);
+
+	return error;
+}
+
+static int v9fs_xattr_set_acl(struct dentry *dentry, const char *name,
+			      const void *value, size_t size,
+			      int flags, int type)
+{
+	return 0;
+}
+
+const struct xattr_handler v9fs_xattr_acl_access_handler = {
+	.prefix	= POSIX_ACL_XATTR_ACCESS,
+	.flags	= ACL_TYPE_ACCESS,
+	.get	= v9fs_xattr_get_acl,
+	.set	= v9fs_xattr_set_acl,
+};
+
+const struct xattr_handler v9fs_xattr_acl_default_handler = {
+	.prefix	= POSIX_ACL_XATTR_DEFAULT,
+	.flags	= ACL_TYPE_DEFAULT,
+	.get	= v9fs_xattr_get_acl,
+	.set	= v9fs_xattr_set_acl,
+};
diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
index 67ac6cf..43ec7df 100644
--- a/fs/9p/xattr.c
+++ b/fs/9p/xattr.c
@@ -164,5 +164,9 @@ ssize_t v9fs_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 
 const struct xattr_handler *v9fs_xattr_handlers[] = {
 	&v9fs_xattr_user_handler,
+#ifdef CONFIG_9P_FS_POSIX_ACL
+	&v9fs_xattr_acl_access_handler,
+	&v9fs_xattr_acl_default_handler,
+#endif
 	NULL
 };
diff --git a/fs/9p/xattr.h b/fs/9p/xattr.h
index ec908c6..eaa837c 100644
--- a/fs/9p/xattr.h
+++ b/fs/9p/xattr.h
@@ -20,6 +20,8 @@
 
 extern const struct xattr_handler *v9fs_xattr_handlers[];
 extern struct xattr_handler v9fs_xattr_user_handler;
+extern const struct xattr_handler v9fs_xattr_acl_access_handler;
+extern const struct xattr_handler v9fs_xattr_acl_default_handler;
 
 extern ssize_t v9fs_fid_xattr_get(struct p9_fid *, const char *,
 				  void *, size_t);
-- 
1.7.0.4

