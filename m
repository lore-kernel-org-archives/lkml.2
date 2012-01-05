Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab2AEObo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:31:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55748 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab2AEObl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:31:41 -0500
Date: Thu, 5 Jan 2012 15:29:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm changes for v3.3
Message-ID: <20120105142933.GA1731@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asm-for-linus


out-of-topic modifications in x86-asm-for-linus:
------------------------------------------------
drivers/lguest/x86/core.c          # 1cf8343: x86: Fix rflags in FAKE_STACK_FRA
mm/slub.c                          # cdcd629: x86: Fix and improve cmpxchg_doub

 Thanks,

	Ingo

------------------>
Alexey Dobriyan (1):
      x86/i386: Use less assembly in strlen(), speed things up a bit

Andy Lutomirski (2):
      x86-64: Set siginfo and context on vsyscall emulation faults
      x86: Default to vsyscall=emulate

David Howells (1):
      x86_64, asm: Optimise fls(), ffs() and fls64()

Eric Dumazet (1):
      x86: Fix atomic64_xxx_cx8() functions

H Hartley Sweeten (1):
      x86: Use the same node_distance for 32 and 64-bit

H. Peter Anvin (1):
      x86, bitops: Move fls64.h inside __KERNEL__

Jan Beulich (6):
      x86-64: Slightly shorten int_ret_from_sys_call
      x86-64: Reduce amount of redundant code generated for invalidate_interruptNN
      x86-64: Slightly shorten line system call entry and exit paths
      x86-64: Cleanup some assembly entry points
      x86: Fix and improve percpu_cmpxchg{8,16}b_double()
      x86: Fix and improve cmpxchg_double{,_local}()

Jeremy Fitzhardinge (2):
      x86/cmpxchg: add a locked add() helper
      x86: consolidate xchg and xadd macros

Joerg Roedel (1):
      x86: Report cpb and eff_freq_ro flags correctly

Maurice Ma (1):
      x86, efi: Convert efi_phys_get_time() args to physical addresses

Sebastian Andrzej Siewior (1):
      x86/div64: Add a micro-optimization shortcut if base is power of two

Seiichi Ikarashi (1):
      x86: Fix rflags in FAKE_STACK_FRAME

Srikar Dronamraju (2):
      x86: Call do_notify_resume() with interrupts enabled
      x86: Clean up and extend do_int3()


 Documentation/kernel-parameters.txt    |    7 +-
 arch/x86/ia32/ia32entry.S              |   43 ++++-----
 arch/x86/include/asm/alternative-asm.h |    4 +-
 arch/x86/include/asm/bitops.h          |   76 ++++++++++++---
 arch/x86/include/asm/cmpxchg.h         |  163 ++++++++++++++++++--------------
 arch/x86/include/asm/cmpxchg_32.h      |   46 ---------
 arch/x86/include/asm/cmpxchg_64.h      |   43 ---------
 arch/x86/include/asm/div64.h           |   22 +++--
 arch/x86/include/asm/percpu.h          |   53 ++++------
 arch/x86/include/asm/processor-flags.h |    1 +
 arch/x86/include/asm/spinlock.h        |   15 +---
 arch/x86/include/asm/thread_info.h     |    9 ++-
 arch/x86/include/asm/topology.h        |    2 -
 arch/x86/include/asm/uaccess.h         |    2 +-
 arch/x86/kernel/cpu/powerflags.c       |    3 +-
 arch/x86/kernel/entry_32.S             |    4 +
 arch/x86/kernel/entry_64.S             |   31 ++++---
 arch/x86/kernel/process.c              |    2 +-
 arch/x86/kernel/traps.c                |    7 +-
 arch/x86/kernel/vsyscall_64.c          |   77 +++++++++++++--
 arch/x86/lib/string_32.c               |    8 +-
 arch/x86/mm/extable.c                  |    2 +-
 arch/x86/mm/fault.c                    |   22 +++-
 arch/x86/platform/efi/efi.c            |    3 +-
 drivers/lguest/x86/core.c              |    2 +-
 mm/slub.c                              |    4 +-
 26 files changed, 345 insertions(+), 306 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 81c287f..6c04e91 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2750,11 +2750,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			functions are at fixed addresses, they make nice
 			targets for exploits that can control RIP.
 
-			emulate     Vsyscalls turn into traps and are emulated
-			            reasonably safely.
+			emulate     [default] Vsyscalls turn into traps and are
+			            emulated reasonably safely.
 
-			native      [default] Vsyscalls are native syscall
-			            instructions.
+			native      Vsyscalls are native syscall instructions.
 			            This is a little bit faster than trapping
 			            and makes a few dynamic recompilers work
 			            better than they would in emulation mode.
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index a6253ec..3e27456 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -134,7 +134,7 @@ ENTRY(ia32_sysenter_target)
 	CFI_REL_OFFSET rsp,0
 	pushfq_cfi
 	/*CFI_REL_OFFSET rflags,0*/
-	movl	8*3-THREAD_SIZE+TI_sysenter_return(%rsp), %r10d
+	movl	TI_sysenter_return+THREAD_INFO(%rsp,3*8-KERNEL_STACK_OFFSET),%r10d
 	CFI_REGISTER rip,r10
 	pushq_cfi $__USER32_CS
 	/*CFI_REL_OFFSET cs,0*/
@@ -150,9 +150,8 @@ ENTRY(ia32_sysenter_target)
  	.section __ex_table,"a"
  	.quad 1b,ia32_badarg
  	.previous	
-	GET_THREAD_INFO(%r10)
-	orl    $TS_COMPAT,TI_status(%r10)
-	testl  $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
+	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
 	cmpq	$(IA32_NR_syscalls-1),%rax
@@ -162,13 +161,12 @@ sysenter_do_call:
 sysenter_dispatch:
 	call	*ia32_sys_call_table(,%rax,8)
 	movq	%rax,RAX-ARGOFFSET(%rsp)
-	GET_THREAD_INFO(%r10)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl	$_TIF_ALLWORK_MASK,TI_flags(%r10)
+	testl	$_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz	sysexit_audit
 sysexit_from_sys_call:
-	andl    $~TS_COMPAT,TI_status(%r10)
+	andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	/* clear IF, that popfq doesn't enable interrupts early */
 	andl  $~0x200,EFLAGS-R11(%rsp) 
 	movl	RIP-R11(%rsp),%edx		/* User %eip */
@@ -205,7 +203,7 @@ sysexit_from_sys_call:
 	.endm
 
 	.macro auditsys_exit exit
-	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
+	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
 	sti
@@ -215,12 +213,11 @@ sysexit_from_sys_call:
 	movzbl %al,%edi		/* zero-extend that into %edi */
 	inc %edi /* first arg, 0->1(AUDITSC_SUCCESS), 1->2(AUDITSC_FAILURE) */
 	call audit_syscall_exit
-	GET_THREAD_INFO(%r10)
 	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall return value */
 	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
 	cli
 	TRACE_IRQS_OFF
-	testl %edi,TI_flags(%r10)
+	testl %edi,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz \exit
 	CLEAR_RREGS -ARGOFFSET
 	jmp int_with_check
@@ -238,7 +235,7 @@ sysexit_audit:
 
 sysenter_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
+	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz	sysenter_auditsys
 #endif
 	SAVE_REST
@@ -309,9 +306,8 @@ ENTRY(ia32_cstar_target)
 	.section __ex_table,"a"
 	.quad 1b,ia32_badarg
 	.previous	
-	GET_THREAD_INFO(%r10)
-	orl   $TS_COMPAT,TI_status(%r10)
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
+	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
 	cmpq $IA32_NR_syscalls-1,%rax
@@ -321,13 +317,12 @@ cstar_do_call:
 cstar_dispatch:
 	call *ia32_sys_call_table(,%rax,8)
 	movq %rax,RAX-ARGOFFSET(%rsp)
-	GET_THREAD_INFO(%r10)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl $_TIF_ALLWORK_MASK,TI_flags(%r10)
+	testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz sysretl_audit
 sysretl_from_sys_call:
-	andl $~TS_COMPAT,TI_status(%r10)
+	andl $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	RESTORE_ARGS 0,-ARG_SKIP,0,0,0
 	movl RIP-ARGOFFSET(%rsp),%ecx
 	CFI_REGISTER rip,rcx
@@ -355,7 +350,7 @@ sysretl_audit:
 
 cstar_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
+	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz cstar_auditsys
 #endif
 	xchgl %r9d,%ebp
@@ -420,9 +415,8 @@ ENTRY(ia32_syscall)
 	/* note the registers are not zero extended to the sf.
 	   this could be a problem. */
 	SAVE_ARGS 0,1,0
-	GET_THREAD_INFO(%r10)
-	orl   $TS_COMPAT,TI_status(%r10)
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
+	orl $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz ia32_tracesys
 	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
@@ -459,8 +453,8 @@ quiet_ni_syscall:
 	CFI_ENDPROC
 	
 	.macro PTREGSCALL label, func, arg
-	.globl \label
-\label:
+	ALIGN
+GLOBAL(\label)
 	leaq \func(%rip),%rax
 	leaq -ARGOFFSET+8(%rsp),\arg	/* 8 for return address */
 	jmp  ia32_ptregs_common	
@@ -477,7 +471,8 @@ quiet_ni_syscall:
 	PTREGSCALL stub32_vfork, sys_vfork, %rdi
 	PTREGSCALL stub32_iopl, sys_iopl, %rsi
 
-ENTRY(ia32_ptregs_common)
+	ALIGN
+ia32_ptregs_common:
 	popq %r11
 	CFI_ENDPROC
 	CFI_STARTPROC32	simple
diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index 091508b..952bd01 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -4,10 +4,10 @@
 
 #ifdef CONFIG_SMP
 	.macro LOCK_PREFIX
-1:	lock
+672:	lock
 	.section .smp_locks,"a"
 	.balign 4
-	.long 1b - .
+	.long 672b - .
 	.previous
 	.endm
 #else
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 1775d6e..b97596e 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -380,6 +380,8 @@ static inline unsigned long __fls(unsigned long word)
 	return word;
 }
 
+#undef ADDR
+
 #ifdef __KERNEL__
 /**
  * ffs - find first set bit in word
@@ -395,10 +397,25 @@ static inline unsigned long __fls(unsigned long word)
 static inline int ffs(int x)
 {
 	int r;
-#ifdef CONFIG_X86_CMOV
+
+#ifdef CONFIG_X86_64
+	/*
+	 * AMD64 says BSFL won't clobber the dest reg if x==0; Intel64 says the
+	 * dest reg is undefined if x==0, but their CPU architect says its
+	 * value is written to set it to the same as before, except that the
+	 * top 32 bits will be cleared.
+	 *
+	 * We cannot do this on 32 bits because at the very least some
+	 * 486 CPUs did not behave this way.
+	 */
+	long tmp = -1;
+	asm("bsfl %1,%0"
+	    : "=r" (r)
+	    : "rm" (x), "0" (tmp));
+#elif defined(CONFIG_X86_CMOV)
 	asm("bsfl %1,%0\n\t"
 	    "cmovzl %2,%0"
-	    : "=r" (r) : "rm" (x), "r" (-1));
+	    : "=&r" (r) : "rm" (x), "r" (-1));
 #else
 	asm("bsfl %1,%0\n\t"
 	    "jnz 1f\n\t"
@@ -422,7 +439,22 @@ static inline int ffs(int x)
 static inline int fls(int x)
 {
 	int r;
-#ifdef CONFIG_X86_CMOV
+
+#ifdef CONFIG_X86_64
+	/*
+	 * AMD64 says BSRL won't clobber the dest reg if x==0; Intel64 says the
+	 * dest reg is undefined if x==0, but their CPU architect says its
+	 * value is written to set it to the same as before, except that the
+	 * top 32 bits will be cleared.
+	 *
+	 * We cannot do this on 32 bits because at the very least some
+	 * 486 CPUs did not behave this way.
+	 */
+	long tmp = -1;
+	asm("bsrl %1,%0"
+	    : "=r" (r)
+	    : "rm" (x), "0" (tmp));
+#elif defined(CONFIG_X86_CMOV)
 	asm("bsrl %1,%0\n\t"
 	    "cmovzl %2,%0"
 	    : "=&r" (r) : "rm" (x), "rm" (-1));
@@ -434,11 +466,35 @@ static inline int fls(int x)
 #endif
 	return r + 1;
 }
-#endif /* __KERNEL__ */
-
-#undef ADDR
 
-#ifdef __KERNEL__
+/**
+ * fls64 - find last set bit in a 64-bit word
+ * @x: the word to search
+ *
+ * This is defined in a similar way as the libc and compiler builtin
+ * ffsll, but returns the position of the most significant set bit.
+ *
+ * fls64(value) returns 0 if value is 0 or the position of the last
+ * set bit if value is nonzero. The last (most significant) bit is
+ * at position 64.
+ */
+#ifdef CONFIG_X86_64
+static __always_inline int fls64(__u64 x)
+{
+	long bitpos = -1;
+	/*
+	 * AMD64 says BSRQ won't clobber the dest reg if x==0; Intel64 says the
+	 * dest reg is undefined if x==0, but their CPU architect says its
+	 * value is written to set it to the same as before.
+	 */
+	asm("bsrq %1,%0"
+	    : "+r" (bitpos)
+	    : "rm" (x));
+	return bitpos + 1;
+}
+#else
+#include <asm-generic/bitops/fls64.h>
+#endif
 
 #include <asm-generic/bitops/find.h>
 
@@ -450,12 +506,6 @@ static inline int fls(int x)
 
 #include <asm-generic/bitops/const_hweight.h>
 
-#endif /* __KERNEL__ */
-
-#include <asm-generic/bitops/fls64.h>
-
-#ifdef __KERNEL__
-
 #include <asm-generic/bitops/le.h>
 
 #include <asm-generic/bitops/ext2-atomic-setbit.h>
diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index 5d3acdf..0c9fa27 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -14,6 +14,8 @@ extern void __cmpxchg_wrong_size(void)
 	__compiletime_error("Bad argument size for cmpxchg");
 extern void __xadd_wrong_size(void)
 	__compiletime_error("Bad argument size for xadd");
+extern void __add_wrong_size(void)
+	__compiletime_error("Bad argument size for add");
 
 /*
  * Constants for operation sizes. On 32-bit, the 64-bit size it set to
@@ -31,60 +33,47 @@ extern void __xadd_wrong_size(void)
 #define	__X86_CASE_Q	-1		/* sizeof will never return -1 */
 #endif
 
+/* 
+ * An exchange-type operation, which takes a value and a pointer, and
+ * returns a the old value.
+ */
+#define __xchg_op(ptr, arg, op, lock)					\
+	({								\
+	        __typeof__ (*(ptr)) __ret = (arg);			\
+		switch (sizeof(*(ptr))) {				\
+		case __X86_CASE_B:					\
+			asm volatile (lock #op "b %b0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case __X86_CASE_W:					\
+			asm volatile (lock #op "w %w0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case __X86_CASE_L:					\
+			asm volatile (lock #op "l %0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case __X86_CASE_Q:					\
+			asm volatile (lock #op "q %q0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		default:						\
+			__ ## op ## _wrong_size();			\
+		}							\
+		__ret;							\
+	})
+
 /*
  * Note: no "lock" prefix even on SMP: xchg always implies lock anyway.
  * Since this is generally used to protect other memory information, we
  * use "asm volatile" and "memory" clobbers to prevent gcc from moving
  * information around.
  */
-#define __xchg(x, ptr, size)						\
-({									\
-	__typeof(*(ptr)) __x = (x);					\
-	switch (size) {							\
-	case __X86_CASE_B:						\
-	{								\
-		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
-		asm volatile("xchgb %0,%1"				\
-			     : "=q" (__x), "+m" (*__ptr)		\
-			     : "0" (__x)				\
-			     : "memory");				\
-		break;							\
-	}								\
-	case __X86_CASE_W:						\
-	{								\
-		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
-		asm volatile("xchgw %0,%1"				\
-			     : "=r" (__x), "+m" (*__ptr)		\
-			     : "0" (__x)				\
-			     : "memory");				\
-		break;							\
-	}								\
-	case __X86_CASE_L:						\
-	{								\
-		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
-		asm volatile("xchgl %0,%1"				\
-			     : "=r" (__x), "+m" (*__ptr)		\
-			     : "0" (__x)				\
-			     : "memory");				\
-		break;							\
-	}								\
-	case __X86_CASE_Q:						\
-	{								\
-		volatile u64 *__ptr = (volatile u64 *)(ptr);		\
-		asm volatile("xchgq %0,%1"				\
-			     : "=r" (__x), "+m" (*__ptr)		\
-			     : "0" (__x)				\
-			     : "memory");				\
-		break;							\
-	}								\
-	default:							\
-		__xchg_wrong_size();					\
-	}								\
-	__x;								\
-})
-
-#define xchg(ptr, v)							\
-	__xchg((v), (ptr), sizeof(*ptr))
+#define xchg(ptr, v)	__xchg_op((ptr), (v), xchg, "")
 
 /*
  * Atomic compare and exchange.  Compare OLD with MEM, if identical,
@@ -165,46 +154,80 @@ extern void __xadd_wrong_size(void)
 	__cmpxchg_local((ptr), (old), (new), sizeof(*ptr))
 #endif
 
-#define __xadd(ptr, inc, lock)						\
+/*
+ * xadd() adds "inc" to "*ptr" and atomically returns the previous
+ * value of "*ptr".
+ *
+ * xadd() is locked when multiple CPUs are online
+ * xadd_sync() is always locked
+ * xadd_local() is never locked
+ */
+#define __xadd(ptr, inc, lock)	__xchg_op((ptr), (inc), xadd, lock)
+#define xadd(ptr, inc)		__xadd((ptr), (inc), LOCK_PREFIX)
+#define xadd_sync(ptr, inc)	__xadd((ptr), (inc), "lock; ")
+#define xadd_local(ptr, inc)	__xadd((ptr), (inc), "")
+
+#define __add(ptr, inc, lock)						\
 	({								\
 	        __typeof__ (*(ptr)) __ret = (inc);			\
 		switch (sizeof(*(ptr))) {				\
 		case __X86_CASE_B:					\
-			asm volatile (lock "xaddb %b0, %1\n"		\
-				      : "+r" (__ret), "+m" (*(ptr))	\
-				      : : "memory", "cc");		\
+			asm volatile (lock "addb %b1, %0\n"		\
+				      : "+m" (*(ptr)) : "ri" (inc)	\
+				      : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_W:					\
-			asm volatile (lock "xaddw %w0, %1\n"		\
-				      : "+r" (__ret), "+m" (*(ptr))	\
-				      : : "memory", "cc");		\
+			asm volatile (lock "addw %w1, %0\n"		\
+				      : "+m" (*(ptr)) : "ri" (inc)	\
+				      : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_L:					\
-			asm volatile (lock "xaddl %0, %1\n"		\
-				      : "+r" (__ret), "+m" (*(ptr))	\
-				      : : "memory", "cc");		\
+			asm volatile (lock "addl %1, %0\n"		\
+				      : "+m" (*(ptr)) : "ri" (inc)	\
+				      : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_Q:					\
-			asm volatile (lock "xaddq %q0, %1\n"		\
-				      : "+r" (__ret), "+m" (*(ptr))	\
-				      : : "memory", "cc");		\
+			asm volatile (lock "addq %1, %0\n"		\
+				      : "+m" (*(ptr)) : "ri" (inc)	\
+				      : "memory", "cc");		\
 			break;						\
 		default:						\
-			__xadd_wrong_size();				\
+			__add_wrong_size();				\
 		}							\
 		__ret;							\
 	})
 
 /*
- * xadd() adds "inc" to "*ptr" and atomically returns the previous
- * value of "*ptr".
+ * add_*() adds "inc" to "*ptr"
  *
- * xadd() is locked when multiple CPUs are online
- * xadd_sync() is always locked
- * xadd_local() is never locked
+ * __add() takes a lock prefix
+ * add_smp() is locked when multiple CPUs are online
+ * add_sync() is always locked
  */
-#define xadd(ptr, inc)		__xadd((ptr), (inc), LOCK_PREFIX)
-#define xadd_sync(ptr, inc)	__xadd((ptr), (inc), "lock; ")
-#define xadd_local(ptr, inc)	__xadd((ptr), (inc), "")
+#define add_smp(ptr, inc)	__add((ptr), (inc), LOCK_PREFIX)
+#define add_sync(ptr, inc)	__add((ptr), (inc), "lock; ")
+
+#define __cmpxchg_double(pfx, p1, p2, o1, o2, n1, n2)			\
+({									\
+	bool __ret;							\
+	__typeof__(*(p1)) __old1 = (o1), __new1 = (n1);			\
+	__typeof__(*(p2)) __old2 = (o2), __new2 = (n2);			\
+	BUILD_BUG_ON(sizeof(*(p1)) != sizeof(long));			\
+	BUILD_BUG_ON(sizeof(*(p2)) != sizeof(long));			\
+	VM_BUG_ON((unsigned long)(p1) % (2 * sizeof(long)));		\
+	VM_BUG_ON((unsigned long)((p1) + 1) != (unsigned long)(p2));	\
+	asm volatile(pfx "cmpxchg%c4b %2; sete %0"			\
+		     : "=a" (__ret), "+d" (__old2),			\
+		       "+m" (*(p1)), "+m" (*(p2))			\
+		     : "i" (2 * sizeof(long)), "a" (__old1),		\
+		       "b" (__new1), "c" (__new2));			\
+	__ret;								\
+})
+
+#define cmpxchg_double(p1, p2, o1, o2, n1, n2) \
+	__cmpxchg_double(LOCK_PREFIX, p1, p2, o1, o2, n1, n2)
+
+#define cmpxchg_double_local(p1, p2, o1, o2, n1, n2) \
+	__cmpxchg_double(, p1, p2, o1, o2, n1, n2)
 
 #endif	/* ASM_X86_CMPXCHG_H */
diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index fbebb07..53f4b21 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -166,52 +166,6 @@ static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
 
 #endif
 
-#define cmpxchg8b(ptr, o1, o2, n1, n2)				\
-({								\
-	char __ret;						\
-	__typeof__(o2) __dummy;					\
-	__typeof__(*(ptr)) __old1 = (o1);			\
-	__typeof__(o2) __old2 = (o2);				\
-	__typeof__(*(ptr)) __new1 = (n1);			\
-	__typeof__(o2) __new2 = (n2);				\
-	asm volatile(LOCK_PREFIX "cmpxchg8b %2; setz %1"	\
-		       : "=d"(__dummy), "=a" (__ret), "+m" (*ptr)\
-		       : "a" (__old1), "d"(__old2),		\
-		         "b" (__new1), "c" (__new2)		\
-		       : "memory");				\
-	__ret; })
-
-
-#define cmpxchg8b_local(ptr, o1, o2, n1, n2)			\
-({								\
-	char __ret;						\
-	__typeof__(o2) __dummy;					\
-	__typeof__(*(ptr)) __old1 = (o1);			\
-	__typeof__(o2) __old2 = (o2);				\
-	__typeof__(*(ptr)) __new1 = (n1);			\
-	__typeof__(o2) __new2 = (n2);				\
-	asm volatile("cmpxchg8b %2; setz %1"			\
-		       : "=d"(__dummy), "=a"(__ret), "+m" (*ptr)\
-		       : "a" (__old), "d"(__old2),		\
-		         "b" (__new1), "c" (__new2),		\
-		       : "memory");				\
-	__ret; })
-
-
-#define cmpxchg_double(ptr, o1, o2, n1, n2)				\
-({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 4);				\
-	VM_BUG_ON((unsigned long)(ptr) % 8);				\
-	cmpxchg8b((ptr), (o1), (o2), (n1), (n2));			\
-})
-
-#define cmpxchg_double_local(ptr, o1, o2, n1, n2)			\
-({									\
-       BUILD_BUG_ON(sizeof(*(ptr)) != 4);				\
-       VM_BUG_ON((unsigned long)(ptr) % 8);				\
-       cmpxchg16b_local((ptr), (o1), (o2), (n1), (n2));			\
-})
-
 #define system_has_cmpxchg_double() cpu_has_cx8
 
 #endif /* _ASM_X86_CMPXCHG_32_H */
diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
index 285da02..614be87 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -20,49 +20,6 @@ static inline void set_64bit(volatile u64 *ptr, u64 val)
 	cmpxchg_local((ptr), (o), (n));					\
 })
 
-#define cmpxchg16b(ptr, o1, o2, n1, n2)				\
-({								\
-	char __ret;						\
-	__typeof__(o2) __junk;					\
-	__typeof__(*(ptr)) __old1 = (o1);			\
-	__typeof__(o2) __old2 = (o2);				\
-	__typeof__(*(ptr)) __new1 = (n1);			\
-	__typeof__(o2) __new2 = (n2);				\
-	asm volatile(LOCK_PREFIX "cmpxchg16b %2;setz %1"	\
-		       : "=d"(__junk), "=a"(__ret), "+m" (*ptr)	\
-		       : "b"(__new1), "c"(__new2),		\
-		         "a"(__old1), "d"(__old2));		\
-	__ret; })
-
-
-#define cmpxchg16b_local(ptr, o1, o2, n1, n2)			\
-({								\
-	char __ret;						\
-	__typeof__(o2) __junk;					\
-	__typeof__(*(ptr)) __old1 = (o1);			\
-	__typeof__(o2) __old2 = (o2);				\
-	__typeof__(*(ptr)) __new1 = (n1);			\
-	__typeof__(o2) __new2 = (n2);				\
-	asm volatile("cmpxchg16b %2;setz %1"			\
-		       : "=d"(__junk), "=a"(__ret), "+m" (*ptr)	\
-		       : "b"(__new1), "c"(__new2),		\
-		         "a"(__old1), "d"(__old2));		\
-	__ret; })
-
-#define cmpxchg_double(ptr, o1, o2, n1, n2)				\
-({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	VM_BUG_ON((unsigned long)(ptr) % 16);				\
-	cmpxchg16b((ptr), (o1), (o2), (n1), (n2));			\
-})
-
-#define cmpxchg_double_local(ptr, o1, o2, n1, n2)			\
-({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	VM_BUG_ON((unsigned long)(ptr) % 16);				\
-	cmpxchg16b_local((ptr), (o1), (o2), (n1), (n2));		\
-})
-
 #define system_has_cmpxchg_double() cpu_has_cx16
 
 #endif /* _ASM_X86_CMPXCHG_64_H */
diff --git a/arch/x86/include/asm/div64.h b/arch/x86/include/asm/div64.h
index 9a2d644..ced283a 100644
--- a/arch/x86/include/asm/div64.h
+++ b/arch/x86/include/asm/div64.h
@@ -4,6 +4,7 @@
 #ifdef CONFIG_X86_32
 
 #include <linux/types.h>
+#include <linux/log2.h>
 
 /*
  * do_div() is NOT a C function. It wants to return
@@ -21,15 +22,20 @@
 ({								\
 	unsigned long __upper, __low, __high, __mod, __base;	\
 	__base = (base);					\
-	asm("":"=a" (__low), "=d" (__high) : "A" (n));		\
-	__upper = __high;					\
-	if (__high) {						\
-		__upper = __high % (__base);			\
-		__high = __high / (__base);			\
+	if (__builtin_constant_p(__base) && is_power_of_2(__base)) { \
+		__mod = n & (__base - 1);			\
+		n >>= ilog2(__base);				\
+	} else {						\
+		asm("" : "=a" (__low), "=d" (__high) : "A" (n));\
+		__upper = __high;				\
+		if (__high) {					\
+			__upper = __high % (__base);		\
+			__high = __high / (__base);		\
+		}						\
+		asm("divl %2" : "=a" (__low), "=d" (__mod)	\
+			: "rm" (__base), "0" (__low), "1" (__upper));	\
+		asm("" : "=A" (n) : "a" (__low), "d" (__high));	\
 	}							\
-	asm("divl %2":"=a" (__low), "=d" (__mod)		\
-	    : "rm" (__base), "0" (__low), "1" (__upper));	\
-	asm("":"=A" (n) : "a" (__low), "d" (__high));		\
 	__mod;							\
 })
 
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 3470c9d..529bf07e 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -451,23 +451,20 @@ do {									\
 #endif /* !CONFIG_M386 */
 
 #ifdef CONFIG_X86_CMPXCHG64
-#define percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)			\
+#define percpu_cmpxchg8b_double(pcp1, pcp2, o1, o2, n1, n2)		\
 ({									\
-	char __ret;							\
-	typeof(o1) __o1 = o1;						\
-	typeof(o1) __n1 = n1;						\
-	typeof(o2) __o2 = o2;						\
-	typeof(o2) __n2 = n2;						\
-	typeof(o2) __dummy = n2;					\
+	bool __ret;							\
+	typeof(pcp1) __o1 = (o1), __n1 = (n1);				\
+	typeof(pcp2) __o2 = (o2), __n2 = (n2);				\
 	asm volatile("cmpxchg8b "__percpu_arg(1)"\n\tsetz %0\n\t"	\
-		    : "=a"(__ret), "=m" (pcp1), "=d"(__dummy)		\
-		    :  "b"(__n1), "c"(__n2), "a"(__o1), "d"(__o2));	\
+		    : "=a" (__ret), "+m" (pcp1), "+m" (pcp2), "+d" (__o2) \
+		    :  "b" (__n1), "c" (__n2), "a" (__o1));		\
 	__ret;								\
 })
 
-#define __this_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
-#define this_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
-#define irqsafe_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)	percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
+#define __this_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
+#define this_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
+#define irqsafe_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
 #endif /* CONFIG_X86_CMPXCHG64 */
 
 /*
@@ -508,31 +505,23 @@ do {									\
  * it in software.  The address used in the cmpxchg16 instruction must be
  * aligned to a 16 byte boundary.
  */
-#ifdef CONFIG_SMP
-#define CMPXCHG16B_EMU_CALL "call this_cpu_cmpxchg16b_emu\n\t" ASM_NOP3
-#else
-#define CMPXCHG16B_EMU_CALL "call this_cpu_cmpxchg16b_emu\n\t" ASM_NOP2
-#endif
-#define percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)			\
+#define percpu_cmpxchg16b_double(pcp1, pcp2, o1, o2, n1, n2)		\
 ({									\
-	char __ret;							\
-	typeof(o1) __o1 = o1;						\
-	typeof(o1) __n1 = n1;						\
-	typeof(o2) __o2 = o2;						\
-	typeof(o2) __n2 = n2;						\
-	typeof(o2) __dummy;						\
-	alternative_io(CMPXCHG16B_EMU_CALL,				\
-		       "cmpxchg16b " __percpu_prefix "(%%rsi)\n\tsetz %0\n\t",	\
+	bool __ret;							\
+	typeof(pcp1) __o1 = (o1), __n1 = (n1);				\
+	typeof(pcp2) __o2 = (o2), __n2 = (n2);				\
+	alternative_io("leaq %P1,%%rsi\n\tcall this_cpu_cmpxchg16b_emu\n\t", \
+		       "cmpxchg16b " __percpu_arg(1) "\n\tsetz %0\n\t",	\
 		       X86_FEATURE_CX16,				\
-		       ASM_OUTPUT2("=a"(__ret), "=d"(__dummy)),		\
-		       "S" (&pcp1), "b"(__n1), "c"(__n2),		\
-		       "a"(__o1), "d"(__o2) : "memory");		\
+		       ASM_OUTPUT2("=a" (__ret), "+m" (pcp1),		\
+				   "+m" (pcp2), "+d" (__o2)),		\
+		       "b" (__n1), "c" (__n2), "a" (__o1) : "rsi");	\
 	__ret;								\
 })
 
-#define __this_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)
-#define this_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)
-#define irqsafe_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)	percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)
+#define __this_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
+#define this_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
+#define irqsafe_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
 
 #endif
 
diff --git a/arch/x86/include/asm/processor-flags.h b/arch/x86/include/asm/processor-flags.h
index 2dddb31..f8ab3ea 100644
--- a/arch/x86/include/asm/processor-flags.h
+++ b/arch/x86/include/asm/processor-flags.h
@@ -6,6 +6,7 @@
  * EFLAGS bits
  */
 #define X86_EFLAGS_CF	0x00000001 /* Carry Flag */
+#define X86_EFLAGS_BIT1	0x00000002 /* Bit 1 - always on */
 #define X86_EFLAGS_PF	0x00000004 /* Parity Flag */
 #define X86_EFLAGS_AF	0x00000010 /* Auxiliary carry Flag */
 #define X86_EFLAGS_ZF	0x00000040 /* Zero Flag */
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 972c260..a82c2bf 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -79,23 +79,10 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
 }
 
-#if (NR_CPUS < 256)
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
-	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
-		     : "+m" (lock->head_tail)
-		     :
-		     : "memory", "cc");
+	__add(&lock->tickets.head, 1, UNLOCK_LOCK_PREFIX);
 }
-#else
-static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
-{
-	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
-		     : "+m" (lock->head_tail)
-		     :
-		     : "memory", "cc");
-}
-#endif
 
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index a1fe5c1..185b719 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -40,7 +40,8 @@ struct thread_info {
 						*/
 	__u8			supervisor_stack[0];
 #endif
-	int			uaccess_err;
+	int			sig_on_uaccess_error:1;
+	int			uaccess_err:1;	/* uaccess failed */
 };
 
 #define INIT_THREAD_INFO(tsk)			\
@@ -231,6 +232,12 @@ static inline struct thread_info *current_thread_info(void)
 	movq PER_CPU_VAR(kernel_stack),reg ; \
 	subq $(THREAD_SIZE-KERNEL_STACK_OFFSET),reg
 
+/*
+ * Same if PER_CPU_VAR(kernel_stack) is, perhaps with some offset, already in
+ * a certain register (to be used in assembler memory operands).
+ */
+#define THREAD_INFO(reg, off) KERNEL_STACK_OFFSET+(off)-THREAD_SIZE(reg)
+
 #endif
 
 #endif /* !X86_32 */
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index c006924..800f77c 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -130,10 +130,8 @@ extern void setup_node_to_cpumask_map(void);
 	.balance_interval	= 1,					\
 }
 
-#ifdef CONFIG_X86_64
 extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
-#endif
 
 #else /* !CONFIG_NUMA */
 
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 36361bf..8be5f54 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -462,7 +462,7 @@ struct __large_struct { unsigned long buf[100]; };
 	barrier();
 
 #define uaccess_catch(err)						\
-	(err) |= current_thread_info()->uaccess_err;			\
+	(err) |= (current_thread_info()->uaccess_err ? -EFAULT : 0);	\
 	current_thread_info()->uaccess_err = prev_err;			\
 } while (0)
 
diff --git a/arch/x86/kernel/cpu/powerflags.c b/arch/x86/kernel/cpu/powerflags.c
index 5abbea2..7b3fe56 100644
--- a/arch/x86/kernel/cpu/powerflags.c
+++ b/arch/x86/kernel/cpu/powerflags.c
@@ -16,5 +16,6 @@ const char *const x86_power_flags[32] = {
 	"100mhzsteps",
 	"hwpstate",
 	"",	/* tsc invariant mapped to constant_tsc */
-		/* nothing */
+	"cpb",  /* core performance boost */
+	"eff_freq_ro", /* Readonly aperf/mperf */
 };
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f3f6f53..22d0e21 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -625,6 +625,8 @@ work_notifysig:				# deal with pending signals and
 	movl %esp, %eax
 	jne work_notifysig_v86		# returning to kernel-space or
 					# vm86-space
+	TRACE_IRQS_ON
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	xorl %edx, %edx
 	call do_notify_resume
 	jmp resume_userspace_sig
@@ -638,6 +640,8 @@ work_notifysig_v86:
 #else
 	movl %esp, %eax
 #endif
+	TRACE_IRQS_ON
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	xorl %edx, %edx
 	call do_notify_resume
 	jmp resume_userspace_sig
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index faf8d5e..a20e1cb 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -221,7 +221,7 @@ ENDPROC(native_usergs_sysret64)
 	/*CFI_REL_OFFSET	ss,0*/
 	pushq_cfi %rax /* rsp */
 	CFI_REL_OFFSET	rsp,0
-	pushq_cfi $X86_EFLAGS_IF /* eflags - interrupts on */
+	pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_BIT1) /* eflags - interrupts on */
 	/*CFI_REL_OFFSET	rflags,0*/
 	pushq_cfi $__KERNEL_CS /* cs */
 	/*CFI_REL_OFFSET	cs,0*/
@@ -411,7 +411,7 @@ ENTRY(ret_from_fork)
 	RESTORE_REST
 
 	testl $3, CS-ARGOFFSET(%rsp)		# from kernel_thread?
-	je   int_ret_from_sys_call
+	jz   retint_restore_args
 
 	testl $_TIF_IA32, TI_flags(%rcx)	# 32-bit compat task needs IRET
 	jnz  int_ret_from_sys_call
@@ -465,7 +465,7 @@ ENTRY(system_call)
 	 * after the swapgs, so that it can do the swapgs
 	 * for the guest and jump here on syscall.
 	 */
-ENTRY(system_call_after_swapgs)
+GLOBAL(system_call_after_swapgs)
 
 	movq	%rsp,PER_CPU_VAR(old_rsp)
 	movq	PER_CPU_VAR(kernel_stack),%rsp
@@ -478,8 +478,7 @@ ENTRY(system_call_after_swapgs)
 	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
-	GET_THREAD_INFO(%rcx)
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%rcx)
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz tracesys
 system_call_fastpath:
 	cmpq $__NR_syscall_max,%rax
@@ -496,10 +495,9 @@ ret_from_sys_call:
 	/* edi:	flagmask */
 sysret_check:
 	LOCKDEP_SYS_EXIT
-	GET_THREAD_INFO(%rcx)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	movl TI_flags(%rcx),%edx
+	movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
 	andl %edi,%edx
 	jnz  sysret_careful
 	CFI_REMEMBER_STATE
@@ -583,7 +581,7 @@ sysret_audit:
 	/* Do syscall tracing */
 tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
+	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz auditsys
 #endif
 	SAVE_REST
@@ -612,8 +610,6 @@ tracesys:
 GLOBAL(int_ret_from_sys_call)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl $3,CS-ARGOFFSET(%rsp)
-	je retint_restore_args
 	movl $_TIF_ALLWORK_MASK,%edi
 	/* edi:	mask to check */
 GLOBAL(int_with_check)
@@ -953,6 +949,7 @@ END(common_interrupt)
 ENTRY(\sym)
 	INTR_FRAME
 	pushq_cfi $~(\num)
+.Lcommon_\sym:
 	interrupt \do_sym
 	jmp ret_from_intr
 	CFI_ENDPROC
@@ -976,13 +973,21 @@ apicinterrupt X86_PLATFORM_IPI_VECTOR \
 	x86_platform_ipi smp_x86_platform_ipi
 
 #ifdef CONFIG_SMP
-.irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
+	ALIGN
+	INTR_FRAME
+.irp idx,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
 	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
 .if NUM_INVALIDATE_TLB_VECTORS > \idx
-apicinterrupt (INVALIDATE_TLB_VECTOR_START)+\idx \
-	invalidate_interrupt\idx smp_invalidate_interrupt
+ENTRY(invalidate_interrupt\idx)
+	pushq_cfi $~(INVALIDATE_TLB_VECTOR_START+\idx)
+	jmp .Lcommon_invalidate_interrupt0
+	CFI_ADJUST_CFA_OFFSET -8
+END(invalidate_interrupt\idx)
 .endif
 .endr
+	CFI_ENDPROC
+apicinterrupt INVALIDATE_TLB_VECTOR_START, \
+	invalidate_interrupt0, smp_invalidate_interrupt
 #endif
 
 apicinterrupt THRESHOLD_APIC_VECTOR \
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ee5d4fb..15763af 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -293,7 +293,7 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	regs.orig_ax = -1;
 	regs.ip = (unsigned long) kernel_thread_helper;
 	regs.cs = __KERNEL_CS | get_kernel_rpl();
-	regs.flags = X86_EFLAGS_IF | 0x2;
+	regs.flags = X86_EFLAGS_IF | X86_EFLAGS_BIT1;
 
 	/* Ok, create the new process.. */
 	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a8e3eb8..fa1191f 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -306,15 +306,10 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 			== NOTIFY_STOP)
 		return;
 #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
-#ifdef CONFIG_KPROBES
+
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
 		return;
-#else
-	if (notify_die(DIE_TRAP, "int3", regs, error_code, 3, SIGTRAP)
-			== NOTIFY_STOP)
-		return;
-#endif
 
 	preempt_conditional_sti(regs);
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index e4d4a22..b07ba93 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -57,7 +57,7 @@ DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
 };
 
-static enum { EMULATE, NATIVE, NONE } vsyscall_mode = NATIVE;
+static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
 
 static int __init vsyscall_setup(char *str)
 {
@@ -140,11 +140,40 @@ static int addr_to_vsyscall_nr(unsigned long addr)
 	return nr;
 }
 
+static bool write_ok_or_segv(unsigned long ptr, size_t size)
+{
+	/*
+	 * XXX: if access_ok, get_user, and put_user handled
+	 * sig_on_uaccess_error, this could go away.
+	 */
+
+	if (!access_ok(VERIFY_WRITE, (void __user *)ptr, size)) {
+		siginfo_t info;
+		struct thread_struct *thread = &current->thread;
+
+		thread->error_code	= 6;  /* user fault, no page, write */
+		thread->cr2		= ptr;
+		thread->trap_no		= 14;
+
+		memset(&info, 0, sizeof(info));
+		info.si_signo		= SIGSEGV;
+		info.si_errno		= 0;
+		info.si_code		= SEGV_MAPERR;
+		info.si_addr		= (void __user *)ptr;
+
+		force_sig_info(SIGSEGV, &info, current);
+		return false;
+	} else {
+		return true;
+	}
+}
+
 bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 {
 	struct task_struct *tsk;
 	unsigned long caller;
 	int vsyscall_nr;
+	int prev_sig_on_uaccess_error;
 	long ret;
 
 	/*
@@ -180,35 +209,65 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 	if (seccomp_mode(&tsk->seccomp))
 		do_exit(SIGKILL);
 
+	/*
+	 * With a real vsyscall, page faults cause SIGSEGV.  We want to
+	 * preserve that behavior to make writing exploits harder.
+	 */
+	prev_sig_on_uaccess_error = current_thread_info()->sig_on_uaccess_error;
+	current_thread_info()->sig_on_uaccess_error = 1;
+
+	/*
+	 * 0 is a valid user pointer (in the access_ok sense) on 32-bit and
+	 * 64-bit, so we don't need to special-case it here.  For all the
+	 * vsyscalls, 0 means "don't write anything" not "write it at
+	 * address 0".
+	 */
+	ret = -EFAULT;
 	switch (vsyscall_nr) {
 	case 0:
+		if (!write_ok_or_segv(regs->di, sizeof(struct timeval)) ||
+		    !write_ok_or_segv(regs->si, sizeof(struct timezone)))
+			break;
+
 		ret = sys_gettimeofday(
 			(struct timeval __user *)regs->di,
 			(struct timezone __user *)regs->si);
 		break;
 
 	case 1:
+		if (!write_ok_or_segv(regs->di, sizeof(time_t)))
+			break;
+
 		ret = sys_time((time_t __user *)regs->di);
 		break;
 
 	case 2:
+		if (!write_ok_or_segv(regs->di, sizeof(unsigned)) ||
+		    !write_ok_or_segv(regs->si, sizeof(unsigned)))
+			break;
+
 		ret = sys_getcpu((unsigned __user *)regs->di,
 				 (unsigned __user *)regs->si,
 				 0);
 		break;
 	}
 
+	current_thread_info()->sig_on_uaccess_error = prev_sig_on_uaccess_error;
+
 	if (ret == -EFAULT) {
-		/*
-		 * Bad news -- userspace fed a bad pointer to a vsyscall.
-		 *
-		 * With a real vsyscall, that would have caused SIGSEGV.
-		 * To make writing reliable exploits using the emulated
-		 * vsyscalls harder, generate SIGSEGV here as well.
-		 */
+		/* Bad news -- userspace fed a bad pointer to a vsyscall. */
 		warn_bad_vsyscall(KERN_INFO, regs,
 				  "vsyscall fault (exploit attempt?)");
-		goto sigsegv;
+
+		/*
+		 * If we failed to generate a signal for any reason,
+		 * generate one here.  (This should be impossible.)
+		 */
+		if (WARN_ON_ONCE(!sigismember(&tsk->pending.signal, SIGBUS) &&
+				 !sigismember(&tsk->pending.signal, SIGSEGV)))
+			goto sigsegv;
+
+		return true;  /* Don't emulate the ret. */
 	}
 
 	regs->ax = ret;
diff --git a/arch/x86/lib/string_32.c b/arch/x86/lib/string_32.c
index 82004d2..bd59090 100644
--- a/arch/x86/lib/string_32.c
+++ b/arch/x86/lib/string_32.c
@@ -164,15 +164,13 @@ EXPORT_SYMBOL(strchr);
 size_t strlen(const char *s)
 {
 	int d0;
-	int res;
+	size_t res;
 	asm volatile("repne\n\t"
-		"scasb\n\t"
-		"notl %0\n\t"
-		"decl %0"
+		"scasb"
 		: "=c" (res), "=&D" (d0)
 		: "1" (s), "a" (0), "0" (0xffffffffu)
 		: "memory");
-	return res;
+	return ~res - 1;
 }
 EXPORT_SYMBOL(strlen);
 #endif
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index d0474ad..1fb85db 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -25,7 +25,7 @@ int fixup_exception(struct pt_regs *regs)
 	if (fixup) {
 		/* If fixup is less than 16, it means uaccess error */
 		if (fixup->fixup < 16) {
-			current_thread_info()->uaccess_err = -EFAULT;
+			current_thread_info()->uaccess_err = 1;
 			regs->ip += fixup->fixup;
 			return 1;
 		}
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 5db0490..9d74824 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -626,7 +626,7 @@ pgtable_bad(struct pt_regs *regs, unsigned long error_code,
 
 static noinline void
 no_context(struct pt_regs *regs, unsigned long error_code,
-	   unsigned long address)
+	   unsigned long address, int signal, int si_code)
 {
 	struct task_struct *tsk = current;
 	unsigned long *stackend;
@@ -634,8 +634,17 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	int sig;
 
 	/* Are we prepared to handle this kernel fault? */
-	if (fixup_exception(regs))
+	if (fixup_exception(regs)) {
+		if (current_thread_info()->sig_on_uaccess_error && signal) {
+			tsk->thread.trap_no = 14;
+			tsk->thread.error_code = error_code | PF_USER;
+			tsk->thread.cr2 = address;
+
+			/* XXX: hwpoison faults will set the wrong code. */
+			force_sig_info_fault(signal, si_code, address, tsk, 0);
+		}
 		return;
+	}
 
 	/*
 	 * 32-bit:
@@ -755,7 +764,7 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 	if (is_f00f_bug(regs, address))
 		return;
 
-	no_context(regs, error_code, address);
+	no_context(regs, error_code, address, SIGSEGV, si_code);
 }
 
 static noinline void
@@ -819,7 +828,7 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 
 	/* Kernel mode? Handle exceptions or die: */
 	if (!(error_code & PF_USER)) {
-		no_context(regs, error_code, address);
+		no_context(regs, error_code, address, SIGBUS, BUS_ADRERR);
 		return;
 	}
 
@@ -854,7 +863,7 @@ mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 		if (!(fault & VM_FAULT_RETRY))
 			up_read(&current->mm->mmap_sem);
 		if (!(error_code & PF_USER))
-			no_context(regs, error_code, address);
+			no_context(regs, error_code, address, 0, 0);
 		return 1;
 	}
 	if (!(fault & VM_FAULT_ERROR))
@@ -864,7 +873,8 @@ mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 		/* Kernel mode? Handle exceptions or die: */
 		if (!(error_code & PF_USER)) {
 			up_read(&current->mm->mmap_sem);
-			no_context(regs, error_code, address);
+			no_context(regs, error_code, address,
+				   SIGSEGV, SEGV_MAPERR);
 			return 1;
 		}
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 37718f0..d2376eb 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -238,7 +238,8 @@ static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 
 	spin_lock_irqsave(&rtc_lock, flags);
 	efi_call_phys_prelog();
-	status = efi_call_phys2(efi_phys.get_time, tm, tc);
+	status = efi_call_phys2(efi_phys.get_time, virt_to_phys(tm),
+				virt_to_phys(tc));
 	efi_call_phys_epilog();
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 65af42f..3980903 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -697,7 +697,7 @@ void lguest_arch_setup_regs(struct lg_cpu *cpu, unsigned long start)
 	 * interrupts are enabled.  We always leave interrupts enabled while
 	 * running the Guest.
 	 */
-	regs->eflags = X86_EFLAGS_IF | 0x2;
+	regs->eflags = X86_EFLAGS_IF | X86_EFLAGS_BIT1;
 
 	/*
 	 * The "Extended Instruction Pointer" register says where the Guest is
diff --git a/mm/slub.c b/mm/slub.c
index ed3334d..09ccee8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -368,7 +368,7 @@ static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct page *page
 	VM_BUG_ON(!irqs_disabled());
 #ifdef CONFIG_CMPXCHG_DOUBLE
 	if (s->flags & __CMPXCHG_DOUBLE) {
-		if (cmpxchg_double(&page->freelist,
+		if (cmpxchg_double(&page->freelist, &page->counters,
 			freelist_old, counters_old,
 			freelist_new, counters_new))
 		return 1;
@@ -402,7 +402,7 @@ static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
 {
 #ifdef CONFIG_CMPXCHG_DOUBLE
 	if (s->flags & __CMPXCHG_DOUBLE) {
-		if (cmpxchg_double(&page->freelist,
+		if (cmpxchg_double(&page->freelist, &page->counters,
 			freelist_old, counters_old,
 			freelist_new, counters_new))
 		return 1;
