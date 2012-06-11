Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab2FKASG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:18:06 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64708 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2FKASF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:18:05 -0400
X-AuditID: 9c930197-b7b5dae000004b23-36-4fd5393a3953
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] mm: do not use page_count without a page pin
Date: Mon, 11 Jun 2012 09:17:51 +0900
Message-Id: <1339373872-31969-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d179e84ba fixed the problem[1] in vmscan.c but same problem is here.
Let's fix it.

[1] http://comments.gmane.org/gmane.linux.kernel.mm/65844

I copy and paste d179e84ba's contents for description.

"It is unsafe to run page_count during the physical pfn scan because
compound_head could trip on a dangling pointer when reading
page->first_page if the compound page is being freed by another CPU."

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/page_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 266f267..019c4fe 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5496,7 +5496,11 @@ __count_immobile_pages(struct zone *zone, struct page *page, int count)
 			continue;
 
 		page = pfn_to_page(check);
-		if (!page_count(page)) {
+		/*
+		 * We can't use page_count withou pin a page
+		 * because another CPU can free compound page.
+		 */
+		if (!atomic_read(&page->_count)) {
 			if (PageBuddy(page))
 				iter += (1 << page_order(page)) - 1;
 			continue;
-- 
1.7.9.5

