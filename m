Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1LUSh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:37:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1LUShW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:37:22 -0500
Date: Wed, 21 Dec 2011 18:40:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH for-3.3] mempool: clean up and document synchronization
	and memory barrier usage
Message-ID: <20111221174057.GA32347@redhat.com>
References: <20111220221818.GJ10752@google.com> <20111221145556.GA25657@redhat.com> <20111221163715.GS10752@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221163715.GS10752@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/21, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Wed, Dec 21, 2011 at 03:55:56PM +0100, Oleg Nesterov wrote:
> > > The wmb can be the implied one from unlocking pool->lock and smp_mb()
> > > in mempool_free() can be replaced with smp_rmb().
> >
> > OK... I do not know if this is the bug or not, but I agree this race
> > is possible.
>
> I'm not entirely sure whether this is a condition which we need to
> guarantee but, if the scenario like the above ever happens, it's gonna
> be a hellish one to track down.

Yes, yes, I agree. In fact I was going to remove this sentence after
I actually read the patch, but forgot.

And in any case, it is very nice to document the barriers.

> > Not really afaics. unlock() doesn't imply wmb().
> >
> > So, if some thread does PTR = mempool_alloc(), the "final" store to PTR
> > can leak into the critical section, and it can be reordered inside this
> > section with --curr_nr.
> >
> > See the fat comment about set_current_state() in prepare_to_wait().
>
> Hmmm.... I'm quoting it part here.  (cc'ing David and Paul, hi guys!)
>
> /*
>  * Note: we use "set_current_state()" _after_ the wait-queue add,
>  * because we need a memory barrier there on SMP, so that any
>  * wake-function that tests for the wait-queue being active
>  * will be guaranteed to see waitqueue addition _or_ subsequent
>  * tests in this thread will see the wakeup having taken place.
>  *
>  * The spin_unlock() itself is semi-permeable and only protects
>  * one way (it only protects stuff inside the critical region and
>  * stops them from bleeding out - it would still allow subsequent
>  * loads to move into the critical region).
>  */
>
> The first paragraph is saying that at that point full barrier (for
> both stores and loads) is necessary at that point and the second
> paragraph is a bit confusing but the last sentence seems to say that
> only loads after the unlock can creep above unlock,

Probably, this is because the comment tries to explain the possible
reordering with the subsequent "if (condition)" check, so it only
mentions loads.

> I think clearer explanation is in memory-barrier.txt.
>
>  (6) UNLOCK operations.
>
>      This also acts as a one-way permeable barrier.  It guarantees that all
>      memory operations before the UNLOCK operation will appear to happen before
>      the UNLOCK operation with respect to the other components of the system.
>
>      Memory operations that occur after an UNLOCK operation may appear to
>      happen before it completes.
>
>      LOCK and UNLOCK operations are guaranteed to appear with respect to each
>      other strictly in the order specified.
>
>      The use of LOCK and UNLOCK operations generally precludes the need for
>      other sorts of memory barrier (but note the exceptions mentioned in the
>      subsection "MMIO write barrier").
>
> So, in a nutshell, I think it's saying w.r.t. stores is that stores
> before unlock may not be deferred across the unlock but stores after
> unlock may creep upwards past unlock, so it acts as one-way write
> barrier.  And, yeah, that would be the minimal requirement for proper
> lock operation.  Curious whether any processor implements such fine
> grained barrier tho, maybe alpha does that too?
>
> Paul, David, am I understanding it correctly?
>
> Anyways, yeah, you're right.  We need a smp_wmb() before returning but
> I think the comment on top of prepare_to_wait() is misleading.

Hmm. I am not sure I understand... Although almost everything written
in English looks misleading to me ;)

I think that "Memory operations that occur after" above means both
loads and stores, so the comment is probably fine. set_current_state()
inserts the barrier between store and load:


	__add_wait_queue();

	mb();			// set_current_state()

	unlock();		// can't serialize with LOAD(condition) below

	if (!condition)
		schedule();

(let's forget about task->state to simplify)

> Great, thanks.  I'll wait a bit for futher comments and repost w/
> smp_wmb() added.

Well. This is almost off-topic, but perhaps we can add
smp_mb__after_unlock() ? We already have smp_mb__after_lock.
Afaics prepare_to_wait() could use it.

I am not talking about perfomance issues, just I think the code
will be more understandable.

Oleg.

