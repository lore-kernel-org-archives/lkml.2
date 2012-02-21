Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab2BUTLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:11:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab2BUTLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:11:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 28/73] union-mount: Add union_create_topmost_dir() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:01:03 +0000
Message-ID: <20120221180103.25235.24872.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Union mounts design requires that the topmost directory exist for
every single directory at the time lookup completes.  This is so that
we don't have to double back and create a whole path's worth of
directories whenever we copy up a file in a directory for the first
time.  This greatly simplifies locking and error handling.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/union.c |  114 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/union.h |    9 +++++
 2 files changed, 123 insertions(+), 0 deletions(-)

diff --git a/fs/union.c b/fs/union.c
index 1e459b0..f183051 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -20,6 +20,8 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/namei.h>
+#include <linux/fsnotify.h>
+#include <linux/xattr.h>
 
 #include "union.h"
 
@@ -88,3 +90,115 @@ int union_add_dir(struct path *topmost, struct path *lower, unsigned layer)
 	*path = *lower;
 	return 0;
 }
+
+/**
+ * union_copyup_xattr
+ * @old: dentry of original file
+ * @new: dentry of new copy
+ *
+ * Copy up extended attributes from the original file to the new one.
+ *
+ * XXX - Permissions?  For now, copying up every xattr.
+ */
+static int union_copyup_xattr(struct dentry *old, struct dentry *new)
+{
+	ssize_t list_size, size;
+	char *buf, *name, *value;
+	int error;
+
+	/* Check for xattr support */
+	if (!old->d_inode->i_op->getxattr ||
+	    !new->d_inode->i_op->getxattr)
+		return 0;
+
+	/* Find out how big the list of xattrs is */
+	list_size = vfs_listxattr(old, NULL, 0);
+	if (list_size <= 0)
+		return list_size;
+
+	/* Allocate memory for the list */
+	buf = kzalloc(list_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	/* Allocate memory for the xattr's value */
+	error = -ENOMEM;
+	value = kmalloc(XATTR_SIZE_MAX, GFP_KERNEL);
+	if (!value)
+		goto out;
+
+	/* Actually get the list of xattrs */
+	list_size = vfs_listxattr(old, buf, list_size);
+	if (list_size <= 0) {
+		error = list_size;
+		goto out_free_value;
+	}
+
+	for (name = buf; name < (buf + list_size); name += strlen(name) + 1) {
+		/* XXX Locking? old is on read-only fs */
+		size = vfs_getxattr(old, name, value, XATTR_SIZE_MAX);
+		if (size <= 0) {
+			error = size;
+			goto out_free_value;
+		}
+		/* XXX do we really need to check for size overflow? */
+		/* XXX locks new dentry, lock ordering problems? */
+		error = vfs_setxattr(new, name, value, size, 0);
+		if (error)
+			goto out_free_value;
+	}
+
+out_free_value:
+	kfree(value);
+out:
+	kfree(buf);
+	return error;
+}
+
+/**
+ * union_create_topmost_dir - Create a matching dir in the topmost file system
+ * @parent - parent of target on topmost layer
+ * @name - name of target
+ * @topmost - path of target on topmost layer
+ * @lower - path of source on lower layer
+ *
+ * As we lookup each directory on the lower layer of a union, we create a
+ * matching directory on the topmost layer if it does not already exist.
+ *
+ * We don't use vfs_mkdir() for a few reasons: don't want to do the security
+ * check, don't want to make the dir opaque, don't need to sanitize the mode.
+ *
+ * XXX - owner is wrong, set credentials properly
+ * XXX - rmdir() directory on failure of xattr copyup
+ * XXX - not atomic w/ respect to crash
+ */
+int union_create_topmost_dir(struct path *parent, struct qstr *name,
+			     struct path *topmost, struct path *lower)
+{
+	struct inode *dir = parent->dentry->d_inode;
+	int mode = lower->dentry->d_inode->i_mode;
+	int error;
+
+	BUG_ON(topmost->dentry->d_inode);
+
+	/* XXX - Do we even need to check this? */
+	if (!dir->i_op->mkdir)
+		return -EPERM;
+
+	error = mnt_want_write(parent->mnt);
+	if (error)
+		return error;
+
+	error = dir->i_op->mkdir(dir, topmost->dentry, mode);
+	if (error)
+		goto out;
+
+	error = union_copyup_xattr(lower->dentry, topmost->dentry);
+	if (error)
+		dput(topmost->dentry);
+
+	fsnotify_mkdir(dir, topmost->dentry);
+out:
+	mnt_drop_write(parent->mnt);
+	return error;
+}
diff --git a/fs/union.h b/fs/union.h
index f39c88d..e918a04 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -58,6 +58,8 @@ static inline bool IS_DIR_UNIONED(struct dentry *dentry)
 
 extern void d_free_unions(struct dentry *);
 extern int union_add_dir(struct path *, struct path *, unsigned int);
+extern int union_create_topmost_dir(struct path *, struct qstr *, struct path *,
+				    struct path *);
 
 static inline
 struct path *union_find_dir(struct dentry *dentry, unsigned int layer)
@@ -85,4 +87,11 @@ int union_add_dir(struct path *topmost, struct path *lower, unsigned layer)
 	return 0;
 }
 
+static inline int union_create_topmost_dir(struct path *parent, struct qstr *name,
+					   struct path *topmost, struct path *lower)
+{
+	BUG();
+	return 0;
+}
+
 #endif	/* CONFIG_UNION_MOUNT */

