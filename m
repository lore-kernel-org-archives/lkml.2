Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1LNHwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:52:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51384 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1LNHwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:52:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Dec 2011 16:51:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH 3/4] memcg: clear pc->mem_cgorup if necessary.
Message-Id: <20111214165124.4d2cf723.kamezawa.hiroyu@jp.fujitsu.com>
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

This is a preparation before removing a flag PCG_ACCT_LRU in page_cgroup
and reducing atomic ops/complexity in memcg LRU handling.

In some cases, pages are added to lru before charge to memcg and pages
are not classfied to memory cgroup at lru addtion. Now, the lru where
the page should be added is determined a bit in page_cgroup->flags and
pc->mem_cgroup. I'd like to remove the check of flag.

To handle the case pc->mem_cgroup may contain stale pointers if pages are
added to LRU before classification. This patch resets pc->mem_cgroup to
root_mem_cgroup before lru additions.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    5 +++++
 mm/ksm.c                   |    1 +
 mm/memcontrol.c            |   14 ++++++++++++++
 mm/swap_state.c            |    1 +
 4 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bd3b102..7428409 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -126,6 +126,7 @@ extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
 extern void mem_cgroup_replace_page_cache(struct page *oldpage,
 					struct page *newpage);
 
+extern void mem_cgroup_reset_owner(struct page *page);
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
 #endif
@@ -388,6 +389,10 @@ static inline void mem_cgroup_replace_page_cache(struct page *oldpage,
 				struct page *newpage)
 {
 }
+
+static inline void mem_cgroup_reset_owner(struct page *page);
+{
+}
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #if !defined(CONFIG_CGROUP_MEM_RES_CTLR) || !defined(CONFIG_DEBUG_VM)
diff --git a/mm/ksm.c b/mm/ksm.c
index a6d3fb7..480983d 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1571,6 +1571,7 @@ struct page *ksm_does_need_to_copy(struct page *page,
 
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 	if (new_page) {
+		mem_cgroup_reset_owner(new_page);
 		copy_user_highpage(new_page, page, address, vma);
 
 		SetPageDirty(new_page);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7a857e8..2ae973d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3024,6 +3024,20 @@ void mem_cgroup_uncharge_swap(swp_entry_t ent)
 	rcu_read_unlock();
 }
 
+/*
+ * A function for resetting pc->mem_cgroup for newly allocated pages.
+ * This function should be called if the newpage will be added to LRU
+ * before start accounting.
+ */
+void mem_cgroup_reset_owner(struct page *newpage)
+{
+	struct page_cgroup *pc;
+
+	pc = lookup_page_cgroup(newpage);
+	VM_BUG_ON(PageCgroupUsed(pc));
+	pc->mem_cgroup = root_mem_cgroup;
+}
+
 /**
  * mem_cgroup_move_swap_account - move swap charge and swap_cgroup's record.
  * @entry: swap entry to be moved
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 78cc4d1..747539e 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -301,6 +301,7 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 			new_page = alloc_page_vma(gfp_mask, vma, addr);
 			if (!new_page)
 				break;		/* Out of memory */
+			mem_cgroup_reset_owner(new_page);
 		}
 
 		/*
-- 
1.7.4.1


