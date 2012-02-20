Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2BTRXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:23:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43752 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab2BTRXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:23:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.135.146 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH v2 10/22] mm: unify inactive_list_is_low()
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 20 Feb 2012 21:23:13 +0400
Message-ID: <20120220172313.22196.37308.stgit@zurg>
In-Reply-To: <20120220171138.22196.65847.stgit@zurg>
References: <20120220171138.22196.65847.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify memcg and non-memcg logic, always use exact counters from struct lruvec.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/vmscan.c |   30 ++++++++----------------------
 1 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3e8d049..6889a39 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1809,6 +1809,7 @@ static int inactive_anon_is_low(struct mem_cgroup_zone *mz,
 {
 	unsigned long active, inactive;
 	unsigned int ratio;
+	struct lruvec *lruvec;
 
 	/*
 	 * If we don't have swap space, anonymous page deactivation
@@ -1822,17 +1823,9 @@ static int inactive_anon_is_low(struct mem_cgroup_zone *mz,
 	else
 		ratio = mem_cgroup_inactive_ratio(sc->target_mem_cgroup);
 
-	if (scanning_global_lru(mz)) {
-		active = zone_page_state(mz->zone, NR_ACTIVE_ANON);
-		inactive = zone_page_state(mz->zone, NR_INACTIVE_ANON);
-	} else {
-		active = mem_cgroup_zone_nr_lru_pages(mz->mem_cgroup,
-				zone_to_nid(mz->zone), zone_idx(mz->zone),
-				BIT(LRU_ACTIVE_ANON));
-		inactive = mem_cgroup_zone_nr_lru_pages(mz->mem_cgroup,
-				zone_to_nid(mz->zone), zone_idx(mz->zone),
-				BIT(LRU_INACTIVE_ANON));
-	}
+	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
+	active = lruvec->pages_count[LRU_ACTIVE_ANON];
+	inactive = lruvec->pages_count[LRU_INACTIVE_ANON];
 
 	return inactive * ratio < active;
 }
@@ -1861,18 +1854,11 @@ static inline int inactive_anon_is_low(struct mem_cgroup_zone *mz,
 static int inactive_file_is_low(struct mem_cgroup_zone *mz)
 {
 	unsigned long active, inactive;
+	struct lruvec *lruvec;
 
-	if (scanning_global_lru(mz)) {
-		active = zone_page_state(mz->zone, NR_ACTIVE_FILE);
-		inactive = zone_page_state(mz->zone, NR_INACTIVE_FILE);
-	} else {
-		active = mem_cgroup_zone_nr_lru_pages(mz->mem_cgroup,
-				zone_to_nid(mz->zone), zone_idx(mz->zone),
-				BIT(LRU_ACTIVE_FILE));
-		inactive = mem_cgroup_zone_nr_lru_pages(mz->mem_cgroup,
-				zone_to_nid(mz->zone), zone_idx(mz->zone),
-				BIT(LRU_INACTIVE_FILE));
-	}
+	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
+	active = lruvec->pages_count[LRU_ACTIVE_FILE];
+	inactive = lruvec->pages_count[LRU_INACTIVE_FILE];
 
 	return inactive < active;
 }

