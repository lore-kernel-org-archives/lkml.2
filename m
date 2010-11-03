Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab0KCPiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:38:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab0KCPax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:30:53 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 37 of 66] transhuge-memcg: commit tail pages at charge
X-Mercurial-Node: 023022a4bc18d09da263221ed1cad26eafd211b6
Message-Id: <023022a4bc18d09da263.1288798092@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:28:12 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Adam Litke <agl@us.ibm.com>,
        Avi Kivity <avi@redhat.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

By this patch, when a transparent hugepage is charged, not only the head page but
also all the tail pages are committed, IOW pc->mem_cgroup and pc->flags of tail
pages are set.

Without this patch:

- Tail pages are not linked to any memcg's LRU at splitting. This causes many
  problems, for example, the charged memcg's directory can never be rmdir'ed
  because it doesn't have enough pages to scan to make the usage decrease to 0.
- "rss" field in memory.stat would be incorrect. Moreover, usage_in_bytes in
  root cgroup is calculated by the stat not by res_counter(since 2.6.32),
  it would be incorrect too.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2087,23 +2087,10 @@ struct mem_cgroup *try_get_mem_cgroup_fr
  * commit a charge got by __mem_cgroup_try_charge() and makes page_cgroup to be
  * USED state. If already USED, uncharge and return.
  */
-
-static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
-				       struct page_cgroup *pc,
-				       enum charge_type ctype,
-				       int page_size)
+static void ____mem_cgroup_commit_charge(struct mem_cgroup *mem,
+					 struct page_cgroup *pc,
+					 enum charge_type ctype)
 {
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
 	pc->mem_cgroup = mem;
 	/*
 	 * We access a page_cgroup asynchronously without lock_page_cgroup().
@@ -2128,6 +2115,33 @@ static void __mem_cgroup_commit_charge(s
 	}
 
 	mem_cgroup_charge_statistics(mem, pc, true);
+}
+
+static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
+				       struct page_cgroup *pc,
+				       enum charge_type ctype,
+				       int page_size)
+{
+	int i;
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
+	for (i = 0; i < count; i++)
+		____mem_cgroup_commit_charge(mem, pc + i, ctype);
 
 	unlock_page_cgroup(pc);
 	/*
@@ -2522,6 +2536,8 @@ direct_uncharge:
 static struct mem_cgroup *
 __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 {
+	int i;
+	int count;
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
 	int page_size = PAGE_SIZE;
@@ -2535,6 +2551,7 @@ __mem_cgroup_uncharge_common(struct page
 	if (PageTransHuge(page))
 		page_size <<= compound_order(page);
 
+	count = page_size >> PAGE_SHIFT;
 	/*
 	 * Check if our page_cgroup is valid
 	 */
@@ -2567,7 +2584,8 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	mem_cgroup_charge_statistics(mem, pc, false);
+	for (i = 0; i < count; i++)
+		mem_cgroup_charge_statistics(mem, pc + i, false);
 
 	ClearPageCgroupUsed(pc);
 	/*
