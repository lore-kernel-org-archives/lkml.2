Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2KLLuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:50:00 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:35800 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2KLLt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:49:57 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 33/55] ARC: ptrace support
Date: Mon, 12 Nov 2012 17:18:51 +0530
Message-ID: <1352720953-24321-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig              |    1 +
 arch/arc/include/asm/ptrace.h |   18 ++++-
 arch/arc/kernel/Makefile      |    3 +
 arch/arc/kernel/entry.S       |   69 +++++++++++++++++
 arch/arc/kernel/ptrace.c      |  164 ++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 251 insertions(+), 4 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 71e55c0..198c7d0 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -20,6 +20,7 @@ config ARC
 	select GENERIC_KERNEL_THREAD
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
 	select HOTPLUG if !INITRAMFS_SOURCE=""
 	select MODULES_USE_ELF_RELA
diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
index bc2229f..bb621e8 100644
--- a/arch/arc/include/asm/ptrace.h
+++ b/arch/arc/include/asm/ptrace.h
@@ -42,6 +42,8 @@
 #define PT_orig_r0	96
 #define PT_orig_r8	100
 
+#ifdef __KERNEL__
+
 #ifndef __ASSEMBLY__
 
 /* THE pt_regs: Defines how regs are saved during entry into kernel */
@@ -115,7 +117,6 @@ struct user_regs_struct {
 /* return 1 if user mode or 0 if kernel mode */
 #define user_mode(regs) (regs->status32 & STATUS_U_MASK)
 
-
 /* return 1 if in syscall, 0 if Intr or Exception */
 #define in_syscall(regs) (((regs->orig_r8) >= 0 && \
 			   (regs->orig_r8 <= NR_syscalls)) ? 1 : 0)
@@ -128,6 +129,19 @@ struct user_regs_struct {
 	(struct pt_regs *)(pg_start + THREAD_SIZE - 4) - 1;	\
 })
 
-#endif /* __ASSEMBLY__ */
+#define in_brkpt_trap(regs) (((regs->orig_r8) == (NR_syscalls + 2)) ? 1 : 0)
+
+#define user_stack_pointer(regs)\
+({  unsigned int sp;		\
+	if (user_mode(regs))	\
+		sp = (regs)->sp;\
+	else			\
+		sp = -1;	\
+	sp;			\
+})
+
+#endif /* !__ASSEMBLY__ */
+
+#endif	/* __KERNEL__ */
 
 #endif /* __ASM_PTRACE_H */
diff --git a/arch/arc/kernel/Makefile b/arch/arc/kernel/Makefile
index 47f6b33..4ddef9a 100644
--- a/arch/arc/kernel/Makefile
+++ b/arch/arc/kernel/Makefile
@@ -5,6 +5,9 @@
 # it under the terms of the GNU General Public License version 2 as
 # published by the Free Software Foundation.
 
+# Pass UTS_MACHINE for user_regset definition
+CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
+
 obj-y	:= arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o \
 	   signal.o traps.o sys.o troubleshoot.o stacktrace.o
 
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 35406da..93cde5e 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -10,6 +10,14 @@
  * TBD:
  *  -remove the low level wrappers for execve/fork/vfork
  *   needed before task_pt_regs was invented. This saves a branch per call
+ *   and more importantly allows clean invocation of post-syscall ptrace hook
+ *
+ * vineetg: Feb 2011 (ptrace low level code fixes)
+ *  -traced syscall return code (r0) was not saved into pt_regs for restoring
+ *   into user reg-file when traded task rets to user space.
+ *  -syscalls needing arch-wrappers (mainly for passing sp as pt_regs)
+ *   were not invoking post-syscall trace hook (jumping directly into
+ *   ret_from_system_call)
  *
  * vineetg: Nov 2010:
  *  -Vector table jumps (@8 bytes) converted into branches (@4 bytes)
@@ -351,6 +359,50 @@ ARC_ENTRY EV_Extension
 	b   ret_from_exception
 ARC_EXIT EV_Extension
 
+;######################### System Call Tracing #########################
+
+tracesys:
+	; save EFA in case tracer wants the PC of traced task
+	; using ERET won't work since next-PC has already committed
+	lr  r12, [efa]
+	GET_CURR_TASK_FIELD_PTR   TASK_THREAD, r11
+	st  r12, [r11, THREAD_FAULT_ADDR]
+
+	; PRE Sys Call Ptrace hook
+	mov r0, sp			; pt_regs needed
+	bl  @syscall_trace_entry
+
+	; Tracing code now returns the syscall num (orig or modif)
+	mov r8, r0
+
+	; Do the Sys Call as we normally would.
+	; Validate the Sys Call number
+	cmp     r8,  NR_syscalls
+	mov.hi  r0, -ENOSYS
+	bhi     tracesys_exit
+
+	; Restore the sys-call args. Mere invocation of the hook abv could have
+	; clobbered them (since they are in scratch regs). The tracer could also
+	; have deliberately changed the syscall args: r0-r7
+	ld  r0, [sp, PT_r0]
+	ld  r1, [sp, PT_r1]
+	ld  r2, [sp, PT_r2]
+	ld  r3, [sp, PT_r3]
+	ld  r4, [sp, PT_r4]
+	ld  r5, [sp, PT_r5]
+	ld  r6, [sp, PT_r6]
+	ld  r7, [sp, PT_r7]
+	ld.as   r9, [sys_call_table, r8]
+	jl      [r9]        ; Entry into Sys Call Handler
+
+tracesys_exit:
+	st  r0, [sp, PT_r0]     ; sys call return value in pt_regs
+
+	;POST Sys Call Ptrace Hook
+	bl  @syscall_trace_exit
+	b   ret_from_exception ; NOT ret_from_system_call at is saves r0 which
+	; we'd done before calling post hook above
+
 ;################### Break Point TRAP ##########################
 
 	; ======= (5b) Trap is due to Break-Point =========
@@ -416,6 +468,11 @@ ARC_ENTRY EV_Trap
 	; Before doing anything, return from CPU Exception Mode
 	FAKE_RET_FROM_EXCPN r11
 
+	; If syscall tracing ongoing, invoke pre-pos-hooks
+	GET_CURR_THR_INFO_FLAGS   r10
+	btst r10, TIF_SYSCALL_TRACE
+	bnz tracesys  ; this never comes back
+
 	;============ This is normal System Call case ==========
 	; Sys-call num shd not exceed the total system calls avail
 	cmp     r8,  NR_syscalls
@@ -621,6 +678,10 @@ ARC_ENTRY sys_fork_wrapper
 	bl  @sys_fork
 	DISCARD_CALLEE_SAVED_USER
 
+	GET_CURR_THR_INFO_FLAGS   r10
+	btst r10, TIF_SYSCALL_TRACE
+	bnz  tracesys_exit
+
 	b ret_from_system_call
 ARC_EXIT sys_fork_wrapper
 
@@ -631,6 +692,10 @@ ARC_ENTRY sys_vfork_wrapper
 	bl  @sys_vfork
 	DISCARD_CALLEE_SAVED_USER
 
+	GET_CURR_THR_INFO_FLAGS   r10
+	btst r10, TIF_SYSCALL_TRACE
+	bnz  tracesys_exit
+
 	b ret_from_system_call
 ARC_EXIT sys_vfork_wrapper
 
@@ -645,5 +710,9 @@ ARC_ENTRY sys_clone_wrapper
 	bl  @sys_clone
 	DISCARD_CALLEE_SAVED_USER
 
+	GET_CURR_THR_INFO_FLAGS   r10
+	btst r10, TIF_SYSCALL_TRACE
+	bnz  tracesys_exit
+
 	b ret_from_system_call
 ARC_EXIT sys_clone_wrapper
diff --git a/arch/arc/kernel/ptrace.c b/arch/arc/kernel/ptrace.c
index 1cf944a..93c7420 100644
--- a/arch/arc/kernel/ptrace.c
+++ b/arch/arc/kernel/ptrace.c
@@ -7,6 +7,122 @@
  */
 
 #include <linux/ptrace.h>
+#include <linux/tracehook.h>
+#include <linux/regset.h>
+#include <linux/unistd.h>
+#include <linux/elf.h>
+
+static struct callee_regs *task_callee_regs(struct task_struct *tsk)
+{
+	struct callee_regs *tmp = (struct callee_regs *)tsk->thread.callee_reg;
+	return tmp;
+}
+
+static int genregs_get(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       void *kbuf, void __user *ubuf)
+{
+	const struct pt_regs *ptregs = task_pt_regs(target);
+	const struct callee_regs *cregs = task_callee_regs(target);
+	int ret = 0;
+	unsigned int stop_pc_val;
+
+#define REG_O_CHUNK(START, END, PTR)	\
+	if (!ret)	\
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, PTR, \
+			offsetof(struct user_regs_struct, START), \
+			offsetof(struct user_regs_struct, END));
+
+#define REG_O_ONE(LOC, PTR)	\
+	if (!ret)		\
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, PTR, \
+			offsetof(struct user_regs_struct, LOC), \
+			offsetof(struct user_regs_struct, LOC) + 4);
+
+	REG_O_CHUNK(scratch, callee, ptregs);
+	REG_O_CHUNK(callee, efa, cregs);
+	REG_O_CHUNK(efa, stop_pc, &target->thread.fault_address);
+
+	if (!ret) {
+		if (in_brkpt_trap(ptregs)) {
+			stop_pc_val = target->thread.fault_address;
+			pr_debug("\t\tstop_pc (brk-pt)\n");
+		} else {
+			stop_pc_val = ptregs->ret;
+			pr_debug("\t\tstop_pc (others)\n");
+		}
+
+		REG_O_ONE(stop_pc, &stop_pc_val);
+	}
+
+	return ret;
+}
+
+static int genregs_set(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       const void *kbuf, const void __user *ubuf)
+{
+	const struct pt_regs *ptregs = task_pt_regs(target);
+	const struct callee_regs *cregs = task_callee_regs(target);
+	int ret = 0;
+
+#define REG_IN_CHUNK(FIRST, NEXT, PTR)	\
+	if (!ret)			\
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, \
+			(void *)(PTR), \
+			offsetof(struct user_regs_struct, FIRST), \
+			offsetof(struct user_regs_struct, NEXT));
+
+#define REG_IN_ONE(LOC, PTR)		\
+	if (!ret)			\
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, \
+			(void *)(PTR), \
+			offsetof(struct user_regs_struct, LOC), \
+			offsetof(struct user_regs_struct, LOC) + 4);
+
+#define REG_IGNORE_ONE(LOC)		\
+	if (!ret)			\
+		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf, \
+			offsetof(struct user_regs_struct, LOC), \
+			offsetof(struct user_regs_struct, LOC) + 4);
+
+	/* TBD: disallow updates to STATUS32, orig_r8 etc*/
+	REG_IN_CHUNK(scratch, callee, ptregs);	/* pt_regs[bta..orig_r8] */
+	REG_IN_CHUNK(callee, efa, cregs);	/* callee_regs[r25..r13] */
+	REG_IGNORE_ONE(efa);			/* efa update invalid */
+	REG_IN_ONE(stop_pc, &ptregs->ret);	/* stop_pc: PC update */
+
+	return ret;
+}
+
+enum arc_getset {
+	REGSET_GENERAL,
+};
+
+static const struct user_regset arc_regsets[] = {
+	[REGSET_GENERAL] = {
+	       .core_note_type = NT_PRSTATUS,
+	       .n = ELF_NGREG,
+	       .size = sizeof(unsigned long),
+	       .align = sizeof(unsigned long),
+	       .get = genregs_get,
+	       .set = genregs_set,
+	}
+};
+
+static const struct user_regset_view user_arc_view = {
+	.name		= UTS_MACHINE,
+	.e_machine	= EM_ARCOMPACT,
+	.regsets	= arc_regsets,
+	.n		= ARRAY_SIZE(arc_regsets)
+};
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+	return &user_arc_view;
+}
 
 void ptrace_disable(struct task_struct *child)
 {
@@ -16,11 +132,55 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret = -EIO;
+	unsigned int count, pos;
+	unsigned int __user *u_addr;
+	void *kbuf;
+
+	pr_debug("REQ=%ld: ADDR =0x%lx, DATA=0x%lx)\n", request, addr, data);
+
+	switch (request) {
+
+	case PTRACE_PEEKUSR:
+		pos = addr;	/* offset in struct user_regs_struct */
+		count = 4;	/* 1 register only */
+		u_addr = (unsigned int __user *)data;
+		kbuf = NULL;
+		ret = genregs_get(child, NULL, pos, count, kbuf, u_addr);
+		break;
+
+	case PTRACE_POKEUSR:
+		pos = addr;	/* offset in struct user_regs_struct */
+		count = 4;	/* 1 register only */
+
+		/* Ideally @data would have abeen a user space buffer, from
+		 * where, we do a copy_from_user.
+		 * However this request only involves one word, which courtesy
+		 * our ABI can be passed in a reg.
+		 * regset interface however expects some buffer to copyin from
+		 */
+		kbuf = &data;
+		u_addr = NULL;
+
+		ret = genregs_set(child, NULL, pos, count, kbuf, u_addr);
+		break;
+
+	default:
+		ret = ptrace_request(child, request, addr, data);
+		break;
+	}
+
 	return ret;
 }
 
+asmlinkage int syscall_trace_entry(struct pt_regs *regs)
+{
+	if (tracehook_report_syscall_entry(regs))
+		return ULONG_MAX;
 
-const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+	return regs->r8;
+}
+
+asmlinkage void syscall_trace_exit(struct pt_regs *regs)
 {
-	return (const struct user_regset_view *)NULL;
+	tracehook_report_syscall_exit(regs, 0);
 }
-- 
1.7.4.1

