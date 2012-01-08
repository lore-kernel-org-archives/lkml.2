Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab2AHI7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 03:59:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38299 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab2AHI7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 03:59:35 -0500
Date: Sun, 8 Jan 2012 00:59:17 -0800
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-42181186ad4db986fcaa40ca95c6e407e9e79372@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, torvalds@linux-foundation.org,
        pjt@google.com, peterz@infradead.org, fweisbec@gmail.com,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, torvalds@linux-foundation.org,
        peterz@infradead.org, pjt@google.com, fweisbec@gmail.com,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1323976535.23971.112.camel@gandalf.stny.rr.com>
References: <1323976535.23971.112.camel@gandalf.stny.rr.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86:
  Add counter when debug stack is used with interrupts enabled
Git-Commit-ID: 42181186ad4db986fcaa40ca95c6e407e9e79372
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 08 Jan 2012 00:59:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42181186ad4db986fcaa40ca95c6e407e9e79372
Gitweb:     http://git.kernel.org/tip/42181186ad4db986fcaa40ca95c6e407e9e79372
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Fri, 16 Dec 2011 11:43:02 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 21 Dec 2011 15:38:56 -0500

x86: Add counter when debug stack is used with interrupts enabled

Mathieu Desnoyers pointed out a case that can cause issues with
NMIs running on the debug stack:

  int3 -> interrupt -> NMI -> int3

Because the interrupt changes the stack, the NMI will not see that
it preempted the debug stack. Looking deeper at this case,
interrupts only happen when the int3 is from userspace or in
an a location in the exception table (fixup).

  userspace -> int3 -> interurpt -> NMI -> int3

All other int3s that happen in the kernel should be processed
without ever enabling interrupts, as the do_trap() call will
panic the kernel if it is called to process any other location
within the kernel.

Adding a counter around the sections that enable interrupts while
using the debug stack allows the NMI to also check that case.
If the NMI sees that it either interrupted a task using the debug
stack or the debug counter is non-zero, then it will have to
change the IDT table to make the int3 not change stacks (which will
corrupt the stack if it does).

Note, I had to move the debug_usage functions out of processor.h
and into debugreg.h because of the static inlined functions to
inc and dec the debug_usage counter. __get_cpu_var() requires
smp.h which includes processor.h, and would fail to build.

Link: http://lkml.kernel.org/r/1323976535.23971.112.camel@gandalf.stny.rr.com

Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Turner <pjt@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/debugreg.h  |   22 ++++++++++++++++++++++
 arch/x86/include/asm/processor.h |    6 ------
 arch/x86/kernel/cpu/common.c     |    6 ++++--
 arch/x86/kernel/traps.c          |   14 ++++++++++++++
 4 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index 078ad0c..b903d5e 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -101,6 +101,28 @@ extern void aout_dump_debugregs(struct user *dump);
 
 extern void hw_breakpoint_restore(void);
 
+#ifdef CONFIG_X86_64
+DECLARE_PER_CPU(int, debug_stack_usage);
+static inline void debug_stack_usage_inc(void)
+{
+	__get_cpu_var(debug_stack_usage)++;
+}
+static inline void debug_stack_usage_dec(void)
+{
+	__get_cpu_var(debug_stack_usage)--;
+}
+int is_debug_stack(unsigned long addr);
+void debug_stack_set_zero(void);
+void debug_stack_reset(void);
+#else /* !X86_64 */
+static inline int is_debug_stack(unsigned long addr) { return 0; }
+static inline void debug_stack_set_zero(void) { }
+static inline void debug_stack_reset(void) { }
+static inline void debug_stack_usage_inc(void) { }
+static inline void debug_stack_usage_dec(void) { }
+#endif /* X86_64 */
+
+
 #endif	/* __KERNEL__ */
 
 #endif /* _ASM_X86_DEBUGREG_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4b39d6d..b650435 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -402,9 +402,6 @@ DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
 extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
-int is_debug_stack(unsigned long addr);
-void debug_stack_set_zero(void);
-void debug_stack_reset(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
 /*
@@ -419,9 +416,6 @@ struct stack_canary {
 };
 DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
-static inline int is_debug_stack(unsigned long addr) { return 0; }
-static inline void debug_stack_set_zero(void) { }
-static inline void debug_stack_reset(void) { }
 #endif	/* X86_64 */
 
 extern unsigned int xstate_size;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index caa4045..266e464 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1093,11 +1093,13 @@ unsigned long kernel_eflags;
 DEFINE_PER_CPU(struct orig_ist, orig_ist);
 
 static DEFINE_PER_CPU(unsigned long, debug_stack_addr);
+DEFINE_PER_CPU(int, debug_stack_usage);
 
 int is_debug_stack(unsigned long addr)
 {
-	return addr <= __get_cpu_var(debug_stack_addr) &&
-		addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ);
+	return __get_cpu_var(debug_stack_usage) ||
+		(addr <= __get_cpu_var(debug_stack_addr) &&
+		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
 }
 
 void debug_stack_set_zero(void)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a93c5ca..0072b38 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -316,9 +316,15 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 		return;
 #endif
 
+	/*
+	 * Let others (NMI) know that the debug stack is in use
+	 * as we may switch to the interrupt stack.
+	 */
+	debug_stack_usage_inc();
 	preempt_conditional_sti(regs);
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
+	debug_stack_usage_dec();
 }
 
 #ifdef CONFIG_X86_64
@@ -411,6 +417,12 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 							SIGTRAP) == NOTIFY_STOP)
 		return;
 
+	/*
+	 * Let others (NMI) know that the debug stack is in use
+	 * as we may switch to the interrupt stack.
+	 */
+	debug_stack_usage_inc();
+
 	/* It's safe to allow irq's after DR6 has been saved */
 	preempt_conditional_sti(regs);
 
@@ -418,6 +430,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 		handle_vm86_trap((struct kernel_vm86_regs *) regs,
 				error_code, 1);
 		preempt_conditional_cli(regs);
+		debug_stack_usage_dec();
 		return;
 	}
 
@@ -437,6 +450,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS) || user_icebp)
 		send_sigtrap(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
+	debug_stack_usage_dec();
 
 	return;
 }
