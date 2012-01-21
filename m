Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2AUOtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 09:49:25 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58436 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab2AUOtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 09:49:24 -0500
MIME-Version: 1.0
Date: Sat, 21 Jan 2012 22:49:23 +0800
Message-ID: <CAJd=RBAbFd=MFZZyCKN-Si-Zt=C6dKVUaG-C7s5VKoTWfY00nA@mail.gmail.com>
Subject: [PATCH] mm: memcg: fix over reclaiming mem cgroup
From: Hillf Danton <dhillf@gmail.com>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In soft limit reclaim, overreclaim occurs when pages are reclaimed from mem
group that is under its soft limit, or when more pages are reclaimd than the
exceeding amount, then performance of reclaimee goes down accordingly.

A helper function is added to compute the number of pages that exceed the soft
limit of given mem cgroup, then the excess pages are used when every reclaimee
is reclaimed to avoid overreclaim.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/memcontrol.c	Tue Jan 17 20:41:36 2012
+++ b/mm/memcontrol.c	Sat Jan 21 21:18:46 2012
@@ -1662,6 +1662,21 @@ static int mem_cgroup_soft_reclaim(struc
 	return total;
 }

+unsigned long mem_cgroup_excess_pages(struct mem_cgroup *memcg)
+{
+	unsigned long pages;
+
+	if (mem_cgroup_disabled())
+		return 0;
+	if (!memcg)
+		return 0;
+	if (mem_cgroup_is_root(memcg))
+		return 0;
+
+	pages = res_counter_soft_limit_excess(&memcg->res) >> PAGE_SHIFT;
+	return pages;
+}
+
 /*
  * Check OOM-Killer is already running under our hierarchy.
  * If someone is running, return false.
--- a/mm/vmscan.c	Sat Jan 14 14:02:20 2012
+++ b/mm/vmscan.c	Sat Jan 21 21:30:06 2012
@@ -2150,8 +2150,34 @@ static void shrink_zone(int priority, st
 			.mem_cgroup = memcg,
 			.zone = zone,
 		};
+		unsigned long old;
+		bool clobbered = false;
+
+		if (memcg != NULL) {
+			unsigned long excess;
+
+			excess = mem_cgroup_excess_pages(memcg);
+			/*
+			 * No bother reclaiming pages from mem cgroup that
+			 * is under soft limit
+			 */
+			if (!excess)
+				goto next;
+			/*
+			 * And reclaim no more pages than excess
+			 */
+			if (excess < sc->nr_to_reclaim) {
+				old = sc->nr_to_reclaim;
+				sc->nr_to_reclaim = excess;
+				clobbered = true;
+			}
+		}

 		shrink_mem_cgroup_zone(priority, &mz, sc);
+
+		if (clobbered)
+			sc->nr_to_reclaim = old;
+next:
 		/*
 		 * Limit reclaim has historically picked one memcg and
 		 * scanned it with decreasing priority levels until
--- a/include/linux/memcontrol.h	Thu Jan 19 22:03:14 2012
+++ b/include/linux/memcontrol.h	Sat Jan 21 21:35:50 2012
@@ -161,6 +161,7 @@ unsigned long mem_cgroup_soft_limit_recl
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
 u64 mem_cgroup_get_limit(struct mem_cgroup *memcg);
+unsigned long mem_cgroup_excess_pages(struct mem_cgroup *memcg);

 void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -376,6 +377,11 @@ unsigned long mem_cgroup_soft_limit_recl

 static inline
 u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
+{
+	return 0;
+}
+
+static inline unsigned long mem_cgroup_excess_pages(struct mem_cgroup *memcg)
 {
 	return 0;
 }
