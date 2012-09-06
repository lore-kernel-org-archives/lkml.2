Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807Ab2IFP5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:57:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758569Ab2IFP4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:56:38 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 2/2] overlayfs: when the underlying filesystem is read-only use inode permissions
Date: Thu,  6 Sep 2012 16:56:34 +0100
Message-Id: <1346946994-21286-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346946994-21286-1-git-send-email-apw@canonical.com>
References: <1346946994-21286-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the lowerdir represents a read-only filesystems, attempts to write
to the overlay will check for write permissions on files in the lower
layer via the lower layer inode .permissions operation.  This operation
may take the read-only status into account and fail the request even
though the notional permissions on the file permit write.  This prevents
a copy_up occuring on the file and fails the write.

Switch to using inode permissions directly when the lower layer is
read-only.

BugLink: http://bugs.launchpad.net/bugs/1039402
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/namei.c           |   36 ++++++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c |   12 ++++++++++++
 include/linux/fs.h   |    1 +
 3 files changed, 49 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 9be439a..09925a9 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -315,6 +315,42 @@ static inline int do_inode_permission(struct inode *inode, int mask)
 }
 
 /**
+ * __inode_permission_generic - Check for access rights to a given inode
+ * @inode: Inode to check permission on
+ * @mask: Right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ *
+ * Check for read/write/execute permissions on an inode.
+ *
+ * When checking for MAY_APPEND, MAY_WRITE must also be set in @mask.
+ *
+ * This does not check for a read-only file system.  You probably want
+ * inode_permission().
+ */
+int __inode_permission_generic(struct inode *inode, int mask)
+{
+	int retval;
+
+	if (unlikely(mask & MAY_WRITE)) {
+		/*
+		 * Nobody gets write access to an immutable file.
+		 */
+		if (IS_IMMUTABLE(inode))
+			return -EACCES;
+	}
+
+	retval = generic_permission(inode, mask);
+	if (retval)
+		return retval;
+
+	retval = devcgroup_inode_permission(inode, mask);
+	if (retval)
+		return retval;
+
+	return security_inode_permission(inode, mask);
+}
+EXPORT_SYMBOL(__inode_permission_generic);
+
+/**
  * __inode_permission - Check for access rights to a given inode
  * @inode: Inode to check permission on
  * @mask: Right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index e7ab09b..00390f2 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -102,6 +102,18 @@ int ovl_permission(struct inode *inode, int mask)
 		if (is_upper && !IS_RDONLY(inode) && IS_RDONLY(realinode) &&
 		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
 			goto out_dput;
+
+		/*
+		 * If the lower layer is read-only the filesystem may
+		 * fail permissions checks for write even if the file
+		 * itself if writable and in a overlay would be eligable
+		 * for copy up.  Use the inode permission in this case
+		 * via generic_permission().
+		 */
+		if (!is_upper && !IS_RDONLY(inode) && IS_RDONLY(realinode)) {
+			err = __inode_permission_generic(realinode, mask);
+			goto out_dput;
+		}
 	}
 
 	err = __inode_permission(realinode, mask);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d573703..5e72ba7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2419,6 +2419,7 @@ extern sector_t bmap(struct inode *, sector_t);
 extern int notify_change(struct dentry *, struct iattr *);
 extern int inode_permission(struct inode *, int);
 extern int __inode_permission(struct inode *, int);
+extern int __inode_permission_generic(struct inode *, int);
 extern int generic_permission(struct inode *, int);
 
 static inline bool execute_ok(struct inode *inode)
-- 
1.7.9.5

