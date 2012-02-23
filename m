Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2BWNw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 08:52:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39147 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab2BWNwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 08:52:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.156.204 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH v3 08/21] mm: unify inactive_list_is_low()
To: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Date: Thu, 23 Feb 2012 17:52:19 +0400
Message-ID: <20120223135219.12988.94138.stgit@zurg>
In-Reply-To: <20120223133728.12988.5432.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
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
index f3c0fbe..b3e8bab 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1822,6 +1822,7 @@ static int inactive_anon_is_low(struct mem_cgroup_zone *mz)
 {
 	unsigned long active, inactive;
 	unsigned int gb, ratio;
+	struct lruvec *lruvec;
 
 	/*
 	 * If we don't have swap space, anonymous page deactivation
@@ -1830,17 +1831,9 @@ static int inactive_anon_is_low(struct mem_cgroup_zone *mz)
 	if (!total_swap_pages)
 		return 0;
 
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
 
 	/* Total size in gigabytes */
 	gb = (active + inactive) >> (30 - PAGE_SHIFT);
@@ -1875,18 +1868,11 @@ static inline int inactive_anon_is_low(struct mem_cgroup_zone *mz)
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

