Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1F1Vty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:49:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154Ab1F1Vtu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:49:50 -0400
Date: Tue, 28 Jun 2011 14:49:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: =?ISO-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andrew Lutomirski <luto@mit.edu>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] mm: vmscan: Correct check for kswapd sleeping in
 sleeping_prematurely
Message-Id: <20110628144900.b33412c6.akpm@linux-foundation.org>
In-Reply-To: <1308926697-22475-2-git-send-email-mgorman@suse.de>
References: <1308926697-22475-1-git-send-email-mgorman@suse.de>
	<1308926697-22475-2-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011 15:44:54 +0100
Mel Gorman <mgorman@suse.de> wrote:

> During allocator-intensive workloads, kswapd will be woken frequently
> causing free memory to oscillate between the high and min watermark.
> This is expected behaviour.
> 
> A problem occurs if the highest zone is small.  balance_pgdat()
> only considers unreclaimable zones when priority is DEF_PRIORITY
> but sleeping_prematurely considers all zones. It's possible for this
> sequence to occur
> 
>   1. kswapd wakes up and enters balance_pgdat()
>   2. At DEF_PRIORITY, marks highest zone unreclaimable
>   3. At DEF_PRIORITY-1, ignores highest zone setting end_zone
>   4. At DEF_PRIORITY-1, calls shrink_slab freeing memory from
>         highest zone, clearing all_unreclaimable. Highest zone
>         is still unbalanced
>   5. kswapd returns and calls sleeping_prematurely
>   6. sleeping_prematurely looks at *all* zones, not just the ones
>      being considered by balance_pgdat. The highest small zone
>      has all_unreclaimable cleared but but the zone is not
>      balanced. all_zones_ok is false so kswapd stays awake
> 
> This patch corrects the behaviour of sleeping_prematurely to check
> the zones balance_pgdat() checked.

But kswapd is making progress: it's reclaiming slab.  Eventually that
won't work any more and all_unreclaimable will not be cleared and the
condition will fix itself up?



btw,

	if (!sleeping_prematurely(...))
		sleep();

hurts my brain.  My brain would prefer

	if (kswapd_should_sleep(...))
		sleep();

no?

> Reported-and-tested-by: Pádraig Brady <P@draigBrady.com>

But what were the before-and-after observations?  I don't understand
how this can cause a permanent cpuchew by kswapd.

> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2323,7 +2323,7 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
>  		return true;
>  
>  	/* Check the watermark levels */
> -	for (i = 0; i < pgdat->nr_zones; i++) {
> +	for (i = 0; i <= classzone_idx; i++) {
>  		struct zone *zone = pgdat->node_zones + i;
>  
>  		if (!populated_zone(zone))

The patch looks sensible.
