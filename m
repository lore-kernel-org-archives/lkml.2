Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1FBUWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 16:22:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43822 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab1FBUWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 16:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b3YwMxxrO3UAk0laMpz+rNyU9EVp7Dp+SBZwtt+PI3zfAfsseTqiDZ1rC+FEIpGkg2
         iGf1Gb9C3AGmd4BfA4rxM5iHIIrsWdzklJY/coyzreHP36MpF1GdaasKYV2cWnGWLXlb
         1WA2S/2va4/SFT0bmP4hyxdoFo7Nv1FSneAc4=
Date: Fri, 3 Jun 2011 05:21:56 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Mel Gorman <mel@csn.ul.ie>,
        akpm@linux-foundation.org, Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110602202156.GA23486@barrios-laptop>
References: <20110530153748.GS5044@csn.ul.ie>
 <20110530165546.GC5118@suse.de>
 <20110530175334.GI19505@random.random>
 <20110531121620.GA3490@barrios-laptop>
 <20110531122437.GJ19505@random.random>
 <20110531133340.GB3490@barrios-laptop>
 <20110531141402.GK19505@random.random>
 <20110531143734.GB13418@barrios-laptop>
 <20110531143830.GC13418@barrios-laptop>
 <20110602182302.GA2802@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602182302.GA2802@random.random>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 08:23:02PM +0200, Andrea Arcangeli wrote:
> On Tue, May 31, 2011 at 11:38:30PM +0900, Minchan Kim wrote:
> > > Yes. You find a new BUG.
> > > It seems to be related to this problem but it should be solved although
> > 
> >  typo : It doesn't seem to be.
> 
> This should fix it, but I doubt it matters for this problem.
> 
> ===
> Subject: mm: no page_count without a page pin
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> It's unsafe to run page_count during the physical pfn scan.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index faa0a08..e41e78a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1124,8 +1124,18 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>  					nr_lumpy_dirty++;
>  				scan++;
>  			} else {
> -				/* the page is freed already. */
> -				if (!page_count(cursor_page))
> +				/*
> +				 * We can't use page_count() as that
> +				 * requires compound_head and we don't
> +				 * have a pin on the page here. If a
> +				 * page is tail, we may or may not
> +				 * have isolated the head, so assume
> +				 * it's not free, it'd be tricky to

Isn't it rather aggressive?
I think cursor page is likely to be PageTail rather than PageHead.
Could we handle it simply with below code?

get_page(cursor_page)
/* The page is freed already */
if (1 == page_count(cursor_page)) {
	put_page(cursor_page)
	continue;
}
put_page(cursor_page);


> +				 * track the head status without a
> +				 * page pin.
> +				 */
> +				if (!PageTail(cursor_page) &&
> +				    !atomic_read(&cursor_page->_count))
>  					continue;
>  				break;

>  			}

-- 
Kind regards
Minchan Kim
