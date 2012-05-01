Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab2EAPR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:17:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab2EAPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:17:57 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 1/5] inode_only_permission: export inode level permissions checks
Date: Tue,  1 May 2012 16:17:51 +0100
Message-Id: <1335885475-11990-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1335885475-11990-1-git-send-email-apw@canonical.com>
References: <1335885475-11990-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to be able to check inode permissions (but not filesystem implied
permissions) for stackable filesystems.  Now that permissions involve
checking with the security LSM, cgroups and basic inode permissions it is
easy to miss a key permission check and introduce a security vunerability.
Expose a new interface for these checks.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/namei.c         |   48 +++++++++++++++++++++++++++++++-----------------
 include/linux/fs.h |    1 +
 2 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 0062dd1..744bd38 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -328,6 +328,36 @@ static inline int do_inode_permission(struct inode *inode, int mask)
 }
 
 /**
+ * inode_only_permission  -  check access rights to a given inode only
+ * @inode:	inode to check permissions on
+ * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC, ...)
+ *
+ * Uses to check read/write/execute permissions on an inode directly, we do
+ * not check filesystem permissions.
+ */
+int inode_only_permission(struct inode *inode, int mask)
+{
+	int retval;
+
+	/*
+	 * Nobody gets write access to an immutable file.
+	 */
+	if (unlikely(mask & MAY_WRITE) && IS_IMMUTABLE(inode))
+		return -EACCES;
+
+	retval = do_inode_permission(inode, mask);
+	if (retval)
+		return retval;
+
+	retval = devcgroup_inode_permission(inode, mask);
+	if (retval)
+		return retval;
+
+	return security_inode_permission(inode, mask);
+}
+EXPORT_SYMBOL(inode_only_permission);
+
+/**
  * inode_permission  -  check for access rights to a given inode
  * @inode:	inode to check permission on
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC, ...)
@@ -341,8 +371,6 @@ static inline int do_inode_permission(struct inode *inode, int mask)
  */
 int inode_permission(struct inode *inode, int mask)
 {
-	int retval;
-
 	if (unlikely(mask & MAY_WRITE)) {
 		umode_t mode = inode->i_mode;
 
@@ -352,23 +380,9 @@ int inode_permission(struct inode *inode, int mask)
 		if (IS_RDONLY(inode) &&
 		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
 			return -EROFS;
-
-		/*
-		 * Nobody gets write access to an immutable file.
-		 */
-		if (IS_IMMUTABLE(inode))
-			return -EACCES;
 	}
 
-	retval = do_inode_permission(inode, mask);
-	if (retval)
-		return retval;
-
-	retval = devcgroup_inode_permission(inode, mask);
-	if (retval)
-		return retval;
-
-	return security_inode_permission(inode, mask);
+	return inode_only_permission(inode, mask);
 }
 
 /**
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fdd1d38..0b531ab 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2226,6 +2226,7 @@ extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
 extern int inode_permission(struct inode *, int);
+extern int inode_only_permission(struct inode *, int);
 extern int generic_permission(struct inode *, int);
 
 static inline bool execute_ok(struct inode *inode)
-- 
1.7.9.5

