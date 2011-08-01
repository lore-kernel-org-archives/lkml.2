Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1HARyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 13:54:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:45316 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab1HARyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 13:54:40 -0400
Date: Mon, 1 Aug 2011 17:53:53 GMT
Message-Id: <201108011753.p71HrrTr011226@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/spinlocks optional for 3.1
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Aug 2011 17:53:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for this late pull; testing on this got delayed due to my and
Ingo's scheduling and the desire to make sure that this would not
cause a performance regression.

At this time we have good confidence in it, but if you feel this is
too late feel free to drop it and we'll do it for 3.2.

	-hpa


The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-spinlocks-for-linus

H. Peter Anvin (1):
      x86, ticketlock: Use asm volatile for __ticket_unlock_release()

Jeremy Fitzhardinge (8):
      x86, ticketlock: Clean up types and accessors
      x86, ticketlock: Convert spin loop to C
      x86, ticketlock: Use C for __ticket_spin_unlock
      x86, ticketlock: Make large and small ticket versions of spin_lock the same
      x86, ticketlock: Make __ticket_spin_lock common
      x86, ticketlock: Make __ticket_spin_trylock common
      x86: Add xadd helper macro
      x86, ticketlock: Use xadd helper

 arch/x86/include/asm/cmpxchg_32.h     |   21 +++++
 arch/x86/include/asm/cmpxchg_64.h     |   26 ++++++
 arch/x86/include/asm/spinlock.h       |  140 +++++++++++----------------------
 arch/x86/include/asm/spinlock_types.h |   22 +++++-
 4 files changed, 114 insertions(+), 95 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 284a6e8..30f0318 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -280,4 +280,25 @@ static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
 
 #endif
 
+#define xadd(ptr, inc)							\
+	do {								\
+		switch (sizeof(*(ptr))) {				\
+		case 1:							\
+			asm volatile (LOCK_PREFIX "xaddb %b0, %1\n"	\
+				      : "+r" (inc), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case 2:							\
+			asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"	\
+				      : "+r" (inc), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case 4:							\
+			asm volatile (LOCK_PREFIX "xaddl %0, %1\n"	\
+				      : "+r" (inc), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		}							\
+	} while(0)
+
 #endif /* _ASM_X86_CMPXCHG_32_H */
diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
index 423ae58..62da1ff 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -151,4 +151,30 @@ extern void __cmpxchg_wrong_size(void);
 	cmpxchg_local((ptr), (o), (n));					\
 })
 
+#define xadd(ptr, inc)							\
+	do {								\
+		switch (sizeof(*(ptr))) {				\
+		case 1:							\
+			asm volatile (LOCK_PREFIX "xaddb %b0, %1\n"	\
+				      : "+r" (inc), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case 2:							\
+			asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"	\
+				      : "+r" (inc), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case 4:							\
+			asm volatile (LOCK_PREFIX "xaddl %0, %1\n"	\
+				      : "+r" (inc), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case 8:							\
+			asm volatile (LOCK_PREFIX "xaddq %q0, %1\n"	\
+				      : "+r" (inc), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		}							\
+	} while(0)
+
 #endif /* _ASM_X86_CMPXCHG_64_H */
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 3089f70..da196f1 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -33,9 +33,21 @@
  * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
  * (PPro errata 66, 92)
  */
-# define UNLOCK_LOCK_PREFIX LOCK_PREFIX
+static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
+{
+	if (sizeof(lock->tickets.head) == sizeof(u8))
+		asm volatile(LOCK_PREFIX "incb %0"
+			     : "+m" (lock->tickets.head) : : "memory");
+	else
+		asm volatile(LOCK_PREFIX "incw %0"
+			     : "+m" (lock->tickets.head) : : "memory");
+
+}
 #else
-# define UNLOCK_LOCK_PREFIX
+static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
+{
+	lock->tickets.head++;
+}
 #endif
 
 /*
@@ -55,121 +67,63 @@
  * save some instructions and make the code more elegant. There really isn't
  * much between them in performance though, especially as locks are out of line.
  */
-#if (NR_CPUS < 256)
-#define TICKET_SHIFT 8
-
-static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
+static __always_inline struct __raw_tickets __ticket_spin_claim(struct arch_spinlock *lock)
 {
-	short inc = 0x0100;
-
-	asm volatile (
-		LOCK_PREFIX "xaddw %w0, %1\n"
-		"1:\t"
-		"cmpb %h0, %b0\n\t"
-		"je 2f\n\t"
-		"rep ; nop\n\t"
-		"movb %1, %b0\n\t"
-		/* don't need lfence here, because loads are in-order */
-		"jmp 1b\n"
-		"2:"
-		: "+Q" (inc), "+m" (lock->slock)
-		:
-		: "memory", "cc");
-}
+	register struct __raw_tickets tickets = { .tail = 1 };
 
-static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
-{
-	int tmp, new;
-
-	asm volatile("movzwl %2, %0\n\t"
-		     "cmpb %h0,%b0\n\t"
-		     "leal 0x100(%" REG_PTR_MODE "0), %1\n\t"
-		     "jne 1f\n\t"
-		     LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
-		     "1:"
-		     "sete %b1\n\t"
-		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
-		     :
-		     : "memory", "cc");
-
-	return tmp;
-}
+	xadd(&lock->tickets, tickets);
 
-static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
-{
-	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
-		     : "+m" (lock->slock)
-		     :
-		     : "memory", "cc");
+	return tickets;
 }
-#else
-#define TICKET_SHIFT 16
 
-static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
+static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
 {
-	int inc = 0x00010000;
-	int tmp;
-
-	asm volatile(LOCK_PREFIX "xaddl %0, %1\n"
-		     "movzwl %w0, %2\n\t"
-		     "shrl $16, %0\n\t"
-		     "1:\t"
-		     "cmpl %0, %2\n\t"
-		     "je 2f\n\t"
-		     "rep ; nop\n\t"
-		     "movzwl %1, %2\n\t"
-		     /* don't need lfence here, because loads are in-order */
-		     "jmp 1b\n"
-		     "2:"
-		     : "+r" (inc), "+m" (lock->slock), "=&r" (tmp)
-		     :
-		     : "memory", "cc");
+	register struct __raw_tickets inc;
+
+	inc = __ticket_spin_claim(lock);
+
+	for (;;) {
+		if (inc.head == inc.tail)
+			goto out;
+		cpu_relax();
+		inc.head = ACCESS_ONCE(lock->tickets.head);
+	}
+out:	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
-	int tmp;
-	int new;
-
-	asm volatile("movl %2,%0\n\t"
-		     "movl %0,%1\n\t"
-		     "roll $16, %0\n\t"
-		     "cmpl %0,%1\n\t"
-		     "leal 0x00010000(%" REG_PTR_MODE "0), %1\n\t"
-		     "jne 1f\n\t"
-		     LOCK_PREFIX "cmpxchgl %1,%2\n\t"
-		     "1:"
-		     "sete %b1\n\t"
-		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
-		     :
-		     : "memory", "cc");
-
-	return tmp;
+	arch_spinlock_t old, new;
+
+	old.tickets = ACCESS_ONCE(lock->tickets);
+	if (old.tickets.head != old.tickets.tail)
+		return 0;
+
+	new.head_tail = old.head_tail + (1 << TICKET_SHIFT);
+
+	/* cmpxchg is a full barrier, so nothing can move before it */
+	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
 }
 
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
-	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
-		     : "+m" (lock->slock)
-		     :
-		     : "memory", "cc");
+	barrier();		/* prevent reordering out of locked region */
+	__ticket_unlock_release(lock);
+	barrier();		/* prevent reordering into locked region */
 }
-#endif
 
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
-	int tmp = ACCESS_ONCE(lock->slock);
+	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-	return !!(((tmp >> TICKET_SHIFT) ^ tmp) & ((1 << TICKET_SHIFT) - 1));
+	return !!(tmp.tail ^ tmp.head);
 }
 
 static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
 {
-	int tmp = ACCESS_ONCE(lock->slock);
+	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
+	return ((tmp.tail - tmp.head) & TICKET_MASK) > 1;
 }
 
 #ifndef CONFIG_PARAVIRT_SPINLOCKS
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index dcb48b2..72e154e 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -5,11 +5,29 @@
 # error "please don't include this file directly"
 #endif
 
+#include <linux/types.h>
+
+#if (CONFIG_NR_CPUS < 256)
+typedef u8  __ticket_t;
+typedef u16 __ticketpair_t;
+#else
+typedef u16 __ticket_t;
+typedef u32 __ticketpair_t;
+#endif
+
+#define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
+#define TICKET_MASK	((__ticket_t)((1 << TICKET_SHIFT) - 1))
+
 typedef struct arch_spinlock {
-	unsigned int slock;
+	union {
+		__ticketpair_t head_tail;
+		struct __raw_tickets {
+			__ticket_t head, tail;
+		} tickets;
+	};
 } arch_spinlock_t;
 
-#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
 
 typedef struct {
 	unsigned int lock;
