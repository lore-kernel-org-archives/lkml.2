Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0FDLw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 07:52:57 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49406 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab0FDLwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 07:52:54 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
CC: John Johansen <john.johansen@canonical.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] vfs: sanitize __d_path()
Message-Id: <E1OKVRc-0002Zk-Sc@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 04 Jun 2010 13:52:12 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

__d_path() no longer appends " (deleted)" to unlinked paths.  This is
moved into d_path() which is the only caller that cares.

If a global root is reached then __d_path() no longer prepends the
name of the root dentry.  This was needed by pseudo filesystems, but
the d_dname() method has superseded it.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c                |   99 ++++++++++++++++++++-------------------------
 fs/seq_file.c              |   12 +++--
 include/linux/dcache.h     |    2 
 security/tomoyo/realpath.c |   17 ++++---
 4 files changed, 62 insertions(+), 68 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-05-27 12:13:46.000000000 +0200
+++ linux-2.6/fs/dcache.c	2010-05-27 12:22:21.000000000 +0200
@@ -1904,78 +1904,57 @@ static int prepend_name(char **buffer, i
  * __d_path - return the path of a dentry
  * @path: the dentry/vfsmount to report
  * @root: root vfsmnt/dentry (may be modified by this function)
- * @buffer: buffer to return value in
- * @buflen: buffer length
+ * @buffer: end of free buffer, will point to the result on return
+ * @buflen: pointer to buffer length
  *
- * Convert a dentry into an ASCII path name. If the entry has been deleted
- * the string " (deleted)" is appended. Note that this is ambiguous.
+ * Convert a vfsmount+dentry into an ASCII path name.
  *
- * Returns a pointer into the buffer or an error code if the
- * path was too long.
+ * Returns an error code if the path was too long.
  *
  * "buflen" should be positive. Caller holds the dcache_lock.
  *
  * If path is not reachable from the supplied root, then the value of
  * root is changed (without modifying refcounts).
  */
-char *__d_path(const struct path *path, struct path *root,
-	       char *buffer, int buflen)
+int __d_path(const struct path *path, struct path *root,
+	     char **buffer, int *buflen)
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
-		struct dentry * parent;
-
-		if (dentry == root->dentry && vfsmnt == root->mnt)
-			break;
+	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
 			/* Global root? */
 			if (vfsmnt->mnt_parent == vfsmnt) {
-				goto global_root;
+				root->mnt = vfsmnt;
+				root->dentry = dentry;
+				break;
 			}
 			dentry = vfsmnt->mnt_mountpoint;
 			vfsmnt = vfsmnt->mnt_parent;
-			continue;
+		} else {
+			struct dentry *parent = dentry->d_parent;
+
+			prefetch(parent);
+			error = prepend_name(buffer, buflen, &dentry->d_name);
+			if (!error)
+				error = prepend(buffer, buflen, "/", 1);
+			if (error)
+				break;
+
+			slash = true;
+			dentry = parent;
 		}
-		parent = dentry->d_parent;
-		prefetch(parent);
-		if ((prepend_name(&end, &buflen, &dentry->d_name) != 0) ||
-		    (prepend(&end, &buflen, "/", 1) != 0))
-			goto Elong;
-		retval = end;
-		dentry = parent;
 	}
-
-out:
 	spin_unlock(&vfsmount_lock);
-	return retval;
 
-global_root:
-	retval += 1;	/* hit the slash */
-	if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
-		goto Elong;
-	root->mnt = vfsmnt;
-	root->dentry = dentry;
-	goto out;
+	if (!error && !slash)
+		error = prepend(buffer, buflen, "/", 1);
 
-Elong:
-	retval = ERR_PTR(-ENAMETOOLONG);
-	goto out;
+	return error;
 }
 
 /**
@@ -1996,9 +1975,10 @@ Elong:
  */
 char *d_path(const struct path *path, char *buf, int buflen)
 {
-	char *res;
+	char *ptr;
 	struct path root;
 	struct path tmp;
+	int error;
 
 	/*
 	 * We have various synthetic filesystems that never get mounted.  On
@@ -2015,11 +1995,19 @@ char *d_path(const struct path *path, ch
 	path_get(&root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
+	ptr = buf + buflen;
+	prepend(&ptr, &buflen, "\0", 1);
+	if (d_unlinked(path->dentry)) {
+		error = prepend(&ptr, &buflen, " (deleted)", 10);
+		if (error)
+			goto out;
+	}
 	tmp = root;
-	res = __d_path(path, &tmp, buf, buflen);
+	error = __d_path(path, &tmp, &ptr, &buflen);
+out:
 	spin_unlock(&dcache_lock);
 	path_put(&root);
-	return res;
+	return error ? ERR_PTR(error) : ptr;
 }
 EXPORT_SYMBOL(d_path);
 
@@ -2120,13 +2108,14 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
 		struct path tmp = root;
-		char * cwd;
+		int buflen = PAGE_SIZE;
+		char *cwd = page + buflen;
 
-		cwd = __d_path(&pwd, &tmp, page, PAGE_SIZE);
+		prepend(&cwd, &buflen, "\0", 1);
+		error = __d_path(&pwd, &tmp, &cwd, &buflen);
 		spin_unlock(&dcache_lock);
 
-		error = PTR_ERR(cwd);
-		if (IS_ERR(cwd))
+		if (error)
 			goto out;
 
 		error = -ERANGE;
Index: linux-2.6/fs/seq_file.c
===================================================================
--- linux-2.6.orig/fs/seq_file.c	2010-05-27 12:13:46.000000000 +0200
+++ linux-2.6/fs/seq_file.c	2010-05-27 12:13:48.000000000 +0200
@@ -448,7 +448,8 @@ int seq_path(struct seq_file *m, struct
 EXPORT_SYMBOL(seq_path);
 
 /*
- * Same as seq_path, but relative to supplied root.
+ * Same as seq_path, but relative to supplied root and doesn't append
+ * " (deleted)" for unlinked dentries.
  *
  * root may be changed, see __d_path().
  */
@@ -460,13 +461,14 @@ int seq_path_root(struct seq_file *m, st
 	int res = -ENAMETOOLONG;
 
 	if (size) {
-		char *p;
+		int buflen = size - 1;
+		char *p = buf + buflen;
 
+		*p = '\0';
 		spin_lock(&dcache_lock);
-		p = __d_path(path, root, buf, size);
+		res = __d_path(path, root, &p, &buflen);
 		spin_unlock(&dcache_lock);
-		res = PTR_ERR(p);
-		if (!IS_ERR(p)) {
+		if (!res) {
 			char *end = mangle_path(buf, p, esc);
 			if (end)
 				res = end - buf;
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2010-05-27 12:13:46.000000000 +0200
+++ linux-2.6/include/linux/dcache.h	2010-05-27 12:13:48.000000000 +0200
@@ -313,7 +313,7 @@ extern int d_validate(struct dentry *, s
  */
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
-extern char *__d_path(const struct path *path, struct path *root, char *, int);
+extern int __d_path(const struct path *path, struct path *root, char **, int *);
 extern char *d_path(const struct path *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
 
Index: linux-2.6/security/tomoyo/realpath.c
===================================================================
--- linux-2.6.orig/security/tomoyo/realpath.c	2010-05-27 12:13:46.000000000 +0200
+++ linux-2.6/security/tomoyo/realpath.c	2010-05-27 12:13:48.000000000 +0200
@@ -77,7 +77,7 @@ int tomoyo_encode(char *buffer, int bufl
 int tomoyo_realpath_from_path2(struct path *path, char *newname,
 			       int newname_len)
 {
-	int error = -ENOMEM;
+	int error = 0;
 	struct dentry *dentry = path->dentry;
 	char *sp;
 
@@ -88,26 +88,29 @@ int tomoyo_realpath_from_path2(struct pa
 		static const int offset = 1536;
 		sp = dentry->d_op->d_dname(dentry, newname + offset,
 					   newname_len - offset);
+		if (IS_ERR(sp))
+			error = PTR_ERR(sp);
 	} else {
 		struct path ns_root = {.mnt = NULL, .dentry = NULL};
+		int buflen = newname_len - 1;
 
+		sp = newname + buflen;
+		*sp = '\0';
 		spin_lock(&dcache_lock);
 		/* go to whatever namespace root we are under */
-		sp = __d_path(path, &ns_root, newname, newname_len);
+		error = __d_path(path, &ns_root, &sp, &buflen);
 		spin_unlock(&dcache_lock);
 		/* Prepend "/proc" prefix if using internal proc vfs mount. */
-		if (!IS_ERR(sp) && (path->mnt->mnt_flags & MNT_INTERNAL) &&
+		if (!error && (path->mnt->mnt_flags & MNT_INTERNAL) &&
 		    (path->mnt->mnt_sb->s_magic == PROC_SUPER_MAGIC)) {
 			sp -= 5;
 			if (sp >= newname)
 				memcpy(sp, "/proc", 5);
 			else
-				sp = ERR_PTR(-ENOMEM);
+				error = -ENOMEM;
 		}
 	}
-	if (IS_ERR(sp))
-		error = PTR_ERR(sp);
-	else
+	if (!error)
 		error = tomoyo_encode(newname, sp - newname, sp);
 	/* Append trailing '/' if dentry is a directory. */
 	if (!error && dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode)
