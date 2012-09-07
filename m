Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2IGSig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:38:36 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58109 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab2IGSid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:38:33 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 2/2] security: introduce kernel_module_from_file hook
Date: Fri,  7 Sep 2012 11:38:14 -0700
Message-Id: <1347043094-11120-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1347043094-11120-1-git-send-email-keescook@chromium.org>
References: <1347043094-11120-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that kernel module origins can be reasoned about, provide a hook to
the LSMs to make policy decisions about the module file.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>
---
 include/linux/security.h |   13 +++++++++++++
 kernel/module.c          |    9 +++++++++
 security/capability.c    |    6 ++++++
 security/security.c      |    5 +++++
 4 files changed, 33 insertions(+), 0 deletions(-)

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
index c1e446e..0ad03c4 100644
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
@@ -2430,6 +2431,10 @@ int copy_module_from_user(const void __user *umod, unsigned long len,
 	if (info->len < sizeof(*(info->hdr)))
 		return -ENOEXEC;
 
+	err = security_kernel_module_from_file(NULL);
+	if (err)
+		return err;
+
 	/* Suck in entire file: we'll want most of it. */
 	info->hdr = vmalloc(info->len);
 	if (!info->hdr)
@@ -2468,6 +2473,10 @@ int copy_module_from_fd(int fd, struct load_info *info)
 	if (err)
 		goto out;
 
+	err = security_kernel_module_from_file(file);
+	if (err)
+		goto out;
+
 	size = stat.size;
 	info->hdr = vmalloc(size);
 	if (!info->hdr) {
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
1.7.0.4

