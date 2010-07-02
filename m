Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab0GBFuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 01:50:12 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:46403 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab0GBFuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 01:50:07 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] hugetlb: add missing unlock in avoidcopy path in hugetlb_cow()
Date: Fri,  2 Jul 2010 14:47:20 +0900
Message-Id: <1278049646-29769-2-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes possible deadlock in hugepage lock_page()
by adding missing unlock_page().

libhugetlbfs test will hit this bug when the next patch in this
patchset ("hugetlb, HWPOISON: move PG_HWPoison bit check") is applied.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 mm/hugetlb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git v2.6.35-rc3-hwpoison/mm/hugetlb.c v2.6.35-rc3-hwpoison/mm/hugetlb.c
index abf249d..a26c24a 100644
--- v2.6.35-rc3-hwpoison/mm/hugetlb.c
+++ v2.6.35-rc3-hwpoison/mm/hugetlb.c
@@ -2323,9 +2323,11 @@ retry_avoidcopy:
 	 * and just make the page writable */
 	avoidcopy = (page_mapcount(old_page) == 1);
 	if (avoidcopy) {
-		if (!trylock_page(old_page))
+		if (!trylock_page(old_page)) {
 			if (PageAnon(old_page))
 				page_move_anon_rmap(old_page, vma, address);
+		} else
+			unlock_page(old_page);
 		set_huge_ptep_writable(vma, address, ptep);
 		return 0;
 	}
-- 
1.7.1

