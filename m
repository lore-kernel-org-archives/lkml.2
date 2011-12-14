Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1LNHuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:50:37 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56498 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1LNHud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:50:33 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Dec 2011 16:49:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH 1/4] memcg: simplify page cache charging.
Message-Id: <20111214164922.05fb4afe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111214164734.4d7d6d97.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111214164734.4d7d6d97.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch is a clean up. No functional/logical changes.

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


