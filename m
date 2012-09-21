Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab2IUTnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:43:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:22137 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588Ab2IUTnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:43:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="225202012"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 08/11] x86, smap: Add STAC and CLAC instructions to control user space access
Date: Fri, 21 Sep 2012 12:43:12 -0700
Message-Id: <1348256595-29119-9-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

When Supervisor Mode Access Prevention (SMAP) is enabled, access to
userspace from the kernel is controlled by the AC flag.  To make the
performance of manipulating that flag acceptable, there are two new
instructions, STAC and CLAC, to set and clear it.

This patch adds those instructions, via alternative(), when the SMAP
feature is enabled.  It also adds X86_EFLAGS_AC unconditionally to the
SYSCALL entry mask; there is simply no reason to make that one
conditional.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/ia32/ia32entry.S           |    6 ++++++
 arch/x86/include/asm/fpu-internal.h |   10 ++++++----
 arch/x86/include/asm/futex.h        |   19 +++++++++++++------
 arch/x86/include/asm/smap.h         |    4 ++--
 arch/x86/include/asm/uaccess.h      |   31 +++++++++++++++++++------------
 arch/x86/include/asm/xsave.h        |   10 ++++++----
 arch/x86/kernel/cpu/common.c        |    3 ++-
 arch/x86/kernel/entry_64.S          |   11 ++++++++++-
 arch/x86/lib/copy_user_64.S         |    7 +++++++
 arch/x86/lib/copy_user_nocache_64.S |    3 +++
 arch/x86/lib/getuser.S              |   10 ++++++++++
 arch/x86/lib/putuser.S              |    8 +++++++-
 arch/x86/lib/usercopy_32.c          |   13 ++++++++++++-
 arch/x86/lib/usercopy_64.c          |    3 +++
 14 files changed, 106 insertions(+), 32 deletions(-)

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
diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 75f4c6d..0fe1358 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -126,8 +126,9 @@ static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 
 	/* See comment in fxsave() below. */
 #ifdef CONFIG_AS_FXSAVEQ
-	asm volatile("1:  fxsaveq %[fx]\n\t"
-		     "2:\n"
+	asm volatile(ASM_STAC "\n"
+		     "1:  fxsaveq %[fx]\n\t"
+		     "2: " ASM_CLAC "\n"
 		     ".section .fixup,\"ax\"\n"
 		     "3:  movl $-1,%[err]\n"
 		     "    jmp  2b\n"
@@ -136,8 +137,9 @@ static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 		     : [err] "=r" (err), [fx] "=m" (*fx)
 		     : "0" (0));
 #else
-	asm volatile("1:  rex64/fxsave (%[fx])\n\t"
-		     "2:\n"
+	asm volatile(ASM_STAC "\n"
+		     "1:  rex64/fxsave (%[fx])\n\t"
+		     "2: " ASM_CLAC "\n"
 		     ".section .fixup,\"ax\"\n"
 		     "3:  movl $-1,%[err]\n"
 		     "    jmp  2b\n"
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
diff --git a/arch/x86/include/asm/smap.h b/arch/x86/include/asm/smap.h
index 3989c24..8d3120f 100644
--- a/arch/x86/include/asm/smap.h
+++ b/arch/x86/include/asm/smap.h
@@ -58,13 +58,13 @@
 
 #ifdef CONFIG_X86_SMAP
 
-static inline void clac(void)
+static __always_inline void clac(void)
 {
 	/* Note: a barrier is implicit in alternative() */
 	alternative(ASM_NOP3, __stringify(__ASM_CLAC), X86_FEATURE_SMAP);
 }
 
-static inline void stac(void)
+static __always_inline void stac(void)
 {
 	/* Note: a barrier is implicit in alternative() */
 	alternative(ASM_NOP3, __stringify(__ASM_STAC), X86_FEATURE_SMAP);
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 2c7df3d..b92ece1 100644
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
@@ -412,8 +416,9 @@ do {									\
 } while (0)
 
 #define __get_user_asm_ex(x, addr, itype, rtype, ltype)			\
-	asm volatile("1:	mov"itype" %1,%"rtype"0\n"		\
-		     "2:\n"						\
+	asm volatile(ASM_STAC "\n"					\
+		     "1:	mov"itype" %1,%"rtype"0\n"		\
+		     "2: " ASM_CLAC "\n"				\
 		     _ASM_EXTABLE_EX(1b, 2b)				\
 		     : ltype(x) : "m" (__m(addr)))
 
@@ -443,8 +448,9 @@ struct __large_struct { unsigned long buf[100]; };
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
@@ -454,8 +460,9 @@ struct __large_struct { unsigned long buf[100]; };
 		     : ltype(x), "m" (__m(addr)), "i" (errret), "0" (err))
 
 #define __put_user_asm_ex(x, addr, itype, rtype, ltype)			\
-	asm volatile("1:	mov"itype" %"rtype"0,%1\n"		\
-		     "2:\n"						\
+	asm volatile(ASM_STAC "\n"					\
+		     "1:	mov"itype" %"rtype"0,%1\n"		\
+		     "2: " ASM_CLAC "\n"				\
 		     _ASM_EXTABLE_EX(1b, 2b)				\
 		     : : ltype(x), "m" (__m(addr)))
 
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 8a1b6f9..2a923bd 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -74,8 +74,9 @@ static inline int xsave_user(struct xsave_struct __user *buf)
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
@@ -97,8 +98,9 @@ static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
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
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a5fbc3c..cd43e52 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1113,7 +1113,8 @@ void syscall_init(void)
 
 	/* Flags to clear on syscall */
 	wrmsrl(MSR_SYSCALL_MASK,
-	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
+	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|
+	       X86_EFLAGS_IOPL|X86_EFLAGS_AC);
 }
 
 unsigned long kernel_eflags;
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
-- 
1.7.6.5

