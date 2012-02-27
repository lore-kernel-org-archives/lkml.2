Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab2B0TZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:25:34 -0500
Received: from smtp.outflux.net ([198.145.64.163]:44899 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab2B0TZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:25:33 -0500
Date: Mon, 27 Feb 2012 11:12:31 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, Will Drewry <wad@chromium.org>
Subject: [PATCH] seccomp: remove duplicated failure logging
Message-ID: <20120227191230.GA2831@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This consolidates the seccomp filter error logging path and adds more
details to the audit log.

Signed-off-by: Kees Cook <keescook@chromium.org>

---
To be applied on top of Will Drewry's seccomp series, specifically
"[PATCH v11 06/12] seccomp: add system call filtering using BPF".

v2:
 - drop compat (really arch) for now.
---
 include/linux/audit.h |    8 ++++----
 kernel/auditsc.c      |    5 +++--
 kernel/seccomp.c      |   15 +--------------
 3 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 9ff7a2c..5aac29b 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -463,7 +463,7 @@ extern void audit_putname(const char *name);
 extern void __audit_inode(const char *name, const struct dentry *dentry);
 extern void __audit_inode_child(const struct dentry *dentry,
 				const struct inode *parent);
-extern void __audit_seccomp(unsigned long syscall);
+extern void __audit_seccomp(unsigned long syscall, long signr);
 extern void __audit_ptrace(struct task_struct *t);
 
 static inline int audit_dummy_context(void)
@@ -508,10 +508,10 @@ static inline void audit_inode_child(const struct dentry *dentry,
 }
 void audit_core_dumps(long signr);
 
-static inline void audit_seccomp(unsigned long syscall)
+static inline void audit_seccomp(unsigned long syscall, long signr)
 {
 	if (unlikely(!audit_dummy_context()))
-		__audit_seccomp(syscall);
+		__audit_seccomp(syscall, signr);
 }
 
 static inline void audit_ptrace(struct task_struct *t)
@@ -634,7 +634,7 @@ extern int audit_signals;
 #define audit_inode(n,d) do { (void)(d); } while (0)
 #define audit_inode_child(i,p) do { ; } while (0)
 #define audit_core_dumps(i) do { ; } while (0)
-#define audit_seccomp(i) do { ; } while (0)
+#define audit_seccomp(i, s) do { ; } while (0)
 #define auditsc_get_stamp(c,t,s) (0)
 #define audit_get_loginuid(t) (-1)
 #define audit_get_sessionid(t) (-1)
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index af1de0f..2150339 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2710,13 +2710,14 @@ void audit_core_dumps(long signr)
 	audit_log_end(ab);
 }
 
-void __audit_seccomp(unsigned long syscall)
+void __audit_seccomp(unsigned long syscall, long signr)
 {
 	struct audit_buffer *ab;
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
-	audit_log_abend(ab, "seccomp", SIGKILL);
+	audit_log_abend(ab, "seccomp", signr);
 	audit_log_format(ab, " syscall=%ld", syscall);
+	audit_log_format(ab, " ip=0x%lx", KSTK_EIP(current));
 	audit_log_end(ab);
 }
 
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 5aabc3c..40af83f 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -57,18 +57,6 @@ struct seccomp_filter {
 	struct sock_filter insns[];
 };
 
-static void seccomp_filter_log_failure(int syscall)
-{
-	int compat = 0;
-#ifdef CONFIG_COMPAT
-	compat = is_compat_task();
-#endif
-	pr_info("%s[%d]: %ssystem call %d blocked at 0x%lx\n",
-		current->comm, task_pid_nr(current),
-		(compat ? "compat " : ""),
-		syscall, KSTK_EIP(current));
-}
-
 /**
  * get_u32 - returns a u32 offset into data
  * @data: a unsigned 64 bit value
@@ -378,7 +366,6 @@ int __secure_computing_int(int this_syscall)
 		default:
 			break;
 		}
-		seccomp_filter_log_failure(this_syscall);
 		exit_code = SIGSYS;
 		break;
 	}
@@ -390,7 +377,7 @@ int __secure_computing_int(int this_syscall)
 #ifdef SECCOMP_DEBUG
 	dump_stack();
 #endif
-	audit_seccomp(this_syscall);
+	audit_seccomp(this_syscall, exit_code);
 	do_exit(exit_code);
 	return -1;	/* never reached */
 }
-- 
1.7.0.4

