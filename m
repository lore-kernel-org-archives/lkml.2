Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab1FAKou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 06:44:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758732Ab1FAKot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 06:44:49 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: imammedo@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
        balbir@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: [PATCH] memcg: do not expose uninitialized mem_cgroup_per_node to world
Date: Wed,  1 Jun 2011 12:44:04 +0200
Message-Id: <1306925044-2828-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freshly allocated 'mem_cgroup_per_node' list entries must be
initialized before the rest of the kernel can see them. Otherwise
zero initialized list fields can lead to race condition at
mem_cgroup_force_empty_list:
  pc = list_entry(list->prev, struct page_cgroup, lru);
where 'pc' will be something like 0xfffffffc if list->prev is 0
and cause page fault later when 'pc' is dereferenced.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bd9052a..ee7cb4c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4707,7 +4707,6 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
 	if (!pn)
 		return 1;
 
-	mem->info.nodeinfo[node] = pn;
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
 		for_each_lru(l)
@@ -4716,6 +4715,7 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
 		mz->on_tree = false;
 		mz->mem = mem;
 	}
+	mem->info.nodeinfo[node] = pn;
 	return 0;
 }
 
-- 
1.7.1

