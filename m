Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab1LFD6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 22:58:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52782 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870Ab1LFD6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 22:58:40 -0500
Date: Tue, 6 Dec 2011 03:58:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] __d_path() API change (was Re: [PATCH] Remove use of
 mnt_ns->root and fix a couple of bugs in d_namespace_path)
Message-ID: <20111206035838.GD2203@ZenIV.linux.org.uk>
References: <1323034020-28780-1-git-send-email-john.johansen@canonical.com>
 <20111204221020.GB2203@ZenIV.linux.org.uk>
 <20111205032711.GC2203@ZenIV.linux.org.uk>
 <4EDD7F46.1050907@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDD7F46.1050907@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 06:34:46PM -0800, John Johansen wrote:
> Thanks Al, this looks good, and I have been running this one a test box doing
> regression testing successfully for hours with one small change in the apparmor
> portion of the code which I have included below.
> 
> With the apparmor change you can add
> 
> Reviewed-by: John Johansen <john.johansen@canonical.com>

OK, change folded, description written, commit pushed to #for-linus.
I have *NOT* sent pull request yet; folks, if you have objections,
it's time to yell.  The commit in question is:

commit 8096378b2d15ccd9f185fd16c1255f8f2619e0d6
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Mon Dec 5 08:43:34 2011 -0500

    fix apparmor dereferencing potentially freed dentry, sanitize __d_path() API
    
    __d_path() API is asking for trouble and in case of apparmor d_namespace_path()
    getting just that.  The root cause is that when __d_path() misses the root
    it had been told to look for, it stores the location of the most remote ancestor
    in *root.  Without grabbing references.  Sure, at the moment of call it had
    been pinned down by what we have in *path.  And if we raced with umount -l, we
    could have very well stopped at vfsmount/dentry that got freed as soon as
    prepend_path() dropped vfsmount_lock.
    
    It is safe to compare these pointers with pre-existing (and known to be still
    alive) vfsmount and dentry, as long as all we are asking is "is it the same
    address?".  Dereferencing is not safe and apparmor ended up stepping into
    that.  d_namespace_path() really wants to examine the place where we stopped,
    even if it's not connected to our namespace.  As the result, it looked
    at ->d_sb->s_magic of a dentry that might've been already freed by that point.
    All other callers had been careful enough to avoid that, but it's really
    a bad interface - it invites that kind of trouble.
    
    On the other hand, we do *not* want show_mountinfo() to have to do mntput()/dput() -
    doing that (or any IO, for that matter) under namespace_sem is a bad idea for
    reasons of robustness, if nothing else.
    
    The fix is fairly straightforward, even though it's bigger than I'd like:
    
            * Give prepend_path() an extra argument for reporting which
    fatherless thing has it reached if it has missed the root - struct
    path *bastard.  struct path *root becomes const on that *and* what
    we put into *bastard is properly grabbed.  We do that only if that
    pointer is not NULL, of course.  In any case we return 1 if we go
    out through global_root:
    
            * modify the callers accordingly; everything except __d_path()
    will simply pass NULL as that extra argument and instead of checking
    if root has been changed, just check if return value was positive.
    
            * __d_path() gets the similar extra argument itself; if it's non-NULL
    and we miss the root, the caller can expect to get (referenced) point where
    the walk has stopped stored there.  _Maybe_ it ought to fill it with
    NULL/NULL otherwise; I've just done that in the only such caller before
    calling __d_path().  If it is NULL *and* root has not been NULL/NULL (i.e.
    we asked for subtree explicitly and have nowhere to put the stopping point),
    we return NULL instead of pointer to relative pathname.
    
            * seq_path_root() does _NOT_ return -ENAMETOOLONG (it's stupid anyway -
    the normal seq_file logics will take care of growing the buffer and redoing
    the call of ->show() just fine).  However, if it gets path not reachable
    from root, it returns SEQ_SKIP.  The only caller adjusted (i.e. stopped
    ignoring the return value as it used to do).
    
            * unlike seq_path_root(), the caller in tomoyo passes NULL/NULL in
    *root (it wants absolute path).  It still calls with bastard == NULL, so
    no references are grabbed.
    
            * apparmor d_namespace_path() calls __d_path() passing it a pointer
    to local struct path to fill.  It's been earlier initialized to NULL/NULL
    (see above in part about __d_path()), so the check for "has it been outside
    of chroot jail" is simply bastard.mnt != NULL after the call.  Moreover,
    in this case it's safe to access vfsmount and dentry; we can do the checks
    just fine, they won't be freed under us.  One more thing - I've exported
    uninlined variant of check_mnt() (called our_mnt(), for obvious reasons)
    and used it here.
    
    [AV: folded fix for braino in apparmor part spotted by jj; with that done
    the patch survives his testing]
    
    Reviewed-by: John Johansen <john.johansen@canonical.com>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Cc: stable@vger.kernel.org

diff --git a/fs/dcache.c b/fs/dcache.c
index 10ba92d..d9854ee 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2439,7 +2439,8 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
 /**
  * prepend_path - Prepend path string to a buffer
  * @path: the dentry/vfsmount to report
- * @root: root vfsmnt/dentry (may be modified by this function)
+ * @root: root vfsmnt/dentry
+ * @bastard: the fatherless thing we'd walked up to if we missed root
  * @buffer: pointer to the end of the buffer
  * @buflen: pointer to buffer length
  *
@@ -2448,7 +2449,9 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
  * If path is not reachable from the supplied root, then the value of
  * root is changed (without modifying refcounts).
  */
-static int prepend_path(const struct path *path, struct path *root,
+static int prepend_path(const struct path *path,
+			const struct path *root,
+			struct path *bastard,
 			char **buffer, int *buflen)
 {
 	struct dentry *dentry = path->dentry;
@@ -2483,10 +2486,10 @@ static int prepend_path(const struct path *path, struct path *root,
 		dentry = parent;
 	}
 
-out:
 	if (!error && !slash)
 		error = prepend(buffer, buflen, "/", 1);
 
+out:
 	br_read_unlock(vfsmount_lock);
 	return error;
 
@@ -2500,15 +2503,22 @@ global_root:
 		WARN(1, "Root dentry has weird name <%.*s>\n",
 		     (int) dentry->d_name.len, dentry->d_name.name);
 	}
-	root->mnt = vfsmnt;
-	root->dentry = dentry;
+	if (bastard) {
+		bastard->mnt = mntget(vfsmnt);
+		bastard->dentry = dget(dentry);
+	}
+	if (!slash)
+		error = prepend(buffer, buflen, "/", 1);
+	if (!error)
+		error = 1;
 	goto out;
 }
 
 /**
  * __d_path - return the path of a dentry
  * @path: the dentry/vfsmount to report
- * @root: root vfsmnt/dentry (may be modified by this function)
+ * @root: root vfsmnt/dentry
+ * @bastard: the fatherless thing we'd walked to if we missed root
  * @buf: buffer to return value in
  * @buflen: buffer length
  *
@@ -2519,10 +2529,17 @@ global_root:
  *
  * "buflen" should be positive.
  *
- * If path is not reachable from the supplied root, then the value of
- * root is changed (without modifying refcounts).
- */
-char *__d_path(const struct path *path, struct path *root,
+ * If the path is not reachable from the supplied root, results depend on
+ * whether "bastard" is %NULL or not.  If it's non-%NULL, the most remote
+ * ancestor we'd been able to find will be stored in *bastard, references
+ * properly grabbed.  Otherwise, if *root had not been {%NULL, %NULL} (i.e.
+ * we'd been asked for a path relative to root of some specific subtree),
+ * we return %NULL since the pathname we'd formed is _not_ what the caller
+ * has asked for.
+ */
+char *__d_path(const struct path *path,
+	       const struct path *root,
+	       struct path *bastard,
 	       char *buf, int buflen)
 {
 	char *res = buf + buflen;
@@ -2530,19 +2547,26 @@ char *__d_path(const struct path *path, struct path *root,
 
 	prepend(&res, &buflen, "\0", 1);
 	write_seqlock(&rename_lock);
-	error = prepend_path(path, root, &res, &buflen);
+	error = prepend_path(path, root, bastard, &res, &buflen);
 	write_sequnlock(&rename_lock);
 
-	if (error)
+	if (error < 0)
 		return ERR_PTR(error);
+	/*
+	 * we'd been asked to stop at specific point, missed it and
+	 * had not been asked to tell where we'd ended up.
+	 */
+	if (error > 0 && !bastard && root->mnt)
+		return NULL;
 	return res;
 }
 
 /*
  * same as __d_path but appends "(deleted)" for unlinked files.
  */
-static int path_with_deleted(const struct path *path, struct path *root,
-				 char **buf, int *buflen)
+static int path_with_deleted(const struct path *path,
+			     const struct path *root,
+			     char **buf, int *buflen)
 {
 	prepend(buf, buflen, "\0", 1);
 	if (d_unlinked(path->dentry)) {
@@ -2551,7 +2575,7 @@ static int path_with_deleted(const struct path *path, struct path *root,
 			return error;
 	}
 
-	return prepend_path(path, root, buf, buflen);
+	return prepend_path(path, root, NULL, buf, buflen);
 }
 
 static int prepend_unreachable(char **buffer, int *buflen)
@@ -2579,7 +2603,6 @@ char *d_path(const struct path *path, char *buf, int buflen)
 {
 	char *res = buf + buflen;
 	struct path root;
-	struct path tmp;
 	int error;
 
 	/*
@@ -2594,9 +2617,8 @@ char *d_path(const struct path *path, char *buf, int buflen)
 
 	get_fs_root(current->fs, &root);
 	write_seqlock(&rename_lock);
-	tmp = root;
-	error = path_with_deleted(path, &tmp, &res, &buflen);
-	if (error)
+	error = path_with_deleted(path, &root, &res, &buflen);
+	if (error < 0)
 		res = ERR_PTR(error);
 	write_sequnlock(&rename_lock);
 	path_put(&root);
@@ -2617,7 +2639,6 @@ char *d_path_with_unreachable(const struct path *path, char *buf, int buflen)
 {
 	char *res = buf + buflen;
 	struct path root;
-	struct path tmp;
 	int error;
 
 	if (path->dentry->d_op && path->dentry->d_op->d_dname)
@@ -2625,9 +2646,8 @@ char *d_path_with_unreachable(const struct path *path, char *buf, int buflen)
 
 	get_fs_root(current->fs, &root);
 	write_seqlock(&rename_lock);
-	tmp = root;
-	error = path_with_deleted(path, &tmp, &res, &buflen);
-	if (!error && !path_equal(&tmp, &root))
+	error = path_with_deleted(path, &root, &res, &buflen);
+	if (error > 0)
 		error = prepend_unreachable(&res, &buflen);
 	write_sequnlock(&rename_lock);
 	path_put(&root);
@@ -2758,19 +2778,18 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 	write_seqlock(&rename_lock);
 	if (!d_unlinked(pwd.dentry)) {
 		unsigned long len;
-		struct path tmp = root;
 		char *cwd = page + PAGE_SIZE;
 		int buflen = PAGE_SIZE;
 
 		prepend(&cwd, &buflen, "\0", 1);
-		error = prepend_path(&pwd, &tmp, &cwd, &buflen);
+		error = prepend_path(&pwd, &root, NULL, &cwd, &buflen);
 		write_sequnlock(&rename_lock);
 
-		if (error)
+		if (error < 0)
 			goto out;
 
 		/* Unreachable from current root */
-		if (!path_equal(&tmp, &root)) {
+		if (error > 0) {
 			error = prepend_unreachable(&cwd, &buflen);
 			if (error)
 				goto out;
diff --git a/fs/namespace.c b/fs/namespace.c
index 6d3a196..2c784ea 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1048,15 +1048,12 @@ static int show_mountinfo(struct seq_file *m, void *v)
 	if (err)
 		goto out;
 	seq_putc(m, ' ');
-	seq_path_root(m, &mnt_path, &root, " \t\n\\");
-	if (root.mnt != p->root.mnt || root.dentry != p->root.dentry) {
-		/*
-		 * Mountpoint is outside root, discard that one.  Ugly,
-		 * but less so than trying to do that in iterator in a
-		 * race-free way (due to renames).
-		 */
-		return SEQ_SKIP;
-	}
+
+	/* mountpoints outside of chroot jail will give SEQ_SKIP on this */
+	err = seq_path_root(m, &mnt_path, &root, " \t\n\\");
+	if (err)
+		goto out;
+
 	seq_puts(m, mnt->mnt_flags & MNT_READONLY ? " ro" : " rw");
 	show_mnt_opts(m, mnt);
 
@@ -2776,3 +2773,9 @@ void kern_unmount(struct vfsmount *mnt)
 	}
 }
 EXPORT_SYMBOL(kern_unmount);
+
+bool our_mnt(struct vfsmount *mnt)
+{
+	return check_mnt(mnt);
+}
+EXPORT_SYMBOL(our_mnt);
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 05d6b0e..688642d 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -449,8 +449,6 @@ EXPORT_SYMBOL(seq_path);
 
 /*
  * Same as seq_path, but relative to supplied root.
- *
- * root may be changed, see __d_path().
  */
 int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
 		  char *esc)
@@ -462,7 +460,9 @@ int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
 	if (size) {
 		char *p;
 
-		p = __d_path(path, root, buf, size);
+		p = __d_path(path, root, NULL, buf, size);
+		if (!p)
+			return SEQ_SKIP;
 		res = PTR_ERR(p);
 		if (!IS_ERR(p)) {
 			char *end = mangle_path(buf, p, esc);
@@ -474,7 +474,7 @@ int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
 	}
 	seq_commit(m, res);
 
-	return res < 0 ? res : 0;
+	return res < 0 && res != -ENAMETOOLONG ? res : 0;
 }
 
 /*
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 4df9261..2b6cf1e 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -339,7 +339,8 @@ extern int d_validate(struct dentry *, struct dentry *);
  */
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
-extern char *__d_path(const struct path *path, struct path *root, char *, int);
+extern char *__d_path(const struct path *, const struct path *,
+			struct path *, char *, int);
 extern char *d_path(const struct path *, char *, int);
 extern char *d_path_with_unreachable(const struct path *, char *, int);
 extern char *dentry_path_raw(struct dentry *, char *, int);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e313022..019dc55 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1942,6 +1942,7 @@ extern int fd_statfs(int, struct kstatfs *);
 extern int statfs_by_dentry(struct dentry *, struct kstatfs *);
 extern int freeze_super(struct super_block *super);
 extern int thaw_super(struct super_block *super);
+extern bool our_mnt(struct vfsmount *mnt);
 
 extern int current_umask(void);
 
diff --git a/security/apparmor/path.c b/security/apparmor/path.c
index 36cc0cc..350cb50 100644
--- a/security/apparmor/path.c
+++ b/security/apparmor/path.c
@@ -57,23 +57,16 @@ static int prepend(char **buffer, int buflen, const char *str, int namelen)
 static int d_namespace_path(struct path *path, char *buf, int buflen,
 			    char **name, int flags)
 {
-	struct path root, tmp;
+	struct path root = {};
+	struct path bastard = {};
 	char *res;
-	int connected, error = 0;
+	int error = 0;
 
-	/* Get the root we want to resolve too, released below */
-	if (flags & PATH_CHROOT_REL) {
-		/* resolve paths relative to chroot */
+	/* resolve paths relative to chroot?*/
+	if (flags & PATH_CHROOT_REL)
 		get_fs_root(current->fs, &root);
-	} else {
-		/* resolve paths relative to namespace */
-		root.mnt = current->nsproxy->mnt_ns->root;
-		root.dentry = root.mnt->mnt_root;
-		path_get(&root);
-	}
 
-	tmp = root;
-	res = __d_path(path, &tmp, buf, buflen);
+	res = __d_path(path, &root, &bastard, buf, buflen);
 
 	*name = res;
 	/* handle error conditions - and still allow a partial path to
@@ -97,10 +90,7 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
 			goto out;
 	}
 
-	/* Determine if the path is connected to the expected root */
-	connected = tmp.dentry == root.dentry && tmp.mnt == root.mnt;
-
-	/* If the path is not connected,
+	/* If the path is not connected to the expected root,
 	 * check if it is a sysctl and handle specially else remove any
 	 * leading / that __d_path may have returned.
 	 * Unless
@@ -111,9 +101,9 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
 	 *     of chroot) and specifically directed to connect paths to
 	 *     namespace root.
 	 */
-	if (!connected) {
+	if (bastard.mnt && (root.mnt || !our_mnt(bastard.mnt)) {
 		/* is the disconnect path a sysctl? */
-		if (tmp.dentry->d_sb->s_magic == PROC_SUPER_MAGIC &&
+		if (bastard.dentry->d_sb->s_magic == PROC_SUPER_MAGIC &&
 		    strncmp(*name, "/sys/", 5) == 0) {
 			/* TODO: convert over to using a per namespace
 			 * control instead of hard coded /proc
@@ -121,8 +111,7 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
 			error = prepend(name, *name - buf, "/proc", 5);
 		} else if (!(flags & PATH_CONNECT_PATH) &&
 			   !(((flags & CHROOT_NSCONNECT) == CHROOT_NSCONNECT) &&
-			     (tmp.mnt == current->nsproxy->mnt_ns->root &&
-			      tmp.dentry == tmp.mnt->mnt_root))) {
+			     our_mnt(bastard.mnt))) {
 			/* disconnected path, don't return pathname starting
 			 * with '/'
 			 */
@@ -133,7 +122,10 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
 	}
 
 out:
-	path_put(&root);
+	if (bastard.mnt)
+		path_put(&bastard);
+	if (flags & PATH_CHROOT_REL)
+		path_put(&root);
 
 	return error;
 }
diff --git a/security/tomoyo/realpath.c b/security/tomoyo/realpath.c
index 738bbdf..99ee841 100644
--- a/security/tomoyo/realpath.c
+++ b/security/tomoyo/realpath.c
@@ -103,7 +103,7 @@ static char *tomoyo_get_absolute_path(struct path *path, char * const buffer,
 	if (buflen >= 256) {
 		struct path ns_root = { };
 		/* go to whatever namespace root we are under */
-		pos = __d_path(path, &ns_root, buffer, buflen - 1);
+		pos = __d_path(path, &ns_root, NULL, buffer, buflen - 1);
 		if (!IS_ERR(pos) && *pos == '/' && pos[1]) {
 			struct inode *inode = path->dentry->d_inode;
 			if (inode && S_ISDIR(inode->i_mode)) {
