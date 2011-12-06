Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab1LFKQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:16:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35778 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052Ab1LFKQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:16:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 6 Dec 2011 19:15:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>
Subject: [RFC][PATCH 3/4] memcg: clear pc->mem_cgroup if necessary
Message-Id: <20111206191505.22cea0aa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111206191211.3be32ccb.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111206123923.1432ab52.kamezawa.hiroyu@jp.fujitsu.com>
	<20111206191211.3be32ccb.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f0c8f600f0d0e5500aaad493fb5740ebe5ee1225 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 6 Dec 2011 17:51:55 +0900
Subject: [PATCH 3/4] memcg: clear pc->mem_cgorup if necessary.

At swap-in, page is added to LRU before accounted by memcg.
This causes page_cgroup->mem_cgroup v.s. LRU mis-match. This problem
is now treated by PCG_ACCT_LRU flag bit in page_cgroup->flags.

This patch is a preparation for new approarch. This patch clears
pc->mem_cgroup if a newly allocated page may be added to LRU before
charge. This will be required for removing PCG_ACCT_LRU bit.

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
index 66a2a59..b8706d8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3017,6 +3017,20 @@ void mem_cgroup_uncharge_swap(swp_entry_t ent)
 	rcu_read_unlock();
 }
 
+/*
+ * A function for resetting pc->memc_cgroup for newly allocated pages.
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


