Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab2BTAVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:21:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57398 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2BTAVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:21:15 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 27/30] x32: Handle process creation
Date: Sun, 19 Feb 2012 16:08:05 -0800
Message-Id: <1329696488-16970-28-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:21:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Allow an x32 process to be started.

Originally-by: H. J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/include/asm/compat.h    |   26 ++++++++++++++++++++++++--
 arch/x86/include/asm/elf.h       |   25 +++++++++++++++++++++----
 arch/x86/kernel/cpu/perf_event.c |    4 +++-
 arch/x86/kernel/entry_64.S       |   15 +++++++++++++++
 arch/x86/kernel/process_64.c     |   23 ++++++++++++++++-------
 5 files changed, 79 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 7938b84..e7f68b4 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -6,6 +6,7 @@
  */
 #include <linux/types.h>
 #include <linux/sched.h>
+#include <asm/processor.h>
 #include <asm/user32.h>
 #include <asm/unistd.h>
 
@@ -187,7 +188,20 @@ struct compat_shmid64_ds {
 /*
  * The type of struct elf_prstatus.pr_reg in compatible core dumps.
  */
+#ifdef CONFIG_X86_X32_ABI
+typedef struct user_regs_struct compat_elf_gregset_t;
+
+#define PR_REG_SIZE(S) (test_thread_flag(TIF_IA32) ? 68 : 216)
+#define PRSTATUS_SIZE(S) (test_thread_flag(TIF_IA32) ? 144 : 296)
+#define SET_PR_FPVALID(S,V) \
+  do { *(int *) (((void *) &((S)->pr_reg)) + PR_REG_SIZE(0)) = (V); } \
+  while (0)
+
+#define COMPAT_USE_64BIT_TIME \
+	(!!(task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT))
+#else
 typedef struct user_regs_struct32 compat_elf_gregset_t;
+#endif
 
 /*
  * A pointer passed in from user mode. This should not
@@ -209,8 +223,16 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 
 static inline void __user *arch_compat_alloc_user_space(long len)
 {
-	struct pt_regs *regs = task_pt_regs(current);
-	return (void __user *)regs->sp - len;
+	compat_uptr_t sp;
+
+	if (test_thread_flag(TIF_IA32)) {
+		sp = task_pt_regs(current)->sp;
+	} else {
+		/* -128 for the x32 ABI redzone */
+		sp = percpu_read(old_rsp) - 128;
+	}
+
+	return (void __user *)round_down(sp - len, 16);
 }
 
 static inline bool is_compat_task(void)
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 410fa6a..83aabea 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -156,7 +156,12 @@ do {						\
 #define elf_check_arch(x)			\
 	((x)->e_machine == EM_X86_64)
 
-#define compat_elf_check_arch(x)	elf_check_arch_ia32(x)
+#define compat_elf_check_arch(x)		\
+	(elf_check_arch_ia32(x) || (x)->e_machine == EM_X86_64)
+
+#if __USER32_DS != __USER_DS
+# error "The following code assumes __USER32_DS == __USER_DS"
+#endif
 
 static inline void elf_common_init(struct thread_struct *t,
 				   struct pt_regs *regs, const u16 ds)
@@ -179,8 +184,9 @@ static inline void elf_common_init(struct thread_struct *t,
 void start_thread_ia32(struct pt_regs *regs, u32 new_ip, u32 new_sp);
 #define compat_start_thread start_thread_ia32
 
-void set_personality_ia32(void);
-#define COMPAT_SET_PERSONALITY(ex) set_personality_ia32()
+void set_personality_ia32(bool);
+#define COMPAT_SET_PERSONALITY(ex)			\
+	set_personality_ia32((ex).e_machine == EM_X86_64)
 
 #define COMPAT_ELF_PLATFORM			("i686")
 
@@ -296,9 +302,20 @@ do {									\
 			    (unsigned long)current->mm->context.vdso);	\
 } while (0)
 
+#define ARCH_DLINFO_X32							\
+do {									\
+	if (vdso_enabled)						\
+		NEW_AUX_ENT(AT_SYSINFO_EHDR,				\
+			    (unsigned long)current->mm->context.vdso);	\
+} while (0)
+
 #define AT_SYSINFO		32
 
-#define COMPAT_ARCH_DLINFO	ARCH_DLINFO_IA32(sysctl_vsyscall32)
+#define COMPAT_ARCH_DLINFO						\
+if (test_thread_flag(TIF_X32))						\
+	ARCH_DLINFO_X32;						\
+else									\
+	ARCH_DLINFO_IA32(sysctl_vsyscall32)
 
 #define COMPAT_ELF_ET_DYN_BASE	(TASK_UNMAPPED_BASE + 0x1000000)
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5adce10..63c0e05 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -28,7 +28,6 @@
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
 #include <asm/nmi.h>
-#include <asm/compat.h>
 #include <asm/smp.h>
 #include <asm/alternative.h>
 
@@ -1595,6 +1594,9 @@ perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 }
 
 #ifdef CONFIG_COMPAT
+
+#include <asm/compat.h>
+
 static inline int
 perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 {
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 53dc821..9e036f0 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -763,6 +763,21 @@ ENTRY(stub_x32_rt_sigreturn)
 	CFI_ENDPROC
 END(stub_x32_rt_sigreturn)
 
+ENTRY(stub_x32_execve)
+	CFI_STARTPROC
+	addq $8, %rsp
+	PARTIAL_FRAME 0
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %r11
+	movq %rsp, %rcx
+	call sys32_execve
+	RESTORE_TOP_OF_STACK %r11
+	movq %rax,RAX(%rsp)
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+	CFI_ENDPROC
+END(stub_x32_execve)
+
 #endif
 
 /*
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 5fe2fba..a0701da 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -364,7 +364,9 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 void start_thread_ia32(struct pt_regs *regs, u32 new_ip, u32 new_sp)
 {
 	start_thread_common(regs, new_ip, new_sp,
-			    __USER32_CS, __USER32_DS, __USER32_DS);
+			    test_thread_flag(TIF_X32)
+			    ? __USER_CS : __USER32_CS,
+			    __USER_DS, __USER_DS);
 }
 #endif
 
@@ -508,6 +510,7 @@ void set_personality_64bit(void)
 
 	/* Make sure to be in 64bit mode */
 	clear_thread_flag(TIF_IA32);
+	clear_thread_flag(TIF_X32);
 	clear_thread_flag(TIF_ADDR32);
 	clear_thread_flag(TIF_X32);
 
@@ -522,22 +525,28 @@ void set_personality_64bit(void)
 	current->personality &= ~READ_IMPLIES_EXEC;
 }
 
-void set_personality_ia32(void)
+void set_personality_ia32(bool x32)
 {
 	/* inherit personality from parent */
 
 	/* Make sure to be in 32bit mode */
-	set_thread_flag(TIF_IA32);
 	set_thread_flag(TIF_ADDR32);
-	clear_thread_flag(TIF_X32);
-	current->personality |= force_personality32;
 
 	/* Mark the associated mm as containing 32-bit tasks. */
 	if (current->mm)
 		current->mm->context.ia32_compat = 1;
 
-	/* Prepare the first "return" to user space */
-	current_thread_info()->status |= TS_COMPAT;
+	if (x32) {
+		clear_thread_flag(TIF_IA32);
+		set_thread_flag(TIF_X32);
+		current->personality &= ~READ_IMPLIES_EXEC;
+	} else {
+		set_thread_flag(TIF_IA32);
+		clear_thread_flag(TIF_X32);
+		current->personality |= force_personality32;
+		/* Prepare the first "return" to user space */
+		current_thread_info()->status |= TS_COMPAT;
+	}
 }
 
 unsigned long get_wchan(struct task_struct *p)
-- 
1.7.6.5

