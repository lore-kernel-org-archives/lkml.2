Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1AUGzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:55:41 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56155 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1AUGzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:55:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 Jan 2011 15:49:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 6/7] memcg : use better variable name
Message-Id: <20110121154943.d4e7a71a.kamezawa.hiroyu@jp.fujitsu.com>
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

rename 'charge_size'at el. to be 'page_size'. Then,

  nr_pages = page_size >> PAGE_SHIFT

seems natural.

This patch renames

 charge_size -> page_size
 count -> nr_pages

etc.



Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

Index: mmotm-0107/mm/memcontrol.c
===================================================================
--- mmotm-0107.orig/mm/memcontrol.c
+++ mmotm-0107/mm/memcontrol.c
@@ -1705,7 +1705,7 @@ static void drain_local_stock(struct wor
  * Cache charges(val) which is from res_counter, to local per_cpu area.
  * This will be consumed by consume_stock() function, later.
  */
-static void refill_stock(struct mem_cgroup *mem, int val)
+static void refill_stock(struct mem_cgroup *mem, int page_size)
 {
 	struct memcg_stock_pcp *stock = &get_cpu_var(memcg_stock);
 
@@ -1713,7 +1713,7 @@ static void refill_stock(struct mem_cgro
 		drain_stock(stock);
 		stock->cached = mem;
 	}
-	stock->charge += val;
+	stock->charge += page_size;
 	put_cpu_var(memcg_stock);
 }
 
@@ -2037,12 +2037,12 @@ bypass:
  * gotten by try_charge().
  */
 static void __mem_cgroup_cancel_charge(struct mem_cgroup *mem,
-							unsigned long count)
+					unsigned long nr_pages)
 {
 	if (!mem_cgroup_is_root(mem)) {
-		res_counter_uncharge(&mem->res, PAGE_SIZE * count);
+		res_counter_uncharge(&mem->res, PAGE_SIZE * nr_pages);
 		if (do_swap_account)
-			res_counter_uncharge(&mem->memsw, PAGE_SIZE * count);
+			res_counter_uncharge(&mem->memsw, PAGE_SIZE * nr_pages);
 	}
 }
 
@@ -2255,9 +2255,9 @@ out:
 
 static void __mem_cgroup_move_account(struct page_cgroup *pc,
 	struct mem_cgroup *from, struct mem_cgroup *to, bool uncharge,
-	int charge_size)
+	int page_size)
 {
-	int nr_pages = charge_size >> PAGE_SHIFT;
+	int nr_pages = page_size >> PAGE_SHIFT;
 
 	VM_BUG_ON(from == to);
 	VM_BUG_ON(PageLRU(pc->page));
@@ -2275,7 +2275,7 @@ static void __mem_cgroup_move_account(st
 	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -nr_pages);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
-		mem_cgroup_cancel_charge(from, charge_size);
+		mem_cgroup_cancel_charge(from, page_size);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
@@ -2295,18 +2295,18 @@ static void __mem_cgroup_move_account(st
  */
 static int mem_cgroup_move_account(struct page_cgroup *pc,
 		struct mem_cgroup *from, struct mem_cgroup *to,
-		bool uncharge, int charge_size)
+		bool uncharge, int page_size)
 {
 	int ret = -EINVAL;
 	unsigned long flags;
 
-	if ((charge_size > PAGE_SIZE) && !PageTransHuge(pc->page))
+	if ((page_size > PAGE_SIZE) && !PageTransHuge(pc->page))
 		return -EBUSY;
 
 	lock_page_cgroup(pc);
 	if (PageCgroupUsed(pc) && pc->mem_cgroup == from) {
 		move_lock_page_cgroup(pc, &flags);
-		__mem_cgroup_move_account(pc, from, to, uncharge, charge_size);
+		__mem_cgroup_move_account(pc, from, to, uncharge, page_size);
 		move_unlock_page_cgroup(pc, &flags);
 		ret = 0;
 	}
@@ -2645,7 +2645,7 @@ direct_uncharge:
 static struct mem_cgroup *
 __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 {
-	int count;
+	int nr_pages;
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
 	int page_size = PAGE_SIZE;
@@ -2661,7 +2661,7 @@ __mem_cgroup_uncharge_common(struct page
 		VM_BUG_ON(!PageTransHuge(page));
 	}
 
-	count = page_size >> PAGE_SHIFT;
+	nr_pages = page_size >> PAGE_SHIFT;
 	/*
 	 * Check if our page_cgroup is valid
 	 */
@@ -2694,7 +2694,7 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	mem_cgroup_charge_statistics(mem, PageCgroupCache(pc), -count);
+	mem_cgroup_charge_statistics(mem, PageCgroupCache(pc), -nr_pages);
 
 	ClearPageCgroupUsed(pc);
 	/*

