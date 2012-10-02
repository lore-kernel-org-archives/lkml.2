Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab2JBA0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:26:23 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42765 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2JBARa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:30 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 18/49] audit: make audit_inode take getname_info
Date: Mon,  1 Oct 2012 20:16:27 -0400
Message-Id: <1349137018-21948-19-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep a pointer to the audit_names "slot" in getname_info.

Have all of the audit_inode callers pass a getname_info ponter to
audit_inode instead of a string pointer. If the aname field is already
populated, then we can skip walking the list altogether and just use it
directly.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c            | 16 +++++++---------
 include/linux/audit.h | 10 +++++-----
 include/linux/fs.h    |  6 ++++--
 ipc/mqueue.c          |  4 ++--
 kernel/auditsc.c      | 29 +++++++++++++++++++++++++----
 5 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 048373c..5e2f5ae 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2004,8 +2004,7 @@ static int ginfo_lookup(int dfd, struct getname_info *ginfo,
 						flags | LOOKUP_REVAL, nd);
 
 	if (likely(!retval))
-		audit_inode(ginfo->name, nd->path.dentry,
-						flags & LOOKUP_PARENT);
+		audit_inode(ginfo, nd->path.dentry, flags & LOOKUP_PARENT);
 	return retval;
 }
 
@@ -2679,7 +2678,6 @@ static int do_last(struct nameidata *nd, struct path *path,
 	struct path save_parent = { .dentry = NULL, .mnt = NULL };
 	bool retried = false;
 	int error;
-	const char *pathname = ginfo->name;
 
 	nd->flags &= ~LOOKUP_PARENT;
 	nd->flags |= op->intent;
@@ -2695,7 +2693,7 @@ static int do_last(struct nameidata *nd, struct path *path,
 		error = complete_walk(nd);
 		if (error)
 			return error;
-		audit_inode(pathname, nd->path.dentry, 0);
+		audit_inode(ginfo, nd->path.dentry, 0);
 		if (open_flag & O_CREAT) {
 			error = -EISDIR;
 			goto out;
@@ -2705,7 +2703,7 @@ static int do_last(struct nameidata *nd, struct path *path,
 		error = complete_walk(nd);
 		if (error)
 			return error;
-		audit_inode(pathname, dir, 0);
+		audit_inode(ginfo, dir, 0);
 		goto finish_open;
 	}
 
@@ -2734,7 +2732,7 @@ static int do_last(struct nameidata *nd, struct path *path,
 		if (error)
 			return error;
 
-		audit_inode(pathname, dir, 0);
+		audit_inode(ginfo, dir, 0);
 		error = -EISDIR;
 		/* trailing slashes? */
 		if (nd->last.name[nd->last.len])
@@ -2764,7 +2762,7 @@ retry_lookup:
 		    !S_ISREG(file->f_path.dentry->d_inode->i_mode))
 			will_truncate = false;
 
-		audit_inode(pathname, file->f_path.dentry, 0);
+		audit_inode(ginfo, file->f_path.dentry, 0);
 		goto opened;
 	}
 
@@ -2781,7 +2779,7 @@ retry_lookup:
 	 * create/update audit record if it already exists.
 	 */
 	if (path->dentry->d_inode)
-		audit_inode(pathname, path->dentry, 0);
+		audit_inode(ginfo, path->dentry, 0);
 
 	/*
 	 * If atomic_open() acquired write access it is dropped now due to
@@ -2846,7 +2844,7 @@ finish_lookup:
 	error = -ENOTDIR;
 	if ((nd->flags & LOOKUP_DIRECTORY) && !nd->inode->i_op->lookup)
 		goto out;
-	audit_inode(pathname, nd->path.dentry, 0);
+	audit_inode(ginfo, nd->path.dentry, 0);
 finish_open:
 	if (!S_ISREG(nd->inode->i_mode))
 		will_truncate = false;
diff --git a/include/linux/audit.h b/include/linux/audit.h
index ea58de3..481cf75 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -472,7 +472,7 @@ extern void __audit_syscall_exit(int ret_success, long ret_value);
 extern struct getname_info *__audit_reusename(const __user char *uptr);
 extern void __audit_getname(struct getname_info *ginfo);
 extern void audit_putname(struct getname_info *ginfo);
-extern void __audit_inode(const char *name, const struct dentry *dentry,
+extern void __audit_inode(struct getname_info *ginfo, const struct dentry *dentry,
 				unsigned int parent);
 extern void __audit_inode_child(const struct inode *parent,
 				const struct dentry *dentry,
@@ -517,10 +517,10 @@ static inline void audit_getname(struct getname_info *name)
 	if (unlikely(!audit_dummy_context()))
 		__audit_getname(name);
 }
-static inline void audit_inode(const char *name, const struct dentry *dentry,
+static inline void audit_inode(struct getname_info *ginfo, const struct dentry *dentry,
 				unsigned int parent) {
 	if (unlikely(!audit_dummy_context()))
-		__audit_inode(name, dentry, parent);
+		__audit_inode(ginfo, dentry, parent);
 }
 static inline void audit_inode_child(const struct inode *parent,
 				     const struct dentry *dentry,
@@ -652,9 +652,9 @@ extern int audit_signals;
 #define audit_reusename(g) ({ NULL; })
 #define audit_getname(n) do { ; } while (0)
 #define audit_putname(n) do { ; } while (0)
-#define __audit_inode(n,d,p) do { ; } while (0)
+#define __audit_inode(g,d,p) do { ; } while (0)
 #define __audit_inode_child(p,d) do { ; } while (0)
-#define audit_inode(n,d,p) do { ; } while (0)
+#define audit_inode(g,d,p) do { ; } while (0)
 #define audit_inode_child(p,d,t) do { ; } while (0)
 #define audit_core_dumps(i) do { ; } while (0)
 #define audit_seccomp(i,s,c) do { ; } while (0)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a37b0c1..4ce38f2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2189,9 +2189,11 @@ static inline int break_lease(struct inode *inode, unsigned int mode)
 #endif /* CONFIG_FILE_LOCKING */
 
 /* fs/open.c */
+struct audit_names;
 struct getname_info {
-	const char *name;		/* pointer to actual string */
-	const __user char *uptr;	/* original userland pointer */
+	const char		*name;	/* pointer to actual string */
+	const __user char	*uptr;	/* original userland pointer */
+	struct audit_names	*aname;
 };
 
 extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 2071a27..07d489e 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -805,7 +805,7 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, umode_t, mode,
 
 	if (oflag & O_CREAT) {
 		if (path.dentry->d_inode) {	/* entry already exists */
-			audit_inode(name->name, path.dentry, 0);
+			audit_inode(name, path.dentry, 0);
 			if (oflag & O_EXCL) {
 				error = -EEXIST;
 				goto out;
@@ -825,7 +825,7 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, umode_t, mode,
 			error = -ENOENT;
 			goto out;
 		}
-		audit_inode(name->name, path.dentry, 0);
+		audit_inode(name, path.dentry, 0);
 		filp = do_open(&path, oflag);
 	}
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 89974ca..92ef854 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2090,6 +2090,7 @@ void __audit_getname(struct getname_info *ginfo)
 	n->ginfo = ginfo;
 	n->name_len = AUDIT_NAME_FULL;
 	n->name_put = true;
+	ginfo->aname = n;
 
 	if (!context->pwd.dentry)
 		get_fs_pwd(current->fs, &context->pwd);
@@ -2176,11 +2177,11 @@ static void audit_copy_inode(struct audit_names *name, const struct dentry *dent
 
 /**
  * __audit_inode - store the inode and device from a lookup
- * @name: name being audited
+ * @ginfo: getname_info for name being audited
  * @dentry: dentry being audited
  * @parent: does this dentry represent the parent?
  */
-void __audit_inode(const char *name, const struct dentry *dentry,
+void __audit_inode(struct getname_info *ginfo, const struct dentry *dentry,
 		   unsigned int parent)
 {
 	struct audit_context *context = current->audit_context;
@@ -2190,12 +2191,32 @@ void __audit_inode(const char *name, const struct dentry *dentry,
 	if (!context->in_syscall)
 		return;
 
-	if (!name)
+	if (!ginfo)
 		goto out_alloc;
 
+#if AUDIT_DEBUG
+	/* The getname_info _must_ have a populated ->name */
+	BUG_ON(!ginfo->name);
+#endif
+	/*
+	 * If we have a pointer to an audit_names entry already, then we can
+	 * just use it directly if the type is correct.
+	 */
+	n = ginfo->aname;
+	if (n) {
+		if (parent) {
+			if (n->type == AUDIT_TYPE_PARENT ||
+			    n->type == AUDIT_TYPE_UNKNOWN)
+				goto out;
+		} else {
+			if (n->type != AUDIT_TYPE_PARENT)
+				goto out;
+		}
+	}
+
 	list_for_each_entry_reverse(n, &context->names_list, list) {
 		/* does the name pointer match? */
-		if (!n->ginfo || n->ginfo->name != name)
+		if (!n->ginfo || n->ginfo->name != ginfo->name)
 			continue;
 
 		/* match the correct record type */
-- 
1.7.11.4

