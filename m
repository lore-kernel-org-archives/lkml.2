Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103Ab2JATDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:03:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47430 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2JATDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:03:05 -0400
Date: Mon, 1 Oct 2012 21:02:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: [GIT PULL] x86/smap changes for v3.7
Message-ID: <20121001190259.GA27789@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-smap-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-smap-for-linus

   HEAD: b2cc2a074de75671bbed5e2dda67a9252ef353ea x86, smep, smap: Make the switching functions one-way

This adds support for the SMAP (Supervisor Mode Access 
Prevention) CPU feature on Intel CPUs: a hardware feature that 
prevents unintended user-space data access from kernel 
privileged code.

It's turned on automatically when possible.

This, in combination with SMEP, makes it even harder to exploit 
kernel bugs such as NULL pointer dereferences.

 Thanks,

	Ingo

------------------>
H. Peter Anvin (16):
      x86, cpufeature: Add feature bit for SMAP
      x86-32, mm: The WP test should be done on a kernel page
      x86, smap: Add CR4 bit for SMAP
      x86, alternative: Use .pushsection/.popsection
      x86, alternative: Add header guards to <asm/alternative-asm.h>
      x86, smap: Add a header file with macros for STAC/CLAC
      x86, uaccess: Merge prototypes for clear_user/__clear_user
      x86, smap: Add STAC and CLAC instructions to control user space access
      x86, smap: Turn on Supervisor Mode Access Prevention
      x86, smap: A page fault due to SMAP is an oops
      x86, smap: Reduce the SMAP overhead for signal handling
      x86-32, smap: Add STAC/CLAC instructions to 32-bit kernel entry
      x86, smap: Do not abuse the [f][x]rstor_checking() functions for user space
      x86-32: Start out eflags and cr4 clean
      x86, suspend: On wakeup always initialize cr4 and EFER
      x86, smep, smap: Make the switching functions one-way


 Documentation/kernel-parameters.txt    |  6 ++-
 arch/x86/Kconfig                       | 11 ++++
 arch/x86/ia32/ia32_signal.c            | 13 +++--
 arch/x86/ia32/ia32entry.S              |  6 +++
 arch/x86/include/asm/alternative-asm.h |  9 +++-
 arch/x86/include/asm/alternative.h     | 32 ++++++------
 arch/x86/include/asm/cpufeature.h      |  1 +
 arch/x86/include/asm/fpu-internal.h    | 42 ++++++++++++++--
 arch/x86/include/asm/futex.h           | 19 ++++---
 arch/x86/include/asm/processor-flags.h |  1 +
 arch/x86/include/asm/smap.h            | 91 ++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/uaccess.h         | 28 +++++++----
 arch/x86/include/asm/uaccess_32.h      |  3 --
 arch/x86/include/asm/uaccess_64.h      |  3 --
 arch/x86/include/asm/xsave.h           | 10 ++--
 arch/x86/kernel/acpi/sleep.c           | 15 ++++--
 arch/x86/kernel/cpu/common.c           | 44 ++++++++++------
 arch/x86/kernel/entry_32.S             | 26 ++++++++++
 arch/x86/kernel/entry_64.S             | 11 +++-
 arch/x86/kernel/head_32.S              | 31 ++++++------
 arch/x86/kernel/signal.c               | 24 +++++----
 arch/x86/kernel/xsave.c                |  6 +--
 arch/x86/lib/copy_user_64.S            |  7 +++
 arch/x86/lib/copy_user_nocache_64.S    |  3 ++
 arch/x86/lib/getuser.S                 | 10 ++++
 arch/x86/lib/putuser.S                 |  8 ++-
 arch/x86/lib/usercopy_32.c             | 13 ++++-
 arch/x86/lib/usercopy_64.c             |  3 ++
 arch/x86/mm/fault.c                    | 18 +++++++
 arch/x86/mm/init_32.c                  |  2 +-
 arch/x86/realmode/rm/wakeup.h          |  2 +
 arch/x86/realmode/rm/wakeup_asm.S      | 29 +++++++----
 32 files changed, 411 insertions(+), 116 deletions(-)
 create mode 100644 arch/x86/include/asm/smap.h

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 46a6a82..c298e9d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1812,8 +1812,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			noexec=on: enable non-executable mappings (default)
 			noexec=off: disable non-executable mappings
 
+	nosmap		[X86]
+			Disable SMAP (Supervisor Mode Access Prevention)
+			even if it is supported by processor.
+
 	nosmep		[X86]
-			Disable SMEP (Supervisor Mode Execution Protection)
+			Disable SMEP (Supervisor Mode Execution Prevention)
 			even if it is supported by processor.
 
 	noexec32	[X86-64]
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..5ce8694 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1487,6 +1487,17 @@ config ARCH_RANDOM
 	  If supported, this is a high bandwidth, cryptographically
 	  secure hardware random number generator.
 
+config X86_SMAP
+	def_bool y
+	prompt "Supervisor Mode Access Prevention" if EXPERT
+	---help---
+	  Supervisor Mode Access Prevention (SMAP) is a security
+	  feature in newer Intel processors.  There is a small
+	  performance cost if this enabled and turned on; there is
+	  also a small increase in the kernel size if this is enabled.
+
+	  If unsure, say Y.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 8c77c64..efc6a95 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -32,6 +32,7 @@
 #include <asm/sigframe.h>
 #include <asm/sighandling.h>
 #include <asm/sys_ia32.h>
+#include <asm/smap.h>
 
 #define FIX_EFLAGS	__FIX_EFLAGS
 
@@ -251,11 +252,12 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 
 		get_user_ex(tmp, &sc->fpstate);
 		buf = compat_ptr(tmp);
-		err |= restore_xstate_sig(buf, 1);
 
 		get_user_ex(*pax, &sc->ax);
 	} get_user_catch(err);
 
+	err |= restore_xstate_sig(buf, 1);
+
 	return err;
 }
 
@@ -506,7 +508,6 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		put_user_ex(sig, &frame->sig);
 		put_user_ex(ptr_to_compat(&frame->info), &frame->pinfo);
 		put_user_ex(ptr_to_compat(&frame->uc), &frame->puc);
-		err |= copy_siginfo_to_user32(&frame->info, info);
 
 		/* Create the ucontext.  */
 		if (cpu_has_xsave)
@@ -518,9 +519,6 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		put_user_ex(sas_ss_flags(regs->sp),
 			    &frame->uc.uc_stack.ss_flags);
 		put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-		err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
-					     regs, set->sig[0]);
-		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 		if (ka->sa.sa_flags & SA_RESTORER)
 			restorer = ka->sa.sa_restorer;
@@ -536,6 +534,11 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		put_user_ex(*((u64 *)&code), (u64 __user *)frame->retcode);
 	} put_user_catch(err);
 
+	err |= copy_siginfo_to_user32(&frame->info, info);
+	err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
+				     regs, set->sig[0]);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
 	if (err)
 		return -EFAULT;
 
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 20e5f7b..9c28950 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -14,6 +14,7 @@
 #include <asm/segment.h>
 #include <asm/irqflags.h>
 #include <asm/asm.h>
+#include <asm/smap.h>
 #include <linux/linkage.h>
 #include <linux/err.h>
 
@@ -146,8 +147,10 @@ ENTRY(ia32_sysenter_target)
 	SAVE_ARGS 0,1,0
  	/* no need to do an access_ok check here because rbp has been
  	   32bit zero extended */ 
+	ASM_STAC
 1:	movl	(%rbp),%ebp
 	_ASM_EXTABLE(1b,ia32_badarg)
+	ASM_CLAC
 	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	CFI_REMEMBER_STATE
@@ -301,8 +304,10 @@ ENTRY(ia32_cstar_target)
 	/* no need to do an access_ok check here because r8 has been
 	   32bit zero extended */ 
 	/* hardware stack frame is complete now */	
+	ASM_STAC
 1:	movl	(%r8),%r9d
 	_ASM_EXTABLE(1b,ia32_badarg)
+	ASM_CLAC
 	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	CFI_REMEMBER_STATE
@@ -365,6 +370,7 @@ cstar_tracesys:
 END(ia32_cstar_target)
 				
 ia32_badarg:
+	ASM_CLAC
 	movq $-EFAULT,%rax
 	jmp ia32_sysret
 	CFI_ENDPROC
diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index 952bd01..372231c 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_X86_ALTERNATIVE_ASM_H
+#define _ASM_X86_ALTERNATIVE_ASM_H
+
 #ifdef __ASSEMBLY__
 
 #include <asm/asm.h>
@@ -5,10 +8,10 @@
 #ifdef CONFIG_SMP
 	.macro LOCK_PREFIX
 672:	lock
-	.section .smp_locks,"a"
+	.pushsection .smp_locks,"a"
 	.balign 4
 	.long 672b - .
-	.previous
+	.popsection
 	.endm
 #else
 	.macro LOCK_PREFIX
@@ -24,3 +27,5 @@
 .endm
 
 #endif  /*  __ASSEMBLY__  */
+
+#endif /* _ASM_X86_ALTERNATIVE_ASM_H */
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 7078068..87bc00d 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -29,10 +29,10 @@
 
 #ifdef CONFIG_SMP
 #define LOCK_PREFIX_HERE \
-		".section .smp_locks,\"a\"\n"	\
-		".balign 4\n"			\
-		".long 671f - .\n" /* offset */	\
-		".previous\n"			\
+		".pushsection .smp_locks,\"a\"\n"	\
+		".balign 4\n"				\
+		".long 671f - .\n" /* offset */		\
+		".popsection\n"				\
 		"671:"
 
 #define LOCK_PREFIX LOCK_PREFIX_HERE "\n\tlock; "
@@ -99,30 +99,30 @@ static inline int alternatives_text_reserved(void *start, void *end)
 /* alternative assembly primitive: */
 #define ALTERNATIVE(oldinstr, newinstr, feature)			\
 	OLDINSTR(oldinstr)						\
-	".section .altinstructions,\"a\"\n"				\
+	".pushsection .altinstructions,\"a\"\n"				\
 	ALTINSTR_ENTRY(feature, 1)					\
-	".previous\n"							\
-	".section .discard,\"aw\",@progbits\n"				\
+	".popsection\n"							\
+	".pushsection .discard,\"aw\",@progbits\n"			\
 	DISCARD_ENTRY(1)						\
-	".previous\n"							\
-	".section .altinstr_replacement, \"ax\"\n"			\
+	".popsection\n"							\
+	".pushsection .altinstr_replacement, \"ax\"\n"			\
 	ALTINSTR_REPLACEMENT(newinstr, feature, 1)			\
-	".previous"
+	".popsection"
 
 #define ALTERNATIVE_2(oldinstr, newinstr1, feature1, newinstr2, feature2)\
 	OLDINSTR(oldinstr)						\
-	".section .altinstructions,\"a\"\n"				\
+	".pushsection .altinstructions,\"a\"\n"				\
 	ALTINSTR_ENTRY(feature1, 1)					\
 	ALTINSTR_ENTRY(feature2, 2)					\
-	".previous\n"							\
-	".section .discard,\"aw\",@progbits\n"				\
+	".popsection\n"							\
+	".pushsection .discard,\"aw\",@progbits\n"			\
 	DISCARD_ENTRY(1)						\
 	DISCARD_ENTRY(2)						\
-	".previous\n"							\
-	".section .altinstr_replacement, \"ax\"\n"			\
+	".popsection\n"							\
+	".pushsection .altinstr_replacement, \"ax\"\n"			\
 	ALTINSTR_REPLACEMENT(newinstr1, feature1, 1)			\
 	ALTINSTR_REPLACEMENT(newinstr2, feature2, 2)			\
-	".previous"
+	".popsection"
 
 /*
  * This must be included *after* the definition of ALTERNATIVE due to
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0debdb5..16cae42 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -210,6 +210,7 @@
 #define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
 #define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
+#define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 92f3c6e..831dbb9 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -21,6 +21,7 @@
 #include <asm/user.h>
 #include <asm/uaccess.h>
 #include <asm/xsave.h>
+#include <asm/smap.h>
 
 #ifdef CONFIG_X86_64
 # include <asm/sigcontext32.h>
@@ -121,6 +122,22 @@ static inline void sanitize_i387_state(struct task_struct *tsk)
 	__sanitize_i387_state(tsk);
 }
 
+#define user_insn(insn, output, input...)				\
+({									\
+	int err;							\
+	asm volatile(ASM_STAC "\n"					\
+		     "1:" #insn "\n\t"					\
+		     "2: " ASM_CLAC "\n"				\
+		     ".section .fixup,\"ax\"\n"				\
+		     "3:  movl $-1,%[err]\n"				\
+		     "    jmp  2b\n"					\
+		     ".previous\n"					\
+		     _ASM_EXTABLE(1b, 3b)				\
+		     : [err] "=r" (err), output				\
+		     : "0"(0), input);					\
+	err;								\
+})
+
 #define check_insn(insn, output, input...)				\
 ({									\
 	int err;							\
@@ -138,18 +155,18 @@ static inline void sanitize_i387_state(struct task_struct *tsk)
 
 static inline int fsave_user(struct i387_fsave_struct __user *fx)
 {
-	return check_insn(fnsave %[fx]; fwait,  [fx] "=m" (*fx), "m" (*fx));
+	return user_insn(fnsave %[fx]; fwait,  [fx] "=m" (*fx), "m" (*fx));
 }
 
 static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 {
 	if (config_enabled(CONFIG_X86_32))
-		return check_insn(fxsave %[fx], [fx] "=m" (*fx), "m" (*fx));
+		return user_insn(fxsave %[fx], [fx] "=m" (*fx), "m" (*fx));
 	else if (config_enabled(CONFIG_AS_FXSAVEQ))
-		return check_insn(fxsaveq %[fx], [fx] "=m" (*fx), "m" (*fx));
+		return user_insn(fxsaveq %[fx], [fx] "=m" (*fx), "m" (*fx));
 
 	/* See comment in fpu_fxsave() below. */
-	return check_insn(rex64/fxsave (%[fx]), "=m" (*fx), [fx] "R" (fx));
+	return user_insn(rex64/fxsave (%[fx]), "=m" (*fx), [fx] "R" (fx));
 }
 
 static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
@@ -164,11 +181,28 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 			  "m" (*fx));
 }
 
+static inline int fxrstor_user(struct i387_fxsave_struct __user *fx)
+{
+	if (config_enabled(CONFIG_X86_32))
+		return user_insn(fxrstor %[fx], "=m" (*fx), [fx] "m" (*fx));
+	else if (config_enabled(CONFIG_AS_FXSAVEQ))
+		return user_insn(fxrstorq %[fx], "=m" (*fx), [fx] "m" (*fx));
+
+	/* See comment in fpu_fxsave() below. */
+	return user_insn(rex64/fxrstor (%[fx]), "=m" (*fx), [fx] "R" (fx),
+			  "m" (*fx));
+}
+
 static inline int frstor_checking(struct i387_fsave_struct *fx)
 {
 	return check_insn(frstor %[fx], "=m" (*fx), [fx] "m" (*fx));
 }
 
+static inline int frstor_user(struct i387_fsave_struct __user *fx)
+{
+	return user_insn(frstor %[fx], "=m" (*fx), [fx] "m" (*fx));
+}
+
 static inline void fpu_fxsave(struct fpu *fpu)
 {
 	if (config_enabled(CONFIG_X86_32))
diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
index 71ecbcb..f373046 100644
--- a/arch/x86/include/asm/futex.h
+++ b/arch/x86/include/asm/futex.h
@@ -9,10 +9,13 @@
 #include <asm/asm.h>
 #include <asm/errno.h>
 #include <asm/processor.h>
+#include <asm/smap.h>
 
 #define __futex_atomic_op1(insn, ret, oldval, uaddr, oparg)	\
-	asm volatile("1:\t" insn "\n"				\
-		     "2:\t.section .fixup,\"ax\"\n"		\
+	asm volatile("\t" ASM_STAC "\n"				\
+		     "1:\t" insn "\n"				\
+		     "2:\t" ASM_CLAC "\n"			\
+		     "\t.section .fixup,\"ax\"\n"		\
 		     "3:\tmov\t%3, %1\n"			\
 		     "\tjmp\t2b\n"				\
 		     "\t.previous\n"				\
@@ -21,12 +24,14 @@
 		     : "i" (-EFAULT), "0" (oparg), "1" (0))
 
 #define __futex_atomic_op2(insn, ret, oldval, uaddr, oparg)	\
-	asm volatile("1:\tmovl	%2, %0\n"			\
+	asm volatile("\t" ASM_STAC "\n"				\
+		     "1:\tmovl	%2, %0\n"			\
 		     "\tmovl\t%0, %3\n"				\
 		     "\t" insn "\n"				\
 		     "2:\t" LOCK_PREFIX "cmpxchgl %3, %2\n"	\
 		     "\tjnz\t1b\n"				\
-		     "3:\t.section .fixup,\"ax\"\n"		\
+		     "3:\t" ASM_CLAC "\n"			\
+		     "\t.section .fixup,\"ax\"\n"		\
 		     "4:\tmov\t%5, %1\n"			\
 		     "\tjmp\t3b\n"				\
 		     "\t.previous\n"				\
@@ -122,8 +127,10 @@ static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
-	asm volatile("1:\t" LOCK_PREFIX "cmpxchgl %4, %2\n"
-		     "2:\t.section .fixup, \"ax\"\n"
+	asm volatile("\t" ASM_STAC "\n"
+		     "1:\t" LOCK_PREFIX "cmpxchgl %4, %2\n"
+		     "2:\t" ASM_CLAC "\n"
+		     "\t.section .fixup, \"ax\"\n"
 		     "3:\tmov     %3, %0\n"
 		     "\tjmp     2b\n"
 		     "\t.previous\n"
diff --git a/arch/x86/include/asm/processor-flags.h b/arch/x86/include/asm/processor-flags.h
index aea1d1d..680cf09 100644
--- a/arch/x86/include/asm/processor-flags.h
+++ b/arch/x86/include/asm/processor-flags.h
@@ -65,6 +65,7 @@
 #define X86_CR4_PCIDE	0x00020000 /* enable PCID support */
 #define X86_CR4_OSXSAVE 0x00040000 /* enable xsave and xrestore */
 #define X86_CR4_SMEP	0x00100000 /* enable SMEP support */
+#define X86_CR4_SMAP	0x00200000 /* enable SMAP support */
 
 /*
  * x86-64 Task Priority Register, CR8
diff --git a/arch/x86/include/asm/smap.h b/arch/x86/include/asm/smap.h
new file mode 100644
index 0000000..8d3120f
--- /dev/null
+++ b/arch/x86/include/asm/smap.h
@@ -0,0 +1,91 @@
+/*
+ * Supervisor Mode Access Prevention support
+ *
+ * Copyright (C) 2012 Intel Corporation
+ * Author: H. Peter Anvin <hpa@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#ifndef _ASM_X86_SMAP_H
+#define _ASM_X86_SMAP_H
+
+#include <linux/stringify.h>
+#include <asm/nops.h>
+#include <asm/cpufeature.h>
+
+/* "Raw" instruction opcodes */
+#define __ASM_CLAC	.byte 0x0f,0x01,0xca
+#define __ASM_STAC	.byte 0x0f,0x01,0xcb
+
+#ifdef __ASSEMBLY__
+
+#include <asm/alternative-asm.h>
+
+#ifdef CONFIG_X86_SMAP
+
+#define ASM_CLAC							\
+	661: ASM_NOP3 ;							\
+	.pushsection .altinstr_replacement, "ax" ;			\
+	662: __ASM_CLAC ;						\
+	.popsection ;							\
+	.pushsection .altinstructions, "a" ;				\
+	altinstruction_entry 661b, 662b, X86_FEATURE_SMAP, 3, 3 ;	\
+	.popsection
+
+#define ASM_STAC							\
+	661: ASM_NOP3 ;							\
+	.pushsection .altinstr_replacement, "ax" ;			\
+	662: __ASM_STAC ;						\
+	.popsection ;							\
+	.pushsection .altinstructions, "a" ;				\
+	altinstruction_entry 661b, 662b, X86_FEATURE_SMAP, 3, 3 ;	\
+	.popsection
+
+#else /* CONFIG_X86_SMAP */
+
+#define ASM_CLAC
+#define ASM_STAC
+
+#endif /* CONFIG_X86_SMAP */
+
+#else /* __ASSEMBLY__ */
+
+#include <asm/alternative.h>
+
+#ifdef CONFIG_X86_SMAP
+
+static __always_inline void clac(void)
+{
+	/* Note: a barrier is implicit in alternative() */
+	alternative(ASM_NOP3, __stringify(__ASM_CLAC), X86_FEATURE_SMAP);
+}
+
+static __always_inline void stac(void)
+{
+	/* Note: a barrier is implicit in alternative() */
+	alternative(ASM_NOP3, __stringify(__ASM_STAC), X86_FEATURE_SMAP);
+}
+
+/* These macros can be used in asm() statements */
+#define ASM_CLAC \
+	ALTERNATIVE(ASM_NOP3, __stringify(__ASM_CLAC), X86_FEATURE_SMAP)
+#define ASM_STAC \
+	ALTERNATIVE(ASM_NOP3, __stringify(__ASM_STAC), X86_FEATURE_SMAP)
+
+#else /* CONFIG_X86_SMAP */
+
+static inline void clac(void) { }
+static inline void stac(void) { }
+
+#define ASM_CLAC
+#define ASM_STAC
+
+#endif /* CONFIG_X86_SMAP */
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_X86_SMAP_H */
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index e1f3a17..a91acfb 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -9,6 +9,7 @@
 #include <linux/string.h>
 #include <asm/asm.h>
 #include <asm/page.h>
+#include <asm/smap.h>
 
 #define VERIFY_READ 0
 #define VERIFY_WRITE 1
@@ -192,9 +193,10 @@ extern int __get_user_bad(void);
 
 #ifdef CONFIG_X86_32
 #define __put_user_asm_u64(x, addr, err, errret)			\
-	asm volatile("1:	movl %%eax,0(%2)\n"			\
+	asm volatile(ASM_STAC "\n"					\
+		     "1:	movl %%eax,0(%2)\n"			\
 		     "2:	movl %%edx,4(%2)\n"			\
-		     "3:\n"						\
+		     "3: " ASM_CLAC "\n"				\
 		     ".section .fixup,\"ax\"\n"				\
 		     "4:	movl %3,%0\n"				\
 		     "	jmp 3b\n"					\
@@ -205,9 +207,10 @@ extern int __get_user_bad(void);
 		     : "A" (x), "r" (addr), "i" (errret), "0" (err))
 
 #define __put_user_asm_ex_u64(x, addr)					\
-	asm volatile("1:	movl %%eax,0(%1)\n"			\
+	asm volatile(ASM_STAC "\n"					\
+		     "1:	movl %%eax,0(%1)\n"			\
 		     "2:	movl %%edx,4(%1)\n"			\
-		     "3:\n"						\
+		     "3: " ASM_CLAC "\n"				\
 		     _ASM_EXTABLE_EX(1b, 2b)				\
 		     _ASM_EXTABLE_EX(2b, 3b)				\
 		     : : "A" (x), "r" (addr))
@@ -379,8 +382,9 @@ do {									\
 } while (0)
 
 #define __get_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
-	asm volatile("1:	mov"itype" %2,%"rtype"1\n"		\
-		     "2:\n"						\
+	asm volatile(ASM_STAC "\n"					\
+		     "1:	mov"itype" %2,%"rtype"1\n"		\
+		     "2: " ASM_CLAC "\n"				\
 		     ".section .fixup,\"ax\"\n"				\
 		     "3:	mov %3,%0\n"				\
 		     "	xor"itype" %"rtype"1,%"rtype"1\n"		\
@@ -443,8 +447,9 @@ struct __large_struct { unsigned long buf[100]; };
  * aliasing issues.
  */
 #define __put_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
-	asm volatile("1:	mov"itype" %"rtype"1,%2\n"		\
-		     "2:\n"						\
+	asm volatile(ASM_STAC "\n"					\
+		     "1:	mov"itype" %"rtype"1,%2\n"		\
+		     "2: " ASM_CLAC "\n"				\
 		     ".section .fixup,\"ax\"\n"				\
 		     "3:	mov %3,%0\n"				\
 		     "	jmp 2b\n"					\
@@ -463,13 +468,13 @@ struct __large_struct { unsigned long buf[100]; };
  * uaccess_try and catch
  */
 #define uaccess_try	do {						\
-	int prev_err = current_thread_info()->uaccess_err;		\
 	current_thread_info()->uaccess_err = 0;				\
+	stac();								\
 	barrier();
 
 #define uaccess_catch(err)						\
+	clac();								\
 	(err) |= (current_thread_info()->uaccess_err ? -EFAULT : 0);	\
-	current_thread_info()->uaccess_err = prev_err;			\
 } while (0)
 
 /**
@@ -569,6 +574,9 @@ strncpy_from_user(char *dst, const char __user *src, long count);
 extern __must_check long strlen_user(const char __user *str);
 extern __must_check long strnlen_user(const char __user *str, long n);
 
+unsigned long __must_check clear_user(void __user *mem, unsigned long len);
+unsigned long __must_check __clear_user(void __user *mem, unsigned long len);
+
 /*
  * movsl can be slow when source and dest are not both 8-byte aligned
  */
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 576e39b..7f760a9 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -213,7 +213,4 @@ static inline unsigned long __must_check copy_from_user(void *to,
 	return n;
 }
 
-unsigned long __must_check clear_user(void __user *mem, unsigned long len);
-unsigned long __must_check __clear_user(void __user *mem, unsigned long len);
-
 #endif /* _ASM_X86_UACCESS_32_H */
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index d8def8b..142810c 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -217,9 +217,6 @@ int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 	}
 }
 
-__must_check unsigned long clear_user(void __user *mem, unsigned long len);
-__must_check unsigned long __clear_user(void __user *mem, unsigned long len);
-
 static __must_check __always_inline int
 __copy_from_user_inatomic(void *dst, const void __user *src, unsigned size)
 {
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 2ddee1b8..0415cda 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -70,8 +70,9 @@ static inline int xsave_user(struct xsave_struct __user *buf)
 	if (unlikely(err))
 		return -EFAULT;
 
-	__asm__ __volatile__("1: .byte " REX_PREFIX "0x0f,0xae,0x27\n"
-			     "2:\n"
+	__asm__ __volatile__(ASM_STAC "\n"
+			     "1: .byte " REX_PREFIX "0x0f,0xae,0x27\n"
+			     "2: " ASM_CLAC "\n"
 			     ".section .fixup,\"ax\"\n"
 			     "3:  movl $-1,%[err]\n"
 			     "    jmp  2b\n"
@@ -90,8 +91,9 @@ static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
 
-	__asm__ __volatile__("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n"
-			     "2:\n"
+	__asm__ __volatile__(ASM_STAC "\n"
+			     "1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n"
+			     "2: " ASM_CLAC "\n"
 			     ".section .fixup,\"ax\"\n"
 			     "3:  movl $-1,%[err]\n"
 			     "    jmp  2b\n"
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 1b8e5a0..11676cf 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -43,17 +43,22 @@ int acpi_suspend_lowlevel(void)
 
 	header->video_mode = saved_video_mode;
 
+	header->pmode_behavior = 0;
+
 #ifndef CONFIG_64BIT
 	store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
-	if (rdmsr_safe(MSR_EFER, &header->pmode_efer_low,
-		       &header->pmode_efer_high))
-		header->pmode_efer_low = header->pmode_efer_high = 0;
+	if (!rdmsr_safe(MSR_EFER,
+			&header->pmode_efer_low,
+			&header->pmode_efer_high))
+		header->pmode_behavior |= (1 << WAKEUP_BEHAVIOR_RESTORE_EFER);
 #endif /* !CONFIG_64BIT */
 
 	header->pmode_cr0 = read_cr0();
-	header->pmode_cr4 = read_cr4_safe();
-	header->pmode_behavior = 0;
+	if (__this_cpu_read(cpu_info.cpuid_level) >= 0) {
+		header->pmode_cr4 = read_cr4();
+		header->pmode_behavior |= (1 << WAKEUP_BEHAVIOR_RESTORE_CR4);
+	}
 	if (!rdmsr_safe(MSR_IA32_MISC_ENABLE,
 			&header->pmode_misc_en_low,
 			&header->pmode_misc_en_high))
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b0fe078..fefd9b7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -259,23 +259,36 @@ static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 }
 #endif
 
-static int disable_smep __cpuinitdata;
 static __init int setup_disable_smep(char *arg)
 {
-	disable_smep = 1;
+	setup_clear_cpu_cap(X86_FEATURE_SMEP);
 	return 1;
 }
 __setup("nosmep", setup_disable_smep);
 
-static __cpuinit void setup_smep(struct cpuinfo_x86 *c)
+static __always_inline void setup_smep(struct cpuinfo_x86 *c)
 {
-	if (cpu_has(c, X86_FEATURE_SMEP)) {
-		if (unlikely(disable_smep)) {
-			setup_clear_cpu_cap(X86_FEATURE_SMEP);
-			clear_in_cr4(X86_CR4_SMEP);
-		} else
-			set_in_cr4(X86_CR4_SMEP);
-	}
+	if (cpu_has(c, X86_FEATURE_SMEP))
+		set_in_cr4(X86_CR4_SMEP);
+}
+
+static __init int setup_disable_smap(char *arg)
+{
+	setup_clear_cpu_cap(X86_FEATURE_SMAP);
+	return 1;
+}
+__setup("nosmap", setup_disable_smap);
+
+static __always_inline void setup_smap(struct cpuinfo_x86 *c)
+{
+	unsigned long eflags;
+
+	/* This should have been cleared long ago */
+	raw_local_save_flags(eflags);
+	BUG_ON(eflags & X86_EFLAGS_AC);
+
+	if (cpu_has(c, X86_FEATURE_SMAP))
+		set_in_cr4(X86_CR4_SMAP);
 }
 
 /*
@@ -712,8 +725,6 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	c->cpu_index = 0;
 	filter_cpuid_features(c, false);
 
-	setup_smep(c);
-
 	if (this_cpu->c_bsp_init)
 		this_cpu->c_bsp_init(c);
 }
@@ -798,8 +809,6 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 		c->phys_proc_id = c->initial_apicid;
 	}
 
-	setup_smep(c);
-
 	get_model_name(c); /* Default name */
 
 	detect_nopl(c);
@@ -864,6 +873,10 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	/* Disable the PN if appropriate */
 	squash_the_stupid_serial_number(c);
 
+	/* Set up SMEP/SMAP */
+	setup_smep(c);
+	setup_smap(c);
+
 	/*
 	 * The vendor-specific functions might have changed features.
 	 * Now we do "generic changes."
@@ -1113,7 +1126,8 @@ void syscall_init(void)
 
 	/* Flags to clear on syscall */
 	wrmsrl(MSR_SYSCALL_MASK,
-	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
+	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|
+	       X86_EFLAGS_IOPL|X86_EFLAGS_AC);
 }
 
 unsigned long kernel_eflags;
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 623f288..9ebbeca 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -57,6 +57,7 @@
 #include <asm/cpufeature.h>
 #include <asm/alternative-asm.h>
 #include <asm/asm.h>
+#include <asm/smap.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
 #include <linux/elf-em.h>
@@ -407,7 +408,9 @@ sysenter_past_esp:
  */
 	cmpl $__PAGE_OFFSET-3,%ebp
 	jae syscall_fault
+	ASM_STAC
 1:	movl (%ebp),%ebp
+	ASM_CLAC
 	movl %ebp,PT_EBP(%esp)
 	_ASM_EXTABLE(1b,syscall_fault)
 
@@ -488,6 +491,7 @@ ENDPROC(ia32_sysenter_target)
 	# system call handler stub
 ENTRY(system_call)
 	RING0_INT_FRAME			# can't unwind into user space anyway
+	ASM_CLAC
 	pushl_cfi %eax			# save orig_eax
 	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
@@ -670,6 +674,7 @@ END(syscall_exit_work)
 
 	RING0_INT_FRAME			# can't unwind into user space anyway
 syscall_fault:
+	ASM_CLAC
 	GET_THREAD_INFO(%ebp)
 	movl $-EFAULT,PT_EAX(%esp)
 	jmp resume_userspace
@@ -825,6 +830,7 @@ END(interrupt)
  */
 	.p2align CONFIG_X86_L1_CACHE_SHIFT
 common_interrupt:
+	ASM_CLAC
 	addl $-0x80,(%esp)	/* Adjust vector into the [-256,-1] range */
 	SAVE_ALL
 	TRACE_IRQS_OFF
@@ -841,6 +847,7 @@ ENDPROC(common_interrupt)
 #define BUILD_INTERRUPT3(name, nr, fn)	\
 ENTRY(name)				\
 	RING0_INT_FRAME;		\
+	ASM_CLAC;			\
 	pushl_cfi $~(nr);		\
 	SAVE_ALL;			\
 	TRACE_IRQS_OFF			\
@@ -857,6 +864,7 @@ ENDPROC(name)
 
 ENTRY(coprocessor_error)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 	pushl_cfi $do_coprocessor_error
 	jmp error_code
@@ -865,6 +873,7 @@ END(coprocessor_error)
 
 ENTRY(simd_coprocessor_error)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 #ifdef CONFIG_X86_INVD_BUG
 	/* AMD 486 bug: invd from userspace calls exception 19 instead of #GP */
@@ -886,6 +895,7 @@ END(simd_coprocessor_error)
 
 ENTRY(device_not_available)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $-1			# mark this as an int
 	pushl_cfi $do_device_not_available
 	jmp error_code
@@ -906,6 +916,7 @@ END(native_irq_enable_sysexit)
 
 ENTRY(overflow)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 	pushl_cfi $do_overflow
 	jmp error_code
@@ -914,6 +925,7 @@ END(overflow)
 
 ENTRY(bounds)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 	pushl_cfi $do_bounds
 	jmp error_code
@@ -922,6 +934,7 @@ END(bounds)
 
 ENTRY(invalid_op)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 	pushl_cfi $do_invalid_op
 	jmp error_code
@@ -930,6 +943,7 @@ END(invalid_op)
 
 ENTRY(coprocessor_segment_overrun)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 	pushl_cfi $do_coprocessor_segment_overrun
 	jmp error_code
@@ -938,6 +952,7 @@ END(coprocessor_segment_overrun)
 
 ENTRY(invalid_TSS)
 	RING0_EC_FRAME
+	ASM_CLAC
 	pushl_cfi $do_invalid_TSS
 	jmp error_code
 	CFI_ENDPROC
@@ -945,6 +960,7 @@ END(invalid_TSS)
 
 ENTRY(segment_not_present)
 	RING0_EC_FRAME
+	ASM_CLAC
 	pushl_cfi $do_segment_not_present
 	jmp error_code
 	CFI_ENDPROC
@@ -952,6 +968,7 @@ END(segment_not_present)
 
 ENTRY(stack_segment)
 	RING0_EC_FRAME
+	ASM_CLAC
 	pushl_cfi $do_stack_segment
 	jmp error_code
 	CFI_ENDPROC
@@ -959,6 +976,7 @@ END(stack_segment)
 
 ENTRY(alignment_check)
 	RING0_EC_FRAME
+	ASM_CLAC
 	pushl_cfi $do_alignment_check
 	jmp error_code
 	CFI_ENDPROC
@@ -966,6 +984,7 @@ END(alignment_check)
 
 ENTRY(divide_error)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0			# no error code
 	pushl_cfi $do_divide_error
 	jmp error_code
@@ -975,6 +994,7 @@ END(divide_error)
 #ifdef CONFIG_X86_MCE
 ENTRY(machine_check)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 	pushl_cfi machine_check_vector
 	jmp error_code
@@ -984,6 +1004,7 @@ END(machine_check)
 
 ENTRY(spurious_interrupt_bug)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $0
 	pushl_cfi $do_spurious_interrupt_bug
 	jmp error_code
@@ -1207,6 +1228,7 @@ return_to_handler:
 
 ENTRY(page_fault)
 	RING0_EC_FRAME
+	ASM_CLAC
 	pushl_cfi $do_page_fault
 	ALIGN
 error_code:
@@ -1279,6 +1301,7 @@ END(page_fault)
 
 ENTRY(debug)
 	RING0_INT_FRAME
+	ASM_CLAC
 	cmpl $ia32_sysenter_target,(%esp)
 	jne debug_stack_correct
 	FIX_STACK 12, debug_stack_correct, debug_esp_fix_insn
@@ -1303,6 +1326,7 @@ END(debug)
  */
 ENTRY(nmi)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi %eax
 	movl %ss, %eax
 	cmpw $__ESPFIX_SS, %ax
@@ -1373,6 +1397,7 @@ END(nmi)
 
 ENTRY(int3)
 	RING0_INT_FRAME
+	ASM_CLAC
 	pushl_cfi $-1			# mark this as an int
 	SAVE_ALL
 	TRACE_IRQS_OFF
@@ -1393,6 +1418,7 @@ END(general_protection)
 #ifdef CONFIG_KVM_GUEST
 ENTRY(async_page_fault)
 	RING0_EC_FRAME
+	ASM_CLAC
 	pushl_cfi $do_async_page_fault
 	jmp error_code
 	CFI_ENDPROC
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 69babd8..ce87e3d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -56,6 +56,7 @@
 #include <asm/ftrace.h>
 #include <asm/percpu.h>
 #include <asm/asm.h>
+#include <asm/smap.h>
 #include <linux/err.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
@@ -465,7 +466,8 @@ END(ret_from_fork)
  * System call entry. Up to 6 arguments in registers are supported.
  *
  * SYSCALL does not save anything on the stack and does not change the
- * stack pointer.
+ * stack pointer.  However, it does mask the flags register for us, so
+ * CLD and CLAC are not needed.
  */
 
 /*
@@ -884,6 +886,7 @@ END(interrupt)
 	 */
 	.p2align CONFIG_X86_L1_CACHE_SHIFT
 common_interrupt:
+	ASM_CLAC
 	XCPT_FRAME
 	addq $-0x80,(%rsp)		/* Adjust vector to [-256,-1] range */
 	interrupt do_IRQ
@@ -1023,6 +1026,7 @@ END(common_interrupt)
  */
 .macro apicinterrupt num sym do_sym
 ENTRY(\sym)
+	ASM_CLAC
 	INTR_FRAME
 	pushq_cfi $~(\num)
 .Lcommon_\sym:
@@ -1077,6 +1081,7 @@ apicinterrupt IRQ_WORK_VECTOR \
  */
 .macro zeroentry sym do_sym
 ENTRY(\sym)
+	ASM_CLAC
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
@@ -1094,6 +1099,7 @@ END(\sym)
 
 .macro paranoidzeroentry sym do_sym
 ENTRY(\sym)
+	ASM_CLAC
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
@@ -1112,6 +1118,7 @@ END(\sym)
 #define INIT_TSS_IST(x) PER_CPU_VAR(init_tss) + (TSS_ist + ((x) - 1) * 8)
 .macro paranoidzeroentry_ist sym do_sym ist
 ENTRY(\sym)
+	ASM_CLAC
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
@@ -1131,6 +1138,7 @@ END(\sym)
 
 .macro errorentry sym do_sym
 ENTRY(\sym)
+	ASM_CLAC
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	subq $ORIG_RAX-R15, %rsp
@@ -1149,6 +1157,7 @@ END(\sym)
 	/* error code is on the stack already */
 .macro paranoiderrorentry sym do_sym
 ENTRY(\sym)
+	ASM_CLAC
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	subq $ORIG_RAX-R15, %rsp
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index d42ab17..957a47a 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -287,27 +287,28 @@ ENTRY(startup_32_smp)
 	leal -__PAGE_OFFSET(%ecx),%esp
 
 default_entry:
-
 /*
  *	New page tables may be in 4Mbyte page mode and may
  *	be using the global pages. 
  *
  *	NOTE! If we are on a 486 we may have no cr4 at all!
- *	So we do not try to touch it unless we really have
- *	some bits in it to set.  This won't work if the BSP
- *	implements cr4 but this AP does not -- very unlikely
- *	but be warned!  The same applies to the pse feature
- *	if not equally supported. --macro
- *
- *	NOTE! We have to correct for the fact that we're
- *	not yet offset PAGE_OFFSET..
+ *	Specifically, cr4 exists if and only if CPUID exists,
+ *	which in turn exists if and only if EFLAGS.ID exists.
  */
-#define cr4_bits pa(mmu_cr4_features)
-	movl cr4_bits,%edx
-	andl %edx,%edx
-	jz 6f
-	movl %cr4,%eax		# Turn on paging options (PSE,PAE,..)
-	orl %edx,%eax
+	movl $X86_EFLAGS_ID,%ecx
+	pushl %ecx
+	popfl
+	pushfl
+	popl %eax
+	pushl $0
+	popfl
+	pushfl
+	popl %edx
+	xorl %edx,%eax
+	testl %ecx,%eax
+	jz 6f			# No ID flag = no CPUID = no CR4
+
+	movl pa(mmu_cr4_features),%eax
 	movl %eax,%cr4
 
 	testb $X86_CR4_PAE, %al		# check if PAE is enabled
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index e10f96a..036bddb 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -114,11 +114,12 @@ int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 		regs->orig_ax = -1;		/* disable syscall checks */
 
 		get_user_ex(buf, &sc->fpstate);
-		err |= restore_xstate_sig(buf, config_enabled(CONFIG_X86_32));
 
 		get_user_ex(*pax, &sc->ax);
 	} get_user_catch(err);
 
+	err |= restore_xstate_sig(buf, config_enabled(CONFIG_X86_32));
+
 	return err;
 }
 
@@ -355,7 +356,6 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		put_user_ex(sig, &frame->sig);
 		put_user_ex(&frame->info, &frame->pinfo);
 		put_user_ex(&frame->uc, &frame->puc);
-		err |= copy_siginfo_to_user(&frame->info, info);
 
 		/* Create the ucontext.  */
 		if (cpu_has_xsave)
@@ -367,9 +367,6 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		put_user_ex(sas_ss_flags(regs->sp),
 			    &frame->uc.uc_stack.ss_flags);
 		put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-		err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
-					regs, set->sig[0]);
-		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 		/* Set up to return from userspace.  */
 		restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
@@ -386,6 +383,11 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		 */
 		put_user_ex(*((u64 *)&rt_retcode), (u64 *)frame->retcode);
 	} put_user_catch(err);
+	
+	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
+				regs, set->sig[0]);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 	if (err)
 		return -EFAULT;
@@ -434,8 +436,6 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		put_user_ex(sas_ss_flags(regs->sp),
 			    &frame->uc.uc_stack.ss_flags);
 		put_user_ex(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
-		err |= setup_sigcontext(&frame->uc.uc_mcontext, fp, regs, set->sig[0]);
-		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 		/* Set up to return from userspace.  If provided, use a stub
 		   already in userspace.  */
@@ -448,6 +448,9 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		}
 	} put_user_catch(err);
 
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, fp, regs, set->sig[0]);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
 	if (err)
 		return -EFAULT;
 
@@ -504,9 +507,6 @@ static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
 			    &frame->uc.uc_stack.ss_flags);
 		put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
 		put_user_ex(0, &frame->uc.uc__pad0);
-		err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
-					regs, set->sig[0]);
-		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 		if (ka->sa.sa_flags & SA_RESTORER) {
 			restorer = ka->sa.sa_restorer;
@@ -518,6 +518,10 @@ static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
 		put_user_ex(restorer, &frame->pretcode);
 	} put_user_catch(err);
 
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
+				regs, set->sig[0]);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
 	if (err)
 		return -EFAULT;
 
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 4e89b3d..ada87a3 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -315,7 +315,7 @@ static inline int restore_user_xstate(void __user *buf, u64 xbv, int fx_only)
 		if ((unsigned long)buf % 64 || fx_only) {
 			u64 init_bv = pcntxt_mask & ~XSTATE_FPSSE;
 			xrstor_state(init_xstate_buf, init_bv);
-			return fxrstor_checking((__force void *) buf);
+			return fxrstor_user(buf);
 		} else {
 			u64 init_bv = pcntxt_mask & ~xbv;
 			if (unlikely(init_bv))
@@ -323,9 +323,9 @@ static inline int restore_user_xstate(void __user *buf, u64 xbv, int fx_only)
 			return xrestore_user(buf, xbv);
 		}
 	} else if (use_fxsr()) {
-		return fxrstor_checking((__force void *) buf);
+		return fxrstor_user(buf);
 	} else
-		return frstor_checking((__force void *) buf);
+		return frstor_user(buf);
 }
 
 int __restore_xstate_sig(void __user *buf, void __user *buf_fx, int size)
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 5b2995f..a30ca15 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -17,6 +17,7 @@
 #include <asm/cpufeature.h>
 #include <asm/alternative-asm.h>
 #include <asm/asm.h>
+#include <asm/smap.h>
 
 /*
  * By placing feature2 after feature1 in altinstructions section, we logically
@@ -130,6 +131,7 @@ ENDPROC(bad_from_user)
  */
 ENTRY(copy_user_generic_unrolled)
 	CFI_STARTPROC
+	ASM_STAC
 	cmpl $8,%edx
 	jb 20f		/* less then 8 bytes, go to byte copy loop */
 	ALIGN_DESTINATION
@@ -177,6 +179,7 @@ ENTRY(copy_user_generic_unrolled)
 	decl %ecx
 	jnz 21b
 23:	xor %eax,%eax
+	ASM_CLAC
 	ret
 
 	.section .fixup,"ax"
@@ -232,6 +235,7 @@ ENDPROC(copy_user_generic_unrolled)
  */
 ENTRY(copy_user_generic_string)
 	CFI_STARTPROC
+	ASM_STAC
 	andl %edx,%edx
 	jz 4f
 	cmpl $8,%edx
@@ -246,6 +250,7 @@ ENTRY(copy_user_generic_string)
 3:	rep
 	movsb
 4:	xorl %eax,%eax
+	ASM_CLAC
 	ret
 
 	.section .fixup,"ax"
@@ -273,12 +278,14 @@ ENDPROC(copy_user_generic_string)
  */
 ENTRY(copy_user_enhanced_fast_string)
 	CFI_STARTPROC
+	ASM_STAC
 	andl %edx,%edx
 	jz 2f
 	movl %edx,%ecx
 1:	rep
 	movsb
 2:	xorl %eax,%eax
+	ASM_CLAC
 	ret
 
 	.section .fixup,"ax"
diff --git a/arch/x86/lib/copy_user_nocache_64.S b/arch/x86/lib/copy_user_nocache_64.S
index cacddc7..6a4f43c 100644
--- a/arch/x86/lib/copy_user_nocache_64.S
+++ b/arch/x86/lib/copy_user_nocache_64.S
@@ -15,6 +15,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
 #include <asm/asm.h>
+#include <asm/smap.h>
 
 	.macro ALIGN_DESTINATION
 #ifdef FIX_ALIGNMENT
@@ -48,6 +49,7 @@
  */
 ENTRY(__copy_user_nocache)
 	CFI_STARTPROC
+	ASM_STAC
 	cmpl $8,%edx
 	jb 20f		/* less then 8 bytes, go to byte copy loop */
 	ALIGN_DESTINATION
@@ -95,6 +97,7 @@ ENTRY(__copy_user_nocache)
 	decl %ecx
 	jnz 21b
 23:	xorl %eax,%eax
+	ASM_CLAC
 	sfence
 	ret
 
diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
index b33b1fb..156b9c8 100644
--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -33,6 +33,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
 #include <asm/asm.h>
+#include <asm/smap.h>
 
 	.text
 ENTRY(__get_user_1)
@@ -40,8 +41,10 @@ ENTRY(__get_user_1)
 	GET_THREAD_INFO(%_ASM_DX)
 	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
+	ASM_STAC
 1:	movzb (%_ASM_AX),%edx
 	xor %eax,%eax
+	ASM_CLAC
 	ret
 	CFI_ENDPROC
 ENDPROC(__get_user_1)
@@ -53,8 +56,10 @@ ENTRY(__get_user_2)
 	GET_THREAD_INFO(%_ASM_DX)
 	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
+	ASM_STAC
 2:	movzwl -1(%_ASM_AX),%edx
 	xor %eax,%eax
+	ASM_CLAC
 	ret
 	CFI_ENDPROC
 ENDPROC(__get_user_2)
@@ -66,8 +71,10 @@ ENTRY(__get_user_4)
 	GET_THREAD_INFO(%_ASM_DX)
 	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
+	ASM_STAC
 3:	mov -3(%_ASM_AX),%edx
 	xor %eax,%eax
+	ASM_CLAC
 	ret
 	CFI_ENDPROC
 ENDPROC(__get_user_4)
@@ -80,8 +87,10 @@ ENTRY(__get_user_8)
 	GET_THREAD_INFO(%_ASM_DX)
 	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae	bad_get_user
+	ASM_STAC
 4:	movq -7(%_ASM_AX),%_ASM_DX
 	xor %eax,%eax
+	ASM_CLAC
 	ret
 	CFI_ENDPROC
 ENDPROC(__get_user_8)
@@ -91,6 +100,7 @@ bad_get_user:
 	CFI_STARTPROC
 	xor %edx,%edx
 	mov $(-EFAULT),%_ASM_AX
+	ASM_CLAC
 	ret
 	CFI_ENDPROC
 END(bad_get_user)
diff --git a/arch/x86/lib/putuser.S b/arch/x86/lib/putuser.S
index 7f951c8..fc6ba17 100644
--- a/arch/x86/lib/putuser.S
+++ b/arch/x86/lib/putuser.S
@@ -15,6 +15,7 @@
 #include <asm/thread_info.h>
 #include <asm/errno.h>
 #include <asm/asm.h>
+#include <asm/smap.h>
 
 
 /*
@@ -31,7 +32,8 @@
 
 #define ENTER	CFI_STARTPROC ; \
 		GET_THREAD_INFO(%_ASM_BX)
-#define EXIT	ret ; \
+#define EXIT	ASM_CLAC ;	\
+		ret ;		\
 		CFI_ENDPROC
 
 .text
@@ -39,6 +41,7 @@ ENTRY(__put_user_1)
 	ENTER
 	cmp TI_addr_limit(%_ASM_BX),%_ASM_CX
 	jae bad_put_user
+	ASM_STAC
 1:	movb %al,(%_ASM_CX)
 	xor %eax,%eax
 	EXIT
@@ -50,6 +53,7 @@ ENTRY(__put_user_2)
 	sub $1,%_ASM_BX
 	cmp %_ASM_BX,%_ASM_CX
 	jae bad_put_user
+	ASM_STAC
 2:	movw %ax,(%_ASM_CX)
 	xor %eax,%eax
 	EXIT
@@ -61,6 +65,7 @@ ENTRY(__put_user_4)
 	sub $3,%_ASM_BX
 	cmp %_ASM_BX,%_ASM_CX
 	jae bad_put_user
+	ASM_STAC
 3:	movl %eax,(%_ASM_CX)
 	xor %eax,%eax
 	EXIT
@@ -72,6 +77,7 @@ ENTRY(__put_user_8)
 	sub $7,%_ASM_BX
 	cmp %_ASM_BX,%_ASM_CX
 	jae bad_put_user
+	ASM_STAC
 4:	mov %_ASM_AX,(%_ASM_CX)
 #ifdef CONFIG_X86_32
 5:	movl %edx,4(%_ASM_CX)
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 1781b2f..98f6d6b6 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -42,10 +42,11 @@ do {									\
 	int __d0;							\
 	might_fault();							\
 	__asm__ __volatile__(						\
+		ASM_STAC "\n"						\
 		"0:	rep; stosl\n"					\
 		"	movl %2,%0\n"					\
 		"1:	rep; stosb\n"					\
-		"2:\n"							\
+		"2: " ASM_CLAC "\n"					\
 		".section .fixup,\"ax\"\n"				\
 		"3:	lea 0(%2,%0,4),%0\n"				\
 		"	jmp 2b\n"					\
@@ -626,10 +627,12 @@ survive:
 		return n;
 	}
 #endif
+	stac();
 	if (movsl_is_ok(to, from, n))
 		__copy_user(to, from, n);
 	else
 		n = __copy_user_intel(to, from, n);
+	clac();
 	return n;
 }
 EXPORT_SYMBOL(__copy_to_user_ll);
@@ -637,10 +640,12 @@ EXPORT_SYMBOL(__copy_to_user_ll);
 unsigned long __copy_from_user_ll(void *to, const void __user *from,
 					unsigned long n)
 {
+	stac();
 	if (movsl_is_ok(to, from, n))
 		__copy_user_zeroing(to, from, n);
 	else
 		n = __copy_user_zeroing_intel(to, from, n);
+	clac();
 	return n;
 }
 EXPORT_SYMBOL(__copy_from_user_ll);
@@ -648,11 +653,13 @@ EXPORT_SYMBOL(__copy_from_user_ll);
 unsigned long __copy_from_user_ll_nozero(void *to, const void __user *from,
 					 unsigned long n)
 {
+	stac();
 	if (movsl_is_ok(to, from, n))
 		__copy_user(to, from, n);
 	else
 		n = __copy_user_intel((void __user *)to,
 				      (const void *)from, n);
+	clac();
 	return n;
 }
 EXPORT_SYMBOL(__copy_from_user_ll_nozero);
@@ -660,6 +667,7 @@ EXPORT_SYMBOL(__copy_from_user_ll_nozero);
 unsigned long __copy_from_user_ll_nocache(void *to, const void __user *from,
 					unsigned long n)
 {
+	stac();
 #ifdef CONFIG_X86_INTEL_USERCOPY
 	if (n > 64 && cpu_has_xmm2)
 		n = __copy_user_zeroing_intel_nocache(to, from, n);
@@ -668,6 +676,7 @@ unsigned long __copy_from_user_ll_nocache(void *to, const void __user *from,
 #else
 	__copy_user_zeroing(to, from, n);
 #endif
+	clac();
 	return n;
 }
 EXPORT_SYMBOL(__copy_from_user_ll_nocache);
@@ -675,6 +684,7 @@ EXPORT_SYMBOL(__copy_from_user_ll_nocache);
 unsigned long __copy_from_user_ll_nocache_nozero(void *to, const void __user *from,
 					unsigned long n)
 {
+	stac();
 #ifdef CONFIG_X86_INTEL_USERCOPY
 	if (n > 64 && cpu_has_xmm2)
 		n = __copy_user_intel_nocache(to, from, n);
@@ -683,6 +693,7 @@ unsigned long __copy_from_user_ll_nocache_nozero(void *to, const void __user *fr
 #else
 	__copy_user(to, from, n);
 #endif
+	clac();
 	return n;
 }
 EXPORT_SYMBOL(__copy_from_user_ll_nocache_nozero);
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index e5b130b..05928aa 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -18,6 +18,7 @@ unsigned long __clear_user(void __user *addr, unsigned long size)
 	might_fault();
 	/* no memory constraint because it doesn't change any memory gcc knows
 	   about */
+	stac();
 	asm volatile(
 		"	testq  %[size8],%[size8]\n"
 		"	jz     4f\n"
@@ -40,6 +41,7 @@ unsigned long __clear_user(void __user *addr, unsigned long size)
 		: [size8] "=&c"(size), [dst] "=&D" (__d0)
 		: [size1] "r"(size & 7), "[size8]" (size / 8), "[dst]"(addr),
 		  [zero] "r" (0UL), [eight] "r" (8UL));
+	clac();
 	return size;
 }
 EXPORT_SYMBOL(__clear_user);
@@ -82,5 +84,6 @@ copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
 	for (c = 0, zero_len = len; zerorest && zero_len; --zero_len)
 		if (__put_user_nocheck(c, to++, sizeof(char)))
 			break;
+	clac();
 	return len;
 }
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 76dcd9d..f2fb75d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -995,6 +995,17 @@ static int fault_in_kernel_space(unsigned long address)
 	return address >= TASK_SIZE_MAX;
 }
 
+static inline bool smap_violation(int error_code, struct pt_regs *regs)
+{
+	if (error_code & PF_USER)
+		return false;
+
+	if (!user_mode_vm(regs) && (regs->flags & X86_EFLAGS_AC))
+		return false;
+
+	return true;
+}
+
 /*
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
@@ -1088,6 +1099,13 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	if (unlikely(error_code & PF_RSVD))
 		pgtable_bad(regs, error_code, address);
 
+	if (static_cpu_has(X86_FEATURE_SMAP)) {
+		if (unlikely(smap_violation(error_code, regs))) {
+			bad_area_nosemaphore(regs, error_code, address);
+			return;
+		}
+	}
+
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 
 	/*
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 575d86f..e537b35 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -712,7 +712,7 @@ static void __init test_wp_bit(void)
   "Checking if this processor honours the WP bit even in supervisor mode...");
 
 	/* Any page-aligned address will do, the test is non-destructive */
-	__set_fixmap(FIX_WP_TEST, __pa(&swapper_pg_dir), PAGE_READONLY);
+	__set_fixmap(FIX_WP_TEST, __pa(&swapper_pg_dir), PAGE_KERNEL_RO);
 	boot_cpu_data.wp_works_ok = do_test_wp_bit();
 	clear_fixmap(FIX_WP_TEST);
 
diff --git a/arch/x86/realmode/rm/wakeup.h b/arch/x86/realmode/rm/wakeup.h
index 9317e00..7dd86a4 100644
--- a/arch/x86/realmode/rm/wakeup.h
+++ b/arch/x86/realmode/rm/wakeup.h
@@ -36,5 +36,7 @@ extern struct wakeup_header wakeup_header;
 
 /* Wakeup behavior bits */
 #define WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE     0
+#define WAKEUP_BEHAVIOR_RESTORE_CR4		1
+#define WAKEUP_BEHAVIOR_RESTORE_EFER		2
 
 #endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */
diff --git a/arch/x86/realmode/rm/wakeup_asm.S b/arch/x86/realmode/rm/wakeup_asm.S
index 8905166..e56479e 100644
--- a/arch/x86/realmode/rm/wakeup_asm.S
+++ b/arch/x86/realmode/rm/wakeup_asm.S
@@ -74,9 +74,18 @@ ENTRY(wakeup_start)
 
 	lidtl	wakeup_idt
 
-	/* Clear the EFLAGS */
-	pushl	$0
+	/* Clear the EFLAGS but remember if we have EFLAGS.ID */
+	movl $X86_EFLAGS_ID, %ecx
+	pushl %ecx
 	popfl
+	pushfl
+	popl %edi
+	pushl $0
+	popfl
+	pushfl
+	popl %edx
+	xorl %edx, %edi
+	andl %ecx, %edi		/* %edi is zero iff CPUID & %cr4 are missing */
 
 	/* Check header signature... */
 	movl	signature, %eax
@@ -93,8 +102,8 @@ ENTRY(wakeup_start)
 
 	/* Restore MISC_ENABLE before entering protected mode, in case
 	   BIOS decided to clear XD_DISABLE during S3. */
-	movl	pmode_behavior, %eax
-	btl	$WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE, %eax
+	movl	pmode_behavior, %edi
+	btl	$WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE, %edi
 	jnc	1f
 
 	movl	pmode_misc_en, %eax
@@ -110,15 +119,15 @@ ENTRY(wakeup_start)
 	movl	pmode_cr3, %eax
 	movl	%eax, %cr3
 
-	movl	pmode_cr4, %ecx
-	jecxz	1f
-	movl	%ecx, %cr4
+	btl	$WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
+	jz	1f
+	movl	pmode_cr4, %eax
+	movl	%eax, %cr4
 1:
+	btl	$WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
+	jz	1f
 	movl	pmode_efer, %eax
 	movl	pmode_efer + 4, %edx
-	movl	%eax, %ecx
-	orl	%edx, %ecx
-	jz	1f
 	movl	$MSR_EFER, %ecx
 	wrmsr
 1:
