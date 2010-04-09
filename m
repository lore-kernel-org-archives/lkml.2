Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0DIM5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 08:57:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab0DIM5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 08:57:38 -0400
Subject: Re: [PATCH 02/13] mm: Revalidate anon_vma in page_lock_anon_vma()
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100408192722.687144862@chello.nl>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.687144862@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 14:57:34 +0200
Message-ID: <1270817854.20295.3356.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 21:17 +0200, Peter Zijlstra wrote:

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
> +		spin_unlock(&anon_vma->lock);
> +		goto again;
> +	}
> +
>  	return anon_vma;
>  out:
>  	rcu_read_unlock();



OK, so I'm not quite sure about this anymore... this locking is quite,..
umh,. interesting.

We have:

 - page_remove_rmap() - which decrements page->_mapcount but does not
clear page->mapping. Even though both it and page_add_anon_rmap()
require pte_lock, there is no guarantee these are the same locks, so
these can indeed race.

So there is indeed a possibility for page->mapping to change, but
holding anon_vma->lock won't make a difference.

 - anon_vma->lock - this does protect vma_anon_link/unlink like things
and is held during rmap walks, it only protects the list.

 - SLAB_DESTROY_BY_RCU - only guarantees we can deref anon_vma, not that
we'll find the one we were looking for.

 - we generally unmap/zap before unlink/free - so this should not see
pages race with anon_vma freeing (except when someone has a page ref),
however on anon_vma merges we seem to simply unlink the next one,
without updating potential pages referencing it?

 - KSM seems to not do anything that swap doesn't also do (but I didn't
look too closely).

 - page migration seems terribly broken..


As it stands I don't see a reliable way to obtain an anon_vma,
vma_address() + page_check_address() things are indeed enough, but not
everybody seems to do that.

