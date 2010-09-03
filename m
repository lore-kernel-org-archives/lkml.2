Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0ICWkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 18:40:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625Ab0ICWkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 18:40:41 -0400
Date: Fri, 3 Sep 2010 15:38:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/3] mm: page allocator: Update free page counters after
 pages are placed on the free list
Message-Id: <20100903153859.52cd1b97.akpm@linux-foundation.org>
In-Reply-To: <1283504926-2120-2-git-send-email-mel@csn.ul.ie>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie>
	<1283504926-2120-2-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  3 Sep 2010 10:08:44 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -588,12 +588,12 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  {
>  	int migratetype = 0;
>  	int batch_free = 0;
> +	int freed = count;
>  
>  	spin_lock(&zone->lock);
>  	zone->all_unreclaimable = 0;
>  	zone->pages_scanned = 0;
>  
> -	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
>  	while (count) {
>  		struct page *page;
>  		struct list_head *list;
> @@ -621,6 +621,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  			trace_mm_page_pcpu_drain(page, 0, page_private(page));
>  		} while (--count && --batch_free && !list_empty(list));
>  	}
> +	__mod_zone_page_state(zone, NR_FREE_PAGES, freed);
>  	spin_unlock(&zone->lock);
>  }
>  

nit: this is why it's evil to modify the value of incoming args.  It's
nicer to leave them alone and treat them as const across the lifetime
of the callee.

Can I do this?

--- a/mm/page_alloc.c~mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix
+++ a/mm/page_alloc.c
@@ -588,13 +588,13 @@ static void free_pcppages_bulk(struct zo
 {
 	int migratetype = 0;
 	int batch_free = 0;
-	int freed = count;
+	int to_free = count;
 
 	spin_lock(&zone->lock);
 	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
-	while (count) {
+	while (to_free) {
 		struct page *page;
 		struct list_head *list;
 
@@ -619,9 +619,9 @@ static void free_pcppages_bulk(struct zo
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, page_private(page));
 			trace_mm_page_pcpu_drain(page, 0, page_private(page));
-		} while (--count && --batch_free && !list_empty(list));
+		} while (--to_free && --batch_free && !list_empty(list));
 	}
-	__mod_zone_page_state(zone, NR_FREE_PAGES, freed);
+	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
 	spin_unlock(&zone->lock);
 }
 
_

