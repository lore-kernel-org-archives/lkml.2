Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab2HGReJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:34:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39198 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755465Ab2HGReI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:34:08 -0400
Date: Tue, 7 Aug 2012 18:33:44 +0100
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
Message-ID: <20120807173344.GD16877@mudshark.cambridge.arm.com>
References: <20120807115647.GA12828@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1208071259270.5231@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208071259270.5231@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 06:14:36PM +0100, Nicolas Pitre wrote:
> On Tue, 7 Aug 2012, Will Deacon wrote:
> > The symptoms are that a bunch of hackbench tasks are left waiting on an
> > unlocked mutex and therefore never get woken up to claim it. I think this
> > boils down to the following sequence:
> > 
> > 
> >         Task A        Task B        Task C        Lock value
> > 0                                                     1
> > 1       lock()                                        0
> > 2                     lock()                          0
> > 3                     spin(A)                         0
> > 4       unlock()                                      1
> > 5                                   lock()            0
> > 6                     cmpxchg(1,0)                    0
> > 7                     contended()                    -1
> > 8       lock()                                        0
> > 9       spin(C)                                       0
> > 10                                  unlock()          1
> > 11      cmpxchg(1,0)                                  0
> > 12      unlock()                                      1
> > 
> > 
> > At this point, the lock is unlocked, but Task B is in an uninterruptible
> > sleep with nobody to wake it up.
> 
> I fail to see how the lock value would go from -1 to 0 on line 8.  How 
> does that happen?

What I think is happening is that B writes the -1 in __mutex_lock_common
and, after seeing a NULL owner (C may not have set that yet), drops through
to the:

	if (atomic_xchg(&lock->count, -1) == 1)
		goto done;

bit. At the same time, A does a mutex_lock, which goes down the fastpath:

	if (unlikely(atomic_xchg(count, 0) != 1))
		fail_fn(count);

setting the count to 0. It then trundles off down the slowpath and spins on
the new owner (C).

Maybe my diagram is confusing... the lock value is supposed to be the value
*after* the relevant operations on that same line have completed.

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
> 
> This would force invokation of the slow path on unlock even if in most 
> cases the lock is unlikely to be contended.  The really slow path does 
> check if the waiting list is empty and sets the count to 0 before 
> exiting to avoid that.  I don't see how this could be done safely in the 
> spin_on_owner loop code as the lock->wait_lock isn't held (which appears 
> to be the point of this code in the first place).

Indeed, it will trigger the slowpath on the next unlock but only in the case
that the lock was contended. You're right that there might not be any
waiters though, and we'd need to take the spinlock to check that.

> Yet, if the lock is heavily contended with a waiting task, the count 
> should never get back to 1 and the cmpxchg on line 11 would not set the 
> count to 0.  Hence my interrogation about line 8 above.

Hmm. __mutex_fastpath_unlock always sets the count to 1:

	if (unlikely(atomic_xchg(count, 1) != 0))
		failt_fn(count);

so there's always a window for a spinning waiter (as opposed to one blocked
in the queue) to succeed in the cmpxchg.

Unless I'm barking up the wrong tree!

Will
