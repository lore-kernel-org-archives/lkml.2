Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2GEAqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 20:46:12 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53403 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab2GEApo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 20:45:44 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 05/11] mm: memcg: only check for PageSwapCache when uncharging anon
Date: Thu,  5 Jul 2012 02:44:57 +0200
Message-Id: <1341449103-1986-6-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only anon pages that are uncharged at the time of the last page table
mapping vanishing may be in swapcache.

When shmem pages, file pages, swap-freed anon pages, or just migrated
pages are uncharged, they are known for sure to be not in swapcache.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a3bf414..3d56b4e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3026,8 +3026,6 @@ void mem_cgroup_uncharge_cache_page(struct page *page)
 {
 	VM_BUG_ON(page_mapped(page));
 	VM_BUG_ON(page->mapping);
-	if (PageSwapCache(page))
-		return;
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE, false);
 }
 
@@ -3092,8 +3090,6 @@ mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
 	if (!swapout) /* this was a swap cache but the swap is unused ! */
 		ctype = MEM_CGROUP_CHARGE_TYPE_DROP;
 
-	if (PageSwapCache(page))
-		return;
 	memcg = __mem_cgroup_uncharge_common(page, ctype, false);
 
 	/*
@@ -3283,11 +3279,10 @@ void mem_cgroup_end_migration(struct mem_cgroup *memcg,
 		unused = oldpage;
 	}
 	anon = PageAnon(used);
-	if (!PageSwapCache(page))
-		__mem_cgroup_uncharge_common(unused,
-					     anon ? MEM_CGROUP_CHARGE_TYPE_ANON
-					     : MEM_CGROUP_CHARGE_TYPE_CACHE,
-					     true);
+	__mem_cgroup_uncharge_common(unused,
+				     anon ? MEM_CGROUP_CHARGE_TYPE_ANON
+				     : MEM_CGROUP_CHARGE_TYPE_CACHE,
+				     true);
 	css_put(&memcg->css);
 	/*
 	 * We disallowed uncharge of pages under migration because mapcount
-- 
1.7.7.6

