Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1D0IqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:46:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38160 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab1D0IqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:46:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Apr 2011 17:39:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC 8/8] compaction: make compaction use in-order putback
Message-Id: <20110427173922.4d65534b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <b7bcce639e9b9bf515431cda79b15d482f889ff2.1303833418.git.minchan.kim@gmail.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<b7bcce639e9b9bf515431cda79b15d482f889ff2.1303833418.git.minchan.kim@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 01:25:25 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Compaction is good solution to get contiguos page but it makes
> LRU churing which is not good.
> This patch makes that compaction code use in-order putback so
> after compaction completion, migrated pages are keeping LRU ordering.
> 
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/compaction.c |   22 +++++++++++++++-------
>  1 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index a2f6e96..480d2ac 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -211,11 +211,11 @@ static void isolate_freepages(struct zone *zone,
>  /* Update the number of anon and file isolated pages in the zone */
>  static void acct_isolated(struct zone *zone, struct compact_control *cc)
>  {
> -	struct page *page;
> +	struct pages_lru *pages_lru;
>  	unsigned int count[NR_LRU_LISTS] = { 0, };
>  
> -	list_for_each_entry(page, &cc->migratepages, lru) {
> -		int lru = page_lru_base_type(page);
> +	list_for_each_entry(pages_lru, &cc->migratepages, lru) {
> +		int lru = page_lru_base_type(pages_lru->page);
>  		count[lru]++;
>  	}
>  
> @@ -281,6 +281,7 @@ static unsigned long isolate_migratepages(struct zone *zone,
>  	spin_lock_irq(&zone->lru_lock);
>  	for (; low_pfn < end_pfn; low_pfn++) {
>  		struct page *page;
> +		struct pages_lru *pages_lru;
>  		bool locked = true;
>  
>  		/* give a chance to irqs before checking need_resched() */
> @@ -334,10 +335,16 @@ static unsigned long isolate_migratepages(struct zone *zone,
>  			continue;
>  		}
>  
> +		pages_lru = kmalloc(sizeof(struct pages_lru), GFP_ATOMIC);
> +		if (pages_lru)
> +			continue;

Hmm, can't we use fixed size of statically allocated pages_lru, per-node or
per-zone ? I think using kmalloc() in memory reclaim path is risky.

Thanks,
-Kame

