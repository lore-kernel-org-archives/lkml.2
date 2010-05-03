Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab0ECXOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:14:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333Ab0ECXOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:14:00 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Jan Blunck <jblunck@suse.de>,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 28/39] union-mount: In-kernel copyup of xattrs
Date: Mon,  3 May 2010 16:12:27 -0700
Message-Id: <1272928358-20854-29-git-send-email-vaurora@redhat.com>
In-Reply-To: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copyup extended attributes as well as file data.
---
 fs/union.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/fs/union.c b/fs/union.c
index d52c7c0..abc964a 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -27,6 +27,7 @@
 #include <linux/file.h>
 #include <linux/security.h>
 #include <linux/splice.h>
+#include <linux/xattr.h>
 
 /*
  * This is borrowed from fs/inode.c. The hashtable for lookups. Somebody
@@ -449,6 +450,72 @@ void detach_mnt_union(struct vfsmount *mnt)
 	return;
 }
 
+/**
+ * union_copyup_xattr
+ *
+ * @old: dentry of original file
+ * @new: dentry of new copy
+ *
+ * Copy up extended attributes from the original file to the new one.
+ *
+ * XXX - Permissions?  For now, copying up every xattr.
+ */
+
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
 /*
  * union_create_topmost_dir - Create a matching dir in the topmost file system
  */
@@ -473,6 +540,10 @@ struct dentry * union_create_topmost_dir(struct path *parent, struct qstr *name,
 		dput(dentry);
 		goto out;
 	}
+
+	res = union_copyup_xattr(lower->dentry, dentry);
+	if (res)
+		dput(dentry);
 out:
 	mnt_drop_write(parent->mnt);
 	return dentry;
@@ -788,6 +859,9 @@ static int __union_copyup_len(struct nameidata *nd, struct path *path,
 		goto out_dput;
 	}
 	/* XXX Copyup xattrs and any other dangly bits */
+	error = union_copyup_xattr(path->dentry, dentry);
+	if (error)
+		goto out_dput;
 out_newpath:
 	/* path_put() of original must happen before we copy in new */
 	path_put(path);
-- 
1.6.3.3

