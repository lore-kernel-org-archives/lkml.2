Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1ARCVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 21:21:49 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60059 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1ARCVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 21:21:48 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 18 Jan 2011 11:15:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH 4/4] memcg: fix rmdir, force_empty with THP
Message-Id: <20110118111550.7633cd0e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110118111055.1be29ad0.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110118110604.e2528324.kamezawa.hiroyu@jp.fujitsu.com>
	<20110118111055.1be29ad0.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now, when THP is enabled, memcg's rmdir() function is broken
because move_account() for THP page is not supported.

This will cause account leak or -EBUSY issue at rmdir().
This patch fixes the issue by supporting move_account() THP pages.

Changelog:
 - style fix.
 - add compound_lock for avoiding races.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

Index: mmotm-0107/mm/memcontrol.c
===================================================================
--- mmotm-0107.orig/mm/memcontrol.c
+++ mmotm-0107/mm/memcontrol.c
@@ -2197,8 +2197,11 @@ void mem_cgroup_split_huge_fixup(struct 
  */
 
 static void __mem_cgroup_move_account(struct page_cgroup *pc,
-	struct mem_cgroup *from, struct mem_cgroup *to, bool uncharge)
+	struct mem_cgroup *from, struct mem_cgroup *to, bool uncharge,
+	int charge_size)
 {
+	int nr_pages = charge_size >> PAGE_SHIFT;
+
 	VM_BUG_ON(from == to);
 	VM_BUG_ON(PageLRU(pc->page));
 	VM_BUG_ON(!page_is_cgroup_locked(pc));
@@ -2212,14 +2215,14 @@ static void __mem_cgroup_move_account(st
 		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		preempt_enable();
 	}
-	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -1);
+	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -nr_pages);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
-		mem_cgroup_cancel_charge(from, PAGE_SIZE);
+		mem_cgroup_cancel_charge(from, charge_size);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
-	mem_cgroup_charge_statistics(to, PageCgroupCache(pc), 1);
+	mem_cgroup_charge_statistics(to, PageCgroupCache(pc), nr_pages);
 	/*
 	 * We charges against "to" which may not have any tasks. Then, "to"
 	 * can be under rmdir(). But in current implementation, caller of
@@ -2234,15 +2237,19 @@ static void __mem_cgroup_move_account(st
  * __mem_cgroup_move_account()
  */
 static int mem_cgroup_move_account(struct page_cgroup *pc,
-		struct mem_cgroup *from, struct mem_cgroup *to, bool uncharge)
+		struct mem_cgroup *from, struct mem_cgroup *to,
+		bool uncharge, int charge_size)
 {
 	int ret = -EINVAL;
 	unsigned long flags;
 
+	if ((charge_size > PAGE_SIZE) && !PageTransHuge(pc->page))
+		return -EBUSY;
+
 	lock_page_cgroup(pc);
 	if (PageCgroupUsed(pc) && pc->mem_cgroup == from) {
 		move_lock_page_cgroup(pc, &flags);
-		__mem_cgroup_move_account(pc, from, to, uncharge);
+		__mem_cgroup_move_account(pc, from, to, uncharge, charge_size);
 		move_unlock_page_cgroup(pc, &flags);
 		ret = 0;
 	}
@@ -2267,6 +2274,8 @@ static int mem_cgroup_move_parent(struct
 	struct cgroup *cg = child->css.cgroup;
 	struct cgroup *pcg = cg->parent;
 	struct mem_cgroup *parent;
+	int charge = PAGE_SIZE;
+	unsigned long flags;
 	int ret;
 
 	/* Is ROOT ? */
@@ -2278,17 +2287,23 @@ static int mem_cgroup_move_parent(struct
 		goto out;
 	if (isolate_lru_page(page))
 		goto put;
+	/* The page is isolated from LRU and we have no race with splitting */
+	charge = PAGE_SIZE << compound_order(page);
 
 	parent = mem_cgroup_from_cont(pcg);
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false,
-				      PAGE_SIZE);
+	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false, charge);
 	if (ret || !parent)
 		goto put_back;
 
-	ret = mem_cgroup_move_account(pc, child, parent, true);
+	if (charge > PAGE_SIZE)
+		flags = compound_lock_irqsave(page);
+
+	ret = mem_cgroup_move_account(pc, child, parent, true, charge);
 	if (ret)
-		mem_cgroup_cancel_charge(parent, PAGE_SIZE);
+		mem_cgroup_cancel_charge(parent, charge);
 put_back:
+	if (charge > PAGE_SIZE)
+		compound_unlock_irqrestore(page, flags);
 	putback_lru_page(page);
 put:
 	put_page(page);
@@ -4868,7 +4883,7 @@ retry:
 				goto put;
 			pc = lookup_page_cgroup(page);
 			if (!mem_cgroup_move_account(pc,
-						mc.from, mc.to, false)) {
+					mc.from, mc.to, false, PAGE_SIZE)) {
 				mc.precharge--;
 				/* we uncharge from mc.from later. */
 				mc.moved_charge++;

