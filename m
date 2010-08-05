Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636Ab0HEPk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:40:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45468 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933365Ab0HEPky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mv1LwoQfa0PUGZpd33XKCcG+vl+9b3lxtkFXNOJfHumOHTDTaAhSG6meicAejU6iTi
         zGmdzEBdWGHGmHAASf3u/qJ+MCxBmXBVhuadurGD+MJ9Yd5EXb40EOaG1KFgt01uCeAy
         XN/TteF7qLWdsSMm47QjX5UM/5zeV6dzwvYDA=
Date: Fri, 6 Aug 2010 00:40:45 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 7/7] vmscan: isolated_lru_pages() stop neighbor search
 if neighbor can't be isolated
Message-ID: <20100805154045.GE2985@barrios-desktop>
References: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
 <20100805151525.31CC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805151525.31CC.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 03:16:06PM +0900, KOSAKI Motohiro wrote:
> isolate_lru_pages() doesn't only isolate LRU tail pages, but also
> isolate neighbor pages of the eviction page.
> 
> Now, the neighbor search don't stop even if neighbors can't be isolated.
> It is silly. successful higher order allocation need full contenious
> memory, even though only one page reclaim failure mean to fail making
> enough contenious memory.
> 
> Then, isolate_lru_pages() should stop to search PFN neighbor pages and
> try to search next page on LRU soon. This patch does it. Also all of
> lumpy reclaim failure account nr_lumpy_failed.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

I agree this patch. 
But I have a one question. 

> ---
>  mm/vmscan.c |   24 ++++++++++++++++--------
>  1 files changed, 16 insertions(+), 8 deletions(-)
> 
<snip>

  
>  			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
>  				list_move(&cursor_page->lru, dst);
> @@ -1074,9 +1080,11 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>  					nr_lumpy_dirty++;
>  				scan++;
>  			} else {
> -				if (mode == ISOLATE_BOTH &&
> -						page_count(cursor_page))
> -					nr_lumpy_failed++;

sc->order = 1;
shrink_inactive_list;
isolate_pages_global with ISOLATE_INACTIVE(I mean no lumpy relcaim mode);
lumpy relcaim in inactive list in isolate_lru_pages;
(But I am not sure we can call it as lumpy reclaim. but at lesat I think 
it a part of lumpy reclaim)
I mean it can reclaim physical pfn order not LRU order in inactive list since
it only consider sc->order.  Is it a intentional?

I guess it's intentional since we care of ISOLATE_BOTH when we increase nr_lumpy_failed. 
If it is, Shouldn't we care of ISOLATE_BOTH still?


> +				/* the page is freed already. */
> +				if (!page_count(cursor_page))
> +					continue;
> +				nr_lumpy_failed++;
> +				break;
>  			}
>  		}
>  	}
> -- 
> 1.6.5.2
> 


-- 
Kind regards,
Minchan Kim
