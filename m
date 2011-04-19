Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1DSUIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:08:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795Ab1DSUIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:08:17 -0400
Date: Tue, 19 Apr 2011 13:06:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Tony Luck <tony.luck@intel.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 01/20] mm: mmu_gather rework
Message-Id: <20110419130606.fb7139b2.akpm@linux-foundation.org>
In-Reply-To: <20110401121725.360704327@chello.nl>
References: <20110401121258.211963744@chello.nl>
	<20110401121725.360704327@chello.nl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Apr 2011 14:12:59 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Remove the first obstackle towards a fully preemptible mmu_gather.
> 
> The current scheme assumes mmu_gather is always done with preemption
> disabled and uses per-cpu storage for the page batches. Change this to
> try and allocate a page for batching and in case of failure, use a
> small on-stack array to make some progress.
> 
> Preemptible mmu_gather is desired in general and usable once
> i_mmap_lock becomes a mutex. Doing it before the mutex conversion
> saves us from having to rework the code by moving the mmu_gather
> bits inside the pte_lock.
> 
> Also avoid flushing the tlb batches from under the pte lock,
> this is useful even without the i_mmap_lock conversion as it
> significantly reduces pte lock hold times.

There doesn't seem much point in reviewing this closely, as a lot of it
gets tossed away later in the series..

>  		free_pages_and_swap_cache(tlb->pages, tlb->nr);

It seems inappropriate that this code uses
free_page[s]_and_swap_cache().  It should go direct to put_page() and
release_pages()?  Please review this code's implicit decision to pass
"cold==0" into release_pages().

> -static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
> +static inline int __tlb_remove_page(struct mmu_gather *tlb, struct page *page)

I wonder if all the inlining which remains in this code is needed and
desirable.

