Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652Ab0HEGNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:13:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44597 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab0HEGNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:13:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 3/7] vmscan: synchrounous lumpy reclaim use lock_page() instead trylock_page()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
References: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
Message-Id: <20100805151304.31C0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  5 Aug 2010 15:13:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When synchrounous lumpy reclaim, there is no reason to give up to
reclaim pages even if page is locked. We use lock_page() instead
trylock_page() in this case.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1cdc3db..833b6ad 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -665,7 +665,9 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		page = lru_to_page(page_list);
 		list_del(&page->lru);
 
-		if (!trylock_page(page))
+		if (sync_writeback == PAGEOUT_IO_SYNC)
+			lock_page(page);
+		else if (!trylock_page(page))
 			goto keep;
 
 		VM_BUG_ON(PageActive(page));
-- 
1.6.5.2



