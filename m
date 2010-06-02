Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab0FBGbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 02:31:33 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:48167 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab0FBGbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 02:31:31 -0400
Date: Wed, 2 Jun 2010 14:46:39 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       Izik Eidus <ieidus@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Dave Hansen <dave@linux.vnet.ibm.com>,
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
       Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][BUGFIX][PATCH 2/2] transhuge-memcg: commit tail pages at
 charge
Message-Id: <20100602144639.15828b0e.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100602144438.dc04ece7.nishimura@mxp.nes.nec.co.jp>
References: <20100521000539.GA5733@random.random>
	<20100602144438.dc04ece7.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b74bd83..708961a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1739,23 +1739,10 @@ struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
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
@@ -1780,6 +1767,33 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
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
@@ -2173,6 +2187,8 @@ direct_uncharge:
 static struct mem_cgroup *
 __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 {
+	int i;
+	int count;
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
 	struct mem_cgroup_per_zone *mz;
@@ -2187,6 +2203,7 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 	if (PageSwapCache(page))
 		return NULL;
 
+	count = page_size >> PAGE_SHIFT;
 	/*
 	 * Check if our page_cgroup is valid
 	 */
@@ -2222,7 +2239,8 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 		__do_uncharge(mem, ctype, page_size);
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
 		mem_cgroup_swap_statistics(mem, true);
-	mem_cgroup_charge_statistics(mem, pc, false);
+	for (i = 0; i < count; i++)
+		mem_cgroup_charge_statistics(mem, pc + i, false);
 
 	ClearPageCgroupUsed(pc);
 	/*
@@ -2238,7 +2256,7 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 	memcg_check_events(mem, page);
 	/* at swapout, this memcg will be accessed to record to swap */
 	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
-		__css_put(&mem->css, page_size >> PAGE_SHIFT);
+		__css_put(&mem->css, count);
 
 	return mem;
 
