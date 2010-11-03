Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0KCPaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:30:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864Ab0KCPaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:30:04 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 38 of 66] memcontrol: try charging huge pages from stock
X-Mercurial-Node: 9d26d3daf23632b20a7b67135e4db7e6d02a3669
Message-Id: <9d26d3daf23632b20a7b.1288798093@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:28:13 +0100
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

From: Johannes Weiner <hannes@cmpxchg.org>

The stock unit is just bytes, there is no reason to only take normal
pages from it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1658,19 +1658,19 @@ static DEFINE_PER_CPU(struct memcg_stock
 static atomic_t memcg_drain_count;
 
 /*
- * Try to consume stocked charge on this cpu. If success, PAGE_SIZE is consumed
+ * Try to consume stocked charge on this cpu. If success, @val is consumed
  * from local stock and true is returned. If the stock is 0 or charges from a
  * cgroup which is not current target, returns false. This stock will be
  * refilled.
  */
-static bool consume_stock(struct mem_cgroup *mem)
+static bool consume_stock(struct mem_cgroup *mem, int val)
 {
 	struct memcg_stock_pcp *stock;
 	bool ret = true;
 
 	stock = &get_cpu_var(memcg_stock);
-	if (mem == stock->cached && stock->charge)
-		stock->charge -= PAGE_SIZE;
+	if (mem == stock->cached && stock->charge >= val)
+		stock->charge -= val;
 	else /* need to call res_counter_charge */
 		ret = false;
 	put_cpu_var(memcg_stock);
@@ -1915,7 +1915,7 @@ again:
 		VM_BUG_ON(css_is_removed(&mem->css));
 		if (mem_cgroup_is_root(mem))
 			goto done;
-		if (page_size == PAGE_SIZE && consume_stock(mem))
+		if (consume_stock(mem, page_size))
 			goto done;
 		css_get(&mem->css);
 	} else {
@@ -1939,7 +1939,7 @@ again:
 			rcu_read_unlock();
 			goto done;
 		}
-		if (page_size == PAGE_SIZE && consume_stock(mem)) {
+		if (consume_stock(mem, page_size)) {
 			/*
 			 * It seems dagerous to access memcg without css_get().
 			 * But considering how consume_stok works, it's not
