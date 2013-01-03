Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab3ACL3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 06:29:37 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:43589 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3ACL3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 06:29:34 -0500
MIME-Version: 1.0
In-Reply-To: <20130103001536.7fd1e952@annuminas.surriel.com>
References: <20130103001536.7fd1e952@annuminas.surriel.com>
Date: Thu, 3 Jan 2013 16:59:32 +0530
Message-ID: <CAC4Lta05MkYw8-zMq9q5fqJN=voOGRNRdubH+3Y0k4pSsq_GpA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] x86,smp: make ticket spinlock proportional
 backoff w/ auto tuning
From: Raghavendra KT <raghavendra.kt.linux@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        eric.dumazet@gmail.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, knoel@redhat.com,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing my ibm id]
On Thu, Jan 3, 2013 at 10:45 AM, Rik van Riel <riel@redhat.com> wrote:
> Many spinlocks are embedded in data structures; having many CPUs
> pounce on the cache line the lock is in will slow down the lock
> holder, and can cause system performance to fall off a cliff.
>
> The paper "Non-scalable locks are dangerous" is a good reference:
>
>         http://pdos.csail.mit.edu/papers/linux:lock.pdf
>
> In the Linux kernel, spinlocks are optimized for the case of
> there not being contention. After all, if there is contention,
> the data structure can be improved to reduce or eliminate
> lock contention.
>
> Likewise, the spinlock API should remain simple, and the
> common case of the lock not being contended should remain
> as fast as ever.
>
> However, since spinlock contention should be fairly uncommon,
> we can add functionality into the spinlock slow path that keeps
> system performance from falling off a cliff when there is lock
> contention.
>
> Proportional delay in ticket locks is delaying the time between
> checking the ticket based on a delay factor, and the number of
> CPUs ahead of us in the queue for this lock. Checking the lock
> less often allows the lock holder to continue running, resulting
> in better throughput and preventing performance from dropping
> off a cliff.
>
> The test case has a number of threads locking and unlocking a
> semaphore. With just one thread, everything sits in the CPU
> cache and throughput is around 2.6 million operations per
> second, with a 5-10% variation.
>
> Once a second thread gets involved, data structures bounce
> from CPU to CPU, and performance deteriorates to about 1.25
> million operations per second, with a 5-10% variation.
>
> However, as more and more threads get added to the mix,
> performance with the vanilla kernel continues to deteriorate.
> Once I hit 24 threads, on a 24 CPU, 4 node test system,
> performance is down to about 290k operations/second.
>
> With a proportional backoff delay added to the spinlock
> code, performance with 24 threads goes up to about 400k
> operations/second with a 50x delay, and about 900k operations/second
> with a 250x delay. However, with a 250x delay, performance with
> 2-5 threads is worse than with a 50x delay.
>
> Making the code auto-tune the delay factor results in a system
> that performs well with both light and heavy lock contention,
> and should also protect against the (likely) case of the fixed
> delay factor being wrong for other hardware.
>
> The attached graph shows the performance of the multi threaded
> semaphore lock/unlock test case, with 1-24 threads, on the
> vanilla kernel, with 10x, 50x, and 250x proportional delay,
> as well as the v1 patch series with autotuning for 2x and 2.7x
> spinning before the lock is obtained, and with the v2 series.
>
> The v2 series integrates several ideas from Michel Lespinasse
> and Eric Dumazet, which should result in better throughput and
> nicer behaviour in situations with contention on multiple locks.
>
> Please let me know if you manage to break this code in any way,
> so I can fix it...
>

Hi Rik,
 Whole series looks very interesting.Thanks for posting spinlock. I am
also curious, how the series affect virtualization cases.
(was about to reply for V1 with Eric changes but delayed because of vacation).

I am planning try V2 on baremetal and guests and comeback.

On a related note,
While experimenting with PV spinlock, I had tried "weighed spinlock".
rationale behind the patch is in virtualized environment use case is
exactly opposite.

If head and tail difference is more, probability of getting lock is
very less so, spin for only little time when difference is high.
and after loop is over if we have not got lock, halt (pv spinlock)/
yield to better guy.

Here is the patch for reference that I tried on top of PV spinlocks.

summary of patch :
looping is proportional to

2 * SPIN_THRESHOLD
---------------------------------
( head - tail - 1)

---8<---
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index e6881fd..2f637ce 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -53,6 +53,18 @@ static inline void
__ticket_enter_slowpath(arch_spinlock_t *lock)
 	set_bit(0, (volatile unsigned long *)&lock->tickets.tail);
 }

+static inline unsigned get_spin_threshold(int diff)
+{
+	unsigned count = SPIN_THRESHOLD;
+
+	/* handle wrap around */
+	if (unlikely(diff < 0))
+		diff += TICKETLOCK_MAX_VAL;
+
+	count = count >> ((diff - 1) >> 1);
+	return count;
+}
+
 #else  /* !CONFIG_PARAVIRT_SPINLOCKS */
 static __always_inline void __ticket_lock_spinning(arch_spinlock_t *lock,
 							__ticket_t ticket)
@@ -62,6 +74,10 @@ static inline void
__ticket_unlock_kick(arch_spinlock_t *lock,
 							__ticket_t ticket)
 {
 }
+static inline unsigned get_spin_threshold(int diff)
+{
+	return SPIN_THRESHOLD;
+}

 #endif /* CONFIG_PARAVIRT_SPINLOCKS */

@@ -88,8 +104,8 @@ static __always_inline void
arch_spin_lock(arch_spinlock_t *lock)

 	inc.tail &= ~TICKET_SLOWPATH_FLAG;
 	for (;;) {
-		unsigned count = SPIN_THRESHOLD;
-
+		unsigned count = get_spin_threshold(inc.tail -
+					ACCESS_ONCE(lock->tickets.head));
 		do {
 			if (ACCESS_ONCE(lock->tickets.head) == inc.tail)
 				goto out;
diff --git a/arch/x86/include/asm/spinlock_types.h
b/arch/x86/include/asm/spinlock_types.h
index 4f1bea1..22e38a5 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -14,9 +14,11 @@
 #if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_INC))
 typedef u8  __ticket_t;
 typedef u16 __ticketpair_t;
+#define TICKETLOCK_MAX_VAL (1 << 8)
 #else
 typedef u16 __ticket_t;
 typedef u32 __ticketpair_t;
+#define TICKETLOCK_MAX_VAL (1 << 16)
 #endif

 #define TICKET_LOCK_INC	((__ticket_t)__TICKET_LOCK_INC)
