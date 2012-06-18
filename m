Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab2FRMBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:01:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33542 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2FRMBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:01:52 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FDF1830.1000504@jp.fujitsu.com>
Date: Mon, 18 Jun 2012 20:59:44 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-mm <linux-mm@kvack.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 2/2] memcg: clean up force_empty_list() return value check
References: <4FDF17A3.9060202@jp.fujitsu.com>
In-Reply-To: <4FDF17A3.9060202@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By commit "memcg: move charges to root cgroup if use_hierarchy=0"
mem_cgroup_move_parent() only returns -EBUSY, -EINVAL.
So, we can remove -ENOMEM and -EINTR checks.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cf8a0f6..726b7c6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3847,8 +3847,6 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 		pc = lookup_page_cgroup(page);
 
 		ret = mem_cgroup_move_parent(page, pc, memcg, GFP_KERNEL);
-		if (ret == -ENOMEM || ret == -EINTR)
-			break;
 
 		if (ret == -EBUSY || ret == -EINVAL) {
 			/* found lock contention or "pc" is obsolete. */
@@ -3910,9 +3908,6 @@ move_account:
 		}
 		mem_cgroup_end_move(memcg);
 		memcg_oom_recover(memcg);
-		/* it seems parent cgroup doesn't have enough mem */
-		if (ret == -ENOMEM)
-			goto try_to_free;
 		cond_resched();
 	/* "ret" should also be checked to ensure all lists are empty. */
 	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0 || ret);
-- 
1.7.4.1


