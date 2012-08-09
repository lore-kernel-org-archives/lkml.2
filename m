Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030778Ab2HIOuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:50:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35984 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030749Ab2HIOuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:50:35 -0400
Date: Thu, 9 Aug 2012 15:49:53 +0100
From: Will Deacon <will.deacon@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RFC: mutex: hung tasks on SMP platforms with
 asm-generic/mutex-xchg.h
Message-ID: <20120809144953.GC18486@mudshark.cambridge.arm.com>
References: <20120807115647.GA12828@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1208090029460.5231@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208090029460.5231@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

Thanks for the replies.

On Thu, Aug 09, 2012 at 06:12:15AM +0100, Nicolas Pitre wrote:
> On Tue, 7 Aug 2012, Will Deacon wrote:
> > diff --git a/kernel/mutex.c b/kernel/mutex.c
> > index a307cc9..27b7887 100644
> > --- a/kernel/mutex.c
> > +++ b/kernel/mutex.c
> > @@ -170,7 +170,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
> >                 if (owner && !mutex_spin_on_owner(lock, owner))
> >                         break;
> >  
> > -               if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
> > +               if (atomic_cmpxchg(&lock->count, 1, -1) == 1) {
> >                         lock_acquired(&lock->dep_map, ip);
> >                         mutex_set_owner(lock);
> >                         preempt_enable();
> > 
> > 
> > All comments welcome.
> 
> Well... after thinking about this for a while, I came to the conclusion 
> that the mutex_spin_on_owner code is indeed breaking the contract 
> between the xchg lock fast path and the slow path.  The xchg fast path 
> will always set the count to 0 and rely on the slow path to restore a 
> possible pre-existing negative count.  So the above change would be 
> needed for correctness in the xchg case, even if it always forces the 
> unlock into the slow path.

Great, so we agree on that.

> As I mentioned previously, we don't want to force the slow path in all 
> cases though.  The atomic decrement based fast path doesn't need that, 
> so I'd suggest this fix instead:

One minor typo and a suggested alternative below...

> diff --git a/include/asm-generic/mutex-xchg.h b/include/asm-generic/mutex-xchg.h
> index 580a6d35c7..60964844c8 100644
> --- a/include/asm-generic/mutex-xchg.h
> +++ b/include/asm-generic/mutex-xchg.h
> @@ -108,4 +108,6 @@ __mutex_fastpath_trylock(atomic_t *count, int (*fail_fn)(atomic_t *))
>  	return prev;
>  }
>  
> +#define __MUTEX_XCHG_FAST_PATH
> +
>  #endif
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index a307cc9c95..c6a26a4f1c 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -161,6 +161,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  
>  	for (;;) {
>  		struct task_struct *owner;
> +		int locked_val;
>  
>  		/*
>  		 * If there's an owner, wait for it to either
> @@ -170,7 +171,19 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		if (owner && !mutex_spin_on_owner(lock, owner))
>  			break;
>  
> -		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
> +#ifdef __MUTEX_XCHG_FAST_PATH
> +		/*
> +		 * The fast path based on xchg sets a transient 0 count,
> +		 * relying on the slow path to restore a possible
> +		 * pre-existing contended count.  Without checking the
> +		 * waiters' list we must presume possible contension here.

s/contension/contention/

> +		 */
> +		locked_val = -1;
> +#else
> +		locked_val = 0;
> +#endif
> +
> +		if (atomic_cmpxchg(&lock->count, 1, locked_val) == 1) {
>  			lock_acquired(&lock->dep_map, ip);
>  			mutex_set_owner(lock);
>  			preempt_enable();
> 
> That would be needed for the stable tree as well.
> 
> A further cleanup could remove all definitions of 
> __mutex_slowpath_needs_to_unlock() given that they're all set to 1 
> except for the xchg fast path, in which case __MUTEX_XCHG_FAST_PATH 
> could be reused instead.

I think we could actually fix this entirely in mutex-xchg.h by doing
something in fastpath_lock similar to what we do for trylock:


diff --git a/include/asm-generic/mutex-xchg.h b/include/asm-generic/mutex-xchg.h
index 580a6d3..c082e99 100644
--- a/include/asm-generic/mutex-xchg.h
+++ b/include/asm-generic/mutex-xchg.h
@@ -25,8 +25,19 @@
 static inline void
 __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
-       if (unlikely(atomic_xchg(count, 0) != 1))
-               fail_fn(count);
+       int prev = atomic_xchg(count, 0);
+
+       if (unlikely(prev != 1)) {
+               if (prev < 0)
+                       /*
+                        * The lock was contended, so we need to restore
+                        * its original state to ensure that any waiting
+                        * tasks are woken up by the unlock slow path.
+                        */
+                       prev = atomic_xchg(count, prev);
+               if (prev != 1)
+                       fail_fn(count);
+       }
 }
 
 /**


What do you reckon?

> Of course that might tilt the balance towards using mutex-dec.h on ARM 
> v6 and above instead of mutex-xchg.h.  But that is an orthogonal issue, 
> and that doesn't remove the need for fixing the xchg based case for 
> correctness.

I'll do some hackbench runs against mutex-dec once we've decided on the final
xchg code. If it's faster, I'll submit a patch for ARM.

Cheers,

Will
