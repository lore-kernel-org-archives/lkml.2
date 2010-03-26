Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0CZBCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:02:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60180 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0CZBCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:02:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Mar 2010 09:58:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped
 anonymous pages
Message-Id: <20100326095825.69fd63a9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1269530941.1814.21.camel@barrios-desktop>
References: <20100325092131.GK2024@csn.ul.ie>
	<20100325184123.e3e3b009.kamezawa.hiroyu@jp.fujitsu.com>
	<20100325185200.6C8C.A69D9226@jp.fujitsu.com>
	<20100325191229.8e3d2ba1.kamezawa.hiroyu@jp.fujitsu.com>
	<1269530941.1814.21.camel@barrios-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010 00:29:01 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Hi, Kame. 
<snip>

> Which case do we have PageAnon && (page_mapcount == 0) && PageSwapCache ?
> With looking over code which add_to_swap_cache, I found somewhere. 
> 
> 1) shrink_page_list
> I think this case doesn't matter by isolate_lru_xxx.
> 
> 2) shmem_swapin
> It seems to be !PageAnon
> 
> 3) shmem_writepage
> It seems to be !PageAnon. 
> 
> 4) do_swap_page
> page_add_anon_rmap increases _mapcount before setting page->mapping to anon_vma. 
> So It doesn't matter. 

> 
> 
> I think following codes in unmap_and_move seems to handle 3) case. 
> 
> ---
>          * Corner case handling:
>          * 1. When a new swap-cache page is read into, it is added to the LRU
>          * and treated as swapcache but it has no rmap yet.
>         ...
>         if (!page->mapping) {
>                 if (!PageAnon(page) && page_has_private(page)) {
>                 ....
>                 }    
>                 goto skip_unmap;
>         }    
> 
> ---
> 
> Do we really check PageSwapCache in there?
> Do I miss any case?
> 

When a page is fully unmapped, page->mapping is not cleared.

from rmap.c
==
 734 void page_remove_rmap(struct page *page)
 735 {
	....
 758         /*
 759          * It would be tidy to reset the PageAnon mapping here,
 760          * but that might overwrite a racing page_add_anon_rmap
 761          * which increments mapcount after us but sets mapping
 762          * before us: so leave the reset to free_hot_cold_page,
 763          * and remember that it's only reliable while mapped.
 764          * Leaving it set also helps swapoff to reinstate ptes
 765          * faster for those pages still in swapcache.
 766          */
 767 }
==

What happens at memory reclaim is...

	the first vmscan
	1. isolate a page from LRU.
	2. add_to_swap_cache it.
	3. try_to_unmap it
	4. pageout it (PG_reclaim && PG_writeback)
	5. move page to the tail of LRU.
	.....<after some time>
	6. I/O ends and PG_writeback is cleared.

Here, in above cycle, the page is not freed. Still in LRU list.
	next vmscan
	7. isolate a page from LRU.
	8. finds a unmapped clean SwapCache
	9. drop it.

So, to _free_ unmapped SwapCache, sequence 7-9 should happen.
If enough memory is freed by the first itelation of vmscan before I/O end,
next vmscan doesn't happen. Then, we have "unmmaped clean Swapcache which has
anon_vma pointer on page->mapping" on LRU.

Thanks,
-Kame


	



	


