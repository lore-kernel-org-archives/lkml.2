Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab2KFUnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:43:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2KFUnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:43:17 -0500
Date: Tue, 6 Nov 2012 12:43:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
        Jianguo Wu <wujianguo@huawei.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: fix a regression with HIGHMEM introduced by
 changeset 7f1290f2f2a4d
Message-Id: <20121106124315.79deb2bc.akpm@linux-foundation.org>
In-Reply-To: <1352165517-9732-1-git-send-email-jiang.liu@huawei.com>
References: <1352165517-9732-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012 09:31:57 +0800
Jiang Liu <jiang.liu@huawei.com> wrote:

> Changeset 7f1290f2f2 tries to fix a issue when calculating
> zone->present_pages, but it causes a regression to 32bit systems with
> HIGHMEM. With that changeset, function reset_zone_present_pages()
> resets all zone->present_pages to zero, and fixup_zone_present_pages()
> is called to recalculate zone->present_pages when boot allocator frees
> core memory pages into buddy allocator. Because highmem pages are not
> freed by bootmem allocator, all highmem zones' present_pages becomes
> zero.
> 
> Actually there's no need to recalculate present_pages for highmem zone
> because bootmem allocator never allocates pages from them. So fix the
> regression by skipping highmem in function reset_zone_present_pages()
> and fixup_zone_present_pages().
> 
> ...
>
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6108,7 +6108,8 @@ void reset_zone_present_pages(void)
>  	for_each_node_state(nid, N_HIGH_MEMORY) {
>  		for (i = 0; i < MAX_NR_ZONES; i++) {
>  			z = NODE_DATA(nid)->node_zones + i;
> -			z->present_pages = 0;
> +			if (!is_highmem(z))
> +				z->present_pages = 0;
>  		}
>  	}
>  }
> @@ -6123,10 +6124,11 @@ void fixup_zone_present_pages(int nid, unsigned long start_pfn,
>  
>  	for (i = 0; i < MAX_NR_ZONES; i++) {
>  		z = NODE_DATA(nid)->node_zones + i;
> +		if (is_highmem(z))
> +			continue;
> +
>  		zone_start_pfn = z->zone_start_pfn;
>  		zone_end_pfn = zone_start_pfn + z->spanned_pages;
> -
> -		/* if the two regions intersect */
>  		if (!(zone_start_pfn >= end_pfn	|| zone_end_pfn <= start_pfn))
>  			z->present_pages += min(end_pfn, zone_end_pfn) -
>  					    max(start_pfn, zone_start_pfn);

This ...  isn't very nice.  It is embeds within
reset_zone_present_pages() and fixup_zone_present_pages() knowledge
about their caller's state.  Or, more specifically, it is emebedding
knowledge about the overall state of the system when these functions
are called.

I mean, a function called "reset_zone_present_pages" should reset
->present_pages!

The fact that fixup_zone_present_page() has multiple call sites makes
this all even more risky.  And what are the interactions between this
and memory hotplug?

Can we find a cleaner fix?

Please tell us more about what's happening here.  Is it the case that
reset_zone_present_pages() is being called *after* highmem has been
populated?  If so, then fixup_zone_present_pages() should work
correctly for highmem?  Or is it the case that highmem hasn't yet been
setup?  IOW, what is the sequence of operations here?

Is the problem that we're *missing* a call to
fixup_zone_present_pages(), perhaps?  If we call
fixup_zone_present_pages() after highmem has been populated,
fixup_zone_present_pages() should correctly fill in the highmem zone's
->present_pages?


