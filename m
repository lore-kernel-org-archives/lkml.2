Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2HGNsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:48:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:51460 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2HGNsy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:48:54 -0400
Message-ID: <1344347322.27828.120.camel@twins>
Subject: Re: RFC: mutex: hung tasks on SMP platforms with
 asm-generic/mutex-xchg.h
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>,
        Nicolas Pitre <nico@fluxnic.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 07 Aug 2012 15:48:42 +0200
In-Reply-To: <20120807115647.GA12828@mudshark.cambridge.arm.com>
References: <20120807115647.GA12828@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 12:56 +0100, Will Deacon wrote:
> Hello,
> 
> ARM recently moved to asm-generic/mutex-xchg.h for its mutex implementation
> after our previous implementation was found to be missing some crucial
> memory barriers. 


This is a76d7bd96d ("ARM: 7467/1: mutex: use generic xchg-based
implementation for ARMv6+"), right? Why do you use xchg and not dec
based? The changelog mumbles something about shorter critical sections,
but me not knowing anything about ARM wonders about the why of that.

> However, I'm seeing some problems running hackbench on
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

But in this case, either B is still spinning in our spin-loop, or it has
already passed the atomic_xchg(&lock->count, -1) when we fell out.

Since you say B is in UNINTERRUPTIBLE state, we'll assume it fell
through and so the lock count should be -1 (or less) to mark it
contended.


