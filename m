Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab1LNCxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:53:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45608 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab1LNCwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:52:55 -0500
X-Authority-Analysis: v=2.0 cv=Z6Nu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=_GgVX-odOicA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=JfrnYn6hAAAA:8 a=QyXUC8HyAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=r6tlpdmizkw4SpTRxM4A:9 a=pmeH6dRcdzFXV19EwPMA:7 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=00VAB27iOpDD2gO3:21 a=xXETSA8P2YTXNwkd:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111214025253.519573056@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Dec 2011 21:52:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
Subject: [RFC][PATCH 5/5 v2] x86: Allow NMIs to hit breakpoints in i386
References: <20111214025237.457632996@goodmis.org>
Content-Disposition: inline; filename=0005-x86-Allow-NMIs-to-hit-breakpoints-in-i386.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

With i386, NMIs and breakpoints use the current stack and they
do not reset the stack pointer to a fix point that might corrupt
a previous NMI or breakpoint (as it does in x86_64). But NMIs are
still not made to be re-entrant, and need to prevent the case that
an NMI hitting a breakpoint (which does an iret), doesn't allow
another NMI to run.

The fix is to let the NMI be in 3 different states:

1) not running
2) executing
3) latched

When no NMI is executing on a given CPU, the state is "not running".
When the first NMI comes in, the state is switched to "executing".
On exit of that NMI, a cmpxchg is performed to switch the state
back to "not running" and if that fails, the NMI is restarted.

If a breakpoint is hit and does an iret, which re-enables NMIs,
and another NMI comes in before the first NMI finished, it will
detect that the state is not in the "not running" state and the
current NMI is nested. In this case, the state is switched to "latched"
to let the interrupted NMI know to restart the NMI handler, and
the nested NMI exits without doing anything.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Turner <pjt@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/nmi.c |  100 +++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index fb86773..f670295 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -404,11 +404,84 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		unknown_nmi_error(reason, regs);
 }
 
-dotraplinkage notrace __kprobes void
-do_nmi(struct pt_regs *regs, long error_code)
-{
-	int update_debug_stack = 0;
+/*
+ * NMIs can hit breakpoints which will cause it to lose its
+ * NMI context with the CPU when the breakpoint does an iret.
+ */
+#ifdef CONFIG_X86_32
+/*
+ * For i386, NMIs use the same stack as the kernel, and we can
+ * add a workaround to the iret problem in C. Simply have 3 states
+ * the NMI can be in.
+ *
+ *  1) not running
+ *  2) executing
+ *  3) latched
+ *
+ * When no NMI is in progress, it is in the "not running" state.
+ * When an NMI comes in, it goes into the "executing" state.
+ * Normally, if another NMI is triggered, it does not interrupt
+ * the running NMI and the HW will simply latch it so that when
+ * the first NMI finishes, it will restart the second NMI.
+ * (Note, the latch is binary, thus multiple NMIs triggering,
+ *  when one is running, are ignored. Only one NMI is restarted.)
+ *
+ * If an NMI hits a breakpoint that executes an iret, another
+ * NMI can preempt it. We do not want to allow this new NMI
+ * to run, but we want to execute it when the first one finishes.
+ * We set the state to "latched", and the first NMI will perform
+ * an cmpxchg on the state, and if it doesn't successfully
+ * reset the state to "not running" it will restart the next
+ * NMI.
+ */
+enum nmi_states {
+	NMI_NOT_RUNNING,
+	NMI_EXECUTING,
+	NMI_LATCHED,
+};
+static DEFINE_PER_CPU(enum nmi_states, nmi_state);
+
+#define nmi_preprocess(regs)						\
+	do {								\
+		if (__get_cpu_var(nmi_state) != NMI_NOT_RUNNING) {	\
+			__get_cpu_var(nmi_state) = NMI_LATCHED;		\
+			return;						\
+		}							\
+	nmi_restart:							\
+		__get_cpu_var(nmi_state) = NMI_EXECUTING;		\
+	} while (0)
+
+#define nmi_postprocess()						\
+	do {								\
+		if (cmpxchg(&__get_cpu_var(nmi_state),			\
+		    NMI_EXECUTING, NMI_NOT_RUNNING) != NMI_EXECUTING)	\
+			goto nmi_restart;				\
+	} while (0)
+#else /* x86_64 */
+/*
+ * In x86_64 things are a bit more difficult. This has the same problem
+ * where an NMI hitting a breakpoint that calls iret will remove the
+ * NMI context, allowing a nested NMI to enter. What makes this more
+ * difficult is that both NMIs and breakpoints have their own stack.
+ * When a new NMI or breakpoint is executed, the stack is set to a fixed
+ * point. If an NMI is nested, it will have its stack set at that same
+ * fixed address that the first NMI had, and will start corrupting the
+ * stack. This is handled in entry_64.S, but the same problem exists with
+ * the breakpoint stack.
+ *
+ * If a breakpoint is being processed, and the debug stack is being used,
+ * if an NMI comes in and also hits a breakpoint, the stack pointer
+ * will be set to the same fixed address as the breakpoint that was
+ * interrupted, causing that stack to be corrupted. To handle this case,
+ * check if the stack that was interrupted is the debug stack, and if
+ * so, change the IDT so that new breakpoints will use the current stack
+ * and not switch to the fixed address. On return of the NMI, switch back
+ * to the original IDT.
+ */
+static DEFINE_PER_CPU(int, update_debug_stack);
 
+static inline void nmi_preprocess(struct pt_regs *regs)
+{
 	/*
 	 * If we interrupted a breakpoint, it is possible that
 	 * the nmi handler will have breakpoints too. We need to
@@ -417,8 +490,22 @@ do_nmi(struct pt_regs *regs, long error_code)
 	 */
 	if (unlikely(is_debug_stack(regs->sp))) {
 		zero_debug_stack();
-		update_debug_stack = 1;
+		__get_cpu_var(update_debug_stack) = 1;
 	}
+}
+
+static inline void nmi_postprocess(void)
+{
+	if (unlikely(__get_cpu_var(update_debug_stack)))
+		reset_debug_stack();
+}
+#endif
+
+dotraplinkage notrace __kprobes void
+do_nmi(struct pt_regs *regs, long error_code)
+{
+	nmi_preprocess(regs);
+
 	nmi_enter();
 
 	inc_irq_stat(__nmi_count);
@@ -428,8 +515,7 @@ do_nmi(struct pt_regs *regs, long error_code)
 
 	nmi_exit();
 
-	if (unlikely(update_debug_stack))
-		reset_debug_stack();
+	nmi_postprocess();
 }
 
 void stop_nmi(void)
-- 
1.7.7.3


