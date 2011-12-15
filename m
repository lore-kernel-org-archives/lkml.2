Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab1LOTPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:15:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51808 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1LOTPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:15:39 -0500
X-Authority-Analysis: v=2.0 cv=FIuZNpUs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=Wdbr4zj3n9AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=jfOaFXndxd3Fg1AisQcA:9 a=JZ4WC9B1xLZ6WGaHKm8A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1323976535.23971.112.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 4/5 v2] x86: Keep current stack in NMI breakpoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Date: Thu, 15 Dec 2011 14:15:35 -0500
In-Reply-To: <20111214134325.GB2882@Krystal>
References: <20111214025237.457632996@goodmis.org>
	 <20111214025252.684160446@goodmis.org> <20111214134325.GB2882@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 08:43 -0500, Mathieu Desnoyers wrote:

> What happens to the following sequence ?
> 
> - Hit a breakpoint.
> - Execute an interrupt handler nesting over breakpoint handler (made
>   possible by preempt_conditional_sti(regs) in do_int3()).
>   (or take any kind of fault that switch the current stack)
> - NMI fires, not detecting that it is nested over a breakpoint handler,
>   thus potentially corrupting the DEBUG stack.
> 
> Instead of trying to detect if we nest on a stack to find out if we need
> to change the IDT, I would recommend to unconditionally switch the int3
> IDT to use the current stack upon outermost NMI entry, and set it back
> to its usual behavior upon outermost NMI exit.

There's also this simple patch to guarantee that NMIs know the debug
stack is in use:

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index d748d1f..2fef5ba 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -402,6 +402,8 @@ DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
 extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
+void inc_debug_stack_usage(void);
+void dec_debug_stack_usage(void);
 int is_debug_stack(unsigned long addr);
 void zero_debug_stack(void);
 void reset_debug_stack(void);
@@ -420,6 +422,8 @@ struct stack_canary {
 DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
 static inline int is_debug_stack(unsigned long addr) { return 0; }
+static inline void inc_debug_stack_usage(void) { }
+static inline void dec_debug_stack_usage(void) { }
 static inline void zero_debug_stack(void) { }
 static inline void reset_debug_stack(void) { }
 #endif	/* X86_64 */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 98faeff..f1ec612 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1093,11 +1093,23 @@ unsigned long kernel_eflags;
 DEFINE_PER_CPU(struct orig_ist, orig_ist);
 
 static DEFINE_PER_CPU(unsigned long, debug_stack_addr);
+static DEFINE_PER_CPU(int, debug_stack_usage);
+
+void inc_debug_stack_usage(void)
+{
+	__get_cpu_var(debug_stack_usage)++;
+}
+
+void dec_debug_stack_usage(void)
+{
+	__get_cpu_var(debug_stack_usage)--;
+}
 
 int is_debug_stack(unsigned long addr)
 {
-	return addr <= __get_cpu_var(debug_stack_addr) &&
-		addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ);
+	return __get_cpu_var(debug_stack_usage) ||
+		(addr <= __get_cpu_var(debug_stack_addr) &&
+		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
 }
 
 void zero_debug_stack(void)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a93c5ca..d2510e7 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -316,9 +316,15 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 		return;
 #endif
 
+	/*
+	 * Let others (NMI) know that the debug stack is in use
+	 * as we may switch to the interrupt stack.
+	 */
+	inc_debug_stack_usage();
 	preempt_conditional_sti(regs);
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
+	dec_debug_stack_usage();
 }
 
 #ifdef CONFIG_X86_64
@@ -411,6 +417,12 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 							SIGTRAP) == NOTIFY_STOP)
 		return;
 
+	/*
+	 * Let others (NMI) know that the debug stack is in use
+	 * as we may switch to the interrupt stack.
+	 */
+	inc_debug_stack_usage();
+
 	/* It's safe to allow irq's after DR6 has been saved */
 	preempt_conditional_sti(regs);
 
@@ -418,6 +430,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 		handle_vm86_trap((struct kernel_vm86_regs *) regs,
 				error_code, 1);
 		preempt_conditional_cli(regs);
+		dec_debug_stack_usage();
 		return;
 	}
 
@@ -437,6 +450,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS) || user_icebp)
 		send_sigtrap(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
+	dec_debug_stack_usage();
 
 	return;
 }


