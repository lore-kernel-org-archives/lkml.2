Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1LVDUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:20:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37183 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1LVDTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:19:53 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=AovMRheCJyIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=saF8hcu2n9N8FvdQcz0A:9 a=KCf1YiFhvNM2sNysLZ8A:7 a=QEXdDO2ut3YA:10 a=i7oPmvkiC74O1mb2GwEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111222031357.120841629@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 22:13:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 0/6 v3] [GIT PULL] x86: Workaround for NMI iret woes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

I updated the patches to reflect your comments and ran them through
all my tests again. Below is the full diff between v2 and v3.

I renamed nmi_preprocess() and nmi_postprocess() to
nmi_nesting_preprocess() and nmi_nesting_postprocess() to at least
note that this has to do with nmi nesting. I also commented the
fact that i386 may loop back to the preprocess.

I had to move the debug_usage functions to debugreg.h, because
smp.h includes processor.h where making the inc/dec inline
caused include header issues.

-- Steve

Please pull the latest tip/x86/core-3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/x86/core-3

Head SHA1: 42181186ad4db986fcaa40ca95c6e407e9e79372


Linus Torvalds (1):
      x86: Do not schedule while still in NMI context

Steven Rostedt (5):
      x86: Document the NMI handler about not using paranoid_exit
      x86: Add workaround to NMI iret woes
      x86: Keep current stack in NMI breakpoints
      x86: Allow NMIs to hit breakpoints in i386
      x86: Add counter when debug stack is used with interrupts enabled

----
 arch/x86/include/asm/debugreg.h |   22 ++++
 arch/x86/include/asm/desc.h     |   12 ++
 arch/x86/kernel/cpu/common.c    |   24 +++++
 arch/x86/kernel/entry_64.S      |  218 +++++++++++++++++++++++++++++++++--=
----
 arch/x86/kernel/head_64.S       |    4 +
 arch/x86/kernel/nmi.c           |  102 ++++++++++++++++++
 arch/x86/kernel/traps.c         |   20 ++++
 7 files changed, 369 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugre=
g.h
index 078ad0c..b903d5e 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -101,6 +101,28 @@ extern void aout_dump_debugregs(struct user *dump);
=20
 extern void hw_breakpoint_restore(void);
=20
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
=20
 #endif /* _ASM_X86_DEBUGREG_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/proces=
sor.h
index 2fef5ba..b650435 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -402,11 +402,6 @@ DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
 extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
-void inc_debug_stack_usage(void);
-void dec_debug_stack_usage(void);
-int is_debug_stack(unsigned long addr);
-void zero_debug_stack(void);
-void reset_debug_stack(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
 /*
@@ -421,11 +416,6 @@ struct stack_canary {
 };
 DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
-static inline int is_debug_stack(unsigned long addr) { return 0; }
-static inline void inc_debug_stack_usage(void) { }
-static inline void dec_debug_stack_usage(void) { }
-static inline void zero_debug_stack(void) { }
-static inline void reset_debug_stack(void) { }
 #endif	/* X86_64 */
=20
 extern unsigned int xstate_size;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f1ec612..266e464 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1093,17 +1093,7 @@ unsigned long kernel_eflags;
 DEFINE_PER_CPU(struct orig_ist, orig_ist);
=20
 static DEFINE_PER_CPU(unsigned long, debug_stack_addr);
-static DEFINE_PER_CPU(int, debug_stack_usage);
-
-void inc_debug_stack_usage(void)
-{
-	__get_cpu_var(debug_stack_usage)++;
-}
-
-void dec_debug_stack_usage(void)
-{
-	__get_cpu_var(debug_stack_usage)--;
-}
+DEFINE_PER_CPU(int, debug_stack_usage);
=20
 int is_debug_stack(unsigned long addr)
 {
@@ -1112,12 +1102,12 @@ int is_debug_stack(unsigned long addr)
 		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
 }
=20
-void zero_debug_stack(void)
+void debug_stack_set_zero(void)
 {
 	load_idt((const struct desc_ptr *)&nmi_idt_descr);
 }
=20
-void reset_debug_stack(void)
+void debug_stack_reset(void)
 {
 	load_idt((const struct desc_ptr *)&idt_descr);
 }
@@ -1240,7 +1230,7 @@ void __cpuinit cpu_init(void)
 			estacks +=3D exception_stack_sizes[v];
 			oist->ist[v] =3D t->x86_tss.ist[v] =3D
 					(unsigned long)estacks;
-			if (v =3D=3D DEBUG_STACK - 1)
+			if (v =3D=3D DEBUG_STACK-1)
 				per_cpu(debug_stack_addr, cpu) =3D (unsigned long)estacks;
 		}
 	}
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b2dea00..b62aa29 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1560,14 +1560,16 @@ nested_nmi:
 	/* Set up the interrupted NMIs stack to jump to repeat_nmi */
 	leaq -6*8(%rsp), %rdx
 	movq %rdx, %rsp
-	pushq $__KERNEL_DS
-	pushq %rdx
-	pushfq
-	pushq $__KERNEL_CS
+	CFI_ADJUST_CFA_OFFSET 6*8
+	pushq_cfi $__KERNEL_DS
+	pushq_cfi %rdx
+	pushfq_cfi
+	pushq_cfi $__KERNEL_CS
 	pushq_cfi $repeat_nmi
=20
 	/* Put stack back */
 	addq $(11*8), %rsp
+	CFI_ADJUST_CFA_OFFSET -11*8
=20
 nested_nmi_out:
 	popq_cfi %rdx
@@ -1578,7 +1580,7 @@ nested_nmi_out:
 first_nmi:
 	/*
 	 * Because nested NMIs will use the pushed location that we
-	 * stored rdx, we must keep that space available.
+	 * stored in rdx, we must keep that space available.
 	 * Here's what our stack frame will look like:
 	 * +-------------------------+
 	 * | original SS             |
@@ -1661,16 +1663,24 @@ nmi_restore:
 	CFI_ENDPROC
 END(nmi)
=20
+	/*
+	 * If an NMI hit an iret because of an exception or breakpoint,
+	 * it can lose its NMI context, and a nested NMI may come in.
+	 * In that case, the nested NMI will change the preempted NMI's
+	 * stack to jump to here when it does the final iret.
+	 */
 repeat_nmi:
+	INTR_FRAME
 	/* Update the stack variable to say we are still in NMI */
 	movq $1, 5*8(%rsp)
=20
 	/* copy the saved stack back to copy stack */
 	.rept 5
-	pushq 4*8(%rsp)
+	pushq_cfi 4*8(%rsp)
 	.endr
=20
 	jmp restart_nmi
+	CFI_ENDPROC
 end_repeat_nmi:
=20
 ENTRY(ignore_sysret)
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 3cb659c..47acaf3 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -442,7 +442,7 @@ enum nmi_states {
 };
 static DEFINE_PER_CPU(enum nmi_states, nmi_state);
=20
-#define nmi_preprocess(regs)						\
+#define nmi_nesting_preprocess(regs)					\
 	do {								\
 		if (__get_cpu_var(nmi_state) !=3D NMI_NOT_RUNNING) {	\
 			__get_cpu_var(nmi_state) =3D NMI_LATCHED;		\
@@ -452,7 +452,7 @@ static DEFINE_PER_CPU(enum nmi_states, nmi_state);
 		__get_cpu_var(nmi_state) =3D NMI_EXECUTING;		\
 	} while (0)
=20
-#define nmi_postprocess()						\
+#define nmi_nesting_postprocess()					\
 	do {								\
 		if (cmpxchg(&__get_cpu_var(nmi_state),			\
 		    NMI_EXECUTING, NMI_NOT_RUNNING) !=3D NMI_EXECUTING)	\
@@ -481,7 +481,7 @@ static DEFINE_PER_CPU(enum nmi_states, nmi_state);
  */
 static DEFINE_PER_CPU(int, update_debug_stack);
=20
-static inline void nmi_preprocess(struct pt_regs *regs)
+static inline void nmi_nesting_preprocess(struct pt_regs *regs)
 {
 	/*
 	 * If we interrupted a breakpoint, it is possible that
@@ -490,22 +490,22 @@ static inline void nmi_preprocess(struct pt_regs *reg=
s)
 	 * continue to use the NMI stack.
 	 */
 	if (unlikely(is_debug_stack(regs->sp))) {
-		zero_debug_stack();
+		debug_stack_set_zero();
 		__get_cpu_var(update_debug_stack) =3D 1;
 	}
 }
=20
-static inline void nmi_postprocess(void)
+static inline void nmi_nesting_postprocess(void)
 {
 	if (unlikely(__get_cpu_var(update_debug_stack)))
-		reset_debug_stack();
+		debug_stack_reset();
 }
 #endif
=20
 dotraplinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
-	nmi_preprocess(regs);
+	nmi_nesting_preprocess(regs);
=20
 	nmi_enter();
=20
@@ -516,7 +516,8 @@ do_nmi(struct pt_regs *regs, long error_code)
=20
 	nmi_exit();
=20
-	nmi_postprocess();
+	/* On i386, may loop back to preprocess */
+	nmi_nesting_postprocess();
 }
=20
 void stop_nmi(void)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d2510e7..0072b38 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -320,11 +320,11 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *=
regs, long error_code)
 	 * Let others (NMI) know that the debug stack is in use
 	 * as we may switch to the interrupt stack.
 	 */
-	inc_debug_stack_usage();
+	debug_stack_usage_inc();
 	preempt_conditional_sti(regs);
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
-	dec_debug_stack_usage();
+	debug_stack_usage_dec();
 }
=20
 #ifdef CONFIG_X86_64
@@ -421,7 +421,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *r=
egs, long error_code)
 	 * Let others (NMI) know that the debug stack is in use
 	 * as we may switch to the interrupt stack.
 	 */
-	inc_debug_stack_usage();
+	debug_stack_usage_inc();
=20
 	/* It's safe to allow irq's after DR6 has been saved */
 	preempt_conditional_sti(regs);
@@ -430,7 +430,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *r=
egs, long error_code)
 		handle_vm86_trap((struct kernel_vm86_regs *) regs,
 				error_code, 1);
 		preempt_conditional_cli(regs);
-		dec_debug_stack_usage();
+		debug_stack_usage_dec();
 		return;
 	}
=20
@@ -450,7 +450,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *r=
egs, long error_code)
 	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS) || user_icebp)
 		send_sigtrap(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
-	dec_debug_stack_usage();
+	debug_stack_usage_dec();
=20
 	return;
 }

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8qHOAAoJEIy3vGnGbaoATWQQAJvf2mh8ENkqiAZekk5nbEmT
pl49Nzll84UAtKqd6HBL9JiKHGGhoqScnzpg1jFJ0kukM2QoaJkc71BwC7RWBNKS
pH4pbluvWiAKakz0XaLv4jsRgNBGR3Q7bEdZPtkMND1G9+KYcWgBXuD/RkBMEI3/
UuNtZc/yxfeesrgPcYa3s0HB3kZcWrVRg0VsFl65ltrBlS+wc4pL9FRLJ1EAYNB7
cEWlb3apxiWttMboHzcbRubTFo7GN02637wHqWEz2g8Tp0v8NAyUhKDR4Wn6z/Ln
VjTQSRP9AJffuiS8U4Gxp+fzwNnA5XAf+Rorfh4ofW6JF4WffVvTJtNm0yIBNiUt
lPtpoR5vfDkKraCEdB+WNTnDn8FQa819Nh8s3fHLtcRz0uKh00P+1vv8iLNlP6pu
G0ce2QcuzQjNo8qJ5pdB+b+Yhc+UlKuzAY803I6lyke2QvxVPaFHnRbECPJTUZRf
SYLDh2jkpG8ba5tZjfQyIhu4LmwaonuYfPje2oyC+yIVx7T9rOefEJ1u0a7UZ3Rq
HEeRJbSNZ9AN6ptOqka2tmu4jUM9EvIDfmMIIf9puzFEcFKv5tUMPSOgHOsPxi+j
L07QSnlXWrDWEVUmkvT+UMqI4/yy9VkQv+C83TOzFOEig8+zEuOtHC1iM59LV1BW
0DKX9zWeawQZmDMLioXg
=B71j
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
