Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab1ANKPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:15:14 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43157 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab1ANKPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:15:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 14 Jan 2011 19:09:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Greg Thelen <gthelen@google.com>, hannes@cmpxchg.org,
        aarcange@redhat.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 2/4] [BUGFIX] dont set USED bit on tail pages
Message-Id: <20110114190909.d396cdf4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110114190412.73362cd7.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110114190412.73362cd7.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, under THP:

at charge:
  - PageCgroupUsed bit is set to all page_cgroup on a hugepage.
    ....set to 512 pages.
at uncharge
  - PageCgroupUsed bit is unset on the head page.

So, tail pages will remain with "Used" bit.

This patch fixes that Used bit is set only to the head page.
Used bits for tail pages will be set at spliting if necessary.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    4 ++
 mm/huge_memory.c           |    2 +
 mm/memcontrol.c            |   80 ++++++++++++++++++++++-----------------------
 3 files changed, 46 insertions(+), 40 deletions(-)

Index: mmotm-0107/mm/memcontrol.c
===================================================================
--- mmotm-0107.orig/mm/memcontrol.c
+++ mmotm-0107/mm/memcontrol.c
@@ -2084,15 +2084,28 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 	return mem;
 }
 
-/*
- * commit a charge got by __mem_cgroup_try_charge() and makes page_cgroup to be
- * USED state. If already USED, uncharge and return.
- */
-static void ____mem_cgroup_commit_charge(struct mem_cgroup *mem,
-					 struct page_cgroup *pc,
-					 enum charge_type ctype)
+static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
+				       struct page_cgroup *pc,
+				       enum charge_type ctype,
+				       int page_size)
 {
-	bool file = false;
+	int count = page_size >> PAGE_SHIFT;
+
+	/* try_charge() can return NULL to *memcg, taking care of it. */
+	if (!mem)
+		return;
+
+	lock_page_cgroup(pc);
+	if (unlikely(PageCgroupUsed(pc))) {
+		unlock_page_cgroup(pc);
+		mem_cgroup_cancel_charge(mem, page_size);
+		return;
+	}
+
+	/*
+	 * we don't need page_cgroup_lock about tail pages, becase they are not
+	 * accessed by any other context at this point.
+	 */
 	pc->mem_cgroup = mem;
 	/*
 	 * We access a page_cgroup asynchronously without lock_page_cgroup().
@@ -2107,7 +2120,6 @@ static void ____mem_cgroup_commit_charge
 	case MEM_CGROUP_CHARGE_TYPE_SHMEM:
 		SetPageCgroupCache(pc);
 		SetPageCgroupUsed(pc);
-		file = true;
 		break;
 	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
 		ClearPageCgroupCache(pc);
@@ -2117,34 +2129,7 @@ static void ____mem_cgroup_commit_charge
 		break;
 	}
 
-	mem_cgroup_charge_statistics(mem, file, 1);
-}
-
-static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
-				       struct page_cgroup *pc,
-				       enum charge_type ctype,
-				       int page_size)
-{
-	int i;
-	int count = page_size >> PAGE_SHIFT;
-
-	/* try_charge() can return NULL to *memcg, taking care of it. */
-	if (!mem)
-		return;
-
-	lock_page_cgroup(pc);
-	if (unlikely(PageCgroupUsed(pc))) {
-		unlock_page_cgroup(pc);
-		mem_cgroup_cancel_charge(mem, page_size);
-		return;
-	}
-
-	/*
-	 * we don't need page_cgroup_lock about tail pages, becase they are not
-	 * accessed by any other context at this point.
-	 */
-	for (i = 0; i < count; i++)
-		____mem_cgroup_commit_charge(mem, pc + i, ctype);
+	mem_cgroup_charge_statistics(mem, PageCgroupCache(pc), count);
 
 	unlock_page_cgroup(pc);
 	/*
@@ -2154,6 +2139,23 @@ static void __mem_cgroup_commit_charge(s
 	 */
 	memcg_check_events(mem, pc->page);
 }
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+/*
+ * Because tail pages are not mared as "used", set it. We're under
+ * compund_lock and don't need to take care of races.
+ * Statistics are updated properly at charging. We just mark Used bits.
+ */
+void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail)
+{
+	struct page_cgroup *hpc = lookup_page_cgroup(head);
+	struct page_cgroup *tpc = lookup_page_cgroup(tail);
+
+	tpc->mem_cgroup = hpc->mem_cgroup;
+	smp_wmb(); /* see __commit_charge() */
+	SetPageCgroupUsed(tpc);
+	VM_BUG_ON(PageCgroupCache(hpc));
+}
+#endif
 
 /**
  * __mem_cgroup_move_account - move account of the page
@@ -2548,7 +2550,6 @@ direct_uncharge:
 static struct mem_cgroup *
 __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 {
-	int i;
 	int count;
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
@@ -2602,8 +2603,7 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	for (i = 0; i < count; i++)
-		mem_cgroup_charge_statistics(mem, file, -1);
+	mem_cgroup_charge_statistics(mem, file, -count);
 
 	ClearPageCgroupUsed(pc);
 	/*
Index: mmotm-0107/include/linux/memcontrol.h
===================================================================
--- mmotm-0107.orig/include/linux/memcontrol.h
+++ mmotm-0107/include/linux/memcontrol.h
@@ -146,6 +146,10 @@ unsigned long mem_cgroup_soft_limit_recl
 						gfp_t gfp_mask);
 u64 mem_cgroup_get_limit(struct mem_cgroup *mem);
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail);
+#endif
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
Index: mmotm-0107/mm/huge_memory.c
===================================================================
--- mmotm-0107.orig/mm/huge_memory.c
+++ mmotm-0107/mm/huge_memory.c
@@ -1203,6 +1203,8 @@ static void __split_huge_page_refcount(s
 		BUG_ON(!PageDirty(page_tail));
 		BUG_ON(!PageSwapBacked(page_tail));
 
+		mem_cgroup_split_huge_fixup(page, page_tail);
+
 		lru_add_page_tail(zone, page, page_tail);
 	}
 


