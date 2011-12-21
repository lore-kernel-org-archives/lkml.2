Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1LUQhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:37:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38438 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab1LUQhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:37:21 -0500
Date: Wed, 21 Dec 2011 08:37:15 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH for-3.3] mempool: clean up and document synchronization
 and memory barrier usage
Message-ID: <20111221163715.GS10752@google.com>
References: <20111220221818.GJ10752@google.com>
 <20111221145556.GA25657@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221145556.GA25657@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Wed, Dec 21, 2011 at 03:55:56PM +0100, Oleg Nesterov wrote:
> > The wmb can be the implied one from unlocking pool->lock and smp_mb()
> > in mempool_free() can be replaced with smp_rmb().
> 
> OK... I do not know if this is the bug or not, but I agree this race
> is possible.

I'm not entirely sure whether this is a condition which we need to
guarantee but, if the scenario like the above ever happens, it's gonna
be a hellish one to track down.  It is *highly* unlikely to ever cause
any real problem.  It requires combination of unlikely situations to
lead to an actual problem.  But, if that ever happens, it's gonna a
hellish one to track down, to the level that we'll have to put it
aside as one freak occurrence and blame solar activity or alignment of
stars.  As nothing really prevents the described pattern, I think it's
better to be safe.

IMHO fringe corner cases like this are the biggest reason we need to
be extra reserved when playing with lockless tricks and fully document
when we end up using one.

> > Furthermore, mempool_alloc() is already holding pool->lock when it
> > decides that it needs to wait.  There is no reason to do unlock - add
> > waitqueue - test condition again.  It can simply add itself to
> > waitqueue while holding pool->lock and then unlock and sleep.
> 
> Confused. I agree, we can hold pool->lock until schedule(). But, at
> the same time, why should we hold it?
> 
> Or I missed the reason why we must not unlock before prepare_to_wait?

Yeah, as you replied in another message, this is to avoid a ordering
dependent curr_nr test.  Extending lock coverage here doesn't cost
anything and it's always better to be straightforward.

> > --- work.orig/mm/mempool.c
> > +++ work/mm/mempool.c
> > @@ -223,29 +223,31 @@ repeat_alloc:
> >  	spin_lock_irqsave(&pool->lock, flags);
> >  	if (likely(pool->curr_nr)) {
> >  		element = remove_element(pool);
> > +		/* implied wmb in unlock is faired with rmb in mempool_free() */
> >  		spin_unlock_irqrestore(&pool->lock, flags);
> 
> Not really afaics. unlock() doesn't imply wmb().
> 
> So, if some thread does PTR = mempool_alloc(), the "final" store to PTR
> can leak into the critical section, and it can be reordered inside this
> section with --curr_nr.
> 
> See the fat comment about set_current_state() in prepare_to_wait().

Hmmm.... I'm quoting it part here.  (cc'ing David and Paul, hi guys!)

/*
 * Note: we use "set_current_state()" _after_ the wait-queue add,
 * because we need a memory barrier there on SMP, so that any
 * wake-function that tests for the wait-queue being active
 * will be guaranteed to see waitqueue addition _or_ subsequent
 * tests in this thread will see the wakeup having taken place.
 *
 * The spin_unlock() itself is semi-permeable and only protects
 * one way (it only protects stuff inside the critical region and
 * stops them from bleeding out - it would still allow subsequent
 * loads to move into the critical region).
 */
	   
The first paragraph is saying that at that point full barrier (for
both stores and loads) is necessary at that point and the second
paragraph is a bit confusing but the last sentence seems to say that
only loads after the unlock can creep above unlock, which essentially
means write barrier.

I think clearer explanation is in memory-barrier.txt.

 (6) UNLOCK operations.

     This also acts as a one-way permeable barrier.  It guarantees that all
     memory operations before the UNLOCK operation will appear to happen before
     the UNLOCK operation with respect to the other components of the system.

     Memory operations that occur after an UNLOCK operation may appear to
     happen before it completes.

     LOCK and UNLOCK operations are guaranteed to appear with respect to each
     other strictly in the order specified.

     The use of LOCK and UNLOCK operations generally precludes the need for
     other sorts of memory barrier (but note the exceptions mentioned in the
     subsection "MMIO write barrier").
						   
So, in a nutshell, I think it's saying w.r.t. stores is that stores
before unlock may not be deferred across the unlock but stores after
unlock may creep upwards past unlock, so it acts as one-way write
barrier.  And, yeah, that would be the minimal requirement for proper
lock operation.  Curious whether any processor implements such fine
grained barrier tho, maybe alpha does that too?

Paul, David, am I understanding it correctly?

Anyways, yeah, you're right.  We need a smp_wmb() before returning but
I think the comment on top of prepare_to_wait() is misleading.  Care
to update it?

> IOW. Whatever we do, we can race with other threads and miss "curr_nr < min_nr"
> condition. But this is fine, unless this element (which we are going to free)
> was the reason for this condition. Otherwise we can rely on another mempool_free(),
> the waiters in mempool_alloc() can never hang forever.

Yes, that's another way to put it.  It's much easier to understand if
you draw a graph with time on x axis and curr_nr on y and mark which
curr_nr values are guaranteed to be visible to whom.  If at any point
of time, a freeing task sees curr_nr == min_nr, it's guaranteed that
either it's staying that way or, if not, someone else will see the
newly decremented value.

> Yes, I think this is right.

Great, thanks.  I'll wait a bit for futher comments and repost w/
smp_wmb() added.

Thanks.

-- 
tejun
