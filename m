Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2ASHQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:16:10 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38038 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab2ASHQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:16:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 19 Jan 2012 16:14:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH] memcg: remove unnecessary thp check at page stat accounting
Message-Id: <20120119161445.b3a8a9d2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much for reviewing previous RFC series.
This is a patch against memcg-devel and linux-next (can by applied without HUNKs).

==

>From 64641b360839b029bb353fbd95f7554cc806ed05 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 12 Jan 2012 16:08:33 +0900
Subject: [PATCH] memcg: remove unnecessary thp check in mem_cgroup_update_page_stat()

commit 58b318ecf(memcg-devel)
    memcg: make mem_cgroup_split_huge_fixup() more efficient
removes move_lock_page_cgroup() in thp-split path.

So, We do not have to check PageTransHuge in mem_cgroup_update_page_stat
and fallback into the locked accounting because both move charge and thp
split up are done with compound_lock so they cannot race. update vs.
move is protected by the mem_cgroup_stealed sufficiently.

PageTransHuge pages shouldn't appear in this code path currently because
we are tracking only file pages at the moment but later we are planning
to track also other pages (e.g. mlocked ones).

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5073474..fb2dfc3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1801,7 +1801,7 @@ void mem_cgroup_update_page_stat(struct page *page,
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
 		goto out;
 	/* pc->mem_cgroup is unstable ? */
-	if (unlikely(mem_cgroup_stealed(memcg)) || PageTransHuge(page)) {
+	if (unlikely(mem_cgroup_stealed(memcg))) {
 		/* take a lock against to access pc->mem_cgroup */
 		move_lock_page_cgroup(pc, &flags);
 		need_unlock = true;
-- 
1.7.4.1


