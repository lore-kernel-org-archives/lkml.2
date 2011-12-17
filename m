Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab1LQEKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 23:10:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39068 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1LQEKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 23:10:46 -0500
X-Authority-Analysis: v=2.0 cv=HeWWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=aKA1LIvemfIA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=LSvQbrrk286xtPtNAqYA:9 a=l-4p-Z5SRZoyyPCdjkwA:7 a=PUjeQqilurYA:10 a=tAnCUxiLWNKGQtbN:21 a=WGnd_dWiwxHhRfso:21 a=IUnDsLAh842ZTeV-N14A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324095039.23971.145.camel@gandalf.stny.rr.com>
Subject: [PATCH] [GIT PULL v2] x86: Workaround for NMI iret woes
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>
Date: Fri, 16 Dec 2011 23:10:39 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-eJcG8sWcA9lxHkQfYw3u"
X-Mailer: Evolution 3.0.3-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eJcG8sWcA9lxHkQfYw3u
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Ingo,

OK, I rebased the patches on top of v3.2-rc5 and ran them through all my
tests. Instead of spamming LKML and the rest of you with the same 6
patches that haven't changed, I'm posting the combined diff below. Note,
I put this under tip/x86/core-2 instead of just core.

Please pull the latest tip/x86/core-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/x86/core-2

Head SHA1: d1e6d3a08aa7cb73a95f29fc986479782c2f8596


Linus Torvalds (1):
      x86: Do not schedule while still in NMI context

Steven Rostedt (5):
      x86: Document the NMI handler about not using paranoid_exit
      x86: Add workaround to NMI iret woes
      x86: Keep current stack in NMI breakpoints
      x86: Allow NMIs to hit breakpoints in i386
      x86: Add counter when debug stack is used with interrupts enabled

----
 arch/x86/include/asm/desc.h      |   12 ++
 arch/x86/include/asm/processor.h |   10 ++
 arch/x86/kernel/cpu/common.c     |   34 ++++++
 arch/x86/kernel/entry_64.S       |  208 ++++++++++++++++++++++++++++++++--=
----
 arch/x86/kernel/head_64.S        |    4 +
 arch/x86/kernel/nmi.c            |  101 ++++++++++++++++++
 arch/x86/kernel/traps.c          |   20 ++++
 7 files changed, 356 insertions(+), 33 deletions(-)
---------------------------
diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 41935fa..e95822d 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -35,6 +35,8 @@ static inline void fill_ldt(struct desc_struct *desc, con=
st struct user_desc *in
=20
 extern struct desc_ptr idt_descr;
 extern gate_desc idt_table[];
+extern struct desc_ptr nmi_idt_descr;
+extern gate_desc nmi_idt_table[];
=20
 struct gdt_page {
 	struct desc_struct gdt[GDT_ENTRIES];
@@ -307,6 +309,16 @@ static inline void set_desc_limit(struct desc_struct *=
desc, unsigned long limit)
 	desc->limit =3D (limit >> 16) & 0xf;
 }
=20
+#ifdef CONFIG_X86_64
+static inline void set_nmi_gate(int gate, void *addr)
+{
+	gate_desc s;
+
+	pack_gate(&s, GATE_INTERRUPT, (unsigned long)addr, 0, 0, __KERNEL_CS);
+	write_idt_entry(nmi_idt_table, gate, &s);
+}
+#endif
+
 static inline void _set_gate(int gate, unsigned type, void *addr,
 			     unsigned dpl, unsigned ist, unsigned seg)
 {
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/proces=
sor.h
index b650435..2fef5ba 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -402,6 +402,11 @@ DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
 extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
+void inc_debug_stack_usage(void);
+void dec_debug_stack_usage(void);
+int is_debug_stack(unsigned long addr);
+void zero_debug_stack(void);
+void reset_debug_stack(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
 /*
@@ -416,6 +421,11 @@ struct stack_canary {
 };
 DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
+static inline int is_debug_stack(unsigned long addr) { return 0; }
+static inline void inc_debug_stack_usage(void) { }
+static inline void dec_debug_stack_usage(void) { }
+static inline void zero_debug_stack(void) { }
+static inline void reset_debug_stack(void) { }
 #endif	/* X86_64 */
=20
 extern unsigned int xstate_size;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index aa003b1..f1ec612 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1026,6 +1026,8 @@ __setup("clearcpuid=3D", setup_disablecpuid);
=20
 #ifdef CONFIG_X86_64
 struct desc_ptr idt_descr =3D { NR_VECTORS * 16 - 1, (unsigned long) idt_t=
able };
+struct desc_ptr nmi_idt_descr =3D { NR_VECTORS * 16 - 1,
+				    (unsigned long) nmi_idt_table };
=20
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
 		     irq_stack_union) __aligned(PAGE_SIZE);
@@ -1090,6 +1092,36 @@ unsigned long kernel_eflags;
  */
 DEFINE_PER_CPU(struct orig_ist, orig_ist);
=20
+static DEFINE_PER_CPU(unsigned long, debug_stack_addr);
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
+
+int is_debug_stack(unsigned long addr)
+{
+	return __get_cpu_var(debug_stack_usage) ||
+		(addr <=3D __get_cpu_var(debug_stack_addr) &&
+		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
+}
+
+void zero_debug_stack(void)
+{
+	load_idt((const struct desc_ptr *)&nmi_idt_descr);
+}
+
+void reset_debug_stack(void)
+{
+	load_idt((const struct desc_ptr *)&idt_descr);
+}
+
 #else	/* CONFIG_X86_64 */
=20
 DEFINE_PER_CPU(struct task_struct *, current_task) =3D &init_task;
@@ -1208,6 +1240,8 @@ void __cpuinit cpu_init(void)
 			estacks +=3D exception_stack_sizes[v];
 			oist->ist[v] =3D t->x86_tss.ist[v] =3D
 					(unsigned long)estacks;
+			if (v =3D=3D DEBUG_STACK - 1)
+				per_cpu(debug_stack_addr, cpu) =3D (unsigned long)estacks;
 		}
 	}
=20
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index faf8d5e..b2dea00 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1475,62 +1475,204 @@ ENTRY(error_exit)
 	CFI_ENDPROC
 END(error_exit)
=20
+/*
+ * Test if a given stack is an NMI stack or not.
+ */
+	.macro test_in_nmi reg stack nmi_ret normal_ret
+	cmpq %\reg, \stack
+	ja \normal_ret
+	subq $EXCEPTION_STKSZ, %\reg
+	cmpq %\reg, \stack
+	jb \normal_ret
+	jmp \nmi_ret
+	.endm
=20
 	/* runs on exception stack */
 ENTRY(nmi)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq_cfi $-1
+	/*
+	 * We allow breakpoints in NMIs. If a breakpoint occurs, then
+	 * the iretq it performs will take us out of NMI context.
+	 * This means that we can have nested NMIs where the next
+	 * NMI is using the top of the stack of the previous NMI. We
+	 * can't let it execute because the nested NMI will corrupt the
+	 * stack of the previous NMI. NMI handlers are not re-entrant
+	 * anyway.
+	 *
+	 * To handle this case we do the following:
+	 *  Check the a special location on the stack that contains
+	 *  a variable that is set when NMIs are executing.
+	 *  The interrupted task's stack is also checked to see if it
+	 *  is an NMI stack.
+	 *  If the variable is not set and the stack is not the NMI
+	 *  stack then:
+	 *    o Set the special variable on the stack
+	 *    o Copy the interrupt frame into a "saved" location on the stack
+	 *    o Copy the interrupt frame into a "copy" location on the stack
+	 *    o Continue processing the NMI
+	 *  If the variable is set or the previous stack is the NMI stack:
+	 *    o Modify the "copy" location to jump to the repeate_nmi
+	 *    o return back to the first NMI
+	 *
+	 * Now on exit of the first NMI, we first clear the stack variable
+	 * The NMI stack will tell any nested NMIs at that point that it is
+	 * nested. Then we pop the stack normally with iret, and if there was
+	 * a nested NMI that updated the copy interrupt stack frame, a
+	 * jump will be made to the repeat_nmi code that will handle the second
+	 * NMI.
+	 */
+
+	/* Use %rdx as out temp variable throughout */
+	pushq_cfi %rdx
+
+	/*
+	 * Check the special variable on the stack to see if NMIs are
+	 * executing.
+	 */
+	cmp $1, -8(%rsp)
+	je nested_nmi
+
+	/*
+	 * Now test if the previous stack was an NMI stack.
+	 * We need the double check. We check the NMI stack to satisfy the
+	 * race when the first NMI clears the variable before returning.
+	 * We check the variable because the first NMI could be in a
+	 * breakpoint routine using a breakpoint stack.
+	 */
+	lea 6*8(%rsp), %rdx
+	test_in_nmi rdx, 4*8(%rsp), nested_nmi, first_nmi
+
+nested_nmi:
+	/*
+	 * Do nothing if we interrupted the fixup in repeat_nmi.
+	 * It's about to repeat the NMI handler, so we are fine
+	 * with ignoring this one.
+	 */
+	movq $repeat_nmi, %rdx
+	cmpq 8(%rsp), %rdx
+	ja 1f
+	movq $end_repeat_nmi, %rdx
+	cmpq 8(%rsp), %rdx
+	ja nested_nmi_out
+
+1:
+	/* Set up the interrupted NMIs stack to jump to repeat_nmi */
+	leaq -6*8(%rsp), %rdx
+	movq %rdx, %rsp
+	pushq $__KERNEL_DS
+	pushq %rdx
+	pushfq
+	pushq $__KERNEL_CS
+	pushq_cfi $repeat_nmi
+
+	/* Put stack back */
+	addq $(11*8), %rsp
+
+nested_nmi_out:
+	popq_cfi %rdx
+
+	/* No need to check faults here */
+	INTERRUPT_RETURN
+
+first_nmi:
+	/*
+	 * Because nested NMIs will use the pushed location that we
+	 * stored rdx, we must keep that space available.
+	 * Here's what our stack frame will look like:
+	 * +-------------------------+
+	 * | original SS             |
+	 * | original Return RSP     |
+	 * | original RFLAGS         |
+	 * | original CS             |
+	 * | original RIP            |
+	 * +-------------------------+
+	 * | temp storage for rdx    |
+	 * +-------------------------+
+	 * | NMI executing variable  |
+	 * +-------------------------+
+	 * | Saved SS                |
+	 * | Saved Return RSP        |
+	 * | Saved RFLAGS            |
+	 * | Saved CS                |
+	 * | Saved RIP               |
+	 * +-------------------------+
+	 * | copied SS               |
+	 * | copied Return RSP       |
+	 * | copied RFLAGS           |
+	 * | copied CS               |
+	 * | copied RIP              |
+	 * +-------------------------+
+	 * | pt_regs                 |
+	 * +-------------------------+
+	 *
+	 * The saved RIP is used to fix up the copied RIP that a nested
+	 * NMI may zero out. The original stack frame and the temp storage
+	 * is also used by nested NMIs and can not be trusted on exit.
+	 */
+	/* Set the NMI executing variable on the stack. */
+	pushq_cfi $1
+
+	/* Copy the stack frame to the Saved frame */
+	.rept 5
+	pushq_cfi 6*8(%rsp)
+	.endr
+
+	/* Make another copy, this one may be modified by nested NMIs */
+	.rept 5
+	pushq_cfi 4*8(%rsp)
+	.endr
+
+	/* Do not pop rdx, nested NMIs will corrupt it */
+	movq 11*8(%rsp), %rdx
+
+	/*
+	 * Everything below this point can be preempted by a nested
+	 * NMI if the first NMI took an exception. Repeated NMIs
+	 * caused by an exception and nested NMI will start here, and
+	 * can still be preempted by another NMI.
+	 */
+restart_nmi:
+	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
+	/*
+	 * Use save_paranoid to handle SWAPGS, but no need to use paranoid_exit
+	 * as we should not be calling schedule in NMI context.
+	 * Even with normal interrupts enabled. An NMI should not be
+	 * setting NEED_RESCHED or anything that normal interrupts and
+	 * exceptions might do.
+	 */
 	call save_paranoid
 	DEFAULT_FRAME 0
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
 	movq %rsp,%rdi
 	movq $-1,%rsi
 	call do_nmi
-#ifdef CONFIG_TRACE_IRQFLAGS
-	/* paranoidexit; without TRACE_IRQS_OFF */
-	/* ebx:	no swapgs flag */
-	DISABLE_INTERRUPTS(CLBR_NONE)
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz nmi_restore
-	testl $3,CS(%rsp)
-	jnz nmi_userspace
 nmi_swapgs:
 	SWAPGS_UNSAFE_STACK
 nmi_restore:
 	RESTORE_ALL 8
+	/* Clear the NMI executing stack variable */
+	movq $0, 10*8(%rsp)
 	jmp irq_return
-nmi_userspace:
-	GET_THREAD_INFO(%rcx)
-	movl TI_flags(%rcx),%ebx
-	andl $_TIF_WORK_MASK,%ebx
-	jz nmi_swapgs
-	movq %rsp,%rdi			/* &pt_regs */
-	call sync_regs
-	movq %rax,%rsp			/* switch stack for scheduling */
-	testl $_TIF_NEED_RESCHED,%ebx
-	jnz nmi_schedule
-	movl %ebx,%edx			/* arg3: thread flags */
-	ENABLE_INTERRUPTS(CLBR_NONE)
-	xorl %esi,%esi 			/* arg2: oldset */
-	movq %rsp,%rdi 			/* arg1: &pt_regs */
-	call do_notify_resume
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	jmp nmi_userspace
-nmi_schedule:
-	ENABLE_INTERRUPTS(CLBR_ANY)
-	call schedule
-	DISABLE_INTERRUPTS(CLBR_ANY)
-	jmp nmi_userspace
 	CFI_ENDPROC
-#else
-	jmp paranoid_exit
-	CFI_ENDPROC
-#endif
 END(nmi)
=20
+repeat_nmi:
+	/* Update the stack variable to say we are still in NMI */
+	movq $1, 5*8(%rsp)
+
+	/* copy the saved stack back to copy stack */
+	.rept 5
+	pushq 4*8(%rsp)
+	.endr
+
+	jmp restart_nmi
+end_repeat_nmi:
+
 ENTRY(ignore_sysret)
 	CFI_STARTPROC
 	mov $-ENOSYS,%eax
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index e11e394..40f4eb3 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -417,6 +417,10 @@ ENTRY(phys_base)
 ENTRY(idt_table)
 	.skip IDT_ENTRIES * 16
=20
+	.align L1_CACHE_BYTES
+ENTRY(nmi_idt_table)
+	.skip IDT_ENTRIES * 16
+
 	__PAGE_ALIGNED_BSS
 	.align PAGE_SIZE
 ENTRY(empty_zero_page)
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index e88f37b..3cb659c 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -405,9 +405,108 @@ static notrace __kprobes void default_do_nmi(struct p=
t_regs *regs)
 		unknown_nmi_error(reason, regs);
 }
=20
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
+		if (__get_cpu_var(nmi_state) !=3D NMI_NOT_RUNNING) {	\
+			__get_cpu_var(nmi_state) =3D NMI_LATCHED;		\
+			return;						\
+		}							\
+	nmi_restart:							\
+		__get_cpu_var(nmi_state) =3D NMI_EXECUTING;		\
+	} while (0)
+
+#define nmi_postprocess()						\
+	do {								\
+		if (cmpxchg(&__get_cpu_var(nmi_state),			\
+		    NMI_EXECUTING, NMI_NOT_RUNNING) !=3D NMI_EXECUTING)	\
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
+
+static inline void nmi_preprocess(struct pt_regs *regs)
+{
+	/*
+	 * If we interrupted a breakpoint, it is possible that
+	 * the nmi handler will have breakpoints too. We need to
+	 * change the IDT such that breakpoints that happen here
+	 * continue to use the NMI stack.
+	 */
+	if (unlikely(is_debug_stack(regs->sp))) {
+		zero_debug_stack();
+		__get_cpu_var(update_debug_stack) =3D 1;
+	}
+}
+
+static inline void nmi_postprocess(void)
+{
+	if (unlikely(__get_cpu_var(update_debug_stack)))
+		reset_debug_stack();
+}
+#endif
+
 dotraplinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
+	nmi_preprocess(regs);
+
 	nmi_enter();
=20
 	inc_irq_stat(__nmi_count);
@@ -416,6 +515,8 @@ do_nmi(struct pt_regs *regs, long error_code)
 		default_do_nmi(regs);
=20
 	nmi_exit();
+
+	nmi_postprocess();
 }
=20
 void stop_nmi(void)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a8e3eb8..d2510e7 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -316,9 +316,15 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *r=
egs, long error_code)
 		return;
 #endif
=20
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
=20
 #ifdef CONFIG_X86_64
@@ -411,6 +417,12 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *=
regs, long error_code)
 							SIGTRAP) =3D=3D NOTIFY_STOP)
 		return;
=20
+	/*
+	 * Let others (NMI) know that the debug stack is in use
+	 * as we may switch to the interrupt stack.
+	 */
+	inc_debug_stack_usage();
+
 	/* It's safe to allow irq's after DR6 has been saved */
 	preempt_conditional_sti(regs);
=20
@@ -418,6 +430,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *r=
egs, long error_code)
 		handle_vm86_trap((struct kernel_vm86_regs *) regs,
 				error_code, 1);
 		preempt_conditional_cli(regs);
+		dec_debug_stack_usage();
 		return;
 	}
=20
@@ -437,6 +450,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *r=
egs, long error_code)
 	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS) || user_icebp)
 		send_sigtrap(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
+	dec_debug_stack_usage();
=20
 	return;
 }
@@ -723,4 +737,10 @@ void __init trap_init(void)
 	cpu_init();
=20
 	x86_init.irqs.trap_init();
+
+#ifdef CONFIG_X86_64
+	memcpy(&nmi_idt_table, &idt_table, IDT_ENTRIES * 16);
+	set_nmi_gate(1, &debug);
+	set_nmi_gate(3, &int3);
+#endif
 }


--=-eJcG8sWcA9lxHkQfYw3u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO7BZAAAoJEIy3vGnGbaoArxwQANl+7Nr6g5ey2eF3etzRq/11
j0xQLvOgqhwbHcXkO97sSLWCpPAn3d4p1BSMFvQvH93rLpKyevxj6eSw5LIZh0q7
1NqCIRG+DcOYsEHF6/0sqNdNsQlXnBOlGYc/9Fwq8ncMiWVn3FVdaUV0Pf5dV3I6
jhR7JfdC8UC4OlMk39XgS5lhYY+3nu9HBwh77dgVzBrFCqJzlNMroF0KaiLjuvB3
zW3lUnK57YOCg6LcrPlrZ8qnu8FtulY3xGCBE6b8YjdWZ339MvGO8eP+9QWw5lhV
ud81z+NxER87uGjJMca/QwWQKzzAsLvCZlPQySXk/mLGABFzunxPieOWratX5Xzn
euPsAhYmsW6C9k4GudXVdBrJAov1CaXLBRJTW2wpwOgYbelEER2s2WdCkV+r9+O4
JcLwRLx9+GcfB7Gqupxn3EUNy12aWckeK/QJqmH4xV+4uRO/5KWNL8+Z+gVDmWse
6zEIqpggZTyQjpobY+zHViJkCrgf0sIZ9O+TJLrdGL5Uve8vtGrDsinyHMD4rjE6
neMX8MU7/IAcZ015cNJS8Jq254JL8PtucoJwM/qhuoMSmZiM/heZkAm8mcQzMK0w
GfKiv44YVHWLbITRxNRXmzbe2RAtGpKtQNwRfsl3kRvXmPP8SEvRpk0oEXqnIDDJ
7IK0anCJK04Kxu0dXPUs
=mk29
-----END PGP SIGNATURE-----

--=-eJcG8sWcA9lxHkQfYw3u--

