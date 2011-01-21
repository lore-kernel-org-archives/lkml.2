Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1AUG4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:56:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38363 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1AUG4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:56:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 Jan 2011 15:50:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 7/7] memcg : remove ugly vairable initialization by callers
Message-Id: <20110121155051.0b309b1f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a promised one.
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch is for removing initialization in caller of memory cgroup
function. Some memory cgroup uses following style to bring the result
of start function to the end function for avoiding races.

   mem_cgroup_start_A(&(*ptr))
   /* Something very complicated can happen here. */
   mem_cgroup_end_A(*ptr)

In some calls, *ptr should be initialized to NULL be caller. But
it's ugly. This patch fixes that *ptr is initialized by _start
function.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   10 ++++++++--
 mm/memory.c     |    2 +-
 mm/migrate.c    |    2 +-
 mm/swapfile.c   |    2 +-
 4 files changed, 11 insertions(+), 5 deletions(-)

Index: mmotm-0107/mm/memcontrol.c
===================================================================
--- mmotm-0107.orig/mm/memcontrol.c
+++ mmotm-0107/mm/memcontrol.c
@@ -2469,7 +2469,7 @@ int mem_cgroup_cache_charge(struct page 
 
 	/* shmem */
 	if (PageSwapCache(page)) {
-		struct mem_cgroup *mem = NULL;
+		struct mem_cgroup *mem;
 
 		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &mem);
 		if (!ret)
@@ -2495,6 +2495,9 @@ int mem_cgroup_try_charge_swapin(struct 
 	struct mem_cgroup *mem;
 	int ret;
 
+	/* *ptr is used for checking caller needs to call commit */
+	*ptr = NULL;
+
 	if (mem_cgroup_disabled())
 		return 0;
 
@@ -2910,6 +2913,9 @@ int mem_cgroup_prepare_migration(struct 
 	enum charge_type ctype;
 	int ret = 0;
 
+	/* *ptr is used by caller to check end_migration() should be called.*/
+	*ptr = NULL;
+
 	VM_BUG_ON(PageTransHuge(page));
 	if (mem_cgroup_disabled())
 		return 0;
@@ -3052,7 +3058,7 @@ int mem_cgroup_shmem_charge_fallback(str
 			    struct mm_struct *mm,
 			    gfp_t gfp_mask)
 {
-	struct mem_cgroup *mem = NULL;
+	struct mem_cgroup *mem;
 	int ret;
 
 	if (mem_cgroup_disabled())
Index: mmotm-0107/mm/migrate.c
===================================================================
--- mmotm-0107.orig/mm/migrate.c
+++ mmotm-0107/mm/migrate.c
@@ -624,7 +624,7 @@ static int unmap_and_move(new_page_t get
 	int remap_swapcache = 1;
 	int rcu_locked = 0;
 	int charge = 0;
-	struct mem_cgroup *mem = NULL;
+	struct mem_cgroup *mem;
 	struct anon_vma *anon_vma = NULL;
 
 	if (!newpage)
Index: mmotm-0107/mm/memory.c
===================================================================
--- mmotm-0107.orig/mm/memory.c
+++ mmotm-0107/mm/memory.c
@@ -2729,7 +2729,7 @@ static int do_swap_page(struct mm_struct
 	swp_entry_t entry;
 	pte_t pte;
 	int locked;
-	struct mem_cgroup *ptr = NULL;
+	struct mem_cgroup *ptr;
 	int exclusive = 0;
 	int ret = 0;
 
Index: mmotm-0107/mm/swapfile.c
===================================================================
--- mmotm-0107.orig/mm/swapfile.c
+++ mmotm-0107/mm/swapfile.c
@@ -880,7 +880,7 @@ unsigned int count_swap_pages(int type, 
 static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, swp_entry_t entry, struct page *page)
 {
-	struct mem_cgroup *ptr = NULL;
+	struct mem_cgroup *ptr;
 	spinlock_t *ptl;
 	pte_t *pte;
 	int ret = 1;

