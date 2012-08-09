Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab2HIFMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 01:12:18 -0400
Received: from relais.videotron.ca ([24.201.245.36]:27650 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab2HIFMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 01:12:17 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 09 Aug 2012 01:12:15 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: RFC: mutex: hung tasks on SMP platforms with
 asm-generic/mutex-xchg.h
In-reply-to: <20120807115647.GA12828@mudshark.cambridge.arm.com>
Message-id: <alpine.LFD.2.02.1208090029460.5231@xanadu.home>
References: <20120807115647.GA12828@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2012, Will Deacon wrote:

> Hello,
> 
> ARM recently moved to asm-generic/mutex-xchg.h for its mutex implementation
> after our previous implementation was found to be missing some crucial
> memory barriers. However, I'm seeing some problems running hackbench on
> SMP platforms due to the way in which the MUTEX_SPIN_ON_OWNER code operates.
> 
> The symptoms are that a bunch of hackbench tasks are left waiting on an
> unlocked mutex and therefore never get woken up to claim it. I think this
> boils down to the following sequence:
> 
> 
>         Task A        Task B        Task C        Lock value
> 0                                                     1
> 1       lock()                                        0
> 2                     lock()                          0
> 3                     spin(A)                         0
> 4       unlock()                                      1
> 5                                   lock()            0
> 6                     cmpxchg(1,0)                    0
> 7                     contended()                    -1
> 8       lock()                                        0
> 9       spin(C)                                       0
> 10                                  unlock()          1
> 11      cmpxchg(1,0)                                  0
> 12      unlock()                                      1
> 
> 
> At this point, the lock is unlocked, but Task B is in an uninterruptible
> sleep with nobody to wake it up.
> 
> The following patch fixes the problem by ensuring we put the lock into
> the contended state if we acquire it from the spin loop on the slowpath
> but I'd like to be sure that this won't cause problems with other mutex
> implementations:
> 
> 
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index a307cc9..27b7887 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -170,7 +170,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>                 if (owner && !mutex_spin_on_owner(lock, owner))
>                         break;
>  
> -               if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
> +               if (atomic_cmpxchg(&lock->count, 1, -1) == 1) {
>                         lock_acquired(&lock->dep_map, ip);
>                         mutex_set_owner(lock);
>                         preempt_enable();
> 
> 
> All comments welcome.

Well... after thinking about this for a while, I came to the conclusion 
that the mutex_spin_on_owner code is indeed breaking the contract 
between the xchg lock fast path and the slow path.  The xchg fast path 
will always set the count to 0 and rely on the slow path to restore a 
possible pre-existing negative count.  So the above change would be 
needed for correctness in the xchg case, even if it always forces the 
unlock into the slow path.

As I mentioned previously, we don't want to force the slow path in all 
cases though.  The atomic decrement based fast path doesn't need that, 
so I'd suggest this fix instead:

diff --git a/include/asm-generic/mutex-xchg.h b/include/asm-generic/mutex-xchg.h
index 580a6d35c7..60964844c8 100644
--- a/include/asm-generic/mutex-xchg.h
+++ b/include/asm-generic/mutex-xchg.h
@@ -108,4 +108,6 @@ __mutex_fastpath_trylock(atomic_t *count, int (*fail_fn)(atomic_t *))
 	return prev;
 }
 
+#define __MUTEX_XCHG_FAST_PATH
+
 #endif
diff --git a/kernel/mutex.c b/kernel/mutex.c
index a307cc9c95..c6a26a4f1c 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -161,6 +161,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 	for (;;) {
 		struct task_struct *owner;
+		int locked_val;
 
 		/*
 		 * If there's an owner, wait for it to either
@@ -170,7 +171,19 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if (owner && !mutex_spin_on_owner(lock, owner))
 			break;
 
-		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
+#ifdef __MUTEX_XCHG_FAST_PATH
+		/*
+		 * The fast path based on xchg sets a transient 0 count,
+		 * relying on the slow path to restore a possible
+		 * pre-existing contended count.  Without checking the
+		 * waiters' list we must presume possible contension here.
+		 */
+		locked_val = -1;
+#else
+		locked_val = 0;
+#endif
+
+		if (atomic_cmpxchg(&lock->count, 1, locked_val) == 1) {
 			lock_acquired(&lock->dep_map, ip);
 			mutex_set_owner(lock);
 			preempt_enable();

That would be needed for the stable tree as well.

A further cleanup could remove all definitions of 
__mutex_slowpath_needs_to_unlock() given that they're all set to 1 
except for the xchg fast path, in which case __MUTEX_XCHG_FAST_PATH 
could be reused instead.

Of course that might tilt the balance towards using mutex-dec.h on ARM 
v6 and above instead of mutex-xchg.h.  But that is an orthogonal issue, 
and that doesn't remove the need for fixing the xchg based case for 
correctness.


Nicolas
