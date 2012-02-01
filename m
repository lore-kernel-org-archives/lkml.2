Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2BAVIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:08:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50788 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab2BAVHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:07:50 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=KzFBExjkGvcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=57_12kv_sXm3N-Y1ro0A:9 a=kUEh2ZV3-Vyq7Ha0mV0A:7 a=jeBq3FmKZ4MA:10 a=N6QJnO5oWte6PJx6:21 a=Kmbu9my__6Tu-0vz:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120201210748.397671856@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 01 Feb 2012 16:06:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>
Subject: [PATCH RT 1/2 v3] x86: Do not disable preemption in int3 on 32bit
References: <20120201210612.730595791@goodmis.org>
Content-Disposition: inline; filename=fix-rt-int3-x86_32-3.2-rt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preemption must be disabled before enabling interrupts in do_trap
on x86_64 because the stack in use for int3 and debug is a per CPU
stack set by th IST. But 32bit does not have an IST and the stack
still belongs to the current task and there is no problem in scheduling
out the task.

Keep preemption enabled on X86_32 when enabling interrupts for
do_trap().

The name of the function is changed from preempt_conditional_sti/cli()
to conditional_sti/cli_ist(), to annotate that this function is used
when the stack is on the IST.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/arch/x86/kernel/traps.c
===================================================================
--- linux-rt.git.orig/arch/x86/kernel/traps.c
+++ linux-rt.git/arch/x86/kernel/traps.c
@@ -87,9 +87,21 @@ static inline void conditional_sti(struc
 		local_irq_enable();
 }
 
-static inline void preempt_conditional_sti(struct pt_regs *regs)
+static inline void conditional_sti_ist(struct pt_regs *regs)
 {
+#ifdef CONFIG_X86_64
+	/*
+	 * X86_64 uses a per CPU stack on the IST for certain traps
+	 * like int3. The task can not be preempted when using one
+	 * of these stacks, thus preemption must be disabled, otherwise
+	 * the stack can be corrupted if the task is scheduled out,
+	 * and another task comes in and uses this stack.
+	 *
+	 * On x86_32 the task keeps its own stack and it is OK if the
+	 * task schedules out.
+	 */
 	inc_preempt_count();
+#endif
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_enable();
 }
@@ -100,11 +112,13 @@ static inline void conditional_cli(struc
 		local_irq_disable();
 }
 
-static inline void preempt_conditional_cli(struct pt_regs *regs)
+static inline void conditional_cli_ist(struct pt_regs *regs)
 {
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_disable();
+#ifdef CONFIG_X86_64
 	dec_preempt_count();
+#endif
 }
 
 static void __kprobes
@@ -222,9 +236,9 @@ dotraplinkage void do_stack_segment(stru
 	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
 			12, SIGBUS) == NOTIFY_STOP)
 		return;
-	preempt_conditional_sti(regs);
+	conditional_sti_ist(regs);
 	do_trap(12, SIGBUS, "stack segment", regs, error_code, NULL);
-	preempt_conditional_cli(regs);
+	conditional_cli_ist(regs);
 }
 
 dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
@@ -316,9 +330,9 @@ dotraplinkage void __kprobes do_int3(str
 		return;
 #endif
 
-	preempt_conditional_sti(regs);
+	conditional_sti_ist(regs);
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
-	preempt_conditional_cli(regs);
+	conditional_cli_ist(regs);
 }
 
 #ifdef CONFIG_X86_64
@@ -412,12 +426,12 @@ dotraplinkage void __kprobes do_debug(st
 		return;
 
 	/* It's safe to allow irq's after DR6 has been saved */
-	preempt_conditional_sti(regs);
+	conditional_sti_ist(regs);
 
 	if (regs->flags & X86_VM_MASK) {
 		handle_vm86_trap((struct kernel_vm86_regs *) regs,
 				error_code, 1);
-		preempt_conditional_cli(regs);
+		conditional_cli_ist(regs);
 		return;
 	}
 
@@ -436,7 +450,7 @@ dotraplinkage void __kprobes do_debug(st
 	si_code = get_si_code(tsk->thread.debugreg6);
 	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS) || user_icebp)
 		send_sigtrap(tsk, regs, error_code, si_code);
-	preempt_conditional_cli(regs);
+	conditional_cli_ist(regs);
 
 	return;
 }

