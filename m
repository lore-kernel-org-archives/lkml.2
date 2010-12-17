Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab0LQNXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:23:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:33490 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab0LQNXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:23:47 -0500
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimXyic51Qhe_WsfFBwAw10AKdB7e-Z2q0oLRYKP@mail.gmail.com>
References: <20101216145602.899838254@chello.nl>
	 <20101216150920.968046926@chello.nl> <20101216184229.GA15889@redhat.com>
	 <1292525893.2708.50.camel@laptop> <1292526220.2708.55.camel@laptop>
	 <1292528874.2708.85.camel@laptop> <1292531553.2708.89.camel@laptop>
	 <AANLkTimXyic51Qhe_WsfFBwAw10AKdB7e-Z2q0oLRYKP@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Dec 2010 14:23:20 +0100
Message-ID: <1292592200.2266.220.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 11:06 +0800, Yan, Zheng wrote:
> On Fri, Dec 17, 2010 at 4:32 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > @@ -953,7 +955,7 @@ static inline struct rq *__task_rq_lock(
> >        for (;;) {
> >                rq = task_rq(p);
> >                raw_spin_lock(&rq->lock);
> > -               if (likely(rq == task_rq(p)))
> > +               if (likely(rq == task_rq(p)) && !task_is_waking(p))
> >                        return rq;
> >                raw_spin_unlock(&rq->lock);
> >        }
> > @@ -973,7 +975,7 @@ static struct rq *task_rq_lock(struct ta
> >                local_irq_save(*flags);
> >                rq = task_rq(p);
> >                raw_spin_lock(&rq->lock);
> > -               if (likely(rq == task_rq(p)))
> > +               if (likely(rq == task_rq(p)) && !task_is_waking(p))
> >                        return rq;
> >                raw_spin_unlock_irqrestore(&rq->lock, *flags);
> >        }
> 
> Looks like nothing prevents ttwu() from changing task's CPU while
> some one else is holding task_rq_lock(). Is this OK?

Ah, crud, good catch. No that is not quite OK ;-)

I'm starting to think adding a per-task scheduler lock isn't such a bad
idea after all :-)

How does something like the below look, it waits for the current
task_rq(p)->lock owner to go away after we flip p->state to TASK_WAKING.

It also optimizes the x86 spinlock code a bit, no need to wait for all
pending owners to go away, just the current one.

This also solves the p->cpus_allowed race..

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2518,6 +2518,8 @@ try_to_wake_up(struct task_struct *p, un
 			break;
 	}
 
+	raw_spin_unlock_wait(&task_rq(p)->lock);
+
 	ret = 1; /* we qualify as a proper wakeup now */
 
 	if (load) // XXX racy
@@ -2536,10 +2538,7 @@ try_to_wake_up(struct task_struct *p, un
 
 	if (p->sched_class->task_waking)
 		p->sched_class->task_waking(p);
-	/*
-	 * XXX: by having set TASK_WAKING outside of rq->lock, there
-	 * could be an in-flight change to p->cpus_allowed..
-	 */
+
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
 #endif
 	ttwu_queue(p, cpu);
Index: linux-2.6/arch/x86/include/asm/spinlock.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/spinlock.h
+++ linux-2.6/arch/x86/include/asm/spinlock.h
@@ -158,18 +158,34 @@ static __always_inline void __ticket_spi
 }
 #endif
 
+#define TICKET_MASK ((1 << TICKET_SHIFT) - 1)
+
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
 	int tmp = ACCESS_ONCE(lock->slock);
 
-	return !!(((tmp >> TICKET_SHIFT) ^ tmp) & ((1 << TICKET_SHIFT) - 1));
+	return !!(((tmp >> TICKET_SHIFT) ^ tmp) & TICKET_MASK);
 }
 
 static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
 {
 	int tmp = ACCESS_ONCE(lock->slock);
 
-	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
+	return (((tmp >> TICKET_SHIFT) - tmp) & TICKET_MASK) > 1;
+}
+
+static inline void __ticket_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	int tmp = ACCESS_ONCE(lock->slock);
+
+	if (!(((tmp >> TICKET_SHIFT) ^ tmp) & TICKET_MASK))
+		return; /* not locked */
+
+	tmp &= TICKET_MASK;
+
+	/* wait until the current lock holder goes away */
+	while ((ACCESS_ONCE(lock->slock) & TICKET_MASK) == tmp)
+		cpu_relax();
 }
 
 #ifndef CONFIG_PARAVIRT_SPINLOCKS
@@ -206,7 +222,11 @@ static __always_inline void arch_spin_lo
 	arch_spin_lock(lock);
 }
 
-#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
+{
+	__ticket_spin_unlock_wait(lock);
+}
+#else
 
 static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
@@ -214,6 +234,8 @@ static inline void arch_spin_unlock_wait
 		cpu_relax();
 }
 
+#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
+
 /*
  * Read-write spinlocks, allowing multiple readers
  * but only one writer.

