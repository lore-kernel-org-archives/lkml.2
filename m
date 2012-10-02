Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab2JBA0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:26:25 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53967 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab2JBARa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:30 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 17/49] vfs: make path_openat take a getname_info pointer
Date: Mon,  1 Oct 2012 20:16:26 -0400
Message-Id: <1349137018-21948-18-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...and fix up the callers. For do_file_open_root, just declare a
getname_info on the stack and fill out the .name field. For
do_filp_open, make it also take a getname_info pointer, and fix up its
callers to call it appropriately.

For filp_open, add a variant that takes a getname_info pointer and turn
filp_open into a wrapper around it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/exec.c          |  5 +++--
 fs/internal.h      |  4 ++--
 fs/namei.c         | 28 +++++++++++++++-------------
 fs/open.c          | 33 +++++++++++++++++++++++++++++----
 include/linux/fs.h |  1 +
 kernel/acct.c      |  6 +++---
 mm/swapfile.c      |  4 ++--
 7 files changed, 55 insertions(+), 26 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 222e282..77ea602 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -126,7 +126,7 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
 	if (IS_ERR(tmp))
 		goto out;
 
-	file = do_filp_open(AT_FDCWD, tmp->name, &uselib_flags, LOOKUP_FOLLOW);
+	file = do_filp_open(AT_FDCWD, tmp, &uselib_flags, LOOKUP_FOLLOW);
 	putname(tmp);
 	error = PTR_ERR(file);
 	if (IS_ERR(file))
@@ -761,13 +761,14 @@ struct file *open_exec(const char *name)
 {
 	struct file *file;
 	int err;
+	struct getname_info tmp = { .name = name };
 	static const struct open_flags open_exec_flags = {
 		.open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
 		.acc_mode = MAY_EXEC | MAY_OPEN,
 		.intent = LOOKUP_OPEN
 	};
 
-	file = do_filp_open(AT_FDCWD, name, &open_exec_flags, LOOKUP_FOLLOW);
+	file = do_filp_open(AT_FDCWD, &tmp, &open_exec_flags, LOOKUP_FOLLOW);
 	if (IS_ERR(file))
 		goto out;
 
diff --git a/fs/internal.h b/fs/internal.h
index 371bcc4..ddc0d2c 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -97,8 +97,8 @@ struct open_flags {
 	int acc_mode;
 	int intent;
 };
-extern struct file *do_filp_open(int dfd, const char *pathname,
-		const struct open_flags *op, int lookup_flags);
+extern struct file *do_filp_open(int dfd, struct getname_info *ginfo,
+		const struct open_flags *op, int flags);
 extern struct file *do_file_open_root(struct dentry *, struct vfsmount *,
 		const char *, const struct open_flags *, int lookup_flags);
 
diff --git a/fs/namei.c b/fs/namei.c
index 5e31fbb..048373c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2667,7 +2667,7 @@ out_dput:
  */
 static int do_last(struct nameidata *nd, struct path *path,
 		   struct file *file, const struct open_flags *op,
-		   int *opened, const char *pathname)
+		   int *opened, struct getname_info *ginfo)
 {
 	struct dentry *dir = nd->path.dentry;
 	int open_flag = op->open_flag;
@@ -2679,6 +2679,7 @@ static int do_last(struct nameidata *nd, struct path *path,
 	struct path save_parent = { .dentry = NULL, .mnt = NULL };
 	bool retried = false;
 	int error;
+	const char *pathname = ginfo->name;
 
 	nd->flags &= ~LOOKUP_PARENT;
 	nd->flags |= op->intent;
@@ -2913,7 +2914,7 @@ stale_open:
 	goto retry_lookup;
 }
 
-static struct file *path_openat(int dfd, const char *pathname,
+static struct file *path_openat(int dfd, struct getname_info *ginfo,
 		struct nameidata *nd, const struct open_flags *op, int flags)
 {
 	struct file *base = NULL;
@@ -2928,16 +2929,16 @@ static struct file *path_openat(int dfd, const char *pathname,
 
 	file->f_flags = op->open_flag;
 
-	error = path_init(dfd, pathname, flags | LOOKUP_PARENT, nd, &base);
+	error = path_init(dfd, ginfo->name, flags | LOOKUP_PARENT, nd, &base);
 	if (unlikely(error))
 		goto out;
 
 	current->total_link_count = 0;
-	error = link_path_walk(pathname, nd);
+	error = link_path_walk(ginfo->name, nd);
 	if (unlikely(error))
 		goto out;
 
-	error = do_last(nd, &path, file, op, &opened, pathname);
+	error = do_last(nd, &path, file, op, &opened, ginfo);
 	while (unlikely(error > 0)) { /* trailing symlink */
 		struct path link = path;
 		void *cookie;
@@ -2955,7 +2956,7 @@ static struct file *path_openat(int dfd, const char *pathname,
 		error = follow_link(&link, nd, &cookie);
 		if (unlikely(error))
 			break;
-		error = do_last(nd, &path, file, op, &opened, pathname);
+		error = do_last(nd, &path, file, op, &opened, ginfo);
 		put_link(nd, &link, cookie);
 	}
 out:
@@ -2979,17 +2980,17 @@ out:
 	return file;
 }
 
-struct file *do_filp_open(int dfd, const char *pathname,
+struct file *do_filp_open(int dfd, struct getname_info *ginfo,
 		const struct open_flags *op, int flags)
 {
 	struct nameidata nd;
 	struct file *filp;
 
-	filp = path_openat(dfd, pathname, &nd, op, flags | LOOKUP_RCU);
+	filp = path_openat(dfd, ginfo, &nd, op, flags | LOOKUP_RCU);
 	if (unlikely(filp == ERR_PTR(-ECHILD)))
-		filp = path_openat(dfd, pathname, &nd, op, flags);
+		filp = path_openat(dfd, ginfo, &nd, op, flags);
 	if (unlikely(filp == ERR_PTR(-ESTALE)))
-		filp = path_openat(dfd, pathname, &nd, op, flags | LOOKUP_REVAL);
+		filp = path_openat(dfd, ginfo, &nd, op, flags | LOOKUP_REVAL);
 	return filp;
 }
 
@@ -2998,6 +2999,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 {
 	struct nameidata nd;
 	struct file *file;
+	struct getname_info ginfo = { .name = name };
 
 	nd.root.mnt = mnt;
 	nd.root.dentry = dentry;
@@ -3007,11 +3009,11 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	if (dentry->d_inode->i_op->follow_link && op->intent & LOOKUP_OPEN)
 		return ERR_PTR(-ELOOP);
 
-	file = path_openat(-1, name, &nd, op, flags | LOOKUP_RCU);
+	file = path_openat(-1, &ginfo, &nd, op, flags | LOOKUP_RCU);
 	if (unlikely(file == ERR_PTR(-ECHILD)))
-		file = path_openat(-1, name, &nd, op, flags);
+		file = path_openat(-1, &ginfo, &nd, op, flags);
 	if (unlikely(file == ERR_PTR(-ESTALE)))
-		file = path_openat(-1, name, &nd, op, flags | LOOKUP_REVAL);
+		file = path_openat(-1, &ginfo, &nd, op, flags | LOOKUP_REVAL);
 	return file;
 }
 
diff --git a/fs/open.c b/fs/open.c
index 3796d0c..d0f225e 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -909,6 +909,24 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 }
 
 /**
+ * filp_open_ginfo - open file and return file pointer
+ *
+ * @ginfo:	getname_info containing path to open
+ * @flags:	open flags as per the open(2) second argument
+ * @mode:	mode for the new file if O_CREAT is set, else ignored
+ *
+ * This is the helper to open a file from kernelspace if you really
+ * have to.  But in generally you should not do this, so please move
+ * along, nothing to see here..
+ */
+struct file *filp_open_ginfo(struct getname_info *ginfo, int flags, umode_t mode)
+{
+	struct open_flags op;
+	int lookup = build_open_flags(flags, mode, &op);
+	return do_filp_open(AT_FDCWD, ginfo, &op, lookup);
+}
+
+/**
  * filp_open - open file and return file pointer
  *
  * @filename:	path to open
@@ -921,9 +939,16 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
  */
 struct file *filp_open(const char *filename, int flags, umode_t mode)
 {
-	struct open_flags op;
-	int lookup = build_open_flags(flags, mode, &op);
-	return do_filp_open(AT_FDCWD, filename, &op, lookup);
+	struct file *filp;
+	struct getname_info *ginfo = kzalloc(sizeof(*ginfo), GFP_KERNEL);
+
+	if (!ginfo)
+		return ERR_PTR(-ENOMEM);
+
+	ginfo->name = filename;
+	filp = filp_open_ginfo(ginfo, flags, mode);
+	putname(ginfo);
+	return filp;
 }
 EXPORT_SYMBOL(filp_open);
 
@@ -951,7 +976,7 @@ long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
 	if (!IS_ERR(tmp)) {
 		fd = get_unused_fd_flags(flags);
 		if (fd >= 0) {
-			struct file *f = do_filp_open(dfd, tmp->name, &op, lookup);
+			struct file *f = do_filp_open(dfd, tmp, &op, lookup);
 			if (IS_ERR(f)) {
 				put_unused_fd(fd);
 				fd = PTR_ERR(f);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1b0d0fb..a37b0c1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2200,6 +2200,7 @@ extern int do_fallocate(struct file *file, int mode, loff_t offset,
 			loff_t len);
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			umode_t mode);
+extern struct file *filp_open_ginfo(struct getname_info *, int, umode_t);
 extern struct file *filp_open(const char *, int, umode_t);
 extern struct file *file_open_root(struct dentry *, struct vfsmount *,
 				   const char *, int);
diff --git a/kernel/acct.c b/kernel/acct.c
index 3943608..a6b3e14 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -193,7 +193,7 @@ static void acct_file_reopen(struct bsd_acct_struct *acct, struct file *file,
 	}
 }
 
-static int acct_on(const char *name)
+static int acct_on(struct getname_info *pathname)
 {
 	struct file *file;
 	struct vfsmount *mnt;
@@ -201,7 +201,7 @@ static int acct_on(const char *name)
 	struct bsd_acct_struct *acct = NULL;
 
 	/* Difference from BSD - they don't do O_APPEND */
-	file = filp_open(name, O_WRONLY|O_APPEND|O_LARGEFILE, 0);
+	file = filp_open_ginfo(pathname, O_WRONLY|O_APPEND|O_LARGEFILE, 0);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
@@ -263,7 +263,7 @@ SYSCALL_DEFINE1(acct, const char __user *, name)
 		struct getname_info *tmp = getname(name);
 		if (IS_ERR(tmp))
 			return (PTR_ERR(tmp));
-		error = acct_on(tmp->name);
+		error = acct_on(tmp);
 		putname(tmp);
 	} else {
 		struct bsd_acct_struct *acct;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8dbf46d..0f8b1a4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1498,7 +1498,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (IS_ERR(pathname))
 		goto out;
 
-	victim = filp_open(pathname->name, O_RDWR|O_LARGEFILE, 0);
+	victim = filp_open_ginfo(pathname, O_RDWR|O_LARGEFILE, 0);
 	err = PTR_ERR(victim);
 	if (IS_ERR(victim))
 		goto out;
@@ -1966,7 +1966,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		name = NULL;
 		goto bad_swap;
 	}
-	swap_file = filp_open(name->name, O_RDWR|O_LARGEFILE, 0);
+	swap_file = filp_open_ginfo(name, O_RDWR|O_LARGEFILE, 0);
 	if (IS_ERR(swap_file)) {
 		error = PTR_ERR(swap_file);
 		swap_file = NULL;
-- 
1.7.11.4

