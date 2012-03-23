Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964835Ab2CWXsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 19:48:24 -0400
Received: from smtp.outflux.net ([198.145.64.163]:50020 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547Ab2CWXsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 19:48:23 -0400
Date: Fri, 23 Mar 2012 16:32:13 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] audit: always report seccomp violations
Message-ID: <20120323233212.GA18484@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a program violates its own seccomp rules, that is a pretty dire
situation, and the audit message should always be reported (not just
when there is already a rule active for the process).

This change makes the audit_seccomp() logic similar to audit_core_dumps()
(it does not require an active context). Since core dumps are more
common, they sit behind an "audit_enabled" test. Audit reports of seccomp
failures should always be visible, and fall back to printk when auditd
is not running.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/audit.h |    8 +-------
 kernel/auditsc.c      |   11 +++++++++--
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index ed3ef19..596077f 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -463,7 +463,7 @@ extern void audit_putname(const char *name);
 extern void __audit_inode(const char *name, const struct dentry *dentry);
 extern void __audit_inode_child(const struct dentry *dentry,
 				const struct inode *parent);
-extern void __audit_seccomp(unsigned long syscall);
+extern void audit_seccomp(unsigned long syscall);
 extern void __audit_ptrace(struct task_struct *t);
 
 static inline int audit_dummy_context(void)
@@ -508,12 +508,6 @@ static inline void audit_inode_child(const struct dentry *dentry,
 }
 void audit_core_dumps(long signr);
 
-static inline void audit_seccomp(unsigned long syscall)
-{
-	if (unlikely(!audit_dummy_context()))
-		__audit_seccomp(syscall);
-}
-
 static inline void audit_ptrace(struct task_struct *t)
 {
 	if (unlikely(!audit_dummy_context()))
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index af1de0f..a5caecd 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2693,7 +2693,7 @@ static void audit_log_abend(struct audit_buffer *ab, char *reason, long signr)
  * @signr: signal value
  *
  * If a process ends with a core dump, something fishy is going on and we
- * should record the event for investigation.
+ * should record the event for investigation, if auditing is enabled.
  */
 void audit_core_dumps(long signr)
 {
@@ -2710,7 +2710,14 @@ void audit_core_dumps(long signr)
 	audit_log_end(ab);
 }
 
-void __audit_seccomp(unsigned long syscall)
+/**
+ * audit_seccomp - record information about processes that violate seccomp
+ * @syscall: syscall number that triggered the seccomp violation
+ *
+ * If a process violates its own seccomp rules, something has gone very
+ * wrong, and this event should always be reported for investigation.
+ */
+void audit_seccomp(unsigned long syscall)
 {
 	struct audit_buffer *ab;
 
-- 
1.7.0.4

-- 
Kees Cook
Chrome OS Security
