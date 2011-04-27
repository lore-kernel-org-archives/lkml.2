Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab1D0PYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:24:14 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:36064 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab1D0PYK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 27 Apr 2011 11:24:10 -0400
Message-Id: <4DB85183020000780003E6B1@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 27 Apr 2011 16:25:23 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86: fix write lock scalability 64-bit issue
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the write lock path simply subtracting RW_LOCK_BIAS there is, on
large systems, the theoretical possibility of overflowing the 32-bit
value that was used so far (namely if 128 or more CPUs manage to do the
subtraction, but don't get to do the inverse addition in the failure
path quickly enough).

A first measure is to modify RW_LOCK_BIAS itself - with the new value
chosen, it is good for up to 2048 CPUs each allowed to nest over 2048
times on the read path without causing an issue. Quite possibly it
would even be sufficient to adjust the bias a little further, assuming
that allowing for significantly less nesting would suffice.

However, as the original value chosen allowed for even more nesting
levels, to support more than 2048 CPUs (possible currently only for
64-bit kernels) the lock itself gets widened to 64 bits.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/asm.h            |    2 +
 arch/x86/include/asm/rwlock.h         |   43 +++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/spinlock.h       |   37 +++++++++++++++++------------
 arch/x86/include/asm/spinlock_types.h |    6 ----
 arch/x86/lib/rwlock.S                 |   12 ++++-----
 arch/x86/lib/thunk_64.S               |    1 
 6 files changed, 73 insertions(+), 28 deletions(-)

--- 2.6.39-rc5-x86-rw.orig/arch/x86/include/asm/asm.h
+++ 2.6.39-rc5-x86-rw/arch/x86/include/asm/asm.h
@@ -3,9 +3,11 @@
 
 #ifdef __ASSEMBLY__
 # define __ASM_FORM(x)	x
+# define __ASM_FORM_COMMA(x) x,
 # define __ASM_EX_SEC	.section __ex_table, "a"
 #else
 # define __ASM_FORM(x)	" " #x " "
+# define __ASM_FORM_COMMA(x) " " #x ","
 # define __ASM_EX_SEC	" .section __ex_table,\"a\"\n"
 #endif
 
--- 2.6.39-rc5-x86-rw.orig/arch/x86/include/asm/rwlock.h
+++ 2.6.39-rc5-x86-rw/arch/x86/include/asm/rwlock.h
@@ -1,7 +1,48 @@
 #ifndef _ASM_X86_RWLOCK_H
 #define _ASM_X86_RWLOCK_H
 
-#define RW_LOCK_BIAS		 0x01000000
+#include <asm/asm.h>
+
+#if CONFIG_NR_CPUS <= 2048
+
+#ifndef __ASSEMBLY__
+typedef union {
+	s32 lock;
+	s32 write;
+} arch_rwlock_t;
+#endif
+
+#define RW_LOCK_BIAS		0x00100000
+#define READ_LOCK_SIZE(insn)	__ASM_FORM(insn##l)
+#define READ_LOCK_ATOMIC(n)	atomic_##n
+#define WRITE_LOCK_ADD(n)	__ASM_FORM_COMMA(addl n)
+#define WRITE_LOCK_SUB(n)	__ASM_FORM_COMMA(subl n)
+#define WRITE_LOCK_CMP		RW_LOCK_BIAS
+
+#else /* CONFIG_NR_CPUS > 2048 */
+
+#include <linux/const.h>
+
+#ifndef __ASSEMBLY__
+typedef union {
+	s64 lock;
+	struct {
+		u32 read;
+		s32 write;
+	};
+} arch_rwlock_t;
+#endif
+
+#define RW_LOCK_BIAS		(_AC(1,L) << 32)
+#define READ_LOCK_SIZE(insn)	__ASM_FORM(insn##q)
+#define READ_LOCK_ATOMIC(n)	atomic64_##n
+#define WRITE_LOCK_ADD(n)	__ASM_FORM(incl)
+#define WRITE_LOCK_SUB(n)	__ASM_FORM(decl)
+#define WRITE_LOCK_CMP		1
+
+#endif /* CONFIG_NR_CPUS */
+
+#define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
 
 /* Actual code is in asm/spinlock.h or in arch/x86/lib/rwlock.S */
 
--- 2.6.39-rc5-x86-rw.orig/arch/x86/include/asm/spinlock.h
+++ 2.6.39-rc5-x86-rw/arch/x86/include/asm/spinlock.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_SPINLOCK_H
 
 #include <asm/atomic.h>
-#include <asm/rwlock.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <linux/compiler.h>
@@ -234,7 +233,7 @@ static inline void arch_spin_unlock_wait
  */
 static inline int arch_read_can_lock(arch_rwlock_t *lock)
 {
-	return (int)(lock)->lock > 0;
+	return lock->lock > 0;
 }
 
 /**
@@ -243,12 +242,12 @@ static inline int arch_read_can_lock(arc
  */
 static inline int arch_write_can_lock(arch_rwlock_t *lock)
 {
-	return (lock)->lock == RW_LOCK_BIAS;
+	return lock->write == WRITE_LOCK_CMP;
 }
 
 static inline void arch_read_lock(arch_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX " subl $1,(%0)\n\t"
+	asm volatile(LOCK_PREFIX READ_LOCK_SIZE(dec) " (%0)\n\t"
 		     "jns 1f\n"
 		     "call __read_lock_failed\n\t"
 		     "1:\n"
@@ -257,47 +256,55 @@ static inline void arch_read_lock(arch_r
 
 static inline void arch_write_lock(arch_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX " subl %1,(%0)\n\t"
+	asm volatile(LOCK_PREFIX WRITE_LOCK_SUB(%1) "(%0)\n\t"
 		     "jz 1f\n"
 		     "call __write_lock_failed\n\t"
 		     "1:\n"
-		     ::LOCK_PTR_REG (rw), "i" (RW_LOCK_BIAS) : "memory");
+		     ::LOCK_PTR_REG (&rw->write), "i" (RW_LOCK_BIAS)
+		     : "memory");
 }
 
 static inline int arch_read_trylock(arch_rwlock_t *lock)
 {
-	atomic_t *count = (atomic_t *)lock;
+	READ_LOCK_ATOMIC(t) *count = (READ_LOCK_ATOMIC(t) *)lock;
 
-	if (atomic_dec_return(count) >= 0)
+	if (READ_LOCK_ATOMIC(dec_return)(count) >= 0)
 		return 1;
-	atomic_inc(count);
+	READ_LOCK_ATOMIC(inc)(count);
 	return 0;
 }
 
 static inline int arch_write_trylock(arch_rwlock_t *lock)
 {
-	atomic_t *count = (atomic_t *)lock;
+	atomic_t *count = (atomic_t *)&lock->write;
 
-	if (atomic_sub_and_test(RW_LOCK_BIAS, count))
+	if (atomic_sub_and_test(WRITE_LOCK_CMP, count))
 		return 1;
-	atomic_add(RW_LOCK_BIAS, count);
+	atomic_add(WRITE_LOCK_CMP, count);
 	return 0;
 }
 
 static inline void arch_read_unlock(arch_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX "incl %0" :"+m" (rw->lock) : : "memory");
+	asm volatile(LOCK_PREFIX READ_LOCK_SIZE(inc) " %0"
+		     :"+m" (rw->lock) : : "memory");
 }
 
 static inline void arch_write_unlock(arch_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX "addl %1, %0"
-		     : "+m" (rw->lock) : "i" (RW_LOCK_BIAS) : "memory");
+	asm volatile(LOCK_PREFIX WRITE_LOCK_ADD(%1) "%0"
+		     : "+m" (rw->write) : "i" (RW_LOCK_BIAS) : "memory");
 }
 
 #define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
 #define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
 
+#undef READ_LOCK_SIZE
+#undef READ_LOCK_ATOMIC
+#undef WRITE_LOCK_ADD
+#undef WRITE_LOCK_SUB
+#undef WRITE_LOCK_CMP
+
 #define arch_spin_relax(lock)	cpu_relax()
 #define arch_read_relax(lock)	cpu_relax()
 #define arch_write_relax(lock)	cpu_relax()
--- 2.6.39-rc5-x86-rw.orig/arch/x86/include/asm/spinlock_types.h
+++ 2.6.39-rc5-x86-rw/arch/x86/include/asm/spinlock_types.h
@@ -11,10 +11,6 @@ typedef struct arch_spinlock {
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
-typedef struct {
-	unsigned int lock;
-} arch_rwlock_t;
-
-#define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
+#include <asm/rwlock.h>
 
 #endif /* _ASM_X86_SPINLOCK_TYPES_H */
--- 2.6.39-rc5-x86-rw.orig/arch/x86/lib/rwlock.S
+++ 2.6.39-rc5-x86-rw/arch/x86/lib/rwlock.S
@@ -15,12 +15,12 @@ ENTRY(__write_lock_failed)
 	CFI_STARTPROC
 	FRAME
 0:	LOCK_PREFIX
-	addl	$RW_LOCK_BIAS, (%__lock_ptr)
+	WRITE_LOCK_ADD($RW_LOCK_BIAS) (%__lock_ptr)
 1:	rep; nop
-	cmpl	$RW_LOCK_BIAS, (%__lock_ptr)
+	cmpl	$WRITE_LOCK_CMP, (%__lock_ptr)
 	jne	1b
 	LOCK_PREFIX
-	subl	$RW_LOCK_BIAS, (%__lock_ptr)
+	WRITE_LOCK_SUB($RW_LOCK_BIAS) (%__lock_ptr)
 	jnz	0b
 	ENDFRAME
 	ret
@@ -31,12 +31,12 @@ ENTRY(__read_lock_failed)
 	CFI_STARTPROC
 	FRAME
 0:	LOCK_PREFIX
-	incl	(%__lock_ptr)
+	READ_LOCK_SIZE(inc) (%__lock_ptr)
 1:	rep; nop
-	cmpl	$1, (%__lock_ptr)
+	READ_LOCK_SIZE(cmp) $1, (%__lock_ptr)
 	js	1b
 	LOCK_PREFIX
-	decl	(%__lock_ptr)
+	READ_LOCK_SIZE(dec) (%__lock_ptr)
 	js	0b
 	ENDFRAME
 	ret
--- 2.6.39-rc5-x86-rw.orig/arch/x86/lib/thunk_64.S
+++ 2.6.39-rc5-x86-rw/arch/x86/lib/thunk_64.S
@@ -9,7 +9,6 @@
 	#include <linux/linkage.h>
 	#include <asm/dwarf2.h>
 	#include <asm/calling.h>			
-	#include <asm/rwlock.h>
 		
 	/* rdi:	arg1 ... normal C conventions. rax is saved/restored. */ 	
 	.macro thunk name,func


