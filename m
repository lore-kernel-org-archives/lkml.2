Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab2CLJcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 05:32:09 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:37178 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab2CLJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 05:32:05 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 12 Mar 2012 14:55:55 +0530
Message-Id: <20120312092555.5379.942.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20120312092514.5379.36595.sendpatchset@srdronam.in.ibm.com>
References: <20120312092514.5379.36595.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v2 4/7] x86/trivial: Rename trap_no to trap_nr in thread struct.
x-cbid: 12031209-8878-0000-0000-0000019E8380
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

There are precedences of trap number being referred to as trap_nr.
However thread struct refers trap number as trap_no. Change it to trap_nr.

Also use enum instead of left-over literals for trap values.

This is pure cleanup, no functional change intended.

Suggested-by: Ingo Molnar <mingo@eltu.hu>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/x86/ia32/ia32_signal.c      |    2 +-
 arch/x86/include/asm/processor.h |    2 +-
 arch/x86/kernel/dumpstack.c      |    2 +-
 arch/x86/kernel/ptrace.c         |    3 ++-
 arch/x86/kernel/signal.c         |    2 +-
 arch/x86/kernel/traps.c          |   16 ++++++++--------
 arch/x86/kernel/vm86_32.c        |    2 +-
 arch/x86/kernel/vsyscall_64.c    |    2 +-
 arch/x86/math-emu/fpu_entry.c    |    4 ++--
 arch/x86/mm/fault.c              |   10 +++++-----
 10 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 7d4dba9..135cd12 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -346,7 +346,7 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
 		put_user_ex(regs->dx, &sc->dx);
 		put_user_ex(regs->cx, &sc->cx);
 		put_user_ex(regs->ax, &sc->ax);
-		put_user_ex(current->thread.trap_no, &sc->trapno);
+		put_user_ex(current->thread.trap_nr, &sc->trapno);
 		put_user_ex(current->thread.error_code, &sc->err);
 		put_user_ex(regs->ip, &sc->ip);
 		put_user_ex(regs->cs, (unsigned int __user *)&sc->cs);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c59ff02..09ffc86 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -454,7 +454,7 @@ struct thread_struct {
 	unsigned long           ptrace_dr7;
 	/* Fault info: */
 	unsigned long		cr2;
-	unsigned long		trap_no;
+	unsigned long		trap_nr;
 	unsigned long		error_code;
 	/* floating point and extended processor state */
 	struct fpu		fpu;
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 4025fe4..28f9870 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -265,7 +265,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 #endif
 	printk("\n");
 	if (notify_die(DIE_OOPS, str, regs, err,
-			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
+			current->thread.trap_nr, SIGSEGV) == NOTIFY_STOP)
 		return 1;
 
 	show_registers(regs);
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index d14b3cd..52c06b1 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -34,6 +34,7 @@
 #include <asm/prctl.h>
 #include <asm/proto.h>
 #include <asm/hw_breakpoint.h>
+#include <asm/traps.h>
 
 #include "tls.h"
 
@@ -1426,7 +1427,7 @@ static void fill_sigtrap_info(struct task_struct *tsk,
 				int error_code, int si_code,
 				struct siginfo *info)
 {
-	tsk->thread.trap_no = 1;
+	tsk->thread.trap_nr = X86_TRAP_DB;
 	tsk->thread.error_code = error_code;
 
 	memset(info, 0, sizeof(*info));
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 5134e17..115eac4 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -151,7 +151,7 @@ int setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 		put_user_ex(regs->r15, &sc->r15);
 #endif /* CONFIG_X86_64 */
 
-		put_user_ex(current->thread.trap_no, &sc->trapno);
+		put_user_ex(current->thread.trap_nr, &sc->trapno);
 		put_user_ex(current->thread.error_code, &sc->err);
 		put_user_ex(regs->ip, &sc->ip);
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 4310189..19a2b83 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -133,7 +133,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 trap_signal:
 #endif
 	/*
-	 * We want error_code and trap_no set for userspace faults and
+	 * We want error_code and trap_nr set for userspace faults and
 	 * kernelspace faults which result in die(), but not
 	 * kernelspace faults which are fixed up.  die() gives the
 	 * process no chance to handle the signal and notice the
@@ -142,7 +142,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	 * delivered, faults.  See also do_general_protection below.
 	 */
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = trapnr;
+	tsk->thread.trap_nr = trapnr;
 
 #ifdef CONFIG_X86_64
 	if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
@@ -165,7 +165,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 kernel_trap:
 	if (!fixup_exception(regs)) {
 		tsk->thread.error_code = error_code;
-		tsk->thread.trap_no = trapnr;
+		tsk->thread.trap_nr = trapnr;
 		die(str, regs, error_code);
 	}
 	return;
@@ -241,7 +241,7 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	notify_die(DIE_TRAP, str, regs, error_code, X86_TRAP_DF, SIGSEGV);
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = X86_TRAP_DF;
+	tsk->thread.trap_nr = X86_TRAP_DF;
 
 	/*
 	 * This is always a kernel trap and never fixable (and thus must
@@ -269,7 +269,7 @@ do_general_protection(struct pt_regs *regs, long error_code)
 		goto gp_in_kernel;
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = X86_TRAP_GP;
+	tsk->thread.trap_nr = X86_TRAP_GP;
 
 	if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
 			printk_ratelimit()) {
@@ -296,7 +296,7 @@ do_general_protection(struct pt_regs *regs, long error_code)
 		return;
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = X86_TRAP_GP;
+	tsk->thread.trap_nr = X86_TRAP_GP;
 	if (notify_die(DIE_GPF, "general protection fault", regs, error_code,
 			X86_TRAP_GP, SIGSEGV) == NOTIFY_STOP)
 		return;
@@ -476,7 +476,7 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	{
 		if (!fixup_exception(regs)) {
 			task->thread.error_code = error_code;
-			task->thread.trap_no = trapnr;
+			task->thread.trap_nr = trapnr;
 			die(str, regs, error_code);
 		}
 		return;
@@ -486,7 +486,7 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	 * Save the info for the exception handler and clear the error.
 	 */
 	save_init_fpu(task);
-	task->thread.trap_no = trapnr;
+	task->thread.trap_nr = trapnr;
 	task->thread.error_code = error_code;
 	info.si_signo = SIGFPE;
 	info.si_errno = 0;
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index b466cab..a1315ab 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -567,7 +567,7 @@ int handle_vm86_trap(struct kernel_vm86_regs *regs, long error_code, int trapno)
 	}
 	if (trapno != 1)
 		return 1; /* we let this handle by the calling routine */
-	current->thread.trap_no = trapno;
+	current->thread.trap_nr = trapno;
 	current->thread.error_code = error_code;
 	force_sig(SIGTRAP, current);
 	return 0;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index b07ba93..327509b 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -153,7 +153,7 @@ static bool write_ok_or_segv(unsigned long ptr, size_t size)
 
 		thread->error_code	= 6;  /* user fault, no page, write */
 		thread->cr2		= ptr;
-		thread->trap_no		= 14;
+		thread->trap_nr		= X86_TRAP_PF;
 
 		memset(&info, 0, sizeof(info));
 		info.si_signo		= SIGSEGV;
diff --git a/arch/x86/math-emu/fpu_entry.c b/arch/x86/math-emu/fpu_entry.c
index 7718541..0feeca4 100644
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -269,7 +269,7 @@ void math_emulate(struct math_emu_info *info)
 			FPU_EIP = FPU_ORIG_EIP;	/* Point to current FPU instruction. */
 
 			RE_ENTRANT_CHECK_OFF;
-			current->thread.trap_no = 16;
+			current->thread.trap_nr = X86_TRAP_MF;
 			current->thread.error_code = 0;
 			send_sig(SIGFPE, current, 1);
 			return;
@@ -662,7 +662,7 @@ static int valid_prefix(u_char *Byte, u_char __user **fpu_eip,
 void math_abort(struct math_emu_info *info, unsigned int signal)
 {
 	FPU_EIP = FPU_ORIG_EIP;
-	current->thread.trap_no = 16;
+	current->thread.trap_nr = X86_TRAP_MF;
 	current->thread.error_code = 0;
 	send_sig(signal, current, 1);
 	RE_ENTRANT_CHECK_OFF;
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f0b4caf..3ecfd1a 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -615,7 +615,7 @@ pgtable_bad(struct pt_regs *regs, unsigned long error_code,
 	dump_pagetable(address);
 
 	tsk->thread.cr2		= address;
-	tsk->thread.trap_no	= 14;
+	tsk->thread.trap_nr	= X86_TRAP_PF;
 	tsk->thread.error_code	= error_code;
 
 	if (__die("Bad pagetable", regs, error_code))
@@ -636,7 +636,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	/* Are we prepared to handle this kernel fault? */
 	if (fixup_exception(regs)) {
 		if (current_thread_info()->sig_on_uaccess_error && signal) {
-			tsk->thread.trap_no = 14;
+			tsk->thread.trap_nr = X86_TRAP_PF;
 			tsk->thread.error_code = error_code | PF_USER;
 			tsk->thread.cr2 = address;
 
@@ -676,7 +676,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 		printk(KERN_EMERG "Thread overran stack, or stack corrupted\n");
 
 	tsk->thread.cr2		= address;
-	tsk->thread.trap_no	= 14;
+	tsk->thread.trap_nr	= X86_TRAP_PF;
 	tsk->thread.error_code	= error_code;
 
 	sig = SIGKILL;
@@ -754,7 +754,7 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 		/* Kernel addresses are always protection faults: */
 		tsk->thread.cr2		= address;
 		tsk->thread.error_code	= error_code | (address >= TASK_SIZE);
-		tsk->thread.trap_no	= 14;
+		tsk->thread.trap_nr	= X86_TRAP_PF;
 
 		force_sig_info_fault(SIGSEGV, si_code, address, tsk, 0);
 
@@ -838,7 +838,7 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 
 	tsk->thread.cr2		= address;
 	tsk->thread.error_code	= error_code;
-	tsk->thread.trap_no	= 14;
+	tsk->thread.trap_nr	= X86_TRAP_PF;
 
 #ifdef CONFIG_MEMORY_FAILURE
 	if (fault & (VM_FAULT_HWPOISON|VM_FAULT_HWPOISON_LARGE)) {


