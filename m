Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516Ab2JYNKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:10:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:51755 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758543Ab2JYNKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:10:52 -0400
Message-Id: <20121025124834.801088972@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 25 Oct 2012 14:16:48 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 31/31] sched, numa, mm: Add memcg support to do_huge_pmd_numa_page()
References: <20121025121617.617683848@chello.nl>
Content-Disposition: inline; filename=0031-sched-numa-mm-Add-memcg-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

[ Turned email suggestions into patch plus fixes. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/huge_memory.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: tip/mm/huge_memory.c
===================================================================
--- tip.orig/mm/huge_memory.c
+++ tip/mm/huge_memory.c
@@ -742,6 +742,7 @@ void do_huge_pmd_numa_page(struct mm_str
 			   unsigned int flags, pmd_t entry)
 {
 	unsigned long haddr = address & HPAGE_PMD_MASK;
+	struct mem_cgroup *memcg = NULL;
 	struct page *new_page = NULL;
 	struct page *page = NULL;
 	int node, lru;
@@ -800,6 +801,8 @@ migrate:
 	if (!new_page)
 		goto alloc_fail;
 
+	mem_cgroup_prepare_migration(page, new_page, &memcg);
+
 	lru = PageLRU(page);
 
 	if (lru && isolate_lru_page(page)) /* does an implicit get_page() */
@@ -852,14 +855,19 @@ migrate:
 		put_page(page);		/* drop the LRU isolation reference */
 
 	unlock_page(new_page);
+
+	mem_cgroup_end_migration(memcg, page, new_page, true);
+
 	unlock_page(page);
 	put_page(page);			/* Drop the local reference */
 
 	return;
 
 alloc_fail:
-	if (new_page)
+	if (new_page) {
+		mem_cgroup_end_migration(memcg, page, new_page, false);
 		put_page(new_page);
+	}
 
 	unlock_page(page);
 


