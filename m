Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab2EIIzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:55:43 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41880 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758824Ab2EIIz1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 9 May 2012 04:55:27 -0400
Message-Id: <4FAA3D3902000078000826E1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 09 May 2012 08:47:37 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] x86: avoid double stack traces with
 show_regs()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What was called show_registers() so far already showed a stack trace
for kernel faults, and kernel_stack_pointer() isn't even valid to be
used for faults from user mode, hence it was pointless for show_regs()
to call show_trace() after show_registers(). Simply rename
show_registers() to show_regs() and eliminate the old definition.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/include/asm/kdebug.h  |    1 -
 arch/x86/kernel/dumpstack.c    |    2 +-
 arch/x86/kernel/dumpstack_32.c |    2 +-
 arch/x86/kernel/dumpstack_64.c |    2 +-
 arch/x86/kernel/kprobes.c      |    4 ++--
 arch/x86/kernel/nmi.c          |    2 +-
 arch/x86/kernel/process.c      |    6 ------
 7 files changed, 6 insertions(+), 13 deletions(-)

--- 3.4-rc6/arch/x86/include/asm/kdebug.h
+++ 3.4-rc6-x86-no-show_registers/arch/x86/include/asm/kdebug.h
@@ -24,7 +24,6 @@ enum die_val {
 extern void printk_address(unsigned long address, int reliable);
 extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
-extern void show_registers(struct pt_regs *regs);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
 		       unsigned long *sp, unsigned long bp);
 extern void __show_regs(struct pt_regs *regs, int all);
--- 3.4-rc6/arch/x86/kernel/dumpstack.c
+++ 3.4-rc6-x86-no-show_registers/arch/x86/kernel/dumpstack.c
@@ -271,7 +271,7 @@ int __kprobes __die(const char *str, str
 			current->thread.trap_nr, SIGSEGV) == NOTIFY_STOP)
 		return 1;
 
-	show_registers(regs);
+	show_regs(regs);
 #ifdef CONFIG_X86_32
 	if (user_mode_vm(regs)) {
 		sp = regs->sp;
--- 3.4-rc6/arch/x86/kernel/dumpstack_32.c
+++ 3.4-rc6-x86-no-show_registers/arch/x86/kernel/dumpstack_32.c
@@ -82,7 +82,7 @@ show_stack_log_lvl(struct task_struct *t
 }
 
 
-void show_registers(struct pt_regs *regs)
+void show_regs(struct pt_regs *regs)
 {
 	int i;
 
--- 3.4-rc6/arch/x86/kernel/dumpstack_64.c
+++ 3.4-rc6-x86-no-show_registers/arch/x86/kernel/dumpstack_64.c
@@ -245,7 +245,7 @@ show_stack_log_lvl(struct task_struct *t
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
-void show_registers(struct pt_regs *regs)
+void show_regs(struct pt_regs *regs)
 {
 	int i;
 	unsigned long sp;
--- 3.4-rc6/arch/x86/kernel/kprobes.c
+++ 3.4-rc6-x86-no-show_registers/arch/x86/kernel/kprobes.c
@@ -1037,9 +1037,9 @@ int __kprobes longjmp_break_handler(stru
 			       "current sp %p does not match saved sp %p\n",
 			       stack_addr(regs), kcb->jprobe_saved_sp);
 			printk(KERN_ERR "Saved registers for jprobe %p\n", jp);
-			show_registers(saved_regs);
+			show_regs(saved_regs);
 			printk(KERN_ERR "Current registers\n");
-			show_registers(regs);
+			show_regs(regs);
 			BUG();
 		}
 		*regs = kcb->jprobe_saved_regs;
--- 3.4-rc6/arch/x86/kernel/nmi.c
+++ 3.4-rc6-x86-no-show_registers/arch/x86/kernel/nmi.c
@@ -244,7 +244,7 @@ io_check_error(unsigned char reason, str
 	pr_emerg(
 	"NMI: IOCK error (debug interrupt?) for reason %02x on CPU %d.\n",
 		 reason, smp_processor_id());
-	show_registers(regs);
+	show_regs(regs);
 
 	if (panic_on_io_nmi)
 		panic("NMI IOCK error: Not continuing");
--- 3.4-rc6/arch/x86/kernel/process.c
+++ 3.4-rc6-x86-no-show_registers/arch/x86/kernel/process.c
@@ -105,12 +105,6 @@ void exit_thread(void)
 	}
 }
 
-void show_regs(struct pt_regs *regs)
-{
-	show_registers(regs);
-	show_trace(NULL, regs, (unsigned long *)kernel_stack_pointer(regs), 0);
-}
-
 void show_regs_common(void)
 {
 	const char *vendor, *product, *board;



