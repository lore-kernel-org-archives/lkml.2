Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab1BJM1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:27:18 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:55589 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441Ab1BJM1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:27:13 -0500
Date: Thu, 10 Feb 2011 13:26:56 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] memcg: keep only one charge cancelling function
Message-ID: <20110210122656.GL27110@cmpxchg.org>
References: <1297249313-23746-1-git-send-email-hannes@cmpxchg.org>
 <1297249313-23746-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297249313-23746-2-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, here is a fix for this patch that reverts to using the
underscored version of the cancel function, which already took a page
count.  Code developped in parallel will either use the underscore
version with the uncharged semantics or error out on the no longer
existing version that took a number of bytes.

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] memcg: keep only one charge cancelling function fix

Keep the underscore-version of the charge cancelling function which
took a page count, rather than silently changing the semantics of the
non-underscore-version.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 804e9fc..e600b55 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2020,8 +2020,8 @@ bypass:
  * This function is for that and do uncharge, put css's refcnt.
  * gotten by try_charge().
  */
-static void mem_cgroup_cancel_charge(struct mem_cgroup *mem,
-				     unsigned int nr_pages)
+static void __mem_cgroup_cancel_charge(struct mem_cgroup *mem,
+				       unsigned int nr_pages)
 {
 	if (!mem_cgroup_is_root(mem)) {
 		unsigned long bytes = nr_pages * PAGE_SIZE;
@@ -2090,7 +2090,7 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
-		mem_cgroup_cancel_charge(mem, nr_pages);
+		__mem_cgroup_cancel_charge(mem, nr_pages);
 		return;
 	}
 	/*
@@ -2228,7 +2228,7 @@ static int mem_cgroup_move_account(struct page *page, struct page_cgroup *pc,
 	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -nr_pages);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
-		mem_cgroup_cancel_charge(from, nr_pages);
+		__mem_cgroup_cancel_charge(from, nr_pages);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
@@ -2293,7 +2293,7 @@ static int mem_cgroup_move_parent(struct page *page,
 
 	ret = mem_cgroup_move_account(page, pc, child, parent, true, page_size);
 	if (ret)
-		mem_cgroup_cancel_charge(parent, page_size >> PAGE_SHIFT);
+		__mem_cgroup_cancel_charge(parent, page_size >> PAGE_SHIFT);
 
 	if (page_size > PAGE_SIZE)
 		compound_unlock_irqrestore(page, flags);
@@ -2524,7 +2524,7 @@ void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *mem)
 		return;
 	if (!mem)
 		return;
-	mem_cgroup_cancel_charge(mem, 1);
+	__mem_cgroup_cancel_charge(mem, 1);
 }
 
 static void
@@ -4803,7 +4803,7 @@ static void __mem_cgroup_clear_mc(void)
 
 	/* we must uncharge all the leftover precharges from mc.to */
 	if (mc.precharge) {
-		mem_cgroup_cancel_charge(mc.to, mc.precharge);
+		__mem_cgroup_cancel_charge(mc.to, mc.precharge);
 		mc.precharge = 0;
 	}
 	/*
@@ -4811,7 +4811,7 @@ static void __mem_cgroup_clear_mc(void)
 	 * we must uncharge here.
 	 */
 	if (mc.moved_charge) {
-		mem_cgroup_cancel_charge(mc.from, mc.moved_charge);
+		__mem_cgroup_cancel_charge(mc.from, mc.moved_charge);
 		mc.moved_charge = 0;
 	}
 	/* we must fixup refcnts and charges */
-- 
1.7.4

