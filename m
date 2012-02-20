Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab2BTATm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:19:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57356 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab2BTATk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:19:40 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 24/30] x32: Handle the x32 system call flag
Date: Sun, 19 Feb 2012 16:08:02 -0800
Message-Id: <1329696488-16970-25-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:19:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

x32 shares most system calls with x86-64, but unfortunately some
subsystem (the input subsystem is the chief offender) which require
is_compat() when operating with a 32-bit userspace.  The input system
actually has text files in sysfs whose meaning is dependent on
sizeof(long) in userspace!

We could solve this by having two completely disjoint system call
tables; requiring that each system call be duplicated.  This patch
takes a different approach: we add a flag to the system call number;
this flag doesn't affect the system call dispatch but requests compat
treatment from affected subsystems for the duration of the system call.

The change of cmpq to cmpl is safe since it immediately follows the
and.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/compat.h  |   13 +++++++++++--
 arch/x86/include/asm/syscall.h |    5 +++--
 arch/x86/include/asm/unistd.h  |    7 +++++++
 arch/x86/kernel/entry_64.S     |   10 ++++++++++
 4 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 30d737e..7938b84 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <asm/user32.h>
+#include <asm/unistd.h>
 
 #define COMPAT_USER_HZ		100
 #define COMPAT_UTS_MACHINE	"i686\0\0"
@@ -212,9 +213,17 @@ static inline void __user *arch_compat_alloc_user_space(long len)
 	return (void __user *)regs->sp - len;
 }
 
-static inline int is_compat_task(void)
+static inline bool is_compat_task(void)
 {
-	return current_thread_info()->status & TS_COMPAT;
+#ifdef CONFIG_IA32_EMULATION
+	if (current_thread_info()->status & TS_COMPAT)
+		return true;
+#endif
+#ifdef CONFIG_X86_X32_ABI
+	if (task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT)
+		return true;
+#endif
+	return false;
 }
 
 #endif /* _ASM_X86_COMPAT_H */
diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index d962e56..386b786 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -16,6 +16,7 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <asm/asm-offsets.h>	/* For NR_syscalls */
+#include <asm/unistd.h>
 
 extern const unsigned long sys_call_table[];
 
@@ -26,13 +27,13 @@ extern const unsigned long sys_call_table[];
  */
 static inline int syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
 {
-	return regs->orig_ax;
+	return regs->orig_ax & __SYSCALL_MASK;
 }
 
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
-	regs->ax = regs->orig_ax;
+	regs->ax = regs->orig_ax & __SYSCALL_MASK;
 }
 
 static inline long syscall_get_error(struct task_struct *task,
diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index 7a48a55..37cdc9d 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -5,6 +5,13 @@
 #define __X32_SYSCALL_BIT	0x40000000
 
 #ifdef __KERNEL__
+
+# ifdef CONFIG_X86_X32_ABI
+#  define __SYSCALL_MASK (~(__X32_SYSCALL_BIT))
+# else
+#  define __SYSCALL_MASK (~0)
+# endif
+
 # ifdef CONFIG_X86_32
 
 #  include <asm/unistd_32.h>
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3fe8239..a17b342 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -482,7 +482,12 @@ GLOBAL(system_call_after_swapgs)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz tracesys
 system_call_fastpath:
+#if __SYSCALL_MASK == ~0
 	cmpq $__NR_syscall_max,%rax
+#else
+	andl $__SYSCALL_MASK,%eax
+	cmpl $__NR_syscall_max,%eax
+#endif
 	ja badsys
 	movq %r10,%rcx
 	call *sys_call_table(,%rax,8)  # XXX:	 rip relative
@@ -596,7 +601,12 @@ tracesys:
 	 */
 	LOAD_ARGS ARGOFFSET, 1
 	RESTORE_REST
+#if __SYSCALL_MASK == ~0
 	cmpq $__NR_syscall_max,%rax
+#else
+	andl $__SYSCALL_MASK,%eax
+	cmpl $__NR_syscall_max,%eax
+#endif
 	ja   int_ret_from_sys_call	/* RAX(%rsp) set to -ENOSYS above */
 	movq %r10,%rcx	/* fixup for C */
 	call *sys_call_table(,%rax,8)
-- 
1.7.6.5

