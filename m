Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab2JBA26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:28:58 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:37625 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2JBARO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:14 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 06/49] audit: set the name_len in audit_inode for parent lookups
Date: Mon,  1 Oct 2012 20:16:15 -0400
Message-Id: <1349137018-21948-7-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, this gets set mostly by happenstance when we call into
audit_inode_child. While that might be a little more efficient, it seems
wrong. If the syscall ends up failing before audit_inode_child ever gets
called, then you'll have an audit_names record that shows the full path
but has the parent inode info attached.

Fix this by passing in a parent flag when we call audit_inode that gets
set to the value of LOOKUP_PARENT. We can then fix up the pathname for
the audit entry correctly from the get-go.

While we're at it, clean up the no-op macro for audit_inode in the
!CONFIG_AUDITSYSCALL case.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c            | 14 +++++++-------
 fs/open.c             |  4 ++--
 fs/xattr.c            |  8 ++++----
 include/linux/audit.h | 13 ++++++++-----
 ipc/mqueue.c          |  8 ++++----
 kernel/audit.h        |  1 +
 kernel/auditfilter.c  | 30 ++++++++++++++++++++++++++++++
 kernel/auditsc.c      | 41 +++++++++++++++++++++++++++++------------
 8 files changed, 85 insertions(+), 34 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d431111..6c9d86d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1977,7 +1977,7 @@ static int do_path_lookup(int dfd, const char *name,
 		retval = path_lookupat(dfd, name, flags | LOOKUP_REVAL, nd);
 
 	if (likely(!retval))
-		audit_inode(name, nd->path.dentry);
+		audit_inode(name, nd->path.dentry, flags & LOOKUP_PARENT);
 	return retval;
 }
 
@@ -2652,7 +2652,7 @@ static int do_last(struct nameidata *nd, struct path *path,
 		error = complete_walk(nd);
 		if (error)
 			return error;
-		audit_inode(pathname, nd->path.dentry);
+		audit_inode(pathname, nd->path.dentry, 0);
 		if (open_flag & O_CREAT) {
 			error = -EISDIR;
 			goto out;
@@ -2662,7 +2662,7 @@ static int do_last(struct nameidata *nd, struct path *path,
 		error = complete_walk(nd);
 		if (error)
 			return error;
-		audit_inode(pathname, dir);
+		audit_inode(pathname, dir, 0);
 		goto finish_open;
 	}
 
@@ -2691,7 +2691,7 @@ static int do_last(struct nameidata *nd, struct path *path,
 		if (error)
 			return error;
 
-		audit_inode(pathname, dir);
+		audit_inode(pathname, dir, 0);
 		error = -EISDIR;
 		/* trailing slashes? */
 		if (nd->last.name[nd->last.len])
@@ -2721,7 +2721,7 @@ retry_lookup:
 		    !S_ISREG(file->f_path.dentry->d_inode->i_mode))
 			will_truncate = false;
 
-		audit_inode(pathname, file->f_path.dentry);
+		audit_inode(pathname, file->f_path.dentry, 0);
 		goto opened;
 	}
 
@@ -2738,7 +2738,7 @@ retry_lookup:
 	 * create/update audit record if it already exists.
 	 */
 	if (path->dentry->d_inode)
-		audit_inode(pathname, path->dentry);
+		audit_inode(pathname, path->dentry, 0);
 
 	/*
 	 * If atomic_open() acquired write access it is dropped now due to
@@ -2803,7 +2803,7 @@ finish_lookup:
 	error = -ENOTDIR;
 	if ((nd->flags & LOOKUP_DIRECTORY) && !nd->inode->i_op->lookup)
 		goto out;
-	audit_inode(pathname, nd->path.dentry);
+	audit_inode(pathname, nd->path.dentry, 0);
 finish_open:
 	if (!S_ISREG(nd->inode->i_mode))
 		will_truncate = false;
diff --git a/fs/open.c b/fs/open.c
index e1f2cdb..ec06921 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -481,7 +481,7 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
 
 	file = fget(fd);
 	if (file) {
-		audit_inode(NULL, file->f_path.dentry);
+		audit_inode(NULL, file->f_path.dentry, 0);
 		err = chmod_common(&file->f_path, mode);
 		fput(file);
 	}
@@ -594,7 +594,7 @@ SYSCALL_DEFINE3(fchown, unsigned int, fd, uid_t, user, gid_t, group)
 	if (error)
 		goto out_fput;
 	dentry = file->f_path.dentry;
-	audit_inode(NULL, dentry);
+	audit_inode(NULL, dentry, 0);
 	error = chown_common(&file->f_path, user, group);
 	mnt_drop_write_file(file);
 out_fput:
diff --git a/fs/xattr.c b/fs/xattr.c
index 4d45b71..588455b 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -408,7 +408,7 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 	if (!f)
 		return error;
 	dentry = f->f_path.dentry;
-	audit_inode(NULL, dentry);
+	audit_inode(NULL, dentry, 0);
 	error = mnt_want_write_file(f);
 	if (!error) {
 		error = setxattr(dentry, name, value, size, flags);
@@ -502,7 +502,7 @@ SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
 	f = fget_light(fd, &fput_needed);
 	if (!f)
 		return error;
-	audit_inode(NULL, f->f_path.dentry);
+	audit_inode(NULL, f->f_path.dentry, 0);
 	error = getxattr(f->f_path.dentry, name, value, size);
 	fput_light(f, fput_needed);
 	return error;
@@ -583,7 +583,7 @@ SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
 	f = fget_light(fd, &fput_needed);
 	if (!f)
 		return error;
-	audit_inode(NULL, f->f_path.dentry);
+	audit_inode(NULL, f->f_path.dentry, 0);
 	error = listxattr(f->f_path.dentry, list, size);
 	fput_light(f, fput_needed);
 	return error;
@@ -654,7 +654,7 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 	if (!f)
 		return error;
 	dentry = f->f_path.dentry;
-	audit_inode(NULL, dentry);
+	audit_inode(NULL, dentry, 0);
 	error = mnt_want_write_file(f);
 	if (!error) {
 		error = removexattr(dentry, name);
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 48c49eb..155524b 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -454,6 +454,7 @@ extern int audit_classify_arch(int arch);
 /* audit_names->type values */
 #define	AUDIT_TYPE_UNKNOWN	0	/* we don't know yet */
 #define AUDIT_TYPE_NORMAL	1	/* a "normal" audit record */
+#define AUDIT_TYPE_PARENT	2	/* a parent audit record */
 
 #ifdef CONFIG_AUDITSYSCALL
 /* These are defined in auditsc.c */
@@ -466,7 +467,8 @@ extern void __audit_syscall_entry(int arch,
 extern void __audit_syscall_exit(int ret_success, long ret_value);
 extern void __audit_getname(const char *name);
 extern void audit_putname(const char *name);
-extern void __audit_inode(const char *name, const struct dentry *dentry);
+extern void __audit_inode(const char *name, const struct dentry *dentry,
+				unsigned int parent);
 extern void __audit_inode_child(const struct inode *parent,
 				const struct dentry *dentry);
 extern void __audit_seccomp(unsigned long syscall, long signr, int code);
@@ -503,9 +505,10 @@ static inline void audit_getname(const char *name)
 	if (unlikely(!audit_dummy_context()))
 		__audit_getname(name);
 }
-static inline void audit_inode(const char *name, const struct dentry *dentry) {
+static inline void audit_inode(const char *name, const struct dentry *dentry,
+				unsigned int parent) {
 	if (unlikely(!audit_dummy_context()))
-		__audit_inode(name, dentry);
+		__audit_inode(name, dentry, parent);
 }
 static inline void audit_inode_child(const struct inode *parent,
 				     const struct dentry *dentry) {
@@ -635,9 +638,9 @@ extern int audit_signals;
 #define audit_dummy_context() 1
 #define audit_getname(n) do { ; } while (0)
 #define audit_putname(n) do { ; } while (0)
-#define __audit_inode(n,d) do { ; } while (0)
+#define __audit_inode(n,d,p) do { ; } while (0)
 #define __audit_inode_child(p,d) do { ; } while (0)
-#define audit_inode(n,d) do { (void)(d); } while (0)
+#define audit_inode(n,d,p) do { ; } while (0)
 #define audit_inode_child(p,d) do { ; } while (0)
 #define audit_core_dumps(i) do { ; } while (0)
 #define audit_seccomp(i,s,c) do { ; } while (0)
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 9a08acc..69cb5fe 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -805,7 +805,7 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, umode_t, mode,
 
 	if (oflag & O_CREAT) {
 		if (path.dentry->d_inode) {	/* entry already exists */
-			audit_inode(name, path.dentry);
+			audit_inode(name, path.dentry, 0);
 			if (oflag & O_EXCL) {
 				error = -EEXIST;
 				goto out;
@@ -825,7 +825,7 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, umode_t, mode,
 			error = -ENOENT;
 			goto out;
 		}
-		audit_inode(name, path.dentry);
+		audit_inode(name, path.dentry, 0);
 		filp = do_open(&path, oflag);
 	}
 
@@ -979,7 +979,7 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 		goto out_fput;
 	}
 	info = MQUEUE_I(inode);
-	audit_inode(NULL, filp->f_path.dentry);
+	audit_inode(NULL, filp->f_path.dentry, 0);
 
 	if (unlikely(!(filp->f_mode & FMODE_WRITE))) {
 		ret = -EBADF;
@@ -1096,7 +1096,7 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 		goto out_fput;
 	}
 	info = MQUEUE_I(inode);
-	audit_inode(NULL, filp->f_path.dentry);
+	audit_inode(NULL, filp->f_path.dentry, 0);
 
 	if (unlikely(!(filp->f_mode & FMODE_READ))) {
 		ret = -EBADF;
diff --git a/kernel/audit.h b/kernel/audit.h
index 8167668..276ca88 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -76,6 +76,7 @@ static inline int audit_hash_ino(u32 ino)
 
 extern int audit_match_class(int class, unsigned syscall);
 extern int audit_comparator(const u32 left, const u32 op, const u32 right);
+extern int parent_len(const char *path);
 extern int audit_compare_dname_path(const char *dname, const char *path,
 				    int *dirlen);
 extern struct sk_buff *	    audit_make_reply(int pid, int seq, int type,
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index a6c3f1a..29b167b 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1198,6 +1198,36 @@ int audit_comparator(u32 left, u32 op, u32 right)
 	}
 }
 
+/**
+ * parent_len - find the length of the parent portion of a pathname
+ * @path: pathname of which to determine length
+ */
+int parent_len(const char *path)
+{
+	int plen;
+	const char *p;
+
+	plen = strlen(path);
+
+	if (plen == 0)
+		return plen;
+
+	/* disregard trailing slashes */
+	p = path + plen - 1;
+	while ((*p == '/') && (p > path))
+		p--;
+
+	/* walk backward until we find the next slash or hit beginning */
+	while ((*p != '/') && (p > path))
+		p--;
+
+	/* did we find a slash? Then increment to include it in path */
+	if (*p == '/')
+		p++;
+
+	return p - path;
+}
+
 /* Compare given dentry name with last component in given path,
  * return of 0 indicates a match. */
 int audit_compare_dname_path(const char *dname, const char *path,
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index bd11d09..011e923 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2149,13 +2149,13 @@ static void audit_copy_inode(struct audit_names *name, const struct dentry *dent
 }
 
 /**
- * audit_inode - store the inode and device from a lookup
+ * __audit_inode - store the inode and device from a lookup
  * @name: name being audited
  * @dentry: dentry being audited
- *
- * Called from fs/namei.c:path_lookup().
+ * @parent: does this dentry represent the parent?
  */
-void __audit_inode(const char *name, const struct dentry *dentry)
+void __audit_inode(const char *name, const struct dentry *dentry,
+		   unsigned int parent)
 {
 	struct audit_context *context = current->audit_context;
 	const struct inode *inode = dentry->d_inode;
@@ -2168,19 +2168,38 @@ void __audit_inode(const char *name, const struct dentry *dentry)
 		goto out_alloc;
 
 	list_for_each_entry_reverse(n, &context->names_list, list) {
-		if (n->name == name)
-			goto out;
+		/* does the name pointer match? */
+		if (n->name != name)
+			continue;
+
+		/* match the correct record type */
+		if (parent) {
+			if (n->type == AUDIT_TYPE_PARENT ||
+			    n->type == AUDIT_TYPE_UNKNOWN)
+				goto out;
+		} else {
+			if (n->type != AUDIT_TYPE_PARENT)
+				goto out;
+		}
 	}
 
 out_alloc:
-	/* unable to find the name from a previous getname() */
+	/* unable to find the name from a previous getname(). Allocate a new
+	 * anonymous entry.
+	 */
 	n = audit_alloc_name(context, AUDIT_TYPE_NORMAL);
 	if (!n)
 		return;
 out:
+	if (parent) {
+		n->name_len = n->name ? parent_len(n->name) : AUDIT_NAME_FULL;
+		n->type = AUDIT_TYPE_PARENT;
+	} else {
+		n->name_len = AUDIT_NAME_FULL;
+		n->type = AUDIT_TYPE_NORMAL;
+	}
 	handle_path(dentry);
 	audit_copy_inode(n, dentry, inode);
-	n->type = AUDIT_TYPE_NORMAL;
 }
 
 /**
@@ -2204,7 +2223,6 @@ void __audit_inode_child(const struct inode *parent,
 	const struct inode *inode = dentry->d_inode;
 	const char *dname = dentry->d_name.name;
 	struct audit_names *n;
-	int dirlen = 0;
 
 	if (!context->in_syscall)
 		return;
@@ -2218,8 +2236,7 @@ void __audit_inode_child(const struct inode *parent,
 			continue;
 
 		if (n->ino == parent->i_ino &&
-		    !audit_compare_dname_path(dname, n->name, &dirlen)) {
-			n->name_len = dirlen; /* update parent data in place */
+		    !audit_compare_dname_path(dname, n->name, NULL)) {
 			found_parent = n->name;
 			goto add_names;
 		}
@@ -2232,7 +2249,7 @@ void __audit_inode_child(const struct inode *parent,
 
 		/* strcmp() is the more likely scenario */
 		if (!strcmp(dname, n->name) ||
-		     !audit_compare_dname_path(dname, n->name, &dirlen)) {
+		     !audit_compare_dname_path(dname, n->name, NULL)) {
 			if (inode)
 				audit_copy_inode(n, dentry, inode);
 			else
-- 
1.7.11.4

