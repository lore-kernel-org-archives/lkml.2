Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab0F2ObP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 10:31:15 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39678 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab0F2ObN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Tue, 29 Jun 2010 10:31:13 -0400
Message-Id: <4C2A1FE902000078000089E1@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 29 Jun 2010 15:31:37 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <jeremy.fitzhardinge@citrix.com>, "Ky Srinivasan" <KSrinivasan@novell.com>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks -
	 base implementation
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add optional (alternative instructions based) callout hooks to the
contended ticket lock and the ticket unlock paths, to allow hypervisor
specific code to be used for reducing/eliminating the bad effects
ticket locks have on performance when running virtualized.

Note that the lock callout passes the full ticket:current pair in the
case of NR_CPUS < 256, but passes only the ticket otherwise. Making
this consistent would be possible, but at the expense of increasing
the stub sizes for one of the two cases (which seems undesirable to
me).

The only additional overhead this introduces for native execution is
a nop in the release paths, which, if considered undesirable, a
subsequent (optional) patch will eliminate again.

For the moment, this isn't intended to be used together with pv-ops,
but this is just to simplify initial integration. The ultimate goal
for this should still be to replace pv-ops spinlocks.

This requires adjustments to the alternative instruction patching,
since locked instructions may now both get patched out and reside in
replacement code.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: KY Srinivasan <ksrinivasan@novell.com>

---
 arch/x86/Kconfig                    |    8 ++
 arch/x86/include/asm/alternative.h  |   30 ++++++---
 arch/x86/include/asm/arch_hweight.h |    4 -
 arch/x86/include/asm/atomic64_32.h  |    2 
 arch/x86/include/asm/cpufeature.h   |    1 
 arch/x86/include/asm/spinlock.h     |  112 ++++++++++++++++++++++++++++++++----
 arch/x86/kernel/alternative.c       |   37 +++++++++++
 arch/x86/kernel/cpu/hypervisor.c    |    9 ++
 arch/x86/kernel/module.c            |    8 +-
 arch/x86/lib/thunk_32.S             |   32 ++++++++++
 arch/x86/lib/thunk_64.S             |   51 ++++++++++++++++
 11 files changed, 267 insertions(+), 27 deletions(-)

--- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/Kconfig
+++ 2.6.35-rc3-virt-spinlocks/arch/x86/Kconfig
@@ -586,6 +586,14 @@ config PARAVIRT_DEBUG
 	  Enable to debug paravirt_ops internals.  Specifically, BUG if
 	  a paravirt_op is missing when it is called.
 
+config ENLIGHTEN_SPINLOCKS
+	bool "enlighten spinlocks"
+	depends on SMP && !PARAVIRT_SPINLOCKS
+	help
+	  Provide a mechanism for enlightening (para-virtualizing) spin locks
+	  in the absence of full pv-ops support (i.e. for "fully" virtualized
+	  guests).
+
 config NO_BOOTMEM
 	default y
 	bool "Disable Bootmem code"
--- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/include/asm/alternative.h
+++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/alternative.h
@@ -29,10 +29,10 @@
 
 #ifdef CONFIG_SMP
 #define LOCK_PREFIX_HERE \
-		".section .smp_locks,\"a\"\n"	\
+		".pushsection .smp_locks,\"a\"\n" \
 		".balign 4\n"			\
 		".long 671f - .\n" /* offset */	\
-		".previous\n"			\
+		".popsection\n"			\
 		"671:"
 
 #define LOCK_PREFIX LOCK_PREFIX_HERE "\n\tlock; "
@@ -55,7 +55,12 @@ struct alt_instr {
 };
 
 extern void alternative_instructions(void);
-extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
+#ifndef CONFIG_SMP
+#define apply_alternatives(alt_start, alt_end, smp_start, smp_end) \
+	apply_alternatives(alt_start, alt_end)
+#endif
+extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end,
+			       s32 *smp_start, s32 *smp_end);
 
 struct module;
 
@@ -79,8 +84,8 @@ static inline int alternatives_text_rese
 #endif	/* CONFIG_SMP */
 
 /* alternative assembly primitive: */
-#define ALTERNATIVE(oldinstr, newinstr, feature)			\
-									\
+#define ALTERNATIVE(common, oldinstr, newinstr, feature)		\
+      common								\
       "661:\n\t" oldinstr "\n662:\n"					\
       ".section .altinstructions,\"a\"\n"				\
       _ASM_ALIGN "\n"							\
@@ -114,7 +119,8 @@ static inline int alternatives_text_rese
  * without volatile and memory clobber.
  */
 #define alternative(oldinstr, newinstr, feature)			\
-	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature) : : : "memory")
+	asm volatile (ALTERNATIVE(, oldinstr, newinstr, feature)	\
+		: : : "memory")
 
 /*
  * Alternative inline assembly with input.
@@ -128,17 +134,23 @@ static inline int alternatives_text_rese
  * Leaving an unused argument 0 to keep API compatibility.
  */
 #define alternative_input(oldinstr, newinstr, feature, input...)	\
-	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature)		\
+	asm volatile (ALTERNATIVE(, oldinstr, newinstr, feature)	\
 		: : "i" (0), ## input)
 
 /* Like alternative_input, but with a single output argument */
 #define alternative_io(oldinstr, newinstr, feature, output, input...)	\
-	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature)		\
+	asm volatile (ALTERNATIVE(, oldinstr, newinstr, feature)	\
 		: output : "i" (0), ## input)
 
+/* Like alternative_io, but with one or more common instructions. */
+#define alternative_common(common, oldinstr, newinstr, feature,		\
+			   output, input...)				\
+	asm volatile (ALTERNATIVE(common "\n", oldinstr, newinstr,	\
+		      feature) : output : input)
+
 /* Like alternative_io, but for replacing a direct call with another one. */
 #define alternative_call(oldfunc, newfunc, feature, output, input...)	\
-	asm volatile (ALTERNATIVE("call %P[old]", "call %P[new]", feature) \
+	asm volatile (ALTERNATIVE(, "call %P[old]", "call %P[new]", feature) \
 		: output : [old] "i" (oldfunc), [new] "i" (newfunc), ## input)
 
 /*
--- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/include/asm/arch_hweight.h
+++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/arch_hweight.h
@@ -25,7 +25,7 @@ static inline unsigned int __arch_hweigh
 {
 	unsigned int res = 0;
 
-	asm (ALTERNATIVE("call __sw_hweight32", POPCNT32, X86_FEATURE_POPCNT)
+	asm (ALTERNATIVE(, "call __sw_hweight32", POPCNT32, X86_FEATURE_POPCNT)
 		     : "="REG_OUT (res)
 		     : REG_IN (w));
 
@@ -50,7 +50,7 @@ static inline unsigned long __arch_hweig
 	return  __arch_hweight32((u32)w) +
 		__arch_hweight32((u32)(w >> 32));
 #else
-	asm (ALTERNATIVE("call __sw_hweight64", POPCNT64, X86_FEATURE_POPCNT)
+	asm (ALTERNATIVE(, "call __sw_hweight64", POPCNT64, X86_FEATURE_POPCNT)
 		     : "="REG_OUT (res)
 		     : REG_IN (w));
 #endif /* CONFIG_X86_32 */
--- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/include/asm/atomic64_32.h
+++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/atomic64_32.h
@@ -17,7 +17,7 @@ typedef struct {
 #ifdef CONFIG_X86_CMPXCHG64
 #define ATOMIC64_ALTERNATIVE_(f, g) "call atomic64_" #g "_cx8"
 #else
-#define ATOMIC64_ALTERNATIVE_(f, g) ALTERNATIVE("call atomic64_" #f "_386", "call atomic64_" #g "_cx8", X86_FEATURE_CX8)
+#define ATOMIC64_ALTERNATIVE_(f, g) ALTERNATIVE(, "call atomic64_" #f "_386", "call atomic64_" #g "_cx8", X86_FEATURE_CX8)
 #endif
 
 #define ATOMIC64_ALTERNATIVE(f) ATOMIC64_ALTERNATIVE_(f, f)
--- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/include/asm/cpufeature.h
+++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/cpufeature.h
@@ -97,6 +97,7 @@
 #define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
 #define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
 #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
+#define X86_FEATURE_SPINLOCK_YIELD (3*32+31) /* hypervisor yield interface */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
--- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/include/asm/spinlock.h
+++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/spinlock.h
@@ -7,6 +7,52 @@
 #include <asm/processor.h>
 #include <linux/compiler.h>
 #include <asm/paravirt.h>
+
+#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
+#include <asm/alternative.h>
+#include <asm/nops.h>
+/* Including asm/smp.h here causes a cyclic include dependency. */
+#include <asm/percpu.h>
+DECLARE_PER_CPU(int, cpu_number);
+
+extern void (*virt_spin_lock)(struct arch_spinlock *, unsigned int);
+extern void (*virt_spin_unlock)(struct arch_spinlock *, unsigned int);
+extern void virt_spin_lock_stub(void);
+extern void virt_spin_unlock_stub(void);
+
+#define ALTERNATIVE_TICKET_LOCK \
+	"call .L%=stub\n\t" \
+	".previous\n\t" \
+	".subsection 1\n" \
+	".L%=stub:\n\t" \
+	"push %%" REG_PTR_PREFIX "di\n\t" \
+	"push %" REG_PTR_MODE "0\n\t" \
+	"lea %1, %%" REG_PTR_PREFIX "di\n\t" \
+	"jmp %P[stub]\n\t" \
+	".subsection 0\n\t" \
+	".section .altinstr_replacement"
+
+#define ALTERNATIVE_TICKET_UNLOCK_HEAD \
+	"call .L%=stub\n\t" \
+	".previous\n\t" \
+	".subsection 1\n" \
+	".L%=stub:\n\t"
+
+#define ALTERNATIVE_TICKET_UNLOCK_TAIL \
+	"je .L%=ret\n\t" \
+	"push %%" REG_PTR_PREFIX "di\n\t" \
+	"push %" REG_PTR_MODE "[token]\n\t" \
+	"lea %[lock], %%" REG_PTR_PREFIX "di\n\t" \
+	"jmp %P[stub]\n" \
+	".L%=ret:\n\t" \
+	"rep; ret\n\t" \
+	".subsection 0\n\t" \
+	".section .altinstr_replacement"
+#else
+#define virt_spin_lock_stub 0
+#define ALTERNATIVE_TICKET_LOCK "ud2"
+#endif
+
 /*
  * Your basic SMP spinlocks, allowing only a single CPU anywhere
  *
@@ -22,9 +68,11 @@
 #ifdef CONFIG_X86_32
 # define LOCK_PTR_REG "a"
 # define REG_PTR_MODE "k"
+# define REG_PTR_PREFIX "e"
 #else
 # define LOCK_PTR_REG "D"
 # define REG_PTR_MODE "q"
+# define REG_PTR_PREFIX "r"
 #endif
 
 #if defined(CONFIG_X86_32) && \
@@ -62,18 +110,20 @@ static __always_inline void __ticket_spi
 {
 	short inc = 0x0100;
 
-	asm volatile (
+	alternative_common(
 		LOCK_PREFIX "xaddw %w0, %1\n"
 		"1:\t"
 		"cmpb %h0, %b0\n\t"
-		"je 2f\n\t"
+		"je 2f\n\t",
 		"rep ; nop\n\t"
 		"movb %1, %b0\n\t"
 		/* don't need lfence here, because loads are in-order */
 		"jmp 1b\n"
-		"2:"
-		: "+Q" (inc), "+m" (lock->slock)
-		:
+		"2:",
+		ALTERNATIVE_TICKET_LOCK,
+		X86_FEATURE_SPINLOCK_YIELD,
+		ASM_OUTPUT2("+Q" (inc), "+m" (lock->slock)),
+		[stub] "i" (virt_spin_lock_stub)
 		: "memory", "cc");
 }
 
@@ -98,10 +148,26 @@ static __always_inline int __ticket_spin
 
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
+#ifndef CONFIG_ENLIGHTEN_SPINLOCKS
 	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
 		     : "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
+#else
+	unsigned int token;
+
+	alternative_io(UNLOCK_LOCK_PREFIX "incb %[lock]\n\t"
+		ASM_NOP3,
+		ALTERNATIVE_TICKET_UNLOCK_HEAD
+		UNLOCK_LOCK_PREFIX "incb %[lock]\n\t"
+		"movzwl %[lock], %[token]\n\t"
+		"cmpb %h[token], %b[token]\n\t"
+		ALTERNATIVE_TICKET_UNLOCK_TAIL,
+		X86_FEATURE_SPINLOCK_YIELD,
+		ASM_OUTPUT2([lock] "+m" (lock->slock), [token] "=&Q" (token)),
+		[stub] "i" (virt_spin_unlock_stub)
+		: "memory", "cc");
+#endif
 }
 #else
 #define TICKET_SHIFT 16
@@ -111,19 +177,22 @@ static __always_inline void __ticket_spi
 	int inc = 0x00010000;
 	int tmp;
 
-	asm volatile(LOCK_PREFIX "xaddl %0, %1\n"
+	alternative_common(
+		     LOCK_PREFIX "xaddl %0, %1\n"
 		     "movzwl %w0, %2\n\t"
 		     "shrl $16, %0\n\t"
 		     "1:\t"
 		     "cmpl %0, %2\n\t"
-		     "je 2f\n\t"
+		     "je 2f\n\t",
 		     "rep ; nop\n\t"
 		     "movzwl %1, %2\n\t"
 		     /* don't need lfence here, because loads are in-order */
 		     "jmp 1b\n"
-		     "2:"
-		     : "+r" (inc), "+m" (lock->slock), "=&r" (tmp)
-		     :
+		     "2:",
+		     ALTERNATIVE_TICKET_LOCK,
+		     X86_FEATURE_SPINLOCK_YIELD,
+		     ASM_OUTPUT2("+r" (inc), "+m" (lock->slock), "=&r" (tmp)),
+		     [stub] "i" (virt_spin_lock_stub)
 		     : "memory", "cc");
 }
 
@@ -151,13 +220,36 @@ static __always_inline int __ticket_spin
 
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
+#ifndef CONFIG_ENLIGHTEN_SPINLOCKS
 	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
 		     : "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
+#else
+	unsigned int token, tmp;
+
+	alternative_io(UNLOCK_LOCK_PREFIX "incw %[lock]\n\t"
+		ASM_NOP2,
+		ALTERNATIVE_TICKET_UNLOCK_HEAD
+		UNLOCK_LOCK_PREFIX "incw %[lock]\n\t"
+		"movl %[lock], %[token]\n\t"
+		"shldl $16, %[token], %[tmp]\n\t"
+		"cmpw %w[tmp], %w[token]\n\t"
+		ALTERNATIVE_TICKET_UNLOCK_TAIL,
+		X86_FEATURE_SPINLOCK_YIELD,
+		ASM_OUTPUT2([lock] "+m" (lock->slock), [token] "=&r" (token),
+			    [tmp] "=&r" (tmp)),
+		[stub] "i" (virt_spin_unlock_stub)
+		: "memory", "cc");
+#endif
 }
 #endif
 
+#undef virt_spin_lock_stub
+#undef ALTERNATIVE_TICKET_LOCK
+#undef ALTERNATIVE_TICKET_UNLOCK_HEAD
+#undef ALTERNATIVE_TICKET_UNLOCK_TAIL
+
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
 	int tmp = ACCESS_ONCE(lock->slock);
--- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/kernel/alternative.c
+++ 2.6.35-rc3-virt-spinlocks/arch/x86/kernel/alternative.c
@@ -204,7 +204,8 @@ static void *text_poke_early(void *addr,
    Tough. Make sure you disable such features by hand. */
 
 void __init_or_module apply_alternatives(struct alt_instr *start,
-					 struct alt_instr *end)
+					 struct alt_instr *end,
+					 s32 *smp_start, s32 *smp_end)
 {
 	struct alt_instr *a;
 	u8 insnbuf[MAX_PATCH_LEN];
@@ -230,6 +231,37 @@ void __init_or_module apply_alternatives
 		add_nops(insnbuf + a->replacementlen,
 			 a->instrlen - a->replacementlen);
 		text_poke_early(instr, insnbuf, a->instrlen);
+
+#ifdef CONFIG_SMP
+		/*
+		 * Must fix up SMP locks pointers pointing into overwritten
+		 * code, and should fix up SMP locks pointers pointing into
+		 * replacement code (as those would otherwise not take effect).
+		 */
+		if (smp_start) {
+			s32 *poff;
+
+			for (poff = smp_start; poff < smp_end; poff++) {
+				const u8 *ptr = (const u8 *)poff + *poff;
+
+				if (ptr >= instr &&
+				    ptr < instr + a->instrlen) {
+					DPRINTK("invalidate smp lock @ %p\n",
+						ptr);
+					*poff = 0;
+					continue;
+				}
+				if (ptr >= a->replacement &&
+				    ptr < a->replacement + a->replacementlen) {
+					s32 disp = instr - a->replacement;
+
+					DPRINTK("reloc smp lock %p -> %p\n",
+						ptr, ptr + disp);
+					*poff += disp;
+				}
+			}
+		}
+#endif
 	}
 }
 
@@ -469,7 +501,8 @@ void __init alternative_instructions(voi
 	 * patching.
 	 */
 
-	apply_alternatives(__alt_instructions, __alt_instructions_end);
+	apply_alternatives(__alt_instructions, __alt_instructions_end,
+			   __smp_locks, __smp_locks_end);
 
 	/* switch to patch-once-at-boottime-only mode and free the
 	 * tables in case we know the number of CPUs will never ever
--- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/kernel/cpu/hypervisor.c
+++ 2.6.35-rc3-virt-spinlocks/arch/x86/kernel/cpu/hypervisor.c
@@ -25,6 +25,15 @@
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
 
+#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
+#include <linux/cache.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+void (*__read_mostly virt_spin_lock)(struct arch_spinlock *, unsigned int);
+void (*__read_mostly virt_spin_unlock)(struct arch_spinlock *, unsigned int);
+EXPORT_SYMBOL(virt_spin_unlock_stub);
+#endif
+
 /*
  * Hypervisor detect order.  This is specified explicitly here because
  * some hypervisors might implement compatibility modes for other
--- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/kernel/module.c
+++ 2.6.35-rc3-virt-spinlocks/arch/x86/kernel/module.c
@@ -209,6 +209,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 	const Elf_Shdr *s, *text = NULL, *alt = NULL, *locks = NULL,
 		*para = NULL;
 	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+	void *lseg;
 
 	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
 		if (!strcmp(".text", secstrings + s->sh_name))
@@ -221,13 +222,14 @@ int module_finalize(const Elf_Ehdr *hdr,
 			para = s;
 	}
 
+	lseg = locks && text ? (void *)locks->sh_addr : NULL;
 	if (alt) {
 		/* patch .altinstructions */
 		void *aseg = (void *)alt->sh_addr;
-		apply_alternatives(aseg, aseg + alt->sh_size);
+		apply_alternatives(aseg, aseg + alt->sh_size,
+				   lseg, lseg ? lseg + locks->sh_size : NULL);
 	}
-	if (locks && text) {
-		void *lseg = (void *)locks->sh_addr;
+	if (lseg) {
 		void *tseg = (void *)text->sh_addr;
 		alternatives_smp_module_add(me, me->name,
 					    lseg, lseg + locks->sh_size,
--- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/lib/thunk_32.S
+++ 2.6.35-rc3-virt-spinlocks/arch/x86/lib/thunk_32.S
@@ -45,3 +45,35 @@
 	thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller
 	thunk_ra trace_hardirqs_off_thunk,trace_hardirqs_off_caller
 #endif
+
+#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
+#include <asm/dwarf2.h>
+	.macro virt_spin_stub what, _stub=_stub
+ENTRY(virt_spin_\what\_stub)
+	CFI_STARTPROC simple
+	CFI_DEF_CFA esp, 3*4
+	CFI_OFFSET eip, -4
+	CFI_OFFSET edi, -8
+	pushl	%edx
+	CFI_ADJUST_CFA_OFFSET 4
+	movl	4(%esp), %edx			# token
+	movl	%eax, 4(%esp)
+	movl	%edi, %eax			# lock pointer
+	movl	8(%esp), %edi
+	CFI_RESTORE edi
+	movl	%ecx, 8(%esp)
+	call	*virt_spin_\what
+	popl	%edx
+	CFI_ADJUST_CFA_OFFSET -4
+	popl	%eax
+	CFI_ADJUST_CFA_OFFSET -4
+	popl	%ecx
+	CFI_ADJUST_CFA_OFFSET -4
+	ret
+	CFI_ENDPROC
+ENDPROC(virt_spin_\what\_stub)
+	.endm
+virt_spin_stub lock
+virt_spin_stub unlock
+	.purgem virt_spin_stub
+#endif
--- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/lib/thunk_64.S
+++ 2.6.35-rc3-virt-spinlocks/arch/x86/lib/thunk_64.S
@@ -79,3 +79,54 @@ restore_norax:	
 	RESTORE_ARGS 1
 	ret
 	CFI_ENDPROC
+
+#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
+	.text
+	.macro virt_spin_stub what, _stub=_stub
+ENTRY(virt_spin_\what\_stub)
+	CFI_STARTPROC simple
+	CFI_DEF_CFA rsp, 3*8
+	CFI_OFFSET rip, -8
+	pushq	%rsi
+	CFI_ADJUST_CFA_OFFSET 8
+	movl	8(%rsp), %esi			# token
+	movq	%rax, 8(%rsp)
+	pushq	%rcx
+	CFI_ADJUST_CFA_OFFSET 8
+	pushq	%rdx
+	CFI_ADJUST_CFA_OFFSET 8
+	pushq	%r8
+	CFI_ADJUST_CFA_OFFSET 8
+	pushq	%r9
+	CFI_ADJUST_CFA_OFFSET 8
+	pushq	%r10
+	CFI_ADJUST_CFA_OFFSET 8
+	pushq	%r11
+	CFI_ADJUST_CFA_OFFSET 8
+	call	*virt_spin_\what(%rip)
+	popq	%r11
+	CFI_ADJUST_CFA_OFFSET -8
+	popq	%r10
+	CFI_ADJUST_CFA_OFFSET -8
+	popq	%r9
+	CFI_ADJUST_CFA_OFFSET -8
+	popq	%r8
+	CFI_ADJUST_CFA_OFFSET -8
+	popq	%rdx
+	CFI_ADJUST_CFA_OFFSET -8
+	popq	%rcx
+	CFI_ADJUST_CFA_OFFSET -8
+	popq	%rsi
+	CFI_ADJUST_CFA_OFFSET -8
+	popq	%rax
+	CFI_ADJUST_CFA_OFFSET -8
+	popq	%rdi
+	CFI_ADJUST_CFA_OFFSET -8
+	ret
+	CFI_ENDPROC
+ENDPROC(virt_spin_\what\_stub)
+	.endm
+virt_spin_stub lock
+virt_spin_stub unlock
+	.purgem virt_spin_stub
+#endif


