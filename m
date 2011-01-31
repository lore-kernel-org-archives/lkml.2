Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1AaOEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:04:32 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:46466 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939Ab1AaOET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:04:19 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: akpm@linux-foundation.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
        balbir@linux.vnet.ibm.com, minchan.kim@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 3/3] memcg: never OOM when charging huge pages
Date: Mon, 31 Jan 2011 15:03:55 +0100
Message-Id: <1296482635-13421-4-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
References: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huge page coverage should obviously have less priority than the
continued execution of a process.

Never kill a process when charging it a huge page fails.  Instead,
give up after the first failed reclaim attempt and fall back to
regular pages.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c28072f..9e5de7c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2343,13 +2343,19 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask, enum charge_type ctype)
 {
 	struct mem_cgroup *mem = NULL;
+	int page_size = PAGE_SIZE;
 	struct page_cgroup *pc;
+	bool oom = true;
 	int ret;
-	int page_size = PAGE_SIZE;
 
 	if (PageTransHuge(page)) {
 		page_size <<= compound_order(page);
 		VM_BUG_ON(!PageTransHuge(page));
+		/*
+		 * Never OOM-kill a process for a huge page.  The
+		 * fault handler will fall back to regular pages.
+		 */
+		oom = false;
 	}
 
 	pc = lookup_page_cgroup(page);
@@ -2358,7 +2364,7 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
 		return 0;
 	prefetchw(pc);
 
-	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true, page_size);
+	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, oom, page_size);
 	if (ret || !mem)
 		return ret;
 
-- 
1.7.3.5

