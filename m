Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab2DZTpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:45:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56681 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab2DZTpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:45:06 -0400
Date: Thu, 26 Apr 2012 12:44:47 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-bf6266f9db57ee6fcbcb3e3da824dc6d33531720@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, lethal@linux-sh.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        lethal@linux-sh.org
In-Reply-To: <20120426173717.441890095@goodmis.org>
References: <20120426173717.441890095@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/ftrace] ftrace, x86:
  Remove the complex ftrace NMI handling code
Git-Commit-ID: bf6266f9db57ee6fcbcb3e3da824dc6d33531720
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Apr 2012 12:44:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf6266f9db57ee6fcbcb3e3da824dc6d33531720
Gitweb:     http://git.kernel.org/tip/bf6266f9db57ee6fcbcb3e3da824dc6d33531720
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Thu, 26 Apr 2012 13:34:06 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 26 Apr 2012 11:22:29 -0700

ftrace, x86: Remove the complex ftrace NMI handling code

As ftrace function tracing would require modifying code that could
be executed in NMI context, which is not stopped with stop_machine(),
ftrace had to do a complex algorithm with various stages of setup
and memory barriers to make it work.

With the new breakpoint method, this is no longer required. The changes
to the code can be done without any problem in NMI context, as well as
without stop machine altogether. Remove the complex code as it is
no longer needed.

Also, a lot of the notrace annotations could be removed from the
NMI code as it is now safe to trace them. With the exception of
do_nmi itself, which does some special work to handle running in
the debug stack. The breakpoint method can cause NMIs to double
nest the debug stack if it's not setup properly, and that is done
in do_nmi(), thus that function must not be traced.

(Note the arch sh may want to do the same)

Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20120426173717.441890095@goodmis.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig         |    1 -
 arch/x86/kernel/ftrace.c |  169 +---------------------------------------------
 arch/x86/kernel/nmi.c    |   10 ++--
 3 files changed, 6 insertions(+), 174 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d14cc6..1324139 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -40,7 +40,6 @@ config X86
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_GRAPH_FP_TEST
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 80af347..cf2d03e 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -27,38 +27,18 @@
 #include <asm/cacheflush.h>
 #include <asm/ftrace.h>
 #include <asm/nops.h>
-#include <asm/nmi.h>
-
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
-/*
- * modifying_code is set to notify NMIs that they need to use
- * memory barriers when entering or exiting. But we don't want
- * to burden NMIs with unnecessary memory barriers when code
- * modification is not being done (which is most of the time).
- *
- * A mutex is already held when ftrace_arch_code_modify_prepare
- * and post_process are called. No locks need to be taken here.
- *
- * Stop machine will make sure currently running NMIs are done
- * and new NMIs will see the updated variable before we need
- * to worry about NMIs doing memory barriers.
- */
-static int modifying_code __read_mostly;
-static DEFINE_PER_CPU(int, save_modifying_code);
-
 int ftrace_arch_code_modify_prepare(void)
 {
 	set_kernel_text_rw();
 	set_all_modules_text_rw();
-	modifying_code = 1;
 	return 0;
 }
 
 int ftrace_arch_code_modify_post_process(void)
 {
-	modifying_code = 0;
 	set_all_modules_text_ro();
 	set_kernel_text_ro();
 	return 0;
@@ -91,134 +71,6 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 	return calc.code;
 }
 
-/*
- * Modifying code must take extra care. On an SMP machine, if
- * the code being modified is also being executed on another CPU
- * that CPU will have undefined results and possibly take a GPF.
- * We use kstop_machine to stop other CPUS from exectuing code.
- * But this does not stop NMIs from happening. We still need
- * to protect against that. We separate out the modification of
- * the code to take care of this.
- *
- * Two buffers are added: An IP buffer and a "code" buffer.
- *
- * 1) Put the instruction pointer into the IP buffer
- *    and the new code into the "code" buffer.
- * 2) Wait for any running NMIs to finish and set a flag that says
- *    we are modifying code, it is done in an atomic operation.
- * 3) Write the code
- * 4) clear the flag.
- * 5) Wait for any running NMIs to finish.
- *
- * If an NMI is executed, the first thing it does is to call
- * "ftrace_nmi_enter". This will check if the flag is set to write
- * and if it is, it will write what is in the IP and "code" buffers.
- *
- * The trick is, it does not matter if everyone is writing the same
- * content to the code location. Also, if a CPU is executing code
- * it is OK to write to that code location if the contents being written
- * are the same as what exists.
- */
-
-#define MOD_CODE_WRITE_FLAG (1 << 31)	/* set when NMI should do the write */
-static atomic_t nmi_running = ATOMIC_INIT(0);
-static int mod_code_status;		/* holds return value of text write */
-static void *mod_code_ip;		/* holds the IP to write to */
-static const void *mod_code_newcode;	/* holds the text to write to the IP */
-
-static unsigned nmi_wait_count;
-static atomic_t nmi_update_count = ATOMIC_INIT(0);
-
-int ftrace_arch_read_dyn_info(char *buf, int size)
-{
-	int r;
-
-	r = snprintf(buf, size, "%u %u",
-		     nmi_wait_count,
-		     atomic_read(&nmi_update_count));
-	return r;
-}
-
-static void clear_mod_flag(void)
-{
-	int old = atomic_read(&nmi_running);
-
-	for (;;) {
-		int new = old & ~MOD_CODE_WRITE_FLAG;
-
-		if (old == new)
-			break;
-
-		old = atomic_cmpxchg(&nmi_running, old, new);
-	}
-}
-
-static void ftrace_mod_code(void)
-{
-	/*
-	 * Yes, more than one CPU process can be writing to mod_code_status.
-	 *    (and the code itself)
-	 * But if one were to fail, then they all should, and if one were
-	 * to succeed, then they all should.
-	 */
-	mod_code_status = probe_kernel_write(mod_code_ip, mod_code_newcode,
-					     MCOUNT_INSN_SIZE);
-
-	/* if we fail, then kill any new writers */
-	if (mod_code_status)
-		clear_mod_flag();
-}
-
-void ftrace_nmi_enter(void)
-{
-	__this_cpu_write(save_modifying_code, modifying_code);
-
-	if (!__this_cpu_read(save_modifying_code))
-		return;
-
-	if (atomic_inc_return(&nmi_running) & MOD_CODE_WRITE_FLAG) {
-		smp_rmb();
-		ftrace_mod_code();
-		atomic_inc(&nmi_update_count);
-	}
-	/* Must have previous changes seen before executions */
-	smp_mb();
-}
-
-void ftrace_nmi_exit(void)
-{
-	if (!__this_cpu_read(save_modifying_code))
-		return;
-
-	/* Finish all executions before clearing nmi_running */
-	smp_mb();
-	atomic_dec(&nmi_running);
-}
-
-static void wait_for_nmi_and_set_mod_flag(void)
-{
-	if (!atomic_cmpxchg(&nmi_running, 0, MOD_CODE_WRITE_FLAG))
-		return;
-
-	do {
-		cpu_relax();
-	} while (atomic_cmpxchg(&nmi_running, 0, MOD_CODE_WRITE_FLAG));
-
-	nmi_wait_count++;
-}
-
-static void wait_for_nmi(void)
-{
-	if (!atomic_read(&nmi_running))
-		return;
-
-	do {
-		cpu_relax();
-	} while (atomic_read(&nmi_running));
-
-	nmi_wait_count++;
-}
-
 static inline int
 within(unsigned long addr, unsigned long start, unsigned long end)
 {
@@ -239,26 +91,7 @@ do_ftrace_mod_code(unsigned long ip, const void *new_code)
 	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
 		ip = (unsigned long)__va(__pa(ip));
 
-	mod_code_ip = (void *)ip;
-	mod_code_newcode = new_code;
-
-	/* The buffers need to be visible before we let NMIs write them */
-	smp_mb();
-
-	wait_for_nmi_and_set_mod_flag();
-
-	/* Make sure all running NMIs have finished before we write the code */
-	smp_mb();
-
-	ftrace_mod_code();
-
-	/* Make sure the write happens before clearing the bit */
-	smp_mb();
-
-	clear_mod_flag();
-	wait_for_nmi();
-
-	return mod_code_status;
+	return probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE);
 }
 
 static const unsigned char *ftrace_nop_replace(void)
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 47acaf3..eb1539e 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -84,7 +84,7 @@ __setup("unknown_nmi_panic", setup_unknown_nmi_panic);
 
 #define nmi_to_desc(type) (&nmi_desc[type])
 
-static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
+static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
 	struct nmiaction *a;
@@ -209,7 +209,7 @@ void unregister_nmi_handler(unsigned int type, const char *name)
 
 EXPORT_SYMBOL_GPL(unregister_nmi_handler);
 
-static notrace __kprobes void
+static __kprobes void
 pci_serr_error(unsigned char reason, struct pt_regs *regs)
 {
 	pr_emerg("NMI: PCI system error (SERR) for reason %02x on CPU %d.\n",
@@ -236,7 +236,7 @@ pci_serr_error(unsigned char reason, struct pt_regs *regs)
 	outb(reason, NMI_REASON_PORT);
 }
 
-static notrace __kprobes void
+static __kprobes void
 io_check_error(unsigned char reason, struct pt_regs *regs)
 {
 	unsigned long i;
@@ -263,7 +263,7 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 	outb(reason, NMI_REASON_PORT);
 }
 
-static notrace __kprobes void
+static __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
 	int handled;
@@ -305,7 +305,7 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 static DEFINE_PER_CPU(bool, swallow_nmi);
 static DEFINE_PER_CPU(unsigned long, last_nmi_rip);
 
-static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
+static __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 	int handled;
