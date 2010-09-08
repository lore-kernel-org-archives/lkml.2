Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab0IHHeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 03:34:36 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:33250 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756537Ab0IHHee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 03:34:34 -0400
Date: Wed, 8 Sep 2010 17:34:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
Message-ID: <20100908073428.GR705@dastard>
References: <20100907072954.GM705@dastard>
 <4C86003B.6090706@kernel.org>
 <20100907100108.GN705@dastard>
 <4C861582.6080102@kernel.org>
 <20100907124850.GP705@dastard>
 <4C865CC4.9070701@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C865CC4.9070701@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 05:39:48PM +0200, Tejun Heo wrote:
> On 09/07/2010 02:48 PM, Dave Chinner wrote:
> > On Tue, Sep 07, 2010 at 12:35:46PM +0200, Tejun Heo wrote:
> > Almost. What happens is that there is a queue of data IO
> > completions on q0, say w1...wN where wX is in the middle of the
> > queue. wX requires lock A, but lock A is held by a a transaction
> > commit that is blocked by IO completion t1 on q1. The dependency
> > chain we then have is:
> > 
> > 	wX on q0 -> lock A -> t1 on q1
> > 
> > To prevent wX from blocking q0, when lock A is not gained, we
> > requeue wX to the tail of q0 such that the queue is not wX+1..wN,wX.
> > this means that wX will not block completion processing of data IO.
> > If wX is the only work on q0, then to stop the work queue from
> > spinning processing wX, queueing wX, processing wX.... there is a
> > delay(1) call to allow some time for other IOs to complete to occur
> > before trying again to process wX again.
> > 
> > At some point, q1 is processed and t1 is run and lock A
> > released. Once this happens, wX will gain lock A and finish the
> > completion and be freed.
> > 
> > The issue I appear to be seeing is that while q0 is doing:
> > 
> > 	wX -> requeue on q0 -> delay(1) -> wX -> requeue q0 -> wX
> > 
> > q1 which contains t1 is never getting processed, and hence the q0/wX
> > loop is never getting broken.
> 
> I see.  The use case itself shouldn't be problematic at all for cmwq
> (sans bugs of course).  In the other reply, you said "the system is
> 100% unresponsive when the livelock occurs", which is kind of
> puzzling.  It isn't really a livelock.

Actually, it is. You don't need to burn CPU to livelock, you just
need a loop in the state machine that cannot be broken by internal
or external events to be considered livelocked.

However, this is not what I was calling the livelock problem - this
is what I was calling the deadlock problem because to all external
appearences the state machine is deadlocked on the inode lock....

The livelock case I described where the system is completely
unresponsive is the one I'm testing the WQ_HIGHPRI mod against.

FWIW, having considered the above case again, and seeing what the
WQ_HIGHPRI mod does in terms of queuing, I think that it may also
solve this deadlock as the log IO completionwill always be queued
ahead of the data IO completion now.


> >> Also, how does delay(1) help with chewing up CPU?  Are you talking
> >> about avoiding constant lock/unlock ops starving other lockers?  In
> >> such case, wouldn't cpu_relax() make more sense?
> > 
> > Basically delay(1) is used in many places in XFS as a "backoff and
> > retry after a short period of time" mechanism in places where
> > blocking would lead to deadlock or we need a state change to occur
> > before retrying the operation that would have deadlocked. If we
> > don't put a backoff in, then we simply burn CPU until the condition
> > clears.
> > 
> > In the case of the data Io completion workqueue processing, the CPU
> > burn occurred when the only item on the workqueue was the inode that
> > we could not lock.  Hence the backoff. It's not a great solution,
> > but it's the only one that could be sued without changing everything
> > to use delayed works and hence suffer the associated structure bloat
> > for what is a rare corner case....
> 
> Hmm... The point where I'm confused is that *delay()'s are busy waits.
> They burn CPU cycles.  I suppose you're referring to *sleep()'s,
> right?

fs/xfs/linux-2.6/time.h:

static inline void delay(long ticks)
{
        schedule_timeout_uninterruptible(ticks);
}

> >> I don't remember but once I increased maximum concurrency for every
> >> workqueue (the limit was 128 or something) and xfs pretty quickly hit
> >> the concurrency limit.  IIRC, there was a function which allocates
> >> work_struct and schedules it.  I'll look through the emails.
> > 
> > How do you get concurrency requirements of 128 when you only have a
> > small number of CPUs?
> 
> Probably I have overloaded the term 'concurrency' too much.  In this
> case, I meant the number of workers assigned to work items of the wq.
> If you fire off N work items which sleep at the same time, cmwq will
> eventually try to create N workers as each previous worker goes to
> sleep so that the CPU doesn't sit idle while there are work items to
> process as long as N < @wq->nr->active.

Ok, so if I queue N items on a single CPU when max_active == N, they
get spread across N worker threads on different CPUs? 

> Documentation follows.

I'll have read of this tonight.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
