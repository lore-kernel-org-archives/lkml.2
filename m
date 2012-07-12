Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030579Ab2GLKjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:39:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44983 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933641Ab2GLKjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:39:33 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH RFC] mm/memcg: recalculate chargeable space after waiting migrating charges
Date: Thu, 12 Jul 2012 18:39:21 +0800
Message-Id: <1342089561-11211-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Function mem_cgroup_do_charge will call mem_cgroup_reclaim,
there are two break points in mem_cgroup_reclaim:
if (total && (flag & MEM_CGROUP_RECLAIM_SHIRINK))
	break;
if (mem_cgroup_margin(memcg))
	break;
so mem_cgroup_reclaim can't guarantee reclaim enough pages(nr_pages) 
which is requested from mem_cgroup_do_charge, if mem_cgroup_margin
(mem_over_limit) >= nr_pages is not true, the process will go to
mem_cgroup_wait_acct_move to wait doubly charge counted caused by
task move. But this time still can't guarantee enough pages(nr_pages) is
ready, directly return CHARGE_RETRY is incorret. We should add a check
to confirm enough pages is ready, otherwise go to oom.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f72b5e5..4ae3848 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2210,7 +2210,8 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * At task move, charge accounts can be doubly counted. So, it's
 	 * better to wait until the end of task_move if something is going on.
 	 */
-	if (mem_cgroup_wait_acct_move(mem_over_limit))
+	if (mem_cgroup_wait_acct_move(mem_over_limit)
+			&& mem_cgroup_margin(mem_over_limit) >= nr_pages)
 		return CHARGE_RETRY;
 
 	/* If we don't need to call oom-killer at el, return immediately */
-- 
1.7.5.4

