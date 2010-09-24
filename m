Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab0IXQaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:30:08 -0400
Received: from kroah.org ([198.145.64.141]:38604 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932844Ab0IXQ3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:29:01 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:21 2010
Message-Id: <20100924162621.460340492@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:25:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [75/80] mm: page allocator: update free page counters after pages are placed on the free list
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mel@csn.ul.ie>

commit 72853e2991a2702ae93aaf889ac7db743a415dd3 upstream.

When allocating a page, the system uses NR_FREE_PAGES counters to
determine if watermarks would remain intact after the allocation was made.
This check is made without interrupts disabled or the zone lock held and
so is race-prone by nature.  Unfortunately, when pages are being freed in
batch, the counters are updated before the pages are added on the list.
During this window, the counters are misleading as the pages do not exist
yet.  When under significant pressure on systems with large numbers of
CPUs, it's possible for processes to make progress even though they should
have been stalled.  This is particularly problematic if a number of the
processes are using GFP_ATOMIC as the min watermark can be accidentally
breached and in extreme cases, the system can livelock.

This patch updates the counters after the pages have been added to the
list.  This makes the allocator more cautious with respect to preserving
the watermarks and mitigates livelock possibilities.

[akpm@linux-foundation.org: avoid modifying incoming args]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -588,13 +588,13 @@ static void free_pcppages_bulk(struct zo
 {
 	int migratetype = 0;
 	int batch_free = 0;
+	int to_free = count;
 
 	spin_lock(&zone->lock);
 	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
-	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
-	while (count) {
+	while (to_free) {
 		struct page *page;
 		struct list_head *list;
 
@@ -619,8 +619,9 @@ static void free_pcppages_bulk(struct zo
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, page_private(page));
 			trace_mm_page_pcpu_drain(page, 0, page_private(page));
-		} while (--count && --batch_free && !list_empty(list));
+		} while (--to_free && --batch_free && !list_empty(list));
 	}
+	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
 	spin_unlock(&zone->lock);
 }
 
@@ -631,8 +632,8 @@ static void free_one_page(struct zone *z
 	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
-	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
 	__free_one_page(page, zone, order, migratetype);
+	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
 	spin_unlock(&zone->lock);
 }
 


