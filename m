Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab1AETOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 14:14:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:54786 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab1AETOk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 14:14:40 -0500
Subject: [RFC][PATCH] spinlock: Kill spin_unlock_wait()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <20110104064542.GF3402@amd>
References: <20101224122338.172750730@chello.nl>
	 <20101224123742.724459093@chello.nl>
	 <AANLkTikGBsh0-QTe9CA2gwDtwzpdMi+fbDsTEKiJAL0P@mail.gmail.com>
	 <1294054362.2016.74.camel@laptop>  <20110104064542.GF3402@amd>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 20:14:27 +0100
Message-ID: <1294254867.2016.281.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 17:45 +1100, Nick Piggin wrote:
> So I agree, taking it out the back and shooting it in the head would make
> the world a better place. 

There appear to be only two callsites of said horror, one in the exit
path and one in ata-eh, neither appear to be performance critical so I
replaced them with a simple lock-unlock sequence.

---
 arch/alpha/include/asm/spinlock.h          |    2 --
 arch/arm/include/asm/spinlock.h            |    2 --
 arch/blackfin/include/asm/spinlock.h       |    6 ------
 arch/cris/include/arch-v32/arch/spinlock.h |    6 ------
 arch/ia64/include/asm/spinlock.h           |   19 -------------------
 arch/m32r/include/asm/spinlock.h           |    2 --
 arch/mips/include/asm/spinlock.h           |    2 --
 arch/mn10300/include/asm/spinlock.h        |    1 -
 arch/parisc/include/asm/spinlock.h         |    2 --
 arch/powerpc/include/asm/spinlock.h        |    7 -------
 arch/powerpc/lib/locks.c                   |   11 -----------
 arch/s390/include/asm/spinlock.h           |    3 ---
 arch/sh/include/asm/spinlock.h             |    2 --
 arch/sparc/include/asm/spinlock_32.h       |    3 ---
 arch/sparc/include/asm/spinlock_64.h       |    4 ----
 arch/tile/include/asm/spinlock_32.h        |    2 --
 arch/tile/lib/spinlock_32.c                |    8 --------
 arch/x86/include/asm/spinlock.h            |    6 ------
 drivers/ata/libata-eh.c                    |    6 ++++--
 include/linux/spinlock.h                   |   11 -----------
 include/linux/spinlock_up.h                |    3 ---
 kernel/exit.c                              |    3 ++-
 22 files changed, 6 insertions(+), 105 deletions(-)

diff --git a/arch/alpha/include/asm/spinlock.h b/arch/alpha/include/asm/spinlock.h
index d0faca1..0545bef 100644
--- a/arch/alpha/include/asm/spinlock.h
+++ b/arch/alpha/include/asm/spinlock.h
@@ -14,8 +14,6 @@
 
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
 #define arch_spin_is_locked(x)	((x)->lock != 0)
-#define arch_spin_unlock_wait(x) \
-		do { cpu_relax(); } while ((x)->lock)
 
 static inline void arch_spin_unlock(arch_spinlock_t * lock)
 {
diff --git a/arch/arm/include/asm/spinlock.h b/arch/arm/include/asm/spinlock.h
index 17eb355..91ede71 100644
--- a/arch/arm/include/asm/spinlock.h
+++ b/arch/arm/include/asm/spinlock.h
@@ -34,8 +34,6 @@ static inline void dsb_sev(void)
  */
 
 #define arch_spin_is_locked(x)		((x)->lock != 0)
-#define arch_spin_unlock_wait(lock) \
-	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
 
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
 
diff --git a/arch/blackfin/include/asm/spinlock.h b/arch/blackfin/include/asm/spinlock.h
index 1942ccf..d1630fc 100644
--- a/arch/blackfin/include/asm/spinlock.h
+++ b/arch/blackfin/include/asm/spinlock.h
@@ -46,12 +46,6 @@ static inline void arch_spin_unlock(arch_spinlock_t *lock)
 	__raw_spin_unlock_asm(&lock->lock);
 }
 
-static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
-{
-	while (arch_spin_is_locked(lock))
-		cpu_relax();
-}
-
 static inline int arch_read_can_lock(arch_rwlock_t *rw)
 {
 	return __raw_uncached_fetch_asm(&rw->lock) > 0;
diff --git a/arch/cris/include/arch-v32/arch/spinlock.h b/arch/cris/include/arch-v32/arch/spinlock.h
index f171a66..01da21c 100644
--- a/arch/cris/include/arch-v32/arch/spinlock.h
+++ b/arch/cris/include/arch-v32/arch/spinlock.h
@@ -22,12 +22,6 @@ static inline void arch_spin_unlock(arch_spinlock_t *lock)
 			  : "memory");
 }
 
-static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
-{
-	while (arch_spin_is_locked(lock))
-		cpu_relax();
-}
-
 static inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	return cris_spin_trylock((void *)&lock->slock);
diff --git a/arch/ia64/include/asm/spinlock.h b/arch/ia64/include/asm/spinlock.h
index 1a91c91..7c4de8b 100644
--- a/arch/ia64/include/asm/spinlock.h
+++ b/arch/ia64/include/asm/spinlock.h
@@ -75,20 +75,6 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 	ACCESS_ONCE(*p) = (tmp + 2) & ~1;
 }
 
-static __always_inline void __ticket_spin_unlock_wait(arch_spinlock_t *lock)
-{
-	int	*p = (int *)&lock->lock, ticket;
-
-	ia64_invala();
-
-	for (;;) {
-		asm volatile ("ld4.c.nc %0=[%1]" : "=r"(ticket) : "r"(p) : "memory");
-		if (!(((ticket >> TICKET_SHIFT) ^ ticket) & TICKET_MASK))
-			return;
-		cpu_relax();
-	}
-}
-
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
 	long tmp = ACCESS_ONCE(lock->lock);
@@ -135,11 +121,6 @@ static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 	arch_spin_lock(lock);
 }
 
-static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
-{
-	__ticket_spin_unlock_wait(lock);
-}
-
 #define arch_read_can_lock(rw)		(*(volatile int *)(rw) >= 0)
 #define arch_write_can_lock(rw)	(*(volatile int *)(rw) == 0)
 
diff --git a/arch/m32r/include/asm/spinlock.h b/arch/m32r/include/asm/spinlock.h
index 179a064..0e099cc 100644
--- a/arch/m32r/include/asm/spinlock.h
+++ b/arch/m32r/include/asm/spinlock.h
@@ -26,8 +26,6 @@
 
 #define arch_spin_is_locked(x)		(*(volatile int *)(&(x)->slock) <= 0)
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
-#define arch_spin_unlock_wait(x) \
-		do { cpu_relax(); } while (arch_spin_is_locked(x))
 
 /**
  * arch_spin_trylock - Try spin lock and return a result
diff --git a/arch/mips/include/asm/spinlock.h b/arch/mips/include/asm/spinlock.h
index 396e402..711425f 100644
--- a/arch/mips/include/asm/spinlock.h
+++ b/arch/mips/include/asm/spinlock.h
@@ -42,8 +42,6 @@ static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 }
 
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
-#define arch_spin_unlock_wait(x) \
-	while (arch_spin_is_locked(x)) { cpu_relax(); }
 
 static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
diff --git a/arch/mn10300/include/asm/spinlock.h b/arch/mn10300/include/asm/spinlock.h
index 9342915..3460e5d 100644
--- a/arch/mn10300/include/asm/spinlock.h
+++ b/arch/mn10300/include/asm/spinlock.h
@@ -23,7 +23,6 @@
  */
 
 #define arch_spin_is_locked(x)	(*(volatile signed char *)(&(x)->slock) != 0)
-#define arch_spin_unlock_wait(x) do { barrier(); } while (arch_spin_is_locked(x))
 
 static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
diff --git a/arch/parisc/include/asm/spinlock.h b/arch/parisc/include/asm/spinlock.h
index 74036f4..b419128 100644
--- a/arch/parisc/include/asm/spinlock.h
+++ b/arch/parisc/include/asm/spinlock.h
@@ -12,8 +12,6 @@ static inline int arch_spin_is_locked(arch_spinlock_t *x)
 }
 
 #define arch_spin_lock(lock) arch_spin_lock_flags(lock, 0)
-#define arch_spin_unlock_wait(x) \
-		do { cpu_relax(); } while (arch_spin_is_locked(x))
 
 static inline void arch_spin_lock_flags(arch_spinlock_t *x,
 					 unsigned long flags)
diff --git a/arch/powerpc/include/asm/spinlock.h b/arch/powerpc/include/asm/spinlock.h
index f9611bd..c9fd936 100644
--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -150,13 +150,6 @@ static inline void arch_spin_unlock(arch_spinlock_t *lock)
 	lock->slock = 0;
 }
 
-#ifdef CONFIG_PPC64
-extern void arch_spin_unlock_wait(arch_spinlock_t *lock);
-#else
-#define arch_spin_unlock_wait(lock) \
-	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
-#endif
-
 /*
  * Read-write spinlocks, allowing multiple readers
  * but only one writer.
diff --git a/arch/powerpc/lib/locks.c b/arch/powerpc/lib/locks.c
index 9b8182e..e800d5f 100644
--- a/arch/powerpc/lib/locks.c
+++ b/arch/powerpc/lib/locks.c
@@ -82,14 +82,3 @@ void __rw_yield(arch_rwlock_t *rw)
 }
 #endif
 
-void arch_spin_unlock_wait(arch_spinlock_t *lock)
-{
-	while (lock->slock) {
-		HMT_low();
-		if (SHARED_PROCESSOR)
-			__spin_yield(lock);
-	}
-	HMT_medium();
-}
-
-EXPORT_SYMBOL(arch_spin_unlock_wait);
diff --git a/arch/s390/include/asm/spinlock.h b/arch/s390/include/asm/spinlock.h
index 56612fc..cb98ce7 100644
--- a/arch/s390/include/asm/spinlock.h
+++ b/arch/s390/include/asm/spinlock.h
@@ -35,9 +35,6 @@ _raw_compare_and_swap(volatile unsigned int *lock,
  */
 
 #define arch_spin_is_locked(x) ((x)->owner_cpu != 0)
-#define arch_spin_unlock_wait(lock) \
-	do { while (arch_spin_is_locked(lock)) \
-		 arch_spin_relax(lock); } while (0)
 
 extern void arch_spin_lock_wait(arch_spinlock_t *);
 extern void arch_spin_lock_wait_flags(arch_spinlock_t *, unsigned long flags);
diff --git a/arch/sh/include/asm/spinlock.h b/arch/sh/include/asm/spinlock.h
index bdc0f3b..7ac8916 100644
--- a/arch/sh/include/asm/spinlock.h
+++ b/arch/sh/include/asm/spinlock.h
@@ -25,8 +25,6 @@
 
 #define arch_spin_is_locked(x)		((x)->lock <= 0)
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
-#define arch_spin_unlock_wait(x) \
-	do { while (arch_spin_is_locked(x)) cpu_relax(); } while (0)
 
 /*
  * Simple spin lock operations.  There are two variants, one clears IRQ's
diff --git a/arch/sparc/include/asm/spinlock_32.h b/arch/sparc/include/asm/spinlock_32.h
index 7f9b9db..f10958a 100644
--- a/arch/sparc/include/asm/spinlock_32.h
+++ b/arch/sparc/include/asm/spinlock_32.h
@@ -12,9 +12,6 @@
 
 #define arch_spin_is_locked(lock) (*((volatile unsigned char *)(lock)) != 0)
 
-#define arch_spin_unlock_wait(lock) \
-	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
-
 static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	__asm__ __volatile__(
diff --git a/arch/sparc/include/asm/spinlock_64.h b/arch/sparc/include/asm/spinlock_64.h
index 073936a..2845f6e 100644
--- a/arch/sparc/include/asm/spinlock_64.h
+++ b/arch/sparc/include/asm/spinlock_64.h
@@ -23,10 +23,6 @@
 
 #define arch_spin_is_locked(lp)	((lp)->lock != 0)
 
-#define arch_spin_unlock_wait(lp)	\
-	do {	rmb();			\
-	} while((lp)->lock)
-
 static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	unsigned long tmp;
diff --git a/arch/tile/include/asm/spinlock_32.h b/arch/tile/include/asm/spinlock_32.h
index 88efdde..3ccb768 100644
--- a/arch/tile/include/asm/spinlock_32.h
+++ b/arch/tile/include/asm/spinlock_32.h
@@ -61,8 +61,6 @@ static inline void arch_spin_unlock(arch_spinlock_t *lock)
 	lock->current_ticket = old_ticket + TICKET_QUANTUM;
 }
 
-void arch_spin_unlock_wait(arch_spinlock_t *lock);
-
 /*
  * Read-write spinlocks, allowing multiple readers
  * but only one writer.
diff --git a/arch/tile/lib/spinlock_32.c b/arch/tile/lib/spinlock_32.c
index 5cd1c40..72a6507 100644
--- a/arch/tile/lib/spinlock_32.c
+++ b/arch/tile/lib/spinlock_32.c
@@ -61,14 +61,6 @@ int arch_spin_trylock(arch_spinlock_t *lock)
 }
 EXPORT_SYMBOL(arch_spin_trylock);
 
-void arch_spin_unlock_wait(arch_spinlock_t *lock)
-{
-	u32 iterations = 0;
-	while (arch_spin_is_locked(lock))
-		delay_backoff(iterations++);
-}
-EXPORT_SYMBOL(arch_spin_unlock_wait);
-
 /*
  * The low byte is always reserved to be the marker for a "tns" operation
  * since the low bit is set to "1" by a tns.  The next seven bits are
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 3089f70..f23106f 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -208,12 +208,6 @@ static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
 
-static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
-{
-	while (arch_spin_is_locked(lock))
-		cpu_relax();
-}
-
 /*
  * Read-write spinlocks, allowing multiple readers
  * but only one writer.
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 17a6378..f246965 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -668,8 +668,10 @@ void ata_scsi_error(struct Scsi_Host *host)
 
 		/* initialize eh_tries */
 		ap->eh_tries = ATA_EH_MAX_TRIES;
-	} else
-		spin_unlock_wait(ap->lock);
+	} else {
+		spin_lock_irqsave(ap->lock, flags);
+		spin_unlock_irqrestore(ap->lock, flags);
+	}
 
 	/* If we timed raced normal completion and there is nothing to
 	   recover nr_timedout == 0 why exactly are we doing error recovery ? */
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 80e5358..d7b89ef 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -122,12 +122,6 @@ do {								\
 static inline void smp_mb__after_lock(void) { smp_mb(); }
 #endif
 
-/**
- * raw_spin_unlock_wait - wait until the spinlock gets unlocked
- * @lock: the spinlock in question.
- */
-#define raw_spin_unlock_wait(lock)	arch_spin_unlock_wait(&(lock)->raw_lock)
-
 #ifdef CONFIG_DEBUG_SPINLOCK
  extern void do_raw_spin_lock(raw_spinlock_t *lock) __acquires(lock);
 #define do_raw_spin_lock_flags(lock, flags) do_raw_spin_lock(lock)
@@ -355,11 +349,6 @@ static inline int spin_trylock_irq(spinlock_t *lock)
 	raw_spin_trylock_irqsave(spinlock_check(lock), flags); \
 })
 
-static inline void spin_unlock_wait(spinlock_t *lock)
-{
-	raw_spin_unlock_wait(&lock->rlock);
-}
-
 static inline int spin_is_locked(spinlock_t *lock)
 {
 	return raw_spin_is_locked(&lock->rlock);
diff --git a/include/linux/spinlock_up.h b/include/linux/spinlock_up.h
index b14f6a9..53c7a86 100644
--- a/include/linux/spinlock_up.h
+++ b/include/linux/spinlock_up.h
@@ -70,7 +70,4 @@ static inline void arch_spin_unlock(arch_spinlock_t *lock)
 #define arch_read_can_lock(lock)	(((void)(lock), 1))
 #define arch_write_can_lock(lock)	(((void)(lock), 1))
 
-#define arch_spin_unlock_wait(lock) \
-		do { cpu_relax(); } while (arch_spin_is_locked(lock))
-
 #endif /* __LINUX_SPINLOCK_UP_H */
diff --git a/kernel/exit.c b/kernel/exit.c
index 676149a..2c6b725 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -956,7 +956,8 @@ NORET_TYPE void do_exit(long code)
 	 * an exiting task cleaning up the robust pi futexes.
 	 */
 	smp_mb();
-	raw_spin_unlock_wait(&tsk->pi_lock);
+	raw_spin_lock_irq(&tsk->pi_lock);
+	raw_spin_unlock_irq(&tsk->pi_lock);
 
 	if (unlikely(in_atomic()))
 		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",

