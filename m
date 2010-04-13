Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab0DMMAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 08:00:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39980 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab0DMMAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 08:00:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas of a mergeable VMA
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
In-Reply-To: <1271158226.4807.1107.camel@twins>
References: <20100413194443.D116.A69D9226@jp.fujitsu.com> <1271158226.4807.1107.camel@twins>
Message-Id: <20100413204149.D11C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 13 Apr 2010 21:00:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2010-04-13 at 19:53 +0900, KOSAKI Motohiro wrote:
> > >  struct anon_vma *page_lock_anon_vma(struct page *page)
> > >  {
> > > @@ -294,14 +309,24 @@ struct anon_vma *page_lock_anon_vma(struct page *page)
> > >  	unsigned long anon_mapping;
> > >  
> > >  	rcu_read_lock();
> > > -	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
> > > +	anon_mapping = (unsigned long)rcu_dereference(page->mapping);
> > >  	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
> > >  		goto out;
> > > -	if (!page_mapped(page))
> > > -		goto out;
> > >  
> > >  	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
> > >  	spin_lock(&anon_vma->lock);
> > 
> > Does anon->lock dereference is guranteed if page->_mapcount==-1?
> > It can be freed miliseconds ago, rcu_read_lock() doesn't provide such
> > gurantee.
> > 
> > perhaps, I'm missing your point.
> 
> No you're right, I got my head hopelessly twisted up trying to make
> page_lock_anon_vma() do something reliable, but there really isn't much
> that can be done.
> 
> Luckily most users (with exception of the memory-failure.c one) don't
> really care and all take steps to verify the page is indeed in any of
> the vmas it might find.
> 
> So I've given up on this and will only submit a patch like the below,
> which hopefully does still make sense...
> 
> I do think there's a missing barrier in there as well, but I've made
> enough of a fool of myself.
> 
> [ with the preemptible mmu_gather patches I introduce a refcount to
>   the anon_vma, and then with atomic_inc_not_zero() we can add a
>   guarantee that the returned anon_vma is alive ]

Indeed. refcount is best way. anon_vma DESTROY_BY_RCU stuff seems
overengineering, I think. this is fastest, but anon_vma allocation is not
(and was not) fork/exit bottleneck point. So, I guess most simply way is
best.


Also following patch looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thanks for that. I've thought this is really necessary. but my (very) poor
english skill make hesitate it to me. sorry my laziness ;)



> 
> ---
>  mm/rmap.c |   18 ++++++++++++++++--
>  1 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index eaa7a09..49a2533 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -285,8 +285,22 @@ void __init anon_vma_init(void)
>  }
>  
>  /*
> - * Getting a lock on a stable anon_vma from a page off the LRU is
> - * tricky: page_lock_anon_vma rely on RCU to guard against the races.
> + * Getting a lock on a stable anon_vma from a page off the LRU is tricky!
> + *
> + * Since there is no serialization what so ever against page_remove_rmap()
> + * the best this function can do is return a locked anon_vma that might
> + * have been relevant to this page.
> + *
> + * The page might have been remapped to a different anon_vma or the anon_vma
> + * returned may already be freed (and even reused).
> + *
> + * All users of this function must be very careful when walking the anon_vma
> + * chain and verify that the page in question is indeed mapped in it
> + * [ something equivalent to page_mapped_in_vma() ].
> + *
> + * Since anon_vma's slab is DESTROY_BY_RCU and we know from page_remove_rmap()
> + * that the anon_vma pointer from page->mapping is valid if there is a
> + * mapcount, we can dereference the anon_vma after observing those.
>   */
>  struct anon_vma *page_lock_anon_vma(struct page *page)
>  {
> 



