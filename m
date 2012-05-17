Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab2EQAor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:44:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab2EQAop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:44:45 -0400
Date: Thu, 17 May 2012 02:44:34 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Pravin B Shelar <pshelar@nicira.com>
Cc: cl@linux.com, penberg@kernel.org, mpm@selenic.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jesse@nicira.com,
        abhide@nicira.com
Subject: Re: [PATCH 1/2] mm: Fix slab->page flags corruption.
Message-ID: <20120517004434.GX19697@redhat.com>
References: <1337020877-20087-1-git-send-email-pshelar@nicira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337020877-20087-1-git-send-email-pshelar@nicira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pravin,

On Mon, May 14, 2012 at 11:41:17AM -0700, Pravin B Shelar wrote:
> Transparent huge pages can change page->flags (PG_compound_lock)
> without taking Slab lock. Since THP can not break slab pages we can
> safely access compound page without taking compound lock.
> 
> Specificly this patch fixes race between compound_unlock and slab
> functions which does page-flags update. This can occur when
> get_page/put_page is called on page from slab object.

DMA on slab running put_page concurrently with kmem_cache_free/kfree
was unexpected. Is this the scenario where the race happens, right?

> diff --git a/mm/swap.c b/mm/swap.c
> index 8ff73d8..d4eb9f6 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -82,6 +82,16 @@ static void put_compound_page(struct page *page)
>  		if (likely(page != page_head &&
>  			   get_page_unless_zero(page_head))) {
>  			unsigned long flags;
> +
> +			if (PageSlab(page_head)) {
> +				/* THP can not break up slab pages, avoid
> +				 * taking compound_lock(). */
> +				if (put_page_testzero(page_head))
> +					VM_BUG_ON(1);
> +
> +				atomic_dec(&page->_mapcount);
> +				goto skip_lock;
> +			}

If a THP is splitted before get_page_unless_zero runs, the head page
may be then freed and reallocated as slab. The "page" then should not
be freed as a tail page anymore, because it's not a tail page. The
head just accidentally become a slab (maybe not even a compound slab).

To avoid such scenario this should be enough:

     if (PageSlab(page_head) && PageTail(page)) {
     ...
     }

Thanks,
Andrea
