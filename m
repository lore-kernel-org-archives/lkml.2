Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab1LFKNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:13:41 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34654 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074Ab1LFKNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:13:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 6 Dec 2011 19:12:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>
Subject: [RFC][PATCH 1/4] memcg: simplify page cache charging
Message-Id: <20111206191211.3be32ccb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111206123923.1432ab52.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111206123923.1432ab52.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an add-on patches to mem_cgroup_replace_page_cache(), introducing
new LRU rule under memcg, finally. After this, lru handling will be
much simplified. (all pathces are based on 3.2.0-rc4-next-20111205+)

But this is experimental... I may forget some important corner cases.
==
>From 028eddd3fea1634e23b18a96ba5653e8c54b437b Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 6 Dec 2011 14:57:01 +0900
Subject: [PATCH 1/4] memcg: simplify page cache charging.

Because of commit ef6a3c6311, FUSE uses replace_page_cache() instead
of add_to_page_cache(). Then, mem_cgroup_cache_charge() is not
called against FUSE's pages from splice.

So, Now, mem_cgroup_cache_charge() doesn't receive a page on LRU
unless it's not SwapCache.
For checking, WARN_ON_ONCE(PageLRU(page)) is added.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   31 +++++++++----------------------
 1 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a9e92a6..947c62c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2710,6 +2710,7 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
 	struct mem_cgroup *memcg = NULL;
+	enum charge_type type = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	int ret;
 
 	if (mem_cgroup_disabled())
@@ -2719,31 +2720,17 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 
 	if (unlikely(!mm))
 		mm = &init_mm;
+	if (!page_is_file_cache(page))
+		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
 
-	if (page_is_file_cache(page)) {
-		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &memcg, true);
-		if (ret || !memcg)
-			return ret;
-
-		/*
-		 * FUSE reuses pages without going through the final
-		 * put that would remove them from the LRU list, make
-		 * sure that they get relinked properly.
-		 */
-		__mem_cgroup_commit_charge_lrucare(page, memcg,
-					MEM_CGROUP_CHARGE_TYPE_CACHE);
-		return ret;
-	}
-	/* shmem */
-	if (PageSwapCache(page)) {
+	if (!PageSwapCache(page)) {
+		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
+		WARN_ON_ONCE(PageLRU(page));
+	} else { /* page is swapcache/shmem */
 		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &memcg);
 		if (!ret)
-			__mem_cgroup_commit_charge_swapin(page, memcg,
-					MEM_CGROUP_CHARGE_TYPE_SHMEM);
-	} else
-		ret = mem_cgroup_charge_common(page, mm, gfp_mask,
-					MEM_CGROUP_CHARGE_TYPE_SHMEM);
-
+			__mem_cgroup_commit_charge_swapin(page, memcg, type);
+	}
 	return ret;
 }
 
-- 
1.7.4.1


