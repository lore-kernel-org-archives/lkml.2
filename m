Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab2HJIat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 04:30:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42320 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab2HJI3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 04:29:45 -0400
From: Alex Kelly <alex.page.kelly@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Alex Kelly <alex.page.kelly@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCHv4 3/3] fs: Update coredump-related headers
Date: Fri, 10 Aug 2012 01:26:09 -0700
Message-Id: <1344587169-18682-3-git-send-email-alex.page.kelly@gmail.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1344587169-18682-1-git-send-email-alex.page.kelly@gmail.com>
References: <1344587169-18682-1-git-send-email-alex.page.kelly@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a new header file, fs/coredump.h, which contains
functions only used by the new coredump.c. It also moves do_coredump
to the include/linux/coredump.h header file, for consistency.

Signed-off-by: Alex Kelly <alex.page.kelly@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/coredump.c            | 2 ++
 fs/coredump.h            | 6 ++++++
 fs/exec.c                | 1 +
 include/linux/binfmts.h  | 5 -----
 include/linux/coredump.h | 5 +++++
 include/linux/sched.h    | 1 -
 kernel/signal.c          | 1 +
 7 files changed, 15 insertions(+), 6 deletions(-)
 create mode 100644 fs/coredump.h

diff --git a/fs/coredump.c b/fs/coredump.c
index 9692329..1935b4d 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -14,6 +14,7 @@
 #include <linux/key.h>
 #include <linux/personality.h>
 #include <linux/binfmts.h>
+#include <linux/coredump.h>
 #include <linux/utsname.h>
 #include <linux/pid_namespace.h>
 #include <linux/module.h>
@@ -39,6 +40,7 @@
 
 #include <trace/events/task.h>
 #include "internal.h"
+#include "coredump.h"
 
 #include <trace/events/sched.h>
 
diff --git a/fs/coredump.h b/fs/coredump.h
new file mode 100644
index 0000000..e39ff07
--- /dev/null
+++ b/fs/coredump.h
@@ -0,0 +1,6 @@
+#ifndef _FS_COREDUMP_H
+#define _FS_COREDUMP_H
+
+extern int __get_dumpable(unsigned long mm_flags);
+
+#endif
diff --git a/fs/exec.c b/fs/exec.c
index b604050..a0ad3a2 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -63,6 +63,7 @@
 
 #include <trace/events/task.h>
 #include "internal.h"
+#include "coredump.h"
 
 #include <trace/events/sched.h>
 
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 00e2e89..c7b16ee 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -132,11 +132,6 @@ extern int copy_strings_kernel(int argc, const char *const *argv,
 			       struct linux_binprm *bprm);
 extern int prepare_bprm_creds(struct linux_binprm *bprm);
 extern void install_exec_creds(struct linux_binprm *bprm);
-#ifdef CONFIG_COREDUMP
-extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
-#else
-static inline void do_coredump(long signr, int exit_code, struct pt_regs *regs) {}
-#endif
 extern void set_binfmt(struct linux_binfmt *new);
 extern void free_bprm(struct linux_binprm *);
 
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index ba4b85a..42f9752 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -11,5 +11,10 @@
  */
 extern int dump_write(struct file *file, const void *addr, int nr);
 extern int dump_seek(struct file *file, loff_t off);
+#ifdef CONFIG_COREDUMP
+extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
+#else
+static inline void do_coredump(long signr, int exit_code, struct pt_regs *regs) {}
+#endif
 
 #endif /* _LINUX_COREDUMP_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7bb5047..c147e70 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -413,7 +413,6 @@ static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
 
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
-extern int __get_dumpable(unsigned long mm_flags);
 
 /* get/set_dumpable() values */
 #define SUID_DUMPABLE_DISABLED	0
diff --git a/kernel/signal.c b/kernel/signal.c
index be4f856..fb4fd72 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #include <linux/tty.h>
 #include <linux/binfmts.h>
+#include <linux/coredump.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/ptrace.h>
-- 
1.7.11.2

