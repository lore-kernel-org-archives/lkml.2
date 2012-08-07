Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab2HGOFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:05:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64190 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734Ab2HGOFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:05:22 -0400
Date: Tue, 7 Aug 2012 15:04:55 +0100
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>,
        Nicolas Pitre <nico@fluxnic.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RFC: mutex: hung tasks on SMP platforms with
 asm-generic/mutex-xchg.h
Message-ID: <20120807140455.GB12828@mudshark.cambridge.arm.com>
References: <20120807115647.GA12828@mudshark.cambridge.arm.com>
 <1344347322.27828.120.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344347322.27828.120.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 02:48:42PM +0100, Peter Zijlstra wrote:
> On Tue, 2012-08-07 at 12:56 +0100, Will Deacon wrote:
> > ARM recently moved to asm-generic/mutex-xchg.h for its mutex implementation
> > after our previous implementation was found to be missing some crucial
> > memory barriers. 
> 
> 
> This is a76d7bd96d ("ARM: 7467/1: mutex: use generic xchg-based
> implementation for ARMv6+"), right? Why do you use xchg and not dec
> based? The changelog mumbles something about shorter critical sections,
> but me not knowing anything about ARM wonders about the why of that.

Correct, that's the patch. We don't have atomic add/sub instructions on ARM,
so instead we have to do:

1:	ldrex	...	@ Exclusive load
	add/sub ...     @ Do the arithmetic
	strex	...	@ Exclusive store
	cmp	...	@ Check the store succeeded
	bne	1b	@ Retry if we weren't atomic

So using dec adds a sub where we wouldn't need an instruction there for xchg.
I suspect there's no measurable difference between the two, but we use the
xchg-based implementation for CPUs prior to ARMv6 so it saves an ifdef as
well. Some discussion on the original patch here:

  http://lists.infradead.org/pipermail/linux-arm-kernel/2012-July/109333.html

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

[...]

> But in this case, either B is still spinning in our spin-loop, or it has
> already passed the atomic_xchg(&lock->count, -1) when we fell out.

Yes, it does that xchg on line 7 (see the lock value of -1)...

> Since you say B is in UNINTERRUPTIBLE state, we'll assume it fell
> through and so the lock count should be -1 (or less) to mark it
> contended.

... but then A sets it straight back to 0 in __mutex_fastpath_lock and falls
down the slowpath due to it being contended. The problem is that it doesn't
restore the -1 when it acquires the lock on line 11, so B is never woken up.

Will
