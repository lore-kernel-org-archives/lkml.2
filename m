Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2BTRWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:22:48 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43752 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2BTRWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:22:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.120.10 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH v2 02/22] memcg: fix page_referencies cgroup filter on global
 reclaim
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 20 Feb 2012 21:22:43 +0400
Message-ID: <20120220172243.22196.57870.stgit@zurg>
In-Reply-To: <20120220171138.22196.65847.stgit@zurg>
References: <20120220171138.22196.65847.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Global memory reclaimer should't skip referencies for any pages,
even if they are shared between different cgroups.

This patch adds scan_control->current_mem_cgroup, which points to currently
shrinking sub-cgroup in hierarchy, at global reclaim it always NULL.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/vmscan.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ee4d87a..4bb23ef 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -109,6 +109,12 @@ struct scan_control {
 	struct mem_cgroup *target_mem_cgroup;
 
 	/*
+	 * Currently reclaiming memory cgroup in hierarchy,
+	 * NULL for global reclaim.
+	 */
+	struct mem_cgroup *current_mem_cgroup;
+
+	/*
 	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
 	 * are scanned.
 	 */
@@ -701,13 +707,13 @@ enum page_references {
 };
 
 static enum page_references page_check_references(struct page *page,
-						  struct mem_cgroup_zone *mz,
 						  struct scan_control *sc)
 {
 	int referenced_ptes, referenced_page;
 	unsigned long vm_flags;
 
-	referenced_ptes = page_referenced(page, 1, mz->mem_cgroup, &vm_flags);
+	referenced_ptes = page_referenced(page, 1,
+			sc->current_mem_cgroup, &vm_flags);
 	referenced_page = TestClearPageReferenced(page);
 
 	/* Lumpy reclaim - ignore references */
@@ -828,7 +834,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 			}
 		}
 
-		references = page_check_references(page, mz, sc);
+		references = page_check_references(page, sc);
 		switch (references) {
 		case PAGEREF_ACTIVATE:
 			goto activate_locked;
@@ -1735,7 +1741,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 			continue;
 		}
 
-		if (page_referenced(page, 0, mz->mem_cgroup, &vm_flags)) {
+		if (page_referenced(page, 0, sc->current_mem_cgroup, &vm_flags)) {
 			nr_rotated += hpage_nr_pages(page);
 			/*
 			 * Identify referenced, file-backed active pages and
@@ -2159,6 +2165,9 @@ static void shrink_zone(int priority, struct zone *zone,
 			.zone = zone,
 		};
 
+		if (!global_reclaim(sc))
+			sc->current_mem_cgroup = memcg;
+
 		shrink_mem_cgroup_zone(priority, &mz, sc);
 		/*
 		 * Limit reclaim has historically picked one memcg and
@@ -2478,6 +2487,7 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *memcg,
 		.may_swap = !noswap,
 		.order = 0,
 		.target_mem_cgroup = memcg,
+		.current_mem_cgroup = memcg,
 	};
 	struct mem_cgroup_zone mz = {
 		.mem_cgroup = memcg,

