Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab1AYGLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 01:11:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42148 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1AYGLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 01:11:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 25 Jan 2011 15:05:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 3/3] memcg: fix race at move_parent around compound_order()
Message-Id: <20110125150516.fb2f5e06.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110125145720.cd0cbe16.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110125145720.cd0cbe16.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on 
2.6.38-rc2 + 
 mm-memcontrolc-fix-uninitialized-variable-use-in-mem_cgroup_move_parent.patch
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

A fix up mem_cgroup_move_parent() which use compound_order() in
asynchrnous manner. This compound_order() may return unknown value
because we don't take lock. Use PageTransHuge() and HPAGE_SIZE instead of
it.

Also clean up for mem_cgroup_move_parent(). 
 - remove unnecessary initialization of local variable.
 - rename charge_size -> page_size
 - remove unnecessary (wrong) comment.
 - added a comment about THP.

Changelog:
 - fixed page size calculation for avoiding race.

Note:
 Current design take compound_page_lock() in caller of move_account().
 This should be revisited when we implement direct move_task of hugepage
 without splitting.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

Index: linux-2.6.38-rc2/mm/memcontrol.c
===================================================================
--- linux-2.6.38-rc2.orig/mm/memcontrol.c
+++ linux-2.6.38-rc2/mm/memcontrol.c
@@ -2234,7 +2234,12 @@ static int mem_cgroup_move_account(struc
 {
 	int ret = -EINVAL;
 	unsigned long flags;
-
+	/*
+	 * The page is isolated from LRU. So, collapse function
+ 	 * will not handle this page. But page splitting can happen.
+ 	 * Do this check under compound_page_lock(). The caller should
+ 	 * hold it.
+ 	 */
 	if ((charge_size > PAGE_SIZE) && !PageTransHuge(pc->page))
 		return -EBUSY;
 
@@ -2266,7 +2271,7 @@ static int mem_cgroup_move_parent(struct
 	struct cgroup *cg = child->css.cgroup;
 	struct cgroup *pcg = cg->parent;
 	struct mem_cgroup *parent;
-	int charge = PAGE_SIZE;
+	int page_size = PAGE_SIZE;
 	unsigned long flags;
 	int ret;
 
@@ -2279,22 +2284,24 @@ static int mem_cgroup_move_parent(struct
 		goto out;
 	if (isolate_lru_page(page))
 		goto put;
-	/* The page is isolated from LRU and we have no race with splitting */
-	charge = PAGE_SIZE << compound_order(page);
+
+	if (PageTransHuge(page))
+		page_size = HPAGE_SIZE;
 
 	parent = mem_cgroup_from_cont(pcg);
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false, charge);
+	ret = __mem_cgroup_try_charge(NULL, gfp_mask,
+				&parent, false, page_size);
 	if (ret || !parent)
 		goto put_back;
 
-	if (charge > PAGE_SIZE)
+	if (page_size > PAGE_SIZE)
 		flags = compound_lock_irqsave(page);
 
-	ret = mem_cgroup_move_account(pc, child, parent, true, charge);
+	ret = mem_cgroup_move_account(pc, child, parent, true, page_size);
 	if (ret)
-		mem_cgroup_cancel_charge(parent, charge);
+		mem_cgroup_cancel_charge(parent, page_size);
 
-	if (charge > PAGE_SIZE)
+	if (page_size > PAGE_SIZE)
 		compound_unlock_irqrestore(page, flags);
 put_back:
 	putback_lru_page(page);

