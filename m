Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1GUKIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:08:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:60107 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab1GUKIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:08:50 -0400
Date: Thu, 21 Jul 2011 10:07:54 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Message-ID: <tip-a750036f35cda160ef77408ec92c3dc41f8feebb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        jbeulich@novell.com, akpm@linux-foundation.org, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, jbeulich@novell.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        JBeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4E258E0D020000780004E3F0@nat28.tlf.novell.com>
References: <4E258E0D020000780004E3F0@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Fix write lock scalability 64-bit issue
Git-Commit-ID: a750036f35cda160ef77408ec92c3dc41f8feebb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:07:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a750036f35cda160ef77408ec92c3dc41f8feebb
Gitweb:     http://git.kernel.org/tip/a750036f35cda160ef77408ec92c3dc41f8feebb
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Tue, 19 Jul 2011 13:00:45 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 09:03:36 +0200

x86: Fix write lock scalability 64-bit issue

With the write lock path simply subtracting RW_LOCK_BIAS there
is, on large systems, the theoretical possibility of overflowing
the 32-bit value that was used so far (namely if 128 or more
CPUs manage to do the subtraction, but don't get to do the
inverse addition in the failure path quickly enough).

A first measure is to modify RW_LOCK_BIAS itself - with the new
value chosen, it is good for up to 2048 CPUs each allowed to
nest over 2048 times on the read path without causing an issue.
Quite possibly it would even be sufficient to adjust the bias a
little further, assuming that allowing for significantly less
nesting would suffice.

However, as the original value chosen allowed for even more
nesting levels, to support more than 2048 CPUs (possible
currently only for 64-bit kernels) the lock itself gets widened
to 64 bits.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4E258E0D020000780004E3F0@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/asm.h            |    2 +
 arch/x86/include/asm/rwlock.h         |   43 ++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/spinlock.h       |   37 +++++++++++++++++-----------
 arch/x86/include/asm/spinlock_types.h |    6 +----
 arch/x86/lib/rwlock.S                 |   12 ++++----
 arch/x86/lib/thunk_64.S               |    1 -
 6 files changed, 73 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 5890beb..9412d65 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
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
 
diff --git a/arch/x86/include/asm/rwlock.h b/arch/x86/include/asm/rwlock.h
index 6a8c0d6..a5370a0 100644
--- a/arch/x86/include/asm/rwlock.h
+++ b/arch/x86/include/asm/rwlock.h
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
 
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 3089f70..e9e51f7 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_SPINLOCK_H
 
 #include <asm/atomic.h>
-#include <asm/rwlock.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <linux/compiler.h>
@@ -234,7 +233,7 @@ static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
  */
 static inline int arch_read_can_lock(arch_rwlock_t *lock)
 {
-	return (int)(lock)->lock > 0;
+	return lock->lock > 0;
 }
 
 /**
@@ -243,12 +242,12 @@ static inline int arch_read_can_lock(arch_rwlock_t *lock)
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
@@ -257,47 +256,55 @@ static inline void arch_read_lock(arch_rwlock_t *rw)
 
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
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index dcb48b2..7c7a486 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -11,10 +11,6 @@ typedef struct arch_spinlock {
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
-typedef struct {
-	unsigned int lock;
-} arch_rwlock_t;
-
-#define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
+#include <asm/rwlock.h>
 
 #endif /* _ASM_X86_SPINLOCK_TYPES_H */
diff --git a/arch/x86/lib/rwlock.S b/arch/x86/lib/rwlock.S
index fca1782..1cad221 100644
--- a/arch/x86/lib/rwlock.S
+++ b/arch/x86/lib/rwlock.S
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
diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
index d5b088b..a63efd6 100644
--- a/arch/x86/lib/thunk_64.S
+++ b/arch/x86/lib/thunk_64.S
@@ -8,7 +8,6 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/calling.h>
-#include <asm/rwlock.h>
 
 	/* rdi:	arg1 ... normal C conventions. rax is saved/restored. */
 	.macro THUNK name, func, put_ret_addr_in_rdi=0
