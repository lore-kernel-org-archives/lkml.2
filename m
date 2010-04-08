Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719Ab0DHVyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:54:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:57116 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933631Ab0DHVyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:54:32 -0400
Subject: Re: [PATCH 02/13] mm: Revalidate anon_vma in page_lock_anon_vma()
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100408142051.717b278c.akpm@linux-foundation.org>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.687144862@chello.nl>
	 <20100408142051.717b278c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 23:54:26 +0200
Message-ID: <1270763666.20295.3198.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 14:20 -0700, Andrew Morton wrote:
> On Thu, 08 Apr 2010 21:17:39 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > There is nothing preventing the anon_vma from being detached while we
> > are spinning to acquire the lock.
> 
> Well.  The comment there clearly implies (or states) that RCU
> protection is used to "guard against races".  If that's inaccurate
> or incomplete, can we please get it fixed?

Good point, goes together with that last comment you made.

> The whole function makes be a bit queasy.
> 
> - Fails to explain why it pulls all these party tricks to read
>   page->mapping a single time.  What code path are we defending against
>   here?

>From what I understand we race with tear-down, anon_vma_unlock() takes
anon_vma->lock, so holding the lock pins the anon_vma.

So what we do to acquire a stable anon_vma from a page * is to, while
holding RCU read lock, very carefully read page->mapping, extract the
anon_vma and acquire the lock.

Now, the RCU usage is a tad tricky here, anon_vma uses
SLAB_DESTROY_BY_RCU, which means that the slab will be RCU freed,
however not the objects allocated from it. This means that an anon_vma
can be re-used directly after its gets freed, but the storage will
remain valid for at least a grace period after the free.

So once we do have the lock we need to revalidate that we indeed got the
anon_vma we throught we got.

So its:

  page->mapping = NULL;
  anon_vma_unlink();
    spin_lock()
    spin_unlock()
    kmem_cache_free(anon_vma);

 VS

  page_lock_anon_vma()'s trickery.

> - Then checks page_mapped() without having any apparent defence
>   against page_mapped() becoming untrue one nanosecond later.
> 
> - Checks page_mapped() inside the rcu_read_locked() section for
>   inscrutable reasons.

Right, I think the page_mapped() stuff is just an early bail out.

