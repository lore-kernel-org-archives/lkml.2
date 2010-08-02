Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0HBLUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 07:20:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42502 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab0HBLU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 07:20:29 -0400
Message-Id: <20100802112022.340131929@szeredi.hu>
References: <20100802111955.025275647@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Mon, 02 Aug 2010 13:20:00 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] vfs: add prepend_path() helper
Content-Disposition: inline; filename=vfs-add-prepend_path-helper.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Split off prepend_path() from __d_path().  This new helper takes an
end-of-buffer pointer and buffer-length pointer just like the other
prepend_* functions.  Move the " (deleted)" postfix out to __d_path().

This patch doesn't change any functionality but paves the way for the
following patches.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c |   94 +++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 58 insertions(+), 36 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-07-06 18:08:12.000000000 +0200
+++ linux-2.6/fs/dcache.c	2010-07-06 18:08:16.000000000 +0200
@@ -1903,48 +1903,30 @@ static int prepend_name(char **buffer, i
 }
 
 /**
- * __d_path - return the path of a dentry
+ * Prepend path string to a buffer
+ *
  * @path: the dentry/vfsmount to report
  * @root: root vfsmnt/dentry (may be modified by this function)
- * @buffer: buffer to return value in
- * @buflen: buffer length
+ * @buffer: pointer to the end of the buffer
+ * @buflen: pointer to buffer length
  *
- * Convert a dentry into an ASCII path name. If the entry has been deleted
- * the string " (deleted)" is appended. Note that this is ambiguous.
- *
- * Returns a pointer into the buffer or an error code if the
- * path was too long.
- *
- * "buflen" should be positive. Caller holds the dcache_lock.
+ * Caller holds the dcache_lock.
  *
  * If path is not reachable from the supplied root, then the value of
  * root is changed (without modifying refcounts).
  */
-char *__d_path(const struct path *path, struct path *root,
-	       char *buffer, int buflen)
+static int prepend_path(const struct path *path, struct path *root,
+			char **buffer, int *buflen)
 {
 	struct dentry *dentry = path->dentry;
 	struct vfsmount *vfsmnt = path->mnt;
-	char *end = buffer + buflen;
-	char *retval;
+	bool slash = false;
+	int error = 0;
 
 	spin_lock(&vfsmount_lock);
-	prepend(&end, &buflen, "\0", 1);
-	if (d_unlinked(dentry) &&
-		(prepend(&end, &buflen, " (deleted)", 10) != 0))
-			goto Elong;
-
-	if (buflen < 1)
-		goto Elong;
-	/* Get '/' right */
-	retval = end-1;
-	*retval = '/';
-
-	for (;;) {
+	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
 
-		if (dentry == root->dentry && vfsmnt == root->mnt)
-			break;
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
 			/* Global root? */
 			if (vfsmnt->mnt_parent == vfsmnt) {
@@ -1956,16 +1938,22 @@ char *__d_path(const struct path *path,
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
-		if ((prepend_name(&end, &buflen, &dentry->d_name) != 0) ||
-		    (prepend(&end, &buflen, "/", 1) != 0))
-			goto Elong;
-		retval = end;
+		error = prepend_name(buffer, buflen, &dentry->d_name);
+		if (!error)
+			error = prepend(buffer, buflen, "/", 1);
+		if (error)
+			break;
+
+		slash = true;
 		dentry = parent;
 	}
 
 out:
+	if (!error && !slash)
+		error = prepend(buffer, buflen, "/", 1);
+
 	spin_unlock(&vfsmount_lock);
-	return retval;
+	return error;
 
 global_root:
 	/*
@@ -1980,10 +1968,44 @@ global_root:
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
 	goto out;
+}
 
-Elong:
-	retval = ERR_PTR(-ENAMETOOLONG);
-	goto out;
+/**
+ * __d_path - return the path of a dentry
+ * @path: the dentry/vfsmount to report
+ * @root: root vfsmnt/dentry (may be modified by this function)
+ * @buffer: buffer to return value in
+ * @buflen: buffer length
+ *
+ * Convert a dentry into an ASCII path name. If the entry has been deleted
+ * the string " (deleted)" is appended. Note that this is ambiguous.
+ *
+ * Returns a pointer into the buffer or an error code if the
+ * path was too long.
+ *
+ * "buflen" should be positive. Caller holds the dcache_lock.
+ *
+ * If path is not reachable from the supplied root, then the value of
+ * root is changed (without modifying refcounts).
+ */
+char *__d_path(const struct path *path, struct path *root,
+	       char *buf, int buflen)
+{
+	char *res = buf + buflen;
+	int error;
+
+	prepend(&res, &buflen, "\0", 1);
+	if (d_unlinked(path->dentry)) {
+		error = prepend(&res, &buflen, " (deleted)", 10);
+		if (error)
+			return ERR_PTR(error);
+	}
+
+	error = prepend_path(path, root, &res, &buflen);
+	if (error)
+		return ERR_PTR(error);
+
+	return res;
 }
 
 /**

-- 
