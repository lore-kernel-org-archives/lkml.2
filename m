Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220Ab0KRQZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:25:51 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35563 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab0KRQZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:25:50 -0500
Date: Thu, 18 Nov 2010 16:25:36 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 56 of 66] transhuge isolate_migratepages()
Message-ID: <20101118162535.GF8135@csn.ul.ie>
References: <patchbomb.1288798055@v2.random> <deca9009a1afa678b7e0.1288798111@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <deca9009a1afa678b7e0.1288798111@v2.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 04:28:31PM +0100, Andrea Arcangeli wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> It's not worth migrating transparent hugepages during compaction. Those
> hugepages don't create fragmentation.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

I think this will collide with my compaction series because of the "fast
scanning" patch but the resolution should be trivial. Your check still should
go in after the PageLRU check and the PageTransCompound check should still
be after __isolate_lru_page.

> ---
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -272,10 +272,25 @@ static unsigned long isolate_migratepage
>  		if (PageBuddy(page))
>  			continue;
>  
> +		if (!PageLRU(page))
> +			continue;
> +
> +		/*
> +		 * PageLRU is set, and lru_lock excludes isolation,
> +		 * splitting and collapsing (collapsing has already
> +		 * happened if PageLRU is set).
> +		 */
> +		if (PageTransHuge(page)) {
> +			low_pfn += (1 << compound_order(page)) - 1;
> +			continue;
> +		}
> +
>  		/* Try isolate the page */
>  		if (__isolate_lru_page(page, ISOLATE_BOTH, 0) != 0)
>  			continue;
>  
> +		VM_BUG_ON(PageTransCompound(page));
> +
>  		/* Successfully isolated */
>  		del_page_from_lru_list(zone, page, page_lru(page));
>  		list_add(&page->lru, migratelist);
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
