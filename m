Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab2BTRXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:23:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43752 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2BTRXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:23:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.124.142 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH v2 09/22] mm: link lruvec with zone and node
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 20 Feb 2012 21:23:09 +0400
Message-ID: <20120220172309.22196.76135.stgit@zurg>
In-Reply-To: <20120220171138.22196.65847.stgit@zurg>
References: <20120220171138.22196.65847.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds links from lruvec to its zone and node.
For CONFIG_CGROUP_MEM_RES_CTLR=n this is just container_of().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/mm.h     |   20 ++++++++++++++++++++
 include/linux/mmzone.h |    4 ++++
 mm/memcontrol.c        |    2 ++
 mm/page_alloc.c        |    4 ++++
 4 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e483f30..24c24f0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -734,6 +734,16 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
 
 extern struct lruvec *page_lruvec(struct page *lruvec);
 
+static inline struct zone *lruvec_zone(struct lruvec *lruvec)
+{
+	return lruvec->zone;
+}
+
+static inline struct pglist_data *lruvec_node(struct lruvec *lruvec)
+{
+	return lruvec->node;
+}
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 
 /* Single lruvec in zone */
@@ -743,6 +753,16 @@ static inline struct lruvec *page_lruvec(struct page *page)
 	return &page_zone(page)->lruvec;
 }
 
+static inline struct zone *lruvec_zone(struct lruvec *lruvec)
+{
+	return container_of(lruvec, struct zone, lruvec);
+}
+
+static inline struct pglist_data *lruvec_node(struct lruvec *lruvec)
+{
+	return lruvec_zone(lruvec)->zone_pgdat;
+}
+
 #endif /* CONFIG_CGROUP_MEM_RES_CTLR */
 
 /*
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b39f230..bd2cae4 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -297,6 +297,10 @@ struct zone_reclaim_stat {
 };
 
 struct lruvec {
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+	struct pglist_data	*node;
+	struct zone		*zone;
+#endif
 	struct list_head	pages_lru[NR_LRU_LISTS];
 	unsigned long		pages_count[NR_LRU_LISTS];
 };
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fa64817..e29420d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4673,6 +4673,8 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 			INIT_LIST_HEAD(&mz->lruvec.pages_lru[lru]);
 			mz->lruvec.pages_count[lru] = 0;
 		}
+		mz->lruvec.node = NODE_DATA(node);
+		mz->lruvec.zone = &NODE_DATA(node)->node_zones[zone];
 		mz->usage_in_excess = 0;
 		mz->on_tree = false;
 		mz->memcg = memcg;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c7fcddc..c500084 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4366,6 +4366,10 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 			INIT_LIST_HEAD(&zone->lruvec.pages_lru[lru]);
 			zone->lruvec.pages_count[lru] = 0;
 		}
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+		zone->lruvec.node = pgdat;
+		zone->lruvec.zone = zone;
+#endif
 		zone->reclaim_stat.recent_rotated[0] = 0;
 		zone->reclaim_stat.recent_rotated[1] = 0;
 		zone->reclaim_stat.recent_scanned[0] = 0;

