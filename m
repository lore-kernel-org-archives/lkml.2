Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0FDLx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 07:53:57 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49412 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab0FDLx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 07:53:56 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
CC: John Johansen <john.johansen@canonical.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <E1OKVRc-0002Zk-Sc@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Fri, 04 Jun 2010 13:52:12 +0200)
Subject: [PATCH 2/2] vfs: show unreachable paths in getcwd and proc
References: <E1OKVRc-0002Zk-Sc@pomaz-ex.szeredi.hu>
Message-Id: <E1OKVT4-0002bA-KD@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 04 Jun 2010 13:53:42 +0200
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
 fs/dcache.c            |   82 +++++++++++++++++++++++++++++++++++++++++--------
 fs/proc/base.c         |    2 -
 include/linux/dcache.h |    1 
 3 files changed, 72 insertions(+), 13 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-05-27 12:22:21.000000000 +0200
+++ linux-2.6/fs/dcache.c	2010-05-27 12:22:24.000000000 +0200
@@ -1957,6 +1957,33 @@ int __d_path(const struct path *path, st
 	return error;
 }
 
+static void current_root(struct path *root)
+{
+	read_lock(&current->fs->lock);
+	*root = current->fs->root;
+	path_get(root);
+	read_unlock(&current->fs->lock);
+}
+
+static int __d_path_with_deleted(const struct path *path, struct path *root,
+				 char **buffer, int *buflen)
+{
+	int error;
+
+	prepend(buffer, buflen, "\0", 1);
+	if (d_unlinked(path->dentry)) {
+		error = prepend(buffer, buflen, " (deleted)", 10);
+		if (error)
+			return error;
+	}
+	return __d_path(path, root, buffer, buflen);
+}
+
+static int prepend_unreachable(char **buffer, int *buflen)
+{
+	return prepend(buffer, buflen, "(unreachable)", 13);
+}
+
 /**
  * d_path - return the path of a dentry
  * @path: path to report
@@ -1990,27 +2017,51 @@ char *d_path(const struct path *path, ch
 	if (path->dentry->d_op && path->dentry->d_op->d_dname)
 		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
 
-	read_lock(&current->fs->lock);
-	root = current->fs->root;
-	path_get(&root);
-	read_unlock(&current->fs->lock);
+	current_root(&root);
 	spin_lock(&dcache_lock);
 	ptr = buf + buflen;
-	prepend(&ptr, &buflen, "\0", 1);
-	if (d_unlinked(path->dentry)) {
-		error = prepend(&ptr, &buflen, " (deleted)", 10);
-		if (error)
-			goto out;
-	}
 	tmp = root;
-	error = __d_path(path, &tmp, &ptr, &buflen);
-out:
+	error = __d_path_with_deleted(path, &tmp, &ptr, &buflen);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return error ? ERR_PTR(error) : ptr;
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
+	char *ptr;
+	struct path root;
+	struct path tmp;
+	int error;
+
+	if (path->dentry->d_op && path->dentry->d_op->d_dname)
+		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
+
+	current_root(&root);
+	spin_lock(&dcache_lock);
+	ptr = buf + buflen;
+	tmp = root;
+	error = __d_path_with_deleted(path, &tmp, &ptr, &buflen);
+	if (!error) {
+		if (tmp.dentry != root.dentry || tmp.mnt != root.mnt)
+			error = prepend_unreachable(&ptr, &buflen);
+	}
+
+	spin_unlock(&dcache_lock);
+	path_put(&root);
+	return error ? ERR_PTR(error) : ptr;
+}
+
 /*
  * Helper function for dentry_operations.d_dname() members
  */
@@ -2118,6 +2169,13 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 		if (error)
 			goto out;
 
+		/* Unreachable from current root */
+		if (tmp.dentry != root.dentry || tmp.mnt != root.mnt) {
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
--- linux-2.6.orig/include/linux/dcache.h	2010-05-27 12:13:48.000000000 +0200
+++ linux-2.6/include/linux/dcache.h	2010-05-27 12:22:24.000000000 +0200
@@ -315,6 +315,7 @@ extern char *dynamic_dname(struct dentry
 
 extern int __d_path(const struct path *path, struct path *root, char **, int *);
 extern char *d_path(const struct path *, char *, int);
+extern char *d_path_with_unreachable(const struct path *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
 
 /* Allocation counts.. */
Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c	2010-05-27 11:53:55.000000000 +0200
+++ linux-2.6/fs/proc/base.c	2010-05-27 12:22:24.000000000 +0200
@@ -1438,7 +1438,7 @@ static int do_proc_readlink(struct path
 	if (!tmp)
 		return -ENOMEM;
 
-	pathname = d_path(path, tmp, PAGE_SIZE);
+	pathname = d_path_with_unreachable(path, tmp, PAGE_SIZE);
 	len = PTR_ERR(pathname);
 	if (IS_ERR(pathname))
 		goto out;
