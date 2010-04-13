Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab0DMDnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 23:43:17 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35545 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab0DMDnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 23:43:15 -0400
Date: Mon, 12 Apr 2010 20:43:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 01/13] powerpc: Add rcu_read_lock() to gup_fast()
 implementation
Message-ID: <20100413034311.GB2772@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100408191737.296180458@chello.nl>
 <20100408192722.643778654@chello.nl>
 <1271120731.13059.6.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271120731.13059.6.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 11:05:31AM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2010-04-08 at 21:17 +0200, Peter Zijlstra wrote:
> > plain text document attachment (powerpc-gup_fast-rcu.patch)
> > The powerpc page table freeing relies on the fact that IRQs hold off
> > an RCU grace period, this is currently true for all existing RCU
> > implementations but is not an assumption Paul wants to support.
> > 
> > Therefore, also take the RCU read lock along with disabling IRQs to
> > ensure the RCU grace period does at least cover these lookups.
> 
> There's a few other places that need a similar fix then. The hash page
> code for example. All the C cases should end up calling the
> find_linux_pte() helper afaik, so we should be able to stick the lock in
> there (and the hugetlbfs variant, find_linux_pte_or_hugepte()).
> 
> However, we also have cases of tight asm code walking the page tables,
> such as the tlb miss handler on embedded processors. I don't see how I
> could do that there. IE. I only have a handful of registers to play
> with, no stack, etc...
> 
> So we might have to support the interrupt assumption, at least in some
> form, with those guys...

One way to make the interrupt assumption official is to use
synchronize_sched() rather than synchronize_rcu().

							Thanx, Paul

> Cheers,
> Ben. 
> 
> > Requested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Nick Piggin <npiggin@suse.de>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > ---
> >  arch/powerpc/mm/gup.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > Index: linux-2.6/arch/powerpc/mm/gup.c
> > ===================================================================
> > --- linux-2.6.orig/arch/powerpc/mm/gup.c
> > +++ linux-2.6/arch/powerpc/mm/gup.c
> > @@ -142,6 +142,7 @@ int get_user_pages_fast(unsigned long st
> >  	 * So long as we atomically load page table pointers versus teardown,
> >  	 * we can follow the address down to the the page and take a ref on it.
> >  	 */
> > +	rcu_read_lock();
> >  	local_irq_disable();
> >  
> >  	pgdp = pgd_offset(mm, addr);
> > @@ -162,6 +163,7 @@ int get_user_pages_fast(unsigned long st
> >  	} while (pgdp++, addr = next, addr != end);
> >  
> >  	local_irq_enable();
> > +	rcu_read_unlock();
> >  
> >  	VM_BUG_ON(nr != (end - start) >> PAGE_SHIFT);
> >  	return nr;
> > @@ -171,6 +173,7 @@ int get_user_pages_fast(unsigned long st
> >  
> >  slow:
> >  		local_irq_enable();
> > +		rcu_read_unlock();
> >  slow_irqon:
> >  		pr_devel("  slow path ! nr = %d\n", nr);
> >  
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
