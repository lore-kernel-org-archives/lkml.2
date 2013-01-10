Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3AJLo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:44:28 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:42008 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3AJLo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:44:26 -0500
From: Sha Zhengju <handai.szj@gmail.com>
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org
Cc: mhocko@suse.cz, akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        Sha Zhengju <handai.szj@taobao.com>
Subject: [PATCH] memcg: modify swap accounting function to support THP
Date: Thu, 10 Jan 2013 19:43:58 +0800
Message-Id: <1357818238-11455-1-git-send-email-handai.szj@taobao.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sha Zhengju <handai.szj@taobao.com>

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 mm/memcontrol.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3817460..674cf21 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -914,10 +914,9 @@ static long mem_cgroup_read_stat(struct mem_cgroup *memcg,
 }
 
 static void mem_cgroup_swap_statistics(struct mem_cgroup *memcg,
-					 bool charge)
+					 int nr_pages)
 {
-	int val = (charge) ? 1 : -1;
-	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAP], val);
+	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAP], nr_pages);
 }
 
 static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
@@ -4107,7 +4106,7 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype,
 	 */
 	memcg_check_events(memcg, page);
 	if (do_swap_account && ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT) {
-		mem_cgroup_swap_statistics(memcg, true);
+		mem_cgroup_swap_statistics(memcg, nr_pages);
 		mem_cgroup_get(memcg);
 	}
 	/*
@@ -4238,7 +4237,7 @@ void mem_cgroup_uncharge_swap(swp_entry_t ent)
 		 */
 		if (!mem_cgroup_is_root(memcg))
 			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
-		mem_cgroup_swap_statistics(memcg, false);
+		mem_cgroup_swap_statistics(memcg, -1);
 		mem_cgroup_put(memcg);
 	}
 	rcu_read_unlock();
@@ -4267,8 +4266,8 @@ static int mem_cgroup_move_swap_account(swp_entry_t entry,
 	new_id = css_id(&to->css);
 
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
-		mem_cgroup_swap_statistics(from, false);
-		mem_cgroup_swap_statistics(to, true);
+		mem_cgroup_swap_statistics(from, -1);
+		mem_cgroup_swap_statistics(to, 1);
 		/*
 		 * This function is only called from task migration context now.
 		 * It postpones res_counter and refcount handling till the end
-- 
1.7.9.5

