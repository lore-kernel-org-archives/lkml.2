Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab2GEAqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 20:46:34 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53394 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab2GEApn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 20:45:43 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 04/11] mm: memcg: push down PageSwapCache check into uncharge entry functions
Date: Thu,  5 Jul 2012 02:44:56 +0200
Message-Id: <1341449103-1986-5-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all uncharge paths need to check if the page is swapcache, some of
them can know for sure.

Push down the check into all callsites of uncharge_common() so that
the patch that removes some of them is more obvious.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4ea19c6..a3bf414 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2920,8 +2920,7 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype,
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	if (PageSwapCache(page))
-		return NULL;
+	VM_BUG_ON(PageSwapCache(page));
 
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
@@ -3018,6 +3017,8 @@ void mem_cgroup_uncharge_page(struct page *page)
 	if (page_mapped(page))
 		return;
 	VM_BUG_ON(page->mapping && !PageAnon(page));
+	if (PageSwapCache(page))
+		return;
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_ANON, false);
 }
 
@@ -3025,6 +3026,8 @@ void mem_cgroup_uncharge_cache_page(struct page *page)
 {
 	VM_BUG_ON(page_mapped(page));
 	VM_BUG_ON(page->mapping);
+	if (PageSwapCache(page))
+		return;
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE, false);
 }
 
@@ -3089,6 +3092,8 @@ mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
 	if (!swapout) /* this was a swap cache but the swap is unused ! */
 		ctype = MEM_CGROUP_CHARGE_TYPE_DROP;
 
+	if (PageSwapCache(page))
+		return;
 	memcg = __mem_cgroup_uncharge_common(page, ctype, false);
 
 	/*
@@ -3278,10 +3283,11 @@ void mem_cgroup_end_migration(struct mem_cgroup *memcg,
 		unused = oldpage;
 	}
 	anon = PageAnon(used);
-	__mem_cgroup_uncharge_common(unused,
-		anon ? MEM_CGROUP_CHARGE_TYPE_ANON
-		     : MEM_CGROUP_CHARGE_TYPE_CACHE,
-		true);
+	if (!PageSwapCache(page))
+		__mem_cgroup_uncharge_common(unused,
+					     anon ? MEM_CGROUP_CHARGE_TYPE_ANON
+					     : MEM_CGROUP_CHARGE_TYPE_CACHE,
+					     true);
 	css_put(&memcg->css);
 	/*
 	 * We disallowed uncharge of pages under migration because mapcount
-- 
1.7.7.6

