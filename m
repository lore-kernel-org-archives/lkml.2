Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1BJLqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 06:46:54 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60365 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1BJLqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 06:46:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZsrJytounXjhaoInTN8uNb9y1MTI1Ge4nCOTZcUS0o5datLP3pB2aH6IB+knh2UoEB
         IRyzVGDRSxPu4lGKt1VH4tzhLk7kN+QBrhppkI7xrMZllFStG49SmSV6JK5hilb2de/Q
         6JgMfENaf9zrOGFEAl0O2u9fYmS1uEy0JRQPQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] mm: handle simple case in free_pcppages_bulk()
Date: Thu, 10 Feb 2011 20:46:48 +0900
Message-Id: <1297338408-3590-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now I'm seeing that there are some cases to free all pages in a
pcp lists. In that case, just frees all pages in the lists instead
of being bothered with round-robin lists traversal.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/page_alloc.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e8b02771ccea..959c54450ddf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -596,6 +596,28 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
+	/* Simple case: Free all */
+	if (to_free == pcp->count) {
+		LIST_HEAD(freelist);
+
+		for (; migratetype < MIGRATE_PCPTYPES; migratetype++)
+			if (!list_empty(&pcp->lists[migratetype]))
+				list_move(&pcp->lists[migratetype], &freelist);
+
+		while (!list_empty(&freelist)) {
+			struct page *page;
+
+			page = list_first_entry(&freelist, struct page, lru);
+			/* must delete as __free_one_page list manipulates */
+			list_del(&page->lru);
+			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
+			__free_one_page(page, zone, 0, page_private(page));
+			trace_mm_page_pcpu_drain(page, 0, page_private(page));
+			to_free--;
+		}
+		VM_BUG_ON(to_free);
+	}
+
 	while (to_free) {
 		struct page *page;
 		struct list_head *list;
-- 
1.7.4

