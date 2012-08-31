Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab2HaVbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 17:31:45 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55912 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab2HaVbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 17:31:43 -0400
Date: Fri, 31 Aug 2012 14:31:26 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: James Morris <james.l.morris@oracle.com>, Eric Paris <eparis@redhat.com>,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        John Johansen <john.johansen@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] security: unconditionally call Yama
Message-ID: <20120831213126.GA19688@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unconditionally call Yama, no matter what LSM module is selected.

Ubuntu and Chrome OS already carry patches to do this, and Fedora has
voiced interest in doing this as well. Instead of having everyone carry
these patches, just switch Yama to being unconditional when compiled
into the kernel.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/security.h |   31 +++++++++++++++++++++++++++++++
 security/Kconfig         |    5 -----
 security/security.c      |   13 +++++++++++++
 security/yama/yama_lsm.c |   14 ++++----------
 4 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 3dea6a9..01ef030 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -3021,5 +3021,36 @@ static inline void free_secdata(void *secdata)
 { }
 #endif /* CONFIG_SECURITY */
 
+#ifdef CONFIG_SECURITY_YAMA
+extern int yama_ptrace_access_check(struct task_struct *child,
+				    unsigned int mode);
+extern int yama_ptrace_traceme(struct task_struct *parent);
+extern void yama_task_free(struct task_struct *task);
+extern int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
+			   unsigned long arg4, unsigned long arg5);
+#else
+static inline int yama_ptrace_access_check(struct task_struct *child,
+					   unsigned int mode)
+{
+	return 0;
+}
+
+static inline int yama_ptrace_traceme(struct task_struct *parent)
+{
+	return 0;
+}
+
+static inline void yama_task_free(struct task_struct *task)
+{
+}
+
+static inline int yama_task_prctl(int option, unsigned long arg2,
+				  unsigned long arg3, unsigned long arg4,
+				  unsigned long arg5)
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_SECURITY_YAMA */
+
 #endif /* ! __LINUX_SECURITY_H */
 
diff --git a/security/Kconfig b/security/Kconfig
index e9c6ac7..bde1b31 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -131,7 +131,6 @@ choice
 	default DEFAULT_SECURITY_SMACK if SECURITY_SMACK
 	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
 	default DEFAULT_SECURITY_APPARMOR if SECURITY_APPARMOR
-	default DEFAULT_SECURITY_YAMA if SECURITY_YAMA
 	default DEFAULT_SECURITY_DAC
 
 	help
@@ -150,9 +149,6 @@ choice
 	config DEFAULT_SECURITY_APPARMOR
 		bool "AppArmor" if SECURITY_APPARMOR=y
 
-	config DEFAULT_SECURITY_YAMA
-		bool "Yama" if SECURITY_YAMA=y
-
 	config DEFAULT_SECURITY_DAC
 		bool "Unix Discretionary Access Controls"
 
@@ -164,7 +160,6 @@ config DEFAULT_SECURITY
 	default "smack" if DEFAULT_SECURITY_SMACK
 	default "tomoyo" if DEFAULT_SECURITY_TOMOYO
 	default "apparmor" if DEFAULT_SECURITY_APPARMOR
-	default "yama" if DEFAULT_SECURITY_YAMA
 	default "" if DEFAULT_SECURITY_DAC
 
 endmenu
diff --git a/security/security.c b/security/security.c
index 860aeb3..92b723a 100644
--- a/security/security.c
+++ b/security/security.c
@@ -136,11 +136,19 @@ int __init register_security(struct security_operations *ops)
 
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
+	int rc;
+	rc = yama_ptrace_access_check(child, mode);
+	if (rc)
+		return rc;
 	return security_ops->ptrace_access_check(child, mode);
 }
 
 int security_ptrace_traceme(struct task_struct *parent)
 {
+	int rc;
+	rc = yama_ptrace_traceme(parent);
+	if (rc)
+		return rc;
 	return security_ops->ptrace_traceme(parent);
 }
 
@@ -761,6 +769,7 @@ int security_task_create(unsigned long clone_flags)
 
 void security_task_free(struct task_struct *task)
 {
+	yama_task_free(task);
 	security_ops->task_free(task);
 }
 
@@ -876,6 +885,10 @@ int security_task_wait(struct task_struct *p)
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			 unsigned long arg4, unsigned long arg5)
 {
+	int rc;
+	rc = yama_task_prctl(option, arg2, arg3, arg4, arg5);
+	if (rc != -ENOSYS)
+		return rc;
 	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5);
 }
 
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index dcd6178..aef5c6a 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -100,7 +100,7 @@ static void yama_ptracer_del(struct task_struct *tracer,
  * yama_task_free - check for task_pid to remove from exception list
  * @task: task being removed
  */
-static void yama_task_free(struct task_struct *task)
+void yama_task_free(struct task_struct *task)
 {
 	yama_ptracer_del(task, task);
 }
@@ -116,7 +116,7 @@ static void yama_task_free(struct task_struct *task)
  * Return 0 on success, -ve on error.  -ENOSYS is returned when Yama
  * does not handle the given option.
  */
-static int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
+int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			   unsigned long arg4, unsigned long arg5)
 {
 	int rc;
@@ -243,7 +243,7 @@ static int ptracer_exception_found(struct task_struct *tracer,
  *
  * Returns 0 if following the ptrace is allowed, -ve on error.
  */
-static int yama_ptrace_access_check(struct task_struct *child,
+int yama_ptrace_access_check(struct task_struct *child,
 				    unsigned int mode)
 {
 	int rc;
@@ -293,7 +293,7 @@ static int yama_ptrace_access_check(struct task_struct *child,
  *
  * Returns 0 if following the ptrace is allowed, -ve on error.
  */
-static int yama_ptrace_traceme(struct task_struct *parent)
+int yama_ptrace_traceme(struct task_struct *parent)
 {
 	int rc;
 
@@ -378,14 +378,8 @@ static struct ctl_table yama_sysctl_table[] = {
 
 static __init int yama_init(void)
 {
-	if (!security_module_enable(&yama_ops))
-		return 0;
-
 	printk(KERN_INFO "Yama: becoming mindful.\n");
 
-	if (register_security(&yama_ops))
-		panic("Yama: kernel registration failed.\n");
-
 #ifdef CONFIG_SYSCTL
 	if (!register_sysctl_paths(yama_sysctl_path, yama_sysctl_table))
 		panic("Yama: sysctl registration failed.\n");
-- 
1.7.0.4


-- 
Kees Cook
Chrome OS Security
