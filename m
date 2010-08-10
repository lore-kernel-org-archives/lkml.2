Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab0HJJnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:43:50 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47695 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab0HJJnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:43:39 -0400
Message-Id: <20100810094332.395632981@szeredi.hu>
References: <20100810094134.596235651@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 10 Aug 2010 11:41:40 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] vfs: only add " (deleted)" where necessary
Content-Disposition: inline; filename=vfs-d_path-move-deleted-into-callers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

__d_path() has 4 callers:

  d_path()
  sys_getcwd()
  seq_path_root()
  tomoyo_realpath_from_path2()

Of these the only one which needs the " (deleted)" ending is d_path().

sys_getcwd() checks for existence before calling __d_path().

seq_path_root() is used to show the mountpoint path in
/proc/PID/mountinfo, which is always a positive.

And tomoyo doesn't want the deleted ending.

Create a helper "path_with_deleted()" as subsequent patches will need
this in multiple places.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-07-06 18:08:16.000000000 +0200
+++ linux-2.6/fs/dcache.c	2010-07-06 18:08:19.000000000 +0200
@@ -1977,8 +1977,7 @@ global_root:
  * @buffer: buffer to return value in
  * @buflen: buffer length
  *
- * Convert a dentry into an ASCII path name. If the entry has been deleted
- * the string " (deleted)" is appended. Note that this is ambiguous.
+ * Convert a dentry into an ASCII path name.
  *
  * Returns a pointer into the buffer or an error code if the
  * path was too long.
@@ -1995,12 +1994,6 @@ char *__d_path(const struct path *path,
 	int error;
 
 	prepend(&res, &buflen, "\0", 1);
-	if (d_unlinked(path->dentry)) {
-		error = prepend(&res, &buflen, " (deleted)", 10);
-		if (error)
-			return ERR_PTR(error);
-	}
-
 	error = prepend_path(path, root, &res, &buflen);
 	if (error)
 		return ERR_PTR(error);
@@ -2008,6 +2001,22 @@ char *__d_path(const struct path *path,
 	return res;
 }
 
+/*
+ * same as __d_path but appends "(deleted)" for unlinked files.
+ */
+static int path_with_deleted(const struct path *path, struct path *root,
+				 char **buf, int *buflen)
+{
+	prepend(buf, buflen, "\0", 1);
+	if (d_unlinked(path->dentry)) {
+		int error = prepend(buf, buflen, " (deleted)", 10);
+		if (error)
+			return error;
+	}
+
+	return prepend_path(path, root, buf, buflen);
+}
+
 /**
  * d_path - return the path of a dentry
  * @path: path to report
@@ -2026,9 +2035,10 @@ char *__d_path(const struct path *path,
  */
 char *d_path(const struct path *path, char *buf, int buflen)
 {
-	char *res;
+	char *res = buf + buflen;
 	struct path root;
 	struct path tmp;
+	int error;
 
 	/*
 	 * We have various synthetic filesystems that never get mounted.  On
@@ -2043,7 +2053,9 @@ char *d_path(const struct path *path, ch
 	get_fs_root(current->fs, &root);
 	spin_lock(&dcache_lock);
 	tmp = root;
-	res = __d_path(path, &tmp, buf, buflen);
+	error = path_with_deleted(path, &tmp, &res, &buflen);
+	if (error)
+		res = ERR_PTR(error);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;

-- 
