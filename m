Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab2CFQSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:18:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42576 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab2CFQSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:18:08 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 1/2] inode_only_permission: export inode level permissions checks
Date: Tue,  6 Mar 2012 16:18:05 +0000
Message-Id: <1331050686-1815-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <20120306161224.GE9978@shadowen.org>
References: <20120306161224.GE9978@shadowen.org>
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
 fs/namei.c         |   34 +++++++++++++++++++++++++---------
 include/linux/fs.h |    1 +
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e2ba628..16c77a4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -328,6 +328,30 @@ static inline int do_inode_permission(struct inode *inode, int mask)
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
@@ -360,15 +384,7 @@ int inode_permission(struct inode *inode, int mask)
 			return -EACCES;
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
index 871c87f..b06a3b4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2228,6 +2228,7 @@ extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
 extern int inode_permission(struct inode *, int);
+extern int inode_only_permission(struct inode *, int);
 extern int generic_permission(struct inode *, int);
 
 static inline bool execute_ok(struct inode *inode)
-- 
1.7.9

