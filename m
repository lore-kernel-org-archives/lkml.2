Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017Ab2JZPoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:44:00 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:65278 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933879Ab2JZPnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:43:55 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: hch@infradead.org, eparis@redhat.com, linux-audit@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] audit: break up __audit_inode into two functions
Date: Fri, 26 Oct 2012 11:43:42 -0400
Message-Id: <1351266222-11107-4-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351266222-11107-1-git-send-email-jlayton@redhat.com>
References: <1351266222-11107-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One to handle the case where we have a ginfo and a parent flag. Another to
handle the trivial case where we have no ginfo and no parent flag.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/open.c             |  4 ++--
 fs/xattr.c            |  8 ++++----
 include/linux/audit.h | 11 ++++++++++-
 ipc/mqueue.c          |  4 ++--
 kernel/auditsc.c      | 17 +++++++++++++++++
 5 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 59071f5..94d5649 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -478,7 +478,7 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
 
 	file = fget(fd);
 	if (file) {
-		audit_inode(NULL, file->f_path.dentry, 0);
+		audit_anonymous(file->f_path.dentry);
 		err = chmod_common(&file->f_path, mode);
 		fput(file);
 	}
@@ -588,7 +588,7 @@ SYSCALL_DEFINE3(fchown, unsigned int, fd, uid_t, user, gid_t, group)
 	error = mnt_want_write_file(f.file);
 	if (error)
 		goto out_fput;
-	audit_inode(NULL, f.file->f_path.dentry, 0);
+	audit_anonymous(f.file->f_path.dentry);
 	error = chown_common(&f.file->f_path, user, group);
 	mnt_drop_write_file(f.file);
 out_fput:
diff --git a/fs/xattr.c b/fs/xattr.c
index e21c119..f3a2ffa 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -412,7 +412,7 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 	if (!f.file)
 		return error;
 	dentry = f.file->f_path.dentry;
-	audit_inode(NULL, dentry, 0);
+	audit_anonymous(dentry);
 	error = mnt_want_write_file(f.file);
 	if (!error) {
 		error = setxattr(dentry, name, value, size, flags);
@@ -507,7 +507,7 @@ SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
 
 	if (!f.file)
 		return error;
-	audit_inode(NULL, f.file->f_path.dentry, 0);
+	audit_anonymous(f.file->f_path.dentry);
 	error = getxattr(f.file->f_path.dentry, name, value, size);
 	fdput(f);
 	return error;
@@ -586,7 +586,7 @@ SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
 
 	if (!f.file)
 		return error;
-	audit_inode(NULL, f.file->f_path.dentry, 0);
+	audit_anonymous(f.file->f_path.dentry);
 	error = listxattr(f.file->f_path.dentry, list, size);
 	fdput(f);
 	return error;
@@ -655,7 +655,7 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 	if (!f.file)
 		return error;
 	dentry = f.file->f_path.dentry;
-	audit_inode(NULL, dentry, 0);
+	audit_anonymous(dentry);
 	error = mnt_want_write_file(f.file);
 	if (!error) {
 		error = removexattr(dentry, name);
diff --git a/include/linux/audit.h b/include/linux/audit.h
index bce729a..2214478 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -97,6 +97,7 @@ extern void __audit_syscall_exit(int ret_success, long ret_value);
 extern struct filename *__audit_reusename(const __user char *uptr);
 extern void __audit_getname(struct filename *name);
 extern void audit_putname(struct filename *name);
+extern void __audit_anonymous(const struct dentry *dentry);
 extern void __audit_inode(struct filename *name, const struct dentry *dentry,
 				unsigned int parent);
 extern void __audit_inode_child(const struct inode *parent,
@@ -142,6 +143,10 @@ static inline void audit_getname(struct filename *name)
 	if (unlikely(!audit_dummy_context()))
 		__audit_getname(name);
 }
+static inline void audit_anonymous(const struct dentry *dentry) {
+	if (unlikely(!audit_dummy_context()))
+		__audit_anonymous(dentry);
+}
 static inline void audit_inode(struct filename *name, const struct dentry *dentry,
 				unsigned int parent) {
 	if (unlikely(!audit_dummy_context()))
@@ -303,7 +308,9 @@ static inline void audit_getname(struct filename *name)
 { }
 static inline void audit_putname(struct filename *name)
 { }
-static inline void __audit_inode(struct filename *name,
+static inline void __audit_anonymous(const struct dentry *dentry)
+{ }
+static inline void __audit_inode(struct getname_info *ginfo,
 					const struct dentry *dentry,
 					unsigned int parent)
 { }
@@ -311,6 +318,8 @@ static inline void __audit_inode_child(const struct inode *parent,
 					const struct dentry *dentry,
 					const unsigned char type)
 { }
+static inline void audit_anonymous(const struct dentry *dentry)
+{ }
 static inline void audit_inode(struct filename *name,
 				const struct dentry *dentry,
 				unsigned int parent)
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 71a3ca1..2967a09 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -979,7 +979,7 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 		goto out_fput;
 	}
 	info = MQUEUE_I(inode);
-	audit_inode(NULL, f.file->f_path.dentry, 0);
+	audit_anonymous(f.file->f_path.dentry);
 
 	if (unlikely(!(f.file->f_mode & FMODE_WRITE))) {
 		ret = -EBADF;
@@ -1095,7 +1095,7 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 		goto out_fput;
 	}
 	info = MQUEUE_I(inode);
-	audit_inode(NULL, f.file->f_path.dentry, 0);
+	audit_anonymous(f.file->f_path.dentry);
 
 	if (unlikely(!(f.file->f_mode & FMODE_READ))) {
 		ret = -EBADF;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 9a65af0..e5495f2 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2175,6 +2175,23 @@ static void audit_names_setup(struct audit_names *n,
 	audit_copy_fcaps(n, dentry);
 }
 
+/*
+ * __audit_anonymous - store a new audit_names record for an
+ *		       dentry with no pathname
+ * @dentry: dentry being audited
+ */
+void __audit_anonymous(const struct dentry *dentry)
+{
+	struct audit_context *context = current->audit_context;
+	struct audit_names *n;
+
+	n = audit_alloc_name(context, AUDIT_TYPE_NORMAL);
+	if (!n)
+		return;
+
+	audit_names_setup(n, dentry, 0);
+}
+
 /**
  * __audit_inode - store the inode and device from a lookup
  * @name: name being audited
-- 
1.7.11.7

