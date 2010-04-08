Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055Ab0DHVWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:22:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759024Ab0DHVWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:22:00 -0400
Date: Thu, 8 Apr 2010 14:20:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 02/13] mm: Revalidate anon_vma in page_lock_anon_vma()
Message-Id: <20100408142051.717b278c.akpm@linux-foundation.org>
In-Reply-To: <20100408192722.687144862@chello.nl>
References: <20100408191737.296180458@chello.nl>
	<20100408192722.687144862@chello.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Apr 2010 21:17:39 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> There is nothing preventing the anon_vma from being detached while we
> are spinning to acquire the lock.

Well.  The comment there clearly implies (or states) that RCU
protection is used to "guard against races".  If that's inaccurate
or incomplete, can we please get it fixed?


The whole function makes be a bit queasy.

- Fails to explain why it pulls all these party tricks to read
  page->mapping a single time.  What code path are we defending against
  here?

- Then checks page_mapped() without having any apparent defence
  against page_mapped() becoming untrue one nanosecond later.

- Checks page_mapped() inside the rcu_read_locked() section for
  inscrutable reasons.

> Most (all?) current users end up
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
> 
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
> +		spin_unlock(&anon_vma->lock);
> +		goto again;
> +	}
> +
>  	return anon_vma;
>  out:
>  	rcu_read_unlock();
> 

A comment here explaining how this situation could come about would
be helpful.

