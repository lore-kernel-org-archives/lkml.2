Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab0IGK3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:29:03 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41136 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab0IGK2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:28:43 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 3/6] fs/9p: Implement setting posix acl
Date: Tue,  7 Sep 2010 15:58:21 +0530
Message-Id: <1283855304-22472-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283855304-22472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1283855304-22472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also update mode bits, as a normal file system.
I am not sure wether we should do that, considering that
a setxattr on the server will again update the ACL/mode value

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/acl.c       |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/9p/v9fs_vfs.h  |    1 +
 fs/9p/vfs_inode.c |    2 +-
 3 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index 4293b45..cad38bc 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -17,9 +17,11 @@
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 #include <linux/posix_acl_xattr.h>
 #include "xattr.h"
 #include "acl.h"
+#include "v9fs_vfs.h"
 
 static struct posix_acl *__v9fs_get_acl(struct p9_fid *fid, char *name)
 {
@@ -119,7 +121,77 @@ static int v9fs_xattr_set_acl(struct dentry *dentry, const char *name,
 			      const void *value, size_t size,
 			      int flags, int type)
 {
-	return 0;
+	int retval;
+	struct posix_acl *acl;
+	struct inode *inode = dentry->d_inode;
+
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+	if (!is_owner_or_cap(inode))
+		return -EPERM;
+	if (value) {
+		/* update the cached acl value */
+		acl = posix_acl_from_xattr(value, size);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		else if (acl) {
+			retval = posix_acl_valid(acl);
+			if (retval)
+				goto err_out;
+		}
+	} else
+		acl = NULL;
+
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		name = POSIX_ACL_XATTR_ACCESS;
+		if (acl) {
+			mode_t mode = inode->i_mode;
+			retval = posix_acl_equiv_mode(acl, &mode);
+			if (retval < 0)
+				goto err_out;
+			else {
+				struct iattr iattr;
+				if (retval == 0) {
+					/*
+					 * ACL can be represented
+					 * by the mode bits. So don't
+					 * update ACL.
+					 */
+					acl = NULL;
+					value = NULL;
+					size = 0;
+				}
+				/* Updte the mode bits */
+				iattr.ia_mode = ((mode & S_IALLUGO) |
+						 (inode->i_mode & ~S_IALLUGO));
+				iattr.ia_valid = ATTR_MODE;
+				/* FIXME should we update ctime ?
+				 * What is the following setxattr update the
+				 * mode ?
+				 */
+				v9fs_vfs_setattr_dotl(dentry, &iattr);
+			}
+		}
+		break;
+	case ACL_TYPE_DEFAULT:
+		name = POSIX_ACL_XATTR_DEFAULT;
+		if (!S_ISDIR(inode->i_mode)) {
+			retval = -EINVAL;
+			goto err_out;
+		}
+		break;
+	default:
+		BUG();
+	}
+	retval = v9fs_xattr_set(dentry, name, value, size, flags);
+	if (!retval)
+		set_cached_acl(inode, type, acl);
+err_out:
+	posix_acl_release(acl);
+	return retval;
 }
 
 const struct xattr_handler v9fs_xattr_acl_access_handler = {
diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index 88418c4..0986129 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -64,3 +64,4 @@ int v9fs_uflags2omode(int uflags, int extended);
 
 ssize_t v9fs_file_readn(struct file *, char *, char __user *, u32, u64);
 void v9fs_blank_wstat(struct p9_wstat *wstat);
+int v9fs_vfs_setattr_dotl(struct dentry *, struct iattr *);
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index ee0a21a..df5c6fa 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1242,7 +1242,7 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
  *
  */
 
-static int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
+int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 {
 	int retval;
 	struct v9fs_session_info *v9ses;
-- 
1.7.0.4

