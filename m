Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1ARCUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 21:20:55 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43775 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab1ARCUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 21:20:54 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 18 Jan 2011 11:14:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH 3/4] memcg: fix LRU accounting with THP
Message-Id: <20110118111455.8e75b086.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110118110604.e2528324.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110118110604.e2528324.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

memory cgroup's LRU stat should take care of size of pages because
Transparent Hugepage inserts hugepage into LRU.
If this value is the number wrong, memory reclaim will not work well.

Note: only head page of THP's huge page is linked into LRU.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

Index: mmotm-0107/mm/memcontrol.c
===================================================================
--- mmotm-0107.orig/mm/memcontrol.c
+++ mmotm-0107/mm/memcontrol.c
@@ -814,7 +814,8 @@ void mem_cgroup_del_lru_list(struct page
 	 * removed from global LRU.
 	 */
 	mz = page_cgroup_zoneinfo(pc);
-	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
+	/* huge page split is done under lru_lock. so, we have no races. */
+	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
 	if (mem_cgroup_is_root(pc->mem_cgroup))
 		return;
 	VM_BUG_ON(list_empty(&pc->lru));
@@ -865,7 +866,8 @@ void mem_cgroup_add_lru_list(struct page
 		return;
 
 	mz = page_cgroup_zoneinfo(pc);
-	MEM_CGROUP_ZSTAT(mz, lru) += 1;
+	/* huge page split is done under lru_lock. so, we have no races. */
+	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
 	SetPageCgroupAcctLRU(pc);
 	if (mem_cgroup_is_root(pc->mem_cgroup))
 		return;
@@ -2140,10 +2142,10 @@ static void __mem_cgroup_commit_charge(s
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
 #define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MOVE_LOCK) |\
-			(1 << PCG_MIGRATION))
+			(1 << PCG_ACCT_LRU) | (1 << PCG_MIGRATION))
 /*
  * Because tail pages are not marked as "used", set it. We're under
- * 'splitting' and compund_lock. 'splitting' ensures that the pages
+ * 'splitting' and compund_lock and zone->lru_lock.
  */
 void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail)
 {
@@ -2152,14 +2154,26 @@ void mem_cgroup_split_huge_fixup(struct 
 	unsigned long flags;
 
 	/*
-	 * We have no races witch charge/uncharge but will have races with
+	 * We have no races with charge/uncharge but will have races with
 	 * page state accounting.
 	 */
 	move_lock_page_cgroup(head_pc, &flags);
 
 	tail_pc->mem_cgroup = head_pc->mem_cgroup;
 	smp_wmb(); /* see __commit_charge() */
-	/* we don't need to copy all flags...*/
+	if (PageCgroupAcctLRU(head_pc)) {
+		enum lru_list lru;
+		struct mem_cgroup_per_zone *mz;
+
+		/*
+		 * LRU flags cannot be copied because we need to add tail
+		 * page to LRU by generic call and our hook will be called.
+		 * We hold lru_lock, then, reduce counter directly.
+		 */
+		lru = page_lru(head);
+		mz = page_cgroup_zoneinfo(head_pc);
+		MEM_CGROUP_ZSTAT(mz, lru) -= 1;
+	}
 	tail_pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
 	move_unlock_page_cgroup(head_pc, &flags);
 }

