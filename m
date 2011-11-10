Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935369Ab1KJP6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:58:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801Ab1KJP57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:57:59 -0500
Date: Thu, 10 Nov 2011 16:57:27 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        mel <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/5]thp: correct order in lru list for split huge page
Message-ID: <20111110155727.GA5075@redhat.com>
References: <1319511577.22361.140.camel@sli10-conroe>
 <20111027231928.GB29407@barrios-laptop.redhat.com>
 <1319778538.22361.152.camel@sli10-conroe>
 <20111028072102.GA6268@barrios-laptop.redhat.com>
 <20111110023915.GR5075@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110023915.GR5075@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I adjusted comment and removed the isolated lru changes which seem
unnecessary.

I would have preferred > 0, but I thought >= 1 may make it more
explicit it's really not meant to hit on the first page.

====
From: Shaohua Li <shaohua.li@intel.com>
Subject: thp: improve order in lru list for split huge page

Put the tail subpages of an isolated hugepage under splitting in the
lru reclaim head as they supposedly should be isolated too next.

Queues the subpages in physical order in the lru for non isolated
hugepages under splitting. That might provide some theoretical cache
benefit to the buddy allocator later.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/huge_memory.c |    5 ++---
 mm/swap.c        |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fd925d0..e221fbf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1199,7 +1199,6 @@ static int __split_huge_page_splitting(struct page *page,
 static void __split_huge_page_refcount(struct page *page)
 {
 	int i;
-	unsigned long head_index = page->index;
 	struct zone *zone = page_zone(page);
 	int zonestat;
 	int tail_count = 0;
@@ -1208,7 +1207,7 @@ static void __split_huge_page_refcount(struct page *page)
 	spin_lock_irq(&zone->lru_lock);
 	compound_lock(page);
 
-	for (i = 1; i < HPAGE_PMD_NR; i++) {
+	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
 		struct page *page_tail = page + i;
 
 		/* tail_page->_mapcount cannot change */
@@ -1271,7 +1270,7 @@ static void __split_huge_page_refcount(struct page *page)
 		BUG_ON(page_tail->mapping);
 		page_tail->mapping = page->mapping;
 
-		page_tail->index = ++head_index;
+		page_tail->index = page->index + i;
 
 		BUG_ON(!PageAnon(page_tail));
 		BUG_ON(!PageUptodate(page_tail));
diff --git a/mm/swap.c b/mm/swap.c
index a91caf7..f8cfc91 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -684,7 +684,7 @@ void lru_add_page_tail(struct zone* zone,
 		if (likely(PageLRU(page)))
 			head = page->lru.prev;
 		else
-			head = &zone->lru[lru].list;
+			head = zone->lru[lru].list.prev;
 		__add_page_to_lru_list(zone, page_tail, lru, head);
 	} else {
 		SetPageUnevictable(page_tail);
