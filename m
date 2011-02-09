Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1BIUif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:38:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364Ab1BIUie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:38:34 -0500
Date: Wed, 9 Feb 2011 12:38:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: batch-free pcp list if possible
Message-Id: <20110209123803.4bb6291c.akpm@linux-foundation.org>
In-Reply-To: <1297257677-12287-1-git-send-email-namhyung@gmail.com>
References: <1297257677-12287-1-git-send-email-namhyung@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Feb 2011 22:21:17 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> free_pcppages_bulk() frees pages from pcp lists in a round-robin
> fashion by keeping batch_free counter. But it doesn't need to spin
> if there is only one non-empty list. This can be checked by
> batch_free == MIGRATE_PCPTYPES.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  mm/page_alloc.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a873e61e312e..470fb42e303c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -614,6 +614,10 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  			list = &pcp->lists[migratetype];
>  		} while (list_empty(list));
>  
> +		/* This is an only non-empty list. Free them all. */
> +		if (batch_free == MIGRATE_PCPTYPES)
> +			batch_free = to_free;
> +
>  		do {
>  			page = list_entry(list->prev, struct page, lru);
>  			/* must delete as __free_one_page list manipulates */

free_pcppages_bulk() hurts my brain.

What is it actually trying to do, and why?  It counts up the number of
contiguous empty lists and then frees that number of pages from the
first-encountered non-empty list and then advances onto the next list?

What's the point in that?  What relationship does the number of
contiguous empty lists have with the number of pages to free from one
list?

The comment "This is so more pages are freed off fuller lists instead
of spinning excessively around empty lists" makes no sense - the only
way this can be true is if the code knows the number of elements on
each list, and it doesn't know that.

Also, the covering comments over free_pcppages_bulk() regarding the
pages_scanned counter and the "all pages pinned" logic appear to be out
of date.  Or, alternatively, those comments do reflect the desired
design, but we broke it.


Methinks that free_pcppages_bulk() is an area ripe for simplification
and clarification.
