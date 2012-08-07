Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab2HGSOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:14:50 -0400
Received: from relais.videotron.ca ([24.201.245.36]:29665 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab2HGSOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:14:49 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2012 14:14:49 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Tue, 07 Aug 2012 13:14:36 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: RFC: mutex: hung tasks on SMP platforms with
 asm-generic/mutex-xchg.h
In-reply-to: <20120807115647.GA12828@mudshark.cambridge.arm.com>
Message-id: <alpine.LFD.2.02.1208071259270.5231@xanadu.home>
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

I fail to see how the lock value would go from -1 to 0 on line 8.  How 
does that happen?
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

This would force invokation of the slow path on unlock even if in most 
cases the lock is unlikely to be contended.  The really slow path does 
check if the waiting list is empty and sets the count to 0 before 
exiting to avoid that.  I don't see how this could be done safely in the 
spin_on_owner loop code as the lock->wait_lock isn't held (which appears 
to be the point of this code in the first place).

Yet, if the lock is heavily contended with a waiting task, the count 
should never get back to 1 and the cmpxchg on line 11 would not set the 
count to 0.  Hence my interrogation about line 8 above.


Nicolas
