Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab2FXCQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 22:16:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61038 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab2FXCQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 22:16:54 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/memcg: add MAX_CHARGE_BATCH to limit unnecessary charge overhead
Date: Sun, 24 Jun 2012 10:16:09 +0800
Message-Id: <1340504169-5344-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Since exceeded unused cached charges would add pressure to
mem_cgroup_do_charge, more overhead would burn cpu cycles when
mem_cgroup_do_charge cause page reclaim or even OOM be triggered
just for such exceeded unused cached charges. Add MAX_CHARGE_BATCH
to limit max cached charges.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0e092eb..1ff317a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1954,6 +1954,14 @@ void mem_cgroup_update_page_stat(struct page *page,
  * TODO: maybe necessary to use big numbers in big irons.
  */
 #define CHARGE_BATCH	32U
+
+/*
+ * Max size of charge stock. Since exceeded unused cached charges would
+ * add pressure to mem_cgroup_do_charge which will cause page reclaim or
+ * even oom be triggered.
+ */
+#define MAX_CHARGE_BATCH 1024U
+
 struct memcg_stock_pcp {
 	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
@@ -2250,6 +2258,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 	unsigned int batch = max(CHARGE_BATCH, nr_pages);
 	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct mem_cgroup *memcg = NULL;
+	struct memcg_stock_pcp *stock;
 	int ret;
 
 	/*
@@ -2320,6 +2329,13 @@ again:
 		rcu_read_unlock();
 	}
 
+	stock = &get_cpu_var(memcg_stock);
+	if (memcg == stock->cached && stock->nr_pages) {
+		if (stock->nr_pages > MAX_CHARGE_BATCH)
+			batch = nr_pages;
+	}
+	put_cpu_var(memcg_stock);
+
 	do {
 		bool oom_check;
 
-- 
1.7.9.5

