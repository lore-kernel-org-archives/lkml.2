Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab2JDUYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:24:11 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43518 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757199Ab2JDUXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:23:07 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 2/4] security: introduce kernel_module_from_file hook
Date: Thu,  4 Oct 2012 13:22:32 -0700
Message-Id: <1349382154-9804-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349382154-9804-1-git-send-email-keescook@chromium.org>
References: <1349382154-9804-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that kernel module origins can be reasoned about, provide a hook to
the LSMs to make policy decisions about the module file. This will let
Chrome OS enforce that loadable kernel modules can only come from its
read-only hash-verified root filesystem. Other LSMs can, for example,
read extended attributes for signatures, etc.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/security.h |   13 +++++++++++++
 kernel/module.c          |   11 +++++++++++
 security/capability.c    |    6 ++++++
 security/security.c      |    5 +++++
 4 files changed, 35 insertions(+)

diff --git a/include/linux/security.h b/include/linux/security.h
index 3dea6a9..368e539 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -693,6 +693,12 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	userspace to load a kernel module with the given name.
  *	@kmod_name name of the module requested by the kernel
  *	Return 0 if successful.
+ * @kernel_module_from_file:
+ *	Load a kernel module from userspace.
+ *	@file contains the file structure pointing to the file containing
+ *	the kernel module to load. If the module is being loaded from a blob,
+ *	this argument will be NULL.
+ *	Return 0 if permission is granted.
  * @task_fix_setuid:
  *	Update the module's state after setting one or more of the user
  *	identity attributes of the current process.  The @flags parameter
@@ -1507,6 +1513,7 @@ struct security_operations {
 	int (*kernel_act_as)(struct cred *new, u32 secid);
 	int (*kernel_create_files_as)(struct cred *new, struct inode *inode);
 	int (*kernel_module_request)(char *kmod_name);
+	int (*kernel_module_from_file)(struct file *file);
 	int (*task_fix_setuid) (struct cred *new, const struct cred *old,
 				int flags);
 	int (*task_setpgid) (struct task_struct *p, pid_t pgid);
@@ -1764,6 +1771,7 @@ void security_transfer_creds(struct cred *new, const struct cred *old);
 int security_kernel_act_as(struct cred *new, u32 secid);
 int security_kernel_create_files_as(struct cred *new, struct inode *inode);
 int security_kernel_module_request(char *kmod_name);
+int security_kernel_module_from_file(struct file *file);
 int security_task_fix_setuid(struct cred *new, const struct cred *old,
 			     int flags);
 int security_task_setpgid(struct task_struct *p, pid_t pgid);
@@ -2277,6 +2285,11 @@ static inline int security_kernel_module_request(char *kmod_name)
 	return 0;
 }
 
+static inline int security_kernel_module_from_file(struct file *file)
+{
+	return 0;
+}
+
 static inline int security_task_fix_setuid(struct cred *new,
 					   const struct cred *old,
 					   int flags)
diff --git a/kernel/module.c b/kernel/module.c
index 321c6b9..261bf82 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -29,6 +29,7 @@
 #include <linux/vmalloc.h>
 #include <linux/elf.h>
 #include <linux/proc_fs.h>
+#include <linux/security.h>
 #include <linux/seq_file.h>
 #include <linux/syscalls.h>
 #include <linux/fcntl.h>
@@ -2489,10 +2490,16 @@ static int elf_header_check(struct load_info *info)
 static int copy_module_from_user(const void __user *umod, unsigned long len,
 				  struct load_info *info)
 {
+	int err;
+
 	info->len = len;
 	if (info->len < sizeof(*(info->hdr)))
 		return -ENOEXEC;
 
+	err = security_kernel_module_from_file(NULL);
+	if (err)
+		return err;
+
 	/* Suck in entire file: we'll want most of it. */
 	info->hdr = vmalloc(info->len);
 	if (!info->hdr)
@@ -2519,6 +2526,10 @@ static int copy_module_from_fd(int fd, struct load_info *info)
 	if (!file)
 		return -ENOEXEC;
 
+	err = security_kernel_module_from_file(file);
+	if (err)
+		goto out;
+
 	err = vfs_getattr(file->f_vfsmnt, file->f_dentry, &stat);
 	if (err)
 		goto out;
diff --git a/security/capability.c b/security/capability.c
index 61095df..8acb304 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -395,6 +395,11 @@ static int cap_kernel_module_request(char *kmod_name)
 	return 0;
 }
 
+static int cap_kernel_module_from_file(struct file *file)
+{
+	return 0;
+}
+
 static int cap_task_setpgid(struct task_struct *p, pid_t pgid)
 {
 	return 0;
@@ -967,6 +972,7 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, kernel_act_as);
 	set_to_cap_if_null(ops, kernel_create_files_as);
 	set_to_cap_if_null(ops, kernel_module_request);
+	set_to_cap_if_null(ops, kernel_module_from_file);
 	set_to_cap_if_null(ops, task_fix_setuid);
 	set_to_cap_if_null(ops, task_setpgid);
 	set_to_cap_if_null(ops, task_getpgid);
diff --git a/security/security.c b/security/security.c
index 860aeb3..f7f8695 100644
--- a/security/security.c
+++ b/security/security.c
@@ -799,6 +799,11 @@ int security_kernel_module_request(char *kmod_name)
 	return security_ops->kernel_module_request(kmod_name);
 }
 
+int security_kernel_module_from_file(struct file *file)
+{
+	return security_ops->kernel_module_from_file(file);
+}
+
 int security_task_fix_setuid(struct cred *new, const struct cred *old,
 			     int flags)
 {
-- 
1.7.9.5

