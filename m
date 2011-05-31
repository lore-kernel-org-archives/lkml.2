Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab1EaNqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:46:16 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60676 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab1EaNqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:46:15 -0400
Date: Tue, 31 May 2011 15:46:09 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 06/10] vmscan: make isolate_lru_page with filter aware
Message-ID: <20110531134609.GB4594@cmpxchg.org>
References: <cover.1306689214.git.minchan.kim@gmail.com>
 <48bcb7597cd5695f30381715630dc66a5d32c638.1306689214.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48bcb7597cd5695f30381715630dc66a5d32c638.1306689214.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 03:13:45AM +0900, Minchan Kim wrote:
> In __zone_reclaim case, we don't want to shrink mapped page.
> Nonetheless, we have isolated mapped page and re-add it into
> LRU's head. It's unnecessary CPU overhead and makes LRU churning.
> 
> Of course, when we isolate the page, the page might be mapped but
> when we try to migrate the page, the page would be not mapped.
> So it could be migrated. But race is rare and although it happens,
> it's no big deal.
> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/vmscan.c |   29 +++++++++++++++++++++--------
>  1 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9972356..39941c7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1395,6 +1395,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
>  	unsigned long nr_taken;
>  	unsigned long nr_anon;
>  	unsigned long nr_file;
> +	enum ISOLATE_PAGE_MODE mode = ISOLATE_NONE;
>  
>  	while (unlikely(too_many_isolated(zone, file, sc))) {
>  		congestion_wait(BLK_RW_ASYNC, HZ/10);
> @@ -1406,13 +1407,20 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
>  
>  	set_reclaim_mode(priority, sc, false);
>  	lru_add_drain();
> +
> +	if (!sc->may_unmap)
> +		mode |= ISOLATE_UNMAPPED;
> +	if (!sc->may_writepage)
> +		mode |= ISOLATE_CLEAN;
> +	mode |= sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM ?
> +				ISOLATE_BOTH : ISOLATE_INACTIVE;

Hmm, it would probably be cleaner to fully convert the isolation mode
into independent flags.  INACTIVE, ACTIVE, BOTH is currently a
tri-state among flags, which is a bit ugly.

	mode = ISOLATE_INACTIVE;
	if (!sc->may_unmap)
		mode |= ISOLATE_UNMAPPED;
	if (!sc->may_writepage)
		mode |= ISOLATE_CLEAN;
	if (sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM)
		mode |= ISOLATE_ACTIVE;

What do you think?
