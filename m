Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1FDH7g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 03:59:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54706 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab1FDH7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 03:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G4dB58CKoVCdnZBqJERmXcMaKoatNqIzPclPHAGI65RmbMPjDua1F1vBX6AjYDEP9v
         XhD4wogmR3/Ny/N/o7svJiFHubtUzEK3iQ9va4er5CNxBhiTBfnIz76C+VgqCYqtkTxD
         d0neN6sRdScRtScdTOxuy8WL0cApy7XuH0YWE=
Date: Sat, 4 Jun 2011 16:59:26 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Mel Gorman <mel@csn.ul.ie>,
        akpm@linux-foundation.org, Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110604075926.GC4114@barrios-laptop>
References: <20110531143734.GB13418@barrios-laptop>
 <20110531143830.GC13418@barrios-laptop>
 <20110602182302.GA2802@random.random>
 <20110602202156.GA23486@barrios-laptop>
 <20110602214041.GF2802@random.random>
 <BANLkTim1WjdHWOQp7bMg5pFFKp1SSFoLKw@mail.gmail.com>
 <20110602223201.GH2802@random.random>
 <BANLkTikA+ugFNS95Zs_o6QqG2u4r2g93=Q@mail.gmail.com>
 <20110603173707.GL2802@random.random>
 <20110603180730.GM2802@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110603180730.GM2802@random.random>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 08:07:30PM +0200, Andrea Arcangeli wrote:
> On Fri, Jun 03, 2011 at 07:37:07PM +0200, Andrea Arcangeli wrote:
> > On Fri, Jun 03, 2011 at 08:01:44AM +0900, Minchan Kim wrote:
> > > Do you want this? (it's almost pseudo-code)
> > 
> > Yes that's good idea so we at least take into account if we isolated
> > something big, and it's pointless to insist wasting CPU on the tail
> > pages and even trace a fail because of tail pages after it.
> > 
> > I introduced a __page_count to increase readability. It's still
> > hackish to work on subpages in vmscan.c but at least I added a comment
> > and until we serialize destroy_compound_page vs compound_head, I guess
> > there's no better way. I didn't attempt to add out of order
> > serialization similar to what exists for split_huge_page vs
> > compound_trans_head yet, as the page can be allocated or go away from
> > under us, in split_huge_page vs compound_trans_head it's simpler
> > because both callers are required to hold a pin on the page so the
> > page can't go be reallocated and destroyed under it.
> 
> Sent too fast... had to shuffle a few things around... trying again.
> 
> ===
> Subject: mm: no page_count without a page pin
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> It's unsafe to run page_count during the physical pfn scan because
> compound_head could trip on a dangling pointer when reading page->first_page if
> the compound page is being freed by another CPU. Also properly take into
> account if we isolated a compound page during the scan and break the loop if
> we've isolated enoguh. Introduce __page_count to cleanup some atomic_read from
> &page->_count in common code to cleanup.
> 

Patch looks good to me.
I have a question. Please see bottom line.

In addition, I think this patch have to be divided by 4 patches.

1. fix accounting nu_lumpy_taken, nr_lumpy_dirty on hpage
2. early breaking of isolate_lru_pages if we had enough isolated pages
3. introduce __page_count and cleanup
4. fix page_count usage of subpage in vmscan.c

> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/powerpc/mm/gup.c                        |    2 -
>  arch/powerpc/platforms/512x/mpc512x_shared.c |    2 -
>  arch/x86/mm/gup.c                            |    2 -
>  fs/nilfs2/page.c                             |    2 -
>  include/linux/mm.h                           |   13 ++++++----
>  mm/huge_memory.c                             |    4 +--
>  mm/internal.h                                |    2 -
>  mm/page_alloc.c                              |    6 ++--
>  mm/swap.c                                    |    4 +--
>  mm/vmscan.c                                  |   35 ++++++++++++++++++++-------
>  10 files changed, 47 insertions(+), 25 deletions(-)
> 
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1047,7 +1047,7 @@ static unsigned long isolate_lru_pages(u
>  	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
>  		struct page *page;
>  		unsigned long pfn;
> -		unsigned long end_pfn;
> +		unsigned long start_pfn, end_pfn;
>  		unsigned long page_pfn;
>  		int zone_id;
>  
> @@ -1087,9 +1087,9 @@ static unsigned long isolate_lru_pages(u
>  		 */
>  		zone_id = page_zone_id(page);
>  		page_pfn = page_to_pfn(page);
> -		pfn = page_pfn & ~((1 << order) - 1);
> -		end_pfn = pfn + (1 << order);
> -		for (; pfn < end_pfn; pfn++) {
> +		start_pfn = page_pfn & ~((1 << order) - 1);
> +		end_pfn = start_pfn + (1 << order);
> +		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
>  			struct page *cursor_page;
>  
>  			/* The target page is in the block, ignore it. */
> @@ -1116,16 +1116,33 @@ static unsigned long isolate_lru_pages(u
>  				break;
>  
>  			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
> +				unsigned int isolated_pages;
>  				list_move(&cursor_page->lru, dst);
>  				mem_cgroup_del_lru(cursor_page);
> -				nr_taken += hpage_nr_pages(page);
> -				nr_lumpy_taken++;
> +				isolated_pages = hpage_nr_pages(page);
> +				nr_taken += isolated_pages;
> +				nr_lumpy_taken += isolated_pages;
>  				if (PageDirty(cursor_page))
> -					nr_lumpy_dirty++;
> +					nr_lumpy_dirty += isolated_pages;
>  				scan++;
> +				pfn += isolated_pages-1;
> +				VM_BUG_ON(!isolated_pages);
> +				VM_BUG_ON(isolated_pages > MAX_ORDER_NR_PAGES);

What's point of this VM_BUG_ONs?
Could you explain what you expect with this VM_BUG_ONs?

-- 
Kind regards
Minchan Kim
