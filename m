Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0DIDQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 23:16:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab0DIDQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 23:16:47 -0400
Date: Fri, 9 Apr 2010 13:16:41 +1000
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
Subject: Re: [PATCH 02/13] mm: Revalidate anon_vma in page_lock_anon_vma()
Message-ID: <20100409031641.GG5683@laptop>
References: <20100408191737.296180458@chello.nl>
 <20100408192722.687144862@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408192722.687144862@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 09:17:39PM +0200, Peter Zijlstra wrote:
> There is nothing preventing the anon_vma from being detached while we
> are spinning to acquire the lock. Most (all?) current users end up
> calling something like vma_address(page, vma) on it, which has a
> fairly good chance of weeding out wonky vmas.
> 
> However suppose the anon_vma got freed and re-used while we were
> waiting to acquire the lock, and the new anon_vma fits with the
> page->index (because that is the only thing vma_address() uses to
> determine if the page fits in a particular vma, we could end up
> traversing faulty anon_vma chains.
> 
> Close this hole for good by re-validating that page->mapping still
> holds the very same anon_vma pointer after we acquire the lock, if not
> be utterly paranoid and retry the whole operation (which will very
> likely bail, because it's unlikely the page got attached to a different
> anon_vma in the meantime).

Hm, looks like a bugfix? How was this supposed to be safe?

 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  mm/rmap.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> Index: linux-2.6/mm/rmap.c
> ===================================================================
> --- linux-2.6.orig/mm/rmap.c
> +++ linux-2.6/mm/rmap.c
> @@ -294,6 +294,7 @@ struct anon_vma *page_lock_anon_vma(stru
>  	unsigned long anon_mapping;
>  
>  	rcu_read_lock();
> +again:
>  	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
>  	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
>  		goto out;
> @@ -302,6 +303,12 @@ struct anon_vma *page_lock_anon_vma(stru
>  
>  	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
>  	spin_lock(&anon_vma->lock);
> +
> +	if (page_rmapping(page) != anon_vma) {

very unlikely()?

> +		spin_unlock(&anon_vma->lock);
> +		goto again;
> +	}
> +
>  	return anon_vma;
>  out:
>  	rcu_read_unlock();
> 
