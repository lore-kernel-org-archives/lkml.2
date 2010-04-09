Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab0DIIfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 04:35:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:38009 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab0DIIff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 04:35:35 -0400
Subject: Re: [PATCH 13/13] mm: Optimize page_lock_anon_vma
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100408221817.GE2520@linux.vnet.ibm.com>
References: <20100408191737.296180458@chello.nl>
	 <20100408192723.158842551@chello.nl>
	 <20100408221817.GE2520@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 10:35:29 +0200
Message-ID: <1270802129.20295.3269.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 15:18 -0700, Paul E. McKenney wrote:
> On Thu, Apr 08, 2010 at 09:17:50PM +0200, Peter Zijlstra wrote:
> > Optimize page_lock_anon_vma() by removing the atomic ref count
> > ops from the fast path.
> > 
> > Rather complicates the code a lot, but might be worth it.
> 
> Some questions and a disclaimer below.
> 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  mm/rmap.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 67 insertions(+), 4 deletions(-)
> > 
> > Index: linux-2.6/mm/rmap.c
> > ===================================================================
> > --- linux-2.6.orig/mm/rmap.c
> > +++ linux-2.6/mm/rmap.c
> > @@ -78,6 +78,12 @@ static inline struct anon_vma *anon_vma_
> >  void anon_vma_free(struct anon_vma *anon_vma)
> >  {
> >  	VM_BUG_ON(atomic_read(&anon_vma->ref));
> > +	/*
> > +	 * Sync against the anon_vma->lock, so that we can hold the
> > +	 * lock without requiring a reference. See page_lock_anon_vma().
> > +	 */
> > +	mutex_lock(&anon_vma->lock);
> 
> On some systems, the CPU is permitted to pull references into the critical
> section from either side.  So, do we also need an smp_mb() here?
> 
> > +	mutex_unlock(&anon_vma->lock);
> 
> So, a question...
> 
> Can the above mutex be contended?  If yes, what happens when the
> competing mutex_lock() acquires the lock at this point?  Or, worse yet,
> after the kmem_cache_free()?
> 
> If no, what do we accomplish by acquiring the lock?

The thing we gain is that when the holder of the lock finds a !0
refcount it knows it can't go away because any free will first wait to
acquire the lock.

> If the above mutex can be contended, can we fix by substituting
> synchronize_rcu_expedited()?  Which will soon require some scalability
> attention if it gets used here, but what else is new?  ;-)

No, synchronize_rcu_expedited() will not work here, there is no RCU read
side that covers the full usage of the anon_vma (there can't be, it
needs to sleep).

> >  	kmem_cache_free(anon_vma_cachep, anon_vma);
> >  }
> > 
> > @@ -291,7 +297,7 @@ void __init anon_vma_init(void)
> > 
> >  /*
> >   * Getting a lock on a stable anon_vma from a page off the LRU is
> > - * tricky: page_lock_anon_vma relies on RCU to guard against the races.
> > + * tricky: anon_vma_get relies on RCU to guard against the races.
> >   */
> >  struct anon_vma *anon_vma_get(struct page *page)
> >  {
> > @@ -320,12 +326,70 @@ out:
> >  	return anon_vma;
> >  }
> > 
> > +/*
> > + * Similar to anon_vma_get(), however it relies on the anon_vma->lock
> > + * to pin the object. However since we cannot wait for the mutex
> > + * acquisition inside the RCU read lock, we use the ref count
> > + * in the slow path.
> > + */
> >  struct anon_vma *page_lock_anon_vma(struct page *page)
> >  {
> > -	struct anon_vma *anon_vma = anon_vma_get(page);
> > +	struct anon_vma *anon_vma = NULL;
> > +	unsigned long anon_mapping;
> > +
> > +again:
> > +	rcu_read_lock();
> 
> This is interesting.  You have an RCU read-side critical section with
> no rcu_dereference().
> 
> This strange state of affairs is actually legal (assuming that
> anon_mapping is the RCU-protected structure) because all dereferences
> of the anon_vma variable are atomic operations that guarantee ordering
> (the mutex_trylock() and the atomic_inc_not_zero().
> 
> The other dereferences (the atomic_read()s) are under the lock, so
> are also OK assuming that the lock is held when initializing and
> updating these fields, and even more OK due to the smp_rmb() below.
> 
> But see below.


Right so the only thing rcu_read_lock() does here is create the
guarantee that anon_vma is safe to dereference (it lives on a
SLAB_DESTROY_BY_RCU slab).

But yes, I suppose that page->mapping read that now uses ACCESS_ONCE()
would actually want to be an rcu_dereference(), since that both provides
the ACCESS_ONCE() as the read-depend barrier that I thing would be
needed.

> > +	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
> > +	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
> > +		goto unlock;
> > +	if (!page_mapped(page))
> > +		goto unlock;
> > +
> > +	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
> > +	if (!mutex_trylock(&anon_vma->lock)) {
> > +		/*
> > +		 * We failed to acquire the lock, take a ref so we can
> > +		 * drop the RCU read lock and sleep on it.
> > +		 */
> > +		if (!atomic_inc_not_zero(&anon_vma->ref)) {
> > +			/*
> > +			 * Failed to get a ref, we're dead, bail.
> > +			 */
> > +			anon_vma = NULL;
> > +			goto unlock;
> > +		}
> > +		rcu_read_unlock();
> > 
> > -	if (anon_vma)
> >  		mutex_lock(&anon_vma->lock);
> > +		/*
> > +		 * We got the lock, drop the temp. ref, if it was the last
> > +		 * one free it and bail.
> > +		 */
> > +		if (atomic_dec_and_test(&anon_vma->ref)) {
> > +			mutex_unlock(&anon_vma->lock);
> > +			anon_vma_free(anon_vma);
> > +			anon_vma = NULL;
> > +		}
> > +		goto out;
> > +	}
> > +	/*
> > +	 * Got the lock, check we're still alive. Seeing a ref
> > +	 * here guarantees the object will stay alive due to
> > +	 * anon_vma_free() syncing against the lock we now hold.
> > +	 */
> > +	smp_rmb(); /* Order against anon_vma_put() */
> 
> This is ordering the fetch into anon_vma against the atomic_read() below?
> If so, smp_read_barrier_depends() will cover it more cheaply.  Alternatively,
> use rcu_dereference() when fetching into anon_vma.
> 
> Or am I misunderstanding the purpose of this barrier?

Yes, it is:

  atomic_dec_and_test(&anon_vma->ref) /* implies mb */

				smp_rmb();
				atomic_read(&anon_vma->ref);

> (Disclaimer: I have not yet found anon_vma_put(), so I am assuming that
> anon_vma_free() plays the role of a grace period.)

Yes, that lives in one of the other patches (does not exist in
mainline).


