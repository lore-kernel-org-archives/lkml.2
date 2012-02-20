Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab2BTAR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:17:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57317 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2BTAR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:17:56 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 20/30] x86: Move some signal-handling definitions to a common header
Date: Sun, 19 Feb 2012 16:07:58 -0800
Message-Id: <1329696488-16970-21-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:17:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

There are some definitions which are duplicated between
kernel/signal.c and ia32/ia32_signal.c; move them to a common header
file.

Rather than adding stuff to existing header files which contain data
structures, create a new header file; hence the slightly odd name
("all the good ones were taken.")

Note: nothing relied on signal_fault() being defined in
<asm/ptrace.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/ia32/ia32_signal.c        |   12 ++----------
 arch/x86/include/asm/ptrace.h      |    1 -
 arch/x86/include/asm/sighandling.h |   19 +++++++++++++++++++
 arch/x86/kernel/signal.c           |   10 +---------
 4 files changed, 22 insertions(+), 20 deletions(-)
 create mode 100644 arch/x86/include/asm/sighandling.h

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 6557769..25d80f3 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -12,10 +12,8 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/kernel.h>
-#include <linux/signal.h>
 #include <linux/errno.h>
 #include <linux/wait.h>
-#include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
 #include <linux/personality.h>
@@ -31,16 +29,10 @@
 #include <asm/proto.h>
 #include <asm/vdso.h>
 #include <asm/sigframe.h>
+#include <asm/sighandling.h>
 #include <asm/sys_ia32.h>
 
-#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
-
-#define FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
-			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
-			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
-			 X86_EFLAGS_CF)
-
-void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
+#define FIX_EFLAGS	__FIX_EFLAGS
 
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 3566454..dcfde52 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -145,7 +145,6 @@ extern unsigned long
 convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code, int si_code);
-void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
 extern long syscall_trace_enter(struct pt_regs *);
 extern void syscall_trace_leave(struct pt_regs *);
diff --git a/arch/x86/include/asm/sighandling.h b/arch/x86/include/asm/sighandling.h
new file mode 100644
index 0000000..843e299
--- /dev/null
+++ b/arch/x86/include/asm/sighandling.h
@@ -0,0 +1,19 @@
+#ifndef _ASM_X86_SIGHANDLING_H
+#define _ASM_X86_SIGHANDLING_H
+
+#include <linux/compiler.h>
+#include <linux/ptrace.h>
+#include <linux/signal.h>
+
+#include <asm/processor-flags.h>
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
+#define __FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
+			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
+			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
+			 X86_EFLAGS_CF)
+
+void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
+
+#endif /* _ASM_X86_SIGHANDLING_H */
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 46a01bd..c432dc0 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -10,10 +10,8 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/kernel.h>
-#include <linux/signal.h>
 #include <linux/errno.h>
 #include <linux/wait.h>
-#include <linux/ptrace.h>
 #include <linux/tracehook.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
@@ -26,6 +24,7 @@
 #include <asm/i387.h>
 #include <asm/vdso.h>
 #include <asm/mce.h>
+#include <asm/sighandling.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/proto.h>
@@ -37,13 +36,6 @@
 
 #include <asm/sigframe.h>
 
-#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
-
-#define __FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
-			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
-			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
-			 X86_EFLAGS_CF)
-
 #ifdef CONFIG_X86_32
 # define FIX_EFLAGS	(__FIX_EFLAGS | X86_EFLAGS_RF)
 #else
-- 
1.7.6.5

