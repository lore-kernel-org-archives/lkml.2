Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2BUSJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:09:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab2BUSHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:07:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/73] VFS: Split inode_permission() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com> (Further development)
Date: Tue, 21 Feb 2012 17:58:10 +0000
Message-ID: <20120221175810.25235.53821.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split inode_permission() into inode- and superblock-dependent parts.

This is aimed at unionmounts where the superblock from the upper layer has to
be checked rather than the superblock from the lower layer as the upper layer
may be writable, thus allowing an unwritable file from the lower layer to be
copied up and modified.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com> (Further development)
---

 fs/internal.h |    5 ++++
 fs/namei.c    |   66 ++++++++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 9962c59..043a937 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -42,6 +42,11 @@ static inline int __sync_blockdev(struct block_device *bdev, int wait)
 extern void __init chrdev_init(void);
 
 /*
+ * namei.c
+ */
+extern int __inode_permission(struct inode *, int);
+
+/*
  * namespace.c
  */
 extern int copy_mount_options(const void __user *, unsigned long *);
diff --git a/fs/namei.c b/fs/namei.c
index 2d983f7..7f9df02 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -328,31 +328,22 @@ static inline int do_inode_permission(struct inode *inode, int mask)
 }
 
 /**
- * inode_permission  -  check for access rights to a given inode
- * @inode:	inode to check permission on
- * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC, ...)
+ * __inode_permission - Check for access rights to a given inode
+ * @inode: Inode to check permission on
+ * @mask: Right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
  *
- * Used to check for read/write/execute permissions on an inode.
- * We use "fsuid" for this, letting us set arbitrary permissions
- * for filesystem access without changing the "normal" uids which
- * are used for other things.
+ * Check for read/write/execute permissions on an inode.
  *
  * When checking for MAY_APPEND, MAY_WRITE must also be set in @mask.
+ *
+ * This does not check for a read-only file system.  You probably want
+ * inode_permission().
  */
-int inode_permission(struct inode *inode, int mask)
+int __inode_permission(struct inode *inode, int mask)
 {
 	int retval;
 
 	if (unlikely(mask & MAY_WRITE)) {
-		umode_t mode = inode->i_mode;
-
-		/*
-		 * Nobody gets write access to a read-only fs.
-		 */
-		if (IS_RDONLY(inode) &&
-		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
-			return -EROFS;
-
 		/*
 		 * Nobody gets write access to an immutable file.
 		 */
@@ -372,6 +363,47 @@ int inode_permission(struct inode *inode, int mask)
 }
 
 /**
+ * sb_permission - Check superblock-level permissions
+ * @sb: Superblock of inode to check permission on
+ * @mask: Right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ *
+ * Separate out file-system wide checks from inode-specific permission checks.
+ */
+static int sb_permission(struct super_block *sb, struct inode *inode, int mask)
+{
+	if (unlikely(mask & MAY_WRITE)) {
+		umode_t mode = inode->i_mode;
+
+		/* Nobody gets write access to a read-only fs. */
+		if ((sb->s_flags & MS_RDONLY) &&
+		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
+			return -EROFS;
+	}
+	return 0;
+}
+
+/**
+ * inode_permission - Check for access rights to a given inode
+ * @inode: Inode to check permission on
+ * @mask: Right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ *
+ * Check for read/write/execute permissions on an inode.  We use fs[ug]id for
+ * this, letting us set arbitrary permissions for filesystem access without
+ * changing the "normal" UIDs which are used for other things.
+ *
+ * When checking for MAY_APPEND, MAY_WRITE must also be set in @mask.
+ */
+int inode_permission(struct inode *inode, int mask)
+{
+	int retval;
+
+	retval = sb_permission(inode->i_sb, inode, mask);
+	if (retval)
+		return retval;
+	return __inode_permission(inode, mask);
+}
+
+/**
  * path_get - get a reference to a path
  * @path: path to get the reference to
  *

