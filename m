Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1BILCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 06:02:23 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:40720 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab1BILCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 06:02:20 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [patch 3/4] memcg: convert uncharge batching from bytes to page granularity
Date: Wed,  9 Feb 2011 12:01:52 +0100
Message-Id: <1297249313-23746-4-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1297249313-23746-1-git-send-email-hannes@cmpxchg.org>
References: <1297249313-23746-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never uncharge subpage quantities.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/sched.h |    4 ++--
 mm/memcontrol.c       |   18 ++++++++++--------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7f7e97b..f896362 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1524,8 +1524,8 @@ struct task_struct {
 	struct memcg_batch_info {
 		int do_batch;	/* incremented when batch uncharge started */
 		struct mem_cgroup *memcg; /* target memcg of uncharge */
-		unsigned long bytes; 		/* uncharged usage */
-		unsigned long memsw_bytes; /* uncharged mem+swap usage */
+		unsigned long nr_pages;	/* uncharged usage */
+		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
 };
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 179fd74..ab5cd3b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2553,9 +2553,9 @@ __do_uncharge(struct mem_cgroup *mem, const enum charge_type ctype,
 	if (batch->memcg != mem)
 		goto direct_uncharge;
 	/* remember freed charge and uncharge it later */
-	batch->bytes += PAGE_SIZE;
+	batch->nr_pages++;
 	if (uncharge_memsw)
-		batch->memsw_bytes += PAGE_SIZE;
+		batch->memsw_nr_pages++;
 	return;
 direct_uncharge:
 	res_counter_uncharge(&mem->res, page_size);
@@ -2682,8 +2682,8 @@ void mem_cgroup_uncharge_start(void)
 	/* We can do nest. */
 	if (current->memcg_batch.do_batch == 1) {
 		current->memcg_batch.memcg = NULL;
-		current->memcg_batch.bytes = 0;
-		current->memcg_batch.memsw_bytes = 0;
+		current->memcg_batch.nr_pages = 0;
+		current->memcg_batch.memsw_nr_pages = 0;
 	}
 }
 
@@ -2704,10 +2704,12 @@ void mem_cgroup_uncharge_end(void)
 	 * This "batch->memcg" is valid without any css_get/put etc...
 	 * bacause we hide charges behind us.
 	 */
-	if (batch->bytes)
-		res_counter_uncharge(&batch->memcg->res, batch->bytes);
-	if (batch->memsw_bytes)
-		res_counter_uncharge(&batch->memcg->memsw, batch->memsw_bytes);
+	if (batch->nr_pages)
+		res_counter_uncharge(&batch->memcg->res,
+				     batch->nr_pages * PAGE_SIZE);
+	if (batch->memsw_nr_pages)
+		res_counter_uncharge(&batch->memcg->memsw,
+				     batch->memsw_nr_pages * PAGE_SIZE);
 	memcg_oom_recover(batch->memcg);
 	/* forget this pointer (for sanity check) */
 	batch->memcg = NULL;
-- 
1.7.4

