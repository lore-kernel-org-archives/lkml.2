Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab0DIDL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 23:11:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab0DIDL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 23:11:56 -0400
Date: Fri, 9 Apr 2010 13:11:40 +1000
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 01/13] powerpc: Add rcu_read_lock() to gup_fast()
 implementation
Message-ID: <20100409031140.GF5683@laptop>
References: <20100408191737.296180458@chello.nl>
 <20100408192722.643778654@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408192722.643778654@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not wrong per se, but the entire powerpc memory management code
does the IRQ disabling for its pagetable RCU code. So I think it would be
better to do the whole thing in one go.

I don't think Paul will surprise-break powerpc :)

It's up to Ben really, though.


On Thu, Apr 08, 2010 at 09:17:38PM +0200, Peter Zijlstra wrote:
> The powerpc page table freeing relies on the fact that IRQs hold off
> an RCU grace period, this is currently true for all existing RCU
> implementations but is not an assumption Paul wants to support.
> 
> Therefore, also take the RCU read lock along with disabling IRQs to
> ensure the RCU grace period does at least cover these lookups.
> 
> Requested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  arch/powerpc/mm/gup.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6/arch/powerpc/mm/gup.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/mm/gup.c
> +++ linux-2.6/arch/powerpc/mm/gup.c
> @@ -142,6 +142,7 @@ int get_user_pages_fast(unsigned long st
>  	 * So long as we atomically load page table pointers versus teardown,
>  	 * we can follow the address down to the the page and take a ref on it.
>  	 */
> +	rcu_read_lock();
>  	local_irq_disable();
>  
>  	pgdp = pgd_offset(mm, addr);
> @@ -162,6 +163,7 @@ int get_user_pages_fast(unsigned long st
>  	} while (pgdp++, addr = next, addr != end);
>  
>  	local_irq_enable();
> +	rcu_read_unlock();
>  
>  	VM_BUG_ON(nr != (end - start) >> PAGE_SHIFT);
>  	return nr;
> @@ -171,6 +173,7 @@ int get_user_pages_fast(unsigned long st
>  
>  slow:
>  		local_irq_enable();
> +		rcu_read_unlock();
>  slow_irqon:
>  		pr_devel("  slow path ! nr = %d\n", nr);
>  
> 
