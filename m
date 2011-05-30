Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab1E3QOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 12:14:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60909 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156Ab1E3QOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 12:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fjGrAWZv9c8HBg03c/CocY4H00euw1aEV+w/RxrtjtbPz5x8GgFR8ENt7UQuisMft1
         2j5uRJfxX+16CLkVexH3WBYFZWZYQT68ydCRxcuGajStLenS/D9cK1NaJKWZKaK1gbzH
         f6Ooj2ba+kjUCLZJIbfEmVfr1ez9q4Yu+G2yo=
Date: Tue, 31 May 2011 01:14:15 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110530161415.GB2200@barrios-laptop>
References: <20110530131300.GQ5044@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530131300.GQ5044@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 02:13:00PM +0100, Mel Gorman wrote:
> Asynchronous compaction is used when promoting to huge pages. This is
> all very nice but if there are a number of processes in compacting
> memory, a large number of pages can be isolated. An "asynchronous"
> process can stall for long periods of time as a result with a user
> reporting that firefox can stall for 10s of seconds. This patch aborts
> asynchronous compaction if too many pages are isolated as it's better to
> fail a hugepage promotion than stall a process.
> 
> If accepted, this should also be considered for 2.6.39-stable. It should
> also be considered for 2.6.38-stable but ideally [11bc82d6: mm:
> compaction: Use async migration for __GFP_NO_KSWAPD and enforce no
> writeback] would be applied to 2.6.38 before consideration.
> 
> Reported-and-Tested-by: Ury Stankevich <urykhy@gmail.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

I have a nitpick below.
Otherwise, looks good to me.

> ---
>  mm/compaction.c |   32 ++++++++++++++++++++++++++------
>  1 files changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 021a296..331a2ee 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -240,11 +240,20 @@ static bool too_many_isolated(struct zone *zone)
>  	return isolated > (inactive + active) / 2;
>  }
>  
> +/* possible outcome of isolate_migratepages */
> +typedef enum {
> +	ISOLATE_ABORT,		/* Abort compaction now */
> +	ISOLATE_NONE,		/* No pages isolated, continue scanning */
> +	ISOLATE_SUCCESS,	/* Pages isolated, migrate */
> +} isolate_migrate_t;
> +
>  /*
>   * Isolate all pages that can be migrated from the block pointed to by
>   * the migrate scanner within compact_control.
> + *
> + * Returns false if compaction should abort at this point due to congestion.

false? I think it would be better to use explicit word, ISOLATE_ABORT.

-- 
Kind regards
Minchan Kim
