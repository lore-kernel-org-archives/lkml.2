Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab0HJJon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:44:43 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47699 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab0HJJnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:43:41 -0400
Message-Id: <20100810094334.659303424@szeredi.hu>
References: <20100810094134.596235651@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 10 Aug 2010 11:41:41 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] vfs: show unreachable paths in getcwd and proc
Content-Disposition: inline; filename=vfs-unreachable-paths.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Prepend "(unreachable)" to path strings if the path is not reachable
from the current root.

Two places updated are
 - the return string from getcwd()
 - and symlinks under /proc/$PID.

Other uses of d_path() are left unchanged (we know that some old
software crashes if /proc/mounts is changed).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c            |   54 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/proc/base.c         |    2 -
 include/linux/dcache.h |    1 
 include/linux/path.h   |    5 ++++
 4 files changed, 57 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-07-06 18:08:19.000000000 +0200
+++ linux-2.6/fs/dcache.c	2010-07-06 18:08:22.000000000 +0200
@@ -2017,6 +2017,11 @@ static int path_with_deleted(const struc
 	return prepend_path(path, root, buf, buflen);
 }
 
+static int prepend_unreachable(char **buffer, int *buflen)
+{
+	return prepend(buffer, buflen, "(unreachable)", 13);
+}
+
 /**
  * d_path - return the path of a dentry
  * @path: path to report
@@ -2062,6 +2067,39 @@ char *d_path(const struct path *path, ch
 }
 EXPORT_SYMBOL(d_path);
 
+/**
+ * d_path_with_unreachable - return the path of a dentry
+ * @path: path to report
+ * @buf: buffer to return value in
+ * @buflen: buffer length
+ *
+ * The difference from d_path() is that this prepends "(unreachable)"
+ * to paths which are unreachable from the current process' root.
+ */
+char *d_path_with_unreachable(const struct path *path, char *buf, int buflen)
+{
+	char *res = buf + buflen;
+	struct path root;
+	struct path tmp;
+	int error;
+
+	if (path->dentry->d_op && path->dentry->d_op->d_dname)
+		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
+
+	get_fs_root(current->fs, &root);
+	spin_lock(&dcache_lock);
+	tmp = root;
+	error = path_with_deleted(path, &tmp, &res, &buflen);
+	if (!error && !path_equal(&tmp, &root))
+		error = prepend_unreachable(&res, &buflen);
+	spin_unlock(&dcache_lock);
+	path_put(&root);
+	if (error)
+		res =  ERR_PTR(error);
+
+	return res;
+}
+
 /*
  * Helper function for dentry_operations.d_dname() members
  */
@@ -2154,15 +2192,23 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
 		struct path tmp = root;
-		char * cwd;
+		char *cwd = page + PAGE_SIZE;
+		int buflen = PAGE_SIZE;
 
-		cwd = __d_path(&pwd, &tmp, page, PAGE_SIZE);
+		prepend(&cwd, &buflen, "\0", 1);
+		error = prepend_path(&pwd, &tmp, &cwd, &buflen);
 		spin_unlock(&dcache_lock);
 
-		error = PTR_ERR(cwd);
-		if (IS_ERR(cwd))
+		if (error)
 			goto out;
 
+		/* Unreachable from current root */
+		if (!path_equal(&tmp, &root)) {
+			error = prepend_unreachable(&cwd, &buflen);
+			if (error)
+				goto out;
+		}
+
 		error = -ERANGE;
 		len = PAGE_SIZE + page - cwd;
 		if (len <= size) {
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2010-07-06 17:59:04.000000000 +0200
+++ linux-2.6/include/linux/dcache.h	2010-07-06 18:08:22.000000000 +0200
@@ -315,6 +315,7 @@ extern char *dynamic_dname(struct dentry
 
 extern char *__d_path(const struct path *path, struct path *root, char *, int);
 extern char *d_path(const struct path *, char *, int);
+extern char *d_path_with_unreachable(const struct path *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
 
 /* Allocation counts.. */
Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c	2010-07-06 18:08:06.000000000 +0200
+++ linux-2.6/fs/proc/base.c	2010-07-06 18:08:22.000000000 +0200
@@ -1426,7 +1426,7 @@ static int do_proc_readlink(struct path
 	if (!tmp)
 		return -ENOMEM;
 
-	pathname = d_path(path, tmp, PAGE_SIZE);
+	pathname = d_path_with_unreachable(path, tmp, PAGE_SIZE);
 	len = PTR_ERR(pathname);
 	if (IS_ERR(pathname))
 		goto out;
Index: linux-2.6/include/linux/path.h
===================================================================
--- linux-2.6.orig/include/linux/path.h	2010-07-06 17:59:04.000000000 +0200
+++ linux-2.6/include/linux/path.h	2010-07-06 18:08:22.000000000 +0200
@@ -12,4 +12,9 @@ struct path {
 extern void path_get(struct path *);
 extern void path_put(struct path *);
 
+static inline int path_equal(const struct path *path1, const struct path *path2)
+{
+	return path1->mnt == path2->mnt && path1->dentry == path2->dentry;
+}
+
 #endif  /* _LINUX_PATH_H */

-- 
