Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab1DZGun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:50:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42910 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab1DZGul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:50:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: readahead and oom
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Young <hidave.darkstar@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
In-Reply-To: <20110426063421.GC19717@localhost>
References: <BANLkTinM9DjK9QsGtN0Sh308rr+86UMF0A@mail.gmail.com> <20110426063421.GC19717@localhost>
Message-Id: <20110426155258.F38F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 26 Apr 2011 15:50:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > btw readahead page allocations are completely optional. They are OK to
> > > fail and in theory shall not trigger OOM on themselves. We may
> > > consider passing __GFP_NORETRY for readahead page allocations.
> > 
> > Good idea, care to submit a patch?
> 
> Here it is :)
> 
> Thanks,
> Fengguang
> ---
> readahead: readahead page allocations is OK to fail
> 
> Pass __GFP_NORETRY for readahead page allocations.
> 
> readahead page allocations are completely optional. They are OK to
> fail and in particular shall not trigger OOM on themselves.
> 
> Reported-by: Dave Young <hidave.darkstar@gmail.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  include/linux/pagemap.h |    5 +++++
>  mm/readahead.c          |    2 +-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> --- linux-next.orig/include/linux/pagemap.h	2011-04-26 14:27:46.000000000 +0800
> +++ linux-next/include/linux/pagemap.h	2011-04-26 14:29:31.000000000 +0800
> @@ -219,6 +219,11 @@ static inline struct page *page_cache_al
>  	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD);
>  }
>  
> +static inline struct page *page_cache_alloc_cold_noretry(struct address_space *x)
> +{
> +	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD|__GFP_NORETRY);
> +}
> +
>  typedef int filler_t(void *, struct page *);
>  
>  extern struct page * find_get_page(struct address_space *mapping,
> --- linux-next.orig/mm/readahead.c	2011-04-26 14:27:02.000000000 +0800
> +++ linux-next/mm/readahead.c	2011-04-26 14:27:24.000000000 +0800
> @@ -180,7 +180,7 @@ __do_page_cache_readahead(struct address
>  		if (page)
>  			continue;
>  
> -		page = page_cache_alloc_cold(mapping);
> +		page = page_cache_alloc_cold_noretry(mapping);
>  		if (!page)
>  			break;
>  		page->index = page_offset;

I like this patch.

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



