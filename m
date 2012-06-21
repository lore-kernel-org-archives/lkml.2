Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148Ab2FUT1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:27:33 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52566 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760044Ab2FUT1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:27:32 -0400
Message-ID: <4FE37434.808@linaro.org>
Date: Thu, 21 Jun 2012 12:21:24 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Pekka Enberg <penberg@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Hugh Dickins <hughd@google.com>
Subject: Re: RFC:  Easy-Reclaimable LRU list
References: <4FE012CD.6010605@kernel.org>
In-Reply-To: <4FE012CD.6010605@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062119-5518-0000-0000-00000565D551
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 10:49 PM, Minchan Kim wrote:
> Hi everybody!
>
> Recently, there are some efforts to handle system memory pressure.
>
> 1) low memory notification - [1]
> 2) fallocate(VOLATILE) - [2]
> 3) fadvise(NOREUSE) - [3]
>
> For them, I would like to add new LRU list, aka "Ereclaimable" which is opposite of "unevictable".
> Reclaimable LRU list includes _easy_ reclaimable pages.
> For example, easy reclaimable pages are following as.
>
> 1. invalidated but remained LRU list.
> 2. pageout pages for reclaim(PG_reclaim pages)
> 3. fadvise(NOREUSE)
> 4. fallocate(VOLATILE)
>
> Their pages shouldn't stir normal LRU list and compaction might not migrate them, even.
> Reclaimer can reclaim Ereclaimable pages before normal lru list and will avoid unnecessary
> swapout in anon pages in easy-reclaimable LRU list.

I was hoping there would be further comment on this by more core VM 
devs, but so far things have been quiet (is everyone on vacation?).

Overall this seems reasonable for the volatile ranges functionality.  
The one down-side being that dealing with the ranges on a per-page basis 
can make marking and unmarking larger ranges as volatile fairly 
expensive. In my tests with my last patchset, it was over 75x slower 
(~1.5ms) marking and umarking a 1meg range when we deactivate and 
activate all of the pages, instead of just inserting the volatile range 
into an interval tree and purge via the shrinker (~20us).  Granted, my 
initial approach is somewhat naive, and some pagevec batching has 
improved things three-fold (down to ~500us) , but I'm still ~25x slower 
when iterating over all the pages.

There's surely further improvements to be made, but this added cost 
worries me, as users are unlikely to generously volunteer up memory to 
the kernel as volatile if doing so frequently adds significant overhead.

This makes me wonder if having something like an early-shrinker which 
gets called prior to shrinking the lrus might be a better approach for 
volatile ranges. It would still be numa-unaware, but would keep the 
overhead very light to both volatile users and non users.

Even so, I'd be interested in seeing more about your approach, in the 
hopes that it might not be as costly as my initial attempt. Do you have 
any plans to start prototyping this?

thanks
-john

