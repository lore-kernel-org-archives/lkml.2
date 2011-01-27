Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077Ab1A0FHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 00:07:41 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53088 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1A0FHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 00:07:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 27 Jan 2011 14:01:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [PATCH] memcg: fix ugly initialization of return value is in caller
Message-Id: <20110127140132.35f4285e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on  mm-of-the-moment snapshot 2011-01-25-15-47
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch is for removing initialization of vaiable in caller of
memory cgroup function. Actually, it's return value of memcg function
but it's initialized in caller.

Some memory cgroup uses following style to bring the result
of start function to the end function for avoiding races.

   mem_cgroup_start_A(&(*ptr))
   /* Something very complicated can happen here. */
   mem_cgroup_end_A(*ptr)

In some calls, *ptr should be initialized to NULL be caller. But
it's ugly. This patch fixes that *ptr is initialized by _start
function.

Changelog:
 - removed unnecessary comments.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    8 ++++++--
 mm/memory.c     |    2 +-
 mm/migrate.c    |    2 +-
 mm/swapfile.c   |    2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

Index: mmotm-0125/mm/memcontrol.c
===================================================================
--- mmotm-0125.orig/mm/memcontrol.c
+++ mmotm-0125/mm/memcontrol.c
@@ -2413,7 +2413,7 @@ int mem_cgroup_cache_charge(struct page 
 
 	/* shmem */
 	if (PageSwapCache(page)) {
-		struct mem_cgroup *mem = NULL;
+		struct mem_cgroup *mem;
 
 		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &mem);
 		if (!ret)
@@ -2439,6 +2439,8 @@ int mem_cgroup_try_charge_swapin(struct 
 	struct mem_cgroup *mem;
 	int ret;
 
+	*ptr = NULL;
+
 	if (mem_cgroup_disabled())
 		return 0;
 
@@ -2854,6 +2856,8 @@ int mem_cgroup_prepare_migration(struct 
 	enum charge_type ctype;
 	int ret = 0;
 
+	*ptr = NULL;
+
 	VM_BUG_ON(PageTransHuge(page));
 	if (mem_cgroup_disabled())
 		return 0;
@@ -2996,7 +3000,7 @@ int mem_cgroup_shmem_charge_fallback(str
 			    struct mm_struct *mm,
 			    gfp_t gfp_mask)
 {
-	struct mem_cgroup *mem = NULL;
+	struct mem_cgroup *mem;
 	int ret;
 
 	if (mem_cgroup_disabled())
Index: mmotm-0125/mm/migrate.c
===================================================================
--- mmotm-0125.orig/mm/migrate.c
+++ mmotm-0125/mm/migrate.c
@@ -623,7 +623,7 @@ static int unmap_and_move(new_page_t get
 	struct page *newpage = get_new_page(page, private, &result);
 	int remap_swapcache = 1;
 	int charge = 0;
-	struct mem_cgroup *mem = NULL;
+	struct mem_cgroup *mem;
 	struct anon_vma *anon_vma = NULL;
 
 	if (!newpage)
Index: mmotm-0125/mm/memory.c
===================================================================
--- mmotm-0125.orig/mm/memory.c
+++ mmotm-0125/mm/memory.c
@@ -2707,7 +2707,7 @@ static int do_swap_page(struct mm_struct
 	swp_entry_t entry;
 	pte_t pte;
 	int locked;
-	struct mem_cgroup *ptr = NULL;
+	struct mem_cgroup *ptr;
 	int exclusive = 0;
 	int ret = 0;
 
Index: mmotm-0125/mm/swapfile.c
===================================================================
--- mmotm-0125.orig/mm/swapfile.c
+++ mmotm-0125/mm/swapfile.c
@@ -880,7 +880,7 @@ unsigned int count_swap_pages(int type, 
 static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, swp_entry_t entry, struct page *page)
 {
-	struct mem_cgroup *ptr = NULL;
+	struct mem_cgroup *ptr;
 	spinlock_t *ptl;
 	pte_t *pte;
 	int ret = 1;

