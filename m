Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1AUGdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:33:40 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:53135 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab1AUGda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:33:30 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <tatsu@ab.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Mel Gorman <mel@csn.ul.ie>,
        Christoph Lameter <cl@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        tony.luck@intel.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 3/7] remove putback_lru_pages() in hugepage migration context
Date: Fri, 21 Jan 2011 15:28:56 +0900
Message-Id: <1295591340-1862-4-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295591340-1862-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1295591340-1862-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This putback_lru_pages() is inserted at cf608ac19c to allow
memory compaction to count the number of migration failed pages.

But we should not do it for a hugepage because page->lru of a hugepage
is used differently from that of a normal page:

   in-use hugepage : page->lru is unlinked,
   free hugepage   : page->lru is linked to the free hugepage list,

so putting back hugepages to LRU lists collapses this rule.
We just drop this change (without any impact on memory compaction.)

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
---
 mm/memory-failure.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git v2.6.38-rc1/mm/memory-failure.c v2.6.38-rc1/mm/memory-failure.c
index 548fbd7..b4910e8 100644
--- v2.6.38-rc1/mm/memory-failure.c
+++ v2.6.38-rc1/mm/memory-failure.c
@@ -1295,7 +1295,6 @@ static int soft_offline_huge_page(struct page *page, int flags)
 	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0,
 				true);
 	if (ret) {
-		putback_lru_pages(&pagelist);
 		pr_debug("soft offline: %#lx: migration failed %d, type %lx\n",
 			 pfn, ret, page->flags);
 		if (ret > 0)
-- 
1.7.3.4

