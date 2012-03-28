Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab2C1AlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:41:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:9032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756928Ab2C1AlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:41:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="146594438"
From: Andi Kleen <andi@firstfloor.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] Implement simple hierarchical draining
Date: Tue, 27 Mar 2012 17:40:33 -0700
Message-Id: <1332895233-32471-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332895233-32471-1-git-send-email-andi@firstfloor.org>
References: <1332895233-32471-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Instead of draining all CPUs immediately try the neighbors first.
Currently this is core, socket, all

Global draining is a quite expensive operation on a larger system,
and it does suffer from quite high lock contention because all
CPUs bang on the same zones.

This gives a moderate speedup on a drain intensive workload,
and significantly lowers spinlock contention.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 mm/page_alloc.c |   38 ++++++++++++++++++++++++++++++++++----
 1 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8cd4f6a..d7dea3f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1196,6 +1196,36 @@ void drain_all_pages(void)
 	on_each_cpu(drain_local_pages, NULL, 1);
 }
 
+enum { 
+	DRAIN_CORE,
+	DRAIN_SOCKET,
+	DRAIN_ALL,
+	/* Could do nearby nodes here? */
+	NUM_DRAIN_LEVELS,
+};
+
+/* 
+ * Drain nearby CPUs, reaching out the farther the higher level is.
+ */
+static void drain_all_pages_level(int level)
+{	
+	const cpumask_t *mask;
+	int cpu = smp_processor_id();
+
+	switch (level) { 
+	case DRAIN_CORE:
+		mask = topology_thread_cpumask(cpu);
+		break;
+	case DRAIN_SOCKET:
+		mask = topology_core_cpumask(cpu);
+		break;
+	case DRAIN_ALL:
+		mask = cpu_online_mask;
+		break;
+	}
+	smp_call_function_many(mask, drain_local_pages, NULL, 1);
+}
+
 #ifdef CONFIG_HIBERNATION
 
 void mark_free_pages(struct zone *zone)
@@ -2085,7 +2115,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 {
 	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
-	bool drained = false;
+	int drained = 0;
 
 	cond_resched();
 
@@ -2121,9 +2151,9 @@ retry:
 	 * If an allocation failed after direct reclaim, it could be because
 	 * pages are pinned on the per-cpu lists. Drain them and try again
 	 */
-	if (!page && !drained) {
-		drain_all_pages();
-		drained = true;
+	if (!page && drained < NUM_DRAIN_LEVELS) {
+		drain_all_pages_level(drained);
+		drained++;
 		goto retry;
 	}
 
-- 
1.7.7.6

